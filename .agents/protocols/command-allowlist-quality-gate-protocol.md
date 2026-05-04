# Command Allowlist and Quality Gate Protocol

> Framework Version: 7.1.0
> Status: Active
> Loading Group: quality-gates

## Purpose

This protocol defines how HEPHAESTUS may execute project-local quality gates without turning local command execution into an unsafe or token-heavy behavior.

It is intentionally conservative:

- commands come only from `.agents/config/project.yaml`;
- commands must be explicitly marked `allowed: true`;
- destructive commands are denied even when allowed;
- execution produces a compact report;
- normal framework usage does not load this protocol unless command execution or quality gates are relevant.

## Activation Triggers

Use this protocol when the operator asks to:

- run project tests, lint, build, format, or install commands through the adapter;
- validate a real project before or after a controlled change;
- prove that configured quality gates are executable;
- audit whether project commands are safe to run.

Do not activate it for normal discussion, documentation-only edits, roadmap planning, or requirements discovery unless quality gate execution is explicitly part of the task.

## Command Source

The only supported command source is:

```text
.agents/config/project.yaml
```

The supported command keys are:

- `install`
- `test`
- `lint`
- `build`
- `format`
- `dev`

Each command entry must contain:

```yaml
commands:
  test:
    command: "project test command"
    allowed: true
```

Empty commands are skipped. Commands with `allowed: false` are skipped.

## Safety Rules

The runner must deny commands that match destructive patterns, including:

- recursive deletion;
- force deletion;
- disk formatting;
- shutdown/reboot operations;
- registry deletion;
- destructive git cleanup/reset;
- database/table drop statements.

The denylist is a safety floor, not a complete security sandbox. Operators still control what is allowed in the project adapter, and Apply remains governed by the real-project execution protocols.

## Execution Rules

1. Resolve the project root.
2. Read `.agents/config/project.yaml`.
3. Parse configured adapter commands.
4. Select requested gates, or all allowed gates when no gate list is supplied.
5. Deny unsafe commands before execution.
6. Run allowed commands from the project root.
7. Capture exit code and compact output.
8. Write `.agents/reports/executions/quality-gates-latest.md` when requested.

## Result Semantics

- `PASS`: every selected allowed gate succeeded, or no gates were configured and the run was a no-op.
- `FAIL`: an allowed selected gate failed.
- `DENIED`: a selected command matched the destructive denylist.
- `SKIP`: command was empty, not allowed, or not selected.

Denied commands fail the run.

## Token Policy

The runner should report concise output:

- command names;
- allowed/skipped/denied status;
- exit codes;
- short output excerpts only.

Long command output should not be loaded into normal agent context unless the operator asks for diagnostic detail.

