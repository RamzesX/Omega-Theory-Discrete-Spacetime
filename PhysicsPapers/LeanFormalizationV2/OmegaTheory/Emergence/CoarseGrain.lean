/-
  OmegaTheory.Emergence.CoarseGrain

  Coarse graining: averaging the discrete metric over a region.
  This is how the discrete lattice "looks smooth" at large scales.
-/

import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects

/-! ## Coarse-Grained Metric -/

/-- The coarse-grained metric: average g over a finite region. -/
noncomputable def coarseGrainedMetric (g : DiscreteMetric)
    (region : Finset LatticePoint) (μ ν : Fin 4) : ℝ :=
  (region.sum fun q => g q μ ν) / region.card

/-- The coarse-grained defect: average of pointwise defects. -/
noncomputable def coarseGrainedDefect (g g_exact : DiscreteMetric)
    (region : Finset LatticePoint) (μ ν : Fin 4) : ℝ :=
  (region.sum fun q => g q μ ν - g_exact q μ ν) / region.card

/-! ## Defect Bound Under Coarse Graining -/

/-- If every |f(p)| ≤ B and B ≥ 0, then |Σf / N| ≤ B.
    The average of bounded values is bounded. -/
theorem avg_le_max (region : Finset LatticePoint) (hne : region.Nonempty)
    (f : LatticePoint → ℝ) (B : ℝ) (hB : 0 ≤ B)
    (hbnd : ∀ p ∈ region, |f p| ≤ B) :
    |(region.sum f) / region.card| ≤ B := by
  have hcard : (0 : ℝ) < region.card := Nat.cast_pos.mpr (Finset.Nonempty.card_pos hne)
  rw [abs_div, abs_of_pos hcard]
  rw [div_le_iff₀ hcard]
  calc |region.sum f|
      ≤ region.sum (fun p => |f p|) := by
          apply Finset.abs_sum_le_sum_abs
    _ ≤ region.sum (fun _ => B) := Finset.sum_le_sum (fun p hp => hbnd p hp)
    _ = B * region.card := by simp [Finset.sum_const, nsmul_eq_mul, mul_comm]

/-- The coarse-grained defect of a semi-smooth metric is bounded by ε. -/
theorem coarseGrainedDefect_bounded (ssm : SemiSmoothMetric)
    (region : Finset LatticePoint) (hne : region.Nonempty)
    (μ ν : Fin 4) :
    |coarseGrainedDefect ssm.g ssm.g_exact region μ ν| ≤ ssm.epsilon := by
  unfold coarseGrainedDefect
  exact avg_le_max region hne _ ssm.epsilon ssm.epsilon_nonneg
    (fun p _ => ssm.component_bounded p μ ν)

/-! ## Scale-Dependent Smoothness -/

/-- A metric is ε-smooth at a given region if the coarse-grained defect ≤ ε. -/
def IsEpsilonSmooth (g g_exact : DiscreteMetric)
    (region : Finset LatticePoint) (epsilon : ℝ) : Prop :=
  ∀ μ ν, ∀ hne : region.Nonempty,
    |coarseGrainedDefect g g_exact region μ ν| ≤ epsilon

/-- Every semi-smooth metric is ε-smooth at any non-empty region. -/
theorem semiSmooth_is_epsilonSmooth (ssm : SemiSmoothMetric)
    (region : Finset LatticePoint) :
    IsEpsilonSmooth ssm.g ssm.g_exact region ssm.epsilon :=
  fun μ ν hne => coarseGrainedDefect_bounded ssm region hne μ ν

end OmegaTheory.Emergence
