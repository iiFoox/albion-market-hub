# 20 — Install and Update Wizard

> Framework Version: 8.0.0
> When to use: Installing HEPHAESTUS into a new project or updating an existing project.
> Safety model: Dry-run first, backup before update, preserve project-local configuration.

---

## What This Wizard Does

This guide turns the install/update tools into a clear operator flow. It does not add a heavy runtime agent. It helps the operator choose the right command, review the dry-run, apply only when intentional, and validate the result.

Use it when:

- a project does not have `.agents/` yet;
- a project already has `.agents/` and needs an update;
- you want to compare versions before copying files;
- you received a framework ZIP and need a safe setup path.

## Step 1: Choose Source and Target

Source root is the folder that contains the current HEPHAESTUS `.agents/`.

Target root is the project that should receive or update HEPHAESTUS.

Example:

```powershell
$source = "C:\Project\SuperAgentsClaudiao"
$target = "C:\Project\MyApp"
```

## Step 2: Compare Versions

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/compare-framework-version.ps1 -SourceRoot $source -TargetRoot $target
```

If the target has no `.agents/`, continue with install.

If the target already has `.agents/`, continue with update.

## Step 3A: New Install

Dry run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/install-framework.ps1 -SourceRoot $source -TargetRoot $target
```

Apply after reviewing the dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/install-framework.ps1 -SourceRoot $source -TargetRoot $target -Apply
```

The installer refuses to install over an existing `.agents/` folder. Use update instead.

## Step 3B: Existing Update

Dry run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/update-framework.ps1 -SourceRoot $source -TargetRoot $target
```

Apply with backup:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/update-framework.ps1 -SourceRoot $source -TargetRoot $target -Apply
```

The updater preserves project-local config and session state by default.

## Step 4: Validate the Target

After install or update, run from the target project:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/validate-framework.ps1 -Root .
```

For full release-level validation, run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/pre-release-gate.ps1 -Root . -Version 8.0.0
```

## What Is Preserved During Update

The updater preserves:

- `.agents/config/project.yaml`
- `.agents/config/multi-project.yaml`
- `.agents/memory/context-db/session-checkpoint.md`
- `.agents/memory/context-db/session-brief.md`
- `.agents/memory/context-db/next-chat-activation-prompt.md`

Use overwrite behavior only when intentionally replacing project-local settings.

## Wizard Prompt for a Host AI

```markdown
Read .agents/protocols/install-update-wizard-protocol.md and .agents/kernel/INSTALL-UPDATE.md.
Guide me through installing or updating HEPHAESTUS.
Start with dry-run, preserve project-local config, and do not apply changes until I approve.
```

## Completion Checklist

- [ ] Source root confirmed.
- [ ] Target root confirmed.
- [ ] Target state identified: new install or update.
- [ ] Compare or dry-run executed.
- [ ] Apply explicitly approved or skipped.
- [ ] Backup behavior preserved for update.
- [ ] Target validation executed.



