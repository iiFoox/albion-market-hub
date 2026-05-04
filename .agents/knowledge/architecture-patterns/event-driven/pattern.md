# Event-Driven Architecture

> **Type:** Asynchronous, loosely-coupled communication pattern
> **Best For:** High throughput, decoupled systems, real-time processing

---

## Overview

Event-Driven Architecture (EDA) centers on producing, detecting, consuming, and reacting to events. Components communicate through events rather than direct calls, enabling loose coupling and high scalability.

```
┌──────────┐    Event     ┌──────────────┐    Event     ┌──────────┐
│ Producer │───────────→  │  Event Bus   │───────────→  │ Consumer │
│ (Order)  │              │ (Kafka/RMQ)  │              │ (Email)  │
└──────────┘              └──────┬───────┘              └──────────┘
                                 │
                                 │  Event
                                 ▼
                          ┌──────────┐
                          │ Consumer │
                          │(Analytics│
                          └──────────┘
```

## Core Concepts

| Concept | Description |
|---|---|
| **Event** | Immutable fact that something happened: `OrderCreated`, `PaymentFailed` |
| **Producer** | Publishes events when state changes |
| **Consumer** | Subscribes to events and reacts to them |
| **Event Bus/Broker** | Middleware that routes events (Kafka, RabbitMQ, AWS SNS/SQS) |
| **Event Store** | Persistent log of all events (for event sourcing) |

## Event Types

### 1. Domain Events
Business-relevant state changes:
```typescript
interface OrderCreatedEvent {
  type: 'order.created';
  data: {
    orderId: string;
    userId: string;
    items: OrderItem[];
    total: number;
  };
  metadata: {
    timestamp: string;
    correlationId: string;
    version: 1;
  };
}
```

### 2. Integration Events
Cross-service communication:
```typescript
// Published by Order Service, consumed by Shipping Service
interface OrderReadyForShipmentEvent {
  type: 'order.ready_for_shipment';
  data: { orderId: string; address: Address; };
}
```

### 3. Notification Events
Fire-and-forget notifications:
```typescript
interface UserRegisteredEvent {
  type: 'user.registered';
  data: { userId: string; email: string; name: string; };
}
// Consumed by: Email service, Analytics, CRM integration
```

## Patterns

### Event Notification
Producer publishes event, doesn't care who consumes:
- ✅ Loose coupling
- ❌ No response — producer doesn't know if consumer processed

### Event-Carried State Transfer
Event contains all data needed by consumers:
- ✅ Consumers don't need to call back to producer
- ❌ Events can be large

### Event Sourcing
Store ALL events as source of truth:
- ✅ Complete audit trail, time-travel debugging
- ❌ Complex to implement, eventual consistency

## Technology Comparison

| Broker | Best For | Throughput | Ordering | Persistence |
|---|---|---|---|---|
| **Apache Kafka** | High throughput, event sourcing, streaming | Very High (1M+/s) | Per partition | Yes (log-based) |
| **RabbitMQ** | Task queues, routing, RPC | High (50K/s) | Per queue | Optional |
| **AWS SQS/SNS** | Serverless, managed | High | FIFO available | Yes |
| **Redis Streams** | Low latency, caching | Very High | Per stream | Yes |
| **NATS** | Lightweight, cloud-native | Very High | Per subject | JetStream |

## Event Schema Best Practices

```typescript
// GOOD: Versioned, immutable, self-describing
{
  id: "evt-550e8400-e29b-41d4-a716-446655440000",
  type: "order.created",
  version: 1,
  timestamp: "2026-04-05T15:00:00.000Z",
  source: "order-service",
  correlationId: "req-abc-123",
  data: {
    orderId: "order-789",
    userId: "user-123",
    total: 299.90
  }
}
```

### Schema Evolution Rules
1. **Add fields** — always safe (consumers ignore unknown fields)
2. **Remove fields** — BREAKING (deprecate first, remove in next major version)
3. **Rename fields** — BREAKING (add new field, deprecate old one)
4. **Change types** — BREAKING (create new event version)

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Systems need loose coupling | Request-response is sufficient |
| High throughput processing (10K+ events/s) | Low traffic, simple CRUD |
| Multiple consumers for same event | Only one consumer per event |
| Audit trail / event history needed | History is not important |
| Real-time processing required | Batch processing is fine |
| Services evolve independently | Tight coordination required |

## Common Mistakes

1. **Using events for synchronous workflows** — if you need a response, use request/response
2. **Not handling duplicate events** — consumers must be idempotent
3. **No schema registry** — without schema management, breaking changes are inevitable
4. **Giant events** — events should contain necessary data, not entire entity dumps
5. **Missing dead letter queue** — failed events must go somewhere for investigation
6. **No correlation ID** — without it, tracing a request across services is impossible
7. **Ignoring ordering** — some events must be processed in order (Kafka partitions solve this)
