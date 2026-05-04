# 09 — Error Correction

> **When things go wrong:** How the framework handles failures, rejections, and correction loops.

---

## Correction Loops

When the Validator rejects the Builder's output:

```
Attempt 1: Builder implements → Validator rejects → Builder corrects
Attempt 2: Builder re-implements → Validator rejects → Orchestrator reviews
Attempt 3: Orchestrator may re-plan or escalate to user
```

**Maximum 3 loops** before mandatory escalation.

## What Happens on Failure

| Failure Type | Framework Response |
|-------------|-------------------|
| **Tests fail** | Builder gets specific failures, fixes, resubmits |
| **Security issue** | Auto-escalate to DEEP, security-first fix |
| **Platform incompatible** | Platform Guardian provides platform-specific fix |
| **Design rejected** | UI/UX Specialist provides exact changes needed |
| **Plan was wrong** | Re-run planning phase with new information |
| **Unknown error** | Researcher investigates, then re-plan |

## How to Recover from a Bad Session

If a session went wrong and produced broken state:

```
HEPHAESTUS — recovery mode.
Read the checkpoint and git status.
The last session produced issues: [describe what went wrong].
Revert to the last known good state and re-approach the task.
```

## Learning from Failures

Every failure is recorded in memory as a `failure` learning:
```markdown
## What — [what failed]
## Context — [what we were trying to do]
## Evidence — [how we know it failed]
## Reuse Rule — [how to avoid this in the future]
```

These learnings are consulted before future similar tasks, preventing repeat failures.
