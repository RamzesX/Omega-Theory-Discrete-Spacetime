/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolynomialEvalBasics

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 135.
  `Polynomial.eval` foundational identities.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's `Polynomial.eval` on basic generators:

  1. **`T5_eval_X`** : `eval x X = x`.
  2. **`T5_eval_C`** : `eval x (C a) = a`.
  3. **`T5_eval_one`** : `eval x 1 = 1`.
  4. **`T5_eval_C_mul`** : `eval x (C a * p) = a * eval x p`.

  Mirror of T5_Phase3_AevalBasics (s120) for Polynomial (vs MvPolynomial).

  Used in T-5 polynomial-index calculus, where univariate polynomials
  appear as the minimal polynomials of algebraic α.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolynomialEvalBasics

open Polynomial

variable {R : Type*} [Semiring R]

/-! ## Polynomial.eval on generators -/

/-- **Wave T5 session 135 — eval at X is identity**.

    `eval x X = x`. -/
theorem T5_eval_X (x : R) : Polynomial.eval x (X : R[X]) = x :=
  Polynomial.eval_X

/-- **Wave T5 session 135 — eval at constant is constant**.

    `eval x (C a) = a`. -/
theorem T5_eval_C (a x : R) : Polynomial.eval x (C a : R[X]) = a :=
  Polynomial.eval_C

/-- **Wave T5 session 135 — eval at 1 is 1**.

    `eval x 1 = 1`. -/
theorem T5_eval_one (x : R) : Polynomial.eval x (1 : R[X]) = 1 :=
  Polynomial.eval_one

/-- **Wave T5 session 135 — eval distributes over `C a * p`**.

    `eval x (C a * p) = a * eval x p`. -/
theorem T5_eval_C_mul {a : R} {p : R[X]} {x : R} :
    Polynomial.eval x (C a * p) = a * Polynomial.eval x p :=
  Polynomial.eval_C_mul

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 135 — Polynomial eval basics**.

    Four foundational identities:
    1. `eval x X = x`.
    2. `eval x (C a) = a`.
    3. `eval x 1 = 1`.
    4. `eval x (C a * p) = a * eval x p`.

    Sub-lemma 24/N in T-5 Phase 3.  Lean-core only.

    Mirror of T5_Phase3_AevalBasics (s120) for univariate `Polynomial`. -/
theorem session_135_polynomial_eval_basics_headline
    {R : Type*} [Semiring R] :
    -- (1) eval X
    (∀ (x : R), Polynomial.eval x (X : R[X]) = x)
    -- (2) eval C
    ∧ (∀ (a x : R), Polynomial.eval x (C a : R[X]) = a)
    -- (3) eval 1
    ∧ (∀ (x : R), Polynomial.eval x (1 : R[X]) = 1)
    -- (4) eval C·p
    ∧ (∀ {a : R} {p : R[X]} {x : R},
        Polynomial.eval x (C a * p) = a * Polynomial.eval x p) :=
  ⟨T5_eval_X, T5_eval_C, T5_eval_one, fun {_a _p _x} => T5_eval_C_mul⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolynomialEvalBasics
