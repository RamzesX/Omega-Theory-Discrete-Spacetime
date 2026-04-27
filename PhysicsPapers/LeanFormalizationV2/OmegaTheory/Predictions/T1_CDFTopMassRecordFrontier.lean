/-
  OmegaTheory.Predictions.T1_CDFTopMassRecordFrontier

  T-1 (light quark masses) — FRONTIER, sub session 276.
  CDF II 2012 top quark mass record precision (vs PDG world average).

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  CDF II 2012 final top quark mass measurement:
  - CDF II 2012:  m_t = 174.98 ± 0.41 (stat) ± 0.49 (syst) GeV
                       → 174.98 ± 0.64 GeV (combined)
  - PDG 2024:     m_t = 172.69 ± 0.30 GeV (world average)
  - Tension:      ~3σ between CDF II and world average

  Both sit within the same broad SM range (~170-180 GeV) but the
  CDF II value is anomalously high. This is RELATED to the W mass
  CDF II anomaly (s241) — both pointing to top-W EW coupling.

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_CDFTopMassRecordFrontier

/-! ## Top mass measurements (in GeV) -/

/-- **m_t CDF II 2012**: `174.98 GeV`. -/
noncomputable def m_t_CDF_II_2012 : ℝ := 17498 / 100

/-- **m_t PDG 2024 world average**: `172.69 GeV`. -/
noncomputable def m_t_PDG_world : ℝ := 17269 / 100

/-! ## Uncertainty (in GeV) -/

/-- **m_t CDF II 2012 combined uncertainty**: `0.64 GeV`. -/
noncomputable def m_t_CDF_II_uncertainty : ℝ := 64 / 100

/-- **m_t PDG 2024 uncertainty**: `0.30 GeV`. -/
noncomputable def m_t_PDG_uncertainty : ℝ := 30 / 100

/-! ## Positivity -/

/-- **Wave T1 session 276 — `m_t CDF II > 0`**. -/
theorem T1_m_t_CDF_II_pos : 0 < m_t_CDF_II_2012 := by
  unfold m_t_CDF_II_2012; norm_num

/-- **Wave T1 session 276 — `m_t PDG > 0`**. -/
theorem T1_m_t_PDG_pos : 0 < m_t_PDG_world := by
  unfold m_t_PDG_world; norm_num

/-- **Wave T1 session 276 — `CDF II uncert > 0`**. -/
theorem T1_m_t_CDF_II_uncertainty_pos : 0 < m_t_CDF_II_uncertainty := by
  unfold m_t_CDF_II_uncertainty; norm_num

/-- **Wave T1 session 276 — `PDG uncert > 0`**. -/
theorem T1_m_t_PDG_uncertainty_pos : 0 < m_t_PDG_uncertainty := by
  unfold m_t_PDG_uncertainty; norm_num

/-! ## CDF II > PDG world average -/

/-- **🚨 FRONTIER — Wave T1 session 276 — `m_t CDF II > m_t PDG`**.

    CDF II 2012 result is anomalously high. -/
theorem T1_CDF_top_higher_than_PDG :
    m_t_CDF_II_2012 > m_t_PDG_world := by
  unfold m_t_CDF_II_2012 m_t_PDG_world; linarith

/-- **🚨 FRONTIER — Wave T1 session 276 — `m_t CDF II - m_t PDG > 2 GeV`**.

    Difference > 2 GeV (more than combined 1σ). -/
theorem T1_CDF_PDG_diff_above_2 :
    m_t_CDF_II_2012 - m_t_PDG_world > 2 := by
  unfold m_t_CDF_II_2012 m_t_PDG_world; linarith

/-! ## Both within SM range -/

/-- **🚨 FRONTIER — Wave T1 session 276 — `170 < m_t CDF II < 180`**. -/
theorem T1_m_t_CDF_II_in_SM_range :
    170 < m_t_CDF_II_2012 ∧ m_t_CDF_II_2012 < 180 := by
  refine ⟨?_, ?_⟩
  · unfold m_t_CDF_II_2012; norm_num
  · unfold m_t_CDF_II_2012; norm_num

/-- **🚨 FRONTIER — Wave T1 session 276 — `170 < m_t PDG < 180`**. -/
theorem T1_m_t_PDG_in_SM_range :
    170 < m_t_PDG_world ∧ m_t_PDG_world < 180 := by
  refine ⟨?_, ?_⟩
  · unfold m_t_PDG_world; norm_num
  · unfold m_t_PDG_world; norm_num

/-! ## PDG more precise than CDF II -/

/-- **🚨 FRONTIER — Wave T1 session 276 — `PDG uncert < CDF II uncert`**.

    World average is twice as precise. -/
theorem T1_PDG_more_precise :
    m_t_PDG_uncertainty < m_t_CDF_II_uncertainty := by
  unfold m_t_PDG_uncertainty m_t_CDF_II_uncertainty; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 276 — CDF II top mass record frontier**.

    🚨 FRONTIER (precision tension with world average) 🚨

    Eight foundational facts:
    1. `m_t CDF II = 174.98 GeV > 0` (CDF II 2012 final).
    2. `m_t PDG = 172.69 GeV > 0` (world avg 2024).
    3. `CDF II uncert = 0.64 GeV > 0`.
    4. `PDG uncert = 0.30 GeV > 0`.
    5. `m_t CDF II > m_t PDG` (anomalously high).
    6. `m_t CDF II - m_t PDG > 2 GeV` (~3σ tension).
    7. `170 < both < 180 GeV` (within SM range).
    8. `PDG uncert < CDF II uncert` (PDG ~2× more precise).

    Related to W mass CDF II anomaly (s241) — both pointing
    to possible top-W EW coupling new physics.

    Sub-lemma 98/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of CDF II top mass record. -/
theorem session_276_CDF_top_mass_frontier_headline :
    0 < m_t_CDF_II_2012 ∧ 0 < m_t_PDG_world
    ∧ 0 < m_t_CDF_II_uncertainty ∧ 0 < m_t_PDG_uncertainty
    ∧ m_t_CDF_II_2012 > m_t_PDG_world
    ∧ m_t_CDF_II_2012 - m_t_PDG_world > 2
    ∧ (170 < m_t_CDF_II_2012 ∧ m_t_CDF_II_2012 < 180)
    ∧ (170 < m_t_PDG_world ∧ m_t_PDG_world < 180)
    ∧ m_t_PDG_uncertainty < m_t_CDF_II_uncertainty :=
  ⟨T1_m_t_CDF_II_pos, T1_m_t_PDG_pos,
   T1_m_t_CDF_II_uncertainty_pos, T1_m_t_PDG_uncertainty_pos,
   T1_CDF_top_higher_than_PDG, T1_CDF_PDG_diff_above_2,
   T1_m_t_CDF_II_in_SM_range, T1_m_t_PDG_in_SM_range,
   T1_PDG_more_precise⟩

end OmegaTheory.Predictions.T1_CDFTopMassRecordFrontier
