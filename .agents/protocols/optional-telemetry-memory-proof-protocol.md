# Optional Telemetry and Memory Proof Protocol

> Framework Version: 7.7.0
> Purpose: Provide compact proof that memory consultation rules can be audited without expanding normal-session token usage.

---

## Scope

This protocol is optional and evidence-oriented. It does not require every normal request to write a telemetry file. It defines how HEPHAESTUS can prove that memory consultation is available, policy-bound, tier-aware, and auditable when the operator or release gate asks for evidence.

Use this protocol when:

- validating a release;
- auditing whether memory consultation is wired correctly;
- proving that memory access remains index-first and tier-aware;
- checking optional telemetry retention behavior.

## Token Economy Rule

Do not load memory stores broadly for proof generation.

The proof must inspect only:

- `.agents/config/memory-policy.yaml`
- `.agents/protocols/memory-consultation-protocol.md`
- `.agents/memory/context-db/session-checkpoint.md`
- `.agents/memory/context-db/session-brief.md`
- `.agents/memory/MEMORY-INDEX.md`
- `.agents/config/telemetry-schema.yaml`

The proof may reference file paths instead of embedding memory content.

## Required Evidence

The memory proof must show:

- memory consultation policy is present;
- memory consultation protocol is present;
- index-first loading is enabled;
- full-store loading is disabled by default;
- session start and session close consultation are configured;
- telemetry schema accepts memory-proof evidence;
- retention cleanup can run in dry-run mode.

## Optional Retention Enforcement

Retention enforcement is manual and dry-run-first:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/cleanup-telemetry.ps1 -Root . -RetentionDays 365
```

Apply with archive only when the operator intentionally approves:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/cleanup-telemetry.ps1 -Root . -RetentionDays 365 -Archive -Apply
```

Do not delete telemetry logs as part of this protocol.

## Completion Criteria

The protocol is complete when:

- the proof runner emits a compact report;
- the checker validates config, schema, protocol, and loading group;
- the pre-release gate includes the checker;
- normal Smart Loading does not include memory proof unless the trigger is relevant.

