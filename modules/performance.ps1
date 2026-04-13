function Set-STZBackgroundAppsPolicy {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Disable', 'Default')]
        [string]$Mode
    )

    $policyKey = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy'
    if (-not (Test-Path $policyKey)) {
        New-Item -Path $policyKey -Force | Out-Null
    }

    if ($Mode -eq 'Disable') {
        Set-ItemProperty -Path $policyKey -Name 'LetAppsRunInBackground' -Value 2 -Type DWord -ErrorAction Stop
        return
    }

    if (Get-ItemProperty -Path $policyKey -Name 'LetAppsRunInBackground' -ErrorAction SilentlyContinue) {
        Remove-ItemProperty -Path $policyKey -Name 'LetAppsRunInBackground' -ErrorAction Stop
    }
}

function Set-STZExplorerDwordValue {
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [int]$Value
    )

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type DWord -ErrorAction Stop
}

function Set-STZDesktopStringValue {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Value
    )

    $desktopKey = 'HKCU:\Control Panel\Desktop'
    Set-ItemProperty -Path $desktopKey -Name $Name -Value $Value -ErrorAction Stop
}

function Set-STZVisualEffectState {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [bool]$Enabled
    )

    $visualEffectsRoot = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
    $effectKey = Join-Path -Path $visualEffectsRoot -ChildPath $Name

    if (-not (Test-Path $effectKey)) {
        New-Item -Path $effectKey -Force | Out-Null
    }

    $value = if ($Enabled) { 1 } else { 0 }
    Set-ItemProperty -Path $effectKey -Name 'DefaultApplied' -Value $value -Type DWord -ErrorAction Stop
}

