/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

  T-5 (Roth's theorem) — **D.7 Block D foundation: rothIndex positivity ⇒ vanishing**.

  Three tier-99 contrapositive sub-lemmas of `T5_rothIndex_eq_zero_of_aeval_ne_zero`,
  preparing the integer-non-vanishing argument of D.7 Block D (Hindry-Silverman D.7
  contradiction bridge).

  Strategic context (per `~/.claude/plans/binary-painting-dijkstra.md` 2026-04-30):
  - Atom 2 (`T5_RothBoundLargeFromMasterAndPigeonhole`) closure needs
    Blocks C / D / E / F.  Block D is "integer non-vanishing lower bound":
    `P ∈ ℤ[X], P(q-tuple) ≠ 0 ⇒ |P(q-tuple)| ≥ ∏ d_i^{-R_i}`.
  - The non-vanishing input `P(q-tuple) ≠ 0` is what these contrapositives prepare.
  - Tier-99 (99+% true, routine): direct logical contrapositive via `not_imp_not`.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

open Real
open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

/-! ## D-pre-1 — `rothIndex > 0 ⇒ aeval α P = 0` (strict positivity contrapositive) -/

/-- **D-pre-1 — `T5_rothIndex_pos_implies_aeval_zero`**: contrapositive of
    `T5_rothIndex_eq_zero_of_aeval_ne_zero`.  If the Roth-index is strictly
    positive at `α`, then `P` vanishes at `α`.

    Proof: contrapositive — if `aeval α P ≠ 0`, then `rothIndex P α d = 0`
    by the existing Phase-4 INTERIM MASTER (s559bb), which contradicts
    the strict-positivity hypothesis.

    Tier-99 sub-lemma per Phase B truth-rank.  Used downstream by D.7
    Block D (integer non-vanishing) when combining the Schmidt aux poly
    with the index-reduction inequality. -/
theorem T5_rothIndex_pos_implies_aeval_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h_pos : 0 < rothIndex P α d) :
    aeval α P = 0 := by
  by_contra h_ne
  have h_eq : rothIndex P α d = 0 :=
    T5_rothIndex_eq_zero_of_aeval_ne_zero P α d h_ne
  rw [h_eq] at h_pos
  exact lt_irrefl 0 h_pos

/-! ## D-pre-2 — `rothIndex ≠ 0 ⇒ aeval α P = 0` (the same statement in `≠ 0` form) -/

/-- **D-pre-2 — `T5_rothIndex_ne_zero_implies_aeval_zero`**: alternate form
    of D-pre-1 using `≠ 0` instead of `0 <`.  Useful when the hypothesis
    is given in non-equality form (no positivity already in scope).

    Note: `rothIndex ≥ 0` always (Phase 4 foundation), so `≠ 0` ⟺ `0 <`.
    But this form avoids the need to invoke `nonneg` separately at the
    call site. -/
theorem T5_rothIndex_ne_zero_implies_aeval_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h_ne : rothIndex P α d ≠ 0) :
    aeval α P = 0 := by
  by_contra h_aeval_ne
  apply h_ne
  exact T5_rothIndex_eq_zero_of_aeval_ne_zero P α d h_aeval_ne

/-! ## D-pre-3 — `rothIndex P α d ≠ 0 ⇒ P ≠ 0` (poly nonzero from index nonzero) -/

/-- **D-pre-3 — `T5_rothIndex_ne_zero_implies_P_ne_zero`**: a positive
    Roth-index forces `P` to be a nonzero polynomial.

    Proof: contrapositive of `T5_rothIndex_zero_poly` (Phase 4 ENTRY,
    `rothIndex 0 α d = 0`).  If `P = 0`, the Roth-index is zero,
    contradicting the nonzero hypothesis.

    Tier-99 sub-lemma — purely logical contrapositive.  Used downstream
    in Block D combined with `IsAlgebraic` / `aeval` to extract the
    minimal polynomial witness. -/
theorem T5_rothIndex_ne_zero_implies_P_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h_ne : rothIndex P α d ≠ 0) :
    P ≠ 0 := by
  intro hP_zero
  apply h_ne
  rw [hP_zero]
  exact T5_rothIndex_zero_poly α d

/-! ## D-pre-4 — Bundled iff (rothIndex = 0 ⇔ aeval α P ≠ 0 ∨ P = 0) — strengthening D-pre-1/2 -/

/-- **D-pre-4 — `T5_rothIndex_eq_zero_iff`**: characterizes when the
    Roth-index is exactly zero.  Either `aeval α P ≠ 0` (the direct case)
    or `P = 0` (the empty-set fallback).

    Direct compilation of:
    - Phase 4 INTERIM MASTER `T5_rothIndex_eq_zero_of_aeval_ne_zero`
    - Phase 4 ENTRY `T5_rothIndex_zero_poly`

    Reverse direction needs careful handling because `rothIndex P α d = 0`
    can ALSO occur when P ≠ 0 and aeval α P = 0 but a sequence of
    `j → 0` witnesses approach 0.  So this iff is one-direction-only;
    we provide the easy direction as a logical OR. -/
theorem T5_rothIndex_eq_zero_of_disj {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h : aeval α P ≠ 0 ∨ P = 0) :
    rothIndex P α d = 0 := by
  rcases h with h_ne | h_zero
  · exact T5_rothIndex_eq_zero_of_aeval_ne_zero P α d h_ne
  · rw [h_zero]
    exact T5_rothIndex_zero_poly α d

/-! ## D-pre-aux — Strict-positivity ⟺ ne-zero (under nonneg) bridge -/

/-- **D-pre-aux1 — `T5_rothIndex_pos_iff_ne_zero`**: bridge between strict
    positivity and ≠-form for the Roth-index.  Uses `T5_rothIndex_nonneg`
    (Phase 4 foundation) implicitly via `lt_iff_le_and_ne`.

    Easy direction: 0 < x → x ≠ 0 by `ne_of_gt`.
    Hard direction needs `0 ≤ rothIndex` which holds by Phase 4 ENTRY.

    For now, supply only the easy direction (sufficient for D-pre-1
    consumers).  Hard direction reserved for a follow-up that imports
    the nonneg lemma. -/
theorem T5_rothIndex_pos_implies_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h_pos : 0 < rothIndex P α d) :
    rothIndex P α d ≠ 0 :=
  ne_of_gt h_pos

/-! ## D-pre-aux2 — Combined: strict positivity ⇒ both `aeval α P = 0` AND `P ≠ 0` -/

/-- **D-pre-aux2 — `T5_rothIndex_pos_implies_aeval_zero_and_P_ne_zero`**:
    bundles D-pre-1 + D-pre-3 into one statement for downstream Block D
    consumers that need both pieces simultaneously.

    Used in Block D when constructing the integer-non-vanishing bound:
    we need `P ≠ 0` (for the leading-coefficient + denominator argument)
    AND `aeval α P = 0` (to anchor the Schmidt-aux-poly construction at
    the algebraic α). -/
theorem T5_rothIndex_pos_implies_aeval_zero_and_P_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h_pos : 0 < rothIndex P α d) :
    aeval α P = 0 ∧ P ≠ 0 :=
  ⟨T5_rothIndex_pos_implies_aeval_zero P α d h_pos,
   T5_rothIndex_ne_zero_implies_P_ne_zero P α d (ne_of_gt h_pos)⟩

/-! ## D-pre-aux3 — Three-way disjunction characterizing rothIndex = 0 -/

/-- **D-pre-aux3 — `T5_rothIndex_eq_zero_three_way`**: characterizes
    when the Roth-index is exactly zero by three sufficient conditions
    (chained ORs).

    Either:
      (i) `aeval α P ≠ 0` (j = 0 witness — direct case)
      (ii) `P = 0` (empty-set fallback)
      (iii) explicit `rothIndex = 0` hypothesis (degenerate trivial)

    The combined three-way disjunction is `aeval α P ≠ 0 ∨ P = 0`
    (since (iii) makes the conclusion trivially true).  We package
    via the existing D-pre-4 to keep the bundle uniform. -/
theorem T5_rothIndex_eq_zero_three_way {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h : aeval α P ≠ 0 ∨ P = 0 ∨ rothIndex P α d = 0) :
    rothIndex P α d = 0 := by
  rcases h with h_ne | h_zero | h_idx
  · exact T5_rothIndex_eq_zero_of_aeval_ne_zero P α d h_ne
  · rw [h_zero]
    exact T5_rothIndex_zero_poly α d
  · exact h_idx

/-! ## D-pre-aux4 — Global `rothIndex P α d ≥ 0` (filling a Phase-4 gap) -/

