# HEPHAESTUS Framework — Roadmap to 9.7/10

> Current baseline: 7.0.0
> Target: 9.7/10 framework maturity
> Strategy: small versioned releases, no big-bang rewrite, no token-cost explosion
> Guiding rule: improve enforceability, consistency, and operational reliability before adding broad new capabilities

---

## Current Honest Assessment

HEPHAESTUS is already strong as a multi-agent software engineering framework. It has a clear agent model, protocols, workflows, memory, telemetry, profiles, knowledge base, bilingual documentation, and release history.

The main gap is not imagination. The main gap is enforceable reliability.

To reach 9.7/10, the framework needs:

- stronger integrity checks;
- version consistency across config, docs, registry, and references;
- fewer stale paths;
- a measurable health score;
- better memory and telemetry contracts;
- operational fixtures that keep token usage predictable;
- sharper boundaries between active behavior, prompt guidance, and future aspirations.

---

## Scoring Baseline

| Area | Current | Target | Main Gap |
|---|---:|---:|---|
| Architecture | 9.0 | 9.8 | Strong structure, needs enforceable contracts |
| Documentation | 8.8 | 9.8 | Bilingual docs exist, but some references remain stale |
| Token Economy | 8.7 | 9.7 | Smart Loading exists, needs manifest-based validation |
| Agent Design | 9.0 | 9.8 | Agents are rich, but activation contracts need test fixtures |
| Operational Reliability | 7.8 | 9.7 | Missing automated integrity checks |
| Memory System | 8.0 | 9.6 | Present, but not strongly enforced or scored |
| Telemetry | 7.8 | 9.6 | Present, but lacks schema validation and retention tooling |
| Release Governance | 8.5 | 9.8 | Changelog exists, but version sync is not automated |

---

## v5.2.0 — Integrity and Version Alignment

### Goal

Make the framework self-checking without changing agent behavior.

### Add

- `.agents/tools/validate-framework.ps1`
- `.agents/config/framework-manifest.yaml`
- `.agents/reports/health/README.md`

### Improve

- Align version metadata across:
  - `.agents/config/framework.yaml`
  - `.agents/config/agent-registry.yaml`
  - `.agents/AGENTS.md`
  - `.agents/docs/**`
  - `.agents/releases/CHANGELOG.md`
- Validate expected counts:
  - 10 agents
  - 13 protocols
  - 9 workflows
  - 4 memory stores
  - 2 documentation languages
- Validate local Markdown links.
- Validate referenced `.agents/...` paths.
- Detect stale references to retired legacy files.

### Impact

This is the highest ROI release. It does not add token cost during normal use, but it prevents drift.

### Improves

- operational reliability;
- release confidence;
- documentation trust;
- future refactor safety.

### Risk

Low. Additive tooling only.

### Target Score After Release

8.9 to 9.1.

---

## v5.3.0 — Smart Loading Manifest

### Goal

Make token economy measurable and auditable.

### Add

- `.agents/config/loading-tiers.yaml`
- `.agents/tools/estimate-loading.ps1`
- `.agents/reports/loading/README.md`

### Improve

- Convert Smart Loading from prose-only guidance into a manifest:
  - LITE files
  - STANDARD delta files
  - DEEP delta files
  - CRITICAL delta files
  - conditional files by trigger
- Add missing-path detection for tier definitions.
- Add approximate file-size/token-budget reporting.
- Replace stale references in `smart-loading-protocol.md`.

### Impact

This protects the framework from becoming too heavy. The system can remain ambitious without loading everything.

### Improves

- token economy;
- auto-escalation reliability;
- user trust when tasks scale;
- repeatable behavior across hosts.

### Risk

Low to medium. Requires careful mapping, but no behavior needs to be removed.

### Target Score After Release

9.1 to 9.25.

---

## v5.4.0 — Memory Contract and Session State

### Goal

Make memory use consistent without forcing large memory loads.

### Add

- `.agents/protocols/memory-consultation-protocol.md`
- `.agents/config/memory-policy.yaml`
- `.agents/memory/context-db/session-checkpoint.md` template
- `.agents/memory/context-db/session-brief.md` template
- `.agents/memory/context-db/next-chat-activation-prompt.md` template

### Improve

