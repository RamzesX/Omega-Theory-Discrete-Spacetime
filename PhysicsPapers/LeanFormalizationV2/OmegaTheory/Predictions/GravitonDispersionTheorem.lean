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

/-! ## Section 4 — Quartic Taylor bound (Tier-B, conditional |k·ℓ_P| ≤ 1)

The substantive substrate prediction: under |k·ℓ_P| ≤ 1, the
deviation of lattice dispersion from continuum is bounded by
    `k⁴ · ℓ_P² · (5/48)`.

This is the Lion's-Pride completion of the file, closing the
deferral noted in commit 525f77f. -/

/-- **Half-angle and substitution identity** rewrite of the deficit:
    after multiplying by `ℓ_P²`, the deficit becomes a polynomial
    in `k`, `ℓ_P`, and `cos(k·ℓ_P)`. -/
private theorem deficit_times_l_P_sq (k : ℝ) :
    l_P ^ 2 * (k ^ 2 - (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) =
      k ^ 2 * l_P ^ 2 - 2 + 2 * Real.cos (k * l_P) := by
  rw [dispersion_deficit_in_terms_of_cos]
  have hl : l_P ^ 2 ≠ 0 := ne_of_gt (sq_pos_of_pos l_P_pos)
  have hcancel : l_P ^ 2 * (2 / l_P ^ 2) = 2 := by
    rw [mul_div_assoc']; exact mul_div_cancel_left₀ 2 hl
  -- Distribute, then cancel `l_P^2 · (2/l_P^2)` to `2`.
  have hdist : l_P ^ 2 * (k ^ 2 - (2 / l_P ^ 2) * (1 - Real.cos (k * l_P))) =
      l_P ^ 2 * k ^ 2 - (l_P ^ 2 * (2 / l_P ^ 2)) * (1 - Real.cos (k * l_P)) := by ring
  rw [hdist, hcancel]
  ring

/-- **Quartic dispersion correction** (the Tier-B headline).

    For wavevectors within Planck-scale (|k·ℓ_P| ≤ 1), the deviation
    of lattice dispersion from continuum is bounded by `k⁴·ℓ_P²·(5/48)`.

    Proof: by `dispersion_deficit_in_terms_of_cos`, the deficit equals
    `k² − (2/ℓ_P²)(1 − cos(k·ℓ_P))`.  Multiplying by `ℓ_P² > 0`
    converts this to `k²·ℓ_P² − 2 + 2·cos(k·ℓ_P)`.  By `Real.cos_bound`
    at `x = k·ℓ_P` (under `|x| ≤ 1`), `cos(x) ≤ 1 − x²/2 + x⁴·(5/96)`,
    which gives `k²·ℓ_P² − 2 + 2·cos(x) ≤ k²·ℓ_P² − 2 + 2(1 − x²/2 +
    x⁴·5/96) = k²·ℓ_P² − x² + x⁴·5/48 = 0 + k⁴·ℓ_P⁴·5/48`.  Dividing
    by `ℓ_P² > 0` recovers the deficit bound `k⁴·ℓ_P²·5/48`. -/
theorem dispersion_deficit_le_quartic (k : ℝ) (hk : |k * l_P| ≤ 1) :
    k ^ 2 - (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2 ≤
      k ^ 4 * l_P ^ 2 * (5 / 48) := by
  -- Step 1: Apply Real.cos_bound at x = k·l_P.
  have hcos := Real.cos_bound hk
  -- |x|^4 = x^4 for real x (even power).
  have habs4 : |k * l_P| ^ 4 = (k * l_P) ^ 4 := by
    rw [show (4 : ℕ) = 2 * 2 from rfl, pow_mul, pow_mul, sq_abs]
  rw [habs4] at hcos
  -- Upper bound on cos:
  have hcos_upper : Real.cos (k * l_P) ≤
      1 - (k * l_P) ^ 2 / 2 + (k * l_P) ^ 4 * (5 / 96) := by
    have := (abs_le.mp hcos).2
    linarith
  -- Step 2: Multiply both sides of the deficit inequality by l_P^2,
  -- which is positive (so direction preserved).
  have hl_pos : 0 < l_P ^ 2 := sq_pos_of_pos l_P_pos
  have hl_ne : l_P ^ 2 ≠ 0 := ne_of_gt hl_pos
  -- The l_P^2-scaled deficit is a polynomial in k, l_P, cos.
  have h_scaled := deficit_times_l_P_sq k
  -- Substituting the cos upper bound:
  -- k^2·l_P^2 - 2 + 2·cos(k·l_P) ≤ k^2·l_P^2 - 2 + 2·[1 − (k·l_P)²/2 + (k·l_P)⁴·(5/96)]
  --                            = k^2·l_P^2 - (k·l_P)² + (k·l_P)⁴·(10/96)
  --                            = 0 + k⁴·l_P⁴·(5/48)
  have h_target_scaled :
      l_P ^ 2 * (k ^ 2 - (4 / l_P ^ 2) * (Real.sin (k * l_P / 2)) ^ 2) ≤
        l_P ^ 2 * (k ^ 4 * l_P ^ 2 * (5 / 48)) := by
    rw [h_scaled]
    -- Goal: k^2·l_P^2 - 2 + 2·cos(k·l_P) ≤ l_P^2·k^4·l_P^2·(5/48) = k^4·l_P^4·(5/48)
    have h_klP_sq : (k * l_P) ^ 2 = k ^ 2 * l_P ^ 2 := by ring
    have h_klP_4  : (k * l_P) ^ 4 = k ^ 4 * l_P ^ 4 := by ring
    -- From hcos_upper, multiply both sides by 2:
    --   2 cos(k·l_P) ≤ 2 - (k·l_P)² + (k·l_P)⁴·(10/96)
    have hcos_scaled : 2 * Real.cos (k * l_P) ≤
        2 - (k * l_P) ^ 2 + (k * l_P) ^ 4 * (10 / 96) := by linarith
    -- Substitute (k·l_P)² = k²·l_P² and (k·l_P)⁴ = k⁴·l_P⁴:
    rw [h_klP_sq, h_klP_4] at hcos_scaled
    -- hcos_scaled : 2·cos(k·l_P) ≤ 2 - k²·l_P² + k⁴·l_P⁴·(10/96)
    -- Add k²·l_P² - 2 to both sides:
    -- k²·l_P² - 2 + 2·cos(k·l_P) ≤ k⁴·l_P⁴·(10/96) = k⁴·l_P⁴·(5/48)
    -- Compare with goal: l_P^2·k^4·l_P^2·(5/48) = k^4·l_P^4·(5/48). ✓
    have h_target_eq : l_P ^ 2 * (k ^ 4 * l_P ^ 2 * (5 / 48)) =
                        k ^ 4 * l_P ^ 4 * (5 / 48) := by ring
    have h_coef_eq : (10 : ℝ) / 96 = 5 / 48 := by norm_num
    rw [h_target_eq]
    linarith [h_coef_eq ▸ hcos_scaled]
  -- Step 3: Divide both sides by l_P^2 (positive).
  -- We have: l_P^2 · LHS ≤ l_P^2 · RHS, l_P^2 > 0 ⟹ LHS ≤ RHS.
  exact le_of_mul_le_mul_left h_target_scaled hl_pos

end OmegaTheory.Predictions
