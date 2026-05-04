# Operational Score Review

> Framework Version: 8.0.0
> Language: English
> Scope: User guide

## Purpose

The Operational Score Review summarizes the framework's release readiness after the v7.x hardening sequence.

It evaluates:

- structural integrity;
- safety enforcement;
- real-project execution readiness;
- documentation continuity;
- release governance;
- token economy;
- residual operational gaps.

## Run It

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-operational-score-review.ps1 -Root . -WriteReport
```

Latest report:

```text
.agents/reports/operational/score-review-latest.md
```

## Meaning

The score is an operational readiness indicator, not a promise that the framework replaces human judgment.



