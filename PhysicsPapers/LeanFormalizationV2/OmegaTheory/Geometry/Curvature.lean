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

/-! ## Raise-Lower Bridge and Alternative Ricci Form

The Ricci tensor has two equivalent definitions:
1. `ricciTensor := Σ_ρ R^ρ_{μρν}` (trace of upper-index Riemann)
2. `ricciTensor' := Σ_{ρ,σ} g^{ρσ} R_{ρμσν}` (metric-contracted lowered Riemann)

The second form makes Ricci symmetry an algebraic consequence of pair swap
plus inverse-metric symmetry. We build the bridge here. -/

/-- Raising the first index of the lowered Riemann recovers the original.
    R^ρ_{σμν} = Σ_λ g^{ρλ} R_{λσμν}.
    This is definitional: `riemannLower` lowers, and contracting with `inverseMetric`
    raises it back. Uses `inverse_mul_metric`. -/
theorem riemann_raise_lower (g : DiscreteMetric) (hnd : ∀ p, IsNondegenerate (g p))
    (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannTensor g ρ σ μ ν p =
    Finset.univ.sum fun lam => (inverseMetric (g p)) ρ lam *
      riemannLower g lam σ μ ν p := by
  unfold riemannLower
  have h_delta : ∀ tau : Fin 4,
      Finset.univ.sum (fun lam => (inverseMetric (g p)) ρ lam * (g p) lam tau) =
      if ρ = tau then (1 : ℝ) else 0 := by
    intro tau
    have h := inverse_mul_metric (g p) (hnd p)
    have heq := congrFun (congrFun h ρ) tau
    simp only [Matrix.mul_apply, Matrix.one_apply] at heq
    exact heq
  symm
  calc Finset.univ.sum (fun lam => (inverseMetric (g p)) ρ lam *
          Finset.univ.sum (fun tau => (g p) lam tau * riemannTensor g tau σ μ ν p))
      = Finset.univ.sum (fun lam => Finset.univ.sum fun tau =>
          (inverseMetric (g p)) ρ lam * ((g p) lam tau * riemannTensor g tau σ μ ν p)) := by
        apply Finset.sum_congr rfl; intro lam _; rw [Finset.mul_sum]
    _ = Finset.univ.sum (fun tau => Finset.univ.sum fun lam =>
          (inverseMetric (g p)) ρ lam * ((g p) lam tau * riemannTensor g tau σ μ ν p)) := by
        rw [Finset.sum_comm]
    _ = Finset.univ.sum (fun tau => Finset.univ.sum fun lam =>
          ((inverseMetric (g p)) ρ lam * (g p) lam tau) * riemannTensor g tau σ μ ν p) := by
        apply Finset.sum_congr rfl; intro tau _
        apply Finset.sum_congr rfl; intro lam _; ring
    _ = Finset.univ.sum (fun tau =>
          (Finset.univ.sum fun lam => (inverseMetric (g p)) ρ lam * (g p) lam tau) *
          riemannTensor g tau σ μ ν p) := by
        apply Finset.sum_congr rfl; intro tau _; rw [← Finset.sum_mul]
    _ = Finset.univ.sum (fun tau =>
          (if ρ = tau then (1 : ℝ) else 0) * riemannTensor g tau σ μ ν p) := by
        apply Finset.sum_congr rfl; intro tau _; rw [h_delta tau]
    _ = Finset.univ.sum (fun tau =>
          if ρ = tau then riemannTensor g tau σ μ ν p else 0) := by
        apply Finset.sum_congr rfl; intro tau _; split_ifs <;> ring
    _ = riemannTensor g ρ σ μ ν p := by
        rw [Finset.sum_ite_eq]; simp

/-- Alternative definition of the Ricci tensor via metric contraction:
    R_{μν} = g^{ρσ} R_{ρμσν}.
    This form exposes Ricci symmetry as a direct consequence of pair swap. -/
noncomputable def ricciTensor' (g : DiscreteMetric) (μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun ρ =>
    Finset.univ.sum fun σ =>
      (inverseMetric (g p)) ρ σ * riemannLower g ρ μ σ ν p

/-- Bridge: the two Ricci definitions agree.
    Proof: unfold `ricciTensor` as `Σ_ρ R^ρ_{μρν}`, substitute `riemann_raise_lower`
    to convert each term into `Σ_λ g^{ρλ} R_{λμρν}`, exchange sum order, and use
    inverse-metric symmetry to match `ricciTensor'`. Requires metric symmetry and
    nondegeneracy. -/
theorem ricciTensor_eq_ricciTensor' (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (hnd : ∀ p, IsNondegenerate (g p))
    (μ ν : Fin 4) (p : LatticePoint) :
    ricciTensor g μ ν p = ricciTensor' g μ ν p := by
  unfold ricciTensor ricciTensor'
  conv_lhs =>
    congr
    · skip
    · ext ρ
      rw [riemann_raise_lower g hnd ρ μ ρ ν p]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl; intro lam _
  apply Finset.sum_congr rfl; intro ρ _
  rw [inverseMetric_symm (g p) (hsym p) ρ lam]

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

/-! ## Einstein Trace

The trace of the Einstein tensor: g^{μν} G_{μν} = -R.
Proof: Tr(G) = Tr(Ric) - (1/2) Tr(g) R = R - (1/2)(4)R = -R.
Uses Tr(g⁻¹g) = Tr(I) = 4. -/

/-- Trace of g⁻¹g equals 4 (the spacetime dimension).
    Σ_{μν} g^{μν} g_{νμ} = Tr(g⁻¹ · g) = Tr(I₄) = 4. -/
theorem metric_inverse_trace (g : MetricTensor) (hnd : IsNondegenerate g) :
    Finset.univ.sum (fun μ : Fin 4 => Finset.univ.sum (fun ν : Fin 4 =>
      (inverseMetric g) μ ν * g ν μ)) = 4 := by
  have h_prod := inverse_mul_metric g hnd
  have h_diag : ∀ μ : Fin 4, Finset.univ.sum (fun ν =>
      (inverseMetric g) μ ν * g ν μ) = 1 := by
    intro μ
    have := congrFun (congrFun h_prod μ) μ
    simp only [Matrix.mul_apply, Matrix.one_apply_eq] at this
    exact this
  simp_rw [h_diag, Finset.sum_const, Finset.card_fin, nsmul_eq_mul, Nat.cast_ofNat]
  norm_num

/-- With metric symmetry: Σ_{μν} g^{μν} g_{μν} = 4. -/
theorem metric_inverse_trace_sym (g : MetricTensor) (hsym : IsSymmetric g)
    (hnd : IsNondegenerate g) :
    Finset.univ.sum (fun μ : Fin 4 => Finset.univ.sum (fun ν : Fin 4 =>
      (inverseMetric g) μ ν * g μ ν)) = 4 := by
  have hsym' : ∀ μ ν : Fin 4, g μ ν = g ν μ := by
    intros μ ν
    have := congrFun (congrFun hsym ν) μ
    simp only [Matrix.transpose_apply] at this; exact this
  have hrw : (fun μ : Fin 4 => Finset.univ.sum (fun ν : Fin 4 =>
      (inverseMetric g) μ ν * g μ ν)) =
    (fun μ : Fin 4 => Finset.univ.sum (fun ν : Fin 4 =>
      (inverseMetric g) μ ν * g ν μ)) := by
    ext μ; apply Finset.sum_congr rfl; intro ν _; rw [hsym' μ ν]
  rw [hrw]
  exact metric_inverse_trace g hnd

/-- Einstein trace: g^{μν} G_{μν} = -R.
    The trace of the Einstein tensor equals minus the scalar curvature.
    Proof: Tr(G) = Tr(Ric) - (1/2)·Tr(g⁻¹g)·R = R - (1/2)·4·R = -R. -/
theorem einstein_trace (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (hnd : ∀ p, IsNondegenerate (g p)) (p : LatticePoint) :
    Finset.univ.sum (fun μ => Finset.univ.sum (fun ν =>
      (inverseMetric (g p)) μ ν * einsteinTensor g μ ν p)) =
    -scalarCurvature g p := by
  have h4 := metric_inverse_trace_sym (g p) (hsym p) (hnd p)
  -- Step 1: Expand einsteinTensor in each term
  have key : ∀ μ ν : Fin 4,
      (inverseMetric (g p)) μ ν * einsteinTensor g μ ν p =
      (inverseMetric (g p)) μ ν * ricciTensor g μ ν p -
      (1 / 2) * scalarCurvature g p * ((inverseMetric (g p)) μ ν * (g p) μ ν) := by
    intros; unfold einsteinTensor; ring
  -- Step 2: Calculate via explicit chain
  calc Finset.univ.sum (fun μ => Finset.univ.sum (fun ν =>
        (inverseMetric (g p)) μ ν * einsteinTensor g μ ν p))
      -- Expand each term
      = Finset.univ.sum (fun μ => Finset.univ.sum (fun ν =>
        ((inverseMetric (g p)) μ ν * ricciTensor g μ ν p -
         (1 / 2) * scalarCurvature g p *
          ((inverseMetric (g p)) μ ν * (g p) μ ν)))) := by
        congr 1; ext μ; congr 1; ext ν; exact key μ ν
      -- Split inner sums
    _ = Finset.univ.sum (fun μ =>
        Finset.univ.sum (fun ν =>
          (inverseMetric (g p)) μ ν * ricciTensor g μ ν p) -
        Finset.univ.sum (fun ν =>
          (1 / 2) * scalarCurvature g p *
          ((inverseMetric (g p)) μ ν * (g p) μ ν))) := by
        congr 1; ext μ; rw [← Finset.sum_sub_distrib]
      -- Factor constant from inner sum
    _ = Finset.univ.sum (fun μ =>
        Finset.univ.sum (fun ν =>
          (inverseMetric (g p)) μ ν * ricciTensor g μ ν p) -
        (1 / 2) * scalarCurvature g p *
        Finset.univ.sum (fun ν =>
          (inverseMetric (g p)) μ ν * (g p) μ ν)) := by
        congr 1; ext μ; congr 1; rw [← Finset.mul_sum]
      -- Split outer sum
    _ = Finset.univ.sum (fun μ => Finset.univ.sum (fun ν =>
          (inverseMetric (g p)) μ ν * ricciTensor g μ ν p)) -
        Finset.univ.sum (fun μ =>
          (1 / 2) * scalarCurvature g p *
          Finset.univ.sum (fun ν =>
            (inverseMetric (g p)) μ ν * (g p) μ ν)) := by
        rw [← Finset.sum_sub_distrib]
      -- Factor constant from outer sum
    _ = scalarCurvature g p -
        (1 / 2) * scalarCurvature g p *
        Finset.univ.sum (fun μ => Finset.univ.sum (fun ν =>
          (inverseMetric (g p)) μ ν * (g p) μ ν)) := by
        congr 1; rw [← Finset.mul_sum]
      -- Apply trace = 4
    _ = scalarCurvature g p - (1 / 2) * scalarCurvature g p * 4 := by
        rw [h4]
    _ = -scalarCurvature g p := by ring

/-! ## Kretschmann Scalar (Mixed-Index)

The mixed-index Kretschmann K' = Σ_{ρσμν} (R^ρ_{σμν})² is a sum of squares,
hence nonneg. This is a coordinate-dependent quantity that equals the standard
Kretschmann scalar K = R_{αβγδ}R^{αβγδ} in orthonormal frames. -/

/-- Mixed-index Kretschmann: K' = Σ_{ρσμν} (R^ρ_{σμν})². -/
noncomputable def kretschmannMixed (g : DiscreteMetric) (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun ρ => Finset.univ.sum fun σ =>
    Finset.univ.sum fun μ => Finset.univ.sum fun ν =>
      (riemannTensor g ρ σ μ ν p) ^ 2

/-- Kretschmann is nonneg (sum of squares). -/
theorem kretschmannMixed_nonneg (g : DiscreteMetric) (p : LatticePoint) :
    0 ≤ kretschmannMixed g p := by
  unfold kretschmannMixed
  apply Finset.sum_nonneg; intro ρ _
  apply Finset.sum_nonneg; intro σ _
  apply Finset.sum_nonneg; intro μ _
  apply Finset.sum_nonneg; intro ν _
  exact sq_nonneg _

/-- Kretschmann vanishes for flat spacetime. -/
theorem kretschmannMixed_flat (p : LatticePoint) :
    kretschmannMixed DiscreteMetric.flat p = 0 := by
  unfold kretschmannMixed
  apply Finset.sum_eq_zero; intro ρ _
  apply Finset.sum_eq_zero; intro σ _
  apply Finset.sum_eq_zero; intro μ _
  apply Finset.sum_eq_zero; intro ν _
  rw [riemann_flat]; norm_num

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
