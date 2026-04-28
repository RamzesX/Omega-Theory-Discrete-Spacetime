/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowAtZero

  T-5 (Roth's theorem) — **🏆 PHASE 5 GRAND THEOREM:
  `rothIndex (X i^k) α d = k / d_i` when α_i = 0**, sub session 559oo
  — STRICT critical-path #316 (T-5) Phase 5 GRAND THEOREM.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  The **first non-trivial positive-index theorem** for the
  Roth-index polynomial calculus:

      `α i = 0 → rothIndex (X i^k) α d = (k : ℝ) / (d i : ℝ)`

  Direct application of `csInf_singleton` to the Phase 5 singleton
  characterization (s559nn).

  This is the climax of T-5 Phase 5.  The Roth-index of `X i^k`
  at a point with `α_i = 0` measures the order of vanishing
  weighted by `d_i`, returning exactly `k / d_i`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 5 GRAND THEOREM — first non-trivial rothIndex computation.
  T-5 critical path status post-s559oo:

  - Phase 1 (s68-s78): RothTheorem Prop ✓
  - Phase 2 ENTRY (s79-s93): MvPolynomial vocabulary ✓
  - Phase 3 FOUNDATION MASTER (s559v): Wronskian + Vandermonde ✓
  - Phase 4 EXTENDED MASTER (s559gg): rothIndex calculus +
    invariance group (ℝ\{0}, ·) ✓
  - Phase 5 SINGLETON CLOSURE (s559nn): rothIndexSet (X i^k) at
    α_i = 0 = {k/d_i} ✓
  - **Phase 5 GRAND THEOREM (s559oo, this file): rothIndex = k/d_i ✓**

  Phase 6+ remaining: translation invariance (via `bind₁` shift) +
  Siegel's lemma application + analytical bound assembly.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowSingleton

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowAtZero

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowSingleton

/-! ## Phase 5 GRAND THEOREM -/

/-- **🏆 Wave T5 session 559oo — Phase 5 GRAND THEOREM**:

      `α i = 0 → rothIndex (X i^k) α d = (k : ℝ) / (d i : ℝ)`

    First non-trivial positive-index computation for the Roth-index
    polynomial.  Direct application of `csInf_singleton` to the
    Phase 5 singleton characterization (s559nn).

    Combined with Phase 4 EXTENDED MASTER (rothIndex = 0 when
    aeval ≠ 0), this fully characterizes rothIndex on monomial
    families `X i^k` over ℝ. -/
theorem T5_rothIndex_X_pow_at_zero {n : ℕ}
    (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ) (hα : α i = 0) :
    rothIndex ((X i : MvPolynomial (Fin n) ℝ) ^ k) α d = (k : ℝ) / (d i : ℝ) := by
  unfold rothIndex
  rw [T5_rothIndexSet_X_pow_at_zero_eq_singleton i k α d hα]
  exact csInf_singleton _

/-! ## RothIndexXPowAtZero Prop scaffold -/

/-- **RothIndexXPowAtZero**: 1-conjunct Phase 5 GRAND THEOREM Prop. -/
def RothIndexXPowAtZero : Prop :=
  ∀ {n : ℕ} (i : Fin n) (k : ℕ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    α i = 0 →
    rothIndex ((X i : MvPolynomial (Fin n) ℝ) ^ k) α d = (k : ℝ) / (d i : ℝ)

/-- **🏆 Wave T5 session 559oo — `RothIndexXPowAtZero`**. -/
theorem T5_roth_index_X_pow_at_zero : RothIndexXPowAtZero :=
  @T5_rothIndex_X_pow_at_zero

/-! ## Concrete numerical witnesses -/

/-- **🏆 Wave T5 session 559oo — `rothIndex (X 0^2) 0 1 = 2`** (n = 1, k = 2). -/
theorem T5_rothIndex_X_0_pow_2_at_zero_d_1 :
    rothIndex ((X (0 : Fin 1) : MvPolynomial (Fin 1) ℝ) ^ 2)
      (fun _ => (0 : ℝ)) (fun _ => 1) = 2 := by
  rw [T5_rothIndex_X_pow_at_zero (0 : Fin 1) 2 (fun _ => 0) (fun _ => 1) rfl]
  norm_num

/-- **🏆 Wave T5 session 559oo — `rothIndex (X 0^3) 0 1 = 3`** (n = 1, k = 3). -/
theorem T5_rothIndex_X_0_pow_3_at_zero_d_1 :
    rothIndex ((X (0 : Fin 1) : MvPolynomial (Fin 1) ℝ) ^ 3)
      (fun _ => (0 : ℝ)) (fun _ => 1) = 3 := by
  rw [T5_rothIndex_X_pow_at_zero (0 : Fin 1) 3 (fun _ => 0) (fun _ => 1) rfl]
  norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559oo — T-5 Phase 5 GRAND THEOREM 🏆**.

    🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 5 GRAND THEOREM.

    `T5_rothIndex_X_pow_at_zero`: when `α_i = 0`,

        `rothIndex (X i^k) α d = (k : ℝ) / (d i : ℝ)`

    First non-trivial positive-index Roth-index computation in OV2.
    Composes the entire Phase 5 toolkit:
    - s559hh: cross-variable iterated pderiv vanishing
    - s559ii: pderiv-iterate on constants
    - s559jj: same-variable diagonal cases
    - s559kk: multi-pderiv positive case (foldr walk)
    - s559ll: explicit (⊇) witness
    - s559mm: vanishing complement (IsXiMonomialForm invariant)
    - s559nn: SINGLETON-SET CLOSURE
    - **s559oo (this): csInf_singleton → final theorem**

    + concrete witnesses:
    - rothIndex (X 0^2) (α=0) (d=1) = 2
    - rothIndex (X 0^3) (α=0) (d=1) = 3

    T-5 critical path status (cycle 65 day-of-record):
    - Phase 1 ✓ — Phase 2 ENTRY ✓ — Phase 3 FOUNDATION MASTER ✓
    - Phase 4 EXTENDED MASTER ✓ (invariance under (ℝ\{0}, ·))
    - **Phase 5 GRAND THEOREM ✓ — rothIndex (X i^k) at α_i=0 = k/d_i**

    Phase 6+ remaining: translation invariance (`bind₁` shift) +
    Siegel's lemma application + analytical bound assembly +
    Roth main theorem proper.

    Mathlib usage: `csInf_singleton`,
    `Set.eq_singleton_iff_unique_mem`, `Finset.sum_ite_eq'`,
    `Nat.descFactorial_self`, `Nat.factorial_pos`, `zero_pow`.

    Sub-lemma 189/N in T-1 (T-5 Phase 5 GRAND THEOREM 🏆).
    Lean-core only.

    🏆 First Lean-core T-5 Phase 5 non-trivial rothIndex
    closed-form computation. -/
theorem session_559oo_T5_phase5_grand_theorem_headline :
    RothIndexXPowAtZero :=
  T5_roth_index_X_pow_at_zero

end OmegaTheory.Irrationality.CustomMath.T5_Phase5_RothIndexXPowAtZero
