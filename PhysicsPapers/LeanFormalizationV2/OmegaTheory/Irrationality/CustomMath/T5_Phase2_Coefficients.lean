/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_Coefficients

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 11/15 session 89.
  MvPolynomial coefficient extraction.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of MvPolynomial coefficient API for use in T-5 Phase 2-3:

  1. **`T5_coeff_add`** : `coeff m (p + q) = coeff m p + coeff m q`.
  2. **`T5_coeff_C_mul`** : `coeff m (C a * p) = a * coeff m p`.
  3. **`T5_coeff_X`** : `coeff (single i 1) (X i) = 1`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_Coefficients

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Sum -/

/-- **Wave T4b session 89 — coeff of MvPolynomial sum**.

    `coeff m (p + q) = coeff m p + coeff m q`. -/
theorem T5_coeff_add (m : σ →₀ ℕ) (p q : MvPolynomial σ R) :
    coeff m (p + q) = coeff m p + coeff m q :=
  MvPolynomial.coeff_add m p q

/-! ## Scalar multiplication -/

/-- **Wave T4b session 89 — coeff of `C a * p`**.

    `coeff m (C a * p) = a * coeff m p`. -/
theorem T5_coeff_C_mul (m : σ →₀ ℕ) (a : R) (p : MvPolynomial σ R) :
    coeff m (C a * p) = a * coeff m p :=
  MvPolynomial.coeff_C_mul m a p

/-! ## Variable -/

/-- **Wave T4b session 89 — coeff of `X i` at single index 1**.

    `coeff (single i 1) (X i) = 1`. -/
theorem T5_coeff_X (i : σ) :
    coeff (Finsupp.single i 1) (X i : MvPolynomial σ R) = 1 :=
  MvPolynomial.coeff_X i

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 89 — coefficient extraction**.

    Three foundational facts for tracking specific coefficients:
    1. coeff distributes over sum.
    2. coeff of C-multiple.
    3. coeff of X i at appropriate index.

    Sub-lemma 11/15 in T-5 Phase 2. Lean-core only. -/
theorem session_89_coefficient_extraction_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Sum
    (∀ m : σ →₀ ℕ, ∀ p q : MvPolynomial σ R,
        coeff m (p + q) = coeff m p + coeff m q)
    -- (2) C-mul
    ∧ (∀ m : σ →₀ ℕ, ∀ a : R, ∀ p : MvPolynomial σ R,
        coeff m (C a * p) = a * coeff m p)
    -- (3) X i
    ∧ (∀ i : σ,
        coeff (Finsupp.single i 1) (X i : MvPolynomial σ R) = 1) := by
  refine ⟨?_, ?_, ?_⟩
  · exact T5_coeff_add
  · exact T5_coeff_C_mul
  · exact T5_coeff_X

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_Coefficients
