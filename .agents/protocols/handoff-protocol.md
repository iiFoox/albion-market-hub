# Handoff Protocol

> **Protocol Version:** 1.0.0  
> **Applies To:** All agents performing sequential task transfers  
> **Reference:** Inter-Agent Communication Protocol

---

## 1. Purpose

This protocol defines the mandatory process for transferring task ownership between agents. A handoff is the most critical communication type — it carries the full context needed for the receiving agent to continue work without information loss.

---

## 2. Handoff Principles

1. **Complete Context Transfer** — No implicit knowledge. Everything the receiving agent needs must be in the handoff artifact.
2. **Clean Ownership Transfer** — The sender STOPS working on the task after handoff. The receiver owns it.
3. **Verifiable Completeness** — The handoff artifact has mandatory fields. Missing fields trigger a rejection.
4. **Traceability** — Every handoff is logged with correlation IDs linking the full pipeline chain.
5. **Reversibility** — If the receiver determines the handoff is incomplete or flawed, they can reject it back to the sender.

---

## 3. Handoff Artifact (Mandatory Structure)

Every handoff MUST include ALL of the following sections:

```markdown
---
handoff_id: "UUID"
correlation_id: "UUID"
pipeline_id: "UUID"
from_agent: "agent-id"
to_agent: "agent-id"
timestamp: "ISO-8601"
handoff_type: "sequential" | "escalation" | "delegation" | "correction"
---

## Task
[Clear, concise description of what needs to be done]

## Objective
[What success looks like — measurable criteria]

## Context
[All relevant background information:
- Original user request
- Project state
- Architecture context
- Technology stack involved
- Prior agent outputs in this pipeline]

## Constraints
[Limitations, rules, boundaries:
- Time constraints
- Technology constraints
- Scope boundaries
- Quality requirements
- Compatibility requirements]

## Affected Areas
[Specific files, modules, services, APIs, UIs, databases affected]

## Risks
[Known risks, concerns, potential issues:
- Technical risks
- Integration risks
- Performance risks
- Security risks
- UX risks]

## Assumptions
[Explicit statements of what is being assumed:
- Each assumption must be clearly stated
- Assumptions must be verifiable
- If an assumption proves wrong, the handoff may need revision]

## Proposed Action
[Recommended approach — the receiving agent may modify this:
- Step-by-step suggested approach
- Alternatives considered
- Why this approach was recommended]

## Expected Output
[What the receiving agent should produce:
- Specific deliverables
- Format requirements
- Quality criteria]

## Validation Needed
[How to verify the output is correct:
- Test criteria
- Acceptance criteria
- Edge cases to verify
- Regression checks needed]

## Done When
[Explicit completion criteria — the task is DONE when:
- Criterion 1
- Criterion 2
- ...]

## Open Questions
[Unresolved questions that may need attention:
- Questions for the receiving agent
- Questions that may need user input
- Uncertainties that need resolution]

## Memory References
[Relevant memory entries that influenced this handoff:
- Pattern: [id] — [brief description]
- Learning: [id] — [brief description]
- Context: [id] — [brief description]]

## Previous Pipeline Output
[Summarized output from all previous agents in this pipeline:
- Researcher output: [summary]
- Planner output: [summary]
- etc.]
```

---

## 4. Handoff Types

### 4.1 Sequential
Standard pipeline flow: Research → Plan → Build → Validate.
- Most common type
- Follows pipeline priority order
- Carries accumulated pipeline context

### 4.2 Escalation
A non-adjacent agent is needed due to unexpected complexity.
- Routes through the Orchestrator
- Must include justification for skipping pipeline order
- Logged as an anomaly in telemetry

### 4.3 Delegation
One agent asks another to handle a specific sub-task.
- Ownership of the sub-task transfers
- The delegating agent retains ownership of the overall task
- Sub-task results are returned via a response message

### 4.4 Correction
A downstream agent sends work back upstream for revision.
- Must include specific, actionable feedback
- The upstream agent fixes and re-handoffs
- Correction loops are tracked (max 3 before Orchestrator intervention)

---

## 5. Handoff Validation

The receiving agent MUST validate the handoff before accepting:

### Validation Checklist
- [ ] All mandatory sections are present
- [ ] Task description is clear and actionable
- [ ] Objective is measurable
- [ ] Context is sufficient to begin work
- [ ] Constraints are understood
- [ ] Affected areas are identified
- [ ] Risks are acknowledged
- [ ] Assumptions are reasonable
- [ ] Expected output is clear
- [ ] Completion criteria are explicit

### Rejection
If validation fails, the receiving agent:
1. Rejects the handoff with specific reasons
2. Lists what is missing or unclear
3. Sends a correction handoff back to the sender
4. The rejection is logged in telemetry

---

## 6. Handoff Chain

For a complete pipeline, the handoff chain looks like:

```
Orchestrator → Researcher
    Researcher produces: Context Map, Risk Assessment, Feasibility Report
    
Researcher → Planner (via handoff)
    Planner produces: Task Plan, Acceptance Criteria, Validation Requirements
    
Planner → Builder (via handoff)
    Builder produces: Implementation, Modified Files, Change Summary
    
Builder → Validator (via handoff)
    Validator produces: Test Results, Quality Report, Approval/Rejection
    
Validator → Documentation (via handoff)
    Documentation produces: Updated Docs, Changelog, Architecture Updates
    
Documentation → Project Manager (via handoff)
    Project Manager produces: Telemetry Log, Evolution Assessment, Metrics
```

Each handoff carries ALL accumulated context from previous agents.

---

## 7. Telemetry Integration

Every handoff generates:
- A communication log entry
- Agent activity log entries (for sender and receiver)
- Memory operations (if handoff references or creates memory entries)
- Pipeline execution log update
