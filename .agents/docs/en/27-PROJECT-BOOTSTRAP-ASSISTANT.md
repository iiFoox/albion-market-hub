# 27 — Project Bootstrap Assistant

> Framework Version: 8.7.0
> When to use: You installed HEPHAESTUS into a project and want the first safe readiness pass.

## Purpose

The Project Bootstrap Assistant connects first install to the two existing readiness layers:

- Project Discovery for story, use cases, users, rules, costs, legal/IP, MVP, and implementation readiness.
- Real Project Adapter for stack, commands, paths, protected files, execution mode, and quality gates.

It creates a compact report and, optionally, an adapter draft. It does not overwrite active config.

## Command

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot .
```

Direct tool:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-project-bootstrap.ps1 -Root . -TargetRoot . -WriteReport -WriteAdapterDraft
```

## Outputs

- `.agents/reports/adapters/project-bootstrap-latest.md`
- `.agents/reports/adapters/project-adapter-draft.yaml` when draft generation is requested

## Safety

- Starts in analysis-only mode.
- Does not enable commands automatically.
- Does not mutate `.agents/config/project.yaml`.
- Uses detected files only as hints.
- Keeps Discovery as the source for product decisions.
