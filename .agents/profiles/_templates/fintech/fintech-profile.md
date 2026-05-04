# Fintech Specialization Profile

> **Category:** Profile / Industry-Specific
> **Usage:** Applied when project involves financial services

---

## Activation Trigger
```
ACTIVATE WHEN:
→ Project handles money, payments, or financial transactions
→ Project processes or stores financial data
→ Project requires PCI-DSS, SOX, or banking compliance
→ User mentions: fintech, banking, payments, trading, insurance
```

## Security Requirements (PCI-DSS Overlay)

### Mandatory Controls
- [ ] **Encryption everywhere** — AES-256 at rest, TLS 1.3 in transit
- [ ] **Tokenization** — never store raw card numbers; use payment processor tokens
- [ ] **Audit logging** — log ALL data access with who, what, when, where
- [ ] **Role-based access** — principle of least privilege enforced
- [ ] **Session management** — 15-min timeout for admin, 30-min for users
- [ ] **MFA required** — for all admin and financial operations
- [ ] **Key rotation** — encryption keys rotated every 90 days
- [ ] **Penetration testing** — annual third-party pentest required
- [ ] **Vulnerability scanning** — automated weekly scans
- [ ] **No sensitive data in logs** — mask card numbers, SSN, passwords

### Financial Data Classification
| Classification | Examples | Storage | Access |
|---|---|---|---|
| **Restricted** | Card numbers, CVV, bank account | Tokenized only | Need-to-know |
| **Confidential** | SSN, tax ID, income | Encrypted at rest | Authorized roles |
| **Internal** | Transaction history, balances | Encrypted at rest | Authenticated users |
| **Public** | Product names, interest rates | Standard | Anyone |

## Audit Requirements

```typescript
// Every financial operation MUST produce an audit entry
interface AuditEntry {
  id: string;
  timestamp: Date;
  action: 'create' | 'update' | 'delete' | 'read' | 'transfer';
  entity: string;           // 'transaction', 'account', 'user'
  entityId: string;
  performedBy: string;      // User ID
  ipAddress: string;
  userAgent: string;
  previousState?: object;   // For updates
  newState?: object;
  amount?: number;          // For financial operations
  currency?: string;
  result: 'success' | 'failure';
  failureReason?: string;
}

// RULE: Audit logs are IMMUTABLE and APPEND-ONLY
// RULE: Audit logs must be retained for 7 years minimum
// RULE: Audit logs must be stored separately from application data
```

## Money Handling Rules

```typescript
// NEVER use floating-point for money
// ❌ const price = 29.99;  // Floating point = money bugs

// ✅ Use integer cents (smallest currency unit)
const priceInCents = 2999;  // R$ 29.99 = 2999 centavos

// ✅ Or use a Money value object
class Money {
  constructor(
    public readonly cents: number,    // Always integer
    public readonly currency: string, // ISO 4217: BRL, USD, EUR
  ) {
    if (!Number.isInteger(cents)) throw new Error('Cents must be integer');
  }

  add(other: Money): Money {
    this.assertSameCurrency(other);
    return new Money(this.cents + other.cents, this.currency);
  }

  format(): string {
    return new Intl.NumberFormat('pt-BR', {
      style: 'currency',
      currency: this.currency,
    }).format(this.cents / 100);
  }
}
```

## Transaction Patterns

```
IDEMPOTENCY KEY:
→ Every financial operation MUST have an idempotency key
→ Prevents double charges, duplicate transfers
→ Key = client-generated UUID, stored server-side

DOUBLE-ENTRY BOOKKEEPING:
→ Every transaction creates TWO entries: debit + credit
→ Sum of all debits MUST equal sum of all credits
→ No money appears or disappears from the system

RECONCILIATION:
→ Daily reconciliation between app records and payment processor
→ Automated alerts for discrepancies > $0.01
→ Monthly reconciliation reports
```
