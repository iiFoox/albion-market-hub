# Release Evidence Bundle

> Framework Version: 8.0.0
> Language: English
> Scope: User guide

## Purpose

The Release Evidence Bundle consolidates release proof into one compact report.

It references existing validation outputs instead of copying full command logs.

## Run It

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-release-evidence-bundle.ps1 -Root . -Version 8.0.0 -PackagePath HEPHAESTUS-Framework-v8.0.0.zip -WriteReport
```

Latest report:

```text
.agents/reports/releases/release-evidence-latest.md
```

## Evidence Included

- framework integrity;
- documentation runtime;
- command quality gates;
- real-project execution;
- real-project Apply scenario;
- package presence.

## Token Economy

The bundle keeps evidence path-oriented and summary-oriented. It should not embed full pre-release output.





