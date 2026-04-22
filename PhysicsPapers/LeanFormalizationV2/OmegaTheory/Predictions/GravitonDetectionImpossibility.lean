/-
  OmegaTheory.Predictions.GravitonDetectionImpossibility

  **Graviton detection impossibility (Dyson–Rovelli style argument).**

  Claim.  Any detector with energy-resolution sufficient to resolve a
  single graviton quantum of energy at or above the Planck energy `E_P`
  must either

    (1)  violate the Bekenstein bound (unphysical:
         `bekensteinBound detector ≤ 0`), or
    (2)  have collapsed to a black hole (`isBH detector`).

  Formally, for every `detector` satisfying `canResolve E_graviton
  detector` and confined to a region at most one graviton wavelength
  wide (`radius ≤ ℓ_P`), one of the two disjuncts holds:

    `∀ d, d.radius ≤ ℓ_P → canResolve E_graviton d
        → (bekensteinBound d ≤ 0 ∨ isBH d)`.

  The argument.  To resolve a single quantum whose energy `E` satisfies
  `E ≥ E_P`, the detector must (i) have mass-energy at least `E` inside
  a region smaller than the graviton wavelength `λ = ℏ c / E ≤ ℓ_P`, and
  (ii) support enough independent degrees of freedom (bits) to
  distinguish the single-quantum signal from noise.  Crucially, if
  the detector mass-energy fits inside its own Schwarzschild radius
  (`R ≤ r_s(M) = 2GM/c²`), the detector is a black hole — its horizon
  precedes detection.  At the Planck scale, these two conditions become
  mutually exclusive: resolving a Planck-energy quantum requires mass
  at least `M_P` inside a region `≤ ℓ_P`, and `r_s(M_P) = 2 ℓ_P > ℓ_P`.
  The detector cannot both (a) resolve the graviton AND (b) avoid
  horizon collapse.

  What is formalised.

  * `Detector` — a record bundling the two relevant physical
    observables: the detector's mass-energy content `mass` (kg) and
    its confinement radius `radius` (m).
  * `canResolve E d` — the detector has energy resolution at least `E`;
    operationally, its mass-energy `M · c²` can register a quantum at
    energy `E`, i.e. `E ≤ M · c²`.
  * `isBH d` — the detector fits inside its own Schwarzschild radius.
  * `bekensteinBound d` — the Susskind–Bekenstein bit bound on a ball
    of radius `R` containing mass-energy `M`: `2π · R · M · c / ℏ`.
  * `graviton_detection_impossibility` — headline theorem.

  Honest scope.

  * The `2π` prefactor is the standard Bekenstein bound coefficient.
    Our theorem is ABOUT the structural disjunction, not about the
    coefficient.
  * We impose `R ≤ ℓ_P` as a hypothesis (the graviton-wavelength
    constraint from λ = ℏc/E_P = ℓ_P).
  * The result is a NO-GO about detection, not about gravitons
    themselves — gravitons as field quanta exist unambiguously (see
    `Emergence/Gravitons.lean`).

  No `sorry`.  No new axioms.  Author: Nunki (σ Sagittarii), 2026-04-19.
-/

import OmegaTheory.Emergence.BekensteinBound
import OmegaTheory.Emergence.Gravitons
import OmegaTheory.Emergence.BlackHoleFormation
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Predictions.GravitonDetectionImpossibility

open OmegaTheory.Spacetime
open OmegaTheory.Emergence
open OmegaTheory.Emergence.BlackHoleFormation

/-! ## §1  Detector structure -/

/-- **Detector**: a physical apparatus with two scalar observables:

    * `mass` — the detector's mass-energy content (kg).
    * `radius` — the linear size of the region confining that mass (m).

    These two numbers are all that enter the Dyson–Rovelli argument:
    Bekenstein bound uses `R · M`, BH condition uses `R` vs `r_s(M)`, and
    resolution uses `M · c²`. -/
structure Detector where
  /-- Mass-energy content of the detector (kg). -/
  mass : ℝ
  /-- Radius of the smallest region confining the detector mass (m). -/
  radius : ℝ

namespace Detector

/-- A detector is **physical** if both its mass and radius are strictly
    positive. -/
def IsPhysical (d : Detector) : Prop := 0 < d.mass ∧ 0 < d.radius

theorem mass_pos_of_physical {d : Detector} (h : d.IsPhysical) : 0 < d.mass :=
  h.1

theorem radius_pos_of_physical {d : Detector} (h : d.IsPhysical) : 0 < d.radius :=
  h.2

end Detector

/-! ## §2  Bekenstein bit bound on the detector -/

/-- **Bekenstein bit bound** on the detector, in the Susskind–Bekenstein
    form `2π · R · M · c / ℏ`. -/
noncomputable def bekensteinBound (d : Detector) : ℝ :=
  2 * Real.pi * d.radius * d.mass * c / hbar

/-- For a physical detector, the Bekenstein bound is strictly positive. -/
theorem bekensteinBound_pos {d : Detector} (h : d.IsPhysical) :
    0 < bekensteinBound d := by
  unfold bekensteinBound
  have hR : 0 < d.radius := h.2
  have hM : 0 < d.mass := h.1
  have hc : 0 < c := c_pos
  have hℏ : 0 < hbar := hbar_pos
  positivity

/-! ## §3  Resolution predicate and black-hole predicate -/

/-- **The detector can resolve an energy quantum `E`** iff its
    mass-energy content `M · c²` is at least `E`.  Operationally, a
    detector whose total mass-energy is below `E` cannot register a
    single quantum of energy `E` against noise. -/
def canResolve (E : ℝ) (d : Detector) : Prop :=
  E ≤ d.mass * c ^ 2

/-- **The detector is a black hole** iff its confinement radius fits
    inside its own Schwarzschild radius.  Re-uses
    `BlackHoleFormation.BlackHoleFormed`. -/
def isBH (d : Detector) : Prop :=
  0 < d.mass ∧ 0 < d.radius ∧ d.radius ≤ schwarzschildRadius d.mass

/-- Equivalence: `isBH d` unfolds to `BlackHoleFormed d.mass d.radius`. -/
theorem isBH_iff_blackHoleFormed (d : Detector) :
    isBH d ↔ BlackHoleFormed d.mass d.radius := Iff.rfl

/-! ## §4  Graviton energy threshold -/

/-- **Graviton detection energy threshold**: the Planck energy.  At or
    above this energy, single-quantum detection runs into the
    Dyson–Rovelli no-go.  The specific quantum under discussion (field
    graviton at Planck frequency `ω_P = c / ℓ_P`) has energy exactly
    `hbar · ω_P = E_P`. -/
noncomputable def E_graviton : ℝ := E_P

theorem E_graviton_pos : 0 < E_graviton := E_P_pos

/-! ## §5  Algebraic helpers -/

/-- Schwarzschild radius is monotone in mass. -/
theorem schwarzschildRadius_mono {M₁ M₂ : ℝ} (h : M₁ ≤ M₂) :
    schwarzschildRadius M₁ ≤ schwarzschildRadius M₂ := by
  unfold schwarzschildRadius OmegaTheory.Conservation.schwarzschildRadius
  have h2G : 0 ≤ 2 * G_N :=
    le_of_lt (mul_pos (by norm_num : (0:ℝ) < 2) G_N_pos)
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  apply div_le_div_of_nonneg_right _ (le_of_lt hc2)
  exact mul_le_mul_of_nonneg_left h h2G

/-- `r_s(M_P) = 2·ℓ_P`.  Follows from `M_P = ℏ/(ℓ_P·c)` and `ℓ_P² = ℏG/c³`:
        `r_s(M_P) = 2·G·M_P / c² = 2·G·ℏ / (ℓ_P·c³) = 2·ℓ_P²·c³ / (ℓ_P·c³)
                 = 2·ℓ_P`. -/
