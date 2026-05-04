# Modular Monolith Architecture

> **Type:** Monolithic with strong module boundaries
> **Best For:** Growing teams, medium complexity, future-proofing for microservices

---

## Overview

A Modular Monolith is a single deployable application organized into well-defined modules with strict boundaries. Each module owns its own domain, data, and API. Modules communicate through explicit public contracts, not shared internals.

```
┌─────────────────────────────────────────────┐
│               Modular Monolith               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Users   │  │  Orders  │  │ Products │  │
│  │  Module  │──│  Module  │──│  Module  │  │
│  │          │  │          │  │          │  │
│  │ ┌──────┐ │  │ ┌──────┐ │  │ ┌──────┐ │  │
│  │ │ DB   │ │  │ │ DB   │ │  │ │ DB   │ │  │
│  │ │Schema│ │  │ │Schema│ │  │ │Schema│ │  │
│  │ └──────┘ │  │ └──────┘ │  │ └──────┘ │  │
│  └──────────┘  └──────────┘  └──────────┘  │
│            Single Database (schemas)         │
│            Single Deployment Unit            │
└─────────────────────────────────────────────┘
```

## Core Principles

1. **Module Boundaries are Sacred** — no reaching into another module's internals
2. **Public Contract Only** — modules communicate through explicit public APIs (not DB joins)
3. **Separate Schemas** — each module owns its DB schema (even in the same database)
4. **Independent Development** — changes in one module don't require changes in others
5. **Single Deployment** — still deployed as one unit (simplicity of monolith)
6. **Future Extraction** — any module can become a microservice later

## Folder Structure

### Node.js / TypeScript
```
src/
├── modules/
│   ├── users/
│   │   ├── public/                # Public API — other modules can import ONLY from here
│   │   │   ├── UserModule.ts     # Module registration / DI container
│   │   │   ├── UserPublicApi.ts  # Public methods other modules can call
│   │   │   └── types.ts         # Public DTOs/interfaces
│   │   ├── internal/             # Private — ONLY this module can access
│   │   │   ├── domain/
│   │   │   │   ├── User.ts
│   │   │   │   └── UserRepository.ts (interface)
│   │   │   ├── application/
│   │   │   │   ├── CreateUser.ts
│   │   │   │   └── GetUserProfile.ts
│   │   │   ├── infrastructure/
│   │   │   │   ├── PrismaUserRepository.ts
│   │   │   │   └── UserEmailService.ts
│   │   │   └── presentation/
│   │   │       └── UserController.ts
│   │   └── tests/
│   │       ├── unit/
│   │       └── integration/
│   │
│   ├── orders/
│   │   ├── public/
│   │   │   ├── OrderModule.ts
│   │   │   ├── OrderPublicApi.ts
│   │   │   └── types.ts
│   │   └── internal/
│   │       └── ... (same structure)
│   │
│   └── products/
│       ├── public/
│       └── internal/
│
├── shared/                        # Truly shared utilities (logging, auth, config)
│   ├── auth/
│   ├── logging/
│   └── config/
│
├── infrastructure/                # App-level infra (database connection, server)
│   ├── database.ts
│   ├── server.ts
│   └── middleware/
│
└── main.ts                        # Composition root
```

## Module Communication Rules

### ✅ ALLOWED
```typescript
// orders/internal/application/CreateOrder.ts
import { UserPublicApi } from '@modules/users/public/UserPublicApi';

// Calling through public API
const user = await this.userApi.getById(userId);
```

### ❌ FORBIDDEN
```typescript
// orders/internal/application/CreateOrder.ts
import { User } from '@modules/users/internal/domain/User';        // ❌ Internal!
import { PrismaUserRepository } from '@modules/users/internal/...'; // ❌ Internal!

// Direct DB query on another module's schema
const user = await prisma.user.findUnique({ where: { id } });      // ❌ Cross-schema!
```

## Database Strategy

### Option A: Separate Schemas (Same DB)
```sql
-- Each module owns its schema
CREATE SCHEMA users;
CREATE SCHEMA orders;
CREATE SCHEMA products;

-- Users module owns users.users
CREATE TABLE users.users (...);

-- Orders module owns orders.orders
CREATE TABLE orders.orders (...);
-- Orders has a user_id column but NO foreign key to users.users
-- Referential integrity is managed at application level
```

### Option B: Separate Tables with Prefix
```prisma
// Users module
model User { @@map("users_users") }

// Orders module
model Order { @@map("orders_orders") }
```

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Team is 3-15 developers | Team is 1-2 developers (overkill) |
| Application will grow but isn't huge yet | Already at microservices scale (20+ devs) |
| Clear domain boundaries exist | Domain is simple CRUD |
| Want microservices benefits without operational cost | Need independent scaling per module |
| Single deployment pipeline is preferred | Different modules need different release cadences |
| Future microservices migration is possible but not needed now | Regulatory requirements mandate service isolation |

## Extraction Path (to Microservices)

```
WHEN TO EXTRACT A MODULE:
→ Module needs to scale independently (10x traffic vs others)
→ Module needs different tech stack
→ Module is owned by a separate team wanting independent releases
→ Module's failure should not affect other modules

HOW TO EXTRACT:
1. Module already has public API → this becomes the service API
2. Module already has separate schema → this becomes the service database
3. Replace internal calls with HTTP/gRPC/events
4. Deploy module as separate service
5. Remove module from monolith codebase
```

## Common Mistakes

1. **No module boundaries** — just folders without enforcement = monolith
2. **Cross-module DB joins** — using SQL JOINs across module schemas
3. **Shared domain objects** — modules importing each other's entities
4. **God shared module** — `shared/` becomes a dumping ground
5. **No lint rules** — without tooling to enforce boundaries, devs will cross them

## Enforcing Boundaries

### ESLint (TypeScript)
```json
{
  "rules": {
    "no-restricted-imports": ["error", {
      "patterns": [
        "*/modules/*/internal/*"
      ]
    }]
  }
}
```

### Architecture Tests
```typescript
// __tests__/architecture.test.ts
describe('Module Boundaries', () => {
  it('orders module should not import from users internals', () => {
    const ordersFiles = glob.sync('src/modules/orders/**/*.ts');
    for (const file of ordersFiles) {
      const content = fs.readFileSync(file, 'utf-8');
      expect(content).not.toContain('modules/users/internal');
    }
  });
});
```
