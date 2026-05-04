# Command Allowlist and Quality Gates

> Framework Version: 8.0.0
> Language: English
> Scope: User guide

## Purpose

HEPHAESTUS can run project-local quality gates through `.agents/config/project.yaml`, but only when a command is explicitly allowed.

This keeps real project execution controlled: the framework may validate tests, lint, build, or similar checks without accepting arbitrary command execution as a default behavior.

## Configuration

Commands live in the project adapter:

```yaml
commands:
  test:
    command: "powershell -NoProfile -ExecutionPolicy Bypass -File tests/quality.test.ps1"
    allowed: true
  lint:
    command: ""
    allowed: false
```

Only commands with `allowed: true` and a non-empty `command` are candidates for execution.

## Safety Behavior

The runner denies destructive patterns before execution, including recursive deletion, destructive git reset/clean commands, disk formatting, shutdown commands, registry deletion, and destructive database statements.

This is a guardrail, not a replacement for operator judgment. Keep project commands minimal, predictable, and local to the project.

## Running Gates

Run all allowed gates:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-quality-gates.ps1 -Root . -WriteReport
```

Run selected gates:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-quality-gates.ps1 -Root . -GateNames test,lint -WriteReport
```

The latest compact report is written to:

```text
.agents/reports/executions/quality-gates-latest.md
```

## Token Economy

This capability is loaded only when quality gates or adapter command execution are relevant. Reports stay compact and avoid pulling full command logs into normal context.








