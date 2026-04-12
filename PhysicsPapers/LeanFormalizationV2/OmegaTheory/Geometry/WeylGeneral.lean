/-
  OmegaTheory.Geometry.WeylGeneral

  Dimension-generic Weyl tensor: definition and tracefree proof for
  arbitrary dimension n >= 3.

  The Weyl tensor in n dimensions is:

    C_{ρσμν} = R_{ρσμν}
      - 1/(n-2) * (g_{ρμ} R_{σν} - g_{ρν} R_{σμ} - g_{σμ} R_{ρν} + g_{σν} R_{ρμ})
      + 1/((n-1)(n-2)) * S * (g_{ρμ} g_{σν} - g_{ρν} g_{σμ})

  The main theorem `weyl_tracefree_n` proves that
  Σ_{ρμ} g^{ρμ} C_{ρσμν} = 0 for any dimension n >= 3, assuming:
    (1) Symmetric nondegenerate metric
    (2) Riemann contracts to Ricci: Σ g^{ρμ} R_{ρσμν} = Ric_{σν}
    (3) Scalar curvature is Σ g^{μν} Ric_{μν}

  This file has NO dependency on the lattice, Christoffel symbols, or any
  physical infrastructure — it is a purely algebraic identity about the
  trace of the Weyl decomposition of curvature.

  Research significance: To our knowledge, this is the first formal proof
  of the Weyl tracefree property in arbitrary dimension in any theorem prover.

  The n=4 specialization recovers the coefficients (1/2, 1/6) used in Weyl.lean.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Tactic

namespace OmegaTheory.Geometry.General

open Matrix Finset

/-! ## Dimension Arithmetic Helpers -/

private lemma n_cast_gt_two (n : ℕ) (hn : 2 < n) : (2 : ℝ) < (n : ℝ) :=
  by exact_mod_cast hn

private lemma n_cast_gt_one (n : ℕ) (hn : 2 < n) : (1 : ℝ) < (n : ℝ) :=
  lt_trans one_lt_two (n_cast_gt_two n hn)

private lemma n_sub_2_ne_zero (n : ℕ) (hn : 2 < n) : (n : ℝ) - 2 ≠ 0 :=
  sub_ne_zero.mpr (ne_of_gt (n_cast_gt_two n hn))

private lemma n_sub_1_ne_zero (n : ℕ) (hn : 2 < n) : (n : ℝ) - 1 ≠ 0 :=
  sub_ne_zero.mpr (ne_of_gt (n_cast_gt_one n hn))

private lemma n_sub_12_ne_zero (n : ℕ) (hn : 2 < n) :
    ((n : ℝ) - 1) * ((n : ℝ) - 2) ≠ 0 :=
  mul_ne_zero (n_sub_1_ne_zero n hn) (n_sub_2_ne_zero n hn)

/-! ## Definition -/

/-- General-dimension Weyl tensor from abstract curvature data.

    Takes a symmetric nondegenerate metric `g`, lowered Riemann `R_lower`,
    Ricci tensor `Ric`, and scalar curvature `S` as parameters.
    The coefficients 1/(n-2) and 1/((n-1)(n-2)) are the standard ones
    (Wald §3.2, Carroll §3.7). -/
noncomputable def weylTensorN (n : ℕ) (hn : 2 < n)
    (g : Matrix (Fin n) (Fin n) ℝ)
    (R_lower : Fin n → Fin n → Fin n → Fin n → ℝ)
    (Ric : Fin n → Fin n → ℝ)
    (S : ℝ)
    (ρ σ μ ν : Fin n) : ℝ :=
  R_lower ρ σ μ ν
  - (1 / ((n : ℝ) - 2)) * (g ρ μ * Ric σ ν - g ρ ν * Ric σ μ
                           - g σ μ * Ric ρ ν + g σ ν * Ric ρ μ)
  + (1 / (((n : ℝ) - 1) * ((n : ℝ) - 2))) * S
      * (g ρ μ * g σ ν - g ρ ν * g σ μ)

/-! ## Antisymmetry in last two indices -/

theorem weyl_antisym_34_n (n : ℕ) (hn : 2 < n)
    (g : Matrix (Fin n) (Fin n) ℝ)
    (R_lower : Fin n → Fin n → Fin n → Fin n → ℝ)
    (Ric : Fin n → Fin n → ℝ) (S : ℝ)
    (h_R_antisym : ∀ ρ σ μ ν, R_lower ρ σ μ ν + R_lower ρ σ ν μ = 0)
    (ρ σ μ ν : Fin n) :
    weylTensorN n hn g R_lower Ric S ρ σ μ ν +
    weylTensorN n hn g R_lower Ric S ρ σ ν μ = 0 := by
  unfold weylTensorN
  have := h_R_antisym ρ σ μ ν
  linarith

/-! ## Contraction Lemmas -/

/-- Inverse metric contraction: Σ_μ g^{ρμ} g_{μσ} = δ^ρ_σ. -/
private lemma inverse_contract_n {n : ℕ}
    (g : Matrix (Fin n) (Fin n) ℝ)
    (hnd : g.det ≠ 0) (ρ σ : Fin n) :
    (univ.sum fun μ => g⁻¹ ρ μ * g μ σ) =
    (if ρ = σ then (1 : ℝ) else 0) := by
  have h := congrFun (congrFun (nonsing_inv_mul g (isUnit_iff_ne_zero.mpr hnd)) ρ) σ
  simpa [mul_apply, one_apply] using h

/-- Left contraction with symmetric metric: Σ_ρ g^{ρμ} g_{ρν} = δ^μ_ν. -/
private lemma inverse_contract_left_n {n : ℕ}
    (g : Matrix (Fin n) (Fin n) ℝ)
    (hsym : g.IsSymm) (hnd : g.det ≠ 0) (μ ν : Fin n) :
    (univ.sum fun ρ => g⁻¹ ρ μ * g ρ ν) =
    (if μ = ν then (1 : ℝ) else 0) := by
  have h_eq : (univ.sum fun ρ => g⁻¹ ρ μ * g ρ ν) =
      (univ.sum fun ρ => g⁻¹ μ ρ * g ρ ν) := by
    apply sum_congr rfl; intro ρ _
    rw [show g⁻¹ ρ μ = g⁻¹ μ ρ from by
      have hinv := hsym.inv
      have := congrFun (congrFun hinv μ) ρ
      simpa [transpose_apply] using this]
  rw [h_eq]; exact inverse_contract_n g hnd μ ν

/-- Right contraction with lower index swap: Σ_μ g^{ρμ} g_{σμ} = δ^ρ_σ. -/
private lemma inverse_contract_swap_n {n : ℕ}
    (g : Matrix (Fin n) (Fin n) ℝ)
    (hsym : g.IsSymm) (hnd : g.det ≠ 0) (ρ σ : Fin n) :
    (univ.sum fun μ => g⁻¹ ρ μ * g σ μ) =
    (if ρ = σ then (1 : ℝ) else 0) := by
  have h_eq : (univ.sum fun μ => g⁻¹ ρ μ * g σ μ) =
      (univ.sum fun μ => g⁻¹ ρ μ * g μ σ) := by
    apply sum_congr rfl; intro μ _
    rw [show g σ μ = g μ σ from by
      have := congrFun (congrFun hsym μ) σ; simpa [transpose_apply] using this]
  rw [h_eq]; exact inverse_contract_n g hnd ρ σ

/-! ## Metric Frobenius Trace -/

/-- Tr(g⁻¹ g) = n: the Frobenius trace of the identity. -/
private lemma metric_frobenius_n {n : ℕ}
    (g : Matrix (Fin n) (Fin n) ℝ)
    (hsym : g.IsSymm) (hnd : g.det ≠ 0) :
    (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * g ρ μ) = (n : ℝ) := by
  -- Each inner sum: Σ_μ g^{ρμ} g_{ρμ} = Σ_μ g^{ρμ} g_{μρ} (by symmetry)
  --                                     = δ^ρ_ρ = 1
  have h_inner : ∀ ρ, (univ.sum fun μ => g⁻¹ ρ μ * g ρ μ) = (1 : ℝ) := by
    intro ρ
    have h_eq : (univ.sum fun μ => g⁻¹ ρ μ * g ρ μ) =
        (univ.sum fun μ => g⁻¹ ρ μ * g μ ρ) := by
      apply sum_congr rfl; intro μ _
      rw [show g ρ μ = g μ ρ from by
        have := congrFun (congrFun hsym μ) ρ; simpa [transpose_apply] using this]
    rw [h_eq, inverse_contract_n g hnd ρ ρ]
    simp
  simp_rw [h_inner]
  simp [Finset.sum_const, Finset.card_univ, Fintype.card_fin]

/-! ## Tracefree Theorem -/

/-- The Weyl tensor is tracefree in arbitrary dimension n ≥ 3:
    Σ_{ρ,μ} g^{ρμ} C_{ρσμν} = 0.

    This is a purely algebraic identity about the Weyl decomposition.
    No lattice structure, no Christoffel symbols, no physics — just
    the defining algebraic relation between Riemann, Ricci, scalar,
    and the metric. -/
