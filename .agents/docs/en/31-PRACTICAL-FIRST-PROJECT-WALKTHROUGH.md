# Practical First Project Walkthrough

> Framework Version: 8.7.0
> Language: English
> Scope: First complete project flow after installing HEPHAESTUS

---

## Purpose

Use this guide when starting your first project with HEPHAESTUS. It covers both a new empty project and an existing project that already has files or Git history.

## Path A — New Project

1. Create an empty project folder.
2. Run the guided installer.
3. Choose repository mode: `none`, `local`, `github`, `gitlab`, `bitbucket`, `other`, or `existing`.
4. Review the dry-run.
5. Apply install only after the target folder is correct.
6. Open `HEPHAESTUS-FIRST-CALL.md` or run `START-HEPHAESTUS.bat`.
7. Paste the first-call prompt into Antigravity, Codex, Cursor, VS Code, or another AI coding assistant.
8. Ask HEPHAESTUS to run or review `bootstrap`.
9. Review `.agents/reports/adapters/project-adapter-draft.yaml`.
10. Run Project Discovery for product story, users, use cases, business rules, costs, legal/IP, and readiness.
11. Confirm stack, repository strategy, protected paths, and allowed commands.
12. Start implementation only after the adapter and quality gates are understood.

## Path B — Existing Project

1. Choose the existing project folder.
2. Run the guided installer in dry-run first.
3. If `.git` exists, preserve branch, remote, and history.
4. Apply install only after confirming `.agents` does not already exist.
5. Open `HEPHAESTUS-FIRST-CALL.md` or run `START-HEPHAESTUS.bat`.
6. Paste the first-call prompt into the AI coding assistant.
7. Ask HEPHAESTUS to inspect the existing project organically before changing config.
8. Run or review `bootstrap`.
9. Review adapter draft without copying it into active config yet.
10. Confirm local commands before setting any `allowed: true`.
11. Confirm protected paths before any Apply execution.
12. Use DryRun-first execution for real changes.

## First Call Prompt Use

The installer creates `HEPHAESTUS-FIRST-CALL.md`. Installation is operationally incomplete until that prompt is pasted into the AI coding assistant.

## Repository Setup

Repository setup is guidance-first. The installer records repository intent but does not run `git init`, add remotes, rewrite branches, commit, or push.

## First Useful Commands

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action doctor -Root .
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot .
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action validate -Root .
```

## Ready To Implement Checklist

- `HEPHAESTUS-FIRST-CALL.md` was pasted into the AI assistant.
- Bootstrap report was reviewed.
- Adapter draft was reviewed.
- Project Discovery was completed or explicitly deferred with reason.
- Repository strategy is understood.
- Protected paths are confirmed.
- Allowed commands are confirmed.
- DryRun is used before Apply.

