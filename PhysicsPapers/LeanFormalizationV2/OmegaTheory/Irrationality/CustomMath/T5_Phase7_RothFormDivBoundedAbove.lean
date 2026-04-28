/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormDivBoundedAbove

  T-5 (Roth's theorem) — **Phase 7 ext #164: Roth-form `C / q.den^e ≤ 1`
  for C ≤ 1 + e ≥ 0 (cubic+ chain bookkeeping)**, sub session
  559lllllllll — STRICT critical-path #316 (T-5) Phase 7 ext #164.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Upper bound on Roth-form denominator:

  For C : ℝ with `0 ≤ C ≤ 1`, q : ℚ, e : ℝ with `0 ≤ e`:
    `C / ((q.den : ℝ)) ^ e ≤ 1`

  Strategy: `q.den^e ≥ 1` (ext #163) + `C / X ≤ 1 / X` for C ≤ 1 + `1 / X ≤ 1`
  for X ≥ 1 — combine.

  Single derivation:
  1. `T5_roth_form_div_bounded_above`: `C / q.den^e ≤ 1`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #164 — Roth-form denominator bounded above by 1.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowGeOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormDivBoundedAbove

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowGeOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

/-! ## Roth-form upper-bound -/

/-- **🚨 Wave T5 session 559lllllllll — `C / q.den^e ≤ 1` for C ≤ 1, e ≥ 0**. -/
theorem T5_roth_form_div_bounded_above
    (C : ℝ) (hC_nn : 0 ≤ C) (hC_le : C ≤ 1)
    (q : ℚ) (e : ℝ) (he : 0 ≤ e) :
    C / ((q.den : ℝ)) ^ e ≤ 1 := by
  have h_pow_ge_one : (1 : ℝ) ≤ ((q.den : ℝ)) ^ e := T5_qden_rpow_ge_one q e he
  have h_pow_pos : (0 : ℝ) < ((q.den : ℝ)) ^ e := T5_qden_rpow_pos q e
  -- C / X ≤ 1 / X (since X > 0 and C ≤ 1)
  -- 1 / X ≤ 1 (since X ≥ 1)
  calc C / ((q.den : ℝ)) ^ e
      ≤ 1 / ((q.den : ℝ)) ^ e :=
        div_le_div_of_nonneg_right hC_le h_pow_pos.le
    _ ≤ 1 / 1 := by
        apply one_div_le_one_div_of_le (by norm_num : (0:ℝ) < 1)
        exact h_pow_ge_one
    _ = 1 := by norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559lllllllll — T-5 Phase 7 ext #164**.

    🏆 BOOKKEEPING — Roth-form `C / q.den^e ≤ 1` for C ≤ 1, e ≥ 0.

    Sub-lemma 337/N. Lean-core only. -/
theorem session_559lllllllll_T5_phase7_roth_form_div_bounded_above_headline
    (C : ℝ) (hC_nn : 0 ≤ C) (hC_le : C ≤ 1)
    (q : ℚ) (e : ℝ) (he : 0 ≤ e) :
    C / ((q.den : ℝ)) ^ e ≤ 1 :=
  T5_roth_form_div_bounded_above C hC_nn hC_le q e he

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormDivBoundedAbove
