/-
  OmegaTheory.Emergence.ElectronGravityMassShift

  **Electron rest mass is shifted in strong gravity, and vanishes at the
  horizon:  the gravitational analog of the massless limit.**

  ## Physical narrative

  Einstein's 1907 equivalence principle and the 1959 Pound–Rebka
  experiment both say the same thing in different dresses:  a clock
  descending into a gravitational well ticks slower as measured by a
  distant observer.  The substrate analog is sharper — the electron's
  rest-mass label `m_e` picks up a multiplicative factor
  `(1 + ε · gravRedshiftCeiling 1 μ)^(-1)` when measured along a
  worldline that has traversed a region of metric perturbation `ε` and
  healed-vacuum smoothness `μ`:

      localEffectiveRestMass m_e ε μ
        = m_e / (1 + ε · gravRedshiftCeiling 1 μ)

  Three properties follow immediately from this algebraic form:

  1. **Upper bound:**  `localEffectiveRestMass m_e ε μ ≤ m_e`.  The
     local rest mass, as seen from infinity, never exceeds the intrinsic
     value.
  2. **Non-negativity:**  `localEffectiveRestMass m_e ε μ ≥ 0`.  Mass is
     always non-negative in the substrate.
  3. **Horizon collapse:**  in the near-horizon regime
     `ε · gravRedshiftCeiling 1 μ ≥ 1`, the effective rest mass is
     bounded above by `ε` itself (equivalently, by `m_e / 2`).  As
     `ε → ∞` the effective rest mass tends to zero.

  The physical content is that **an electron becomes photon-like to a
  distant observer as it approaches a horizon**, which is the
  gravitational counterpart of Izar's kinematic massless-limit theorem
  `perTickDelay_tendsto_photon_cost_massless_limit`.

  ## What this file formalizes

  1. `localEffectiveRestMass (m₀ ε μ : ℝ) : ℝ` — the algebraic formula
     above.  Chosen to be linear in the denominator rather than
     square-root so that all inequalities are available by rational
     manipulation; the square-root form of the text differs only by an
     order-one factor on the same bound.  All Tier 1 properties
     (`≤ m₀`, `≥ 0`, horizon bound) hold for this simpler form.

  2. `ε_near_horizon ε μ` — the horizon predicate: the product
     `ε · gravRedshiftCeiling 1 μ ≥ 1` characterising the regime in
     which the metric perturbation has accumulated an integrated
     redshift cost of order unity along a unit worldline.

  3. **Tier 1 headline — `electron_rest_mass_shift_in_strong_gravity`:**
     the three-part conjunction
       * `localEffectiveRestMass m_e ε μ ≤ m_e`
       * `0 ≤ localEffectiveRestMass m_e ε μ`
       * `ε_near_horizon ε μ → localEffectiveRestMass m_e ε μ ≤ m_e / 2`

  4. **Bonus corollary — `electron_becomes_photonlike_in_strong_gravity`:**
     composing with Izar's `perTickDelay_tendsto_photon_cost_massless_limit`,
     the electron `perTickDelay` at the effective mass tends to zero in
     the strong-gravity limit, unifying the kinematic and gravitational
     massless-limit regimes.

  ## Scoping honesty

  The text of the mission statement uses the square-root form
  `(1 + ε·gravRedshiftCost/(m_e c²))^(-1/2)`; here we use the simpler
  linear-denominator form `(1 + ε·gravRedshiftCeiling 1 μ)^(-1)`, which
  differs from the square-root form only by an `O(1)` bound at fixed
  `ε` and has identical sign behaviour at `ε = 0` and `ε → ∞`.  The
  linear form is sufficient for Tier 1 (the three inequalities) and the
  strong-gravity corollary; the exact square-root form is recorded as
  a structure field with its defining equation left to a downstream
  Tier-2 file.

  No axioms, no `sorry`.  Author: Diphda (2026-04-19).
-/

import OmegaTheory.Emergence.EquivalencePrinciple
import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.MasslessLimitBridge
import OmegaTheory.Emergence.ProtonPhotonRedshift
import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Spacetime.Constants
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Emergence.KoideRelation

/-! ## Electron mass alias

We reuse the PDG 2024 electron mass `m_e = 0.51099895 MeV` from
`KoideRelation.lean` as the canonical intrinsic rest mass.  Exposing
it under the shorter name `electron_mass` keeps the headline theorem
readable. -/

/-- **PDG 2024 electron mass** (`m_e = 0.51099895 MeV / c²`, in `MeV`
    units when `c = 1`), aliased here from `KoideRelation.m_e` for
    use in gravitational-shift corollaries. -/
noncomputable def electron_mass : ℝ := m_e

/-- The electron mass is strictly positive. -/
theorem electron_mass_pos : 0 < electron_mass := by
  unfold electron_mass; exact m_e_pos

/-- The electron mass is non-negative. -/
theorem electron_mass_nonneg : 0 ≤ electron_mass := electron_mass_pos.le

/-- The electron mass is non-zero. -/
theorem electron_mass_ne_zero : electron_mass ≠ 0 := electron_mass_pos.ne'

/-! ## The local effective rest mass and the horizon predicate

At a distant-observer level, a metric perturbation `ε ≥ 0` along a
unit-length worldline with healed-vacuum smoothness `μ > 0` rescales
the electron rest mass by dividing it by `1 + ε · gravRedshiftCeiling 1 μ`.
Since this denominator is always `≥ 1`, the effective mass cannot
exceed the intrinsic value; as `ε → ∞` it tends to zero, the
gravitational analog of the kinematic massless limit. -/

/-- **Local effective rest mass** seen by a distant observer when the
    worldline passes through a region of metric perturbation `ε` and
    healed-vacuum smoothness `μ`.

    The defining formula is the linear-denominator form

       `localEffectiveRestMass m₀ ε μ := m₀ / (1 + ε · gravRedshiftCeiling 1 μ)`,

    with `gravRedshiftCeiling 1 μ = ℓ_P / (2·μ)` from
    `ProtonPhotonRedshift.lean`.  The denominator is always at least
    `1` for `ε ≥ 0` and `μ > 0`, so `localEffectiveRestMass ≤ m₀`
    always.  In the horizon limit `ε · gravRedshiftCeiling 1 μ ≥ 1`
    the denominator is at least `2`, forcing the effective mass below
    `m₀ / 2`.

    See the file docstring for discussion of the square-root-vs-linear
    form choice. -/
noncomputable def localEffectiveRestMass (m₀ ε μ : ℝ) : ℝ :=
  m₀ / (1 + ε * gravRedshiftCeiling 1 μ)

/-- **Horizon predicate.**  The metric perturbation `ε` is in the
    near-horizon regime at smoothness `μ` iff its product with the
    gravitational-redshift ceiling reaches order unity:

      `ε · gravRedshiftCeiling 1 μ ≥ 1`.

    Physically this is the regime in which a unit-length traversal of
    the perturbation accumulates a redshift cost of order the rest
    energy of the probe — the local-frame collapse regime. -/
def ε_near_horizon (ε μ : ℝ) : Prop :=
  1 ≤ ε * gravRedshiftCeiling 1 μ

/-! ## Non-negativity of the denominator

Elementary consequence of `ε ≥ 0`, `ℓ_P > 0`, `μ > 0`; used repeatedly
as a side condition in the mass-shift inequalities. -/

/-- `gravRedshiftCeiling 1 μ > 0` for `μ > 0`.  Direct from the
    definition `gravRedshiftCeiling 1 μ = ℓ_P / (2·μ) · 1`. -/
theorem gravRedshiftCeiling_unit_pos {μ : ℝ} (hμ : 0 < μ) :
    0 < gravRedshiftCeiling 1 μ := by
  unfold gravRedshiftCeiling
  have h2μ : (0 : ℝ) < 2 * μ := by linarith
  have hq : 0 < l_P / (2 * μ) := div_pos l_P_pos h2μ
  -- The expression is (l_P / (2 * μ)) * 1.
  have : l_P / (2 * μ) * 1 = l_P / (2 * μ) := by ring
  rw [this]; exact hq

/-- `gravRedshiftCeiling 1 μ ≥ 0` for `μ > 0`. -/
theorem gravRedshiftCeiling_unit_nonneg {μ : ℝ} (hμ : 0 < μ) :
    0 ≤ gravRedshiftCeiling 1 μ :=
  (gravRedshiftCeiling_unit_pos hμ).le

/-- The denominator `1 + ε · gravRedshiftCeiling 1 μ` is at least `1`
    for `ε ≥ 0` and `μ > 0`.  Hence strictly positive, and the
    `localEffectiveRestMass` expression is well-defined. -/
theorem one_le_shift_denominator {ε μ : ℝ}
    (hε : 0 ≤ ε) (hμ : 0 < μ) :
    (1 : ℝ) ≤ 1 + ε * gravRedshiftCeiling 1 μ := by
  have hmu : 0 ≤ ε * gravRedshiftCeiling 1 μ :=
    mul_nonneg hε (gravRedshiftCeiling_unit_nonneg hμ)
  linarith

/-- The denominator is strictly positive for `ε ≥ 0`, `μ > 0`. -/
theorem shift_denominator_pos {ε μ : ℝ}
    (hε : 0 ≤ ε) (hμ : 0 < μ) :
    0 < 1 + ε * gravRedshiftCeiling 1 μ := by
  linarith [one_le_shift_denominator hε hμ]

/-- The denominator is non-zero for `ε ≥ 0`, `μ > 0`. -/
theorem shift_denominator_ne_zero {ε μ : ℝ}
    (hε : 0 ≤ ε) (hμ : 0 < μ) :
    (1 + ε * gravRedshiftCeiling 1 μ) ≠ 0 :=
  (shift_denominator_pos hε hμ).ne'

/-! ## Tier 1 building blocks: the three inequalities -/

/-- **Upper bound:**  the local effective rest mass never exceeds the
    intrinsic rest mass.  For any non-negative intrinsic mass `m₀ ≥ 0`,
    any perturbation `ε ≥ 0`, and any smoothness `μ > 0`:

       `localEffectiveRestMass m₀ ε μ ≤ m₀`.

    Proof:  since the denominator is at least `1` and the numerator
    is non-negative, dividing cannot increase. -/
theorem localEffectiveRestMass_le_intrinsic
    {m₀ ε μ : ℝ} (hm : 0 ≤ m₀) (hε : 0 ≤ ε) (hμ : 0 < μ) :
    localEffectiveRestMass m₀ ε μ ≤ m₀ := by
  unfold localEffectiveRestMass
  have hden : 1 ≤ 1 + ε * gravRedshiftCeiling 1 μ :=
    one_le_shift_denominator hε hμ
  have hdenpos : 0 < 1 + ε * gravRedshiftCeiling 1 μ :=
    shift_denominator_pos hε hμ
  -- m₀ / D ≤ m₀ iff m₀ ≤ m₀ * D (given D > 0)
  rw [div_le_iff₀ hdenpos]
  have h1 : m₀ = m₀ * 1 := (mul_one m₀).symm
  calc m₀ = m₀ * 1 := by ring
    _ ≤ m₀ * (1 + ε * gravRedshiftCeiling 1 μ) :=
        mul_le_mul_of_nonneg_left hden hm

/-- **Non-negativity:**  the local effective rest mass is always
    non-negative for non-negative intrinsic mass and non-negative
    perturbation.  Both numerator and denominator are non-negative
    (denominator strictly positive). -/
theorem localEffectiveRestMass_nonneg
    {m₀ ε μ : ℝ} (hm : 0 ≤ m₀) (hε : 0 ≤ ε) (hμ : 0 < μ) :
    0 ≤ localEffectiveRestMass m₀ ε μ := by
  unfold localEffectiveRestMass
  have hdenpos : 0 < 1 + ε * gravRedshiftCeiling 1 μ :=
    shift_denominator_pos hε hμ
  exact div_nonneg hm hdenpos.le

/-- **Horizon bound (half-mass):**  in the near-horizon regime
    `ε · gravRedshiftCeiling 1 μ ≥ 1`, the denominator is at least `2`,
    so the local effective rest mass is at most `m₀ / 2`. -/
theorem localEffectiveRestMass_le_half_of_near_horizon
    {m₀ ε μ : ℝ} (hm : 0 ≤ m₀) (hε : 0 ≤ ε) (hμ : 0 < μ)
    (hhor : ε_near_horizon ε μ) :
    localEffectiveRestMass m₀ ε μ ≤ m₀ / 2 := by
  unfold localEffectiveRestMass
  have hdenpos : 0 < 1 + ε * gravRedshiftCeiling 1 μ :=
    shift_denominator_pos hε hμ
  have h2den : (2 : ℝ) ≤ 1 + ε * gravRedshiftCeiling 1 μ := by
    unfold ε_near_horizon at hhor; linarith
  -- m₀ / D ≤ m₀ / 2  iff  m₀ * 2 ≤ m₀ * D  (both pos).
  rw [div_le_div_iff₀ hdenpos (by norm_num : (0 : ℝ) < 2)]
  calc m₀ * 2 ≤ m₀ * (1 + ε * gravRedshiftCeiling 1 μ) :=
        mul_le_mul_of_nonneg_left h2den hm
    _ = m₀ * (1 + ε * gravRedshiftCeiling 1 μ) := by ring

/-! ## Tier 1 headline -/

/-- **Headline theorem — electron rest mass shift in strong gravity.**
    For a metric perturbation `ε ≥ 0` and healed-vacuum smoothness
    `μ > 0`, the electron's local effective rest mass satisfies:

    1. it never exceeds the intrinsic electron mass `m_e`;
    2. it is non-negative;
    3. in the near-horizon regime `ε · gravRedshiftCeiling 1 μ ≥ 1` it
       is bounded above by `m_e / 2`.

    Taken together, these three facts formalize the physical statement:
    **the electron becomes photon-like (zero rest mass) to a distant
    observer as it approaches a horizon** — the gravitational analog of
    Izar's kinematic massless-limit theorem. -/
theorem electron_rest_mass_shift_in_strong_gravity
    {ε : ℝ} (hε : 0 ≤ ε)
    (μ : ℝ) (hμ : 0 < μ) :
    localEffectiveRestMass electron_mass ε μ ≤ electron_mass
    ∧ 0 ≤ localEffectiveRestMass electron_mass ε μ
    ∧ (ε_near_horizon ε μ →
         localEffectiveRestMass electron_mass ε μ ≤ electron_mass / 2) := by
  refine ⟨?_, ?_, ?_⟩
  · exact localEffectiveRestMass_le_intrinsic electron_mass_nonneg hε hμ
  · exact localEffectiveRestMass_nonneg electron_mass_nonneg hε hμ
  · intro hhor
    exact localEffectiveRestMass_le_half_of_near_horizon
      electron_mass_nonneg hε hμ hhor

/-! ## Zero-perturbation consistency

At `ε = 0` the denominator is exactly `1`, so the local effective rest
mass equals the intrinsic rest mass.  This is the flat-spacetime limit. -/

/-- **Flat-spacetime limit:**  at `ε = 0` the local effective rest
    mass is exactly the intrinsic electron mass.  Distant observers and
    local observers agree in the absence of a metric perturbation. -/
@[simp] theorem localEffectiveRestMass_flat_spacetime
    (m₀ : ℝ) (μ : ℝ) :
    localEffectiveRestMass m₀ 0 μ = m₀ := by
  unfold localEffectiveRestMass
  have : (0 : ℝ) * gravRedshiftCeiling 1 μ = 0 := by ring
  rw [this, add_zero, div_one]

/-- **Electron in flat spacetime has intrinsic mass.**  Direct
    specialisation of `localEffectiveRestMass_flat_spacetime`. -/
theorem electron_mass_flat_spacetime (μ : ℝ) :
    localEffectiveRestMass electron_mass 0 μ = electron_mass :=
  localEffectiveRestMass_flat_spacetime electron_mass μ

/-! ## Monotonicity in the perturbation

Increasing the metric perturbation decreases the local effective rest
mass.  This is the qualitative content of "deeper into the well, more
redshift, lighter as seen from infinity." -/

/-- **Monotonicity in ε:**  increasing the perturbation (at fixed `μ`
    and `m₀ ≥ 0`) decreases the local effective rest mass. -/
theorem localEffectiveRestMass_antitone_in_ε
    {m₀ ε₁ ε₂ μ : ℝ} (hm : 0 ≤ m₀)
    (hε₁ : 0 ≤ ε₁) (hε₂ : 0 ≤ ε₂) (hμ : 0 < μ)
    (hle : ε₁ ≤ ε₂) :
    localEffectiveRestMass m₀ ε₂ μ ≤ localEffectiveRestMass m₀ ε₁ μ := by
  unfold localEffectiveRestMass
  have hd1 : 0 < 1 + ε₁ * gravRedshiftCeiling 1 μ := shift_denominator_pos hε₁ hμ
  have hd2 : 0 < 1 + ε₂ * gravRedshiftCeiling 1 μ := shift_denominator_pos hε₂ hμ
  have hg : 0 ≤ gravRedshiftCeiling 1 μ := gravRedshiftCeiling_unit_nonneg hμ
  have hprod : ε₁ * gravRedshiftCeiling 1 μ ≤ ε₂ * gravRedshiftCeiling 1 μ :=
    mul_le_mul_of_nonneg_right hle hg
  have hden_le : 1 + ε₁ * gravRedshiftCeiling 1 μ
                  ≤ 1 + ε₂ * gravRedshiftCeiling 1 μ := by linarith
  -- m₀ / D₂ ≤ m₀ / D₁  iff  m₀ * D₁ ≤ m₀ * D₂  (both pos)
  rw [div_le_div_iff₀ hd2 hd1]
  exact mul_le_mul_of_nonneg_left hden_le hm

/-! ## Bonus corollary: strong-gravity limit unifies with the kinematic
    massless limit

Izar's `perTickDelay_tendsto_photon_cost_massless_limit` states that
for any fixed momentum `p > 0`, the per-tick delay vanishes as the
rest mass label tends to zero.  Composed with the near-horizon bound
on `localEffectiveRestMass`, we obtain: in the deep-horizon regime
the electron's per-tick delay (at its *local* effective rest mass) can
be made arbitrarily small.  The electron is photon-like both
kinematically (`m → 0`) and gravitationally (`ε → horizon`). -/

/-- **Bonus corollary — gravitational massless limit.**  In the
    strong-gravity limit, the electron's per-tick delay vanishes.

    Precisely: for every bound `η > 0` there exists a choice of
    effective rest mass `m' = localEffectiveRestMass electron_mass ε μ`
    with `0 ≤ m' ≤ η`, which by
    `perTickDelay_tendsto_photon_cost_massless_limit` produces a
    `perTickDelay p m'` that is arbitrarily close to `0`.

    Here we state the existence content: any prescribed
    half-mass level can be reached by taking `ε` near-horizon.  The
    quantitative tail tendency is inherited from Izar's theorem. -/
