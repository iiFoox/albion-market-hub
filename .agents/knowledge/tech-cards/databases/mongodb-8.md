# MongoDB 8 — Tech Card

> **Category:** NoSQL Document Database
> **Current Version:** 8.x
> **Type:** Document store (BSON/JSON)

---

## Quick Setup (Docker)
```bash
docker run -d --name mongo -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=secret mongo:8
```

## When to Use MongoDB vs PostgreSQL

| Choose MongoDB | Choose PostgreSQL |
|---|---|
| Schema varies per document | Schema is well-defined and stable |
| Nested/hierarchical data (embedded docs) | Heavily relational data (many JOINs) |
| Rapid prototyping (schemaless) | ACID transactions across tables |
| Horizontal scaling (sharding) | Vertical scaling sufficient |
| Document-oriented queries | Complex SQL queries, CTEs, window functions |
| High write throughput | Strong consistency requirements |

## Top 10 Best Practices

1. **Design for queries** — model data based on how you READ, not how it's structured
2. **Embed when data is accessed together** — `order.items[]` not separate collections
3. **Reference when data is shared** — `userId` reference, not embedded user copy
4. **Use schema validation** — `db.createCollection()` with JSON Schema validator
5. **Index every query** — `explain()` should show IXSCAN, not COLLSCAN
6. **Use compound indexes** — order matters: ESR rule (Equality, Sort, Range)
7. **Use `$lookup` sparingly** — it's a LEFT JOIN; if you need many, use PostgreSQL instead
8. **Use `ObjectId` for `_id`** — built-in timestamp, sortable, unique
9. **Limit document size** — max 16MB per document; if close, redesign
10. **Use transactions for multi-doc updates** — v4.0+ supports multi-document ACID

## Top 10 Gotchas

1. ❌ **No JOINs natively** — `$lookup` is limited; embed related data instead
2. ❌ **ObjectId is NOT a string** — compare with `new ObjectId(id)`, not string equality
3. ❌ **Missing indexes = full collection scan** — fatal at scale
4. ❌ **Schema drift** — without validation, documents diverge over time
5. ❌ **Unbounded arrays** — array growing without limit = poor performance
6. ❌ **Case-sensitive queries** — `"John"` ≠ `"john"`; use collation or regex
7. ❌ **No default transactions** — operations are atomic per document, NOT per query
8. ❌ **Large documents** — 16MB limit; large arrays cause rewriting entire doc on update
9. ❌ **Write concern `w:0`** — fire-and-forget; data may be lost
10. ❌ **Blocking migrations** — index creation blocks writes; use `{ background: true }`

## Data Modeling Patterns

### Embedded (One-to-Few)
```javascript
// ✅ Good: order with items (always accessed together)
{
  _id: ObjectId("..."),
  userId: ObjectId("..."),
  items: [
    { productId: ObjectId("..."), name: "Widget", quantity: 2, price: 29.90 },
    { productId: ObjectId("..."), name: "Gadget", quantity: 1, price: 49.90 }
  ],
  total: 109.70,
  status: "confirmed"
}
```

### Referenced (One-to-Many, Many-to-Many)
```javascript
// ✅ Good: user references (user belongs to many orders)
// orders collection
{ _id: ObjectId("..."), userId: ObjectId("user-123"), total: 109.70 }

// Application-level join
const orders = await db.orders.find({ userId: user._id });
```

### Bucket Pattern (Time-Series)
```javascript
// Instead of one doc per event, bucket by hour
{
  sensorId: "temp-001",
  date: ISODate("2026-04-05T12:00:00Z"),
  readings: [
    { time: ISODate("2026-04-05T12:01:00Z"), value: 22.5 },
    { time: ISODate("2026-04-05T12:02:00Z"), value: 22.6 },
    // ... up to 60 readings per bucket (1 per minute)
  ],
  count: 60
}
```

## Index Strategy
```javascript
// Single field
db.users.createIndex({ email: 1 }, { unique: true });

// Compound (ESR: Equality, Sort, Range)
db.orders.createIndex({ status: 1, createdAt: -1, total: 1 });

// Text search
db.products.createIndex({ name: "text", description: "text" });

// TTL (auto-delete after expiry)
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 86400 });

// Partial (index subset)
db.orders.createIndex({ status: 1 }, { partialFilterExpression: { status: "active" } });
```
