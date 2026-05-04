# Disaster Recovery & Resilience Patterns

> **Category:** Knowledge / Resilience
> **Usage:** Referenced by all agents for building resilient, recoverable systems

---

## DR Strategies by Tier

| Tier | RTO | RPO | Strategy | Cost |
|---|---|---|---|---|
| **Tier 1: Critical** | < 1 hour | 0 (zero data loss) | Active-Active multi-region | $$$$ |
| **Tier 2: Important** | < 4 hours | < 1 hour | Warm standby | $$$ |
| **Tier 3: Standard** | < 24 hours | < 4 hours | Pilot light (scaled down replica) | $$ |
| **Tier 4: Low** | < 72 hours | < 24 hours | Backup and restore | $ |

```
RTO = Recovery Time Objective (how fast must we recover?)
RPO = Recovery Point Objective (how much data loss is acceptable?)
```

## Backup Strategies

### Database Backups
```
AUTOMATED BACKUP SCHEDULE:
→ Full backup: daily at 03:00 UTC
→ Incremental: every 6 hours
→ WAL archiving: continuous (PostgreSQL)
→ Retention: 30 days (hot) + 1 year (cold storage)
→ Cross-region replication: async to secondary region

TESTING (monthly):
1. Restore backup to test environment
2. Verify data integrity (row counts, checksums)
3. Measure actual recovery time
4. Document results in DR test log
```

### Application Backups
```
WHAT TO BACKUP:
→ Database (automated, encrypted)
→ File storage (S3/Blob versioning enabled)
→ Environment configuration (in secrets manager, versioned)
→ Infrastructure as Code (git history IS the backup)
→ DNS configuration (documented, exportable)

WHAT NOT TO BACKUP:
→ Logs (they have their own retention)
→ Cache (Redis) — it's ephemeral by design
→ Build artifacts — can be rebuilt from source
```

## Failover Patterns

### Active-Passive
```
Primary Region ──(replication)──→ Secondary Region (standby)
         ↓ (failure detected)
DNS switches to Secondary → Secondary promoted to Primary
Recovery: 5-30 minutes
```

### Active-Active
```
Region A ←──(sync)──→ Region B
    ↑                     ↑
    └──── Load Balancer ──┘ (routes to nearest/healthiest)
Recovery: automatic, near-zero downtime
Complexity: conflict resolution needed for writes
```

## Data Integrity Patterns

### Idempotency
```typescript
// Every write operation should be safe to retry
// Use idempotency keys for critical operations
app.post('/api/payments', async (req, res) => {
  const idempotencyKey = req.headers['idempotency-key'];
  
  // Check if this operation was already processed
  const existing = await redis.get(`idempotent:${idempotencyKey}`);
  if (existing) return res.json(JSON.parse(existing));
  
  // Process payment
  const result = await processPayment(req.body);
  
  // Store result for deduplication (24h)
  await redis.setex(`idempotent:${idempotencyKey}`, 86400, JSON.stringify(result));
  
  return res.status(201).json(result);
});
```

### Feature Flags for Safe Rollouts
```typescript
// Gradual rollout with kill switch
const featureFlags = {
  'new-checkout-flow': {
    enabled: true,
    rolloutPercentage: 25,    // 25% of users
    allowlist: ['user-beta-1', 'user-beta-2'], // Always enabled
    blocklist: [],              // Always disabled
  },
};

function isFeatureEnabled(flag: string, userId: string): boolean {
  const config = featureFlags[flag];
  if (!config?.enabled) return false;
  if (config.blocklist.includes(userId)) return false;
  if (config.allowlist.includes(userId)) return true;
  
  // Deterministic percentage based on user ID
  const hash = hashCode(userId + flag);
  return (hash % 100) < config.rolloutPercentage;
}
```

## Chaos Engineering Principles

```
RULES:
1. Start with a hypothesis: "The system will handle X failure gracefully"
2. Run experiments in production (with guardrails)
3. Minimize blast radius (start small, expand gradually)
4. Automate experiments (run regularly, not just once)

EXPERIMENT IDEAS:
→ Kill a random pod/instance → Does the system recover?
→ Add 500ms latency to database → Does the app degrade gracefully?
→ Fill disk to 95% → Are alerts triggered? Does app handle it?
→ Expire all sessions → Do users get redirected to login properly?
→ Return 503 from payment provider → Does checkout show proper error?
```
