# Anti-Pattern Registry

> **Category:** Operational Intelligence
> **Usage:** Referenced by Builder (avoidance) and Validator (detection)
> **Rule:** Every anti-pattern includes WHAT to do instead

---

## Architecture Anti-Patterns

### ARCH-01: Premature Microservices
```
ANTI-PATTERN: Starting a new project with microservices architecture
WHY IT'S BAD: Massive operational overhead for a team of 1-5 developers
SIGNS: Team spending more time on infra than features
DO INSTEAD: Start with Modular Monolith → extract services when needed
RULE OF THUMB: Microservices when team > 10 AND clear domain boundaries exist
```

### ARCH-02: Shared Database Between Services
```
ANTI-PATTERN: Multiple services reading/writing the same database tables
WHY IT'S BAD: Tight coupling — changing a table breaks all services
SIGNS: "We can't deploy service A without service B"
DO INSTEAD: Each service owns its data. Communicate via API or events.
```

### ARCH-03: God Service
```
ANTI-PATTERN: One service that does everything (auth, orders, emails, reports)
WHY IT'S BAD: Single point of failure, impossible to scale independently
SIGNS: Service has 50+ endpoints, 100+ files, deploys take 30+ minutes
DO INSTEAD: Identify bounded contexts → separate by domain responsibility
```

---

## Code Anti-Patterns

### CODE-01: Stringly Typed
```
ANTI-PATTERN: Using strings for everything (status = "active", role = "admin")
WHY IT'S BAD: Typos cause bugs, no autocomplete, no type safety
DO INSTEAD: Use enums, union types, or constants
  ❌ if (user.role === "amdin")
  ✅ if (user.role === Role.ADMIN)
```

### CODE-02: Callback Hell / Promise Chain
```
ANTI-PATTERN: Deeply nested callbacks or .then().then().then()
WHY IT'S BAD: Unreadable, error handling scattered, debugging nightmare
DO INSTEAD: Use async/await with try/catch
```

### CODE-03: Copy-Paste Driven Development
```
ANTI-PATTERN: Duplicating code instead of abstracting
WHY IT'S BAD: Bug in one copy requires fixing ALL copies
SIGNS: Same logic in 3+ places
DO INSTEAD: Extract to function/hook/utility. DRY principle (but don't over-DRY)
```

### CODE-04: Pokemon Exception Handling
```
ANTI-PATTERN: catch(error) { /* ignore */ } — gotta catch 'em all and ignore 'em all
WHY IT'S BAD: Silently swallows errors, bugs become invisible
DO INSTEAD: Catch specific errors, log unexpected ones, always re-throw if not handled
```

---

## API Anti-Patterns

### API-01: Chatty API
```
ANTI-PATTERN: Client needs 10+ API calls to render one page
WHY IT'S BAD: Latency multiplied, mobile performance terrible
DO INSTEAD: Aggregate endpoints, use GraphQL, or implement BFF pattern
```

### API-02: Exposing Internal IDs
```
ANTI-PATTERN: Using auto-increment IDs in URLs (/users/1, /users/2, /users/3)
WHY IT'S BAD: Reveals data volume, enables enumeration attacks
DO INSTEAD: Use UUIDs for public-facing IDs
```

### API-03: No Pagination
```
ANTI-PATTERN: GET /orders returns ALL orders
WHY IT'S BAD: Response grows unbounded → OOM, timeout, bandwidth waste
DO INSTEAD: Always paginate (cursor-based for large datasets)
```

---

## Database Anti-Patterns

### DB-01: Using FLOAT for Money
```
ANTI-PATTERN: price DECIMAL(10,2) → actually stored as FLOAT
WHY IT'S BAD: 0.1 + 0.2 = 0.30000000000000004
DO INSTEAD: Store as integer cents (2999 = R$ 29.99) or DECIMAL type
```

### DB-02: No Index on Foreign Key
```
ANTI-PATTERN: Foreign key constraint without index
WHY IT'S BAD: JOINs and cascading deletes do full table scan
DO INSTEAD: Always create index on FK columns
  PostgreSQL does NOT auto-create indexes on FKs!
```

### DB-03: EAV (Entity-Attribute-Value)
```
ANTI-PATTERN: Generic table with (entity_id, attribute_name, attribute_value)
WHY IT'S BAD: No type safety, impossible to query efficiently, no constraints
DO INSTEAD: Use JSONB column for flexible attributes, or proper schema design
```

---

## DevOps Anti-Patterns

### OPS-01: Snowflake Server
```
ANTI-PATTERN: Manually configured server that nobody can reproduce
WHY IT'S BAD: If it dies, nobody knows how to rebuild it
DO INSTEAD: Infrastructure as Code (Terraform, Pulumi, Docker)
```

### OPS-02: Deploy on Friday
```
ANTI-PATTERN: Deploying to production before the weekend
WHY IT'S BAD: If something breaks, response time is slower
DO INSTEAD: Deploy Monday-Thursday, before lunch. Never before vacation.
```
