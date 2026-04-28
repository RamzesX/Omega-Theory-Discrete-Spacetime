/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNeg

  T-5 (Roth's theorem) — **Phase 4 ext #4: rothIndex negation
  invariance**, sub session 559ee — STRICT critical-path #316
  (T-5) Phase 4 ext #4.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Sign invariance of the Roth-index polynomial:

      `rothIndex (-P) α d = rothIndex P α d`

  Proof: by establishing the multi-iterated-pderiv linearity:
  - `(pderiv k)^[m] (-P) = -(pderiv k)^[m] P` (induction on m)
  - `(List.foldr ...) (-P) = -(List.foldr ...) P` (induction on list)
  - `multiIteratedPDeriv j (-P) = -multiIteratedPDeriv j P`
  - hence aeval α applied to either preserves ≠ 0 (since `-x ≠ 0 ↔ x ≠ 0`)
  - hence the rothIndexSet for `-P` equals the rothIndexSet for `P`
  - hence sInf is equal.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 4 ext #4 — symmetry property.  Useful in Roth-Schmidt-Wirsing
  arguments where polynomials and their negations are interchangeable.
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNeg

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## Iterate-pderiv-negation -/

/-- **🚨 Wave T5 session 559ee — `(pderiv k)^[m] (-P) = -(pderiv k)^[m] P`**.

    Iterated partial derivative commutes with negation, by induction
    on the iteration count `m`. -/
theorem T5_iterate_pderiv_neg {n : ℕ} (k : Fin n) (m : ℕ)
    (P : MvPolynomial (Fin n) ℝ) :
    (pderiv k)^[m] (-P) = -(pderiv k)^[m] P := by
  induction m with
  | zero => simp
  | succ m ih =>
    simp only [Function.iterate_succ_apply', ih, Derivation.map_neg]

/-! ## List-foldr commutes with negation -/

/-- **🚨 Wave T5 session 559ee — list-foldr of iterated pderivs commutes with negation**. -/
theorem T5_foldr_pderiv_neg {n : ℕ} (l : List (Fin n)) (j : Fin n → ℕ)
    (P : MvPolynomial (Fin n) ℝ) :
    l.foldr (fun k q => (pderiv k)^[j k] q) (-P) =
    -(l.foldr (fun k q => (pderiv k)^[j k] q) P) := by
  induction l with
  | nil => simp
  | cons k l ih =>
    rw [List.foldr_cons, List.foldr_cons, ih]
    exact T5_iterate_pderiv_neg k (j k) _

/-! ## multiIteratedPDeriv-negation -/

/-- **🚨 Wave T5 session 559ee — `multiIteratedPDeriv j (-P) = -multiIteratedPDeriv j P`**. -/
theorem T5_multiIteratedPDeriv_neg {n : ℕ} (j : Fin n → ℕ)
    (P : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv j (-P) = -multiIteratedPDeriv j P := by
  unfold multiIteratedPDeriv
  exact T5_foldr_pderiv_neg (List.finRange n) j P

/-! ## rothIndex set equality under negation -/

/-- **🚨 Wave T5 session 559ee — Roth-index indexing sets equal for `P` and `-P`**. -/
theorem T5_rothIndex_set_neg {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j (-P)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } =
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
  ext r
  constructor
  · rintro ⟨j, hne, hreq⟩
    refine ⟨j, ?_, hreq⟩
    rw [T5_multiIteratedPDeriv_neg, map_neg] at hne
    intro heq
    apply hne
    rw [heq]; ring
  · rintro ⟨j, hne, hreq⟩
    refine ⟨j, ?_, hreq⟩
    rw [T5_multiIteratedPDeriv_neg, map_neg]
    intro heq
    apply hne
    linarith

/-! ## rothIndex negation invariance -/

/-- **🚨 Wave T5 session 559ee — `rothIndex (-P) α d = rothIndex P α d`**.

    The Roth-index is invariant under polynomial negation, since the
    indexing set is identical (the `≠ 0` condition is sign-blind). -/
theorem T5_rothIndex_neg {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    rothIndex (-P) α d = rothIndex P α d := by
  unfold rothIndex
  rw [T5_rothIndex_set_neg]

/-! ## RothIndexNeg Prop scaffold -/

/-- **RothIndexNeg**: 1-conjunct Prop packaging the rothIndex negation
    invariance. -/
def RothIndexNeg : Prop :=
  ∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    rothIndex (-P) α d = rothIndex P α d

/-- **🚨 Wave T5 session 559ee — `RothIndexNeg`**. -/
theorem T5_roth_index_neg : RothIndexNeg :=
  @T5_rothIndex_neg

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ee — T-5 Phase 4 ext #4: rothIndex negation invariance**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 ext #4.

    Establishes `rothIndex (-P) α d = rothIndex P α d` via:
    1. `T5_iterate_pderiv_neg`: iterated pderiv preserves negation
    2. `T5_foldr_pderiv_neg`: list-foldr preserves negation
    3. `T5_multiIteratedPDeriv_neg`: multi-pderiv preserves negation
    4. `T5_rothIndex_set_neg`: indexing sets equal for ±P
    5. `T5_rothIndex_neg`: **the master invariance theorem**
    + RothIndexNeg Prop (1-conjunct).

    Mathlib usage: `Function.iterate_succ_apply'`, `map_neg` (from
    Derivation/LinearMap), `List.foldr_cons`.

    Sub-lemma 179/N in T-1 (T-5 Phase 4 ext #4).  Lean-core only.

    🏆 First Lean-core T-5 Phase 4 rothIndex sign-invariance. -/
theorem session_559ee_T5_phase4_roth_index_neg_headline :
    RothIndexNeg :=
  T5_roth_index_neg

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNeg
