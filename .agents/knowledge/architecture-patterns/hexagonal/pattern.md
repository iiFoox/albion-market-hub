# Hexagonal Architecture (Ports & Adapters)

> **Type:** Application architecture pattern
> **Also known as:** Ports & Adapters, Onion Architecture
> **Created by:** Alistair Cockburn, 2005

---

## Overview

Hexagonal Architecture isolates the application core from external concerns by defining **Ports** (interfaces the application exposes or requires) and **Adapters** (implementations that connect to actual infrastructure).

```
              ┌─────────────────────────────┐
              │         Adapters             │
              │  ┌───────────────────────┐  │
   REST ──────│──│     PORTS (IN)        │  │
   GraphQL ───│──│  (Driving/Primary)    │  │
   CLI ───────│──│                       │  │
              │  │  ┌─────────────────┐  │  │
              │  │  │   APPLICATION   │  │  │
              │  │  │     CORE        │  │  │
              │  │  │  (Domain Logic) │  │  │
              │  │  └─────────────────┘  │  │
              │  │                       │  │
              │  │     PORTS (OUT)       │──│──── Database
              │  │  (Driven/Secondary)   │──│──── Email Service
              │  │                       │──│──── Payment Gateway
              │  └───────────────────────┘  │
              └─────────────────────────────┘
```

## Core Concepts

| Concept | Role | Example |
|---|---|---|
| **Port (IN)** | Interface that DRIVES the application | `CreateOrderUseCase` interface |
| **Port (OUT)** | Interface that the application NEEDS | `OrderRepository` interface |
| **Adapter (IN)** | Implementation that calls IN ports | REST Controller, CLI command |
| **Adapter (OUT)** | Implementation that fulfills OUT ports | PostgreSQL Repository, Stripe client |
| **Application Core** | Domain logic, use cases, entities | `Order.create()`, business rules |

## Folder Structure (TypeScript)

```
src/
├── core/                          # Application core (NO external dependencies)
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── Order.ts          # Rich domain entity
│   │   │   └── User.ts
│   │   ├── value-objects/
│   │   │   └── Money.ts
│   │   └── events/
│   │       └── OrderCreated.ts
│   │
│   ├── ports/
│   │   ├── in/                    # Driving ports (USE CASE interfaces)
│   │   │   ├── CreateOrder.ts    # Interface: what the app CAN DO
│   │   │   └── GetUserOrders.ts
│   │   └── out/                   # Driven ports (INFRASTRUCTURE interfaces)
│   │       ├── OrderRepository.ts # Interface: what the app NEEDS
│   │       ├── PaymentGateway.ts
│   │       └── NotificationSender.ts
│   │
│   └── application/               # Use case implementations
│       ├── CreateOrderService.ts  # Implements CreateOrder port
│       └── GetUserOrdersService.ts
│
├── adapters/
│   ├── in/                        # Driving adapters
│   │   ├── http/
│   │   │   ├── OrderController.ts # REST adapter → calls CreateOrder port
│   │   │   └── routes.ts
│   │   ├── graphql/
│   │   │   └── OrderResolver.ts   # GraphQL adapter → calls same port
│   │   └── cli/
│   │       └── CreateOrderCLI.ts  # CLI adapter → calls same port
│   │
│   └── out/                       # Driven adapters
│       ├── persistence/
│       │   ├── PrismaOrderRepository.ts  # Implements OrderRepository port
│       │   └── InMemoryOrderRepository.ts # For testing
│       ├── payment/
│       │   ├── StripePaymentGateway.ts   # Implements PaymentGateway port
│       │   └── MockPaymentGateway.ts     # For testing
│       └── notification/
│           ├── SendGridNotificationSender.ts
│           └── ConsoleNotificationSender.ts  # For development
│
└── config/
    └── dependency-injection.ts    # Wires adapters to ports
```

## Key Advantage: Testability

```typescript
// Test with mock adapters — no database, no APIs, no external services
describe('CreateOrderService', () => {
  it('should create order and process payment', async () => {
    // Use in-memory/mock adapters
    const orderRepo = new InMemoryOrderRepository();
    const paymentGw = new MockPaymentGateway();
    const notifier = new ConsoleNotificationSender();
    
    const service = new CreateOrderService(orderRepo, paymentGw, notifier);
    
    const order = await service.execute({ userId: 'user-1', items: [...] });
    
    expect(order.status).toBe('confirmed');
    expect(orderRepo.findById(order.id)).toBeDefined();
    expect(paymentGw.charges).toHaveLength(1);
  });
});
```

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Multiple input channels (REST + GraphQL + CLI + Queue) | Single input channel |
| Need to swap infrastructure easily (change DB, payment provider) | Infrastructure is fixed |
| High testability requirement | Quick prototype |
| Long-lived application | Throwaway project |
| Complex domain logic worth protecting | Simple CRUD |

## vs Clean Architecture

| Aspect | Hexagonal | Clean Architecture |
|---|---|---|
| Focus | Ports & Adapters (interfaces) | Concentric layers |
| Terminology | Ports, Adapters, Core | Entities, Use Cases, Controllers |
| Direction | Inside-out (core drives) | Inside-out (same) |
| Practical difference | Almost identical — different vocabulary |

Both are great. Choose based on team familiarity.
