/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyCoeffsAlg

  Cycle 63→64 Phase B Wave T-4b session 43 — coefficients of
  formalSubsetSumPoly are in the symmetric subalgebra, hence by
  esymmAlgEquiv expressible as polynomial in elementary symmetrics.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Combines s42 (each coeff is symmetric) with `MvPolynomial.esymmAlgEquiv`
  to produce the existence statement:

      `∃ Q : MvPolynomial (Fin n) ℤ, formalSubsetSumPoly.coeff k =
         ((esymmAlgEquiv ...) Q).val`

  This is the cycle 64 keystone: each coefficient is the image of some
  Q via the isomorphism that sends Y_i ↦ esymm i.  When Q is evaluated at
  esymm of f.aroots ℂ (rational by s29), the result is rational.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolySymmetric
import Mathlib.RingTheory.MvPolynomial.Symmetric.FundamentalTheorem

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyCoeffsAlg

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolySymmetric

/-! ## Coefficient is in symmetric subalgebra -/

/-- Each coefficient of formalSubsetSumPoly is in the symmetric subalgebra. -/
theorem formalSubsetSumPoly_coeff_mem_symmetricSubalgebra
    (n : ℕ) (k : ℕ) :
    (formalSubsetSumPoly n).coeff k ∈
      MvPolynomial.symmetricSubalgebra (Fin n) ℤ :=
  (MvPolynomial.mem_symmetricSubalgebra _).mpr
    (formalSubsetSumPoly_coeff_isSymmetric n k)

/-! ## Existence of Q : Fundamental theorem of symmetric polynomials -/

/-- **Wave T4b session 43 — coefficients expressible in elementary symmetrics**.

    Each coefficient of formalSubsetSumPoly is the image of some
    `Q : MvPolynomial (Fin n) ℤ` under the algebra equivalence that sends
    Y_i to the i-th elementary symmetric polynomial. -/
theorem formalSubsetSumPoly_coeff_eq_aeval_esymm
    (n : ℕ) (k : ℕ) :
    ∃ Q : MvPolynomial (Fin n) ℤ,
      (formalSubsetSumPoly n).coeff k =
        ((MvPolynomial.esymmAlgEquiv (Fin n) ℤ (Fintype.card_fin n)) Q).val := by
  refine ⟨(MvPolynomial.esymmAlgEquiv (Fin n) ℤ (Fintype.card_fin n)).symm
            ⟨(formalSubsetSumPoly n).coeff k,
              formalSubsetSumPoly_coeff_mem_symmetricSubalgebra n k⟩, ?_⟩
  rw [AlgEquiv.apply_symm_apply]

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 43**.  Each coefficient of
    formalSubsetSumPoly is expressible via the fundamental theorem of
    symmetric polynomials: as the image of some Q : MvPolynomial (Fin n) ℤ
    under the esymmAlgEquiv (which sends Y_i to esymm i).

    This is the cycle 64 keystone — combined with rationality of esymm of
    f.aroots ℂ (s29), specializing Y_i to α_i gives rational coefficient
    values. -/
theorem session_43_formalSubsetSumPoly_coeffs_alg_headline
    (n : ℕ) (k : ℕ) :
    (formalSubsetSumPoly n).coeff k ∈
      MvPolynomial.symmetricSubalgebra (Fin n) ℤ ∧
    ∃ Q : MvPolynomial (Fin n) ℤ,
      (formalSubsetSumPoly n).coeff k =
        ((MvPolynomial.esymmAlgEquiv (Fin n) ℤ (Fintype.card_fin n)) Q).val := by
  refine ⟨?_, ?_⟩
  · exact formalSubsetSumPoly_coeff_mem_symmetricSubalgebra n k
  · exact formalSubsetSumPoly_coeff_eq_aeval_esymm n k

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyCoeffsAlg
