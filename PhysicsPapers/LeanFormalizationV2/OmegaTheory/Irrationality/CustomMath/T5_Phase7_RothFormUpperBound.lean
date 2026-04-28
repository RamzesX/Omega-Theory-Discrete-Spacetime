/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormUpperBound

  T-5 (Roth's theorem) — **Phase 7 ext #150: Roth-form upper bound
  `C · q.den^e ≤ q.den^e` for C ≤ 1 (cubic+ chain bookkeeping)**, sub
  session 559xxxxxxxx — STRICT critical-path #316 (T-5) Phase 7 ext #150.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Upper bound on Roth-form LHS when C ≤ 1:

  For C : ℝ with `0 ≤ C ≤ 1`, q : ℚ, e : ℝ:
    `C * (q.den : ℝ)^e ≤ (q.den : ℝ)^e`

  Used to compare the Roth-form bound `C · q.den^(-(2+ε))` with the
  unscaled `q.den^(-(2+ε))` form (since C ∈ (0, 1] from ext #143).

  Single derivation:
  1. `T5_roth_form_upper_bound`: `C · q.den^e ≤ q.den^e`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #150 — Roth-form upper bound C ≤ 1 implies C·... ≤ ....
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormUpperBound

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenRpowPos

/-! ## Roth-form upper bound -/

/-- **🚨 Wave T5 session 559xxxxxxxx — `C · q.den^e ≤ q.den^e` for C ≤ 1**.

    For C with `0 ≤ C ≤ 1`, q : ℚ, e : ℝ. -/
theorem T5_roth_form_upper_bound
    (C : ℝ) (hC_nn : 0 ≤ C) (hC_le_one : C ≤ 1) (q : ℚ) (e : ℝ) :
    C * ((q.den : ℝ)) ^ e ≤ ((q.den : ℝ)) ^ e := by
  have h_qden_pos := T5_qden_rpow_pos q e
  -- C · x ≤ 1 · x = x when 0 ≤ x and C ≤ 1
  calc C * ((q.den : ℝ)) ^ e
      ≤ 1 * ((q.den : ℝ)) ^ e := by
        apply mul_le_mul_of_nonneg_right hC_le_one (le_of_lt h_qden_pos)
    _ = ((q.den : ℝ)) ^ e := one_mul _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559xxxxxxxx — T-5 Phase 7 ext #150**.

    🏆 BOOKKEEPING — `C · q.den^e ≤ q.den^e` for `C ≤ 1`.

    Strategy: `mul_le_mul_of_nonneg_right` + `one_mul`.

    Used to bound the Roth-form LHS `C · q.den^(-(2+ε))` above by
    `q.den^(-(2+ε))` (when C ∈ (0, 1] from ext #143).

    Sub-lemma 323/N. Lean-core only. -/
theorem session_559xxxxxxxx_T5_phase7_roth_form_upper_bound_headline
    (C : ℝ) (hC_nn : 0 ≤ C) (hC_le_one : C ≤ 1) (q : ℚ) (e : ℝ) :
    C * ((q.den : ℝ)) ^ e ≤ ((q.den : ℝ)) ^ e :=
  T5_roth_form_upper_bound C hC_nn hC_le_one q e

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormUpperBound
