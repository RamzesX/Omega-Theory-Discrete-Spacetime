/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivLinearity

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 6/15 session 84.
  Linearity and Leibniz rule for MvPolynomial.pderiv.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-exports of Mathlib's MvPolynomial.pderiv linearity properties:

  1. **`T5_pderiv_add`** : pderiv distributes over sum.
  2. **`T5_pderiv_mul`** : Leibniz rule for product.
  3. **`T5_pderiv_pow`** : `pderiv i (f^n) = n * f^(n-1) * pderiv i f`.
  4. **`T5_pderiv_C_mul`** : `pderiv i (C a * f) = C a * pderiv i f`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivLinearity

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Sum -/

/-- **Wave T4b session 84 — pderiv distributes over sum**.

    pderiv is a Derivation, hence ℝ-linear (in particular distributes
    over +). -/
theorem T5_pderiv_add (i : σ) (f g : MvPolynomial σ R) :
    pderiv i (f + g) = pderiv i f + pderiv i g := by
  simp [map_add]

/-! ## Leibniz rule for product -/

/-- **Wave T4b session 84 — Leibniz rule**.

    `pderiv i (f * g) = pderiv i f * g + f * pderiv i g`. -/
theorem T5_pderiv_mul (i : σ) (f g : MvPolynomial σ R) :
    pderiv i (f * g) = pderiv i f * g + f * pderiv i g :=
  MvPolynomial.pderiv_mul

/-! ## Power rule -/

/-- **Wave T4b session 84 — power rule**.

    `pderiv i (f^n) = n * f^(n-1) * pderiv i f`. -/
theorem T5_pderiv_pow (i : σ) (f : MvPolynomial σ R) (n : ℕ) :
    pderiv i (f ^ n) = n * f ^ (n - 1) * pderiv i f :=
  MvPolynomial.pderiv_pow

/-! ## Scalar from R -/

/-- **Wave T4b session 84 — scalar pull-out**.

    `pderiv i (C a * f) = C a * pderiv i f`. -/
theorem T5_pderiv_C_mul {a : R} (i : σ) (f : MvPolynomial σ R) :
    pderiv i (C a * f) = C a * pderiv i f :=
  MvPolynomial.pderiv_C_mul

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 84 — pderiv linearity**.

    Four foundational linearity facts:
    1. Sum: `pderiv i (f + g) = pderiv i f + pderiv i g`
    2. Leibniz: `pderiv i (f * g) = pderiv i f * g + f * pderiv i g`
    3. Power: `pderiv i (f^n) = n · f^(n-1) · pderiv i f`
    4. C-mul: `pderiv i (C a * f) = C a * pderiv i f`

    Sub-lemma 6/15 in T-5 Phase 2. Lean-core only. -/
theorem session_84_mvpoly_pderiv_linearity_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Sum
    (∀ i : σ, ∀ f g : MvPolynomial σ R,
        pderiv i (f + g) = pderiv i f + pderiv i g)
    -- (2) Mul (Leibniz)
    ∧ (∀ i : σ, ∀ f g : MvPolynomial σ R,
        pderiv i (f * g) = pderiv i f * g + f * pderiv i g)
    -- (3) Pow
    ∧ (∀ i : σ, ∀ f : MvPolynomial σ R, ∀ n : ℕ,
        pderiv i (f ^ n) = n * f ^ (n - 1) * pderiv i f)
    -- (4) C-mul
    ∧ (∀ i : σ, ∀ a : R, ∀ f : MvPolynomial σ R,
        pderiv i (C a * f) = C a * pderiv i f) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact T5_pderiv_add
  · exact T5_pderiv_mul
  · exact T5_pderiv_pow
  · intros i a f; exact T5_pderiv_C_mul i f

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivLinearity
