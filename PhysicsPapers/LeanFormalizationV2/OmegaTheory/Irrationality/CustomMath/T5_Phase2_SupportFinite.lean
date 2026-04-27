/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase2_SupportFinite

  T-5 (Roth's theorem axiom retirement) — Phase 2 sub 12/15 session 90.
  MvPolynomial support finiteness.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  The fundamental observation: every MvPolynomial has finite support
  (by definition of `Finsupp`).

  This is foundational for Siegel's lemma (auxiliary polynomial
  construction) — we need to enumerate the FINITELY MANY monomials
  with bounded total degree as basis vectors for the polynomial space.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase2_SupportFinite

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Finite support -/

/-- **Wave T4b session 90 — MvPolynomial support is finite Finset**.

    MvPolynomial = Finsupp from monomial-tuples to coefficients,
    so every MvPolynomial's support is automatically a finite Finset.
    The lemma re-states this for emphasis. -/
theorem T5_mvpoly_support_finite (p : MvPolynomial σ R) :
    p.support.toSet.Finite := p.support.finite_toSet

/-- **Wave T4b session 90 — coeff at non-support point is zero**.

    `p.coeff m = 0 ↔ m ∉ p.support`. -/
theorem T5_mvpoly_notMem_support_iff (p : MvPolynomial σ R) (m : σ →₀ ℕ) :
    m ∉ p.support ↔ p.coeff m = 0 :=
  MvPolynomial.notMem_support_iff

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 90 — MvPolynomial support finiteness**.

    Two key facts:
    1. Every MvPolynomial has finite support.
    2. Coefficient is zero iff monomial-tuple not in support.

    Foundation for Siegel's lemma (Phase 2-3 of T-5).

    Sub-lemma 12/15 in T-5 Phase 2. Lean-core only. -/
theorem session_90_mvpoly_support_finite_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Support is always finite
    (∀ p : MvPolynomial σ R, p.support.toSet.Finite)
    -- (2) Coeff zero iff not in support
    ∧ (∀ p : MvPolynomial σ R, ∀ m : σ →₀ ℕ,
        m ∉ p.support ↔ p.coeff m = 0) := by
  refine ⟨?_, ?_⟩
  · exact T5_mvpoly_support_finite
  · exact T5_mvpoly_notMem_support_iff

end OmegaTheory.Irrationality.CustomMath.T5_Phase2_SupportFinite
