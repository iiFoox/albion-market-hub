# 12 — Project Discovery and Requirements Maturation

> Framework Version: 8.0.0
> Purpose: Use HEPHAESTUS to mature a project idea before implementation.

---

## What This Mode Does

Project Discovery turns a rough idea into an implementation-ready product direction.

Instead of accepting a shallow prompt and building too early, HEPHAESTUS asks structured questions, identifies missing context, compares options, records decisions, and creates living documentation as the operator answers.

## When To Use It

Use this mode when you are:

- starting a new app, SaaS, platform, game, automation, marketplace, or internal tool;
- defining an MVP;
- changing the direction of an existing project;
- unsure about backend, data, integrations, costs, legal/IP, or production operation;
- preparing multiple operators or multiple AI hosts to work in parallel.

## Recommended Prompt

```text
HEPHAESTUS, activate Project Discovery mode.

I want to mature a project idea before implementation.
Ask me one question at a time, challenge shallow assumptions, document decisions,
compare options with pros/cons, and preserve token economy.

Start by asking me to describe the product story as I imagine it.
```

## What HEPHAESTUS Will Explore

| Area | What It Clarifies |
|---|---|
| Product Story | What the operator imagines and why the product should exist |
| Problem | Pain, urgency, current workaround, and value |
| Users | Personas, roles, permissions, incentives, and edge cases |
| Journeys | Step-by-step flows, alternate paths, and failure cases |
| Business Rules | Validations, policies, exceptions, and calculations |
| Backend | APIs, services, auth, jobs, storage, and operations |
| Data | Entities, privacy, lifecycle, backups, retention, and migration |
| Integrations | External services, payment, email, analytics, AI, maps, storage |
| Costs | Zero-cost start, free-tier limits, growth costs, and vendor lock-in |
| Legal/IP | Copyright, trademarks, data protection, inspiration boundaries |
| Market | Alternatives, differentiation, and validation assumptions |
| MVP | Must-have scope, deferred scope, and success criteria |
| Team/Git | Operators, parallel work fronts, repository choice, branch strategy |
| Risks | Technical, legal, operational, financial, UX, market, and delivery risks |

## Output

The framework produces a Project Discovery Report with:

- product story;
- problem and users;
- use cases and journeys;
- business rules;
- backend and data assumptions;
- integrations;
- zero-cost or low-cost launch path;
- legal/IP notes;
- MVP and future scope;
- Git/workspace strategy;
- risks and mitigations;
- decisions and open questions;
- implementation readiness status.

## Token Economy

This mode is conditional. It is not loaded during normal bug fixes or small edits.

HEPHAESTUS loads the discovery protocol, policy, workflow, and templates only when discovery is relevant. On continuation sessions, it should summarize existing answers instead of reloading every report.

## Readiness Rule

Do not move into implementation planning until the operator confirms the product direction and the main open questions are either answered or explicitly accepted as risks.











