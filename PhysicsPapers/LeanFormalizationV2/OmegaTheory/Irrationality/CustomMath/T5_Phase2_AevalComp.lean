/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalComp

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 14/15 session 92.
  MvPolynomial.aeval composition properties.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of aeval composition identities:

  1. **`T5_comp_aeval_apply`** : `φ (aeval f p) = aeval (φ ∘ f) p`
     for any algebra hom `φ`.

  2. **`T5_aeval_X_left_apply`** : `aeval X p = p` (identity evaluation).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Eval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalComp

open MvPolynomial

variable {σ R S₁ B : Type*} [CommSemiring R] [CommSemiring S₁] [CommSemiring B]
    [Algebra R S₁] [Algebra R B]

/-! ## aeval composition with algebra-hom -/

/-- **Wave T4b session 92 — aeval-φ composition**.

    For algebra-hom `φ : S₁ →ₐ[R] B` and polynomial `p : MvPolynomial σ R`
    evaluated at `f : σ → S₁`:

      `φ (aeval f p) = aeval (fun i => φ (f i)) p`. -/
theorem T5_comp_aeval_apply (f : σ → S₁) (φ : S₁ →ₐ[R] B) (p : MvPolynomial σ R) :
    φ ((aeval f) p) = (aeval (fun i ↦ φ (f i))) p := by
  exact MvPolynomial.comp_aeval_apply (f := f) φ p

/-! ## aeval at X is identity -/

/-- **Wave T4b session 92 — aeval at X is identity**.

    `aeval X p = p` for any `p : MvPolynomial σ R`. -/
theorem T5_aeval_X_left_apply (p : MvPolynomial σ R) :
    (aeval X) p = p :=
  MvPolynomial.aeval_X_left_apply p

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 92 — aeval composition + identity**.

    Two foundational composition identities:
    1. `φ (aeval f p) = aeval (φ ∘ f) p` (composition with algebra-hom).
    2. `aeval X p = p` (X is identity-evaluation).

    Sub-lemma 14/15 in T-5 Phase 2. Lean-core only. -/
theorem session_92_aeval_composition_headline
    {σ R S₁ B : Type*} [CommSemiring R] [CommSemiring S₁] [CommSemiring B]
    [Algebra R S₁] [Algebra R B] :
    -- (1) Composition
    (∀ f : σ → S₁, ∀ φ : S₁ →ₐ[R] B, ∀ p : MvPolynomial σ R,
        φ ((aeval f) p) = (aeval (fun i ↦ φ (f i))) p)
    -- (2) Identity
    ∧ (∀ p : MvPolynomial σ R, (aeval X) p = p) := by
  refine ⟨?_, ?_⟩
  · exact T5_comp_aeval_apply
  · exact T5_aeval_X_left_apply

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalComp
