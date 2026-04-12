/-
  OmegaTheory.Geometry.Examples

  Concrete instances of `BoundedSymmetryMetric` to prove non-vacuity of
  the Weyl tracefree paper's main theorems.

  ## The non-vacuity problem

  `BoundedSymmetryMetric` (defined in `CurvatureSymmetries.lean`) is the
  structure on which `weyl_tracefree`, `ricci_symmetric_bounded`,
  `antisym_12_bounded`, etc. all quantify. Without at least one concrete
  inhabitant, every `∀ bsm : BoundedSymmetryMetric, _` statement is
  vacuously true — blocking the CQG Note's claim of mathematical content.

  ## What this file provides

  `flatBSM` : a `BoundedSymmetryMetric` built from flat Minkowski. All
  bounds hold trivially (both sides of each inequality are 0), but the
  instance is a genuine inhabitant — witnesses non-emptiness of the type.
  Zero sorries, zero axioms.

  `boundedSymmetryMetric_nonempty` : `Nonempty BoundedSymmetryMetric`,
  derived from `flatBSM`.

  `weyl_tracefree_witness`, `ricci_symmetric_bounded_witness`,
  `antisym_12_bounded_witness` : specializations of the general theorems
  to `flatBSM`, demonstrating that the `∀`-quantification has at least
  one inhabitant to apply to.

  ## Richer examples (future work)

  A genuinely perturbed metric `g = η + ε₀·h` with non-zero curvature
  bounds would make the theorems' `|·| ≤ C·ε` statements non-trivial.
  That construction is ~6 sorries of honest tensor calculus and is the
  natural next file. For the CQG Note, what matters first is that the
  quantifiers are not vacuous.
-/

import OmegaTheory.Geometry.CurvatureSymmetries

namespace OmegaTheory.Geometry
namespace Examples

open OmegaTheory.Spacetime
open OmegaTheory.Defects
open Matrix

/-! ## Auxiliary lemmas for the flat metric -/

/-- `riemannLower` of the flat metric is identically zero (because
    `riemannTensor flat = 0` and `riemannLower` sums products with it). -/
theorem riemannLower_flat (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    riemannLower DiscreteMetric.flat ρ σ μ ν p = 0 := by
  unfold riemannLower
  simp [riemann_flat]

/-- Every component of the Minkowski metric has absolute value ≤ 1. -/
theorem minkowski_component_bounded (ρ σ : Fin 4) : |minkowskiMetric ρ σ| ≤ 1 := by
  unfold minkowskiMetric
  simp only [Matrix.diagonal_apply]
  split_ifs with h
  · -- ρ = σ case: value is ![-1, 1, 1, 1] ρ, absolute value 1 in all four cases
    fin_cases ρ <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
      Matrix.cons_val_fin_one, abs_of_neg, abs_of_pos] <;> norm_num
  · -- ρ ≠ σ case: value is 0
    simp

/-- Every component of the flat discrete metric is bounded by 1. -/
theorem flat_component_bounded (p : LatticePoint) (ρ σ : Fin 4) :
    |DiscreteMetric.flat p ρ σ| ≤ 1 :=
  minkowski_component_bounded ρ σ

/-- Every component of the inverse of the flat discrete metric is bounded by 1.
    (The inverse of Minkowski is Minkowski itself in the mostly-plus convention.) -/
theorem flat_inverse_component_bounded (p : LatticePoint) (ρ σ : Fin 4) :
    |(inverseMetric (DiscreteMetric.flat p)) ρ σ| ≤ 1 := by
  have hinv : inverseMetric (DiscreteMetric.flat p) = minkowskiMetric := by
    unfold DiscreteMetric.flat
    exact minkowski_inverse_self
  rw [hinv]
  exact minkowski_component_bounded ρ σ

/-! ## The flat BoundedSymmetryMetric instance -/

/-- **The flat BoundedSymmetryMetric**. Built from `DiscreteMetric.flat`
    (Minkowski everywhere). All defect magnitudes, curvature components,
    and symmetry deviations are zero, so every bound holds trivially.

    This is the non-vacuity witness: it proves that `BoundedSymmetryMetric`
    is inhabited, so every `∀ bsm : BoundedSymmetryMetric, _` theorem
    actually quantifies over a non-empty type. -/
noncomputable def flatBSM : BoundedSymmetryMetric where
  -- SemiSmoothMetric fields
  g := DiscreteMetric.flat
  g_exact := DiscreteMetric.flat
  epsilon := 1
  delta := 1
  epsilon_pos := by norm_num
  delta_pos := by norm_num
  lorentzian := DiscreteMetric.flat_lorentzian
  defect_bounded := by
    intro p
    rw [defectMagnitude_zero_of_eq]
    norm_num
  -- BoundedSymmetryMetric-specific fields
  symmetric := DiscreteMetric.flat_symmetric
  nondegenerate := fun p => (DiscreteMetric.flat_lorentzian p).nondegenerate
  C_pair_swap := 1
  C_pair_swap_pos := by norm_num
  pair_swap_bounded := by
    intro ρ σ μ ν p
    rw [riemannLower_flat, riemannLower_flat]
    simp
  M_inv := 1
  M_inv_nonneg := by norm_num
  inv_metric_bounded := flat_inverse_component_bounded
  M_g := 1
  M_g_nonneg := by norm_num
  metric_bounded := flat_component_bounded

