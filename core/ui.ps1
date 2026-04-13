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

    $badges = @()

    if ($Action.RequiresAdmin) {
        $badges += [pscustomobject]@{
            Type = 'Admin'
            Text = '[Admin Required]'
        }
    }

    if ($Action.RebootRecommended) {
        $badges += [pscustomobject]@{
            Type = 'Reboot'
            Text = '[Reboot Recommended]'
        }
    }

    if ($Action.RiskLevel -in @('Medium', 'High')) {
        $badges += [pscustomobject]@{
            Type = 'Risk'
            Text = "[$($Action.RiskLevel) Risk]"
        }
    }

    if (-not $badges) {
        return
    }

    Write-Host "$($script:STZUI.MutedColor) Operational Metadata$($script:STZUI.Reset)"
    foreach ($badge in $badges) {
        Write-STZBadge -Type $badge.Type -Text $badge.Text
    }
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
    Show-STZActionMenu -Title 'System' -Subtitle 'Core operating system maintenance routines.' -Actions @(Get-STZDiskCleanupAction) -BackKey '2'
}

function Show-STZNetworkMenu {
    Show-STZActionMenu -Title 'Network' -Subtitle 'Fast recovery routines for network connectivity.' -Actions (Get-STZNetworkMenuActions) -BackKey '5'
}

function Show-STZDevicesMenu {
    Show-STZActionMenu -Title 'Devices' -Subtitle 'Basic diagnosis and recovery for Plug and Play and HID devices.' -Actions (Get-STZDevicesMenuActions) -BackKey '5'
}

function Show-STZPrintingMenu {
    Show-STZActionMenu -Title 'Printing' -Subtitle 'Maintenance and recovery routines for Windows printing services.' -Actions (Get-STZPrintingMenuActions) -BackKey '5'
}

function Show-STZTweaksMenu {
    Show-STZActionMenu -Title 'Tweaks' -Subtitle 'Safe and reversible Windows convenience tweaks.' -Actions (Get-STZTweaksMenuActions) -BackKey '6'
}

function Show-STZDiagnosticsMenu {
    Show-STZActionMenu -Title 'Diagnostics' -Subtitle 'Basic hardware telemetry and reporting.' -Actions (Get-STZDiagnosticsMenuActions) -BackKey '5'
}

function Start-STZSOS {
    Show-STZLoading -Text 'Initializing terminal modules'
    Show-STZAdministratorNotice
    Start-Sleep -Milliseconds 700
    Show-STZMainMenu
}
