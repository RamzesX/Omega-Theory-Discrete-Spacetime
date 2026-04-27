/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalRename

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 25 session 106.
  MvPolynomial.aeval composed with rename.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-export of Mathlib's `MvPolynomial.aeval_rename`:

      `aeval g (rename k p) = aeval (g ∘ k) p`

  Useful for variable substitution in the T-5 multivariable
  index machinery (where we need to track how aeval at one tuple
  relates to aeval at a renamed tuple).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Rename

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalRename

open MvPolynomial

variable {σ τ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]

/-! ## aeval ∘ rename -/

/-- **Wave T4b session 106 — aeval composed with rename**.

    `aeval g (rename k p) = aeval (g ∘ k) p`. -/
theorem T5_aeval_rename (k : σ → τ) (g : τ → S) (p : MvPolynomial σ R) :
    (aeval g : MvPolynomial τ R →ₐ[R] S) (rename k p) =
      (aeval (g ∘ k) : MvPolynomial σ R →ₐ[R] S) p :=
  MvPolynomial.aeval_rename k g p

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 106 — aeval-rename composition**.

    `aeval g ∘ rename k = aeval (g ∘ k)`.

    Useful for tracking how variable-renaming interacts with evaluation
    in T-5 multivariable index machinery.

    Sub-lemma 25 in T-5 Phase 2 (extension). Lean-core only. -/
theorem session_106_aeval_rename_headline
    {σ τ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S] :
    ∀ (k : σ → τ) (g : τ → S) (p : MvPolynomial σ R),
      (aeval g : MvPolynomial τ R →ₐ[R] S) (rename k p) =
        (aeval (g ∘ k) : MvPolynomial σ R →ₐ[R] S) p :=
  T5_aeval_rename

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalRename
