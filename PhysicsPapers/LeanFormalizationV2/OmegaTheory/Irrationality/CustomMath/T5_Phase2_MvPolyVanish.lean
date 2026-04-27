/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_MvPolyVanish

  T-5 (Roth's theorem axiom retirement) — Phase 2 entry session 79.
  Multi-variable polynomial vanishing at a point.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Phase 2 entry foundations for MvPolynomial-side index computations:

  1. **`MvPolynomial.vanishesAt`** : `MvPolynomial σ R → (σ → S) → Prop`
     — predicate: P evaluated at point γ is zero (i.e., aeval γ P = 0).

  2. **`MvPolynomial.vanishesAt_iff_aeval_zero`** : characterization
     in terms of `aeval`.

  3. **`MvPolynomial.vanishesAt.add`** : closure under sum.

  4. **`MvPolynomial.vanishesAt.smul`** : closure under scalar multiple.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.Algebra.MvPolynomial.Eval

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_MvPolyVanish

open MvPolynomial

/-! ## Vanishing predicate -/

variable {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S]

/-- **Wave T4b session 79 — multivariate polynomial vanishes at point**.

    `P : MvPolynomial σ R` vanishes at point `γ : σ → S` iff
    `MvPolynomial.aeval γ P = 0`. -/
def MvPolynomial.vanishesAt (P : MvPolynomial σ R) (γ : σ → S) : Prop :=
  MvPolynomial.aeval γ P = 0

/-! ## Characterization -/

/-- Characterization. -/
theorem MvPolynomial.vanishesAt_iff_aeval_zero (P : MvPolynomial σ R) (γ : σ → S) :
    MvPolynomial.vanishesAt P γ ↔ MvPolynomial.aeval γ P = 0 := Iff.rfl

/-! ## Closure properties -/

/-- Sum closure: if P, Q both vanish at γ, then P + Q vanishes. -/
theorem MvPolynomial.vanishesAt.add {P Q : MvPolynomial σ R} {γ : σ → S}
    (hP : MvPolynomial.vanishesAt P γ) (hQ : MvPolynomial.vanishesAt Q γ) :
    MvPolynomial.vanishesAt (P + Q) γ := by
  unfold MvPolynomial.vanishesAt at *
  rw [map_add, hP, hQ]
  ring

/-- Scalar-mul closure: if P vanishes at γ, then c · P vanishes. -/
theorem MvPolynomial.vanishesAt.smul (c : R) {P : MvPolynomial σ R} {γ : σ → S}
    (hP : MvPolynomial.vanishesAt P γ) :
    MvPolynomial.vanishesAt (c • P) γ := by
  unfold MvPolynomial.vanishesAt at *
  rw [map_smul, hP, smul_zero]

/-- Multiplicative closure (RIGHT): if P vanishes at γ, then P · Q vanishes. -/
theorem MvPolynomial.vanishesAt.mul_right {P : MvPolynomial σ R} {Q : MvPolynomial σ R}
    {γ : σ → S} (hP : MvPolynomial.vanishesAt P γ) :
    MvPolynomial.vanishesAt (P * Q) γ := by
  unfold MvPolynomial.vanishesAt at *
  rw [map_mul, hP, zero_mul]

/-- Multiplicative closure (LEFT): if Q vanishes at γ, then P · Q vanishes. -/
theorem MvPolynomial.vanishesAt.mul_left {P Q : MvPolynomial σ R} {γ : σ → S}
    (hQ : MvPolynomial.vanishesAt Q γ) :
    MvPolynomial.vanishesAt (P * Q) γ := by
  unfold MvPolynomial.vanishesAt at *
  rw [map_mul, hQ, mul_zero]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 79 — MvPolynomial vanishing**.

    Phase 2 entry: definition + closure properties for vanishing
    of multi-variable polynomials at points.

    Sub-lemma 1/15 in T-5 Phase 2 (auxiliary polynomial construction).
    Lean-core only. -/
theorem session_79_mvpoly_vanish_headline
    {σ R S : Type*} [CommSemiring R] [CommSemiring S] [Algebra R S] :
    -- (1) Characterization
    (∀ P : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ ↔ MvPolynomial.aeval γ P = 0)
    -- (2) Sum closure
    ∧ (∀ P Q : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ → MvPolynomial.vanishesAt Q γ →
        MvPolynomial.vanishesAt (P + Q) γ)
    -- (3) Scalar closure
    ∧ (∀ c : R, ∀ P : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ →
        MvPolynomial.vanishesAt (c • P) γ)
    -- (4) Mul-right closure
    ∧ (∀ P Q : MvPolynomial σ R, ∀ γ : σ → S,
        MvPolynomial.vanishesAt P γ →
        MvPolynomial.vanishesAt (P * Q) γ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intros P γ; exact MvPolynomial.vanishesAt_iff_aeval_zero P γ
  · intros P Q γ hP hQ; exact MvPolynomial.vanishesAt.add hP hQ
  · intros c P γ hP; exact MvPolynomial.vanishesAt.smul c hP
  · intros P Q γ hP; exact MvPolynomial.vanishesAt.mul_right hP

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_MvPolyVanish
