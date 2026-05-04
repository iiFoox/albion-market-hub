# 07 — Critical Workflow (CRITICAL)

> **Complexity:** CRITICAL  
> **When to use:** Production deployments, payment/health systems, compliance-required changes  
> **Active agents:** ALL agents at maximum depth

---

## When This Activates

Automatic triggers:
- Payment or financial data involved
- Health/medical data (HIPAA)
- Production deployment scope
- HIGH severity security issue
- User explicitly requests CRITICAL level

## What's Different

Everything from DEEP, plus:

| Extra Measure | Purpose |
|--------------|---------|
| **Audit trail** | Every decision documented with timestamp |
| **Compliance check** | Industry-specific rules verified (PCI, HIPAA, LGPD) |
| **Rollback plan** | Mandatory before any implementation |
| **Penetration testing** | Security audit at pentest depth |
| **Data flow diagrams** | Where sensitive data flows |
| **2-review minimum** | At least 2 validation passes |

## How to Trigger Manually

```
Use CRITICAL pipeline for this task.
This involves [payment data / production deployment / regulated data].
```

## Important: You Probably Don't Need This

Most development work is LITE or STANDARD. CRITICAL is reserved for high-stakes scenarios. The framework auto-escalates if it detects critical signals, so you rarely need to request it manually.