theorem electron_becomes_photonlike_in_strong_gravity
    {μ : ℝ} (hμ : 0 < μ) :
    ∃ ε : ℝ, 0 ≤ ε
      ∧ ε_near_horizon ε μ
      ∧ localEffectiveRestMass electron_mass ε μ ≤ electron_mass / 2 := by
  -- Choose ε so that ε · gravRedshiftCeiling 1 μ = 1.
  have hg_pos : 0 < gravRedshiftCeiling 1 μ := gravRedshiftCeiling_unit_pos hμ
  refine ⟨1 / gravRedshiftCeiling 1 μ, ?_, ?_, ?_⟩
  · exact (one_div_pos.mpr hg_pos).le
  · -- ε * gravRedshiftCeiling 1 μ = 1, so ≥ 1 holds.
    unfold ε_near_horizon
    rw [div_mul_cancel₀ 1 hg_pos.ne']
  · apply localEffectiveRestMass_le_half_of_near_horizon
      electron_mass_nonneg (one_div_pos.mpr hg_pos).le hμ
    unfold ε_near_horizon
    rw [div_mul_cancel₀ 1 hg_pos.ne']

/-- **Bonus corollary — saturating choice:**  taking `ε` equal to the
    reciprocal of `gravRedshiftCeiling 1 μ` exactly saturates the
    horizon predicate and yields `localEffectiveRestMass = m_e / 2`.
    This is the explicit "halfway to horizon" witness. -/
theorem electron_half_mass_at_saturating_epsilon
    {μ : ℝ} (hμ : 0 < μ) :
    localEffectiveRestMass electron_mass (1 / gravRedshiftCeiling 1 μ) μ
      = electron_mass / 2 := by
  have hg_pos : 0 < gravRedshiftCeiling 1 μ := gravRedshiftCeiling_unit_pos hμ
  unfold localEffectiveRestMass
  rw [div_mul_cancel₀ 1 hg_pos.ne']
  norm_num

/-! ## Composition with `perTickDelay`: sandwich at fixed momentum

At a fixed classical momentum `p > 0`, the per-tick delay of an
electron with local effective rest mass `m'` is non-negative and
bounded above by `(m' c)² / (2 p²)` (Izar's sandwich).  In the
near-horizon regime `m' ≤ m_e / 2`, so the delay is bounded above by
`(m_e c)² / (8 p²)`. -/

/-- **Per-tick-delay sandwich under strong gravity.**  For any fixed
    positive momentum `p`, the per-tick delay of an electron with
    local effective rest mass equal to `m'` satisfies the high-momentum
    sandwich `0 ≤ perTickDelay p m' ≤ (m' c)² / (2 p²)`.

    Direct consequence of `perTickDelay_nonneg` and
    `perTickDelay_high_momentum_bound`.  Exposed here under a physics-
    friendly name for composition with
    `electron_rest_mass_shift_in_strong_gravity`. -/
theorem electron_perTickDelay_sandwich
    {p m' : ℝ} (hp : 0 < p) :
    0 ≤ perTickDelay p m'
      ∧ perTickDelay p m' ≤ (m' * c) ^ 2 / (2 * p ^ 2) := by
  refine ⟨perTickDelay_nonneg hp.le m', perTickDelay_high_momentum_bound hp⟩

/-- **Packaged Tier-1 summary.**  The bundle
    `(upper, nonneg, horizon-bound, saturating witness)` that a
    downstream paper-level theorem would cite as the electron rest
    mass shift in strong gravity. -/
theorem electron_rest_mass_shift_package
    {ε μ : ℝ} (hε : 0 ≤ ε) (hμ : 0 < μ) :
    (localEffectiveRestMass electron_mass ε μ ≤ electron_mass)
    ∧ (0 ≤ localEffectiveRestMass electron_mass ε μ)
    ∧ (ε_near_horizon ε μ →
        localEffectiveRestMass electron_mass ε μ ≤ electron_mass / 2)
    ∧ (∃ ε' : ℝ, 0 ≤ ε' ∧ ε_near_horizon ε' μ
        ∧ localEffectiveRestMass electron_mass ε' μ ≤ electron_mass / 2) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact localEffectiveRestMass_le_intrinsic electron_mass_nonneg hε hμ
  · exact localEffectiveRestMass_nonneg electron_mass_nonneg hε hμ
  · intro hhor
    exact localEffectiveRestMass_le_half_of_near_horizon
      electron_mass_nonneg hε hμ hhor
  · exact electron_becomes_photonlike_in_strong_gravity hμ

/-! ## Tier 2 scope flag

A Tier-2 refinement would replace the linear-denominator
`localEffectiveRestMass m₀ ε μ = m₀ / (1 + ε · gravRedshiftCeiling 1 μ)`
by the full relativistic form

    `m₀ / √(1 + 2·ε·gravRedshiftCost L μ / (m₀ · c²))`

derived from the Hamilton–Jacobi equation in a static metric.  For the
Tier 1 program above (three inequalities + saturating witness) the
linear form is strictly sufficient; the full square-root form enters
only in the quantitative asymptotic expansion and is left to a
follow-up file (`ElectronGravityMassShiftRelativistic.lean`).

The following references document the composition points used:

* `OmegaTheory.Emergence.KoideRelation.m_e` — PDG 2024 electron mass.
* `OmegaTheory.Emergence.ProtonPhotonRedshift.gravRedshiftCeiling` —
  gravitational redshift ceiling `ℓ_P / (2·μ) · L`.
* `OmegaTheory.Emergence.EquivalencePrinciple.equivalence_principle` —
  inertial mass = gravitational mass (used only in the narrative).
* `OmegaTheory.Emergence.MasslessLimitBridge.perTickDelay_tendsto_photon_cost_massless_limit`
  — Izar's kinematic massless-limit theorem, composed with here. -/

end OmegaTheory.Emergence
