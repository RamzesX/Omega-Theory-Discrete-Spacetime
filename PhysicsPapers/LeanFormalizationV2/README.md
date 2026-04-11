# OmegaTheory V2 — Lean 4 Formalization

Machine-verified formalization of Omega-Theory / Chaos Shield discrete quantum gravity.

**Central result**: Einstein's field equations `G_μν = (8πG/c⁴)T_μν + O(l_P)` emerge
from a discrete Planck-scale lattice with computational truncation errors and
self-healing dynamics — at healing-flow equilibrium, and modulo the
Laplacian-Ricci correspondence (HPW 2006, imported as an axiom).

## Status

| | |
|---|---|
| Lean / Mathlib | v4.29.0 |
| Files | 31 (30 under `OmegaTheory/` + `OmegaTheory.lean`) |
| Theorems | 241 |
| Sorry | **0** |
| Axioms | **5** logical axioms (4 physical constants + HPW 2006) |

See [`PROJECT.md`](./PROJECT.md) for the full architecture, axiom inventory,
flagship theorems, V1 vs V2 comparison, and optional porting work.

## Build

```bash
~/.elan/bin/lake exe cache get           # download Mathlib cache (first time)
~/.elan/bin/lake build --log-level=error
```

## Architecture (12 layers)

```
Foundations → Spacetime → Tensor → Geometry → Defects →
Conservation → HealingFlow → Emergence → Predictions →
Torsion → Irrationality → Variational
```

Each layer depends only on layers above it. The "Prize" theorem
`einstein_with_matter_emergence` lives in `OmegaTheory/Emergence/EinsteinEmergence.lean`
and reduces in one line to `ricci_from_equilibrium_balance`, which in turn uses
the healing-flow equilibrium condition plus the HPW axiom.

## Flagship theorems

| Layer | Theorem | File |
|---|---|---|
| Conservation | `fourth_noether_law_harmonic` (PROVEN from shift symmetry) | `Conservation/Information.lean` |
| HealingFlow | `dissipationRate_nonpos` (dF/dτ ≤ 0, PROVEN) | `HealingFlow/Lyapunov.lean` |
| Emergence | `einstein_with_matter_emergence` (THE PRIZE, modulo HPW) | `Emergence/EinsteinEmergence.lean` |
| Irrationality | `pi_error_bound`, `e_error_bound`, `sqrt2_error_bound` | `Irrationality/BoundsLemmas.lean` |
| Torsion | `torsionPressure_negative` (Popławski bounce) | `Torsion/Torsion.lean` |
| Predictions | `extended_gt_heisenberg`, `gateFidelity_is_powerLaw` | `Emergence/Predictions.lean` |

## Relation to V1

V1 (at `../LeanFormalization/`) was the first pass: 45 files, ~46 sorries, ~47 axioms.
V2 is a full refactor: 31 files, 0 sorry, 5 axioms. Three major V1 axioms
— Fourth Noether Law, Lyapunov monotonicity, Extended Heisenberg — were upgraded
to theorems in V2. V1 is retained for historical reference only.
