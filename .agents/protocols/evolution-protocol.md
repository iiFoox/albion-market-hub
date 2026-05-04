# Evolution Protocol

> **Protocol Version:** 1.0.0  
> **Managed By:** Project Manager (primary), All agents (contributors)  
> **Purpose:** Ensure the framework continuously learns, grows, and measurably improves

---

## 1. Purpose

This protocol defines how the HEPHAESTUS Agent Framework evolves over time. Evolution is not optional — it is a core design principle. Every interaction contributes to the framework's growth, and this growth is tracked, measured, and validated.

---

## 2. Evolution Dimensions

The framework evolves along five dimensions:

### 2.1 Knowledge Growth
The framework's total body of knowledge expands.
- New patterns discovered
- New technology compatibility data learned
- New architecture approaches validated
- New domain knowledge acquired

### 2.2 Decision Quality
The framework makes better decisions over time.
- Higher success rate on chosen approaches
- Fewer correction loops
- Better risk prediction accuracy
- More efficient trade-off analysis

### 2.3 Execution Efficiency
The framework executes faster and with less waste.
- Shorter pipeline durations
- Fewer unnecessary agent activations
- Better resource allocation
- Fewer false positive self-evaluations

### 2.4 Collaboration Quality
Agents work together more effectively.
- Fewer conflicts
- Higher quality handoffs
- More productive consultations
- Better conflict resolution accuracy

### 2.5 Agent Maturity
Individual agents become more capable.
- Deeper domain expertise
- Better self-evaluation accuracy
- Higher quality outputs
- Broader technology coverage

---

## 3. Evolution Loop

```
┌────────────────────────────────────────────────────────┐
│                   EVOLUTION LOOP                        │
│                                                         │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │ CAPTURE  │ →  │   ANALYZE    │ →  │   IMPROVE    │  │
│  │          │    │              │    │              │  │
│  │ • Events │    │ • Patterns   │    │ • Update     │  │
│  │ • Metrics│    │ • Trends     │    │   agents     │  │
│  │ • Outco- │    │ • Anomalies  │    │ • Refine     │  │
│  │   mes    │    │ • Gaps       │    │   protocols  │  │
│  │ • Feed-  │    │ • Strengths  │    │ • Enrich     │  │
│  │   back   │    │              │    │   memory     │  │
│  └──────────┘    └──────────────┘    └──────────────┘  │
│       ▲                                    │            │
│       │           ┌──────────────┐         │            │
│       └───────────│   MEASURE    │←────────┘            │
│                   │              │                       │
│                   │ • Growth     │                       │
│                   │   metrics    │                       │
│                   │ • Quality    │                       │
│                   │   scores     │                       │
│                   │ • Trend      │                       │
│                   │   analysis   │                       │
│                   └──────────────┘                       │
└────────────────────────────────────────────────────────┘
```

---

## 4. Evolution Triggers

### 4.1 Automatic Triggers (Every Pipeline)
After every pipeline execution:
1. Record all learnings in the learning store
2. Update context DB with new project state
3. Score any previously referenced memory entries
4. Log telemetry metrics
5. Check for new patterns or anti-patterns

### 4.2 Periodic Triggers

| Trigger | Frequency | Responsible Agent | Action |
|---|---|---|---|
| Daily Review | Every day | Project Manager | Summarize daily telemetry |
| Weekly Assessment | Every week | Project Manager | Assess evolution across all dimensions |
| Monthly Report | Every month | Project Manager | Full evolution report with trends |
| Quarterly Audit | Every 3 months | All agents | Deep review of agent capabilities and framework health |

### 4.3 Event Triggers

| Event | Trigger |
|---|---|
| Major failure | Immediate root cause analysis and learning capture |
| Breakthrough success | Pattern extraction and knowledge graph enrichment |
| New technology adopted | Capability expansion and knowledge base update |
| Repeated conflict on same topic | Protocol refinement trigger |
| Agent consistently underperforming | Agent enhancement review |

---

## 5. Evolution Metrics

### 5.1 Core Metrics (Tracked Continuously)

```yaml
metrics:
  knowledge:
    total_knowledge_entries: N
    entries_this_period: N
    knowledge_graph_density: float  # relationships per entry
    knowledge_utilization_rate: float  # % of entries referenced in pipelines
  
  decision_quality:
    success_rate: float  # % of decisions with positive outcomes
    correction_loop_rate: float  # % of pipelines with correction loops
    risk_prediction_accuracy: float  # % of predicted risks that materialized
    false_positive_risk_rate: float  # % of predicted risks that didn't materialize
  
  execution:
    avg_pipeline_duration_ms: N
    agents_per_pipeline_avg: float
    false_positive_eval_rate: float  # agents that participated but added no value
    false_negative_eval_rate: float  # agents that skipped but were later needed
  
  collaboration:
    conflict_rate: float  # conflicts per pipeline
    conflict_resolution_accuracy: float  # % of resolutions with positive outcomes
    handoff_quality_score: float  # avg quality score of handoffs
    consultation_value_score: float  # avg value added by consultations
  
  agent_maturity:
    per_agent:
      orchestrator: { maturity: float, trend: "up|stable|down" }
      researcher: { maturity: float, trend: "up|stable|down" }
      planner: { maturity: float, trend: "up|stable|down" }
      builder: { maturity: float, trend: "up|stable|down" }
      validator: { maturity: float, trend: "up|stable|down" }
      documentation: { maturity: float, trend: "up|stable|down" }
      project-manager: { maturity: float, trend: "up|stable|down" }
```

### 5.2 Evolution Scoring

Each dimension is scored on a **maturity scale**:

| Level | Score | Description |
|---|---|---|
| **Nascent** | 0.0 - 0.2 | Just starting — limited knowledge, basic capabilities |
| **Developing** | 0.2 - 0.4 | Growing — learning from experience, patterns emerging |
| **Competent** | 0.4 - 0.6 | Solid — reliable decisions, good pattern recognition |
| **Proficient** | 0.6 - 0.8 | Advanced — proactive risk management, deep expertise |
| **Expert** | 0.8 - 1.0 | Mastery — anticipates issues, optimal decisions, teaches |

---

## 6. Evolution Assessment Report

Generated periodically by the Project Manager:

```markdown
---
report_type: "evolution-assessment"
period: "YYYY-MM-DD to YYYY-MM-DD"
framework_version: "1.0.0"
generated_by: "project-manager"
generated_at: "ISO-8601"
overall_health: "excellent | good | fair | poor"
---

## Executive Summary
[Brief assessment of framework health and growth]

## Dimension Scores
| Dimension | Previous | Current | Trend | Target |
|---|---|---|---|---|
| Knowledge Growth | 0.35 | 0.42 | ↑ +0.07 | 0.60 |
| Decision Quality | 0.40 | 0.45 | ↑ +0.05 | 0.70 |
| Execution Efficiency | 0.50 | 0.52 | → +0.02 | 0.65 |
| Collaboration Quality | 0.30 | 0.38 | ↑ +0.08 | 0.55 |
| Agent Maturity | 0.35 | 0.40 | ↑ +0.05 | 0.60 |

## Key Achievements This Period
- [Achievement 1]
- [Achievement 2]

## Areas of Concern
- [Concern 1 — recommended action]
- [Concern 2 — recommended action]

## Agent Performance
| Agent | Score | Trend | Highlight | Improvement Needed |
|---|---|---|---|---|
| orchestrator | 0.45 | ↑ | Better pipeline assembly | Conflict resolution speed |
| researcher | 0.42 | ↑ | Deeper context analysis | Tech research breadth |
| ... | ... | ... | ... | ... |

## Top Learnings This Period
1. [Learning 1 — impact score]
2. [Learning 2 — impact score]

## Recommendations
1. [Recommendation 1 — priority]
2. [Recommendation 2 — priority]

## Memory Health
- Total entries: N
- New entries this period: N
- Scored entries: N%
- Stale entries flagged: N
- Knowledge graph connections: N

## Next Period Goals
1. [Goal 1 — measurable target]
2. [Goal 2 — measurable target]
```

---

## 7. Anti-Patterns in Evolution

The framework must NEVER:
1. **Fake growth** — Metrics must reflect genuine improvement, not gaming
2. **Ignore regressions** — Quality decreases must be immediately addressed
3. **Hoard knowledge** — All learnings must be shared via memory
4. **Skip assessments** — Periodic reviews are mandatory
5. **Resist change** — Evolution requires willingness to update protocols and approaches
6. **Optimize one dimension at the expense of others** — Balanced growth is essential
