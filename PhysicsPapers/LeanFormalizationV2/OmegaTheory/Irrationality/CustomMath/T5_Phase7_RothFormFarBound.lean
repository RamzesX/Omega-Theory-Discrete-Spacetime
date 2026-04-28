/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound

  T-5 (Roth's theorem) — **Phase 7 ext #156: Roth-form bound for q
  far from α (|q-α| > 1) (cubic+ chain pigeonhole companion)**, sub
  session 559ddddddddd — STRICT critical-path #316 (T-5)
  Phase 7 ext #156.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  For q ∈ ℚ with `|q - α| > 1` and Roth constant `C ∈ (0, 1]`:
    `C · q.den^(-(2+ε)) ≤ |q - α|`

  Strategy: when |q - α| > 1 (q far from α), the Roth bound is trivially
  satisfied since the LHS `C · q.den^(-(2+ε)) ≤ q.den^(-(2+ε)) ≤ 1 < |q - α|`
  (using C ≤ 1, q.den ≥ 1 with negative exponent, and 1 < |q-α|).

  Single derivation:
  1. `T5_roth_form_far_bound`: bound for q far from α.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #156 — Roth-form bound for q far from α.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenScaleBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenScaleBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QDenExponentMono

/-! ## Roth-form bound for q far from α -/

/-- **🚨 Wave T5 session 559ddddddddd — Roth-form for q far from α**.

    For C ∈ (0, 1], q : ℚ with `1 < |q - α|`, ε > 0:
      `C · q.den^(-(2+ε)) ≤ |q - α|`. -/
theorem T5_roth_form_far_bound
    (C : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1)
    (q : ℚ) (α : ℝ) (h_far : 1 < |((q : ℚ) : ℝ) - α|)
    (ε : ℝ) (hε : 0 < ε) :
    C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  -- C · q.den^(-(2+ε)) ≤ q.den^(-(2+ε)) (from ext #155 with e := -(2+ε))
  have h_scale := (T5_qden_scale_bound C hC_pos hC_le q (-(2 + ε))).2
  -- q.den^(-(2+ε)) ≤ q.den^0 = 1 (from exponent mono with -(2+ε) ≤ 0)
  have h_exp_le : -(2 + ε) ≤ (0 : ℝ) := by linarith
  have h_qden_mono := T5_qden_rpow_mono q (-(2 + ε)) 0 h_exp_le
  -- q.den^0 = 1
  have h_qden_zero : ((q.den : ℝ)) ^ (0 : ℝ) = 1 := Real.rpow_zero _
  -- Chain: C · q.den^e ≤ q.den^e ≤ q.den^0 = 1 < |q - α|
  calc C * ((q.den : ℝ)) ^ (-(2 + ε))
      ≤ ((q.den : ℝ)) ^ (-(2 + ε)) := h_scale
    _ ≤ ((q.den : ℝ)) ^ (0 : ℝ) := h_qden_mono
    _ = 1 := h_qden_zero
    _ ≤ |((q : ℚ) : ℝ) - α| := le_of_lt h_far

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ddddddddd — T-5 Phase 7 ext #156**.

    🏆 BOOKKEEPING — Roth-form bound trivially holds for q far from α.

    Strategy: chain `C · q.den^e ≤ q.den^e ≤ q.den^0 = 1 < |q - α|`.

    Used in pigeonhole over rationals: split |q - α| ≤ 1 (close) vs
    |q - α| > 1 (far). The far case is trivial.

    Sub-lemma 329/N. Lean-core only. -/
theorem session_559ddddddddd_T5_phase7_roth_form_far_bound_headline
    (C : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1)
    (q : ℚ) (α : ℝ) (h_far : 1 < |((q : ℚ) : ℝ) - α|)
    (ε : ℝ) (hε : 0 < ε) :
    C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_form_far_bound C hC_pos hC_le q α h_far ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound
