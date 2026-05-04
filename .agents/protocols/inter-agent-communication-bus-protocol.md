# Inter-Agent Communication Bus Protocol

> Framework Version: 7.9.0
> Purpose: Provide a compact, auditable message bus for handoffs, consultations, conflicts, alerts, decisions, and corrections between agents.

---

## Scope

This protocol turns inter-agent communication from an informal instruction into a structured message contract. It does not require logging full agent transcripts. It records only compact evidence needed to audit coordination, ownership transfer, conflict handling, and decisions.

Use this protocol when:

- one agent hands work to another;
- a non-adjacent agent needs consultation;
- a conflict must be surfaced and resolved;
- a validation rejection sends work back upstream;
- a release or audit needs proof of agent coordination.

## Token Economy Rule

The bus records summaries, not transcripts.

Messages must be compact:

- one message per meaningful coordination event;
- no full chain-of-thought;
- no broad memory dumps;
- no duplicated release notes;
- references to files/reports instead of embedded long content.

## Message Contract

Each bus message must include:

```yaml
message_id: "uuid-or-stable-id"
correlation_id: "shared-request-or-pipeline-id"
pipeline_id: "pipeline-id"
timestamp: "ISO-8601"
from_agent: "agent-id"
to_agent: "agent-id-or-all"
message_type: "handoff|consultation|broadcast|alert|conflict|decision|correction"
priority: "critical|high|normal|low"
summary: "compact summary"
status: "created|accepted|rejected|resolved|superseded"
references:
  - "relative artifact path when applicable"
```

## Routing Rules

- Orchestrator may send messages to any agent.
- Adjacent workflow agents may hand off directly.
- Non-adjacent communication routes through Orchestrator.
- Broadcasts and critical alerts route through Orchestrator.
- Conflict and correction messages require explicit status updates.

## Required Bus Events

| Event | Required when |
|---|---|
| `handoff` | Ownership transfers between agents |
| `consultation` | An agent asks another for expert input without ownership transfer |
| `conflict` | Agents disagree on scope, risk, architecture, quality, or priority |
| `decision` | Orchestrator resolves a conflict or chooses between options |
| `correction` | Downstream validation sends work back upstream |
| `alert` | Security, data loss, destructive command, or production risk appears |

## Completion Criteria

The bus is healthy when:

- config defines required fields and allowed values;
- runner can generate compact communication evidence;
- checker validates config, protocol, reports, loading group, telemetry schema, and gate wiring;
- release evidence includes communication-bus proof;
- normal sessions load bus context only when coordination/audit is relevant.
