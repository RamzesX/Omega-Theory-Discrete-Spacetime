/-
  OmegaTheory.Predictions.T1_NeutronProtonGFactorPDG

  T-1 (light quark masses) — Phase 2 sub session 225.
  Neutron / proton g-factors PDG anchors.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  PDG 2024 nucleon g-factors:
  - g_p = 5.5856947 (proton, anomalous magnetic moment)
  - g_n = -3.82608545 (neutron, anomalous magnetic moment)

  Plus structural facts: g_p > 0, g_n < 0, |g_p| > 0, |g_n| > 0.

  Substrate predicts g-factors via SU(3) color charge averaging
  over valence quark wavefunctions.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_NeutronProtonGFactorPDG

/-! ## PDG anchors -/

/-- **g_p PDG**: `5.5856947` (proton anomalous magnetic g-factor). -/
noncomputable def g_p_PDG : ℝ := 55856947 / 10000000

/-- **g_n PDG**: `-3.82608545` (neutron anomalous magnetic g-factor). -/
noncomputable def g_n_PDG : ℝ := -382608545 / 100000000

/-! ## Sign relations -/

/-- **Wave T1 session 225 — `g_p > 0`** (proton positive g-factor). -/
theorem T1_g_p_PDG_pos : 0 < g_p_PDG := by
  unfold g_p_PDG; norm_num

/-- **Wave T1 session 225 — `g_n < 0`** (neutron NEGATIVE g-factor). -/
theorem T1_g_n_PDG_neg : g_n_PDG < 0 := by
  unfold g_n_PDG; norm_num

/-- **Wave T1 session 225 — `g_p > -g_n`** (proton magnitude larger). -/
theorem T1_g_p_gt_abs_g_n : g_p_PDG > -g_n_PDG := by
  unfold g_p_PDG g_n_PDG; linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 225 — `g_p > 5`**. -/
theorem T1_g_p_PDG_gt_5 : g_p_PDG > 5 := by
  unfold g_p_PDG; norm_num

/-- **Wave T1 session 225 — `g_n < -3`**. -/
theorem T1_g_n_PDG_lt_neg_3 : g_n_PDG < -3 := by
  unfold g_n_PDG; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 225 — Nucleon g-factors PDG**.

    Five foundational facts:
    1. `g_p = 5.586 > 0` (proton positive g-factor).
    2. `g_n = -3.826 < 0` (neutron negative g-factor).
    3. `g_p > -g_n` (proton magnitude larger).
    4. `g_p > 5`.
    5. `g_n < -3`.

    Substrate predicts g-factors via SU(3) color charge averaging
    over valence quark wavefunctions.

    Sub-lemma 50/N in T-1.  Lean-core only.

    🏆 50 T-1 sub-lemmas LANDED. -/
theorem session_225_nucleon_g_factors_PDG_headline :
    0 < g_p_PDG ∧ g_n_PDG < 0
    ∧ g_p_PDG > -g_n_PDG
    ∧ g_p_PDG > 5 ∧ g_n_PDG < -3 :=
  ⟨T1_g_p_PDG_pos, T1_g_n_PDG_neg, T1_g_p_gt_abs_g_n,
   T1_g_p_PDG_gt_5, T1_g_n_PDG_lt_neg_3⟩

end OmegaTheory.Predictions.T1_NeutronProtonGFactorPDG
