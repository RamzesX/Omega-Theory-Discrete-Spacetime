/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntCastAbsHelpers

  T-5 (Roth's theorem) — **D.7 Block D INTEGER CAST ABS HELPERS**.

  Tier-99 stepping stones for V7-N2 multivariate integer non-vanishing
  lower bound: the foundational |z : ℝ| ≥ 1 fact when z is the cast of
  a non-zero integer.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Int.Cast.Lemmas
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntCastAbsHelpers

/-! ## ICA-1 — Non-zero integer cast absolute value ≥ 1 -/

/-- **ICA-1 — `T5_int_cast_abs_ge_one`**: for a nonzero integer `k`,
    `|(k : ℝ)| ≥ 1`.

    Direct integer-cast fact derived from `Int.one_le_abs`. -/
theorem T5_int_cast_abs_ge_one
    (k : ℤ) (h_ne : k ≠ 0) :
    1 ≤ |((k : ℤ) : ℝ)| := by
  -- k ≠ 0 in ℤ ⇒ 1 ≤ |k| in ℤ
  have h_int : (1 : ℤ) ≤ |k| := Int.one_le_abs h_ne
  -- Cast to ℝ preserves order
  have h_cast : ((1 : ℤ) : ℝ) ≤ ((|k| : ℤ) : ℝ) := by exact_mod_cast h_int
  rw [Int.cast_abs] at h_cast
  push_cast at h_cast
  exact h_cast

/-! ## ICA-2 — Real number that is integer-cast and non-zero has |.| ≥ 1 -/

/-- **ICA-2 — `T5_real_is_int_cast_implies_abs_ge_one`**: if a real number
    `z` is the cast of some integer AND `z ≠ 0`, then `|z| ≥ 1`.

    Existential form useful when the integer is implicit (from clearance
    arguments). -/
theorem T5_real_is_int_cast_implies_abs_ge_one
    (z : ℝ) (h_int : ∃ k : ℤ, z = ((k : ℤ) : ℝ)) (h_ne : z ≠ 0) :
    1 ≤ |z| := by
  obtain ⟨k, hk⟩ := h_int
  rw [hk]
  rw [hk] at h_ne
  have hk_ne : k ≠ 0 := by
    intro hk_zero
    apply h_ne
    rw [hk_zero]
    simp
  exact T5_int_cast_abs_ge_one k hk_ne

/-! ## ICA-3 — Inverse-bound form -/

/-- **ICA-3 — `T5_int_cast_inv_bound`**: for nonzero integer `k` and
    any positive real `D`, `1/D ≤ |(k : ℝ)| / D`.

    Trivial division of the basic ICA-1 bound by D. -/
theorem T5_int_cast_inv_bound
    (k : ℤ) (h_ne : k ≠ 0) (D : ℝ) (hD : 0 < D) :
    1 / D ≤ |((k : ℤ) : ℝ)| / D := by
  apply div_le_div_of_nonneg_right
  · exact T5_int_cast_abs_ge_one k h_ne
  · exact le_of_lt hD

/-! ## ICA-4 — Headline: integer-cast abs helpers bundle -/

/-- **🚨 ICA-4 — `T5_INT_CAST_ABS_HELPERS_HEADLINE`**: paper-citable bundle
    of the 3 integer-cast absolute-value helpers.

    Foundational tier-99 stepping stones for V7-N2 multivariate
    integer non-vanishing lower bound (atom-2 D.7 closure). -/
theorem T5_INT_CAST_ABS_HELPERS_HEADLINE :
    -- (a) ICA-1 raw form
    (∀ (k : ℤ), k ≠ 0 → 1 ≤ |((k : ℤ) : ℝ)|) ∧
    -- (b) ICA-2 existential form
    (∀ (z : ℝ), (∃ k : ℤ, z = ((k : ℤ) : ℝ)) → z ≠ 0 → 1 ≤ |z|) ∧
    -- (c) ICA-3 inverse form
    (∀ (k : ℤ), k ≠ 0 → ∀ (D : ℝ), 0 < D →
      1 / D ≤ |((k : ℤ) : ℝ)| / D) :=
  ⟨T5_int_cast_abs_ge_one,
   T5_real_is_int_cast_implies_abs_ge_one,
   T5_int_cast_inv_bound⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntCastAbsHelpers
