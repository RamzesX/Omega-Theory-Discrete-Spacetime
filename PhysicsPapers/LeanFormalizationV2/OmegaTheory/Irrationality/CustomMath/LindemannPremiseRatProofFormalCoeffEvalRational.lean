/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalCoeffEvalRational

  Cycle 63→64 Phase B Wave T-4b session 46 — generic rationality of
  evaluated coefficient of formalSubsetSumPoly at α : Fin n → ℂ when
  every esymm of (univ.val.map α) is rational.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Composes the chain:
  - s43: `(formalSubsetSumPoly n).coeff k = aeval (fun i => esymm (i+1)) Q`
  - Mathlib `MvPolynomial.comp_aeval_apply`: `aeval α ∘ aeval f = aeval (aeval α ∘ f)`
  - Mathlib `MvPolynomial.aeval_esymm_eq_multiset_esymm`: `aeval α (esymm k) = (univ.val.map α).esymm k`
  - s45: `aeval at rational tuple of integer poly is rational`

  Headline: under the hypothesis that each `(univ.val.map α).esymm k` is
  rational (cast to ℂ), every `aeval α (formalSubsetSumPoly n).coeff k`
  is rational.

  Combined with s29 (`(f.aroots ℂ).esymm k` rational for nonzero `f : ℤ[X]`)
  and the choice α : Fin n → ℂ enumerating `f.aroots ℂ` (with n =
  Multiset.card (f.aroots ℂ)), this gives: every coefficient of
  `subsetSumPoly_C (f.aroots ℂ)` is rational.  This is the cycle-64
  keystone for π² ∉ ℚ closure.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyEval
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMvPolyRationalEval
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalCoeffEvalRational

open Polynomial Complex Finset
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyCoeffsAlg
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPolyEval
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMvPolyRationalEval
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational

/-! ## Composition of aeval α with esymmAlgEquiv -/

/-- **Wave T4b session 46 — composition lemma**.

    For any `α : Fin n → ℂ` and any `Q : MvPolynomial (Fin n) ℤ`:

      `aeval α (((esymmAlgEquiv ...) Q).val) =
         aeval (fun i => aeval α (esymm (Fin n) ℤ (i.val + 1))) Q`

    This is the application of Mathlib's `MvPolynomial.comp_aeval_apply`
    to the unfold of `esymmAlgEquiv` (via `esymmAlgHom_apply`). -/
theorem aeval_esymmAlgEquiv_eq_aeval_aeval_esymm
    (n : ℕ) (α : Fin n → ℂ) (Q : MvPolynomial (Fin n) ℤ) :
    (MvPolynomial.aeval α)
        (((MvPolynomial.esymmAlgEquiv (Fin n) ℤ (Fintype.card_fin n)) Q).val) =
      (MvPolynomial.aeval
          (fun i : Fin n =>
            (MvPolynomial.aeval α) (MvPolynomial.esymm (Fin n) ℤ (i.val + 1)))) Q := by
  -- Unfold esymmAlgEquiv to esymmAlgHom
  rw [MvPolynomial.esymmAlgEquiv_apply, MvPolynomial.esymmAlgHom_apply]
  -- Apply comp_aeval_apply
  rw [MvPolynomial.comp_aeval_apply]

/-! ## Composition: aeval α (esymm k) = Multiset.esymm of mapped α -/

/-- For `α : Fin n → ℂ` and `k : ℕ`, the value
    `aeval α (esymm (Fin n) ℤ k)` equals `(univ.val.map α).esymm k` in ℂ.

    This is the direct application of Mathlib's
    `MvPolynomial.aeval_esymm_eq_multiset_esymm` lemma. -/
theorem aeval_esymm_eq_multiset_esymm_apply
    (n : ℕ) (α : Fin n → ℂ) (k : ℕ) :
    (MvPolynomial.aeval α) (MvPolynomial.esymm (Fin n) ℤ k) =
      ((Finset.univ : Finset (Fin n)).val.map α).esymm k :=
  MvPolynomial.aeval_esymm_eq_multiset_esymm (σ := Fin n) (R := ℤ) k α

/-! ## Rationality of evaluated formal coefficient -/

/-- **Wave T4b session 46 — generic rationality of evaluated formal coefficient**.

    For any `α : Fin n → ℂ` such that for every `k : ℕ` the value
    `((Finset.univ : Finset (Fin n)).val.map α).esymm k` is rational,
    every `aeval α (formalSubsetSumPoly n).coeff k` is rational.

    Proof:
    1. By s43: coeff k = `((esymmAlgEquiv ...) Q).val` for some Q : ℤ-MvPolynomial.
    2. By the composition lemma: aeval α (this) = aeval (fun i => aeval α (esymm)) Q.
    3. By aeval_esymm_eq_multiset_esymm: each component is `(univ.val.map α).esymm (i+1)`.
    4. By hypothesis: each is rational.
    5. By s45 (mvpoly_eval_rational_at_rational_tuple): the result is rational. -/
theorem formalCoeff_eval_rational_of_esymm_rational
    (n : ℕ) (α : Fin n → ℂ)
    (h_rat : ∀ k : ℕ, ∃ q : ℚ,
       ((Finset.univ : Finset (Fin n)).val.map α).esymm k = (q : ℂ))
    (k : ℕ) :
    ∃ q : ℚ, (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) = (q : ℂ) := by
  -- s43: coeff k = ((esymmAlgEquiv ...) Q).val
  obtain ⟨Q, hQ⟩ := formalSubsetSumPoly_coeff_eq_aeval_esymm n k
  -- Apply aeval α
  have h_eval :
      (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) =
        (MvPolynomial.aeval α)
          (((MvPolynomial.esymmAlgEquiv (Fin n) ℤ (Fintype.card_fin n)) Q).val) := by
    rw [hQ]
  -- Use the composition lemma
  rw [h_eval, aeval_esymmAlgEquiv_eq_aeval_aeval_esymm n α Q]
  -- Now we need: ∃ q, aeval (fun i => aeval α (esymm (i+1))) Q = (q : ℂ)
  -- Show each component is rational, then apply s45
  have h_γ_rat : ∀ i : Fin n, ∃ q : ℚ,
      (MvPolynomial.aeval α) (MvPolynomial.esymm (Fin n) ℤ (i.val + 1)) = (q : ℂ) := by
    intro i
    rw [aeval_esymm_eq_multiset_esymm_apply n α (i.val + 1)]
    exact h_rat (i.val + 1)
  -- Apply s45
  exact mvpoly_eval_rational_at_rational_tuple n
    (fun i : Fin n =>
      (MvPolynomial.aeval α) (MvPolynomial.esymm (Fin n) ℤ (i.val + 1))) h_γ_rat Q

/-! ## Specialization to f.aroots ℂ -/

/-- **Wave T4b session 46 — specialization to α = enumeration of f.aroots ℂ**.

    For any nonzero `f : Polynomial ℤ` and any `α : Fin n → ℂ` such that
    `(univ.val.map α : Multiset ℂ) = f.aroots ℂ` and `n = Multiset.card (f.aroots ℂ)`,
    every `aeval α (formalSubsetSumPoly n).coeff k` is rational.

    Proof: combines s29 (esymm of f.aroots is rational) with the generic
    lemma above (just substituting the equality of multisets). -/
theorem formalCoeff_eval_rational_at_aroots
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (k : ℕ) :
    ∃ q : ℚ, (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) = (q : ℂ) := by
  apply formalCoeff_eval_rational_of_esymm_rational n α
  intro j
  -- (univ.val.map α).esymm j = (f.aroots ℂ).esymm j (rewrite by h_α)
  rw [h_α]
  exact aroots_esymm_is_rational f h_ne j

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 46**.  Every coefficient of
    `formalSubsetSumPoly`, when evaluated at α : Fin n → ℂ enumerating
    `f.aroots ℂ` for any nonzero `f : ℤ[X]`, is rational.

    This is the cycle 64 keystone for π² ∉ ℚ closure: gives that the
    polynomial `subsetSumPoly_C (f.aroots ℂ)` (assembled from these
    rational coefficients) descends to ℚ[X], and hence (after
    `IsLocalization.integerNormalization`) to ℤ[X]. -/
theorem session_46_formalCoeff_eval_rational_at_aroots_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0)
    (n : ℕ) (α : Fin n → ℂ)
    (h_α : ((Finset.univ : Finset (Fin n)).val.map α) = f.aroots ℂ)
    (k : ℕ) :
    ∃ q : ℚ, (MvPolynomial.aeval α) ((formalSubsetSumPoly n).coeff k) = (q : ℂ) :=
  formalCoeff_eval_rational_at_aroots f h_ne n α h_α k

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalCoeffEvalRational
