# Real Project Apply Scenario

> Framework Version: 8.0.0
> Language: English
> Scope: User guide

## Purpose

The Real Project Apply Scenario proves the full controlled execution path in an isolated fixture:

1. run an adapter allowlisted quality gate;
2. generate a DryRun plan;
3. run controlled Apply with the required approval token;
4. verify backup and audit evidence;
5. run the quality gate again;
6. restore from the latest backup artifact.

This does not make real project mutation automatic. It proves that the safety rails work together.

## Run It

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/test-real-project-apply-scenario.ps1 -Root .
```

The latest compact report is written to:

```text
.agents/reports/executions/real-project-apply-scenario-latest.md
```

## What It Validates

- `.agents/config/project.yaml` adapter behavior
- quality gate command allowlist behavior
- DryRun-first execution
- approval token enforcement
- backup-before-mutation behavior
- audit trail creation
- restore command availability

## Token Economy

This scenario is loaded and executed only when validating real-project Apply behavior. Normal work does not load it.







