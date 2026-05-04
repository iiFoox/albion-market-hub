# Guided Installer and Repository Onboarding Protocol

> Framework Version: 8.7.0
> Status: Active
> Scope: First install, repository readiness, and first-call handoff

---

## Purpose

This protocol makes project onboarding explicit after installing HEPHAESTUS into a target project.

The installer must not only copy `.agents/`; it must guide the operator through repository intent and the required first call.

## Repository Modes

Supported repository modes:

- `none`
- `local`
- `github`
- `gitlab`
- `bitbucket`
- `other`
- `existing`

## Safety Rules

- No `git init` is executed automatically.
- No branch rewrite is executed automatically.
- No remote is added automatically.
- No commit or push is executed automatically.
- Existing projects must be aligned organically in the first call.
- Apply remains explicit.

## First Call Handoff

After Apply install, the launcher must generate:

- `HEPHAESTUS-FIRST-CALL.md`
- `START-HEPHAESTUS.bat`
- `.agents/reports/operator/repository-setup-latest.md`

The terminal must show the next required step so the operator does not forget to paste the first-call prompt into the AI coding assistant.

## Enforcement

`.agents/tools/check-guided-installer.ps1` validates:

- repository modes are present in the Windows launcher and PowerShell launcher
- first-call prompt generation exists
- first-call launcher generation exists
- repository setup report generation exists
- Git mutation is explicitly avoided
- unified CLI exposes repository onboarding parameters
- docs, protocol, config, loading group, and gate integration are present
