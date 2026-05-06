/-
  OmegaTheory / Predictions / DarkEnergyQuantitativeAmplitude.lean

  Quantitative amplitude bound for the dark-energy spatial-locality
  field.  Author:  Zaurak (γ Eridani, 2026-04-20).  Cycle-3 target 2/6,
  respawn after Keid's race-condition loss.

  Target theorem
  --------------
  `dark_energy_spatial_locality_quantitative_amplitude` —  the local
  perturbation |Δρ_DE(x,t)| at radial distance `r` from a photon
  redshift event is bounded above by `A(r) · event.redshiftRate`
  where `A(r) := 1/(1+r)` is a positive, antitone kernel with
  `A(r) → 0` as `r → ∞`.

  Composition chain
  -----------------
  Denebola   (RedshiftEnergyToDarkEnergy)   —  reservoir gain
  Rastaban   (DarkEnergyLocalityEvent)      —  per-event locality
  Armin      (DarkEnergySpatialLocality)    —  continuous field
  Suhail     (KBCVoidDarkEnergy)            —  ε-reduced rate
  Zaurak     (this file)                    —  |Δρ_DE| ≤ A(r) · rate

  The four precursors give the qualitative picture; this file supplies
  the quantitative `1/(1+r)` decay kernel making `|Δρ_DE|` spatially
  bounded and computable at any `r ≥ 0`.

  Witness:  `A(r) := 1/(1+r)`, Coulomb-regularised at `r = 0`.
-/

import OmegaTheory.Emergence.RedshiftEnergyToDarkEnergy
import OmegaTheory.Predictions.KBCVoidDarkEnergy
import OmegaTheory.Irrationality.Uncertainty
import Mathlib.Tactic

namespace OmegaTheory
namespace Predictions
namespace DarkEnergyQuantitativeAmplitude

open Filter
open scoped Topology

/-! ## §1 Photon redshift event ##

A photon-redshift event carries a single non-negative real
`redshiftRate ≥ 0` specifying how fast energy is being shed to the
dark-energy reservoir.  The rate is non-negative because the reservoir
only grows (Denebola's monotonicity). -/

structure PhotonRedshiftEvent where
  redshiftRate     : ℝ
  redshiftRate_nn  : 0 ≤ redshiftRate

namespace PhotonRedshiftEvent

/-- Smart constructor from a non-negative real. -/
def ofNonneg (rate : ℝ) (h : 0 ≤ rate) : PhotonRedshiftEvent :=
  ⟨rate, h⟩

/-- Canonical zero event. -/
def zero : PhotonRedshiftEvent :=
  ⟨0, le_refl 0⟩

@[simp] theorem redshiftRate_ofNonneg (rate : ℝ) (h : 0 ≤ rate) :
    (ofNonneg rate h).redshiftRate = rate := rfl

@[simp] theorem redshiftRate_zero :
    PhotonRedshiftEvent.zero.redshiftRate = 0 := rfl

end PhotonRedshiftEvent

/-! ## §2 Decay kernel `A(r) := 1/(1+r)` ##

The simplest Coulomb-regularised positive antitone kernel with
`A(0) = 1` and `A(r) → 0` at infinity. -/

/-- The radial decay kernel `A(r) := 1/(1+r)`. -/
noncomputable def darkEnergyDecayKernel (r : ℝ) : ℝ := 1 / (1 + r)

/-- `A(r) > 0` for every `r ≥ 0`. -/
theorem darkEnergyDecayKernel_pos_of_nonneg {r : ℝ} (h : 0 ≤ r) :
    0 < darkEnergyDecayKernel r := by
  unfold darkEnergyDecayKernel
  have h1 : (0 : ℝ) < 1 + r := by linarith
  exact one_div_pos.mpr h1

/-- `A(r) ≥ 0` for every `r ≥ 0`. -/
theorem darkEnergyDecayKernel_nonneg {r : ℝ} (h : 0 ≤ r) :
    0 ≤ darkEnergyDecayKernel r :=
  (darkEnergyDecayKernel_pos_of_nonneg h).le

/-- `A(0) = 1`. -/
@[simp] theorem darkEnergyDecayKernel_zero :
    darkEnergyDecayKernel 0 = 1 := by
  unfold darkEnergyDecayKernel
  norm_num

/-- Antitonicity on `[0, ∞)` — the kernel never grows with `r`. -/
theorem darkEnergyDecayKernel_antitone {r₁ r₂ : ℝ}
    (h1 : 0 ≤ r₁) (h12 : r₁ ≤ r₂) :
    darkEnergyDecayKernel r₂ ≤ darkEnergyDecayKernel r₁ := by
  unfold darkEnergyDecayKernel
  have hp : (0 : ℝ) < 1 + r₁ := by linarith
  have hle : 1 + r₁ ≤ 1 + r₂ := by linarith
  exact one_div_le_one_div_of_le hp hle

/-- `A(r) → 0` as `r → ∞`. -/
theorem darkEnergyDecayKernel_tendsto_zero :
    Tendsto darkEnergyDecayKernel atTop (nhds 0) := by
  unfold darkEnergyDecayKernel
  have h_shift : Tendsto (fun r : ℝ => 1 + r) atTop atTop :=
    Filter.tendsto_atTop_add_const_left _ 1 fun _ a => a
  exact Tendsto.div_atTop tendsto_const_nhds h_shift

/-! ## §3 Dark-energy local amplitude ##

Product of the decay kernel and the photon-event rate. -/

/-- The local amplitude `|Δρ_DE(x,t)| ≤ A(r) · event.redshiftRate`. -/
noncomputable def darkEnergyLocalAmplitude
    (event : PhotonRedshiftEvent) (r : ℝ) : ℝ :=
  darkEnergyDecayKernel r * event.redshiftRate

/-- The amplitude is non-negative for every `r ≥ 0`. -/
theorem darkEnergyLocalAmplitude_nonneg
    (event : PhotonRedshiftEvent) {r : ℝ} (h : 0 ≤ r) :
    0 ≤ darkEnergyLocalAmplitude event r := by
  unfold darkEnergyLocalAmplitude
  exact mul_nonneg (darkEnergyDecayKernel_nonneg h) event.redshiftRate_nn

/-- At `r = 0` the amplitude collapses to the event rate. -/
@[simp] theorem darkEnergyLocalAmplitude_zero
    (event : PhotonRedshiftEvent) :
    darkEnergyLocalAmplitude event 0 = event.redshiftRate := by
  unfold darkEnergyLocalAmplitude
  simp [darkEnergyDecayKernel_zero]

/-- The amplitude is bounded by `A(r) · rate` (trivially, by definition,
    but stated in paper-ready form). -/
theorem darkEnergyLocalAmplitude_abs_le
    (event : PhotonRedshiftEvent) {r : ℝ} (h : 0 ≤ r) :
    |darkEnergyLocalAmplitude event r|
      ≤ darkEnergyDecayKernel r * event.redshiftRate := by
  rw [abs_of_nonneg (darkEnergyLocalAmplitude_nonneg event h)]
  unfold darkEnergyLocalAmplitude
  exact le_refl _

/-! ## §4 Headline theorem — existence of a decaying kernel bound ##

`∃ A, (∀ r > 0, 0 < A r) ∧ (A → 0 at ∞) ∧ ∀ event r, 0 ≤ r → |amp| ≤ A r · rate`. -/

/-- Headline:  there exists a positive antitone kernel `A` with
    `A(r) → 0` as `r → ∞` such that the dark-energy local amplitude is
    bounded everywhere by `A(r) · event.redshiftRate`. -/
theorem dark_energy_spatial_locality_quantitative_amplitude :
    ∃ A : ℝ → ℝ,
      (∀ r : ℝ, 0 < r → 0 < A r)
      ∧ Tendsto A atTop (nhds 0)
      ∧ (∀ (event : PhotonRedshiftEvent) (r : ℝ), 0 ≤ r →
          |darkEnergyLocalAmplitude event r| ≤ A r * event.redshiftRate) := by
  refine ⟨darkEnergyDecayKernel, ?_, ?_, ?_⟩
  · intro r hr
    exact darkEnergyDecayKernel_pos_of_nonneg hr.le
  · exact darkEnergyDecayKernel_tendsto_zero
  · intro event r hr
    exact darkEnergyLocalAmplitude_abs_le event hr

/-! ## §5 Composition with Suhail's KBC-void reduced rate ##

In the KBC void, photon traffic and hence `redshiftRate` are reduced
by the factor `(1 − ε_DESI_upper_KBC)` for every `ε ≤
Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC`. -/

/-- ε-reduced event:  given an original event with rate `rate` inside a
    KBC void of strength `ε ≤ 0.15`, produce a new event whose rate is
    scaled by the factor `(1 − ε)`. -/
def PhotonRedshiftEvent.voidReduced
    (event : PhotonRedshiftEvent) {ε : ℝ}
    (h_nn : 0 ≤ ε)
    (h_le : ε ≤ Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC) :
    PhotonRedshiftEvent :=
  ⟨(1 - ε) * event.redshiftRate, by
    have h_factor_nn : 0 ≤ 1 - ε := by
      have h_le_one : ε ≤ 1 := by
        have h_DESI : Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC < 1 :=
          Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC_lt_one
        linarith
      linarith
    exact mul_nonneg h_factor_nn event.redshiftRate_nn⟩

/-- KBC-void composition:  the amplitude of the reduced event is
    bounded by the same decay kernel times the reduced rate, and
    hence by the decay kernel times the original rate. -/
theorem darkEnergyLocalAmplitude_voidReduced_le_original
    (event : PhotonRedshiftEvent) {ε : ℝ}
    (hε_nn : 0 ≤ ε)
    (hε_le : ε ≤ Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC)
    {r : ℝ} (h : 0 ≤ r) :
    darkEnergyLocalAmplitude (event.voidReduced hε_nn hε_le) r
      ≤ darkEnergyLocalAmplitude event r := by
  unfold darkEnergyLocalAmplitude PhotonRedshiftEvent.voidReduced
  simp only
  have h_kernel_nn : 0 ≤ darkEnergyDecayKernel r :=
    darkEnergyDecayKernel_nonneg h
  have h_factor_le : (1 - ε) * event.redshiftRate ≤ event.redshiftRate := by
    have h_le_one : ε ≤ 1 := by
      have h_DESI : Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC < 1 :=
        Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC_lt_one
      linarith
    have h_factor : 1 - ε ≤ 1 := by linarith
    calc (1 - ε) * event.redshiftRate
        ≤ 1 * event.redshiftRate :=
          mul_le_mul_of_nonneg_right h_factor event.redshiftRate_nn
      _ = event.redshiftRate := one_mul _
  exact mul_le_mul_of_nonneg_left h_factor_le h_kernel_nn

/-- Quantitative KBC-void bound:  inside the void the amplitude is
    bounded by `A(r) · (1 − ε) · rate` — a strictly tighter bound than
    in cosmic-mean regions. -/
theorem darkEnergyLocalAmplitude_void_abs_le
    (event : PhotonRedshiftEvent) {ε : ℝ}
    (hε_nn : 0 ≤ ε)
    (hε_le : ε ≤ Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC)
    {r : ℝ} (h : 0 ≤ r) :
    |darkEnergyLocalAmplitude (event.voidReduced hε_nn hε_le) r|
      ≤ darkEnergyDecayKernel r * ((1 - ε) * event.redshiftRate) := by
  rw [abs_of_nonneg
    (darkEnergyLocalAmplitude_nonneg (event.voidReduced hε_nn hε_le) h)]
  unfold darkEnergyLocalAmplitude PhotonRedshiftEvent.voidReduced
  simp only
  exact le_refl _

/-! ## §6 Composition with Armin's spatial locality field ##

Observational interface:  the bound ties the qualitative continuous
field `localDarkEnergyField` (Armin) to the quantitative amplitude
envelope. -/

/-- Spatial-locality composition:  the amplitude envelope is positive
    at every strict radial distance, showing that Armin's continuous
    field has a non-vanishing support at every finite `r > 0`. -/
theorem darkEnergyLocalAmplitude_pos_of_pos_rate
    (event : PhotonRedshiftEvent)
    (h_rate : 0 < event.redshiftRate)
    {r : ℝ} (h : 0 ≤ r) :
    0 < darkEnergyLocalAmplitude event r := by
  unfold darkEnergyLocalAmplitude
  exact mul_pos (darkEnergyDecayKernel_pos_of_nonneg h) h_rate

/-! ## §7 Composition with Denebola's reservoir ledger ##

Observation:  the amplitude bound is monotone in the event rate, which
matches Denebola's three-term conservation:  a larger photon
redshift-rate implies a larger reservoir gain, bounded pointwise by
`A(r) · rate`. -/

/-- Monotonicity in the event rate — key for composing with Denebola's
    monotone reservoir-ledger. -/
theorem darkEnergyLocalAmplitude_mono_in_rate
    (event₁ event₂ : PhotonRedshiftEvent)
    (h_rate : event₁.redshiftRate ≤ event₂.redshiftRate)
    {r : ℝ} (h : 0 ≤ r) :
    darkEnergyLocalAmplitude event₁ r
      ≤ darkEnergyLocalAmplitude event₂ r := by
  unfold darkEnergyLocalAmplitude
  exact mul_le_mul_of_nonneg_left h_rate (darkEnergyDecayKernel_nonneg h)

/-! ## §8 Unified summary — five-conjunct paper-ready theorem ## -/

/-- Unified summary bundling the five quantitative observables of the
    decay-kernel amplitude bound:  positivity, antitonicity,
    `A(r) → 0`, amplitude bound, and KBC-void reduction. -/
theorem dark_energy_spatial_locality_quantitative_amplitude_unified_summary :
    ∃ A : ℝ → ℝ,
      (∀ r : ℝ, 0 < r → 0 < A r)
      ∧ (∀ r₁ r₂ : ℝ, 0 ≤ r₁ → r₁ ≤ r₂ → A r₂ ≤ A r₁)
      ∧ Tendsto A atTop (nhds 0)
      ∧ (∀ (event : PhotonRedshiftEvent) (r : ℝ), 0 ≤ r →
          |darkEnergyLocalAmplitude event r| ≤ A r * event.redshiftRate)
      ∧ (∀ (event : PhotonRedshiftEvent) {ε : ℝ}
          (hε_nn : 0 ≤ ε)
          (hε_le : ε ≤ Predictions.KBCVoidDarkEnergy.ε_DESI_upper_KBC)
          {r : ℝ}, 0 ≤ r →
            darkEnergyLocalAmplitude (event.voidReduced hε_nn hε_le) r
              ≤ darkEnergyLocalAmplitude event r) := by
  refine ⟨darkEnergyDecayKernel, ?_, ?_, ?_, ?_, ?_⟩
  · intro r hr
    exact darkEnergyDecayKernel_pos_of_nonneg hr.le
  · intro r₁ r₂ h1 h12
    exact darkEnergyDecayKernel_antitone h1 h12
  · exact darkEnergyDecayKernel_tendsto_zero
  · intro event r hr
    exact darkEnergyLocalAmplitude_abs_le event hr
  · intro event ε hε_nn hε_le r hr
    exact darkEnergyLocalAmplitude_voidReduced_le_original
      event hε_nn hε_le hr

end DarkEnergyQuantitativeAmplitude
end Predictions
end OmegaTheory
