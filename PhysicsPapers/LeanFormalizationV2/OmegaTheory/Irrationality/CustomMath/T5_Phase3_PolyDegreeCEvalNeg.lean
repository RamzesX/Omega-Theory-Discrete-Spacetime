/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeCEvalNeg

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 161.
  `Polynomial.degree (C a)` (when a ≠ 0) + `Polynomial.eval` of `-p`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's identities:

  1. **`T5_polynomial_degree_C`** : for `a ≠ 0`, `(C a).degree = 0`.
  2. **`T5_polynomial_eval_neg`** : `eval x (-p) = -eval x p` (over Ring).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Eval.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeCEvalNeg

open Polynomial

/-! ## degree of `C a` when nonzero -/

/-- **Wave T5 session 161 — `(C a).degree = 0` when `a ≠ 0`**. -/
theorem T5_polynomial_degree_C
    {R : Type*} [Semiring R] {a : R} (ha : a ≠ 0) :
    (Polynomial.C a : R[X]).degree = 0 :=
  Polynomial.degree_C ha

/-! ## eval of negation -/

/-- **Wave T5 session 161 — `eval x (-p) = -eval x p`**.

    Negation passes through `eval` (over a Ring). -/
theorem T5_polynomial_eval_neg
    {R : Type*} [Ring R] (p : R[X]) (x : R) :
    Polynomial.eval x (-p) = -Polynomial.eval x p :=
  Polynomial.eval_neg p x

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 161 — degree_C + eval_neg**.

    Two foundational identities:
    1. `(C a).degree = 0` for `a ≠ 0`.
    2. `eval x (-p) = -eval x p` (over a Ring).

    Sub-lemma 48/N in T-5 Phase 3.  Lean-core only. -/
theorem session_161_polynomial_degree_C_eval_neg_headline :
    -- (1) degree_C
    (∀ {R : Type*} [_inst : Semiring R] {a : R}, a ≠ 0 →
        (Polynomial.C a : R[X]).degree = 0)
    -- (2) eval_neg
    ∧ (∀ {R : Type*} [_inst : Ring R] (p : R[X]) (x : R),
        Polynomial.eval x (-p) = -Polynomial.eval x p) := by
  refine ⟨?_, ?_⟩
  · intros R _ a ha; exact T5_polynomial_degree_C ha
  · intros R _ p x; exact T5_polynomial_eval_neg p x

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyDegreeCEvalNeg
