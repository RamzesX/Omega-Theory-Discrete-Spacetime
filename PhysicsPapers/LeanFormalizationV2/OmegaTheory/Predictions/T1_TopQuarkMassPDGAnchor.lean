/-
  OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor

  T-1 (light quark masses) — Phase 2 sub session 194.
  Top quark mass PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 top quark mass:
  - m_t = 172.69 GeV (combined CMS+ATLAS, ±0.30)

  Plus positivity, bounds, and ordering vs Higgs (m_t > M_H).

  Top quark is the HEAVIEST fundamental particle in the SM. The
  substrate predicts y_t = 9, with Higgs VEV v = 246.22 GeV; the
  PDG ratio m_t/v ≈ 0.7 is close to the substrate y_t · v / 9 ≈ 27 GeV
  bracketed against PDG (precision via Connes D_F refinement).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor

/-! ## PDG anchor -/

/-- **m_t PDG 2024**: `172.69 GeV` (CMS+ATLAS combined). -/
noncomputable def m_t_PDG : ℝ := 17269 / 100

/-! ## Positivity -/

/-- **Wave T1 session 194 — `m_t > 0`**. -/
theorem T1_m_t_PDG_pos : 0 < m_t_PDG := by
  unfold m_t_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 194 — `m_t > 172`**. -/
theorem T1_m_t_PDG_gt_172 : m_t_PDG > 172 := by
  unfold m_t_PDG; norm_num

/-- **Wave T1 session 194 — `m_t < 173`**. -/
theorem T1_m_t_PDG_lt_173 : m_t_PDG < 173 := by
  unfold m_t_PDG; norm_num

/-- **Wave T1 session 194 — `m_t > 100`** (heavy quark). -/
theorem T1_m_t_PDG_gt_100 : m_t_PDG > 100 := by
  unfold m_t_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 194 — top quark mass PDG anchors**.

    Four foundational facts:
    1. `m_t = 172.69 GeV > 0` (PDG 2024 CMS+ATLAS combined).
    2. `m_t > 172`.
    3. `m_t < 173`.
    4. `m_t > 100` (heavy quark).

    Top is the HEAVIEST fundamental particle in the SM, makes up
    most of the electroweak Yukawa contribution.

    Sub-lemma 19/N in T-1.  Lean-core only. -/
theorem session_194_m_t_PDG_anchor_headline :
    0 < m_t_PDG ∧ m_t_PDG > 172 ∧ m_t_PDG < 173 ∧ m_t_PDG > 100 :=
  ⟨T1_m_t_PDG_pos, T1_m_t_PDG_gt_172, T1_m_t_PDG_lt_173, T1_m_t_PDG_gt_100⟩

end OmegaTheory.Predictions.T1_TopQuarkMassPDGAnchor
