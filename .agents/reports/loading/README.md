# Smart Loading Reports

> Framework Version: 5.3.0
> Purpose: Store generated Smart Loading estimates and review notes.

---

## Estimator

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/estimate-loading.ps1 -Tier lite
```

With conditional groups:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/estimate-loading.ps1 -Tier standard -IncludeGroups ui,flutter
```

Show file-level detail:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/estimate-loading.ps1 -Tier deep -IncludeGroups platform -ShowFiles
```

## Token Estimate

The estimator uses a conservative approximation:

```text
approx_tokens = ceiling(bytes / 4)
```

Use this for relative comparisons between tiers, not as an exact tokenizer.
