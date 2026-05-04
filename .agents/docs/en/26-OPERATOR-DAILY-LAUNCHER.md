# 26 — Operator Daily Launcher

> Framework Version: 8.7.0
> When to use: You want simple entry points for daily work, validation, release preparation, or first install.

## Purpose

The operator daily launcher maps common intentions to existing safe framework tools.

It keeps the normal safety model: install is dry-run by default, release validation still uses the pre-release gate, and the launcher does not hide the underlying scripts.

## Daily Commands

Start work:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode start
```

Validate before closing:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode validate
```

Prepare release validation:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -DailyMode release -Version 8.7.0
```

## Windows Install Launcher

Run:

```bat
.agents\tools\install-hephaestus.bat C:\Project\Target
```

The launcher asks whether to apply. Anything except `YES` runs dry-run.

When Apply succeeds, it creates:

```text
HEPHAESTUS-FIRST-CALL.md
```

That file contains a ready first prompt for the target project.

## EXE Decision

Do not build an `.exe` yet. A `.bat` launcher is easier to inspect, package, validate, and update. An `.exe` can be considered later only if there is a real distribution need, signing plan, and support policy.
