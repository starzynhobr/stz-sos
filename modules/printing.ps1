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

function Show-STZPrintSpoolerStatus {
    $action = New-STZActionDefinition `
        -Title 'Print Spooler Status' `
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

    Invoke-STZAction -Action $action
}

function Restart-STZPrintSpooler {
    $action = New-STZActionDefinition `
        -Title 'Restart Print Spooler' `
        -Description 'Stops and starts the Windows Print Spooler service.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Print Spooler restarted successfully.' `
        -Handler {
            Stop-STZPrintSpooler
            Start-STZPrintSpooler
        }

    Invoke-STZAction -Action $action
}

function Clear-STZPrintQueue {
    $action = New-STZActionDefinition `
        -Title 'Clear Print Queue' `
        -Description 'Stops the spooler, clears queued print jobs, and starts the service again.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Medium' `
        -SuccessMessage 'Print queue cleared successfully.' `
        -Handler {
            Invoke-STZPrintQueueCleanup
        }

    Invoke-STZAction -Action $action
}

function Repair-STZPrintStack {
    $action = New-STZActionDefinition `
        -Title 'Repair Print Stack' `
        -Description 'Runs a simple print recovery routine by recycling the spooler and clearing the queue.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Medium' `
        -SuccessMessage 'Print stack repair completed successfully.' `
        -Handler {
            Invoke-STZPrintQueueCleanup
        }

    Invoke-STZAction -Action $action
}
