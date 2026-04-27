/-
  OmegaTheory.Irrationality.CustomMath.T5_LeadingCoeff

  T-5 (Roth's theorem axiom retirement) — sub-lemma 9/10 session 77.
  Leading coefficient of polynomial products.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Two re-exports for T-5 Phase 2 auxiliary polynomial construction:

  1. **`T5_leadingCoeff_mul`** — `leadingCoeff(p · q) = leadingCoeff p · leadingCoeff q`
     (in any commutative ring; sharper for domain).

  2. **`T5_monic_mul`** — product of monics is monic.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.RingDivision

namespace OmegaTheory.Irrationality.CustomMath.T5_LeadingCoeff

open Polynomial

variable {R : Type*} [CommRing R] [IsDomain R]

/-! ## Leading coefficient of product -/

/-- **Wave T4b session 77 — leadingCoeff of polynomial product**.

    For p, q ∈ R[X] (R integral domain):

      `leadingCoeff(p * q) = leadingCoeff p * leadingCoeff q`. -/
theorem T5_leadingCoeff_mul (p q : R[X]) :
    (p * q).leadingCoeff = p.leadingCoeff * q.leadingCoeff :=
  Polynomial.leadingCoeff_mul p q

/-! ## Monic preservation -/

/-- **Wave T4b session 77 — Monic.mul re-export**.

    Product of monic polynomials is monic. -/
theorem T5_monic_mul {p q : R[X]} (hp : p.Monic) (hq : q.Monic) :
    (p * q).Monic := hp.mul hq

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 77 — leadingCoeff calculus**.

    Two key facts for T-5 Phase 2:
    1. leadingCoeff multiplicativity over products.
    2. Monic product preservation.

    Sub-lemma 9/10 in T-5 Phase 1. Lean-core only. -/
theorem session_77_leadingCoeff_calculus_headline
    {R : Type*} [CommRing R] [IsDomain R] :
    -- (1) leadingCoeff multiplicativity
    (∀ p q : R[X], (p * q).leadingCoeff = p.leadingCoeff * q.leadingCoeff)
    -- (2) Monic product
    ∧ (∀ p q : R[X], p.Monic → q.Monic → (p * q).Monic) := by
  refine ⟨?_, ?_⟩
  · intros p q; exact T5_leadingCoeff_mul p q
  · intros p q hp hq; exact T5_monic_mul hp hq

end OmegaTheory.Irrationality.CustomMath.T5_LeadingCoeff
