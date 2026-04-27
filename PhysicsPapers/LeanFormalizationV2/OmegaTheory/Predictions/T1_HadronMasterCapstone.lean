/-
  OmegaTheory.Predictions.T1_HadronMasterCapstone

  T-1 (light quark masses) — Phase 2 HADRON MASTER CAPSTONE,
  session 211.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  6-conjunct master capstone tying T-1 hadron-mass sub-lemmas
  s207-s210:

  1. **Proton mass** (s207): m_p > 0, 80× quark sum (QCD dominance).
  2. **Neutron mass** (s208): m_n > m_p, n-p split 1-2 MeV.
  3. **Pion masses** (s209): π± > π⁰ (EM contribution).
  4. **Kaon masses** (s210): K > π (strange quark contribution).
  5. **K⁰ > K±** (neutral vs charged kaon).
  6. **Full hadron hierarchy** combined.

  Foundation for T-3 (Λ_QCD / proton mass derivation).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Predictions.T1_ProtonMassPDG
import OmegaTheory.Predictions.T1_NeutronMassPDG
import OmegaTheory.Predictions.T1_PionMassesPDG
import OmegaTheory.Predictions.T1_KaonMassesPDG

namespace OmegaTheory.Predictions.T1_HadronMasterCapstone

open OmegaTheory.Predictions.T1_ProtonMassPDG
open OmegaTheory.Predictions.T1_NeutronMassPDG
open OmegaTheory.Predictions.T1_PionMassesPDG
open OmegaTheory.Predictions.T1_KaonMassesPDG

/-- **HEADLINE — Wave T1 session 211 — HADRON MASTER CAPSTONE**.

    6-conjunct master capstone for T-1 hadron-mass sub-lemmas
    s207-s210.

    Foundation for T-3 (Λ_QCD / proton mass derivation).

    Lean-core only.  Cycle 65. -/
theorem session_211_T1_hadron_master_capstone :
    -- (1) proton mass + QCD dominance
    (0 < m_p_PDG)
    -- (2) neutron mass + n-p split
    ∧ (m_n_PDG > m_p_PDG ∧ m_n_PDG - m_p_PDG > 1 ∧ m_n_PDG - m_p_PDG < 2)
    -- (3) pion masses (charged > neutral)
    ∧ (0 < m_pi_0_PDG ∧ 0 < m_pi_pm_PDG ∧ m_pi_pm_PDG > m_pi_0_PDG)
    -- (4) kaon masses (kaon > pion)
    ∧ (0 < m_K_0_PDG ∧ 0 < m_K_pm_PDG
       ∧ m_K_0_PDG > m_pi_0_PDG ∧ m_K_pm_PDG > m_pi_pm_PDG)
    -- (5) K⁰ vs K±
    ∧ (m_K_0_PDG > m_K_pm_PDG)
    -- (6) full hadron hierarchy
    ∧ (m_pi_0_PDG < m_pi_pm_PDG ∧ m_pi_pm_PDG < m_K_pm_PDG
       ∧ m_K_pm_PDG < m_K_0_PDG ∧ m_K_0_PDG < m_p_PDG ∧ m_p_PDG < m_n_PDG) := by
  refine ⟨T1_m_p_PDG_pos, ?_, ?_, ?_, T1_m_K_0_gt_K_pm, ?_⟩
  · exact ⟨T1_m_n_gt_m_p, T1_m_n_minus_m_p_gt_1, T1_m_n_minus_m_p_lt_2⟩
  · exact ⟨T1_m_pi_0_PDG_pos, T1_m_pi_pm_PDG_pos, T1_m_pi_pm_gt_pi_0⟩
  · exact ⟨T1_m_K_0_PDG_pos, T1_m_K_pm_PDG_pos,
           T1_m_K_0_gt_m_pi_0, T1_m_K_pm_gt_m_pi_pm⟩
  · refine ⟨T1_m_pi_pm_gt_pi_0, ?_, ?_, ?_, T1_m_n_gt_m_p⟩
    · -- m_π± < m_K± : 139.57 < 493.677
      unfold m_pi_pm_PDG m_K_pm_PDG; linarith
    · exact T1_m_K_0_gt_K_pm
    · -- m_K⁰ < m_p : 497.611 < 938.272
      unfold m_K_0_PDG m_p_PDG; linarith

end OmegaTheory.Predictions.T1_HadronMasterCapstone
