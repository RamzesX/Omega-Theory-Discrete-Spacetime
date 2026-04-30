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
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

open Real
open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexEqZero
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ

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

/-! ## D-pre-aux6 — Sub-threshold vanishing (the core Block D bridge) -/

/-- **D-pre-aux6 — `T5_rothIndex_lower_bound_implies_subthreshold_vanish`**:
    if `rothIndex P at α ≥ t`, then any multi-index `j` with weighted sum
    strictly LESS than `t` must satisfy `aeval α (multiIteratedPDeriv j P) = 0`.

    This is the core "high index ⇒ vanish to high order" implication
    used by D.7 Block D when combining the index-reduction inequality
    (Wave-2 Phase 2.3 Statement form, available via `master.2.2.2.1`)
    with the integer-non-vanishing argument.

    Proof: by contrapositive — if `aeval α (multiIteratedPDeriv j P) ≠ 0`,
    then `r := ∑ j_i / d_i` is in the rothIndex set (j is a witness with
    derivative non-vanishing), so `rothIndex ≤ r` by `csInf_le`.  Combined
    with hypothesis `r < t ≤ rothIndex`, contradiction. -/
theorem T5_rothIndex_lower_bound_implies_subthreshold_vanish {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (t : ℝ) (h_lower : t ≤ rothIndex P α d)
    (j : Fin n → ℕ) (h_strict : (∑ i, (j i : ℝ) / (d i : ℝ)) < t) :
    aeval α (multiIteratedPDeriv j P) = 0 := by
  by_contra h_ne
  -- j with derivative non-vanishing → r := ∑ j_i / d_i is in the rothIndex set
  have h_mem :
      (∑ i, (j i : ℝ) / (d i : ℝ)) ∈
        { r : ℝ | ∃ j : Fin n → ℕ,
            aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
            r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
    refine ⟨j, h_ne, ?_⟩
    rfl
  -- BddBelow: every member ≥ 0
  have h_bdd :
      BddBelow { r : ℝ | ∃ j : Fin n → ℕ,
                  aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
                  r = ∑ i, (j i : ℝ) / (d i : ℝ) } := by
    refine ⟨0, ?_⟩
    intro r hr
    exact T5_rothIndex_setMember_nonneg P α d r hr
  -- rothIndex ≤ r by csInf_le
  have h_idx_le : rothIndex P α d ≤ ∑ i, (j i : ℝ) / (d i : ℝ) := by
    unfold rothIndex
    exact csInf_le h_bdd h_mem
  -- t ≤ rothIndex ≤ r < t — contradiction
  linarith

/-! ## D-pre-aux7 — Strict version: rothIndex > t ⇒ subthreshold-(t+ε) vanish for any ε > 0 -/

/-- **D-pre-aux7 — `T5_rothIndex_strict_lower_bound_subthreshold_vanish`**:
    strict-inequality version of D-pre-aux6.  If `rothIndex P at α > t`,
    then any j with `∑ j_i / d_i ≤ t` (note: ≤, not <) must satisfy
    the vanishing.

    Proof: from `rothIndex > t` and `∑ j_i / d_i ≤ t`, we have
    `∑ j_i / d_i ≤ t < rothIndex`, so `∑ j_i / d_i < rothIndex`, apply
    D-pre-aux6 with `t' := rothIndex P α d` and the ≤-form. -/
theorem T5_rothIndex_strict_lower_bound_subthreshold_vanish {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (t : ℝ) (h_strict : t < rothIndex P α d)
    (j : Fin n → ℕ) (h_le : (∑ i, (j i : ℝ) / (d i : ℝ)) ≤ t) :
    aeval α (multiIteratedPDeriv j P) = 0 := by
  apply T5_rothIndex_lower_bound_implies_subthreshold_vanish P α d
    (rothIndex P α d) (le_refl _) j
  linarith

/-! ## D-pre-aux8 — Existential dual: rothIndex < t ⇒ ∃ sub-threshold witness (with S nonempty hyp) -/

/-- **D-pre-aux8 — `T5_rothIndex_lt_implies_exists_witness`**: dual of
    D-pre-aux6.  If the rothIndex set is nonempty AND `rothIndex P α d < t`,
    then there exists a multi-index `j` with `∑ j_i/d_i < t` and
    `aeval α (multiIteratedPDeriv j P) ≠ 0`.

    The nonempty precondition is mandatory: when S = ∅, rothIndex = 0
    by `Real.sInf_empty` and the conclusion is vacuously false (no witness
    exists at all).  The nonempty hypothesis is satisfied in the practical
    Block-D application via `P ≠ 0` (some j makes the derivative non-zero,
    e.g. j = full-degree gives a constant scalar).

    Used by D.7 Block C analytical Taylor argument when the index-reduction
    inequality gives `rothIndex at q-tuple ≤ t - √(mε)` and we need to
    extract a SPECIFIC small-j witness whose derivative is non-vanishing
    at the q-tuple (which then provides the leading term in the Taylor
    expansion bound).

    Proof: if no such j exists, every member `r` of the rothIndex set
    has `r ≥ t`, so `t ≤ sInf set = rothIndex` by `le_csInf` (using the
    nonempty hypothesis).  But that contradicts `rothIndex < t`. -/
theorem T5_rothIndex_lt_implies_exists_witness {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (t : ℝ) (h_lt : rothIndex P α d < t)
    (h_nonempty : ({ r : ℝ | ∃ j : Fin n → ℕ,
        aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
        r = ∑ i, (j i : ℝ) / (d i : ℝ) } : Set ℝ).Nonempty) :
    ∃ (j : Fin n → ℕ),
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (d i : ℝ)) < t := by
  by_contra h_no_witness
  push_neg at h_no_witness
  -- h_no_witness : ∀ j, aeval α (multiIteratedPDeriv j P) ≠ 0 →
  --                  t ≤ ∑ i, (j i : ℝ) / (d i : ℝ)
  -- This means every member of the rothIndex set is ≥ t, so t is a lower bound.
  have h_t_lb : ∀ r ∈ { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) }, t ≤ r := by
    intro r hr
    rcases hr with ⟨j, hj_ne, hr_eq⟩
    rw [hr_eq]
    exact h_no_witness j hj_ne
  -- Apply le_csInf using the nonempty hypothesis
  have h_t_le_sInf : t ≤ sInf { r : ℝ | ∃ j : Fin n → ℕ,
      aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / (d i : ℝ) } :=
    le_csInf h_nonempty h_t_lb
  have h_t_le_idx : t ≤ rothIndex P α d := by
    unfold rothIndex
    exact h_t_le_sInf
  linarith

/-! ## D-pre-aux9 — Convenience: rothIndex set nonempty from aeval α P ≠ 0 -/

/-- **D-pre-aux9 — `T5_rothIndex_set_nonempty_of_aeval_ne_zero`**:
    convenience lemma deriving S nonempty (precondition for D-pre-aux8)
    from `aeval α P ≠ 0`.

    Proof: j = 0 is a witness in S since `multiIteratedPDeriv 0 P = P`
    (via Phase 4 ext #2 `T5_multiIteratedPDeriv_zeroJ`), `aeval α P ≠ 0`
    by hypothesis, and `∑ 0 / d_i = 0`.

    Used to discharge the `h_nonempty` precondition of D-pre-aux8 in the
    actual Block D application (Schmidt aux poly has `aeval α P` derived
    from algebraic-relation context). -/
theorem T5_rothIndex_set_nonempty_of_aeval_ne_zero {n : ℕ}
    (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
    (h_ne : aeval α P ≠ 0) :
    ({ r : ℝ | ∃ j : Fin n → ℕ,
        aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
        r = ∑ i, (j i : ℝ) / (d i : ℝ) } : Set ℝ).Nonempty := by
  refine ⟨0, ?_⟩
  refine ⟨fun _ => 0, ?_, ?_⟩
  · -- multiIteratedPDeriv 0 P = P (via zeroJ identity), so aeval α P ≠ 0 ↦ aeval α (...) ≠ 0
    rw [T5_multiIteratedPDeriv_zeroJ]
    exact h_ne
  · simp

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
      0 < rothIndex P α d ↔ rothIndex P α d ≠ 0) ∧
    -- (j) sub-threshold vanishing (≤-form): the core Block D bridge
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
      (t : ℝ), t ≤ rothIndex P α d →
      ∀ (j : Fin n → ℕ), (∑ i, (j i : ℝ) / (d i : ℝ)) < t →
        aeval α (multiIteratedPDeriv j P) = 0) ∧
    -- (k) strict-form sub-threshold vanishing
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
      (t : ℝ), t < rothIndex P α d →
      ∀ (j : Fin n → ℕ), (∑ i, (j i : ℝ) / (d i : ℝ)) ≤ t →
        aeval α (multiIteratedPDeriv j P) = 0) ∧
    -- (l) existential dual (with nonempty hypothesis)
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ)
      (t : ℝ), rothIndex P α d < t →
      ({ r : ℝ | ∃ j : Fin n → ℕ,
          aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (d i : ℝ) } : Set ℝ).Nonempty →
      ∃ (j : Fin n → ℕ),
        aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, (j i : ℝ) / (d i : ℝ)) < t) ∧
    -- (m) convenience: nonempty from aeval α P ≠ 0
    (∀ {n : ℕ} (P : MvPolynomial (Fin n) ℝ) (α : Fin n → ℝ) (d : Fin n → ℕ),
      aeval α P ≠ 0 →
      ({ r : ℝ | ∃ j : Fin n → ℕ,
          aeval α (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (d i : ℝ) } : Set ℝ).Nonempty) :=
  ⟨@T5_rothIndex_pos_implies_aeval_zero,
   @T5_rothIndex_ne_zero_implies_aeval_zero,
   @T5_rothIndex_ne_zero_implies_P_ne_zero,
   @T5_rothIndex_eq_zero_of_disj,
   @T5_rothIndex_pos_implies_ne_zero,
   @T5_rothIndex_pos_implies_aeval_zero_and_P_ne_zero,
   @T5_rothIndex_eq_zero_three_way,
   @T5_rothIndex_nonneg,
   @T5_rothIndex_pos_iff_ne_zero,
   @T5_rothIndex_lower_bound_implies_subthreshold_vanish,
   @T5_rothIndex_strict_lower_bound_subthreshold_vanish,
   @T5_rothIndex_lt_implies_exists_witness,
   @T5_rothIndex_set_nonempty_of_aeval_ne_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
