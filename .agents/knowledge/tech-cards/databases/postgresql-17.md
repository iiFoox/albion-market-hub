# PostgreSQL 17 — Tech Card

> **Category:** Relational Database
> **Current Version:** 17.x
> **Type:** ACID-compliant RDBMS

---

## Quick Setup (Docker)
```bash
docker run -d --name postgres -e POSTGRES_PASSWORD=secret -p 5432:5432 postgres:17
```

## Prisma Connection
```env
DATABASE_URL="postgresql://postgres:secret@localhost:5432/mydb?schema=public"
```

## Top 10 Best Practices

1. **Always use indexes** on columns used in WHERE, JOIN, ORDER BY
2. **Use UUIDs for public IDs** — auto-increment exposes data volume
3. **Use connection pooling** — PgBouncer or Prisma's built-in pool
4. **Use ENUM types** for small fixed sets (status, role, type)
5. **Use transactions** for multi-step operations that must be atomic
6. **Use partial indexes** — `CREATE INDEX ... WHERE status = 'active'` (smaller, faster)
7. **Use JSONB sparingly** — great for flexible data, but not a replacement for columns
8. **Set timezone to UTC** — `SET timezone = 'UTC'` in connection config
9. **Use EXPLAIN ANALYZE** before deploying new queries to production
10. **Backup with pg_dump / pg_basebackup** — test restoration regularly

## Top 10 Gotchas

1. ❌ **Missing indexes on foreign keys** — FK doesn't auto-create index; add manually
2. ❌ **N+1 queries via ORM** — use `include` (Prisma) or `joinedload` (SQLAlchemy)
3. ❌ **Connection exhaustion** — default pool is small; set `connection_limit` in URL
4. ❌ **Locking with long transactions** — keep transactions short; use `SKIP LOCKED` for job queues
5. ❌ **Storing money as FLOAT** — use `DECIMAL(10,2)` or `BIGINT` (cents)
6. ❌ **Large tables without partitioning** — partition by date for tables > 10M rows
7. ❌ **Not using VACUUM** — dead rows accumulate; autovacuum is on by default but tune it
8. ❌ **SELECT * in production** — select only needed columns; reduces I/O and network
9. ❌ **Ignoring query plans** — a seq scan on 10M rows is catastrophic
10. ❌ **No connection timeout** — set `statement_timeout` to prevent runaway queries

## Index Strategy
```sql
-- B-tree (default): equality and range queries
CREATE INDEX idx_users_email ON users(email);

-- Unique: enforce uniqueness
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Composite: multi-column WHERE/ORDER
CREATE INDEX idx_orders_user_date ON orders(user_id, created_at DESC);

-- Partial: index subset of rows (smaller, faster)
CREATE INDEX idx_orders_active ON orders(status) WHERE status = 'active';

-- GIN: for JSONB and full-text search
CREATE INDEX idx_products_metadata ON products USING GIN(metadata);

-- Expression: index on computed value
CREATE INDEX idx_users_email_lower ON users(LOWER(email));
```

## Query Optimization
```sql
-- EXPLAIN ANALYZE: see execution plan + actual timing
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 'abc' ORDER BY created_at DESC LIMIT 10;

-- What to look for:
-- ✅ Index Scan — fast
-- ❌ Seq Scan on large table — needs index
-- ❌ Nested Loop with large tables — consider JOIN strategy
-- ❌ Sort (on disk) — needs index on ORDER BY column
```

## Common Patterns
| Pattern | SQL | Use Case |
|---|---|---|
| **Upsert** | `INSERT ... ON CONFLICT DO UPDATE` | Create or update |
| **Soft Delete** | `deleted_at TIMESTAMP` + partial index on active | Don't lose data |
| **Cursor Pagination** | `WHERE id > :cursor ORDER BY id LIMIT N` | Efficient pagination |
| **Advisory Lock** | `pg_advisory_lock(key)` | Distributed locking |
| **Pub/Sub** | `LISTEN/NOTIFY` | Real-time notifications |
| **Full-Text Search** | `tsvector` + `tsquery` | Built-in search |

## Security Checklist
- [ ] Use parameterized queries (Prisma/SQLAlchemy do this automatically)
- [ ] Create application-specific DB user (not postgres superuser)
- [ ] Use SSL for connections (`?sslmode=require`)
- [ ] Enable row-level security (RLS) for multi-tenant
- [ ] Audit sensitive table access with `pgaudit`
- [ ] Encrypt sensitive columns (or use column-level encryption)
- [ ] Set `statement_timeout` to prevent DoS via slow queries

## Monitoring Queries
```sql
-- Find slow queries
SELECT query, mean_exec_time, calls FROM pg_stat_statements ORDER BY mean_exec_time DESC LIMIT 10;

-- Check index usage
SELECT relname, seq_scan, idx_scan FROM pg_stat_user_tables ORDER BY seq_scan DESC;

-- Table sizes
SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) FROM pg_stat_user_tables ORDER BY pg_total_relation_size(relid) DESC;
```
