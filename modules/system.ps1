function Invoke-STZDiskCleanup {
    Show-STZLoading -Text 'Limpando arquivos temporarios'

    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:WINDIR\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "`n$($script:STZUI.AccentColor) [✓] Cache do sistema purgado com sucesso.$($script:STZUI.Reset)"
    Wait-STZPause
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
    Show-STZLoading -Text 'Buscando telemetria de hardware'
    $report = Get-STZHardwareReport

    Write-Host "`n$($script:STZUI.MutedColor) --- SPEC REPORT ---$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor) CPU:$($script:STZUI.TextColor) $($report.CPU)$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor) RAM:$($script:STZUI.TextColor) $($report.RAM)$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor) GPU:$($script:STZUI.TextColor) $($report.GPU)$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.MutedColor) -------------------$($script:STZUI.Reset)"
    Wait-STZPause
}
