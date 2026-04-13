function Invoke-STZDiskCleanup {
    $action = New-STZActionDefinition `
        -Title 'Disk Cleanup' `
        -Description 'Purges temporary files and cached data from standard Windows temp locations.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Temporary files were purged successfully.' `
        -Handler {
            Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction Stop
        }

    Invoke-STZAction -Action $action
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

function Show-STZHardwareReport {
    $action = New-STZActionDefinition `
        -Title 'Hardware Report' `
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

    Invoke-STZAction -Action $action
}
