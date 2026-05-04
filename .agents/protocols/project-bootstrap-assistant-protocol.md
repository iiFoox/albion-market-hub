# Project Bootstrap Assistant Protocol

> Framework Version: 8.7.0
> Scope: Bridge first install, Project Discovery, and Real Project Adapter readiness.

## Purpose

The Project Bootstrap Assistant helps a newly installed project become ready for HEPHAESTUS without skipping product discovery or adapter safety.

It does not replace Project Discovery. Discovery remains responsible for product story, use cases, users, rules, costs, legal/IP, MVP, risks, and implementation readiness.

It does not replace the Real Project Adapter. The adapter remains responsible for stack, commands, paths, protected files, execution mode, and quality gates.

## Operating Rules

- Start in analysis-only mode.
- Generate reports and adapter drafts, not active config mutations.
- Never set command `allowed: true` automatically.
- Do not infer product decisions from file structure.
- Use detected files only as hints for adapter review.
- Ask the operator to confirm project direction before implementation planning.

## Tool

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-project-bootstrap.ps1 -Root . -TargetRoot . -WriteReport -WriteAdapterDraft
```

## Output

- `.agents/reports/adapters/project-bootstrap-latest.md`
- optional `.agents/reports/adapters/project-adapter-draft.yaml`

## Readiness Meaning

Bootstrap readiness means the project has enough local structure to continue into Discovery and Adapter review. It does not mean the project is ready for implementation.
