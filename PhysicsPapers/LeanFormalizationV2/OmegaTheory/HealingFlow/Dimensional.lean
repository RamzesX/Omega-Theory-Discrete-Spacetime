/-
  OmegaTheory.HealingFlow.Dimensional

  **Lion's-Pride Phase 3.6 of the honest graviton-energy plan.**

  The substrate's `HealingFlow/Lyapunov.lean` proves the
  Lyapunov-dissipation identity
      `dF/dτ = -‖∇F‖² ≤ 0`
  with `F` and `‖∇F‖²` carrying *dimensionless* parameters
  `params.mu, params.lambda, params.gamma`.  For the Phase-4 spectral
  derivation of the repair-quantum energy `E ≈ E_P/2` we need this
  identity in *energy units*: dimensionless rate of change of `F` →
  joules / second.

  ## What this file proves

  Tier-A — definitional bridge:

  * `dimensionalEnergyMultiplier := ℏ` (one new noncomputable def
    pinning the unit conversion).
  * `dimensionalEnergyMultiplier_pos`.
  * `dissipationRateEnergy` — the energy-form dissipation rate:
        `dE/dτ := ℏ · dF/dτ = -ℏ · ‖∇F‖²`.

  Tier-B — non-positivity transferred to energy form:

  * `dissipationRateEnergy_nonpos` — `dE/dτ ≤ 0`.  Energy is
    dissipated, not created — the substrate's gradient flow respects
    the second law.
  * `dissipationRateEnergy_zero_iff` — `dE/dτ = 0 ↔ ‖∇F‖² = 0`,
    transferring the equilibrium characterisation from the
    dimensionless Lyapunov form.
  * `dissipationRateEnergy_eq_neg_hbar_normSq` — the explicit form.

  ## Why ℏ?

  Dimensional analysis: `dF/dτ` carries units of `[F]/[τ]`.  In the
  substrate, `F` is the healing functional with units of
  `[length]^{-2}` (sum of squares of metric perturbations), and `τ` is
  the healing time which we identify with substrate ticks (units of
  `t_P = ℓ_P/c`).  Energy carries units of `M · L² / T² = E`.  The
  natural conversion `[F] · [τ]^{-1} → [E]` is the Planck action `ℏ`,
  the substrate's unique action quantum.

  This is consistent with the Wien-law analogue argument in
  `Predictions/RepairQuantumEnergyTheorem.lean` (Phase 4), where the
  spectral peak `ω_peak ~ c/ℓ_P` gives `E_peak = ℏ ω_peak ~ E_P`.

  ## What this file does NOT prove

  * **Uniqueness** of the dimensional multiplier.  Other choices
    (e.g. ℏ · k for some dimensionless `k`) give equivalent
    dimensional analysis up to a constant.  We pin `k = 1` by
    convention; downstream Phase-4 results scale linearly with this
    choice.

  ## Citations

  * V2 `HealingFlow/Lyapunov.lean::dissipationRate_nonpos` — the
    underlying dimensionless dissipation theorem.
  * V2 `Spacetime/Constants.lean::hbar_pos` — the substrate's
    Planck-action constant as `noncomputable opaque {x : ℝ // 0 < x}`.

  -- Lion's-Pride Phase 3.6, 2026-05-05.
-/

import OmegaTheory.HealingFlow.Lyapunov
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.HealingFlow

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Defects

/-! ## Section 1 — The dimensional multiplier -/

/-- **Dimensional energy multiplier**: pins `μ_E := ℏ` for converting
    the dimensionless Lyapunov-flow rate into joules / second. -/
noncomputable def dimensionalEnergyMultiplier : ℝ := hbar

/-- The multiplier is strictly positive. -/
theorem dimensionalEnergyMultiplier_pos : 0 < dimensionalEnergyMultiplier :=
  hbar_pos

/-- The multiplier is non-negative. -/
theorem dimensionalEnergyMultiplier_nonneg : 0 ≤ dimensionalEnergyMultiplier :=
  le_of_lt dimensionalEnergyMultiplier_pos

/-- The multiplier is non-zero. -/
theorem dimensionalEnergyMultiplier_ne_zero : dimensionalEnergyMultiplier ≠ 0 :=
  hbar_ne_zero

/-! ## Section 2 — Energy-form dissipation rate -/

/-- **Energy-form dissipation rate**: `dE/dτ := ℏ · dF/dτ`. -/
noncomputable def dissipationRateEnergy (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) : ℝ :=
  dimensionalEnergyMultiplier *
    dissipationRate params g g_exact I I_bar region

/-! ## Section 3 — Transfer of Lyapunov non-positivity -/

/-- **PROVEN**: the energy-form dissipation rate is non-positive.
    `dE/dτ ≤ 0`. -/
theorem dissipationRateEnergy_nonpos (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    dissipationRateEnergy params g g_exact I I_bar region ≤ 0 := by
  unfold dissipationRateEnergy
  have h_diss := dissipationRate_nonpos params g g_exact I I_bar region
  have h_pos := dimensionalEnergyMultiplier_pos
  have : dimensionalEnergyMultiplier *
           dissipationRate params g g_exact I I_bar region ≤
         dimensionalEnergyMultiplier * 0 :=
    mul_le_mul_of_nonneg_left h_diss (le_of_lt h_pos)
  simpa using this

/-- **PROVEN**: `dE/dτ = 0` iff the gradient norm-squared vanishes
    (i.e., the system is at equilibrium of `F`). -/
theorem dissipationRateEnergy_zero_iff (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    dissipationRateEnergy params g g_exact I I_bar region = 0 ↔
    gradientNormSq params g g_exact I I_bar region = 0 := by
  unfold dissipationRateEnergy
  constructor
  · intro h
    have h_ne := dimensionalEnergyMultiplier_ne_zero
    have h_diss : dissipationRate params g g_exact I I_bar region = 0 := by
      have := mul_eq_zero.mp h
      rcases this with h1 | h2
      · exact absurd h1 h_ne
      · exact h2
    exact (dissipationRate_zero_iff params g g_exact I I_bar region).mp h_diss
  · intro h
    have h_diss : dissipationRate params g g_exact I I_bar region = 0 :=
      (dissipationRate_zero_iff params g g_exact I I_bar region).mpr h
    rw [h_diss]
    ring

/-! ## Section 4 — The explicit energy form -/

/-- The energy-form dissipation rate equals `-ℏ · ‖∇F‖²`. -/
theorem dissipationRateEnergy_eq_neg_hbar_normSq (params : HealingParams)
    (g g_exact : DiscreteMetric) (I : InformationDensity) (I_bar : ℝ)
    (region : Finset LatticePoint) :
    dissipationRateEnergy params g g_exact I I_bar region =
      - dimensionalEnergyMultiplier *
        gradientNormSq params g g_exact I I_bar region := by
  unfold dissipationRateEnergy dissipationRate
  ring

/-! ## Section 5 — Audit hook

NO `def OmegaConjecture` in this file.  Direct `#print axioms` on
every theorem returns `[propext, Classical.choice, Quot.sound]`.

Phase 3.6 deliverable:  honest dimensional bridge from Lyapunov-form
dissipation to energy-form dissipation, ready for Phase-4 spectral
analysis. -/

end OmegaTheory.HealingFlow
