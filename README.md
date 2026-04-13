# STZ SOS

Modular PowerShell SOS toolkit for Windows maintenance, recovery, diagnostics, quick fixes, and post-format app setup.

## Overview

STZ SOS is a keyboard-first terminal utility built around a modular PowerShell architecture. It keeps a neon-style terminal UI, loads modules through a bootstrap entrypoint, and executes actions through a shared metadata-driven layer with consistent labels, admin gating, and result handling.

## Features / Modules

Top-level menus currently available:

- `System`
- `Network`
- `Devices`
- `Printing`
- `Tweaks`
- `Performance`
- `Diagnostics`
- `Quick Fixes`
- `Apps`

Highlights:

- Shared action model with `Title`, `Description`, `RequiresAdmin`, `RebootRecommended`, `RiskLevel`, and `Handler`
- Standardized execution flow with friendly success/error output and automatic `[admin]` submenu badges
- Local and remote bootstrap loading
- Diagnostics TXT export to `%TEMP%\stz-sos\reports\`
- Curated WinGet app/runtime installation catalog plus WinGet tools

## Project Structure

```text
stz-sos/
├── README.md
├── bootstrap.ps1
├── stz-sos.txt
├── core/
│   ├── helpers.ps1
│   └── ui.ps1
└── modules/
    ├── apps.ps1
    ├── devices.ps1
    ├── diagnostics.ps1
    ├── network.ps1
    ├── performance.ps1
    ├── printing.ps1
    ├── quickfixes.ps1
    ├── system.ps1
    └── tweaks.ps1
```

## Usage

### Local

```powershell
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
```

`bootstrap.ps1` tries to locate the local project root, validates the required `core/*` and `modules/*` files, dot-sources them, and starts `Start-STZSOS`.

### Remote

```powershell
irm cli.stzlabs.com | iex
```

Expected flow:

1. `cli.stzlabs.com` serves the raw `bootstrap.ps1`
2. `bootstrap.ps1` loads the remaining project files from GitHub Raw:
   `https://raw.githubusercontent.com/starzynhobr/stz-sos/main`
3. The app initializes and opens the terminal menu

## Notes

- Some actions require an elevated PowerShell session.
- `Apps` uses WinGet and checks whether `winget` is available before running install/search/upgrade/export actions.
- The repository is intentionally public to keep the remote bootstrap flow simple and auditable.

## Safety

- Review the code before running remote scripts in your environment.
- Prefer launching elevated PowerShell only when you need protected maintenance actions.
