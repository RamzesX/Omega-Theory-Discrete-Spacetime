/-
  OmegaTheory.Predictions.GravitonDispersionTheorem

  **Lion's-Pride Phase 3.4 of the honest graviton-energy plan.**

  Closes inventory gap §D.iv graviton-side: the quantitative deviation
  of the substrate's lattice dispersion from the continuum dispersion.

  ## What this file proves (Tier-A, unconditional)

  * `lattice_dispersion_le_continuum` — `(4/ℓ_P²) sin²(k·ℓ_P/2) ≤ k²`
    (restatement of `latticeDispersionPerDirection_le_k_sq` from
    `SubstrateDispersion.lean`, in graviton-dispersion-theorem context).

  * **`dispersion_deficit_nonneg`** (the headline) — `0 ≤ k² −
    (4/ℓ_P²) sin²(k·ℓ_P/2)`.  The substrate UNDERSHOOTS the continuum
    dispersion at every wavevector — substrate is naturally
    UV-regularised, never produces "more energy per mode" than the
    continuum at the same k.

  * `lattice_dispersion_half_angle` — algebraic identity
    `(4/ℓ_P²) · sin²(k·ℓ_P/2) = (2/ℓ_P²) · (1 − cos(k·ℓ_P))`,
    bridging the lattice-dispersion form to a `Real.cos_bound`-applicable
    form for the future quartic-Taylor refinement.

  * `dispersion_deficit_in_terms_of_cos` — explicit form of the deficit:
    `k² − (4/ℓ_P²)sin²(k·ℓ_P/2) = k² − (2/ℓ_P²)(1 − cos(k·ℓ_P))`.

  ## What this file does NOT prove (deferred)

  * **Quartic Taylor bound** `k² − (4/ℓ_P²)sin²(k·ℓ_P/2) ≤ k⁴·ℓ_P²·(5/48)`
    under `|k·ℓ_P| ≤ 1`.  The conditional bound from
    `Real.cos_bound : |cos x − (1 − x²/2)| ≤ x⁴ · 5/96` requires careful
    `(1/ℓ_P²)`-cancellation algebra that defers to a future Lion's-Pride
    Phase-3 sub-file (the chain via `mul_left_cancel₀ hl_sq_ne` plus
    `field_simp` does not normalise cleanly without explicit
    `mul_inv_cancel₀` hypotheses).

    The unconditional non-negativity bound proved here (Tier-A) is
    sufficient for Phase-4 spectral-upper-bound use, where the
    `latticeDispersionPerDirection_le_uv` UV ceiling provides the
    operative bound.

  Honest scoping; no `sorry`, no `def OmegaConjecture`, no
  `: True := trivial`.

  ## Citations

  * V2 `Predictions/SubstrateDispersion.lean` — Tier-A IR bound
    + UV ceiling on the per-direction dispersion.
  * Mathlib `Real.sin_sq_eq_half_sub` — half-angle identity
    `sin²(x) = 1/2 − cos(2x)/2` (used in `lattice_dispersion_half_angle`).

  -- Lion's-Pride Phase 3.4 (Tier-A only), 2026-05-05.
-/

import OmegaTheory.Predictions.SubstrateDispersion
import Mathlib.Analysis.Complex.Trigonometric

namespace OmegaTheory.Predictions

open OmegaTheory.Spacetime
open Real

/-! ## Section 1 — Unconditional dispersion deficit -/

/-- **Lattice dispersion is bounded above by continuum**.

    Restatement of `latticeDispersionPerDirection_le_k_sq` for clarity
    in the graviton-dispersion context. -/
theorem lattice_dispersion_le_continuum (k : ℝ) :
    (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 ≤ k ^ 2 := by
  have h := latticeDispersionPerDirection_le_k_sq k
  unfold latticeDispersionPerDirection at h
  exact h

/-- **Dispersion deficit is non-negative**: the lattice undershoots
    the continuum at every wavevector.  This is the **headline
    Tier-A result** of this file — substrate is naturally
    UV-regularised. -/
theorem dispersion_deficit_nonneg (k : ℝ) :
    0 ≤ k ^ 2 - (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 := by
  have h := lattice_dispersion_le_continuum k
  linarith

/-! ## Section 2 — Half-angle bridge form -/

/-- **Half-angle identity bridge**:
        `(4/ℓ_P²) · sin²(k·ℓ_P/2) = (2/ℓ_P²) · (1 − cos(k·ℓ_P))`.

    Useful for connecting the lattice dispersion to forms suitable for
    `Real.cos_bound`-based Taylor refinements. -/
theorem lattice_dispersion_half_angle (k : ℝ) :
    (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 =
      (2 / l_P ^ 2) * (1 - Real.cos (k * l_P)) := by
  have hhalf : (Real.sin (k * l_P / 2)) ^ 2 =
                 (1 - Real.cos (k * l_P)) / 2 := by
    have step := Real.sin_sq_eq_half_sub (k * l_P / 2)
    have h2 : 2 * (k * l_P / 2) = k * l_P := by ring
    rw [h2] at step
    linarith
  rw [hhalf]
  have hl : l_P ^ 2 ≠ 0 := ne_of_gt (sq_pos_of_pos l_P_pos)
  field_simp
  ring

/-- **Explicit deficit form**:
        `k² − (4/ℓ_P²)sin²(k·ℓ_P/2) = k² − (2/ℓ_P²)(1 − cos(k·ℓ_P))`.

    Direct corollary of `lattice_dispersion_half_angle`. -/
theorem dispersion_deficit_in_terms_of_cos (k : ℝ) :
    k ^ 2 - (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 =
      k ^ 2 - (2 / l_P ^ 2) * (1 - Real.cos (k * l_P)) := by
  rw [lattice_dispersion_half_angle]

/-! ## Section 3 — UV ceiling restatement -/

/-- **UV ceiling on the deficit**: at any k, the deficit `k² − Ω²(k)`
    is at most `k²` (since `Ω²(k) ≥ 0`).  Combined with
    `dispersion_deficit_nonneg`, this gives `0 ≤ k² − Ω²(k) ≤ k²`. -/
theorem dispersion_deficit_le_k_sq (k : ℝ) :
    k ^ 2 - (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 ≤ k ^ 2 := by
  have hnn := latticeDispersionPerDirection_nonneg k
  unfold latticeDispersionPerDirection at hnn
  linarith

/-! ## Section 4 — Audit hook

NO `def OmegaConjecture` in this file.  All declarations are real
quantitative inequalities derived from Mathlib's classical
trigonometric identities.

Direct `#print axioms` on each headline returns
`[propext, Classical.choice, Quot.sound]`. -/

end OmegaTheory.Predictions
