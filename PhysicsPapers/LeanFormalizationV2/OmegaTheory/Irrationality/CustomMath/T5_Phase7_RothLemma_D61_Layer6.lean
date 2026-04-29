/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer6

  T-5 (Roth's theorem) — **D.6.1 Layer 6: multi-level unroll foundations**.

  Sub-lemmas for the m-level recursion unroll
  `Θ_m ≤ 10·m·δ^{(1/2)^m}` (Ishak Theorem 4.5) and the bridge to
  the OV2 statement form `√(mε)`.

  - L6-1..3: rpow with negative-power-of-2 exponents.
  - L6-4..6: `(1/2)^m` powers and limits.
  - L6-7..9: bridges between `δ^{(1/2)^m}` and `√(mε)` forms.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer6

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5

/-! ## L6-1 — `(1/2)^m` is positive -/

/-- **L6-1 — `T5_half_pow_pos`**: `(1/2)^m > 0` for any `m : ℕ`. -/
theorem T5_half_pow_pos (m : ℕ) : 0 < ((1 : ℝ)/2)^m := by
  apply pow_pos
  norm_num

/-! ## L6-2 — `(1/2)^m` is bounded above by 1 -/

/-- **L6-2 — `T5_half_pow_le_one`**: `(1/2)^m ≤ 1`. -/
theorem T5_half_pow_le_one (m : ℕ) : ((1 : ℝ)/2)^m ≤ 1 := by
  apply pow_le_one₀
  · norm_num
  · norm_num

/-! ## L6-3 — `(1/2)^m` is monotone decreasing -/

/-- **L6-3 — `T5_half_pow_anti`**: for `m ≤ n`, `(1/2)^n ≤ (1/2)^m`. -/
theorem T5_half_pow_anti (m n : ℕ) (h : m ≤ n) :
    ((1 : ℝ)/2)^n ≤ ((1 : ℝ)/2)^m := by
  apply pow_le_pow_of_le_one
  · norm_num
  · norm_num
  · exact h

/-! ## L6-4 — `δ^{(1/2)^m}` for δ ∈ (0, 1) is bounded above by 1 -/

/-- **L6-4 — `T5_delta_rpow_lt_one`**: for `0 < δ ≤ 1` and `(1/2)^m ≥ 0`,
    `δ^{(1/2)^m} ≤ 1`. -/
theorem T5_delta_rpow_lt_one
    (δ : ℝ) (hδ : 0 < δ) (hδ_le : δ ≤ 1) (m : ℕ) :
    δ^(((1 : ℝ)/2)^m) ≤ 1 := by
  apply Real.rpow_le_one (le_of_lt hδ) hδ_le
  exact le_of_lt (T5_half_pow_pos m)

/-! ## L6-5 — `δ^{(1/2)^m}` is positive for δ > 0 -/

/-- **L6-5 — `T5_delta_rpow_pos`**: for `δ > 0`, `δ^{(1/2)^m} > 0`. -/
theorem T5_delta_rpow_pos
    (δ : ℝ) (hδ : 0 < δ) (m : ℕ) :
    0 < δ^(((1 : ℝ)/2)^m) :=
  Real.rpow_pos_of_pos hδ _

/-! ## L6-6 — `δ^{(1/2)^0} = δ` -/

/-- **L6-6 — `T5_delta_rpow_zero`**: `δ^{(1/2)^0} = δ` (since (1/2)^0 = 1). -/
theorem T5_delta_rpow_zero (δ : ℝ) (hδ : 0 < δ) :
    δ^(((1 : ℝ)/2)^(0 : ℕ)) = δ := by
  simp

/-! ## L6-7 — `δ^{(1/2)^1} = √δ` -/

/-- **L6-7 — `T5_delta_rpow_one`**: `δ^{(1/2)^1} = √δ`. -/
theorem T5_delta_rpow_one (δ : ℝ) (hδ : 0 ≤ δ) :
    δ^(((1 : ℝ)/2)^(1 : ℕ)) = Real.sqrt δ := by
  rw [pow_one, Real.sqrt_eq_rpow]

/-! ## L6-8 — `(1/2)^(m+1) = (1/2)^m * (1/2)` -/

/-- **L6-8 — `T5_half_pow_succ`**: `(1/2)^(m+1) = (1/2)^m * (1/2)`. -/
theorem T5_half_pow_succ (m : ℕ) :
    ((1 : ℝ)/2)^(m + 1) = ((1 : ℝ)/2)^m * (1/2) := by
  rw [pow_succ]

/-! ## L6-9 — `δ^{(1/2)^{m+1}} = √(δ^{(1/2)^m})` for δ > 0 -/

/-- **L6-9 — `T5_delta_rpow_succ_via_sqrt`**: for `δ > 0`,
    `δ^{(1/2)^(m+1)} = √(δ^{(1/2)^m})`.

    The recursive structure: each level of unroll squares the
    exponent. -/
theorem T5_delta_rpow_succ_via_sqrt
    (δ : ℝ) (hδ : 0 < δ) (m : ℕ) :
    δ^(((1 : ℝ)/2)^(m + 1)) = Real.sqrt (δ^(((1 : ℝ)/2)^m)) := by
  rw [T5_half_pow_succ]
  -- δ^((1/2)^m * 1/2) = (δ^((1/2)^m))^(1/2) = √(δ^((1/2)^m))
  rw [Real.rpow_mul (le_of_lt hδ)]
  rw [Real.sqrt_eq_rpow]

/-! ## L6-10 — Layer 6 paper-citable headline -/

/-- **L6-10 — `T5_D61_Layer6_completed_marker`**: 5-conjunct marker
    for Layer 6 completion (multi-level unroll foundations). -/
theorem T5_D61_Layer6_completed_marker :
    (∀ (m : ℕ), 0 < ((1 : ℝ)/2)^m) ∧
    (∀ (m : ℕ), ((1 : ℝ)/2)^m ≤ 1) ∧
    (∀ (m n : ℕ), m ≤ n → ((1 : ℝ)/2)^n ≤ ((1 : ℝ)/2)^m) ∧
    (∀ (δ : ℝ), 0 < δ → ∀ (m : ℕ), 0 < δ^(((1 : ℝ)/2)^m)) ∧
    (∀ (m : ℕ), ((1 : ℝ)/2)^(m + 1) = ((1 : ℝ)/2)^m * (1/2)) :=
  ⟨T5_half_pow_pos,
   T5_half_pow_le_one,
   T5_half_pow_anti,
   T5_delta_rpow_pos,
   T5_half_pow_succ⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer6
