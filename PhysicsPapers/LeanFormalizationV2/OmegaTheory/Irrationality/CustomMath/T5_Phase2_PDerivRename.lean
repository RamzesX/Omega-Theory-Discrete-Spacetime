/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivRename

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 10/15 session 88.
  pderiv commutes with rename (variable substitution).

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-export of Mathlib's `MvPolynomial.pderiv_rename` for use in T-5
  multi-variable index machinery:

  For injective `f : σ → τ`, `x : σ`, and `p : MvPolynomial σ R`:

      `pderiv (f x) (rename f p) = rename f (pderiv x p)`.

  This means renaming variables commutes with partial derivatives —
  useful for symmetry-of-variables arguments in Roth's lemma.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivRename

open MvPolynomial

variable {σ τ R : Type*} [CommSemiring R]

/-! ## pderiv commutes with rename -/

/-- **Wave T4b session 88 — pderiv commutes with `rename`**.

    For injective `f : σ → τ`:

      `pderiv (f x) (rename f p) = rename f (pderiv x p)`. -/
theorem T5_pderiv_rename {f : σ → τ} (hf : Function.Injective f)
    (x : σ) (p : MvPolynomial σ R) :
    pderiv (f x) (rename f p) = rename f (pderiv x p) :=
  MvPolynomial.pderiv_rename hf x p

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 88 — pderiv-rename commutativity**.

    For injective f, pderiv commutes with rename:

      `pderiv (f x) ∘ rename f = rename f ∘ pderiv x`.

    Useful for symmetry-of-variables arguments in T-5 multi-variable
    index machinery.

    Sub-lemma 10/15 in T-5 Phase 2. Lean-core only. -/
theorem session_88_pderiv_rename_headline
    {σ τ R : Type*} [CommSemiring R] :
    ∀ {f : σ → τ}, Function.Injective f →
      ∀ (x : σ) (p : MvPolynomial σ R),
        pderiv (f x) (rename f p) = rename f (pderiv x p) := by
  intros f hf x p
  exact T5_pderiv_rename hf x p

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivRename
