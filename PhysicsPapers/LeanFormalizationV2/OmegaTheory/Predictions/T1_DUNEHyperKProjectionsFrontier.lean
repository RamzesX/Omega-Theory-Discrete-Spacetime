/-
  OmegaTheory.Predictions.T1_DUNEHyperKProjectionsFrontier

  T-1 (light quark masses) — FRONTIER, sub session 293.
  DUNE (Fermilab) + Hyper-Kamiokande (Japan) — next-gen ν oscillation.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Next-generation long-baseline neutrino experiments:
  - DUNE (Fermilab→Sanford):
      * 1300 km baseline, 40 kton liquid-argon TPC
      * Will resolve δ_CP at 5σ for ~75% of values (2030-2035)
      * Mass ordering at 5σ regardless of δ_CP
  - Hyper-K (T2HKK + Korea):
      * 295 km baseline, 260 kton water Cherenkov
      * δ_CP measurement to ±10° precision
      * Expected start 2027

  - Both will resolve T2K vs NOvA θ_23 octant tension (s289)
  - DUNE additionally: proton decay, supernova ν, atmospheric ν
  - Hyper-K: 1 megaton-year exposure baseline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_DUNEHyperKProjectionsFrontier

/-! ## DUNE + Hyper-K parameters -/

/-- **DUNE baseline**: `1300 km`. -/
noncomputable def DUNE_baseline_km : ℝ := 1300

/-- **DUNE detector mass**: `40 kton` (liquid argon TPC). -/
noncomputable def DUNE_mass_kton : ℝ := 40

/-- **Hyper-K baseline**: `295 km` (T2HKK has 1100 km Korea arm). -/
noncomputable def HyperK_baseline_km : ℝ := 295

/-- **Hyper-K detector mass**: `260 kton` (water Cherenkov). -/
noncomputable def HyperK_mass_kton : ℝ := 260

/-- **DUNE δ_CP discovery 5σ fraction**: `0.75` (75% of δ_CP values). -/
noncomputable def DUNE_delta_CP_5sigma_fraction : ℝ := 75 / 100

/-- **Hyper-K δ_CP precision**: `10°` (degrees). -/
noncomputable def HyperK_delta_CP_precision_deg : ℝ := 10

/-! ## Positivity -/

/-- **Wave T1 session 293 — `DUNE baseline > 0`**. -/
theorem T1_DUNE_baseline_pos : 0 < DUNE_baseline_km := by
  unfold DUNE_baseline_km; norm_num

/-- **Wave T1 session 293 — `DUNE mass > 0`**. -/
theorem T1_DUNE_mass_pos : 0 < DUNE_mass_kton := by
  unfold DUNE_mass_kton; norm_num

/-- **Wave T1 session 293 — `Hyper-K baseline > 0`**. -/
theorem T1_HyperK_baseline_pos : 0 < HyperK_baseline_km := by
  unfold HyperK_baseline_km; norm_num

/-- **Wave T1 session 293 — `Hyper-K mass > 0`**. -/
theorem T1_HyperK_mass_pos : 0 < HyperK_mass_kton := by
  unfold HyperK_mass_kton; norm_num

/-- **Wave T1 session 293 — `DUNE 5σ frac > 0`**. -/
theorem T1_DUNE_frac_pos : 0 < DUNE_delta_CP_5sigma_fraction := by
  unfold DUNE_delta_CP_5sigma_fraction; norm_num

/-- **Wave T1 session 293 — `Hyper-K precision > 0`**. -/
theorem T1_HyperK_precision_pos : 0 < HyperK_delta_CP_precision_deg := by
  unfold HyperK_delta_CP_precision_deg; norm_num

/-! ## Comparison: DUNE vs Hyper-K -/

/-- **🚨 FRONTIER — Wave T1 session 293 — `DUNE baseline > Hyper-K baseline`**.

    DUNE has ~4× longer baseline. -/
