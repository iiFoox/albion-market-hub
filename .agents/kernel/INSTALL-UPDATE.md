# Install and Update Automation

> Framework Version: 8.7.0
> Purpose: Safely install or update HEPHAESTUS across local projects.

---

## Safety Model

Installation and update tools are conservative by default:

- `install-framework.ps1` uses dry-run mode unless `-Apply` is passed.
- `update-framework.ps1` uses dry-run mode unless `-Apply` is passed.
- updates create a backup ZIP by default;
- project-specific config and session context are preserved by default;
- no network access is required.

## Operator Wizard

For a step-by-step operator flow, use:

- `.agents/docs/en/20-INSTALL-UPDATE-WIZARD.md`
- `.agents/docs/pt-br/20-WIZARD-DE-INSTALACAO-E-UPDATE.md`
- `.agents/protocols/install-update-wizard-protocol.md`

## Compare Versions

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/compare-framework-version.ps1 -SourceRoot . -TargetRoot C:\Path\To\Project
```

## Install Into a New Project

Dry run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/install-framework.ps1 -SourceRoot . -TargetRoot C:\Path\To\Project
```

Apply:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/install-framework.ps1 -SourceRoot . -TargetRoot C:\Path\To\Project -Apply
```

## Update an Existing Project

Dry run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/update-framework.ps1 -SourceRoot . -TargetRoot C:\Path\To\Project
```

Apply with backup:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/update-framework.ps1 -SourceRoot . -TargetRoot C:\Path\To\Project -Apply
```

## Preserved By Default

The updater preserves:

- `.agents/config/project.yaml`
- `.agents/config/multi-project.yaml`
- `.agents/memory/context-db/session-checkpoint.md`
- `.agents/memory/context-db/session-brief.md`
- `.agents/memory/context-db/next-chat-activation-prompt.md`

Use `-OverwriteProjectConfig` only when intentionally replacing project-local settings.











