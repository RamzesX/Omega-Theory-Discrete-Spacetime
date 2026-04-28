/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_NatRealCastPos

  T-5 (Roth's theorem) — **Phase 7 ext #123: Nat → ℝ cast positivity
  helpers (cubic+ chain bookkeeping)**, sub session 559wwwwwww —
  STRICT critical-path #316 (T-5) Phase 7 ext #123.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Cast bookkeeping for the Schmidt index `k : ℕ`:

  For k : ℕ with `1 ≤ k`:
    `(1 : ℝ) ≤ (k : ℝ)`
    `(0 : ℝ) < (k : ℝ)`
    `(0 : ℝ) ≤ (k : ℝ)`
    `(k : ℝ) ≠ 0`

  Used throughout cubic+ chain when transitioning from Nat-indexed
  Schmidt index to Real-power forms.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #123 — Nat → ℝ cast positivity.
-/

import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_NatRealCastPos

/-! ## Nat → ℝ cast positivity -/

/-- **🚨 Wave T5 session 559wwwwwww — `1 ≤ k → (1 : ℝ) ≤ (k : ℝ)`**.

    For k : ℕ with 1 ≤ k. -/
theorem T5_nat_real_cast_one_le {k : ℕ} (hk : 1 ≤ k) :
    (1 : ℝ) ≤ (k : ℝ) := by
  exact_mod_cast hk

/-- Companion: strict pos — `1 ≤ k → 0 < (k : ℝ)`. -/
theorem T5_nat_real_cast_pos {k : ℕ} (hk : 1 ≤ k) :
    (0 : ℝ) < (k : ℝ) :=
  lt_of_lt_of_le (by norm_num) (T5_nat_real_cast_one_le hk)

/-- Companion: non-negative — `(0 : ℝ) ≤ (k : ℝ)`. -/
theorem T5_nat_real_cast_nn (k : ℕ) :
    (0 : ℝ) ≤ (k : ℝ) := by
  exact_mod_cast Nat.zero_le k

/-- Companion: non-zero — `1 ≤ k → (k : ℝ) ≠ 0`. -/
theorem T5_nat_real_cast_ne_zero {k : ℕ} (hk : 1 ≤ k) :
    (k : ℝ) ≠ 0 :=
  ne_of_gt (T5_nat_real_cast_pos hk)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559wwwwwww — T-5 Phase 7 ext #123**.

    🏆 BOOKKEEPING — Nat → ℝ cast positivity (4-conjunct).

    Sub-lemma 296/N. Lean-core only. -/
theorem session_559wwwwwww_T5_phase7_nat_real_cast_pos_headline
    {k : ℕ} (hk : 1 ≤ k) :
    (1 : ℝ) ≤ (k : ℝ) ∧
    (0 : ℝ) < (k : ℝ) ∧
    (0 : ℝ) ≤ (k : ℝ) ∧
    (k : ℝ) ≠ 0 :=
  ⟨T5_nat_real_cast_one_le hk,
   T5_nat_real_cast_pos hk,
   T5_nat_real_cast_nn k,
   T5_nat_real_cast_ne_zero hk⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_NatRealCastPos
