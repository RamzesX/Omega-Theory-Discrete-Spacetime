/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexExamples

  T-5 (Roth's theorem) — **Phase 4 ext #3: concrete rothIndex
  computations on simple polynomials**, sub session 559dd —
  STRICT critical-path #316 (T-5) Phase 4 ext #3.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Three concrete rothIndex computations leveraging the Phase 4
  interim master (s559bb):

  1. **`T5_rothIndex_const`** : `c ≠ 0 → rothIndex (C c) α d = 0`
  2. **`T5_rothIndex_one`** : `rothIndex 1 α d = 0` (specialization)
  3. **`T5_rothIndex_X_at_nonzero`** :
     `α i ≠ 0 → rothIndex (X i) α d = 0`

  All follow directly from s559bb (`aeval α P ≠ 0 → rothIndex = 0`)
  by computing the aeval value at the simple polynomial.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 4 ext #3 — concrete witnesses.  These show that rothIndex
  is "trivial" (= 0) on the simplest polynomial classes.  The
  *interesting* rothIndex > 0 case requires P to vanish at α with
  positive multiplicity, which is the Phase 5+ frontier.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexExamples

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero

/-! ## Constant polynomial -/

/-- **🚨 Wave T5 session 559dd — `rothIndex (C c) α d = 0` for `c ≠ 0`**.

    For a non-zero constant polynomial `C c : MvPolynomial (Fin n) ℝ`,
    `aeval α (C c) = c ≠ 0`, so by s559bb the index is 0. -/
theorem T5_rothIndex_const {n : ℕ}
    (c : ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) (hc : c ≠ 0) :
    rothIndex (C c : MvPolynomial (Fin n) ℝ) α d = 0 := by
  apply T5_rothIndex_eq_zero_of_aeval_ne_zero
  rw [MvPolynomial.aeval_C]
  simp [hc]

/-! ## Unit polynomial -/

/-- **🚨 Wave T5 session 559dd — `rothIndex 1 α d = 0`**.

    For the unit polynomial `1 : MvPolynomial (Fin n) ℝ`,
    `aeval α 1 = 1 ≠ 0`, so the index is 0. -/
theorem T5_rothIndex_one {n : ℕ}
    (α : Fin n → ℝ) (d : Fin n → ℕ) :
    rothIndex (1 : MvPolynomial (Fin n) ℝ) α d = 0 := by
  apply T5_rothIndex_eq_zero_of_aeval_ne_zero
  simp

/-! ## Single variable polynomial -/

/-- **🚨 Wave T5 session 559dd — `rothIndex (X i) α d = 0` when `α i ≠ 0`**.

    For the single-variable polynomial `X i : MvPolynomial (Fin n) ℝ`,
    `aeval α (X i) = α i`, which is non-zero by hypothesis, so the
    index is 0. -/
theorem T5_rothIndex_X_at_nonzero {n : ℕ}
    (i : Fin n) (α : Fin n → ℝ) (d : Fin n → ℕ) (hα : α i ≠ 0) :
    rothIndex (X i : MvPolynomial (Fin n) ℝ) α d = 0 := by
  apply T5_rothIndex_eq_zero_of_aeval_ne_zero
  rw [MvPolynomial.aeval_X]
  exact hα

/-! ## RothIndexExamples Prop scaffold -/

/-- **RothIndexExamples**: 3-conjunct Prop packaging concrete
    rothIndex examples on simple polynomials. -/
def RothIndexExamples : Prop :=
  (∀ {n : ℕ} (c : ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    c ≠ 0 → rothIndex (C c : MvPolynomial (Fin n) ℝ) α d = 0) ∧
  (∀ {n : ℕ} (α : Fin n → ℝ) (d : Fin n → ℕ),
    rothIndex (1 : MvPolynomial (Fin n) ℝ) α d = 0) ∧
  (∀ {n : ℕ} (i : Fin n) (α : Fin n → ℝ) (d : Fin n → ℕ),
    α i ≠ 0 → rothIndex (X i : MvPolynomial (Fin n) ℝ) α d = 0)

/-- **🚨 Wave T5 session 559dd — `RothIndexExamples`**. -/
theorem T5_roth_index_examples : RothIndexExamples :=
  ⟨@T5_rothIndex_const,
   @T5_rothIndex_one,
   @T5_rothIndex_X_at_nonzero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559dd — T-5 Phase 4 ext #3: rothIndex examples**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 ext #3.

    Three concrete rothIndex computations + Prop:
    1. `T5_rothIndex_const`: `c ≠ 0 → rothIndex (C c) α d = 0`
    2. `T5_rothIndex_one`: `rothIndex 1 α d = 0`
    3. `T5_rothIndex_X_at_nonzero`:
       `α i ≠ 0 → rothIndex (X i) α d = 0`
    + RothIndexExamples Prop (3-conjunct).

    All follow directly from the Phase 4 interim master s559bb
    (`aeval α P ≠ 0 → rothIndex = 0`) by computing aeval at the
    specific polynomial.  The MvPolynomial `aeval_C` and `aeval_X`
    Mathlib API discharges the values.

    Phase 4 status: foundation MASTER (s559cc) + concrete witness
    examples (this file).  The interesting Roth case (rothIndex > 0
    via P vanishing at α with positive multiplicity) remains in
    Phase 5+.

    Mathlib usage: `MvPolynomial.aeval_C`, `MvPolynomial.aeval_X`,
    `simp` on `algebraMap ℝ ℝ`.

    Sub-lemma 178/N in T-1 (T-5 Phase 4 ext #3).  Lean-core only.

    🏆 First Lean-core T-5 Phase 4 rothIndex examples on simple
    polynomials. -/
theorem session_559dd_T5_phase4_roth_index_examples_headline :
    RothIndexExamples :=
  T5_roth_index_examples

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexExamples
