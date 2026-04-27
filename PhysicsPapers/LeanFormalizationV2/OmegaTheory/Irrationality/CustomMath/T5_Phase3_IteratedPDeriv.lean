/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_IteratedPDeriv

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 121.
  Multi-index iterated `pderiv` over a List.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Definition + foundational identity for the List-foldr of iterated
  partial derivatives:

      `l.foldr (fun k q => (pderiv k)^[j k] q) p`

  applied to a polynomial `p : MvPolynomial σ R`.  This is the operator
  central to Roth's polynomial-index calculus — the index is the inf
  over multi-indices `j : σ → ℕ` where the multi-pderiv doesn't vanish
  at the target point.

  Note: `Finset.fold` over `· ∘ ·` requires `Std.Commutative` which
  function composition lacks in general.  Using `List.foldr` is
  equivalent (since pderivs do commute by Schwarz, s110, but the
  elaborator doesn't see that automatically).

  Main result:
  **`T5_multiIteratedPDeriv_zero`** : applied to `0 : MvPolynomial σ R`,
  the iterate is `0` regardless of multi-index or list.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_IteratedPDeriv

open MvPolynomial

variable {σ R : Type*} [CommSemiring R]

/-! ## Multi-index iterated pderiv preserves zero -/

/-- **Wave T5 session 121 — multi-pderiv on zero polynomial**.

    `l.foldr (fun k q => (pderiv k)^[j k] q) (0 : MvPolynomial σ R) = 0`.

    For any list `l : List σ` and multi-index `j : σ → ℕ`, applying
    the right-fold of iterated partial derivatives to the zero
    polynomial yields zero. -/
theorem T5_multiIteratedPDeriv_zero (j : σ → ℕ) (l : List σ) :
    l.foldr (fun k q => (pderiv k)^[j k] q) (0 : MvPolynomial σ R) = 0 := by
  induction l with
  | nil => simp
  | cons k l ih =>
    rw [List.foldr_cons, ih]
    -- Goal: (pderiv k)^[j k] 0 = 0
    induction j k with
    | zero => simp
    | succ m ih2 =>
      rw [Function.iterate_succ_apply', ih2]
      exact map_zero _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 121 — multi-pderiv preserves zero**.

    For any list `l : List σ` and multi-index `j : σ → ℕ`, the iterated
    partial derivative right-fold applied to the zero polynomial is
    zero.

    Sub-lemma 11/N in T-5 Phase 3.  Lean-core only.

    Foundational for Roth's polynomial-index calculus.  The "index of
    P at α with weights d" is `inf {⟨j, 1/d⟩ : multi-pderiv P ≠ 0 at α}`. -/
theorem session_121_multi_iterated_pderiv_zero_headline
    {σ R : Type*} [CommSemiring R] :
    ∀ (j : σ → ℕ) (l : List σ),
        l.foldr (fun k q => (pderiv k)^[j k] q) (0 : MvPolynomial σ R) = 0 :=
  T5_multiIteratedPDeriv_zero

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_IteratedPDeriv
