# Universal Triage Protocol

> **Protocol ID:** HEPHAESTUS-PROTOCOL-007
> **Type:** Agent Routing
> **Priority:** MANDATORY — executes on every request, after complexity classification
> **Status:** Active

---

## Purpose

Ensure **no agent is omitted** when it should participate. Every agent performs a lightweight relevance scan on every request and declares its participation need.

**Problem this solves:** The Orchestrator sometimes fails to activate an agent that would add value, causing gaps in quality, security, or documentation.

---

## How It Works

```
1. User sends request
2. Adaptive Complexity classifies level (LITE/STANDARD/DEEP/CRITICAL)
3. ALL agents perform TRIAGE SCAN (lightweight, ~1 paragraph each)
4. Orchestrator receives all triage results
5. Orchestrator builds pipeline based on:
   a. Complexity level minimum requirements
   b. Agent self-assessments
   c. CRITICAL flags (mandatory inclusion)
6. Pipeline executes
```

## Triage Response Format

Each agent MUST respond with this structure:

```yaml
agent: [agent-name]
relevance: CRITICAL | RELEVANT | OPTIONAL | NOT_NEEDED
confidence: HIGH | MEDIUM | LOW
reason: "[1 sentence explaining why]"
risk_if_skipped: "[1 sentence: what could go wrong if this agent doesn't participate]"
recommended_mode: "deep | standard | lite | skip"
```

## Relevance Levels

| Level | Meaning | Orchestrator Action |
|---|---|---|
| `CRITICAL` | Agent MUST participate; skipping creates risk | Include. If excluded, must justify in telemetry |
| `RELEVANT` | Agent adds clear value; recommended | Include unless complexity level restricts |
| `OPTIONAL` | Agent could add minor value | Include only if complexity allows |
| `NOT_NEEDED` | Agent has nothing to contribute | Skip |

## Mandatory Rules

### Rule 1: CRITICAL Override
```
IF any agent declares relevance = CRITICAL
AND Orchestrator excludes that agent
THEN Orchestrator MUST log justification in telemetry
AND PM MUST flag this in next evolution log
```

### Rule 2: Minimum Agents per Level
```
LITE:     Orchestrator + Builder (minimum 2)
STANDARD: Orchestrator + relevant agents (minimum 4)
DEEP:     Orchestrator + all RELEVANT/CRITICAL (minimum 6)
CRITICAL: ALL agents participate (no exceptions)
```

### Rule 3: Always-On Agents
```
These agents ALWAYS participate regardless of complexity:
→ Orchestrator (routes everything)
→ Project Manager (observes everything for telemetry)
```

### Rule 4: Triage Weight
```
Triage scan must be LIGHTWEIGHT:
→ No deep analysis
→ No code generation
→ No research
→ Just: "Does this request touch my domain? Yes/No/Maybe + why"
→ Target: < 100 words per agent
```

## Triage Examples

### Example 1: "Fix the login button color"
```yaml
# Researcher
agent: researcher
relevance: NOT_NEEDED
reason: "Simple UI fix, no research needed."
risk_if_skipped: "None."

# Planner
agent: planner
relevance: NOT_NEEDED
reason: "No planning needed for single CSS change."
risk_if_skipped: "None."

# Builder
agent: builder
relevance: CRITICAL
reason: "Implementation required."
risk_if_skipped: "Change won't be made."

# Validator
agent: validator
relevance: OPTIONAL
reason: "Minor change, low regression risk."
risk_if_skipped: "Minimal."

# Documentation
agent: documentation
relevance: NOT_NEEDED
reason: "No documentation impact."
risk_if_skipped: "None."

# Delivery
agent: delivery
relevance: RELEVANT
reason: "Change should be committed."
risk_if_skipped: "Change may be lost."

# PM
agent: project-manager
relevance: RELEVANT
confidence: HIGH
reason: "Always observes for telemetry."
risk_if_skipped: "Pipeline metrics lost."
```

### Example 2: "Implement Stripe payment integration"
```yaml
# Researcher
agent: researcher
relevance: CRITICAL
reason: "Payment integration requires technology evaluation and risk analysis."
risk_if_skipped: "Wrong library choice, missing security requirements."

# Planner
agent: planner
relevance: CRITICAL
reason: "Payment needs phased approach, webhook handling, error flows."
risk_if_skipped: "Incomplete implementation plan, missing edge cases."

# Builder
agent: builder
relevance: CRITICAL
reason: "Core implementation."
risk_if_skipped: "Nothing gets built."

# Validator
agent: validator
relevance: CRITICAL
reason: "Financial security audit mandatory, OWASP API checks."
risk_if_skipped: "Security vulnerabilities in payment flow."

# Documentation
agent: documentation
relevance: RELEVANT
reason: "Payment API docs, webhook handling, error codes."
risk_if_skipped: "Undocumented payment flow."

# Delivery
agent: delivery
relevance: RELEVANT
reason: "Structured commit + minor version bump."
risk_if_skipped: "Version not tracked."

# PM
agent: project-manager
relevance: RELEVANT
reason: "Track scope, risk, telemetry."
risk_if_skipped: "No pipeline metrics."
```

## Integration with Orchestrator

The Orchestrator's system prompt must include:

```
BEFORE BUILDING ANY PIPELINE:
1. Classify complexity (Adaptive Complexity Protocol)
2. Request triage from ALL agents
3. Build pipeline using triage results + complexity minimums
4. If excluding a CRITICAL agent, document justification
5. Proceed with execution
```
