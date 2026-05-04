# Core Contract Drift Guard Protocol

> Framework Version: 8.1.0
> Scope: Keep the always-loaded framework contract compact, current, and release-validated.

## Purpose

The core contract drift guard prevents `.agents/AGENTS.md` and related core entry points from drifting into stale, oversized, or unenforced content.

`AGENTS.md` is loaded by the Smart Loading core tier, so it must stay compact. Broad technology catalogs, stale protocol references, and mismatched framework versions increase token cost and operator confusion without adding enforcement.

## Activation

Use this protocol during:

- framework release preparation;
- edits to `.agents/AGENTS.md`;
- edits to version metadata in framework config, manifest, or documentation map;
- operator experience, Smart Loading, or core contract cleanup.

## Required Checks

The checker MUST verify:

- version alignment across `framework.yaml`, `framework-manifest.yaml`, `_translation-map.yaml`, and `AGENTS.md`;
- the presence of the active core contract drift guard config;
- the presence of the current inter-agent communication bus reference in `AGENTS.md`;
- the absence of broad always-loaded technology catalog markers in `AGENTS.md`;
- EN/PT-BR documentation map entries for this feature;
- integration into the pre-release gate.

## Token Policy

Do not move broad technology catalogs into core config or `AGENTS.md`.

Use project-local adapter config, active profiles, or conditional knowledge files when stack-specific guidance is needed.

## Tool

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-core-contract.ps1 -Root .
```

## Output Contract

The checker prints tabular PASS/FAIL results and a compact summary line:

```text
Summary: PASS=<n>
```

Any FAIL result blocks release.
