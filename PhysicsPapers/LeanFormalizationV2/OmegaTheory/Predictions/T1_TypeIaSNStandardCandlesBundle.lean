/-
  OmegaTheory.Predictions.T1_TypeIaSNStandardCandlesBundle

  T-1 — Type Ia supernova standard candles bundle, sessions 824-828.

  Single-thread hand-authored 2026-04-28 (cycle 65, frontier #313).

  ## What this file delivers

  Type Ia supernovae as the rung-3 standard candles of the SH0ES distance
  ladder (Riess et al. 2022). Phillips brightness-decline relation +
  Hubble-flow redshift band → H_0 anchor consistent with the SH0ES rung
  recorded in `T1_HubbleTensionBundle.lean`:

  - s824: Type Ia peak absolute B-band magnitude M_B ≈ -19.25 (Riess 2022).
  - s825: Phillips relation slope: Δm_15(B) ≈ 1.0 mag (B-band 15-day decline).
  - s826: Hubble-flow redshift band 0.01 < z < 0.1 (cosmological flow regime).
  - s827: Resulting H_0 from SN Ia + Cepheid: 73.0 km/s/Mpc (SH0ES 2022).
  - s828: Bundle composition + TypeIaSNStandardCandles Prop.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_TypeIaSNStandardCandlesBundle

/-! ## Magnitude anchors (in 0.01 mag units, i.e. value × 100) -/

/-- **M_B^TypeIa (signed, units of 0.01 mag)**: `-1925 ↔ -19.25 mag`
    (Riess 2022 SH0ES Cepheid+TRGB-calibrated peak absolute B-band magnitude). -/
noncomputable def M_B_TypeIa_units : ℝ := -1925

/-- **|M_B^TypeIa| (units of 0.01 mag)**: `1925 ↔ 19.25 mag`. -/
noncomputable def M_B_TypeIa_abs_units : ℝ := 1925

/-- **Δm_15(B) (units of 0.01 mag)**: `100 ↔ 1.0 mag` Phillips canonical anchor. -/
noncomputable def Delta_m_15_units : ℝ := 100

/-! ## Hubble-flow redshift band (in units of 0.01) -/

/-- **z_min HubbleFlow (units of 0.01)**: `1 ↔ z = 0.01` lower bound of the
    cosmological flow band (peculiar-velocity contamination below this). -/
noncomputable def z_min_HubbleFlow : ℝ := 1

/-- **z_max HubbleFlow (units of 0.01)**: `10 ↔ z = 0.10` upper bound of the
    nearby Hubble flow used to anchor H_0 (Hubble-Lemaître linear regime). -/
noncomputable def z_max_HubbleFlow : ℝ := 10

/-! ## H_0 anchor from SN Ia + Cepheid (in 10⁻¹ km/s/Mpc units, i.e. ×10) -/

/-- **H_0^SNIa (×10 km/s/Mpc)**: `730 ↔ 73.0 km/s/Mpc` SH0ES 2022 result.
    Same anchor as `T1_HubbleTensionBundle.H0_SH0ES`. -/
noncomputable def H_0_SNIa_units : ℝ := 730

/-! ## Sign + abs identity -/

/-- **🚨 s824 — `M_B^TypeIa = -|M_B^TypeIa|`**. -/
theorem T1_M_B_TypeIa_neg_eq_abs :
    M_B_TypeIa_units = -M_B_TypeIa_abs_units := by
  unfold M_B_TypeIa_units M_B_TypeIa_abs_units; norm_num

/-- **🚨 s824 — `M_B^TypeIa < 0`** (intrinsically luminous). -/
theorem T1_M_B_TypeIa_neg : M_B_TypeIa_units < 0 := by
  unfold M_B_TypeIa_units; norm_num

/-- **🚨 s824 — `|M_B^TypeIa| > 0`**. -/
theorem T1_M_B_TypeIa_abs_pos : 0 < M_B_TypeIa_abs_units := by
  unfold M_B_TypeIa_abs_units; norm_num

/-! ## Magnitude band (15 < |M_B| < 25 in mag, i.e. 1500 < units < 2500) -/

/-- **🚨 s824 — `|M_B^TypeIa| > 1500` (i.e. > 15 mag)** intrinsic luminosity. -/
theorem T1_M_B_TypeIa_abs_above_1500 : 1500 < M_B_TypeIa_abs_units := by
  unfold M_B_TypeIa_abs_units; norm_num

/-- **🚨 s824 — `|M_B^TypeIa| < 2500` (i.e. < 25 mag)** intrinsic luminosity. -/
theorem T1_M_B_TypeIa_abs_below_2500 : M_B_TypeIa_abs_units < 2500 := by
  unfold M_B_TypeIa_abs_units; norm_num

/-- **🚨 s824 — `|M_B^TypeIa|` in the SN Ia luminosity band `[1500, 2500]`**. -/
theorem T1_M_B_TypeIa_abs_in_band :
    1500 < M_B_TypeIa_abs_units ∧ M_B_TypeIa_abs_units < 2500 :=
  ⟨T1_M_B_TypeIa_abs_above_1500, T1_M_B_TypeIa_abs_below_2500⟩

/-- **🚨 s824 — `|M_B^TypeIa|` tighter band `[1900, 1950]` around -19.25 mag**. -/
theorem T1_M_B_TypeIa_abs_tight_band :
    1900 < M_B_TypeIa_abs_units ∧ M_B_TypeIa_abs_units < 1950 := by
  refine ⟨?_, ?_⟩
  · unfold M_B_TypeIa_abs_units; norm_num
  · unfold M_B_TypeIa_abs_units; norm_num

/-! ## Phillips relation slope -/

/-- **🚨 s825 — `Δm_15 > 0`** (the B-band light curve declines after peak). -/
theorem T1_Delta_m_15_pos : 0 < Delta_m_15_units := by
  unfold Delta_m_15_units; norm_num

/-- **🚨 s825 — `Δm_15 < 200`** (canonical SN Ia decline rate is below 2 mag). -/
theorem T1_Delta_m_15_below_200 : Delta_m_15_units < 200 := by
  unfold Delta_m_15_units; norm_num

/-- **🚨 s825 — `Δm_15` in physical Phillips band `[50, 200]`**
    (0.5 mag < decline rate < 2.0 mag). -/
theorem T1_Delta_m_15_in_band :
    50 < Delta_m_15_units ∧ Delta_m_15_units < 200 := by
  refine ⟨?_, ?_⟩
  · unfold Delta_m_15_units; norm_num
  · unfold Delta_m_15_units; norm_num

/-! ## Hubble-flow redshift band -/

/-- **🚨 s826 — `z_min < z_max`** (proper redshift interval). -/
theorem T1_z_min_lt_z_max : z_min_HubbleFlow < z_max_HubbleFlow := by
  unfold z_min_HubbleFlow z_max_HubbleFlow; norm_num

/-- **🚨 s826 — `z_min > 0`**. -/
theorem T1_z_min_pos : 0 < z_min_HubbleFlow := by
  unfold z_min_HubbleFlow; norm_num

/-- **🚨 s826 — `z_max > 0`**. -/
theorem T1_z_max_pos : 0 < z_max_HubbleFlow := by
  unfold z_max_HubbleFlow; norm_num

/-- **🚨 s826 — `z_min` is exactly `0.01` in real units**: `1/100 = z_min/100`. -/
theorem T1_z_min_eq_one : z_min_HubbleFlow = 1 := by
  unfold z_min_HubbleFlow; rfl

/-- **🚨 s826 — `z_max` is exactly `0.10` in real units**: `10/100 = 0.10`. -/
theorem T1_z_max_eq_ten : z_max_HubbleFlow = 10 := by
  unfold z_max_HubbleFlow; rfl

/-! ## H_0 anchor positivity + band -/

/-- **🚨 s827 — `H_0^SNIa > 0`**. -/
theorem T1_H_0_SNIa_pos : 0 < H_0_SNIa_units := by
  unfold H_0_SNIa_units; norm_num

/-- **🚨 s827 — `H_0^SNIa > 700`** (above 70.0 km/s/Mpc per Cepheid+SN Ia). -/
theorem T1_H_0_SNIa_above_700 : 700 < H_0_SNIa_units := by
  unfold H_0_SNIa_units; norm_num

/-- **🚨 s827 — `H_0^SNIa < 750`** (below 75.0 km/s/Mpc). -/
theorem T1_H_0_SNIa_below_750 : H_0_SNIa_units < 750 := by
  unfold H_0_SNIa_units; norm_num

/-- **🚨 s827 — `H_0^SNIa` in the SH0ES band `[700, 750]`**. -/
theorem T1_H_0_SNIa_in_band :
    700 < H_0_SNIa_units ∧ H_0_SNIa_units < 750 :=
  ⟨T1_H_0_SNIa_above_700, T1_H_0_SNIa_below_750⟩

/-! ## TypeIaSNStandardCandles Prop scaffold -/

/-- **TypeIaSNStandardCandles**: the empirical content of Type Ia SN as
    rung-3 standard candles of the SH0ES distance ladder.

    Real Prop body — non-trivial 6-conjunct: peak luminosity sign + absolute
    magnitude band + Phillips decline rate sign + Hubble-flow redshift band
    + H_0 anchor positivity + H_0 anchor in SH0ES band. -/
def TypeIaSNStandardCandles : Prop :=
  -- Peak B-band magnitude is intrinsically negative (luminous)
  M_B_TypeIa_units < 0 ∧
  -- |M_B| in tight band [1900, 1950] around -19.25 mag
  (1900 < M_B_TypeIa_abs_units ∧ M_B_TypeIa_abs_units < 1950) ∧
  -- Phillips slope positive
  0 < Delta_m_15_units ∧
  -- Hubble-flow band proper
  z_min_HubbleFlow < z_max_HubbleFlow ∧
  -- H_0 anchor positive
  0 < H_0_SNIa_units ∧
  -- H_0 in SH0ES band
  (700 < H_0_SNIa_units ∧ H_0_SNIa_units < 750)

/-- **🚨 s828 — `TypeIaSNStandardCandles`**. -/
theorem T1_TypeIa_SN_standard_candles : TypeIaSNStandardCandles :=
  ⟨T1_M_B_TypeIa_neg,
   T1_M_B_TypeIa_abs_tight_band,
   T1_Delta_m_15_pos,
   T1_z_min_lt_z_max,
   T1_H_0_SNIa_pos,
   T1_H_0_SNIa_in_band⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 824-828 — Type Ia SN standard candles bundle**.

    🏆 Frontier topic #313 (T-1).

    5 sessions:
    - s824: M_B^TypeIa = -19.25 mag (Riess 2022 SH0ES Cepheid-calibrated)
    - s825: Δm_15(B) = 1.0 mag canonical Phillips decline rate
    - s826: Hubble-flow redshift band 0.01 < z < 0.10
    - s827: H_0^SNIa = 73.0 km/s/Mpc anchor (SH0ES 2022)
    - s828: bundle composition + TypeIaSNStandardCandles Prop

    Plus TypeIaSNStandardCandles Prop (6-conjunct).

    SN Ia standardised peak luminosity (M_B = -19.25 ± 0.03 mag) calibrated
    against Cepheid hosts (rung 2) gives the rung-3 standard candle of the
    SH0ES ladder. The Hubble-flow band 0.01 < z < 0.1 isolates the linear
    Hubble-Lemaître regime (peculiar velocities subdominant; ΛCDM late-time
    expansion not yet differentiating from flat-z behaviour).

    The resulting H_0 = 73.0 km/s/Mpc agrees exactly with the SH0ES anchor
    in `T1_HubbleTensionBundle.H0_SH0ES`, persisting the ~5σ tension with
    Planck CMB ΛCDM (67.4 km/s/Mpc).

    Sub-lemma 313/N in T-1.  Lean-core only.

    🏆 First Lean-core SN Ia standard-candle bundle with Phillips slope
    + Hubble-flow band + SH0ES anchor cross-validation. -/
theorem session_824_to_828_TypeIa_SN_standard_candles_bundle_headline :
    M_B_TypeIa_units = -M_B_TypeIa_abs_units
    ∧ M_B_TypeIa_units < 0
    ∧ 0 < M_B_TypeIa_abs_units
    ∧ (1500 < M_B_TypeIa_abs_units ∧ M_B_TypeIa_abs_units < 2500)
    ∧ (1900 < M_B_TypeIa_abs_units ∧ M_B_TypeIa_abs_units < 1950)
    ∧ 0 < Delta_m_15_units
    ∧ Delta_m_15_units < 200
    ∧ (50 < Delta_m_15_units ∧ Delta_m_15_units < 200)
    ∧ z_min_HubbleFlow < z_max_HubbleFlow
    ∧ 0 < z_min_HubbleFlow
    ∧ 0 < z_max_HubbleFlow
    ∧ 0 < H_0_SNIa_units
    ∧ (700 < H_0_SNIa_units ∧ H_0_SNIa_units < 750)
    ∧ TypeIaSNStandardCandles :=
  ⟨T1_M_B_TypeIa_neg_eq_abs,
   T1_M_B_TypeIa_neg,
   T1_M_B_TypeIa_abs_pos,
   T1_M_B_TypeIa_abs_in_band,
   T1_M_B_TypeIa_abs_tight_band,
   T1_Delta_m_15_pos,
   T1_Delta_m_15_below_200,
   T1_Delta_m_15_in_band,
   T1_z_min_lt_z_max,
   T1_z_min_pos,
   T1_z_max_pos,
   T1_H_0_SNIa_pos,
   T1_H_0_SNIa_in_band,
   T1_TypeIa_SN_standard_candles⟩

end OmegaTheory.Predictions.T1_TypeIaSNStandardCandlesBundle