theorem weyl_tracefree_n (n : ℕ) (hn : 2 < n)
    (g : Matrix (Fin n) (Fin n) ℝ)
    (hsym : g.IsSymm) (hnd : g.det ≠ 0)
    (R_lower : Fin n → Fin n → Fin n → Fin n → ℝ)
    (Ric : Fin n → Fin n → ℝ)
    (S : ℝ)
    -- Structural hypothesis: Riemann contracts to Ricci
    (h_contract : ∀ σ ν,
      (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * R_lower ρ σ μ ν) = Ric σ ν)
    -- Structural hypothesis: scalar is trace of Ricci
    (h_scalar : S = univ.sum fun μ => univ.sum fun ν =>
        g⁻¹ μ ν * Ric μ ν)
    (σ ν : Fin n) :
    (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * weylTensorN n hn g R_lower Ric S ρ σ μ ν) = 0 := by
  -- Pointwise expansion of g^{ρμ} * C_{ρσμν} into seven summands
  have h_pt : ∀ (ρ μ : Fin n),
      g⁻¹ ρ μ * weylTensorN n hn g R_lower Ric S ρ σ μ ν =
        g⁻¹ ρ μ * R_lower ρ σ μ ν
        - (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g ρ μ * Ric σ ν))
        + (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g ρ ν * Ric σ μ))
        + (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g σ μ * Ric ρ ν))
        - (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g σ ν * Ric ρ μ))
        + (1 / (((n : ℝ) - 1) * ((n : ℝ) - 2))) * S *
            (g⁻¹ ρ μ * (g ρ μ * g σ ν))
        - (1 / (((n : ℝ) - 1) * ((n : ℝ) - 2))) * S *
            (g⁻¹ ρ μ * (g ρ ν * g σ μ)) := by
    intro ρ μ; unfold weylTensorN; ring
  -- Rewrite under the double sum
  have h_outer :
      (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * weylTensorN n hn g R_lower Ric S ρ σ μ ν) =
      (univ.sum fun ρ => univ.sum fun μ =>
        (g⁻¹ ρ μ * R_lower ρ σ μ ν
         - (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g ρ μ * Ric σ ν))
         + (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g ρ ν * Ric σ μ))
         + (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g σ μ * Ric ρ ν))
         - (1 / ((n : ℝ) - 2)) * (g⁻¹ ρ μ * (g σ ν * Ric ρ μ))
         + (1 / (((n : ℝ) - 1) * ((n : ℝ) - 2))) * S *
             (g⁻¹ ρ μ * (g ρ μ * g σ ν))
         - (1 / (((n : ℝ) - 1) * ((n : ℝ) - 2))) * S *
             (g⁻¹ ρ μ * (g ρ ν * g σ μ)))) := by
    apply sum_congr rfl; intro ρ _
    apply sum_congr rfl; intro μ _
    exact h_pt ρ μ
  rw [h_outer]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  -- Now we have seven separate double-sums. Evaluate each.
  -- Term 1: Σ g^{ρμ} R_{ρσμν} = Ric_{σν}
  rw [h_contract σ ν]
  -- Sub-sum b1: Σ g^{ρμ} g_{ρμ} Ric_{σν} = n · Ric_{σν}
  have hb1 : (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * (g ρ μ * Ric σ ν)) =
      (n : ℝ) * Ric σ ν := by
    have : (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * (g ρ μ * Ric σ ν)) =
      (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * g ρ μ) * Ric σ ν := by
      rw [Finset.sum_mul]; apply sum_congr rfl; intro ρ _
      rw [Finset.sum_mul]; apply sum_congr rfl; intro μ _; ring
    rw [this, metric_frobenius_n g hsym hnd]
  -- Sub-sum b2: Σ g^{ρμ} g_{ρν} Ric_{σμ} = Ric_{σν}
  have hb2 : (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * (g ρ ν * Ric σ μ)) = Ric σ ν := by
    rw [Finset.sum_comm]
    have h_eq : (univ.sum fun μ => univ.sum fun ρ =>
        g⁻¹ ρ μ * (g ρ ν * Ric σ μ)) =
      (univ.sum fun μ => Ric σ μ *
        (univ.sum fun ρ => g⁻¹ ρ μ * g ρ ν)) := by
      apply sum_congr rfl; intro μ _; rw [Finset.mul_sum]
      apply sum_congr rfl; intro ρ _; ring
    rw [h_eq]
    conv_lhs => rhs; ext μ; rw [inverse_contract_left_n g hsym hnd μ ν]
    simp
  -- Sub-sum b3: Σ g^{ρμ} g_{σμ} Ric_{ρν} = Ric_{σν}
  have hb3 : (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * (g σ μ * Ric ρ ν)) = Ric σ ν := by
    have h_eq : (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * (g σ μ * Ric ρ ν)) =
      (univ.sum fun ρ => Ric ρ ν *
        (univ.sum fun μ => g⁻¹ ρ μ * g σ μ)) := by
      apply sum_congr rfl; intro ρ _; rw [Finset.mul_sum]
      apply sum_congr rfl; intro μ _; ring
    rw [h_eq]
    conv_lhs => rhs; ext ρ; rw [inverse_contract_swap_n g hsym hnd ρ σ]
    simp
  -- Sub-sum b4: Σ g^{ρμ} g_{σν} Ric_{ρμ} = g_{σν} · S
  have hb4 : (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * (g σ ν * Ric ρ μ)) =
      g σ ν * S := by
    have h_eq : (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * (g σ ν * Ric ρ μ)) =
      g σ ν * (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * Ric ρ μ) := by
      rw [Finset.mul_sum]; apply sum_congr rfl; intro ρ _
      rw [Finset.mul_sum]; apply sum_congr rfl; intro μ _; ring
    rw [h_eq, h_scalar]
  -- Sub-sum s1: Σ g^{ρμ} g_{ρμ} g_{σν} = n · g_{σν}
  have hs1 : (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * (g ρ μ * g σ ν)) =
      (n : ℝ) * g σ ν := by
    have : (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * (g ρ μ * g σ ν)) =
      (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * g ρ μ) * g σ ν := by
      rw [Finset.sum_mul]; apply sum_congr rfl; intro ρ _
      rw [Finset.sum_mul]; apply sum_congr rfl; intro μ _; ring
    rw [this, metric_frobenius_n g hsym hnd]
  -- Sub-sum s2: Σ g^{ρμ} g_{ρν} g_{σμ} = g_{σν}
  have hs2 : (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * (g ρ ν * g σ μ)) = g σ ν := by
    rw [Finset.sum_comm]
    have h_eq : (univ.sum fun μ => univ.sum fun ρ =>
        g⁻¹ ρ μ * (g ρ ν * g σ μ)) =
      (univ.sum fun μ => g σ μ *
        (univ.sum fun ρ => g⁻¹ ρ μ * g ρ ν)) := by
      apply sum_congr rfl; intro μ _; rw [Finset.mul_sum]
      apply sum_congr rfl; intro ρ _; ring
    rw [h_eq]
    conv_lhs => rhs; ext μ; rw [inverse_contract_left_n g hsym hnd μ ν]
    simp
  -- Assembly: substitute all sub-sums and close with field_simp + ring
  rw [hb1, hb2, hb3, hb4, hs1, hs2]
  -- Goal: Ric σ ν - 1/(n-2) * (n * Ric σ ν) + 1/(n-2) * Ric σ ν
  --     + 1/(n-2) * Ric σ ν - 1/(n-2) * (g σ ν * S)
  --     + 1/((n-1)(n-2)) * S * (n * g σ ν) - 1/((n-1)(n-2)) * S * g σ ν = 0
  field_simp [n_sub_1_ne_zero n hn, n_sub_2_ne_zero n hn, n_sub_12_ne_zero n hn]
  ring

