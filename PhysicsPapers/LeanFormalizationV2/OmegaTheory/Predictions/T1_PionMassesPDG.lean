/-
  OmegaTheory.Predictions.T1_PionMassesPDG

  T-1 (light quark masses) — Phase 2 sub session 209.
  Pion masses PDG anchors.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 pion masses:
  - m_π⁰ = 134.977 MeV (neutral pion)
  - m_π± = 139.570 MeV (charged pion)

  Plus structural facts: charged π heavier than neutral π (EM contribution).

  Pions are pseudo-Goldstone bosons of chiral symmetry breaking
  (chiral SU(2)_L × SU(2)_R / SU(2)_V). Their masses relate to quark
  masses via Gell-Mann–Oakes–Renner relation.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_PionMassesPDG

/-! ## PDG anchors -/

/-- **m_π⁰ PDG 2024**: `134.977 MeV` (neutral pion). -/
noncomputable def m_pi_0_PDG : ℝ := 134977 / 1000

/-- **m_π± PDG 2024**: `139.570 MeV` (charged pion). -/
noncomputable def m_pi_pm_PDG : ℝ := 13957 / 100

/-! ## Positivity -/

/-- **Wave T1 session 209 — `m_π⁰ > 0`**. -/
theorem T1_m_pi_0_PDG_pos : 0 < m_pi_0_PDG := by
  unfold m_pi_0_PDG; norm_num

/-- **Wave T1 session 209 — `m_π± > 0`**. -/
theorem T1_m_pi_pm_PDG_pos : 0 < m_pi_pm_PDG := by
  unfold m_pi_pm_PDG; norm_num

/-! ## π± vs π⁰ -/

/-- **Wave T1 session 209 — `m_π± > m_π⁰`** (charged heavier than neutral).

    EM contribution makes charged pion ~5 MeV heavier. -/
theorem T1_m_pi_pm_gt_pi_0 : m_pi_pm_PDG > m_pi_0_PDG := by
  unfold m_pi_pm_PDG m_pi_0_PDG; linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 209 — `m_π⁰ > 134`**. -/
theorem T1_m_pi_0_PDG_gt_134 : m_pi_0_PDG > 134 := by
  unfold m_pi_0_PDG; norm_num

/-- **Wave T1 session 209 — `m_π⁰ < 135`**. -/
theorem T1_m_pi_0_PDG_lt_135 : m_pi_0_PDG < 135 := by
  unfold m_pi_0_PDG; norm_num

/-- **Wave T1 session 209 — `m_π± > 139`**. -/
theorem T1_m_pi_pm_PDG_gt_139 : m_pi_pm_PDG > 139 := by
  unfold m_pi_pm_PDG; norm_num

/-- **Wave T1 session 209 — `m_π± < 140`**. -/
theorem T1_m_pi_pm_PDG_lt_140 : m_pi_pm_PDG < 140 := by
  unfold m_pi_pm_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 209 — pion masses PDG anchors**.

    Five foundational facts:
    1. `m_π⁰ = 134.977 MeV > 0`.
    2. `m_π± = 139.570 MeV > 0`.
    3. `m_π± > m_π⁰` (EM contribution to charged).
    4. `134 < m_π⁰ < 135`.
    5. `139 < m_π± < 140`.

    Pions are pseudo-Goldstone bosons of chiral symmetry breaking.
    Gell-Mann–Oakes–Renner: m_π² ∝ (m_u + m_d) · |⟨q̄q⟩| / f_π².

    Sub-lemma 34/N in T-1.  Lean-core only. -/
theorem session_209_pion_masses_PDG_anchors_headline :
    0 < m_pi_0_PDG ∧ 0 < m_pi_pm_PDG
    ∧ m_pi_pm_PDG > m_pi_0_PDG
    ∧ m_pi_0_PDG > 134 ∧ m_pi_0_PDG < 135
    ∧ m_pi_pm_PDG > 139 ∧ m_pi_pm_PDG < 140 :=
  ⟨T1_m_pi_0_PDG_pos, T1_m_pi_pm_PDG_pos, T1_m_pi_pm_gt_pi_0,
   T1_m_pi_0_PDG_gt_134, T1_m_pi_0_PDG_lt_135,
   T1_m_pi_pm_PDG_gt_139, T1_m_pi_pm_PDG_lt_140⟩

end OmegaTheory.Predictions.T1_PionMassesPDG
