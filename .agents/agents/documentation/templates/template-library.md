# Documentation Template Library

> **Category:** Documentation / Templates
> **Usage:** Ready-to-use templates for all documentation types

---

## 1. README Template

```markdown
# Project Name

> Brief one-line description of the project.

[![CI](badge-url)](ci-url) [![Coverage](badge-url)](coverage-url)

## Overview

2-3 sentences about what this project does and why it exists.

## Quick Start

\`\`\`bash
# Prerequisites
node >= 22, npm >= 10, PostgreSQL >= 17

# Install
git clone <repo-url>
cd project-name
cp .env.example .env
npm install
npx prisma migrate dev

# Run
npm run dev  # → http://localhost:3000
\`\`\`

## Architecture

Brief architecture overview with diagram reference.

See [Architecture Decision Records](docs/adr/) for design decisions.

## Project Structure

\`\`\`
src/
├── app/        # Next.js App Router pages
├── components/ # React components
├── lib/        # Utilities and helpers
├── actions/    # Server Actions
└── types/      # TypeScript types
\`\`\`

## Development

\`\`\`bash
npm run dev          # Start dev server
npm run test         # Run tests
npm run lint         # Lint code
npm run build        # Production build
npm run db:migrate   # Run migrations
npm run db:seed      # Seed database
\`\`\`

## Environment Variables

| Variable | Description | Required | Default |
|---|---|---|---|
| `DATABASE_URL` | PostgreSQL connection string | Yes | — |
| `NEXTAUTH_SECRET` | Auth encryption key | Yes | — |
| `NEXTAUTH_URL` | App URL | Yes | `http://localhost:3000` |

## Contributing

See `CONTRIBUTING.md` for development guidelines.

## License

[MIT](LICENSE) © [Author]
```

---

## 2. ADR Template (Architecture Decision Record)

```markdown
# ADR-001: [Decision Title]

**Date:** YYYY-MM-DD
**Status:** [proposed | accepted | deprecated | superseded by ADR-XXX]
**Deciders:** [who made this decision]

## Context

What is the problem or situation we are addressing?
What constraints exist?

## Decision

We will [decision].

## Alternatives Considered

### Option A: [Name]
- **Pros:** ...
- **Cons:** ...

### Option B: [Name]
- **Pros:** ...
- **Cons:** ...

## Consequences

### Positive
- [benefit]

### Negative
- [tradeoff]

### Risks
- [risk and mitigation]
```

---

## 3. Runbook Template (Operations)

```markdown
# Runbook: [Service/Process Name]

## Overview
What this service does and why it matters.

## Health Check
- **URL:** `https://api.example.com/health`
- **Expected:** `200 OK` with `{ "status": "healthy" }`

## Common Issues

### Issue: High Response Time (> 2s p95)
**Symptoms:** Slow API responses, timeout errors
**Diagnosis:**
1. Check database: `SELECT * FROM pg_stat_activity WHERE state = 'active';`
2. Check Redis: `redis-cli INFO memory`
3. Check CPU/Memory: Dashboard → Monitoring → Alerts

**Resolution:**
1. If DB queries slow → Check for missing indexes, long transactions
2. If Redis OOM → Increase maxmemory or check for key explosion
3. If CPU high → Scale horizontally (add replicas)

### Issue: Service Unavailable (503)
**Diagnosis:**
1. Check if pods are running: `kubectl get pods -n production`
2. Check recent deployments: `kubectl rollout history deployment/api`

**Resolution:**
1. If crash loop → Check logs: `kubectl logs <pod> --previous`
2. If OOM killed → Increase memory limits
3. If bad deploy → Rollback: `kubectl rollout undo deployment/api`

## Escalation
| Level | Contact | When |
|---|---|---|
| L1 | On-call engineer | Service degradation |
| L2 | Tech Lead | Data loss risk |
| L3 | CTO | Security breach |
```

---

## 4. Incident Postmortem Template

```markdown
# Postmortem: [Incident Title]

**Date:** YYYY-MM-DD
**Duration:** [start] — [end] ([total])
**Severity:** [P1/P2/P3/P4]
**Author:** [name]

## Summary
One paragraph describing what happened, impact, and resolution.

## Timeline (UTC)
| Time | Event |
|---|---|
| 14:00 | Alert triggered: API response time > 5s |
| 14:05 | On-call acknowledged, began investigation |
| 14:15 | Root cause identified: missing index on orders table |
| 14:20 | Fix deployed: `CREATE INDEX CONCURRENTLY ...` |
| 14:25 | Metrics returned to normal |

## Impact
- **Users affected:** ~500
- **Revenue impact:** $0 (no transactions failed)
- **Data loss:** None

## Root Cause
Missing database index on `orders.user_id` column caused sequential scans
on a table with 2M rows when loading user dashboards.

## Resolution
Added index `CREATE INDEX idx_orders_user_id ON orders(user_id)` using
CONCURRENTLY to avoid locking.

## Action Items
| Action | Owner | Due |
|---|---|---|
| Add index coverage check to CI | @developer | 2026-04-12 |
| Review all tables > 100K rows for missing indexes | @dba | 2026-04-15 |
| Add query performance monitoring alert | @devops | 2026-04-10 |

## Lessons Learned
- Database indexes should be part of migration review process
- Need automated slow query detection before issues reach production
```

---

## 5. Technical Design Document Template

```markdown
# TDD: [Feature Name]

**Author:** [name]
**Status:** [draft | review | approved | implemented]
**Reviewers:** [names]
**Date:** YYYY-MM-DD

## Problem Statement
What problem are we solving? Why now?

## Proposed Solution
High-level description of the approach.

## Detailed Design

### API Changes
[New endpoints, modified endpoints, breaking changes]

### Data Model Changes
[Schema changes, new tables, migrations]

### Architecture Diagram
[Mermaid diagram or image]

### Security Considerations
[Auth, data protection, input validation]

### Performance Considerations
[Expected load, caching strategy, query optimization]

## Alternatives Considered
[What else was considered and why it was rejected]

## Migration Plan
[How to deploy without downtime]

## Testing Plan
[Unit, integration, E2E test strategy]

## Rollback Plan
[How to undo if something goes wrong]
```
