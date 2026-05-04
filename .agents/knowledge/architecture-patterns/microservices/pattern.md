# Microservices Architecture

> **Type:** Distributed System Architecture
> **Best For:** Large teams, high-scale, independent deployability

---

## Overview

Microservices decomposes an application into small, independently deployable services, each owning its own data and communicating via APIs or events. Each service is built, deployed, and scaled independently.

```
                    ┌─────────────┐
                    │  API Gateway │
                    └──────┬──────┘
              ┌────────────┼────────────┐
              ▼            ▼            ▼
       ┌──────────┐ ┌──────────┐ ┌──────────┐
       │  User    │ │  Order   │ │  Product  │
       │  Service │ │  Service │ │  Service  │
       └────┬─────┘ └────┬─────┘ └────┬─────┘
            │            │            │
       ┌────┴─────┐ ┌────┴─────┐ ┌────┴─────┐
       │ User DB  │ │ Order DB │ │Product DB│
       └──────────┘ └──────────┘ └──────────┘
              ▲            ▲            ▲
              └────────────┼────────────┘
                    ┌──────┴──────┐
                    │ Message Bus │  (Events)
                    └─────────────┘
```

## Core Principles

1. **Single Responsibility** — each service does ONE thing well
2. **Database per Service** — no shared databases between services
3. **API-First Communication** — services communicate via well-defined APIs
4. **Independent Deployment** — change one service without redeploying others
5. **Decentralized Governance** — each team chooses its own tech stack
6. **Design for Failure** — assume any service can fail at any time

## Service Boundaries

### How to Define Service Boundaries
```
THINKING:
→ What are the bounded contexts? (DDD language)
→ Which data changes together? (cohesion)
→ Which operations need to be transactional?
→ What teams own what functionality?
→ What can be deployed independently without breaking others?
```

### Anti-Patterns in Service Boundaries
| Anti-Pattern | Problem | Fix |
|---|---|---|
| **Nano-services** | Too many tiny services (e.g., one per table) | Merge related services |
| **Distributed Monolith** | All services deploy together | Reduce synchronous coupling |
| **Shared Database** | Services share DB tables | Database per service |
| **God Service** | One service does everything | Decompose by bounded context |

## Communication Patterns

### Synchronous (Request-Response)
| Pattern | When | Example |
|---|---|---|
| REST | CRUD, simple queries | `GET /api/users/123` |
| gRPC | Low latency, internal services | Service-to-service calls |
| GraphQL | BFF (Backend-for-Frontend) | Mobile app aggregation |

### Asynchronous (Event-Driven)
| Pattern | When | Example |
|---|---|---|
| Events (fire-and-forget) | Notifications, logging | `OrderCreated` event |
| Commands (request-async) | Long-running operations | `ProcessPayment` command |
| Saga | Distributed transactions | Order → Payment → Shipping |
| CQRS | Read/write optimization | Separate read models |

## Data Management

### Saga Pattern (Distributed Transactions)
```
Choreography Saga:
Order Service ──publish──→ OrderCreated
                              │
Payment Service ←──listen────┘
     │ ──publish──→ PaymentCompleted
                         │
Shipping Service ←──listen┘
     │ ──publish──→ ShipmentCreated

Compensation (if Payment fails):
Payment Service ──publish──→ PaymentFailed
                                  │
Order Service ←──listen──────────┘
     │ ──cancel──→ OrderCancelled (compensating transaction)
```

## Essential Infrastructure

| Component | Purpose | Options |
|---|---|---|
| **API Gateway** | Single entry point, routing, auth | Kong, Traefik, AWS API Gateway |
| **Service Discovery** | Find service instances | Consul, Kubernetes DNS |
| **Message Broker** | Async communication | RabbitMQ, Kafka, AWS SQS |
| **Config Server** | Centralized configuration | Spring Cloud Config, Consul |
| **Circuit Breaker** | Failure isolation | Resilience4j, Polly, opossum |
| **Distributed Tracing** | Request tracking across services | Jaeger, Zipkin, AWS X-Ray |
| **Centralized Logging** | Aggregate logs from all services | ELK Stack, Loki, CloudWatch |
| **Container Orchestration** | Deployment, scaling | Kubernetes, Docker Swarm, ECS |

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Team has 5+ engineers in independent squads | Team has < 5 developers |
| Different parts scale independently | Uniform load across all features |
| Need polyglot tech stack | Single tech stack sufficient |
| CI/CD maturity is high | No CI/CD pipeline exists |
| Application has clear bounded contexts | Domain boundaries are unclear |
| Need independent deployability | Startup/MVP phase |

## Common Mistakes

1. **Starting with microservices** — build a modular monolith first, then extract
2. **Shared databases** — this creates the distributed monolith anti-pattern
3. **Synchronous chains** — A calls B calls C calls D = fragile + slow
4. **No circuit breakers** — one failing service cascades to all
5. **Ignoring data consistency** — eventual consistency requires explicit handling
6. **No observability** — without tracing/logging, debugging is impossible
7. **Over-decomposition** — 50 services for a 10-feature app is madness

## Migration Strategy: Strangler Fig

```
Phase 1: Identify boundary → Extract one service
Phase 2: Route traffic → New service handles its domain
Phase 3: Repeat → Extract next service
Phase 4: Retire monolith → All traffic on services

KEY RULE: Never do a "big bang" migration. One service at a time.
```
