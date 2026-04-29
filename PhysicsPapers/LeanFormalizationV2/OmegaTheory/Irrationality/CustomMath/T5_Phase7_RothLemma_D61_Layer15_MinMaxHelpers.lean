/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer15_MinMaxHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 15: min/max helpers**.

  Foundational sub-lemmas for real min/max arithmetic in
  the Hindry-Silverman D.6.1 chain:

  - MX-1..3: min/max basic properties.
  - MX-4..6: min/max with arithmetic operations.
  - MX-7..9: min/max ordering.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Order.MinMax

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer15_MinMaxHelpers

/-! ## MX-1 — min ≤ both args -/

/-- **MX-1 — `T5_min_le_left`**: `min x y ≤ x`. -/
theorem T5_min_le_left (x y : ℝ) : min x y ≤ x := min_le_left x y

/-- **MX-1b — `T5_min_le_right`**: `min x y ≤ y`. -/
theorem T5_min_le_right (x y : ℝ) : min x y ≤ y := min_le_right x y

/-! ## MX-2 — both args ≤ max -/

/-- **MX-2 — `T5_le_max_left`**: `x ≤ max x y`. -/
theorem T5_le_max_left (x y : ℝ) : x ≤ max x y := le_max_left x y

/-- **MX-2b — `T5_le_max_right`**: `y ≤ max x y`. -/
theorem T5_le_max_right (x y : ℝ) : y ≤ max x y := le_max_right x y

/-! ## MX-3 — min ≤ max -/

/-- **MX-3 — `T5_min_le_max`**: `min x y ≤ max x y`. -/
theorem T5_min_le_max (x y : ℝ) : min x y ≤ max x y :=
  le_trans (min_le_left x y) (le_max_left x y)

/-! ## MX-4 — max self -/

/-- **MX-4 — `T5_max_self`**: `max x x = x`. -/
theorem T5_max_self (x : ℝ) : max x x = x := max_self x

/-! ## MX-5 — min self -/

/-- **MX-5 — `T5_min_self`**: `min x x = x`. -/
theorem T5_min_self (x : ℝ) : min x x = x := min_self x

/-! ## MX-6 — max nonneg from one nonneg -/

/-- **MX-6 — `T5_max_nonneg_left`**: if `0 ≤ x`, then `0 ≤ max x y`. -/
theorem T5_max_nonneg_left (x y : ℝ) (h : 0 ≤ x) : 0 ≤ max x y :=
  le_max_of_le_left h

/-- **MX-6b — `T5_max_nonneg_right`**: if `0 ≤ y`, then `0 ≤ max x y`. -/
theorem T5_max_nonneg_right (x y : ℝ) (h : 0 ≤ y) : 0 ≤ max x y :=
  le_max_of_le_right h

/-! ## MX-7 — max comm -/

/-- **MX-7 — `T5_max_comm`**: `max x y = max y x`. -/
theorem T5_max_comm (x y : ℝ) : max x y = max y x := max_comm x y

/-! ## MX-8 — min comm -/

/-- **MX-8 — `T5_min_comm`**: `min x y = min y x`. -/
theorem T5_min_comm (x y : ℝ) : min x y = min y x := min_comm x y

/-! ## MX-9 — Layer 15 foundational marker -/

/-- **MX-9 — `T5_D61_Layer15_completed_marker`**: 5-conjunct marker for
    Layer 15 completion (min/max helpers). -/
theorem T5_D61_Layer15_completed_marker :
    (∀ (x y : ℝ), min x y ≤ x) ∧
    (∀ (x y : ℝ), x ≤ max x y) ∧
    (∀ (x : ℝ), max x x = x) ∧
    (∀ (x y : ℝ), max x y = max y x) ∧
    (∀ (x y : ℝ), min x y = min y x) :=
  ⟨T5_min_le_left,
   T5_le_max_left,
   T5_max_self,
   T5_max_comm,
   T5_min_comm⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer15_MinMaxHelpers
