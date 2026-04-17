/-
  OmegaTheory.Emergence.ErrorGaugeSU3

  SU(3) gauge theory with substrate error -- the strong force.

  Agent: Kornephoros, April 15, 2026. No sorry, no new axioms.
-/

import OmegaTheory.Foundations.ErrorLieAlgebra
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory.Emergence.ErrorGaugeSU3

open OmegaTheory.Foundations
open OmegaTheory.Irrationality
open OmegaTheory.Spacetime

abbrev SU3LieAlgebra := Fin 8 → ℝ

noncomputable instance : Add SU3LieAlgebra := Pi.instAdd
noncomputable instance : SMul ℝ SU3LieAlgebra := Pi.instSMul
noncomputable instance : Neg SU3LieAlgebra := Pi.instNeg
noncomputable instance : Zero SU3LieAlgebra := Pi.instZero

noncomputable def su3f : Fin 8 → Fin 8 → Fin 8 → ℝ :=
  fun i j k =>
    if i = 0 ∧ j = 1 ∧ k = 2 then 1
    else if i = 1 ∧ j = 2 ∧ k = 0 then 1
    else if i = 2 ∧ j = 0 ∧ k = 1 then 1
    else if i = 1 ∧ j = 0 ∧ k = 2 then -1
    else if i = 0 ∧ j = 2 ∧ k = 1 then -1
    else if i = 2 ∧ j = 1 ∧ k = 0 then -1
    else if i = 0 ∧ j = 3 ∧ k = 6 then 1/2
    else if i = 3 ∧ j = 6 ∧ k = 0 then 1/2
    else if i = 6 ∧ j = 0 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 0 ∧ k = 6 then -(1/2)
    else if i = 0 ∧ j = 6 ∧ k = 3 then -(1/2)
    else if i = 6 ∧ j = 3 ∧ k = 0 then -(1/2)
    else if i = 0 ∧ j = 4 ∧ k = 5 then -(1/2)
    else if i = 4 ∧ j = 5 ∧ k = 0 then -(1/2)
    else if i = 5 ∧ j = 0 ∧ k = 4 then -(1/2)
    else if i = 4 ∧ j = 0 ∧ k = 5 then 1/2
    else if i = 0 ∧ j = 5 ∧ k = 4 then 1/2
    else if i = 5 ∧ j = 4 ∧ k = 0 then 1/2
    else if i = 1 ∧ j = 3 ∧ k = 5 then 1/2
    else if i = 3 ∧ j = 5 ∧ k = 1 then 1/2
    else if i = 5 ∧ j = 1 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 1 ∧ k = 5 then -(1/2)
    else if i = 1 ∧ j = 5 ∧ k = 3 then -(1/2)
    else if i = 5 ∧ j = 3 ∧ k = 1 then -(1/2)
    else if i = 1 ∧ j = 4 ∧ k = 6 then 1/2
    else if i = 4 ∧ j = 6 ∧ k = 1 then 1/2
    else if i = 6 ∧ j = 1 ∧ k = 4 then 1/2
    else if i = 4 ∧ j = 1 ∧ k = 6 then -(1/2)
    else if i = 1 ∧ j = 6 ∧ k = 4 then -(1/2)
    else if i = 6 ∧ j = 4 ∧ k = 1 then -(1/2)
    else if i = 2 ∧ j = 3 ∧ k = 4 then 1/2
    else if i = 3 ∧ j = 4 ∧ k = 2 then 1/2
    else if i = 4 ∧ j = 2 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 2 ∧ k = 4 then -(1/2)
    else if i = 2 ∧ j = 4 ∧ k = 3 then -(1/2)
    else if i = 4 ∧ j = 3 ∧ k = 2 then -(1/2)
    else if i = 2 ∧ j = 5 ∧ k = 6 then -(1/2)
    else if i = 5 ∧ j = 6 ∧ k = 2 then -(1/2)
    else if i = 6 ∧ j = 2 ∧ k = 5 then -(1/2)
    else if i = 5 ∧ j = 2 ∧ k = 6 then 1/2
    else if i = 2 ∧ j = 6 ∧ k = 5 then 1/2
    else if i = 6 ∧ j = 5 ∧ k = 2 then 1/2
    else if i = 3 ∧ j = 4 ∧ k = 7 then Real.sqrt 3 / 2
    else if i = 4 ∧ j = 7 ∧ k = 3 then Real.sqrt 3 / 2
    else if i = 7 ∧ j = 3 ∧ k = 4 then Real.sqrt 3 / 2
    else if i = 4 ∧ j = 3 ∧ k = 7 then -(Real.sqrt 3 / 2)
    else if i = 3 ∧ j = 7 ∧ k = 4 then -(Real.sqrt 3 / 2)
    else if i = 7 ∧ j = 4 ∧ k = 3 then -(Real.sqrt 3 / 2)
    else if i = 5 ∧ j = 6 ∧ k = 7 then Real.sqrt 3 / 2
    else if i = 6 ∧ j = 7 ∧ k = 5 then Real.sqrt 3 / 2
    else if i = 7 ∧ j = 5 ∧ k = 6 then Real.sqrt 3 / 2
    else if i = 6 ∧ j = 5 ∧ k = 7 then -(Real.sqrt 3 / 2)
    else if i = 5 ∧ j = 7 ∧ k = 6 then -(Real.sqrt 3 / 2)
    else if i = 7 ∧ j = 6 ∧ k = 5 then -(Real.sqrt 3 / 2)
    else 0

