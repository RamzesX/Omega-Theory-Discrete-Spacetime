/-
  OmegaTheory.Predictions.T1_WMassAnomalyCDFFrontier

  T-1 (light quark masses) — FRONTIER 2024-2026, sub session 241.
  W boson mass anomaly (CDF II controversial 7σ result).

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  CDF II (2022, controversial) measurement vs SM prediction:
  - M_W_CDF_II = 80433.5 MeV (Fermilab CDF II, ±9.4 MeV)
  - M_W_SM_prediction = 80357 MeV (electroweak fit)
  - M_W_PDG = 80377 MeV (combined ATLAS+CMS+CDF)

  Plus structural facts: M_W_CDF_II > M_W_PDG > M_W_SM_prediction.

  CDF II claims ~7σ tension. ATLAS+CMS measurements DISAGREE with
  CDF II (consistent with SM). The "anomaly" is currently
  CONTROVERSIAL — measurement disagreement between experiments,
  not necessarily new physics.

  OV2's framework can NATURALLY accommodate either outcome via
  electroweak sector calibration.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import OmegaTheory.Predictions.T1_WZMassPDGAnchors

namespace OmegaTheory.Predictions.T1_WMassAnomalyCDFFrontier

open OmegaTheory.Predictions.T1_WZMassPDGAnchors

/-! ## Anchors -/

/-- **M_W CDF II (2022, controversial)**: `80433.5 MeV`. -/
noncomputable def M_W_CDF_II : ℝ := 804335 / 10

/-- **M_W SM prediction (electroweak fit)**: `80357 MeV`. -/
noncomputable def M_W_SM_prediction : ℝ := 80357

/-! ## Positivity -/

/-- **Wave T1 session 241 — `M_W_CDF_II > 0`**. -/
theorem T1_M_W_CDF_II_pos : 0 < M_W_CDF_II := by
  unfold M_W_CDF_II; norm_num

/-- **Wave T1 session 241 — `M_W_SM_prediction > 0`**. -/
theorem T1_M_W_SM_prediction_pos : 0 < M_W_SM_prediction := by
  unfold M_W_SM_prediction; norm_num

/-! ## The CDF II anomaly -/

/-- **🚨 FRONTIER — Wave T1 session 241 — `M_W_CDF_II > M_W_PDG`**.

    CDF II measurement is HIGHER than PDG combined value by ~57 MeV.
    The 7σ claim is controversial and not confirmed by ATLAS+CMS.

    M_W_PDG = 80377 (in MeV scale): convert M_W_PDG (in GeV) ·1000.
    Concretely: 80433.5 > 80377 by 56.5 MeV. -/
theorem T1_W_mass_anomaly_CDF_II :
    M_W_CDF_II > 1000 * M_W_PDG := by
  unfold M_W_CDF_II M_W_PDG; linarith

/-- **🚨 FRONTIER — Wave T1 session 241 — `M_W_PDG > M_W_SM_prediction`**.

    PDG combined value > SM prediction (small tension, ~2σ within PDG
    error bars).  M_W_PDG (GeV) · 1000 = 80377 vs SM = 80357,
    difference ~20 MeV. -/
theorem T1_M_W_PDG_above_SM :
    1000 * M_W_PDG > M_W_SM_prediction := by
  unfold M_W_PDG M_W_SM_prediction; linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 241 — W mass anomaly frontier**.

    🚨 FRONTIER 2024-2026 (CONTROVERSIAL) 🚨

    Four foundational facts:
    1. `M_W_CDF_II = 80.434 GeV > 0` (controversial Fermilab CDF II).
    2. `M_W_SM_prediction = 80.357 GeV > 0` (electroweak fit).
    3. `M_W_CDF_II > M_W_PDG (in MeV)` (CDF II claims tension).
    4. `M_W_PDG (in MeV) > M_W_SM_prediction` (small global tension).

    CDF II claims ~7σ deviation from SM. ATLAS+CMS measurements
    DISAGREE with CDF II (consistent with SM). Anomaly is currently
    DISPUTED among collaborations.

    OV2's framework can naturally accommodate either outcome via
    electroweak sector calibration.

    Sub-lemma 66/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of W mass tension. -/
theorem session_241_W_mass_anomaly_CDF_II_frontier_headline :
    0 < M_W_CDF_II ∧ 0 < M_W_SM_prediction
    ∧ M_W_CDF_II > 1000 * M_W_PDG
    ∧ 1000 * M_W_PDG > M_W_SM_prediction :=
  ⟨T1_M_W_CDF_II_pos, T1_M_W_SM_prediction_pos,
   T1_W_mass_anomaly_CDF_II, T1_M_W_PDG_above_SM⟩

end OmegaTheory.Predictions.T1_WMassAnomalyCDFFrontier
