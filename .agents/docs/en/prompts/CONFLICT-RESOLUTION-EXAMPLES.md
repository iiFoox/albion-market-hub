# Conflict Resolution Examples

> **Purpose:** Shows how agents handle disagreements and how the Orchestrator resolves them  
> **Protocol:** See `protocols/collaboration-protocol.md` for full specification

---

## Example 1: Technical Disagreement — REST vs GraphQL

### Situation
Builder wants REST API. Researcher recommends GraphQL.

### Builder's Position
```
POSITION: Use REST API
REASONING:
- Team already knows REST patterns
- Existing endpoints follow REST conventions
- Simpler to implement and debug
- Better caching with HTTP standards
RISK OF MY POSITION: Over-fetching data on complex screens
RISK OF OPPOSING: Learning curve, tooling complexity
COMPROMISE: REST with query parameters for field selection
CONFIDENCE: 0.75
```

### Researcher's Position
```
POSITION: Use GraphQL
REASONING:
- Multiple screens need different subsets of same data
- Mobile needs minimal payloads (bandwidth)
- Schema provides auto-documentation
- Single endpoint simplifies API management
RISK OF MY POSITION: Learning curve, complexity for simple CRUD
RISK OF OPPOSING: N+1 API calls on dashboard screen
COMPROMISE: GraphQL for complex queries, REST for simple CRUD
CONFIDENCE: 0.70
```

### Orchestrator Resolution
```
DECISION: REST (Builder's position)

REASONING:
1. Memory check: No prior GraphQL experience in project
2. Risk comparison: Learning curve risk > over-fetching risk
3. Alignment: User asked for "simple API" — REST aligns better
4. Simplicity: When evidence is equal, prefer simpler approach
5. Reversibility: Can migrate to GraphQL later if needed

FOLLOW-UP: If over-fetching becomes a real problem, revisit GraphQL
LEARNING: "For teams without GraphQL experience, REST is safer default"
```

---

## Example 2: Quality Disagreement — Validator Rejects Builder

### Situation
Validator flags performance concern. Builder disagrees.

### Validator's Flag
```
ISSUE: ListView.builder in dashboard loads all 500+ items at once
SEVERITY: MEDIUM
EVIDENCE: No pagination, no lazy loading, potential memory issue
RECOMMENDATION: Add pagination with 20 items per page
```

### Builder's Response
```
DISAGREE: Items are lightweight (just text + icon)
REASONING:
- Each item is ~200 bytes in memory
- 500 × 200 = 100KB — trivial for modern devices
- Adding pagination increases complexity significantly
- ListView.builder already virtualizes rendering
CONFIDENCE: 0.80
```

### Orchestrator Resolution
```
DECISION: Builder's position (no pagination now)

REASONING:
1. ListView.builder already handles virtualization
2. 100KB memory is indeed trivial
3. Premature optimization adds complexity
4. BUT: Add monitoring — if list grows to 5000+, revisit

FOLLOW-UP: Add a Quick Learning noting the threshold
LEARNING: "ListView.builder handles 500 lightweight items fine. Revisit at 5000+"
```

---

## Example 3: Escalation to User

### Situation
Dark mode: auto-detect system setting vs manual toggle only

### UI/UX Specialist
```
POSITION: Auto-detect system setting + manual override
REASONING: Best UX practice, respects user OS preferences
```

### Builder
```
POSITION: Manual toggle only
REASONING: Simpler to implement, system detection has edge cases on Windows
```

### Orchestrator Cannot Resolve → Escalates
```
## 🤔 Decision Needed

The agents disagree on dark mode implementation:

### Option A: UI/UX Specialist — Auto-detect + manual override
- **Pros:** Better UX, respects OS settings, industry standard
- **Cons:** More complex, Windows detection edge cases
- **Risk:** LOW

### Option B: Builder — Manual toggle only
- **Pros:** Simpler implementation, no platform edge cases
- **Cons:** User must always set manually, ignores OS preference
- **Risk:** LOW

### Framework Recommendation
Option A is the industry standard, but Option B is valid for MVP.
Your call based on project priorities.
```

---

## Correction Loop Example

### Loop 1: Validator rejects
```
VALIDATOR: Form submission doesn't validate email format
→ Builder fixes: adds email regex validation
→ Resubmits
```

### Loop 2: Validator rejects again
```
VALIDATOR: Email validation passes "test@" as valid
→ Orchestrator reviews: confirms the regex is too permissive
→ Builder fixes: uses stricter RFC 5322 regex
→ Resubmits
```

### Loop 3: Passes ✅
```
VALIDATOR: Email validation now correctly rejects all invalid formats
→ APPROVED
→ Learning saved: "Use RFC 5322 regex for email validation, not simple @ check"
```

---

## Key Principles

1. **Evidence wins** — Not seniority or preference
2. **Memory informs** — Past decisions guide current ones
3. **Max 3 loops** — Then escalate to user
4. **Always record** — Every resolution becomes a learning
5. **Compromise is valid** — Not every conflict needs a winner
