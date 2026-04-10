/-
  OmegaTheory.Geometry.Curvature

  Curvature tensors on the discrete Planck lattice.

  Defines Riemann, Ricci, scalar curvature, and Einstein tensor.
  All "flat vanishes" sanity checks proven. Antisymmetry in last
  two indices proven (pure algebra). Pair swap and Ricci symmetry
  deferred (need axioms or deeper analysis).
-/

import OmegaTheory.Geometry.Connection
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Finset

/-! ## Christoffel Derivative -/

/-- Partial derivative of Christoffel symbol: ∂_α Γ^ρ_{μν}. -/
noncomputable def christoffelDerivative (g : DiscreteMetric) (ρ μ ν α : Fin 4)
    (p : LatticePoint) : ℝ :=
  symmetricDiff (fun q => christoffelSymbol g ρ μ ν q) α p

/-- Christoffel derivative inherits symmetry in μ,ν from Christoffel symmetry. -/
theorem christoffelDerivative_symm (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (ρ μ ν α : Fin 4) (p : LatticePoint) :
    christoffelDerivative g ρ μ ν α p = christoffelDerivative g ρ ν μ α p := by
  unfold christoffelDerivative symmetricDiff
  have hpos := christoffel_symmetry g hsym ρ μ ν (shiftFin p α)
  have hneg := christoffel_symmetry g hsym ρ μ ν (shiftBackFin p α)
  simp only [hpos, hneg]

/-- All Christoffel derivatives vanish for flat metric. -/
theorem christoffelDerivative_flat (ρ μ ν α : Fin 4) (p : LatticePoint) :
    christoffelDerivative DiscreteMetric.flat ρ μ ν α p = 0 := by
  unfold christoffelDerivative symmetricDiff
  simp [christoffel_flat]

/-! ## Riemann Curvature Tensor -/

/-- R^ρ_{σμν} = ∂_μ Γ^ρ_{νσ} - ∂_ν Γ^ρ_{μσ}
              + Σ_λ Γ^ρ_{μλ} Γ^λ_{νσ} - Σ_λ Γ^ρ_{νλ} Γ^λ_{μσ} -/
noncomputable def riemannTensor (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  christoffelDerivative g ρ ν σ μ p - christoffelDerivative g ρ μ σ ν p +
  Finset.univ.sum (fun l => christoffelSymbol g ρ μ l p * christoffelSymbol g l ν σ p) -
  Finset.univ.sum (fun l => christoffelSymbol g ρ ν l p * christoffelSymbol g l μ σ p)

/-- Riemann antisymmetry in last two indices: R^ρ_{σμν} = -R^ρ_{σνμ}.
    Pure algebra — swapping μ ↔ ν negates every term. -/
theorem riemann_antisym_34 (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannTensor g ρ σ μ ν p = -riemannTensor g ρ σ ν μ p := by
  unfold riemannTensor
  -- A - B + C - D = -(B - A + D - C) where sums C,D swap
  linarith

/-- For flat metric, Riemann tensor vanishes. -/
theorem riemann_flat (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannTensor DiscreteMetric.flat ρ σ μ ν p = 0 := by
  unfold riemannTensor
  simp only [christoffelDerivative_flat, christoffel_flat, mul_zero,
    Finset.sum_const_zero, add_zero, sub_zero, sub_self]

/-! ## Lowered Riemann Tensor -/

/-- R_{ρσμν} = g_{ρλ} R^λ_{σμν} (lower first index). -/
noncomputable def riemannLower (g : DiscreteMetric) (ρ σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun l => (g p) ρ l * riemannTensor g l σ μ ν p

/-- Lowered Riemann antisymmetry: R_{ρσμν} = -R_{ρσνμ}. -/
theorem riemannLower_antisym_34 (g : DiscreteMetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower g ρ σ μ ν p = -riemannLower g ρ σ ν μ p := by
  unfold riemannLower
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro l _
  rw [riemann_antisym_34 g l σ μ ν p]; ring

/-! ## Ricci Tensor -/

/-- R_{μν} = R^ρ_{μρν} (trace of Riemann on 1st and 3rd indices). -/
noncomputable def ricciTensor (g : DiscreteMetric) (μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun ρ => riemannTensor g ρ μ ρ ν p

/-- Ricci vanishes for flat metric. -/
theorem ricci_flat (μ ν : Fin 4) (p : LatticePoint) :
    ricciTensor DiscreteMetric.flat μ ν p = 0 := by
  unfold ricciTensor; simp [riemann_flat]

/-! ## Scalar Curvature -/

/-- R = g^{μν} R_{μν} (trace of Ricci with inverse metric). -/
noncomputable def scalarCurvature (g : DiscreteMetric) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ =>
    Finset.univ.sum fun ν =>
      (inverseMetric (g p)) μ ν * ricciTensor g μ ν p

/-- Scalar curvature vanishes for flat metric. -/
theorem scalar_flat (p : LatticePoint) :
    scalarCurvature DiscreteMetric.flat p = 0 := by
  unfold scalarCurvature; simp [ricci_flat]

/-! ## Einstein Tensor -/

/-- G_{μν} = R_{μν} - (1/2) g_{μν} R. -/
noncomputable def einsteinTensor (g : DiscreteMetric) (μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  ricciTensor g μ ν p - (1 / 2) * (g p) μ ν * scalarCurvature g p

/-- Einstein tensor vanishes for flat metric. -/
theorem einstein_flat (μ ν : Fin 4) (p : LatticePoint) :
    einsteinTensor DiscreteMetric.flat μ ν p = 0 := by
  unfold einsteinTensor
  simp [ricci_flat, scalar_flat]

/-- Vacuum Einstein equations: G_{μν} = 0. -/
def satisfiesVacuumEinstein (g : DiscreteMetric) : Prop :=
  ∀ μ ν p, einsteinTensor g μ ν p = 0

/-- Flat metric satisfies vacuum Einstein equations. -/
theorem flat_satisfies_vacuum : satisfiesVacuumEinstein DiscreteMetric.flat :=
  fun μ ν p => einstein_flat μ ν p

/-! ## First (Algebraic) Bianchi Identity

R^ρ_{σμν} + R^ρ_{μνσ} + R^ρ_{νσμ} = 0

EXACT — no approximation needed. Proof uses only Christoffel symmetry
(which requires metric symmetry) and algebraic cancellation. -/

/-- First Bianchi identity: cyclic sum of Riemann vanishes.
    Proof: derivative terms cancel via christoffelDerivative_symm,
    product terms cancel by index relabeling + christoffel_symmetry. -/
theorem first_bianchi (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannTensor g ρ σ μ ν p + riemannTensor g ρ μ ν σ p +
    riemannTensor g ρ ν σ μ p = 0 := by
  unfold riemannTensor
  -- Derivative equalities from Christoffel symmetry
  have hD1 := christoffelDerivative_symm g hsym ρ ν σ μ p  -- ∂_μΓ^ρ_{νσ} = ∂_μΓ^ρ_{σν}
  have hD2 := christoffelDerivative_symm g hsym ρ μ σ ν p  -- ∂_νΓ^ρ_{μσ} = ∂_νΓ^ρ_{σμ}
  have hD3 := christoffelDerivative_symm g hsym ρ ν μ σ p  -- ∂_σΓ^ρ_{νμ} = ∂_σΓ^ρ_{μν}
  -- Product equalities from Christoffel symmetry in second factor
  have hP1 : ∀ l, christoffelSymbol g l ν σ p = christoffelSymbol g l σ ν p :=
    fun l => christoffel_symmetry g hsym l ν σ p
  have hP2 : ∀ l, christoffelSymbol g l μ σ p = christoffelSymbol g l σ μ p :=
    fun l => christoffel_symmetry g hsym l μ σ p
  have hP3 : ∀ l, christoffelSymbol g l ν μ p = christoffelSymbol g l μ ν p :=
    fun l => christoffel_symmetry g hsym l ν μ p
  -- Rewrite all product sums using symmetry
  simp_rw [hP1, hP2, hP3, hD1, hD2, hD3]
  ring

/-- First Bianchi for the lowered tensor:
    R_{ρσμν} + R_{ρμνσ} + R_{ρνσμ} = 0.
    Follows from first_bianchi by linearity of metric contraction. -/
theorem first_bianchi_lower (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower g ρ σ μ ν p + riemannLower g ρ μ ν σ p +
    riemannLower g ρ ν σ μ p = 0 := by
  unfold riemannLower
  rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
  apply Finset.sum_eq_zero
  intro l _
  have h := first_bianchi g hsym l σ μ ν p
  have : (g p) ρ l * riemannTensor g l σ μ ν p +
    (g p) ρ l * riemannTensor g l μ ν σ p +
    (g p) ρ l * riemannTensor g l ν σ μ p =
    (g p) ρ l * (riemannTensor g l σ μ ν p + riemannTensor g l μ ν σ p +
      riemannTensor g l ν σ μ p) := by ring
  rw [this, h, mul_zero]

end OmegaTheory.Geometry