function Set-STZVisualEffectsPreset {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Reduce', 'Default')]
        [string]$Mode
    )

    $desktopKey = 'HKCU:\Control Panel\Desktop'
    $advancedKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $visualEffectsKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
    $dwmKey = 'HKCU:\Software\Microsoft\Windows\DWM'

    if ($Mode -eq 'Reduce') {
        Set-STZVisualEffectState -Name 'ControlAnimations' -Enabled $false
        Set-STZVisualEffectState -Name 'AnimateMinMax' -Enabled $false
        Set-STZVisualEffectState -Name 'TaskbarAnimations' -Enabled $false
        Set-STZVisualEffectState -Name 'MenuAnimation' -Enabled $false
        Set-STZVisualEffectState -Name 'TooltipAnimation' -Enabled $false
        Set-STZVisualEffectState -Name 'SelectionFade' -Enabled $false
        Set-STZVisualEffectState -Name 'ComboBoxAnimation' -Enabled $false
        Set-STZVisualEffectState -Name 'DWMAeroPeekEnabled' -Enabled $false

        Set-STZExplorerDwordValue -Path $advancedKey -Name 'TaskbarAnimations' -Value 0
        Set-STZExplorerDwordValue -Path $dwmKey -Name 'EnableAeroPeek' -Value 0

        Set-STZVisualEffectState -Name 'DragFullWindows' -Enabled $true
        Set-STZVisualEffectState -Name 'ThumbnailsOrIcon' -Enabled $true
        Set-STZVisualEffectState -Name 'ListviewAlphaSelect' -Enabled $true
        Set-STZVisualEffectState -Name 'DropShadow' -Enabled $true
        Set-STZVisualEffectState -Name 'ListBoxSmoothScrolling' -Enabled $true
        Set-STZVisualEffectState -Name 'DWMSaveThumbnailEnabled' -Enabled $true
        Set-STZVisualEffectState -Name 'FontSmoothing' -Enabled $true
        Set-STZExplorerDwordValue -Path $advancedKey -Name 'IconsOnly' -Value 0
        Set-STZExplorerDwordValue -Path $advancedKey -Name 'ListviewAlphaSelect' -Value 1
        Set-STZExplorerDwordValue -Path $dwmKey -Name 'AlwaysHibernateThumbnails' -Value 1
        Set-STZDesktopStringValue -Name 'FontSmoothing' -Value '2'
        Set-STZExplorerDwordValue -Path $desktopKey -Name 'FontSmoothingType' -Value 2
        Set-STZDesktopStringValue -Name 'DragFullWindows' -Value '1'
        Set-STZDesktopStringValue -Name 'MinAnimate' -Value '0'
        Set-STZExplorerDwordValue -Path $visualEffectsKey -Name 'VisualFXSetting' -Value 3
        return
    }

    Set-STZVisualEffectState -Name 'ControlAnimations' -Enabled $true
    Set-STZVisualEffectState -Name 'AnimateMinMax' -Enabled $true
    Set-STZVisualEffectState -Name 'TaskbarAnimations' -Enabled $true
    Set-STZVisualEffectState -Name 'MenuAnimation' -Enabled $true
    Set-STZVisualEffectState -Name 'TooltipAnimation' -Enabled $true
    Set-STZVisualEffectState -Name 'SelectionFade' -Enabled $true
    Set-STZVisualEffectState -Name 'ComboBoxAnimation' -Enabled $true
    Set-STZVisualEffectState -Name 'DWMAeroPeekEnabled' -Enabled $true

    Set-STZExplorerDwordValue -Path $advancedKey -Name 'TaskbarAnimations' -Value 1
    Set-STZExplorerDwordValue -Path $dwmKey -Name 'EnableAeroPeek' -Value 1

    Set-STZVisualEffectState -Name 'DragFullWindows' -Enabled $true
    Set-STZVisualEffectState -Name 'ThumbnailsOrIcon' -Enabled $true
    Set-STZVisualEffectState -Name 'ListviewAlphaSelect' -Enabled $true
    Set-STZVisualEffectState -Name 'DropShadow' -Enabled $true
    Set-STZVisualEffectState -Name 'ListBoxSmoothScrolling' -Enabled $true
    Set-STZVisualEffectState -Name 'DWMSaveThumbnailEnabled' -Enabled $true
    Set-STZVisualEffectState -Name 'FontSmoothing' -Enabled $true
    Set-STZExplorerDwordValue -Path $advancedKey -Name 'IconsOnly' -Value 0
    Set-STZExplorerDwordValue -Path $advancedKey -Name 'ListviewAlphaSelect' -Value 1
    Set-STZExplorerDwordValue -Path $dwmKey -Name 'AlwaysHibernateThumbnails' -Value 1
    Set-STZDesktopStringValue -Name 'FontSmoothing' -Value '2'
    Set-STZExplorerDwordValue -Path $desktopKey -Name 'FontSmoothingType' -Value 2
    Set-STZDesktopStringValue -Name 'DragFullWindows' -Value '1'
    Set-STZDesktopStringValue -Name 'MinAnimate' -Value '1'
    Set-STZExplorerDwordValue -Path $visualEffectsKey -Name 'VisualFXSetting' -Value 0
}

function Set-STZTransparencyEffects {
    param(
        [Parameter(Mandatory)]
        [bool]$Enabled
    )

    $personalizeKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    $value = if ($Enabled) { 1 } else { 0 }
    Set-STZExplorerDwordValue -Path $personalizeKey -Name 'EnableTransparency' -Value $value
}

function Get-STZDisableBackgroundAppsAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Disable Background Apps' `
        -MenuLabel 'Disable Background Apps (Windows app activity)' `
        -Description 'Applies a conservative global policy to reduce Windows background app activity.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Medium' `
        -SuccessMessage 'Background app activity disabled successfully.' `
        -Handler {
            Set-STZBackgroundAppsPolicy -Mode 'Disable'
        }
}

function Disable-STZBackgroundApps {
    Invoke-STZAction -Action (Get-STZDisableBackgroundAppsAction)
}

function Get-STZRestoreBackgroundAppsDefaultAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Restore Background Apps Default' `
        -MenuLabel 'Restore Background Apps Default' `
        -Description 'Removes the background app restriction policy and restores the default behavior.' `
        -RequiresAdmin $true `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Background app default behavior restored successfully.' `
        -Handler {
            Set-STZBackgroundAppsPolicy -Mode 'Default'
        }
}

