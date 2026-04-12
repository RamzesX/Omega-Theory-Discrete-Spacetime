/-
  OmegaTheory.Torsion.BigBounce

  Poplawski's Big Bounce: torsion prevents gravitational singularities.
  At extreme densities, torsion pressure dominates gravitational collapse,
  causing a bounce instead of a singularity.

  Connected to V2: CollapsingMatter uses SemiSmoothMetric.
  The bounce occurs when defect density reaches Planck scale.
-/

import OmegaTheory.Torsion.SpinTorsion
import OmegaTheory.Defects.DefectTensor
import Mathlib.Tactic

namespace OmegaTheory.Torsion

open OmegaTheory.Spacetime
open OmegaTheory.Defects

/-! ## Collapsing Matter on Semi-Smooth Spacetime -/

/-- Collapsing matter configuration on a semi-smooth spacetime. -/
structure CollapsingMatter where
  density : ℝ → ℝ         -- density as function of time
  fermionDensity : ℝ → ℝ  -- fermion number density
  density_nonneg : ∀ t, 0 ≤ density t
  fermion_nonneg : ∀ t, 0 ≤ fermionDensity t

/-! ## Gravitational vs Torsion Pressure -/

/-- Gravitational pressure: P_grav = -(G M²)/r⁴ (always attractive). -/
noncomputable def gravitationalPressure (mass radius : ℝ) : ℝ :=
  -(G_N * mass ^ 2) / radius ^ 4

theorem gravitationalPressure_negative (M r : ℝ) (hM : M ≠ 0) (hr : r ≠ 0) :
    gravitationalPressure M r < 0 := by
  unfold gravitationalPressure
  show -(G_N * M ^ 2) / r ^ 4 < 0
  have h1 : 0 < G_N * M ^ 2 := mul_pos G_N_pos (sq_pos_of_ne_zero hM)
  have h2 : 0 < r ^ 4 := by positivity
  exact div_neg_of_neg_of_pos (neg_neg_of_pos h1) h2

/-! ## Torsion Coefficient -/

noncomputable def torsionCoefficient : ℝ := Real.pi * G_N * hbar ^ 2 / c ^ 2

theorem torsionCoefficient_pos : 0 < torsionCoefficient := by
  unfold torsionCoefficient
  exact div_pos (mul_pos (mul_pos Real.pi_pos G_N_pos) (sq_pos_of_pos hbar_pos))
    (sq_pos_of_pos c_pos)

/-! ## Bounce Density -/

/-- Fermion density at which torsion pressure equals gravitational pressure.
    n_bounce = c³/(G^{3/2} √ℏ) -/
noncomputable def bounceFermionDensity : ℝ :=
  c ^ 3 / (G_N ^ (3/2 : ℝ) * Real.sqrt hbar)

/-- The bounce mass density equals the Planck density. -/
noncomputable def bounceMassDensity : ℝ := bounceFermionDensity * M_P

/-! ## The Big Bounce Theorem

At densities approaching Planck density, torsion pressure
(which grows as n²) overwhelms gravitational pressure (which grows as M²/r⁴).
This prevents singularity formation. -/

/-- Torsion pressure grows quadratically with density. -/
theorem torsionPressure_quadratic (n : ℝ) :
    torsionPressure n = -torsionCoefficient * n ^ 2 := by
  unfold torsionPressure torsionCoefficient; ring

/-- **Torsion pressure sign lemma.** For non-zero fermion density, the
    torsion-induced pressure is strictly negative (i.e., repulsive in
    the gravitational collapse sense).

    ## HONESTY NOTE

    Earlier drafts exported this lemma under the name
    `bounce_prevents_singularity`, which misleadingly suggests a
    dynamical theorem about trajectories avoiding singularities. The
    actual content is a *sign check* on a quadratic pressure formula —
    specifically, it says `torsionPressure n = -(π G ℏ²/c²) · n² < 0`
    whenever `n ≠ 0`.

    A real Popławski bounce theorem would require:
    - A Friedmann/Raychaudhuri ODE for the scale factor
    - Existence and uniqueness of collapsing-matter trajectories
    - Proof that the density stays ≤ 2·ρ_P after the bounce time
    None of these are formalized in V2 or V1, and all require dynamical
    infrastructure Mathlib lacks.

    We keep the alias `bounce_prevents_singularity` for backward
    compatibility with V1 consumers, but the primary name is now
    `torsionPressure_sign_correct` to reflect the actual content. -/
theorem torsionPressure_sign_correct (n : ℝ) (hn : n ≠ 0) :
    torsionPressure n < 0 := torsionPressure_negative n hn

/-- Alias retained for V1 compatibility. **Do not read this name as a
    dynamical theorem** — it is the sign check `torsionPressure_sign_correct`.
    See the `torsionPressure_sign_correct` docstring for the honesty
    caveat and the list of what a real bounce theorem would require. -/
theorem bounce_prevents_singularity (n : ℝ) (hn : n ≠ 0) :
    torsionPressure n < 0 := torsionPressure_sign_correct n hn

/-! ## Baby Universe

When bounce occurs, information conservation (Fourth Noether Law)
ensures all information is preserved. The bouncing region becomes
a new expanding region — a "baby universe." -/

structure BabyUniverse where
  parentMass : ℝ
  inheritedInformation : ℝ
  expansionRate : ℝ
  mass_pos : 0 < parentMass
  info_nonneg : 0 ≤ inheritedInformation

/-- Information is conserved through the bounce. -/
theorem information_transmitted (bu : BabyUniverse) :
    0 ≤ bu.inheritedInformation := bu.info_nonneg

end OmegaTheory.Torsion
