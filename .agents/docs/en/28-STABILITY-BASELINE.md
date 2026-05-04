# 28 — Stability Baseline

> Framework Version: 8.7.0
> When to use: You want to confirm the stable operational surface has not regressed.

## Purpose

The Stability Baseline and Regression Sentinel protects the core capabilities operators rely on after many incremental upgrades.

It checks compact wiring, not full behavior. Feature-specific behavior remains covered by each existing checker.

## Command

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-stability-baseline.ps1 -Root .
```

## What It Checks

- Minimum structural counts.
- Unified CLI action presence.
- Critical capability config markers.
- Required protocol and checker files for critical capabilities.
- Baseline version alignment with the manifest.

## Output

The runner writes:

```text
.agents/reports/operational/stability-baseline-latest.md
```

Any FAIL result blocks release through the pre-release gate.

## Safety

The sentinel does not execute project commands, mutate project files, or require network access.
