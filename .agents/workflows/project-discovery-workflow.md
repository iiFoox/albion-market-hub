# Project Discovery Workflow

> Framework Version: 7.0.0
> Purpose: Turn a project idea into a coherent, documented, implementation-ready direction.

---

## When To Use

Use this workflow before implementation when the user is:

- starting a new project;
- defining or revising an MVP;
- describing a business/product idea;
- deciding backend, stack, cost model, legal direction, Git strategy, or team workflow;
- changing project direction in a way that affects scope or architecture.

## Agents

| Phase | Agent | Responsibility |
|---|---|---|
| 1 | Orchestrator | Detect discovery need and load the conditional discovery group |
| 2 | Researcher | Explore domain, market, feasibility, legal/IP signals, and technical constraints |
| 3 | Planner | Structure use cases, business rules, MVP boundaries, and decision options |
| 4 | UI/UX Specialist | Clarify user journeys and experience expectations when the product is user-facing |
| 5 | Platform Guardian | Check platform, deployment, hosting, and integration constraints |
| 6 | Documentation | Maintain the living discovery report and decision log |
| 7 | Project Manager | Track scope, cost, risks, readiness, and operator alignment |
| 8 | Delivery | Prepare Git/repository guidance when the operator confirms the direction |

## Flow

1. Classify the request as project discovery.
2. Load only the `discovery` conditional group plus normal tier context.
3. Ask for the product story in the operator's own words.
4. Extract facts, assumptions, risks, and open questions.
5. Interrogate each discovery domain.
6. Present decisions with pros, cons, costs, risks, and recommended defaults.
7. Update the Project Discovery Report after meaningful answers.
8. Record direction-changing choices in the decision log.
9. Run the readiness gate.
10. Ask for operator confirmation before moving into implementation planning.

## Questioning Style

- Ask clear questions in Portuguese when the operator speaks Portuguese.
- Keep internal definitions and generated technical artifacts in English.
- Use one question at a time for immature ideas.
- Use grouped checklists only when the operator already has a mature brief.
- Do not overwhelm the operator with all domains at once.
- Preserve momentum: summarize what is known, then ask the next highest-value question.

## Minimum Output

The workflow must produce:

- a Project Discovery Report;
- a decision log when direction changes occur;
- an MVP boundary;
- a risk list with mitigations;
- a Git/workspace recommendation;
- an implementation readiness status.

## Completion Criteria

Discovery is complete when:

- the operator confirms the product direction;
- the main user journey and alternate paths are documented;
- backend, data, integration, cost, legal/IP, and workspace assumptions are documented;
- MVP and deferred scope are separated;
- risks and open questions are accepted;
- Planner can create an implementation plan without inventing business context.




