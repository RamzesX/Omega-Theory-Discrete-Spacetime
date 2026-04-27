/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalBasics

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 13/15 session 91.
  MvPolynomial.aeval basic identities.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of MvPolynomial.aeval API:

  1. **`T5_aeval_C`** : `aeval γ (C a) = algebraMap _ _ a`.
  2. **`T5_aeval_X`** : `aeval γ (X i) = γ i`.
  3. **`T5_aeval_zero`** : `aeval γ 0 = 0`.
  4. **`T5_aeval_one`** : `aeval γ 1 = 1`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Eval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalBasics

open MvPolynomial

variable {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]

/-! ## aeval at basic generators -/

/-- **Wave T4b session 91 — aeval at `C a`**.

    `aeval γ (C a) = algebraMap R S a`. -/
theorem T5_aeval_C (γ : σ → S) (a : R) :
    (aeval γ : MvPolynomial σ R →ₐ[R] S) (C a) = algebraMap R S a :=
  MvPolynomial.aeval_C γ a

/-- **Wave T4b session 91 — aeval at `X i`**.

    `aeval γ (X i) = γ i`. -/
theorem T5_aeval_X (γ : σ → S) (i : σ) :
    (aeval γ : MvPolynomial σ R →ₐ[R] S) (X i) = γ i :=
  MvPolynomial.aeval_X γ i

/-! ## Linearity -/

/-- **Wave T4b session 91 — aeval at `0` is `0`**. -/
theorem T5_aeval_zero (γ : σ → S) :
    (aeval γ : MvPolynomial σ R →ₐ[R] S) 0 = 0 := by
  simp

/-- **Wave T4b session 91 — aeval at `1` is `1`**. -/
theorem T5_aeval_one (γ : σ → S) :
    (aeval γ : MvPolynomial σ R →ₐ[R] S) 1 = 1 := by
  simp

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 91 — aeval basic identities**.

    Four foundational facts:
    1. aeval at C a = algebraMap a
    2. aeval at X i = γ i
    3. aeval at 0 = 0
    4. aeval at 1 = 1

    Sub-lemma 13/15 in T-5 Phase 2. Lean-core only. -/
theorem session_91_aeval_basic_identities_headline
    {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S] :
    -- (1) aeval C
    (∀ γ : σ → S, ∀ a : R,
        (aeval γ : MvPolynomial σ R →ₐ[R] S) (C a) = algebraMap R S a)
    -- (2) aeval X
    ∧ (∀ γ : σ → S, ∀ i : σ,
        (aeval γ : MvPolynomial σ R →ₐ[R] S) (X i) = γ i)
    -- (3) aeval 0
    ∧ (∀ γ : σ → S,
        (aeval γ : MvPolynomial σ R →ₐ[R] S) 0 = 0)
    -- (4) aeval 1
    ∧ (∀ γ : σ → S,
        (aeval γ : MvPolynomial σ R →ₐ[R] S) 1 = 1) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact T5_aeval_C
  · exact T5_aeval_X
  · exact T5_aeval_zero
  · exact T5_aeval_one

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_AevalBasics
