$Host.UI.RawUI.WindowTitle = 'STZ Labs - Terminal'

$script:STZUI = @{
    Esc            = [char]27
    NeonColor      = "$([char]27)[38;2;157;78;221m"
    AccentColor    = "$([char]27)[38;2;0;255;255m"
    HighlightColor = "$([char]27)[38;2;255;0;128m"
    MutedColor     = "$([char]27)[38;2;100;100;100m"
    TextColor      = "$([char]27)[38;2;255;255;255m"
    SuccessColor   = "$([char]27)[38;2;0;255;255m"
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

function Show-STZMainMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Selecione um modulo de execucao:' -Subtitle 'Navegacao por teclado, estilo terminal original preservado.'
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
                Show-STZLoading -Text 'Encerrando sessao'
                return
            }
            default {
                Show-STZFriendlyError -Message 'Modulo nao reconhecido. Tente novamente.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZSystemMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'System' -Subtitle 'Rotinas principais de manutencao do sistema.'
        Write-STZMenuOption -Key '1' -Label 'Otimizacao de Disco (Limpar Temp/Cache)'
        Write-STZMenuOption -Key '2' -Label 'Voltar'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Invoke-STZDiskCleanup }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Opcao invalida no modulo System.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZNetworkMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Network' -Subtitle 'Recuperacao rapida de conectividade.'
        Write-STZMenuOption -Key '1' -Label 'Reset de Interface de Rede (DNS/IP)'
        Write-STZMenuOption -Key '2' -Label 'Voltar'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Repair-STZNetworkStack }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Opcao invalida no modulo Network.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZDevicesMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Devices' -Subtitle 'Estrutura pronta para expansao.'
        Write-STZMenuOption -Key '1' -Label 'Listar placeholders de suporte a dispositivos'
        Write-STZMenuOption -Key '2' -Label 'Voltar'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZDevicesPlaceholder }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Opcao invalida no modulo Devices.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZPrintingMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Printing' -Subtitle 'Base pronta para manutencao e reparo de impressao.'
        Write-STZMenuOption -Key '1' -Label 'Listar placeholders de impressao'
        Write-STZMenuOption -Key '2' -Label 'Voltar'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZPrintingPlaceholder }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Opcao invalida no modulo Printing.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZTweaksMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Tweaks' -Subtitle 'Espaco reservado para ajustes futuros do Windows.'
        Write-STZMenuOption -Key '1' -Label 'Listar placeholders de tweaks'
        Write-STZMenuOption -Key '2' -Label 'Voltar'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZTweaksPlaceholder }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Opcao invalida no modulo Tweaks.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Show-STZDiagnosticsMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Diagnostics' -Subtitle 'Telemetria basica de hardware.'
        Write-STZMenuOption -Key '1' -Label 'Relatorio de Hardware (CPU/RAM/GPU)'
        Write-STZMenuOption -Key '2' -Label 'Voltar'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZHardwareReport }
            '2' { return }
            default {
                Show-STZFriendlyError -Message 'Opcao invalida no modulo Diagnostics.'
                Start-Sleep -Seconds 2
            }
        }
    }
}

function Start-STZSOS {
    Show-STZLoading -Text 'Inicializando modulos do terminal'
    Show-STZAdministratorNotice
    Start-Sleep -Milliseconds 700
    Show-STZMainMenu
}