theorem schwarzschildRadius_planckMass :
    schwarzschildRadius M_P = 2 * l_P := by
  unfold schwarzschildRadius OmegaTheory.Conservation.schwarzschildRadius
  unfold M_P E_P t_P
  -- Goal: 2 · G_N · (hbar / (l_P / c) / c^2) / c^2 = 2 · l_P
  have hc : 0 < c := c_pos
  have hℏ : 0 < hbar := hbar_pos
  have hG : 0 < G_N := G_N_pos
  have hlP : 0 < l_P := l_P_pos
  have hc_ne : c ≠ 0 := ne_of_gt hc
  have hℏ_ne : hbar ≠ 0 := ne_of_gt hℏ
  have hG_ne : G_N ≠ 0 := ne_of_gt hG
  have hlP_ne : l_P ≠ 0 := ne_of_gt hlP
  have hc2_pos : 0 < c ^ 2 := pow_pos hc 2
  have hc2_ne : (c : ℝ) ^ 2 ≠ 0 := pow_ne_zero 2 hc_ne
  have hc3_pos : 0 < c ^ 3 := pow_pos hc 3
  have hc3_ne : (c : ℝ) ^ 3 ≠ 0 := pow_ne_zero 3 hc_ne
  -- Use the defining equation `l_P² = ℏ G / c³`:
  have hlP_sq : l_P ^ 2 = hbar * G_N / c ^ 3 := by
    unfold l_P
    rw [Real.sq_sqrt (le_of_lt (div_pos (mul_pos hℏ hG) hc3_pos))]
  -- Hence `ℏ G = l_P² · c³`.
  have hhG_eq : hbar * G_N = l_P ^ 2 * c ^ 3 := by
    have := hlP_sq
    field_simp at this
    linarith
  -- LHS: 2·G·(ℏ/(ℓ_P/c)/c²)/c² = 2·G·ℏ·c/(ℓ_P·c²·c²) = 2·G·ℏ/(ℓ_P·c³).
  -- Substitute `G·ℏ = l_P² · c³`:
  -- = 2·l_P²·c³ / (l_P·c³) = 2·l_P.
  have hlPc_ne : l_P / c ≠ 0 := div_ne_zero hlP_ne hc_ne
  -- Rewrite the LHS into clean form.
  have hlhs_eq : 2 * G_N * (hbar / (l_P / c) / c ^ 2) / c ^ 2
        = 2 * (G_N * hbar) / (l_P * c ^ 3) := by
    field_simp
  rw [hlhs_eq]
  -- Now: 2 * (G_N * hbar) / (l_P * c^3) = 2 * l_P.
  -- G_N * hbar = hbar * G_N = l_P^2 * c^3 (from hhG_eq).
  have hGℏ_eq : G_N * hbar = l_P ^ 2 * c ^ 3 := by linarith [hhG_eq]
  rw [hGℏ_eq]
  -- Now: 2 * (l_P^2 * c^3) / (l_P * c^3) = 2 * l_P.
  have hlPc3_ne : l_P * c ^ 3 ≠ 0 := mul_ne_zero hlP_ne hc3_ne
  field_simp

/-! ## §6  Main theorem: graviton detection impossibility -/

/-- **Graviton detection impossibility — main theorem.**

    For any detector `d` with confinement radius hypothesis `R ≤ ℓ_P`
    (at most the graviton wavelength at Planck energy), if `d` resolves
    `E_graviton = E_P` then either

      (i)  `d` is non-physical (its Bekenstein bound is ≤ 0), or
      (ii) `d` has collapsed to a black hole.

    Both disjuncts preclude `d` from functioning as a graviton
    detector: (i) is not a real apparatus, (ii) emits only Hawking
    radiation and cannot return a resolved single-quantum readout.

    Combined with `R ≤ ℓ_P`, this is the Dyson (2013) / Rovelli (2013)
    no-go statement, formalized on the OmegaTheory substrate. -/
theorem graviton_detection_impossibility
    (d : Detector)
    (h_radius_below_planck : d.radius ≤ l_P)
    (h_resolve : canResolve E_graviton d) :
    bekensteinBound d ≤ 0 ∨ isBH d := by
  -- The resolution hypothesis forces M > 0 (since E_P > 0 and c² > 0).
  unfold canResolve E_graviton at h_resolve
  have hEP_pos : 0 < E_P := E_P_pos
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  have hMc2_pos : 0 < d.mass * c ^ 2 := lt_of_lt_of_le hEP_pos h_resolve
  have hM_pos : 0 < d.mass := by
    -- 0 < M·c² and c² > 0 ⟹ M > 0
    rcases (mul_pos_iff.mp hMc2_pos) with ⟨hm, _⟩ | ⟨_, hc2_neg⟩
    · exact hm
    · exact absurd hc2 (not_lt.mpr (le_of_lt hc2_neg))
  -- Case split on whether R > 0.  Since `canResolve` forces M > 0, the
  -- only non-physical sub-case is R ≤ 0.
  by_cases hR_pos : 0 < d.radius
  · -- Physical detector: both M > 0 and R > 0.  Show it's a BH.
    right
    -- From canResolve: M ≥ E_P / c² = M_P.
    have hM_ge_MP : M_P ≤ d.mass := by
      unfold M_P
      rw [div_le_iff₀ hc2]
      linarith
    -- r_s(M_P) ≤ r_s(M), and r_s(M_P) = 2·ℓ_P.
    have h_rs_mono : schwarzschildRadius M_P ≤ schwarzschildRadius d.mass :=
      schwarzschildRadius_mono hM_ge_MP
    have h_rs_MP : schwarzschildRadius M_P = 2 * l_P :=
      schwarzschildRadius_planckMass
    have h_rs_d : 2 * l_P ≤ schwarzschildRadius d.mass := by
      rw [← h_rs_MP]; exact h_rs_mono
    -- R ≤ ℓ_P ≤ 2·ℓ_P ≤ r_s(M).
    have h_lP_le : l_P ≤ 2 * l_P := by linarith [l_P_nonneg]
    have h_R_le_rs : d.radius ≤ schwarzschildRadius d.mass :=
      le_trans h_radius_below_planck (le_trans h_lP_le h_rs_d)
    exact ⟨hM_pos, hR_pos, h_R_le_rs⟩
  · -- Non-physical detector: R ≤ 0.  Bekenstein bound ≤ 0.
    left
    have hR_nonpos : d.radius ≤ 0 := not_lt.mp hR_pos
    unfold bekensteinBound
    -- Numerator sign: 2π > 0, R ≤ 0, M > 0, c > 0 ⟹ numerator ≤ 0.
    have h2pi_pos : 0 < 2 * Real.pi := by positivity
    have hc_pos : 0 < c := c_pos
    have hℏ_pos : 0 < hbar := hbar_pos
    -- Show 2π·R·M·c ≤ 0.
    have h2piR_nonpos : 2 * Real.pi * d.radius ≤ 0 := by
      -- 2π > 0, R ≤ 0 ⟹ 2π·R ≤ 0
      have step : 2 * Real.pi * d.radius ≤ 2 * Real.pi * 0 :=
        mul_le_mul_of_nonneg_left hR_nonpos (le_of_lt h2pi_pos)
      simpa using step
    have h_three_nonpos : 2 * Real.pi * d.radius * d.mass ≤ 0 := by
      -- 2π·R ≤ 0 and M > 0 ⟹ 2π·R·M ≤ 0
      have : 2 * Real.pi * d.radius * d.mass ≤ 0 * d.mass := by
        apply mul_le_mul_of_nonneg_right h2piR_nonpos (le_of_lt hM_pos)
      simpa using this
    have h_four_nonpos : 2 * Real.pi * d.radius * d.mass * c ≤ 0 := by
      have : 2 * Real.pi * d.radius * d.mass * c ≤ 0 * c := by
        apply mul_le_mul_of_nonneg_right h_three_nonpos (le_of_lt hc_pos)
      simpa using this
    -- Divide by ℏ > 0: preserves sign.
    exact div_nonpos_of_nonpos_of_nonneg h_four_nonpos (le_of_lt hℏ_pos)

/-! ## §7  Paper-level headline -/

/-- **Paper headline**: Any detector resolving a single graviton (at or
    above Planck energy) with confinement below the graviton wavelength
    `≤ ℓ_P` must either fail the Bekenstein bound or collapse to a BH.

    The Dyson (2013) / Rovelli (2013) single-graviton no-go theorem,
    formalized on the OmegaTheory substrate via the Bekenstein bit
    bound.  Experimental implication: no foreseeable technology can
    resolve a single graviton; gravitons are detectable in aggregate
    (LIGO GW150914 ~10⁷⁷ gravitons) but unresolvable
    quantum-by-quantum. -/
theorem any_single_graviton_detector_is_bh_or_unphysical :
    ∀ (d : Detector), d.radius ≤ l_P → canResolve E_graviton d →
      (bekensteinBound d ≤ 0 ∨ isBH d) :=
  fun d h_rad h_res => graviton_detection_impossibility d h_rad h_res

end OmegaTheory.Predictions.GravitonDetectionImpossibility
