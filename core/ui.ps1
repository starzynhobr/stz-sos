$Host.UI.RawUI.WindowTitle = 'STZ Labs - Terminal'

$script:STZUI = @{
    Esc            = [char]27
    NeonColor      = "$([char]27)[38;2;157;78;221m"
    AccentColor    = "$([char]27)[38;2;0;255;255m"
    HighlightColor = "$([char]27)[38;2;255;0;128m"
    MutedColor     = "$([char]27)[38;2;100;100;100m"
    TextColor      = "$([char]27)[38;2;255;255;255m"
    SuccessColor   = "$([char]27)[38;2;0;255;255m"
    WarningColor   = "$([char]27)[38;2;255;191;0m"
    Reset          = "$([char]27)[0m"
    PromptColor    = "$([char]27)[38;2;157;78;221m"
}

function Show-STZLoading {
    param(
        [Parameter(Mandatory)]
        [string]$Text
    )

    Write-Host "`n$($script:STZUI.MutedColor)[*] $Text $($script:STZUI.Reset)" -NoNewline
    for ($index = 0; $index -lt 3; $index++) {
        Start-Sleep -Milliseconds 400
        Write-Host "$($script:STZUI.HighlightColor).$($script:STZUI.Reset)" -NoNewline
    }
    Write-Host " $($script:STZUI.AccentColor)OK$($script:STZUI.Reset)"
    Start-Sleep -Milliseconds 500
}

function Show-STZHeader {
    try {
        Clear-Host
    }
    catch {
    }

    Write-Host "$($script:STZUI.NeonColor)   _____ _______ ______    $($script:STZUI.HighlightColor) _               ____   _____ $($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor)  / ____|__   __|___  /    $($script:STZUI.HighlightColor)| |        /\   |  _ \ / ____|$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor) | (___    | |     / /     $($script:STZUI.HighlightColor)| |       /  \  | |_) | (___  $($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor)  \___ \   | |    / /      $($script:STZUI.HighlightColor)| |      / /\ \ |  _ < \___ \ $($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor)  ____) |  | |   / /__     $($script:STZUI.HighlightColor)| |____ / ____ \| |_) |____) |$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.NeonColor) |_____/   |_|  /_____|    $($script:STZUI.HighlightColor)|______/_/    \_\____/|_____/ $($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.MutedColor) =======================================================$($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.AccentColor)        C O R E   S Y S T E M   U T I L I T Y           $($script:STZUI.Reset)"
    Write-Host "$($script:STZUI.MutedColor) =======================================================`n$($script:STZUI.Reset)"
}

function Show-STZSectionTitle {
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [string]$Subtitle
    )

    Show-STZHeader
    Write-Host "$($script:STZUI.TextColor) $Title$($script:STZUI.Reset)"
    if ($Subtitle) {
        Write-Host "$($script:STZUI.MutedColor) $Subtitle$($script:STZUI.Reset)"
    }
    Write-Host ''
}

function Write-STZMenuOption {
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Label
    )

    Write-Host "$($script:STZUI.MutedColor) [$($script:STZUI.AccentColor)$Key$($script:STZUI.MutedColor)]$($script:STZUI.TextColor) $Label$($script:STZUI.Reset)"
}

function Read-STZPrompt {
    param(
        [string]$Prompt = 'stz-cli> '
    )

    return Read-Host "$($script:STZUI.PromptColor) $Prompt$($script:STZUI.Reset)"
}

function Write-STZBadge {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Admin', 'Reboot', 'Risk')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$Text
    )

    $badgeColor = switch ($Type) {
        'Admin' { $script:STZUI.HighlightColor }
        'Reboot' { $script:STZUI.WarningColor }
        'Risk' {
            switch -Regex ($Text) {
                'Low Risk' { $script:STZUI.SuccessColor }
                'Medium Risk' { $script:STZUI.WarningColor }
                default { $script:STZUI.HighlightColor }
            }
        }
    }

    Write-Host " $badgeColor$Text$($script:STZUI.Reset)"
}

function Show-STZActionMetadata {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Action
    )

    $adminText = if ($Action.RequiresAdmin) { '[Admin Required]' } else { '[No Admin Required]' }
    $rebootText = if ($Action.RebootRecommended) { '[Reboot Recommended]' } else { '[No Reboot Required]' }
    $riskText = "[$($Action.RiskLevel) Risk]"

    Write-Host "$($script:STZUI.MutedColor) Operational Metadata$($script:STZUI.Reset)"
    Write-STZBadge -Type 'Admin' -Text $adminText
    Write-STZBadge -Type 'Reboot' -Text $rebootText
    Write-STZBadge -Type 'Risk' -Text $riskText
    Write-Host ''
}

