# Unified Operator CLI Protocol

> Framework Version: 8.7.0
> Purpose: Provide one safe command entry point for common HEPHAESTUS operator actions.

---

## Scope

The unified CLI is a wrapper over existing tools. It does not weaken the safety model of the underlying scripts.

Supported actions:

- `doctor` — run compact operator health checks;
- `validate` — run framework integrity validation;
- `gate` — run the pre-release gate;
- `package` — create a release ZIP;
- `evidence` — generate release evidence;
- `compare` — compare source and target framework versions;
- `install` — install framework into a target project;
- `update` — update framework in a target project;
- `daily` — run intent-based daily start, validation, or release preparation;
- `bootstrap` — run the first project readiness bridge from install to Discovery and Adapter review.

## Safety Rules

- Install and update remain dry-run unless `-Apply` is passed.
- Update keeps backup behavior by default.
- Package creation does not delete older packages.
- Doctor uses compact checks, not the full benchmark suite.
- The CLI must not introduce network access.

## Token Economy Rule

Use this protocol and `.agents/tools/hephaestus.ps1` only when the operator asks for command guidance, daily operation, installation, update, validation, packaging, or release operations.

## Completion Criteria

The CLI is healthy when:

- the script exists;
- the checker validates all supported action strings;
- docs exist in EN/PT-BR;
- Smart Loading has a CLI group;
- the pre-release gate validates the CLI wiring;
- package verification includes the CLI script and release note.
