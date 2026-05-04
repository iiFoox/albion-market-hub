# Release Evidence Bundle Protocol

> Framework Version: 7.4.0
> Status: Active
> Loading Group: release-evidence

## Purpose

This protocol defines a compact release evidence bundle for HEPHAESTUS releases.

The bundle does not replace the pre-release gate. It summarizes evidence from existing gates, documentation checks, scenario reports, and package validation into one auditable report.

## Evidence Contract

The bundle should capture:

- release version;
- package path and package presence;
- framework integrity evidence;
- documentation parity evidence;
- scenario evidence;
- package gate evidence;
- known missing evidence, if any.

## Token Policy

The bundle must remain compact. It should reference report paths and summary lines instead of embedding full gate output.

## Output

Latest report:

```text
.agents/reports/releases/release-evidence-latest.md
```

