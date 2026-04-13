function Invoke-STZIconCacheRebuildCore {
    $iconCacheFiles = @(
        (Join-Path $env:LOCALAPPDATA 'IconCache.db')
    )
    $iconCacheFiles += Get-ChildItem -Path (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Explorer') -Filter 'iconcache*' -File -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty FullName

    Show-STZLoading -Text 'Stopping Explorer shell'
    $explorerProcesses = Get-Process -Name 'explorer' -ErrorAction SilentlyContinue
    if ($explorerProcesses) {
        $explorerProcesses | Stop-Process -Force -ErrorAction Stop
        Start-Sleep -Milliseconds 800
    }

    Show-STZLoading -Text 'Removing icon cache files'
    foreach ($file in ($iconCacheFiles | Sort-Object -Unique)) {
        if (Test-Path $file) {
            Remove-Item -Path $file -Force -ErrorAction Stop
        }
    }

    Show-STZLoading -Text 'Restarting Explorer shell'
    Start-Process -FilePath 'explorer.exe' -ErrorAction Stop | Out-Null
}

function Get-STZDiskCleanupAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Disk Cleanup' `
        -MenuLabel 'Disk Cleanup (temp/cache purge)' `
        -Description 'Purges temporary files and cached data from standard Windows temp locations.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Temporary files were purged successfully.' `
        -Handler {
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction Stop
        }
}

function Invoke-STZDiskCleanup {
    Invoke-STZAction -Action (Get-STZDiskCleanupAction)
}

function Get-STZRebuildIconCacheAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Rebuild Icon Cache' `
        -MenuLabel 'Rebuild Icon Cache (refresh broken icons)' `
        -Description 'Rebuilds the current user icon cache and restarts Explorer to refresh stale or broken icons.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Icon cache rebuilt successfully.' `
        -Handler {
            Invoke-STZIconCacheRebuildCore
        }
}

function Rebuild-STZIconCache {
    Invoke-STZAction -Action (Get-STZRebuildIconCacheAction)
}

function Get-STZOpenStartupFolderAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Open Startup Folder' `
        -MenuLabel 'Open Startup Folder (current user)' `
        -Description 'Opens the current user Startup folder for quick login item checks.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Startup folder opened successfully.' `
        -Handler {
            Start-Process -FilePath 'explorer.exe' -ArgumentList 'shell:startup' -ErrorAction Stop | Out-Null
        }
}

function Open-STZStartupFolder {
    Invoke-STZAction -Action (Get-STZOpenStartupFolderAction)
}

function Get-STZOpenServicesAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Open Services' `
        -MenuLabel 'Open Services (services.msc)' `
        -Description 'Opens the classic Windows Services management console.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Services console opened successfully.' `
        -Handler {
            Start-Process -FilePath 'services.msc' -ErrorAction Stop | Out-Null
        }
}

function Open-STZServices {
    Invoke-STZAction -Action (Get-STZOpenServicesAction)
}

function Get-STZOpenDeviceManagerAction {
    return New-STZActionDefinition `
        -Key '5' `
        -Title 'Open Device Manager' `
        -MenuLabel 'Open Device Manager (devmgmt.msc)' `
        -Description 'Opens Windows Device Manager for hardware inspection and troubleshooting.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Device Manager opened successfully.' `
        -Handler {
            Start-Process -FilePath 'devmgmt.msc' -ErrorAction Stop | Out-Null
        }
}

function Open-STZSystemDeviceManager {
    Invoke-STZAction -Action (Get-STZOpenDeviceManagerAction)
}

function Get-STZOpenNetworkAdaptersAction {
    return New-STZActionDefinition `
        -Key '6' `
        -Title 'Open Network Adapters' `
        -MenuLabel 'Open Network Adapters (ncpa.cpl)' `
        -Description 'Opens the classic Network Connections adapters view directly.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Network Adapters opened successfully.' `
        -Handler {
            Start-Process -FilePath 'ncpa.cpl' -ErrorAction Stop | Out-Null
        }
}

function Open-STZNetworkAdapters {
    Invoke-STZAction -Action (Get-STZOpenNetworkAdaptersAction)
}

function Get-STZHardwareReport {
    $cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Name
    $ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $gpu = Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name

    return [pscustomobject]@{
        CPU = $cpu
        RAM = "$ram GB"
        GPU = $gpu
    }
}

function Get-STZHardwareReportAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Hardware Report' `
        -MenuLabel 'Hardware Report (CPU / RAM / GPU)' `
        -Description 'Collects a basic CPU, RAM, and GPU summary for the current machine.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Hardware report generated successfully.' `
        -Handler {
            $report = Get-STZHardwareReport

            Write-Host "`n$($script:STZUI.MutedColor) --- SPEC REPORT ---$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) CPU:$($script:STZUI.TextColor) $($report.CPU)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) RAM:$($script:STZUI.TextColor) $($report.RAM)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) GPU:$($script:STZUI.TextColor) $($report.GPU)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) -------------------$($script:STZUI.Reset)"
        }
}

function Show-STZHardwareReport {
    Invoke-STZAction -Action (Get-STZHardwareReportAction)
}

function Get-STZSystemMenuActions {
    return @(
        Get-STZDiskCleanupAction
        Get-STZRebuildIconCacheAction
        Get-STZOpenStartupFolderAction
        Get-STZOpenServicesAction
        Get-STZOpenDeviceManagerAction
        Get-STZOpenNetworkAdaptersAction
    )
}
