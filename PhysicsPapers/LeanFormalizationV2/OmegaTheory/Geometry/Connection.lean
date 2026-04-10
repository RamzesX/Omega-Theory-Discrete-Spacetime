/-
  OmegaTheory.Geometry.Connection

  Levi-Civita connection (Christoffel symbols) on the discrete lattice.
  Ported from V1 (0 sorry) with adaptations to V2 types.

  Defines:
  - metricDerivative: discrete partial derivative of metric
  - christoffelSymbol: Γ^ρ_{μν} via the standard formula
  - Christoffel symmetry: Γ^ρ_{μν} = Γ^ρ_{νμ}
  - covariantDeriv: ∇_ν V^μ
  - Flat Christoffel vanishing
-/

import OmegaTheory.Geometry.Metric
import OmegaTheory.Spacetime.Operators
import OmegaTheory.Spacetime.Constants
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

namespace OmegaTheory.Geometry

open OmegaTheory.Spacetime

/-! ## Metric Derivative -/

/-- Discrete partial derivative of the metric: ∂_σ g_{μν}
    Uses the symmetric (central) difference. -/
noncomputable def metricDerivative (g : DiscreteMetric) (σ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  symmetricDiff (fun q => g q μ ν) σ p

/-- Metric derivative inherits symmetry from metric symmetry.
    If g is symmetric, then ∂_σ g_{μν} = ∂_σ g_{νμ}. -/
theorem metricDerivative_symm (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (σ μ ν : Fin 4) (p : LatticePoint) :
    metricDerivative g σ μ ν p = metricDerivative g σ ν μ p := by
  unfold metricDerivative symmetricDiff
  congr 1
  have h1 := hsym (shiftFin p σ)
  have h2 := hsym (shiftBackFin p σ)
  unfold IsSymmetric at h1 h2
  have h1' := congrFun (congrFun h1 ν) μ
  have h2' := congrFun (congrFun h2 ν) μ
  simp only [Matrix.transpose_apply] at h1' h2'
  linarith

/-! ## Christoffel Symbols -/

/-- Christoffel symbol of the second kind:
    Γ^ρ_{μν} = (1/2) Σ_σ g^{ρσ} (∂_μ g_{νσ} + ∂_ν g_{μσ} - ∂_σ g_{μν}) -/
noncomputable def christoffelSymbol (g : DiscreteMetric) (ρ μ ν : Fin 4)
    (p : LatticePoint) : ℝ :=
  (1 / 2) * Finset.univ.sum fun σ =>
    (inverseMetric (g p)) ρ σ *
      (metricDerivative g μ ν σ p +
       metricDerivative g ν μ σ p -
       metricDerivative g σ μ ν p)

/-- Christoffel symbols are symmetric in the lower two indices:
    Γ^ρ_{μν} = Γ^ρ_{νμ}

    Requires metric symmetry: the third term ∂_σ g_{μν} = ∂_σ g_{νμ}
    only holds when g_{μν} = g_{νμ}. -/
theorem christoffel_symmetry (g : DiscreteMetric) (hsym : g.IsEverywhereSymmetric)
    (ρ μ ν : Fin 4) (p : LatticePoint) :
    christoffelSymbol g ρ μ ν p = christoffelSymbol g ρ ν μ p := by
  unfold christoffelSymbol
  congr 1
  apply Finset.sum_congr rfl
  intro σ _
  congr 1
  have h := metricDerivative_symm g hsym σ μ ν p
  linarith

/-- For flat (Minkowski) metric, all Christoffel symbols vanish. -/
theorem christoffel_flat (ρ μ ν : Fin 4) (p : LatticePoint) :
    christoffelSymbol DiscreteMetric.flat ρ μ ν p = 0 := by
  unfold christoffelSymbol metricDerivative DiscreteMetric.flat
  simp [symmetricDiff]

/-! ## Covariant Derivative of a Vector Field -/

/-- Covariant derivative of a vector field:
    ∇_ν V^μ = ∂_ν V^μ + Σ_ρ Γ^μ_{νρ} V^ρ -/
noncomputable def covariantDerivVector (g : DiscreteMetric)
    (V : LatticePoint → Fin 4 → ℝ) (ν μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  symmetricDiff (fun q => V q μ) ν p +
  Finset.univ.sum fun ρ => christoffelSymbol g μ ν ρ p * V p ρ

/-- Covariant derivative of a covector field:
    ∇_ν W_μ = ∂_ν W_μ - Σ_ρ Γ^ρ_{νμ} W_ρ -/
noncomputable def covariantDerivCovector (g : DiscreteMetric)
    (W : LatticePoint → Fin 4 → ℝ) (ν μ : Fin 4)
    (p : LatticePoint) : ℝ :=
  symmetricDiff (fun q => W q μ) ν p -
  Finset.univ.sum fun ρ => christoffelSymbol g ρ ν μ p * W p ρ

/-- For flat metric, covariant derivative reduces to partial derivative. -/
theorem covariantDeriv_flat_eq_partial (V : LatticePoint → Fin 4 → ℝ)
    (ν μ : Fin 4) (p : LatticePoint) :
    covariantDerivVector DiscreteMetric.flat V ν μ p =
    symmetricDiff (fun q => V q μ) ν p := by
  unfold covariantDerivVector
  simp [christoffel_flat]

end OmegaTheory.Geometry
