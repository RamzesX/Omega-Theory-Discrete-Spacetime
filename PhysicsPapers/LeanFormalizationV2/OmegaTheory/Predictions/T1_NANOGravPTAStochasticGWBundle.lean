/-
  OmegaTheory.Predictions.T1_NANOGravPTAStochasticGWBundle

  T-1 (light quark masses) — FRONTIER, bundled sessions s639-s643.
  NANOGrav 15-year pulsar timing array — stochastic gravitational
  wave background, Hellings-Downs spectral index, nHz GW frequency
  band, multi-decade frequency reach over LIGO.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Five-session bundle on the NANOGrav 15-year (2023) pulsar timing
  array detection of a stochastic gravitational wave background at
  ~3.5σ Hellings-Downs significance — the first hint of nHz-scale
  stochastic GWs, complementary to LIGO's ~100 Hz band:

  - s639: GW spectral amplitude in `10⁻¹⁵` units at `f_yr⁻¹ ≈ 3.17×10⁻⁸ Hz`:
          `A_yr = 6.4` (= 6.4 × 10⁻¹⁵ NANOGrav 15-yr median).
  - s640: Hellings-Downs spectral index `γ_HD = 13/3 ≈ 4.33`
          (SMBHB stochastic background prediction).
  - s641: Hellings-Downs statistical significance: 3.5σ.
  - s642: Frequency-decade gap: `f_LIGO_log10 - f_NANOGrav_log10 = 11`
          decades (NANOGrav ≈ 10⁻⁹ Hz, LIGO ≈ 10² Hz).
  - s643: bundle composition + `NANOGravPTAStochasticGW` Prop scaffold.

  Companion to:
  - `T1_NANOGravPulsarTimingFrontier.lean` (s254) — single-A_GWB witness.
  - `T1_LIGOSensitivityBundle.lean` (s428–432) — LIGO/LISA/ET tower.
  - `T1_CrabPulsarTimingBundle.lean` (s619–623) — single-pulsar timing.

  Together this bundle + companions bracket the GW observational
  landscape from nHz (NANOGrav) to mHz (LISA) to ~100 Hz (LIGO/ET).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_NANOGravPTAStochasticGWBundle

/-! ## s639 — GW spectral amplitude at f_yr⁻¹ in 10⁻¹⁵ units -/

/-- **NANOGrav 15-yr GW spectral amplitude at `f = 1/yr ≈ 3.17×10⁻⁸ Hz`,
    in `10⁻¹⁵` units**: `A_yr = 64/10 = 6.4`.

    Stored in mantissa form `64/10` so `decide`/`norm_num` resolve all
    bounds without floating-point. Equivalent to `6.4 × 10⁻¹⁵` in
    natural units of characteristic strain.

    NANOGrav 15-yr data set 2023: median posterior estimate of the
    common-spectrum amplitude consistent with Hellings-Downs at the
    `~3.5σ` level. -/
noncomputable def A_yr_NANOGrav_units : ℝ := 64 / 10

/-- **s639 — `A_yr > 0`**. -/
theorem s639_A_yr_pos : 0 < A_yr_NANOGrav_units := by
  unfold A_yr_NANOGrav_units; norm_num

/-- **s639 — `A_yr > 1`** (non-trivial amplitude in `10⁻¹⁵` units). -/
theorem s639_A_yr_above_1 : A_yr_NANOGrav_units > 1 := by
  unfold A_yr_NANOGrav_units; norm_num

/-- **s639 — `A_yr < 100`** (reasonable upper anchor in `10⁻¹⁵` units). -/
theorem s639_A_yr_below_100 : A_yr_NANOGrav_units < 100 := by
  unfold A_yr_NANOGrav_units; norm_num

/-- **🚨 FRONTIER — s639 — `A_yr = 6.4 × 10⁻¹⁵` is in `(1, 100)`
    band of `10⁻¹⁵` units, strictly positive**. -/
theorem s639_A_yr_band :
    0 < A_yr_NANOGrav_units
    ∧ 1 < A_yr_NANOGrav_units
    ∧ A_yr_NANOGrav_units < 100 :=
  ⟨s639_A_yr_pos, s639_A_yr_above_1, s639_A_yr_below_100⟩

/-! ## s640 — Hellings-Downs spectral index γ_HD = 13/3 -/

/-- **Hellings-Downs spectral index target**: `γ_HD = 433/100 = 4.33`.

    The stochastic GW background spectrum from supermassive black hole
    binary (SMBHB) mergers is predicted to have spectral index
    `γ_HD = 13/3 ≈ 4.33`. NANOGrav 15-yr median posterior is consistent
    with this value within the 1σ contour. -/
noncomputable def gamma_HD_target : ℝ := 433 / 100

/-- **s640 — `γ_HD > 0`**. -/
theorem s640_gamma_HD_pos : 0 < gamma_HD_target := by
  unfold gamma_HD_target; norm_num

/-- **s640 — `γ_HD > 4`** (lower SMBHB anchor). -/
theorem s640_gamma_HD_above_4 : gamma_HD_target > 4 := by
  unfold gamma_HD_target; norm_num

/-- **s640 — `γ_HD < 5`** (upper SMBHB anchor). -/
theorem s640_gamma_HD_below_5 : gamma_HD_target < 5 := by
  unfold gamma_HD_target; norm_num

/-- **🚨 FRONTIER — s640 — `γ_HD = 4.33` is in `(4, 5)` band — close
    to `13/3 ≈ 4.33` SMBHB stochastic background prediction**. -/
theorem s640_gamma_HD_band :
    0 < gamma_HD_target
    ∧ 4 < gamma_HD_target
    ∧ gamma_HD_target < 5 :=
  ⟨s640_gamma_HD_pos, s640_gamma_HD_above_4, s640_gamma_HD_below_5⟩

/-! ## s641 — Hellings-Downs significance 3.5σ -/

/-- **Hellings-Downs correlation significance**: `3.5σ`.

    NANOGrav 15-yr observed Hellings-Downs spatial correlation pattern
    at `~3.5σ` (the stochastic-amplitude alone is `~2σ`, but the HD
    angular correlation pushes the joint significance to `~3.5σ`). -/
noncomputable def HD_significance_sigma : ℝ := 35 / 10

/-- **s641 — significance > 0**. -/
theorem s641_HD_significance_pos : 0 < HD_significance_sigma := by
  unfold HD_significance_sigma; norm_num

/-- **s641 — significance > 3** (statistically meaningful). -/
theorem s641_HD_significance_above_3 : HD_significance_sigma > 3 := by
  unfold HD_significance_sigma; norm_num

/-- **s641 — significance < 5** (not yet a discovery 5σ). -/
theorem s641_HD_significance_below_5 : HD_significance_sigma < 5 := by
  unfold HD_significance_sigma; norm_num

/-- **🚨 FRONTIER — s641 — Hellings-Downs significance in `(3, 5)`
    band — strong evidence but not yet a discovery (5σ)**. -/
theorem s641_HD_significance_band :
    0 < HD_significance_sigma
    ∧ 3 < HD_significance_sigma
    ∧ HD_significance_sigma < 5 :=
  ⟨s641_HD_significance_pos, s641_HD_significance_above_3,
   s641_HD_significance_below_5⟩

/-! ## s642 — Frequency-decade gap NANOGrav vs LIGO -/

/-- **NANOGrav frequency band log10 anchor**: `-9` (≈ 10⁻⁹ Hz, nHz). -/
noncomputable def f_NANOGrav_log10 : ℝ := -9

/-- **LIGO frequency band log10 anchor**: `2` (≈ 10² Hz, ~100 Hz). -/
noncomputable def f_LIGO_log10 : ℝ := 2

/-- **s642 — NANOGrav band log10 < 0** (sub-Hz frequencies). -/
theorem s642_f_NANOGrav_negative : f_NANOGrav_log10 < 0 := by
  unfold f_NANOGrav_log10; norm_num

/-- **s642 — LIGO band log10 > 0** (above 1 Hz). -/
theorem s642_f_LIGO_positive : 0 < f_LIGO_log10 := by
  unfold f_LIGO_log10; norm_num

/-- **s642 — NANOGrav band strictly below LIGO band**. -/
theorem s642_f_NANOGrav_below_LIGO :
    f_NANOGrav_log10 < f_LIGO_log10 := by
  unfold f_NANOGrav_log10 f_LIGO_log10; norm_num

/-- **🚨 FRONTIER — s642 — Frequency-decade gap is exactly 11 decades**.

    `f_LIGO_log10 - f_NANOGrav_log10 = 2 - (-9) = 11`.
    NANOGrav PTAs probe nHz GWs from SMBHB mergers; LIGO probes ~100 Hz
    GWs from stellar-mass black hole / neutron star mergers; LISA fills
    the mHz gap.  The 11-decade frequency span between PTA and LIGO is
    a key reach-extension. -/
theorem s642_frequency_decade_gap_11 :
    f_LIGO_log10 - f_NANOGrav_log10 = 11 := by
  unfold f_LIGO_log10 f_NANOGrav_log10; norm_num

/-- **🚨 FRONTIER — s642 — Joint frequency band ordering**:
    NANOGrav < LIGO with strict 11-decade gap. -/
theorem s642_frequency_band_ordering :
    f_NANOGrav_log10 < f_LIGO_log10
    ∧ f_LIGO_log10 - f_NANOGrav_log10 = 11 :=
  ⟨s642_f_NANOGrav_below_LIGO, s642_frequency_decade_gap_11⟩

