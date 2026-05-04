# Unit Testing Guide

> **Category:** Validator / Testing Playbook
> **Usage:** Reference for writing effective unit tests

---

## Structure: Arrange-Act-Assert (AAA)

```typescript
describe('OrderService', () => {
  describe('createOrder', () => {
    it('should create order with calculated total', () => {
      // ARRANGE — set up test data and dependencies
      const items = [
        { productId: 'p1', quantity: 2, price: 29.90 },
        { productId: 'p2', quantity: 1, price: 49.90 },
      ];
      const mockRepo = { save: jest.fn().mockResolvedValue(undefined) };
      const service = new OrderService(mockRepo);

      // ACT — execute the function being tested
      const order = await service.createOrder('user-123', items);

      // ASSERT — verify the results
      expect(order.total).toBe(109.70);
      expect(order.status).toBe('pending');
      expect(order.items).toHaveLength(2);
      expect(mockRepo.save).toHaveBeenCalledWith(expect.objectContaining({ userId: 'user-123' }));
    });
  });
});
```

## What to Test (Prioritized)

```
HIGH PRIORITY (Always test):
→ Business rules and calculations
→ Validation logic (valid + invalid inputs)
→ Error handling (expected exceptions)
→ Edge cases (null, empty, boundary values)
→ State transitions (pending → confirmed → shipped)

MEDIUM PRIORITY:
→ Data transformations (DTO mapping)
→ Conditional logic (if/else branches)
→ Integration points (mock external dependencies)

LOW PRIORITY (Don't over-test):
→ Simple getters/setters
→ Framework code (React rendering, Express routing)
→ Configuration files
→ Third-party library behavior
```

## Naming Convention

```typescript
// Pattern: should [expected behavior] when [condition]
it('should throw ValidationError when email is empty')
it('should return 0 when cart has no items')
it('should apply 10% discount when order has 5+ items')
it('should not allow cancellation after shipping')

// ❌ Bad names
it('test1')
it('createOrder works')
it('handles error')
```

## Mocking Strategies

```typescript
// 1. Mock repository (test business logic in isolation)
const mockUserRepo: jest.Mocked<IUserRepository> = {
  findById: jest.fn(),
  save: jest.fn(),
  delete: jest.fn(),
};

// 2. Mock external service
jest.spyOn(emailService, 'send').mockResolvedValue({ messageId: 'msg-1' });

// 3. Mock time
jest.useFakeTimers();
jest.setSystemTime(new Date('2026-04-05T12:00:00Z'));

// 4. Inline mock for specific test
mockUserRepo.findById.mockResolvedValueOnce(createTestUser({ role: 'admin' }));
```

## Test Fixtures (Factories)

```typescript
// factories/user.factory.ts
export function createTestUser(overrides: Partial<User> = {}): User {
  return {
    id: 'user-' + crypto.randomUUID().slice(0, 8),
    name: 'Test User',
    email: `test-${Date.now()}@example.com`,
    role: 'user',
    createdAt: new Date(),
    ...overrides,  // Override any field
  };
}

// Usage in tests
const admin = createTestUser({ role: 'admin' });
const banned = createTestUser({ status: 'banned' });
```

## Edge Cases Checklist

- [ ] **Null/undefined input** — does the function handle it?
- [ ] **Empty string** — different from null
- [ ] **Empty array** — boundary for collections
- [ ] **Single item** — boundary between 0 and many
- [ ] **Large numbers** — overflow, precision (0.1 + 0.2 !== 0.3)
- [ ] **Negative numbers** — quantities, amounts
- [ ] **Unicode/special chars** — names with accents, emojis
- [ ] **Concurrent access** — race conditions
- [ ] **Maximum values** — boundary limits (max items, max length)
- [ ] **Date boundaries** — midnight, DST, timezone differences
