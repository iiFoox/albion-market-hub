# REST API Best Practices

> **Category:** Builder / API Design
> **Usage:** Reference for designing production-quality REST APIs

---

## URL Design

```
RULES:
→ Use nouns, not verbs: /users (not /getUsers)
→ Use plural: /orders (not /order)
→ Use kebab-case: /order-items (not /orderItems)
→ Nest for relationships: /users/123/orders
→ Max 2 levels of nesting: /users/123/orders (not /users/123/orders/456/items/789)
→ Use query params for filtering: /orders?status=active&sort=-createdAt
```

## HTTP Methods & Status Codes

| Method | Action | Success | Error |
|---|---|---|---|
| `GET /resources` | List | 200 + array | 400 (bad params) |
| `GET /resources/:id` | Get one | 200 + object | 404 |
| `POST /resources` | Create | 201 + object + Location header | 400/409/422 |
| `PUT /resources/:id` | Full update | 200 + object | 400/404 |
| `PATCH /resources/:id` | Partial update | 200 + object | 400/404 |
| `DELETE /resources/:id` | Delete | 204 (no body) | 404 |

## Response Format (Standard)

```typescript
// Success response
{
  "data": { ... },                    // Single object or array
  "meta": {                           // Pagination/extra info
    "total": 150,
    "page": 1,
    "perPage": 20,
    "totalPages": 8,
    "hasMore": true
  }
}

// Error response
{
  "error": {
    "code": "VALIDATION_ERROR",       // Machine-readable code
    "message": "Validation failed",   // Human-readable message
    "details": [                      // Field-level errors
      { "field": "email", "message": "Invalid email format" },
      { "field": "name", "message": "Name is required" }
    ],
    "requestId": "req-abc-123"        // For support tracking
  }
}
```

## Pagination (Cursor-based)

```typescript
// Request
GET /api/orders?cursor=eyJpZCI6MTAwfQ&limit=20

// Response
{
  "data": [...],
  "meta": {
    "hasMore": true,
    "nextCursor": "eyJpZCI6MTIwfQ",  // Base64 encoded cursor
    "prevCursor": "eyJpZCI6ODB9"
  }
}

// Implementation
async function listOrders(cursor?: string, limit = 20) {
  const decodedCursor = cursor ? JSON.parse(Buffer.from(cursor, 'base64url').toString()) : null;
  
  const items = await db.order.findMany({
    where: decodedCursor ? { id: { gt: decodedCursor.id } } : undefined,
    orderBy: { id: 'asc' },
    take: limit + 1, // +1 to check if there's more
  });

  const hasMore = items.length > limit;
  const data = hasMore ? items.slice(0, limit) : items;
  const nextCursor = hasMore
    ? Buffer.from(JSON.stringify({ id: data[data.length - 1].id })).toString('base64url')
    : null;

  return { data, meta: { hasMore, nextCursor } };
}
```

## Filtering, Sorting, Fields

```
# Filtering
GET /orders?status=active&minTotal=100&createdAfter=2026-01-01

# Sorting (- for desc)
GET /orders?sort=-createdAt,total

# Field selection (sparse fieldsets)
GET /orders?fields=id,status,total

# Search
GET /products?search=wireless+headphones
```

## Versioning Strategies

| Strategy | URL | Header |
|---|---|---|
| **URL prefix** (recommended) | `/api/v1/users` | Simple, cacheable |
| **Header** | `Accept: application/vnd.myapi.v1+json` | Clean URLs, harder to test |
| **Query param** | `/users?version=1` | Not recommended |

## Idempotency

```typescript
// POST requests should support idempotency keys
// Client sends: Idempotency-Key: <unique-key>

app.post('/api/orders', async (req, res) => {
  const idempotencyKey = req.headers['idempotency-key'];

  if (idempotencyKey) {
    const existing = await redis.get(`idempotency:${idempotencyKey}`);
    if (existing) return res.status(200).json(JSON.parse(existing));
  }

  const order = await createOrder(req.body);

  if (idempotencyKey) {
    await redis.setex(`idempotency:${idempotencyKey}`, 86400, JSON.stringify(order));
  }

  return res.status(201).json(order);
});
```

## HATEOAS (Hypermedia)

```json
{
  "data": {
    "id": "order-123",
    "status": "confirmed",
    "total": 299.90
  },
  "links": {
    "self": "/api/v1/orders/order-123",
    "cancel": "/api/v1/orders/order-123/cancel",
    "items": "/api/v1/orders/order-123/items",
    "user": "/api/v1/users/user-456"
  }
}
```
