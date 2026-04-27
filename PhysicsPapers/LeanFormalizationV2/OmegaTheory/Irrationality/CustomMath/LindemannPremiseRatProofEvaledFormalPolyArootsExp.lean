/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyArootsExp

  Cycle 63→64 Phase B Wave T-4b session 54 — aroots of evaledFormalPoly +
  exp-sum identity.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Two key results:

  1. **aroots equality**:
     `evaledFormalPoly.aroots ℂ = Finset.univ.powerset.val.map σ_S`
     where σ_S = ∑ i ∈ S, α i.

     Proof: evaledFormalPoly is a Multiset.prod of (X - C σ_S), so
     `roots_multiset_prod_X_sub_C` directly gives this.

  2. **exp-sum identity**: under iπ ∈ univ.val.map α,
     `((evaledFormalPoly.aroots ℂ).map exp).sum = 0`.

     Proof: aroots = Multiset of σ_S (by 1), and ∑_{S} exp σ_S = 0 (by s53).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFinsetOrbitSum

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyArootsExp

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFormalSubsetSumPoly
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyRoots
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofFinsetOrbitSum

/-! ## evaledFormalPoly as multisetProd of (X - C σ_S) -/

/-- evaledFormalPoly equals the multiset product of `(X - C σ_S)` over
    all subsets `S : Finset (Fin n)`. -/
theorem evaledFormalPoly_eq_multisetProd (n : ℕ) (α : Fin n → ℂ) :
    (formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom =
      ((Finset.univ : Finset (Fin n)).powerset.val.map
        (fun S : Finset (Fin n) => Polynomial.X - Polynomial.C (∑ i ∈ S, α i))).prod := by
  -- Unfold formalSubsetSumPoly
  unfold formalSubsetSumPoly
  rw [Polynomial.map_prod]
  -- Goal: ∏ S ∈ univ.powerset, (X - C (∑ i ∈ S, α i)) = (univ.powerset.val.map ...).prod
  rw [Finset.prod_eq_multiset_prod]
  -- Goal: (univ.powerset.val.map ...).prod = (univ.powerset.val.map (fun S => X - C ...)).prod
  congr 1
  apply Multiset.map_congr rfl
  intros S _
  -- Goal: (map (aeval α) (X - C (∑ i ∈ S, MvPolynomial.X i))) = X - C (∑ i ∈ S, α i)
  rw [Polynomial.map_sub, Polynomial.map_X, Polynomial.map_C]
  congr 2
  rw [map_sum]
  apply Finset.sum_congr rfl
  intros i _
  exact MvPolynomial.aeval_X _ i

/-! ## aroots of evaledFormalPoly -/

/-- The aroots of evaledFormalPoly in ℂ equal the multiset of subset-sums
    over Finset.univ.powerset. -/
theorem aroots_evaledFormalPoly (n : ℕ) (α : Fin n → ℂ) :
    ((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).aroots ℂ =
      (Finset.univ : Finset (Fin n)).powerset.val.map
        (fun S : Finset (Fin n) => ∑ i ∈ S, α i) := by
  rw [evaledFormalPoly_eq_multisetProd n α]
  -- Goal: ((Finset.univ.powerset.val.map (X - C σ)).prod).aroots ℂ = ...
  -- For ℂ-coeff poly, aroots ℂ = roots
  have h_aroots_eq_roots : ∀ (q : Polynomial ℂ), q.aroots ℂ = q.roots := by
    intro q
    rw [Polynomial.aroots_def]
    congr 1
    exact Polynomial.map_id
  rw [h_aroots_eq_roots]
  -- Use roots_multiset_prod_X_sub_C
  -- We need to convert (univ.powerset.val.map (fun S => X - C σ_S)).prod into
  -- (...|>.map (X - C ·)).prod form
  rw [show (((Finset.univ : Finset (Fin n)).powerset.val.map
              (fun S : Finset (Fin n) => Polynomial.X - Polynomial.C (∑ i ∈ S, α i))).prod) =
        (((Finset.univ : Finset (Fin n)).powerset.val.map
              (fun S : Finset (Fin n) => ∑ i ∈ S, α i)).map
            (fun a : ℂ => Polynomial.X - Polynomial.C a)).prod from ?_]
  · exact Polynomial.roots_multiset_prod_X_sub_C _
  · rw [Multiset.map_map]
    rfl

/-! ## exp-sum of evaledFormalPoly aroots = 0 -/

/-- **Wave T4b session 54 — exp-sum of evaledFormalPoly aroots is 0**.

    For `α : Fin n → ℂ` such that `iπ ∈ univ.val.map α`,
    `((evaledFormalPoly.aroots ℂ).map exp).sum = 0`. -/
theorem aroots_evaledFormalPoly_exp_sum_eq_zero
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α) :
    ((((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).aroots ℂ).map
      Complex.exp).sum = 0 := by
  rw [aroots_evaledFormalPoly]
  -- Goal: ((Finset.univ.powerset.val.map σ_S).map exp).sum = 0
  rw [Multiset.map_map]
  -- Goal: (univ.powerset.val.map (cexp ∘ fun S => σ_S)).sum = 0
  -- Convert Function.comp
  simp only [Function.comp]
  -- Goal: (univ.powerset.val.map (fun S => cexp σ_S)).sum = 0
  -- Convert Multiset.sum to Finset.sum
  rw [show ((Finset.univ : Finset (Fin n)).powerset.val.map
            (fun S : Finset (Fin n) => Complex.exp (∑ i ∈ S, α i))).sum =
        ∑ S ∈ (Finset.univ : Finset (Fin n)).powerset,
          Complex.exp (∑ i ∈ S, α i) from rfl]
  exact finset_orbit_sum_eq_zero n α h_iPi_mem

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 54**.

    1. evaledFormalPoly.aroots ℂ = Multiset of subset-sums.
    2. exp-sum of these aroots = 0 (when iπ ∈ univ.val.map α).

    This is the cycle 64+ entry into the bridge discharge: the integer
    polynomial p_ℤ from s50 has the same exp-sum-of-aroots up to scalar,
    and after dividing out the X^m factor (zero subset-sums), we get
    an integer polynomial h_ℤ with ((h_ℤ.aroots).map exp).sum = -m. -/
theorem session_54_evaledFormalPoly_aroots_exp_headline
    (n : ℕ) (α : Fin n → ℂ)
    (h_iPi_mem : Complex.I * (Real.pi : ℂ) ∈ (Finset.univ : Finset (Fin n)).val.map α) :
    ((((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).aroots ℂ) =
      (Finset.univ : Finset (Fin n)).powerset.val.map
        (fun S : Finset (Fin n) => ∑ i ∈ S, α i)) ∧
    ((((formalSubsetSumPoly n).map (MvPolynomial.aeval α).toRingHom).aroots ℂ).map
      Complex.exp).sum = 0 := by
  refine ⟨?_, ?_⟩
  · exact aroots_evaledFormalPoly n α
  · exact aroots_evaledFormalPoly_exp_sum_eq_zero n α h_iPi_mem

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofEvaledFormalPolyArootsExp
