# Building Omega-Theory Lean Formalization (V1 — HISTORICAL)

> ⚠️ **SUPERSEDED.** The active formalization is **V2** at
> [`../LeanFormalizationV2/`](../LeanFormalizationV2/). V2 uses Mathlib v4.29.0
> (this V1 doc describes v4.13.0). For current build instructions see
> [`../LeanFormalizationV2/README.md`](../LeanFormalizationV2/README.md).

## Prerequisites

- WSL2 with Ubuntu
- Elan (Lean version manager) installed in WSL
- Mathlib cache tool

## Quick Start

```bash
# From Windows CMD/PowerShell
wsl.exe bash -c "cd /mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalization && ~/.elan/bin/lake exe cache get && ~/.elan/bin/lake build --log-level=error 2>&1"
```

## Step by Step

### 1. Get Mathlib Cache (saves hours!)
```bash
lake exe cache get
```

### 2. Build
```bash
# Lake 5.0 has automatic parallelism - no LAKE_JOBS needed!
lake build --log-level=error
```

**Note**: Lake 5.0+ automatically uses all available cores. The `--log-level=error` flag suppresses warning spam.

### 3. After Updating Dependencies
```bash
lake update
lake exe cache get  # ALWAYS after update!
lake build
```

## Project Structure

```
DiscreteSpacetime/
  Basic/          - Constants, Lattice, Operators
  Axioms/         - Physical postulates
  Geometry/       - Metric, Connection, Curvature, Torsion
  Dynamics/       - Healing flow, Defects, Stability
  Conservation/   - Noether, FourthLaw, SpinInformation
  Torsion/        - SpinTorsion, BigBounce (Poplawski)
  Emergence/      - ContinuumLimit, EinsteinEmergence
  Irrationality/  - Computational bounds from truncated irrationals
  Variational/    - GraphAction, DiscreteNoether, InformationGeodesics
```

## Mathlib Version

v4.13.0 - see lakefile.lean

## Troubleshooting

See `.claude/lean-build-guide.md` for detailed troubleshooting.
