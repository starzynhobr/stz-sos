function Wait-STZPause {
    [void](Read-Host "`n$($script:STZUI.PromptColor) press ENTER to continue $($script:STZUI.Reset)")
}

function Test-STZAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Join-STZPath {
    param(
        [Parameter(Mandatory)]
        [string]$BasePath,

        [Parameter(Mandatory)]
        [string]$ChildPath
    )

    return Join-Path $BasePath $ChildPath
}

function New-STZActionDefinition {
    param(
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter(Mandatory)]
        [scriptblock]$Handler,

        [ValidateSet('Low', 'Medium', 'High')]
        [string]$RiskLevel = 'Low',

        [bool]$RequiresAdmin = $false,

        [bool]$RebootRecommended = $false,

        [string]$SuccessMessage = 'Action completed successfully.'
    )

    return [pscustomobject]@{
        Title             = $Title
        Description       = $Description
        Handler           = $Handler
        RiskLevel         = $RiskLevel
        RequiresAdmin     = $RequiresAdmin
        RebootRecommended = $RebootRecommended
        SuccessMessage    = $SuccessMessage
    }
}

function Get-STZActionBadgeText {
    param(
        [Parameter(Mandatory)]
        [string]$Label,

        [Parameter(Mandatory)]
        [string]$Value
    )

    return "[${Label}: $Value]"
}

function Write-STZStatus {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('SUCCESS', 'WARNING', 'ERROR', 'INFO')]
        [string]$Type,

        [Parameter(Mandatory)]
        [string]$Message
    )

    $colorMap = @{
        SUCCESS = $script:STZUI.SuccessColor
        WARNING = $script:STZUI.WarningColor
        ERROR   = $script:STZUI.HighlightColor
        INFO    = $script:STZUI.AccentColor
    }

    Write-Host "`n$($colorMap[$Type])[$Type]$($script:STZUI.Reset) $($script:STZUI.TextColor)$Message$($script:STZUI.Reset)"
}

function Show-STZFriendlyError {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-STZStatus -Type 'ERROR' -Message $Message
}

function Show-STZAdministratorNotice {
    if (-not (Test-STZAdministrator)) {
        Write-STZStatus -Type 'WARNING' -Message 'Some actions may require running PowerShell as Administrator.'
    }
}

function Show-STZAdminRequirementError {
    param(
        [Parameter(Mandatory)]
        [string]$ActionTitle
    )

    Write-STZStatus -Type 'ERROR' -Message "$ActionTitle requires an elevated PowerShell session."
    Write-STZStatus -Type 'INFO' -Message 'Restart PowerShell as Administrator and try again.'
}

function Get-STZErrorMessage {
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    if ($ErrorRecord.Exception -and $ErrorRecord.Exception.Message) {
        return $ErrorRecord.Exception.Message
    }

    return 'An unexpected error occurred while running the action.'
}

function Invoke-STZAction {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Action
    )

    Show-STZActionScreen -Action $Action

    if ($Action.RequiresAdmin -and -not (Test-STZAdministrator)) {
        Show-STZAdminRequirementError -ActionTitle $Action.Title
        Wait-STZPause
        return
    }

    try {
        & $Action.Handler
        Write-STZStatus -Type 'SUCCESS' -Message $Action.SuccessMessage
    }
    catch {
        $friendlyMessage = Get-STZErrorMessage -ErrorRecord $_
        Show-STZFriendlyError -Message $friendlyMessage
    }

    Wait-STZPause
}
