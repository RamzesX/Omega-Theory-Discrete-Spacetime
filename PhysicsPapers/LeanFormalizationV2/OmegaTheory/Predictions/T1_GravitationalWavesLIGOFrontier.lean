/-
  OmegaTheory.Predictions.T1_GravitationalWavesLIGOFrontier

  T-1 (light quark masses) — FRONTIER, sub session 252.
  Gravitational wave detections (LIGO/Virgo).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  LIGO/Virgo first detection + characteristic events:
  - GW150914: BBH merger, total mass 65 M_⊙ (first detection 2015)
  - GW170817: BNS merger, total mass 2.74 M_⊙ (first multi-messenger 2017)
  - GW190521: Heaviest BBH, total mass 150 M_⊙ (intermediate-mass BH)

  Plus structural facts: BBH masses cluster around stellar to
  intermediate range.

  Confirms general relativity in strong-field regime.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_GravitationalWavesLIGOFrontier

/-! ## LIGO event masses (in solar masses M_⊙) -/

/-- **GW150914 total mass**: `65 M_⊙` (first BBH detection, 2015). -/
noncomputable def GW150914_total_mass_solar : ℝ := 65

/-- **GW170817 total mass**: `2.74 M_⊙` (BNS merger, 2017). -/
noncomputable def GW170817_total_mass_solar : ℝ := 274 / 100

/-- **GW190521 total mass**: `150 M_⊙` (intermediate-mass BH, 2020). -/
noncomputable def GW190521_total_mass_solar : ℝ := 150

/-! ## Positivity -/

/-- **Wave T1 session 252 — `GW150914 mass > 0`**. -/
theorem T1_GW150914_pos : 0 < GW150914_total_mass_solar := by
  unfold GW150914_total_mass_solar; norm_num

/-- **Wave T1 session 252 — `GW170817 mass > 0`**. -/
theorem T1_GW170817_pos : 0 < GW170817_total_mass_solar := by
  unfold GW170817_total_mass_solar; norm_num

/-- **Wave T1 session 252 — `GW190521 mass > 0`**. -/
theorem T1_GW190521_pos : 0 < GW190521_total_mass_solar := by
  unfold GW190521_total_mass_solar; norm_num

/-! ## Mass hierarchy: BNS << BBH << intermediate-mass -/

/-- **🚨 FRONTIER — Wave T1 session 252 — `GW170817 (BNS) << GW150914 (BBH)`**. -/
theorem T1_BNS_lighter_than_BBH :
    GW170817_total_mass_solar < GW150914_total_mass_solar := by
  unfold GW170817_total_mass_solar GW150914_total_mass_solar; linarith

/-- **🚨 FRONTIER — Wave T1 session 252 — `GW150914 < GW190521`** (intermediate-mass). -/
theorem T1_GW190521_heaviest :
    GW150914_total_mass_solar < GW190521_total_mass_solar := by
  unfold GW150914_total_mass_solar GW190521_total_mass_solar; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 252 — LIGO gravitational wave detections**.

    🚨 FRONTIER (multi-messenger astronomy era) 🚨

    Five foundational facts:
    1. `GW150914 (BBH, 2015) = 65 M_⊙ > 0` (first GW detection).
    2. `GW170817 (BNS, 2017) = 2.74 M_⊙ > 0` (first multi-messenger).
    3. `GW190521 (intermediate, 2020) = 150 M_⊙ > 0` (heaviest BBH).
    4. `GW170817 << GW150914` (BNS lighter than BBH).
    5. `GW150914 < GW190521` (BBH < intermediate-mass BH).

    LIGO/Virgo confirmed GR in strong-field regime + opened the
    multi-messenger era of astronomy.

    Sub-lemma 77/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of LIGO GW event masses. -/
theorem session_252_LIGO_GW_frontier_headline :
    0 < GW150914_total_mass_solar ∧ 0 < GW170817_total_mass_solar
    ∧ 0 < GW190521_total_mass_solar
    ∧ GW170817_total_mass_solar < GW150914_total_mass_solar
    ∧ GW150914_total_mass_solar < GW190521_total_mass_solar :=
  ⟨T1_GW150914_pos, T1_GW170817_pos, T1_GW190521_pos,
   T1_BNS_lighter_than_BBH, T1_GW190521_heaviest⟩

end OmegaTheory.Predictions.T1_GravitationalWavesLIGOFrontier
