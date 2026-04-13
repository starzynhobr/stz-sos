function Get-STZActiveNetworkAdapters {
    return Get-NetIPConfiguration -ErrorAction Stop | Where-Object {
        $_.NetAdapter.Status -eq 'Up'
    }
}

function Get-STZNetworkGatewayHint {
    $adapter = Get-STZActiveNetworkAdapters | Select-Object -First 1
    if ($adapter -and $adapter.IPv4DefaultGateway -and $adapter.IPv4DefaultGateway.NextHop) {
        return $adapter.IPv4DefaultGateway.NextHop
    }

    return $null
}

function Test-STZPingTarget {
    param(
        [Parameter(Mandatory)]
        [string]$Target
    )

    try {
        return Test-Connection -TargetName $Target -Count 1 -Quiet -ErrorAction Stop
    }
    catch {
        return $false
    }
}

function Test-STZDnsResolution {
    param(
        [Parameter(Mandatory)]
        [string]$HostName
    )

    try {
        $null = Resolve-DnsName -Name $HostName -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Reset-STZProxySettingsCore {
    $internetSettingsKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'

    Show-STZLoading -Text 'Resetting WinHTTP proxy'
    netsh winhttp reset proxy | Out-Null

    Show-STZLoading -Text 'Clearing user proxy settings'
    Set-STZRegistryDwordValue -Path $internetSettingsKey -Name 'ProxyEnable' -Value 0
    Set-STZRegistryStringValue -Path $internetSettingsKey -Name 'ProxyServer' -Value ''
    Set-STZRegistryStringValue -Path $internetSettingsKey -Name 'ProxyOverride' -Value ''
    Set-STZRegistryDwordValue -Path $internetSettingsKey -Name 'AutoDetect' -Value 1

    if (Get-ItemProperty -Path $internetSettingsKey -Name 'AutoConfigURL' -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $internetSettingsKey -Name 'AutoConfigURL' -ErrorAction Stop
    }
}

function Get-STZQuickNetworkRepairAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Quick Network Repair' `
        -MenuLabel 'Quick Network Repair (flush DNS / renew IP)' `
        -Description 'Refreshes common DNS and IP lease state to recover routine connectivity problems.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Quick network repair completed successfully.' `
        -Handler {
            Show-STZLoading -Text 'Flushing DNS resolver cache'
            ipconfig /flushdns | Out-Null

            Show-STZLoading -Text 'Releasing IP leases'
            ipconfig /release | Out-Null

            Show-STZLoading -Text 'Renewing IP leases'
            ipconfig /renew | Out-Null

            Show-STZLoading -Text 'Registering DNS records'
            ipconfig /registerdns | Out-Null
        }
}

function Invoke-STZQuickNetworkRepair {
    Invoke-STZAction -Action (Get-STZQuickNetworkRepairAction)
}

function Repair-STZNetworkStack {
    Invoke-STZQuickNetworkRepair
}

function Get-STZDeepNetworkRepairAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Deep Network Repair' `
        -MenuLabel 'Deep Network Repair (reset Winsock / TCP-IP)' `
        -Description 'Resets Winsock and TCP/IP state, then refreshes DNS and IP lease information.' `
        -RequiresAdmin $true `
        -RebootRecommended $true `
        -RiskLevel 'Medium' `
        -SuccessMessage 'Deep network repair completed successfully.' `
        -Handler {
            Show-STZLoading -Text 'Resetting Winsock catalog'
            netsh winsock reset | Out-Null

            Show-STZLoading -Text 'Resetting TCP/IP stack'
            netsh int ip reset | Out-Null

            Show-STZLoading -Text 'Flushing DNS resolver cache'
            ipconfig /flushdns | Out-Null

            Show-STZLoading -Text 'Releasing IP leases'
            ipconfig /release | Out-Null

            Show-STZLoading -Text 'Renewing IP leases'
            ipconfig /renew | Out-Null
        }
}

function Invoke-STZDeepNetworkRepair {
    Invoke-STZAction -Action (Get-STZDeepNetworkRepairAction)
}

function Get-STZNetworkReportAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Network Report' `
        -MenuLabel 'Show Network Report (IP / DNS / gateway)' `
        -Description 'Displays a compact snapshot of active adapters, IPv4, gateway, DNS, and internet hint.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Network report generated successfully.' `
        -Handler {
            $adapters = Get-STZActiveNetworkAdapters
            $internetHint = if ((Test-STZPingTarget -Target '8.8.8.8') -or (Test-STZDnsResolution -HostName 'google.com')) {
                'Likely online'
            }
            else {
                'Offline or restricted'
            }

            Write-Host "`n$($script:STZUI.MutedColor) --- NETWORK REPORT ---$($script:STZUI.Reset)"

            if (-not $adapters) {
                Write-Host "$($script:STZUI.WarningColor) No active adapters detected.$($script:STZUI.Reset)"
            }

            foreach ($adapter in $adapters) {
                $ipv4 = if ($adapter.IPv4Address) { ($adapter.IPv4Address | ForEach-Object { $_.IPAddress }) -join ', ' } else { 'N/A' }
                $gateway = if ($adapter.IPv4DefaultGateway) { ($adapter.IPv4DefaultGateway | ForEach-Object { $_.NextHop }) -join ', ' } else { 'N/A' }
                $dns = if ($adapter.DnsServer.ServerAddresses) { ($adapter.DnsServer.ServerAddresses -join ', ') } else { 'N/A' }

                Write-Host "$($script:STZUI.NeonColor) Adapter:$($script:STZUI.TextColor) $($adapter.InterfaceAlias)$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) IPv4:$($script:STZUI.TextColor) $ipv4$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) Gateway:$($script:STZUI.TextColor) $gateway$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) DNS:$($script:STZUI.TextColor) $dns$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.MutedColor) ----------------------$($script:STZUI.Reset)"
            }

            Write-Host "$($script:STZUI.NeonColor) Internet Hint:$($script:STZUI.TextColor) $internetHint$($script:STZUI.Reset)"
        }
}

function Show-STZNetworkReport {
    Invoke-STZAction -Action (Get-STZNetworkReportAction)
}

function Get-STZConnectivityTestAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Connectivity Test' `
        -MenuLabel 'Test Connectivity (gateway / DNS / internet)' `
        -Description 'Runs a short reachability and DNS test against local and external targets.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Connectivity test completed successfully.' `
        -Handler {
            $gateway = Get-STZNetworkGatewayHint
            $gatewayResult = if ($gateway) {
                if (Test-STZPingTarget -Target $gateway) { 'Reachable' } else { 'Unreachable' }
            }
            else {
                'Not available'
            }

            $dnsResult = if (Test-STZDnsResolution -HostName 'google.com') { 'Resolved' } else { 'Failed' }
            $ipResult = if (Test-STZPingTarget -Target '8.8.8.8') { 'Reachable' } else { 'Unreachable' }
            $hostResult = if (Test-STZPingTarget -Target 'google.com') { 'Reachable' } else { 'Unreachable' }

            Write-Host "`n$($script:STZUI.MutedColor) --- CONNECTIVITY TEST ---$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Local Gateway:$($script:STZUI.TextColor) $gatewayResult$($script:STZUI.Reset)"
            if ($gateway) {
                Write-Host "$($script:STZUI.MutedColor) Target: $gateway$($script:STZUI.Reset)"
            }
            Write-Host "$($script:STZUI.NeonColor) DNS Resolution:$($script:STZUI.TextColor) $dnsResult$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) Target: google.com$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) External IP:$($script:STZUI.TextColor) $ipResult$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) Target: 8.8.8.8$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) External Host:$($script:STZUI.TextColor) $hostResult$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) Target: google.com$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) -------------------------$($script:STZUI.Reset)"
        }
}

function Test-STZConnectivity {
    Invoke-STZAction -Action (Get-STZConnectivityTestAction)
}

function Get-STZResetProxySettingsAction {
    return New-STZActionDefinition `
        -Key '5' `
        -Title 'Reset Proxy Settings' `
        -MenuLabel 'Reset Proxy Settings (clear WinHTTP / user proxy)' `
        -Description 'Clears common WinHTTP and current-user proxy settings to recover from proxy misconfiguration.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Proxy settings reset successfully.' `
        -Handler {
            Reset-STZProxySettingsCore
        }
}

function Reset-STZProxySettings {
    Invoke-STZAction -Action (Get-STZResetProxySettingsAction)
}

function Get-STZNetworkMenuActions {
    return @(
        Get-STZQuickNetworkRepairAction
        Get-STZDeepNetworkRepairAction
        Get-STZNetworkReportAction
        Get-STZConnectivityTestAction
        Get-STZResetProxySettingsAction
    )
}
