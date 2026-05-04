# HEPHAESTUS Agent Framework — Complete Reference

> Version: 8.7.0 — Practical First Project Walkthrough
> Created by: Self-evolving framework
> Last updated: 2026-04-23
> Purpose: Complete reference for the framework architecture, capabilities, components, and operating model

---

## Table of Contents

1. [Overview](#1-overview)
2. [Architecture](#2-architecture)
3. [The 10 Agents](#3-the-10-agents)
4. [Memory System](#4-memory-system)
5. [Operational Protocols](#5-operational-protocols)
6. [Workflows](#6-workflows)
7. [Profiles](#7-profiles)
8. [Knowledge Base](#8-knowledge-base)
9. [Telemetry](#9-telemetry)
10. [Token Economy](#10-token-economy)
11. [Continuous Evolution](#11-continuous-evolution)
12. [Documentation Structure](#12-documentation-structure)
13. [Version History](#13-version-history)
14. [Metrics and Capabilities](#14-metrics-and-capabilities)

---

## 1. Overview

HEPHAESTUS is a multi-agent software engineering framework that turns a host LLM into an organized engineering team. It is designed to work with Codex, Antigravity, ChatGPT, Claude, Gemini, and similar environments.

It is not a generic chatbot, a loose prompt collection, or a boilerplate generator. It is a structured operating system for software delivery with specialized agents, routing rules, memory, workflows, quality gates, and evolution tracking.

### Core Principles

| Principle | Meaning |
|---|---|
| Expert-level by default | Agents operate with senior or architect-level judgment |
| Memory-driven evolution | Lessons, decisions, and outcomes feed future work |
| Collaborative intelligence | Agents can consult, hand off, and resolve conflicts |
| Mandatory self-evaluation | All agents perform lightweight relevance triage |
| Token efficiency | Smart Loading keeps context lean |
| Host cooperation | The framework augments the host tool instead of competing with it |
| Continuous documentation | Documentation is treated as part of delivery |
| Quality gates | Validation, testing, and risk checks are first-class |

## 2. Architecture

The framework is organized around a stable operational core:

```text
.agents/
├── AGENTS.md
├── config/
├── agents/
├── protocols/
├── workflows/
├── profiles/
├── knowledge/
├── memory/
├── telemetry/
├── docs/
└── releases/
```

`AGENTS.md` is the master operational contract. It defines the framework identity, behavior rules, language policy, agent registry summary, and project-level governance.

`config/framework.yaml` defines active settings only. Aspirational features belong in `ROADMAP.md` until they have real enforcement or a concrete operating protocol.

## 3. The 10 Agents

| ID | Agent | Main Responsibility |
|---|---|---|
| `orchestrator` | Orchestrator | Request analysis, routing, pipeline assembly, conflict resolution |
| `researcher` | Researcher | Context analysis, technology research, dependency mapping, risk assessment |
| `planner` | Planner | Task decomposition, strategy selection, acceptance criteria |
| `builder` | Builder | Implementation, refactoring, platform adaptation, version-aware changes |
| `ui-ux-specialist` | UI/UX Specialist | Design systems, accessibility, responsive behavior, visual review |
| `platform-guardian` | Platform Guardian | Cross-platform compatibility, package checks, platform constraints |
| `validator` | Validator | Testing, regression checks, security audit, quality gates |
| `documentation` | Documentation | API docs, architecture docs, changelogs, tutorials |
| `project-manager` | Project Manager | Scope control, telemetry, performance analysis, evolution tracking |
| `delivery` | Delivery | Commits, release checks, semantic versioning, repository hygiene |

Each agent has an `AGENT.md`, `capabilities.yaml`, and specialized prompts under `.agents/agents/<agent-id>/`.

## 4. Memory System

The memory system is shared by all agents and is organized into four stores:

| Store | Path | Purpose |
|---|---|---|
| Knowledge Graph | `.agents/memory/knowledge-graph/` | Stable project and architecture relationships |
| Learning Store | `.agents/memory/learning-store/` | Lessons, heuristics, recurring decisions |
| Evolution Log | `.agents/memory/evolution-log/` | Framework growth and version evolution |
| Context DB | `.agents/memory/context-db/` | Session state, project checkpoints, handoff context |

Memory is used to reduce repeated discovery, improve routing, and preserve continuity across sessions.

## 5. Operational Protocols

Current protocol files:

| Protocol | Purpose |
|---|---|
| Adaptive Complexity | Classifies work as LITE, STANDARD, DEEP, or CRITICAL |
| Auto-Escalation | Starts lean and escalates only when triggers require more depth |
| Collaboration | Defines how agents cooperate on shared work |
| Commit Gate | Establishes checks before commits |
| Documentation Enforcement | Keeps documentation aligned through lightweight impact checks |
| Evolution | Captures lessons and improvement opportunities |
| Handoff | Structures transfer of work between agents or sessions |
| Memory Consultation | Defines triggered, tier-aware memory consultation |
| Memory Governance | Defines how memory should be created and used |
| Project Discovery | Matures project ideas, requirements, cost, legal/IP, Git, and readiness before implementation |
| Real Project Adapter | Reads project-local stack, commands, protected paths, execution mode, and quality gates |
| Real Project Execution | Produces DryRun-first controlled execution plans for real local projects |
| Real Project Execution Hardening | Adds controlled Apply fixture, backup artifact, audit trail, protected-path override checks, and restore validation |
| Command Allowlist and Quality Gates | Executes only adapter-allowed project commands and denies destructive command patterns |
| Real Project Apply Scenario | Proves DryRun-to-Apply behavior in an isolated fixture with before/after quality gates, backup, audit, and restore evidence |
| Documentation Runtime Loop | Converts changed paths into compact documentation impact decisions and evidence |
| Release Evidence Bundle | Consolidates release, package, docs, quality gate, and scenario evidence into one compact audit index |
| Operational Score Review | Summarizes score, residual risks, token economy, and release readiness |
| Install and Update Wizard | Guides safe install/update operation with dry-run, backup, project-local preservation, and validation |
| Optional Telemetry and Memory Proof | Proves memory consultation wiring, index-first behavior, schema support, and retention dry-run without normal-session expansion |
| Final Operator Experience Review | Keeps operator entry points, ready prompts, legacy bridges, and intent-based navigation current |
| Inter-Agent Communication Bus | Records compact auditable messages for handoffs, consultations, conflicts, decisions, alerts, and corrections |
| Unified Operator CLI | Provides one safe command entry point for doctor, validate, gate, package, evidence, install, and update |
| Core Contract Drift Guard | Keeps the always-loaded core contract compact, current, version-aligned, and release-validated |
| Operator Daily Launcher | Provides intent-based daily commands and a Windows first-install launcher with first-call prompt generation |
| Project Bootstrap Assistant | Bridges first install to Project Discovery and Real Project Adapter readiness without mutating active config |
| Stability Baseline | Verifies the stable operational surface has not regressed across releases |
| Operator Runbook and Recovery | Provides compact daily operation and recovery guidance for failed validation, gates, packages, install, and update |
| Guided Installer and Repository Onboarding | Records repository intent and creates first-call handoff files after guided install |
| Practical First Project Walkthrough | Guides the operator through first real use in new and existing projects |
| Self-Evaluation | Requires agents to judge whether they should participate |
| Session Closing | Defines end-of-session capture |
| Session Handoff | Supports starting a new chat without losing context |
| Smart Loading | Loads only the needed context tiers |
| Universal Triage | Ensures all agents are considered for each request |
| Versioning | Defines SemVer, changelog, and release behavior |

## 6. Workflows

Current workflow files:

| Workflow | Typical Use |
|---|---|
| `quick-fix.md` | Small fixes, configuration edits, isolated changes |
| `research-only.md` | Investigation without implementation |
| `review-only.md` | Code or architecture review |
| `full-pipeline.md` | End-to-end work from research to delivery |
| `ui-workflow.md` | UI, UX, accessibility, and visual changes |
| `project-onboarding.md` | Initial project setup and framework adoption |
| `project-discovery-workflow.md` | Requirements maturation before implementation planning |
| `real-project-adapter-workflow.md` | Project-local adapter validation before controlled real-project work |
| `real-project-execution-workflow.md` | DryRun-first execution planning and approval gates for real local projects |
| `multi-project-support.md` | Operating across more than one project |
| `health-dashboard.md` | Framework/project health analysis |
| `weekly-evolution-review.md` | Periodic learning and evolution review |

## 7. Profiles

Profiles adapt the framework to a project type, industry, or stack. The active configured profile is:

| Profile | Path | Purpose |
|---|---|---|
| Flutter Multiplatform | `.agents/profiles/flutter-multiplatform/` | Android, Windows, Web, and iOS guidance for Flutter projects |

Template profiles also exist for domains such as e-commerce, fintech, healthcare, AI/ML, and realtime systems.

## 8. Knowledge Base

The knowledge base gives agents reusable engineering context:

- architecture patterns
- security practices
- database playbooks
- resilience patterns
- observability guidance
- operational intelligence
- technology cards for frontend, backend, mobile, database, and DevOps stacks

This prevents repeated reinvention and helps the agents ground decisions in known patterns.

## 9. Telemetry

Telemetry records how the framework operates:

- pipeline start and completion
- agents involved
- complexity classification
- triage output
- validation outcomes
- conflicts
- release or commit events
- lessons for future evolution

Logs live under `.agents/telemetry/logs/`.

## 10. Token Economy

HEPHAESTUS uses Smart Loading to avoid loading the entire framework on every request. The goal is to load only the right context:

| Tier | Loaded When |
|---|---|
| Core | Always needed framework rules and current request context |
| Agent | Only the agents relevant to the task |
| Workflow | Only the workflow matching the complexity and type of work |
| Knowledge/Profile | Only when the task needs domain, stack, or platform guidance |

This keeps the framework usable in constrained context windows.

## 11. Continuous Evolution

The framework improves through:

- memory entries
- telemetry review
- evolution logs
- weekly review workflow
- release notes
- roadmap cleanup
- consolidation of repeated lessons into reusable guidance

The rule is simple: active configuration should describe what is actually enforced. Aspirational behavior belongs in the roadmap until implemented.

## 12. Documentation Structure

Starting in v5.1.0, user-facing documentation is split into two complete language folders:

```text
.agents/docs/
├── en/
│   ├── daily-prompts/
│   └── prompts/
└── pt-br/
    ├── daily-prompts/
    └── prompts/
```

The operational core remains in English:

- agent definitions
- prompt internals
- protocols
- configuration
- memory entries
- technical definitions

The framework can still communicate with the user in Portuguese, as defined by the language policy.

## 13. Version History

| Version | Theme | Main Additions |
|---|---|---|
| v1.0.0 | Foundation | Initial agents, memory, protocols, workflows |
| v1.5.0 | Expert Prompts | Senior-level prompts, self-evaluation, deep reasoning examples |
| v2.0.0 | Advanced Knowledge Base | Architecture patterns, tech cards, reusable knowledge |
| v2.5.0 | Specialist Patterns | Agent-specific playbooks, blueprints, testing guides |
| v3.0.0 | Enterprise Grade | Governance, stronger standards, broader project controls |
| v3.5.0 | Operational Intelligence | Delivery agent, versioning, commit gates, maturity routing |
| v3.6.0 | Context Optimization | Smart Loading and context economy improvements |
| v4.0.0 | Practical Intelligence | Platform Guardian, UI/UX Specialist, auto-escalation model |
| v5.0.0 | Active Configuration Cleanup | Framework config reduced to active/enforced behavior |
| v5.1.0 | Bilingual Documentation Structure | Complete EN and PT-BR user-facing documentation sets |
| v5.2.0 | Integrity and Version Alignment | Framework manifest, local validation, version alignment, path hygiene |
| v5.3.0 | Smart Loading Manifest | Auditable loading tiers, token estimation, and loading reports |
| v5.4.0 | Memory Contract and Session State | Triggered memory consultation, memory policy, session state templates |
| v5.5.0 | Telemetry Schema and Health Score | Telemetry schema, telemetry validation, framework health scoring |
| v5.6.0 | Agent Contract Tests | Routing fixtures and contract test runner for canonical requests |
| v5.7.0 | Documentation Source of Truth and Reference Generation | Translation map and documentation parity validation |
| v5.8.0 | Practical Enforcement Layer | Pre-release gate, package checklist, package verification, telemetry cleanup tool |
| v6.0.0 | Framework Kernel Stabilization | Stable kernel contract, compatibility policy, migration guide, host matrix |
| v6.1.0 | Safe Install and Update Automation | Dry-run installer, updater with backup, version comparison, installation tool tests |
| v6.2.0 | Isolated Simulation Harness | Temporary-workspace framework simulation with compact behavior report |
| v6.3.0 | Developer Execution Mode Simulation | Controlled mini-project implementation with tests and delivery report |
| v6.4.0 | Multi-Scenario Developer Benchmark | Repeated developer execution across feature, docs, bug fix, and validation scenarios |
| v6.5.0 | Documentation Enforcement and Mastery Calibration | Documentation checkpoint enforcement and master-level agent calibration |
| v6.6.0 | Project Discovery and Requirements Maturation | Conditional discovery mode for product story, use cases, backend, cost, legal/IP, Git, and readiness |
| v6.7.0 | Real Project Adapter | Project-local adapter contract for stack, commands, protected paths, execution mode, and quality gates |
| v6.8.0 | Developer Execution on Real Local Project | DryRun-first real-project execution planning with backup, approval, protected-path, and quality-gate controls |
| v6.9.0 | Benchmark Expansion | Expanded developer benchmark across API, database migration, refactor, security fix, failing tests, and docs-only release scenarios |
| v7.0.0 | Real Project Execution Hardening | Controlled Apply fixture, backup artifact, audit trail, protected-path override checks, and restore validation |
| v7.1.0 | Command Allowlist and Quality Gate Runner | Adapter command parser, safe allowlist runner, destructive-command denial, and compact quality gate reports |
| v7.2.0 | Real Project Apply Scenario | Isolated DryRun-to-Apply validation with before/after quality gates, backup, audit, and restore evidence |
| v7.3.0 | Documentation Agent Runtime Loop | Changed-path documentation impact loop, not-impacted reason gate, and compact evidence report |
| v7.4.0 | Release Evidence Bundle | Compact release audit index for gates, package, documentation runtime, quality gates, and scenarios |
| v7.5.0 | Operational Polish and Score Review | Final score rubric, residual risk review, token economy review, and readiness report |
| v7.6.0 | Install and Update Wizard | Operator-guided install/update documentation, protocol, validation, and current Getting Started alignment |
| v7.7.0 | Optional Telemetry and Memory Proof | Compact memory consultation proof, optional retention evidence, and release evidence integration |
| v7.8.0 | Final Operator Experience Review | Intent-based operator map, ready prompt cleanup, legacy bridge update, and operator experience gate |
| v7.9.0 | Real Inter-Agent Communication Bus | Compact auditable message contract, communication proof, release evidence integration, and gate validation |
| v8.0.0 | Unified Operator CLI and Doctor | Unified safe command wrapper for diagnostics, validation, packaging, evidence, install, and update |
| v8.1.0 | Core Contract Alignment and Drift Guard | Compact guard for version alignment, current core references, and always-loaded token economy |
| v8.2.0 | Operator Daily Launcher and First-Call Installer | Intent-based daily commands, Windows launcher, and generated first-call prompt for target projects |
| v8.3.0 | Project Bootstrap Assistant | First readiness bridge from install to Discovery and Adapter review with optional adapter draft |
| v8.4.0 | Stability Baseline and Regression Sentinel | Compact regression guard for CLI actions, critical capability wiring, and stable counts |
| v8.5.0 | Operator Runbook and Recovery Guide | Compact operator runbook for daily operation and recovery after failed gates, package, install, or update |
| v8.6.0 | Guided Installer and Repository Onboarding | Guided repository mode, first-call handoff, and safe install onboarding |
| v8.7.0 | Practical First Project Walkthrough | Step-by-step first real project usage for new and existing projects |

## 14. Metrics and Capabilities

| Metric | Current Value |
|---|---|
| Specialist agents | 10 |
| Shared memory systems | 1 |
| Memory stores | 4 |
| Protocol files | 36 |
| Workflow files | 12 |
| Complexity levels | 4 |
| Documentation languages | 2 |
| Active configured profile | 1 |
| Knowledge areas | Architecture, security, database, resilience, observability, operations, technology cards |

HEPHAESTUS is strongest when used as a disciplined operating framework: classify the request, activate the right agents, load only the needed context, validate the result, document the outcome, and preserve lessons for the next session.







