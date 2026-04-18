/-
  OmegaTheory.Emergence.BlackHoleFormation

  **Classical black-hole formation criterion + substrate-resolution regime +
  Planck-density bounce discharge.**

  This file packages the standard GR / Popławski observations about black
  holes in a lattice-compatible form:

  * **Formation** — a clump of matter of positive mass `M` is in the
    classical black-hole regime whenever it is compressed inside its own
    Schwarzschild radius `r_s(M) = 2GM/c²`.
  * **Substrate resolution** — the horizon is classically meaningful only
    when `ℓ_P < r_s(M)`; below the Planck mass, `r_s(M) < ℓ_P` and the
    classical-horizon picture breaks down (substrate is not refined enough
    to resolve it).
  * **Bounce** — at Planck density, the `OmegaTheory.Torsion.BigBounce`
    sign lemma for `torsionPressure` gives a repulsive contribution that
    the classical singularity cannot turn into attraction.  No *dynamical*
    bounce is claimed here; the conclusion is the Popławski-style
    `torsionPressure < 0` sign check, re-exported as a "high-density
    repulsion" witness keyed on `rho_P`.

  ## Scope and honesty

  We do **not**:
  * re-axiomatise `G_N`, `c`, `ℓ_P`, `M_P` — these are re-used from
    `OmegaTheory.Spacetime.Constants`;
  * re-define `schwarzschildRadius` — it is already defined in
    `OmegaTheory.Conservation.Correspondence`, and everything below is a
    thin wrapper around that definition;
  * claim a *dynamical* bounce theorem — `OmegaTheory.Torsion.BigBounce`
    already documents (honestly) that the real Popławski bounce requires a
    Friedmann / Raychaudhuri ODE the project does not currently formalise.
    The file here inherits that honest scope marker and does not strengthen
    the claim.

  All theorems below are algebraic sign-checks and inequalities, closed by
  `positivity` / `div_pos` / `linarith` / `ring` at worst.  Zero axioms,
  zero `sorry`, zero `Prop := True`.
-/

import OmegaTheory.Conservation.Correspondence
import OmegaTheory.Emergence.HpwSchwarzschild
import OmegaTheory.Torsion.BigBounce

namespace OmegaTheory.Emergence.BlackHoleFormation

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Torsion

/-! ## Re-exports from `Conservation.Correspondence`

We re-export `schwarzschildRadius` under the local namespace so the
black-hole-formation API is self-contained, while pointing at the
canonical definition. -/

/-- **Schwarzschild radius** `r_s(M) = 2GM/c²` (re-export of
`OmegaTheory.Conservation.schwarzschildRadius`). -/
noncomputable abbrev schwarzschildRadius (M : ℝ) : ℝ :=
  OmegaTheory.Conservation.schwarzschildRadius M

theorem schwarzschildRadius_pos (M : ℝ) (hM : 0 < M) : 0 < schwarzschildRadius M :=
  OmegaTheory.Conservation.schwarzschildRadius_pos M hM

theorem schwarzschildRadius_nonneg (M : ℝ) (hM : 0 ≤ M) : 0 ≤ schwarzschildRadius M := by
  unfold schwarzschildRadius OmegaTheory.Conservation.schwarzschildRadius
  have h2G : 0 ≤ 2 * G_N * M :=
    mul_nonneg (mul_nonneg (by norm_num : (0:ℝ) ≤ 2) (le_of_lt G_N_pos)) hM
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  exact div_nonneg h2G (le_of_lt hc2)

/-! ## Classical black-hole formation criterion -/

/-- **Classical black-hole formation criterion.**

A clump of matter of positive mass `M`, with characteristic radius `r`, is
in the *classical* black-hole regime iff `r ≤ r_s(M)`, i.e. iff it is
compressed inside its own Schwarzschild radius. -/
def BlackHoleFormed (M r : ℝ) : Prop :=
  0 < M ∧ 0 < r ∧ r ≤ schwarzschildRadius M

/-- Formation at exactly the horizon radius. -/
theorem blackHoleFormed_at_horizon (M : ℝ) (hM : 0 < M) :
    BlackHoleFormed M (schwarzschildRadius M) :=
  ⟨hM, schwarzschildRadius_pos M hM, le_refl _⟩

/-- Shrinking a BH inside its horizon keeps it a BH. -/
theorem blackHoleFormed_mono {M r₁ r₂ : ℝ}
    (hbh : BlackHoleFormed M r₂) (hr : 0 < r₁) (h_le : r₁ ≤ r₂) :
    BlackHoleFormed M r₁ :=
  ⟨hbh.1, hr, le_trans h_le hbh.2.2⟩

/-! ## Substrate-resolution regime

The substrate can classically resolve the horizon iff `ℓ_P < r_s(M)`,
equivalently (after unfolding) `ℓ_P c² < 2 G M`, i.e. `M > M_P_horizon`
for some mass threshold.  Below that threshold the classical horizon is
smaller than the lattice spacing and classical BH physics breaks down. -/

/-- **Classical-BH regime indicator.**

The substrate can classically resolve the horizon of a mass-`M` black
hole iff `ℓ_P < r_s(M)`.  Below this threshold the Schwarzschild horizon
is sub-Planckian and the classical BH picture is not applicable. -/
def ClassicalBHRegime (M : ℝ) : Prop := l_P < schwarzschildRadius M

/-- Classical-BH regime is compatible with formation: if `r` is inside
`r_s(M)` and the regime is classical, then `r < r_s(M)` is consistent
with `ℓ_P < r_s(M)`. -/
theorem classicalBHRegime_horizon_exceeds_lP
    {M : ℝ} (h : ClassicalBHRegime M) : l_P < schwarzschildRadius M := h

/-- Classical-BH regime implies the horizon radius is positive. -/
theorem classicalBHRegime_radius_pos {M : ℝ} (h : ClassicalBHRegime M) :
    0 < schwarzschildRadius M := lt_trans l_P_pos h

/-- Classical-BH regime implies positive mass (from `r_s(M) > 0`). -/
theorem classicalBHRegime_mass_pos {M : ℝ} (h : ClassicalBHRegime M) :
    0 < M := by
  have hrs : 0 < schwarzschildRadius M := classicalBHRegime_radius_pos h
  unfold schwarzschildRadius OmegaTheory.Conservation.schwarzschildRadius at hrs
  -- `0 < 2 G M / c²`  together with `c² > 0`, `2G > 0` forces `M > 0`
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  have h2G : 0 < 2 * G_N := mul_pos (by norm_num : (0:ℝ) < 2) G_N_pos
  have h2GM_pos : 0 < 2 * G_N * M :=
    (div_pos_iff.mp hrs).elim (fun ⟨hn, _⟩ => hn) (fun ⟨_, hd⟩ =>
      absurd hd (not_lt.mpr (le_of_lt hc2)))
  exact (mul_pos_iff.mp h2GM_pos).elim (fun ⟨_, hM⟩ => hM)
    (fun ⟨h2G_neg, _⟩ => absurd h2G_neg (not_lt.mpr (le_of_lt h2G)))

/-! ## Sub-Planck: the classical horizon is hidden by the lattice

Below the threshold where the horizon fits in a lattice cell, the
classical BH formation criterion cannot be resolved by the substrate —
`r_s(M) < ℓ_P` means the would-be horizon is smaller than the finest
resolution the substrate offers.

The precise mass threshold is `M_thresh := ℓ_P · c² / (2 G)` (i.e. the
mass at which `r_s(M) = ℓ_P`); this differs from the reduced-Planck-mass
`M_P = E_P/c²` by a dimensional factor of order unity. -/

/-- **Lattice-resolution mass threshold.**  The mass at which
`r_s(M_thresh) = ℓ_P`.  Classical BH physics breaks down below this. -/
noncomputable def latticeResolutionMass : ℝ := l_P * c ^ 2 / (2 * G_N)

theorem latticeResolutionMass_pos : 0 < latticeResolutionMass := by
  unfold latticeResolutionMass
  exact div_pos (mul_pos l_P_pos (sq_pos_of_pos c_pos))
    (mul_pos (by norm_num : (0:ℝ) < 2) G_N_pos)

/-- **Sub-threshold: `M ≤ latticeResolutionMass → r_s(M) ≤ ℓ_P`.**

Below the lattice-resolution mass threshold, the Schwarzschild radius is
not larger than the Planck length — the classical horizon does not fit
in the substrate at all. -/
theorem sub_threshold_horizon_sub_planck
    {M : ℝ} (_hM : 0 ≤ M) (h : M ≤ latticeResolutionMass) :
    schwarzschildRadius M ≤ l_P := by
  unfold schwarzschildRadius OmegaTheory.Conservation.schwarzschildRadius
    latticeResolutionMass at *
  -- Goal: 2 G M / c² ≤ ℓ_P
  -- Hypothesis h: M ≤ ℓ_P · c² / (2 G)
  have h2G : 0 < 2 * G_N := mul_pos (by norm_num : (0:ℝ) < 2) G_N_pos
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  have h2G_ne : (2 * G_N) ≠ 0 := ne_of_gt h2G
  -- From `M ≤ ℓ_P · c² / (2 G)` multiply both sides by `2G > 0`
  have step1 : 2 * G_N * M ≤ 2 * G_N * (l_P * c ^ 2 / (2 * G_N)) :=
    mul_le_mul_of_nonneg_left h (le_of_lt h2G)
  -- Right-hand side simplifies to ℓ_P · c²
  have step2 : 2 * G_N * (l_P * c ^ 2 / (2 * G_N)) = l_P * c ^ 2 :=
    mul_div_cancel₀ (l_P * c ^ 2) h2G_ne
  rw [step2] at step1
  -- Divide by c² > 0
  rw [div_le_iff₀ hc2]
  linarith

/-- **Strict sub-threshold: `M < latticeResolutionMass → r_s(M) < ℓ_P`.** -/
theorem strict_sub_threshold_horizon_sub_planck
    {M : ℝ} (_hM : 0 ≤ M) (h : M < latticeResolutionMass) :
    schwarzschildRadius M < l_P := by
  unfold schwarzschildRadius OmegaTheory.Conservation.schwarzschildRadius
    latticeResolutionMass at *
  have h2G : 0 < 2 * G_N := mul_pos (by norm_num : (0:ℝ) < 2) G_N_pos
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  have h2G_ne : (2 * G_N) ≠ 0 := ne_of_gt h2G
  have step1 : 2 * G_N * M < 2 * G_N * (l_P * c ^ 2 / (2 * G_N)) :=
    mul_lt_mul_of_pos_left h h2G
  have step2 : 2 * G_N * (l_P * c ^ 2 / (2 * G_N)) = l_P * c ^ 2 :=
    mul_div_cancel₀ (l_P * c ^ 2) h2G_ne
  rw [step2] at step1
  rw [div_lt_iff₀ hc2]
  linarith

/-- **Strict super-threshold: `M > latticeResolutionMass → r_s(M) > ℓ_P`,
i.e. the classical-BH regime holds.** -/
theorem strict_super_threshold_classicalBHRegime
    {M : ℝ} (h : latticeResolutionMass < M) : ClassicalBHRegime M := by
  unfold ClassicalBHRegime schwarzschildRadius
    OmegaTheory.Conservation.schwarzschildRadius latticeResolutionMass at *
  have h2G : 0 < 2 * G_N := mul_pos (by norm_num : (0:ℝ) < 2) G_N_pos
  have hc2 : 0 < c ^ 2 := sq_pos_of_pos c_pos
  have h2G_ne : (2 * G_N) ≠ 0 := ne_of_gt h2G
  have step1 : 2 * G_N * (l_P * c ^ 2 / (2 * G_N)) < 2 * G_N * M :=
    mul_lt_mul_of_pos_left h h2G
  have step2 : 2 * G_N * (l_P * c ^ 2 / (2 * G_N)) = l_P * c ^ 2 :=
    mul_div_cancel₀ (l_P * c ^ 2) h2G_ne
  rw [step2] at step1
  rw [lt_div_iff₀ hc2]
  linarith

/-! ## Planck-density repulsion (inherited honest-scope marker)

At density `ρ ≥ ρ_P = M_P/ℓ_P³`, the substrate is at or beyond its
finest resolution.  The `OmegaTheory.Torsion.BigBounce` file supplies a
SIGN lemma `torsionPressure_sign_correct` stating that the torsion
pressure of a non-zero fermion density is strictly negative (repulsive in
the gravitational-collapse sense).  We re-export a Planck-density-keyed
wrapper.

**Honest scope**: this is a sign check on a quadratic pressure formula,
not a dynamical bounce theorem.  A real Popławski bounce would require a
Friedmann/Raychaudhuri ODE the project does not formalise.  We only
promise: "when the substrate is at Planck density and a non-zero fermion
density is present, the torsion contribution to the pressure is
strictly negative." -/

