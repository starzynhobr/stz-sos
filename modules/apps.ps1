function Get-STZAppsCatalog {
    return @(
        [pscustomobject]@{ DisplayName = 'Google Chrome'; PackageId = 'Google.Chrome'; Category = 'Browsers'; Description = 'Installs Google Chrome via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Mozilla Firefox'; PackageId = 'Mozilla.Firefox'; Category = 'Browsers'; Description = 'Installs Mozilla Firefox via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Brave'; PackageId = 'Brave.Brave'; Category = 'Browsers'; Description = 'Installs Brave Browser via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Zen Browser'; PackageId = 'Zen-Team.Zen-Browser'; Category = 'Browsers'; Description = 'Installs Zen Browser via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Floorp Browser'; PackageId = 'Ablaze.Floorp'; Category = 'Browsers'; Description = 'Installs Floorp Browser via WinGet.'; RequiresAdmin = $false }

        [pscustomobject]@{ DisplayName = '7-Zip'; PackageId = '7zip.7zip'; Category = 'Utilities'; Description = 'Installs 7-Zip via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'NanaZip'; PackageId = 'M2Team.NanaZip'; Category = 'Utilities'; Description = 'Installs NanaZip via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'PowerToys'; PackageId = 'Microsoft.PowerToys'; Category = 'Utilities'; Description = 'Installs Microsoft PowerToys via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Notepad++'; PackageId = 'Notepad++.Notepad++'; Category = 'Utilities'; Description = 'Installs Notepad++ via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Lightshot'; PackageId = 'Skillbrains.Lightshot'; Category = 'Utilities'; Description = 'Installs Lightshot via WinGet.'; RequiresAdmin = $false }

        [pscustomobject]@{ DisplayName = 'Visual Studio Code'; PackageId = 'Microsoft.VisualStudioCode'; Category = 'Dev'; Description = 'Installs Visual Studio Code via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Git'; PackageId = 'Git.Git'; Category = 'Dev'; Description = 'Installs Git via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'GitHub Desktop'; PackageId = 'GitHub.GitHubDesktop'; Category = 'Dev'; Description = 'Installs GitHub Desktop via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Python'; PackageId = 'Python.Python.3.12'; Category = 'Dev'; Description = 'Installs Python via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Node.js'; PackageId = 'OpenJS.NodeJS.LTS'; Category = 'Dev'; Description = 'Installs the Node.js LTS runtime via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Docker Desktop'; PackageId = 'Docker.DockerDesktop'; Category = 'Dev'; Description = 'Installs Docker Desktop via WinGet.'; RequiresAdmin = $false }

        [pscustomobject]@{ DisplayName = 'Telegram Desktop'; PackageId = 'Telegram.TelegramDesktop'; Category = 'Communication'; Description = 'Installs Telegram Desktop via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Discord'; PackageId = 'Discord.Discord'; Category = 'Communication'; Description = 'Installs Discord via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Slack'; PackageId = 'SlackTechnologies.Slack'; Category = 'Communication'; Description = 'Installs Slack via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Zoom'; PackageId = 'Zoom.Zoom'; Category = 'Communication'; Description = 'Installs Zoom via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Obsidian'; PackageId = 'Obsidian.Obsidian'; Category = 'Communication'; Description = 'Installs Obsidian via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Notion'; PackageId = 'Notion.Notion'; Category = 'Communication'; Description = 'Installs Notion via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'WhatsApp Desktop'; PackageId = '9NBDXK71NK08'; Category = 'Communication'; Description = 'Installs WhatsApp Desktop via Microsoft Store through WinGet.'; RequiresAdmin = $false }

        [pscustomobject]@{ DisplayName = 'VLC'; PackageId = 'VideoLAN.VLC'; Category = 'Media & Creation'; Description = 'Installs VLC media player via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'OBS Studio'; PackageId = 'OBSProject.OBSStudio'; Category = 'Media & Creation'; Description = 'Installs OBS Studio via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Spotify'; PackageId = 'Spotify.Spotify'; Category = 'Media & Creation'; Description = 'Installs Spotify via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'GIMP'; PackageId = 'GIMP.GIMP'; Category = 'Media & Creation'; Description = 'Installs GIMP via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Krita'; PackageId = 'KDE.Krita'; Category = 'Media & Creation'; Description = 'Installs Krita via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Blender'; PackageId = 'BlenderFoundation.Blender'; Category = 'Media & Creation'; Description = 'Installs Blender via WinGet.'; RequiresAdmin = $false }

        [pscustomobject]@{ DisplayName = 'Steam'; PackageId = 'Valve.Steam'; Category = 'Games & Launchers'; Description = 'Installs Steam via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Ubisoft Connect'; PackageId = 'Ubisoft.Connect'; Category = 'Games & Launchers'; Description = 'Installs Ubisoft Connect via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Epic Games Launcher'; PackageId = 'EpicGames.EpicGamesLauncher'; Category = 'Games & Launchers'; Description = 'Installs Epic Games Launcher via WinGet.'; RequiresAdmin = $false }

        [pscustomobject]@{ DisplayName = 'Java Runtime'; PackageId = 'EclipseAdoptium.Temurin.17.JRE'; Category = 'Runtimes'; Description = 'Installs the Temurin Java Runtime via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Java JDK'; PackageId = 'EclipseAdoptium.Temurin.17.JDK'; Category = 'Runtimes'; Description = 'Installs the Temurin Java JDK via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = 'Visual C++ Redistributables'; PackageId = 'Microsoft.VCRedist.2015+.x64'; Category = 'Runtimes'; Description = 'Installs the Microsoft Visual C++ Redistributable package via WinGet.'; RequiresAdmin = $false }
        [pscustomobject]@{ DisplayName = '.NET Runtimes'; PackageId = 'Microsoft.DotNet.Runtime.8'; Category = 'Runtimes'; Description = 'Installs the Microsoft .NET Runtime via WinGet.'; RequiresAdmin = $false }
    )
}

function ConvertTo-STZAppInstallAction {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$App,

        [Parameter(Mandatory)]
        [int]$Index
    )

    $displayName = $App.DisplayName
    $packageId = $App.PackageId
    $category = $App.Category
    $description = $App.Description
    $requiresAdmin = $App.RequiresAdmin
    $installWingetPackage = ${function:Install-STZWingetPackage}

    $action = New-STZActionDefinition `
        -Key $Index.ToString() `
        -Title $displayName `
        -MenuLabel $displayName `
        -Description $description `
        -RequiresAdmin $requiresAdmin `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage "$displayName installed successfully." `
        -Handler ({
            & $installWingetPackage -PackageId $packageId -DisplayName $displayName
        }.GetNewClosure())

    $action | Add-Member -NotePropertyName 'DisplayName' -NotePropertyValue $displayName -Force
    $action | Add-Member -NotePropertyName 'PackageId' -NotePropertyValue $packageId -Force
    $action | Add-Member -NotePropertyName 'Category' -NotePropertyValue $category -Force
    return $action
}

function Get-STZAppCategoryActions {
    param(
        [Parameter(Mandatory)]
        [string]$Category
    )

    $apps = Get-STZAppsCatalog | Where-Object { $_.Category -eq $Category }
    $actions = @()
    for ($index = 0; $index -lt $apps.Count; $index++) {
        $actions += ConvertTo-STZAppInstallAction -App $apps[$index] -Index ($index + 1)
    }

    return $actions
}

function Get-STZWingetSearchAction {
    return New-STZActionDefinition `
        -Key '1' `
        -Title 'Search Package' `
        -MenuLabel 'Search Package (manual query)' `
        -Description 'Prompts for a term and runs a WinGet package search.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Package search completed successfully.' `
        -Handler {
            Assert-STZWingetAvailability
            $query = (Read-STZPrompt -Prompt 'search> ').Trim()
            if (-not $query) {
                throw 'A search term is required.'
            }

            Invoke-STZWingetCommand -Arguments @('search', $query) -ProgressText 'Searching WinGet packages' -FailureMessage 'Failed to search WinGet packages.'
        }
}

function Get-STZWingetShowPackageAction {
    return New-STZActionDefinition `
        -Key '2' `
        -Title 'Show Package Details' `
        -MenuLabel 'Show Package Details (manual ID)' `
        -Description 'Prompts for a package ID and shows detailed WinGet package metadata.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Package details retrieved successfully.' `
        -Handler {
            Assert-STZWingetAvailability
            $packageId = (Read-STZPrompt -Prompt 'package-id> ').Trim()
            if (-not $packageId) {
                throw 'A package ID is required.'
            }

            Invoke-STZWingetCommand -Arguments @('show', '--id', $packageId, '-e') -ProgressText 'Loading package details' -FailureMessage 'Failed to load package details.'
        }
}

function Get-STZWingetUpgradeAllAction {
    return New-STZActionDefinition `
        -Key '3' `
        -Title 'Upgrade All Packages' `
        -MenuLabel 'Upgrade All Packages' `
        -Description 'Runs a WinGet upgrade across all eligible installed packages.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'WinGet upgrade completed successfully.' `
        -Handler {
            Invoke-STZWingetCommand `
                -Arguments @('upgrade', '--all', '--accept-package-agreements', '--accept-source-agreements') `
                -ProgressText 'Upgrading WinGet packages' `
                -FailureMessage 'Failed to upgrade WinGet packages.'
        }
}

function Get-STZWingetExportAction {
    return New-STZActionDefinition `
        -Key '4' `
        -Title 'Export Winget Package List' `
        -MenuLabel 'Export Winget Package List' `
        -Description 'Exports the current WinGet package list to a JSON file in the temp reports folder.' `
        -RequiresAdmin $false `
        -RebootRecommended $false `
        -RiskLevel 'Low' `
        -SuccessMessage 'Winget package list exported successfully.' `
        -Handler {
            Assert-STZWingetAvailability
            $reportRoot = Join-Path $env:TEMP 'stz-sos\reports'
            if (-not (Test-Path $reportRoot)) {
                New-Item -Path $reportRoot -ItemType Directory -Force | Out-Null
            }

            $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
            $exportPath = Join-Path $reportRoot "winget-export-$timestamp.json"

            Invoke-STZWingetCommand `
                -Arguments @('export', '-o', $exportPath, '--accept-source-agreements') `
                -ProgressText 'Exporting WinGet package list' `
                -FailureMessage 'Failed to export WinGet package list.'

            Write-Host "`n$($script:STZUI.NeonColor) Export Path:$($script:STZUI.TextColor) $exportPath$($script:STZUI.Reset)"
        }
}

function Get-STZWingetToolsActions {
    return @(
        Get-STZWingetSearchAction
        Get-STZWingetShowPackageAction
        Get-STZWingetUpgradeAllAction
        Get-STZWingetExportAction
    )
}

function Show-STZAppCategoryMenu {
    param(
        [Parameter(Mandatory)]
        [string]$Category
    )

    $actions = Get-STZAppCategoryActions -Category $Category
    $backKey = ($actions.Count + 1).ToString()
    Show-STZActionMenu -Title $Category -Subtitle 'Curated WinGet installs with friendly names and exact package IDs.' -Actions $actions -BackKey $backKey
}

function Show-STZWingetToolsMenu {
    $actions = Get-STZWingetToolsActions
    $backKey = ($actions.Count + 1).ToString()
    Show-STZActionMenu -Title 'Winget Tools' -Subtitle 'Manual WinGet search, inspection, upgrade, and export helpers.' -Actions $actions -BackKey $backKey
}

function Show-STZAppsMenu {
    while ($true) {
        Show-STZSectionTitle -Title 'Apps' -Subtitle 'Curated WinGet installs for post-format and setup workflows.'
        Write-STZMenuOption -Key '1' -Label 'Browsers'
        Write-STZMenuOption -Key '2' -Label 'Utilities'
        Write-STZMenuOption -Key '3' -Label 'Dev'
        Write-STZMenuOption -Key '4' -Label 'Communication'
        Write-STZMenuOption -Key '5' -Label 'Media & Creation'
        Write-STZMenuOption -Key '6' -Label 'Games & Launchers'
        Write-STZMenuOption -Key '7' -Label 'Runtimes'
        Write-STZMenuOption -Key '8' -Label 'Winget Tools'
        Write-STZMenuOption -Key '9' -Label 'Back'
        Write-Host ''

        switch ((Read-STZPrompt).Trim()) {
            '1' { Show-STZAppCategoryMenu -Category 'Browsers' }
            '2' { Show-STZAppCategoryMenu -Category 'Utilities' }
            '3' { Show-STZAppCategoryMenu -Category 'Dev' }
            '4' { Show-STZAppCategoryMenu -Category 'Communication' }
            '5' { Show-STZAppCategoryMenu -Category 'Media & Creation' }
            '6' { Show-STZAppCategoryMenu -Category 'Games & Launchers' }
            '7' { Show-STZAppCategoryMenu -Category 'Runtimes' }
            '8' { Show-STZWingetToolsMenu }
            '9' { return }
            default {
                Show-STZFriendlyError -Message 'Invalid option in Apps.'
                Start-Sleep -Seconds 2
            }
        }
    }
}