function Restore-STZBackgroundAppsDefault {
    Invoke-STZAction -Action (Get-STZRestoreBackgroundAppsDefaultAction)
}

function Get-STZReduceVisualEffectsAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Reduce Visual Effects' `
        -MenuLabel 'Reduce Visual Effects (keep drag + thumbnails)' `
        -Description 'Applies a lighter visual preset while keeping drag contents and thumbnails enabled.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Reduced visual effects preset applied successfully.' `
        -Handler {
            Set-STZVisualEffectsPreset -Mode 'Reduce'
            Restart-STZExplorerCore
        }
}

function Reduce-STZVisualEffects {
    Invoke-STZAction -Action (Get-STZReduceVisualEffectsAction)
}

function Get-STZRestoreVisualEffectsDefaultAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Restore Visual Effects Default' `
        -MenuLabel 'Restore Visual Effects Default' `
        -Description 'Restores the default visual effects behavior for the current user.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Default visual effects restored successfully.' `
        -Handler {
            Set-STZVisualEffectsPreset -Mode 'Default'
            Restart-STZExplorerCore
        }
}

function Restore-STZVisualEffectsDefault {
    Invoke-STZAction -Action (Get-STZRestoreVisualEffectsDefaultAction)
}

function Get-STZDisableTransparencyEffectsAction {
    return New-STZActionDefinition `
        -Key '5' `
        -Title 'Disable Transparency Effects' `
        -MenuLabel 'Disable Transparency Effects' `
        -Description 'Disables Windows transparency effects for a slightly cleaner rendering path.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Transparency effects disabled successfully.' `
        -Handler {
            Set-STZTransparencyEffects -Enabled $false
            Restart-STZExplorerCore
        }
}

function Disable-STZTransparencyEffects {
    Invoke-STZAction -Action (Get-STZDisableTransparencyEffectsAction)
}

function Get-STZEnableTransparencyEffectsAction {
    return New-STZActionDefinition `
        -Key '6' `
        -Title 'Enable Transparency Effects' `
        -MenuLabel 'Enable Transparency Effects' `
        -Description 'Re-enables Windows transparency effects for the current user.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Transparency effects enabled successfully.' `
        -Handler {
            Set-STZTransparencyEffects -Enabled $true
            Restart-STZExplorerCore
        }
}

function Enable-STZTransparencyEffects {
    Invoke-STZAction -Action (Get-STZEnableTransparencyEffectsAction)
}

function Get-STZOpenAdvancedPerformanceSettingsAction {
    return New-STZActionDefinition `
        -Key '7' `
        -Title 'Open Advanced Performance Settings' `
        -MenuLabel 'Open Advanced Performance Settings' `
        -Description 'Opens the classic Windows performance options dialog.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Advanced Performance Settings opened successfully.' `
        -Handler {
            Start-Process -FilePath 'SystemPropertiesPerformance.exe' -ErrorAction Stop | Out-Null
        }
}

function Open-STZAdvancedPerformanceSettings {
    Invoke-STZAction -Action (Get-STZOpenAdvancedPerformanceSettingsAction)
}

function Get-STZPerformanceMenuActions {
    return @(
        Get-STZDisableBackgroundAppsAction
        Get-STZRestoreBackgroundAppsDefaultAction
        Get-STZReduceVisualEffectsAction
        Get-STZRestoreVisualEffectsDefaultAction
        Get-STZDisableTransparencyEffectsAction
        Get-STZEnableTransparencyEffectsAction
        Get-STZOpenAdvancedPerformanceSettingsAction
    )
}
