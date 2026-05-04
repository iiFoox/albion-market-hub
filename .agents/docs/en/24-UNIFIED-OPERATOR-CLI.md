# 24 — Unified Operator CLI

> Framework Version: 8.7.0
> When to use: You want one command entry point for install, update, validation, release, package, and diagnostics.

---

## Purpose

The unified CLI wraps the existing HEPHAESTUS tools without changing their safety model.

CLI path:

```text
.agents/tools/hephaestus.ps1
```

## Common Commands

Doctor:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action doctor -Root .
```

Validate:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action validate -Root .
```

Bootstrap:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot .
```

Daily start:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -Root . -DailyMode start
```

Pre-release gate:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action gate -Root . -Version 8.7.0
```

Package:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action package -Root . -Version 8.7.0
```

Release evidence:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action evidence -Root . -Version 8.7.0 -PackagePath HEPHAESTUS-Framework-v8.7.0.zip
```

Install dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot C:\Project\Target
```

Install apply:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot C:\Project\Target -Apply
```

Update dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action update -SourceRoot . -TargetRoot C:\Project\Target
```

Update apply:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action update -SourceRoot . -TargetRoot C:\Project\Target -Apply
```

## Safety Model

- Install and update are dry-run unless `-Apply` is present.
- Update keeps backup behavior by default.
- The CLI does not delete packages or telemetry.
- The CLI does not require network access.
- The daily launcher wraps existing checks and does not bypass release gates.
