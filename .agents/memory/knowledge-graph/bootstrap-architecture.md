---
id: "kg-2026-0405-001"
type: "architecture"
created: "2026-04-05T03:45:00-03:00"
updated: "2026-04-05T03:45:00-03:00"
confidence: 1.0
usage_count: 0
last_used: null
tags: ["framework", "multi-agent", "architecture", "foundation"]
related_entries: ["ev-2026-0405-001", "ctx-2026-0405-001"]
agents_contributed: ["orchestrator", "project-manager"]
---

## Title
HEPHAESTUS Agent Framework — Core Architecture Pattern

## Description
The HEPHAESTUS Agent Framework uses a hub-and-spoke architecture with the
Orchestrator as the central hub and specialist agents as spokes. All agents
share a common memory system and communicate via structured protocols.

Key architectural decisions:
1. **7 autonomous agents** — consolidated from 12 proposed roles
2. **Shared memory system** — not an agent, but infrastructure used by all
3. **Sequential pipeline** with optional parallel consultation
4. **Mandatory self-evaluation** for every request
5. **Always-active agents:** Orchestrator, Documentation, Project Manager
6. **Conditionally-active agents:** Researcher, Planner, Builder, Validator

## Evidence
This architecture was designed based on:
- Analysis of software development lifecycle needs
- Evaluation of role consolidation (12 → 7 agents)
- Review of the reference Archon agent system
- Best practices in multi-agent system design

## Applicability
This architecture applies to all software development projects using this
framework, from simple scripts to complex multi-platform applications.

## Limitations
- Sequential pipeline may add latency for simple tasks (mitigated by Quick Fix workflow)
- Self-evaluation overhead exists even for trivial requests (intentional — ensures quality)
- Memory system requires real usage data to become valuable

## Connections
- Related to: bootstrap-genesis (evolution log)
- Related to: bootstrap-project-state (context DB)
