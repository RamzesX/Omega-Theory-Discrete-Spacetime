/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivMap

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 9/15 session 87.
  pderiv commutes with map (ring-hom transport).

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-export of Mathlib's `MvPolynomial.pderiv_map` for use in T-5
  multi-variable index machinery:

      `pderiv i (map φ f) = map φ (pderiv i f)`

  This means computing partial derivatives commutes with applying a
  ring homomorphism to the coefficients — useful for transporting
  derivative bounds between coefficient rings (ℤ → ℚ → ℝ → ℂ).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivMap

open MvPolynomial

variable {σ R S : Type*} [CommSemiring R] [CommSemiring S]

/-! ## pderiv commutes with map -/

/-- **Wave T4b session 87 — pderiv commutes with `map`**.

    For any ring hom `φ : R →+* S` and any `f : MvPolynomial σ R`:

      `pderiv i (map φ f) = map φ (pderiv i f)`. -/
theorem T5_pderiv_map {φ : R →+* S} {f : MvPolynomial σ R} {i : σ} :
    pderiv i (map φ f) = map φ (pderiv i f) :=
  MvPolynomial.pderiv_map

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 87 — pderiv-map commutativity**.

    Composition: `pderiv i ∘ map φ = map φ ∘ pderiv i`.

    Useful for ℤ → ℚ → ℝ → ℂ coefficient-ring transport in T-5
    multi-variable index machinery.

    Sub-lemma 9/15 in T-5 Phase 2. Lean-core only. -/
theorem session_87_pderiv_map_headline
    {σ R S : Type*} [CommSemiring R] [CommSemiring S] :
    ∀ (φ : R →+* S) (f : MvPolynomial σ R) (i : σ),
      pderiv i (map φ f) = map φ (pderiv i f) := by
  intros φ f i
  exact T5_pderiv_map

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivMap
