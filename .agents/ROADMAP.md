# HEPHAESTUS Framework — Roadmap & Aspirational Features

> **Purpose:** Features and capabilities that are planned but NOT yet enforced.  
> These items were removed from `framework.yaml` to keep the config clean.  
> When implemented with real enforcement, they should be moved back to the config.

---

## 🔴 Not Yet Implemented (were in framework.yaml as if active)

### Memory Consultation Protocol
```yaml
# Was:
memory_consultation:
  required: true
  before_action: true    # ← No enforcement mechanism
  after_action: true     # ← No enforcement mechanism
```
**Status:** Implemented in v5.4.0 as triggered, tier-aware consultation.

Implemented files:
- `.agents/protocols/memory-consultation-protocol.md`
- `.agents/config/memory-policy.yaml`
- `.agents/memory/templates/`

Remaining future improvement: optional telemetry event proving memory consultation occurred.

### Inter-Agent Communication Bus
```yaml
# Was:
inter_agent_communication:
  enabled: true
  broadcast_on_critical: true   # ← No message bus exists
  log_all_messages: true        # ← No message log exists
```
**To implement:** Create a structured message format and log file where agents record inter-agent communications.

### Auto Documentation
```yaml
# Was:
documentation:
  auto_update: true          # ← No auto-trigger exists
  always_participate: true   # ← No enforcement
```
**To implement:** Create a protocol that triggers documentation agent on every code change.

### Periodic Evolution Review
```yaml
# Was:
evolution:
  periodic_review: "weekly"  # ← No scheduler exists
```
**To implement:** Create a weekly review prompt template that the user runs to trigger evolution analysis.

### Self-Evaluation Timeout
```yaml
# Was:
self_evaluation:
  timeout_ms: 5000           # ← No timeout enforcement possible
```
**Status:** Removed — LLMs don't have real timeout mechanisms in prompt-based interaction.

### Telemetry Retention
```yaml
# Was:
telemetry:
  retention_days: 365        # ← No cleanup job exists
```
**To implement:** Create a cleanup script that archives/removes telemetry older than N days.

---

## 🟠 Technology Catalogs (removed from config)

These lists were in `framework.yaml` but served no functional purpose — the AI already knows all these technologies natively. They were consuming ~500 tokens per session for zero benefit.

If a project needs to **restrict** which technologies are allowed, that should go in the **project profile**, not the framework config.

### Removed Catalogs:
- **Platforms:** mobile (iOS, Android, cross-platform), desktop (Windows, macOS, Linux), web (frontend, backend), server, scripting, embedded
- **Databases:** relational, document, key-value, graph, timeseries, search, vector, message queue, cache, columnar
- **Infrastructure:** cloud providers, containerization, orchestration, IaC, CI/CD, monitoring, security
- **Quality:** testing frameworks, linters, type checking, static analysis, architecture patterns

---

## 🟢 Future Feature Ideas

### v5.4.0 — Memory Contract and Session State
- [x] Memory consultation protocol (triggered, tier-aware)
- [x] Memory policy config
- [x] Session state templates
- [x] Memory entry templates
- [ ] Telemetry proof event for memory consultation
- [ ] Telemetry retention cleanup script
- [ ] Periodic evolution review template

### v5.5.0 — Telemetry Schema and Health Score
- [x] Telemetry event schema
- [x] Framework health score script
- [x] Telemetry validation script
- [ ] Telemetry retention cleanup script

### v5.6.0 — Agent Contract Tests
- [x] Routing fixtures
- [x] Expected routing documentation
- [x] Routing test runner

### v5.7.0 — Auto Documentation and Documentation Parity
- [x] EN/PT-BR translation map
- [x] Documentation source-of-truth notes
- [x] Documentation parity checker
- [x] Documentation parity validation in release notes

### v5.8.0 — Practical Enforcement Layer
- [x] Pre-release gate script
- [x] Single command release validation
- [x] Package verification checklist
- [x] Optional telemetry legacy cleanup

### v6.0.0 — Framework Kernel Stabilization
- [x] Stable kernel specification
- [x] Compatibility policy
- [x] Migration guide from 5.x to 6.0
- [x] Supported host matrix
- [x] Kernel contract validator
- [x] Kernel validation in pre-release gate

### v6.1.0 — Safe Install and Update Automation
- [x] Version comparison tool
- [x] Dry-run installer
- [x] Updater with backup
- [x] Project-local config preservation
- [x] Installation tooling tests

### v6.2.0 — Isolated Simulation Harness
- [x] Temporary simulation workspace
- [x] Framework install inside isolated project
- [x] Scenario-based simulation runner
- [x] Compact simulation report
- [x] Simulation harness validation in pre-release gate

### v6.3.0 — Developer Execution Mode Simulation
- [x] Temporary mini project
- [x] Controlled implementation plan
- [x] Generated feature files
- [x] Local structural test
- [x] Delivery note
- [x] Developer execution report
- [x] Developer execution validation in pre-release gate

### v6.4.0 — Multi-Scenario Developer Benchmark
- [x] Profile card feature scenario
- [x] Documentation update scenario
- [x] Bug fix scenario
- [x] Validation failure correction scenario
- [x] Consolidated benchmark report
- [x] Benchmark validation in pre-release gate

### v6.5.0 — Documentation Enforcement and Mastery Calibration
- [x] Documentation enforcement protocol
- [x] Documentation policy config
- [x] Documentation impact template
- [x] Documentation enforcement validator
- [x] Agent mastery validator
- [x] Documentation always-active registry correction
- [x] Master-level / 30+ years equivalent calibration across agents
- [x] Pre-release gate integration

### v6.6.0 — Project Discovery and Requirements Maturation
- [x] Guided project story intake
- [x] Use case and user journey interrogation
- [x] Business rule, exception, and alternative-flow discovery
- [x] Backend, data, integration, and cost exploration
- [x] Zero-cost production-start analysis
- [x] Legal, copyright, intellectual-property, and inspiration checks
- [x] Multi-operator / multi-agent workspace planning
- [x] Git/repository setup decision flow
- [x] Living documentation generated from operator answers
- [x] Conditional Smart Loading group
- [x] Project discovery validator in pre-release gate

### v6.7.0 — Real Project Adapter
- [x] Project-local `.agents/config/project.yaml` adapter contract
- [x] Stack, test, build, lint, and protected-path configuration
- [x] Adapter validation tool
- [x] Documentation for adapting HEPHAESTUS to real projects
- [x] Conditional Smart Loading group
- [x] Pre-release gate integration

### v6.8.0 — Developer Execution on Real Local Project
- [x] Controlled real-project execution mode
- [x] DryRun-first execution plan
- [x] Backup-before-mutation flow
- [x] Approval gate before applying changes
- [x] Adapter-bound command execution
- [x] Real project execution report
- [x] Apply blocking test
- [x] Pre-release gate integration

### v6.9.0 — Benchmark Expansion
- [x] API scenario
- [x] Database migration fake scenario
- [x] Refactor scenario
- [x] Security fix scenario
- [x] Failing tests correction scenario
- [x] Docs-only release scenario
- [x] Scenario presence validation
- [x] Expanded benchmark report

### v7.0.0 — Real Project Execution Hardening
- [x] Real adapter fixture project
- [x] Controlled Apply fixture with backup artifact
- [x] Protected-path override audit trail
- [x] Backup/restore validation
- [x] Hardening validator
- [x] Pre-release gate integration
- [x] Command allowlist execution test

### v7.1.0 — Command Allowlist and Quality Gate Runner
- [x] Adapter command parser
- [x] Safe command allowlist runner
- [x] Required quality gate execution in fixture
- [x] Command output report
- [x] Deny destructive command fixture

### v7.2.0 — Real Project Apply Scenario
- [x] End-to-end DryRun to controlled Apply fixture
- [x] Quality gate before/after Apply
- [x] Backup restore verification after Apply
- [x] Compact execution evidence bundle

### v7.3.0 — Documentation Agent Runtime Loop
- [x] Runtime documentation checkpoint scenario
- [x] Documentation impact report generated during project change
- [x] Drift detection between implementation and docs
- [x] Compact documentation evidence report

### v7.4.0 — Release Evidence Bundle
- [x] Consolidated release evidence report
- [x] Package, gate, docs, and scenario summary in one artifact
- [x] Evidence bundle package validation

### v7.5.0 — Operational Polish and Score Review
- [x] Final score rubric update
- [x] Residual risk review
- [x] Token economy review across v7.x additions

