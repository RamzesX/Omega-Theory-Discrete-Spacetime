/-
  OmegaTheory.HealingFlow.Flow

  The healing flow PDE: ∂g/∂τ = -δF/δg.

  This is a gradient flow — the metric evolves to minimize the
  healing functional F[g]. The three terms produce:
  - μΔg: geometric smoothing (like Ricci flow)
  - -λD: direct defect elimination
  - -γ(I-Ī)δI/δg: information equalization
-/

import OmegaTheory.HealingFlow.Functional

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Metric Evolution -/

/-- A discrete metric path: a one-parameter family of metrics g(τ).
    τ is the "healing time" parameter. -/
def MetricPath := ℝ → DiscreteMetric

/-- The rate of change of the metric at healing time τ.
    Approximated as finite difference: (g(τ+δ) - g(τ)) / δ. -/
noncomputable def metricRate (path : MetricPath) (tau delta_tau : ℝ)
    (p : LatticePoint) (μ ν : Fin 4) : ℝ :=
  (path (tau + delta_tau) p μ ν - path tau p μ ν) / delta_tau

/-! ## Healing Flow Equation

Discrete gradient flow with step size `delta_tau`:

  g(τ+δτ) = g(τ) + δτ · (μΔg − λD − γ(I−Ī))

The right-hand side is −δF/δg at g(τ), so this is forward-Euler gradient
descent on the healing functional. (The `∂I/∂g^{μν}` factor from Appendix D
§5 is absorbed into γ — V2 treats the information field as exogenous.)

Unlike the previous `∃ x, x = expr` scaffold, this structure imposes a
genuine equation on `path` and is consumed below by bridge theorems in
`Lyapunov.lean`. -/

/-- A discrete healing flow with step size `delta_tau`. -/
structure IsHealingFlow (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I_field : ℝ → InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ) : Prop where
  /-- The time step is positive. -/
  step_pos : 0 < delta_tau
  /-- Forward Euler gradient descent equation. -/
  gradient_step : ∀ tau p μ ν,
    path (tau + delta_tau) p μ ν =
    path tau p μ ν + delta_tau * (
      params.mu * discreteLaplacian (fun q => path tau q μ ν) p
      - params.lambda * defectTensor (path tau) g_exact p μ ν
      - params.gamma * (I_field tau p - I_bar))

/-! ## Equilibrium -/

/-- A metric is at healing equilibrium when the flow rate vanishes:
    δF/δg = 0, meaning the functional derivative is zero. -/
structure IsHealingEquilibrium (params : HealingParams)
    (g : DiscreteMetric) (g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ) : Prop where
  /-- At equilibrium: μΔg = λD + γ(I-Ī)·δI/δg.
      The smoothing term balances defect repair and info equalization. -/
  balance : ∀ p μ ν,
    params.mu * discreteLaplacian (fun q => g q μ ν) p =
    params.lambda * defectTensor g g_exact p μ ν +
    params.gamma * (I p - I_bar)

/-- At equilibrium with zero defects and uniform information,
    the Laplacian of the metric vanishes. -/
theorem equilibrium_flat_laplacian (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (heq : IsHealingEquilibrium params g g_exact I I_bar)
    (hD : ∀ p μ ν, defectTensor g g_exact p μ ν = 0)
    (hI : ∀ p, I p = I_bar) (p : LatticePoint) (μ ν : Fin 4) :
    discreteLaplacian (fun q => g q μ ν) p = 0 := by
  have h := heq.balance p μ ν
  simp only [hD, hI, sub_self, mul_zero, add_zero] at h
  -- h : params.mu * discreteLaplacian ... = 0, and mu ≠ 0
  exact (mul_eq_zero.mp h).resolve_left (ne_of_gt params.mu_pos)

end OmegaTheory.HealingFlow
