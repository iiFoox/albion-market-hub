# Incident Archetypes — "We've Seen This Break Before"

> **Category:** Operational Intelligence
> **Usage:** Referenced by ALL agents to prevent known failure patterns
> **Philosophy:** Senior teams don't just know best practices — they remember past failures

---

## Database Incidents

### DB-01: Connection Pool Exhaustion
```
PATTERN: App suddenly returns 500 errors under moderate load
ROOT CAUSE: Default connection pool too small (Prisma default = 5)
SYMPTOMS:
→ "Connection pool timeout" errors in logs
→ Response times spike from 100ms to 30s+
→ Happens during traffic peaks
PREVENTION:
→ Set connection_limit=20 minimum for web apps
→ Monitor active connections: SELECT count(*) FROM pg_stat_activity
→ Use PgBouncer for production (external pooling)
SEVERITY: HIGH — causes total service degradation
```

### DB-02: Migration Locks Production Table
```
PATTERN: Deploy runs migration → site freezes → rollback needed
ROOT CAUSE: ALTER TABLE without CONCURRENTLY locks entire table
SYMPTOMS:
→ All writes block during migration
→ Reads may also block (depending on lock type)
→ Duration depends on table size (millions of rows = minutes of lock)
PREVENTION:
→ Always use CREATE INDEX CONCURRENTLY
→ Add columns as NULLABLE first, backfill, then add NOT NULL
→ Test migrations against production-sized data BEFORE deploying
→ Schedule large migrations during low-traffic windows
SEVERITY: CRITICAL — causes total downtime
```

### DB-03: N+1 Query Explosion
```
PATTERN: Page loads fine in dev, takes 30 seconds in production
ROOT CAUSE: ORM lazy-loading executes 1 query per related entity
SYMPTOMS:
→ Database shows thousands of simple SELECT queries per page load
→ Response time grows linearly with data size
→ Works fine with 10 rows, catastrophic with 10,000
PREVENTION:
→ Use include/eager loading (Prisma: include, SQLAlchemy: joinedload)
→ Use DataLoader for GraphQL
→ Monitor query count per request (should be <10 for most pages)
SEVERITY: HIGH — causes progressive degradation
```

---

## Authentication Incidents

### AUTH-01: JWT Without Refresh Token Rotation
```
PATTERN: Security audit finds "token reuse vulnerability"
ROOT CAUSE: Refresh token never changes → stolen token works forever
PREVENTION:
→ Issue new refresh token on each use
→ Invalidate old refresh token immediately
→ Implement reuse detection (if old token used → revoke ALL)
SEVERITY: HIGH — security vulnerability
```

### AUTH-02: Session Timeout Causes Mass Logout
```
PATTERN: Deploy new version → all users logged out simultaneously
ROOT CAUSE: Sessions stored in server memory → restart clears them
PREVENTION:
→ Store sessions in Redis/database (not in-memory)
→ Use JWT with refresh tokens (stateless — survives restarts)
→ Set appropriate session TTL (not too short)
SEVERITY: MEDIUM — user experience degradation
```

---

## Deployment Incidents

### DEPLOY-01: Feature Without Flag Breaks All Users
```
PATTERN: New feature deployed → 100% of users see broken state
ROOT CAUSE: No feature flag, no gradual rollout, no canary deploy
PREVENTION:
→ Use feature flags for ALL new features
→ Start at 5% rollout → 25% → 50% → 100%
→ Have kill switch to disable feature instantly
→ Monitor error rates after each rollout stage
SEVERITY: CRITICAL — affects all users
```

### DEPLOY-02: Environment Variable Missing in Production
```
PATTERN: Works in dev, crashes immediately in production
ROOT CAUSE: New env var added but not configured in production
PREVENTION:
→ Validate ALL required env vars at app startup (fail fast)
→ Use Zod/schema validation for environment configuration
→ CI/CD checks for env var parity between environments
→ Use .env.example as documentation of required vars
SEVERITY: HIGH — prevents deployment
```

---

## Performance Incidents

### PERF-01: Unbounded Query Returns Entire Table
```
PATTERN: Admin page takes 60 seconds to load
ROOT CAUSE: SELECT * FROM large_table without LIMIT
PREVENTION:
→ ALWAYS use pagination (cursor-based for large tables)
→ Set max limit in API (e.g., max 100 items per request)
→ Add database-level statement_timeout
SEVERITY: MEDIUM — can cause OOM or timeout
```

### PERF-02: Image Upload Without Size Limit
```
PATTERN: Storage costs spike, upload endpoint crashes
ROOT CAUSE: No file size validation → users upload 50MB images
PREVENTION:
→ Server-side file size limit (e.g., max 5MB)
→ Validate file type by content (magic bytes), not just extension
→ Resize images before storing
→ Use separate storage (S3/Blob) with CDN
SEVERITY: MEDIUM — cost and performance
```

---

## Integration Incidents

### INT-01: External API Down → App Down
```
PATTERN: Payment provider has 5-minute outage → entire checkout broken
ROOT CAUSE: No circuit breaker, no retry, no fallback
PREVENTION:
→ Implement circuit breaker pattern
→ Retry with exponential backoff (max 3 retries)
→ Graceful degradation (show "temporarily unavailable" not error)
→ Queue failed operations for retry
SEVERITY: HIGH — business impact
```

### INT-02: Webhook Signature Not Validated
```
PATTERN: Attacker sends fake webhook → system processes fraudulent data
ROOT CAUSE: Webhook endpoint accepts any POST without signature verification
PREVENTION:
→ ALWAYS validate webhook signatures (Stripe, GitHub, etc.)
→ Use shared secret + HMAC verification
→ Reject requests without valid signature
→ Log all webhook attempts (valid and invalid)
SEVERITY: CRITICAL — security vulnerability
```

---

## Security Incidents

### SEC-01: Secrets Committed to Repository
```
PATTERN: API key found in git history → exposed on GitHub
ROOT CAUSE: .env file committed or secret hardcoded in source
PREVENTION:
→ .gitignore includes .env* from day one
→ Use git-secrets or pre-commit hooks to scan
→ If exposed: rotate key IMMEDIATELY (assume compromised)
→ Use environment variables or secrets manager, NEVER hardcode
SEVERITY: CRITICAL — immediate security breach
```

### SEC-02: IDOR — User Accesses Other User's Data
```
PATTERN: Change user_id in URL → see another user's data
ROOT CAUSE: API doesn't verify ownership, only checks authentication
PREVENTION:
→ ALWAYS add ownership check: WHERE id = :id AND user_id = :userId
→ Use middleware to enforce ownership at route level
→ Test with multiple user accounts
SEVERITY: CRITICAL — data breach
```
