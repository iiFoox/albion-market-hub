# Self-Evaluation Protocol

> **Protocol Version:** 1.0.0  
> **Applies To:** All agents  
> **Trigger:** Every incoming request — NO exceptions

---

## 1. Purpose

This protocol defines how every agent evaluates whether it should participate in a given request. Self-evaluation is **mandatory** for every agent on every request. No agent is ever automatically excluded without performing this evaluation.

This ensures:
- The optimal team of agents is assembled for every request
- No relevant expertise is accidentally excluded
- Agents with low relevance don't waste pipeline time
- The decision is traceable and improvable over time

---

## 2. Mandatory Evaluation Mandate

> **RULE: Every agent MUST perform self-evaluation for EVERY request.**

This is non-negotiable. Even agents that seem obviously irrelevant must still evaluate — because:
1. Non-obvious connections exist (e.g., a "simple fix" might need documentation)
2. The evaluation itself generates useful metadata for telemetry
3. Patterns of agent participation inform framework evolution
4. Memory entries might reveal unexpected relevance

---

## 3. Evaluation Process

### Step 1: Request Analysis

```markdown
### Request Analysis
- **Request summary:** [Brief description of what was asked]
- **Request type:** [feature | bugfix | research | review | refactor | doc | infra | query | planning]
- **Complexity:** [trivial | simple | moderate | complex | critical]
- **Platforms involved:** [web | mobile | desktop | server | scripting | embedded | multiple]
- **Technologies detected:** [list of technologies mentioned or implied]
- **Urgency:** [low | normal | high | critical]
```

### Step 2: Capability Matching

```markdown
### Capability Matching
- **Domain match:** [0-100]% — How much does this request fall within my domain?
- **Capability match:** [0-100]% — Can I actually contribute to this request?
- **Expertise depth:** [surface | moderate | deep | expert] — At what level can I contribute?
- **Unique contribution:** [yes | no] — Can I provide something no other agent can?
```

### Step 3: Memory Consultation

```markdown
### Memory Consultation
- **Relevant memories found:** [count]
- **Key memories:**
  - [memory-id]: [brief description and relevance]
  - [memory-id]: [brief description and relevance]
- **Historical precedent:** [yes | no]
  - If yes: [What happened last time a similar request was handled with/without this agent?]
- **Learned patterns applicable:** [list]
```

### Step 4: Risk Assessment

```markdown
### Risk Assessment
- **Risk if excluded:** [none | low | medium | high | critical]
  - Justification: [Why this risk level?]
- **Risk if included unnecessarily:** [none | low | medium]
  - Justification: [Cost of false positive inclusion]
- **Downstream impact:** [What agents would be affected by my exclusion?]
```

### Step 5: Decision

```markdown
### Decision
- **Participate:** [YES | NO | STANDBY]
- **Involvement level:** [full | partial | advisory | monitor]
- **Justification:** [Clear reasoning for the decision]
- **Conditions:** [If STANDBY — what would trigger activation?]
- **Confidence in this decision:** [0.0-1.0]
```

---

## 4. Decision Definitions

### YES (Participate)
The agent has determined it should be part of the pipeline.
- **Full** — Active participant with output production
- **Partial** — Contributes to specific aspects only
- **Advisory** — Available for consultation but not in main pipeline

### NO (Skip)
The agent has determined it is not needed. Must still provide justification.
- The decision is logged in telemetry
- If this agent is repeatedly skipped and then needed later, the pattern is flagged

### STANDBY
The agent is not initially needed but should be ready to activate.
- Provides conditions under which it would switch to YES
- Monitored by the Orchestrator during pipeline execution
- Can be activated mid-pipeline if conditions are met

---

## 5. Orchestrator Aggregation

After collecting all self-evaluations, the Orchestrator:

1. **Reviews all decisions** — Checks for consistency and completeness
2. **Validates skip decisions** — Ensures no critical expertise is excluded
3. **Resolves conflicts** — If two agents disagree about involvement
4. **Assembles the pipeline** — Orders participating agents by priority
5. **Records evaluation results** — Logs in telemetry for future analysis
6. **Publishes the pipeline** — Announces the assembled team to all agents

### Override Rules

The Orchestrator may override agent self-evaluations:
- **Force inclusion** — If an agent skipped but the Orchestrator determines they're needed
- **Force exclusion** — If an agent wants to participate but would add no value
- All overrides must be justified and logged

---

## 6. Always-Active Agents

The following agents always participate (self-evaluation still runs for metrics):

| Agent | Reason |
|---|---|
| **Orchestrator** | Pipeline coordination is always needed |
| **Documentation** | Every change must be documented |
| **Project Manager** | Telemetry and evolution tracking on every execution |

---

## 7. Evaluation Quality Metrics

The self-evaluation system itself is tracked for quality:

| Metric | Description |
|---|---|
| `false_positive_rate` | % of times an agent participated but added no value |
| `false_negative_rate` | % of times an agent skipped but was later needed |
| `decision_consistency` | Do similar requests produce similar evaluations? |
| `evaluation_speed` | How quickly agents complete self-evaluation |
| `override_rate` | How often the Orchestrator overrides agent decisions |

These metrics feed into the evolution system to improve self-evaluation accuracy over time.

---

## 8. Self-Evaluation Template (Quick Reference)

```markdown
## Self-Evaluation: [Agent Name]
**Request ID:** [UUID]
**Timestamp:** [ISO-8601]

### Request Analysis
- Request summary: [...]
- Request type: [...]
- Complexity: [...]

### Capability Match
- Domain match: [0-100]%
- Capability match: [0-100]%
- Unique contribution: [yes/no]

### Memory Consultation
- Relevant memories: [count]
- Historical precedent: [yes/no]

### Risk Assessment
- Risk if excluded: [none|low|medium|high|critical]
- Risk if included unnecessarily: [none|low|medium]

### Decision
- **Participate:** [YES | NO | STANDBY]
- **Level:** [full | partial | advisory | monitor]
- **Justification:** [...]
- **Confidence:** [0.0-1.0]
```
