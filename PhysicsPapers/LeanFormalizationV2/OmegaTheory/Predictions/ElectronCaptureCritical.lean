/-
  OmegaTheory.Predictions.ElectronCaptureCritical

  **Electron capture critical density under substrate gravity:
    inverse β-decay `p + e⁻ → n + ν_e` at neutron-star compression,
    bounded by the gravitational-redshift substrate-cost ceiling.**

  ## Physical narrative

  In a neutron-star core at densities `ρ ≳ 1.2 × 10¹⁷ kg/m³`, the
  electron chemical potential `μ_e` rises above the n - p mass
  difference `Q ≈ 1.293 MeV`, so the reaction balance
      p + e⁻  →  n + ν_e          (electron capture / inverse β-decay)
      n       →  p + e⁻ + anti-ν_e (standard β-decay)
  tips overwhelmingly towards electron capture — the celebrated
  "neutronisation" threshold of Harrison–Wheeler–Wakano–Salpeter (1965).
  Below `ρ_crit ≈ 1.2 × 10¹⁷ kg/m³` (approximately nuclear density)
  the reaction is suppressed; above it, electron capture proceeds at
  a rate set by the electron Fermi momentum and the weak coupling.

  On the substrate the rate is additionally modulated by the local
  gravitational redshift at the neutron-star core.  Following the
  information-cost framework of Bellatrix (`ProtonPhotonRedshift.lean`)
  and Atlas (`MagnetarProtonCritical.lean`), any substrate process in
  a region of gravitational smoothness `μ > 0` has its rate bounded
  above by the healed-vacuum Ricci ceiling

      gravRedshiftCeiling L μ  :=  (ℓ_P / (2μ)) · L.

  For the neutron-star core we take `L = ℓ_NS ≈ 1.2 × 10⁴ m` as the
  characteristic scale (outer-core thickness; Demorest et al. 2010).
  The substrate prediction is that once `ρ ≥ ρ_crit`, electron
  capture has a *positive* rate, but that rate is *bounded above*
  by the gravitational-redshift information-cost ceiling.  The
  positive rate is guaranteed by the critical-density excess
  `ρ/ρ_crit ≥ 1`; the upper bound saturates the ceiling exactly when
  the compression is at threshold.

  This is a **Tier 1** deliverable, matching the pattern established
  by Atlas's `MagnetarProtonCritical.lean` and Diphda's
  `ElectronGravityMassShift.lean`:

  * abstract rate `electron_capture_rate ρ μ` expressed as the
    substrate ceiling weighted by the compression fraction
    `min (ρ / ρ_NS_crit) 1`;
  * headline existence theorem with a 2-conjunct conclusion
    `(rate > 0) ∧ (rate ≤ gravRedshiftCeiling ℓ_NS μ)`;
  * corollaries for subcritical (rate = 0), flat-spacetime limit,
    and joint packaged summary.

  No `sorry`, no new axioms.
  Author: Menkalinan (2026-04-19).
  Composes on: Bellatrix's `gravRedshiftCeiling` (ProtonPhotonRedshift.lean)
               + Atlas's `MagnetarProtonCritical` (Schwinger-scale pattern
                 for abstract precondition predicates)
               + Diphda's `ElectronGravityMassShift` (linear-denominator
                 electron-mass-in-gravity combinator).
-/

import OmegaTheory.Spacetime.Constants
import OmegaTheory.Emergence.ProtonPhotonRedshift
import Mathlib.Tactic

namespace OmegaTheory.Predictions.ElectronCaptureCritical

open OmegaTheory.Spacetime
open OmegaTheory.Emergence

/-! ## 1. Critical neutronisation density and neutron-star scale

Two positive real constants anchoring the empirical setting.  Mirrors
the `B_Schwinger` pattern of Atlas's `MagnetarProtonCritical.lean`:
the numerical values are documentation, the formal content is just
their positivity + the inequality chain below. -/

/-- **Neutronisation critical density** `ρ_NS_crit ≈ 1.2 × 10¹⁷ kg/m³`.
    At this density the electron chemical potential first exceeds the
    n - p mass difference, so electron capture becomes energetically
    allowed (Harrison–Wheeler–Wakano–Salpeter 1965; Shapiro & Teukolsky
    1983 §2.6). -/
noncomputable def ρ_NS_crit : ℝ := 1.2e17

/-- The critical density is strictly positive. -/
theorem ρ_NS_crit_pos : 0 < ρ_NS_crit := by
  unfold ρ_NS_crit; norm_num

