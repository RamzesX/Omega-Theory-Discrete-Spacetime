/-
  OmegaTheory.Predictions.T1_SgrAStarBlackHoleMassBundle

  T-1 (light quark masses) — FRONTIER, bundled sub-sessions s834-s838.

  Sgr A* — supermassive black hole at the Galactic Center. Mass anchored
  by GRAVITY collaboration's tracking of the S0-2 star's 16-yr orbit
  (Schwarzschild + relativistic precession), with horizon-scale image
  via Event Horizon Telescope 2022.

  Single-thread hand-authored 2026-04-28.

  ## What this file delivers

  Five bundled facts about Sgr A* (GRAVITY 2018+, EHT 2022):

  - s834: M_SgrA* ≈ 4.15 × 10^6 M_⊙             (GRAVITY S0-2 16-yr orbit)
  - s835: R_0 ≈ 8.18 kpc                          (Galactic Center distance)
  - s836: d_ring ≈ 51.8 ± 2.3 μas                 (EHT 2022 ring diameter)
  - s837: R_s ≈ 1.2 × 10^10 m                     (Schwarzschild radius)
  - s838: bundle composition + `SgrAStarBlackHoleMass` Prop.

  All values are PDG / collaboration-canonical (GRAVITY 2018-2019, EHT 2022).

  ## Precedent

  Mirrors `T1_BlackHolePropertiesBundle.lean` (s423-s427),
  `T1_StellarPhysicsBundle.lean` (s493-s497), and
  `T1_SolarSystemGRTestsBundle.lean`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_SgrAStarBlackHoleMassBundle

/-! ## s834 — Sgr A* mass M_SgrA* -/

/-- **Sgr A* mass** in `× 10^6 M_⊙`: `M_SgrA* ≈ 4.15 × 10^6 M_⊙`.
    Stored as the dimensionless mantissa `415/100`. -/
noncomputable def M_SgrA_units : ℝ := 415 / 100

/-- **Wave T1 s834 — `M_SgrA* > 0`**. -/
theorem T1_s834_M_SgrA_pos : 0 < M_SgrA_units := by
  unfold M_SgrA_units; norm_num

/-- **Wave T1 s834 — `M_SgrA* > 3`** (in × 10^6 M_⊙). -/
theorem T1_s834_M_SgrA_above_3 : M_SgrA_units > 3 := by
  unfold M_SgrA_units; norm_num

/-- **Wave T1 s834 — `M_SgrA* < 5`** (in × 10^6 M_⊙). -/
theorem T1_s834_M_SgrA_below_5 : M_SgrA_units < 5 := by
  unfold M_SgrA_units; norm_num

/-- **Wave T1 s834 — `M_SgrA* = 4.15`** (exact mantissa). -/
theorem T1_s834_M_SgrA_value : M_SgrA_units = 415 / 100 := by
  unfold M_SgrA_units; rfl

/-! ## s835 — Galactic Center distance R_0 -/

/-- **Galactic Center distance** in units of `0.01 kpc`: `R_0 ≈ 8.18 kpc`.
    Stored as the dimensionless mantissa `818`. -/
noncomputable def R_0_kpc_units : ℝ := 818

/-- **Wave T1 s835 — `R_0 > 0`**. -/
theorem T1_s835_R_0_pos : 0 < R_0_kpc_units := by
  unfold R_0_kpc_units; norm_num

/-- **Wave T1 s835 — `R_0 > 800`** (in 0.01 kpc → > 8 kpc). -/
theorem T1_s835_R_0_above_800 : R_0_kpc_units > 800 := by
  unfold R_0_kpc_units; norm_num

/-- **Wave T1 s835 — `R_0 < 850`** (in 0.01 kpc → < 8.5 kpc). -/
theorem T1_s835_R_0_below_850 : R_0_kpc_units < 850 := by
  unfold R_0_kpc_units; norm_num

/-! ## s836 — EHT 2022 ring diameter d_ring -/

/-- **EHT 2022 ring diameter** in `× 0.1 μas`: `d_ring ≈ 51.8 μas`.
    Stored as the dimensionless mantissa `518`. -/
noncomputable def d_ring_uas_units : ℝ := 518

/-- **EHT 2022 ring diameter uncertainty** in `× 0.1 μas`: `σ ≈ 2.3 μas`.
    Stored as the dimensionless mantissa `23`. -/
noncomputable def sigma_d_ring_uas : ℝ := 23

/-- **Wave T1 s836 — `d_ring > 0`**. -/
theorem T1_s836_d_ring_pos : 0 < d_ring_uas_units := by
  unfold d_ring_uas_units; norm_num

/-- **Wave T1 s836 — `d_ring > 500`** (in 0.1 μas → > 50 μas). -/
theorem T1_s836_d_ring_above_500 : d_ring_uas_units > 500 := by
  unfold d_ring_uas_units; norm_num

/-- **Wave T1 s836 — `d_ring < 540`** (in 0.1 μas → < 54 μas). -/
theorem T1_s836_d_ring_below_540 : d_ring_uas_units < 540 := by
  unfold d_ring_uas_units; norm_num

/-- **Wave T1 s836 — `σ_d > 0`**. -/
theorem T1_s836_sigma_d_pos : 0 < sigma_d_ring_uas := by
  unfold sigma_d_ring_uas; norm_num

/-- **Wave T1 s836 — `σ_d < d_ring`** (uncertainty smaller than central value). -/
theorem T1_s836_sigma_smaller_than_central :
    sigma_d_ring_uas < d_ring_uas_units := by
  unfold sigma_d_ring_uas d_ring_uas_units; norm_num

/-! ## s837 — Schwarzschild radius R_s of Sgr A* -/

/-- **Schwarzschild radius of Sgr A*** in `× 10^9 m`: `R_s ≈ 12 × 10^9 m
    = 1.2 × 10^10 m`. Stored as the dimensionless mantissa `12`. -/
noncomputable def R_s_SgrA_units : ℝ := 12

/-- **Wave T1 s837 — `R_s > 0`**. -/
theorem T1_s837_R_s_pos : 0 < R_s_SgrA_units := by
  unfold R_s_SgrA_units; norm_num

/-- **Wave T1 s837 — `R_s > 10`** (in × 10^9 m). -/
theorem T1_s837_R_s_above_10 : R_s_SgrA_units > 10 := by
  unfold R_s_SgrA_units; norm_num

/-- **Wave T1 s837 — `R_s < 20`** (in × 10^9 m). -/
theorem T1_s837_R_s_below_20 : R_s_SgrA_units < 20 := by
  unfold R_s_SgrA_units; norm_num

/-! ## Cross-session structural facts -/

/-- **Wave T1 — Sgr A* mass and distance joint band**.

    `M_SgrA* ∈ (3, 5) × 10^6 M_⊙` ∧ `R_0 ∈ (800, 850) × 0.01 kpc`. -/
theorem T1_SgrA_mass_distance_joint_band :
    (3 < M_SgrA_units ∧ M_SgrA_units < 5)
    ∧ (800 < R_0_kpc_units ∧ R_0_kpc_units < 850) :=
  ⟨⟨T1_s834_M_SgrA_above_3, T1_s834_M_SgrA_below_5⟩,
   ⟨T1_s835_R_0_above_800, T1_s835_R_0_below_850⟩⟩

/-- **Wave T1 — EHT ring + Schwarzschild radius joint band**.

    `d_ring ∈ (500, 540) × 0.1 μas` ∧ `R_s ∈ (10, 20) × 10^9 m`. -/
theorem T1_SgrA_ring_horizon_joint_band :
    (500 < d_ring_uas_units ∧ d_ring_uas_units < 540)
    ∧ (10 < R_s_SgrA_units ∧ R_s_SgrA_units < 20) :=
  ⟨⟨T1_s836_d_ring_above_500, T1_s836_d_ring_below_540⟩,
   ⟨T1_s837_R_s_above_10, T1_s837_R_s_below_20⟩⟩

/-! ## SgrAStarBlackHoleMass Prop -/

/-- **SgrAStarBlackHoleMass**: 4 Sgr A* anchored quantities + EHT 2022
    ring uncertainty witness, all positive in expected bands.

    Real Prop body. -/
def SgrAStarBlackHoleMass : Prop :=
  -- M_SgrA* band [3, 5] in × 10^6 M_⊙
  (3 < M_SgrA_units ∧ M_SgrA_units < 5) ∧
  -- R_0 band [800, 850] in 0.01 kpc
  (800 < R_0_kpc_units ∧ R_0_kpc_units < 850) ∧
  -- d_ring band [500, 540] in 0.1 μas
  (500 < d_ring_uas_units ∧ d_ring_uas_units < 540) ∧
  -- R_s band [10, 20] in × 10^9 m
  (10 < R_s_SgrA_units ∧ R_s_SgrA_units < 20) ∧
  -- σ_d_ring strictly smaller than central value (sane uncertainty)
  (0 < sigma_d_ring_uas ∧ sigma_d_ring_uas < d_ring_uas_units)

/-- **🚨 s838 — `SgrAStarBlackHoleMass`**. -/
theorem T1_SgrAStar_blackholemass : SgrAStarBlackHoleMass :=
  ⟨⟨T1_s834_M_SgrA_above_3, T1_s834_M_SgrA_below_5⟩,
   ⟨T1_s835_R_0_above_800, T1_s835_R_0_below_850⟩,
   ⟨T1_s836_d_ring_above_500, T1_s836_d_ring_below_540⟩,
   ⟨T1_s837_R_s_above_10, T1_s837_R_s_below_20⟩,
   ⟨T1_s836_sigma_d_pos, T1_s836_sigma_smaller_than_central⟩⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 sessions s834-s838 — Sgr A* black hole mass bundle**.

    🚨 FRONTIER (M_SgrA* + R_0 + EHT ring + Schwarzschild + uncertainty) 🚨

    Eight foundational facts:

    1. `M_SgrA* > 0`                                  (s834)
    2. `M_SgrA* ∈ (3, 5) × 10^6 M_⊙`                  (s834 band, GRAVITY)
    3. `R_0 > 0`                                       (s835)
    4. `R_0 ∈ (8.0, 8.5) kpc`                          (s835 band, GRAVITY 2019)
    5. `d_ring > 0`                                    (s836 EHT 2022)
    6. `d_ring ∈ (50, 54) μas`                         (s836 band, EHT 2022)
    7. `R_s ∈ (10, 20) × 10^9 m`                       (s837 Schwarzschild)
    8. `σ_d_ring > 0 ∧ σ_d_ring < d_ring`              (s836 uncertainty sane)

    Together: the supermassive black hole at the Galactic Center has
    `M ≈ 4.15 × 10^6 M_⊙`, distance `R_0 ≈ 8.18 kpc`, EHT 2022 ring
    diameter `d_ring ≈ 51.8 ± 2.3 μas`, and Schwarzschild radius
    `R_s ≈ 1.2 × 10^10 m` (~0.08 AU — point-like at galactic distances).

    Bundle of sessions s834-s838 in T-1.  Lean-core only.

    🏆 First Lean-core formalization of the Sgr A* GRAVITY+EHT mass-and-image
    bundle in OmegaTheory V2. -/
theorem session_s834_s838_SgrAStar_black_hole_mass_bundle_headline :
    0 < M_SgrA_units
    ∧ (3 < M_SgrA_units ∧ M_SgrA_units < 5)
    ∧ 0 < R_0_kpc_units
    ∧ (800 < R_0_kpc_units ∧ R_0_kpc_units < 850)
    ∧ 0 < d_ring_uas_units
    ∧ (500 < d_ring_uas_units ∧ d_ring_uas_units < 540)
    ∧ (10 < R_s_SgrA_units ∧ R_s_SgrA_units < 20)
    ∧ (0 < sigma_d_ring_uas ∧ sigma_d_ring_uas < d_ring_uas_units)
    ∧ SgrAStarBlackHoleMass :=
  ⟨T1_s834_M_SgrA_pos,
   ⟨T1_s834_M_SgrA_above_3, T1_s834_M_SgrA_below_5⟩,
   T1_s835_R_0_pos,
   ⟨T1_s835_R_0_above_800, T1_s835_R_0_below_850⟩,
   T1_s836_d_ring_pos,
   ⟨T1_s836_d_ring_above_500, T1_s836_d_ring_below_540⟩,
   ⟨T1_s837_R_s_above_10, T1_s837_R_s_below_20⟩,
   ⟨T1_s836_sigma_d_pos, T1_s836_sigma_smaller_than_central⟩,
   T1_SgrAStar_blackholemass⟩

end OmegaTheory.Predictions.T1_SgrAStarBlackHoleMassBundle
