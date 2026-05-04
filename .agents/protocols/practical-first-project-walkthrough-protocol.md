# Practical First Project Walkthrough Protocol

> Framework Version: 8.7.0
> Status: Active
> Scope: First real project walkthrough for new and existing projects

---

## Purpose

This protocol turns first project usage into a concrete operator path.

It exists because installation is not complete until the operator has:

- installed HEPHAESTUS
- completed the first-call handoff
- reviewed repository intent
- run or reviewed bootstrap
- confirmed Discovery and Adapter next steps

## Required Paths

The walkthrough must cover two paths:

- new project
- existing project

## Required Steps

The operator guide must cover:

1. Create or choose a project folder.
2. Run guided install with repository mode.
3. Apply only after reviewing dry-run.
4. Open `HEPHAESTUS-FIRST-CALL.md` or `START-HEPHAESTUS.bat`.
5. Paste the first-call prompt into the AI coding assistant.
6. Run or review `bootstrap`.
7. Review `project-adapter-draft.yaml`.
8. Run Project Discovery before planning implementation.
9. Confirm repository strategy, protected paths, and allowed commands.
10. Start implementation only after adapter and gates are understood.

## Safety Rules

- Do not mutate Git during walkthrough unless the operator explicitly asks later.
- Do not enable adapter commands automatically.
- Do not skip Project Discovery for unclear product ideas.
- Do not treat installation as complete before the first call.

## Enforcement

`.agents/tools/check-first-project-walkthrough.ps1` validates:

- EN/PT-BR walkthrough docs exist
- translation map includes the pair
- framework config points to the protocol, checker, and guides
- Smart Loading has the `first-project-walkthrough` group
- pre-release gate and doctor invoke the checker
- required first project steps are documented

