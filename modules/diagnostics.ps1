function Get-STZSystemStatus {
    $os = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop

    return [pscustomobject]@{
        ComputerName = $env:COMPUTERNAME
        UserName     = "$env:USERDOMAIN\$env:USERNAME"
        WindowsName  = $os.Caption
        Build        = "$($os.Version) (Build $($os.BuildNumber))"
        Elevated     = if (Test-STZAdministrator) { 'Yes' } else { 'No' }
    }
}

function Get-STZNetworkSummary {
    try {
        $adapter = Get-NetIPConfiguration -ErrorAction Stop | Where-Object {
            $_.NetAdapter.Status -eq 'Up'
        } | Select-Object -First 1

        if (-not $adapter) {
            return [pscustomobject]@{
                Adapter = 'No active adapter'
                IPv4    = 'N/A'
                Gateway = 'N/A'
                DNS     = 'N/A'
            }
        }

        return [pscustomobject]@{
            Adapter = $adapter.InterfaceAlias
            IPv4    = if ($adapter.IPv4Address) { ($adapter.IPv4Address | ForEach-Object { $_.IPAddress }) -join ', ' } else { 'N/A' }
            Gateway = if ($adapter.IPv4DefaultGateway) { ($adapter.IPv4DefaultGateway | ForEach-Object { $_.NextHop }) -join ', ' } else { 'N/A' }
            DNS     = if ($adapter.DnsServer.ServerAddresses) { $adapter.DnsServer.ServerAddresses -join ', ' } else { 'N/A' }
        }
    }
    catch {
        return [pscustomobject]@{
            Adapter = 'Unavailable'
            IPv4    = 'Unavailable'
            Gateway = 'Unavailable'
            DNS     = 'Unavailable'
        }
    }
}

function Get-STZDiagnosticReportPath {
    $reportRoot = Join-Path $env:TEMP 'stz-sos\reports'
    if (-not (Test-Path $reportRoot)) {
        New-Item -Path $reportRoot -ItemType Directory -Force | Out-Null
    }
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    return Join-Path $reportRoot "stz-diagnostic-report-$timestamp.txt"
}

function Get-STZRecentIssueSummary {
    $serviceNames = @('Spooler', 'wuauserv', 'BITS', 'LanmanWorkstation')
    $serviceIssues = Get-Service -Name $serviceNames -ErrorAction SilentlyContinue | Where-Object {
        $_.Status -ne 'Running' -and $_.StartType -ne 'Disabled'
    } | Select-Object -First 8

    $deviceIssues = @()
    try {
        $deviceIssues = Get-STZProblemDevices | Select-Object -First 8
    }
    catch {
    }

    return [pscustomobject]@{
        Services = $serviceIssues
        Devices  = $deviceIssues
    }
}

function Get-STZDiagnosticsHardwareReportAction {
    $action = Get-STZHardwareReportAction
    $action.Key = '1'
    $action.MenuLabel = 'Hardware Report (CPU / RAM / GPU)'
    return $action
}

function Show-STZDiagnosticsHardwareReport {
    Invoke-STZAction -Action (Get-STZDiagnosticsHardwareReportAction)
}

function Get-STZSystemStatusAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'System Status' `
        -MenuLabel 'System Status (OS / build / admin)' `
        -Description 'Shows concise Windows, session, and machine information.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'System status generated successfully.' `
        -Handler {
            $status = Get-STZSystemStatus

            Write-Host "`n$($script:STZUI.MutedColor) --- SYSTEM STATUS ---$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Windows:$($script:STZUI.TextColor) $($status.WindowsName)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Build:$($script:STZUI.TextColor) $($status.Build)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) User:$($script:STZUI.TextColor) $($status.UserName)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) PowerShell Elevated:$($script:STZUI.TextColor) $($status.Elevated)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Machine:$($script:STZUI.TextColor) $($status.ComputerName)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) ---------------------$($script:STZUI.Reset)"
        }
}

function Show-STZSystemStatus {
    Invoke-STZAction -Action (Get-STZSystemStatusAction)
}

function Get-STZExportDiagnosticReportAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Export Diagnostic Report' `
        -MenuLabel 'Export Diagnostic Report (save to TXT)' `
        -Description 'Saves a compact TXT snapshot with hardware, system, and network details.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Diagnostic report exported successfully.' `
        -Handler {
            $hardware = Get-STZHardwareReport
            $system = Get-STZSystemStatus
            $network = Get-STZNetworkSummary
            $path = Get-STZDiagnosticReportPath
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

            $content = @(
                'STZ SOS Diagnostic Report'
                "Timestamp: $timestamp"
                ''
                '[Hardware]'
                "CPU: $($hardware.CPU)"
                "RAM: $($hardware.RAM)"
                "GPU: $($hardware.GPU)"
                ''
                '[System]'
                "Windows: $($system.WindowsName)"
                "Build: $($system.Build)"
                "User: $($system.UserName)"
                "Admin: $($system.Elevated)"
                "Machine: $($system.ComputerName)"
                ''
                '[Network]'
                "Adapter: $($network.Adapter)"
                "IPv4: $($network.IPv4)"
                "Gateway: $($network.Gateway)"
                "DNS: $($network.DNS)"
            )

            Set-Content -Path $path -Value $content -Encoding UTF8 -ErrorAction Stop
            Start-Process -FilePath 'notepad.exe' -ArgumentList $path -ErrorAction Stop | Out-Null
            Write-Host "`n$($script:STZUI.NeonColor) Report Path:$($script:STZUI.TextColor) $path$($script:STZUI.Reset)"
        }
}

function Export-STZDiagnosticReport {
    Invoke-STZAction -Action (Get-STZExportDiagnosticReportAction)
}

function Get-STZRecentIssuesAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Recent Issues' `
        -MenuLabel 'Recent Issues (services / devices)' `
        -Description 'Shows a practical summary of service and device issues detected right now.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Recent issue summary generated successfully.' `
        -Handler {
            $issues = Get-STZRecentIssueSummary

            Write-Host "`n$($script:STZUI.MutedColor) --- RECENT ISSUES ---$($script:STZUI.Reset)"

            if (-not $issues.Services -and -not $issues.Devices) {
                Write-Host "$($script:STZUI.SuccessColor) No immediate service or device issues detected.$($script:STZUI.Reset)"
                return
            }

            if ($issues.Services) {
                Write-Host "$($script:STZUI.NeonColor) Services:$($script:STZUI.Reset)"
                foreach ($service in $issues.Services) {
                    Write-Host "$($script:STZUI.TextColor) - $($service.Name): $($service.Status)$($script:STZUI.Reset)"
                }
            }

            if ($issues.Devices) {
                Write-Host "$($script:STZUI.NeonColor) Devices:$($script:STZUI.Reset)"
                foreach ($device in $issues.Devices) {
                    $name = if ($device.FriendlyName) { $device.FriendlyName } elseif ($device.Name) { $device.Name } else { 'Unknown device' }
                    Write-Host "$($script:STZUI.TextColor) - $name$($script:STZUI.Reset)"
                }
            }
        }
}

function Show-STZRecentIssues {
    Invoke-STZAction -Action (Get-STZRecentIssuesAction)
}

function Get-STZDiagnosticsMenuActions {
    return @(
        Get-STZDiagnosticsHardwareReportAction
        Get-STZSystemStatusAction
        Get-STZExportDiagnosticReportAction
        Get-STZRecentIssuesAction
    )
}
