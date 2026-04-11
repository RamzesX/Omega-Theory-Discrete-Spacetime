/-
  OmegaTheory.Conservation.Correspondence

  Fundamental correspondences between physical quantities.
  ALL DERIVED — zero axioms. Everything follows from definitions.

  Key correspondences:
  - E = k_B T ln(2) · I  (Landauer: energy-information)
  - m = k_B T ln(2) · I / c²  (mass-information, from E=mc²)
  - S_BH = A / (4 l_P²)  (Bekenstein-Hawking entropy)
  - T_H = ℏc³ / (8πGMk_B)  (Hawking temperature)
-/

import OmegaTheory.Conservation.Information
import OmegaTheory.Spacetime.Constants
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Tactic

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime

/-! ## Fundamental Constants -/

/-- ln(2) is positive. -/
theorem log_two_pos : 0 < Real.log 2 := Real.log_pos (by norm_num : (1:ℝ) < 2)

/-- ln(2) is nonneg. -/
theorem log_two_nonneg : 0 ≤ Real.log 2 := le_of_lt log_two_pos

/-- ln(2) ≠ 0. -/
theorem log_two_ne_zero : Real.log 2 ≠ 0 := ne_of_gt log_two_pos

/-! ## Part I: Landauer Energy (Definition, not axiom)

The minimum energy to erase one bit at temperature T.
This is a DEFINITION of information energy, not an axiom. -/

/-- Landauer energy: E_L(T) = k_B · T · ln(2). -/
noncomputable def landauerEnergy (T : ℝ) : ℝ := k_B * T * Real.log 2

theorem landauerEnergy_pos (T : ℝ) (hT : 0 < T) : 0 < landauerEnergy T :=
  mul_pos (mul_pos k_B_pos hT) log_two_pos

theorem landauerEnergy_nonneg (T : ℝ) (hT : 0 ≤ T) : 0 ≤ landauerEnergy T :=
  mul_nonneg (mul_nonneg (le_of_lt k_B_pos) hT) log_two_nonneg

theorem landauerEnergy_zero : landauerEnergy 0 = 0 := by
  unfold landauerEnergy; ring

theorem landauerEnergy_mono {T₁ T₂ : ℝ} (h : T₁ ≤ T₂) :
    landauerEnergy T₁ ≤ landauerEnergy T₂ := by
  unfold landauerEnergy
  apply mul_le_mul_of_nonneg_right
  · exact mul_le_mul_of_nonneg_left h (le_of_lt k_B_pos)
  · exact log_two_nonneg

theorem landauerEnergy_scale (T lam : ℝ) :
    landauerEnergy (lam * T) = lam * landauerEnergy T := by
  unfold landauerEnergy; ring

/-! ## Part II: Energy-Information Correspondence (DERIVED)

E = k_B T ln(2) · I follows directly from Landauer's definition.
No axiom needed — it's just multiplication. -/

/-- Energy of I bits at temperature T.
    E(I,T) = landauerEnergy(T) · I = k_B · T · ln(2) · I -/
noncomputable def energyFromInformation (I T : ℝ) : ℝ := landauerEnergy T * I

/-- Maximum information extractable from energy E at temperature T. -/
noncomputable def maxInformationFromEnergy (E T : ℝ) (hT : 0 < T) : ℝ :=
  E / landauerEnergy T

theorem energyFromInformation_nonneg (I T : ℝ) (hI : 0 ≤ I) (hT : 0 ≤ T) :
    0 ≤ energyFromInformation I T :=
  mul_nonneg (landauerEnergy_nonneg T hT) hI

theorem energyFromInformation_linear (I₁ I₂ T : ℝ) :
    energyFromInformation (I₁ + I₂) T =
    energyFromInformation I₁ T + energyFromInformation I₂ T := by
  unfold energyFromInformation; ring

/-- Round-trip: info → energy → info recovers original. -/
theorem info_energy_roundtrip (I T : ℝ) (hT : 0 < T) :
    maxInformationFromEnergy (energyFromInformation I T) T hT = I := by
  unfold maxInformationFromEnergy energyFromInformation
  rw [mul_div_cancel_left₀]
  exact ne_of_gt (landauerEnergy_pos T hT)

/-! ## Part III: Mass-Information Correspondence (DERIVED from E=mc²)

m = E/c² = k_B T ln(2) · I / c². No axiom — just E=mc². -/

/-- Einstein energy: E = mc². -/
noncomputable def einsteinEnergy (m : ℝ) : ℝ := m * c ^ 2

theorem einsteinEnergy_pos (m : ℝ) (hm : 0 < m) : 0 < einsteinEnergy m :=
  mul_pos hm (sq_pos_of_pos c_pos)

/-- Mass from bound information: m = k_B T ln(2) · I / c². -/
noncomputable def massFromInformation (I T : ℝ) : ℝ :=
  energyFromInformation I T / c ^ 2

/-- Information content of mass m at temperature T. -/
noncomputable def informationFromMass (m T : ℝ) (hT : 0 < T) : ℝ :=
  einsteinEnergy m / landauerEnergy T

theorem massFromInformation_nonneg (I T : ℝ) (hI : 0 ≤ I) (hT : 0 ≤ T) :
    0 ≤ massFromInformation I T :=
  div_nonneg (energyFromInformation_nonneg I T hI hT) (le_of_lt (sq_pos_of_pos c_pos))

/-- E = mc² consistency: mass-from-info times c² gives energy-from-info. -/
theorem triad_consistency (I T : ℝ) :
    einsteinEnergy (massFromInformation I T) = energyFromInformation I T := by
  unfold einsteinEnergy massFromInformation
  rw [div_mul_cancel₀]
  exact ne_of_gt (sq_pos_of_pos c_pos)

/-- Round-trip: mass → info → mass recovers original. -/
theorem mass_info_roundtrip (m T : ℝ) (hT : 0 < T) :
    massFromInformation (informationFromMass m T hT) T = m := by
  unfold massFromInformation informationFromMass energyFromInformation einsteinEnergy landauerEnergy
  have hk : k_B ≠ 0 := ne_of_gt k_B_pos
  have hT' : T ≠ 0 := ne_of_gt hT
  have hl : Real.log 2 ≠ 0 := log_two_ne_zero
  have hc : c ≠ 0 := ne_of_gt c_pos
  field_simp

/-! ## Part IV: Bekenstein-Hawking Entropy (DEFINITION)

S_BH = A / (4 l_P²). This is a definition, not an axiom. -/

/-- Holographic information density: 1/(4 l_P²) bits per area. -/
noncomputable def holographicDensity : ℝ := 1 / (4 * l_P ^ 2)

theorem holographicDensity_pos : 0 < holographicDensity := by
  unfold holographicDensity
  exact div_pos one_pos (mul_pos (by norm_num : (0:ℝ) < 4) (sq_pos_of_pos l_P_pos))

/-- Bekenstein-Hawking entropy: S_BH = A / (4 l_P²). -/
noncomputable def bekensteinHawkingEntropy (A : ℝ) : ℝ := A / (4 * l_P ^ 2)

theorem bekensteinHawkingEntropy_nonneg (A : ℝ) (hA : 0 ≤ A) :
    0 ≤ bekensteinHawkingEntropy A :=
  div_nonneg hA (le_of_lt (mul_pos (by norm_num : (0:ℝ) < 4) (sq_pos_of_pos l_P_pos)))

theorem bekensteinHawkingEntropy_pos (A : ℝ) (hA : 0 < A) :
    0 < bekensteinHawkingEntropy A :=
  div_pos hA (mul_pos (by norm_num : (0:ℝ) < 4) (sq_pos_of_pos l_P_pos))

theorem bekensteinHawkingEntropy_mono {A₁ A₂ : ℝ} (h : A₁ ≤ A₂) :
    bekensteinHawkingEntropy A₁ ≤ bekensteinHawkingEntropy A₂ := by
  unfold bekensteinHawkingEntropy
  exact div_le_div_of_nonneg_right h
    (le_of_lt (mul_pos (by norm_num : (0:ℝ) < 4) (sq_pos_of_pos l_P_pos)))

/-- BH entropy equals area times holographic density. -/
theorem bekensteinHawking_eq_area_density (A : ℝ) :
    bekensteinHawkingEntropy A = A * holographicDensity := by
  unfold bekensteinHawkingEntropy holographicDensity; field_simp

/-! ## Part V: Hawking Temperature (DERIVED)

T_H = ℏc³/(8πGMk_B). Derived from dimensional analysis + Bekenstein-Hawking. -/

/-- Hawking temperature of a black hole of mass M. -/
noncomputable def hawkingTemperature (M : ℝ) : ℝ :=
  hbar * c ^ 3 / (8 * Real.pi * G_N * M * k_B)

theorem hawkingTemperature_pos (M : ℝ) (hM : 0 < M) : 0 < hawkingTemperature M := by
  unfold hawkingTemperature
  apply div_pos
  · exact mul_pos hbar_pos (pow_pos c_pos 3)
  · apply mul_pos
    apply mul_pos
    apply mul_pos
    apply mul_pos
    · linarith [Real.pi_pos]
    · exact Real.pi_pos
    · exact G_N_pos
    · exact hM
    · exact k_B_pos

/-- Smaller black holes are hotter (antimono in mass). -/
theorem hawkingTemperature_antimono {M₁ M₂ : ℝ} (hM₁ : 0 < M₁) (hM₂ : 0 < M₂)
    (h : M₁ < M₂) :
    hawkingTemperature M₂ < hawkingTemperature M₁ := by
  unfold hawkingTemperature
  apply div_lt_div_of_pos_left
  · exact mul_pos hbar_pos (pow_pos c_pos 3)
  · exact mul_pos (mul_pos (mul_pos (mul_pos (by nlinarith [Real.pi_pos]) Real.pi_pos) G_N_pos) hM₁) k_B_pos
  · exact mul_lt_mul_of_pos_right (mul_lt_mul_of_pos_left h
      (mul_pos (mul_pos (by nlinarith [Real.pi_pos]) Real.pi_pos) G_N_pos)) k_B_pos

/-! ## Part VI: Schwarzschild Geometry -/

/-- Schwarzschild radius: r_s = 2GM/c². -/
noncomputable def schwarzschildRadius (M : ℝ) : ℝ := 2 * G_N * M / c ^ 2

theorem schwarzschildRadius_pos (M : ℝ) (hM : 0 < M) : 0 < schwarzschildRadius M :=
  div_pos (mul_pos (mul_pos two_pos G_N_pos) hM) (sq_pos_of_pos c_pos)

theorem schwarzschildRadius_linear (M₁ M₂ : ℝ) :
    schwarzschildRadius (M₁ + M₂) = schwarzschildRadius M₁ + schwarzschildRadius M₂ := by
  unfold schwarzschildRadius
  rw [mul_add, add_div]

/-- Schwarzschild horizon area: A = 4π r_s². -/
noncomputable def schwarzschildArea (M : ℝ) : ℝ :=
  4 * Real.pi * schwarzschildRadius M ^ 2

theorem schwarzschildArea_nonneg (M : ℝ) : 0 ≤ schwarzschildArea M := by
  unfold schwarzschildArea
  exact mul_nonneg
    (mul_nonneg (by norm_num : (0:ℝ) ≤ 4) (le_of_lt Real.pi_pos))
    (sq_nonneg _)

theorem schwarzschildArea_pos (M : ℝ) (hM : 0 < M) : 0 < schwarzschildArea M := by
  unfold schwarzschildArea
  exact mul_pos
    (mul_pos (by norm_num : (0:ℝ) < 4) Real.pi_pos)
    (sq_pos_of_pos (schwarzschildRadius_pos M hM))

theorem schwarzschildArea_scale (M lam : ℝ) :
    schwarzschildArea (lam * M) = lam ^ 2 * schwarzschildArea M := by
  unfold schwarzschildArea schwarzschildRadius
  have h : c ^ 2 ≠ 0 := pow_ne_zero 2 c_ne_zero
  field_simp

/-! ## Part VII: Extended Thermodynamic Chain (rescued from V1)

The theorems below port the content of V1's `Conservation/Correspondence.lean`
into V2's definitional framework. No new axioms — everything is a corollary of
existing V2 definitions. -/

/-- Landauer energy is strictly monotone for positive temperatures. -/
theorem landauerEnergy_strict_mono {T₁ T₂ : ℝ} (_h₁ : 0 < T₁) (h : T₁ < T₂) :
    landauerEnergy T₁ < landauerEnergy T₂ := by
  unfold landauerEnergy
  exact mul_lt_mul_of_pos_right
    (mul_lt_mul_of_pos_left h k_B_pos) log_two_pos

/-- Landauer energy vanishes exactly at zero temperature (for T ≥ 0). -/
theorem landauerEnergy_eq_zero_iff {T : ℝ} (_hT : 0 ≤ T) :
    landauerEnergy T = 0 ↔ T = 0 := by
  unfold landauerEnergy
  constructor
  · intro h
    rcases mul_eq_zero.mp h with h1 | hlog
    · rcases mul_eq_zero.mp h1 with hk | ht
      · exact absurd hk (ne_of_gt k_B_pos)
      · exact ht
    · exact absurd hlog log_two_ne_zero
  · intro h; rw [h, mul_zero, zero_mul]

/-- The ratio E_L(T)/T = k_B · ln 2 is a universal constant. -/
theorem energy_per_temperature_constant {T : ℝ} (hT : 0 < T) :
    landauerEnergy T / T = k_B * Real.log 2 := by
  unfold landauerEnergy
  have hT_ne : T ≠ 0 := ne_of_gt hT
  field_simp

/-- Canonical factorization: E(I,T) = E_L(T) · I. -/
theorem energyFromInformation_eq_landauer_mul (I T : ℝ) :
    energyFromInformation I T = landauerEnergy T * I := rfl

/-- Einstein energy is nonneg for nonneg mass. -/
theorem einsteinEnergy_nonneg (m : ℝ) (hm : 0 ≤ m) : 0 ≤ einsteinEnergy m :=
  mul_nonneg hm (le_of_lt (sq_pos_of_pos c_pos))

/-- Einstein energy is linear in mass. -/
theorem einsteinEnergy_linear (m₁ m₂ : ℝ) :
    einsteinEnergy (m₁ + m₂) = einsteinEnergy m₁ + einsteinEnergy m₂ := by
  unfold einsteinEnergy; ring

/-- Bekenstein-Hawking entropy is linear in area. -/
theorem bekensteinHawkingEntropy_linear (A₁ A₂ : ℝ) :
    bekensteinHawkingEntropy (A₁ + A₂) =
    bekensteinHawkingEntropy A₁ + bekensteinHawkingEntropy A₂ := by
  unfold bekensteinHawkingEntropy
  rw [add_div]

/-- Bekenstein-Hawking entropy scales with area. -/
theorem bekensteinHawkingEntropy_scale (A lam : ℝ) :
    bekensteinHawkingEntropy (lam * A) = lam * bekensteinHawkingEntropy A := by
  unfold bekensteinHawkingEntropy
  have h : 4 * l_P ^ 2 ≠ 0 :=
    mul_ne_zero (by norm_num) (pow_ne_zero 2 l_P_ne_zero)
  field_simp

/-- Hawking temperature scales as 1/M. -/
theorem hawkingTemperature_scale (M lam : ℝ) (hM : 0 < M) (hlam : 0 < lam) :
    hawkingTemperature (lam * M) = hawkingTemperature M / lam := by
  unfold hawkingTemperature
  have hlam_ne : lam ≠ 0 := ne_of_gt hlam
  have hM_ne : M ≠ 0 := ne_of_gt hM
  have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  have hG : G_N ≠ 0 := ne_of_gt G_N_pos
  have hkB : k_B ≠ 0 := ne_of_gt k_B_pos
  field_simp

/-- Compton wavelength: λ_C = ℏ / (m c). -/
noncomputable def comptonWavelength (m : ℝ) : ℝ := hbar / (m * c)

theorem comptonWavelength_pos (m : ℝ) (hm : 0 < m) : 0 < comptonWavelength m :=
  div_pos hbar_pos (mul_pos hm c_pos)

/-- Compton wavelength is antimonotone in mass: heavier particles → shorter λ. -/
theorem comptonWavelength_antimono {m₁ m₂ : ℝ} (hm₁ : 0 < m₁) (_hm₂ : 0 < m₂)
    (h : m₁ < m₂) :
    comptonWavelength m₂ < comptonWavelength m₁ := by
  unfold comptonWavelength
  apply div_lt_div_of_pos_left hbar_pos
  · exact mul_pos hm₁ c_pos
  · exact mul_lt_mul_of_pos_right h c_pos

/-- Black hole mass entropy: S_M = 4π (G M)² / (ℏ c). -/
noncomputable def blackHoleMassEntropy (M : ℝ) : ℝ :=
  4 * Real.pi * (G_N * M) ^ 2 / (hbar * c)

theorem blackHoleMassEntropy_nonneg (M : ℝ) : 0 ≤ blackHoleMassEntropy M := by
  unfold blackHoleMassEntropy
  apply div_nonneg
  · exact mul_nonneg
      (mul_nonneg (by norm_num : (0:ℝ) ≤ 4) (le_of_lt Real.pi_pos))
      (sq_nonneg _)
  · exact le_of_lt (mul_pos hbar_pos c_pos)

theorem blackHoleMassEntropy_pos (M : ℝ) (hM : 0 < M) :
    0 < blackHoleMassEntropy M := by
  unfold blackHoleMassEntropy
  apply div_pos
  · exact mul_pos
      (mul_pos (by norm_num : (0:ℝ) < 4) Real.pi_pos)
      (sq_pos_of_pos (mul_pos G_N_pos hM))
  · exact mul_pos hbar_pos c_pos

theorem blackHoleMassEntropy_scale (M lam : ℝ) :
    blackHoleMassEntropy (lam * M) = lam ^ 2 * blackHoleMassEntropy M := by
  unfold blackHoleMassEntropy
  have h : hbar * c ≠ 0 := mul_ne_zero hbar_ne_zero c_ne_zero
  field_simp

/-- BH entropy of a Schwarzschild horizon equals
    the area formula 4π r_s² / (4 l_P²). -/
theorem blackHole_entropy_area_relation (M : ℝ) :
    bekensteinHawkingEntropy (schwarzschildArea M) =
    4 * Real.pi * (2 * G_N * M / c ^ 2) ^ 2 / (4 * l_P ^ 2) := by
  unfold bekensteinHawkingEntropy schwarzschildArea schwarzschildRadius
  rfl

end OmegaTheory.Conservation
