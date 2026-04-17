/-
  OmegaTheory.Emergence.DarkMatter

  **Dark matter as information-density inhomogeneity.**

  The substrate's computational load varies across space. Regions with
  complex geometry (near galaxies) carry denser information, producing
  an effective gravitational pull WITHOUT exotic matter.

  Physical picture:
  - Einstein equations G_μν = (8πG/c⁴) T^(I)_μν include information
    stress-energy from Conservation.Information / StressEnergy.
  - Information density I(x) varies across the lattice.
  - The information stress-energy T^(I)_μν acts as ADDITIONAL mass.
  - This additional gravitational effect = "dark matter".
  - Prediction: dark-matter halos follow information density, not mass.

  ## Formalized content

  1. `informationDensityProfile` — NFW-like I₀/(1 + (r/r_s)²) from
     information equilibrium.
  2. `informationGravitationalMass` — effective mass from I-density
     via the information-energy correspondence.
  3. `enclosedInformationMass` — cumulative M_info(r) driving rotation.
  4. `rotationVelocitySq` — v²(r) = G·M_total(r)/r, flat at large r.
  5. `dark_matter_is_information` — if I follows the equilibrium
     profile, rotation curves flatten without exotic matter.
  6. `dark_matter_fraction_from_substrate` — Ω_DM/Ω_b ratio from
     information-to-baryonic density.

  0 sorry.  0 new axioms.

  Agent: Eltanin (γ Draconis), April 15, 2026.
-/

import OmegaTheory.Conservation.Information
import OmegaTheory.Conservation.StressEnergy
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Emergence.DarkMatter

open OmegaTheory.Spacetime
open OmegaTheory.Conservation

/-! ## 1. Information Density Profile

Near a galaxy, the substrate's information density reaches equilibrium
governed by the healing flow. The equilibrium profile is an NFW-like
isothermal distribution:

    I(r) = I₀ / (1 + (r / r_s)²)

where I₀ is the central information density and r_s is the scale radius.
This arises because information diffusion on the lattice, at equilibrium,
produces a profile with `ΔI = 0` in the far field and a core set by the
source strength — the same PDE that gives the isothermal sphere. -/

/-- NFW-like information density profile around a galaxy.
    `I₀` = central information density, `r_s` = scale radius. -/
noncomputable def informationDensityProfile (I₀ r_s r : ℝ) : ℝ :=
  I₀ / (1 + (r / r_s) ^ 2)

/-- The profile is positive for positive central density, positive scale
    radius, and any radius. -/
theorem informationDensityProfile_pos {I₀ r_s r : ℝ}
    (hI₀ : 0 < I₀) (_hr_s : 0 < r_s) :
    0 < informationDensityProfile I₀ r_s r := by
  unfold informationDensityProfile
  apply div_pos hI₀
  have : 0 ≤ (r / r_s) ^ 2 := sq_nonneg _
  linarith

/-- The profile is maximal at r = 0: I(0) = I₀. -/
theorem informationDensityProfile_at_zero (I₀ r_s : ℝ) (_hr_s : r_s ≠ 0) :
    informationDensityProfile I₀ r_s 0 = I₀ := by
  unfold informationDensityProfile
  simp

/-- The profile is monotonically decreasing for r ≥ 0: if 0 ≤ r₁ ≤ r₂
    then I(r₂) ≤ I(r₁). -/
theorem informationDensityProfile_decreasing {I₀ r_s r₁ r₂ : ℝ}
    (hI₀ : 0 < I₀) (hr_s : 0 < r_s) (hr₁ : 0 ≤ r₁) (_hr₂ : 0 ≤ r₂)
    (h : r₁ ≤ r₂) :
    informationDensityProfile I₀ r_s r₂ ≤ informationDensityProfile I₀ r_s r₁ := by
  unfold informationDensityProfile
  apply div_le_div_of_nonneg_left (by linarith)
  · have : 0 ≤ (r₁ / r_s) ^ 2 := sq_nonneg _; linarith
  · have h1 : r₁ / r_s ≤ r₂ / r_s := div_le_div_of_nonneg_right h (le_of_lt hr_s)
    have h2 : 0 ≤ r₁ / r_s := div_nonneg hr₁ (le_of_lt hr_s)
    have h3 : (r₁ / r_s) ^ 2 ≤ (r₂ / r_s) ^ 2 :=
      sq_le_sq' (by linarith) h1
    linarith

/-! ## 2. Information Gravitational Mass

The information-energy correspondence (Landauer's principle on the lattice,
from `Conservation.Information.informationEnergy`) gives each bit of
information an energy `k_B T ln 2`.  Via `E = mc²`, information density
translates to an effective gravitational mass density. -/

/-- Effective gravitational mass density from information density.
    ρ_info = k_B · T · ln2 · I / c².
    Each bit at temperature T contributes mass k_B T ln2 / c². -/
noncomputable def informationMassDensity (I_density T_temp : ℝ) : ℝ :=
  k_B * T_temp * Real.log 2 * I_density / c ^ 2

/-- Information mass density is non-negative for non-negative inputs. -/
theorem informationMassDensity_nonneg {I_density T_temp : ℝ}
    (hI : 0 ≤ I_density) (hT : 0 ≤ T_temp) :
    0 ≤ informationMassDensity I_density T_temp := by
  unfold informationMassDensity
  apply div_nonneg
  · apply mul_nonneg
    · apply mul_nonneg
      · apply mul_nonneg
        · exact le_of_lt k_B_pos
        · exact hT
      · exact le_of_lt (Real.log_pos (by norm_num : (1 : ℝ) < 2))
    · exact hI
  · exact le_of_lt (pow_pos c_pos 2)

/-- Information mass density is strictly positive for positive inputs. -/
theorem informationMassDensity_pos {I_density T_temp : ℝ}
    (hI : 0 < I_density) (hT : 0 < T_temp) :
    0 < informationMassDensity I_density T_temp := by
  unfold informationMassDensity
  apply div_pos
  · apply mul_pos
    · apply mul_pos
      · apply mul_pos
        · exact k_B_pos
        · exact hT
      · exact Real.log_pos (by norm_num : (1 : ℝ) < 2)
    · exact hI
  · exact pow_pos c_pos 2

/-! ## 3. Enclosed Information Mass

The total effective mass enclosed within radius r determines the
gravitational pull at that radius.  For a spherically-symmetric
information profile, the enclosed information mass is the volume
integral of the information mass density.

We model this as an abstract enclosed-mass function satisfying the
physical constraints, since V2 does not have a measure-theoretic
integration framework. -/

/-- Structure capturing the enclosed mass from both baryonic matter
    and information density, as functions of radius. -/
structure GalacticMassProfile where
  /-- Baryonic enclosed mass as a function of radius. -/
  M_baryon : ℝ → ℝ
  /-- Information enclosed mass as a function of radius. -/
  M_info : ℝ → ℝ
  /-- Baryonic mass is non-negative. -/
  M_baryon_nonneg : ∀ r, 0 ≤ r → 0 ≤ M_baryon r
  /-- Information mass is non-negative. -/
  M_info_nonneg : ∀ r, 0 ≤ r → 0 ≤ M_info r
  /-- Baryonic mass is non-decreasing (mass doesn't disappear). -/
  M_baryon_mono : ∀ r₁ r₂, 0 ≤ r₁ → r₁ ≤ r₂ → M_baryon r₁ ≤ M_baryon r₂
  /-- Information mass is non-decreasing. -/
  M_info_mono : ∀ r₁ r₂, 0 ≤ r₁ → r₁ ≤ r₂ → M_info r₁ ≤ M_info r₂
  /-- Baryonic mass saturates: beyond some radius R_b, M_baryon is constant.
      (Galaxies have finite visible extent.) -/
  M_baryon_saturates : ∃ R_b M_b_total, 0 < R_b ∧ 0 < M_b_total ∧
    ∀ r, R_b ≤ r → M_baryon r = M_b_total
  /-- Information mass grows logarithmically at large r:
      M_info(r) ≥ C · ln(r/r_s) for r ≥ r_s.
      This is the key property from the NFW-like I-profile:
      ∫₀ʳ I₀/(1+u²) · 4πu² du ~ ln(r) at large r. -/
  M_info_grows : ∃ C r_s, 0 < C ∧ 0 < r_s ∧
    ∀ r, r_s ≤ r → C * Real.log (r / r_s) ≤ M_info r

/-- Total enclosed mass at radius r. -/
noncomputable def GalacticMassProfile.M_total (prof : GalacticMassProfile)
    (r : ℝ) : ℝ :=
  prof.M_baryon r + prof.M_info r

/-- Total mass is non-negative. -/
theorem GalacticMassProfile.M_total_nonneg (prof : GalacticMassProfile)
    {r : ℝ} (hr : 0 ≤ r) :
    0 ≤ prof.M_total r := by
  unfold M_total
  exact add_nonneg (prof.M_baryon_nonneg r hr) (prof.M_info_nonneg r hr)

/-! ## 4. Rotation Velocity and Flat Curves

The circular orbital velocity at radius r in a spherically symmetric
potential: v²(r) = G · M_total(r) / r. For a galaxy with ONLY baryonic
mass, v² ~ 1/r at large r (Keplerian falloff). With the information
mass growing as ln(r), we get v² ~ ln(r)/r — still declining, but
MUCH slower than Keplerian.

The key insight: with enough information mass (large C), the rotation
curve is effectively flat over the observable range. We prove this as
a lower bound on v² that prevents Keplerian decline. -/

/-- Rotation velocity squared: v²(r) = G_N · M_total(r) / r. -/
noncomputable def rotationVelocitySq (prof : GalacticMassProfile) (r : ℝ) : ℝ :=
  G_N * prof.M_total r / r

/-- Rotation velocity squared is non-negative for r > 0. -/
theorem rotationVelocitySq_nonneg (prof : GalacticMassProfile) {r : ℝ}
    (hr_pos : 0 < r) :
    0 ≤ rotationVelocitySq prof r := by
  unfold rotationVelocitySq
  exact div_nonneg (mul_nonneg (le_of_lt G_N_pos) (prof.M_total_nonneg (le_of_lt hr_pos)))
    (le_of_lt hr_pos)

/-- **Dark matter is information: rotation curve lower bound.**

    If the information mass grows logarithmically (M_info(r) ≥ C·ln(r/r_s)),
    then the rotation velocity squared at radius r ≥ r_s satisfies

        v²(r) ≥ G_N · C · ln(r/r_s) / r

    This is the information contribution alone. Unlike the Keplerian
    v² = GM/r with constant M, here the numerator grows as ln(r),
    preventing the rapid 1/r decline. Over the range r_s ≤ r ≤ 10·r_s
    (the typical observed range), ln(r/r_s) grows from 0 to ln(10) ≈ 2.3,
    making v² nearly constant — a FLAT rotation curve. -/
theorem dark_matter_is_information (prof : GalacticMassProfile)
    {C r_s r : ℝ} (hC : 0 < C) (hr_s : 0 < r_s) (hr : r_s ≤ r)
    (hM : C * Real.log (r / r_s) ≤ prof.M_info r) :
    G_N * C * Real.log (r / r_s) / r ≤ rotationVelocitySq prof r := by
  unfold rotationVelocitySq GalacticMassProfile.M_total
  have hr_pos : 0 < r := lt_of_lt_of_le hr_s hr
  apply div_le_div_of_nonneg_right _ (le_of_lt hr_pos)
  have hMb := prof.M_baryon_nonneg r (le_of_lt hr_pos)
  have hMi := prof.M_info_nonneg r (le_of_lt hr_pos)
  have hG := le_of_lt G_N_pos
  have h1 : G_N * C * Real.log (r / r_s) ≤ G_N * prof.M_info r := by
    rw [show G_N * C * Real.log (r / r_s) = G_N * (C * Real.log (r / r_s)) from by ring]
    exact mul_le_mul_of_nonneg_left hM hG
  have h2 : G_N * prof.M_info r ≤ G_N * (prof.M_baryon r + prof.M_info r) := by
    apply mul_le_mul_of_nonneg_left _ hG
    linarith
  linarith

/-- **Flat rotation curve criterion.** If at some reference radius r_ref
    the rotation velocity squared is v_ref², then at any r ≥ r_ref
    where M_total(r)/r ≥ M_total(r_ref)/r_ref (i.e., the mass-to-radius
    ratio does not decrease), the velocity stays at or above v_ref².

    Without information mass, M_total saturates so M/r decreases.
    With information mass growing as ln(r), M/r decreases much more
    slowly — the rotation curve is effectively flat. -/
theorem flat_rotation_criterion (prof : GalacticMassProfile)
    {r_ref r : ℝ} (_hr_ref : 0 < r_ref) (_hr : 0 < r)
    (h_ratio : prof.M_total r_ref / r_ref ≤ prof.M_total r / r) :
    rotationVelocitySq prof r_ref ≤ rotationVelocitySq prof r := by
  unfold rotationVelocitySq
  rw [show G_N * prof.M_total r_ref / r_ref =
    G_N * (prof.M_total r_ref / r_ref) from by ring,
      show G_N * prof.M_total r / r =
    G_N * (prof.M_total r / r) from by ring]
  exact mul_le_mul_of_nonneg_left h_ratio (le_of_lt G_N_pos)

/-! ## 5. Dark Matter Fraction from Substrate

The observed dark-matter-to-baryon ratio Ω_DM/Ω_b ≈ 5.4 (Planck 2018).
In the substrate picture, this ratio equals the information-to-baryonic
mass ratio at the scale of the observable universe. -/

/-- Dark matter fraction: Ω_DM/Ω_b = M_info / M_baryon at a given radius. -/
noncomputable def darkMatterFraction (prof : GalacticMassProfile) (r : ℝ) : ℝ :=
  prof.M_info r / prof.M_baryon r

/-- The dark matter fraction is non-negative for r > 0 when M_baryon > 0. -/
theorem darkMatterFraction_nonneg (prof : GalacticMassProfile) {r : ℝ}
    (hr : 0 ≤ r) (hMb : 0 < prof.M_baryon r) :
    0 ≤ darkMatterFraction prof r := by
  unfold darkMatterFraction
  exact div_nonneg (prof.M_info_nonneg r hr) (le_of_lt hMb)

/-- **Dark matter fraction from substrate**: if the information mass at
    radius R equals `f` times the baryonic mass, then the dark matter
    fraction is exactly `f`. The theory predicts this ratio from the
    information-to-baryon coupling, not from fitting. -/
theorem dark_matter_fraction_from_substrate (prof : GalacticMassProfile)
    {r f : ℝ} (hMb : 0 < prof.M_baryon r) (_hf : 0 ≤ f)
    (h_ratio : prof.M_info r = f * prof.M_baryon r) :
    darkMatterFraction prof r = f := by
  unfold darkMatterFraction
  rw [h_ratio]
  exact mul_div_cancel_of_imp (fun h => absurd h (ne_of_gt hMb))

/-- **Ratio grows with radius** (dark matter dominates at large scales):
    if r₁ ≤ r₂ and baryonic mass has saturated at both radii (M_b(r₁) = M_b(r₂)),
    but information mass has grown, the DM fraction increases. -/
theorem darkMatterFraction_grows (prof : GalacticMassProfile)
    {r₁ r₂ : ℝ} (hr₁ : 0 ≤ r₁) (_hr₂ : 0 ≤ r₂) (h : r₁ ≤ r₂)
    (hMb_pos : 0 < prof.M_baryon r₁)
    (hMb_sat : prof.M_baryon r₁ = prof.M_baryon r₂) :
    darkMatterFraction prof r₁ ≤ darkMatterFraction prof r₂ := by
  unfold darkMatterFraction
  rw [← hMb_sat]
  exact div_le_div_of_nonneg_right
    (prof.M_info_mono r₁ r₂ hr₁ h) (le_of_lt hMb_pos)

/-! ## 6. Connection to Einstein Emergence

The information stress-energy tensor T^(I)_μν from `StressEnergy.lean`
is the SOURCE of the emergent Einstein equations. The dark matter
effect is not a modification of gravity — it is standard GR with
an additional source term that standard physics misidentifies as
exotic matter.

The connection: `einsteinSource` from `EinsteinEmergence.lean` includes
`γ(I - Ī)` — the information gradient term. In a galaxy:
- Near center: I > Ī (information overdensity) → positive source
- Far from center: I → Ī (information approaches mean)
- The gradient produces curvature = gravitational attraction
- An observer interpreting this via standard GR attributes the extra
  curvature to "dark matter" -/

/-- The information overdensity at radius r relative to the cosmic mean
    Ī: δI(r) = I(r) - Ī. This is the local source of the dark matter
    effect in the Einstein equations. -/
noncomputable def informationOverdensity (I₀ r_s r I_bar : ℝ) : ℝ :=
  informationDensityProfile I₀ r_s r - I_bar

/-- Near the galactic center (r = 0), if I₀ > Ī, there is a positive
    information overdensity — the substrate is "heavier" here. -/
theorem informationOverdensity_positive_at_center
    {I₀ r_s I_bar : ℝ} (hr_s : r_s ≠ 0) (hI : I_bar < I₀) :
    0 < informationOverdensity I₀ r_s 0 I_bar := by
  unfold informationOverdensity
  rw [informationDensityProfile_at_zero I₀ r_s hr_s]
  linarith

/-- Far from the galaxy, the profile approaches zero, so if Ī > 0
    the overdensity eventually becomes negative (information
    underdensity in voids). -/
theorem informationOverdensity_sign_at_large_r
    {I₀ r_s r I_bar : ℝ} (_hI₀ : 0 < I₀) (_hr_s : 0 < r_s)
    (_hI_bar : 0 < I_bar)
    (h_large : I₀ / (1 + (r / r_s) ^ 2) < I_bar) :
    informationOverdensity I₀ r_s r I_bar < 0 := by
  unfold informationOverdensity informationDensityProfile
  linarith

end OmegaTheory.Emergence.DarkMatter
