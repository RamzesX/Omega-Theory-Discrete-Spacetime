/-
  OmegaTheory.Predictions.T1_PDGRatioBoundsQuarks

  T-1 (light quark masses) — Phase 2 sub session 212.
  PDG quark mass ratio bounds.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Quark mass ratios from PDG anchors:

      m_b / m_c > 3 (PDG ≈ 3.28)
      m_c / m_s > 13 (PDG ≈ 13.6)
      m_s / m_d > 19 (PDG ≈ 20)
      m_t / m_b > 40 (PDG ≈ 41.3)

  These ratios characterize the SM mass hierarchy.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.LightQuarkPDGAnchors
import OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor

namespace OmegaTheory.Predictions.T1_PDGRatioBoundsQuarks

open OmegaTheory.Predictions.LightQuarkPDGAnchors
open OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor

/-! ## PDG quark mass ratios -/

/-- **Wave T1 session 212 — `m_b / m_c > 3`** (PDG ≈ 3.28). -/
theorem T1_m_b_over_m_c_gt_3 : m_b_PDG / m_c_PDG > 3 := by
  unfold m_b_PDG m_c_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (1273 : ℝ) > 0)]
  linarith

/-- **Wave T1 session 212 — `m_c / m_s > 13`** (PDG ≈ 13.6). -/
theorem T1_m_c_over_m_s_gt_13 : m_c_PDG / m_s_PDG > 13 := by
  unfold m_c_PDG m_s_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (934 : ℝ) / 10 > 0)]
  linarith

/-- **Wave T1 session 212 — `m_s / m_d > 19`** (PDG ≈ 20). -/
theorem T1_m_s_over_m_d_gt_19 : m_s_PDG / m_d_PDG > 19 := by
  unfold m_s_PDG m_d_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (467 : ℝ) / 100 > 0)]
  linarith

/-- **Wave T1 session 212 — `m_t / m_b > 40`** (PDG ≈ 41.3 GeV/GeV).

    Note: m_t in GeV, m_b in MeV; convert m_b to GeV: 4.18 GeV.
    m_t/m_b = 172.69/4.18 ≈ 41.3. We use both in MeV in our anchors,
    so m_t in MeV = 172690, m_b = 4180. 172690/4180 ≈ 41.3. -/
theorem T1_m_t_over_m_b_gt_40 : (1000 * m_t_PDG) / m_b_PDG > 40 := by
  unfold m_t_PDG m_b_PDG
  rw [gt_iff_lt, lt_div_iff₀ (by norm_num : (4180 : ℝ) > 0)]
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 212 — quark mass ratio PDG bounds**.

    Four foundational PDG mass ratio bounds:
    1. `m_b / m_c > 3` (bottom/charm).
    2. `m_c / m_s > 13` (charm/strange).
    3. `m_s / m_d > 19` (strange/down).
    4. `1000·m_t / m_b > 40` (top in GeV / bottom in MeV).

    These ratios characterize the SM quark mass hierarchy. Substrate
    Yukawa hierarchy (s179) gives 5/3 / 3/3 / 2/1 / 9/5 — much smaller
    than PDG due to QCD running.

    Sub-lemma 37/N in T-1.  Lean-core only. -/
theorem session_212_PDG_ratio_bounds_quarks_headline :
    m_b_PDG / m_c_PDG > 3
    ∧ m_c_PDG / m_s_PDG > 13
    ∧ m_s_PDG / m_d_PDG > 19
    ∧ (1000 * m_t_PDG) / m_b_PDG > 40 :=
  ⟨T1_m_b_over_m_c_gt_3, T1_m_c_over_m_s_gt_13,
   T1_m_s_over_m_d_gt_19, T1_m_t_over_m_b_gt_40⟩

end OmegaTheory.Predictions.T1_PDGRatioBoundsQuarks
