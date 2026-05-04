# Real Project Apply Scenario Protocol

> Framework Version: 7.2.0
> Status: Active
> Loading Group: real-apply-scenario

## Purpose

This protocol defines an isolated end-to-end scenario for proving that real-project execution can move from DryRun to controlled Apply without weakening the framework safety model.

The scenario is a validation harness, not a general permission system. It must use a temporary project fixture and leave the framework directory clean.

## Scenario Contract

The scenario must prove:

- project adapter configuration exists;
- pre-Apply quality gate can run through the command allowlist;
- DryRun produces a plan without mutation;
- Apply remains controlled by `execution.mode: "controlled"` and the required approval token;
- backup artifact is created before mutation;
- audit log records DryRun, backup, Apply, and restore events;
- post-Apply quality gate can run through the command allowlist;
- restore command succeeds against the latest backup artifact;
- a compact evidence report is produced.

## Safety Rules

- The scenario must run in a temporary workspace.
- The scenario must copy only the minimum tools needed for execution.
- The fixture must not depend on external network access.
- The scenario must not modify the framework project files except for its own report.
- The scenario must not enable destructive commands.

## Token Policy

The scenario report must stay compact:

- final status;
- gate summaries;
- artifact paths;
- PASS/FAIL table;
- no long command logs unless needed for failure diagnosis.

