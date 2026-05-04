# Operator Daily Launcher Protocol

> Framework Version: 8.2.0
> Scope: Provide low-friction operator entry points for daily work, validation, release preparation, and first install.

## Purpose

The operator daily launcher turns common operator intentions into compact, auditable command paths:

- start today's work;
- validate before closing or handing off;
- prepare release validation;
- install HEPHAESTUS into a project through a Windows-friendly launcher.

It does not replace the underlying tools. It routes to existing validation, gate, and install scripts while preserving dry-run-first behavior.

## Daily Modes

### start

Runs a compact core-contract check and prints the smallest useful documentation pointers for the operator.

### validate

Runs framework integrity validation and documentation parity.

### release

Runs the pre-release gate for the requested or manifest-detected version.

## Installer Launcher

The Windows launcher is:

```text
.agents/tools/install-hephaestus.bat
```

It calls:

```text
.agents/tools/install-hephaestus-launcher.ps1
```

The launcher asks for a target project folder when not supplied, keeps dry-run as the default unless the operator explicitly types `YES`, and creates `HEPHAESTUS-FIRST-CALL.md` after Apply.

## Safety Rules

- The launcher must not delete target files.
- Install remains dry-run unless Apply is explicit.
- Existing `.agents` targets must use update instead of install.
- Generated first-call documentation is operator-facing and project-local.
- No network access is required.

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode start
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode validate
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode release -Version 8.2.0
```

```bat
.agents\tools\install-hephaestus.bat C:\Project\Target
```
