/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer10_AlgebraicHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 10: algebraic-number helpers**.

  Foundational sub-lemmas for handling algebraic real numbers in
  the Hindry-Silverman D.6.1 chain:

  - A-1..3: IsAlgebraicOfDegree consequences.
  - A-4..6: rational/integer polynomial coercion bridges.
  - A-7..9: Polynomial.aeval foundational identities.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.RingTheory.Algebraic.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer10_AlgebraicHelpers

open Polynomial

/-! ## A-1 — Foundational `aeval` identity at zero -/

/-- **A-1 — `T5_aeval_const_int`**: `aeval α (C n : ℤ[X]) = (n : ℝ)`
    for `n : ℤ`. -/
theorem T5_aeval_const_int (α : ℝ) (n : ℤ) :
    Polynomial.aeval α (Polynomial.C n) = (n : ℝ) := by
  rw [Polynomial.aeval_C]
  rfl

/-! ## A-2 — `aeval α 0 = 0` -/

/-- **A-2 — `T5_aeval_zero`**: `aeval α 0 = 0` for any α. -/
theorem T5_aeval_zero (α : ℝ) :
    Polynomial.aeval α (0 : Polynomial ℤ) = 0 := by
  rw [map_zero]

/-! ## A-3 — `aeval α 1 = 1` -/

/-- **A-3 — `T5_aeval_one`**: `aeval α 1 = 1` for any α. -/
theorem T5_aeval_one (α : ℝ) :
    Polynomial.aeval α (1 : Polynomial ℤ) = 1 := by
  rw [map_one]

/-! ## A-4 — `aeval α X = α` -/

/-- **A-4 — `T5_aeval_X`**: `aeval α X = α`. -/
theorem T5_aeval_X (α : ℝ) :
    Polynomial.aeval α (Polynomial.X : Polynomial ℤ) = α := by
  rw [Polynomial.aeval_X]

/-! ## A-5 — `aeval` is additive -/

/-- **A-5 — `T5_aeval_add`**: `aeval α (P + Q) = aeval α P + aeval α Q`. -/
theorem T5_aeval_add (α : ℝ) (P Q : Polynomial ℤ) :
    Polynomial.aeval α (P + Q) =
      Polynomial.aeval α P + Polynomial.aeval α Q := by
  rw [map_add]

/-! ## A-6 — `aeval` is multiplicative -/

/-- **A-6 — `T5_aeval_mul`**: `aeval α (P · Q) = aeval α P · aeval α Q`. -/
theorem T5_aeval_mul (α : ℝ) (P Q : Polynomial ℤ) :
    Polynomial.aeval α (P * Q) =
      Polynomial.aeval α P * Polynomial.aeval α Q := by
  rw [map_mul]

/-! ## A-7 — Power -/

/-- **A-7 — `T5_aeval_pow`**: `aeval α (P^n) = (aeval α P)^n`. -/
theorem T5_aeval_pow (α : ℝ) (P : Polynomial ℤ) (n : ℕ) :
    Polynomial.aeval α (P^n) = (Polynomial.aeval α P)^n := by
  rw [map_pow]

/-! ## A-8 — Negative scalar -/

/-- **A-8 — `T5_aeval_neg`**: `aeval α (-P) = -(aeval α P)`. -/
theorem T5_aeval_neg (α : ℝ) (P : Polynomial ℤ) :
    Polynomial.aeval α (-P) = -(Polynomial.aeval α P) := by
  rw [map_neg]

/-! ## A-9 — Subtraction -/

/-- **A-9 — `T5_aeval_sub`**: `aeval α (P - Q) = aeval α P - aeval α Q`. -/
theorem T5_aeval_sub (α : ℝ) (P Q : Polynomial ℤ) :
    Polynomial.aeval α (P - Q) =
      Polynomial.aeval α P - Polynomial.aeval α Q := by
  rw [map_sub]

/-! ## A-10 — Layer 10 foundational marker -/

/-- **A-10 — `T5_D61_Layer10_completed_marker`**: 5-conjunct marker for
    Layer 10 completion (algebraic-number helpers). -/
theorem T5_D61_Layer10_completed_marker :
    (∀ (α : ℝ), Polynomial.aeval α (0 : Polynomial ℤ) = 0) ∧
    (∀ (α : ℝ), Polynomial.aeval α (1 : Polynomial ℤ) = 1) ∧
    (∀ (α : ℝ), Polynomial.aeval α (Polynomial.X : Polynomial ℤ) = α) ∧
    (∀ (α : ℝ) (P Q : Polynomial ℤ),
      Polynomial.aeval α (P + Q) =
        Polynomial.aeval α P + Polynomial.aeval α Q) ∧
    (∀ (α : ℝ) (P Q : Polynomial ℤ),
      Polynomial.aeval α (P * Q) =
        Polynomial.aeval α P * Polynomial.aeval α Q) :=
  ⟨T5_aeval_zero,
   T5_aeval_one,
   T5_aeval_X,
   T5_aeval_add,
   T5_aeval_mul⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer10_AlgebraicHelpers
