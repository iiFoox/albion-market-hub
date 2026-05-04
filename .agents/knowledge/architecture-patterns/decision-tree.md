# Architecture Decision Tree

> **Usage:** Loaded by the Planner to select the correct architecture pattern for a project.

---

## Quick Decision Flow

```
START: What kind of system?
│
├── Single application, < 5 devs?
│   ├── Simple CRUD, < 10 entities? → MVC / Layered Architecture (no pattern needed)
│   ├── Complex domain logic? → Clean Architecture or Hexagonal
│   └── Growing team, future microservices? → Modular Monolith
│
├── Distributed system, 5+ devs?
│   ├── Teams need independent deployment? → Microservices
│   ├── Need async processing? → Event-Driven + Microservices
│   └── Audit trail mandatory? → CQRS + Event Sourcing
│
├── Cloud-native, variable workload?
│   ├── Pay-per-use important? → Serverless
│   ├── Event processing (IoT, streaming)? → Event-Driven + Serverless
│   └── Need containers? → Microservices + Kubernetes
│
└── Complex business domain?
    ├── Rich business rules? → DDD Tactical + Clean/Hexagonal
    ├── Separate read/write needs? → CQRS
    └── Full auditability? → Event Sourcing + CQRS
```

## Detailed Comparison Matrix

| Criterion | Clean Architecture | Hexagonal | Modular Monolith | Microservices | Event-Driven | CQRS + ES | Serverless | DDD |
|---|---|---|---|---|---|---|---|---|
| **Team Size** | 2-10 | 2-10 | 3-15 | 5-50+ | 5-30+ | 3-15 | 1-10 | 3-15 |
| **Complexity** | Medium | Medium | Medium | High | High | Very High | Low-Med | High |
| **Learning Curve** | Medium | Medium | Low-Med | High | Medium | High | Low | High |
| **Testability** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Scalability** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Ops Overhead** | Low | Low | Low | Very High | High | High | Very Low | Low |
| **Best For** | Testable apps | Multi-interface | Growing apps | Large orgs | High throughput | Audit/Finance | Variable load | Complex domains |

## Combination Patterns

Common pattern combinations:

| Combination | When |
|---|---|
| **Clean + DDD** | Complex domain + high testability |
| **Microservices + Event-Driven** | Large distributed system |
| **Microservices + CQRS** | Scale reads independently per service |
| **Modular Monolith + DDD** | Growing domain, not yet microservices |
| **Serverless + Event-Driven** | Cloud-native event processing |
| **Hexagonal + DDD** | Same as Clean + DDD (different vocabulary) |

## Anti-Patterns to Avoid

| Anti-Pattern | Why It's Wrong |
|---|---|
| **Microservices from day 1** | Premature complexity; start with modular monolith |
| **Event Sourcing for everything** | 99% of apps don't need it; use only for audit-critical |
| **CQRS for simple CRUD** | Adds complexity with zero benefit for simple apps |
| **Clean Architecture for a TODO app** | Overkill; use simple MVC |
| **Serverless for consistent high load** | EC2/containers are cheaper for 24/7 high traffic |
| **DDD without domain experts** | You'll create a wrong model; need collaboration |

## Decision for the Planner

```
BEFORE CHOOSING, ANSWER:
1. How complex is the business domain? (1-5)
2. How large is the team? (number)
3. Does it need independent deployment of parts? (yes/no)
4. Is audit trail mandatory? (yes/no)
5. Is the workload variable or constant? (variable/constant)
6. What is the expected lifetime? (< 1 year / 1-3 years / 3+ years)
7. Are there multiple input channels? (REST only / REST + mobile + CLI + events)

THEN MAP TO PATTERN using the decision flow above.
ALWAYS DOCUMENT the decision in an ADR (Architecture Decision Record).
```
