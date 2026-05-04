# Clean Architecture

> **Also known as:** Onion Architecture, Ports & Adapters (Hexagonal)
> **Created by:** Robert C. Martin (Uncle Bob), 2012

---

## Overview

Clean Architecture organizes code into concentric layers where dependencies point **inward only**. The innermost layer (Entities/Domain) has zero dependencies on frameworks, databases, or UI. Each outer layer can depend on inner layers, but never the reverse.

```
┌──────────────────────────────────────────────┐
│              Frameworks & Drivers             │  ← Web, DB, UI, External APIs
│  ┌────────────────────────────────────────┐  │
│  │          Interface Adapters            │  │  ← Controllers, Gateways, Presenters
│  │  ┌──────────────────────────────────┐  │  │
│  │  │       Application Layer          │  │  │  ← Use Cases, Application Services
│  │  │  ┌────────────────────────────┐  │  │  │
│  │  │  │     Domain / Entities      │  │  │  │  ← Business Rules, Value Objects
│  │  │  └────────────────────────────┘  │  │  │
│  │  └──────────────────────────────────┘  │  │
│  └────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
          Dependencies point INWARD →
```

## Core Principles

1. **Dependency Rule:** Source code dependencies must point inward only
2. **Entities:** Enterprise-wide business rules (independent of everything)
3. **Use Cases:** Application-specific business rules (orchestrate entity interactions)
4. **Interface Adapters:** Convert data between use cases and external formats
5. **Frameworks & Drivers:** The outermost layer — database, web framework, UI

## Layer Responsibilities

| Layer | Contains | Depends On | Never Depends On |
|---|---|---|---|
| **Domain** | Entities, Value Objects, Domain Events, Repository Interfaces | Nothing | Anything external |
| **Application** | Use Cases, DTOs, Application Services, Port Interfaces | Domain | Frameworks, DB |
| **Infrastructure** | Repository Implementations, External Service Clients, ORM Config | Domain, Application | UI |
| **Presentation** | Controllers, Views, API Routes, Serializers | Application | Domain internals |

## Folder Structure

### Node.js / TypeScript
```
src/
├── domain/                    # Layer 1: Entities & Business Rules
│   ├── entities/
│   │   ├── User.ts           # Entity with business logic methods
│   │   ├── Order.ts
│   │   └── Product.ts
│   ├── value-objects/
│   │   ├── Email.ts          # Self-validating value object
│   │   ├── Money.ts
│   │   └── Address.ts
│   ├── events/
│   │   └── OrderCreated.ts
│   └── repositories/         # Interfaces (NOT implementations)
│       ├── IUserRepository.ts
│       └── IOrderRepository.ts
│
├── application/               # Layer 2: Use Cases
│   ├── use-cases/
│   │   ├── CreateOrder.ts    # Single use case: one class, one execute()
│   │   ├── GetUserOrders.ts
│   │   └── CancelOrder.ts
│   ├── dtos/
│   │   ├── CreateOrderDTO.ts
│   │   └── OrderResponseDTO.ts
│   └── services/
│       └── NotificationService.ts  # Interface for notifications
│
├── infrastructure/            # Layer 3: External Implementations
│   ├── database/
│   │   ├── prisma/
│   │   │   ├── schema.prisma
│   │   │   └── PrismaUserRepository.ts   # Implements IUserRepository
│   │   └── PrismaOrderRepository.ts
│   ├── services/
│   │   ├── StripePaymentService.ts
│   │   └── SendGridNotificationService.ts
│   └── config/
│       └── database.ts
│
├── presentation/              # Layer 4: API / UI
│   ├── http/
│   │   ├── controllers/
│   │   │   ├── OrderController.ts
│   │   │   └── UserController.ts
│   │   ├── middleware/
│   │   │   ├── auth.ts
│   │   │   └── validation.ts
│   │   └── routes/
│   │       └── index.ts
│   └── serializers/
│       └── OrderSerializer.ts
│
└── main.ts                    # Composition root (wires everything together)
```

### Python / FastAPI
```
src/
├── domain/
│   ├── entities/
│   │   ├── user.py
│   │   └── order.py
│   ├── value_objects/
│   │   └── email.py
│   └── repositories/
│       └── user_repository.py    # Abstract Base Class
│
├── application/
│   ├── use_cases/
│   │   ├── create_order.py
│   │   └── get_user_orders.py
│   └── dtos/
│       └── order_dto.py
│
├── infrastructure/
│   ├── database/
│   │   ├── sqlalchemy_user_repo.py  # Implements UserRepository ABC
│   │   └── models.py
│   └── services/
│       └── stripe_payment.py
│
├── presentation/
│   ├── api/
│   │   ├── routes/
│   │   │   └── orders.py
│   │   └── dependencies.py        # FastAPI Depends() injection
│   └── schemas/
│       └── order_schema.py        # Pydantic models
│
└── main.py
```

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Business logic is complex and must be testable | Simple CRUD app with no business logic |
| Application will live for years (long-term maintainability) | Hackathon / prototype / throwaway code |
| Multiple presentation layers (API + CLI + Queue consumer) | Single tiny microservice with 1-2 endpoints |
| Team has 3+ developers working on different layers | Solo developer on small project |
| Business rules change independently of infrastructure | Tech stack is unlikely to change |
| You need to swap databases/frameworks without rewriting logic | Time-to-market is the only priority |

## Decision Criteria (Scoring)

| Factor | Score 1-5 | Weight |
|---|---|---|
| Business logic complexity | [assess] | 25% |
| Expected lifetime (years) | [assess] | 20% |
| Team size | [assess] | 15% |
| Presentation layer count | [assess] | 15% |
| Infrastructure flexibility need | [assess] | 15% |
| Time-to-market pressure | [assess] | 10% |
| **If weighted total > 3.5:** Use Clean Architecture | | |
| **If weighted total < 2.5:** Use simpler pattern (MVC/Layered) | | |

---

## Common Mistakes

1. **Leaking framework dependencies into domain** — Entity importing `@prisma/client` is a violation
2. **Anemic domain model** — Entities with only getters/setters, no business logic
3. **Missing repository interfaces** — Domain must define interfaces, not import implementations
4. **Too many layers for simple operations** — Simple CRUD doesn't need 4 layers
5. **God use cases** — Each use case should do ONE thing, not orchestrate 10 operations
6. **DTOs everywhere** — Don't over-convert; only at layer boundaries

## Key Code Pattern: Use Case

```typescript
// application/use-cases/CreateOrder.ts
export class CreateOrder {
  constructor(
    private readonly orderRepository: IOrderRepository,  // Interface, not implementation
    private readonly paymentService: IPaymentService,
    private readonly notificationService: INotificationService,
  ) {}

  async execute(dto: CreateOrderDTO): Promise<OrderResponseDTO> {
    // 1. Create domain entity
    const order = Order.create({
      userId: dto.userId,
      items: dto.items.map(item => OrderItem.create(item)),
    });

    // 2. Process payment (via interface)
    const payment = await this.paymentService.charge(order.total);
    order.confirmPayment(payment.id);

    // 3. Persist (via interface)
    await this.orderRepository.save(order);

    // 4. Notify (via interface)
    await this.notificationService.sendOrderConfirmation(order);

    // 5. Return DTO (not entity)
    return OrderResponseDTO.fromEntity(order);
  }
}
```

## Key Code Pattern: Entity with Business Logic

```typescript
// domain/entities/Order.ts
export class Order {
  private constructor(
    public readonly id: string,
    public readonly userId: string,
    private _items: OrderItem[],
    private _status: OrderStatus,
    private _paymentId: string | null,
  ) {}

  // Factory method (controlled creation)
  static create(props: { userId: string; items: OrderItem[] }): Order {
    if (props.items.length === 0) {
      throw new DomainError('Order must have at least one item');
    }
    return new Order(uuid(), props.userId, props.items, 'pending', null);
  }

  // Business rule: total with discount logic
  get total(): Money {
    const subtotal = this._items.reduce((sum, item) => sum.add(item.total), Money.zero());
    return this._items.length >= 5 ? subtotal.applyDiscount(0.1) : subtotal;
  }

  // Business rule: can only confirm once
  confirmPayment(paymentId: string): void {
    if (this._status !== 'pending') {
      throw new DomainError('Can only confirm pending orders');
    }
    this._paymentId = paymentId;
    this._status = 'confirmed';
  }

  // Business rule: cancellation policy
  cancel(): void {
    if (this._status === 'shipped') {
      throw new DomainError('Cannot cancel shipped orders');
    }
    this._status = 'cancelled';
  }
}
```
