/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantLeOne

  T-5 (Roth's theorem) — **Phase 7 ext #141: Roth constant ≤ 1 (for
  M ≥ 1, k ≥ 1) (cubic+ chain bookkeeping)**, sub session 559oooooooo
  — STRICT critical-path #316 (T-5) Phase 7 ext #141.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Roth constant upper bound:

  For M ≥ 1, k : ℕ, k ≥ 1: `M^(-(1/(k:ℝ))) ≤ 1`.

  Strategy: M ≥ 1 + negative exponent → result ≤ 1 via Real.rpow_le_one_of_one_le_of_nonpos
  or equivalent. Let me check Mathlib.

  Actually for M ≥ 1, e ≤ 0: `M^e ≤ 1`. Mathlib: `Real.rpow_le_one_of_one_le_of_nonpos`.

  Single derivation:
  1. `T5_roth_constant_le_one`: `M^(-(1/k)) ≤ 1` for M ≥ 1, k ≥ 1.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #141 — Roth constant ≤ 1 for M ≥ 1, k ≥ 1.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantLeOne

/-! ## Roth constant ≤ 1 -/

/-- **🚨 Wave T5 session 559oooooooo — `M^(-(1/k)) ≤ 1` for M ≥ 1, k ≥ 1**. -/
theorem T5_roth_constant_le_one (M : ℝ) (hM : 1 ≤ M) (k : ℕ) (hk : 1 ≤ k) :
    M ^ (-(1 / (k : ℝ))) ≤ 1 := by
  have hk_pos : (0 : ℝ) < (k : ℝ) := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hk
  have h_inv_pos : (0 : ℝ) < 1 / (k : ℝ) := by positivity
  have h_neg_le : -(1 / (k : ℝ)) ≤ 0 := by linarith
  exact Real.rpow_le_one_of_one_le_of_nonpos hM h_neg_le

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559oooooooo — T-5 Phase 7 ext #141**.

    🏆 BOOKKEEPING — Roth constant `M^(-(1/k)) ≤ 1` for M ≥ 1, k ≥ 1.

    Strategy: `Real.rpow_le_one_of_one_le_of_nonpos` (M ≥ 1 + exponent ≤ 0).

    Combined with M ≥ 1 (from ext #140) when p ∈ ℤ[X], p ≠ 0, k ≤ p.natDegree:
    the cubic+ Roth constant `C = M^(-1/k) ≤ 1` always.

    Sub-lemma 314/N. Lean-core only. -/
theorem session_559oooooooo_T5_phase7_roth_constant_le_one_headline
    (M : ℝ) (hM : 1 ≤ M) (k : ℕ) (hk : 1 ≤ k) :
    M ^ (-(1 / (k : ℝ))) ≤ 1 :=
  T5_roth_constant_le_one M hM k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantLeOne
