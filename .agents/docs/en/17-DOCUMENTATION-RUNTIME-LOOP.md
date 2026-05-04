# Documentation Runtime Loop

> Framework Version: 8.0.0
> Language: English
> Scope: User guide

## Purpose

The Documentation Runtime Loop proves that documentation keeps moving with project changes.

Instead of loading the whole documentation set, the loop receives changed file paths, classifies documentation impact, and writes a compact evidence report.

## Run It

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-documentation-runtime-loop.ps1 -Root . -ChangedFiles src/example.ts -WriteReport
```

Latest report:

```text
.agents/reports/documentation/documentation-runtime-latest.md
```

## Behavior

- Source changes usually require README or feature documentation review.
- API changes require API documentation review.
- Framework config/protocol/workflow changes require complete reference review.
- `not_impacted` is allowed only with an explicit reason.

## Token Economy

The loop uses changed paths and compact policy rules. It does not load broad documentation unless the change requires it.