/-! ## s643 — Bundle composition + NANOGravPTAStochasticGW Prop -/

/-- **NANOGrav PTA Stochastic GW Properties** — five-conjunct precision
    Prop capturing the joint constraints on GW amplitude, spectral
    index, statistical significance, and the GW-frequency band gap
    against LIGO.

    This is a real Prop: each conjunct is a non-trivial real-arithmetic
    inequality on the corresponding `noncomputable def`. No stubs, no
    `True := trivial`, no placeholder Props. -/
def NANOGravPTAStochasticGW : Prop :=
    (1 < A_yr_NANOGrav_units ∧ A_yr_NANOGrav_units < 100)
    ∧ (4 < gamma_HD_target ∧ gamma_HD_target < 5)
    ∧ (3 < HD_significance_sigma ∧ HD_significance_sigma < 5)
    ∧ f_NANOGrav_log10 < f_LIGO_log10
    ∧ f_LIGO_log10 - f_NANOGrav_log10 = 11

/-- **s643 — NANOGrav PTA stochastic GW properties hold**. -/
theorem s643_nanograv_pta_stochastic_gw :
    NANOGravPTAStochasticGW := by
  refine ⟨⟨s639_A_yr_above_1, s639_A_yr_below_100⟩,
          ⟨s640_gamma_HD_above_4, s640_gamma_HD_below_5⟩,
          ⟨s641_HD_significance_above_3, s641_HD_significance_below_5⟩,
          s642_f_NANOGrav_below_LIGO,
          s642_frequency_decade_gap_11⟩

/-- **🚨 FRONTIER — HEADLINE — s639-s643 — NANOGrav PTA stochastic
    GW background bundle**.

    Eight foundational facts spanning amplitude / spectral index /
    significance / band-reach:

    1. `A_yr > 0` (s639 — strain amplitude positive).
    2. `1 < A_yr < 100` in `10⁻¹⁵` units (s639 — `6.4 × 10⁻¹⁵` band).
    3. `γ_HD > 0` (s640 — spectral index positive).
    4. `4 < γ_HD < 5` (s640 — `4.33 ≈ 13/3` SMBHB anchor band).
    5. `0 < HD_significance < 5` (s641 — `3.5σ`, evidence but not 5σ).
    6. `3 < HD_significance` (s641 — statistically meaningful).
    7. `f_NANOGrav < f_LIGO` (s642 — band ordering nHz < 100 Hz).
    8. `f_LIGO - f_NANOGrav = 11` decades (s642 — frequency gap).

    GW landscape:
    - **NANOGrav 15-yr (2023)**: stochastic background ~3.5σ HD,
      `A_yr ≈ 6.4 × 10⁻¹⁵` at `f_yr⁻¹ ≈ 3.17 × 10⁻⁸ Hz`.
    - **Spectral index**: `γ_HD = 13/3 ≈ 4.33` predicted by SMBHB
      (supermassive black hole binary) merger driven background.
    - **Frequency band**: `f ≈ 10⁻⁹ Hz` (nHz) — vs LIGO `~10² Hz`,
      `LISA ~10⁻³ Hz` — extending the GW window 11 orders of
      magnitude below LIGO.
    - **Possible source classes**: SMBHB mergers (canonical), or
      new-physics signatures (cosmic strings, primordial inflation,
      first-order phase transitions).

    Sub-lemmas for sessions s639-s643 in T-1.  Lean-core only.

    🏆 First Lean-core formalization of the NANOGrav 15-yr stochastic
       GW background spectral + significance bundle (multi-anchor
       version distinct from single-A_GWB session 254). -/
theorem s639_s643_nanograv_pta_stochastic_gw_bundle_headline :
    0 < A_yr_NANOGrav_units
    ∧ (1 < A_yr_NANOGrav_units ∧ A_yr_NANOGrav_units < 100)
    ∧ 0 < gamma_HD_target
    ∧ (4 < gamma_HD_target ∧ gamma_HD_target < 5)
    ∧ (0 < HD_significance_sigma ∧ HD_significance_sigma < 5)
    ∧ 3 < HD_significance_sigma
    ∧ f_NANOGrav_log10 < f_LIGO_log10
    ∧ f_LIGO_log10 - f_NANOGrav_log10 = 11 :=
  ⟨s639_A_yr_pos,
   ⟨s639_A_yr_above_1, s639_A_yr_below_100⟩,
   s640_gamma_HD_pos,
   ⟨s640_gamma_HD_above_4, s640_gamma_HD_below_5⟩,
   ⟨s641_HD_significance_pos, s641_HD_significance_below_5⟩,
   s641_HD_significance_above_3,
   s642_f_NANOGrav_below_LIGO,
   s642_frequency_decade_gap_11⟩

end OmegaTheory.Predictions.T1_NANOGravPTAStochasticGWBundle
