# HEPHAESTUS Framework — Release History

> Purpose: Consolidated history of framework releases and documentation changes.
> Current version: 8.7.0
> Operational language: English
> User communication: Portuguese (pt-BR)

---

## v8.7.0 — Practical First Project Walkthrough

Release note: [v8.7.0.md](v8.7.0.md)

### What Changed

- Added practical first project walkthrough guides in EN and PT-BR.
- Added a walkthrough protocol and checker.
- Covered new project and existing project first-use paths.
- Made first-call, bootstrap, adapter draft, Project Discovery, repository strategy, protected paths, allowed commands, and DryRun readiness explicit.

### Why It Matters

v8.7.0 reduces first-use uncertainty: the operator now has a concrete path from install to first real implementation without skipping safety, discovery, or adapter alignment.

---

## v8.6.0 — Guided Installer and Repository Onboarding

Release note: [v8.6.0.md](v8.6.0.md)

### What Changed

- Added guided repository mode prompts to the installer.
- Added repository onboarding options to the unified CLI install action.
- Added first-call handoff generation with `HEPHAESTUS-FIRST-CALL.md` and `START-HEPHAESTUS.bat`.
- Added repository setup report generation.
- Added checker, protocol, Smart Loading group, and EN/PT-BR guides.

### Why It Matters

v8.6.0 makes installation harder to forget halfway: the framework now records whether the project is local, GitHub, another remote, existing, or no repository yet, then guides the operator into the first AI call without mutating Git automatically.

---

## v8.5.0 — Operator Runbook and Recovery Guide

Release note: [v8.5.0.md](v8.5.0.md)

### What Changed

- Added operator runbook and recovery protocol.
- Added EN/PT-BR runbook guides for daily operation and failed validation, gate, package, install, and update recovery.
- Added `check-operator-runbook.ps1`.
- Integrated runbook validation into `doctor`, pre-release gate, Smart Loading, and stability baseline.

### Why It Matters

v8.5.0 makes the framework easier to operate when something fails: the operator gets a validated, compact path from diagnosis to package and evidence recovery.

---

## v8.4.0 — Stability Baseline and Regression Sentinel

Release note: [v8.4.0.md](v8.4.0.md)

### What Changed

- Added compact stability baseline config.
- Added regression sentinel runner and checker.
- Added a stability baseline report template and generated latest report.
- Added critical capability wiring checks for CLI, Discovery, Adapter, Evidence, Daily, Bootstrap, Memory, Documentation, and Core Guard.
- Integrated stability baseline validation into release evidence and the pre-release gate.

### Why It Matters

v8.4.0 turns the current stable operational surface into an explicit regression baseline, reducing the risk that future upgrades silently disconnect critical capabilities.

---

## v8.3.0 — Project Bootstrap Assistant

Release note: [v8.3.0.md](v8.3.0.md)

### What Changed

- Added an analysis-only project bootstrap runner.
- Added a Discovery-to-Adapter bridge report.
- Added optional adapter draft generation under reports, without mutating active config.
- Added the unified CLI `bootstrap` action.
- Added project bootstrap protocol, checker, template, and EN/PT-BR guides.

### Why It Matters

v8.3.0 closes the gap after first install: it helps the operator move from "framework copied into the project" to "project ready for Discovery and Adapter review" without inventing commands or bypassing product maturation.

---

## v8.2.0 — Operator Daily Launcher and First-Call Installer

Release note: [v8.2.0.md](v8.2.0.md)

### What Changed

- Added an intent-based daily launcher for `start`, `validate`, and `release` operator modes.
- Added the unified CLI `daily` action.
- Added a Windows `.bat` install launcher that wraps the existing safe PowerShell installer.
- Added first-call prompt generation after Apply installs.
- Added operator daily launcher protocol, checker, and EN/PT-BR guides.

### Why It Matters

v8.2.0 reduces daily operator friction without weakening the existing safety model: install remains dry-run unless explicitly applied, release still uses the pre-release gate, and the new launcher remains transparent and script-based.

