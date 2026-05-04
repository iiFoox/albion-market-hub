# Operator Runbook and Recovery Guide

> Framework Version: 8.7.0
> Language: English
> Scope: Operator runbook and recovery flow

---

## Purpose

Use this guide when operating HEPHAESTUS day to day, preparing a release, or recovering from a failed validation, gate, package, install, or update.

## Command Map

| Intent | Command |
|---|---|
| Diagnose framework wiring | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action doctor -Root .` |
| Validate manifest and required files | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action validate -Root .` |
| Run pre-release gate | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action gate -Root . -Version 8.7.0` |
| Create release package | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action package -Root . -Version 8.7.0` |
| Build release evidence | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action evidence -Root . -Version 8.7.0 -PackagePath HEPHAESTUS-Framework-v8.7.0.zip` |
| Compare installed framework versions | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action compare -SourceRoot . -TargetRoot <target>` |
| Install into a target project | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot <target>` |
| Update a target project | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action update -SourceRoot . -TargetRoot <target>` |
| Start daily operation | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -Root . -DailyMode start` |
| Bootstrap project readiness | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot <target>` |

## Normal Operation

1. For a new day, run `daily` with `start`.
2. For a new or recently installed project, run `bootstrap`.
3. Before relying on the framework state, run `doctor`.
4. Before release work, run `validate`.
5. For release readiness, run `gate`.
6. After release docs and configs are final, run `package`.
7. Run package gate with `-PackagePath`.
8. Run `evidence` with the final package path.

## Recovery Flow

When a command fails, use this order:

1. Run `doctor` first.
2. Read the failing check name.
3. If the failure is structural, run `validate`.
4. If the failure is documentation drift, run the documentation parity checker.
5. If the failure is release related, re-run `gate` after fixing the specific issue.
6. If the package changed, re-run `package`, package gate, and `evidence`.

## Common Failures

| Failure | First response |
|---|---|
| Missing required file | Restore or create the required file, then run `validate`. |
| Version drift | Align `framework.yaml`, `framework-manifest.yaml`, docs indexes, release note, and changelog. |
| Documentation parity failure | Update both EN and PT-BR docs and `.agents/docs/_translation-map.yaml`. |
| Gate failure | Fix the named checker, then re-run `gate`. |
| Package gate failure | Rebuild the ZIP after all documentation and manifest changes. |
| Evidence failure | Ensure latest reports exist, then re-run `evidence` with the final package path. |
| Install or update uncertainty | Run without `-Apply` first, review the dry-run, then apply only after approval. |

## Safety Rules

- Do not mutate target projects during recovery unless the operator explicitly approves Apply.
- Do not remove files to make validation pass.
- Do not add aspirational config without a checker, runner, protocol, or real enforcement.
- Keep recovery evidence compact.

## Validation

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-operator-runbook.ps1 -Root .
```
