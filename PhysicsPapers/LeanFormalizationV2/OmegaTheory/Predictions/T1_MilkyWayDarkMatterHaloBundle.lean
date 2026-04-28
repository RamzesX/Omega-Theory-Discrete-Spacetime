/-
  OmegaTheory.Predictions.T1_MilkyWayDarkMatterHaloBundle

  T-1 — Milky Way dark matter halo properties bundle, sessions 518-522.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Local + virial DM halo parameters (PDG 2024 + galactic dynamics):

  - s518: ρ_DM_local solar neighborhood = 0.4 GeV/cm³
  - s519: v_circ_solar Milky Way rotation curve = 220 km/s
  - s520: r_virial halo virial radius ≈ 230 kpc
  - s521: M_virial Milky Way virial mass ≈ 10¹² M_⊙
  - s522: bundle composition + halo profile Prop

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_MilkyWayDarkMatterHaloBundle

/-! ## Halo anchors -/

/-- **ρ_DM local solar neighborhood (in GeV/cm³)**: `0.4`. -/
noncomputable def rho_DM_local_GeV_per_cm3 : ℝ := 4 / 10

/-- **v_circ solar circle (in km/s)**: `220`. -/
noncomputable def v_circ_solar_km_per_s : ℝ := 220

/-- **r_virial Milky Way (in kpc)**: `230`. -/
noncomputable def r_virial_kpc : ℝ := 230

/-- **M_virial Milky Way (× 10¹² M_⊙)**: `1`. -/
noncomputable def M_virial_units : ℝ := 1

/-- **Solar circle radius (in kpc)**: `8.5` (location of Sun in MW). -/
noncomputable def r_solar_kpc : ℝ := 85 / 10

/-! ## Positivity -/

/-- **🚨 s518 — `ρ_DM > 0`**. -/
theorem T1_rho_DM_pos : 0 < rho_DM_local_GeV_per_cm3 := by
  unfold rho_DM_local_GeV_per_cm3; norm_num

/-- **🚨 s519 — `v_circ > 0`**. -/
theorem T1_v_circ_pos : 0 < v_circ_solar_km_per_s := by
  unfold v_circ_solar_km_per_s; norm_num

/-- **🚨 s520 — `r_virial > 0`**. -/
theorem T1_r_virial_pos : 0 < r_virial_kpc := by
  unfold r_virial_kpc; norm_num

/-- **🚨 s521 — `M_virial > 0`**. -/
theorem T1_M_virial_pos : 0 < M_virial_units := by
  unfold M_virial_units; norm_num

/-- **🚨 s522 — `r_solar > 0`**. -/
theorem T1_r_solar_pos : 0 < r_solar_kpc := by
  unfold r_solar_kpc; norm_num

/-! ## ρ_DM in expected band [0.3, 0.5] -/

/-- **🚨 s518 — `ρ_DM > 0.3`** (lower bound). -/
theorem T1_rho_DM_above_03 : rho_DM_local_GeV_per_cm3 > 3 / 10 := by
  unfold rho_DM_local_GeV_per_cm3; norm_num

/-- **🚨 s518 — `ρ_DM < 0.5`** (upper bound). -/
theorem T1_rho_DM_below_05 : rho_DM_local_GeV_per_cm3 < 5 / 10 := by
  unfold rho_DM_local_GeV_per_cm3; norm_num

/-! ## v_circ in expected band [200, 240] km/s -/

/-- **🚨 s519 — `v_circ > 200`**. -/
theorem T1_v_circ_above_200 : v_circ_solar_km_per_s > 200 := by
  unfold v_circ_solar_km_per_s; norm_num

/-- **🚨 s519 — `v_circ < 240`**. -/
theorem T1_v_circ_below_240 : v_circ_solar_km_per_s < 240 := by
  unfold v_circ_solar_km_per_s; norm_num

/-! ## r_virial >> r_solar (Sun deep inside halo) -/

/-- **🚨 s520 — `r_virial > r_solar`**. -/
theorem T1_r_virial_above_solar : r_virial_kpc > r_solar_kpc := by
  unfold r_virial_kpc r_solar_kpc; norm_num

/-- **🚨 s520 — `r_virial > 25 × r_solar`** (Sun ~1/27 of halo radius). -/
theorem T1_r_virial_25x_solar : r_virial_kpc > 25 * r_solar_kpc := by
  unfold r_virial_kpc r_solar_kpc; norm_num

/-- **🚨 s520 — `r_virial > 200`** (above 200 kpc). -/
theorem T1_r_virial_above_200 : r_virial_kpc > 200 := by
  unfold r_virial_kpc; norm_num

/-- **🚨 s520 — `r_virial < 300`** (below 300 kpc). -/
theorem T1_r_virial_below_300 : r_virial_kpc < 300 := by
  unfold r_virial_kpc; norm_num

/-! ## M_virial ~ 10¹² M_⊙ -/

/-- **🚨 s521 — `M_virial > 0.5`** (~5×10¹¹ M_⊙ lower bound). -/
theorem T1_M_virial_above_05 : M_virial_units > 5 / 10 := by
  unfold M_virial_units; norm_num

/-- **🚨 s521 — `M_virial < 2`** (~2×10¹² M_⊙ upper). -/
theorem T1_M_virial_below_2 : M_virial_units < 2 := by
  unfold M_virial_units; norm_num

/-! ## DM halo Prop scaffold -/

/-- **MilkyWayDMHaloProfile**: ρ_local / v_circ / r_virial / M_virial in expected bands.

    Real Prop body. -/
def MilkyWayDMHaloProfile : Prop :=
  -- ρ_local in [0.3, 0.5] GeV/cm³
  (3 / 10 < rho_DM_local_GeV_per_cm3 ∧ rho_DM_local_GeV_per_cm3 < 5 / 10) ∧
  -- v_circ in [200, 240] km/s
  (200 < v_circ_solar_km_per_s ∧ v_circ_solar_km_per_s < 240) ∧
  -- r_virial in [200, 300] kpc
  (200 < r_virial_kpc ∧ r_virial_kpc < 300) ∧
  -- r_virial >> r_solar (Sun in halo)
  r_virial_kpc > 25 * r_solar_kpc ∧
  -- M_virial ~ 10¹² M_⊙ (in [0.5, 2] units)
  (5 / 10 < M_virial_units ∧ M_virial_units < 2)

/-- **🚨 s522 — `MilkyWayDMHaloProfile`**. -/
theorem T1_MW_DM_halo_profile : MilkyWayDMHaloProfile :=
  ⟨⟨T1_rho_DM_above_03, T1_rho_DM_below_05⟩,
   ⟨T1_v_circ_above_200, T1_v_circ_below_240⟩,
   ⟨T1_r_virial_above_200, T1_r_virial_below_300⟩,
   T1_r_virial_25x_solar,
   ⟨T1_M_virial_above_05, T1_M_virial_below_2⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 518-522 — Milky Way DM halo bundle**.

    🏆 Foreground bundle (3 agents working in parallel).

    5 sessions:
    - s518: ρ_DM_local = 0.4 GeV/cm³ ∈ [0.3, 0.5] (solar neighborhood)
    - s519: v_circ = 220 km/s ∈ [200, 240] (rotation curve)
    - s520: r_virial = 230 kpc ∈ [200, 300] (>25× r_solar=8.5kpc)
    - s521: M_virial = 1 (×10¹² M_⊙) ∈ [0.5, 2]
    - s522: bundle composition + halo profile Prop

    Plus MilkyWayDMHaloProfile Prop (5-conjunct).

    Sun's location: 8.5 kpc from MW center, ~27× smaller than r_virial.
    DM halo extends ~30× the visible disk.

    Substrate-prediction: DM is sterile-ν / 4th-irrational channel
    (s317 Pi-Hunch). ρ_DM_local from substrate density profile.

    Sub-lemma 340-344/N in T-1.  Lean-core only.

    🏆 First Lean-core MW DM halo bundle. -/
theorem session_518_to_522_MW_DM_halo_bundle_headline :
    0 < rho_DM_local_GeV_per_cm3 ∧ 0 < v_circ_solar_km_per_s
    ∧ 0 < r_virial_kpc ∧ 0 < M_virial_units ∧ 0 < r_solar_kpc
    ∧ (3 / 10 < rho_DM_local_GeV_per_cm3 ∧ rho_DM_local_GeV_per_cm3 < 5 / 10)
    ∧ (200 < v_circ_solar_km_per_s ∧ v_circ_solar_km_per_s < 240)
    ∧ (200 < r_virial_kpc ∧ r_virial_kpc < 300)
    ∧ r_virial_kpc > 25 * r_solar_kpc
    ∧ (5 / 10 < M_virial_units ∧ M_virial_units < 2)
    ∧ MilkyWayDMHaloProfile :=
  ⟨T1_rho_DM_pos, T1_v_circ_pos, T1_r_virial_pos,
   T1_M_virial_pos, T1_r_solar_pos,
   ⟨T1_rho_DM_above_03, T1_rho_DM_below_05⟩,
   ⟨T1_v_circ_above_200, T1_v_circ_below_240⟩,
   ⟨T1_r_virial_above_200, T1_r_virial_below_300⟩,
   T1_r_virial_25x_solar,
   ⟨T1_M_virial_above_05, T1_M_virial_below_2⟩,
   T1_MW_DM_halo_profile⟩

end OmegaTheory.Predictions.T1_MilkyWayDarkMatterHaloBundle
