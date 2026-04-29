/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer22_RealAnalysisHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 22: real analysis helpers**.

  Foundational sub-lemmas for real analysis topics in the
  Hindry-Silverman D.6.1 chain.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Log.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer22_RealAnalysisHelpers

/-! ## RA-1 — sqrt of zero -/

theorem T5_sqrt_zero : Real.sqrt 0 = 0 := Real.sqrt_zero

/-! ## RA-2 — sqrt of one -/

theorem T5_sqrt_one : Real.sqrt 1 = 1 := Real.sqrt_one

/-! ## RA-3 — sqrt monotone -/

theorem T5_sqrt_le_sqrt (a b : ℝ) (h : a ≤ b) :
    Real.sqrt a ≤ Real.sqrt b := Real.sqrt_le_sqrt h

/-! ## RA-4 — sqrt nonneg -/

theorem T5_sqrt_nonneg (a : ℝ) : 0 ≤ Real.sqrt a := Real.sqrt_nonneg a

/-! ## RA-5 — sqrt of squared -/

theorem T5_sqrt_sq (a : ℝ) (ha : 0 ≤ a) : Real.sqrt (a^2) = a := by
  rw [sq, Real.sqrt_mul_self ha]

/-! ## RA-6 — log of one -/

theorem T5_log_one : Real.log 1 = 0 := Real.log_one

/-! ## RA-7 — log positive for x > 1 -/

theorem T5_log_pos (x : ℝ) (h : 1 < x) : 0 < Real.log x := Real.log_pos h

/-! ## RA-8 — log nonneg for x ≥ 1 -/

theorem T5_log_nonneg (x : ℝ) (h : 1 ≤ x) : 0 ≤ Real.log x :=
  Real.log_nonneg h

/-! ## RA-9 — log monotone -/

theorem T5_log_le_log (x y : ℝ) (hx : 0 < x) (h : x ≤ y) :
    Real.log x ≤ Real.log y := Real.log_le_log hx h

/-! ## RA-10 — Layer 22 foundational marker -/

theorem T5_D61_Layer22_completed_marker :
    (Real.sqrt 0 = 0) ∧
    (Real.sqrt 1 = 1) ∧
    (∀ (a : ℝ), 0 ≤ Real.sqrt a) ∧
    (Real.log 1 = 0) ∧
    (∀ (x : ℝ), 1 ≤ x → 0 ≤ Real.log x) :=
  ⟨T5_sqrt_zero,
   T5_sqrt_one,
   T5_sqrt_nonneg,
   T5_log_one,
   T5_log_nonneg⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer22_RealAnalysisHelpers
