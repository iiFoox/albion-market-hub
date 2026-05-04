# 23 — Inter-Agent Communication Bus

> Framework Version: 8.0.0
> When to use: Auditing handoffs, consultations, conflicts, decisions, alerts, or correction loops between agents.

---

## Purpose

The communication bus gives HEPHAESTUS a compact, auditable way to prove that agents are coordinating. It records structured summaries, not full transcripts.

## What It Captures

| Message Type | Use |
|---|---|
| `handoff` | Ownership transfer between agents |
| `consultation` | Expert input without ownership transfer |
| `broadcast` | Shared information through Orchestrator |
| `alert` | Security, production, destructive command, or data-loss risk |
| `conflict` | Disagreement about scope, quality, architecture, risk, or priority |
| `decision` | Orchestrator decision after evidence review |
| `correction` | Downstream rejection sent back upstream |

## Run the Proof

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-communication-bus-proof.ps1 -Root . -WriteReport
```

Expected output:

```text
Communication bus summary: status=PASS, messages=4
```

Latest report:

```text
.agents/reports/communication/communication-bus-latest.md
```

## Validate the Wiring

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-communication-bus.ps1 -Root .
```

## Token Boundary

Load this guide only when the task involves inter-agent coordination, audit evidence, handoffs, conflicts, corrections, or release proof.


