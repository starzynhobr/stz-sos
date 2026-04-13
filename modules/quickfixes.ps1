function Restart-STZAudioServicesCore {
    $serviceNames = @('AudioEndpointBuilder', 'Audiosrv')

    foreach ($serviceName in $serviceNames) {
        $service = Get-Service -Name $serviceName -ErrorAction Stop

        if ($service.Status -eq 'Running') {
            Show-STZLoading -Text "Restarting $serviceName"
            Restart-Service -Name $serviceName -Force -ErrorAction Stop
        }
        else {
            Show-STZLoading -Text "Starting $serviceName"
            Start-Service -Name $serviceName -ErrorAction Stop
        }
    }
}

function Get-STZRestartAudioServicesAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Restart Audio Services' `
        -MenuLabel 'Restart Audio Services (fix no sound)' `
        -Description 'Restarts core Windows audio services to recover from common no-sound issues.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Audio services restarted successfully.' `
        -Handler {
            Restart-STZAudioServicesCore
        }
}

function Restart-STZAudioServices {
    Invoke-STZAction -Action (Get-STZRestartAudioServicesAction)
}

function Get-STZQuickFixesMenuActions {
    $restartExplorer = Get-STZRestartExplorerAction
    $restartExplorer.Key = '1'

    $quickNetworkRepair = Get-STZQuickNetworkRepairAction
    $quickNetworkRepair.Key = '3'

    $restartPrintSpooler = Get-STZRestartPrintSpoolerAction
    $restartPrintSpooler.Key = '4'

    $rescanDevices = Get-STZDeviceRescanAction
    $rescanDevices.Key = '5'

    return @(
        $restartExplorer
        Get-STZRestartAudioServicesAction
        $quickNetworkRepair
        $restartPrintSpooler
        $rescanDevices
    )
}
