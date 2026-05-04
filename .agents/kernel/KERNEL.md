# HEPHAESTUS Kernel Contract

> Framework Version: 8.7.0
> Status: Stable kernel contract
> Purpose: Define the stable core surface of the HEPHAESTUS framework.

---

## Kernel Scope

The kernel is the minimum stable framework surface that must remain compatible across minor releases.

Kernel directories:

- `.agents/agents`
- `.agents/config`
- `.agents/docs`
- `.agents/kernel`
- `.agents/memory`
- `.agents/protocols`
- `.agents/releases`
- `.agents/reports`
- `.agents/tests`
- `.agents/tools`
- `.agents/workflows`

Kernel entry points:

- `.agents/AGENTS.md`
- `.agents/config/framework.yaml`
- `.agents/config/agent-registry.yaml`
- `.agents/config/framework-manifest.yaml`
- `.agents/tools/pre-release-gate.ps1`
- `.agents/releases/CHANGELOG.md`
- `.agents/tools/install-framework.ps1`
- `.agents/tools/update-framework.ps1`

## Stability Rules

Minor releases may:

- add optional tools, protocols, workflows, fixtures, docs, or reports;
- add config keys when a real implementation exists;
- strengthen validation when existing valid packages continue to pass or have a documented migration path;
- add documentation languages if the translation map and parity tooling are updated.

Minor releases must not:

- remove a kernel directory;
- rename a kernel entry point;
- change the meaning of an existing config key without migration guidance;
- require loading all framework files for normal operation;
- add network-dependent validation to the release gate.

Major releases may:

- rename kernel directories;
- remove deprecated entry points;
- change required manifest structure;
- alter compatibility policy;
- revise the core agent contract.

## Operational Guarantees

The kernel guarantees:

- local validation with no network access;
- bilingual documentation parity checks;
- manifest-based package verification;
- measurable loading tiers;
- schema-validated telemetry;
- routing regression fixtures;
- version-aligned release notes and changelog.
- safe dry-run install/update automation.
- operator-guided install/update wizard documentation.
- optional compact memory consultation proof without normal-session token expansion.
- operator intent map and stale entrypoint review.
- compact inter-agent communication bus for handoffs, conflicts, decisions, and correction evidence.
- isolated framework simulation with temporary workspace cleanup.
- controlled developer execution simulation in temporary projects.
- multi-scenario developer benchmark in temporary projects.
- documentation enforcement as a lightweight mandatory checkpoint.
- master-level 30+ years equivalent calibration across all agents.

## Non-Kernel Surface

The following may evolve more freely:

- generated health and loading reports;
- historical release notes;
- archived telemetry;
- project-specific profiles;
- future experimental protocols that are not in the manifest.











