function Wait-STZPause {
    [void](Read-Host "`n$($script:STZUI.PromptColor) pressione ENTER para continuar $($script:STZUI.Reset)")
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

function Write-STZMessage {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet('Info', 'Success', 'Warning', 'Error', 'Muted')]
        [string]$Level = 'Info'
    )

    $prefixMap = @{
        Info    = '[*]'
        Success = '[+]'
        Warning = '[!]'
        Error   = '[x]'
        Muted   = '[-]'
    }

    $colorMap = @{
        Info    = $script:STZUI.AccentColor
        Success = $script:STZUI.SuccessColor
        Warning = $script:STZUI.HighlightColor
        Error   = $script:STZUI.HighlightColor
        Muted   = $script:STZUI.MutedColor
    }

    Write-Host "`n$($colorMap[$Level]) $($prefixMap[$Level]) $Message$($script:STZUI.Reset)"
}

function Show-STZFriendlyError {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-Host "`n$($script:STZUI.HighlightColor) [!] $Message$($script:STZUI.Reset)"
}

function Show-STZAdministratorNotice {
    if (-not (Test-STZAdministrator)) {
        Write-Host "$($script:STZUI.HighlightColor) [!] Algumas rotinas podem exigir PowerShell como administrador.$($script:STZUI.Reset)"
    }
}