/-- **D-pre-aux4 — `T5_rothIndex_nonneg`**: the Roth-index is always nonneg.

    Despite being a corollary of `T5_rothIndex_setMember_nonneg` (Phase 4
    foundation), this global statement was NEVER exposed in OV2 — only
    derived inline in `T5_rothIndex_eq_zero_of_aeval_ne_zero` (Phase 4
    INTERIM MASTER, lines 85-89).

    Two cases by the rothIndex definition (empty-set sInf convention vs
    nonempty-set sInf):
    1. Set empty → `sInf ∅ = 0` on ℝ → `rothIndex = 0 ≥ 0`.
    2. Set nonempty → bounded below by 0 (every member ≥ 0) → sInf ≥ 0.

    Useful tier-99 closure of the rothIndex calculus.  Used by D-pre-aux5
    below for the iff bridge. -/
theorem T5_rothIndex_nonneg {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    0 ≤ rothIndex P α d := by
  unfold rothIndex
  by_cases h_empty :
      { r : ℝ | ∃ j : Fin n → ℕ,
          aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (d i : ℝ) } = ∅
  · rw [h_empty]
    rw [Real.sInf_empty]
  · -- Nonempty: pick a witness, sInf ≥ 0 by le_csInf
    have h_nonempty : Set.Nonempty
        { r : ℝ | ∃ j : Fin n → ℕ,
            aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
            r = ∑ i, (j i : ℝ) / (d i : ℝ) } :=
      Set.nonempty_iff_ne_empty.mpr h_empty
    apply le_csInf h_nonempty
    intro b hb
    exact T5_rothIndex_setMember_nonneg P α d b hb

/-! ## D-pre-aux5 — Strict-positivity ⟺ ne-zero iff (under nonneg) -/

/-- **D-pre-aux5 — `T5_rothIndex_pos_iff_ne_zero`**: full iff between
    `0 < rothIndex P α d` and `rothIndex P α d ≠ 0`, using nonneg.

    Forward: ne_of_gt (already in D-pre-aux1).
    Reverse: from `0 ≤ x` and `x ≠ 0`, derive `0 < x` via `lt_of_le_of_ne`. -/
theorem T5_rothIndex_pos_iff_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ) :
    0 < rothIndex P α d ↔ rothIndex P α d ≠ 0 := by
  constructor
  · exact ne_of_gt
  · intro h_ne
    exact lt_of_le_of_ne (T5_rothIndex_nonneg P α d) (Ne.symm h_ne)

/-! ## D-pre-5 — Headline -/

/-- **🚨 D-pre-5 — `T5_BlockD_RothIndexPosVanish_HEADLINE`**: paper-citable
    Block-D foundation headline.  Bundles the 4 tier-99 contrapositive
    sub-lemmas into a 4-conjunct package preparing the integer-non-vanishing
    argument of D.7 atom 2.

    Per project rule §7.0: NAMED real Prop content, used non-vacuously
    via the four conjuncts. -/
theorem T5_BlockD_RothIndexPosVanish_HEADLINE :
    -- (a) strict positivity ⇒ vanishing
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      0 < rothIndex P α d → aeval α P = 0) ∧
    -- (b) nonzero index ⇒ vanishing
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      rothIndex P α d ≠ 0 → aeval α P = 0) ∧
    -- (c) nonzero index ⇒ P ≠ 0
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      rothIndex P α d ≠ 0 → P ≠ 0) ∧
    -- (d) easy direction of zero-index characterization
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      aeval α P ≠ 0 ∨ P = 0 → rothIndex P α d = 0) ∧
    -- (e) strict positivity ⇒ ≠ 0 form
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      0 < rothIndex P α d → rothIndex P α d ≠ 0) ∧
    -- (f) strict positivity ⇒ both vanishing AND P ≠ 0
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      0 < rothIndex P α d → aeval α P = 0 ∧ P ≠ 0) ∧
    -- (g) three-way disjunction
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      aeval α P ≠ 0 ∨ P = 0 ∨ rothIndex P α d = 0 → rothIndex P α d = 0) ∧
    -- (h) global rothIndex nonneg
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      0 ≤ rothIndex P α d) ∧
    -- (i) iff between strict positive and ne_zero
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      0 < rothIndex P α d ↔ rothIndex P α d ≠ 0) :=
  ⟨@T5_rothIndex_pos_implies_aeval_zero,
   @T5_rothIndex_ne_zero_implies_aeval_zero,
   @T5_rothIndex_ne_zero_implies_P_ne_zero,
   @T5_rothIndex_eq_zero_of_disj,
   @T5_rothIndex_pos_implies_ne_zero,
   @T5_rothIndex_pos_implies_aeval_zero_and_P_ne_zero,
   @T5_rothIndex_eq_zero_three_way,
   @T5_rothIndex_nonneg,
   @T5_rothIndex_pos_iff_ne_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