---

## v8.1.0 — Core Contract Alignment and Drift Guard

Release note: [v8.1.0.md](v8.1.0.md)

### What Changed

- Compacted `.agents/AGENTS.md` by replacing broad always-loaded technology catalogs with a concise universality contract.
- Updated the master contract to reference the current inter-agent communication bus.
- Added a core contract drift guard protocol, checker, and EN/PT-BR guides.
- Integrated core contract validation into Smart Loading, manifest validation, doctor, and pre-release gate.

### Why It Matters

v8.1.0 protects the always-loaded framework core from stale references, version drift, and token-heavy catalog creep while keeping project-specific stack rules in adapters, profiles, or conditional knowledge.

---

## v8.0.0 — Unified Operator CLI and Doctor

Release note: [v8.0.0.md](v8.0.0.md)

### What Changed

- Added `.agents/tools/hephaestus.ps1` as a unified operator CLI.
- Added CLI actions for `doctor`, `validate`, `gate`, `package`, `evidence`, `compare`, `install`, and `update`.
- Added unified CLI protocol, checker, and EN/PT-BR guides.
- Integrated CLI validation into Smart Loading, manifest validation, and pre-release gate.

### Why It Matters

v8.0.0 gives operators one safe command surface for common framework operations while preserving dry-run-first install/update behavior and existing release safety gates.

---

## v7.9.0 — Real Inter-Agent Communication Bus

Release note: [v7.9.0.md](v7.9.0.md)

### What Changed

- Added compact inter-agent communication bus protocol and config.
- Added communication bus proof runner, checker, report template, and reports folder.
- Added EN/PT-BR communication bus guides.
- Integrated communication bus checks into Smart Loading, telemetry schema, release evidence, and pre-release gate.
- Added auditable message types for handoff, consultation, broadcast, alert, conflict, decision, and correction.

### Why It Matters

v7.9.0 closes the long-standing communication gap by giving agent coordination a real, compact, auditable message contract without storing full transcripts or expanding normal-session loading.

---

## v7.8.0 — Final Operator Experience Review

Release note: [v7.8.0.md](v7.8.0.md)

### What Changed

- Added final operator experience review protocol.
- Added EN/PT-BR operator experience maps organized by operator intent.
- Updated ready prompts from stale v4/v5 references to v7.8.0.
- Updated legacy bridge READMEs from v7.0.0 to current official documentation pointers.
- Added operator experience runner, checker, report template, and release gate integration.

### Why It Matters

v7.8.0 makes the framework easier to operate by turning the documentation set into an intent-based map while preserving the existing low-token loading model.

---

## v7.7.0 — Optional Telemetry and Memory Proof

Release note: [v7.7.0.md](v7.7.0.md)

### What Changed

- Added optional telemetry and memory proof protocol.
- Added compact memory proof runner, checker, report template, and reports folder.
- Added telemetry schema support for `memory-proof` evidence.
- Added optional memory proof policy to the memory policy config.
- Integrated memory proof into Smart Loading, release evidence, and the pre-release gate.

### Why It Matters

v7.7.0 gives the framework auditable proof that memory consultation is wired correctly while keeping normal sessions lean and avoiding mandatory telemetry expansion.

---

## v7.6.0 — Install and Update Wizard

Release note: [v7.6.0.md](v7.6.0.md)

### What Changed

- Added install/update wizard protocol for operator-guided setup.
- Added EN/PT-BR wizard guides with compare, dry-run, Apply, backup, preservation, and validation steps.
- Added a lightweight install/update wizard checker and pre-release gate integration.
- Added Smart Loading group for install/update wizard context.
- Updated Getting Started docs to distinguish framework install/update from project onboarding.

### Why It Matters

v7.6.0 turns the existing safe install/update tools into a clear operator experience without changing the low-token normal workflow or weakening the dry-run-first safety model.

---

## v7.5.0 — Operational Polish and Score Review

Release note: [v7.5.0.md](v7.5.0.md)

### What Changed

- Added operational score review protocol, runner, checker, reports folder, and report template.
- Added score rubric for structure, safety, real-project readiness, documentation, release governance, token economy, and residual gaps.
- Added residual risk review and token economy snapshot.
- Added EN/PT-BR user guides for operational score review.
- Integrated operational score review into the pre-release gate.

### Why It Matters

v7.5.0 closes the hardening sequence with a compact, repeatable way to explain the framework's current level, remaining risks, and token impact.

---

## v7.4.0 — Release Evidence Bundle

Release note: [v7.4.0.md](v7.4.0.md)

### What Changed

- Added release evidence protocol, runner, checker, fixture test, reports folder, and report template.
- Added compact release evidence report for framework, docs, quality gates, scenarios, and package presence.
- Added EN/PT-BR user guides for release evidence.
- Integrated release evidence checks into Smart Loading, manifest validation, and pre-release gate.

### Why It Matters

v7.4.0 gives each release a compact audit index instead of scattering proof across separate gate outputs and reports.

---

## v7.3.0 — Documentation Agent Runtime Loop

Release note: [v7.3.0.md](v7.3.0.md)

### What Changed

- Added documentation runtime loop protocol, runner, checker, fixture test, and report template.
- Added changed-path documentation impact classification with compact evidence.
- Added explicit rejection for `not_impacted` without a reason.
- Added EN/PT-BR user guides for the documentation runtime loop.
- Integrated documentation runtime checks into the pre-release gate and Smart Loading.

### Why It Matters

v7.3.0 proves that documentation can move alongside project changes at runtime without loading the full documentation corpus or increasing normal token usage.

---

## v7.2.0 — Real Project Apply Scenario

Release note: [v7.2.0.md](v7.2.0.md)

### What Changed

- Added isolated real-project Apply scenario protocol, checker, report template, and fixture test.
- Added before/after quality gate validation around controlled Apply.
- Added compact evidence report for DryRun, Apply, backup, audit, restore, and quality gates.
- Integrated the scenario into Smart Loading, manifest validation, and the pre-release gate.
- Updated bilingual documentation and complete references for `7.2.0`.

### Why It Matters

v7.2.0 proves the real-project execution chain end to end without mutating the framework project or making Apply permissive.

---

## v7.1.0 — Command Allowlist and Quality Gate Runner

Release note: [v7.1.0.md](v7.1.0.md)

### What Changed

- Added command allowlist protocol, runner, report template, checker, and fixture test.
- Added destructive command denial for adapter-configured quality gates.
- Added EN/PT-BR user guides for quality gate execution.
- Integrated command allowlist validation into the pre-release gate and Smart Loading.
- Updated framework metadata and references for `7.1.0`.

### Why It Matters

v7.1.0 lets HEPHAESTUS validate real projects through explicit, safe adapter commands without weakening the token economy or making local command execution permissive.

---

## v7.0.0 — Real Project Execution Hardening

Release note: [v7.0.0.md](v7.0.0.md)

### What Changed

- Added hardening protocol, report template, validator, and pre-release gate integration.
- Added backup artifact, audit trail, restore latest backup, and protected-path override checks to real-project execution.
- Expanded real-project execution tests with an isolated controlled Apply fixture.
- Updated framework metadata and complete references for `7.0.0`.

### Why It Matters

v7.0.0 turns real-project execution from a DryRun-only safety layer into a hardened, reversible, auditable controlled Apply path while keeping Apply blocked by default.

---

## v6.9.0 — Benchmark Expansion

Release note: [v6.9.0.md](v6.9.0.md)

### What Changed

- Expanded developer benchmark from 4 to 10 scenarios.
- Added API, database migration, refactor, security fix, failing tests, and docs-only release scenarios.
- Added scenario presence validation to the benchmark test.
- Added explicit `benchmark_scenarios` config.
- Updated framework metadata, roadmap, and complete references for `6.9.0`.

### Why It Matters

v6.9.0 makes the framework prove repeatability across more realistic work types while keeping benchmark execution isolated and token-neutral for normal usage.

---

## v6.8.0 — Developer Execution on Real Local Project

Release note: [v6.8.0.md](v6.8.0.md)

### What Changed

- Added DryRun-first real-project execution protocol, workflow, tools, report template, docs, and validators.
- Added `real_project_execution` to active framework config.
- Added conditional Smart Loading group for real execution.
- Added pre-release validation and tests for blocked Apply and DryRun reports.
- Updated framework metadata, manifest counts, roadmap, and complete references for `6.8.0`.

### Why It Matters

v6.8.0 lets HEPHAESTUS prepare controlled work in real local projects without sacrificing safety: plan first, backup required, approval required, protected paths checked, and Apply blocked by default.

---

## v6.7.0 — Real Project Adapter

Release note: [v6.7.0.md](v6.7.0.md)

### What Changed

- Expanded `.agents/config/project.yaml` into a real project adapter contract.
- Added Real Project Adapter protocol, workflow, report template, docs, and validator.
- Added conditional Smart Loading group for adapter work.
- Added pre-release validation for real-project adapter readiness.
- Updated framework metadata, manifest counts, roadmap, and complete references for `6.7.0`.

### Why It Matters

v6.7.0 lets HEPHAESTUS understand real repositories through explicit local rules before planning execution, running commands, or touching project files.

---

## v6.6.0 — Project Discovery and Requirements Maturation

Release note: [v6.6.0.md](v6.6.0.md)

### What Changed

- Added Project Discovery protocol, policy, workflow, report templates, and validator.
- Added conditional Smart Loading group for discovery work.
- Added EN/PT-BR user guides for project discovery.
- Added pre-release validation for discovery readiness.
- Updated framework metadata, manifest counts, roadmap, and complete references for `6.6.0`.

### Why It Matters

v6.6.0 prevents shallow project starts by making the framework question, mature, document, and confirm product direction before implementation planning.

---

## v6.5.0 — Documentation Enforcement and Mastery Calibration

Release note: [v6.5.0.md](v6.5.0.md)

### What Changed

- Added documentation enforcement protocol, policy, report template, and validator.
- Set Documentation as always active and mandatory in the agent registry pipeline.
- Added agent mastery validation to the pre-release gate.
- Calibrated all agents to Master-level / 30+ years equivalent expertise.
- Updated kernel, framework config, references, and bilingual docs for `6.5.0`.

### Why It Matters

v6.5.0 makes documentation continuity enforceable and upgrades agent behavior expectations without increasing normal token consumption.

---

## v6.4.0 — Multi-Scenario Developer Benchmark

Release note: [v6.4.0.md](v6.4.0.md)

### What Changed

- Added `.agents/tools/run-developer-benchmark.ps1`.
- Added `.agents/tools/test-developer-benchmark.ps1`.
- Added generated benchmark report support.
- Updated framework metadata to `6.4.0`.
- Added benchmark validation to the pre-release gate.
- Updated telemetry schema to recognize developer benchmark reports.

### Why It Matters

v6.4.0 tests developer execution repeatability across multiple controlled work types instead of proving only one happy path.

---

## v6.3.0 — Developer Execution Mode Simulation

Release note: [v6.3.0.md](v6.3.0.md)

### What Changed

- Added `.agents/tools/run-developer-execution-simulation.ps1`.
- Added `.agents/tools/test-developer-execution-mode.ps1`.
- Added `.agents/reports/executions/README.md`.
- Updated framework metadata to `6.3.0`.
- Added controlled developer execution validation to the pre-release gate.
- Updated telemetry schema to recognize developer execution reports.

### Why It Matters

v6.3.0 gives HEPHAESTUS its first controlled developer-execution loop: create a mini project, implement a small feature, run tests, validate the framework, and report the delivery without touching the real project.

---

## v6.2.0 — Isolated Simulation Harness

Release note: [v6.2.0.md](v6.2.0.md)

### What Changed

- Added `.agents/tools/run-framework-simulation.ps1`.
- Added `.agents/tools/test-simulation-harness.ps1`.
- Added `.agents/reports/simulations/README.md`.
- Updated framework metadata to `6.2.0`.
- Added simulation harness validation to the pre-release gate.
- Updated telemetry schema to recognize simulation reports.

### Why It Matters

v6.2.0 lets the framework test itself in a disposable project workspace. This gives us a clean way to observe routing, loading, installation, and release gates without leaving simulated project files inside the framework.

---

## v6.1.0 — Safe Install and Update Automation

Release note: [v6.1.0.md](v6.1.0.md)

### What Changed

- Added `.agents/tools/compare-framework-version.ps1`.
- Added `.agents/tools/install-framework.ps1`.
- Added `.agents/tools/update-framework.ps1`.
- Added `.agents/tools/test-installation-tools.ps1`.
- Added `.agents/kernel/INSTALL-UPDATE.md`.
- Updated framework metadata to `6.1.0`.
- Added installation tooling validation to the pre-release gate.

### Why It Matters

v6.1.0 makes HEPHAESTUS portable across projects with a conservative safety model: dry-run first, backup before update, and project-local configuration preserved by default.

---

## v6.0.0 — Framework Kernel Stabilization

Release note: [v6.0.0.md](v6.0.0.md)

### What Changed

- Added `.agents/kernel/KERNEL.md`.
- Added `.agents/kernel/COMPATIBILITY.md`.
- Added `.agents/kernel/MIGRATION-v5-to-v6.md`.
- Added `.agents/kernel/HOST-MATRIX.md`.
- Added `.agents/tools/check-kernel-contract.ps1`.
- Updated framework metadata to `6.0.0`.
- Added kernel validation to the pre-release gate.

### Why It Matters

v6.0.0 turns the hardened 5.x framework into a stable kernel contract. Future 6.x releases now have clear compatibility rules, migration expectations, supported host requirements, and locally verifiable kernel boundaries.

---

## v5.8.0 — Practical Enforcement Layer

Release note: [v5.8.0.md](v5.8.0.md)

### What Changed

- Added `.agents/tools/pre-release-gate.ps1`.
- Added `.agents/tools/cleanup-telemetry.ps1`.
- Added `.agents/releases/PACKAGE-CHECKLIST.md`.
- Updated framework metadata to `5.8.0`.
- Added enforceable release governance paths to active config.
- Added v5.8.0 tooling and checklist to the integrity manifest.

### Why It Matters

v5.8.0 turns validation into an operational gate. The framework can now validate itself with one command before release and verify that a generated ZIP contains every manifest-required file.

---

## v5.7.0 — Documentation Source of Truth and Reference Generation

Release note: [v5.7.0.md](v5.7.0.md)

### What Changed

- Added `.agents/docs/_translation-map.yaml`.
- Added `.agents/docs/_source/README.md`.
- Added `.agents/tools/check-doc-parity.ps1`.
- Updated framework metadata to `5.7.0`.
- Added documentation parity files to the integrity manifest.

### Why It Matters

v5.7.0 prevents bilingual documentation drift. The framework can now verify that EN/PT-BR docs stay paired, visible, and aligned with the current version and key reference counts.

---

## v5.6.0 — Agent Contract Tests

Release note: [v5.6.0.md](v5.6.0.md)

### What Changed

- Added `.agents/tests/fixtures/` with canonical routing fixtures.
- Added `.agents/tests/expected-routing/README.md`.
- Added `.agents/tools/test-routing.ps1`.
- Updated framework metadata to `5.6.0`.
- Added test paths and runner to the integrity manifest.

### Why It Matters

v5.6.0 gives the framework a regression harness for routing expectations. It helps keep complexity classification, workflow selection, and agent activation from drifting silently as the framework evolves.

---

## v5.5.0 — Telemetry Schema and Health Score

Release note: [v5.5.0.md](v5.5.0.md)

### What Changed

- Added `.agents/config/telemetry-schema.yaml`.
- Added `.agents/tools/validate-telemetry.ps1`.
- Added `.agents/tools/framework-health.ps1`.
- Added `.agents/reports/health/README.md`.
- Updated framework metadata to `5.5.0`.
- Added telemetry schema and health report paths to active config.

### Why It Matters

v5.5.0 gives HEPHAESTUS a local health signal. The framework can now validate its structure, inspect telemetry quality, estimate loading cost, and summarize health without relying on external services.

---

## v5.4.0 — Memory Contract and Session State

Release note: [v5.4.0.md](v5.4.0.md)

### What Changed

- Added `.agents/protocols/memory-consultation-protocol.md`.
- Added `.agents/config/memory-policy.yaml`.
- Added memory templates for:
  - decisions;
  - learnings;
  - risks;
  - project state;
  - next actions.
- Updated framework metadata to `5.4.0`.
- Updated expected protocol count to `14`.
- Updated `ROADMAP.md` to reflect v5.x sequencing.

### Why It Matters

v5.4.0 makes memory useful in a controlled way. Agents now have a clear rule for when to consult memory, how much memory to load, and when to write durable learnings back.

---

## v5.3.0 — Smart Loading Manifest

Release note: [v5.3.0.md](v5.3.0.md)

### What Changed

- Added `.agents/config/loading-tiers.yaml`.
- Added `.agents/tools/estimate-loading.ps1`.
- Added `.agents/reports/loading/README.md`.
- Updated `smart-loading-protocol.md` to use the manifest as the auditable source of truth.
- Updated framework metadata to `5.3.0`.

### Why It Matters

v5.3.0 protects token economy by making loading tiers measurable. The framework can now estimate how much context a tier costs before expanding what gets loaded.

### Validation

- Integrity validation through `.agents/tools/validate-framework.ps1`.
- Tier estimation through `.agents/tools/estimate-loading.ps1`.

---

## v5.2.0 — Integrity and Version Alignment

Release note: [v5.2.0.md](v5.2.0.md)

### What Changed

- Added `.agents/config/framework-manifest.yaml`.
- Added `.agents/tools/validate-framework.ps1`.
- Updated active framework version metadata to `5.2.0`.
- Updated `agent-registry.yaml` to `5.2.0`.
- Added compact Context DB templates:
  - `session-checkpoint.md`
  - `session-brief.md`
  - `next-chat-activation-prompt.md`
- Updated `health-dashboard.md` expected version and protocol count.
- Fixed stale references in `AGENTS.md`, `smart-loading-protocol.md`, and `GETTING_STARTED.md`.

### Why It Matters

v5.2.0 makes HEPHAESTUS locally verifiable. This reduces framework drift without increasing normal prompt/token cost.

### Validation

- Required files and directories are checked through the manifest.
- Agent contracts are checked for `AGENT.md` and `capabilities.yaml`.
- Local Markdown links are validated.
- Missing `.agents/...` references are reported as warnings by default.

---

## v5.1.0 — Bilingual Documentation Structure

Release note: [v5.1.0.md](v5.1.0.md)

### What Changed

- Created the official bilingual documentation root at `.agents/docs/`.
- Created complete English documentation under `.agents/docs/en/`.
- Created complete Brazilian Portuguese documentation under `.agents/docs/pt-br/`.
- Added complete English framework reference:
  - `.agents/docs/en/HEPHAESTUS-COMPLETE-REFERENCE.md`
- Updated Portuguese complete reference to reflect the new documentation structure:
  - `.agents/docs/pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md`
- Moved daily usage guides into the official documentation structure:
  - `.agents/docs/en/daily-prompts/`
  - `.agents/docs/pt-br/daily-prompts/`
- Kept framework internals in English:
  - agent definitions
  - protocols
  - workflows
  - configuration
  - memory entries
  - technical instructions
- Preserved user-facing Portuguese communication as the expected interaction style.

### Cleanup

