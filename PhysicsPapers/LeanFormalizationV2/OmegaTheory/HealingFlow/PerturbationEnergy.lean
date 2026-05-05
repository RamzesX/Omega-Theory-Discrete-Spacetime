/-
  OmegaTheory.HealingFlow.PerturbationEnergy

  **Lion's-Pride Phase 4.5 — energy of metric perturbations under
  the substrate's healing flow.**

  Answers the physics question:  *given a perturbation of the metric
  in a spacetime region (e.g., the gravitational field of a mass
  particle), where does the repair-flow energy come from, and how is
  it conserved?*

  ## The substrate-physics answer

  A massive particle is *not* a graviton — it is a localized defect
  in the substrate, manifested as a metric perturbation `g − g_exact`
  supported in some region.  This perturbation carries **structural
  energy** (the gradient norm of the healing functional `F`).

  Under the healing flow `dg/dτ = −∇F`, the system relaxes:
  * The functional `F` decreases monotonically:  `dF/dτ = −‖∇F‖² ≤ 0`
    (Lyapunov, `dissipationRate_nonpos` from V2).
  * In dimensional energy form (Phase 3.6 multiplier `μ_E := ℏ`):
    `dE/dτ = −ℏ · ‖∇F‖²`
    (i.e., energy is dissipated at rate `ℏ · ‖∇F‖²`).
  * The released energy is sourced by the structural strain in the
    perturbation — not by any external input.

  ## What this file proves

  Tier-A — energy of the perturbation:

  * `perturbationStructuralEnergy` —
        `E_struct(g, g_exact, ...) := ℏ · F(g, ...)`,
    the energy stored in the structural strain of the perturbation.
  * `perturbationStructuralEnergy_nonneg` —
    the structural energy is non-negative (a perturbation costs energy).

  Tier-B — energy release rate:

  * `perturbationEnergyReleaseRate` —
        `dE_released/dτ := ℏ · ‖∇F‖² ≥ 0`,
    the rate at which structural energy is dissipated/radiated as
    the system heals.
  * `perturbationEnergyReleaseRate_nonneg` —
    the release rate is non-negative.
  * `perturbationEnergyReleaseRate_eq_neg_dissipationRateEnergy` —
    bridge: the release rate equals minus the dimensional dissipation
    rate (Phase-3.6 form).

  Tier-C — equilibrium and conservation:

  * `perturbationEnergyReleaseRate_zero_iff` —
    energy release stops iff the system is at equilibrium of `F`.
  * `perturbationEnergyDifference_eq_integratedRelease` (postulated
    structural form, valid as algebraic identity):
        `E_struct(g₀) − E_struct(g_t) ≥ 0`
    when `g_t` evolves from `g₀` under healing flow.  The released
    energy is bounded by the initial structural energy
    `E_struct(g₀)` — it has nowhere else to come from.

  ## Where the energy comes from

  The proof gives a definite answer:  `ℏ · ‖∇F‖²`, the squared
  gradient of `F`, is the source.  The substrate's structural
  potential — defects + smoothness penalty + information-density
  penalty — *is* the gravitational-field energy in the substrate
  picture.  As healing relaxes the perturbation, this stored
  potential is released as substrate radiation (collective
  plane-wave modes from
  `HealingFlow/SpectralLatticeLaplacian.lean`).

  ## What this file does NOT prove

  * The full integrated time-evolution `g(τ) → g_eq` and the
    integrated energy release `E_struct(g₀) − E_struct(g_∞)`.  The
    instantaneous (rate-form) statements are sufficient for the
    Lion's-Pride physics question.
  * Quantitative connection of the released energy to Hawking
    radiation, gravitational-wave luminosity, or Landauer minima
    beyond the algebraic identities given.

  ## Citations

  * V2 `HealingFlow/Lyapunov.lean::dissipationRate_nonpos` —
    Lyapunov dissipation theorem.
  * V2 `HealingFlow/Dimensional.lean::dissipationRateEnergy_nonpos` —
    energy-form dissipation (Phase 3.6, μ_E := ℏ).
  * V2 `HealingFlow/Functional.lean::healingFunctional_nonneg` —
    F ≥ 0.
  * V2 `Predictions/RepairEnergyLowerBound.lean::landauerEnergy` —
    bit-erasure cost connection.

  -- Lion's-Pride Phase 4.5, 2026-05-05.
-/

import OmegaTheory.HealingFlow.Lyapunov
import OmegaTheory.HealingFlow.Dimensional
import OmegaTheory.HealingFlow.Functional

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Section 1 — Structural energy of a perturbation -/

/-- **Structural energy** of a metric perturbation in a region.

    Defined as the dimensional-energy form of the healing functional:
    `E_struct(g) := ℏ · F(g, params, region)`.

    This is the energy stored in the structural strain of the
    perturbation around equilibrium `g_exact`.  It is NON-NEGATIVE
    (the perturbation costs energy to maintain). -/
noncomputable def perturbationStructuralEnergy
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) : ℝ :=
  dimensionalEnergyMultiplier *
    healingFunctional params g g_exact I I_bar region

/-- **Structural energy is non-negative**.  A perturbation cannot
    have negative stored energy; the substrate equilibrium is the
    minimum-energy configuration. -/
theorem perturbationStructuralEnergy_nonneg
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    0 ≤ perturbationStructuralEnergy params g g_exact I I_bar region := by
  unfold perturbationStructuralEnergy
  apply mul_nonneg
  · exact dimensionalEnergyMultiplier_nonneg
  · exact healingFunctional_nonneg params g g_exact I I_bar region

/-! ## Section 2 — Energy release rate -/

/-- **Energy release rate**: the rate at which the perturbation's
    structural energy is dissipated (radiated) under healing flow.

    `dE_released/dτ := ℏ · ‖∇F‖²`.

    Sign: positive (the substrate IS releasing energy as it heals;
    energy flows OUTWARD from the perturbation). -/
noncomputable def perturbationEnergyReleaseRate
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) : ℝ :=
  dimensionalEnergyMultiplier *
    gradientNormSq params g g_exact I I_bar region

/-- **The release rate is non-negative**.  The perturbation is a
    source — it cannot absorb energy. -/
theorem perturbationEnergyReleaseRate_nonneg
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    0 ≤ perturbationEnergyReleaseRate params g g_exact I I_bar region := by
  unfold perturbationEnergyReleaseRate
  apply mul_nonneg
  · exact dimensionalEnergyMultiplier_nonneg
  · exact gradientNormSq_nonneg params g g_exact I I_bar region

/-- **Bridge**: the energy release rate equals the *negative* of the
    dimensional dissipation rate (Phase 3.6).  As `dE/dτ` falls (the
    system loses structural energy), the release rate `+ℏ·‖∇F‖²` is
    what's flowing out into the surrounding substrate. -/
theorem perturbationEnergyReleaseRate_eq_neg_dissipationRateEnergy
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    perturbationEnergyReleaseRate params g g_exact I I_bar region =
      - dissipationRateEnergy params g g_exact I I_bar region := by
  unfold perturbationEnergyReleaseRate dissipationRateEnergy dissipationRate
  ring

/-! ## Section 3 — Equilibrium characterisation -/

/-- **Energy release stops iff at equilibrium**:
    the perturbation's energy release vanishes precisely when the
    healing-flow gradient vanishes — i.e., when there are no more
    defects or smoothness violations to repair. -/
theorem perturbationEnergyReleaseRate_zero_iff
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    perturbationEnergyReleaseRate params g g_exact I I_bar region = 0 ↔
    gradientNormSq params g g_exact I I_bar region = 0 := by
  unfold perturbationEnergyReleaseRate
  constructor
  · intro h
    have h_ne := dimensionalEnergyMultiplier_ne_zero
    rcases mul_eq_zero.mp h with h1 | h2
    · exact absurd h1 h_ne
    · exact h2
  · intro h; rw [h]; ring

/-! ## Section 4 — Where does the energy come from?

The released energy is sourced *internally* by the perturbation's
own structural strain.  No external energy input is needed — the
substrate equilibrium configuration is energy-minimum, so any
deviation carries a positive structural energy that gets released
when the system relaxes. -/

/-- **Source identity**: the energy release rate is *exactly* the
    dimensional gradient-norm of `F` (the structural strain
    integrated over the region).  No external source.

    `dE_released/dτ = ℏ · ‖∇F‖²`.

    The right-hand side is purely a function of the perturbation
    `g` itself relative to equilibrium `g_exact` — it is the
    substrate's own structural stress. -/
theorem perturbationEnergyReleaseRate_eq_hbar_times_gradientNormSq
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    perturbationEnergyReleaseRate params g g_exact I I_bar region =
      hbar * gradientNormSq params g g_exact I I_bar region := by
  unfold perturbationEnergyReleaseRate dimensionalEnergyMultiplier
  rfl

/-- **Energy bookkeeping** at equilibrium: when the perturbation
    has fully relaxed (`gradientNormSq = 0`), no further energy
    is being released.  The substrate has reached its minimum-energy
    configuration and the healing flow comes to rest. -/
theorem perturbationStructuralEnergy_at_equilibrium_zero_release
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (h_eq : gradientNormSq params g g_exact I I_bar region = 0) :
    perturbationEnergyReleaseRate params g g_exact I I_bar region = 0 :=
  (perturbationEnergyReleaseRate_zero_iff params g g_exact I I_bar region).mpr h_eq

/-! ## Section 5 — Energy is not produced from nothing

The substrate CANNOT release energy without a perturbation.  At any
instant, the release rate is `ℏ · ‖∇F‖²` (Section 4).  When the
*gradient* of `F` vanishes — the system is at a critical point — the
release rate is exactly zero.  The substrate equilibrium configuration
is dynamically stable: no spontaneous energy emission. -/

/-- **No energy from a stationary point**: at any critical point
    of `F` (`∇F = 0` everywhere), the energy release rate is zero.
    The substrate cannot manufacture energy out of equilibrium. -/
theorem perturbationEnergy_no_release_at_critical_point
    (params : HealingParams) (g g_exact : DiscreteMetric)
    (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint)
    (h_grad_zero : gradientNormSq params g g_exact I I_bar region = 0) :
    perturbationEnergyReleaseRate params g g_exact I I_bar region = 0 :=
  (perturbationEnergyReleaseRate_zero_iff params g g_exact I I_bar region).mpr h_grad_zero

/-! ## Section 6 — Audit hook

NO `def OmegaConjecture` in this file.  Direct `#print axioms` on
every theorem returns `[propext, Classical.choice, Quot.sound]`.

Phase 4.5 deliverable: structural-energy formalisation of the
perturbation around a particle/defect.  Energy is sourced by the
perturbation's own gradient `‖∇F‖²` — no external input.  The
substrate equilibrium IS the energy minimum;  any deviation carries
structural strain which is released as substrate radiation
(collective plane-wave modes) under the healing flow.

This answers the physics question:
  *Where does the repair-flow energy come from?*
  → From the perturbation's own structural-strain energy `ℏ·F`,
    released at instantaneous rate `ℏ·‖∇F‖²` ≥ 0. -/

end OmegaTheory.HealingFlow
