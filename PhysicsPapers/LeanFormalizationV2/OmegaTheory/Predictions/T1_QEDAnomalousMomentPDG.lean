/-
  OmegaTheory.Predictions.T1_QEDAnomalousMomentPDG

  T-1 (light quark masses) — Phase 2 sub session 226.
  QED anomalous magnetic moment a_e PDG anchor.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 anomalous magnetic moments:
  - a_e = (g-2)/2 of electron = 1.15965218 × 10^(-3)
  - a_μ = (g-2)/2 of muon = 1.16591810 × 10^(-3)

  Plus a_μ > a_e (heavy lepton has slightly larger anomaly).

  These are the most precisely-measured quantities in physics.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_QEDAnomalousMomentPDG

/-! ## PDG anchors -/

/-- **a_e PDG**: `1.15965218 × 10^(-3)` (electron anomaly). -/
noncomputable def a_e_PDG : ℝ := 115965218 / 100000000000

/-- **a_μ PDG**: `1.16591810 × 10^(-3)` (muon anomaly). -/
noncomputable def a_mu_PDG : ℝ := 116591810 / 100000000000

/-! ## Positivity -/

/-- **Wave T1 session 226 — `a_e > 0`**. -/
theorem T1_a_e_PDG_pos : 0 < a_e_PDG := by
  unfold a_e_PDG; norm_num

/-- **Wave T1 session 226 — `a_μ > 0`**. -/
theorem T1_a_mu_PDG_pos : 0 < a_mu_PDG := by
  unfold a_mu_PDG; norm_num

/-! ## Hierarchy -/

/-- **Wave T1 session 226 — `a_μ > a_e`** (heavy lepton has larger anomaly). -/
theorem T1_a_mu_gt_a_e : a_mu_PDG > a_e_PDG := by
  unfold a_mu_PDG a_e_PDG; linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 226 — `a_e < 1/100`** (small anomaly). -/
theorem T1_a_e_PDG_lt_1e_neg_2 : a_e_PDG < 1 / 100 := by
  unfold a_e_PDG; norm_num

/-- **Wave T1 session 226 — `a_μ < 1/100`**. -/
theorem T1_a_mu_PDG_lt_1e_neg_2 : a_mu_PDG < 1 / 100 := by
  unfold a_mu_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 226 — QED anomalous moments PDG**.

    Five foundational facts:
    1. `a_e = 1.16 × 10^(-3) > 0` (electron anomaly).
    2. `a_μ = 1.17 × 10^(-3) > 0` (muon anomaly).
    3. `a_μ > a_e` (mass-dependent).
    4. `a_e < 10^(-2)`.
    5. `a_μ < 10^(-2)`.

    Most precisely-measured quantities in physics — they cross-check
    QED + electroweak via 5-loop calculations.  Any substrate-derived
    g-2 prediction must match these.

    Sub-lemma 51/N in T-1.  Lean-core only. -/
theorem session_226_QED_anomalous_moments_PDG_headline :
    0 < a_e_PDG ∧ 0 < a_mu_PDG
    ∧ a_mu_PDG > a_e_PDG
    ∧ a_e_PDG < 1 / 100 ∧ a_mu_PDG < 1 / 100 :=
  ⟨T1_a_e_PDG_pos, T1_a_mu_PDG_pos, T1_a_mu_gt_a_e,
   T1_a_e_PDG_lt_1e_neg_2, T1_a_mu_PDG_lt_1e_neg_2⟩

end OmegaTheory.Predictions.T1_QEDAnomalousMomentPDG
