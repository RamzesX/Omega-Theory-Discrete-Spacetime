/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffAddEvalZero

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 153.
  `Polynomial.coeff` additivity + `eval 0`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.coeff` and `eval` identities:

  1. **`T5_polynomial_coeff_add`** : `(p + q).coeff n = p.coeff n + q.coeff n`.
  2. **`T5_polynomial_eval_zero`** : `eval x 0 = 0`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffAddEvalZero

open Polynomial

/-! ## coeff additivity -/

/-- **Wave T5 session 153 — `(p + q).coeff n = p.coeff n + q.coeff n`**. -/
theorem T5_polynomial_coeff_add {R : Type*} [Semiring R]
    (p q : R[X]) (n : ℕ) :
    (p + q).coeff n = p.coeff n + q.coeff n :=
  Polynomial.coeff_add p q n

/-- **Wave T5 session 153 — `eval x 0 = 0`**. -/
theorem T5_polynomial_eval_zero {R : Type*} [Semiring R] {x : R} :
    Polynomial.eval x (0 : R[X]) = 0 :=
  Polynomial.eval_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 153 — coeff additivity + eval zero**.

    Two foundational identities:
    1. `(p + q).coeff n = p.coeff n + q.coeff n` (coeff is additive).
    2. `eval x 0 = 0`.

    Sub-lemma 40/N in T-5 Phase 3.  Lean-core only. -/
theorem session_153_polynomial_coeff_add_eval_zero_headline :
    -- (1) coeff additive
    (∀ {R : Type*} [_inst : Semiring R] (p q : R[X]) (n : ℕ),
        (p + q).coeff n = p.coeff n + q.coeff n)
    -- (2) eval zero
    ∧ (∀ {R : Type*} [_inst : Semiring R] {x : R},
        Polynomial.eval x (0 : R[X]) = 0) := by
  refine ⟨?_, ?_⟩
  · intros R _ p q n; exact T5_polynomial_coeff_add p q n
  · intros R _ x; exact T5_polynomial_eval_zero

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffAddEvalZero
