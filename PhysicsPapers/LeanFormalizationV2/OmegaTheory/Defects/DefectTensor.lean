/-
  OmegaTheory.Defects.DefectTensor

  Metric defects: D_μν = g_actual - g_exact.
  This is where the error tower meets the geometry tower.

  A SemiSmoothMetric is the central structure: a discrete metric with
  bounded, sparse defects — "not smooth but feels smooth."
-/

import OmegaTheory.Geometry.Metric
import OmegaTheory.Foundations.ErrorAlgebra
import OmegaTheory.Spacetime.Constants
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Defects

open OmegaTheory.Geometry
open OmegaTheory.Spacetime
open OmegaTheory.Foundations

/-! ## Defect Tensor -/

/-- The defect tensor D_μν(p) = g_actual(p) - g_exact(p).
    Measures how much the actual discrete metric deviates from the ideal. -/
noncomputable def defectTensor (g_actual g_exact : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  g_actual p μ ν - g_exact p μ ν

/-- Defect magnitude squared at a point (Frobenius norm squared). -/
noncomputable def defectMagnitudeSq (g_actual g_exact : DiscreteMetric)
    (p : LatticePoint) : ℝ :=
  Finset.univ.sum fun μ =>
    Finset.univ.sum fun ν =>
      (defectTensor g_actual g_exact p μ ν) ^ 2

/-- Defect magnitude (Frobenius norm). -/
noncomputable def defectMagnitude (g_actual g_exact : DiscreteMetric)
    (p : LatticePoint) : ℝ :=
  Real.sqrt (defectMagnitudeSq g_actual g_exact p)

/-- Defect magnitude squared is nonneg. -/
theorem defectMagnitudeSq_nonneg (g_actual g_exact : DiscreteMetric)
    (p : LatticePoint) : 0 ≤ defectMagnitudeSq g_actual g_exact p := by
  unfold defectMagnitudeSq
  apply Finset.sum_nonneg; intro μ _
  apply Finset.sum_nonneg; intro ν _
  exact sq_nonneg _

/-- Defect magnitude is nonneg. -/
theorem defectMagnitude_nonneg (g_actual g_exact : DiscreteMetric)
    (p : LatticePoint) : 0 ≤ defectMagnitude g_actual g_exact p :=
  Real.sqrt_nonneg _

/-- Zero defect when metrics agree. -/
theorem defectMagnitudeSq_zero_of_eq (g : DiscreteMetric) (p : LatticePoint) :
    defectMagnitudeSq g g p = 0 := by
  unfold defectMagnitudeSq defectTensor
  simp [sub_self]

/-- Zero defect magnitude when metrics agree. -/
theorem defectMagnitude_zero_of_eq (g : DiscreteMetric) (p : LatticePoint) :
    defectMagnitude g g p = 0 := by
  unfold defectMagnitude
  rw [defectMagnitudeSq_zero_of_eq]
  simp

/-! ## Semi-Smooth Metric -/

/-- An (ε,δ)-semi-smooth metric: a discrete metric where defects are
    bounded and sparse. This is the central structure connecting
    error tracking to geometry.

    "Not smooth but feels smooth with bounded irregularities." -/
structure SemiSmoothMetric where
  /-- The actual discrete metric (with computational errors). -/
  g : DiscreteMetric
  /-- The reference exact metric (infinite-precision ideal). -/
  g_exact : DiscreteMetric
  /-- Maximum pointwise defect magnitude. -/
  epsilon : ℝ
  /-- Defect site fraction bound. -/
  delta : ℝ
  /-- ε > 0. -/
  epsilon_pos : 0 < epsilon
  /-- δ > 0. -/
  delta_pos : 0 < delta
  /-- The actual metric is everywhere Lorentzian. -/
  lorentzian : g.IsEverywhereLorentzian
  /-- Every defect is bounded by ε. -/
  defect_bounded : ∀ p, defectMagnitude g g_exact p ≤ epsilon

namespace SemiSmoothMetric

/-- ε is nonneg. -/
theorem epsilon_nonneg (ssm : SemiSmoothMetric) : 0 ≤ ssm.epsilon :=
  le_of_lt ssm.epsilon_pos

/-- δ is nonneg. -/
theorem delta_nonneg (ssm : SemiSmoothMetric) : 0 ≤ ssm.delta :=
  le_of_lt ssm.delta_pos

/-- The defect tensor at each point. -/
noncomputable def defectAt (ssm : SemiSmoothMetric) (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  defectTensor ssm.g ssm.g_exact p μ ν

/-- Each component of the defect is bounded by the defect magnitude. -/
theorem component_sq_le_magnitudeSq (g_actual g_exact : DiscreteMetric)
    (p : LatticePoint) (μ ν : Fin 4) :
    (defectTensor g_actual g_exact p μ ν) ^ 2 ≤
    defectMagnitudeSq g_actual g_exact p := by
  unfold defectMagnitudeSq
  -- The single term D_μν² appears in the double sum Σ_α Σ_β D_αβ²
  calc (defectTensor g_actual g_exact p μ ν) ^ 2
      ≤ Finset.univ.sum fun β => (defectTensor g_actual g_exact p μ β) ^ 2 := by
        apply Finset.single_le_sum (fun β _ => sq_nonneg _) (Finset.mem_univ ν)
    _ ≤ Finset.univ.sum fun α => Finset.univ.sum fun β =>
          (defectTensor g_actual g_exact p α β) ^ 2 := by
        apply Finset.single_le_sum (fun α _ => Finset.sum_nonneg fun β _ => sq_nonneg _)
          (Finset.mem_univ μ)

/-- Each component of the defect is bounded by ε.
    |D_μν| ≤ |D| ≤ ε. -/
theorem component_bounded (ssm : SemiSmoothMetric) (p : LatticePoint) (μ ν : Fin 4) :
    |defectAt ssm p μ ν| ≤ ssm.epsilon := by
  have h_bound := ssm.defect_bounded p
  have h_sq := component_sq_le_magnitudeSq ssm.g ssm.g_exact p μ ν
  -- |x| = √(x²), then √(x²) ≤ √(Σ D²) = defectMagnitude ≤ ε
  rw [← Real.sqrt_sq_eq_abs]
  exact (Real.sqrt_le_sqrt h_sq).trans h_bound

/-- The defect as an ErrorBound. -/
noncomputable def defectErrorBound (ssm : SemiSmoothMetric) : ErrorBound :=
  ⟨ssm.epsilon, ssm.epsilon_nonneg⟩

end SemiSmoothMetric

end OmegaTheory.Defects
