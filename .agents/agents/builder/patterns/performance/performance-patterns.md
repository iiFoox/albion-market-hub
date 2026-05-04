# Performance Patterns — Frontend & Backend

> **Category:** Builder / Performance  
> **Usage:** Reference for optimizing application performance

---

## Frontend Performance (Core Web Vitals)

### LCP (Largest Contentful Paint) — Target: < 2.5s
```
OPTIMIZATIONS:
→ Preload critical resources: <link rel="preload" as="image" href="hero.jpg">
→ Priority hints: <img fetchpriority="high">
→ Optimize images: next/image with WebP/AVIF
→ Reduce server response time (TTFB)
→ Eliminate render-blocking CSS/JS
```

### CLS (Cumulative Layout Shift) — Target: < 0.1
```
OPTIMIZATIONS:
→ Always set width/height on images and videos
→ Reserve space for dynamic content (skeleton loaders)
→ Avoid inserting content above existing content
→ Use CSS contain for isolated sections
→ Font-display: swap with size-adjusted fallback
```

### INP (Interaction to Next Paint) — Target: < 200ms
```
OPTIMIZATIONS:
→ Break long tasks (> 50ms) with scheduler.yield()
→ Debounce rapid user input
→ Use Web Workers for heavy computation
→ Virtualize long lists (@tanstack/virtual)
→ Use startTransition for non-urgent updates
```

### Code Splitting & Lazy Loading
```typescript
// Route-level splitting (React)
const Dashboard = lazy(() => import('./pages/Dashboard'));
const Settings = lazy(() => import('./pages/Settings'));

// Component-level splitting
const HeavyChart = lazy(() => import('./components/HeavyChart'));

// Next.js dynamic import
const Map = dynamic(() => import('./Map'), { 
  ssr: false,  // Client-only component
  loading: () => <Skeleton height={400} />
});
```

---

## Backend Performance

### Caching Strategy (Multi-Layer)
```
Layer 1: In-Memory (Node.js Map / LRU Cache)
→ Response time: < 1ms
→ Use for: config, small frequently-accessed data
→ Invalidation: process restart or TTL

Layer 2: Redis
→ Response time: 1-5ms
→ Use for: session, API responses, computed results
→ Invalidation: explicit delete or TTL

Layer 3: CDN (CloudFront, Vercel Edge)
→ Response time: 5-50ms
→ Use for: static assets, ISR pages, immutable API responses
→ Invalidation: cache tags or purge

Layer 4: Database Query Cache
→ Response time: 10-50ms
→ Use for: complex aggregations, reports
→ Invalidation: materialized view refresh
```

### N+1 Query Prevention
```typescript
// ❌ N+1 Problem (1 query + N queries)
const users = await db.user.findMany();
for (const user of users) {
  user.orders = await db.order.findMany({ where: { userId: user.id } }); // N queries!
}

// ✅ Eager loading (2 queries total)
const users = await db.user.findMany({
  include: { orders: true }  // Prisma: JOIN or IN query
});

// ✅ DataLoader pattern (batching) — GraphQL
const userLoader = new DataLoader(async (ids: string[]) => {
  const users = await db.user.findMany({ where: { id: { in: ids } } });
  return ids.map(id => users.find(u => u.id === id));
});
```

### Async Processing
```typescript
// ❌ Synchronous: User waits for everything
app.post('/api/orders', async (req, res) => {
  const order = await createOrder(req.body);
  await sendConfirmationEmail(order);     // 2-5 seconds!
  await updateInventory(order);            // 1-3 seconds!
  await notifyShipping(order);             // 1-2 seconds!
  res.status(201).json(order);             // Total: 4-10 seconds 😱
});

// ✅ Async: User gets instant response
app.post('/api/orders', async (req, res) => {
  const order = await createOrder(req.body);
  
  // Queue async tasks (user doesn't wait)
  await queue.add('order.confirmation-email', { orderId: order.id });
  await queue.add('order.update-inventory', { orderId: order.id });
  await queue.add('order.notify-shipping', { orderId: order.id });
  
  res.status(201).json(order);             // Total: < 500ms ✅
});
```

### Database Performance Checklist
- [ ] Every WHERE column has an index
- [ ] Every JOIN column has an index  
- [ ] Queries use `LIMIT` (never unbounded selects)
- [ ] N+1 queries eliminated (eager loading or DataLoader)
- [ ] Large result sets use cursor pagination (not OFFSET)
- [ ] Expensive queries are cached (Redis or materialized views)
- [ ] Connection pooling is configured and sized
- [ ] Slow query logging is enabled (log queries > 100ms)
