/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalAddMul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 149.
  `Polynomial.eval` add / mul — ring-hom properties.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.eval` ring-hom identities:

  1. **`T5_polynomial_eval_add`** : `eval x (p + q) = eval x p + eval x q`.
  2. **`T5_polynomial_eval_mul`** : `eval x (p * q) = eval x p * eval x q`.

  Confirms `eval x` is a ring homomorphism R[X] → R.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalAddMul

open Polynomial

/-! ## eval is additive + multiplicative -/

/-- **Wave T5 session 149 — `eval` is additive**.

    `eval x (p + q) = eval x p + eval x q`. -/
theorem T5_polynomial_eval_add
    {R : Type*} [Semiring R] {p q : R[X]} {x : R} :
    Polynomial.eval x (p + q) = Polynomial.eval x p + Polynomial.eval x q :=
  Polynomial.eval_add

/-- **Wave T5 session 149 — `eval` is multiplicative**.

    `eval x (p * q) = eval x p * eval x q`. -/
theorem T5_polynomial_eval_mul
    {R : Type*} [CommSemiring R] {p q : R[X]} {x : R} :
    Polynomial.eval x (p * q) = Polynomial.eval x p * Polynomial.eval x q :=
  Polynomial.eval_mul

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 149 — eval add/mul (ring hom)**.

    Two foundational identities establishing `eval x : R[X] → R` is
    a ring homomorphism:
    1. `eval x (p + q) = eval x p + eval x q` (additive).
    2. `eval x (p * q) = eval x p * eval x q` (multiplicative,
       requires CommSemiring R).

    Sub-lemma 37/N in T-5 Phase 3.  Lean-core only. -/
theorem session_149_polynomial_eval_add_mul_headline :
    -- (1) Additive
    (∀ {R : Type*} [_inst : Semiring R] {p q : R[X]} {x : R},
        Polynomial.eval x (p + q) = Polynomial.eval x p + Polynomial.eval x q)
    -- (2) Multiplicative
    ∧ (∀ {R : Type*} [_inst : CommSemiring R] {p q : R[X]} {x : R},
        Polynomial.eval x (p * q) =
          Polynomial.eval x p * Polynomial.eval x q) := by
  refine ⟨?_, ?_⟩
  · intros R _ p q x; exact T5_polynomial_eval_add
  · intros R _ p q x; exact T5_polynomial_eval_mul

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyEvalAddMul
