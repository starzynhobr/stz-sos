function Show-STZPrintingPlaceholder {
    Write-Host "`n$($script:STZUI.MutedColor) --- PRINTING ---$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.TextColor) Base preparada para rotinas como:$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor) - limpeza de fila$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor) - restart do spooler$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor) - reparo de impressoras$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.HighlightColor) coming soon$($script:STZUI.Reset)"
    Wait-STZPause
}
