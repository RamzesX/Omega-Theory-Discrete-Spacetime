/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMvPolyRationalEval

  Cycle 63→64 Phase B Wave T-4b session 45 — generic rationality of
  MvPolynomial evaluation at rational-valued tuples.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Generic lemma: for any `Q : MvPolynomial (Fin n) ℤ` and any tuple
  `γ : Fin n → ℂ` where each `γ i` is rational, the evaluation
  `MvPolynomial.aeval γ Q` (treated via algebraMap ℤ → ℂ) is rational.

  Proof: induction on the structure of Q (using `MvPolynomial.induction_on`)
  + closure of ℚ-image in ℂ under +, *, and constants (Int.cast).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Algebra.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.CommRing
import Mathlib.Data.Complex.Basic
import Mathlib.Algebra.Polynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMvPolyRationalEval

open Complex

/-! ## Generic rationality of evaluation -/

/-- **Wave T4b session 45 — MvPolynomial integer evaluated at rationals**.

    For any `Q : MvPolynomial (Fin n) ℤ` and `γ : Fin n → ℂ` such that
    each `γ i` is rational (∃ q, γ i = (q : ℂ)), the evaluation is rational.

    Proof: induction on Q via `MvPolynomial.induction_on`. -/
theorem mvpoly_eval_rational_at_rational_tuple
    (n : ℕ) (γ : Fin n → ℂ) (h_γ_rat : ∀ i, ∃ q : ℚ, γ i = (q : ℂ))
    (Q : MvPolynomial (Fin n) ℤ) :
    ∃ q : ℚ, (MvPolynomial.aeval γ) Q = (q : ℂ) := by
  induction Q using MvPolynomial.induction_on with
  | C r =>
      refine ⟨(r : ℚ), ?_⟩
      rw [MvPolynomial.aeval_C]
      push_cast
      rfl
  | add p q ih_p ih_q =>
      obtain ⟨qp, hp⟩ := ih_p
      obtain ⟨qq, hq⟩ := ih_q
      refine ⟨qp + qq, ?_⟩
      rw [map_add, hp, hq]
      push_cast
      rfl
  | mul_X p i ih_p =>
      obtain ⟨qp, hp⟩ := ih_p
      obtain ⟨qi, hi⟩ := h_γ_rat i
      refine ⟨qp * qi, ?_⟩
      rw [map_mul, MvPolynomial.aeval_X, hp, hi]
      push_cast
      rfl

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 45**.  Generic rationality of MvPolynomial
    evaluation at rational-valued tuples.

    Combined with s44 (evaluation chain through esymmAlgEquiv) + s29
    (rationality of esymm of f.aroots), this gives the rationality of
    each evaluated coefficient of formalSubsetSumPoly at α = f.aroots. -/
theorem session_45_mvpoly_eval_rational_headline
    (n : ℕ) (γ : Fin n → ℂ) (h_γ_rat : ∀ i, ∃ q : ℚ, γ i = (q : ℂ))
    (Q : MvPolynomial (Fin n) ℤ) :
    ∃ q : ℚ, (MvPolynomial.aeval γ) Q = (q : ℂ) :=
  mvpoly_eval_rational_at_rational_tuple n γ h_γ_rat Q

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMvPolyRationalEval
