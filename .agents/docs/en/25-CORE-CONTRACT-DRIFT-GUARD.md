# 25 — Core Contract Drift Guard

> Framework Version: 8.7.0
> When to use: You changed the framework core contract, version metadata, Smart Loading core, or release entry points.

## Purpose

The core contract drift guard keeps the always-loaded framework contract compact and current.

It protects `AGENTS.md` from accumulating broad technology catalogs, stale protocol references, or version drift that would increase normal-session token cost.

## Command

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-core-contract.ps1 -Root .
```

## What It Checks

- Version alignment across core metadata.
- Current communication bus reference in `AGENTS.md`.
- Core drift guard registration in active config.
- Absence of broad technology catalog markers in `AGENTS.md`.
- Documentation map entries for this guide and its PT-BR pair.
- Pre-release gate integration.

## Release Use

The pre-release gate runs this check automatically. Operators can also run it directly before release work when `AGENTS.md` or version metadata changed.

## Safety Model

This guard does not execute project commands, mutate project code, or require network access. It only reads framework files and reports drift.
