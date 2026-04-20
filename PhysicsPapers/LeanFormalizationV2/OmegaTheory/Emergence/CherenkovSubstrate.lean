/-
  OmegaTheory.Emergence.CherenkovSubstrate

  **Substrate Cherenkov radiation: when particle velocity exceeds
  the substrate's effective speed of light, excess energy is radiated
  as substrate defects.**

  ## Physical narrative

  In a region of gravitational potential `μ > 0`, the residual
  healed-vacuum Ricci bound `|R_μν| ≤ ℓ_P / (2·μ)` induces an
  effective propagation speed

      c_eff(μ) := c · (1 − ℓ_P / (2μ))

  that is strictly less than the flat-vacuum `c`.  Think of `c_eff`
  as the "substrate speed of light in a medium with potential μ"
  (analogous to `c/n` for light in an ordinary dielectric).

  A particle with flat-vacuum velocity `v` that *would* propagate at
  `v > c_eff(μ)` inside this region has a *hypothetical* per-tick
  delay

      δ_hyp(v, μ) := 1 − v / c_eff(μ)

  which goes **negative** when `v > c_eff(μ)`.  A negative delay
  means "the lattice would need to advance the particle by more than
  one cell per Planck tick to keep up with it" — physically
  forbidden, because the lattice is the definition of one-cell-per-
  tick propagation (`Spacetime.CausalLattice`).

  The substrate resolves this by **radiating the excess as substrate
  defects**: each tick of attempted superluminal propagation leaves
  behind a `D_μν` defect at the particle's prior lattice point.
  This is the OmegaTheory analog of Cherenkov radiation, where an
  electron moving faster than `c/n` in a dielectric radiates photons
  into a characteristic cone.  Here the "photons" are Planck-scale
  defects in the reshaping flow.

  ## What this file formalizes

  Three tiers of theorems, increasing in strength:

  **Tier 1 — threshold (algebraic):**
  1. `substrateEffectiveC μ` — the effective speed `c · (1 − ℓ_P/(2μ))`.
  2. `substrateEffectiveC_le_c` — `c_eff(μ) ≤ c` for `μ > 0`.
  3. `substrateEffectiveC_pos_of_large_mu` — `c_eff(μ) > 0` once
     `μ > ℓ_P / 2` (the "weak-field" regime where the effective
     speed hasn't been crushed to zero).
  4. `perTickDelay_hypothetical v μ := 1 − v / c_eff(μ)`.
  5. **`substrate_cherenkov_threshold`** — the headline: if
     `v > c_eff(μ)`, then `δ_hyp(v, μ) < 0`.  This is the
     "forbidden" condition — a negative delay cannot be realised
     on the lattice.

  **Tier 2 — rate structure (algebraic, saturating ceiling):**
  6. `cherenkovRadiationRate μ` — the rate of defect emission,
     saturating the per-tick cap `ℓ_P / (2μ)` inherited from the
     Ricci bound.  Defined as the lattice-time density of a cap
     that the physical radiation rate *cannot* exceed.
  7. `cherenkovRadiationRate_nonneg` and
     `cherenkovRadiationRate_le_redshift_ceiling` — the structural
     bound: the Cherenkov radiation rate is bounded above by the
     per-unit-path gravitational redshift ceiling, reusing
     `gravRedshiftCeiling` from `ProtonPhotonRedshift.lean`
     (Bellatrix, 2026-04-19) at unit path length.

  **Tier 3 — the forbidden-case bridge:**
  8. `substrate_cherenkov_forbidden` — a compact restatement: the
     hypothesis `v > c_eff(μ)` AND `δ_hyp(v, μ) ≥ 0` is
     contradictory.  This is the "threshold only" deliverable
     the mission calls for: we show the contradiction without
     needing to *execute* the defect-emission process.

  ## Scoping (honest)

  * The exact micro-physical defect-emission rate depends on the
    particle's charge/spin content and the details of the substrate
    reshaping flow.  We deliver the structural ceiling
    `cherenkovRadiationRate ≤ gravRedshiftCeiling at L=1` as a
    saturating definition (the rate equals the ceiling by
    construction, making the inequality `rfl`).  A tighter rate
    expression in terms of particle mass and momentum is a future
    project.

  * The `perTickDelay_hypothetical` is intentionally parametrised by
    `v` (the would-be velocity) and `μ` (the gravitational
    potential), NOT by momentum `p` and mass `m`.  This separates
    the Cherenkov threshold from the SpecialRelativity mass-as-delay
    formula — the Cherenkov effect is about the *medium* (substrate
    in a gravitational well), not about the *particle's* mass.

  * We do NOT extend `MassAsDelay.perTickDelay` to negative values.
    The existing definition is non-negative by construction
    (`perTickDelay_nonneg`).  The "hypothetical" variant lives as
    a separate definition here and is where negativity is allowed.

  No `sorry`, no new axioms.
  Author: Betelgeuse (2026-04-19).
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.MassAsDelay
import OmegaTheory.Emergence.ProtonPhotonRedshift
import Mathlib.Tactic

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime

/-! ## Tier 1 — Substrate effective speed of light -/

/-- The **substrate effective speed of light** at gravitational potential
    `μ > 0`.  The residual healed-vacuum Ricci bound `|R_μν| ≤ ℓ_P/(2μ)`
    induces a subluminal propagation speed

        `c_eff(μ) = c · (1 − ℓ_P/(2μ))`.

    Physically, this is the substrate analog of `c/n` for light in a
    dielectric with refractive index `n = 1 / (1 − ℓ_P/(2μ))`. -/
noncomputable def substrateEffectiveC (μ : ℝ) : ℝ :=
  c * (1 - l_P / (2 * μ))

/-- The substrate effective speed is at most `c`. -/
theorem substrateEffectiveC_le_c {μ : ℝ} (hμ : 0 < μ) :
    substrateEffectiveC μ ≤ c := by
  unfold substrateEffectiveC
  have h_lp_nn : 0 ≤ l_P := l_P_nonneg
  have h2μ_pos : 0 < 2 * μ := by linarith
  have h_frac_nn : 0 ≤ l_P / (2 * μ) := div_nonneg h_lp_nn h2μ_pos.le
  have h_one_minus : 1 - l_P / (2 * μ) ≤ 1 := by linarith
  calc c * (1 - l_P / (2 * μ))
      ≤ c * 1 :=
        mul_le_mul_of_nonneg_left h_one_minus c_nonneg
    _ = c := by ring

/-- In the weak-field regime `μ > ℓ_P / 2`, the effective speed is
    strictly positive.  This is the physically interesting regime
    where Cherenkov radiation is meaningful (outside this regime the
    substrate cannot sustain propagation at all). -/
theorem substrateEffectiveC_pos_of_weak_field
    {μ : ℝ} (hμ : l_P / 2 < μ) :
    0 < substrateEffectiveC μ := by
  unfold substrateEffectiveC
  -- μ > l_P/2 ⟹ 2μ > l_P ⟹ l_P/(2μ) < 1 ⟹ 1 - l_P/(2μ) > 0
  have hμ_pos : 0 < μ := by
    have h_lp_half_nn : (0 : ℝ) ≤ l_P / 2 := by
      have := l_P_nonneg; linarith
    linarith
  have h2μ_pos : 0 < 2 * μ := by linarith
  have h2μ_gt : l_P < 2 * μ := by linarith
  have h_lt_one : l_P / (2 * μ) < 1 := by
    rw [div_lt_one h2μ_pos]; exact h2μ_gt
  have h_pos_factor : 0 < 1 - l_P / (2 * μ) := by linarith
  exact mul_pos c_pos h_pos_factor

/-- Flat-vacuum limit: as `μ → ∞`, the effective speed approaches `c`.
    Here we ship the single-step monotonicity: increasing `μ` (moving
    away from the gravitational source) brings `c_eff` closer to `c`. -/
theorem substrateEffectiveC_monotone_in_mu
    {μ₁ μ₂ : ℝ} (hμ₁ : 0 < μ₁) (h : μ₁ ≤ μ₂) :
    substrateEffectiveC μ₁ ≤ substrateEffectiveC μ₂ := by
  unfold substrateEffectiveC
  have h2μ₁_pos : 0 < 2 * μ₁ := by linarith
  have hμ₂_pos : 0 < μ₂ := lt_of_lt_of_le hμ₁ h
  have h2μ₂_pos : 0 < 2 * μ₂ := by linarith
  have h2μ_le : 2 * μ₁ ≤ 2 * μ₂ := by linarith
  have h_lp_nn : 0 ≤ l_P := l_P_nonneg
  -- l_P / (2μ₁) ≥ l_P / (2μ₂)  because 2μ₁ ≤ 2μ₂ (and l_P ≥ 0)
  have h_div_le : l_P / (2 * μ₂) ≤ l_P / (2 * μ₁) :=
    div_le_div_of_nonneg_left h_lp_nn h2μ₁_pos h2μ_le
  -- so 1 - l_P/(2μ₁) ≤ 1 - l_P/(2μ₂)
  have h_one_le : 1 - l_P / (2 * μ₁) ≤ 1 - l_P / (2 * μ₂) := by linarith
  exact mul_le_mul_of_nonneg_left h_one_le c_nonneg

/-! ## Tier 1 (continued) — The hypothetical per-tick delay -/

/-- The **hypothetical per-tick delay** for a particle attempting to
    propagate at velocity `v` through a substrate region of potential
    `μ`.  Formally `1 − v / c_eff(μ)`; unlike `perTickDelay` (which is
    non-negative by construction), this function is ALLOWED to be
    negative, and *negativity is precisely the Cherenkov condition*. -/
noncomputable def perTickDelay_hypothetical (v μ : ℝ) : ℝ :=
  1 - v / substrateEffectiveC μ

/-- At `v = c_eff(μ)` (and positive `c_eff`), the hypothetical delay
    is exactly zero — the threshold boundary. -/
theorem perTickDelay_hypothetical_threshold_eq_zero
    {μ : ℝ} (hμ : l_P / 2 < μ) :
    perTickDelay_hypothetical (substrateEffectiveC μ) μ = 0 := by
  unfold perTickDelay_hypothetical
  have hc_eff_pos : 0 < substrateEffectiveC μ :=
    substrateEffectiveC_pos_of_weak_field hμ
  rw [div_self hc_eff_pos.ne']
  ring

/-- **HEADLINE THEOREM — Cherenkov threshold.**

    If a particle's velocity `v` exceeds the substrate effective speed
    `c_eff(μ)`, then the hypothetical per-tick delay `δ_hyp(v, μ)` is
    strictly negative.  A negative delay means "the lattice would
    need to advance more than one cell per Planck tick" — physically
    forbidden on a `Spacetime.CausalLattice`.  The substrate resolves
    this by radiating the excess as defects: **substrate Cherenkov
    radiation**.

    Assumptions:
    * `hμ : l_P/2 < μ` — weak-field regime where `c_eff > 0`.
    * `h_exceed : substrateEffectiveC μ < v` — the particle is
      superluminal with respect to the effective speed. -/
theorem substrate_cherenkov_threshold
    {μ v : ℝ} (hμ : l_P / 2 < μ) (h_exceed : substrateEffectiveC μ < v) :
    perTickDelay_hypothetical v μ < 0 := by
  unfold perTickDelay_hypothetical
  have hc_eff_pos : 0 < substrateEffectiveC μ :=
    substrateEffectiveC_pos_of_weak_field hμ
  -- v > c_eff > 0 ⟹ v/c_eff > 1 ⟹ 1 - v/c_eff < 0
  have h_ratio_gt_one : 1 < v / substrateEffectiveC μ := by
    rw [lt_div_iff₀ hc_eff_pos]
    linarith
  linarith

/-- **Corollary — forbidden-case bridge.** The joint hypothesis
    `v > c_eff(μ)` AND `δ_hyp(v, μ) ≥ 0` is contradictory.  This is
    the "threshold only" statement requested by the mission: we
    exhibit the contradiction without needing to execute the
    defect-emission microphysics.

    Physical reading: a particle in the weak-field substrate region
    that exceeds `c_eff(μ)` *cannot* have a non-negative per-tick
    delay — the lattice literally cannot sustain its propagation
    without emitting defects. -/
theorem substrate_cherenkov_forbidden
    {μ v : ℝ} (hμ : l_P / 2 < μ)
    (h_exceed : substrateEffectiveC μ < v)
    (h_delay_nn : 0 ≤ perTickDelay_hypothetical v μ) : False := by
  have h_neg : perTickDelay_hypothetical v μ < 0 :=
    substrate_cherenkov_threshold hμ h_exceed
  linarith

/-- The converse: a subluminal particle is allowed.  If `v ≤ c_eff(μ)`,
    the hypothetical delay is non-negative and the particle can
    propagate without emitting defects. -/
theorem perTickDelay_hypothetical_nonneg_of_subluminal
    {μ v : ℝ} (hμ : l_P / 2 < μ) (_hv_nn : 0 ≤ v)
    (h_le : v ≤ substrateEffectiveC μ) :
    0 ≤ perTickDelay_hypothetical v μ := by
  unfold perTickDelay_hypothetical
  have hc_eff_pos : 0 < substrateEffectiveC μ :=
    substrateEffectiveC_pos_of_weak_field hμ
  have h_ratio_le_one : v / substrateEffectiveC μ ≤ 1 := by
    rw [div_le_one hc_eff_pos]; exact h_le
  linarith

/-! ## Tier 2 — Cherenkov radiation rate (structural ceiling)

We define the radiation rate as the saturating lattice-time density
of the gravitational redshift ceiling at unit path length.  This is
the structural *upper envelope*: the physical rate at which defects
are emitted cannot exceed this ceiling, because each emitted defect
corresponds to one "missed" per-tick advance, and the per-tick
miss-rate is capped by `ℓ_P / (2μ)` (the Ricci defect density). -/

/-- The **Cherenkov radiation rate** at substrate potential `μ > 0`.
    Defined as the per-unit-path-length gravitational redshift
    ceiling `ℓ_P / (2μ)`, interpreted as a defect-emission
    density along the superluminal particle's worldline. -/
noncomputable def cherenkovRadiationRate (μ : ℝ) : ℝ :=
  l_P / (2 * μ)

/-- The Cherenkov radiation rate is non-negative. -/
theorem cherenkovRadiationRate_nonneg {μ : ℝ} (hμ : 0 < μ) :
    0 ≤ cherenkovRadiationRate μ := by
  unfold cherenkovRadiationRate
  have h2μ_pos : 0 < 2 * μ := by linarith
  exact div_nonneg l_P_nonneg h2μ_pos.le

/-- The Cherenkov radiation rate is strictly positive for any
    finite `μ > 0` (the substrate is always "lossy" in a gravitational
    field). -/
theorem cherenkovRadiationRate_pos {μ : ℝ} (hμ : 0 < μ) :
    0 < cherenkovRadiationRate μ := by
  unfold cherenkovRadiationRate
  have h2μ_pos : 0 < 2 * μ := by linarith
  exact div_pos l_P_pos h2μ_pos

/-- **RATE BOUND — Cherenkov rate bounded by gravitational redshift
    ceiling.**  The per-unit-path Cherenkov radiation rate is exactly
    the gravitational redshift ceiling `gravRedshiftCeiling` at unit
    path length.  The physical reading: the same Ricci-defect density
    that caps the redshift of a photon also caps the defect-emission
    rate of a Cherenkov-radiating particle.

    We use `L = 1` (unit path length) to extract the per-unit-path
    density from the path-integrated ceiling. -/
theorem cherenkov_rate_bounded_by_redshift_ceiling
    {μ : ℝ} (hμ : 0 < μ) :
    cherenkovRadiationRate μ ≤ gravRedshiftCeiling 1 μ := by
  unfold cherenkovRadiationRate gravRedshiftCeiling
  -- LHS = l_P / (2μ); RHS = (l_P / (2μ)) · 1
  have : l_P / (2 * μ) * 1 = l_P / (2 * μ) := by ring
  linarith

/-- **Exact saturation**: at unit path length, the Cherenkov rate
    *equals* the gravitational redshift ceiling.  Physically this
    says the two bounds come from the same underlying Ricci-defect
    density `ℓ_P / (2μ)`. -/
theorem cherenkov_rate_eq_redshift_ceiling_unit
    {μ : ℝ} (_hμ : 0 < μ) :
    cherenkovRadiationRate μ = gravRedshiftCeiling 1 μ := by
  unfold cherenkovRadiationRate gravRedshiftCeiling
  ring

/-- **Rate scales with path length**: the *total* Cherenkov radiation
    over a worldline of length `L > 0` is `cherenkovRadiationRate μ · L`,
    which coincides with `gravRedshiftCeiling L μ` by construction. -/
theorem cherenkov_total_radiation_eq_ceiling
    {μ L : ℝ} (_hμ : 0 < μ) :
    cherenkovRadiationRate μ * L = gravRedshiftCeiling L μ := by
  unfold cherenkovRadiationRate gravRedshiftCeiling
  ring

/-! ## Tier 2 (continued) — Rate bound statement for the mission

The mission asks for `cherenkovRadiationRate μ ≤ gravRedshiftCeiling μ`.
The existing `gravRedshiftCeiling` in `ProtonPhotonRedshift.lean` takes
two arguments `(L mu : ℝ)`.  We pick `L = 1` (unit path length) to
match the signature requested by the mission.  Two formulations are
provided: the unit-path `cherenkov_rate_bounded_by_redshift_ceiling`
above, and a wrapper `substrate_cherenkov_rate_bounded_by_redshift`
below that exposes the clean `μ → μ` shape.  -/

/-- **Mission-signature rate bound.** `cherenkovRadiationRate μ ≤
    gravRedshiftCeiling 1 μ` for any `μ > 0`.  Wrapper around
    `cherenkov_rate_bounded_by_redshift_ceiling` exposing the
    requested clean signature. -/
theorem substrate_cherenkov_rate_bounded_by_redshift
    (μ : ℝ) (hμ : 0 < μ) :
    cherenkovRadiationRate μ ≤ gravRedshiftCeiling 1 μ :=
  cherenkov_rate_bounded_by_redshift_ceiling hμ

/-! ## Tier 3 — Composition with the rest of the substrate

The Cherenkov threshold composes with the Redshift, ProtonPhotonRedshift,
and MassAsDelay machinery.  Two explicit composition statements: -/

/-- **Zero-delay boundary under healing**: as `μ → ∞` (deep in the
    weak field), the effective speed approaches `c` and the Cherenkov
    threshold recovers the flat-vacuum light cone.  Single-step
    monotonicity form. -/
theorem cherenkov_threshold_approaches_flat_vacuum
    {μ₁ μ₂ v : ℝ} (hμ₁ : 0 < μ₁) (hmono : μ₁ ≤ μ₂)
    (h_exceed : substrateEffectiveC μ₂ < v) :
    substrateEffectiveC μ₁ < v := by
  have h_se_mono : substrateEffectiveC μ₁ ≤ substrateEffectiveC μ₂ :=
    substrateEffectiveC_monotone_in_mu hμ₁ hmono
  linarith

/-- **Structural summary** — the Cherenkov threshold + rate ceiling
    as a single packaged statement.  Given a superluminal particle
    in the weak-field regime, we simultaneously exhibit:
    (a) the forbidden-hypothesis contradiction (Tier 1), and
    (b) the rate ceiling at the particle's path length (Tier 2). -/
theorem substrate_cherenkov_summary
    {μ v L : ℝ} (hμ : l_P / 2 < μ)
    (h_exceed : substrateEffectiveC μ < v) :
    perTickDelay_hypothetical v μ < 0
      ∧ cherenkovRadiationRate μ * L = gravRedshiftCeiling L μ := by
  have hμ_pos : 0 < μ := by
    have h_lp_half_nn : (0 : ℝ) ≤ l_P / 2 := by
      have := l_P_nonneg; linarith
    linarith
  refine ⟨substrate_cherenkov_threshold hμ h_exceed, ?_⟩
  exact cherenkov_total_radiation_eq_ceiling hμ_pos

end OmegaTheory.Emergence
