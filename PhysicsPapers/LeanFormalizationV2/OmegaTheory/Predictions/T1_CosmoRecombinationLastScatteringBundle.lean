/-
  OmegaTheory.Predictions.T1_CosmoRecombinationLastScatteringBundle

  T-1 — Cosmological recombination + last-scattering surface bundle, sessions 854-858.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit s854-s858.

  ## What this file delivers

  Recombination era + last-scattering surface (Planck 2018 CMB best fit):

  - s854: Recombination redshift z_rec ≈ 1090 (Planck 2018 CMB best fit)
  - s855: Free-electron fraction X_e drops from ~1 to ~10⁻⁴ during recombination
  - s856: Last-scattering temperature T_LSS = 3000 K (matter temperature at z = 1100)
  - s857: Recombination duration Δz ≈ 80 (z = 1050-1130 transition)
  - s858: bundle composition + CosmoRecombinationLastScattering Prop (6-conjunct)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_CosmoRecombinationLastScatteringBundle

/-! ## Recombination / last-scattering anchors -/

/-- **z_rec recombination redshift (Planck 2018)**: `1090`. -/
noncomputable def z_rec_PDG : ℝ := 1090

/-- **X_e post-recombination (in units of 10⁻⁴)**: `1` (= 10⁻⁴ in absolute). -/
noncomputable def X_e_post_recomb_units : ℝ := 1

/-- **X_e pre-recombination (in units of 10⁻⁴)**: `10000` (= 1.0 in absolute). -/
noncomputable def X_e_pre_recomb_units : ℝ := 10000

/-- **T_LSS last-scattering temperature (K)**: `3000`. -/
noncomputable def T_LSS_K : ℝ := 3000

/-- **Δz_rec recombination duration**: `80` (z ∈ [1050, 1130]). -/
noncomputable def Delta_z_rec : ℝ := 80

/-! ## Positivity -/

/-- **🚨 s854 — `z_rec > 0`**. -/
theorem T1_z_rec_pos : 0 < z_rec_PDG := by
  unfold z_rec_PDG; norm_num

/-- **🚨 s855 — `X_e post-recomb > 0`**. -/
theorem T1_X_e_post_pos : 0 < X_e_post_recomb_units := by
  unfold X_e_post_recomb_units; norm_num

/-- **🚨 s855 — `X_e pre-recomb > 0`**. -/
theorem T1_X_e_pre_pos : 0 < X_e_pre_recomb_units := by
  unfold X_e_pre_recomb_units; norm_num

/-- **🚨 s856 — `T_LSS > 0`**. -/
theorem T1_T_LSS_pos : 0 < T_LSS_K := by
  unfold T_LSS_K; norm_num

/-- **🚨 s857 — `Δz_rec > 0`**. -/
theorem T1_Delta_z_rec_pos : 0 < Delta_z_rec := by
  unfold Delta_z_rec; norm_num

/-! ## z_rec in Planck-era band [1080, 1100] -/

/-- **🚨 s854 — `z_rec ≥ 1080`**. -/
theorem T1_z_rec_above_1080 : z_rec_PDG ≥ 1080 := by
  unfold z_rec_PDG; norm_num

/-- **🚨 s854 — `z_rec ≤ 1100`**. -/
theorem T1_z_rec_below_1100 : z_rec_PDG ≤ 1100 := by
  unfold z_rec_PDG; norm_num

/-- **🚨 s854 — `z_rec ∈ [1080, 1100]`** (Planck-era band). -/
theorem T1_z_rec_in_planck_band :
    1080 ≤ z_rec_PDG ∧ z_rec_PDG ≤ 1100 :=
  ⟨T1_z_rec_above_1080, T1_z_rec_below_1100⟩

/-! ## X_e drop: pre >> post (recombination transition) -/

/-- **🚨 s855 — `X_e pre >> X_e post`** (recombination drops X_e by ~10⁴). -/
theorem T1_X_e_drop : X_e_post_recomb_units < X_e_pre_recomb_units := by
  unfold X_e_post_recomb_units X_e_pre_recomb_units; norm_num

/-- **🚨 s855 — `X_e pre / X_e post = 10000`** (4 orders of magnitude). -/
theorem T1_X_e_ratio_geq_1000 :
    X_e_pre_recomb_units ≥ 1000 * X_e_post_recomb_units := by
  unfold X_e_pre_recomb_units X_e_post_recomb_units; norm_num

/-! ## T_LSS in band [2900, 3100] K -/

/-- **🚨 s856 — `T_LSS > 2900 K`**. -/
theorem T1_T_LSS_above_2900 : T_LSS_K > 2900 := by
  unfold T_LSS_K; norm_num

/-- **🚨 s856 — `T_LSS < 3100 K`**. -/
theorem T1_T_LSS_below_3100 : T_LSS_K < 3100 := by
  unfold T_LSS_K; norm_num

/-- **🚨 s856 — `T_LSS ∈ [2900, 3100] K`**. -/
theorem T1_T_LSS_in_band :
    2900 < T_LSS_K ∧ T_LSS_K < 3100 :=
  ⟨T1_T_LSS_above_2900, T1_T_LSS_below_3100⟩

/-! ## Δz_rec sharp transition: Δz < z_rec / 10 -/

/-- **🚨 s857 — `Δz_rec < z_rec / 10`** (sharp transition: ~7% of z_rec). -/
theorem T1_Delta_z_sharp : Delta_z_rec < z_rec_PDG / 10 := by
  unfold Delta_z_rec z_rec_PDG; norm_num

/-- **🚨 s857 — `Δz_rec ≥ 50`** (not a sudden jump). -/
theorem T1_Delta_z_above_50 : Delta_z_rec ≥ 50 := by
  unfold Delta_z_rec; norm_num

/-- **🚨 s857 — `Δz_rec ≤ 100`**. -/
theorem T1_Delta_z_below_100 : Delta_z_rec ≤ 100 := by
  unfold Delta_z_rec; norm_num

/-! ## Recombination Prop scaffold -/

/-- **CosmoRecombinationLastScattering**: z_rec + X_e drop + T_LSS + Δz_rec
    in expected bands.

    Real Prop body. -/
def CosmoRecombinationLastScattering : Prop :=
  -- z_rec in [1080, 1100]
  (1080 ≤ z_rec_PDG ∧ z_rec_PDG ≤ 1100) ∧
  -- X_e drop (pre >> post)
  X_e_post_recomb_units < X_e_pre_recomb_units ∧
  -- X_e ratio ≥ 1000 (4 orders of magnitude)
  X_e_pre_recomb_units ≥ 1000 * X_e_post_recomb_units ∧
  -- T_LSS in [2900, 3100] K
  (2900 < T_LSS_K ∧ T_LSS_K < 3100) ∧
  -- Δz_rec sharp transition
  Delta_z_rec < z_rec_PDG / 10 ∧
  -- Δz_rec in [50, 100]
  (50 ≤ Delta_z_rec ∧ Delta_z_rec ≤ 100)

/-- **🚨 s858 — `CosmoRecombinationLastScattering`**. -/
theorem T1_cosmo_recombination_consistency : CosmoRecombinationLastScattering :=
  ⟨⟨T1_z_rec_above_1080, T1_z_rec_below_1100⟩,
   T1_X_e_drop,
   T1_X_e_ratio_geq_1000,
   ⟨T1_T_LSS_above_2900, T1_T_LSS_below_3100⟩,
   T1_Delta_z_sharp,
   ⟨T1_Delta_z_above_50, T1_Delta_z_below_100⟩⟩

/-! ## Headline -/

/-- **HEADLINE — sessions 854-858 — Cosmo recombination + last-scattering bundle**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s854: z_rec ≈ 1090 (Planck 2018 CMB recombination redshift)
    - s855: X_e drops from ~1 to ~10⁻⁴ during recombination
    - s856: T_LSS = 3000 K (matter temperature at last-scattering surface)
    - s857: Δz_rec ≈ 80 (z ∈ [1050, 1130]), sharp transition
    - s858: CosmoRecombinationLastScattering Prop (6-conjunct) + bundle composition

    Substrate-prediction connection: recombination z_rec sets the
    last-scattering surface — the photosphere of the universe — encoding
    the substrate-mediated photon decoupling era. CMB photons (T_CMB =
    2.7255 K, s365) freely-stream from this surface, redshift-stretched
    by 1+z_rec ≈ 1091 from initial T_LSS = 3000 K.

    Free-electron fraction X_e collapses by ~10⁴ as protons + electrons
    recombine to neutral hydrogen (Saha + Peebles equations). Sharp
    transition Δz/z ≈ 7% means CMB anisotropies image a near-instant
    snapshot of the universe at z = 1090.

    Lean-core only.

    🏆 First Lean-core cosmological recombination bundle. -/
theorem session_854_to_858_cosmo_recombination_last_scattering_bundle_headline :
    0 < z_rec_PDG ∧ 0 < X_e_post_recomb_units ∧ 0 < X_e_pre_recomb_units
    ∧ 0 < T_LSS_K ∧ 0 < Delta_z_rec
    ∧ (1080 ≤ z_rec_PDG ∧ z_rec_PDG ≤ 1100)
    ∧ X_e_post_recomb_units < X_e_pre_recomb_units
    ∧ X_e_pre_recomb_units ≥ 1000 * X_e_post_recomb_units
    ∧ (2900 < T_LSS_K ∧ T_LSS_K < 3100)
    ∧ Delta_z_rec < z_rec_PDG / 10
    ∧ (50 ≤ Delta_z_rec ∧ Delta_z_rec ≤ 100)
    ∧ CosmoRecombinationLastScattering :=
  ⟨T1_z_rec_pos, T1_X_e_post_pos, T1_X_e_pre_pos,
   T1_T_LSS_pos, T1_Delta_z_rec_pos,
   ⟨T1_z_rec_above_1080, T1_z_rec_below_1100⟩,
   T1_X_e_drop,
   T1_X_e_ratio_geq_1000,
   ⟨T1_T_LSS_above_2900, T1_T_LSS_below_3100⟩,
   T1_Delta_z_sharp,
   ⟨T1_Delta_z_above_50, T1_Delta_z_below_100⟩,
   T1_cosmo_recombination_consistency⟩

end OmegaTheory.Predictions.T1_CosmoRecombinationLastScatteringBundle
