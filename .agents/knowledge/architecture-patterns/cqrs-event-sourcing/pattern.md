# CQRS + Event Sourcing

> **Type:** Data architecture pattern for complex domains
> **Best For:** Audit-critical systems, high-read/low-write ratio, complex business logic

---

## Overview

**CQRS** (Command Query Responsibility Segregation) separates read and write models. **Event Sourcing** stores state as a sequence of events instead of current state.

```
                WRITE SIDE                          READ SIDE
┌─────────────────────────────┐     ┌─────────────────────────────┐
│       Command Handler       │     │        Query Handler        │
│  (validates & creates event)│     │   (reads from read model)   │
└──────────────┬──────────────┘     └──────────────▲──────────────┘
               │                                    │
               ▼                                    │
┌──────────────────────────────┐    ┌───────────────┴──────────────┐
│         Event Store          │───►│     Read Model (Projection)  │
│  (append-only event log)     │    │  (denormalized, fast queries) │
└──────────────────────────────┘    └──────────────────────────────┘
```

## CQRS Without Event Sourcing

You can use CQRS without Event Sourcing — just separate read and write models:

```typescript
// WRITE SIDE: Command
class CreateOrderCommand {
  constructor(
    public readonly userId: string,
    public readonly items: OrderItem[],
  ) {}
}

class CreateOrderHandler {
  async handle(command: CreateOrderCommand): Promise<string> {
    const order = Order.create(command.userId, command.items);
    await this.writeDb.orders.save(order);  // Write to normalized DB
    return order.id;
  }
}

// READ SIDE: Query
class GetOrderSummaryQuery {
  constructor(public readonly orderId: string) {}
}

class GetOrderSummaryHandler {
  async handle(query: GetOrderSummaryQuery): Promise<OrderSummaryDTO> {
    // Read from denormalized read model (optimized for this exact query)
    return this.readDb.orderSummaries.findById(query.orderId);
  }
}
```

## Event Sourcing

Instead of storing current state, store the sequence of events that produced it:

```typescript
// Traditional: Store current state
// { id: "order-1", status: "shipped", total: 299.90 }

// Event Sourcing: Store events
[
  { type: "OrderCreated", data: { orderId: "order-1", items: [...], total: 299.90 }, version: 1 },
  { type: "PaymentReceived", data: { orderId: "order-1", paymentId: "pay-1" }, version: 2 },
  { type: "OrderShipped", data: { orderId: "order-1", trackingId: "TRK-123" }, version: 3 },
]

// Current state = replay all events
function rehydrate(events: Event[]): Order {
  let order = new Order();
  for (const event of events) {
    order = order.apply(event);  // Each event modifies state
  }
  return order;
}
```

## Projections (Read Models)

Events are projected into read-optimized views:

```typescript
class OrderDashboardProjection {
  // Listens to events and builds a denormalized read model
  async on(event: OrderCreatedEvent) {
    await this.readDb.dashboardOrders.insert({
      orderId: event.data.orderId,
      customerName: event.data.customerName,
      total: event.data.total,
      status: 'pending',
      createdAt: event.metadata.timestamp,
    });
  }

  async on(event: OrderShippedEvent) {
    await this.readDb.dashboardOrders.update(
      { orderId: event.data.orderId },
      { status: 'shipped', shippedAt: event.metadata.timestamp }
    );
  }
}
```

## Key Benefits

| Benefit | Impact |
|---|---|
| **Complete audit trail** | Every change is recorded — perfect for financial/legal |
| **Time travel** | Replay events to any point in time — debug past states |
| **Multiple read models** | Same events → dashboard view, report view, analytics view |
| **Scale reads independently** | Read model can be Redis, Elasticsearch, etc. |
| **Retroactive projections** | Add a new read model and replay all history |

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Audit trail is mandatory (finance, healthcare, legal) | Simple CRUD with no audit needs |
| Read and write patterns are very different | Read and write are similar |
| Domain has complex business rules with events | Simple data storage |
| Need multiple read optimizations | Single read pattern |
| High-read, low-write ratio | Balanced read/write |
| Need to answer "what was the state at time X?" | Current state is sufficient |

## Common Mistakes

1. **Using ES for simple CRUD** — enormous overhead for no benefit
2. **Not handling event versioning** — events evolve; have a schema migration strategy 
3. **Ignoring eventual consistency** — read model may lag behind write model
4. **Giant aggregates** — too many events make rehydration slow (use snapshots)
5. **Not storing metadata** — correlation ID, timestamp, causation ID are essential
6. **Mutable events** — events are IMMUTABLE; never modify stored events
