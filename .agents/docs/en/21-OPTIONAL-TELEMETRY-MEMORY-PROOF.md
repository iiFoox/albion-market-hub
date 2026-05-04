# 21 — Optional Telemetry and Memory Proof

> Framework Version: 8.0.0
> When to use: Release validation, memory consultation audit, or optional telemetry evidence.
> Token model: Compact proof, no full memory-store loading.

---

## Purpose

This guide explains how to prove that HEPHAESTUS can consult memory safely without forcing memory telemetry into every normal session.

The proof is optional. It is designed for release gates, audits, and operator confidence.

## What It Proves

The proof checks that:

- memory policy exists;
- memory consultation protocol exists;
- memory is index-first;
- full memory-store loading is disabled by default;
- session start and close memory consultation are configured;
- telemetry schema accepts memory-proof evidence;
- telemetry retention cleanup can run in dry-run mode.

## Run the Proof

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/run-memory-proof.ps1 -Root . -WriteReport
```

Expected output:

```text
Memory proof summary: status=PASS, evidence=7
```

The latest report is written to:

```text
.agents/reports/memory/memory-proof-latest.md
```

## Validate the Wiring

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-memory-proof.ps1 -Root .
```

## Optional Telemetry Retention

Dry-run retention check:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/cleanup-telemetry.ps1 -Root . -RetentionDays 365
```

Archive old logs only after intentional approval:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/cleanup-telemetry.ps1 -Root . -RetentionDays 365 -Archive -Apply
```

The framework does not delete telemetry as part of this feature.

## Token Economy Boundary

Normal requests do not load this guide or the memory proof protocol. Load them only when the request mentions memory proof, telemetry proof, retention, release validation, or memory audit.




