/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_KthRootStep

  T-5 (Roth's theorem) — **Phase 7 ext #109: kth-root step
  `x^k ≥ A → x ≥ A^(1/k)` (cubic+ chain real-power flip)**, sub
  session 559iiiiiii — STRICT critical-path #316 (T-5) Phase 7 ext #109.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Real-power kth-root flip:

  For `x, A ≥ 0` and `k ≥ 1`:
    `A ≤ x^k → A^(1/k) ≤ x`

  This is the bridge between integer-power form (s108: `|q-α|^k · M · q.den^d ≥ 1`)
  and real-power form (Roth-form: `|q-α| ≥ ...`).

  Strategy: use `Real.rpow_le_rpow_iff` or equivalent monotonicity lemma.
  For k ≥ 1 and x, A ≥ 0:
    `A^(1/k) ≤ x ↔ A ≤ x^k`
  (equivalent statement; we want left-to-right under `x^k ≥ A`).

  Single derivation:
  1. `T5_kth_root_step`: `A ≤ x^k → A^(1/k) ≤ x` (k ≥ 1, x ≥ 0, A ≥ 0).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #109 — kth-root step real-power flip.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.NNReal
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_KthRootStep

/-! ## kth-root step -/

/-- **🚨 Wave T5 session 559iiiiiii — kth-root flip `x^k ≥ A → x ≥ A^(1/k)`**.

    For `x ≥ 0`, `A ≥ 0`, and `k ≥ 1` (natural):
      `A ≤ x^k → A ^ (1/(k : ℝ)) ≤ x`

    Strategy: use Real.rpow monotonicity. Cast `x^k = x^(k : ℝ)` via
    `Real.rpow_natCast`; apply `Real.rpow_le_rpow` with the inverse
    exponent. -/
theorem T5_kth_root_step
    (x A : ℝ) (hx : 0 ≤ x) (hA : 0 ≤ A) (k : ℕ) (hk : 1 ≤ k)
    (h : A ≤ x ^ k) :
    A ^ (1 / (k : ℝ)) ≤ x := by
  -- Cast x^k to x^(k : ℝ)
  have hk_pos : (0 : ℝ) < k := by exact_mod_cast Nat.lt_of_lt_of_le (by norm_num) hk
  have hk_inv_pos : (0 : ℝ) < 1 / (k : ℝ) := by positivity
  have hk_ne : (k : ℝ) ≠ 0 := ne_of_gt hk_pos
  -- A ≤ x^k = x^(k : ℝ) (since x ≥ 0)
  have h_cast : (x ^ k : ℝ) = x ^ ((k : ℕ) : ℝ) := by
    rw [Real.rpow_natCast]
  rw [h_cast] at h
  -- Apply Real.rpow_le_rpow with exponent 1/k
  have h_rpow := Real.rpow_le_rpow hA h (le_of_lt hk_inv_pos)
  -- Now: A^(1/k) ≤ (x^(k : ℝ))^(1/k). Rewrite RHS via rpow_mul.
  rw [← Real.rpow_mul hx] at h_rpow
  -- (k : ℝ) * (1/k) = 1
  rw [mul_one_div, div_self hk_ne, Real.rpow_one] at h_rpow
  exact h_rpow

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559iiiiiii — T-5 Phase 7 ext #109:
    kth-root step**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #109.

    🏆 REAL-POWER FLIP — `x^k ≥ A → x ≥ A^(1/k)`.

    Single derivation:
    1. `T5_kth_root_step` — kth-root inequality flip via Real.rpow.

    Strategy: cast `x^k = x^(k:ℝ)` via `Real.rpow_natCast`, apply
    `Real.rpow_le_rpow` with inverse exponent `1/k`, simplify
    `(x^k)^(1/k) = x` via `Real.rpow_mul + div_self`.

    This is the BRIDGE from integer-power form (s108: `|q-α|^k · ... ≥ 1`)
    to real-power form (final Roth-form `|q-α| ≥ C · q.den^(-(2+ε))`).

    Mathlib usage: `Real.rpow_natCast`, `Real.rpow_le_rpow`,
    `Real.rpow_mul`, `Real.rpow_one`, `mul_one_div`, `div_self`.

    Sub-lemma 282/N in T-1 (T-5 Phase 7 ext #109).  Lean-core only. -/
theorem session_559iiiiiii_T5_phase7_kth_root_step_headline
    (x A : ℝ) (hx : 0 ≤ x) (hA : 0 ≤ A) (k : ℕ) (hk : 1 ≤ k)
    (h : A ≤ x ^ k) :
    A ^ (1 / (k : ℝ)) ≤ x :=
  T5_kth_root_step x A hx hA k hk h

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_KthRootStep
