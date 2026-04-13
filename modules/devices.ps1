function Invoke-STZDeviceRescanCore {
    pnputil /scan-devices | Out-Null
}

function Get-STZProblemDevices {
    if (Get-Command Get-PnpDevice -ErrorAction SilentlyContinue) {
        return Get-PnpDevice -PresentOnly -ErrorAction Stop | Where-Object {
            $_.Status -ne 'OK' -or $_.Problem -ne 0
        }
    }

    return Get-CimInstance Win32_PnPEntity -ErrorAction Stop | Where-Object {
        $_.ConfigManagerErrorCode -ne 0
    } | Select-Object @{
        Name = 'FriendlyName'
        Expression = { $_.Name }
    }, @{
        Name = 'Class'
        Expression = { $_.PNPClass }
    }, @{
        Name = 'Status'
        Expression = { 'Error' }
    }, @{
        Name = 'Problem'
        Expression = { $_.ConfigManagerErrorCode }
    }
}

function Get-STZMouseRelatedDevices {
    if (Get-Command Get-PnpDevice -ErrorAction SilentlyContinue) {
        return Get-PnpDevice -PresentOnly -ErrorAction Stop | Where-Object {
            $_.Class -in @('Mouse', 'HIDClass', 'Keyboard') -or
            $_.FriendlyName -match 'mouse|touchpad|hid'
        }
    }

    return Get-CimInstance Win32_PnPEntity -ErrorAction Stop | Where-Object {
        $_.PNPClass -in @('Mouse', 'HIDClass', 'Keyboard') -or
        $_.Name -match 'mouse|touchpad|hid'
    } | Select-Object @{
        Name = 'FriendlyName'
        Expression = { $_.Name }
    }, @{
        Name = 'Class'
        Expression = { $_.PNPClass }
    }, @{
        Name = 'Status'
        Expression = { if ($_.ConfigManagerErrorCode -eq 0) { 'OK' } else { 'Error' } }
    }
}

function Get-STZDeviceRescanAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Rescan Devices' `
        -MenuLabel 'Rescan Devices (refresh Plug and Play)' `
        -Description 'Refreshes Plug and Play detection to pick up recently changed hardware state.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Device rescan completed successfully.' `
        -Handler {
            Show-STZLoading -Text 'Refreshing Plug and Play devices'
            Invoke-STZDeviceRescanCore
        }
}

function Invoke-STZDeviceRescan {
    Invoke-STZAction -Action (Get-STZDeviceRescanAction)
}

function Get-STZDevicesWithErrorsAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Devices With Errors' `
        -MenuLabel 'List Devices With Errors (PnP problem scan)' `
        -Description 'Shows devices that appear to have a Plug and Play problem state.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Problem device scan completed successfully.' `
        -Handler {
            $devices = Get-STZProblemDevices | Select-Object -First 12

            Write-Host "`n$($script:STZUI.MutedColor) --- DEVICE PROBLEMS ---$($script:STZUI.Reset)"

            if (-not $devices) {
                Write-Host "$($script:STZUI.SuccessColor) No device problems detected.$($script:STZUI.Reset)"
                return
            }

            foreach ($device in $devices) {
                $name = if ($device.FriendlyName) { $device.FriendlyName } elseif ($device.Name) { $device.Name } else { 'Unknown device' }
                $class = if ($device.Class) { $device.Class } else { 'Unknown class' }
                $status = if ($device.Status) { $device.Status } else { 'Unknown' }
                $problem = if ($null -ne $device.Problem) { $device.Problem } else { 'N/A' }

                Write-Host "$($script:STZUI.NeonColor) Device:$($script:STZUI.TextColor) $name$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) Class:$($script:STZUI.TextColor) $class$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) State:$($script:STZUI.TextColor) $status / Problem $problem$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.MutedColor) ----------------------$($script:STZUI.Reset)"
            }
        }
}

function Show-STZDevicesWithErrors {
    Invoke-STZAction -Action (Get-STZDevicesWithErrorsAction)
}

function Get-STZBasicMouseRecoveryAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Basic Mouse Recovery' `
        -MenuLabel 'Basic Mouse Recovery (HID / mouse rescan)' `
        -Description 'Runs a safe first-aid routine by rescanning devices and showing mouse or HID entries.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Basic mouse recovery completed successfully.' `
        -Handler {
            Show-STZLoading -Text 'Refreshing HID and mouse devices'
            Invoke-STZDeviceRescanCore

            $devices = Get-STZMouseRelatedDevices | Select-Object -First 10

            Write-Host "`n$($script:STZUI.MutedColor) --- MOUSE / HID DEVICES ---$($script:STZUI.Reset)"
            if (-not $devices) {
                Write-Host "$($script:STZUI.WarningColor) No related mouse or HID devices were found.$($script:STZUI.Reset)"
                return
            }

            foreach ($device in $devices) {
                $name = if ($device.FriendlyName) { $device.FriendlyName } elseif ($device.Name) { $device.Name } else { 'Unknown device' }
                $class = if ($device.Class) { $device.Class } else { 'Unknown class' }
                $status = if ($device.Status) { $device.Status } else { 'Unknown' }

                Write-Host "$($script:STZUI.NeonColor) Device:$($script:STZUI.TextColor) $name$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) Class:$($script:STZUI.TextColor) $class$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.NeonColor) Status:$($script:STZUI.TextColor) $status$($script:STZUI.Reset)"
                Write-Host "$($script:STZUI.MutedColor) --------------------------$($script:STZUI.Reset)"
            }
        }
}

function Invoke-STZBasicMouseRecovery {
    Invoke-STZAction -Action (Get-STZBasicMouseRecoveryAction)
}

function Get-STZOpenDeviceManagerAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Open Device Manager' `
        -MenuLabel 'Open Device Manager (devmgmt.msc)' `
        -Description 'Launches the Windows Device Manager console for manual inspection.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Device Manager launched successfully.' `
        -Handler {
            Start-Process -FilePath 'devmgmt.msc' -ErrorAction Stop | Out-Null
        }
}

function Open-STZDeviceManager {
    Invoke-STZAction -Action (Get-STZOpenDeviceManagerAction)
}

function Get-STZDevicesMenuActions {
    return @(
        Get-STZDeviceRescanAction
        Get-STZDevicesWithErrorsAction
        Get-STZBasicMouseRecoveryAction
        Get-STZOpenDeviceManagerAction
    )
}