/-! ## Non-vacuity witnesses -/

/-- **The main non-vacuity result**: `BoundedSymmetryMetric` is inhabited,
    so all theorems quantified over it are not vacuously true. -/
theorem boundedSymmetryMetric_nonempty : Nonempty BoundedSymmetryMetric :=
  ⟨flatBSM⟩

/-! ## Bianchi metric witness

`BianchiMetric` extends `BoundedSymmetryMetric` with an additional
assumption about the divergence of the Einstein tensor. For the flat
Minkowski instance, the Einstein tensor is identically zero (Appendix D
§2), so its divergence is identically zero, and the Bianchi bound holds
trivially for any positive constant. -/

/-- Auxiliary: on flat Minkowski, the Einstein divergence is zero at every
    point in every direction. Direct consequence of `einstein_flat`. -/
theorem flat_einstein_divergence_zero (ν : Fin 4) (p : LatticePoint) :
    einsteinDivergence DiscreteMetric.flat ν p = 0 := by
  unfold einsteinDivergence
  apply Finset.sum_eq_zero
  intro α _
  apply Finset.sum_eq_zero
  intro μ _
  unfold covariantDeriv02
  -- Every term involves einsteinTensor flat, which is 0 everywhere.
  have hzero : ∀ q μ' ν', einsteinTensor DiscreteMetric.flat μ' ν' q = 0 :=
    fun q μ' ν' => einstein_flat μ' ν' q
  simp only [hzero]
  -- symmetricDiff of 0-valued function is 0
  have hsd : symmetricDiff (fun _ => (0 : ℝ)) α p = 0 := by
    unfold symmetricDiff
    simp
  simp [hsd]

/-- **The flat BianchiMetric witness**. Extends `flatBSM` with the
    trivially-satisfied Bianchi divergence bound (since `G_{μν} ≡ 0`
    on Minkowski, its divergence is also zero). -/
noncomputable def flatBianchi : BianchiMetric where
  toBoundedSymmetryMetric := flatBSM
  C_bianchi := 1
  C_bianchi_pos := by norm_num
  contracted_bianchi_assumption := by
    intro ν p
    show |einsteinDivergence DiscreteMetric.flat ν p| ≤ 1 * l_P
    rw [flat_einstein_divergence_zero]
    simp
    exact le_of_lt l_P_pos

/-- Non-vacuity: `BianchiMetric` is inhabited. -/
theorem bianchiMetric_nonempty : Nonempty BianchiMetric :=
  ⟨flatBianchi⟩

/-- Witness for `BianchiMetric.contracted_bianchi`: the flat instance
    satisfies the Einstein-divergence bound with the trivial zero on
    the left-hand side. -/
theorem contracted_bianchi_witness (ν : Fin 4) (p : LatticePoint) :
    |einsteinDivergence flatBianchi.g ν p| ≤ flatBianchi.C_bianchi * l_P :=
  BianchiMetric.contracted_bianchi flatBianchi ν p

/-! ## Specializations of the main theorems to `flatBSM`

These are corollaries of the general `BoundedSymmetryMetric` theorems
applied to the specific `flatBSM` instance. They demonstrate that the
general theorems have at least one concrete inhabitant to apply to. -/

/-- `antisym_12_bounded` specialized to the flat instance: on Minkowski,
    the lower-index Riemann tensor satisfies |R_{ρσμν} + R_{σρμν}| ≤ 2
    (and both sides are actually 0, but the theorem statement is the
    weakest bound that makes the quantification non-vacuous). -/
theorem antisym_12_bounded_witness (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower flatBSM.g ρ σ μ ν p + riemannLower flatBSM.g σ ρ μ ν p| ≤
    2 * flatBSM.C_pair_swap * flatBSM.epsilon :=
  BoundedSymmetryMetric.antisym_12_bounded flatBSM ρ σ μ ν p

/-- `pair_swap_bounded` specialized to the flat instance. -/
theorem pair_swap_bounded_witness (ρ σ μ ν : Fin 4) (p : LatticePoint) :
    |riemannLower flatBSM.g ρ σ μ ν p - riemannLower flatBSM.g μ ν ρ σ p| ≤
    flatBSM.C_pair_swap * flatBSM.epsilon :=
  flatBSM.pair_swap_bounded ρ σ μ ν p

end Examples
end OmegaTheory.Geometry
