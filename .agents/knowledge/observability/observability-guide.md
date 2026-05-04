# Observability Stack — Logging, Metrics, Tracing, Alerting

> **Category:** Knowledge / Observability
> **Usage:** Referenced by Builder (implementation) and PM (monitoring)

---

## The Three Pillars

```
LOGS    → What happened? (text records of events)
METRICS → How much? How fast? (numeric measurements)
TRACES  → Where did time go? (request journey across services)
```

## 1. Structured Logging

```typescript
import pino from 'pino';

const logger = pino({
  level: process.env.LOG_LEVEL || 'info',
  timestamp: () => `,"timestamp":"${new Date().toISOString()}"`,
  formatters: {
    level: (label) => ({ level: label }),
  },
});

// ✅ Structured log (machine-parseable)
logger.info({
  event: 'order.created',
  orderId: 'order-123',
  userId: 'user-456',
  total: 299.90,
  items: 3,
  duration: 145,  // ms
}, 'Order created successfully');

// ❌ Unstructured log (hard to parse)
console.log('Order order-123 created for user user-456 with total 299.90');

// Log Levels:
// FATAL → System is unusable
// ERROR → Operation failed, needs attention
// WARN  → Unexpected but recoverable
// INFO  → Key business events
// DEBUG → Development troubleshooting (never in production)
```

### What to Log
| ALWAYS Log | NEVER Log |
|---|---|
| Auth events (login, logout, failures) | Passwords or credentials |
| Business operations (order, payment) | Full credit card numbers |
| Errors with context | PII (unless properly masked) |
| Performance metrics (slow queries) | Sensitive health/financial data |
| Security events (permission denied) | Encryption keys or secrets |

## 2. Metrics Strategy

```
KEY METRICS (RED Method for services):
→ Rate:    requests per second
→ Errors:  error rate (%)
→ Duration: response time (p50, p95, p99)

KEY METRICS (USE Method for resources):
→ Utilization: CPU %, memory %, disk %
→ Saturation: queue depth, thread pool usage
→ Errors: error count by type

CUSTOM BUSINESS METRICS:
→ orders_created_total (counter)
→ payment_amount_total (counter, label: currency)
→ active_users_gauge (gauge)
→ checkout_duration_seconds (histogram)
```

## 3. Distributed Tracing

```
TRACE = end-to-end journey of a single request:

User Request → API Gateway → Auth Service → Order Service → Payment → DB → Response
    |              |              |              |            |       |        |
    └──────────────┴──────────────┴──────────────┴────────────┴───────┴────────┘
                              TRACE (single trace ID)
    
Each segment = SPAN (has start time, duration, metadata)
```

## 4. Alerting Strategy (Anti-Alert-Fatigue)

```
ALERT SEVERITY:
P1 CRITICAL → Pages on-call engineer immediately
   - Service completely down
   - Data loss in progress
   - Security breach detected

P2 HIGH → Notification within 15 minutes
   - Error rate > 5%
   - Response time p95 > 5s
   - Disk space < 10%

P3 MEDIUM → Notification within 1 hour (business hours)
   - Error rate > 1%
   - Response time p95 > 2s
   - Certificate expiring in < 30 days

P4 LOW → Daily digest
   - Dependency deprecation warnings
   - Trending increase in errors
   - Cost anomalies

ANTI-FATIGUE RULES:
→ Every alert MUST have a runbook link
→ If alert fires > 5x without action → fix the root cause or delete the alert
→ Group related alerts (don't send 50 alerts for 1 incident)
→ Use alert inhibition (if DB is down, don't also alert about API errors)
```
