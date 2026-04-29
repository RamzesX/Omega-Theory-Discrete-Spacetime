/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer23_PolyEvalHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 23: polynomial eval helpers**.

  Foundational sub-lemmas for polynomial evaluation operations.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Algebra.Polynomial.Eval.Coeff

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer23_PolyEvalHelpers

open Polynomial

/-! ## PE-1 — Eval of zero -/

theorem T5_eval_zero (x : ℝ) : Polynomial.eval x (0 : Polynomial ℝ) = 0 :=
  Polynomial.eval_zero

/-! ## PE-2 — Eval of one -/

theorem T5_eval_one (x : ℝ) : Polynomial.eval x (1 : Polynomial ℝ) = 1 :=
  Polynomial.eval_one

/-! ## PE-3 — Eval of constant -/

theorem T5_eval_C (x c : ℝ) : Polynomial.eval x (Polynomial.C c) = c :=
  Polynomial.eval_C

/-! ## PE-4 — Eval of X -/

theorem T5_eval_X (x : ℝ) : Polynomial.eval x (Polynomial.X : Polynomial ℝ) = x :=
  Polynomial.eval_X

/-! ## PE-5 — Eval is additive -/

theorem T5_eval_add (x : ℝ) (P Q : Polynomial ℝ) :
    Polynomial.eval x (P + Q) = Polynomial.eval x P + Polynomial.eval x Q :=
  Polynomial.eval_add

/-! ## PE-6 — Eval is multiplicative -/

theorem T5_eval_mul (x : ℝ) (P Q : Polynomial ℝ) :
    Polynomial.eval x (P * Q) = Polynomial.eval x P * Polynomial.eval x Q :=
  Polynomial.eval_mul

/-! ## PE-7 — Eval is subtractive -/

theorem T5_eval_sub (x : ℝ) (P Q : Polynomial ℝ) :
    Polynomial.eval x (P - Q) = Polynomial.eval x P - Polynomial.eval x Q := by
  rw [Polynomial.eval_sub]

/-! ## PE-8 — Eval of negation -/

theorem T5_eval_neg (x : ℝ) (P : Polynomial ℝ) :
    Polynomial.eval x (-P) = -(Polynomial.eval x P) := by
  rw [Polynomial.eval_neg]

/-! ## PE-9 — Eval of pow -/

theorem T5_eval_pow (x : ℝ) (P : Polynomial ℝ) (n : ℕ) :
    Polynomial.eval x (P^n) = (Polynomial.eval x P)^n := by
  rw [Polynomial.eval_pow]

/-! ## PE-10 — Layer 23 foundational marker -/

theorem T5_D61_Layer23_completed_marker :
    (∀ (x : ℝ), Polynomial.eval x (0 : Polynomial ℝ) = 0) ∧
    (∀ (x : ℝ), Polynomial.eval x (1 : Polynomial ℝ) = 1) ∧
    (∀ (x : ℝ), Polynomial.eval x (Polynomial.X : Polynomial ℝ) = x) ∧
    (∀ (x : ℝ) (P Q : Polynomial ℝ),
      Polynomial.eval x (P + Q) = Polynomial.eval x P + Polynomial.eval x Q) ∧
    (∀ (x : ℝ) (P Q : Polynomial ℝ),
      Polynomial.eval x (P * Q) = Polynomial.eval x P * Polynomial.eval x Q) :=
  ⟨T5_eval_zero,
   T5_eval_one,
   T5_eval_X,
   T5_eval_add,
   T5_eval_mul⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer23_PolyEvalHelpers
