/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedDegree

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 111.
  Weighted total degree basics for MvPolynomial.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Phase 3 of T-5 (Roth's theorem port) needs the polynomial-index
  calculus, which uses Mathlib's `MvPolynomial.weightedTotalDegree`.
  This file packages a few foundational re-exports + adds the
  homogeneity wrapper for constants and zero.

  Re-exports:
  1. **`T5_weightedTotalDegree_zero`** : `weightedTotalDegree w 0 = ⊥`.
  2. **`T5_isWeightedHomogeneous_C`** : a constant is w-homogeneous of
     degree 0.
  3. **`T5_isWeightedHomogeneous_X`** : `X i` is w-homogeneous of degree
     `w i`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.RingTheory.MvPolynomial.WeightedHomogeneous

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedDegree

open MvPolynomial

variable {σ R M : Type*} [CommSemiring R] [SemilatticeSup M] [OrderBot M] [AddCommMonoid M]

/-! ## weightedTotalDegree of zero -/

/-- **Wave T5 session 111 — weightedTotalDegree of zero polynomial**.

    `weightedTotalDegree w 0 = ⊥`. -/
theorem T5_weightedTotalDegree_zero (w : σ → M) :
    weightedTotalDegree (R := R) w (0 : MvPolynomial σ R) = ⊥ :=
  MvPolynomial.weightedTotalDegree_zero w

/-! ## Weighted homogeneity of generators -/

/-- **Wave T5 session 111 — `C r` is w-homogeneous of degree 0**. -/
theorem T5_isWeightedHomogeneous_C (w : σ → M) (r : R) :
    IsWeightedHomogeneous w (C r : MvPolynomial σ R) 0 :=
  MvPolynomial.isWeightedHomogeneous_C w r

/-- **Wave T5 session 111 — `0` is w-homogeneous of any degree**. -/
theorem T5_isWeightedHomogeneous_zero (w : σ → M) (m : M) :
    IsWeightedHomogeneous w (0 : MvPolynomial σ R) m :=
  MvPolynomial.isWeightedHomogeneous_zero R w m

/-- **Wave T5 session 111 — `1` is w-homogeneous of degree 0**. -/
theorem T5_isWeightedHomogeneous_one (w : σ → M) :
    IsWeightedHomogeneous w (1 : MvPolynomial σ R) 0 :=
  MvPolynomial.isWeightedHomogeneous_one R w

/-- **Wave T5 session 111 — `X i` is w-homogeneous of degree `w i`**. -/
theorem T5_isWeightedHomogeneous_X (w : σ → M) (i : σ) :
    IsWeightedHomogeneous w (X i : MvPolynomial σ R) (w i) :=
  MvPolynomial.isWeightedHomogeneous_X R w i

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 111 — Weighted-degree generator basics**.

    Five foundational facts from Mathlib's WeightedHomogeneous library:
    1. `weightedTotalDegree w 0 = ⊥`
    2. `IsWeightedHomogeneous w (C r) 0`
    3. `IsWeightedHomogeneous w 0 m` (for any m)
    4. `IsWeightedHomogeneous w 1 0`
    5. `IsWeightedHomogeneous w (X i) (w i)`

    Sub-lemma 3/N in T-5 Phase 3.  Lean-core only.

    Used to bootstrap Roth's polynomial-index calculus over weighted
    multivariate polynomial degrees. -/
theorem session_111_weighted_degree_generators_headline
    {σ R M : Type*} [CommSemiring R] [SemilatticeSup M] [OrderBot M] [AddCommMonoid M] :
    -- (1) zero
    (∀ w : σ → M, weightedTotalDegree (R := R) w (0 : MvPolynomial σ R) = ⊥)
    -- (2) C r
    ∧ (∀ (w : σ → M) (r : R), IsWeightedHomogeneous w (C r : MvPolynomial σ R) 0)
    -- (3) 0 of any m
    ∧ (∀ (w : σ → M) (m : M), IsWeightedHomogeneous w (0 : MvPolynomial σ R) m)
    -- (4) 1
    ∧ (∀ w : σ → M, IsWeightedHomogeneous w (1 : MvPolynomial σ R) 0)
    -- (5) X i
    ∧ (∀ (w : σ → M) (i : σ), IsWeightedHomogeneous w (X i : MvPolynomial σ R) (w i)) :=
  ⟨T5_weightedTotalDegree_zero,
   T5_isWeightedHomogeneous_C,
   T5_isWeightedHomogeneous_zero,
   T5_isWeightedHomogeneous_one,
   T5_isWeightedHomogeneous_X⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WeightedDegree
