# DDD Tactical Patterns

> **Type:** Domain-Driven Design implementation patterns
> **Created by:** Eric Evans, 2003
> **Best For:** Complex business domains with rich logic

---

## Overview

DDD Tactical Patterns are implementation-level building blocks for expressing complex domain models in code. They work inside any architecture (Clean, Hexagonal, Modular Monolith).

## Building Blocks

### 1. Entity
Object with identity that persists across state changes:
```typescript
class Order {
  constructor(
    public readonly id: OrderId,       // Identity
    private _status: OrderStatus,
    private _items: OrderItem[],
  ) {}

  // Equality by ID, not by attributes
  equals(other: Order): boolean {
    return this.id.equals(other.id);
  }
}
```

### 2. Value Object
Immutable object defined by its attributes (no identity):
```typescript
class Money {
  constructor(
    public readonly amount: number,
    public readonly currency: string,
  ) {
    if (amount < 0) throw new Error('Money cannot be negative');
  }

  add(other: Money): Money {
    if (this.currency !== other.currency) throw new Error('Currency mismatch');
    return new Money(this.amount + other.amount, this.currency);
  }

  // Equality by value
  equals(other: Money): boolean {
    return this.amount === other.amount && this.currency === other.currency;
  }
}
```

### 3. Aggregate
Cluster of entities/VOs treated as a single unit for data changes:
```typescript
class Order {  // Aggregate Root
  private _items: OrderItem[];  // Part of aggregate

  // ALL modifications go through the aggregate root
  addItem(product: Product, quantity: number): void {
    if (this._status !== 'draft') throw new Error('Cannot modify confirmed order');
    if (this._items.length >= 50) throw new Error('Max 50 items per order');
    this._items.push(OrderItem.create(product, quantity));
  }

  removeItem(itemId: string): void {
    this._items = this._items.filter(i => i.id !== itemId);
  }

  // Direct modification of OrderItem from outside is NOT allowed
  // order.items[0].quantity = 5;  ❌ VIOLATION
}
```

### Aggregate Rules
1. **Only the root is referenced externally** — other entities are accessed through root
2. **Modify only through the root** — all mutations via aggregate root methods
3. **One aggregate per transaction** — never modify two aggregates in one transaction
4. **Reference other aggregates by ID** — not by object reference
5. **Keep aggregates small** — large aggregates = performance problems

### 4. Domain Event
Something that happened in the domain:
```typescript
class OrderConfirmedEvent {
  constructor(
    public readonly orderId: string,
    public readonly userId: string,
    public readonly total: Money,
    public readonly occurredAt: Date,
  ) {}
}

// Aggregate emits events
class Order {
  private _events: DomainEvent[] = [];

  confirm(): void {
    if (this._items.length === 0) throw new Error('Cannot confirm empty order');
    this._status = 'confirmed';
    this._events.push(new OrderConfirmedEvent(this.id, this.userId, this.total, new Date()));
  }

  pullEvents(): DomainEvent[] {
    const events = [...this._events];
    this._events = [];
    return events;
  }
}
```

### 5. Repository
Persistence interface defined in domain, implemented in infrastructure:
```typescript
// Domain defines the interface
interface OrderRepository {
  findById(id: OrderId): Promise<Order | null>;
  save(order: Order): Promise<void>;
  findByUserId(userId: string): Promise<Order[]>;
  nextId(): OrderId;
}

// Infrastructure implements it
class PrismaOrderRepository implements OrderRepository {
  async findById(id: OrderId): Promise<Order | null> {
    const data = await prisma.order.findUnique({ where: { id: id.value }, include: { items: true } });
    return data ? OrderMapper.toDomain(data) : null;
  }
}
```

### 6. Domain Service
Logic that doesn't naturally belong to any single entity:
```typescript
// Pricing logic spans Product + Order + Discount rules
class PricingService {
  calculateTotal(items: OrderItem[], discountCode?: string): Money {
    const subtotal = items.reduce((sum, item) => sum.add(item.total), Money.zero('BRL'));
    if (discountCode) {
      const discount = this.discountRepository.findByCode(discountCode);
      return discount?.applyTo(subtotal) ?? subtotal;
    }
    return subtotal;
  }
}
```

### 7. Factory
Complex object creation logic:
```typescript
class OrderFactory {
  static createFromCart(cart: Cart, shippingAddress: Address): Order {
    const items = cart.items.map(cartItem =>
      OrderItem.create(cartItem.product, cartItem.quantity)
    );
    return new Order(OrderId.generate(), cart.userId, items, shippingAddress, 'draft');
  }
}
```

---

## When to Use DDD Tactical Patterns

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Domain has complex business rules | Simple CRUD (read/write data) |
| Domain experts are available for collaboration | No domain expert access |
| Business logic changes frequently | Logic is static/simple |
| Multiple teams need shared understanding | Solo project |
| Correctness is critical (finance, healthcare) | Prototype/MVP |

## Common Mistakes

1. **Anemic Domain Model** — entities with only getters/setters; all logic in services
2. **Giant aggregates** — loading 1000 items with an order; keep aggregates small
3. **Cross-aggregate transactions** — modifying Order + Inventory in one transaction
4. **Referencing aggregates by object** — use IDs, not object references
5. **DDD for CRUD** — tactical patterns add complexity; use only when justified
6. **Ignoring Ubiquitous Language** — code should use business terms, not technical jargon
