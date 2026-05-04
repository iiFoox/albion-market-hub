# Operational Polish and Score Review Protocol

> Framework Version: 7.5.0
> Status: Active
> Loading Group: operational-review

## Purpose

This protocol defines the final operational review pass for a release sequence.

It converts local evidence into:

- a score rubric;
- residual risk review;
- token economy review;
- final readiness statement.

## Review Inputs

Use compact local evidence:

- `.agents/reports/releases/release-evidence-latest.md`
- `.agents/reports/health/latest.md`
- Smart Loading estimates from `.agents/tools/estimate-loading.ps1`
- framework manifest counts;
- documentation parity result from the latest pre-release gate.

## Scoring Model

Score the framework across:

- structural integrity;
- safety enforcement;
- real-project execution readiness;
- documentation continuity;
- release governance;
- token economy preservation;
- remaining operational gaps.

The score is advisory. It is a release-readiness signal, not a guarantee that all future projects will be implemented without human judgment.

## Token Policy

The review must remain summary-first. It should not paste full gate outputs or scan broad docs unless a failure requires diagnosis.

