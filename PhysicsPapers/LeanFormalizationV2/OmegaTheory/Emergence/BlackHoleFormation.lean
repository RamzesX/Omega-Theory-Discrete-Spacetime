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

end OmegaTheory.Emergence.BlackHoleFormation
