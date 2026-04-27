/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeCasts

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 175.
  `Polynomial.derivative` of natCast / intCast.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.derivative` on number casts:

  1. **`T5_polynomial_derivative_natCast`** : `derivative (n : R[X]) = 0` for n : ℕ.
  2. **`T5_polynomial_derivative_intCast`** : `derivative (n : R[X]) = 0` for n : ℤ.

  Casts have zero derivative — they're constants.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeCasts

open Polynomial

/-! ## derivative of natCast -/

/-- **Wave T5 session 175 — `derivative (n : R[X]) = 0`** for `n : ℕ`. -/
theorem T5_polynomial_derivative_natCast {R : Type*} [Semiring R] {n : ℕ} :
    Polynomial.derivative ((n : R[X])) = 0 :=
  Polynomial.derivative_natCast

/-! ## derivative of intCast -/

/-- **Wave T5 session 175 — `derivative (n : R[X]) = 0`** for `n : ℤ`. -/
theorem T5_polynomial_derivative_intCast {R : Type*} [Ring R] {n : ℤ} :
    Polynomial.derivative ((n : R[X])) = 0 :=
  Polynomial.derivative_intCast

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 175 — derivative of casts**.

    Two foundational identities:
    1. `derivative (n : R[X]) = 0` for n : ℕ.
    2. `derivative (n : R[X]) = 0` for n : ℤ.

    Casts are constants — their derivative vanishes.

    Sub-lemma 62/N in T-5 Phase 3.  Lean-core only. -/
theorem session_175_polynomial_derivative_casts_headline :
    -- (1) ℕ
    (∀ {R : Type*} [_inst : Semiring R] {n : ℕ},
        Polynomial.derivative ((n : R[X])) = 0)
    -- (2) ℤ
    ∧ (∀ {R : Type*} [_inst : Ring R] {n : ℤ},
        Polynomial.derivative ((n : R[X])) = 0) := by
  refine ⟨?_, ?_⟩
  · intros R _ n; exact T5_polynomial_derivative_natCast
  · intros R _ n; exact T5_polynomial_derivative_intCast

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeCasts
