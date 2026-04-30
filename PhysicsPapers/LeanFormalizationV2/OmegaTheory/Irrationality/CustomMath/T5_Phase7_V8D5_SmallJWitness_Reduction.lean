/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction

  T-5 (Roth's theorem) — **V8-D5 NAMED Prop REDUCTION** to a smaller
  analytical NAMED leaf (small-J witness existence).

  Strategy: instead of taking the FULL D.6.1 statement
  (`T5_RothLemmaIndexReduction_Statement`) as a single NAMED Prop, factor
  through the EXISTENCE OF A SMALL-J WITNESS:

      ∃ j : Fin m → ℕ,
        aeval q (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, j_i / R_i) ≤ t - √(mε)

  The full D.6.1 statement THEN follows by `csInf_le` (rothIndex is the
  infimum of the rothIndex set; the witness `j` provides a member with
  the desired upper bound).

  This is V8-D5 architecture progress: the analytical heart (Taylor +
  AM-QM √m birth) is now isolated in `T5_NAMED_smallJ_witness_at_q`.
  Subsequent fires discharge that NAMED via H_a, H_c, etc.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — NEW NAMED Prop with explicit discharge plan
  + composition theorem proving reduction.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

/-! ## V8-D5-A — Small-J witness NAMED Prop (the analytical heart) -/

/-- **V8-D5-A — `T5_NAMED_smallJ_witness_at_q`** [NAMED HYPOTHESIS,
    THE ANALYTICAL HEART OF D.6.1].

    Under D.6.1's hypotheses (growth + balance + α-diagonal lower bound),
    there EXISTS a small-J multi-index whose iterated derivative does NOT
    vanish at the rational tuple `q` AND whose weighted sum `∑ j_i / R_i`
    is bounded by `t - √(mε)`.

    Discharge plan (V8 HEART, ~970 lines, 4-5 days):
    1. **H_a-1, H_a-2** — multivariate Taylor at α expanded form
       (`P(α + y) = Σ_J c(J) · y^J` with `c(J) = (1/J!) · ∂^J P (α)`)
    2. **H_c-1** — weighted-sum pigeonhole on Fin m
    3. **H_c-2** — pigeonhole applied to Taylor offsets (J' - J)
    4. **H_c-3** — per-i factor bound `|qᵢ - α|^k ≤ dᵢ^{-k(2+ε)}`
    5. **H_c-4** — combine via AM-QM `(∑aᵢ) ≤ √(m · ∑aᵢ²)` for √m birth
    6. **H_c-5** — invert via D-pre-aux8 contrapositive

    The result feeds into `csInf_le` to give the D.6.1 upper bound. -/
def T5_NAMED_smallJ_witness_at_q : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
    P ≠ 0 →
    0 < ε →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    (∀ i, 1 ≤ (q i).den) →
    T5_DenominatorGrowthCondition q ε →
    T5_DegreeHeightBalanceCondition R q ε →
    rothIndex P (fun _ => α) R ≥ t →
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε)

/-! ## V8-D5-B — Composition: smallJ witness ⇒ D.6.1 upper bound -/

/-- **V8-D5-B — `T5_RothLemmaIndexReductionDischarge_via_smallJ_witness`**:
    UNCONDITIONAL composition theorem reducing
    `T5_RothLemmaIndexReduction_Statement` to the small-J witness NAMED
    Prop.

    Given the witness `j` from the NAMED hypothesis, `csInf_le` gives
    `rothIndex P (q-tuple) R ≤ ∑ j_i / R_i ≤ t - √(mε)`. -/
theorem T5_RothLemmaIndexReductionDischarge_via_smallJ_witness
    (h_witness : T5_NAMED_smallJ_witness_at_q) :
    T5_RothLemmaIndexReduction_Statement := by
  intro m hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  -- Extract the witness from the NAMED Prop
  obtain ⟨j, h_aeval_ne, h_sum_le⟩ :=
    h_witness hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  -- The witness gives a member of the rothIndex set at q
  have h_mem :
      (∑ i, (j i : ℝ) / (R i : ℝ)) ∈
        { r : ℝ | ∃ j : Fin m → ℕ,
            aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
            r = ∑ i, (j i : ℝ) / (R i : ℝ) } :=
    ⟨j, h_aeval_ne, rfl⟩
  -- The set is bounded below by 0 (each member is nonneg sum)
  have h_bdd :
      BddBelow { r : ℝ | ∃ j : Fin m → ℕ,
                  aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
                  r = ∑ i, (j i : ℝ) / (R i : ℝ) } := by
    refine ⟨0, ?_⟩
    intro r hr
    exact T5_rothIndex_setMember_nonneg P (fun i => ((q i : ℚ) : ℝ)) R r hr
  -- Apply csInf_le to get rothIndex ≤ ∑ j_i / R_i
  have h_idx_le :
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
        (∑ i, (j i : ℝ) / (R i : ℝ)) := by
    unfold rothIndex
    exact csInf_le h_bdd h_mem
  -- Combine with witness bound: ∑ j_i / R_i ≤ t - √(mε)
  linarith

/-! ## V8-D5-C — V8 atom 1 reduction headline -/

/-- **🚨🚨🚨 V8-D5-C — `T5_V8_ATOM1_REDUCTION_TO_SMALLJ`**: paper-citable
    V8-atom-1 (D.6.1) reduction headline.

    V8-atom-1 closure path via small-J witness:
    - Once `T5_NAMED_smallJ_witness_at_q` is discharged unconditionally
      (via the H_a + H_c HEART work), the composition above
      (`T5_RothLemmaIndexReductionDischarge_via_smallJ_witness`)
      immediately gives `T5_RothLemmaIndexReduction_Statement`
      unconditional.
    - `T5_RothLemmaIndexReduction_Statement` is `T5_NAMED_HEART_lift_to_rothIndex`
      (per V8DecompositionStatus.lean), i.e., V8-atom-1.

    Strategic value: factors the FULL D.6.1 NAMED Prop
    (universally-quantified inequality) into a SMALLER, FOCUSED NAMED
    Prop (single witness existence).  The composition is MACHINE-CHECKED
    (no NAMED required for it).  All future analytical work concentrates
    on `T5_NAMED_smallJ_witness_at_q` discharge. -/
theorem T5_V8_ATOM1_REDUCTION_TO_SMALLJ :
    -- (a) NAMED Prop is well-formed
    (T5_NAMED_smallJ_witness_at_q → T5_NAMED_smallJ_witness_at_q) ∧
    -- (b) Composition: NAMED ⇒ D.6.1 unconditional
    (T5_NAMED_smallJ_witness_at_q → T5_RothLemmaIndexReduction_Statement) :=
  ⟨id, T5_RothLemmaIndexReductionDischarge_via_smallJ_witness⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
