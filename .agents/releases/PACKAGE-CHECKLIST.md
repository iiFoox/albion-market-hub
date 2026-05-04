# HEPHAESTUS Package Checklist

> Framework Version: 8.7.0
> Purpose: repeatable package verification before publishing a framework ZIP.

---

## Required Gate

Run the pre-release gate before packaging:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/pre-release-gate.ps1 -Version 7.9.0
```

The gate must pass:

- framework integrity;
- documentation parity;
- telemetry schema validation;
- routing fixtures;
- health report generation;
- loading estimates for LITE, STANDARD, DEEP, and CRITICAL.

## Package Creation

Create the package from `.agents`:

```powershell
Compress-Archive -Path .agents/* -DestinationPath HEPHAESTUS-Framework-v7.9.0.zip -Force
```

## Package Verification

Run the gate again with package verification:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/pre-release-gate.ps1 -Version 7.9.0 -PackagePath HEPHAESTUS-Framework-v7.9.0.zip
```

The package check verifies:

- every manifest-required file exists inside the ZIP;
- the release note for the requested version exists inside the ZIP.

## Expected Warning Policy

Telemetry warnings are allowed only when they come from known legacy logs.

Use strict telemetry only after legacy logs are migrated or archived:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/pre-release-gate.ps1 -Version 7.9.0 -StrictTelemetry
```










