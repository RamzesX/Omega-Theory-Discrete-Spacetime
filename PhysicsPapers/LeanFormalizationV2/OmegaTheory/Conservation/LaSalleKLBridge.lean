/-
  OmegaTheory.Conservation.LaSalleKLBridge

  **Bridge: LaSalle equilibrium ⇒ KL information conservation.**

  Ties `HealingFlow/LaSalle.lean` (discrete LaSalle invariance principle for
  the healing functional) to `Conservation/InformationKLBridge.lean` (exact
  conservation of the KL gradient current on flat Minkowski).

  Headlines:
  1. `flat_is_healing_equilibrium_for_uniform_info` — `DiscreteMetric.flat`
     is at healing equilibrium when `I = Ī` pointwise.
  2. `informationDensityKL_constant_along_equilibrium_trajectory` — with
     static info, the KL density is pointwise time-independent along an
     equilibrium trajectory.
  3. `informationKLCurrent_conserved_on_flat_equilibrium_trajectory` — the
     KL gradient current is exactly conserved at every discrete step of a
     trajectory started at flat Minkowski with uniform static info.
  4. `total_informationKL_constant_along_equilibrium_trajectory` — the
     discrete-second-law degenerate case: equilibrium produces no entropy
     flux, so regional KL totals are constant.

  No `sorry`.  No new axioms.  Agent: team-lead (v2-apr15-lean), 2026-04-15.
-/

import OmegaTheory.HealingFlow.LaSalle
import OmegaTheory.Conservation.InformationKLBridge

namespace OmegaTheory.Conservation

open OmegaTheory.HealingFlow
open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Defects

/-! ## Flat Minkowski is an equilibrium for uniform info -/

/-- **Lemma**: on flat Minkowski, each metric component is a constant
    function of the lattice point, hence its discrete Laplacian vanishes. -/
theorem flat_component_laplacian_zero
    (p : LatticePoint) (μ ν : Fin 4) :
    discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0 := by
  unfold DiscreteMetric.flat
  exact discreteLaplacian_const _ _

/-- **Flat + uniform info is a healing equilibrium.**  Both sides of the
    balance equation vanish: `μΔ(flat) = 0` because flat is component-wise
    constant, and `λ·D(flat,flat) + γ(I − Ī) = 0 + γ·0 = 0` because
    defect is zero and information is uniform. -/
theorem flat_is_healing_equilibrium_for_uniform_info
    (params : HealingParams) (I : InformationDensity) (I_bar : ℝ)
    (h_uniform : ∀ p, I p = I_bar) :
    IsHealingEquilibrium params DiscreteMetric.flat DiscreteMetric.flat
      I I_bar := by
  refine ⟨fun p μ ν => ?_⟩
  have h_defect :
      defectTensor DiscreteMetric.flat DiscreteMetric.flat p μ ν = 0 := by
    unfold defectTensor
    ring
  have h_lap :
      discreteLaplacian (fun q => DiscreteMetric.flat q μ ν) p = 0 :=
    flat_component_laplacian_zero p μ ν
  rw [h_lap, h_defect, h_uniform p]
  ring

/-! ## KL density is pointwise constant along an equilibrium trajectory -/

/-- **KL density is pointwise constant along an equilibrium trajectory
    (static info)**: direct rewrite via `healing_flow_static_info_path_eq_initial`
    from `LaSalle.lean`. -/
theorem informationDensityKL_constant_along_equilibrium_trajectory
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (hflow : IsHealingFlow params path g_exact (fun _ => I) I_bar delta_tau)
    (heq0 : IsHealingEquilibrium params (path 0) g_exact I I_bar)
    (n : ℕ) (p : LatticePoint) :
    informationDensityKL (path ((n : ℝ) * delta_tau)) g_exact p =
    informationDensityKL (path 0) g_exact p := by
  rw [healing_flow_static_info_path_eq_initial params path g_exact I I_bar
        delta_tau hflow heq0 n]

/-! ## KL current exactly conserved on a flat-equilibrium trajectory -/

/-- **KL current is exactly conserved on a flat-equilibrium trajectory with
    uniform static info.**  Under flat initial condition + uniform `I = Ī`,
    LaSalle pins the trajectory at `DiscreteMetric.flat`; the flat KL
    current is harmonic, hence exactly conserved
    (`informationKL_flat_conserved`). -/
theorem informationKLCurrent_conserved_on_flat_equilibrium_trajectory
    (params : HealingParams) (path : MetricPath)
    (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (h_uniform : ∀ p, I p = I_bar)
    (hflow : IsHealingFlow params path DiscreteMetric.flat
      (fun _ => I) I_bar delta_tau)
    (h_start : path 0 = DiscreteMetric.flat)
    (n : ℕ) :
    IsConserved (informationKLCurrent
      (path ((n : ℝ) * delta_tau)) DiscreteMetric.flat) := by
  have heq_start : IsHealingEquilibrium params (path 0)
      DiscreteMetric.flat I I_bar := by
    rw [h_start]
    exact flat_is_healing_equilibrium_for_uniform_info params I I_bar h_uniform
  have h_stays : path ((n : ℝ) * delta_tau) = path 0 :=
    healing_flow_static_info_path_eq_initial params path DiscreteMetric.flat
      I I_bar delta_tau hflow heq_start n
  rw [h_stays, h_start]
  exact informationKL_flat_conserved

/-! ## Discrete second-law degenerate case: regional KL totals are time-invariant

The second law predicts entropy production along dissipative dynamics.  At
equilibrium this collapses trivially: there is no entropy production because
the system is stationary.  Our discrete Lyapunov formalism captures this
collapse exactly — `dissipationRate_of_equilibrium` (in `LaSalle.lean`) gives
`dF/dτ = 0` at equilibrium, and here we show the corresponding KL total is
conserved along the whole trajectory. -/

/-- **Discrete second-law at equilibrium, degenerate case**: along an
    equilibrium trajectory with static information field, the regional sum
    of KL density is `n`-independent.  The generic non-equilibrium second
    law would say "monotonically changing"; the equilibrium specialisation
    makes this "constant." -/
theorem total_informationKL_constant_along_equilibrium_trajectory
    (params : HealingParams) (path : MetricPath)
    (g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (region : Finset LatticePoint)
    (hflow : IsHealingFlow params path g_exact (fun _ => I) I_bar delta_tau)
    (heq0 : IsHealingEquilibrium params (path 0) g_exact I I_bar)
    (n : ℕ) :
    region.sum (fun p => informationDensityKL
        (path ((n : ℝ) * delta_tau)) g_exact p) =
    region.sum (fun p => informationDensityKL (path 0) g_exact p) := by
  apply Finset.sum_congr rfl
  intro p _
  exact informationDensityKL_constant_along_equilibrium_trajectory
    params path g_exact I I_bar delta_tau hflow heq0 n p

/-- **Corollary**: regional KL total on a flat-equilibrium trajectory equals
    `2 · |region|` at every step (uniform info, flat initial condition). -/
theorem total_informationKL_flat_equilibrium_trajectory
    (params : HealingParams) (path : MetricPath)
    (I : InformationDensity) (I_bar : ℝ)
    (delta_tau : ℝ)
    (region : Finset LatticePoint)
    (h_uniform : ∀ p, I p = I_bar)
    (hflow : IsHealingFlow params path DiscreteMetric.flat
      (fun _ => I) I_bar delta_tau)
    (h_start : path 0 = DiscreteMetric.flat)
    (n : ℕ) :
    region.sum (fun p => informationDensityKL
        (path ((n : ℝ) * delta_tau)) DiscreteMetric.flat p) =
    2 * (region.card : ℝ) := by
  have heq_start : IsHealingEquilibrium params (path 0)
      DiscreteMetric.flat I I_bar := by
    rw [h_start]
    exact flat_is_healing_equilibrium_for_uniform_info params I I_bar h_uniform
  rw [total_informationKL_constant_along_equilibrium_trajectory
        params path DiscreteMetric.flat I I_bar delta_tau region hflow
        heq_start n, h_start]
  simp_rw [informationDensityKL_flat_self]
  rw [Finset.sum_const, nsmul_eq_mul]
  ring

end OmegaTheory.Conservation
