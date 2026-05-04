# Integration & E2E Testing Guide

> **Category:** Validator / Testing Playbook
> **Usage:** Reference for testing component interactions and full user flows

---

## Integration Testing

### API Integration Test (Supertest + Jest)
```typescript
import request from 'supertest';
import { app } from '../src/app';
import { prisma } from '../src/lib/prisma';

describe('POST /api/orders', () => {
  let authToken: string;

  beforeAll(async () => {
    // Seed test user + get auth token
    const user = await prisma.user.create({ data: testUserData });
    authToken = generateTestToken(user.id);
  });

  afterAll(async () => {
    await prisma.$transaction([
      prisma.orderItem.deleteMany(),
      prisma.order.deleteMany(),
      prisma.user.deleteMany(),
    ]);
    await prisma.$disconnect();
  });

  it('should create order and return 201', async () => {
    const response = await request(app)
      .post('/api/orders')
      .set('Authorization', `Bearer ${authToken}`)
      .send({
        items: [
          { productId: 'prod-1', quantity: 2 },
          { productId: 'prod-2', quantity: 1 },
        ],
      })
      .expect(201);

    expect(response.body.data).toMatchObject({
      status: 'pending',
      items: expect.arrayContaining([
        expect.objectContaining({ productId: 'prod-1', quantity: 2 }),
      ]),
    });

    // Verify in database
    const dbOrder = await prisma.order.findUnique({ where: { id: response.body.data.id } });
    expect(dbOrder).not.toBeNull();
    expect(dbOrder!.userId).toBe(testUserId);
  });

  it('should return 401 without auth', async () => {
    await request(app)
      .post('/api/orders')
      .send({ items: [] })
      .expect(401);
  });

  it('should return 400 with empty items', async () => {
    await request(app)
      .post('/api/orders')
      .set('Authorization', `Bearer ${authToken}`)
      .send({ items: [] })
      .expect(400);
  });
});
```

### Database Integration Test
```typescript
describe('UserRepository', () => {
  const repo = new PrismaUserRepository(prisma);

  afterEach(async () => {
    await prisma.user.deleteMany();
  });

  it('should save and retrieve user', async () => {
    const user = User.create({ name: 'John', email: 'john@test.com' });
    await repo.save(user);

    const found = await repo.findById(user.id);
    expect(found).not.toBeNull();
    expect(found!.email).toBe('john@test.com');
  });

  it('should return null for non-existent user', async () => {
    const found = await repo.findById('non-existent-id');
    expect(found).toBeNull();
  });
});
```

---

## E2E Testing (Playwright)

### Setup
```typescript
// playwright.config.ts
export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  retries: process.env.CI ? 2 : 0,
  webServer: {
    command: 'npm run dev',
    port: 3000,
    reuseExistingServer: !process.env.CI,
  },
  use: {
    baseURL: 'http://localhost:3000',
    screenshot: 'only-on-failure',
    trace: 'retain-on-failure',
  },
});
```

### E2E Test: Full User Flow
```typescript
import { test, expect } from '@playwright/test';

test.describe('Order Flow', () => {
  test.beforeEach(async ({ page }) => {
    // Login
    await page.goto('/login');
    await page.fill('[data-testid="email"]', 'test@example.com');
    await page.fill('[data-testid="password"]', 'TestPass123!');
    await page.click('[data-testid="login-button"]');
    await expect(page).toHaveURL('/dashboard');
  });

  test('should create order from product page', async ({ page }) => {
    // Navigate to product
    await page.goto('/products');
    await page.click('[data-testid="product-card-1"]');

    // Add to cart
    await page.click('[data-testid="add-to-cart"]');
    await expect(page.locator('[data-testid="cart-count"]')).toHaveText('1');

    // Go to checkout
    await page.click('[data-testid="cart-icon"]');
    await page.click('[data-testid="checkout-button"]');

    // Fill shipping
    await page.fill('[data-testid="address"]', 'Rua Test, 123');
    await page.fill('[data-testid="city"]', 'São Paulo');
    await page.click('[data-testid="confirm-order"]');

    // Verify success
    await expect(page.locator('[data-testid="order-success"]')).toBeVisible();
    await expect(page.locator('[data-testid="order-id"]')).not.toBeEmpty();
  });
});
```

## Test Categories Pyramid

```
         ╱╲
        ╱ E2E ╲           10% — Critical user flows only
       ╱────────╲
      ╱Integration╲       20% — API, DB, service interactions
     ╱──────────────╲
    ╱   Unit Tests    ╲    70% — Business logic, pure functions
   ╱────────────────────╲
```

## CI/CD Test Strategy

```yaml
# Run in order: fast → slow
jobs:
  unit-tests:        # 30 seconds
    run: npm run test:unit
  
  integration-tests: # 2-5 minutes
    needs: unit-tests
    services: [postgres, redis]
    run: npm run test:integration
  
  e2e-tests:         # 5-10 minutes
    needs: integration-tests
    run: npx playwright test
```
