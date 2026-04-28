/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PDerivIterateXPowEval

  T-5 (Roth's theorem) — **Phase 7 ext #34: pderiv iterate X^n eval at α
  (single-variable closed-form integer point evaluation)**, sub session
  559aaaa — STRICT critical-path #316 (T-5) Phase 7 ext #34.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Single-variable iterated pderiv evaluated at integer point — direct
  composition of T5_Phase3 single-variable closed form with Mathlib's
  `MvPolynomial.eval_X` + `eval_pow`:

      `(eval α) ((pderiv i)^[k] (X i)^n) = descFactorial n k · (α i)^(n-k)`

  This is the SINGLE-VARIABLE specialization of the multivariate
  product-monomial closed form (Gap A core, ext #35+). Provides the
  evaluation-at-integer-point form needed for the matrix-entry chain.

  Single derivation + Prop:
  1. `T5_pderiv_iterate_X_pow_eval`: eval composition theorem

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow
import Mathlib.Algebra.MvPolynomial.Eval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PDerivIterateXPowEval

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_PDerivIterateXPow

variable {σ : Type*} {R : Type*} [CommSemiring R]

/-! ## Single-variable iterated pderiv eval at α -/

/-- **🚨 Wave T5 session 559aaaa — `(eval α) ((pderiv i)^[k] (X i)^n) = descFactorial n k · α i^(n-k)`**.

    Direct composition: T5_pderiv_iterate_X_pow_self closed form
    + MvPolynomial.eval_X + eval_pow + map_mul + map_natCast. -/
theorem T5_pderiv_iterate_X_pow_eval (α : σ → R) (i : σ) (n k : ℕ) :
    (MvPolynomial.eval α)
      ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n))
      = (n.descFactorial k : R) * (α i) ^ (n - k) := by
  rw [T5_pderiv_iterate_X_pow_self]
  rw [map_mul]
  rw [MvPolynomial.eval_pow, MvPolynomial.eval_X]
  congr 1
  -- (eval α) (n.descFactorial k : MvPolynomial σ R) = (n.descFactorial k : R)
  rw [show ((n.descFactorial k : MvPolynomial σ R) : MvPolynomial σ R) =
        ((n.descFactorial k : ℕ) : MvPolynomial σ R) from rfl]
  rw [map_natCast]

/-! ## PDerivIterateXPowEval Prop scaffold -/

/-- **PDerivIterateXPowEval**: 1-conjunct Prop packaging the
    eval-at-integer-point single-variable closed form. -/
def PDerivIterateXPowEval : Prop :=
  ∀ {σ : Type*} {R : Type*} [CommSemiring R] (α : σ → R) (i : σ) (n k : ℕ),
    (MvPolynomial.eval α)
      ((pderiv i)^[k] ((X i : MvPolynomial σ R) ^ n))
      = (n.descFactorial k : R) * (α i) ^ (n - k)

/-- **🚨 Wave T5 session 559aaaa — `PDerivIterateXPowEval`**. -/
theorem T5_pderiv_iterate_X_pow_eval_prop : PDerivIterateXPowEval :=
  @T5_pderiv_iterate_X_pow_eval

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaaa — T-5 Phase 7 ext #34:
    iterated pderiv X^n eval at integer point**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #34.

    Single derivation + Prop:
    1. `T5_pderiv_iterate_X_pow_eval` — eval composition via
       T5_pderiv_iterate_X_pow_self (T5_Phase3:43) + map_mul +
       eval_pow + eval_X + map_natCast
    + PDerivIterateXPowEval Prop (1-conjunct).

    Single-variable specialization: combined with the FULL multi-
    pderiv product-monomial closed form (ext #35+), gives the
    matrix-entry evaluation `multiIteratedPDeriv I (∏ X^s) at α =
    (∏ descFactorial sⱼ Iⱼ) · (∏ α^(sⱼ-Iⱼ))`.

    Mathlib usage: `MvPolynomial.eval_X`, `MvPolynomial.eval_pow`,
    `map_mul`, `map_natCast`.

    Sub-lemma 227/N in T-1 (T-5 Phase 7 ext #34).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 single-variable iterated pderiv
    eval-at-integer-point closed form. -/
theorem session_559aaaa_T5_phase7_pderiv_iterate_X_pow_eval_headline :
    PDerivIterateXPowEval :=
  T5_pderiv_iterate_X_pow_eval_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PDerivIterateXPowEval
