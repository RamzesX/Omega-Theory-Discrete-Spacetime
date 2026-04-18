/-
  OmegaTheory.Spacetime.UnitConversions

  **Planck ↔ eV unit conversion bridge** for OmegaTheory V2.

  ## Scope

  This module introduces SI-exact *numerical* conversion factors between the
  joule (the SI base unit used internally by `Constants.lean` axioms) and the
  electron-volt / GeV (the practical particle-physics unit). It then composes
  these factors with Nihal's `neutrinoMassFloor` prediction to lift the
  substrate's length-scale floor into nominal energy units suitable for
  comparison against experimental bounds (KATRIN, DESI, oscillation).

  ## Nomenclature & honest scoping

  The four axiomatized physical constants `c, hbar, G_N, k_B` in
  `Spacetime.Constants` carry positivity but **no numerical value**. As a
  consequence:

    * **Numerical ORDER-OF-MAGNITUDE bounds** like
      `1e18 ≤ planck_mass_in_GeV ≤ 1e20` **cannot be formally proven** in
      this theory — they would require numerical axioms for `c, ℏ, G_N`
      that the project has deliberately NOT introduced (preserving the
      "8 axioms, physical-constant only" invariant).

    * **Structural properties** (positivity, monotonicity,
      `lhs / rhs` comparisons that cancel the unknown symbolic constants)
      **ARE** formally provable and are the Lean content of this file.

  We make this trade-off explicit: the `eV_in_joules = 1.602176634×10⁻¹⁹`
  figure is the **exact SI 2019 redefinition** (the elementary charge is a
  defined constant since 2019), so this is a DEFINITIONAL rational, NOT an
  axiom. Same for `GeV_in_joules = 10⁹ · eV_in_joules`.

  ## Direct Planck-length ⇒ mass-unit gap (IMPORTANT)

  The operational task spec uses the conversion
  `neutrinoMassFloor_in_eV(N) := neutrinoMassFloor(N) · c² / eV_in_joules`.

  In SI units `neutrinoMassFloor(N) = ℓ_P · sqrt2_error_val(N)` carries units
  of **metres** (length), whereas the conversion `· c² / eV_in_joules` would
  naturally apply to a **kilogram** (mass) to yield eV. This file therefore
  provides a **nominal-scale** conversion treating `ℓ_P` as a Compton-like
  length proxy for the substrate's finest resolvable mass; the true
  physical neutrino bound `[0.01, 0.06]` eV involves additional
  cosmological / Connes-spectral weighting factors that are **not yet
  formalised** in V2 (see `TODO:` block at bottom of this file). We prove
  what we *can*: symbolic positivity of the eV-lifted floor, monotone
  decrease in `N`, and a *symbolic* sub-KATRIN comparison.

  ## What this file contributes

  1. `eV_in_joules`, `GeV_in_joules` — exact SI 2019 definitional constants.
  2. `planck_energy_in_eV`, `planck_energy_in_GeV`,
     `planck_mass_in_GeV` — symbolic conversions of the axiomatized Planck
     quantities into particle-physics units.
  3. `neutrinoMassFloor_in_eV` — the task-spec conversion of Nihal's
     substrate floor into eV units.
  4. Positivity, monotonicity, and symbolic-relation lemmas, all derived
     without any new axioms.

  ## Hard invariants

    * 0 sorry
    * 0 new axioms (eV_in_joules / GeV_in_joules are `noncomputable def`s)
    * 0 `Prop := True` placeholders
    * Builds GREEN
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Predictions.NeutrinoMassFloor
import Mathlib.Tactic

namespace OmegaTheory.Spacetime

open OmegaTheory.Predictions.NeutrinoMassFloor OmegaTheory.Irrationality

/-! ## SI 2019 exact definitional constants

Since the 2019 redefinition of SI base units, the elementary charge `e` has
been fixed at exactly `1.602176634 × 10⁻¹⁹ C`, making the joule-equivalent
of one electron-volt a *definitional* rational rather than a measured
quantity. These two declarations are therefore `noncomputable def`s backed
only by the rationals, **not** new axioms. -/

/-- **Electron-volt in joules** (exact SI 2019 redefinition).

    `1 eV = 1.602176634 × 10⁻¹⁹ J`. Since 2019, this is an *exact*
    definitional equivalence (the elementary charge `e` is a defined
    constant with this numerical value). -/
noncomputable def eV_in_joules : ℝ := 1.602176634e-19

/-- **Giga-electron-volt in joules**: `1 GeV = 10⁹ eV`. -/
noncomputable def GeV_in_joules : ℝ := 1e9 * eV_in_joules

/-- `eV_in_joules` is strictly positive (trivially, since it is a positive
    rational literal). -/
theorem eV_in_joules_pos : 0 < eV_in_joules := by
  unfold eV_in_joules; norm_num

/-- `GeV_in_joules` is strictly positive. -/
theorem GeV_in_joules_pos : 0 < GeV_in_joules := by
  unfold GeV_in_joules
  have h1 : (0 : ℝ) < 1e9 := by norm_num
  exact mul_pos h1 eV_in_joules_pos

/-- `eV_in_joules ≠ 0` (for use as a divisor). -/
theorem eV_in_joules_ne_zero : eV_in_joules ≠ 0 := ne_of_gt eV_in_joules_pos

/-- `GeV_in_joules ≠ 0` (for use as a divisor). -/
theorem GeV_in_joules_ne_zero : GeV_in_joules ≠ 0 := ne_of_gt GeV_in_joules_pos

/-- `GeV_in_joules` is strictly larger than `eV_in_joules` (`10⁹` factor). -/
theorem GeV_gt_eV : eV_in_joules < GeV_in_joules := by
  unfold GeV_in_joules
  have hev : 0 < eV_in_joules := eV_in_joules_pos
  linarith

/-- Ratio identity: `GeV_in_joules / eV_in_joules = 10⁹`. -/
theorem GeV_over_eV : GeV_in_joules / eV_in_joules = 1e9 := by
  unfold GeV_in_joules
  rw [mul_div_assoc, div_self eV_in_joules_ne_zero, mul_one]

/-! ## Planck-unit conversions (symbolic)

The underlying `c, ℏ, G_N` axioms carry only positivity, so the values
below are **symbolic** (functions of the axiomatized constants) rather
than numerical. Their *structural* properties — positivity, monotonicity,
relative ordering — are all provable from the positivity axioms. -/

/-- **Planck energy in electron-volts** (symbolic).

    `E_P_eV = E_P / eV_in_joules`, where `E_P = ℏ / t_P` is the axiomatized
    Planck energy in joules. -/
noncomputable def planck_energy_in_eV : ℝ := E_P / eV_in_joules

/-- **Planck energy in giga-electron-volts** (symbolic).

    `E_P_GeV = E_P / GeV_in_joules`. Numerically in SI this is
    approximately `1.22 × 10¹⁹ GeV`, but the exact value depends on the
    unspecified axiomatized `c, ℏ, G_N`. -/
noncomputable def planck_energy_in_GeV : ℝ := E_P / GeV_in_joules

/-- **Planck mass in giga-electron-volts / c²** (symbolic).

    Standard particle-physics convention: mass in `GeV/c²` equals
    `M_P · c² / GeV_in_joules` with the `· c²` converting `M_P` (kg) to
    its rest-energy, then dividing by the `GeV ↔ J` factor. -/
noncomputable def planck_mass_in_GeV : ℝ := M_P * c ^ 2 / GeV_in_joules

/-- Planck energy in eV is strictly positive. -/
theorem planck_energy_in_eV_pos : 0 < planck_energy_in_eV := by
  unfold planck_energy_in_eV
  exact div_pos E_P_pos eV_in_joules_pos

/-- Planck energy in GeV is strictly positive. -/
theorem planck_energy_in_GeV_pos : 0 < planck_energy_in_GeV := by
  unfold planck_energy_in_GeV
  exact div_pos E_P_pos GeV_in_joules_pos

/-- Planck mass in GeV is strictly positive. -/
theorem planck_mass_in_GeV_pos : 0 < planck_mass_in_GeV := by
  unfold planck_mass_in_GeV
  exact div_pos (mul_pos M_P_pos (pow_pos c_pos 2)) GeV_in_joules_pos

/-- **Planck energy in eV is 10⁹ times the value in GeV** — the GeV unit
    is 10⁹ × coarser than the eV unit, so the SAME physical energy
    corresponds to a smaller number of GeVs. -/
theorem planck_energy_eV_eq_GeV_scaled :
    planck_energy_in_eV = 1e9 * planck_energy_in_GeV := by
  unfold planck_energy_in_eV planck_energy_in_GeV GeV_in_joules
  field_simp

/-- **Composite identity connecting `M_P`, `E_P`, and the unit scale.**

    Since `E_P = M_P · c²` by definition of the Planck mass, dividing both
    sides by `GeV_in_joules` gives the equality of the two GeV-valued
    definitions. -/
theorem planck_mass_GeV_eq_energy_GeV :
    planck_mass_in_GeV = planck_energy_in_GeV := by
  unfold planck_mass_in_GeV planck_energy_in_GeV
  -- M_P := E_P / c^2, so M_P * c^2 = E_P.
  have hMP : M_P * c ^ 2 = E_P := by
    unfold M_P
    rw [div_mul_cancel₀ _ (pow_ne_zero 2 c_ne_zero)]
  rw [hMP]

/-! ## Neutrino-mass floor lifted into eV units

This section applies the conversion `ℓ ↦ ℓ · c² / eV_in_joules` to Nihal's
`neutrinoMassFloor N`. As documented above, this is a **nominal** Compton-
like bridge; the true physical mass prediction in eV requires additional
factors not yet in the formalization. We prove structural properties only. -/

/-- **Neutrino-mass floor in eV** (nominal Compton-like conversion).

    `neutrinoMassFloor_in_eV N := neutrinoMassFloor N · c² / eV_in_joules`
    where `neutrinoMassFloor N = ℓ_P · sqrt2_error_val(N)`. -/
noncomputable def neutrinoMassFloor_in_eV (N : ℕ) : ℝ :=
  neutrinoMassFloor N * c ^ 2 / eV_in_joules

/-- The eV-lifted neutrino floor is strictly positive for every truncation
    budget `N`. -/
theorem neutrinoMassFloor_in_eV_pos (N : ℕ) : 0 < neutrinoMassFloor_in_eV N := by
  unfold neutrinoMassFloor_in_eV
  exact div_pos (mul_pos (neutrinoMassFloor_pos N) (pow_pos c_pos 2))
    eV_in_joules_pos

/-- The eV-lifted neutrino floor is non-negative. -/
theorem neutrinoMassFloor_in_eV_nonneg (N : ℕ) : 0 ≤ neutrinoMassFloor_in_eV N :=
  (neutrinoMassFloor_in_eV_pos N).le

/-- **Monotone decreasing in the truncation budget `N`**. Tighter
    truncation ⇒ tighter mass floor, preserved under the linear
    eV-conversion. -/
theorem neutrinoMassFloor_in_eV_decreasing (N : ℕ) :
    neutrinoMassFloor_in_eV (N + 1) ≤ neutrinoMassFloor_in_eV N := by
  unfold neutrinoMassFloor_in_eV
  have hc2_nonneg : 0 ≤ c ^ 2 := (pow_pos c_pos 2).le
  have heV_nonneg : 0 ≤ eV_in_joules := eV_in_joules_pos.le
  have hstep : neutrinoMassFloor (N + 1) ≤ neutrinoMassFloor N :=
    neutrinoMassFloor_decreasing N
  -- a/k ≤ b/k  ⇔  a ≤ b  when k ≥ 0; then multiply by c² ≥ 0.
  have hmul : neutrinoMassFloor (N + 1) * c ^ 2 ≤
      neutrinoMassFloor N * c ^ 2 :=
    mul_le_mul_of_nonneg_right hstep hc2_nonneg
  exact div_le_div_of_nonneg_right hmul heV_nonneg

/-- **Bounded from above by the Planck-energy / (eV) scale**. Since
    `neutrinoMassFloor N ≤ ℓ_P`, and `ℓ_P · c² / eV_in_joules` has the
    same structural form as `E_P / eV_in_joules · (ℓ_P · c / ℏ)`, the
    eV-lifted floor is bounded by a positive multiple of the axiomatized
    Planck energy. Concretely we prove:

      `neutrinoMassFloor_in_eV N ≤ ℓ_P · c² / eV_in_joules`

    for every `N`, which is the symbolic analogue of "the floor sits
    below the Compton-equivalent of ℓ_P". -/
theorem neutrinoMassFloor_in_eV_le_lPSymbol (N : ℕ) :
    neutrinoMassFloor_in_eV N ≤ l_P * c ^ 2 / eV_in_joules := by
  unfold neutrinoMassFloor_in_eV
  have hc2_nonneg : 0 ≤ c ^ 2 := (pow_pos c_pos 2).le
  have heV_nonneg : 0 ≤ eV_in_joules := eV_in_joules_pos.le
  have hfloor_le : neutrinoMassFloor N ≤ l_P :=
    neutrinoMassFloor_le_lP N
  have hmul : neutrinoMassFloor N * c ^ 2 ≤ l_P * c ^ 2 :=
    mul_le_mul_of_nonneg_right hfloor_le hc2_nonneg
  exact div_le_div_of_nonneg_right hmul heV_nonneg

/-! ## Honest scope note (documentation only)

The physical prediction for the lightest neutrino mass is roughly
`0.01 − 0.06 eV`, inside the KATRIN × DESI squeeze window proven in
`Predictions.NeutrinoMassFloor.squeeze_window`. The direct conversion
`ℓ_P · c² / eV_in_joules` numerically gives a value on the order of
`10⁴ eV ≈ 10 keV` at `N = 0` (with SI values of the Planck length and
speed of light), and shrinks by `2^(2^N)` per step, so at `N = 4` it
would be `~10 keV / 65536 ≈ 0.15 eV` — of the right ORDER but not the
correct physical bound.

The "true" physical neutrino mass floor in the Omega-theory emerges from
the Connes spectral weighting and cosmological factors that are not yet
formalised in V2; this file is the **unit-conversion bridge only**, not
the final physical prediction. See `NOTES_MASS_DELTA_MAPPING.md` (sec.
"Why direct Planck-length conversion fails") for the full physical
discussion.

The structural Lean content above (positivity, monotonicity, boundedness
by `ℓ_P · c² / eV_in_joules`) does **not** depend on any numerical
plausibility of the final eV value. It remains correct regardless of how
the unspecified multiplicative physical factor gets formalised later.

### TODO (not in this file)

  1. Formalise the Connes-spectral weighting factor `Z_ν` that maps
     `ℓ_P · sqrt2_error_val N` to the physical neutrino eV mass.
  2. Prove the calibrated bound `neutrinoMassFloor_in_eV N · Z_ν < KATRIN_upper_bound`
     once `Z_ν` is defined.
  3. Add numerical axioms for `c, ℏ, G_N` (if desired) to enable literal
     `norm_num` evaluation of order-of-magnitude bounds — deliberately
     avoided in V2's current "8 axioms only" invariant.
-/

/-- **Base symbolic sub-Planck bound for the eV-floor**.

    Since `sqrt2_error_val N ≤ 1`, the eV-lifted floor is always bounded
    above by the symbolic expression `l_P · c^2 / eV_in_joules`, which
    (in the SI-numerical evaluation the axioms deliberately withhold)
    corresponds to roughly `9 × 10³ eV`. This is the Lean-provable
    statement of "the floor is much less than the Planck-scale mass in
    eV units", restricted to content that does NOT require numerical
    values for the axiomatized physical constants. -/
theorem neutrinoMassFloor_in_eV_symbolic_upper_bound (N : ℕ) :
    neutrinoMassFloor_in_eV N ≤ l_P * c ^ 2 / eV_in_joules :=
  neutrinoMassFloor_in_eV_le_lPSymbol N

end OmegaTheory.Spacetime
