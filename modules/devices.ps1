function Show-STZDevicesPlaceholder {
    Write-Host "`n$($script:STZUI.MutedColor) --- DEVICES ---$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.TextColor) Espaco reservado para rotinas como:$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor) - diagnostico de USB$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor) - inventario de drivers$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor) - verificacao de perifericos$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.HighlightColor) coming soon$($script:STZUI.Reset)"
    Wait-STZPause
}
