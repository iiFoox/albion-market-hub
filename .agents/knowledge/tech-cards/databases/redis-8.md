# Redis 8 — Tech Card

> **Category:** In-Memory Data Store / Cache
> **Current Version:** 8.x
> **Type:** Key-value store, cache, pub/sub, streaming

---

## Quick Setup (Docker)
```bash
docker run -d --name redis -p 6379:6379 redis:8-alpine
```

## When to Use Redis

| Use Case | Pattern | Example |
|---|---|---|
| **Caching** | Key-Value with TTL | Cache API responses, DB query results |
| **Session Storage** | Key-Value with expiry | User sessions (faster than DB) |
| **Rate Limiting** | INCR + EXPIRE | API rate limiting per user/IP |
| **Queues** | Lists + BRPOP | Background job processing |
| **Pub/Sub** | PUBLISH/SUBSCRIBE | Real-time notifications, WebSocket fan-out |
| **Leaderboard** | Sorted Sets | Game rankings, trending items |
| **Distributed Lock** | SET NX EX | Prevent concurrent processing |
| **Real-time Analytics** | HyperLogLog + Bitmap | Unique visitors, feature flags |

## Essential Patterns

### 1. Cache-Aside Pattern
```typescript
async function getUser(userId: string): Promise<User> {
  // 1. Try cache first
  const cached = await redis.get(`user:${userId}`);
  if (cached) return JSON.parse(cached);

  // 2. Cache miss → fetch from DB
  const user = await db.user.findUnique({ where: { id: userId } });
  if (!user) throw new NotFoundError();

  // 3. Store in cache with TTL
  await redis.setex(`user:${userId}`, 3600, JSON.stringify(user)); // 1 hour TTL

  return user;
}

// Invalidate on update
async function updateUser(userId: string, data: UpdateUserDTO) {
  await db.user.update({ where: { id: userId }, data });
  await redis.del(`user:${userId}`); // Invalidate cache
}
```

### 2. Rate Limiting (Sliding Window)
```typescript
async function isRateLimited(key: string, limit: number, windowSec: number): Promise<boolean> {
  const current = await redis.incr(key);
  if (current === 1) {
    await redis.expire(key, windowSec);
  }
  return current > limit;
}

// Usage: 5 requests per minute per user
if (await isRateLimited(`rate:login:${userId}`, 5, 60)) {
  return res.status(429).json({ error: 'Too many attempts' });
}
```

### 3. Distributed Lock (Redlock)
```typescript
async function acquireLock(resource: string, ttlMs: number): Promise<string | null> {
  const lockId = crypto.randomUUID();
  const acquired = await redis.set(`lock:${resource}`, lockId, 'PX', ttlMs, 'NX');
  return acquired ? lockId : null;
}

async function releaseLock(resource: string, lockId: string): Promise<void> {
  // Lua script: only delete if we own the lock
  const script = `
    if redis.call("get", KEYS[1]) == ARGV[1] then
      return redis.call("del", KEYS[1])
    else
      return 0
    end
  `;
  await redis.eval(script, 1, `lock:${resource}`, lockId);
}
```

## Best Practices

1. **Always set TTL** — keys without expiry fill memory forever
2. **Use key prefixes** — `user:123`, `session:abc`, `cache:products:list`
3. **Use pipelining** — batch multiple commands in one round trip
4. **Monitor memory** — `redis-cli INFO memory`; set `maxmemory` + eviction policy
5. **Use Lua scripts** — atomic multi-step operations
6. **Don't store large values** — max value 512MB but keep < 1MB for performance
7. **Use `SCAN` not `KEYS`** — `KEYS *` blocks Redis; `SCAN` is non-blocking
8. **Set eviction policy** — `allkeys-lru` for caching; `noeviction` for data store

## Gotchas

1. ❌ **Data loss on restart** — enable AOF persistence for durability
2. ❌ **Single-threaded** — one slow command blocks everything; avoid `KEYS *`
3. ❌ **Memory limits** — Redis keeps everything in RAM; monitor usage
4. ❌ **`KEYS *` in production** — blocks Redis for seconds on large datasets
5. ❌ **No native JSON** — serialize/deserialize yourself (or use RedisJSON module)