function Show-STZActionScreen {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Action
    )

    Show-STZSectionTitle -Title $Action.Title -Subtitle $Action.Description
    Show-STZActionMetadata -Action $Action
    Show-STZLoading -Text 'Preparing action'
}

function Show-STZMainMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Select an execution module:' -Subtitle 'Keyboard-first navigation with the original terminal visual style.'
        if (-not (Test-STZAdministrator)) {
            Write-Host "$($script:STZUI.WarningColor) [Admin Notice]$($script:STZUI.Reset) $($script:STZUI.MutedColor)Run PowerShell as Administrator for protected maintenance actions.$($script:STZUI.Reset)"
            Write-Host ''
        }
        Write-STZMenuOption -Key '1' -Label 'System'
        Write-STZMenuOption -Key '2' -Label 'Network'
        Write-STZMenuOption -Key '3' -Label 'Devices'
        Write-STZMenuOption -Key '4' -Label 'Printing'
        Write-STZMenuOption -Key '5' -Label 'Tweaks'
        Write-STZMenuOption -Key '6' -Label 'Diagnostics'
        Write-STZMenuOption -Key 'Q' -Label 'Exit'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZSystemMenu }
            '2' { Show-STZNetworkMenu }
            '3' { Show-STZDevicesMenu }
            '4' { Show-STZPrintingMenu }
            '5' { Show-STZTweaksMenu }
            '6' { Show-STZDiagnosticsMenu }
            { $_ -in 'Q', 'q' } {
                Show-STZLoading -Text 'Closing session'
                return
            }
            default {
                Show-STZFriendlyError -Message 'Unknown module. Try again.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZSystemMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'System' -Subtitle 'Core operating system maintenance routines.'
        Write-STZMenuOption -Key '1' -Label 'Disk Cleanup (temp/cache purge)'
        Write-STZMenuOption -Key '2' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Invoke-STZDiskCleanup }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in System.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZNetworkMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Network' -Subtitle 'Fast recovery routines for network connectivity.'
        Write-STZMenuOption -Key '1' -Label 'Quick Network Repair (flush DNS / renew IP)'
        Write-STZMenuOption -Key '2' -Label 'Deep Network Repair (reset Winsock / TCP-IP)'
        Write-STZMenuOption -Key '3' -Label 'Show Network Report (IP / DNS / gateway)'
        Write-STZMenuOption -Key '4' -Label 'Test Connectivity (gateway / DNS / internet)'
        Write-STZMenuOption -Key '5' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Invoke-STZQuickNetworkRepair }
            '2' { Invoke-STZDeepNetworkRepair }
            '3' { Show-STZNetworkReport }
            '4' { Test-STZConnectivity }
            '5' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in Network.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZDevicesMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Devices' -Subtitle 'Reserved structure for future device support.'
        Write-STZMenuOption -Key '1' -Label 'Show current device placeholders'
        Write-STZMenuOption -Key '2' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZDevicesPlaceholder }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in Devices.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZPrintingMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Printing' -Subtitle 'Maintenance and recovery routines for Windows printing services.'
        Write-STZMenuOption -Key '1' -Label 'Show Spooler Status (service / startup type)'
        Write-STZMenuOption -Key '2' -Label 'Restart Print Spooler (stop / start service)'
        Write-STZMenuOption -Key '3' -Label 'Clear Print Queue (purge pending jobs)'
        Write-STZMenuOption -Key '4' -Label 'Repair Print Stack (reset queue / spooler)'
        Write-STZMenuOption -Key '5' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZPrintSpoolerStatus }
            '2' { Restart-STZPrintSpooler }
            '3' { Clear-STZPrintQueue }
            '4' { Repair-STZPrintStack }
            '5' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in Printing.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZTweaksMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Tweaks' -Subtitle 'Reserved space for future Windows adjustments.'
        Write-STZMenuOption -Key '1' -Label 'Show current tweaks placeholders'
        Write-STZMenuOption -Key '2' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZTweaksPlaceholder }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in Tweaks.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZDiagnosticsMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Diagnostics' -Subtitle 'Basic hardware telemetry and reporting.'
        Write-STZMenuOption -Key '1' -Label 'Hardware report (CPU/RAM/GPU)'
        Write-STZMenuOption -Key '2' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZHardwareReport }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in Diagnostics.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Start-STZSOS {
    Show-STZLoading -Text 'Initializing terminal modules'
    Show-STZAdministratorNotice
    Start-Sleep -Milliseconds 700
    Show-STZMainMenu
}
