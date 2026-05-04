# Real Project Execution Hardening Protocol

> Framework Version: 7.0.0
> Purpose: Mature project ideas before implementation so shallow requirements do not become expensive rework.

---

## Principle

Do not build from a vague idea.

When a user is starting a new project, changing product direction, defining an MVP, or describing a business idea, HEPHAESTUS must slow down and mature the requirements before implementation. The framework should question, compare, document, and confirm decisions before code is written.

## Activation Triggers

Activate this protocol when the request includes:

- starting a new project, product, app, SaaS, platform, game, marketplace, automation, or internal tool;
- defining MVP scope or product roadmap;
- turning an idea into a plan;
- uncertainty about users, costs, backend, data, legal risk, monetization, integrations, or operations;
- major direction changes in an existing project;
- multi-operator or multi-agent project setup.

## Operating Rules

- Ask one focused question at a time when the user is still forming the idea.
- Group related questions when the user already provided a mature brief.
- Do not accept shallow answers without probing risks, exceptions, and alternatives.
- Prefer zero-cost or low-cost starting paths when the operator asks for cost control.
- Separate facts, assumptions, decisions, risks, and open questions.
- Record every direction-changing decision in living documentation.
- Keep the active context lean: load this protocol only when discovery is relevant.

## Discovery Domains

The framework must cover these domains before declaring the project ready for implementation:

| Domain | Required Exploration |
|---|---|
| Product Story | What the operator imagines, why it exists, and what outcome it creates |
| Problem | Pain, urgency, current workaround, and who pays or benefits |
| Users | Personas, roles, permissions, incentives, and edge users |
| Journeys | Step-by-step happy paths, alternate paths, and failure paths |
| Business Rules | Constraints, validations, policies, calculations, and exceptions |
| Backend | APIs, services, jobs, storage, authentication, authorization, and operations |
| Data | Entities, lifecycle, privacy, backups, retention, and migration concerns |
| Integrations | External APIs, payment, email, analytics, AI, storage, maps, or third parties |
| Cost Model | Free-tier viability, expected growth costs, vendor lock-in, and operational surprises |
| Legal/IP | Copyright, inspiration sources, trademarks, data law, terms, and intellectual property |
| Market Context | Alternatives, differentiation, positioning, and viability assumptions |
| MVP | Must-have scope, explicitly deferred scope, success criteria, and launch threshold |
| Team/Workflow | Single operator or multiple operators, parallel work fronts, Git strategy, and host tools |
| Risks | Technical, legal, operational, financial, UX, market, and delivery risks |

## Output Contract

Every discovery session must produce or update a Project Discovery Report:

```markdown
# Project Discovery Report

## Product Story
## Problem and Users
## Journeys and Use Cases
## Business Rules
## Backend and Data
## Integrations
## Cost and Zero-Cost Start
## Legal, Copyright, and IP
## Market and Differentiation
## MVP and Future Scope
## Team, Git, and Workspace Strategy
## Risks and Mitigations
## Decisions
## Open Questions
## Implementation Readiness
```

## Readiness Gate

The project is ready to move from discovery into planning only when:

- the core user journey is described step by step;
- MVP boundaries are explicit;
- backend and data assumptions are documented;
- cost constraints are known;
- legal/IP concerns are either cleared or marked as risks;
- repository/workspace strategy is chosen;
- open questions are acceptable for the next phase;
- the operator confirms the direction.

## Token Policy

Project discovery is a conditional loading group. It must not be part of the default LITE load.

- Load the discovery protocol, policy, workflow, and template only for project-start or major-direction work.
- Summarize prior answers instead of reloading all discovery reports when continuing.
- Use compact decision logs for direction changes.




