/-
  OmegaTheory.Geometry.Metric

  Metric tensor on the discrete Planck lattice.
  Ported from V1 (0 sorry) with namespace adaptations.

  Defines:
  - MetricTensor (4×4 real matrix)
  - Minkowski metric η = diag(-1,1,1,1)
  - Lorentzian signature
  - Inverse metric, index raising/lowering
  - DiscreteMetric (metric field on lattice)
-/

import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Matrix.Symmetric
import Mathlib.Data.Fin.VecNotation
import Mathlib.Tactic
import OmegaTheory.Spacetime.Lattice

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime
open Matrix

/-! ## Metric Tensor -/

/-- A metric tensor is a 4×4 real matrix g_{μν}. -/
abbrev MetricTensor := Matrix (Fin 4) (Fin 4) ℝ

/-- Symmetry: g_{μν} = g_{νμ}. -/
def IsSymmetric (g : MetricTensor) : Prop := g.IsSymm

/-- Non-degeneracy: det(g) ≠ 0. -/
def IsNondegenerate (g : MetricTensor) : Prop := g.det ≠ 0

/-! ## Minkowski Metric -/

/-- η = diag(-1, 1, 1, 1), mostly-plus convention. -/
noncomputable def minkowskiMetric : MetricTensor :=
  Matrix.diagonal ![(-1 : ℝ), 1, 1, 1]

theorem minkowski_symmetric : IsSymmetric minkowskiMetric := by
  unfold IsSymmetric minkowskiMetric
  rw [Matrix.IsSymm]
  ext i j
  simp only [Matrix.transpose_apply, Matrix.diagonal_apply]
  by_cases h : i = j
  · simp [h]
  · simp [h, Ne.symm h]

theorem minkowski_off_diag (i j : Fin 4) (h : i ≠ j) :
    minkowskiMetric i j = 0 := by
  simp [minkowskiMetric, Matrix.diagonal, h]

/-! ## Lorentzian Signature -/

/-- A metric is Lorentzian: symmetric, non-degenerate, det < 0. -/
structure IsLorentzian (g : MetricTensor) : Prop where
  symmetric : IsSymmetric g
  nondegenerate : IsNondegenerate g
  signature : g.det < 0

private lemma vec4_2 : ![-1, 1, 1, 1] (2 : Fin 4) = (1 : ℝ) := rfl
private lemma vec4_3 : ![-1, 1, 1, 1] (3 : Fin 4) = (1 : ℝ) := rfl

theorem minkowski_lorentzian : IsLorentzian minkowskiMetric := by
  constructor
  · exact minkowski_symmetric
  · unfold IsNondegenerate minkowskiMetric
    simp only [Matrix.det_diagonal, Fin.prod_univ_four, vec4_2, vec4_3]
    norm_num
  · unfold minkowskiMetric
    simp only [Matrix.det_diagonal, Fin.prod_univ_four, vec4_2, vec4_3]
    norm_num

/-! ## Discrete Metric (metric field on lattice) -/

/-- A discrete metric assigns a metric tensor to each lattice point. -/
abbrev DiscreteMetric := LatticePoint → MetricTensor

/-- Flat spacetime: Minkowski metric everywhere. -/
noncomputable def DiscreteMetric.flat : DiscreteMetric := fun _ => minkowskiMetric

/-- Everywhere symmetric. -/
def DiscreteMetric.IsEverywhereSymmetric (g : DiscreteMetric) : Prop :=
  ∀ p, IsSymmetric (g p)

/-- Everywhere Lorentzian. -/
def DiscreteMetric.IsEverywhereLorentzian (g : DiscreteMetric) : Prop :=
  ∀ p, IsLorentzian (g p)

theorem DiscreteMetric.flat_symmetric : DiscreteMetric.flat.IsEverywhereSymmetric :=
  fun _ => minkowski_symmetric

theorem DiscreteMetric.flat_lorentzian : DiscreteMetric.flat.IsEverywhereLorentzian :=
  fun _ => minkowski_lorentzian

/-! ## Inverse Metric -/

/-- The inverse metric g^{μν}. -/
noncomputable def inverseMetric (g : MetricTensor) : MetricTensor := g⁻¹

theorem isUnit_det_of_nondegenerate (g : MetricTensor) (hnd : IsNondegenerate g) :
    IsUnit g.det := by
  rw [isUnit_iff_ne_zero]; exact hnd

theorem metric_mul_inverse (g : MetricTensor) (hnd : IsNondegenerate g) :
    g * inverseMetric g = 1 := by
  unfold inverseMetric
  exact Matrix.mul_nonsing_inv g (isUnit_det_of_nondegenerate g hnd)

theorem inverse_mul_metric (g : MetricTensor) (hnd : IsNondegenerate g) :
    inverseMetric g * g = 1 := by
  unfold inverseMetric
  exact Matrix.nonsing_inv_mul g (isUnit_det_of_nondegenerate g hnd)

theorem minkowski_inverse_self : inverseMetric minkowskiMetric = minkowskiMetric := by
  unfold inverseMetric minkowskiMetric
  apply Matrix.inv_eq_left_inv
  rw [Matrix.diagonal_mul_diagonal]
  ext i j
  simp only [Matrix.diagonal_apply, Matrix.one_apply]
  split_ifs with h <;> fin_cases i <;> norm_num

/-! ## Index Raising and Lowering -/

/-- Raise: v^μ = g^{μν} v_ν. -/
noncomputable def raiseIndex (g : MetricTensor) (v : Fin 4 → ℝ) : Fin 4 → ℝ :=
  fun μ => Finset.univ.sum fun ν => (inverseMetric g) μ ν * v ν

/-- Lower: v_μ = g_{μν} v^ν. -/
noncomputable def lowerIndex (g : MetricTensor) (v : Fin 4 → ℝ) : Fin 4 → ℝ :=
  fun μ => Finset.univ.sum fun ν => g μ ν * v ν

/-- Lower ∘ Raise = id for non-degenerate metric. -/
theorem lower_raise_identity (g : MetricTensor) (hnd : IsNondegenerate g) (v : Fin 4 → ℝ) :
    lowerIndex g (raiseIndex g v) = v := by
  have hlower : ∀ w, lowerIndex g w = g.mulVec w := fun _ => rfl
  have hraise : raiseIndex g v = (inverseMetric g).mulVec v := rfl
  rw [hlower, hraise, Matrix.mulVec_mulVec, metric_mul_inverse g hnd, Matrix.one_mulVec]

/-! ## Kronecker Delta and Contraction -/

/-- The Kronecker delta. -/
def kroneckerDelta (μ ν : Fin 4) : ℝ := if μ = ν then 1 else 0

/-- Contracting metric with inverse gives Kronecker delta. -/
theorem metric_inverse_contract (g : MetricTensor) (hnd : IsNondegenerate g)
    (μ ν : Fin 4) :
    Finset.univ.sum (fun ρ => (inverseMetric g) μ ρ * g ρ ν) = kroneckerDelta μ ν := by
  have h := inverse_mul_metric g hnd
  have := congrFun (congrFun h μ) ν
  simp only [Matrix.mul_apply, Matrix.one_apply] at this
  rw [kroneckerDelta]; exact this

/-! ## Inner Product -/

/-- Metric inner product: ⟨u, v⟩_g = g_{μν} u^μ v^ν. -/
noncomputable def metricInnerProduct (g : MetricTensor) (u v : Fin 4 → ℝ) : ℝ :=
  Finset.univ.sum fun μ =>
    Finset.univ.sum fun ν => g μ ν * u μ * v ν

/-- Inner product is symmetric for symmetric metric. -/
theorem innerProduct_symm (g : MetricTensor) (hsym : IsSymmetric g) (u v : Fin 4 → ℝ) :
    metricInnerProduct g u v = metricInnerProduct g v u := by
  unfold metricInnerProduct
  rw [Finset.sum_comm]
  congr 1; ext μ; congr 1; ext ν
  have hsym' : g μ ν = g ν μ := by
    have := congrFun (congrFun hsym ν) μ
    simp only [Matrix.transpose_apply] at this; exact this
  rw [hsym']; ring

end OmegaTheory.Geometry
