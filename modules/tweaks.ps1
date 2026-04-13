function Restart-STZExplorerCore {
    $explorerProcesses = Get-Process -Name 'explorer' -ErrorAction SilentlyContinue
    if ($explorerProcesses) {
        $explorerProcesses | Stop-Process -Force -ErrorAction Stop
        Start-Sleep -Milliseconds 800
    }

    Start-Process -FilePath 'explorer.exe' -ErrorAction Stop | Out-Null
}

function Set-STZClassicContextMenuState {
    param(
        [Parameter(Mandatory)]
        [bool]$Enabled
    )

    $baseKey = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}'
    $inprocKey = Join-Path $baseKey 'InprocServer32'

    if ($Enabled) {
        New-Item -Path $inprocKey -Force | Out-Null
        Set-ItemProperty -Path $inprocKey -Name '(default)' -Value '' -ErrorAction Stop
        return
    }

    if (Test-Path $baseKey) {
        Remove-Item -Path $baseKey -Recurse -Force -ErrorAction Stop
    }
}

function Set-STZFileExtensionsVisibility {
    param(
        [Parameter(Mandatory)]
        [bool]$Visible
    )

    $advancedKey = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $hideValue = if ($Visible) { 0 } else { 1 }

    Set-ItemProperty -Path $advancedKey -Name 'HideFileExt' -Value $hideValue -Type DWord -ErrorAction Stop
}

function Get-STZEnableClassicContextMenuAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Enable Classic Context Menu' `
        -MenuLabel 'Enable Classic Context Menu (Windows 11 legacy menu)' `
        -Description 'Restores the legacy Windows 11 context menu and refreshes Explorer.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Classic context menu enabled successfully.' `
        -Handler {
            Set-STZClassicContextMenuState -Enabled $true
            Restart-STZExplorerCore
        }
}

function Enable-STZClassicContextMenu {
    Invoke-STZAction -Action (Get-STZEnableClassicContextMenuAction)
}

function Get-STZDisableClassicContextMenuAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Disable Classic Context Menu' `
        -MenuLabel 'Disable Classic Context Menu (restore default menu)' `
        -Description 'Restores the default Windows 11 context menu behavior and refreshes Explorer.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Default context menu restored successfully.' `
        -Handler {
            Set-STZClassicContextMenuState -Enabled $false
            Restart-STZExplorerCore
        }
}

function Disable-STZClassicContextMenu {
    Invoke-STZAction -Action (Get-STZDisableClassicContextMenuAction)
}

function Get-STZRestartExplorerAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Restart Explorer' `
        -MenuLabel 'Restart Explorer (refresh shell)' `
        -Description 'Restarts the Windows shell to refresh Explorer and desktop UI state.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Explorer restarted successfully.' `
        -Handler {
            Restart-STZExplorerCore
        }
}

function Restart-STZExplorer {
    Invoke-STZAction -Action (Get-STZRestartExplorerAction)
}

function Get-STZShowFileExtensionsAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Show File Extensions' `
        -MenuLabel 'Show File Extensions (enable known extensions)' `
        -Description 'Enables known file extension visibility in File Explorer and refreshes Explorer.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'File extensions are now visible.' `
        -Handler {
            Set-STZFileExtensionsVisibility -Visible $true
            Restart-STZExplorerCore
        }
}

function Show-STZFileExtensions {
    Invoke-STZAction -Action (Get-STZShowFileExtensionsAction)
}

function Get-STZHideFileExtensionsAction {
    return New-STZActionDefinition `
        -Key '5' `
        -Title 'Hide File Extensions' `
        -MenuLabel 'Hide File Extensions (restore default behavior)' `
        -Description 'Restores the default File Explorer behavior for known file extensions.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'File extensions are now hidden.' `
        -Handler {
            Set-STZFileExtensionsVisibility -Visible $false
            Restart-STZExplorerCore
        }
}

function Hide-STZFileExtensions {
    Invoke-STZAction -Action (Get-STZHideFileExtensionsAction)
}

function Get-STZTweaksMenuActions {
    return @(
        Get-STZEnableClassicContextMenuAction
        Get-STZDisableClassicContextMenuAction
        Get-STZRestartExplorerAction
        Get-STZShowFileExtensionsAction
        Get-STZHideFileExtensionsAction
    )
}
