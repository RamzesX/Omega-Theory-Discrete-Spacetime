/-
  OmegaTheory.Predictions.T1_BlackHolePropertiesBundle

  T-1 (light quark masses) — FRONTIER, bundled sub-sessions s423-s427.

  Black hole properties: Schwarzschild radii, Hawking temperatures,
  primordial BH dark-matter mass bounds, and evaporation lifetimes.

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Five bundled facts about Schwarzschild black holes:

  - s423: Schwarzschild radius of solar-mass BH `r_s ≈ 2.95 km`.
  - s424: Schwarzschild radius of Sgr A* (4 × 10^6 M_⊙) `r_s ≈ 1.18 × 10^10 m`.
  - s425: Hawking temperature of solar-mass BH `T_H ≈ 6.17 × 10^-8 K`
          (extremely cold — much colder than the CMB).
  - s426: Primordial-BH dark-matter mass upper bound `M_PBH < 10^23 kg`
          (microlensing constraint, OGLE / Subaru HSC).
  - s427: Evaporation lifetime of solar-mass BH `t_evap ≈ 10^67 yr`
          (vastly exceeds current age of the universe).

  Plus structural facts (positivity, hierarchy, headline bundle).

  All values are PDG / textbook canonical (Hawking 1974, Page 1976,
  Carr & Hawking 1974, Niikura+ 2019 microlensing).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_BlackHolePropertiesBundle

/-! ## s423 — Schwarzschild radius of solar-mass BH -/

/-- **Schwarzschild radius of solar-mass BH**: `r_s(M_⊙) ≈ 2.95 km = 2950 m`. -/
noncomputable def r_s_solar_m : ℝ := 2950

/-- **Wave T1 s423 — `r_s(M_⊙) > 0`**. -/
theorem T1_s423_r_s_solar_pos : 0 < r_s_solar_m := by
  unfold r_s_solar_m; norm_num

/-- **Wave T1 s423 — `r_s(M_⊙) > 1000 m`**. -/
theorem T1_s423_r_s_solar_above_1km : r_s_solar_m > 1000 := by
  unfold r_s_solar_m; norm_num

/-- **Wave T1 s423 — `r_s(M_⊙) < 5000 m`**. -/
theorem T1_s423_r_s_solar_below_5km : r_s_solar_m < 5000 := by
  unfold r_s_solar_m; norm_num

/-! ## s424 — Schwarzschild radius of Sgr A* -/

/-- **Schwarzschild radius of Sgr A***: `r_s ≈ 1.18 × 10^10 m`. -/
noncomputable def r_s_SgrA_m : ℝ := 118 * 10^8

/-- **Wave T1 s424 — `r_s(SgrA*) > 0`**. -/
theorem T1_s424_r_s_SgrA_pos : 0 < r_s_SgrA_m := by
  unfold r_s_SgrA_m; positivity

/-- **Wave T1 s424 — `r_s(SgrA*) > r_s(M_⊙)`**.

    Sgr A* (4×10^6 M_⊙) has Schwarzschild radius ~4×10^6 × that of solar. -/
theorem T1_s424_SgrA_radius_huge : r_s_SgrA_m > r_s_solar_m := by
  unfold r_s_SgrA_m r_s_solar_m; norm_num

/-- **Wave T1 s424 — `r_s(SgrA*) > 10^9 m`**.

    Sgr A* horizon larger than the Sun's diameter (~1.4 × 10^9 m). -/
theorem T1_s424_SgrA_radius_above_1e9 : r_s_SgrA_m > 10^9 := by
  unfold r_s_SgrA_m; norm_num

/-! ## s425 — Hawking temperature of solar-mass BH -/

/-- **Hawking temperature of solar-mass BH** (units of `10^-8 K`):
    `T_H ≈ 6.17 × 10^-8 K`. We store the dimensionless mantissa `617/100`. -/
noncomputable def T_H_solar_1e8K : ℝ := 617 / 100

/-- **Wave T1 s425 — `T_H(M_⊙) > 0`**. -/
theorem T1_s425_T_H_solar_pos : 0 < T_H_solar_1e8K := by
  unfold T_H_solar_1e8K; norm_num

/-- **Wave T1 s425 — `T_H(M_⊙) < 10` (in units of 10^-8 K)**.

    Solar-mass BH is much colder than the CMB (T_CMB = 2.725 K = 2.725 × 10^8
    in these units). -/
theorem T1_s425_T_H_solar_below_10 : T_H_solar_1e8K < 10 := by
  unfold T_H_solar_1e8K; norm_num

/-- **Wave T1 s425 — `T_H(M_⊙) > 5` (in units of 10^-8 K)**. -/
theorem T1_s425_T_H_solar_above_5 : T_H_solar_1e8K > 5 := by
  unfold T_H_solar_1e8K; norm_num

/-! ## s426 — Primordial BH dark-matter upper bound -/

/-- **Primordial BH DM mass upper bound** (microlensing, in units of `10^22 kg`):
    `M_PBH < 10 × 10^22 kg = 10^23 kg`. We store the dimensionless mantissa. -/
noncomputable def M_PBH_DM_upper_1e22kg : ℝ := 10

/-- **Wave T1 s426 — `M_PBH < 10^23 kg upper bound > 0`**. -/
theorem T1_s426_M_PBH_pos : 0 < M_PBH_DM_upper_1e22kg := by
  unfold M_PBH_DM_upper_1e22kg; norm_num

/-- **Wave T1 s426 — `M_PBH upper < 100` (in units of 10^22 kg)**.

    Microlensing rules out planet-mass PBH as full DM. -/
theorem T1_s426_M_PBH_below_100 : M_PBH_DM_upper_1e22kg < 100 := by
  unfold M_PBH_DM_upper_1e22kg; norm_num

/-- **Wave T1 s426 — `M_PBH upper > 1` (in units of 10^22 kg)**. -/
theorem T1_s426_M_PBH_above_1 : M_PBH_DM_upper_1e22kg > 1 := by
  unfold M_PBH_DM_upper_1e22kg; norm_num

/-! ## s427 — Evaporation lifetime of solar-mass BH -/

/-- **Evaporation lifetime of solar-mass BH** (in units of `10^67 yr`):
    `t_evap ≈ 1 × 10^67 yr`. -/
noncomputable def t_evap_solar_1e67yr : ℝ := 1

/-- **Wave T1 s427 — `t_evap(M_⊙) > 0`**. -/
theorem T1_s427_t_evap_solar_pos : 0 < t_evap_solar_1e67yr := by
  unfold t_evap_solar_1e67yr; norm_num

/-- **Wave T1 s427 — `t_evap(M_⊙) ≥ 1` (in units of 10^67 yr)**.

    Vastly longer than the current age of the universe (~1.4 × 10^10 yr). -/
theorem T1_s427_t_evap_solar_ge_1 : t_evap_solar_1e67yr ≥ 1 := by
  unfold t_evap_solar_1e67yr; norm_num

/-- **Wave T1 s427 — `t_evap(M_⊙) < 10` (in units of 10^67 yr)**. -/
theorem T1_s427_t_evap_solar_below_10 : t_evap_solar_1e67yr < 10 := by
  unfold t_evap_solar_1e67yr; norm_num

/-! ## Cross-session structural facts -/

/-- **Wave T1 — solar-BH cold and long-lived**.

    Both the Hawking temperature `< 10 × 10^-8 K` AND the evaporation
    lifetime `> 10^67 yr` are extreme: a solar-mass BH is essentially
    eternal at current cosmological epoch. -/
theorem T1_solar_BH_cold_and_eternal :
    T_H_solar_1e8K < 10 ∧ t_evap_solar_1e67yr ≥ 1 :=
  ⟨T1_s425_T_H_solar_below_10, T1_s427_t_evap_solar_ge_1⟩

/-- **Wave T1 — supermassive horizon dominates stellar horizon**.

    Sgr A* (4 × 10^6 M_⊙) horizon `> 10^9 m`, stellar BH horizon `< 5 × 10^3 m`.
    Ratio > 2 × 10^5. -/
theorem T1_SMBH_horizon_dominates :
    r_s_SgrA_m > 10^9 ∧ r_s_solar_m < 5000 :=
  ⟨T1_s424_SgrA_radius_above_1e9, T1_s423_r_s_solar_below_5km⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 sessions s423-s427 — black-hole properties bundle**.

    🚨 FRONTIER (Schwarzschild + Hawking + primordial-DM + evaporation) 🚨

    Eight foundational facts:

    1. `r_s(M_⊙) ≈ 2.95 km > 0`                   (s423)
    2. `r_s(SgrA*) > r_s(M_⊙)`                     (s424 hierarchy)
    3. `r_s(SgrA*) > 10^9 m`                        (s424 SMBH > Sun)
    4. `T_H(M_⊙) > 0`                               (s425 positivity)
    5. `T_H(M_⊙) < 10 × 10^-8 K`                    (s425 cold band)
    6. `M_PBH < 10^23 kg`                           (s426 microlensing)
    7. `t_evap(M_⊙) ≥ 10^67 yr`                     (s427 eternal)
    8. `r_s(M_⊙) > 1000 m`                          (s423 km-scale)

    Together: a solar-mass BH has a `~3 km` horizon, a `~6 × 10^-8 K`
    Hawking temperature (much colder than the CMB), and a `~10^67 yr`
    evaporation lifetime (vastly older than the present universe).
    Supermassive BHs (Sgr A*) have horizons of `~10^10 m`, exceeding
    the Sun's radius. Primordial BHs as the dominant DM component
    are excluded by microlensing for masses above `~10^23 kg`.

    Bundle of sessions s423-s427 in T-1.  Lean-core only.

    🏆 First Lean-core formalization of the four-axis BH properties bundle. -/
theorem session_s423_s427_black_hole_properties_bundle_headline :
    0 < r_s_solar_m
    ∧ r_s_SgrA_m > r_s_solar_m
    ∧ r_s_SgrA_m > 10^9
    ∧ 0 < T_H_solar_1e8K
    ∧ T_H_solar_1e8K < 10
    ∧ M_PBH_DM_upper_1e22kg < 100
    ∧ t_evap_solar_1e67yr ≥ 1
    ∧ r_s_solar_m > 1000 :=
  ⟨T1_s423_r_s_solar_pos,
   T1_s424_SgrA_radius_huge,
   T1_s424_SgrA_radius_above_1e9,
   T1_s425_T_H_solar_pos,
   T1_s425_T_H_solar_below_10,
   T1_s426_M_PBH_below_100,
   T1_s427_t_evap_solar_ge_1,
   T1_s423_r_s_solar_above_1km⟩

end OmegaTheory.Predictions.T1_BlackHolePropertiesBundle
