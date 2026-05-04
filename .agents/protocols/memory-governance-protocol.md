# Memory Governance Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-010
> **Type:** Knowledge Management
> **Priority:** MANDATORY — applies to all memory operations
> **Status:** Active
> **Companion:** `.agents/protocols/memory-consultation-protocol.md`

---

## Purpose

Ensure the framework's shared memory remains **reliable, curated, and valuable** over time. Without governance, memory accumulates noise, contradictions, and stale entries that degrade decision quality instead of improving it.

---

## Memory Entry Classification

Every memory entry MUST be classified by type:

| Type | Definition | Lifespan | Example |
|---|---|---|---|
| `RULE` | Established practice, always applies | Permanent (until disproved) | "Always use parameterized queries for SQL" |
| `LESSON` | Learning from real experience | Long (validated by results) | "Prisma pool of 5 is too low for auth-heavy apps" |
| `HYPOTHESIS` | Untested assumption | Short (validate or expire) | "Using Redis for sessions may reduce latency by 60%" |
| `EXCEPTION` | Valid deviation from standard practice | Context-dependent | "For this client, we use MongoDB despite SQL being standard" |
| `TEMPORARY` | Context-specific, single-project | Expires with project | "Current sprint deadline is April 15th" |
| `WARNING` | Something that went wrong | Long | "React 19 use() hook causes hydration error with SSR streaming" |

## Confidence Scoring

Every memory entry receives a confidence score:

```
CONFIDENCE LEVELS:

5 — PROVEN
→ Validated across 3+ projects
→ Supported by documentation or benchmarks
→ Promoted to global knowledge

4 — VALIDATED
→ Confirmed in 2 projects
→ No contradicting evidence
→ Eligible for promotion

3 — OBSERVED
→ Seen in 1 project
→ Seems correct but not cross-validated
→ Default for new lessons

2 — UNCERTAIN
→ Theoretical or based on external source
→ Not yet applied in practice
→ Needs validation

1 — DISPUTED
→ Contradicted by newer evidence
→ May be stale or context-dependent
→ Flagged for review
```

## Lifecycle Rules

### Creation
```
WHEN CREATING A NEW MEMORY ENTRY:
1. Classify type (rule/lesson/hypothesis/exception/temporary/warning)
2. Assign initial confidence (usually 3 — OBSERVED)
3. Tag with: project, technology, category
4. Record source: which pipeline/request generated this
5. Set initial review date (30 days for hypothesis, 90 days for lesson)
```

### Promotion (Local → Global)
```
PROMOTION CRITERIA:
→ Confidence ≥ 4 (validated in 2+ projects)
→ No active contradictions
→ Applicable beyond current project context
→ Approved by PM during evolution review

PROMOTION PROCESS:
1. PM identifies candidate during evolution tracking
2. Entry is reviewed for generalizability
3. Context-specific details are removed or abstracted
4. Entry is copied to global/shared-knowledge/
5. Original local entry gets reference to global version
```

### Decay & Expiration
```
DECAY RULES:
→ Entries unused for 60 days: confidence drops by 1
→ Entries unused for 120 days: flagged for review
→ Entries unused for 180 days: archived (not deleted)
→ TEMPORARY entries: expire when project closes
→ HYPOTHESIS entries: expire after 30 days if not validated

EXCEPTIONS TO DECAY:
→ RULE type entries don't decay (they're permanent standards)
→ WARNING type entries decay slower (90-day cycle)
→ Entries with confidence 5 don't decay (proven knowledge)
```

### Conflict Resolution
```
WHEN TWO MEMORY ENTRIES CONTRADICT:

1. IDENTIFY the conflict
   → Both entries claim opposite things about the same topic
   → Example: Entry A says "Use JWT" vs Entry B says "Use sessions"

2. COMPARE evidence
   → Which has higher confidence?
   → Which is more recent?
   → Which has been validated in more projects?
   → Are they context-dependent? (both may be correct in different contexts)

3. RESOLVE
   → If context-dependent: mark both as EXCEPTION with context conditions
   → If one is clearly superior: downgrade the other to confidence 1 (DISPUTED)
   → If unclear: flag for PM review in next evolution cycle
   → NEVER silently delete a contradicted entry — archive with explanation
```

## Memory Hygiene (PM Responsibility)

```
WEEKLY:
→ Review new entries for proper classification and confidence
→ Check for duplicates or near-duplicates (merge if appropriate)

MONTHLY:
→ Run decay check on unused entries
→ Review DISPUTED entries for resolution
→ Identify promotion candidates

QUARTERLY:
→ Archive entries below confidence 2
→ Review global knowledge for staleness
→ Consolidate fragmented entries
→ Report memory health metrics (total entries, active, archived, promoted)
```
