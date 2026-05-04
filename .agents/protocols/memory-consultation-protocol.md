# Memory Consultation Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-014
> **Type:** Context and Learning Retrieval
> **Priority:** MANDATORY when trigger conditions apply
> **Status:** Active (v5.4.0+)
> **Depends on:** Memory Governance Protocol (010), Smart Loading Protocol (011), Session Closing Protocol

---

## Purpose

Make memory useful without making memory expensive.

This protocol defines when agents must consult memory, how much memory can be loaded by complexity tier, and when outcomes must be written back. It prevents two common failures:

1. ignoring useful prior learnings;
2. loading too much memory and wasting context.

---

## Consultation Triggers

Agents MUST consult memory when any trigger below applies.

| Trigger | Required Store | Minimum Action |
|---|---|---|
| New session or resumed chat | `context-db/` | Read `session-checkpoint.md` and `session-brief.md` |
| Similar prior failure may exist | `MEMORY-INDEX.md`, `learning-store/` | Search index first, then read only relevant entries |
| Architecture or data model decision | `knowledge-graph/`, `learning-store/` | Read related decisions and lessons |
| Platform-specific work | `learning-store/`, active profile | Read platform learnings and profile constraints |
| Security, production, compliance, or migration work | all relevant stores | Read risk, warnings, decisions, and current state |
| Session close | `context-db/`, `learning-store/`, `evolution-log/` | Update compact state and write validated lessons |
| Release or version bump | `evolution-log/`, `releases/` | Check prior release history and update release memory if needed |

If no trigger applies, agents should use only the current request, loaded tier, and active workflow.

---

## Tier-Aware Memory Budget

Memory loading MUST respect Smart Loading tiers.

| Tier | Memory Budget | Allowed Reads |
|---|---:|---|
| LITE | 1-2 files | `session-checkpoint.md`; optionally `MEMORY-INDEX.md` |
| STANDARD | 3-5 files | checkpoint, brief, index, plus 1-2 relevant entries |
| DEEP | 6-10 files | checkpoint, brief, index, relevant learning/knowledge entries |
| CRITICAL | As needed, still selective | all relevant state, risk, warning, compliance, and release entries |

Do not read an entire memory store unless the task is CRITICAL and memory coverage is directly relevant.

---

## Read Order

When memory is needed, read in this order:

1. `.agents/memory/context-db/session-checkpoint.md`
2. `.agents/memory/context-db/session-brief.md`
3. `.agents/memory/MEMORY-INDEX.md`
4. Relevant entries only:
   - `.agents/memory/learning-store/`
   - `.agents/memory/knowledge-graph/`
   - `.agents/memory/evolution-log/`
5. `MEMORY.md` only when memory format or governance is unclear.

---

## Memory Consultation Note

When memory is consulted, the agent should leave a compact note in the response or internal handoff:

```text
Memory consulted:
- Stores: context-db, learning-store
- Entries: session-checkpoint.md, seed-flutter-platform.md
- Relevant finding: Web platform package compatibility has prior risk
- Effect on plan: activate Platform Guardian and avoid unsupported APIs
```

For LITE tasks, this can be one sentence.

---

## Write-Back Rules

Agents MUST write or propose memory updates when the work produces durable knowledge.

| Outcome | Store | Format |
|---|---|---|
| Current state changed | `context-db/session-checkpoint.md` | Compact state update |
| Resume context needed | `context-db/session-brief.md` | Short summary |
| Validated success/failure | `learning-store/` | Quick Learning |
| Architecture relationship/decision | `knowledge-graph/` | Knowledge Graph entry |
| Framework capability changed | `evolution-log/` | Evolution entry |
| Next chat prompt changed | `context-db/next-chat-activation-prompt.md` | Copy-ready prompt |

Avoid writing speculative memory. Hypotheses are allowed only when clearly marked and reviewed later.

---

## Compactness Rules

Memory entries must be concise:

- prefer Quick Learning over long reports;
- write evidence, not vague impressions;
- include reuse rule;
- include confidence;
- avoid duplicating changelog or release notes;
- update `MEMORY-INDEX.md` when adding new entries.

---

## Escalation Rules

Memory can trigger auto-escalation:

| Memory Finding | Escalation |
|---|---|
| Negative learning for proposed approach | STANDARD -> DEEP |
| High-risk platform or security warning | STANDARD -> DEEP or CRITICAL |
| Production/compliance warning | DEEP -> CRITICAL |
| Contradictory memory entries | activate Project Manager and Planner |

---

## Non-Goals

This protocol does not require:

- reading all memory every time;
- writing memory for trivial changes;
- replacing release notes;
- replacing telemetry;
- loading inactive profiles;
- storing private or sensitive user data unless explicitly required by the project.
