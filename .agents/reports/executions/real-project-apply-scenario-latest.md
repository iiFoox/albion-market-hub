---
log_type: "real-project-apply-scenario"
framework_version: "7.5.0"
status: "PASS"
generated_at: "2026-04-29T21:51:16.1481280-03:00"
fixture_root: "C:\Users\dudes\AppData\Local\Temp\hephaestus-real-apply-scenario-0a1f796d6f9f4c449009838e4ef053e8"
---

# Real Project Apply Scenario Report

## Checks

| Check | Status | Notes |
|---|---:|---|
| audit-trail | PASS | Audit trail contains DryRun, backup, Apply, and restore events |
| controlled-apply | PASS | Apply created marker and backup artifact |
| dry-run | PASS | DryRun completed without marker mutation |
| evidence-reports | PASS | Real execution and quality gate reports created |
| post-apply-quality-gate | PASS | Quality gate passed after Apply |
| pre-apply-quality-gate | PASS | Quality gate passed before Apply |
| restore | PASS | Restore command succeeded against latest backup |