/-- **Substrate Planck-density regime.**

The substrate is at or beyond the Planck-density threshold `ρ_P`. -/
def AtPlanckDensity (ρ : ℝ) : Prop := rho_P ≤ ρ

/-- **Planck-density torsion-repulsion witness.**

At Planck density, for any *non-zero* fermion density `n`, the torsion
pressure is strictly negative — a repulsive contribution.  This is the
sign-check wrapping of `torsionPressure_sign_correct`, with the extra
`AtPlanckDensity` hypothesis kept in the signature to mark physical
scope; the inequality itself does not depend on the density being at
Planck scale. -/
theorem torsion_repulsion_at_planck_density
    {ρ n : ℝ} (_hρ : AtPlanckDensity ρ) (hn : n ≠ 0) :
    torsionPressure n < 0 :=
  torsionPressure_sign_correct n hn

/-- **Popławski-style avoidance indicator.**

At Planck density with non-zero fermion density, the *would-be* singular
collapse receives a strictly negative (repulsive) torsion pressure
contribution.  This is NOT a dynamical bounce theorem — see
`OmegaTheory.Torsion.BigBounce.torsionPressure_sign_correct` honesty note
for the list of ODE / trajectory infrastructure a full proof would
require. -/
theorem substrate_repulsive_at_singularity_density
    (ρ n : ℝ) (hρ : AtPlanckDensity ρ) (hn : n ≠ 0) :
    ∃ P, P < 0 ∧ P = torsionPressure n :=
  ⟨torsionPressure n, torsion_repulsion_at_planck_density hρ hn, rfl⟩

/-! ## Bridge to `HpwSchwarzschild`

Outside the horizon, the discrete metric `g` is in the static
spherically-symmetric vacuum regime.  `HpwSchwarzschild.lean` already
supplies `HpwHypothesis_of_vacuum_static` packaging the three sharp
`ℓ_P/12` bounds.  We re-export a trivial bridge: any black hole is a
static spherically-symmetric vacuum *outside* its horizon, so the HPW
axiom is eliminable on the exterior regime. -/

/-- **Exterior HPW availability.**

For any classical black hole (where `ClassicalBHRegime M` holds) the
Schwarzschild exterior is a static spherically-symmetric vacuum region,
and `HpwSchwarzschild.HpwHypothesis_of_vacuum_static` supplies the HPW
discharge from any `VacuumStaticSphericalData g` for the exterior
metric.  Here we record the *availability* statement — given such a
bundle, the hypothesis witness follows by direct call. -/
noncomputable def exterior_hpw_available {g : DiscreteMetric}
    (data : OmegaTheory.Emergence.VacuumStaticSphericalData g) :
    OmegaTheory.Emergence.HpwHypothesis g :=
  OmegaTheory.Emergence.HpwHypothesis_of_vacuum_static g data

/-! ## Hawking physics (Tier 1 upgrade, Sabik 2026-04-17)

This section equips every Schwarzschild black hole with the canonical
Hawking thermodynamic quartet:

* **event horizon area** `A = 4π r_s² = 16π G²M²/c⁴` (bridge to
  `OmegaTheory.Conservation.schwarzschildArea`),
* **surface gravity** `κ = c⁴/(4GM)` — the redshift-weighted gravitational
  acceleration at the horizon,
* **Hawking temperature** `T_H = ℏκ/(2πc·k_B) = ℏc³/(8πGM·k_B)` (bridge to
  `OmegaTheory.Conservation.hawkingTemperature`), in explicit
  surface-gravity form via `hawkingTemperature_eq_surfaceGravity_form`,
* **Hawking radiation rate** `dM/dt = -ℏc⁴/(15360·π·G²M²)` — the mass-loss
  rate of an isolated Schwarzschild BH; its negativity is the *theorem*
  that BHs evaporate,
* **evaporation time** `τ_ev = 5120·π·G²M³/(ℏc⁴)` — integration of the
  radiation rate, giving the familiar `M³` scaling,
* **Bekenstein–Hawking entropy in bits** `S = A/(4·ℓ_P²·ln 2)` — the
  Hawking entropy expressed in units of binary information.

