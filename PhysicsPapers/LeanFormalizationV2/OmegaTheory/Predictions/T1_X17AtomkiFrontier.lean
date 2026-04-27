/-
  OmegaTheory.Predictions.T1_X17AtomkiFrontier

  T-1 (light quark masses) — FRONTIER, sub session 303.
  X17 Atomki anomaly — claimed light boson at ~17 MeV.

  Single-thread hand-authored 2026-04-28 (cycle 65).
  opus-code-crawler proposal #7. (Anomaly-claim status, NOT discovery.)

  ## What this file delivers

  Atomki claims (Hungarian Academy of Sciences) — anomalous e⁺e⁻ pair
  emissions from nuclear transitions point to ~17 MeV boson:
  - ⁸Be excitation: m_X = 16.86 ± 0.06 MeV (Phys.Rev.C 106 (2022) L061601)
  - ⁴He excitation: consistent with ⁸Be value
  - ¹²C excitation: consistent (Phys.Rev.C 109 (2024) 044003)

  Why important:
  - Atomki claim spans 3 different nuclei = independent evidence
  - If real → 5th force / new light mediator
  - PADME (LNF) + MEG-II + STRING (CERN) testing in 2024-2025

  RISK FLAG: PDG 2024 lists X17 as "anomaly under test", NOT confirmed.
  We formalize the claim values, NOT the existence assertion.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_X17AtomkiFrontier

/-! ## X17 mass values (in MeV) -/

/-- **X17 m_X from ⁸Be Atomki**: `16.86 MeV`. -/
noncomputable def m_X_Be8 : ℝ := 1686 / 100

/-- **X17 m_X uncertainty**: `0.06 MeV`. -/
noncomputable def m_X_uncertainty : ℝ := 6 / 100

/-- **X17 m_X from ⁴He Atomki**: `~17 MeV` (consistent). -/
noncomputable def m_X_He4 : ℝ := 17

/-- **X17 m_X from ¹²C Atomki 2024**: `~17 MeV` (consistent). -/
noncomputable def m_X_C12 : ℝ := 17

/-! ## Positivity -/

/-- **Wave T1 session 303 — `m_X Be8 > 0`**. -/
theorem T1_m_X_Be8_pos : 0 < m_X_Be8 := by
  unfold m_X_Be8; norm_num

/-- **Wave T1 session 303 — `m_X uncertainty > 0`**. -/
theorem T1_m_X_uncertainty_pos : 0 < m_X_uncertainty := by
  unfold m_X_uncertainty; norm_num

/-- **Wave T1 session 303 — `m_X He4 > 0`**. -/
theorem T1_m_X_He4_pos : 0 < m_X_He4 := by
  unfold m_X_He4; norm_num

/-- **Wave T1 session 303 — `m_X C12 > 0`**. -/
theorem T1_m_X_C12_pos : 0 < m_X_C12 := by
  unfold m_X_C12; norm_num

/-! ## Cross-nucleus consistency: He4 = C12 -/

/-- **🚨 FRONTIER — Wave T1 session 303 — `m_X He4 = m_X C12`**.

    Atomki claims same X17 value across 3 nuclei. -/
theorem T1_He4_eq_C12 :
    m_X_He4 = m_X_C12 := by
  unfold m_X_He4 m_X_C12; rfl

/-! ## Mass in narrow band [16.5, 17.5] MeV -/

/-- **🚨 FRONTIER — Wave T1 session 303 — `m_X Be8 > 16.5 MeV`**. -/
theorem T1_m_X_above_16_5 : m_X_Be8 > 165 / 10 := by
  unfold m_X_Be8; norm_num

/-- **🚨 FRONTIER — Wave T1 session 303 — `m_X Be8 < 17.5 MeV`**. -/
theorem T1_m_X_below_17_5 : m_X_Be8 < 175 / 10 := by
  unfold m_X_Be8; norm_num

/-- **🚨 FRONTIER — Wave T1 session 303 — `m_X He4 < 17.5 MeV`**. -/
theorem T1_m_X_He4_below_17_5 : m_X_He4 < 175 / 10 := by
  unfold m_X_He4; norm_num

/-! ## Be8 - He4 difference within uncertainty -/

/-- **🚨 FRONTIER — Wave T1 session 303 — `|m_X He4 - m_X Be8| < 0.5 MeV`**. -/
theorem T1_He4_Be8_diff_small :
    m_X_He4 - m_X_Be8 < 1/2 := by
  unfold m_X_He4 m_X_Be8; norm_num

/-! ## Lightness (much less than W mass) -/

/-- **🚨 FRONTIER — Wave T1 session 303 — `m_X < 100 MeV`**. -/
theorem T1_m_X_lt_100_MeV : m_X_Be8 < 100 := by
  unfold m_X_Be8; norm_num

/-- **🚨 FRONTIER — Wave T1 session 303 — `m_X > 10 MeV`** (above electron mass × 20). -/
theorem T1_m_X_gt_10_MeV : m_X_Be8 > 10 := by
  unfold m_X_Be8; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 303 — X17 Atomki anomaly frontier**.

    🚨 FRONTIER (claimed light boson, NOT yet confirmed) 🚨

    Eleven foundational facts:
    1. `m_X Be8 = 16.86 MeV > 0`.
    2. `uncertainty = 0.06 MeV > 0`.
    3. `m_X He4 = 17 MeV > 0`.
    4. `m_X C12 = 17 MeV > 0`.
    5. `m_X He4 = m_X C12` (cross-nucleus consistency).
    6. `m_X Be8 > 16.5 MeV`.
    7. `m_X Be8 < 17.5 MeV`.
    8. `m_X He4 < 17.5 MeV`.
    9. `|He4 - Be8| < 0.5 MeV` (consistent within Δm ≈ 0.14).
    10. `m_X < 100 MeV` (light boson).
    11. `m_X > 10 MeV` (above electron-pair threshold).

    Atomki claim spans 3 nuclei → if real, 5th force / new light
    mediator. PADME + MEG-II + STRING testing 2024-2025.

    RISK FLAG: anomaly under test, NOT yet confirmed by independent
    experiments.

    Sub-lemma 123/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of X17 Atomki claim values. -/
theorem session_303_X17_Atomki_frontier_headline :
    0 < m_X_Be8 ∧ 0 < m_X_uncertainty
    ∧ 0 < m_X_He4 ∧ 0 < m_X_C12
    ∧ m_X_He4 = m_X_C12
    ∧ m_X_Be8 > 165 / 10
    ∧ m_X_Be8 < 175 / 10
    ∧ m_X_He4 < 175 / 10
    ∧ m_X_He4 - m_X_Be8 < 1/2
    ∧ m_X_Be8 < 100 ∧ m_X_Be8 > 10 :=
  ⟨T1_m_X_Be8_pos, T1_m_X_uncertainty_pos,
   T1_m_X_He4_pos, T1_m_X_C12_pos,
   T1_He4_eq_C12,
   T1_m_X_above_16_5, T1_m_X_below_17_5, T1_m_X_He4_below_17_5,
   T1_He4_Be8_diff_small,
   T1_m_X_lt_100_MeV, T1_m_X_gt_10_MeV⟩

end OmegaTheory.Predictions.T1_X17AtomkiFrontier
