/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_to_OG_NAMED

  T-5 (Roth's theorem) — **Yoneda bridge: V8AtomOne_StrictClosure ⇒ OG NAMED**.

  Bridges the V8AtomOne_StrictClosure result (constrained-strict V8-atom-1)
  to the original V6/V7 capstone NAMED Prop `T5_RothLemmaIndexReductionDischarge`.

  Strategic significance: connects the new V8-atom-1 strict closure path
  (built this fire) directly to the OG NAMED Prop used in V6/V7 paper
  capstones, enabling V8-via-V6 and V8-via-V7 composition routes.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_to_OG_NAMED

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring

/-! ## V8AOG-1 — Constrained smallJ witness from SJWC-1 + UWF-2 -/

/-- **V8AOG-1 — `T5_constrained_smallJ_witness_via_SJWC1_UWF2`**: under the
    small-ε constraint ε ≤ m³/16, given SJWC-1 + UWF-2 NAMEDs, we get the
    standard smallJ-witness EXISTENCE form (not the universal NAMED Prop).

    This is a CONSTRAINED version — NOT the full T5_NAMED_smallJ_witness_at_q
    (which requires ALL ε > 0). -/
theorem T5_constrained_smallJ_witness_via_SJWC1_UWF2
    (h_SJWC1 : T5_NAMED_index_at_q_strict_upper_bound)
    (h_UWF2 : T5_NAMED_support_extraction_at_zero) :
    ∀ {m : ℕ} (hm : 1 ≤ m)
      (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
      (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
      P ≠ 0 → 0 < ε → ε ≤ ((m : ℝ)^3) / 16 →
      (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
      (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
      T5_DenominatorGrowthCondition q ε →
      T5_DegreeHeightBalanceCondition R q ε →
      rothIndex P (fun _ => α) R ≥ t →
      ∃ (j : Fin m → ℕ),
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε) :=
  T5_V8_atom1_strict_via_SJWC1_and_UWF2 h_SJWC1 h_UWF2

/-! ## V8AOG-2 — Connection to OG D.6.1 statement (under constraint) -/

/-- **V8AOG-2 — `T5_OG_NAMED_via_constrained_smallJ`**: for the
    CONSTRAINED-ε case (ε ≤ m³/16), V8AtomOne_StrictClosure produces
    the bound on rothIndex-at-q matching the OG D.6.1 statement.

    Direct application of `csInf_le` on the rothIndex set, using the
    smallJ witness as a member of that set with bounded sum. -/
theorem T5_OG_NAMED_via_constrained_smallJ
    (h_SJWC1 : T5_NAMED_index_at_q_strict_upper_bound)
    (h_UWF2 : T5_NAMED_support_extraction_at_zero) :
    ∀ {m : ℕ} (hm : 1 ≤ m)
      (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
      (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
      P ≠ 0 → 0 < ε → ε ≤ ((m : ℝ)^3) / 16 →
      (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
      (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
      T5_DenominatorGrowthCondition q ε →
      T5_DegreeHeightBalanceCondition R q ε →
      rothIndex P (fun _ => α) R ≥ t →
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤ t - Real.sqrt ((m : ℝ) * ε) := by
  intros m hm P R α q ε t hP hε hε_small hR_deg hR_pos hq_den
      h_growth h_balance h_t
  -- Get the smallJ witness from V8AOG-1
  obtain ⟨j, h_aeval_ne, h_sum_le⟩ :=
    T5_constrained_smallJ_witness_via_SJWC1_UWF2 h_SJWC1 h_UWF2
      hm P R α q ε t hP hε hε_small hR_deg hR_pos hq_den h_growth h_balance h_t
  -- Apply csInf_le: rothIndex (q-tuple) ≤ ∑ j_i / R_i ≤ t - √(mε)
  have h_mem :
      (∑ i, (j i : ℝ) / (R i : ℝ)) ∈
      { r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } := by
    refine ⟨j, h_aeval_ne, rfl⟩
  have h_bdd : BddBelow
      { r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } := by
    refine ⟨0, ?_⟩
    intros r hr
    obtain ⟨j', _, hr_eq⟩ := hr
    rw [hr_eq]
    exact Finset.sum_nonneg (fun i _ =>
      div_nonneg (Nat.cast_nonneg _) (Nat.cast_nonneg _))
  have h_idx : rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      ∑ i, (j i : ℝ) / (R i : ℝ) := by
    unfold rothIndex
    exact csInf_le h_bdd h_mem
  linarith

/-! ## V8AOG-3 — Headline -/

/-- **🚨🚨 V8AOG-3 — `T5_V8_ATOM1_TO_OG_NAMED_HEADLINE`**: paper-citable
    bundle showing V8AtomOne_StrictClosure connects to OG D.6.1 statement
    (under small-ε constraint).

    Strategic significance: bridges new V8 closure path (this fire) to
    OG V6/V7 capstone NAMED Props. -/
theorem T5_V8_ATOM1_TO_OG_NAMED_HEADLINE :
    T5_NAMED_index_at_q_strict_upper_bound →
    T5_NAMED_support_extraction_at_zero →
    (∀ {m : ℕ} (hm : 1 ≤ m)
       (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
       (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
       P ≠ 0 → 0 < ε → ε ≤ ((m : ℝ)^3) / 16 →
       (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
       (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
       T5_DenominatorGrowthCondition q ε →
       T5_DegreeHeightBalanceCondition R q ε →
       rothIndex P (fun _ => α) R ≥ t →
       rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
         t - Real.sqrt ((m : ℝ) * ε)) :=
  T5_OG_NAMED_via_constrained_smallJ

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_to_OG_NAMED