- Define when memory must be consulted:
  - session start;
  - before architectural decisions;
  - before repeating a failed approach;
  - before session close;
  - before release.
- Define compact memory summaries.
- Define maximum memory load rules by complexity tier.
- Define memory write format for:
  - decision;
  - lesson;
  - risk;
  - project state;
  - next action.

### Impact

Memory becomes reliable without becoming expensive.

### Improves

- session continuity;
- learning quality;
- reduced repeated mistakes;
- context efficiency.

### Risk

Medium. Poorly implemented memory enforcement can increase token usage. Mitigation: compact templates and tier-aware loading.

### Target Score After Release

9.25 to 9.4.

---

## v5.5.0 — Telemetry Schema and Health Score

### Goal

Turn telemetry from passive logs into measurable operational intelligence.

### Add

- `.agents/config/telemetry-schema.yaml`
- `.agents/tools/validate-telemetry.ps1`
- `.agents/tools/framework-health.ps1`
- `.agents/reports/health/latest.md` generated report format

### Improve

- Define telemetry event schema:
  - `pipeline.started`
  - `triage.completed`
  - `agent.activated`
  - `escalation.triggered`
  - `validation.completed`
  - `memory.written`
  - `session.closed`
  - `release.created`
- Define health score:
  - version consistency;
  - agent registry consistency;
  - missing references;
  - memory freshness;
  - telemetry freshness;
  - docs link health;
  - loading manifest validity.

### Impact

The framework gains observability over itself.

### Improves

- operational reliability;
- debugging;
- weekly evolution review quality;
- release confidence.

### Risk

Low if scripts are optional and reports are generated on demand.

### Target Score After Release

9.4 to 9.55.

---

## v5.6.0 — Agent Contract Tests

### Goal

Make agent activation and pipeline behavior testable.

### Add

- `.agents/tests/fixtures/`
- `.agents/tests/expected-routing/`
- `.agents/tools/test-routing.ps1`

### Improve

- Add canonical request fixtures:
  - quick bug fix;
  - UI feature;
  - cross-platform Flutter issue;
  - security-sensitive change;
  - production migration;
  - docs-only change;
  - research-only request;
  - review-only request.
- Define expected:
  - complexity level;
  - activated agents;
  - escalation triggers;
  - workflow;
  - required validation.

### Impact

This makes the multi-agent system feel deterministic enough to trust.

### Improves

- routing quality;
- self-evaluation calibration;
- regression safety for future framework edits;
- host-independent behavior.

### Risk

Medium. Requires careful expectations so tests do not overfit and make the framework rigid.

### Target Score After Release

9.55 to 9.65.

---

## v5.7.0 — Documentation Source of Truth and Reference Generation

### Goal

Prevent EN/PT-BR documentation drift.

### Add

- `.agents/docs/_source/`
- `.agents/docs/_translation-map.yaml`
- `.agents/tools/check-doc-parity.ps1`

### Improve

- Track which EN/PT-BR files are paired.
- Validate that paired files exist.
- Validate version headers.
- Validate reference docs mention current counts.
- Keep `HEPHAESTUS-COMPLETE-REFERENCE.md` aligned in both languages.

### Impact

Documentation stays excellent as the framework grows.

### Improves

- documentation quality;
- onboarding;
- maintainability;
- product polish.

### Risk

Low. Additive checks only.

### Target Score After Release

9.65 to 9.72.

---

## v5.8.0 — Practical Enforcement Layer

### Goal

Move selected roadmap items from aspirational to active, but only where enforceable.

### Add

- pre-release gate script;
- single-command release validation;
- optional telemetry cleanup script;
- package verification checklist.

### Improve

- Promote implemented release governance into active config only after tooling exists.
- Update `framework.yaml` carefully with only enforceable behavior.
- Keep telemetry cleanup manual and dry-run by default.

### Impact

This is where HEPHAESTUS becomes more than structured prompts: it becomes a lightweight operating system with real guardrails.

### Improves

- honesty of active config;
- governance;
- session quality;
- long-term maintainability.

### Risk

Medium to high if overdone. Guardrail: do not add mandatory behaviors that increase token usage on every task.

### Target Score After Release

9.72 to 9.8.

---

## v6.0.0 — Framework Kernel Stabilization