### v7.6.0 — Install and Update Wizard
- [x] Operator-guided install/update protocol
- [x] EN/PT-BR step-by-step wizard guides
- [x] Getting Started alignment
- [x] Dry-run, backup, project-local preservation, and validation checklist
- [x] Lightweight checker and pre-release gate integration

### v7.7.0 — Optional Telemetry and Memory Proof
- [x] Memory consultation proof event
- [x] Optional telemetry retention policy enforcement
- [x] Evidence without normal-session token expansion

### v7.8.0 — Final Operator Experience Review
- [x] Intent-based operator map
- [x] Ready prompt stale-version cleanup
- [x] Legacy bridge update
- [x] Operator experience report and checker
- [x] Pre-release gate integration

### v7.9.0 — Real Inter-Agent Communication Bus
- [x] Compact message contract
- [x] Communication bus config
- [x] Handoff, consultation, conflict, decision, alert, and correction message types
- [x] Communication proof runner and checker
- [x] Release evidence and pre-release gate integration

### v8.0.0 — Unified Operator CLI and Doctor
- [x] Unified CLI entry point
- [x] Doctor command
- [x] Validate, gate, package, evidence commands
- [x] Compare, install, and update wrappers
- [x] CLI checker and pre-release gate integration

### v8.1.0 — Core Contract Alignment and Drift Guard
- [x] Compact `AGENTS.md` core contract by removing broad always-loaded technology catalogs
- [x] Current communication bus reference in the master contract
- [x] Core contract drift guard protocol
- [x] Core contract checker with version alignment and token-economy drift checks
- [x] EN/PT-BR operator guides
- [x] Pre-release gate integration

### v8.2.0 — Operator Daily Launcher and First-Call Installer
- [x] Intent-based daily command wrapper for start, validate, and release preparation
- [x] Unified CLI `daily` action
- [x] Windows `.bat` install launcher over the existing PowerShell installer
- [x] First-call prompt generation in target projects after Apply
- [x] Operator daily launcher protocol
- [x] EN/PT-BR operator guides
- [x] Pre-release gate integration

### v8.3.0 — Project Bootstrap Assistant
- [x] Analysis-only project bootstrap runner
- [x] Discovery-to-adapter bridge report
- [x] Optional adapter draft generated outside active config
- [x] Unified CLI `bootstrap` action
- [x] Project bootstrap checker and pre-release gate integration
- [x] EN/PT-BR operator guides

### v8.4.0 — Stability Baseline and Regression Sentinel
- [x] Compact stability baseline config
- [x] Regression sentinel runner and checker
- [x] Stability baseline report template and latest report generation
- [x] Critical capability wiring checks for CLI, Discovery, Adapter, Evidence, Daily, Bootstrap, Memory, Documentation, and Core Guard
- [x] Release evidence integration
- [x] Pre-release gate integration
- [x] EN/PT-BR operator guides

### v8.5.0 — Operator Runbook and Recovery Guide
- [x] Compact operator runbook and recovery protocol
- [x] EN/PT-BR runbook guides
- [x] Operator runbook checker
- [x] Doctor and pre-release gate integration
- [x] Smart Loading conditional group
- [x] Stability baseline integration

### v8.6.0 — Guided Installer and Repository Onboarding
- [x] Repository mode prompt for local, GitHub, GitLab, Bitbucket, other, existing, or none
- [x] Target project state detection
- [x] First-call handoff prompt generation
- [x] `START-HEPHAESTUS.bat` first-call launcher generation
- [x] Repository setup report generation
- [x] Unified CLI install repository parameters
- [x] Checker, protocol, Smart Loading group, and EN/PT-BR guides

### v8.7.0 — Practical First Project Walkthrough
- [x] EN/PT-BR practical first project guides
- [x] New project path
- [x] Existing project path
- [x] First-call handoff usage
- [x] Bootstrap and adapter draft review steps
- [x] Project Discovery and repository strategy confirmation
- [x] Checker, protocol, Smart Loading group, and gate integration

### v8.8.0 — To Be Defined
- [ ] Next improvement after v8.7 validation

---

> **Rule:** Only move items back to `framework.yaml` when they have a real enforcement mechanism.  
> Config = what IS active. Roadmap = what we WANT to build.
