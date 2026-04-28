/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantStrictLt

  T-5 (Roth's theorem) — **Phase 7 ext #152: Roth constant strictly < 1
  for M > 1 (cubic+ chain bookkeeping)**, sub session 559zzzzzzzz —
  STRICT critical-path #316 (T-5) Phase 7 ext #152.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Strict version of ext #141 (Roth constant ≤ 1):

  For M > 1, k : ℕ, k ≥ 1: `M^(-(1/k)) < 1`.

  Strategy: M > 1 + negative exponent → strictly less than 1.
  Mathlib: `Real.rpow_lt_one_of_one_lt_of_neg`.

  Single derivation:
  1. `T5_roth_constant_strict_lt_one`: `M^(-(1/k)) < 1` for M > 1, k ≥ 1.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #152 — Roth constant strictly < 1 for M > 1.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantStrictLt

/-! ## Roth constant strictly < 1 -/

/-- **🚨 Wave T5 session 559zzzzzzzz — `M^(-(1/k)) < 1` for M > 1, k ≥ 1**.

    Strict version of ext #141. -/
theorem T5_roth_constant_strict_lt_one (M : ℝ) (hM : 1 < M) (k : ℕ) (hk : 1 ≤ k) :
    M ^ (-(1 / (k : ℝ))) < 1 := by
  have hk_pos : (0 : ℝ) < (k : ℝ) := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hk
  have h_inv_pos : (0 : ℝ) < 1 / (k : ℝ) := by positivity
  have h_neg_lt : -(1 / (k : ℝ)) < 0 := by linarith
  exact Real.rpow_lt_one_of_one_lt_of_neg hM h_neg_lt

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zzzzzzzz — T-5 Phase 7 ext #152**.

    🏆 BOOKKEEPING — Roth constant `M^(-(1/k)) < 1` STRICT for M > 1.

    Strategy: `Real.rpow_lt_one_of_one_lt_of_neg` (M > 1 + exponent < 0).

    Useful for non-trivial cases (M > 1 means polynomial has degree ≥ 1
    with non-trivial coefficients).

    Sub-lemma 325/N. Lean-core only. -/
theorem session_559zzzzzzzz_T5_phase7_roth_constant_strict_lt_one_headline
    (M : ℝ) (hM : 1 < M) (k : ℕ) (hk : 1 ≤ k) :
    M ^ (-(1 / (k : ℝ))) < 1 :=
  T5_roth_constant_strict_lt_one M hM k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantStrictLt
