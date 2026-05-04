# Serverless Architecture

> **Type:** Cloud-native, function-as-a-service pattern
> **Best For:** Variable workloads, event processing, cost optimization

---

## Overview

Serverless Architecture uses managed cloud functions that execute on-demand, scaling to zero when idle and auto-scaling under load. The cloud provider manages all infrastructure.

```
Events/Triggers ──→ ┌──────────┐ ──→ ┌──────────┐
                    │ Function │     │ Database │
API Gateway ──────→ │ (Lambda) │ ──→ │ (DynamoDB│
                    │          │     │  / RDS)  │
S3 Upload ────────→ └──────────┘ ──→ └──────────┘
                         │
SQS Message ──────→     ▼
                    ┌──────────┐
Cron Schedule ───→  │ Function │ ──→ External API
                    └──────────┘
```

## Core Components

| Component | AWS | Azure | GCP |
|---|---|---|---|
| **Functions** | Lambda | Functions | Cloud Functions |
| **API Gateway** | API Gateway | API Management | Cloud Endpoints |
| **Database** | DynamoDB | CosmosDB | Firestore |
| **Storage** | S3 | Blob Storage | Cloud Storage |
| **Queue** | SQS | Service Bus | Pub/Sub |
| **Auth** | Cognito | Azure AD B2C | Firebase Auth |
| **CDN** | CloudFront | Front Door | Cloud CDN |

## Function Design Patterns

### Single Responsibility Function
```typescript
// ONE function per operation — not one function for all CRUD
// ✅ Good: separate functions
export const createOrder = async (event: APIGatewayEvent) => { ... };
export const getOrder = async (event: APIGatewayEvent) => { ... };
export const listOrders = async (event: APIGatewayEvent) => { ... };

// ❌ Bad: one function handling everything
export const orderHandler = async (event: APIGatewayEvent) => {
  switch (event.httpMethod) {
    case 'GET': ...
    case 'POST': ...
    case 'DELETE': ...
  }
};
```

### Cold Start Mitigation
```
STRATEGIES:
→ Keep functions small (minimize dependencies)
→ Use provisioned concurrency for critical paths
→ Lazy-load heavy dependencies
→ Use lightweight runtimes (Node.js, Python > Java, .NET)
→ Connection pooling via RDS Proxy
```

## Cost Model

```
Cost = (Requests × Price per request) + (GB-seconds × Price per GB-s)

Example (AWS Lambda):
- 1M requests/month × $0.20/1M = $0.20
- 128MB × 200ms avg × 1M = 25,600 GB-seconds × $0.0000166667 = $0.43
- Total: $0.63/month for 1M requests

VS Traditional Server:
- t3.medium (24/7) = ~$30/month
- Break-even: ~47M requests/month
```

---

## When to Use

| ✅ USE WHEN | ❌ DON'T USE WHEN |
|---|---|
| Variable/unpredictable traffic | Consistent high traffic (24/7 load) |
| Pay-per-use cost is important | Predictable workload (reserved instances cheaper) |
| Event-driven processing | Long-running processes (> 15 min) |
| Rapid prototyping | Need full infrastructure control |
| Infrequent batch jobs | Real-time low-latency requirements (cold starts) |
| Startup with limited ops resources | Large team with DevOps expertise |

## Common Mistakes

1. **Monolith in a Lambda** — giant functions with all business logic defeat the purpose
2. **Ignoring cold starts** — critical for user-facing APIs; use provisioned concurrency
3. **Not handling timeouts** — Lambda has max 15min; design for shorter execution
4. **Direct DB connections** — each invocation opens a new connection; use connection pooling
5. **No local development** — use SAM/Serverless Framework for local testing
6. **Vendor lock-in** — abstract cloud-specific code behind interfaces
7. **Missing observability** — distributed tracing is essential (X-Ray, CloudWatch)
