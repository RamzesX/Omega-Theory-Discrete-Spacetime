/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_MultiPDerivAdd

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 123.
  Multi-index iterated `pderiv` is additive.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Foundational additivity for the multi-pderiv operator:

      `l.foldr (fun k q => (pderiv k)^[j k] q) (p + q) = ... p + ... q`

  Used in T-5 polynomial-index calculus where decomposing a polynomial
  into monomials + applying multi-pderiv requires linearity.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_MultiPDerivAdd

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Iterated single-variable pderiv additivity -/

/-- **Wave T5 session 123 — `(pderiv k)^[m]` is additive**.

    `(pderiv k)^[m] (p + q) = (pderiv k)^[m] p + (pderiv k)^[m] q`. -/
theorem T5_pderiv_iterate_add (k : σ) (m : ℕ) (p q : MvPolynomial σ R) :
    ((pderiv k)^[m] (p + q)) = ((pderiv k)^[m] p) + ((pderiv k)^[m] q) := by
  induction m generalizing p q with
  | zero => simp
  | succ n ih =>
    rw [Function.iterate_succ_apply, map_add, ih,
        ← Function.iterate_succ_apply, ← Function.iterate_succ_apply]

/-- **Wave T5 session 123 — multi-pderiv via foldr is additive**.

    `l.foldr (fun k q => (pderiv k)^[j k] q) (p + q) =
       l.foldr ... p + l.foldr ... q`. -/
theorem T5_multiIteratedPDeriv_add (j : σ → ℕ) (l : List σ)
    (p q : MvPolynomial σ R) :
    l.foldr (fun k q => (pderiv k)^[j k] q) (p + q) =
      l.foldr (fun k q => (pderiv k)^[j k] q) p +
      l.foldr (fun k q => (pderiv k)^[j k] q) q := by
  induction l with
  | nil => simp
  | cons k l ih =>
    rw [List.foldr_cons, List.foldr_cons, List.foldr_cons, ih,
        T5_pderiv_iterate_add]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 123 — multi-pderiv additivity**.

    Two formulations of additivity:
    1. Single-variable iterated pderiv `(pderiv k)^[m]` is additive.
    2. Multi-index iterated pderiv (List foldr) is additive.

    Sub-lemma 12/N in T-5 Phase 3.  Lean-core only.

    Used in Roth's polynomial-index calculus where polynomial
    decomposition into monomials + linearity of multi-pderiv allows
    monomial-by-monomial reasoning. -/
theorem session_123_multi_pderiv_additive_headline
    {σ R : Type*} [CommSemiring R] :
    -- (1) Single-variable iterate
    (∀ (k : σ) (m : ℕ) (p q : MvPolynomial σ R),
        ((pderiv k)^[m] (p + q)) =
          ((pderiv k)^[m] p) + ((pderiv k)^[m] q))
    -- (2) Multi-index foldr
    ∧ (∀ (j : σ → ℕ) (l : List σ) (p q : MvPolynomial σ R),
        l.foldr (fun k q => (pderiv k)^[j k] q) (p + q) =
          l.foldr (fun k q => (pderiv k)^[j k] q) p +
          l.foldr (fun k q => (pderiv k)^[j k] q) q) :=
  ⟨T5_pderiv_iterate_add, T5_multiIteratedPDeriv_add⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_MultiPDerivAdd
