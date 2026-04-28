/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_ChooseDescFactorialBridge

  T-5 (Roth's theorem) — **Phase 7 ext #13: Nat.choose / Nat.descFactorial
  bridge for vanishing matrix entry**, sub session 559fff — STRICT
  critical-path #316 (T-5) Phase 7 ext #13.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Bridge between the integer-form `vanishingMatrixEntry` (using
  `Nat.choose`, integer-clean) and the descFactorial-form that
  matches `multiIteratedPDeriv` output:

      `(pderiv i)^[k] ((X i)^n) = (n.descFactorial k) · (X i)^(n-k)`
      (T5_Phase3_PDerivIterateXPow.lean:43)

  vs.

      `(1/I!) · ∂^I (X^s) |_α has integer form ∏ choose(s,I) · α^(s-I)`
      (this file's vanishingMatrixEntry)

  The bridge: `descFactorial n k = k.factorial * choose n k` (Mathlib
  `Nat.descFactorial_eq_factorial_mul_choose`).

  Two derivations + Prop:
  1. `T5_choose_factorial_eq_descFactorial`: per-component bridge
     `(choose n k : ℤ) * (factorial k : ℤ) = (descFactorial n k : ℤ)`
  2. `T5_vanishingMatrixEntry_factorial_eq_descFactorial_form`: full
     product bridge — each factor multiplied by `(I i).val.factorial`
     converts choose to descFactorial form

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #13 — choose/descFactorial bridge.

  This is the structural connector for ext #14 (full closed-form
  bridge to multiIteratedPDeriv): the per-component descFactorial
  form is what `(pderiv i)^[k] (X i^n) = descFactorial n k * X^(n-k)`
  produces directly, so the bridge lets us re-express our integer
  matrix entries in a form that aligns with T5_Phase3-Phase5
  multi-pderiv vocabulary.
-/

import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.LinearCombination
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_ChooseDescFactorialBridge

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BoundedMultiIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_VanishingMatrixEntry

/-! ## Per-component choose * factorial = descFactorial -/

/-- **🚨 Wave T5 session 559fff — `choose * factorial = descFactorial` (ℤ form)**.

    Mathlib's `Nat.descFactorial_eq_factorial_mul_choose` lifted to ℤ
    via `Nat.cast_mul`. -/
theorem T5_choose_factorial_eq_descFactorial (n k : ℕ) :
    (Nat.choose n k : ℤ) * (Nat.factorial k : ℤ)
      = (Nat.descFactorial n k : ℤ) := by
  rw [Nat.descFactorial_eq_factorial_mul_choose, Nat.cast_mul]
  exact mul_comm _ _

/-! ## Product form bridge -/

/-- **🚨 Wave T5 session 559fff — vanishingMatrixEntry × ∏ I!  =  descFactorial-form product**.

    Multiplying the integer matrix entry by the product of factorials
    of the index components converts the per-factor `choose` to
    `descFactorial`, matching `multiIteratedPDeriv` output. -/
theorem T5_vanishingMatrixEntry_factorial_eq_descFactorial_form
    {n d : ℕ} (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d) :
    vanishingMatrixEntry I α s *
      (∏ i : Fin n, (Nat.factorial (I i).val : ℤ))
      = ∏ i : Fin n, (Nat.descFactorial (s i).val (I i).val : ℤ) *
          (α i) ^ ((s i).val - (I i).val) := by
  unfold vanishingMatrixEntry
  rw [← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intro i _
  have h_bridge := T5_choose_factorial_eq_descFactorial (s i).val (I i).val
  rw [mul_right_comm]
  rw [h_bridge]

/-! ## ChooseDescFactorialBridge Prop scaffold -/

/-- **ChooseDescFactorialBridge**: 2-conjunct Prop packaging the
    per-component + product-form bridges. -/
def ChooseDescFactorialBridge : Prop :=
  (∀ (n k : ℕ),
    (Nat.choose n k : ℤ) * (Nat.factorial k : ℤ)
      = (Nat.descFactorial n k : ℤ)) ∧
  (∀ {n d : ℕ} (I : BoundedMI n d) (α : Fin n → ℤ) (s : BoundedMI n d),
    vanishingMatrixEntry I α s *
      (∏ i : Fin n, (Nat.factorial (I i).val : ℤ))
      = ∏ i : Fin n, (Nat.descFactorial (s i).val (I i).val : ℤ) *
          (α i) ^ ((s i).val - (I i).val))

/-- **🚨 Wave T5 session 559fff — `ChooseDescFactorialBridge`**. -/
theorem T5_choose_descFactorial_bridge : ChooseDescFactorialBridge :=
  ⟨T5_choose_factorial_eq_descFactorial,
   @T5_vanishingMatrixEntry_factorial_eq_descFactorial_form⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559fff — T-5 Phase 7 ext #13: choose/descFactorial bridge**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #13.

    Bridge between integer-form (using `Nat.choose`) and
    descFactorial-form of the vanishing matrix entry — connector for
    ext #14+ where the descFactorial form aligns with
    `multiIteratedPDeriv` output (T5_Phase3_PDerivIterateXPow:
    `(pderiv i)^[k] ((X i)^n) = descFactorial n k · X^(n-k)`).

    Two derivations + Prop:
    1. `T5_choose_factorial_eq_descFactorial` — per-component
       `choose * factorial = descFactorial` (ℤ-cast)
    2. `T5_vanishingMatrixEntry_factorial_eq_descFactorial_form` —
       full product bridge via `Finset.prod_mul_distrib`
    + ChooseDescFactorialBridge Prop (2-conjunct).

    Mathlib usage: `Nat.descFactorial_eq_factorial_mul_choose`,
    `Finset.prod_mul_distrib`, `push_cast` for ℕ→ℤ.

    Sub-lemma 206/N in T-1 (T-5 Phase 7 ext #13).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 choose↔descFactorial integer
    matrix entry bridge. -/
theorem session_559fff_T5_phase7_choose_descFactorial_bridge_headline :
    ChooseDescFactorialBridge :=
  T5_choose_descFactorial_bridge

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_ChooseDescFactorialBridge
