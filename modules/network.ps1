function Repair-STZNetworkStack {
    Show-STZLoading -Text 'Purgando tabela DNS'
    ipconfig /flushdns | Out-Null

    Show-STZLoading -Text 'Renovando concessoes de IP'
    ipconfig /release | Out-Null
    ipconfig /renew | Out-Null

    Write-Host "`n$($script:STZUI.AccentColor) [✓] Protocolos de rede reestabelecidos.$($script:STZUI.Reset)"
    Wait-STZPause
}