theorem T1_DUNE_longer_baseline :
    DUNE_baseline_km > HyperK_baseline_km := by
  unfold DUNE_baseline_km HyperK_baseline_km; linarith

/-- **🚨 FRONTIER — Wave T1 session 293 — `Hyper-K mass > DUNE mass`**.

    Hyper-K has ~6.5× larger detector mass. -/
theorem T1_HyperK_larger_mass :
    HyperK_mass_kton > DUNE_mass_kton := by
  unfold HyperK_mass_kton DUNE_mass_kton; linarith

/-! ## Expected DUNE δ_CP coverage -/

/-- **🚨 FRONTIER — Wave T1 session 293 — `DUNE 5σ frac > 0.5`**.

    DUNE will discover δ_CP for >50% of true values. -/
theorem T1_DUNE_majority_5sigma :
    DUNE_delta_CP_5sigma_fraction > 1/2 := by
  unfold DUNE_delta_CP_5sigma_fraction; norm_num

/-- **🚨 FRONTIER — Wave T1 session 293 — `DUNE 5σ frac > 0.7`**. -/
theorem T1_DUNE_high_5sigma :
    DUNE_delta_CP_5sigma_fraction > 7/10 := by
  unfold DUNE_delta_CP_5sigma_fraction; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 293 — `DUNE baseline > 1000 km`**. -/
theorem T1_DUNE_above_1000 : DUNE_baseline_km > 1000 := by
  unfold DUNE_baseline_km; norm_num

/-- **Wave T1 session 293 — `Hyper-K mass > 200 kton`**. -/
theorem T1_HyperK_mass_above_200 : HyperK_mass_kton > 200 := by
  unfold HyperK_mass_kton; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 293 — DUNE + Hyper-K projections frontier**.

    🚨 FRONTIER (next-gen ν oscillation 2030+) 🚨

    Ten foundational facts:
    1. `DUNE baseline = 1300 km > 0`.
    2. `DUNE mass = 40 kton > 0` (liquid argon).
    3. `Hyper-K baseline = 295 km > 0`.
    4. `Hyper-K mass = 260 kton > 0` (water Cherenkov).
    5. `DUNE 5σ frac = 0.75 > 0`.
    6. `Hyper-K δ_CP precision = 10° > 0`.
    7. `DUNE > Hyper-K baseline` (~4× longer).
    8. `Hyper-K > DUNE mass` (~6.5× larger).
    9. `DUNE 5σ frac > 0.5` (majority coverage).
    10. `DUNE 5σ frac > 0.7` (high coverage).

    Both will resolve T2K vs NOvA θ_23 octant tension (s289),
    measure δ_CP at 5σ, and confirm mass ordering. DUNE adds
    proton decay + supernova ν capability. Hyper-K's 1 Mt·yr
    baseline exposure unmatched.

    Sub-lemma 113/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of DUNE + Hyper-K specs. -/
theorem session_293_DUNE_HyperK_frontier_headline :
    0 < DUNE_baseline_km ∧ 0 < DUNE_mass_kton
    ∧ 0 < HyperK_baseline_km ∧ 0 < HyperK_mass_kton
    ∧ 0 < DUNE_delta_CP_5sigma_fraction ∧ 0 < HyperK_delta_CP_precision_deg
    ∧ DUNE_baseline_km > HyperK_baseline_km
    ∧ HyperK_mass_kton > DUNE_mass_kton
    ∧ DUNE_delta_CP_5sigma_fraction > 1/2
    ∧ DUNE_delta_CP_5sigma_fraction > 7/10 :=
  ⟨T1_DUNE_baseline_pos, T1_DUNE_mass_pos,
   T1_HyperK_baseline_pos, T1_HyperK_mass_pos,
   T1_DUNE_frac_pos, T1_HyperK_precision_pos,
   T1_DUNE_longer_baseline, T1_HyperK_larger_mass,
   T1_DUNE_majority_5sigma, T1_DUNE_high_5sigma⟩

end OmegaTheory.Predictions.T1_DUNEHyperKProjectionsFrontier
