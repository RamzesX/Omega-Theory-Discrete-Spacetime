/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeSubCoeffNeg

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 163.
  `Polynomial.derivative_sub` and `coeff_neg` (Ring level).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's Ring-level polynomial identities:

  1. **`T5_polynomial_derivative_sub`** : `derivative (f - g) = derivative f - derivative g`.
  2. **`T5_polynomial_coeff_neg`** : `(-p).coeff n = -p.coeff n`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Polynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeSubCoeffNeg

open Polynomial

variable {R : Type*} [Ring R]

/-! ## derivative of subtraction -/

/-- **Wave T5 session 163 — `derivative (f - g) = derivative f - derivative g`**. -/
theorem T5_polynomial_derivative_sub {f g : R[X]} :
    Polynomial.derivative (f - g) =
      Polynomial.derivative f - Polynomial.derivative g :=
  Polynomial.derivative_sub

/-! ## coeff of negation -/

/-- **Wave T5 session 163 — `(-p).coeff n = -p.coeff n`**. -/
theorem T5_polynomial_coeff_neg (p : R[X]) (n : ℕ) :
    (-p).coeff n = -p.coeff n :=
  Polynomial.coeff_neg p n

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 163 — derivative_sub + coeff_neg**.

    Two foundational Ring-level identities:
    1. `derivative (f - g) = derivative f - derivative g`.
    2. `(-p).coeff n = -p.coeff n`.

    Sub-lemma 50/N in T-5 Phase 3.  Lean-core only.

    🏆 50 sub-lemmas LANDED (s110-s163). -/
theorem session_163_polynomial_derivative_sub_coeff_neg_headline
    {R : Type*} [Ring R] :
    -- (1) derivative_sub
    (∀ {f g : R[X]},
        Polynomial.derivative (f - g) =
          Polynomial.derivative f - Polynomial.derivative g)
    -- (2) coeff_neg
    ∧ (∀ (p : R[X]) (n : ℕ), (-p).coeff n = -p.coeff n) := by
  refine ⟨?_, ?_⟩
  · intros f g; exact T5_polynomial_derivative_sub
  · intros p n; exact T5_polynomial_coeff_neg p n

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDerivativeSubCoeffNeg
