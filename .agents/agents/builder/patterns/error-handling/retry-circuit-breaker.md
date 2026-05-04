# Retry with Backoff & Circuit Breaker Patterns

> **Category:** Builder / Resilience
> **Usage:** Patterns for handling transient failures in distributed systems

---

## Retry with Exponential Backoff

```typescript
interface RetryOptions {
  maxRetries: number;
  baseDelayMs: number;
  maxDelayMs: number;
  retryableErrors?: string[];  // Error types to retry
}

async function withRetry<T>(
  fn: () => Promise<T>,
  options: RetryOptions = { maxRetries: 3, baseDelayMs: 1000, maxDelayMs: 30000 }
): Promise<T> {
  let lastError: Error;

  for (let attempt = 0; attempt <= options.maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;

      // Don't retry non-retryable errors
      if (options.retryableErrors && !options.retryableErrors.includes(lastError.name)) {
        throw lastError;
      }

      if (attempt === options.maxRetries) break;

      // Exponential backoff with jitter
      const delay = Math.min(
        options.baseDelayMs * Math.pow(2, attempt) + Math.random() * 1000,
        options.maxDelayMs
      );
      
      console.warn(`Attempt ${attempt + 1} failed, retrying in ${delay}ms...`, lastError.message);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }

  throw lastError!;
}

// Usage
const result = await withRetry(
  () => externalApi.fetchData(id),
  { maxRetries: 3, baseDelayMs: 1000, maxDelayMs: 10000 }
);
```

## Circuit Breaker Pattern

```
STATES:
CLOSED ──(failures >= threshold)──→ OPEN
                                      │
         ←──(probe succeeds)──    HALF-OPEN
                                      │
OPEN ────(timeout expires)────→  HALF-OPEN
         ←──(probe fails)────── HALF-OPEN
```

```typescript
enum CircuitState { CLOSED, OPEN, HALF_OPEN }

class CircuitBreaker {
  private state = CircuitState.CLOSED;
  private failures = 0;
  private lastFailure = 0;
  private successesInHalfOpen = 0;

  constructor(
    private readonly threshold: number = 5,      // Failures before opening
    private readonly resetTimeoutMs: number = 30000, // Time before half-open
    private readonly halfOpenSuccesses: number = 3,  // Successes to close
  ) {}

  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === CircuitState.OPEN) {
      if (Date.now() - this.lastFailure >= this.resetTimeoutMs) {
        this.state = CircuitState.HALF_OPEN;
        this.successesInHalfOpen = 0;
      } else {
        throw new Error('Circuit breaker is OPEN — service unavailable');
      }
    }

    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }

  private onSuccess() {
    if (this.state === CircuitState.HALF_OPEN) {
      this.successesInHalfOpen++;
      if (this.successesInHalfOpen >= this.halfOpenSuccesses) {
        this.state = CircuitState.CLOSED;
        this.failures = 0;
      }
    }
    this.failures = 0;
  }

  private onFailure() {
    this.failures++;
    this.lastFailure = Date.now();
    if (this.failures >= this.threshold) {
      this.state = CircuitState.OPEN;
    }
  }
}

// Usage
const paymentCircuit = new CircuitBreaker(5, 30000);
const result = await paymentCircuit.execute(() => stripe.charges.create(data));
```

## Graceful Degradation

```typescript
// Fallback pattern: try primary, fallback to secondary
async function getProductRecommendations(userId: string): Promise<Product[]> {
  try {
    // Primary: ML recommendation service
    return await recommendationService.getPersonalized(userId);
  } catch (error) {
    logger.warn('Recommendation service unavailable, using fallback', { error });

    try {
      // Secondary: cached popular products
      return await cache.get('popular-products');
    } catch {
      // Tertiary: hardcoded defaults
      return DEFAULT_PRODUCTS;
    }
  }
}
```

## When to Use Each Pattern

| Pattern | Use When | Don't Use When |
|---|---|---|
| **Retry** | Transient failures (network timeout, 503) | Permanent failures (400, 404) |
| **Circuit Breaker** | External service may be down for extended period | Internal function calls |
| **Graceful Degradation** | Feature can work with reduced quality | Feature is all-or-nothing |
| **Retry + Circuit Breaker** | Critical external service (payment, auth) | Simple internal operations |
