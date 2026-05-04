# Governance Framework — Project Manager

> **Category:** Project Manager / Governance
> **Usage:** Formal quality gates, definitions, and processes for enterprise-grade project management

---

## 1. Definition of Done (DoD)

### Code Level
- [ ] Code compiles/builds without errors
- [ ] All unit tests pass
- [ ] Code follows project conventions (linting passes)
- [ ] No new warnings introduced
- [ ] TypeScript strict mode — zero `any` types
- [ ] Error handling covers all failure paths
- [ ] Logging added for key operations

### Quality Level
- [ ] Code reviewed by at least 1 peer
- [ ] Security audit completed (OWASP checklist)
- [ ] Test coverage >= 80% for new code
- [ ] No regressions (existing tests still pass)
- [ ] Performance within accepted baselines

### Documentation Level
- [ ] Public APIs documented (JSDoc/docstring)
- [ ] Complex logic has inline comments explaining WHY
- [ ] Changelog updated
- [ ] ADR created for architectural decisions

### Deployment Level
- [ ] CI/CD pipeline passes all stages
- [ ] Feature works in staging environment
- [ ] Rollback plan documented
- [ ] Monitoring/alerts configured for new endpoints

---

## 2. Definition of Ready (DoR)

A task is ready for implementation when:

- [ ] **Clear acceptance criteria** — GIVEN/WHEN/THEN format
- [ ] **Scope defined** — what's IN scope and OUT of scope
- [ ] **Dependencies identified** — external services, libraries, APIs
- [ ] **Design approved** — ADR or design doc reviewed (if architectural)
- [ ] **Estimated** — complexity assessed (S/M/L/XL)
- [ ] **Testable** — criteria can be verified with automated tests
- [ ] **No blockers** — all questions answered, all dependencies available

---

## 3. Quality Gates by Phase

### Gate 1: Planning Complete
```
BEFORE STARTING IMPLEMENTATION:
□ Requirements are clear and written
□ Tech approach approved (ADR if needed)
□ Acceptance criteria defined
□ Risks identified and mitigated
□ Effort estimated
```

### Gate 2: Implementation Complete
```
BEFORE REQUESTING REVIEW:
□ All acceptance criteria met
□ Tests written and passing
□ Self-review done (Builder self-evaluation)
□ Linting passes
□ No TODO/FIXME left unresolved
```

### Gate 3: Review Complete
```
BEFORE MERGING:
□ Code review approved (min 1 reviewer)
□ Security review passed (Validator audit)
□ No open comments/questions
□ CI pipeline green
□ Documentation updated
```

### Gate 4: Deployment Complete
```
BEFORE CLOSING TASK:
□ Deployed to staging successfully
□ Smoke tests pass in staging
□ Deployed to production
□ Monitoring confirms normal behavior (15 min)
□ Rollback plan verified
□ Changelog and docs published
```

---

## 4. Risk Scoring Model

### Probability × Impact Matrix

```
         │  Low Impact  │ Medium Impact │ High Impact  │
─────────┼──────────────┼───────────────┼──────────────┤
High Prob │   MEDIUM     │    HIGH       │   CRITICAL   │
Med Prob  │   LOW        │    MEDIUM     │   HIGH       │
Low Prob  │   LOW        │    LOW        │   MEDIUM     │
```

### Risk Response Strategies
| Strategy | When | Example |
|---|---|---|
| **Mitigate** | Can reduce probability or impact | Add retry logic for transient failures |
| **Accept** | Low risk, cost of mitigation > benefit | Minor UI inconsistency on rare browser |
| **Transfer** | Someone else handles better | Use managed DB (AWS RDS) vs self-hosted |
| **Avoid** | Eliminate the risk entirely | Choose proven tech stack vs experimental |

---

## 5. KPI Dashboard

### Delivery KPIs
| KPI | Target | How to Measure |
|---|---|---|
| Lead Time | < 3 days (feature request → production) | Git: first commit → deploy timestamp |
| Cycle Time | < 1 day (start work → code merged) | Git: branch creation → merge |
| Deployment Frequency | Daily or more | CI/CD: deploy count per day |
| Change Failure Rate | < 15% | Deploys requiring rollback / total deploys |
| MTTR | < 1 hour | Incident start → resolution |

### Quality KPIs
| KPI | Target | How to Measure |
|---|---|---|
| Test Coverage | > 80% | CI: Jest/Vitest coverage report |
| Bug Escape Rate | < 5% | Bugs found in prod / total bugs |
| First-Attempt Pass Rate | > 80% | Pipeline: quality gate pass on first try |
| Security Vulnerabilities | 0 critical, < 5 high | npm audit + security scan |

### Framework KPIs (HEPHAESTUS-specific)
| KPI | Target | How to Measure |
|---|---|---|
| Pipeline Correction Loops | < 20% | Telemetry: loops / total pipelines |
| Memory Reuse Rate | > 40% | Telemetry: queries returning results |
| Agent Self-Eval Accuracy | > 85% | PM: predicted vs actual participation |
| Knowledge Base Growth | +5 entries/week | Evolution log: new entries count |

---

## 6. Escalation Matrix

| Severity | Definition | Response Time | Escalate To |
|---|---|---|---|
| **P1 Critical** | System down, data loss, security breach | 15 minutes | CTO + all hands |
| **P2 High** | Major feature broken, no workaround | 1 hour | Tech Lead |
| **P3 Medium** | Feature degraded, workaround exists | 4 hours | Senior Engineer |
| **P4 Low** | Minor issue, cosmetic, enhancement | Next sprint | Backlog |

---

## 7. Change Management

```
WHEN SCOPE CHANGES:

1. DOCUMENT the change request
   → What changed? Why? Who requested?

2. ASSESS impact
   → Time: How many additional hours/days?
   → Risk: Does it introduce new risks?
   → Dependencies: Does it affect other features?
   → Quality: Can we maintain quality standards?

3. DECIDE
   → If impact < 20% of original scope → Accept (minor growth)
   → If impact 20-50% → Negotiate (reduce scope elsewhere)
   → If impact > 50% → Escalate to stakeholder for re-prioritization

4. COMMUNICATE
   → Update plan and timeline
   → Inform affected parties
   → Update memory (PM scope management)
```
