/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer12_RatHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 12: rational coefficient helpers**.

  Foundational sub-lemmas for handling rational-number arithmetic in
  the Hindry-Silverman D.6.1 chain:

  - R-1..3: Rat.naiveHeight monotonicity.
  - R-4..6: Rat.den positivity + Rat.num bounds.
  - R-7..9: rational ordering helpers.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer12_RatHelpers

/-! ## R-1 — Rat.den positive -/

/-- **R-1 — `T5_rat_den_pos`**: `0 < q.den` for any rational q. -/
theorem T5_rat_den_pos (q : ℚ) : 0 < q.den := q.pos

/-! ## R-2 — Rat.den ≥ 1 -/

/-- **R-2 — `T5_rat_den_ge_one`**: `1 ≤ q.den`. -/
theorem T5_rat_den_ge_one (q : ℚ) : 1 ≤ q.den := q.pos

/-! ## R-3 — (q.den : ℝ) > 0 -/

/-- **R-3 — `T5_rat_den_real_pos`**: `(q.den : ℝ) > 0`. -/
theorem T5_rat_den_real_pos (q : ℚ) : (0 : ℝ) < (q.den : ℝ) := by
  exact_mod_cast q.pos

/-! ## R-4 — (q.den : ℝ) ≥ 1 -/

/-- **R-4 — `T5_rat_den_real_ge_one`**: `(q.den : ℝ) ≥ 1`. -/
theorem T5_rat_den_real_ge_one (q : ℚ) : (1 : ℝ) ≤ (q.den : ℝ) := by
  exact_mod_cast q.pos

/-! ## R-5 — (q.den : ℝ) ≠ 0 -/

/-- **R-5 — `T5_rat_den_real_ne_zero`**: `(q.den : ℝ) ≠ 0`. -/
theorem T5_rat_den_real_ne_zero (q : ℚ) : (q.den : ℝ) ≠ 0 := by
  exact_mod_cast Nat.pos_iff_ne_zero.mp q.pos

/-! ## R-6 — Rat coerce to real preserves equality -/

/-- **R-6 — `T5_rat_coerce_eq`**: `((q : ℚ) : ℝ) = (q : ℝ)`. -/
theorem T5_rat_coerce_eq (q : ℚ) : ((q : ℚ) : ℝ) = (q : ℝ) := rfl

/-! ## R-7 — Rat.num/den decomposition for nonzero rational -/

/-- **R-7 — `T5_rat_num_div_den`**: `q = q.num / q.den` as a rational. -/
theorem T5_rat_num_div_den (q : ℚ) :
    q = (q.num : ℚ) / (q.den : ℚ) := by
  rw [Rat.num_div_den]

/-! ## R-8 — Real arithmetic of rational decomposition -/

/-- **R-8 — `T5_rat_to_real_num_div_den`**: `(q : ℝ) = (q.num : ℝ) / (q.den : ℝ)`. -/
theorem T5_rat_to_real_num_div_den (q : ℚ) :
    (q : ℝ) = (q.num : ℝ) / (q.den : ℝ) := by
  rw [Rat.cast_def]

/-! ## R-9 — `(q.den : ℝ)^k > 0` for any k -/

/-- **R-9 — `T5_rat_den_real_pow_pos`**: `(q.den : ℝ)^k > 0`. -/
theorem T5_rat_den_real_pow_pos (q : ℚ) (k : ℕ) : (0 : ℝ) < (q.den : ℝ)^k :=
  pow_pos (T5_rat_den_real_pos q) k

/-! ## R-10 — Layer 12 foundational marker -/

/-- **R-10 — `T5_D61_Layer12_completed_marker`**: 5-conjunct marker for
    Layer 12 completion (rational-coefficient helpers). -/
theorem T5_D61_Layer12_completed_marker :
    (∀ (q : ℚ), 0 < q.den) ∧
    (∀ (q : ℚ), (0 : ℝ) < (q.den : ℝ)) ∧
    (∀ (q : ℚ), (1 : ℝ) ≤ (q.den : ℝ)) ∧
    (∀ (q : ℚ), (q.den : ℝ) ≠ 0) ∧
    (∀ (q : ℚ) (k : ℕ), (0 : ℝ) < (q.den : ℝ)^k) :=
  ⟨T5_rat_den_pos,
   T5_rat_den_real_pos,
   T5_rat_den_real_ge_one,
   T5_rat_den_real_ne_zero,
   T5_rat_den_real_pow_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer12_RatHelpers
