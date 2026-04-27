/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_Bind1

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub session 109.
  MvPolynomial.bind₁ basics.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of Mathlib's `MvPolynomial.bind₁` API:

  1. **`T5_bind1_X_right`** : `bind₁ f (X i) = f i`.
  2. **`T5_bind1_X_left`** : `bind₁ X = AlgHom.id`.
  3. **`T5_bind1_C_right`** : `bind₁ f (C x) = C x`.

  bind₁ is the substitution operation on MvPolynomial — replace each
  variable X i with f i. Foundational for cycle 64 closure (used in
  s46 via comp_aeval_apply) and T-5 multi-variable index.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Monad

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_Bind1

open MvPolynomial

variable {σ τ R : Type*} [CommSemiring R]

/-! ## bind₁ basic identities -/

/-- **Wave T4b session 109 — bind₁ at X i**.

    `bind₁ f (X i) = f i`. -/
theorem T5_bind1_X_right (f : σ → MvPolynomial τ R) (i : σ) :
    (bind₁ f : MvPolynomial σ R →ₐ[R] MvPolynomial τ R) (X i) = f i :=
  MvPolynomial.bind₁_X_right f i

/-- **Wave T4b session 109 — bind₁ at C x**.

    `bind₁ f (C x) = C x`. -/
theorem T5_bind1_C_right (f : σ → MvPolynomial τ R) (x : R) :
    (bind₁ f : MvPolynomial σ R →ₐ[R] MvPolynomial τ R) (C x) = C x :=
  MvPolynomial.bind₁_C_right f x

/-- **Wave T4b session 109 — bind₁ X is identity**.

    `bind₁ X = AlgHom.id`. -/
theorem T5_bind1_X_left :
    (bind₁ (X : σ → MvPolynomial σ R) : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) =
      AlgHom.id R (MvPolynomial σ R) :=
  MvPolynomial.bind₁_X_left

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 109 — bind₁ basic identities**.

    Three foundational facts:
    1. bind₁ f (X i) = f i (substitute X with f)
    2. bind₁ f (C x) = C x (preserves constants)
    3. bind₁ X = AlgHom.id (identity substitution)

    Lean-core only. -/
theorem session_109_bind1_basics_headline
    {σ τ R : Type*} [CommSemiring R] :
    -- (1) X i
    (∀ f : σ → MvPolynomial τ R, ∀ i : σ,
        (bind₁ f : MvPolynomial σ R →ₐ[R] MvPolynomial τ R) (X i) = f i)
    -- (2) C x
    ∧ (∀ f : σ → MvPolynomial τ R, ∀ x : R,
        (bind₁ f : MvPolynomial σ R →ₐ[R] MvPolynomial τ R) (C x) = C x)
    -- (3) X is identity
    ∧ ((bind₁ (X : σ → MvPolynomial σ R) : MvPolynomial σ R →ₐ[R] MvPolynomial σ R) =
        AlgHom.id R (MvPolynomial σ R)) := by
  refine ⟨?_, ?_, ?_⟩
  · exact T5_bind1_X_right
  · exact T5_bind1_C_right
  · exact T5_bind1_X_left

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_Bind1
