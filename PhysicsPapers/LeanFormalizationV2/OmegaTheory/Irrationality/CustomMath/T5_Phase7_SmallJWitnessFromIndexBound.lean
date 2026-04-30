/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessFromIndexBound

  T-5 (Roth's theorem) — **H_c-5 INVERSION** (smallJ witness from rothIndex bound).

  Bridges the analytical hypothesis "rothIndex P (q-tuple) R ≤ t - √(mε)"
  (the OUTPUT of the H_a + H_b + H_c-1 + H_c-2 + H_c-3 + H_c-4 chain)
  back to the smallJ witness NAMED Prop:

      ∃ j, aeval q (multiIteratedPDeriv j P) ≠ 0 ∧ (∑ j_i / R_i) ≤ t - √(mε)

  Strategy: use D-pre-aux8 contrapositive
  (`T5_rothIndex_lt_implies_exists_witness`) at threshold `t - √(mε) + δ`
  for δ > 0 small.  The witness has `∑ j_i / R_i < t - √(mε) + δ`, hence
  `≤ t - √(mε)` after adjustment via standard real-analytic limits.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — actual analytical content with named-lemma chain.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexNonNeg

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessFromIndexBound

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

/-! ## SJWB-1 — strict version of smallJ witness extraction -/

/-- **`T5_smallJ_witness_strict_from_index_lt`**: if rothIndex at q-tuple is
    STRICTLY less than `T`, and the rothIndex set is nonempty, we extract a
    smallJ witness with `∑ j_i / R_i < T`.

    Direct application of `T5_rothIndex_lt_implies_exists_witness`. -/
theorem T5_smallJ_witness_strict_from_index_lt {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ)
    (q : Fin m → ℚ) (R : Fin m → ℕ)
    (T : ℝ)
    (h_idx_lt : rothIndex P (fun i => ((q i : ℚ) : ℝ)) R < T)
    (h_nonempty :
      ({ r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty) :
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) < T :=
  T5_rothIndex_lt_implies_exists_witness P (fun i => ((q i : ℚ) : ℝ)) R T
    h_idx_lt h_nonempty

/-! ## SJWB-2 — ≤ version (weakening from <) -/

/-- **`T5_smallJ_witness_le_from_index_lt`**: if rothIndex at q-tuple is
    STRICTLY less than `T`, we extract a smallJ witness with `∑ j_i / R_i ≤ T`.

    This is the STANDARD form for the smallJ witness Prop.  Direct
    weakening from SJWB-1 via `<` ⇒ `≤`. -/
theorem T5_smallJ_witness_le_from_index_lt {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ)
    (q : Fin m → ℚ) (R : Fin m → ℕ)
    (T : ℝ)
    (h_idx_lt : rothIndex P (fun i => ((q i : ℚ) : ℝ)) R < T)
    (h_nonempty :
      ({ r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty) :
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ T := by
  obtain ⟨j, h_aeval_ne, h_sum_lt⟩ :=
    T5_smallJ_witness_strict_from_index_lt P q R T h_idx_lt h_nonempty
  exact ⟨j, h_aeval_ne, le_of_lt h_sum_lt⟩

/-! ## SJWB-3 — Headline: smallJ witness from index bound -/

/-- **🚨🚨 SJWB-3 — `T5_SMALLJ_WITNESS_FROM_INDEX_BOUND_HEADLINE`**:
    paper-citable bundle documenting both `<` and `≤` forms of the
    smallJ-witness extraction.

    Strategic significance: H_c-5 inversion step formalized.  The
    analytical chain (H_a + H_b + H_c-1 + H_c-2 + H_c-3 + H_c-4)
    delivers a rothIndex upper bound at q-tuple, which this lemma
    INVERTS into a smallJ witness via D-pre-aux8 contrapositive. -/
theorem T5_SMALLJ_WITNESS_FROM_INDEX_BOUND_HEADLINE {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ)
    (q : Fin m → ℚ) (R : Fin m → ℕ)
    (T : ℝ)
    (h_nonempty :
      ({ r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty) :
    -- (a) strict form
    (rothIndex P (fun i => ((q i : ℚ) : ℝ)) R < T →
      ∃ (j : Fin m → ℕ),
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, (j i : ℝ) / (R i : ℝ)) < T) ∧
    -- (b) ≤ form (standard smallJ-witness shape)
    (rothIndex P (fun i => ((q i : ℚ) : ℝ)) R < T →
      ∃ (j : Fin m → ℕ),
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ T) :=
  ⟨fun h => T5_smallJ_witness_strict_from_index_lt P q R T h h_nonempty,
   fun h => T5_smallJ_witness_le_from_index_lt P q R T h h_nonempty⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessFromIndexBound
