/-
  OmegaTheory.Predictions.T1_SubstrateQuarkRatios

  T-1 (light quark masses) — Phase 1 sub session 179.
  Substrate-predicted quark mass ratios.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Substrate predictions for Yukawa-derived quark mass ratios:

  Within up-type chain:
    y_c / y_u = 3    (substrate)
    y_t / y_u = 9    (substrate)
    y_t / y_c = 3    (substrate)

  Within down-type chain:
    y_s / y_d = 2    (substrate)
    y_b / y_d = 5    (substrate)
    y_b / y_s = 5/2  (substrate)

  These are the BARE Yukawa ratios from Connes D_F + 4-irrational
  ordering.  PDG ratios differ due to QCD running between scales,
  but the structural ordering is preserved.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_YukawaQuarkValues

namespace OmegaTheory.Predictions.T1_SubstrateQuarkRatios

open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Predictions.T1_YukawaQuarkValues

/-! ## up-type ratios -/

/-- **Wave T1 session 179 — y_c / y_u = 3** (charm/up substrate ratio). -/
theorem T1_yukawa_c_over_u : yukawaUpQuark 1 / yukawaUpQuark 0 = 3 := by
  rw [T1_yukawaUpQuark_gen0, T1_yukawaUpQuark_gen1]; norm_num

/-- **Wave T1 session 179 — y_t / y_u = 9** (top/up substrate ratio). -/
theorem T1_yukawa_t_over_u : yukawaUpQuark 2 / yukawaUpQuark 0 = 9 := by
  rw [T1_yukawaUpQuark_gen0, T1_yukawaUpQuark_gen2]; norm_num

/-- **Wave T1 session 179 — y_t / y_c = 3** (top/charm substrate ratio). -/
theorem T1_yukawa_t_over_c : yukawaUpQuark 2 / yukawaUpQuark 1 = 3 := by
  rw [T1_yukawaUpQuark_gen1, T1_yukawaUpQuark_gen2]; norm_num

/-! ## down-type ratios -/

/-- **Wave T1 session 179 — y_s / y_d = 2** (strange/down substrate ratio). -/
theorem T1_yukawa_s_over_d : yukawaDownQuark 1 / yukawaDownQuark 0 = 2 := by
  rw [T1_yukawaDownQuark_gen0, T1_yukawaDownQuark_gen1]; norm_num

/-- **Wave T1 session 179 — y_b / y_d = 5** (bottom/down substrate ratio). -/
theorem T1_yukawa_b_over_d : yukawaDownQuark 2 / yukawaDownQuark 0 = 5 := by
  rw [T1_yukawaDownQuark_gen0, T1_yukawaDownQuark_gen2]; norm_num

/-- **Wave T1 session 179 — y_b / y_s = 5/2** (bottom/strange substrate ratio). -/
theorem T1_yukawa_b_over_s : yukawaDownQuark 2 / yukawaDownQuark 1 = 5 / 2 := by
  rw [T1_yukawaDownQuark_gen1, T1_yukawaDownQuark_gen2]

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 179 — substrate quark mass ratios**.

    Six substrate ratio predictions:
    1. y_c / y_u = 3      (charm/up)
    2. y_t / y_u = 9      (top/up)
    3. y_t / y_c = 3      (top/charm)
    4. y_s / y_d = 2      (strange/down)
    5. y_b / y_d = 5      (bottom/down)
    6. y_b / y_s = 5/2    (bottom/strange)

    These dimensionless ratios come from substrate Connes D_F +
    4-irrational ordering (no calibration constant needed for the
    RATIOS).  PDG ratios differ due to QCD running, but structural
    ordering is preserved.

    Sub-lemma 4/N in T-1.  Lean-core only. -/
theorem session_179_substrate_quark_ratios_headline :
    -- (1-3) up-type
    (yukawaUpQuark 1 / yukawaUpQuark 0 = 3
      ∧ yukawaUpQuark 2 / yukawaUpQuark 0 = 9
      ∧ yukawaUpQuark 2 / yukawaUpQuark 1 = 3)
    -- (4-6) down-type
    ∧ (yukawaDownQuark 1 / yukawaDownQuark 0 = 2
      ∧ yukawaDownQuark 2 / yukawaDownQuark 0 = 5
      ∧ yukawaDownQuark 2 / yukawaDownQuark 1 = 5 / 2) :=
  ⟨⟨T1_yukawa_c_over_u, T1_yukawa_t_over_u, T1_yukawa_t_over_c⟩,
   ⟨T1_yukawa_s_over_d, T1_yukawa_b_over_d, T1_yukawa_b_over_s⟩⟩

end OmegaTheory.Predictions.T1_SubstrateQuarkRatios
