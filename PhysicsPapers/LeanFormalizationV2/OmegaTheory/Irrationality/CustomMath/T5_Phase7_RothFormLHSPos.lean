/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos

  T-5 (Roth's theorem) — **Phase 7 ext #145: Roth-form LHS positivity
  `0 < C · q.den^e` (cubic+ chain bookkeeping)**, sub session 559ssssssss
  — STRICT critical-path #316 (T-5) Phase 7 ext #145.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Positivity of Roth-form bound LHS:

  For C > 0, q : ℚ, e : ℝ:
    `0 < C * (q.den : ℝ)^e`

  Used to ensure the Roth-form lower bound is strictly positive
  (so `|q-α| ≥ C · q.den^e > 0` is a meaningful bound).

  Single derivation:
  1. `T5_roth_form_LHS_pos`: composes positivity + Real.rpow_pos.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #145 — Roth-form LHS positivity.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

/-! ## Roth-form LHS positivity -/

/-- **🚨 Wave T5 session 559ssssssss — `0 < C · q.den^e`**.

    For C > 0, q : ℚ, e : ℝ. -/
theorem T5_roth_form_LHS_pos (C : ℝ) (hC : 0 < C) (q : ℚ) (e : ℝ) :
    (0 : ℝ) < C * ((q.den : ℝ)) ^ e := by
  exact mul_pos hC (T5_qden_rpow_pos q e)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ssssssss — T-5 Phase 7 ext #145**.

    🏆 BOOKKEEPING — Roth-form LHS `0 < C · q.den^e` for C > 0.

    Strategy: `mul_pos` + `T5_qden_rpow_pos` (ext #144).

    Used to ensure the Roth-form lower bound `|q-α| ≥ C · q.den^e` is
    strictly positive, so the bound is meaningful (not vacuous).

    Sub-lemma 318/N. Lean-core only. -/
theorem session_559ssssssss_T5_phase7_roth_form_LHS_pos_headline
    (C : ℝ) (hC : 0 < C) (q : ℚ) (e : ℝ) :
    (0 : ℝ) < C * ((q.den : ℝ)) ^ e :=
  T5_roth_form_LHS_pos C hC q e

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos
