/-
  OmegaTheory.Irrationality.CustomMath.T5_DerivativeCharacterization

  T-5 (Roth's theorem axiom retirement) — sub-lemma 5/10 session 72.
  Derivative-based characterization of polynomial index.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Re-export of Mathlib's `Polynomial.isRoot_iterate_derivative_of_lt_rootMultiplicity`
  in T-5-attack vocabulary.

  Key lemma: `index p a > k ↔ derivative^[m] p has a as root for all m ≤ k`.

  This is the "vanishing derivatives" characterization used in Roth's
  lemma proof (multivariable polynomial vanishing at points with
  high multiplicity).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex
import Mathlib.Algebra.Polynomial.FieldDivision

namespace OmegaTheory.Irrationality.CustomMath.T5_DerivativeCharacterization

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_PolynomialIndex

/-! ## Derivative-based vanishing -/

/-- **Wave T4b session 72 — derivative-based vanishing characterization**.

    For any polynomial p over a CommRing R and any point a : R,
    if `n < indexAtPoint p a`, then all n-th derivatives of p vanish
    at a (i.e., `(derivative^[n] p).IsRoot a`).

    This is Mathlib's
    `Polynomial.isRoot_iterate_derivative_of_lt_rootMultiplicity` in
    T-5 vocabulary. -/
theorem Polynomial.isRoot_iterate_derivative_of_lt_indexAtPoint
    {R : Type*} [CommRing R] [IsDomain R]
    {p : R[X]} {a : R} {n : ℕ}
    (hn : n < Polynomial.indexAtPoint p a) :
    (derivative^[n] p).IsRoot a :=
  isRoot_iterate_derivative_of_lt_rootMultiplicity hn

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 72 — derivative characterization**.

    For any polynomial p ∈ R[X] (R commutative ring with 1, integer
    domain) and any point a ∈ R:

      `n < indexAtPoint p a → (derivative^[n] p).IsRoot a`

    Sub-lemma 5/10 in T-5 Phase 1.  Foundation for multivariable
    polynomial-index machinery in Roth's lemma. -/
theorem session_72_derivative_index_characterization_headline
    {R : Type*} [CommRing R] [IsDomain R] :
    ∀ p : R[X], ∀ a : R, ∀ n : ℕ,
      n < Polynomial.indexAtPoint p a → (derivative^[n] p).IsRoot a := by
  intros p a n hn
  exact Polynomial.isRoot_iterate_derivative_of_lt_indexAtPoint hn

end OmegaTheory.Irrationality.CustomMath.T5_DerivativeCharacterization
