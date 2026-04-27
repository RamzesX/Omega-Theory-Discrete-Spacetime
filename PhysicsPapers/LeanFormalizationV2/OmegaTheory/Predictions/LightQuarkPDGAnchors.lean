/-
  OmegaTheory.Predictions.LightQuarkPDGAnchors

  T-1 (light quark masses) — Phase 1 sub session 177.
  PDG 2024 anchor values for m_u, m_d, m_s, m_c, m_b.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG anchor constants (in MeV) for the five light quark masses,
  as defined in the substrate framework.  These serve as the
  comparison targets for the substrate-derived masses (T-1 final).

  PDG 2024 values (MS-bar at μ = 2 GeV for light, m_q(m_q) for heavy):
  - m_u = 2.16 MeV (PDG ±0.49)
  - m_d = 4.67 MeV (PDG ±0.48)
  - m_s = 93.4 MeV (PDG ±8.6)
  - m_c = 1273 MeV (m_c(m_c), PDG ±5)
  - m_b = 4180 MeV (m_b(m_b), PDG ±70)

  Each is exposed as a `noncomputable def` (positive-real opaque
  bundle) — Lean-core only, no `axiom` keyword.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.LightQuarkPDGAnchors

/-! ## PDG 2024 anchor values (in MeV) -/

/-- **Up quark PDG anchor**: `m_u = 2.16 MeV` (MS-bar, μ = 2 GeV). -/
noncomputable def m_u_PDG : ℝ := 216 / 100

/-- **Down quark PDG anchor**: `m_d = 4.67 MeV` (MS-bar, μ = 2 GeV). -/
noncomputable def m_d_PDG : ℝ := 467 / 100

/-- **Strange quark PDG anchor**: `m_s = 93.4 MeV` (MS-bar, μ = 2 GeV). -/
noncomputable def m_s_PDG : ℝ := 934 / 10

/-- **Charm quark PDG anchor**: `m_c = 1273 MeV ≈ m_c(m_c) MS-bar`. -/
noncomputable def m_c_PDG : ℝ := 1273

/-- **Bottom quark PDG anchor**: `m_b = 4180 MeV ≈ m_b(m_b) MS-bar`. -/
noncomputable def m_b_PDG : ℝ := 4180

/-! ## Positivity -/

/-- **Wave T1 session 177 — `m_u_PDG > 0`**. -/
theorem T1_m_u_PDG_pos : 0 < m_u_PDG := by
  unfold m_u_PDG; norm_num

/-- **Wave T1 session 177 — `m_d_PDG > 0`**. -/
theorem T1_m_d_PDG_pos : 0 < m_d_PDG := by
  unfold m_d_PDG; norm_num

/-- **Wave T1 session 177 — `m_s_PDG > 0`**. -/
theorem T1_m_s_PDG_pos : 0 < m_s_PDG := by
  unfold m_s_PDG; norm_num

/-- **Wave T1 session 177 — `m_c_PDG > 0`**. -/
theorem T1_m_c_PDG_pos : 0 < m_c_PDG := by
  unfold m_c_PDG; norm_num

/-- **Wave T1 session 177 — `m_b_PDG > 0`**. -/
theorem T1_m_b_PDG_pos : 0 < m_b_PDG := by
  unfold m_b_PDG; norm_num

/-! ## Hierarchy -/

/-- **Wave T1 session 177 — light-quark mass hierarchy m_u < m_d**. -/
theorem T1_quark_hierarchy_u_lt_d : m_u_PDG < m_d_PDG := by
  unfold m_u_PDG m_d_PDG; linarith

/-- **Wave T1 session 177 — light-quark mass hierarchy m_d < m_s**. -/
theorem T1_quark_hierarchy_d_lt_s : m_d_PDG < m_s_PDG := by
  unfold m_d_PDG m_s_PDG; linarith

/-- **Wave T1 session 177 — light-quark mass hierarchy m_s < m_c**. -/
theorem T1_quark_hierarchy_s_lt_c : m_s_PDG < m_c_PDG := by
  unfold m_s_PDG m_c_PDG; linarith

/-- **Wave T1 session 177 — light-quark mass hierarchy m_c < m_b**. -/
theorem T1_quark_hierarchy_c_lt_b : m_c_PDG < m_b_PDG := by
  unfold m_c_PDG m_b_PDG; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 177 — Light quark PDG anchors**.

    Five PDG 2024 anchor constants and the SM hierarchy:

    `0 < m_u < m_d < m_s < m_c < m_b`

    These are the comparison targets for substrate-derived quark
    masses (T-1 Phase 2+).

    Lean-core only.  Sub-lemma 2/N in T-1. -/
theorem session_177_light_quark_PDG_anchors_headline :
    0 < m_u_PDG ∧ m_u_PDG < m_d_PDG
    ∧ m_d_PDG < m_s_PDG
    ∧ m_s_PDG < m_c_PDG
    ∧ m_c_PDG < m_b_PDG :=
  ⟨T1_m_u_PDG_pos, T1_quark_hierarchy_u_lt_d,
   T1_quark_hierarchy_d_lt_s,
   T1_quark_hierarchy_s_lt_c,
   T1_quark_hierarchy_c_lt_b⟩

end OmegaTheory.Predictions.LightQuarkPDGAnchors
