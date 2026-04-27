/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffEvalSmul

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 164.
  `Polynomial.coeff_smul` and `eval_smul`.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's SMul-distribution identities:

  1. **`T5_polynomial_coeff_smul`** : `(r • p).coeff n = r • p.coeff n`.
  2. **`T5_polynomial_eval_smul`** : `eval x (s • p) = s • eval x p`.

  Both confirm that scalar action distributes through coeff and eval.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Coeff
import Mathlib.Algebra.Polynomial.Eval.SMul

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffEvalSmul

open Polynomial

/-! ## coeff distributes over SMul -/

/-- **Wave T5 session 164 — `(r • p).coeff n = r • p.coeff n`**. -/
theorem T5_polynomial_coeff_smul
    {R S : Type*} [Semiring R] [SMulZeroClass S R]
    (r : S) (p : R[X]) (n : ℕ) :
    (r • p).coeff n = r • p.coeff n :=
  Polynomial.coeff_smul r p n

/-! ## eval distributes over SMul -/

/-- **Wave T5 session 164 — `eval x (s • p) = s • eval x p`**. -/
theorem T5_polynomial_eval_smul
    {R S : Type*} [Semiring R] [SMulZeroClass S R] [IsScalarTower S R R]
    (s : S) (p : R[X]) (x : R) :
    Polynomial.eval x (s • p) = s • Polynomial.eval x p :=
  Polynomial.eval_smul s p x

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 164 — coeff_smul + eval_smul**.

    Two foundational SMul-distribution identities:
    1. `(r • p).coeff n = r • p.coeff n`.
    2. `eval x (s • p) = s • eval x p`.

    Sub-lemma 51/N in T-5 Phase 3.  Lean-core only. -/
theorem session_164_polynomial_coeff_eval_smul_headline :
    -- (1) coeff_smul
    (∀ {R S : Type*} [_inst : Semiring R] [_inst' : SMulZeroClass S R]
        (r : S) (p : R[X]) (n : ℕ), (r • p).coeff n = r • p.coeff n)
    -- (2) eval_smul
    ∧ (∀ {R S : Type*} [_inst : Semiring R] [_inst' : SMulZeroClass S R]
        [_inst'' : IsScalarTower S R R]
        (s : S) (p : R[X]) (x : R),
        Polynomial.eval x (s • p) = s • Polynomial.eval x p) := by
  refine ⟨?_, ?_⟩
  · intros R S _ _ r p n; exact T5_polynomial_coeff_smul r p n
  · intros R S _ _ _ s p x; exact T5_polynomial_eval_smul s p x

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_PolyCoeffEvalSmul