Everything is a closed-form algebraic identity on the eight physical
constants.  All proofs use `div_pos`, `mul_pos`, `pow_pos`,
`sq_pos_of_pos`, `linarith`, `ring`, `field_simp`, `lt_div_iff₀` —
there is no numerical analysis.

**Honest scope**: these are the standard Schwarzschild BH formulas.
They are derived *from the existing BH-formation geometry* once
`schwarzschildRadius` is fixed; the file does not prove the Wald/Hawking
derivation itself, it packages the formulas as definitions plus the
sign/monotonicity structure the rest of the project consumes. -/

/-! ### Event horizon area -/

/-- **Event horizon area** `A(M) = 4π r_s(M)²`.

Re-export of `OmegaTheory.Conservation.schwarzschildArea` under the
local namespace, so Hawking thermodynamics here does not reinvent its
own area definition. -/
noncomputable abbrev eventHorizonArea (M : ℝ) : ℝ :=
  OmegaTheory.Conservation.schwarzschildArea M

theorem eventHorizonArea_nonneg (M : ℝ) : 0 ≤ eventHorizonArea M :=
  OmegaTheory.Conservation.schwarzschildArea_nonneg M

theorem eventHorizonArea_pos (M : ℝ) (hM : 0 < M) : 0 < eventHorizonArea M :=
  OmegaTheory.Conservation.schwarzschildArea_pos M hM

/-- **Explicit closed form**: `A(M) = 16π G² M² / c⁴`. -/
theorem eventHorizonArea_explicit (M : ℝ) :
    eventHorizonArea M = 16 * Real.pi * G_N ^ 2 * M ^ 2 / c ^ 4 := by
  unfold eventHorizonArea OmegaTheory.Conservation.schwarzschildArea
    OmegaTheory.Conservation.schwarzschildRadius
  have hc2 : c ^ 2 ≠ 0 := pow_ne_zero 2 c_ne_zero
  field_simp
  ring

/-- **Monotone in mass**: larger black holes have larger horizons. -/
theorem eventHorizonArea_strict_mono {M₁ M₂ : ℝ}
    (hM₁ : 0 < M₁) (h : M₁ < M₂) :
    eventHorizonArea M₁ < eventHorizonArea M₂ := by
  have hM₂ : 0 < M₂ := lt_trans hM₁ h
  rw [eventHorizonArea_explicit, eventHorizonArea_explicit]
  have hc4 : 0 < c ^ 4 := pow_pos c_pos 4
  have hpi : 0 < Real.pi := Real.pi_pos
  have hG2 : 0 < G_N ^ 2 := sq_pos_of_pos G_N_pos
  have hpref : 0 < 16 * Real.pi * G_N ^ 2 :=
    mul_pos (mul_pos (by norm_num : (0:ℝ) < 16) hpi) hG2
  have hM1sq : M₁ ^ 2 < M₂ ^ 2 := by
    have := mul_lt_mul'' h h (le_of_lt hM₁) (le_of_lt hM₁)
    simpa [pow_two] using this
  have hnum : 16 * Real.pi * G_N ^ 2 * M₁ ^ 2 < 16 * Real.pi * G_N ^ 2 * M₂ ^ 2 :=
    mul_lt_mul_of_pos_left hM1sq hpref
  exact (div_lt_div_iff_of_pos_right hc4).mpr hnum

/-! ### Surface gravity -/

/-- **Surface gravity** at the Schwarzschild horizon: `κ(M) = c⁴/(4GM)`.

This is the redshift-weighted Killing-vector acceleration at the
horizon, related to the Hawking temperature by
`T_H = ℏκ/(2πc·k_B)`. -/
noncomputable def surfaceGravity (M : ℝ) : ℝ := c ^ 4 / (4 * G_N * M)

theorem surfaceGravity_pos (M : ℝ) (hM : 0 < M) : 0 < surfaceGravity M := by
  unfold surfaceGravity
  apply div_pos (pow_pos c_pos 4)
  exact mul_pos (mul_pos (by norm_num : (0:ℝ) < 4) G_N_pos) hM

theorem surfaceGravity_nonneg (M : ℝ) (hM : 0 < M) : 0 ≤ surfaceGravity M :=
  le_of_lt (surfaceGravity_pos M hM)

/-- **Antimonotone in mass**: heavier black holes are less gravitationally
intense at their horizon (their horizon is correspondingly larger). -/
theorem surfaceGravity_antimono {M₁ M₂ : ℝ}
    (hM₁ : 0 < M₁) (h : M₁ < M₂) :
    surfaceGravity M₂ < surfaceGravity M₁ := by
  unfold surfaceGravity
  have hM₂ : 0 < M₂ := lt_trans hM₁ h
  have h4G : 0 < 4 * G_N := mul_pos (by norm_num : (0:ℝ) < 4) G_N_pos
  apply div_lt_div_of_pos_left (pow_pos c_pos 4)
  · exact mul_pos h4G hM₁
  · exact mul_lt_mul_of_pos_left h h4G

/-- **Hawking temperature in surface-gravity form**:
`T_H(M) = ℏ·κ(M)/(2π c k_B)`. -/
theorem hawkingTemperature_eq_surfaceGravity_form (M : ℝ) (hM : 0 < M) :
    OmegaTheory.Conservation.hawkingTemperature M =
      hbar * surfaceGravity M / (2 * Real.pi * c * k_B) := by
  unfold OmegaTheory.Conservation.hawkingTemperature surfaceGravity
  have hM_ne : M ≠ 0 := ne_of_gt hM
  have hG_ne : G_N ≠ 0 := ne_of_gt G_N_pos
  have hc_ne : c ≠ 0 := c_ne_zero
  have hpi_ne : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
  have hkB_ne : k_B ≠ 0 := ne_of_gt k_B_pos
  field_simp
  ring

/-! ### Hawking radiation rate

Mass-loss rate of an isolated Schwarzschild black hole emitting
Hawking radiation (Page's integrated form for the Stefan–Boltzmann
luminosity through the horizon area):

`dM/dt = -ℏ c⁴ / (15360·π·G²·M²)`.

Note the **sign**: the rate is *strictly negative* for every positive
mass, encoding the fact that an isolated Schwarzschild BH radiates
energy away and so loses mass monotonically. -/

/-- **Hawking radiation rate** `dM/dt = -ℏc⁴/(15360·π·G²M²)`.

The *sign* is part of the definition: black holes emitting Hawking
radiation lose mass, so the rate is negative for every positive mass. -/
noncomputable def hawkingRadiationRate (M : ℝ) : ℝ :=
  -(hbar * c ^ 4) / (15360 * Real.pi * G_N ^ 2 * M ^ 2)

/-- The rate is strictly negative — BHs evaporate. -/
theorem hawkingRadiationRate_neg (M : ℝ) (hM : 0 < M) :
    hawkingRadiationRate M < 0 := by
  unfold hawkingRadiationRate
  have hnum_pos : 0 < hbar * c ^ 4 := mul_pos hbar_pos (pow_pos c_pos 4)
  have hnum_neg : -(hbar * c ^ 4) < 0 := neg_neg_iff_pos.mpr hnum_pos
  have hden : 0 < 15360 * Real.pi * G_N ^ 2 * M ^ 2 :=
    mul_pos
      (mul_pos
        (mul_pos (by norm_num : (0:ℝ) < 15360) Real.pi_pos)
        (sq_pos_of_pos G_N_pos))
      (sq_pos_of_pos hM)
  exact div_neg_of_neg_of_pos hnum_neg hden

/-- **Magnitude** of the Hawking radiation rate. -/
noncomputable def hawkingRadiationMagnitude (M : ℝ) : ℝ :=
  hbar * c ^ 4 / (15360 * Real.pi * G_N ^ 2 * M ^ 2)

theorem hawkingRadiationMagnitude_pos (M : ℝ) (hM : 0 < M) :
    0 < hawkingRadiationMagnitude M := by
  unfold hawkingRadiationMagnitude
  exact div_pos (mul_pos hbar_pos (pow_pos c_pos 4))
    (mul_pos
      (mul_pos
        (mul_pos (by norm_num : (0:ℝ) < 15360) Real.pi_pos)
        (sq_pos_of_pos G_N_pos))
      (sq_pos_of_pos hM))

/-- The rate is the negation of its magnitude. -/
theorem hawkingRadiationRate_eq_neg_magnitude (M : ℝ) :
    hawkingRadiationRate M = -hawkingRadiationMagnitude M := by
  unfold hawkingRadiationRate hawkingRadiationMagnitude
  rw [neg_div]

/-- **Antimonotone magnitude in mass**: larger black holes radiate
*less* intensely (the Hawking luminosity falls off as `1/M²`). -/
theorem hawkingRadiationMagnitude_antimono {M₁ M₂ : ℝ}
    (hM₁ : 0 < M₁) (h : M₁ < M₂) :
    hawkingRadiationMagnitude M₂ < hawkingRadiationMagnitude M₁ := by
  unfold hawkingRadiationMagnitude
  have hM₂ : 0 < M₂ := lt_trans hM₁ h
  have hpref : 0 < 15360 * Real.pi * G_N ^ 2 :=
    mul_pos (mul_pos (by norm_num : (0:ℝ) < 15360) Real.pi_pos)
      (sq_pos_of_pos G_N_pos)
  have hnum : 0 < hbar * c ^ 4 := mul_pos hbar_pos (pow_pos c_pos 4)
  have hM1sq_pos : 0 < M₁ ^ 2 := sq_pos_of_pos hM₁
  have hM1sq_lt : M₁ ^ 2 < M₂ ^ 2 := by
    have := mul_lt_mul'' h h (le_of_lt hM₁) (le_of_lt hM₁)
    simpa [pow_two] using this
  have hden1 : 0 < 15360 * Real.pi * G_N ^ 2 * M₁ ^ 2 :=
    mul_pos hpref hM1sq_pos
  have hden_lt : 15360 * Real.pi * G_N ^ 2 * M₁ ^ 2
                   < 15360 * Real.pi * G_N ^ 2 * M₂ ^ 2 :=
    mul_lt_mul_of_pos_left hM1sq_lt hpref
  exact div_lt_div_of_pos_left hnum hden1 hden_lt

/-! ### Evaporation time

Time to radiate an isolated Schwarzschild BH of mass `M` down to zero
(standard textbook result, integration of the Hawking rate above):

`τ_ev(M) = 5120·π·G²·M³/(ℏc⁴)`.

The cubic scaling in `M` is the hallmark of the `1/M²` radiation rate
combined with the `M → 0` endpoint. -/

/-- **Evaporation time** of a Schwarzschild BH:
`τ_ev(M) = 5120·π·G²M³/(ℏc⁴)`. -/
noncomputable def evaporationTime (M : ℝ) : ℝ :=
  5120 * Real.pi * G_N ^ 2 * M ^ 3 / (hbar * c ^ 4)

theorem evaporationTime_pos (M : ℝ) (hM : 0 < M) : 0 < evaporationTime M := by
  unfold evaporationTime
  exact div_pos
    (mul_pos
      (mul_pos
        (mul_pos (by norm_num : (0:ℝ) < 5120) Real.pi_pos)
        (sq_pos_of_pos G_N_pos))
      (pow_pos hM 3))
    (mul_pos hbar_pos (pow_pos c_pos 4))

theorem evaporationTime_nonneg (M : ℝ) (hM : 0 < M) : 0 ≤ evaporationTime M :=
  le_of_lt (evaporationTime_pos M hM)

/-- **Cubic scaling**: `τ_ev(λ M) = λ³ · τ_ev(M)` for every real `λ`. -/
theorem evaporationTime_cubic_scale (M lam : ℝ) :
    evaporationTime (lam * M) = lam ^ 3 * evaporationTime M := by
  unfold evaporationTime
  have h_hc4_ne : hbar * c ^ 4 ≠ 0 :=
    mul_ne_zero hbar_ne_zero (pow_ne_zero 4 c_ne_zero)
  field_simp

/-- **Strictly increasing in mass**: it takes strictly longer to
evaporate a more massive black hole. -/
theorem evaporationTime_strict_mono {M₁ M₂ : ℝ}
    (hM₁ : 0 < M₁) (h : M₁ < M₂) :
    evaporationTime M₁ < evaporationTime M₂ := by
  unfold evaporationTime
  have hM₂ : 0 < M₂ := lt_trans hM₁ h
  have hden : 0 < hbar * c ^ 4 := mul_pos hbar_pos (pow_pos c_pos 4)
  have hpref : 0 < 5120 * Real.pi * G_N ^ 2 :=
    mul_pos (mul_pos (by norm_num : (0:ℝ) < 5120) Real.pi_pos)
      (sq_pos_of_pos G_N_pos)
  have hM1_cube : M₁ ^ 3 < M₂ ^ 3 := by
    have hnn : 0 ≤ M₁ := le_of_lt hM₁
    have : M₁ ^ 2 < M₂ ^ 2 := by
      have := mul_lt_mul'' h h hnn hnn
      simpa [pow_two] using this
    have hM2sq_nonneg : 0 ≤ M₂ ^ 2 := sq_nonneg _
    have hM1sq_pos : 0 < M₁ ^ 2 := sq_pos_of_pos hM₁
    have : M₁ ^ 2 * M₁ < M₂ ^ 2 * M₂ :=
      mul_lt_mul'' this h (le_of_lt hM1sq_pos) hnn
    simpa [pow_succ, pow_two] using this
  have hnum :
      5120 * Real.pi * G_N ^ 2 * M₁ ^ 3
        < 5120 * Real.pi * G_N ^ 2 * M₂ ^ 3 :=
    mul_lt_mul_of_pos_left hM1_cube hpref
  exact (div_lt_div_iff_of_pos_right hden).mpr hnum

/-! ### Bekenstein–Hawking entropy in bits

The Bekenstein–Hawking entropy `S = A/(4ℓ_P²)` (in nats) converted to
binary information units (bits) by dividing by `ln 2`. -/

/-- **Bekenstein–Hawking entropy in bits**:
`S_bits(M) = A(M)/(4·ℓ_P²·ln 2)`. -/
noncomputable def bekensteinHawkingEntropyBits (M : ℝ) : ℝ :=
  eventHorizonArea M / (4 * l_P ^ 2 * Real.log 2)

theorem bekensteinHawkingEntropyBits_nonneg (M : ℝ) :
    0 ≤ bekensteinHawkingEntropyBits M := by
  unfold bekensteinHawkingEntropyBits
  apply div_nonneg (eventHorizonArea_nonneg M)
  have h1 : 0 ≤ 4 * l_P ^ 2 :=
    mul_nonneg (by norm_num : (0:ℝ) ≤ 4) (sq_nonneg _)
  exact mul_nonneg h1
    OmegaTheory.Conservation.log_two_nonneg

theorem bekensteinHawkingEntropyBits_pos (M : ℝ) (hM : 0 < M) :
    0 < bekensteinHawkingEntropyBits M := by
  unfold bekensteinHawkingEntropyBits
  apply div_pos (eventHorizonArea_pos M hM)
  apply mul_pos
  · exact mul_pos (by norm_num : (0:ℝ) < 4) (sq_pos_of_pos l_P_pos)
  · exact OmegaTheory.Conservation.log_two_pos

/-- **Monotone in mass**: larger BHs carry more bits of entropy. -/
theorem bekensteinHawkingEntropyBits_strict_mono {M₁ M₂ : ℝ}
    (hM₁ : 0 < M₁) (h : M₁ < M₂) :
    bekensteinHawkingEntropyBits M₁ < bekensteinHawkingEntropyBits M₂ := by
  unfold bekensteinHawkingEntropyBits
  have hden_pos : 0 < 4 * l_P ^ 2 * Real.log 2 :=
    mul_pos (mul_pos (by norm_num : (0:ℝ) < 4) (sq_pos_of_pos l_P_pos))
      OmegaTheory.Conservation.log_two_pos
  have harea_lt : eventHorizonArea M₁ < eventHorizonArea M₂ :=
    eventHorizonArea_strict_mono hM₁ h
  exact (div_lt_div_iff_of_pos_right hden_pos).mpr harea_lt

/-- **Bridge to the existing nat-valued `bekensteinHawkingEntropy`**:
the bits version equals the nat version divided by `ln 2`. -/
theorem bekensteinHawkingEntropyBits_eq_nat_div_log2 (M : ℝ) :
    bekensteinHawkingEntropyBits M =
      OmegaTheory.Conservation.bekensteinHawkingEntropy (eventHorizonArea M)
        / Real.log 2 := by
  unfold bekensteinHawkingEntropyBits
    OmegaTheory.Conservation.bekensteinHawkingEntropy
  have hlog : Real.log 2 ≠ 0 := OmegaTheory.Conservation.log_two_ne_zero
  have h4lP : (4 : ℝ) * l_P ^ 2 ≠ 0 :=
    mul_ne_zero (by norm_num) (pow_ne_zero 2 l_P_ne_zero)
  field_simp

end OmegaTheory.Emergence.BlackHoleFormation
