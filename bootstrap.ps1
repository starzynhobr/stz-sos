$script:STZSOSRemoteBase = 'https://stzlabs.com/sos'
$script:STZSOSProjectRoot = $null

function Get-STZBootstrapRoot {
    if ($script:STZSOSProjectRoot) {
        return $script:STZSOSProjectRoot
    }

    $candidates = @()

    if ($PSScriptRoot) {
        $candidates += $PSScriptRoot
    }

    if ($MyInvocation.MyCommand.Path) {
        $candidates += (Split-Path -Parent $MyInvocation.MyCommand.Path)
    }

    try {
        $candidates += (Get-Location).Path
    }
    catch {
    }

    foreach ($candidate in ($candidates | Where-Object { $_ } | Select-Object -Unique)) {
        if (Test-Path (Join-Path $candidate 'core\ui.ps1')) {
            $script:STZSOSProjectRoot = $candidate
            return $candidate
        }
    }

    return $null
}

function Write-STZBootstrapError {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-Host ''
    Write-Host "[STZ SOS] $Message" -ForegroundColor Red
    Write-Host ''
}

function Resolve-STZDependencies {
    $files = @(
        'core\helpers.ps1',
        'core\ui.ps1',
        'modules\system.ps1',
        'modules\network.ps1',
        'modules\devices.ps1',
        'modules\printing.ps1',
        'modules\tweaks.ps1',
        'modules\performance.ps1',
        'modules\diagnostics.ps1',
        'modules\quickfixes.ps1',
        'modules\apps.ps1'
    )

    $root = Get-STZBootstrapRoot

    if ($root) {
        $localSources = foreach ($file in $files) {
            $fullPath = Join-Path $root $file
            if (-not (Test-Path $fullPath)) {
                throw "Required file is missing: $file"
            }

            [pscustomobject]@{
                Type  = 'Local'
                Value = $fullPath
            }
        }

        return $localSources
    }

    $remoteSources = foreach ($file in $files) {
        $uri = '{0}/{1}' -f $script:STZSOSRemoteBase.TrimEnd('/'), ($file -replace '\\', '/')
        $content = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop

        [pscustomobject]@{
            Type  = 'Remote'
            Value = $content
        }
    }

    return $remoteSources
}

try {
    $sources = Resolve-STZDependencies
    foreach ($source in $sources) {
        if ($source.Type -eq 'Local') {
            . $source.Value
            continue
        }

        . ([scriptblock]::Create($source.Value))
    }
}
catch {
    Write-STZBootstrapError -Message $_.Exception.Message
    return
}

if (-not (Get-Command Start-STZSOS -ErrorAction SilentlyContinue)) {
    Write-STZBootstrapError -Message 'Failed to initialize the main Start-STZSOS function.'
    return
}

Start-STZSOS
