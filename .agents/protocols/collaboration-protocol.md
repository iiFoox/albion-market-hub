# Agent Collaboration Protocol

> **Protocol Version:** 2.0.0  
> **Applies To:** All agents  
> **Consolidates:** inter-agent-communication.md + conflict-resolution.md

---

## 1. Communication Types

| Type | Purpose | Ownership Transfer |
|------|---------|-------------------|
| **Handoff** | Transfer task to next pipeline agent | YES — full transfer |
| **Consultation** | Request expert opinion | NO — requester keeps ownership |
| **Broadcast** | Share info with all agents | NO — informational |
| **Alert** | Urgent issue (security, regression, blocker) | NO — Orchestrator routes |

---

## 2. Communication Format

```markdown
## [Type]: [From] → [To]
**Priority:** [critical | high | normal | low]

### Context
[What the receiving agent needs to know]

### Payload
[The actual content — question, task, or information]

### Expected Response
[What the sender needs back, if anything]
```

---

## 3. Routing Rules

- **Orchestrator** can communicate with ALL agents directly
- **Sequential agents** (Researcher→Planner→Builder→Validator) can communicate with adjacent agents
- **Non-adjacent agents** must route through Orchestrator
- **Broadcasts** go through Orchestrator for logging

---

## 4. Handoff Artifact

Every pipeline handoff includes:

```markdown
## Handoff: [From] → [To]

### Task — [what to do]
### Objective — [what success looks like]
### Context — [all relevant background]
### Constraints — [boundaries and rules]
### Affected Areas — [files, modules, APIs]
### Expected Output — [what to produce]
### Done When — [completion criteria]
```

---

## 5. Conflict Resolution

### Types
| Conflict | Example | Resolution Approach |
|----------|---------|-------------------|
| **Technical** | REST vs GraphQL | Evidence-based, memory consultation |
| **Scope** | Minimal vs refactor | Align with original request |
| **Quality** | Validator rejects Builder | Data-driven, acceptance criteria |
| **Priority** | What to do first | Pipeline order, risk, dependencies |

### Resolution Process
1. **Detect** — Any agent raises conflict with type + summary
2. **Escalate** — Orchestrator reviews both positions
3. **Consult Memory** — Check for past precedent and outcomes
4. **Decide** — Based on: evidence → risk → objectives → simplicity → reversibility
5. **Record** — Store resolution in memory for future reference
6. **Track** — Score the outcome when implemented

### Escalation to User
If Orchestrator cannot resolve, present to user:
```markdown
## 🤔 Decision Needed
### Option A: [Agent]'s position — [summary, pros, cons, risk]
### Option B: [Agent]'s position — [summary, pros, cons, risk]
### Framework Recommendation: [if any]
```

### Correction Loops
- **1st rejection** — Normal feedback, Builder corrects
- **2nd rejection** — Orchestrator reviews both positions
- **3rd rejection** — Mandatory escalation (re-plan, or escalate to user)

---

## 6. Anti-Patterns

- ❌ **Never suppress conflicts** — disagreements must surface
- ❌ **Never defer to seniority alone** — evaluate on evidence
- ❌ **Never create endless loops** — max 3 corrections
- ❌ **Never resolve without recording** — memory must capture learnings
- ❌ **Never communicate off-record** — all messages are logged
