/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PositiveScaleBound

  T-5 (Roth's theorem) — **Phase 7 ext #154: Positive scale bound
  `0 < C·x ≤ x` for C ∈ (0,1] and x > 0 (cubic+ chain bookkeeping)**,
  sub session 559bbbbbbbbb — STRICT critical-path #316 (T-5)
  Phase 7 ext #154.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Combined positive scale bound:

  For C, x : ℝ with `0 < C ≤ 1` and `0 < x`:
    `0 < C * x ≤ x`

  Captures the bracketed bound `0 < C·x ≤ x ≤ |q-α|` for cubic+ Roth.

  Single derivation:
  1. `T5_positive_scale_bound`: `0 < C·x ≤ x`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #154 — positive scale bound `0 < C·x ≤ x`.
-/

import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PositiveScaleBound

/-! ## Positive scale bound -/

/-- **🚨 Wave T5 session 559bbbbbbbbb — `0 < C·x ≤ x` for C ∈ (0,1], x > 0**. -/
theorem T5_positive_scale_bound (C x : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1) (hx : 0 < x) :
    0 < C * x ∧ C * x ≤ x := by
  refine ⟨mul_pos hC_pos hx, ?_⟩
  calc C * x ≤ 1 * x := mul_le_mul_of_nonneg_right hC_le (le_of_lt hx)
    _ = x := one_mul _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbbbbbbbb — T-5 Phase 7 ext #154**.

    🏆 BOOKKEEPING — `0 < C·x ≤ x` for C ∈ (0,1], x > 0.

    Sub-lemma 327/N. Lean-core only. -/
theorem session_559bbbbbbbbb_T5_phase7_positive_scale_bound_headline
    (C x : ℝ) (hC_pos : 0 < C) (hC_le : C ≤ 1) (hx : 0 < x) :
    0 < C * x ∧ C * x ≤ x :=
  T5_positive_scale_bound C x hC_pos hC_le hx

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PositiveScaleBound