- Converted `.agents/Tutorial/` into a README-only compatibility bridge.
- Converted `.agents/daily-prompts/` into a README-only compatibility bridge.
- Removed duplicated legacy tutorial and daily prompt files from those old folders.
- Updated references that still described `Tutorial/` as the primary documentation path.

### Validation

- Confirmed `.agents/docs/en/` has 29 files.
- Confirmed `.agents/docs/pt-br/` has 29 files.
- Confirmed `.agents/Tutorial/` has only `README.md`.
- Confirmed `.agents/daily-prompts/` has only `README.md`.
- Validated local Markdown links across:
  - `.agents/docs/**`
  - `.agents/Tutorial/README.md`
  - `.agents/daily-prompts/README.md`
  - `.agents/releases/v5.1.0.md`
- Result: all checked local Markdown links resolve.

### Compatibility Note

The old folder roots still exist:

- `.agents/Tutorial/README.md`
- `.agents/daily-prompts/README.md`

Deep legacy paths such as `.agents/Tutorial/01-PRIMEIROS-PASSOS.md` were intentionally retired in the clean documentation layout. Use `.agents/docs/pt-br/01-PRIMEIROS-PASSOS.md` instead.

---

## v5.0.0 — Active Configuration Cleanup

### What Changed

- `framework.yaml` was reduced to active, enforced settings only.
- Aspirational settings were moved out of active config and documented in `ROADMAP.md`.
- Technology catalogs were removed from config because they consumed context without enforcing behavior.
- Active framework settings included:
  - language policy
  - mandatory self-evaluation
  - telemetry
  - evolution tracking
  - auto-escalation
  - session checkpoint
  - active Flutter multiplatform profile

### Why It Mattered

v5.0.0 clarified the boundary between:

- what the framework actually enforces today;
- what the framework wants to support later;
- what should live in roadmap rather than active config.

This made the framework more honest, lighter, and easier to maintain.

---

## Earlier Milestones

These milestones are summarized from the framework references and historical packages.

| Version | Theme | Main Contribution |
|---|---|---|
| v1.0.0 | Foundation | Initial multi-agent structure, memory, protocols, workflows |
| v1.5.0 | Expert Prompts | Senior-level prompts, self-evaluation, deep reasoning examples |
| v2.0.0 | Advanced Knowledge Base | Architecture patterns, tech cards, reusable engineering knowledge |
| v2.5.0 | Specialist Patterns | Agent playbooks, blueprints, testing guides |
| v3.0.0 | Enterprise Grade | Stronger governance, project standards, broader controls |
| v3.5.0 | Operational Intelligence | Delivery agent, versioning, commit gates, routing/maturity rules |
| v3.6.0 | Context Optimization | Smart Loading and token/context economy |
| v4.0.0 | Practical Intelligence | Platform Guardian, UI/UX Specialist, auto-escalation model |
| v4.0.1 | Reference Update | Complete reference documentation update |
| v4.0.2 | Registry/Packaging Update | Agent registry/package consistency update |

---

## Current Documentation Entry Points

| Purpose | Path |
|---|---|
| Documentation index | `.agents/docs/README.md` |
| English documentation | `.agents/docs/en/README.md` |
| Portuguese documentation | `.agents/docs/pt-br/README.md` |
| English complete reference | `.agents/docs/en/HEPHAESTUS-COMPLETE-REFERENCE.md` |
| Portuguese complete reference | `.agents/docs/pt-br/HEPHAESTUS-COMPLETE-REFERENCE.md` |
| Release notes | `.agents/releases/` |
| Roadmap | `.agents/ROADMAP.md` |

## Current Operational Entry Points

| Purpose | Path |
|---|---|
| Master framework contract | `.agents/AGENTS.md` |
| Global active config | `.agents/config/framework.yaml` |
| Agent registry | `.agents/config/agent-registry.yaml` |
| Protocols | `.agents/protocols/` |
| Workflows | `.agents/workflows/` |
| Memory | `.agents/memory/` |
