# TELEMETRY.md — HEPHAESTUS Telemetry System Specification

> **Managed By:** Project Manager Agent  
> **Written To By:** All Agents  
> **Purpose:** Comprehensive execution logging and evolution tracking

---

## 1. System Identity

The **Telemetry System** provides complete observability into the framework's operation. Every pipeline execution, agent decision, inter-agent communication, and memory operation is logged. This data drives the Project Manager's evolution analysis and ensures the framework's growth is measurable and traceable.

---

## 2. Core Mission

1. **Observe** — Capture every significant event in the framework's operation
2. **Measure** — Quantify agent performance, pipeline efficiency, and decision quality
3. **Trace** — Enable end-to-end traceability of any request through the entire pipeline
4. **Analyze** — Provide data for performance analysis and evolution assessment
5. **Alert** — Surface anomalies, regressions, and improvement opportunities

---

## 3. Log Architecture

```
.agents/telemetry/logs/
├── pipeline/                    # Complete pipeline execution logs
│   └── YYYY-MM-DD/
│       └── pipeline-{UUID}.md
├── agent-activity/              # Individual agent activity logs
│   └── YYYY-MM-DD/
│       └── {agent-id}-{UUID}.md
├── communication/               # Inter-agent communication logs
│   └── YYYY-MM-DD/
│       └── comm-{UUID}.md
├── memory-operations/           # Memory read/write logs
│   └── YYYY-MM-DD/
│       └── memop-{UUID}.md
├── evolution/                   # Evolution assessment logs
│   └── YYYY-MM-DD/
│       └── evolution-{UUID}.md
└── summaries/                   # Periodic summary reports
    ├── daily/
    ├── weekly/
    └── monthly/
```

---

## 4. Log Formats

### 4.1 Pipeline Execution Log

Generated for every complete pipeline execution.

```markdown
---
log_type: "pipeline"
pipeline_id: "UUID"
request_id: "UUID"
timestamp_start: "ISO-8601"
timestamp_end: "ISO-8601"
duration_ms: N
status: "success" | "partial_success" | "failure" | "aborted"
user_request_summary: "Brief summary"
pipeline_type: "full" | "quick-fix" | "research-only" | "review-only" | "custom"
---

## Request
[Original request summary]

## Self-Evaluation Results
| Agent | Decision | Confidence | Justification |
|---|---|---|---|
| orchestrator | PARTICIPATE | 1.0 | Always active |
| researcher | PARTICIPATE | 0.9 | New domain detected |
| planner | PARTICIPATE | 0.85 | Multi-step task |
| builder | PARTICIPATE | 0.95 | Code changes required |
| validator | PARTICIPATE | 0.9 | Tests needed |
| documentation | PARTICIPATE | 1.0 | Always active |
| project-manager | PARTICIPATE | 1.0 | Always active |

## Pipeline Assembled
[Ordered list of agents and their phases]

## Execution Timeline
| # | Agent | Action | Duration | Status | Output Summary |
|---|---|---|---|---|---|
| 1 | researcher | context-analysis | 2000ms | ✅ | Mapped 5 files, 2 risks |
| 2 | planner | task-decomposition | 1500ms | ✅ | 4 steps planned |
| 3 | builder | implementation | 5000ms | ✅ | 3 files modified |
| 4 | validator | test-generation | 3000ms | ✅ | 8 tests, all pass |
| 5 | documentation | auto-doc | 1000ms | ✅ | README updated |
| 6 | project-manager | telemetry | 500ms | ✅ | Metrics logged |

## Inter-Agent Communications
[List of all messages exchanged during this pipeline]

## Memory Operations
| Operation | Component | Entry ID | Agent |
|---|---|---|---|
| query | knowledge-graph | kg-2026-0405-001 | researcher |
| store | learning-store | ls-2026-0405-012 | validator |
| update | context-db | ctx-2026-0405-003 | builder |

## Outcome
- **Status:** [success/partial/failure]
- **Deliverables:** [list of outputs]
- **Quality Score:** [0-100]
- **Evolution Points:** [learnings from this execution]

## Metrics
- Total agents consulted: 7
- Agents activated: 7
- Pipeline duration: 13000ms
- Memory queries: 5
- Memory writes: 3
- Documentation updated: Yes
- Tests generated: 8
- Tests passed: 8/8
- Quality score: 92/100
```

### 4.2 Agent Activity Log

Generated for each agent's activity within a pipeline.