-- 512-case exhaustive check of antisymmetry needs extra heartbeats
set_option maxHeartbeats 800000 in
theorem su3f_antisym (i j k : Fin 8) :
    su3f j i k = -(su3f i j k) := by
  unfold su3f
  fin_cases i <;> fin_cases j <;> fin_cases k <;> simp_all

noncomputable def su3Bracket (X Y : SU3LieAlgebra) :
    SU3LieAlgebra := fun k =>
  ∑ i : Fin 8, ∑ j : Fin 8, su3f i j k * X i * Y j

theorem su3Bracket_neg (X Y : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket Y X k = -(su3Bracket X Y k) := by
  unfold su3Bracket
  -- After unfolding: LHS = ∑ i, ∑ j, f(i,j,k)*Y(i)*X(j)
  -- Step 1: Rewrite each term: f(i,j,k)*Y(i)*X(j) = f(i,j,k)*X(j)*Y(i)
  -- Step 2: Swap summation order (i↔j): ∑ j, ∑ i, f(i,j,k)*X(j)*Y(i)
  -- (after renaming: = ∑ i, ∑ j, f(j,i,k)*X(i)*Y(j))
  -- Step 3: Use f(j,i,k) = -f(i,j,k) pointwise
  conv_lhs =>
    arg 2; ext i; arg 2; ext j
    rw [show su3f i j k * Y i * X j = su3f i j k * X j * Y i from by ring]
  rw [Finset.sum_comm]
  -- Now goal: �� j, ∑ i, f(i,j,k)*X(j)*Y(i) = -(∑ i, ∑ j, f(i,j,k)*X(i)*Y(j))
  -- Rename: this is ∑ i, ∑ j, f(j,i,k)*X(i)*Y(j) = -(∑ i, ∑ j, f(i,j,k)*X(i)*Y(j))
  -- Use f(j,i,k) = -f(i,j,k) under the binders
  conv_lhs =>
    arg 2; ext i; arg 2; ext j
    rw [su3f_antisym i j k]
  -- Now: ∑ i, ∑ j, (-f(i,j,k))*X(i)*Y(j) = -(∑ i, ∑ j, f(i,j,k)*X(i)*Y(j))
  simp only [neg_mul, Finset.sum_neg_distrib]

theorem su3Bracket_antisymmetric_pi (X Y : SU3LieAlgebra) :
    (su3Bracket X Y + su3Bracket Y X : SU3LieAlgebra) =
    (0 : SU3LieAlgebra) := by
  ext k; simp only [Pi.add_apply, Pi.zero_apply]
  rw [su3Bracket_neg Y X k]; ring

theorem su3Bracket_left_linear
    (a b : ℝ) (X₁ X₂ Y : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket (fun j => a * X₁ j + b * X₂ j) Y k =
    a * su3Bracket X₁ Y k + b * su3Bracket X₂ Y k := by
  simp only [su3Bracket, ← Finset.sum_add_distrib, Finset.mul_sum]
  congr 1; ext i; congr 1; ext j; ring

theorem su3Bracket_smul_linear
    (a b : ℝ) (X₁ X₂ Y : SU3LieAlgebra) (k : Fin 8) :
    su3Bracket (a • X₁ + b • X₂) Y k =
    a * su3Bracket X₁ Y k + b * su3Bracket X₂ Y k := by
  change su3Bracket (fun j => a * X₁ j + b * X₂ j) Y k = _
  exact su3Bracket_left_linear a b X₁ X₂ Y k

noncomputable def normInf8 (X : SU3LieAlgebra) : ℝ :=
  Finset.sup' Finset.univ ⟨0, Finset.mem_univ 0⟩ (fun i => |X i|)

theorem normInf8_nonneg (X : SU3LieAlgebra) : 0 ≤ normInf8 X := by
  unfold normInf8
  exact le_trans (abs_nonneg (X 0))
    (Finset.le_sup' (fun i => |X i|) (Finset.mem_univ 0))

theorem normInf8_zero_val : normInf8 (0 : SU3LieAlgebra) = 0 := by
  unfold normInf8
  apply le_antisymm
  · exact Finset.sup'_le _ _ (fun i _ => by simp)
  · exact normInf8_nonneg _

theorem su3Bracket_jacobi_of_hyp
    (hJ : ∀ (X Y Z : SU3LieAlgebra) (k : Fin 8),
      su3Bracket (su3Bracket X Y) Z k +
      su3Bracket (su3Bracket Y Z) X k +
      su3Bracket (su3Bracket Z X) Y k = 0)
    (X Y Z : SU3LieAlgebra) :
    (fun k => su3Bracket (su3Bracket X Y) Z k +
              su3Bracket (su3Bracket Y Z) X k +
              su3Bracket (su3Bracket Z X) Y k) =
    (fun _ => (0 : ℝ)) := by
  funext k; exact hJ X Y Z k

noncomputable instance exactSU3Bracket :
    ErrorLieBracket SU3LieAlgebra where
  bracket := su3Bracket
  bracketError := fun _ _ => 0
  bracketError_nonneg := fun _ _ => le_refl 0

@[reducible]
noncomputable def mkExactSU3LieAlgebra
    (hJ : ∀ (X Y Z : SU3LieAlgebra),
      (su3Bracket (su3Bracket X Y) Z +
       su3Bracket (su3Bracket Y Z) X +
       su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0) :
    ErrorLieAlgebra SU3LieAlgebra where
  bracket := su3Bracket
  bracketError := fun _ _ => 0
  bracketError_nonneg := fun _ _ => le_refl 0
  norm := normInf8
  norm_nonneg := normInf8_nonneg
  εAntisym := 0
  εAntisym_nonneg := le_refl 0
  antisym_error := fun X Y => by
    rw [show su3Bracket X Y + su3Bracket Y X = (0 : SU3LieAlgebra)
        from su3Bracket_antisymmetric_pi X Y]
    exact le_of_eq normInf8_zero_val
  εJacobi := 0
  εJacobi_nonneg := le_refl 0
  jacobi_error := fun X Y Z => by
    rw [hJ X Y Z]; exact le_of_eq normInf8_zero_val
  εLinear := 0
  εLinear_nonneg := le_refl 0
  linear_error_left := fun a b X₁ X₂ Y => by
    have h : (su3Bracket (a • X₁ + b • X₂) Y +
              (-1 : ℝ) • (a • su3Bracket X₁ Y +
                b • su3Bracket X₂ Y) :
        SU3LieAlgebra) = 0 := by
      ext k
      simp only [Pi.add_apply, Pi.smul_apply, Pi.zero_apply, smul_eq_mul]
      rw [su3Bracket_smul_linear a b X₁ X₂ Y k]; ring
    rw [h]; exact le_of_eq normInf8_zero_val

theorem errorSU3_exact_antisym
    (hJ : ∀ (X Y Z : SU3LieAlgebra),
      (su3Bracket (su3Bracket X Y) Z +
       su3Bracket (su3Bracket Y Z) X +
       su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0)
    (X Y : SU3LieAlgebra) :
    @ErrorLieAlgebra.norm SU3LieAlgebra _ _
      (mkExactSU3LieAlgebra hJ)
      (@ErrorLieBracket.bracket SU3LieAlgebra _ _
        (mkExactSU3LieAlgebra hJ).toErrorLieBracket X Y +
       @ErrorLieBracket.bracket SU3LieAlgebra _ _
        (mkExactSU3LieAlgebra hJ).toErrorLieBracket Y X) = 0 :=
  @exact_antisym_of_zero_error SU3LieAlgebra _ _
    (mkExactSU3LieAlgebra hJ) rfl X Y

structure ErrorSU3Bracket (N : ℕ) where
  bracket_eq : ∀ X Y : SU3LieAlgebra,
    su3Bracket X Y = su3Bracket X Y
  error_bound : substrateLieBracketError N ≥ 0
  antisym_bound : ∀ X Y : SU3LieAlgebra,
    normInf8 (su3Bracket X Y + su3Bracket Y X) ≤
      substrateLieBracketError N
  jacobi_bound : ∀ X Y Z : SU3LieAlgebra,
    normInf8 (su3Bracket (su3Bracket X Y) Z +
             su3Bracket (su3Bracket Y Z) X +
             su3Bracket (su3Bracket Z X) Y) ≤
      3 * substrateLieBracketError N

noncomputable def errorSU3BracketInstance (N : ℕ)
    (hJ : ∀ (X Y Z : SU3LieAlgebra),
      (su3Bracket (su3Bracket X Y) Z +
       su3Bracket (su3Bracket Y Z) X +
       su3Bracket (su3Bracket Z X) Y : SU3LieAlgebra) = 0) :
    ErrorSU3Bracket N where
  bracket_eq := fun _ _ => rfl
  error_bound := substrateLieBracketError_nonneg N
  antisym_bound := fun X Y => by
    rw [su3Bracket_antisymmetric_pi X Y]
    exact le_trans (le_of_eq normInf8_zero_val)
      (substrateLieBracketError_nonneg N)
  jacobi_bound := fun X Y Z => by
    rw [hJ X Y Z]
    exact le_trans (le_of_eq normInf8_zero_val)
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 3)
        (substrateLieBracketError_nonneg N))

structure StrongCouplingFromSubstrate (N : ℕ) where
  energyScale : ℝ
  energyScale_pos : 0 < energyScale
  gs_sq : ℝ
  gs_sq_eq : gs_sq = computationalUncertainty N *
    (energyScale / E_P) ^ 2
  gs_sq_nonneg : 0 ≤ gs_sq

noncomputable def strongCouplingConstant_from_substrate
    (N : ℕ) (Λ_QCD : ℝ) (hΛ : 0 < Λ_QCD) :
    StrongCouplingFromSubstrate N where
  energyScale := Λ_QCD
  energyScale_pos := hΛ
  gs_sq := computationalUncertainty N * (Λ_QCD / E_P) ^ 2
  gs_sq_eq := rfl
  gs_sq_nonneg :=
    mul_nonneg (computationalUncertainty_nonneg N)
      (sq_nonneg (Λ_QCD / E_P))

theorem strongCouplingFromSubstrate_pos
    (N : ℕ) (Λ_QCD : ℝ) (hΛ : 0 < Λ_QCD) :
    (strongCouplingConstant_from_substrate N Λ_QCD hΛ).gs_sq > 0 := by
  change computationalUncertainty N * (Λ_QCD / E_P) ^ 2 > 0
  exact mul_pos (computationalUncertainty_pos N)
    (sq_pos_of_pos (div_pos hΛ E_P_pos))

theorem strongCoupling_decreasing
    (N : ℕ) (Λ_QCD : ℝ) (hΛ : 0 < Λ_QCD) :
    (strongCouplingConstant_from_substrate (N + 1) Λ_QCD hΛ).gs_sq ≤
    (strongCouplingConstant_from_substrate N Λ_QCD hΛ).gs_sq := by
  change computationalUncertainty (N + 1) * (Λ_QCD / E_P) ^ 2 ≤
    computationalUncertainty N * (Λ_QCD / E_P) ^ 2
  exact mul_le_mul_of_nonneg_right
    (computationalUncertainty_decreasing N) (sq_nonneg _)

theorem strongCoupling_tendsto_zero
    (Λ_QCD : ℝ) (hΛ : 0 < Λ_QCD) (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ,
      (strongCouplingConstant_from_substrate N Λ_QCD hΛ).gs_sq < ε := by
  have hΛE : (0 : ℝ) < (Λ_QCD / E_P) ^ 2 :=
    sq_pos_of_pos (div_pos hΛ E_P_pos)
  have hbound : 0 < ε / (Λ_QCD / E_P) ^ 2 := div_pos hε hΛE
  obtain ⟨N, hN⟩ :=
    substrateLieBracketError_tendsto_zero
      (ε / (Λ_QCD / E_P) ^ 2) hbound
  use N
  change computationalUncertainty N * (Λ_QCD / E_P) ^ 2 < ε
  unfold substrateLieBracketError at hN
  have hN' : computationalUncertainty N * (Λ_QCD / E_P) ^ 2 <
      ε / (Λ_QCD / E_P) ^ 2 * (Λ_QCD / E_P) ^ 2 :=
    mul_lt_mul_of_pos_right hN hΛE
  rwa [div_mul_cancel₀ ε (ne_of_gt hΛE)] at hN'

noncomputable def gluonSubstrateMassBound (N : ℕ) : ℝ :=
  computationalUncertainty N / c

theorem gluonSubstrateMassBound_nonneg (N : ℕ) :
    0 ≤ gluonSubstrateMassBound N :=
  div_nonneg (computationalUncertainty_nonneg N) c_nonneg

theorem gluonSubstrateMassBound_pos (N : ℕ) :
    0 < gluonSubstrateMassBound N :=
  div_pos (computationalUncertainty_pos N) c_pos

theorem gluonSubstrateMassBound_decreasing (N : ℕ) :
    gluonSubstrateMassBound (N + 1) ≤ gluonSubstrateMassBound N := by
  unfold gluonSubstrateMassBound
  exact div_le_div_of_nonneg_right
    (computationalUncertainty_decreasing N) c_nonneg

theorem gluonSubstrateMassBound_tendsto_zero
    (ε : ℝ) (hε : 0 < ε) :
    ∃ N : ℕ, gluonSubstrateMassBound N < ε := by
  have hcε : 0 < c * ε := mul_pos c_pos hε
  obtain ⟨N, hN⟩ :=
    substrateLieBracketError_tendsto_zero (c * ε) hcε
  use N
  unfold gluonSubstrateMassBound substrateLieBracketError at *
  rw [div_lt_iff₀ c_pos]
  linarith

noncomputable def gluonSubstrateMassErrorBound (N : ℕ) :
    ErrorBound :=
  ⟨gluonSubstrateMassBound N, gluonSubstrateMassBound_nonneg N⟩

def su3Dim : ℕ := 8
theorem su3Dim_eq : su3Dim = 8 := rfl

def su3GaugeBosonCount : ℕ := 8
theorem su3GaugeBosonCount_eq : su3GaugeBosonCount = 8 := rfl

def su3ColorCount : ℕ := 3
theorem su3ColorCount_eq : su3ColorCount = 3 := rfl

end OmegaTheory.Emergence.ErrorGaugeSU3
