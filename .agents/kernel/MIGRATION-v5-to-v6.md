# Migration Guide — v5.x to v6.0.0

> Framework Version: 8.0.0
> Scope: Upgrade hardened 5.x installs to the stable kernel contract.

---

## Summary

v6.0.0 does not replace the v5.8.0 operating model. It formalizes it.

The migration is mostly metadata and governance:

- kernel contract files are added;
- compatibility policy is added;
- host support matrix is added;
- release gate now validates the kernel contract;
- framework version metadata moves to `6.0.0`.

## Required Steps

1. Keep the `.agents` directory layout intact.
2. Add the `.agents/kernel` directory.
3. Add the kernel contract, compatibility policy, migration guide, and host matrix.
4. Update framework metadata to `6.0.0`.
5. Update the integrity manifest with kernel files.
6. Run the pre-release gate.
7. Package the framework.
8. Run the pre-release gate with `-PackagePath`.

## Behavioral Changes

No normal task workflow changes are required.

The release process changes because the kernel contract is now validated by:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-kernel-contract.ps1
```

The same check is included in:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/pre-release-gate.ps1 -Version 6.0.0
```

## Compatibility Notes

Existing v5.8.0 projects should remain compatible if they:

- preserve required directories;
- preserve required manifest files;
- keep documentation under `.agents/docs`;
- keep validation scripts under `.agents/tools`;
- keep release notes under `.agents/releases`.











