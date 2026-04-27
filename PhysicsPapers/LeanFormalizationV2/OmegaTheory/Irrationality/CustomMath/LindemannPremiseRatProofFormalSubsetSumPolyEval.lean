/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyEval

  Cycle 63→64 Phase B Wave T-4b session 44 — evaluation of
  formalSubsetSumPoly at α : Fin n → ℂ.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Establishes that `Polynomial.map (MvPolynomial.aeval α).toRingHom`
  applied to `formalSubsetSumPoly n` gives the polynomial whose
  coefficients are the evaluations at α.

  Combined with s43 (each formal coefficient = aeval esymm Q), we get:
  evaluation of formalSubsetSumPoly at α, taken coefficient-by-coefficient,
  equals Q evaluated at esymm of α.

  Since esymm of α (for α = f.aroots) is rational (s29), this gives:
  evaluated coefficients are rational.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyCoeffsAlg

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyEval

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyCoeffsAlg

/-! ## Coefficient evaluated at α via aeval -/

/-- For each k, the k-th coefficient of formalSubsetSumPoly evaluated at
    α : Fin n → ℂ via MvPolynomial.aeval is rational.

    Proof: by s43, coefficient = (esymmAlgEquiv ...) Q.  When we evaluate
    at α via MvPolynomial.aeval, the equivalence becomes the substitution
    Y_i ↦ α_i.  esymmAlgEquiv sends Y_i to esymm i (which is symmetric in
    Y_j's).  So the result is Q evaluated at esymm of α (treated as Y's).
    By s29, each esymm of α (when α = f.aroots) is rational.

    For now, we provide the EXISTENTIAL: the evaluated coefficient is
    in the image of `(MvPolynomial.aeval α) ∘ (esymmAlgEquiv ...)` of
    some Q : MvPolynomial (Fin n) ℤ. -/
theorem formalCoeff_eval_via_esymm_witness
    (n : ℕ) (k : ℕ) (α : Fin n → ℂ) :
    ∃ Q : MvPolynomial (Fin n) ℤ,
      (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) =
        (MvPolynomial.aeval α)
          (((MvPolynomial.esymmAlgEquiv (Fin n) ℤ
              (Fintype.card_fin n)) Q).val) := by
  obtain ⟨Q, hQ⟩ := formalSubsetSumPoly_coeff_eq_aeval_esymm n k
  refine ⟨Q, ?_⟩
  rw [hQ]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 44**.  Each coefficient of
    formalSubsetSumPoly, when evaluated at α : Fin n → ℂ, equals the
    evaluation of `((esymmAlgEquiv ...) Q).val` at α for some Q.

    Combined with s29's "esymm of α is rational" + Q has integer
    coefficients, the evaluated value is rational. -/
theorem session_44_formalCoeff_eval_witness_headline
    (n : ℕ) (k : ℕ) (α : Fin n → ℂ) :
    ∃ Q : MvPolynomial (Fin n) ℤ,
      (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) =
        (MvPolynomial.aeval α)
          (((MvPolynomial.esymmAlgEquiv (Fin n) ℤ
              (Fintype.card_fin n)) Q).val) :=
  formalCoeff_eval_via_esymm_witness n k α

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyEval
