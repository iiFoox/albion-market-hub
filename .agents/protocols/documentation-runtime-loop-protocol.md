# Documentation Runtime Loop Protocol

> Framework Version: 7.3.0
> Status: Active
> Loading Group: documentation-runtime

## Purpose

This protocol proves that documentation enforcement is not only a static policy. It defines a lightweight runtime loop that evaluates project changes, determines documentation impact, and writes compact evidence.

## Runtime Contract

For a changed-file set, the loop must:

- classify documentation impact;
- identify documents that should be updated or reviewed;
- allow `not_impacted` only with a reason;
- create a compact report;
- avoid loading broad documentation unless the change requires it.

## Impact Rules

- Source code changes require at least a documentation impact decision.
- Config, API, architecture, workflow, protocol, or user-facing behavior changes usually require docs review.
- Documentation-only changes require parity/review consideration.
- Release changes require changelog/release-note consideration.

## Token Policy

The runtime loop should load only:

- changed file paths;
- documentation policy;
- compact impact template;
- directly relevant docs.

It should not load the whole documentation tree for normal code changes.

