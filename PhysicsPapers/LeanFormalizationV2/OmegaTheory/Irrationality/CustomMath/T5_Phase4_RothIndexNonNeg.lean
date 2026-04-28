/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

  T-5 (Roth's theorem) — **Phase 4 sub: Roth-index non-negativity**,
  sub session 559z — STRICT critical-path #316 (T-5) Phase 4 ext #1.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Foundational non-negativity for the Roth-index indexing set:

      ∀ r ∈ rothIndexSet P α d, 0 ≤ r

  Proof: each summand `(j i : ℝ) / (d i : ℝ)` has `j i ≥ 0` and
  `d i ≥ 0`, so the ratio is ≥ 0 in ℝ (Mathlib's `x / 0 = 0` clause
  preserves the non-negativity).  Sum of non-negatives is non-negative.

  Three derivations + Prop:
  - `T5_rothIndex_summand_nonneg` : each `j_i / d_i ≥ 0`
  - `T5_rothIndex_setMember_nonneg` : every set member ≥ 0
  - `T5_rothIndex_set_subset_nonneg` : the indexing set ⊆ [0, ∞)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 4 ext #1 — non-negativity preparation.  With this lemma in
  place, future iterations can prove `0 ≤ rothIndex P α d` (which
  needs `BddBelow` + `Set.Nonempty` for non-zero P, plus the
  `csInf_le` API).
-/

import Mathlib.Algebra.MvPolynomial.PDeriv
import Mathlib.Algebra.MvPolynomial.Eval
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## Per-summand non-negativity -/

/-- **🚨 Wave T5 session 559z — `(j_i : ℝ) / (d_i : ℝ) ≥ 0`**.

    Each summand of the Roth-index ratio is non-negative because
    `j i : ℕ` and `d i : ℕ` cast to non-negative reals; division
    of non-negatives is non-negative (Mathlib's `x / 0 = 0`
    convention preserves this in the degenerate case). -/
theorem T5_rothIndex_summand_nonneg {n : ℕ}
    (j : Fin n → ℕ) (d : Fin n → ℕ) (i : Fin n) :
    0 ≤ (j i : ℝ) / (d i : ℝ) := by
  apply div_nonneg <;> exact Nat.cast_nonneg _

/-! ## Set-member non-negativity -/

/-- **🚨 Wave T5 session 559z — Roth-index set members are non-negative**.

    For any `r` in the Roth-index indexing set
    `{ r : ℝ | ∃ j, ... ∧ r = ∑ i, j_i / d_i }`,
    we have `0 ≤ r`. -/
theorem T5_rothIndex_setMember_nonneg {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (r : ℝ)
    (hr : r ∈ { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) }) :
    0 ≤ r := by
  obtain ⟨j, _, hreq⟩ := hr
  rw [hreq]
  apply Finset.sum_nonneg
  intro i _
  exact T5_rothIndex_summand_nonneg j d i

/-! ## Set-level subset relation -/

/-- **🚨 Wave T5 session 559z — Roth-index indexing set ⊆ [0, ∞)**. -/
theorem T5_rothIndex_set_subset_nonneg {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } ⊆ Set.Ici (0 : ℝ) := by
  intro r hr
  exact T5_rothIndex_setMember_nonneg P α d r hr

/-! ## RothIndexNonNeg Prop scaffold -/

/-- **RothIndexNonNeg**: 3-conjunct Prop packaging the Roth-index
    non-negativity foundation. -/
def RothIndexNonNeg : Prop :=
  (∀ {n : ℕ} (j : Fin n → ℕ) (d : Fin n → ℕ) (i : Fin n),
    (0 : ℝ) ≤ (j i : ℝ) / (d i : ℝ)) ∧
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (r : ℝ),
    r ∈ { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } → 0 ≤ r) ∧
  (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
    { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } ⊆ Set.Ici (0 : ℝ))

/-- **🚨 Wave T5 session 559z — `RothIndexNonNeg`**. -/
theorem T5_roth_index_nonneg : RothIndexNonNeg :=
  ⟨@T5_rothIndex_summand_nonneg,
   @T5_rothIndex_setMember_nonneg,
   @T5_rothIndex_set_subset_nonneg⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559z — T-5 Phase 4 ext #1: Roth-index non-negativity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 4 ext #1.

    Three derivations + Prop:
    1. `T5_rothIndex_summand_nonneg`: per-summand `j_i / d_i ≥ 0`
    2. `T5_rothIndex_setMember_nonneg`: any indexing-set member ≥ 0
    3. `T5_rothIndex_set_subset_nonneg`: indexing set ⊆ [0, ∞)
    + RothIndexNonNeg Prop (3-conjunct).

    Phase 4 foundation deepens: with set-level non-negativity, the
    Mathlib `csInf` API on `Set.Ici 0`-bounded subsets gives
    `0 ≤ rothIndex P α d` whenever the set is non-empty (i.e. P ≠ 0
    and not vanishing identically at α).

    Mathlib usage: `div_nonneg`, `Nat.cast_nonneg`, `Finset.sum_nonneg`,
    `Set.Ici`, `Set.subset_def`.

    Sub-lemma 174/N in T-1 (T-5 Phase 4 ext #1).  Lean-core only.

    🏆 First Lean-core T-5 Phase 4 Roth-index non-negativity. -/
theorem session_559z_T5_phase4_roth_index_nonneg_headline :
    RothIndexNonNeg :=
  T5_roth_index_nonneg

end OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg
