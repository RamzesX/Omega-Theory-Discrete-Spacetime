---
name: Agent identity — Kochab
description: Took Kochab 2026-04-17 for metric-weighted graph Laplacian Foundations infrastructure (Foundations/WeightedGraphLaplacian.lean); generalises Mathlib SimpleGraph.lapMatrix from unit to arbitrary symmetric weights; 7 structural theorems + substrate specialisation; full project GREEN 3624 jobs
type: user
---

Took the name **Kochab** (β Ursae Minoris, "the star" from Arabic *al-kawkab ash-shamāliyy* — orange giant at 131 ly, the second-brightest in Ursa Minor, the "lesser pole star" that guarded Polaris together with Pherkad before precession moved the pole) on 2026-04-17.

## Mission

Build the **metric-weighted graph Laplacian** — the long-missing Mathlib
ingredient needed for the HPW2006 convergence proof on the substrate.
Mathlib v4.29.0 has `SimpleGraph.lapMatrix` but only for UNIT edge weights.
The substrate needs cotangent/mass-stiffness-style weights pulled back
from `g_μν`.

## Deliverable

New file `OmegaTheory/Foundations/WeightedGraphLaplacian.lean`
(~440 lines, 0 sorry, 0 new axioms, 0 Prop:=True).  Registered in
`OmegaTheory/Basic.lean` Layer 0 Foundations (right after
`ErrorHopfStructure`).

## Contents — 7 structural theorems

1. `weightedLapMatrix G w` — the core noncomputable def, entries:
   - diagonal: `∑_x [G.Adj u x → w u x]`
   - off-diag: `-w u v` if `G.Adj u v`, else `0`

2. `weightedLapMatrix_one_eq_lapMatrix` — reduces to Mathlib's
   `SimpleGraph.lapMatrix ℝ G` under unit weights.

3. `weightedLapMatrix_isSymm` — symmetric under `∀ u v, w u v = w v u`.

4. `weightedLapMatrix_mulVec_apply` — standard action formula
   `(L *ᵥ x) u = Σ_v [Adj u v → w u v · (x u − x v)]`.

5. `weightedLapMatrix_mulVec_const` — constant vector in kernel.

6. `weightedLapMatrix_row_sum_zero` — Kirchhoff: `∑_v L u v = 0`.

7. `weightedLapMatrix_quadForm` — `xᵀ L x = (Σ_{u,v}[Adj → w·(x_u−x_v)²])/2`
   under symmetric weights.

8. **`weightedLapMatrix_posSemidef`** — `Matrix.PosSemidef (weightedLapMatrix G w)`
   given symmetric + edge-nonneg weights, via
   `.of_dotProduct_mulVec_nonneg` + the quadratic form identity.

## Substrate specialisation (bridge-ready)

- `metricEdgeWeight d := fun u v => max 0 (max (d u v) (d v u))`
  accepts any pair-function `d` and produces a symmetric non-negative
  edge weight — any future metric-pullback can be plugged in directly.
- `substrateWeightedLapMatrix G d := weightedLapMatrix G (metricEdgeWeight d)`
  inherits all structural lemmas via re-export.
- Companion re-exports: `substrateWeightedLapMatrix_isSymm` /
  `_posSemidef` / `_row_sum_zero`.

## Build verification

- `lake build OmegaTheory.Foundations.WeightedGraphLaplacian` GREEN
- `lake build --log-level=error` full project GREEN **3624 jobs**
- exit code 0
- 0 sorry, 0 new axioms, 0 new Prop:=True

## Technical notes for future agents

- `Matrix.dotProduct` is NOT `Matrix.dotProduct` in v4.29.0 namespace —
  it's the infix `⬝ᵥ` opened in `namespace Matrix`.  Use `show`/`change`
  to unfold `(A *ᵥ x) i = ∑ j, A i j * x j`.
- `G.loopless u` does NOT work directly — use `G.irrefl` (a `protected
  theorem` in `SimpleGraph.Basic`) for `¬ G.Adj u u`.
- `Finset.sum_eq_sum_diff_singleton_add` requires the `f := ...` hint
  when the sum has computed-ite structure; Lean cannot always infer the
  function.

## Downstream path

- Future HPW convergence agent can plug a concrete metric pullback into
  `substrateWeightedLapMatrix` and immediately inherit symmetry +
  Kirchhoff + PosSemidef.
- File is upstream PR-able to Mathlib as
  `Mathlib.Combinatorics.SimpleGraph.WeightedLapMatrix` in a follow-up —
  entry-equality to `SimpleGraph.lapMatrix` under unit weights plus all
  7 structural theorems are pure Mathlib material.

## Credits

Added to README.md line 233 (before Vindemiatrix row).  Entry includes
full theorem list + substrate-specialisation explanation + upstream-PR
potential + Kochab etymology.
