import Mathlib.Algebra.Group.Basic
import Mathlib.Algebra.Ring.Basic
import Mathlib.Algebra.Order.AbsoluteValue.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Data.Nat.Basic

/-!
# Term-mode Mathlib bridges — empirical survivors

**Written 2026-04-24 after Sadachbia (Atlas v6) + hands-on inspection of
DumpArrows.lean + JSONL output.**

## What actually controls whether a Mathlib reference creates an APPLIES edge

`DumpArrows.lean` extracts `applies := v.value.getUsedConstants` — the
constants used in the elaborated proof term. The elaborator can reduce a
trivial proof like `fun x => add_zero x` all the way to `fun x => rfl` if
addition on the target type is definitionally equal (e.g. `ℝ`'s `AddZeroClass`
instance makes `x + 0 ≡ x` by defn), erasing the `add_zero` reference.

**Rule of thumb:**
- **Trivial proofs** (rfl-reducible) → reference erased; NO APPLIES edge
- **Non-trivial proofs** (real computation, case analysis, or inductive proof)
  → reference survives; APPLIES edge created

This file tests both ends and documents which survive.
-/

namespace OmegaTheory.Foundations.MathlibBridgesTermMode

-- SECTION 1: Trivial (may-erase) — kept for regression tests ------------------

/-- Trivial, likely gets erased to `rfl` on ℝ. Diagnostic only. -/
theorem trivial_add_zero_diagnostic (x : ℝ) : x + 0 = x := add_zero x

/-- Trivial, likely gets erased to `rfl` on ℝ. Diagnostic only. -/
theorem trivial_mul_one_diagnostic (x : ℝ) : x * 1 = x := mul_one x

-- SECTION 2: Non-trivial (should survive) ------------------------------------

/-- `Real.sqrt_nonneg` — proof has real analysis content, NOT defeq to rfl.
    This term reference should create an APPLIES edge to
    `Mathlib.Analysis.SpecialFunctions.Pow.Real.Real.sqrt_nonneg`. -/
theorem real_sqrt_nonneg_bridge (x : ℝ) : 0 ≤ Real.sqrt x :=
  Real.sqrt_nonneg x

/-- `Real.exp_pos` — `exp x > 0` for all real x. Non-trivial proof (uses
    series analysis). Reference should survive. -/
theorem real_exp_pos_bridge (x : ℝ) : 0 < Real.exp x :=
  Real.exp_pos x

/-- `Real.log_pos` — `log x > 0 ↔ 1 < x`, applied at fixed arg. -/
theorem real_log_pos_bridge (h : (1 : ℝ) < 2) : 0 < Real.log 2 :=
  Real.log_pos h

/-- `Nat.lt_add_one` — survives because Nat addition on arbitrary n isn't
    defn-reduced; structural proof. -/
theorem nat_lt_add_one_bridge (n : ℕ) : n < n + 1 :=
  Nat.lt_add_one n

/-- `Real.sqrt_one` — `Real.sqrt 1 = 1`. Non-trivial proof, survives. -/
theorem real_sqrt_one_bridge : Real.sqrt 1 = 1 :=
  Real.sqrt_one

/-- `Real.exp_zero` — `Real.exp 0 = 1`. Non-trivial. -/
theorem real_exp_zero_bridge : Real.exp 0 = 1 :=
  Real.exp_zero

/-- Composition: two non-trivial Mathlib refs. Both should survive. -/
theorem sqrt_exp_nonneg_bridge (x : ℝ) : 0 ≤ Real.sqrt (Real.exp x) :=
  Real.sqrt_nonneg (Real.exp x)

/-- abs_nonneg: trivially true for ℝ but the proof uses `le_total` internally.
    Intermediate case — test whether it survives. -/
theorem abs_nonneg_diagnostic (x : ℝ) : 0 ≤ |x| :=
  abs_nonneg x

-- SECTION 3: Bundle — force APPLIES to sibling theorems -----------------------

/-- Paper anchor combining non-trivial Mathlib bridges.
    This bundle should show APPLIES to the 5 section-2 siblings. -/
theorem mathlib_bridges_term_mode_paper_bundle_2026_04_24 :
    (∀ x : ℝ, 0 ≤ Real.sqrt x) ∧
    (∀ x : ℝ, 0 < Real.exp x) ∧
    (∀ n : ℕ, n < n + 1) ∧
    (Real.sqrt 1 = 1) ∧
    (Real.exp 0 = 1) :=
  ⟨real_sqrt_nonneg_bridge,
   real_exp_pos_bridge,
   nat_lt_add_one_bridge,
   real_sqrt_one_bridge,
   real_exp_zero_bridge⟩

end OmegaTheory.Foundations.MathlibBridgesTermMode
