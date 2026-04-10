/-
  OmegaTheory.Torsion.Torsion

  Einstein-Cartan torsion integrated with V2's error-propagating framework.

  Key V2 innovation: torsion EMERGES from the DefectTensor.
  At defect sites, discrete derivatives fail to commute, producing
  an antisymmetric connection component = torsion.

  S^λ_{μν} = (1/2)(Γ^λ_{μν} - Γ^λ_{νμ}) = f(D_{μν})

  The error bound on torsion propagates from SemiSmoothMetric.epsilon:
  |S| ≤ ε / l_P when defects are bounded by ε.

  Based on Poplawski's Einstein-Cartan cosmology (2010, 2016).
-/

import OmegaTheory.Geometry.Connection
import OmegaTheory.Geometry.Curvature
import OmegaTheory.Defects.DefectTensor
import OmegaTheory.Foundations.ErrorAlgebra
import Mathlib.Tactic

namespace OmegaTheory.Torsion

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects
open OmegaTheory.Foundations

/-! ## Torsion Tensor -/

/-- The torsion tensor: antisymmetric part of a general connection.
    S^λ_{μν} = (1/2)(Γ^λ_{μν} - Γ^λ_{νμ}) -/
noncomputable def torsionTensor (Gamma : Fin 4 → Fin 4 → Fin 4 → LatticePoint → ℝ)
    (l μ ν : Fin 4) (p : LatticePoint) : ℝ :=
  (1 / 2 : ℝ) * (Gamma l μ ν p - Gamma l ν μ p)

/-- Torsion is antisymmetric: S^λ_{μν} = -S^λ_{νμ}. -/
theorem torsion_antisymmetric (Gamma : Fin 4 → Fin 4 → Fin 4 → LatticePoint → ℝ)
    (l μ ν : Fin 4) (p : LatticePoint) :
    torsionTensor Gamma l μ ν p = -torsionTensor Gamma l ν μ p := by
  unfold torsionTensor; ring

/-- For the Levi-Civita connection, torsion vanishes (torsion-free). -/
theorem leviCivita_torsion_free (g : DiscreteMetric)
    (hsym : g.IsEverywhereSymmetric) (l μ ν : Fin 4) (p : LatticePoint) :
    torsionTensor (fun a b c q => christoffelSymbol g a b c q) l μ ν p = 0 := by
  unfold torsionTensor
  show 1 / 2 * (christoffelSymbol g l μ ν p - christoffelSymbol g l ν μ p) = 0
  rw [christoffel_symmetry g hsym l μ ν p]; ring

/-! ## Contorsion and Einstein-Cartan Connection -/

/-- Contorsion tensor: K^λ_{μν} = S^λ_{μν} + S_{μ}^{.λ}_{.ν} + S_{ν}^{.λ}_{.μ}.
    Relates torsion to the difference between full and Levi-Civita connections. -/
noncomputable def contorsionTensor (S : Fin 4 → Fin 4 → Fin 4 → LatticePoint → ℝ)
    (g : DiscreteMetric) (l μ ν : Fin 4) (p : LatticePoint) : ℝ :=
  S l μ ν p +
  Finset.univ.sum (fun α => (inverseMetric (g p)) l α *
    (Finset.univ.sum (fun β => (g p) μ β * S β α ν p))) +
  Finset.univ.sum (fun α => (inverseMetric (g p)) l α *
    (Finset.univ.sum (fun β => (g p) ν β * S β α μ p)))

/-- Einstein-Cartan connection = Levi-Civita + contorsion. -/
noncomputable def einsteinCartanConnection (g : DiscreteMetric)
    (S : Fin 4 → Fin 4 → Fin 4 → LatticePoint → ℝ)
    (l μ ν : Fin 4) (p : LatticePoint) : ℝ :=
  christoffelSymbol g l μ ν p + contorsionTensor S g l μ ν p

/-! ## Emergent Torsion from Defects (V2 INNOVATION)

In V2, torsion EMERGES from metric defects. At defect sites,
the actual metric differs from the exact metric, producing an
effective antisymmetric connection component.

S^λ_{μν}(p) ~ (1/2l_P) · (D_{μλ}(p) - D_{νλ}(p))

This is the Torsion-Defect Correspondence from Appendix P. -/

/-- Emergent torsion from a semi-smooth metric's defect tensor.
    Torsion arises from the antisymmetric part of the defect. -/
noncomputable def emergentTorsion (ssm : SemiSmoothMetric)
    (l μ ν : Fin 4) (p : LatticePoint) : ℝ :=
  (1 / (2 * l_P)) * (ssm.defectAt p μ l - ssm.defectAt p ν l)

/-- Emergent torsion is antisymmetric. -/
theorem emergentTorsion_antisymmetric (ssm : SemiSmoothMetric)
    (l μ ν : Fin 4) (p : LatticePoint) :
    emergentTorsion ssm l μ ν p = -emergentTorsion ssm l ν μ p := by
  unfold emergentTorsion; ring

/-- Emergent torsion vanishes when there are no defects (g = g_exact). -/
theorem emergentTorsion_zero_of_no_defect (ssm : SemiSmoothMetric)
    (hD : ∀ p μ ν, ssm.g p μ ν - ssm.g_exact p μ ν = 0)
    (l μ ν : Fin 4) (p : LatticePoint) :
    emergentTorsion ssm l μ ν p = 0 := by
  unfold emergentTorsion SemiSmoothMetric.defectAt defectTensor
  rw [hD p μ l, hD p ν l]; ring

/-- Emergent torsion is bounded by ε/l_P when defects are bounded by ε.
    |S^λ_{μν}| ≤ ε/l_P. -/
theorem emergentTorsion_bounded (ssm : SemiSmoothMetric)
    (l μ ν : Fin 4) (p : LatticePoint) :
    |emergentTorsion ssm l μ ν p| ≤ ssm.epsilon / l_P := by
  unfold emergentTorsion
  have h1 := ssm.component_bounded p μ l
  have h2 := ssm.component_bounded p ν l
  have h_lp_pos : (0 : ℝ) < 2 * l_P := mul_pos two_pos l_P_pos
  -- Triangle inequality: |a - b| ≤ |a| + |b|
  have h_tri : |ssm.defectAt p μ l - ssm.defectAt p ν l| ≤ 2 * ssm.epsilon :=
    (abs_sub (ssm.defectAt p μ l) (ssm.defectAt p ν l)).trans (by linarith)
  -- |c * x| where c = 1/(2l_P) > 0
  have hc : (0 : ℝ) < 1 / (2 * l_P) := by positivity
  calc |1 / (2 * l_P) * (ssm.defectAt p μ l - ssm.defectAt p ν l)|
      = 1 / (2 * l_P) * |ssm.defectAt p μ l - ssm.defectAt p ν l| := by
        rw [abs_mul, abs_of_pos hc]
    _ ≤ 1 / (2 * l_P) * (2 * ssm.epsilon) := by
        apply mul_le_mul_of_nonneg_left h_tri (le_of_lt hc)
    _ = ssm.epsilon / l_P := by field_simp

/-! ## Torsion Pressure (Poplawski)

Torsion generates a repulsive pressure that prevents singularities.
P_torsion = -(πG ℏ²/c²) · n² where n is fermion density.
This is always NEGATIVE (repulsive). -/

/-- Torsion pressure from fermion density.
    P = -(πG ℏ²/c²) · n² -/
noncomputable def torsionPressure (fermionDensity : ℝ) : ℝ :=
  -(Real.pi * G_N * hbar ^ 2 / c ^ 2) * fermionDensity ^ 2

/-- Torsion pressure is negative (repulsive) for nonzero fermion density. -/
theorem torsionPressure_negative (n : ℝ) (hn : n ≠ 0) :
    torsionPressure n < 0 := by
  unfold torsionPressure
  have h1 : 0 < Real.pi * G_N * hbar ^ 2 / c ^ 2 :=
    div_pos (mul_pos (mul_pos Real.pi_pos G_N_pos) (sq_pos_of_pos hbar_pos))
      (sq_pos_of_pos c_pos)
  have h2 : 0 < n ^ 2 := sq_pos_of_ne_zero hn
  nlinarith

/-- Bounce density: ρ_bounce = c⁵/(G²ℏ). The Planck density. -/
noncomputable def bounceDensity : ℝ := c ^ 5 / (G_N ^ 2 * hbar)

/-- Bounce density is positive. -/
theorem bounceDensity_pos : 0 < bounceDensity := by
  unfold bounceDensity
  apply div_pos
  · exact pow_pos c_pos 5
  · exact mul_pos (sq_pos_of_pos G_N_pos) hbar_pos

end OmegaTheory.Torsion
