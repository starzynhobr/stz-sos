function Get-STZPrintSpoolerService {
    return Get-Service -Name 'Spooler' -ErrorAction Stop
}

function Get-STZPrintSpoolerStartType {
    try {
        $service = Get-CimInstance Win32_Service -Filter "Name='Spooler'" -ErrorAction Stop
        return $service.StartMode
    }
    catch {
        return 'Unknown'
    }
}

function Stop-STZPrintSpooler {
    $service = Get-STZPrintSpoolerService
    if ($service.Status -ne 'Stopped') {
        Stop-Service -Name 'Spooler' -Force -ErrorAction Stop
        $service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Stopped, [TimeSpan]::FromSeconds(15))
    }
}

function Start-STZPrintSpooler {
    $service = Get-STZPrintSpoolerService
    if ($service.Status -ne 'Running') {
        Start-Service -Name 'Spooler' -ErrorAction Stop
        $service.WaitForStatus([System.ServiceProcess.ServiceControllerStatus]::Running, [TimeSpan]::FromSeconds(15))
    }
}

function Clear-STZPrintQueueFiles {
    $queuePath = 'C:\Windows\System32\spool\PRINTERS\*'
    Remove-Item -Path $queuePath -Force -Recurse -ErrorAction Stop
}

function Invoke-STZPrintQueueCleanup {
    Stop-STZPrintSpooler
    Clear-STZPrintQueueFiles
    Start-STZPrintSpooler
}

function Get-STZPrintSpoolerStatusAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Print Spooler Status' `
        -MenuLabel 'Show Spooler Status (service / startup type)' `
        -Description 'Displays the current Spooler service state and startup mode.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Print Spooler status retrieved successfully.' `
        -Handler {
            $service = Get-STZPrintSpoolerService
            $startType = Get-STZPrintSpoolerStartType

            Write-Host "`n$($script:STZUI.MutedColor) --- SPOOLER STATUS ---$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Service:$($script:STZUI.TextColor) Spooler$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Status:$($script:STZUI.TextColor) $($service.Status)$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.NeonColor) Start Type:$($script:STZUI.TextColor) $startType$($script:STZUI.Reset)"
            Write-Host "$($script:STZUI.MutedColor) ----------------------$($script:STZUI.Reset)"
        }
}

function Show-STZPrintSpoolerStatus {
    Invoke-STZAction -Action (Get-STZPrintSpoolerStatusAction)
}

function Get-STZRestartPrintSpoolerAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Restart Print Spooler' `
        -MenuLabel 'Restart Print Spooler (stop / start service)' `
        -Description 'Stops and starts the Windows Print Spooler service.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Print Spooler restarted successfully.' `
        -Handler {
            Stop-STZPrintSpooler
            Start-STZPrintSpooler
        }
}

function Restart-STZPrintSpooler {
    Invoke-STZAction -Action (Get-STZRestartPrintSpoolerAction)
}

function Get-STZClearPrintQueueAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Clear Print Queue' `
        -MenuLabel 'Clear Print Queue (purge pending jobs)' `
        -Description 'Stops the spooler, clears queued print jobs, and starts the service again.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Medium' `
        -SuccessMessage 'Print queue cleared successfully.' `
        -Handler {
            Invoke-STZPrintQueueCleanup
        }
}

function Clear-STZPrintQueue {
    Invoke-STZAction -Action (Get-STZClearPrintQueueAction)
}

function Get-STZRepairPrintStackAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Repair Print Stack' `
        -MenuLabel 'Repair Print Stack (reset queue / spooler)' `
        -Description 'Runs a simple print recovery routine by recycling the spooler and clearing the queue.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Medium' `
        -SuccessMessage 'Print stack repair completed successfully.' `
        -Handler {
            Invoke-STZPrintQueueCleanup
        }
}

function Repair-STZPrintStack {
    Invoke-STZAction -Action (Get-STZRepairPrintStackAction)
}

function Get-STZPrintingMenuActions {
    return @(
        Get-STZPrintSpoolerStatusAction
        Get-STZRestartPrintSpoolerAction
        Get-STZClearPrintQueueAction
        Get-STZRepairPrintStackAction
    )
}
