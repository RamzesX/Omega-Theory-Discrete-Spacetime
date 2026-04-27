/-
  OmegaTheory.Predictions.T1_YukawaQuarkValues

  T-1 (light quark masses) — Phase 1 sub session 178.
  Yukawa values for up/down quarks per generation.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Numerical Yukawa values per generation, for the up-type and
  down-type quark chains:

      yukawaUpQuark   : (gen0, gen1, gen2) = (1, 3, 9)
      yukawaDownQuark : (gen0, gen1, gen2) = (1, 2, 5)

  These are the dimensionless substrate ratios used in T-1
  light-quark mass derivation.  Combined with `higgs_vev_substrate`
  (already established in V2, equal to PDG 246.22 GeV), they give
  the absolute Yukawa-derived masses up to a calibration constant.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Emergence.YukawaMatrix

namespace OmegaTheory.Predictions.T1_YukawaQuarkValues

open OmegaTheory.Emergence.YukawaMatrix

/-! ## yukawaUpQuark per generation -/

/-- **Wave T1 session 178 — `yukawaUpQuark gen0 = 1`** (up quark). -/
theorem T1_yukawaUpQuark_gen0 : yukawaUpQuark 0 = 1 := by
  unfold yukawaUpQuark; simp

/-- **Wave T1 session 178 — `yukawaUpQuark gen1 = 3`** (charm quark). -/
theorem T1_yukawaUpQuark_gen1 : yukawaUpQuark 1 = 3 := by
  unfold yukawaUpQuark; simp

/-- **Wave T1 session 178 — `yukawaUpQuark gen2 = 9`** (top quark). -/
theorem T1_yukawaUpQuark_gen2 : yukawaUpQuark 2 = 9 := by
  unfold yukawaUpQuark; simp

/-! ## yukawaDownQuark per generation -/

/-- **Wave T1 session 178 — `yukawaDownQuark gen0 = 1`** (down quark). -/
theorem T1_yukawaDownQuark_gen0 : yukawaDownQuark 0 = 1 := by
  unfold yukawaDownQuark; simp

/-- **Wave T1 session 178 — `yukawaDownQuark gen1 = 2`** (strange quark). -/
theorem T1_yukawaDownQuark_gen1 : yukawaDownQuark 1 = 2 := by
  unfold yukawaDownQuark; simp

/-- **Wave T1 session 178 — `yukawaDownQuark gen2 = 5`** (bottom quark). -/
theorem T1_yukawaDownQuark_gen2 : yukawaDownQuark 2 = 5 := by
  unfold yukawaDownQuark; simp

/-! ## Hierarchy at substrate level -/

/-- **Wave T1 session 178 — substrate up-quark hierarchy 1 < 3 < 9**. -/
theorem T1_yukawaUpQuark_hierarchy :
    yukawaUpQuark 0 < yukawaUpQuark 1 ∧ yukawaUpQuark 1 < yukawaUpQuark 2 := by
  rw [T1_yukawaUpQuark_gen0, T1_yukawaUpQuark_gen1, T1_yukawaUpQuark_gen2]
  refine ⟨?_, ?_⟩ <;> norm_num

/-- **Wave T1 session 178 — substrate down-quark hierarchy 1 < 2 < 5**. -/
theorem T1_yukawaDownQuark_hierarchy :
    yukawaDownQuark 0 < yukawaDownQuark 1 ∧ yukawaDownQuark 1 < yukawaDownQuark 2 := by
  rw [T1_yukawaDownQuark_gen0, T1_yukawaDownQuark_gen1, T1_yukawaDownQuark_gen2]
  refine ⟨?_, ?_⟩ <;> norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 178 — Yukawa quark values per generation**.

    Six exact dimensionless values:
    - up-type:   y_u = 1, y_c = 3, y_t = 9
    - down-type: y_d = 1, y_s = 2, y_b = 5

    Plus the strict hierarchy in each chain.

    These are the substrate's own predictions for Yukawa hierarchy
    (RATIOS, not absolute coupling constants).  Combined with
    `higgs_vev_substrate` give absolute masses up to one calibration
    constant (which sets y_u in physical units).

    Sub-lemma 3/N in T-1.  Lean-core only. -/
theorem session_178_yukawa_quark_values_headline :
    -- (1) Up-type values
    (yukawaUpQuark 0 = 1 ∧ yukawaUpQuark 1 = 3 ∧ yukawaUpQuark 2 = 9)
    -- (2) Down-type values
    ∧ (yukawaDownQuark 0 = 1 ∧ yukawaDownQuark 1 = 2 ∧ yukawaDownQuark 2 = 5)
    -- (3) Strict hierarchies
    ∧ (yukawaUpQuark 0 < yukawaUpQuark 1 ∧ yukawaUpQuark 1 < yukawaUpQuark 2)
    ∧ (yukawaDownQuark 0 < yukawaDownQuark 1 ∧ yukawaDownQuark 1 < yukawaDownQuark 2) :=
  ⟨⟨T1_yukawaUpQuark_gen0, T1_yukawaUpQuark_gen1, T1_yukawaUpQuark_gen2⟩,
   ⟨T1_yukawaDownQuark_gen0, T1_yukawaDownQuark_gen1, T1_yukawaDownQuark_gen2⟩,
   T1_yukawaUpQuark_hierarchy,
   T1_yukawaDownQuark_hierarchy⟩

end OmegaTheory.Predictions.T1_YukawaQuarkValues
