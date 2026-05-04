# Operator Runbook and Recovery Protocol

> Framework Version: 8.7.0
> Status: Active
> Scope: Operator runbook and failure recovery guidance

---

## Purpose

This protocol keeps HEPHAESTUS operator recovery practical, compact, and aligned with the real CLI surface.

It exists to answer one question when an operator is blocked:

> What should I run next, and what should I inspect if it fails?

## Principles

- The runbook must describe existing commands only.
- Recovery must start with diagnosis before mutation.
- Install and update paths remain dry-run first.
- Release recovery must preserve evidence and package verification.
- Guidance must stay compact enough to load only when relevant.

## Required Coverage

The operator runbook must cover:

- first install or update
- daily start
- project bootstrap
- framework validation
- pre-release gate
- packaging
- release evidence
- failed gate recovery
- failed package recovery
- failed install or update recovery

## Command Map

The runbook must reference these unified CLI actions:

- `doctor`
- `validate`
- `gate`
- `package`
- `evidence`
- `install`
- `update`
- `daily`
- `bootstrap`

## Recovery Order

When an operation fails:

1. Run `doctor` to identify broad framework drift.
2. Run the smallest relevant checker when the failure points to a specific capability.
3. Fix the missing file, version marker, documentation pair, or config reference.
4. Run `validate`.
5. Re-run `gate`.
6. Re-run `package` and package gate when release artifacts changed.
7. Re-run `evidence` after the final package exists.

## Enforcement

`.agents/tools/check-operator-runbook.ps1` validates:

- runbook documentation exists in EN and PT-BR
- translation map includes the pair
- framework config points to the protocol, checker, and guides
- Smart Loading has the `operator-runbook` group
- the unified CLI and pre-release gate invoke the checker
- required CLI actions and recovery scenarios are present in the docs

## Token Economy

The runbook is a conditional operational guide. It must not be loaded by default in ordinary implementation work.
