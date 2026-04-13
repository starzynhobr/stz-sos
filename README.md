# STZ SOS

STZ SOS is a modular PowerShell terminal utility for quick Windows maintenance, network recovery, diagnostics, and future support routines, with the original neon/premium terminal identity preserved.

## Structure

```text
stz-sos/
├── README.md
├── bootstrap.ps1
├── core/
│   ├── helpers.ps1
│   └── ui.ps1
└── modules/
    ├── devices.ps1
    ├── network.ps1
    ├── printing.ps1
    ├── system.ps1
    └── tweaks.ps1
```

## Run Locally

```powershell
powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
```

## Remote Usage Idea

```powershell
irm stzlabs.com/sos | iex
```

The bootstrap is prepared to work as the entry point for both local and remote execution flows.

## Notes

- Some routines may require running PowerShell as Administrator.
- For security, review remote scripts before executing them in your environment.
