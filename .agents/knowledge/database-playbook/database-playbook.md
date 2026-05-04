# Database Design Playbook

> **Category:** Database Architecture
> **Usage:** Referenced by Planner (schema design) and Builder (implementation)

---

## Schema Design Patterns

### 1. Soft Delete
```sql
-- Instead of DELETE, mark as deleted
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP NULL;

-- Partial index: only active records (most queries)
CREATE INDEX idx_users_active ON users(email) WHERE deleted_at IS NULL;

-- Application: always filter
SELECT * FROM users WHERE deleted_at IS NULL;
```

### 2. Audit Trail
```sql
CREATE TABLE audit_log (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  table_name  TEXT NOT NULL,
  record_id   UUID NOT NULL,
  action      TEXT NOT NULL,  -- INSERT, UPDATE, DELETE
  old_data    JSONB,
  new_data    JSONB,
  changed_by  UUID REFERENCES users(id),
  changed_at  TIMESTAMP DEFAULT NOW()
);

-- Trigger-based automatic logging
CREATE OR REPLACE FUNCTION audit_trigger() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by)
  VALUES (TG_TABLE_NAME, COALESCE(NEW.id, OLD.id),
          TG_OP, to_jsonb(OLD), to_jsonb(NEW),
          current_setting('app.current_user_id', true)::UUID);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### 3. Multi-Tenant
```
STRATEGIES:
1. Shared Database, Shared Schema + tenant_id column
   → Simplest, cheapest, less isolation
   → Use Row Level Security (RLS) for enforcement
   
2. Shared Database, Separate Schemas
   → Medium isolation, medium complexity
   → Each tenant has own schema (tenant1.users, tenant2.users)
   
3. Separate Databases
   → Maximum isolation, most expensive
   → Each tenant has own database
   
RECOMMENDATION: Start with strategy 1 (RLS), migrate to 2/3 if needed.
```

### 4. Cursor Pagination (vs Offset)
```sql
-- ❌ OFFSET pagination (slow on large tables)
SELECT * FROM orders ORDER BY created_at DESC OFFSET 10000 LIMIT 20;
-- Problem: DB must scan 10020 rows to return 20

-- ✅ Cursor pagination (fast regardless of position)
SELECT * FROM orders 
WHERE created_at < '2026-04-05T12:00:00Z'  -- cursor from previous page
ORDER BY created_at DESC 
LIMIT 20;
-- Benefit: Uses index, scans only 20 rows
```

### 5. Polymorphic Relations
```sql
-- Option A: Single Table Inheritance (STI)
CREATE TABLE notifications (
  id UUID PRIMARY KEY,
  type TEXT NOT NULL,  -- 'email', 'sms', 'push'
  -- shared fields
  recipient TEXT NOT NULL,
  message TEXT NOT NULL,
  sent_at TIMESTAMP,
  -- type-specific fields (nullable)
  email_subject TEXT,     -- only for email
  phone_number TEXT,      -- only for sms
  device_token TEXT       -- only for push
);

-- Option B: Separate tables (recommended for complex types)
CREATE TABLE email_notifications (id UUID PRIMARY KEY, subject TEXT, ...);
CREATE TABLE sms_notifications (id UUID PRIMARY KEY, phone TEXT, ...);
```

## Index Strategy Decision

```
WHEN TO ADD AN INDEX:
→ Column appears in WHERE clause of frequent queries
→ Column appears in JOIN condition
→ Column appears in ORDER BY
→ Column is a foreign key (PostgreSQL doesn't auto-index FKs!)

WHEN NOT TO ADD AN INDEX:
→ Table has < 1000 rows (seq scan is faster)
→ Column has very low cardinality (boolean, status with 3 values)
→ Write-heavy table with rare reads (indexes slow down writes)

INDEX TYPES:
→ B-tree (default): =, <, >, <=, >=, BETWEEN, IN, LIKE 'prefix%'
→ GIN: JSONB, arrays, full-text search
→ BRIN: Large tables ordered by a column (timestamps)
→ Hash: Only equality (=), rarely useful
```

## Migration Best Practices

```
RULES:
1. EVERY schema change goes through a migration (never manual DDL)
2. Migrations must be reversible (up + down)
3. Separate data migrations from schema migrations
4. Never modify a deployed migration — create a new one
5. Test migrations on a copy of production data
6. Large table migrations: use CREATE INDEX CONCURRENTLY (no lock)
7. Add columns as NULLABLE first, backfill, then add NOT NULL constraint

DANGEROUS OPERATIONS:
→ ALTER TABLE ... ADD COLUMN ... NOT NULL   → locks table
→ ALTER TABLE ... ALTER COLUMN TYPE         → rewrites entire table
→ CREATE INDEX (without CONCURRENTLY)       → locks writes
→ DROP COLUMN                               → may break running queries

SAFE PATTERN (add NOT NULL column):
1. ALTER TABLE users ADD COLUMN role TEXT;           -- nullable, no lock
2. UPDATE users SET role = 'user' WHERE role IS NULL; -- backfill
3. ALTER TABLE users ALTER COLUMN role SET NOT NULL;  -- constraint
4. ALTER TABLE users ALTER COLUMN role SET DEFAULT 'user'; -- default
```

## Connection Pooling

```
WHY: Each DB connection uses ~5-10MB RAM. 100 connections = 500MB-1GB.

STRATEGIES:
→ Application-level: Prisma pool (connection_limit in URL)
→ External: PgBouncer (recommended for production)
→ Cloud: RDS Proxy (AWS), Cloud SQL Proxy (GCP)

SIZING:
→ Pool size = (num_cores * 2) + num_disks
→ For web apps: max_connections = max_concurrent_requests / 2
→ Default PostgreSQL: 100 connections max
→ Default Prisma: 5 connections (often too low!)

PRISMA CONNECTION STRING:
postgresql://user:pass@host:5432/db?connection_limit=20&pool_timeout=10
```
