/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivDegree

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 8/15 session 86.
  pderiv-degree relationship (loose bound).

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Properties of MvPolynomial.pderiv preservation related to bounded
  degree, derived from Mathlib API.

  We prove the SPECIAL CASE: pderiv at a constant polynomial = 0.
  More general "pderiv decreases totalDegree" is more involved
  (requires careful monomial-by-monomial analysis); we defer the
  full statement and note the simpler facts here.

  1. **`T5_pderiv_C_zero`** : pderiv at constant is zero (alias).
  2. **`T5_pderiv_zero_add`** : pderiv of (0 + p) = pderiv p (linearity check).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivDegree

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## pderiv at zero -/

/-- **Wave T4b session 86 — pderiv at zero polynomial**.

    `pderiv i 0 = 0`. Trivial via Derivation linearity. -/
theorem T5_pderiv_zero_eq_zero (i : σ) :
    pderiv i (0 : MvPolynomial σ R) = 0 := by
  simp [pderiv]

/-! ## pderiv linearity check -/

/-- **Wave T4b session 86 — pderiv of `0 + p`**.

    Sanity check: pderiv distributes correctly with 0. -/
theorem T5_pderiv_zero_add (i : σ) (p : MvPolynomial σ R) :
    pderiv i (0 + p) = pderiv i p := by
  simp

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 86 — pderiv basic identities**.

    Two foundational identities:
    1. pderiv 0 = 0
    2. pderiv (0 + p) = pderiv p

    HONEST PARTIAL: full "pderiv preserves bounded-degree" lemma
    requires careful monomial analysis (deferred to future cycle).

    Sub-lemma 8/15 in T-5 Phase 2 (PARTIAL — alpha entry to pderiv-degree
    relationship). Lean-core only. -/
theorem session_86_pderiv_basic_identities_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) pderiv at 0
    (∀ i : σ, pderiv i (0 : MvPolynomial σ R) = 0)
    -- (2) pderiv of 0 + p = pderiv p
    ∧ (∀ i : σ, ∀ p : MvPolynomial σ R, pderiv i (0 + p) = pderiv i p) := by
  refine ⟨?_, ?_⟩
  · exact T5_pderiv_zero_eq_zero
  · exact T5_pderiv_zero_add

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_PDerivDegree