```markdown
---
log_type: "agent-activity"
agent_id: "builder"
pipeline_id: "UUID"
timestamp_start: "ISO-8601"
timestamp_end: "ISO-8601"
duration_ms: N
status: "success" | "partial" | "failure"
---

## Self-Evaluation
[Full self-evaluation output]

## Actions Taken
1. [Action 1 — details]
2. [Action 2 — details]

## Decisions Made
| Decision | Rationale | Memory Reference | Confidence |
|---|---|---|---|
| Use Zustand for state | Past success with similar scale | ls-2026-0402-005 | 0.9 |

## Files Affected
- [file1.ts] — Modified (reason)
- [file2.ts] — Created (reason)

## Communications Sent
[Messages to other agents]

## Communications Received
[Messages from other agents]

## Memory Operations
[Reads and writes to memory system]

## Quality Self-Assessment
- Alignment with plan: [0-100]%
- Code quality: [0-100]%
- Risk level: [low/medium/high]
- Confidence in output: [0-100]%
```

### 4.3 Communication Log

Generated for each inter-agent message exchange.

```markdown
---
log_type: "communication"
message_id: "UUID"
correlation_id: "UUID"
pipeline_id: "UUID"
from_agent: "researcher"
to_agent: "planner"
message_type: "handoff"
priority: "normal"
timestamp: "ISO-8601"
---

## Message Content
[Full message content per protocol format]

## Response
[Response content if applicable]

## Resolution
[How the communication was resolved]
```

---

## 5. Telemetry Events

### 5.1 Event Categories

| Category | Events |
|---|---|
| **Pipeline** | `pipeline.started`, `pipeline.completed`, `pipeline.failed`, `pipeline.aborted` |
| **Agent** | `agent.activated`, `agent.completed`, `agent.failed`, `agent.skipped` |
| **Self-Evaluation** | `eval.started`, `eval.completed`, `eval.participate`, `eval.standby`, `eval.skip` |
| **Communication** | `comm.sent`, `comm.received`, `comm.conflict`, `comm.resolved` |
| **Memory** | `memory.query`, `memory.store`, `memory.update`, `memory.hit`, `memory.miss` |
| **Evolution** | `evolution.milestone`, `evolution.regression`, `evolution.metric`, `evolution.review` |
| **Quality** | `quality.test_pass`, `quality.test_fail`, `quality.gate_pass`, `quality.gate_fail` |

### 5.2 Event Format

```yaml
event:
  id: "UUID"
  category: "pipeline"
  name: "pipeline.completed"
  timestamp: "ISO-8601"
  pipeline_id: "UUID"
  agent_id: "orchestrator"
  data:
    duration_ms: 13000
    agents_activated: 7
    status: "success"
  tags: ["feature", "react", "state-management"]
```

---

## 6. Summary Reports

### 6.1 Daily Summary

Generated at end of each day (or on-demand):
- Total requests processed
- Pipeline success rate
- Average pipeline duration
- Most active agents
- Memory operations count
- New learnings captured
- quality metrics

### 6.2 Weekly Summary

Generated weekly (or on-demand):
- Everything in daily, aggregated
- Evolution milestones achieved
- Agent maturity trends
- Knowledge graph growth
- Top learnings of the week
- Areas needing improvement
- Recommendations for next week

### 6.3 Monthly Summary

Generated monthly (or on-demand):
- Everything in weekly, aggregated
- Framework evolution assessment
- Long-term trend analysis
- Strategic recommendations
- Capability gap analysis
- Technology coverage review

---

## 7. Alerting Rules

| Condition | Alert Level | Action |
|---|---|---|
| Pipeline failure rate > 20% | 🔴 Critical | Immediate review required |
| Agent consistently skipped | 🟡 Warning | Review agent relevance |
| Memory hit rate < 30% | 🟡 Warning | Review memory quality |
| Quality score trending down | 🟡 Warning | Investigate regressions |
| New anti-pattern detected | 🟢 Info | Record in learning store |
| Evolution milestone achieved | 🟢 Info | Celebrate and document |
| Memory entries > 1000 unscored | 🟡 Warning | Prioritize scoring |

---

## 8. Data Retention

| Log Type | Retention | Archive Policy |
|---|---|---|
| Pipeline logs | 365 days active | Archive after 1 year |
| Agent activity | 180 days active | Archive after 6 months |
| Communication logs | 90 days active | Archive after 3 months |
| Memory operation logs | 90 days active | Archive after 3 months |
| Evolution logs | Indefinite | Never archive |
| Summary reports | Indefinite | Never archive |