### Goal

Declare a stable kernel contract after the 5.x hardening releases.

### Add

- stable kernel specification;
- compatibility policy;
- migration guide from 5.x to 6.0;
- release checklist;
- supported host matrix.
- kernel contract validator.

### Improve

- Freeze core directory contracts:
  - agents;
  - protocols;
  - workflows;
  - memory;
  - docs;
  - releases;
  - tools;
  - tests.
- Define what can change in minor versions.
- Define what requires major version bump.
- Include kernel validation in the pre-release gate.

### Impact

This makes HEPHAESTUS feel mature and safe to install across projects.

### Improves

- product credibility;
- compatibility;
- contributor confidence;
- multi-project adoption.

### Risk

Medium. Stabilizing too early can lock in mistakes. Only do this after v5.2-v5.8 hardening.

### Target Score After Release

9.8+.

---

## Priority Order

| Priority | Version | Why |
|---:|---|---|
| 1 | v5.2.0 | Integrity checks catch drift immediately |
| 2 | v5.3.0 | Token economy becomes measurable |
| 3 | v5.4.0 | Memory becomes reliable without becoming heavy |
| 4 | v5.5.0 | Health scoring makes quality visible |
| 5 | v5.6.0 | Routing fixtures protect agent behavior |
| 6 | v5.7.0 | Documentation parity prevents bilingual drift |
| 7 | v5.8.0 | Enforcement moves from aspiration to reality |
| 8 | v6.0.0 | Stable kernel once the hardening work proves itself |
| 9 | v6.1.0 | Safe install/update automation makes the kernel portable |
| 10 | v6.2.0 | Isolated simulation proves behavior without polluting the framework |
| 11 | v6.3.0 | Controlled developer execution proves small feature delivery in isolation |
| 12 | v6.4.0 | Multi-scenario benchmark tests repeatability across work types |
| 13 | v6.5.0 | Documentation enforcement and mastery calibration keep evolution aligned |
| 14 | v6.6.0 | Guided project discovery prevents shallow starts and costly direction changes |
| 15 | v6.7.0 | Real project adapter makes repository-specific work explicit and safer |
| 16 | v6.8.0 | Controlled real-project execution applies the adapter with dry-run and approval gates |
| 17 | v6.9.0 | Benchmark expansion tests more realistic implementation risks |
| 18 | v7.0.0 | Hardens controlled Apply, backup, allowlist, and rollback behavior |
| 19 | v7.1.0 | Executes adapter allowlisted commands and quality gates safely |

---

## Non-Goals

Do not do these while pursuing 9.7:

- Do not load all framework files by default.
- Do not add broad technology catalogs back into active config.
- Do not make every agent participate deeply in every request.
- Do not treat roadmap wishes as active features.
- Do not duplicate documentation outside `.agents/docs/`.
- Do not create enforcement rules without a lightweight validation mechanism.
- Do not add automation that requires network access.

---

## Immediate Known Gaps to Fix First

These were found during the v5.1.0 review:

- `agent-registry.yaml` still reports version `4.0.2`.
- `ROADMAP.md` still uses old v4.x future labels.
- Some docs and protocols reference paths that do not currently exist, such as:
  - `.agents/protocols/inter-agent-communication.md`
  - `.agents/agents/builder/prompts/code-review.md`
  - `.agents/agents/planner/prompts/architecture-decision.md`
  - `.agents/memory/context-db/session-checkpoint.md`
  - `.agents/memory/context-db/session-brief.md`
  - `.agents/memory/context-db/next-chat-activation-prompt.md`
- `health-dashboard.md` still uses old expected values such as version `4.0.2` and protocol count `12`.
- The old technical reference remains behind the current framework state.

These should be handled in v5.2.0 before adding new capabilities.

---

## Definition of 9.7/10

HEPHAESTUS reaches 9.7/10 when:

- the framework can validate itself locally;
- all active config matches real implemented behavior;
- Smart Loading is manifest-driven and measurable;
- memory has a compact enforcement contract;
- telemetry has schema and health scoring;
- agent routing has test fixtures;
- EN/PT-BR docs remain paired and current;
- releases are documented and version-aligned;
- no normal workflow requires loading the whole framework;
- no retired paths remain in active references.
