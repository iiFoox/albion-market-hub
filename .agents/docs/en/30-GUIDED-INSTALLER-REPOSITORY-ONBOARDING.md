# Guided Installer and Repository Onboarding

> Framework Version: 8.7.0
> Language: English
> Scope: Guided install, repository intent, and first-call handoff

---

## Purpose

The guided installer helps operators install HEPHAESTUS into new or existing projects while recording repository intent and making the first call hard to miss.

## Repository Modes

Choose one:

| Mode | Meaning |
|---|---|
| `none` | No repository setup is planned yet. |
| `local` | Local Git repository is intended. |
| `github` | GitHub remote is intended or already exists. |
| `gitlab` | GitLab remote is intended or already exists. |
| `bitbucket` | Bitbucket remote is intended or already exists. |
| `other` | Another remote provider is intended. |
| `existing` | The project already has repository state that must be preserved. |

## Install Flow

1. Choose the target project folder.
2. Choose repository mode.
3. Provide a remote URL when available.
4. Choose the default branch.
5. Run dry-run first.
6. Apply only after reviewing the plan.
7. Open `HEPHAESTUS-FIRST-CALL.md`.
8. Paste the prompt into the AI coding assistant.

## New Projects

For new projects, HEPHAESTUS may recommend Git setup in the first call, but the installer does not run `git init`, add remotes, commit, or push automatically.

## Existing Projects

For existing projects, HEPHAESTUS must treat repository state as owned by the project. The first call should inspect branch, remote, protected paths, and local commands organically before any active config change.

## Generated Files

After Apply install:

- `HEPHAESTUS-FIRST-CALL.md`
- `START-HEPHAESTUS.bat`
- `.agents/reports/operator/repository-setup-latest.md`

## CLI Example

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot C:\Project\MyApp -RepositoryMode github -RemoteUrl https://github.com/example/myapp.git -DefaultBranch main -Apply
```
