/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

  T-5 (Roth's theorem) — **Phase 4 ext #2: zero-multi-index identity
  + non-empty witness for the Roth-index indexing set**, sub session
  559aa — STRICT critical-path #316 (T-5) Phase 4 ext #2.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Two foundational identities for `multiIteratedPDeriv` at the
  zero multi-index `j = 0`:

  1. **`T5_multiIteratedPDeriv_zeroJ`** : `multiIteratedPDeriv 0 P = P`
     (no derivatives applied = identity), via `Function.iterate_zero`
     + List.foldr induction.
  2. **`T5_rothIndex_setMember_zero_of_aeval_ne_zero`** : if
     `aeval α P ≠ 0`, then `(0 : ℝ) ∈ rothIndexSet`, witnessed by
     `j = 0` (so the set is **non-empty**).

  Together with s559z (set ⊆ Set.Ici 0), these give:
      `aeval α P ≠ 0 → rothIndex P α d ≤ 0 ≤ rothIndex P α d`
  i.e., `rothIndex P α d = 0` when P doesn't vanish at α (a
  fundamental property of the Roth-index calculus).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 4 ext #2 — non-empty witness foundation.  With this lemma in
  place, the Roth-index polynomial vocabulary now has BOTH bounds:
  empty-set (s559y) `→ rothIndex = 0` and non-empty witness (this file)
  `→ 0 ∈ set` thus `rothIndex ≤ 0`.

  Future iterations: bounded-below ↔ non-vanishing-at-some-index +
  csInf membership for non-empty cases.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import Mathlib.Logic.Function.Iterate
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## Multi-index zero identity -/

/-- **🚨 Wave T5 session 559aa — `multiIteratedPDeriv 0 P = P`**.

    With the zero multi-index, no partial derivatives are applied
    along any variable, so the iterate reduces to identity at each
    step of the List-foldr.  Hence the result is `P` itself. -/
theorem T5_multiIteratedPDeriv_zeroJ {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv (fun _ : Fin n => 0) P = P := by
  unfold multiIteratedPDeriv
  -- Reduce to: (List.finRange n).foldr (fun k q => q) P = P
  -- since (pderiv k)^[0] = id
  have h : ∀ (l : List (Fin n)),
      l.foldr (fun k q => (pderiv k)^[(fun _ : Fin n => 0) k] q) P = P := by
    intro l
    induction l with
    | nil => simp
    | cons k l ih =>
      rw [List.foldr_cons]
      simp only [Function.iterate_zero, id_eq]
      exact ih
  exact h (List.finRange n)

/-! ## Set-member witness via j = 0 -/

/-- **🚨 Wave T5 session 559aa — Roth-index set contains 0 when aeval α P ≠ 0**.

    For any polynomial `P` with `aeval α P ≠ 0`, the multi-index
    `j = 0` witnesses the membership of `r = 0` in the Roth-index
    indexing set:

        - `multiIteratedPDeriv 0 P = P` (no derivatives applied)
        - hence `aeval α (multiIteratedPDeriv 0 P) = aeval α P ≠ 0`
        - and `∑ i, (0 : ℝ) / (d i : ℝ) = 0`. -/
theorem T5_rothIndex_setMember_zero_of_aeval_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (hα : aeval α P ≠ 0) :
    (0 : ℝ) ∈ { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
  refine ⟨fun _ : Fin n => 0, ?_, ?_⟩
  · rw [T5_multiIteratedPDeriv_zeroJ]
    exact hα
  · simp

/-! ## RothIndexZeroJ Prop scaffold -/

/-- **RothIndexZeroJ**: 2-conjunct Prop packaging the zero-multi-index
    identity + non-empty witness foundation. -/
def RothIndexZeroJ : Prop :=
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ),
    multiIteratedPDeriv (fun _ : Fin n => 0) P = P) ∧
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    aeval α P ≠ 0 →
    (0 : ℝ) ∈ { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) })

/-- **🚨 Wave T5 session 559aa — `RothIndexZeroJ`**. -/
theorem T5_roth_index_zero_j : RothIndexZeroJ :=
  ⟨@T5_multiIteratedPDeriv_zeroJ,
   @T5_rothIndex_setMember_zero_of_aeval_ne_zero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aa — T-5 Phase 4 ext #2: zero-J identity + non-empty witness**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 ext #2.

    Two foundational identities + Prop:
    1. `T5_multiIteratedPDeriv_zeroJ`: `multiIteratedPDeriv 0 P = P`
    2. `T5_rothIndex_setMember_zero_of_aeval_ne_zero`:
       `aeval α P ≠ 0 → (0 : ℝ) ∈ rothIndexSet`
    + RothIndexZeroJ Prop (2-conjunct).

    Phase 4 foundation now has BOTH halves:
    - empty-set (s559y) → rothIndex = 0 for P = 0
    - non-empty witness (this file) → 0 ∈ set when `aeval α P ≠ 0`,
      thus `rothIndex P α d ≤ 0`, combined with non-neg (s559z)
      `→ rothIndex P α d = 0`.

    Mathlib usage: `Function.iterate_zero`, `List.foldr_cons`,
    `MvPolynomial.aeval`, set-builder + Finset.sum.

    Sub-lemma 175/N in T-1 (T-5 Phase 4 ext #2).  Lean-core only.

    🏆 First Lean-core T-5 Phase 4 zero-J + non-empty witness. -/
theorem session_559aa_T5_phase4_roth_index_zero_j_headline :
    RothIndexZeroJ :=
  T5_roth_index_zero_j

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