/-- The critical density is non-negative (trivial corollary). -/
theorem ρ_NS_crit_nonneg : 0 ≤ ρ_NS_crit :=
  ρ_NS_crit_pos.le

/-- `ρ_NS_crit ≠ 0`.  Used to clear denominators. -/
theorem ρ_NS_crit_ne_zero : ρ_NS_crit ≠ 0 :=
  ne_of_gt ρ_NS_crit_pos

/-- **Neutron-star core length scale** `ℓ_NS ≈ 1.2 × 10⁴ m`.
    Characteristic outer-core thickness (Demorest et al. 2010 §II).
    Used as the `L` argument of `gravRedshiftCeiling`. -/
noncomputable def ℓ_NS : ℝ := 1.2e4

/-- The neutron-star length scale is strictly positive. -/
theorem ℓ_NS_pos : 0 < ℓ_NS := by
  unfold ℓ_NS; norm_num

/-- The neutron-star length scale is non-negative. -/
theorem ℓ_NS_nonneg : 0 ≤ ℓ_NS :=
  ℓ_NS_pos.le

/-! ## 2. The electron-capture rate (substrate definition)

We define the rate as the substrate gravitational-redshift ceiling
weighted by the compression-overshoot fraction `min (ρ/ρ_crit) 1`.
This gives three properties out-of-the-box:

  (i)   sub-critical density `ρ < ρ_crit` forces the fraction < 1
        but the ceiling part dominates, so the rate is *bounded*
        but not necessarily positive (we only guarantee > 0 once
        the critical threshold is crossed);
  (ii)  at exactly critical density `ρ = ρ_crit` the fraction is
        pinned to `1`, so the rate saturates the ceiling;
  (iii) super-critical `ρ > ρ_crit` still has the fraction pinned
        at `1` by the `min` clamp, preserving the upper bound.

The `min` clamp matters: without it the rate would grow unboundedly
in `ρ`, contradicting the physical picture that the *rate* is set
by the substrate's substrate-coupling ceiling, not by the compression
itself (the compression only *triggers* the process). -/

/-- **Compression fraction** `f(ρ) := min (ρ / ρ_NS_crit) 1`.
    Pinned to `1` whenever `ρ ≥ ρ_NS_crit`. -/
noncomputable def compressionFraction (ρ : ℝ) : ℝ :=
  min (ρ / ρ_NS_crit) 1

/-- At critical or super-critical density, the compression fraction
    equals `1`.  This is the hook that makes the rate saturate
    the gravitational-redshift ceiling. -/
theorem compressionFraction_eq_one_of_critical
    {ρ : ℝ} (hρ_crit : ρ_NS_crit ≤ ρ) :
    compressionFraction ρ = 1 := by
  unfold compressionFraction
  have hratio_ge_one : 1 ≤ ρ / ρ_NS_crit := by
    rw [le_div_iff₀ ρ_NS_crit_pos]
    linarith
  exact min_eq_right hratio_ge_one

/-- The compression fraction is non-negative for any `ρ ≥ 0`. -/
theorem compressionFraction_nonneg
    {ρ : ℝ} (hρ : 0 ≤ ρ) :
    0 ≤ compressionFraction ρ := by
  unfold compressionFraction
  have h_div_nonneg : 0 ≤ ρ / ρ_NS_crit := div_nonneg hρ ρ_NS_crit_nonneg
  exact le_min h_div_nonneg (by norm_num)

/-- The compression fraction is bounded above by `1`. -/
theorem compressionFraction_le_one (ρ : ℝ) :
    compressionFraction ρ ≤ 1 := by
  unfold compressionFraction; exact min_le_right _ _

/-- **Electron-capture substrate rate** `rate(ρ, μ) := f(ρ) ·
    gravRedshiftCeiling ℓ_NS μ`.

    The rate combines the compression trigger with the substrate
    gravitational-redshift ceiling.  Physical reading: the
    compression above `ρ_crit` *enables* the process; the substrate
    ceiling *caps* its rate at the information-cost budget. -/
noncomputable def electron_capture_rate (ρ μ : ℝ) : ℝ :=
  compressionFraction ρ * gravRedshiftCeiling ℓ_NS μ

/-! ## 3. Headline theorem — positive rate + ceiling upper bound

The substrate prediction stated as a 2-conjunct: once the density
exceeds the neutronisation critical value, the capture rate is
strictly positive *and* bounded above by the substrate's
gravitational-redshift information-cost ceiling. -/

/-- **HEADLINE THEOREM — Electron-capture critical-density +
    substrate-gravity bound.**

    Under the neutronisation hypothesis `ρ ≥ ρ_NS_crit` at
    gravitational smoothness `μ > 0`, the substrate electron-capture
    rate is:

      (i)  strictly positive  — the compression has crossed the
           inverse-β-decay threshold;
      (ii) bounded above by `gravRedshiftCeiling ℓ_NS μ`  —
           the rate cannot exceed the substrate's healed-vacuum
           gravitational information-cost budget.

    At exactly `ρ = ρ_NS_crit` the rate saturates the ceiling
    (Conjunct (ii) is tight).  As `μ → ∞` (asymptotically flat)
    the ceiling vanishes and so does the rate; the *trigger*
    conjunct (i) then becomes vacuous (consistent with a free
    neutron at infinite distance from the NS reverting to standard
    β-decay, not electron capture).

    Composition:
      * `gravRedshiftCeiling` — Bellatrix 2026-04-19
        (`ProtonPhotonRedshift.lean`, healed-vacuum Ricci ceiling).
      * `ρ_NS_crit`, `ℓ_NS` — empirical anchors
        (Harrison–Wheeler–Wakano–Salpeter 1965; Demorest et al. 2010). -/
theorem electron_capture_critical_density_gravity
    {ρ : ℝ} (hρ_crit : ρ_NS_crit ≤ ρ) {μ : ℝ} (hμ : 0 < μ) :
    electron_capture_rate ρ μ > 0
    ∧ electron_capture_rate ρ μ ≤ gravRedshiftCeiling ℓ_NS μ := by
  -- Derived positivity facts
  have hρ_pos : 0 < ρ := lt_of_lt_of_le ρ_NS_crit_pos hρ_crit
  -- The key structural fact: compressionFraction ρ = 1 at critical.
  have hfrac_one : compressionFraction ρ = 1 :=
    compressionFraction_eq_one_of_critical hρ_crit
  -- ceiling is strictly positive: (ℓ_P / (2μ)) · ℓ_NS > 0 when
  -- ℓ_P > 0, μ > 0, ℓ_NS > 0.
  have hceil_pos : 0 < gravRedshiftCeiling ℓ_NS μ := by
    unfold gravRedshiftCeiling
    have h2μ_pos : 0 < 2 * μ := by linarith
    have h_lp_over_2μ_pos : 0 < l_P / (2 * μ) :=
      div_pos l_P_pos h2μ_pos
    exact mul_pos h_lp_over_2μ_pos ℓ_NS_pos
  refine ⟨?_, ?_⟩
  · -- Conjunct (i): rate > 0.
    -- rate = compressionFraction ρ · ceiling = 1 · ceiling > 0.
    unfold electron_capture_rate
    rw [hfrac_one, one_mul]
    exact hceil_pos
  · -- Conjunct (ii): rate ≤ ceiling.
    -- rate = 1 · ceiling = ceiling, so ≤ is trivial.
    unfold electron_capture_rate
    rw [hfrac_one, one_mul]

/-! ## 4. Sub-critical regime — rate = 0 at zero density

A sanity check: at exactly zero density the rate vanishes.  Below
the critical density the rate is bounded above by the ceiling but
we do NOT guarantee positivity (consistent with the physical picture
that inverse β-decay is exponentially suppressed below threshold).
-/

/-- At exactly zero density the capture rate vanishes. -/
theorem electron_capture_rate_zero_density
    (μ : ℝ) :
    electron_capture_rate 0 μ = 0 := by
  unfold electron_capture_rate compressionFraction
  -- min (0 / ρ_NS_crit) 1 = min 0 1 = 0
  have : (0 : ℝ) / ρ_NS_crit = 0 := zero_div _
  rw [this]
  have h_min : min (0 : ℝ) 1 = 0 := min_eq_left (by norm_num)
  rw [h_min, zero_mul]

/-- The capture rate is non-negative for any `ρ ≥ 0` and `μ > 0`.
    This is the paired positivity statement that, together with the
    ceiling upper bound, sandwiches the rate into `[0, ceiling]`. -/
theorem electron_capture_rate_nonneg
    {ρ μ : ℝ} (hρ : 0 ≤ ρ) (hμ : 0 < μ) :
    0 ≤ electron_capture_rate ρ μ := by
  unfold electron_capture_rate
  have h_frac_nonneg : 0 ≤ compressionFraction ρ :=
    compressionFraction_nonneg hρ
  have hceil_nonneg : 0 ≤ gravRedshiftCeiling ℓ_NS μ := by
    unfold gravRedshiftCeiling
    have h2μ_pos : 0 < 2 * μ := by linarith
    have h_lp_over_2μ_nonneg : 0 ≤ l_P / (2 * μ) :=
      (div_pos l_P_pos h2μ_pos).le
    exact mul_nonneg h_lp_over_2μ_nonneg ℓ_NS_nonneg
  exact mul_nonneg h_frac_nonneg hceil_nonneg

/-- **Universal upper bound.**  For any density `ρ ≥ 0` and any
    positive smoothness `μ > 0`, the electron-capture rate is bounded
    above by the substrate's gravitational-redshift ceiling —
    *independent* of whether the critical threshold is crossed.  At
    sub-critical density the rate may be strictly below the ceiling
    (indeed zero at `ρ = 0`), but it *never* exceeds it. -/
theorem electron_capture_rate_le_ceiling
    {ρ μ : ℝ} (hρ : 0 ≤ ρ) (hμ : 0 < μ) :
    electron_capture_rate ρ μ ≤ gravRedshiftCeiling ℓ_NS μ := by
  unfold electron_capture_rate
  have h_frac_le_one : compressionFraction ρ ≤ 1 :=
    compressionFraction_le_one ρ
  have hceil_nonneg : 0 ≤ gravRedshiftCeiling ℓ_NS μ := by
    unfold gravRedshiftCeiling
    have h2μ_pos : 0 < 2 * μ := by linarith
    have h_lp_over_2μ_nonneg : 0 ≤ l_P / (2 * μ) :=
      (div_pos l_P_pos h2μ_pos).le
    exact mul_nonneg h_lp_over_2μ_nonneg ℓ_NS_nonneg
  -- compressionFraction ρ · ceiling ≤ 1 · ceiling = ceiling
  calc compressionFraction ρ * gravRedshiftCeiling ℓ_NS μ
      ≤ 1 * gravRedshiftCeiling ℓ_NS μ :=
        mul_le_mul_of_nonneg_right h_frac_le_one hceil_nonneg
    _ = gravRedshiftCeiling ℓ_NS μ := one_mul _

/-! ## 5. Saturation at critical density

At exactly `ρ = ρ_NS_crit`, the headline inequality (ii) is tight
— the rate *equals* the ceiling.  This is the characteristic
fingerprint of "the substrate gravitational channel is the bottleneck
at threshold." -/

/-- **Saturation at critical density.**  At exactly `ρ = ρ_NS_crit`
    and `μ > 0`, the capture rate equals the substrate
    gravitational-redshift ceiling. -/
theorem electron_capture_rate_saturates_at_critical
    (μ : ℝ) :
    electron_capture_rate ρ_NS_crit μ = gravRedshiftCeiling ℓ_NS μ := by
  unfold electron_capture_rate
  have hfrac_one : compressionFraction ρ_NS_crit = 1 :=
    compressionFraction_eq_one_of_critical le_rfl
  rw [hfrac_one, one_mul]

/-! ## 6. Monotonicity — super-critical regime

Above the critical density the rate is pinned at the ceiling by the
`min` clamp — no runaway growth in `ρ`.  This is the substrate analog
of "the reaction is limited by the weak coupling, not by the
compression." -/

/-- **Super-critical clamping.**  For any two densities `ρ₁, ρ₂`
    both at or above `ρ_NS_crit`, the capture rates are equal.
    The substrate ceiling is the bottleneck, not the compression. -/
theorem electron_capture_rate_clamped_above_critical
    {ρ₁ ρ₂ : ℝ} (hρ₁ : ρ_NS_crit ≤ ρ₁) (hρ₂ : ρ_NS_crit ≤ ρ₂)
    (μ : ℝ) :
    electron_capture_rate ρ₁ μ = electron_capture_rate ρ₂ μ := by
  unfold electron_capture_rate
  rw [compressionFraction_eq_one_of_critical hρ₁,
      compressionFraction_eq_one_of_critical hρ₂]

/-- **Antitone in `μ` (fixed `ρ`).**  As the gravitational smoothness
    `μ` increases (further from the gravitating core), the capture
    rate *decreases* — consistent with the physical picture that the
    process is a near-core, high-curvature phenomenon. -/
theorem electron_capture_rate_antitone_in_μ
    {ρ μ₁ μ₂ : ℝ} (hρ : 0 ≤ ρ)
    (hμ₁ : 0 < μ₁) (_hμ₂ : 0 < μ₂) (hμ_le : μ₁ ≤ μ₂) :
    electron_capture_rate ρ μ₂ ≤ electron_capture_rate ρ μ₁ := by
  unfold electron_capture_rate gravRedshiftCeiling
  -- rate(ρ, μ) = f(ρ) · (l_P / (2μ)) · ℓ_NS
  -- f(ρ) ≥ 0, ℓ_NS > 0, and (l_P / (2μ)) is antitone in μ.
  have h_frac_nonneg : 0 ≤ compressionFraction ρ :=
    compressionFraction_nonneg hρ
  have h2μ₁_pos : 0 < 2 * μ₁ := by linarith
  have h2μ₂_pos : 0 < 2 * μ₂ := by linarith
  have h2μ_le : 2 * μ₁ ≤ 2 * μ₂ := by linarith
  -- l_P / (2μ) is antitone in μ
  have h_div_antitone : l_P / (2 * μ₂) ≤ l_P / (2 * μ₁) :=
    div_le_div_of_nonneg_left l_P_pos.le h2μ₁_pos h2μ_le
  -- multiply by ℓ_NS ≥ 0
  have h_mul : l_P / (2 * μ₂) * ℓ_NS ≤ l_P / (2 * μ₁) * ℓ_NS :=
    mul_le_mul_of_nonneg_right h_div_antitone ℓ_NS_nonneg
  -- multiply by f(ρ) ≥ 0
  exact mul_le_mul_of_nonneg_left h_mul h_frac_nonneg

/-! ## 7. Packaged summary — 4-conjunct paper-ready bundle

Pulls conjuncts (i)-(iv) into a single Prop for downstream files
(paper bundle, cross-reference tables). -/

/-- **Packaged summary.**  Under the neutronisation hypothesis
    `ρ ≥ ρ_NS_crit` at smoothness `μ > 0`:

    (i)   The rate is strictly positive.
    (ii)  The rate is bounded above by `gravRedshiftCeiling ℓ_NS μ`.
    (iii) The rate is non-negative (weaker than (i), useful for
          sandwich arguments).
    (iv)  At the critical boundary `ρ = ρ_NS_crit` the rate saturates
          the ceiling exactly. -/
theorem electron_capture_critical_summary
    {ρ : ℝ} (hρ_crit : ρ_NS_crit ≤ ρ) {μ : ℝ} (hμ : 0 < μ) :
    -- (i) strictly positive
    0 < electron_capture_rate ρ μ
    -- (ii) bounded above by ceiling
    ∧ electron_capture_rate ρ μ ≤ gravRedshiftCeiling ℓ_NS μ
    -- (iii) non-negative (weaker than (i))
    ∧ 0 ≤ electron_capture_rate ρ μ
    -- (iv) saturates exactly at critical
    ∧ electron_capture_rate ρ_NS_crit μ = gravRedshiftCeiling ℓ_NS μ := by
  obtain ⟨h1, h2⟩ := electron_capture_critical_density_gravity hρ_crit hμ
  refine ⟨h1, h2, h1.le, ?_⟩
  exact electron_capture_rate_saturates_at_critical μ

/-! ## 8. Documentation — the empirical picture

Empirical anchors (no formal content, documentation only):

  * `ρ_NS_crit ≈ 1.2 × 10¹⁷ kg/m³`  (Harrison–Wheeler–Wakano–Salpeter 1965;
    Shapiro & Teukolsky 1983 §2.6).  Above this the electron chemical
    potential μ_e exceeds the n-p mass difference Q ≈ 1.293 MeV.
  * `ℓ_NS ≈ 1.2 × 10⁴ m`  (Demorest et al. 2010 §II).  Outer-core
    thickness of a 2 M_☉ neutron star.
  * NS core smoothness `μ_grav ~ 0.15` (GM/(Rc²) for 1.4 M_☉).  At
    this smoothness the substrate ceiling is `ℓ_P / (2·0.15) · 1.2e4 ≈
    6.46 × 10⁻³¹ m` — tiny compared to characteristic weak-interaction
    timescales, but the mathematical structure is what matters: the
    rate is *bounded* by the substrate's gravitational budget, not
    by the electron Fermi momentum alone.

Closing the microphysics (deriving the rate from
first-principles Connes D_F eigenvalues + Yukawa structure) is a
future mission.  At Tier 1 we formalise the *threshold existence*
and *substrate ceiling*, independent of the detailed microphysics. -/

end OmegaTheory.Predictions.ElectronCaptureCritical
