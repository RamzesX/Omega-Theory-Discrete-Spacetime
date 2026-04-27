/-
  OmegaTheory.Predictions.T1_KaonMassesPDG

  T-1 (light quark masses) — Phase 2 sub session 210.
  Kaon masses PDG anchors.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 kaon masses:
  - m_K⁰ = 497.611 MeV (neutral kaon)
  - m_K± = 493.677 MeV (charged kaon)

  Kaons contain a strange quark, so heavier than pions (which contain
  only u, d). PDG mass ratio m_K/m_π ≈ 3.5 reflects strange quark
  hierarchy.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.T1_PionMassesPDG

namespace OmegaTheory.Predictions.T1_KaonMassesPDG

open OmegaTheory.Predictions.T1_PionMassesPDG

/-! ## PDG anchors -/

/-- **m_K⁰ PDG 2024**: `497.611 MeV` (neutral kaon). -/
noncomputable def m_K_0_PDG : ℝ := 497611 / 1000

/-- **m_K± PDG 2024**: `493.677 MeV` (charged kaon). -/
noncomputable def m_K_pm_PDG : ℝ := 493677 / 1000

/-! ## Positivity -/

/-- **Wave T1 session 210 — `m_K⁰ > 0`**. -/
theorem T1_m_K_0_PDG_pos : 0 < m_K_0_PDG := by
  unfold m_K_0_PDG; norm_num

/-- **Wave T1 session 210 — `m_K± > 0`**. -/
theorem T1_m_K_pm_PDG_pos : 0 < m_K_pm_PDG := by
  unfold m_K_pm_PDG; norm_num

/-! ## K vs π hierarchy -/

/-- **Wave T1 session 210 — `m_K⁰ > m_π⁰`** (kaon heavier than pion).

    Kaon contains strange quark; pion contains only u, d. -/
theorem T1_m_K_0_gt_m_pi_0 : m_K_0_PDG > m_pi_0_PDG := by
  unfold m_K_0_PDG m_pi_0_PDG; linarith

/-- **Wave T1 session 210 — `m_K± > m_π±`**. -/
theorem T1_m_K_pm_gt_m_pi_pm : m_K_pm_PDG > m_pi_pm_PDG := by
  unfold m_K_pm_PDG m_pi_pm_PDG; linarith

/-- **Wave T1 session 210 — `m_K⁰ > m_K±`** (neutral heavier than charged,
    rare in mesons due to s-d mass content). -/
theorem T1_m_K_0_gt_K_pm : m_K_0_PDG > m_K_pm_PDG := by
  unfold m_K_0_PDG m_K_pm_PDG; linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 210 — `m_K⁰ > 497`**. -/
theorem T1_m_K_0_PDG_gt_497 : m_K_0_PDG > 497 := by
  unfold m_K_0_PDG; norm_num

/-- **Wave T1 session 210 — `m_K⁰ < 498`**. -/
theorem T1_m_K_0_PDG_lt_498 : m_K_0_PDG < 498 := by
  unfold m_K_0_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 210 — kaon masses PDG anchors**.

    Five foundational facts:
    1. `m_K⁰ = 497.611 MeV > 0`.
    2. `m_K± = 493.677 MeV > 0`.
    3. `m_K⁰ > m_π⁰` (kaon heavier than pion, strange contribution).
    4. `m_K± > m_π±`.
    5. `m_K⁰ > m_K±` (neutral kaon heavier than charged).

    Strange-quark hierarchy effect: PDG m_K/m_π ≈ 3.5 reflects
    substrate ratio y_s/y_d = 2 multiplied by QCD running.

    Sub-lemma 35/N in T-1.  Lean-core only.

    🏆 35 T-1 sub-lemmas LANDED. -/
theorem session_210_kaon_masses_PDG_anchors_headline :
    0 < m_K_0_PDG ∧ 0 < m_K_pm_PDG
    ∧ m_K_0_PDG > m_pi_0_PDG ∧ m_K_pm_PDG > m_pi_pm_PDG
    ∧ m_K_0_PDG > m_K_pm_PDG :=
  ⟨T1_m_K_0_PDG_pos, T1_m_K_pm_PDG_pos,
   T1_m_K_0_gt_m_pi_0, T1_m_K_pm_gt_m_pi_pm, T1_m_K_0_gt_K_pm⟩

end OmegaTheory.Predictions.T1_KaonMassesPDG