/-! ## Specialization to n = 4 -/

/-- The n=4 specialization recovers the familiar (1/2, 1/6) coefficients. -/
theorem weylTensorN_four_coeffs :
    (1 : ℝ) / ((4 : ℝ) - 2) = 1 / 2 ∧
    (1 : ℝ) / (((4 : ℝ) - 1) * ((4 : ℝ) - 2)) = 1 / 6 := by
  constructor <;> norm_num

/-- The tracefree property specialized to dimension 4. -/
theorem weyl_tracefree_four
    (g : Matrix (Fin 4) (Fin 4) ℝ)
    (hsym : g.IsSymm) (hnd : g.det ≠ 0)
    (R_lower : Fin 4 → Fin 4 → Fin 4 → Fin 4 → ℝ)
    (Ric : Fin 4 → Fin 4 → ℝ)
    (S : ℝ)
    (h_contract : ∀ σ ν,
      (univ.sum fun ρ => univ.sum fun μ =>
        g⁻¹ ρ μ * R_lower ρ σ μ ν) = Ric σ ν)
    (h_scalar : S = univ.sum fun μ => univ.sum fun ν =>
        g⁻¹ μ ν * Ric μ ν)
    (σ ν : Fin 4) :
    (univ.sum fun ρ => univ.sum fun μ =>
      g⁻¹ ρ μ * weylTensorN 4 (by norm_num) g R_lower Ric S ρ σ μ ν) = 0 :=
  weyl_tracefree_n 4 (by norm_num) g hsym hnd R_lower Ric S h_contract h_scalar σ ν

/-! ## Weyl vanishes for zero curvature -/

theorem weyl_zero_n (n : ℕ) (hn : 2 < n)
    (g : Matrix (Fin n) (Fin n) ℝ) :
    weylTensorN n hn g (fun _ _ _ _ => 0) (fun _ _ => 0) 0 = fun _ _ _ _ => 0 := by
  ext ρ σ μ ν; unfold weylTensorN; ring

end OmegaTheory.Geometry.General
