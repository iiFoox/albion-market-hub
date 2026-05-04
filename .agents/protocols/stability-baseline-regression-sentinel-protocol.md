# Stability Baseline and Regression Sentinel Protocol

> Framework Version: 8.7.0
> Scope: Preserve the stable operational surface while the framework evolves.

## Purpose

The regression sentinel verifies that critical framework capabilities remain wired after each release.

It is not a feature catalog. It is a compact release guard for the capabilities operators rely on every day: CLI actions, Discovery, Adapter, Evidence, Daily Launcher, Bootstrap, Memory proof, Documentation runtime, and Core Guard.

## Rules

- Baseline checks must remain compact.
- New active capabilities should have protocol, checker, and documentation before being added to the stable baseline.
- The sentinel checks presence and wiring; behavior-specific tests remain in each feature checker.
- The baseline must not load broad technology catalogs.

## Tool

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-stability-baseline.ps1 -Root .
```

## Output

- `.agents/reports/operational/stability-baseline-latest.md`

Any FAIL result blocks release.
