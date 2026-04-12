/-
  OmegaTheory.Variational.InformationGeodesics
  ==============================================

  Information Flow as Action-Minimizing Geodesics.

  Formalizes the log-barrier potential V(ρ_I) = -ln(ρ) - ln(1-ρ) that
  constrains information density to (0,1), the kinetic Lagrangian for
  information flow, and their elementary properties.

  Key result: the equilibrium ρ_I = 1/2 is a stationary point of the
  potential, and the kinetic term is nonneg by sum-of-squares.

  References:
  - ErdosLagrangianUnification.md
  - Appendix F: Information Flow Conservation
-/

import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic
import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Spacetime.Constants
import OmegaTheory.Spacetime.Operators

namespace OmegaTheory.Variational

open OmegaTheory.Spacetime

/-! ## Information Potential Energy -/

/-- The information barrier potential V(ρ_I).
    V(ρ) = -ln(ρ) - ln(1 - ρ) for ρ ∈ (0,1), else 0.
    Creates infinite cost at the boundaries, constraining density to (0,1). -/
noncomputable def informationPotentialEnergy
    (ρ_I : ScalarField) (p : LatticePoint) : ℝ :=
  let ρ := ρ_I p
  if 0 < ρ ∧ ρ < 1 then
    -Real.log ρ - Real.log (1 - ρ)
  else
    0

/-- The barrier potential is nonneg for densities in (0,1). -/
theorem potential_nonneg_interior (ρ_I : ScalarField) (p : LatticePoint)
    (h : 0 < ρ_I p ∧ ρ_I p < 1) :
    informationPotentialEnergy ρ_I p ≥ 0 := by
  unfold informationPotentialEnergy
  simp only [h, and_self, ↓reduceIte]
  have h1 : Real.log (ρ_I p) ≤ 0 := Real.log_nonpos (le_of_lt h.1) (le_of_lt h.2)
  have h2 : Real.log (1 - ρ_I p) ≤ 0 := by
    apply Real.log_nonpos <;> linarith
  linarith

/-! ## Potential Derivative and Equilibrium -/

/-- Derivative of the barrier potential: V'(ρ) = -1/ρ + 1/(1-ρ). -/
noncomputable def potentialDerivative (ρ : ℝ) : ℝ :=
  if 0 < ρ ∧ ρ < 1 then
    -1 / ρ + 1 / (1 - ρ)
  else
    0

/-- At equilibrium ρ = 1/2, the derivative vanishes. -/
theorem potential_equilibrium_at_half :
    potentialDerivative (1 / 2) = 0 := by
  unfold potentialDerivative
  simp only [show (0 : ℝ) < 1 / 2 ∧ (1 / 2 : ℝ) < 1 by norm_num, ↓reduceIte]
  norm_num

/-- The equilibrium density is the constant field ρ = 1/2. -/
noncomputable def equilibriumDensity : ScalarField := fun _ => 1 / 2

/-- Equilibrium density is stationary under the potential. -/
theorem equilibrium_is_stationary (p : LatticePoint) :
    potentialDerivative (equilibriumDensity p) = 0 := by
  unfold equilibriumDensity
  exact potential_equilibrium_at_half

/-! ## Information Lagrangian Density -/

/-- Information Lagrangian: L = (1/2)|∇ρ_I|² - V(ρ_I).
    Kinetic (gradient-squared) minus potential (log-barrier). -/
noncomputable def informationLagrangianDensity
    (ρ_I : ScalarField) (p : LatticePoint) : ℝ :=
  let gradSquared := Finset.univ.sum fun μ : Fin 4 =>
    (symmetricDiff ρ_I μ p) ^ 2
  let potential := informationPotentialEnergy ρ_I p
  (1 / 2 : ℝ) * gradSquared - potential

/-- The kinetic (gradient-squared) term is nonneg by sum-of-squares. -/
theorem kinetic_term_nonneg (ρ_I : ScalarField) (p : LatticePoint) :
    Finset.univ.sum (fun μ : Fin 4 => (symmetricDiff ρ_I μ p) ^ 2) ≥ 0 := by
  apply Finset.sum_nonneg
  intro μ _
  exact sq_nonneg _

/-! ## Information Path and Action -/

/-- An information path: a time-parameterized family of scalar fields. -/
structure InformationPath where
  density : ℝ → ScalarField
  τ_start : ℝ
  τ_end : ℝ
  duration_pos : τ_start < τ_end

/-- Duration of an information path. -/
noncomputable def InformationPath.duration (path : InformationPath) : ℝ :=
  path.τ_end - path.τ_start

/-- Duration is positive. -/
theorem InformationPath.duration_pos' (path : InformationPath) :
    path.duration > 0 := by
  unfold duration
  linarith [path.duration_pos]

/-- Discrete information action: sum of Lagrangian over time and space samples. -/
noncomputable def discreteInformationAction
    (path : InformationPath)
    (timeSamples : Finset ℝ)
    (spaceSamples : Finset LatticePoint)
    (δ_τ : ℝ) : ℝ :=
  timeSamples.sum fun τ =>
    spaceSamples.sum fun p =>
      informationLagrangianDensity (path.density τ) p * δ_τ * (l_P ^ 3)

/-- An information geodesic minimizes the action over all variations
    with fixed endpoints. -/
def isInformationGeodesic (path : InformationPath) : Prop :=
  ∀ (variation : InformationPath),
    variation.τ_start = path.τ_start →
    variation.τ_end = path.τ_end →
    variation.density path.τ_start = path.density path.τ_start →
    variation.density path.τ_end = path.density path.τ_end →
    ∀ (timeSamples : Finset ℝ) (spaceSamples : Finset LatticePoint) (δ_τ : ℝ),
      discreteInformationAction path timeSamples spaceSamples δ_τ ≤
      discreteInformationAction variation timeSamples spaceSamples δ_τ

/-! ## Kinetic and Healing Potentials -/

/-- Total kinetic potential over a set of lattice points. -/
noncomputable def kineticPotential
    (ρ_I : ScalarField) (points : Finset LatticePoint) : ℝ :=
  points.sum fun p =>
    (1 / 2 : ℝ) * Finset.univ.sum (fun μ : Fin 4 => (symmetricDiff ρ_I μ p) ^ 2)

/-- Kinetic potential is nonneg. -/
theorem kineticPotential_nonneg (ρ_I : ScalarField) (points : Finset LatticePoint) :
    kineticPotential ρ_I points ≥ 0 := by
  unfold kineticPotential
  apply Finset.sum_nonneg
  intro p _
  apply mul_nonneg (by norm_num : (1 / 2 : ℝ) ≥ 0)
  apply Finset.sum_nonneg
  intro μ _
  exact sq_nonneg _

/-- Overdamped information flow: ∂_t ρ = D · Δρ. -/
noncomputable def overdampedInfoFlow (ρ_I : ScalarField)
    (D : ℝ) (p : LatticePoint) : ℝ :=
  D * discreteLaplacian ρ_I p

/-- Healing flow with potential drive: ∂_t ρ = D · Δρ + V'(ρ). -/
noncomputable def healingFlowRate (ρ_I : ScalarField)
    (D : ℝ) (p : LatticePoint) : ℝ :=
  D * discreteLaplacian ρ_I p + potentialDerivative (ρ_I p)

end OmegaTheory.Variational
