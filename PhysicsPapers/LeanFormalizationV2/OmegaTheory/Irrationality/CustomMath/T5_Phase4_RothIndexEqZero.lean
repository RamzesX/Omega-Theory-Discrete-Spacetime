/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero

  T-5 (Roth's theorem) — **Phase 4 INTERIM MASTER: `rothIndex = 0`
  when polynomial doesn't vanish at α**, sub session 559bb — STRICT
  critical-path #316 (T-5) Phase 4 ext #3.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  The fundamental Roth-index property:

      `aeval α P ≠ 0 → rothIndex P α d = 0`

  This is the **Phase 4 interim master**, composing:
  - s559y `rothIndex` definition + multiIteratedPDeriv shorthand
  - s559z non-negativity (set-member, BddBelow)
  - s559aa zero-J identity + non-empty witness via j = 0

  Proof: by `le_antisymm`:
  - `rothIndex ≤ 0` because `0 ∈ rothIndexSet` (s559aa) and the set
    is bounded below by 0 (s559z).  Apply `csInf_le`.
  - `0 ≤ rothIndex` because every set member is ≥ 0 (s559z) and the
    set is non-empty (s559aa witness).  Apply `le_csInf`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 4 interim master.  This is the FIRST concrete `rothIndex`
  *value* theorem (not just structural).  With this in place:
  - rothIndex of vanishing polynomial = 0 (s559y)
  - rothIndex of non-vanishing polynomial = 0 (this file)
  - the only way for `rothIndex` to be > 0 is when P vanishes at α
    AND has some non-vanishing iterated partial derivative there.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import Mathlib.Order.ConditionallyCompleteLattice.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

/-! ## Phase 4 interim master -/

/-- **🚨 Wave T5 session 559bb — `rothIndex P α d = 0` when `aeval α P ≠ 0`**.

    The Roth-index of a polynomial `P` not vanishing at `α` is zero,
    by the j = 0 witness:

        - `j = 0` gives `multiIteratedPDeriv 0 P = P` (s559aa)
        - hence `aeval α (multiIteratedPDeriv 0 P) = aeval α P ≠ 0`
        - and `r = ∑ i, 0 / d_i = 0` (the sum is zero)
        - so `0 ∈ rothIndexSet`

    Combined with `BddBelow` (every set member ≥ 0, s559z), `csInf`
    machinery delivers `rothIndex = 0`.

    This is the foundational example for the index calculus. -/
theorem T5_rothIndex_eq_zero_of_aeval_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (hα : aeval α P ≠ 0) :
    rothIndex P α d = 0 := by
  unfold rothIndex
  apply le_antisymm
  · -- sInf set ≤ 0
    apply csInf_le
    · -- BddBelow: every member ≥ 0
      refine ⟨0, ?_⟩
      intro r hr
      exact T5_rothIndex_setMember_nonneg P α d r hr
    · exact T5_rothIndex_setMember_zero_of_aeval_ne_zero P α d hα
  · -- 0 ≤ sInf set
    apply le_csInf
    · exact ⟨0, T5_rothIndex_setMember_zero_of_aeval_ne_zero P α d hα⟩
    · intro b hb
      exact T5_rothIndex_setMember_nonneg P α d b hb

/-! ## RothIndexEqZero Prop scaffold -/

/-- **RothIndexEqZero**: 1-conjunct interim-master Prop. -/
def RothIndexEqZero : Prop :=
  ∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    aeval α P ≠ 0 → rothIndex P α d = 0

/-- **🚨 Wave T5 session 559bb — `RothIndexEqZero`**. -/
theorem T5_roth_index_eq_zero : RothIndexEqZero :=
  @T5_rothIndex_eq_zero_of_aeval_ne_zero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bb — T-5 Phase 4 INTERIM MASTER: rothIndex = 0**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 INTERIM MASTER.

    First concrete `rothIndex`-VALUE theorem in OV2:

        `aeval α P ≠ 0 → rothIndex P α d = 0`

    Composes the Phase 4 foundation:
    1. s559y rothIndex definition + multiIteratedPDeriv
    2. s559z non-negativity (BddBelow)
    3. s559aa zero-J + non-empty witness
    4. **(this) interim master via `csInf_le` + `le_csInf`**

    Phase 4 status now: foundation COMPLETE for the trivial case.
    Future iterations target the **interesting case** where P
    vanishes at α (so rothIndex > 0 measures the depth of vanishing).

    Mathlib usage: `csInf_le`, `le_csInf`, `BddBelow`, `Set.Nonempty`,
    `le_antisymm`.

    Sub-lemma 176/N in T-1 (T-5 Phase 4 INTERIM MASTER).
    Lean-core only.

    🏆 First Lean-core T-5 Phase 4 rothIndex-value computation. -/
theorem session_559bb_T5_phase4_roth_index_eq_zero_headline :
    RothIndexEqZero :=
  T5_roth_index_eq_zero

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero
