/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalRenameRename

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 112.
  MvPolynomial.aeval composed with iterated rename.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Iterated form of Mathlib's `MvPolynomial.aeval_rename`:

      `aeval g (rename f (rename k p)) = aeval (g ∘ f ∘ k) p`

  Useful for variable substitution chains in the T-5 multivariable
  index machinery (where we need to compose multiple variable renamings
  before evaluating).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Rename

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalRenameRename

open MvPolynomial

variable {σ τ υ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]

/-! ## aeval ∘ rename ∘ rename -/

/-- **Wave T5 session 112 — aeval composed with two renames**.

    `aeval g (rename f (rename k p)) = aeval (g ∘ f ∘ k) p`. -/
theorem T5_aeval_rename_rename
    (k : σ → τ) (f : τ → υ) (g : υ → S) (p : MvPolynomial σ R) :
    (aeval g : MvPolynomial υ R →ₐ[R] S) (rename f (rename k p)) =
      (aeval (g ∘ f ∘ k) : MvPolynomial σ R →ₐ[R] S) p := by
  rw [MvPolynomial.aeval_rename, MvPolynomial.aeval_rename]
  rfl

/-- **Wave T5 session 112 — rename ∘ rename composition**.

    `rename f (rename k p) = rename (f ∘ k) p`. -/
theorem T5_rename_rename
    (k : σ → τ) (f : τ → υ) (p : MvPolynomial σ R) :
    rename f (rename k p) = rename (f ∘ k) p := by
  rw [← AlgHom.comp_apply, MvPolynomial.rename_comp_rename]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 112 — aeval-rename-rename composition**.

    Two foundational facts for chained variable renaming:
    1. `aeval g (rename f (rename k p)) = aeval (g ∘ f ∘ k) p`
    2. `rename f (rename k p) = rename (f ∘ k) p`

    Combined: a chain of renames composes into a single rename, and
    aeval-after-renames is aeval-after-composed-rename.

    Used in T-5 multivariable index calculus where we track variable
    substitutions through compositions. Lean-core only. -/
theorem session_112_aeval_rename_rename_headline
    {σ τ υ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S] :
    -- (1) aeval over double rename
    (∀ (k : σ → τ) (f : τ → υ) (g : υ → S) (p : MvPolynomial σ R),
        (aeval g : MvPolynomial υ R →ₐ[R] S) (rename f (rename k p)) =
          (aeval (g ∘ f ∘ k) : MvPolynomial σ R →ₐ[R] S) p)
    -- (2) rename composition
    ∧ (∀ (k : σ → τ) (f : τ → υ) (p : MvPolynomial σ R),
        rename f (rename k p) = rename (f ∘ k) p) :=
  ⟨T5_aeval_rename_rename, T5_rename_rename⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_AevalRenameRename
