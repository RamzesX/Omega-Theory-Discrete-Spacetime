/-
  OmegaTheory.Predictions.T1_ProtonMassPDG

  T-1 (light quark masses) — Phase 2 sub session 207.
  Proton mass PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 proton mass:
  - m_p = 938.272 MeV (CODATA, ±0.000058)

  Plus positivity + bounds + relation to quark masses.

  Foundational for OV2 hadron-mass calibration (T-3 Λ_QCD target).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.LightQuarkPDGAnchors

namespace OmegaTheory.Predictions.T1_ProtonMassPDG

open OmegaTheory.Predictions.LightQuarkPDGAnchors

/-! ## PDG anchor -/

/-- **m_p PDG 2024**: `938.272 MeV` (proton mass, CODATA). -/
noncomputable def m_p_PDG : ℝ := 938272 / 1000

/-! ## Positivity -/

/-- **Wave T1 session 207 — `m_p > 0`**. -/
theorem T1_m_p_PDG_pos : 0 < m_p_PDG := by
  unfold m_p_PDG; norm_num

/-! ## Sanity bounds -/

/-- **Wave T1 session 207 — `m_p > 938`**. -/
theorem T1_m_p_PDG_gt_938 : m_p_PDG > 938 := by
  unfold m_p_PDG; norm_num

/-- **Wave T1 session 207 — `m_p < 939`**. -/
theorem T1_m_p_PDG_lt_939 : m_p_PDG < 939 := by
  unfold m_p_PDG; norm_num

/-! ## Hadron-quark mass relation -/

/-- **Wave T1 session 207 — `m_p > m_u + m_d + m_d`** (proton heavier
    than its naive valence quark sum). -/
theorem T1_m_p_gt_uud_sum : m_p_PDG > m_u_PDG + m_d_PDG + m_d_PDG := by
  unfold m_p_PDG m_u_PDG m_d_PDG; linarith

/-- **Wave T1 session 207 — `m_p > 80 × (m_u + m_d + m_d)`** (proton
    mass is dominated by QCD binding energy, not valence quark masses;
    actual ratio ≈ 81.5×). -/
theorem T1_m_p_dominated_by_QCD :
    m_p_PDG > 80 * (m_u_PDG + m_d_PDG + m_d_PDG) := by
  unfold m_p_PDG m_u_PDG m_d_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 207 — proton mass PDG anchor**.

    Five foundational facts:
    1. `m_p = 938.272 MeV > 0`.
    2. `938 < m_p < 939`.
    3. `m_p > m_u + m_d + m_d` (proton heavier than valence sum).
    4. `m_p > 80 × (m_u + m_d + m_d)` (QCD binding dominates,
       actual ratio ≈ 81.5×).

    OV2's T-3 (Λ_QCD) target derives the proton mass from substrate
    truncation δ_comp + 1-loop QCD running.

    Sub-lemma 32/N in T-1.  Lean-core only. -/
theorem session_207_m_p_PDG_anchor_headline :
    0 < m_p_PDG
    ∧ m_p_PDG > 938 ∧ m_p_PDG < 939
    ∧ m_p_PDG > m_u_PDG + m_d_PDG + m_d_PDG
    ∧ m_p_PDG > 80 * (m_u_PDG + m_d_PDG + m_d_PDG) :=
  ⟨T1_m_p_PDG_pos, T1_m_p_PDG_gt_938, T1_m_p_PDG_lt_939,
   T1_m_p_gt_uud_sum, T1_m_p_dominated_by_QCD⟩

end OmegaTheory.Predictions.T1_ProtonMassPDG
