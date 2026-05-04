# Framework Health Reports

> Framework Version: 5.5.0
> Purpose: Store generated health reports for HEPHAESTUS installations.

---

## Generate Report

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/framework-health.ps1 -WriteReport
```

The latest generated report is written to:

```text
.agents/reports/health/latest.md
```
