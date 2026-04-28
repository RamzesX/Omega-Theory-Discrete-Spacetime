/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalNonzeroLowerBound

  T-5 (Roth's theorem) — **Phase 7 ext #38: Rational evaluation
  non-zero lower bound (Gap B closure — Liouville contradiction
  lever, conditional discharge of RothLiouvilleAnalyticalBound)**,
  sub session 559eeee — STRICT critical-path #316 (T-5) Phase 7
  ext #38.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Conditional Liouville lower bound: given the integer-clearing
  hypothesis `(commonDenom q)^d · evalRatPoly q p = k : ℤ` and
  `evalRatPoly q p ≠ 0`, the absolute value satisfies the Liouville
  inequality:

      |evalRatPoly q p| ≥ 1 / (commonDenom q)^d

  This is the **contradiction lever direction** for Roth's main
  proof: combined with the Taylor / analytical UPPER bound (deferred
  to ext #39+), it forces `evalRatPoly q p = 0` for q close to α —
  the Roth contradiction.

  Three derivations + Prop:
  1. `T5_rational_eval_nonzero_lower_bound`: main lower bound
  2. `T5_rational_eval_eq_intCast_div`: structural division form
  3. `T5_rational_eval_int_witness_pos_abs`: |k| ≥ 1 from k ≠ 0

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #38 — Liouville lower bound (contradiction lever).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalAbsBound
import Mathlib.Algebra.Order.Field.Basic
import Mathlib.Algebra.Order.Field.Rat

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalNonzeroLowerBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalIntegerForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalAbsBound

/-! ## Integer-witness absolute value bound -/

/-- **🚨 Wave T5 session 559eeee — `k ≠ 0 → 1 ≤ |k|`** for `k : ℤ`.

    Standard `Int.one_le_abs` re-export. -/
theorem T5_rational_eval_int_witness_pos_abs (k : ℤ) (hk : k ≠ 0) :
    1 ≤ |k| :=
  Int.one_le_abs hk

/-! ## Structural division form -/

/-- **🚨 Wave T5 session 559eeee — division form**.

    Given `(D : ℚ)^d * v = (k : ℤ)` with `D > 0`,
    `v = (k : ℚ) / (D : ℚ)^d`. -/
theorem T5_rational_eval_eq_intCast_div {n d : ℕ} (q : Fin n → ℚ)
    (v : ℚ) (k : ℤ)
    (h_clear : ((commonDenom q : ℚ)) ^ d * v = (k : ℚ)) :
    v = (k : ℚ) / ((commonDenom q : ℚ)) ^ d := by
  have h_pos := T5_commonDenom_pow_pos_rat (d := d) q
  have h_ne := ne_of_gt h_pos
  -- v = k / D^d ↔ D^d * v = k (since D^d ≠ 0)
  rw [eq_div_iff h_ne, mul_comm]
  exact h_clear

/-! ## Main Liouville lower bound -/

/-- **🚨 Wave T5 session 559eeee — Liouville lower bound (conditional)**.

    Given the integer-clearing hypothesis `(commonDenom q)^d · v = (k : ℤ)`
    and `v ≠ 0`, the absolute value `|v|` is bounded below by the
    Liouville inequality `|v| ≥ 1 / (commonDenom q)^d`.

    This is the **contradiction-lever lower bound** for Roth: if a
    rational q-evaluation of an integer-coefficient polynomial is
    non-zero, it cannot be smaller than `1/D^d` where `D = commonDenom q`.
    Combined with the Taylor / analytical upper bound at rational q
    close to algebraic α, this forces `v = 0` (the Roth contradiction). -/
theorem T5_rational_eval_nonzero_lower_bound {n d : ℕ} (q : Fin n → ℚ)
    (v : ℚ) (k : ℤ)
    (h_clear : ((commonDenom q : ℚ)) ^ d * v = (k : ℚ))
    (h_nonzero : v ≠ 0) :
    1 / ((commonDenom q : ℚ)) ^ d ≤ |v| := by
  have h_pos := T5_commonDenom_pow_pos_rat (d := d) q
  -- v = k / D^d
  have h_div := T5_rational_eval_eq_intCast_div q v k h_clear
  -- k ≠ 0 since v ≠ 0 and D^d ≠ 0
  have h_k_ne : k ≠ 0 := by
    intro hk
    apply h_nonzero
    rw [h_div, hk]
    simp
  -- |k| ≥ 1
  have h_k_abs : (1 : ℚ) ≤ |(k : ℚ)| := by
    have h1 : (1 : ℤ) ≤ |k| := Int.one_le_abs h_k_ne
    have h2 : |(k : ℚ)| = ((|k| : ℤ) : ℚ) := by
      rw [Int.cast_abs]
    rw [h2]
    exact_mod_cast h1
  -- |v| = |k| / D^d
  have h_abs : |v| = |(k : ℚ)| / ((commonDenom q : ℚ)) ^ d := by
    rw [h_div]
    rw [abs_div]
    congr 1
    exact abs_of_pos h_pos
  rw [h_abs]
  -- 1 / D^d ≤ |k| / D^d follows from 1 ≤ |k| and D^d > 0
  exact div_le_div_of_nonneg_right h_k_abs (le_of_lt h_pos)

/-! ## RationalEvalNonzeroLowerBound Prop scaffold -/

/-- **RationalEvalNonzeroLowerBound**: 3-conjunct Prop packaging the
    Liouville contradiction-lever direction. -/
def RationalEvalNonzeroLowerBound : Prop :=
  (∀ (k : ℤ), k ≠ 0 → 1 ≤ |k|) ∧
  (∀ {n d : ℕ} (q : Fin n → ℚ) (v : ℚ) (k : ℤ),
    ((commonDenom q : ℚ)) ^ d * v = (k : ℚ) →
    v = (k : ℚ) / ((commonDenom q : ℚ)) ^ d) ∧
  (∀ {n d : ℕ} (q : Fin n → ℚ) (v : ℚ) (k : ℤ),
    ((commonDenom q : ℚ)) ^ d * v = (k : ℚ) →
    v ≠ 0 →
    1 / ((commonDenom q : ℚ)) ^ d ≤ |v|)

/-- **🚨 Wave T5 session 559eeee — `RationalEvalNonzeroLowerBound`**. -/
theorem T5_rational_eval_nonzero_lower_bound_prop :
    RationalEvalNonzeroLowerBound :=
  ⟨T5_rational_eval_int_witness_pos_abs,
   @T5_rational_eval_eq_intCast_div,
   @T5_rational_eval_nonzero_lower_bound⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559eeee — T-5 Phase 7 ext #38:
    Liouville contradiction-lever lower bound (Gap B closure)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #38.

    🏆 Gap B PARTIAL closure (lower bound direction).

    Three derivations + Prop:
    1. `T5_rational_eval_int_witness_pos_abs` — |k| ≥ 1 from k ≠ 0
    2. `T5_rational_eval_eq_intCast_div` — division form structural
    3. `T5_rational_eval_nonzero_lower_bound` — main Liouville lower bound
    + RationalEvalNonzeroLowerBound Prop (3-conjunct).

    The CONTRADICTION-LEVER direction: given the integer-clearing
    hypothesis `(commonDenom q)^d · v = k : ℤ` and `v ≠ 0`,
    `|v| ≥ 1/(commonDenom q)^d`. This is the LOWER bound that
    combines with the Taylor / analytical UPPER bound (deferred to
    ext #39+) to force `v = 0` for q close to α — the Roth
    contradiction.

    Mathlib usage: `Int.one_le_abs`, `abs_div`, `abs_of_pos`,
    `div_le_div_iff`, `mul_le_mul_of_nonneg_right`.

    Sub-lemma 231/N in T-1 (T-5 Phase 7 ext #38).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 Liouville contradiction-lever
    lower bound (Gap B partial closure). -/
theorem session_559eeee_T5_phase7_liouville_lower_bound_headline :
    RationalEvalNonzeroLowerBound :=
  T5_rational_eval_nonzero_lower_bound_prop

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RationalEvalNonzeroLowerBound
