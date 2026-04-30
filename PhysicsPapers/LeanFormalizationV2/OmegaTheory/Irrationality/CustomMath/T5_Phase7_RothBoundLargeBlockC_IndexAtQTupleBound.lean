/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_IndexAtQTupleBound

  T-5 (Roth's theorem) — **D.7 Block C ENTRY-POINT BOUND**.

  Composition of Schmidt aux index lower bound + index reduction Statement
  → derive the rothIndex bound at the q-tuple.

  This is the FIRST genuine STEP-FORWARD on atom-2 D.7 closure (post-pivot
  2026-04-30): combining the Block-A+B output (m violators with growth
  condition + Schmidt aux poly with rothIndex at α-diagonal ≥ m/2 − √(mε))
  with the master's index-reduction Statement to derive

      rothIndex P (q-tuple) R ≤ (m/2 − √(mε)) − √(mε) = m/2 − 2√(mε)

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_IndexAtQTupleBound

open Real
open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

/-! ## C-entry-1 — Schmidt aux index lower bound + index reduction → rothIndex at q-tuple bound -/

/-- **C-entry-1 — `T5_BlockC_rothIndex_at_q_tuple_bound`**: the FIRST
    GENUINE step-forward on atom-2 D.7 closure.

    Given:
    - `master : RothLemmaMaster` (provides Schmidt aux + index reduction Statement)
    - α irrational algebraic, ε > 0, m ≥ m₀ (Schmidt aux threshold)
    - `q : Fin m → ℚ` with growth + balance + denominator ≥ 1 conditions
    - The Schmidt aux poly P with degree bounds R, P ≠ 0
    - `rothIndex P at α-diagonal R ≥ m/2 − √(mε)` (Schmidt aux output)

    Derive:
    - `rothIndex P at q-tuple R ≤ m/2 − 2√(mε)`

    Direct application of `T5_master_extract_indexReduction master`
    with `t := m/2 − √(mε)` after combining with the Schmidt aux index
    lower bound.  This is the bound that feeds the Block D analytical
    contradiction. -/
theorem T5_BlockC_rothIndex_at_q_tuple_bound
    (master : RothLemmaMaster)
    {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ)
    (hP : P ≠ 0) (hε : 0 < ε)
    (h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i)
    (h_q_pos : ∀ i, 1 ≤ (q i).den)
    (h_growth : T5_DenominatorGrowthCondition q ε)
    (h_balance : T5_DegreeHeightBalanceCondition R q ε)
    (h_lower : rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) - Real.sqrt ((m : ℝ) * ε) := by
  -- Extract the index reduction Statement from master
  have h_idxred : T5_RothLemmaIndexReduction_Statement :=
    T5_master_extract_indexReduction master
  -- Apply with t := m/2 - √(mε)
  exact h_idxred hm P R α q ε ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε))
    hP hε h_deg h_R_pos h_q_pos h_growth h_balance h_lower

/-! ## C-entry-2 — Simplification: m/2 − 2√(mε) form -/

/-- **C-entry-2 — `T5_BlockC_rothIndex_at_q_tuple_simplified`**: same as
    C-entry-1 but with the conclusion algebraically simplified to
    `m/2 − 2√(mε)` (subtraction `(m/2 − √(mε)) − √(mε) = m/2 − 2√(mε)`). -/
theorem T5_BlockC_rothIndex_at_q_tuple_simplified
    (master : RothLemmaMaster)
    {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ)
    (hP : P ≠ 0) (hε : 0 < ε)
    (h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i)
    (h_q_pos : ∀ i, 1 ≤ (q i).den)
    (h_growth : T5_DenominatorGrowthCondition q ε)
    (h_balance : T5_DegreeHeightBalanceCondition R q ε)
    (h_lower : rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) :
    rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) := by
  have h_step1 := T5_BlockC_rothIndex_at_q_tuple_bound master hm P R α q ε
    hP hε h_deg h_R_pos h_q_pos h_growth h_balance h_lower
  -- ((m / 2 - √(mε)) - √(mε)) = m/2 - 2√(mε)
  have h_alg : ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) - Real.sqrt ((m : ℝ) * ε)
      = (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) := by ring
  linarith

/-! ## C-entry-bridge — Compose C-entry-2 with D-pre-aux8 (low-index witness extraction) -/

/-- **C-entry-bridge — `T5_BlockC_low_index_witness_at_q_tuple`**: composition
    of C-entry-2 (rothIndex at q ≤ m/2 - 2√(mε)) with D-pre-aux8 (existential
    dual of subthreshold vanishing).

    Given the master, all the index-reduction preconditions, AND a nonempty
    rothIndex set (discharge via `aeval (q-tuple) P ≠ 0` — hypothesis here),
    extract a SPECIFIC low-index multi-derivative witness:

    ∃ j : Fin m → ℕ,
      aeval (q-tuple) (multiIteratedPDeriv j P) ≠ 0 ∧
      ∑ j_i / d_i < m/2 - 2√(mε) + 1

    The +1 offset converts `≤ m/2 - 2√(mε)` to `< m/2 - 2√(mε) + 1` (strict).

    This witness IS the analytical handle for the Block D content
    (multivariate Taylor expansion around α uses this j for the leading term). -/
theorem T5_BlockC_low_index_witness_at_q_tuple
    (master : RothLemmaMaster)
    {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ)
    (hP : P ≠ 0) (hε : 0 < ε)
    (h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i)
    (h_q_pos : ∀ i, 1 ≤ (q i).den)
    (h_growth : T5_DenominatorGrowthCondition q ε)
    (h_balance : T5_DegreeHeightBalanceCondition R q ε)
    (h_lower : rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε))
    (h_aeval_q_ne : aeval (fun i => ((q i : ℚ) : ℝ)) P ≠ 0) :
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) <
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) + 1 := by
  -- Get the rothIndex at q-tuple ≤ m/2 - 2√(mε)
  have h_idx_q :
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) :=
    T5_BlockC_rothIndex_at_q_tuple_simplified master hm P R α q ε
      hP hε h_deg h_R_pos h_q_pos h_growth h_balance h_lower
  -- Strict version: rothIndex < m/2 - 2√(mε) + 1
  have h_idx_strict :
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R <
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) + 1 := by linarith
  -- The rothIndex set is nonempty via D-pre-aux9 (aeval (q-tuple) P ≠ 0)
  have h_nonempty :
      ({ r : ℝ | ∃ j : Fin m → ℕ,
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty :=
    T5_rothIndex_set_nonempty_of_aeval_ne_zero P (fun i => ((q i : ℚ) : ℝ)) R
      h_aeval_q_ne
  -- Apply D-pre-aux8
  exact T5_rothIndex_lt_implies_exists_witness P (fun i => ((q i : ℚ) : ℝ)) R
    ((m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) + 1) h_idx_strict h_nonempty

/-! ## C-entry-3 — Headline: the Block C entry-point bound bundle -/

/-- **🚨🚨🚨 C-entry-3 — `T5_BLOCK_C_ENTRY_POINT_BOUND_HEADLINE`**:
    paper-citable Block C entry-point bound bundle.

    Bundles C-entry-1 (raw form) + C-entry-2 (simplified m/2 − 2√(mε) form)
    into a 2-conjunct headline.  This is the FIRST GENUINE step-forward
    on atom-2 D.7 closure post-pivot 2026-04-30.

    The Block C entry-point bound feeds directly into:
    - Block D analytical (multivariate Taylor at REAL α)
    - Block E contradiction (combine upper + lower bounds on |P(q-tuple)|)
    - V7 capstone (atom 2 discharged) -/
theorem T5_BLOCK_C_ENTRY_POINT_BOUND_HEADLINE :
    -- (a) Raw form: rothIndex at q-tuple ≤ (m/2 − √(mε)) − √(mε)
    (∀ (master : RothLemmaMaster)
       {m : ℕ}, 1 ≤ m →
       ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
         (α : ℝ) (q : Fin m → ℚ) (ε : ℝ),
       P ≠ 0 → 0 < ε →
       (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
       (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
       T5_DenominatorGrowthCondition q ε →
       T5_DegreeHeightBalanceCondition R q ε →
       rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) →
       rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
         ((m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) - Real.sqrt ((m : ℝ) * ε)) ∧
    -- (b) Simplified form: rothIndex at q-tuple ≤ m/2 − 2√(mε)
    (∀ (master : RothLemmaMaster)
       {m : ℕ}, 1 ≤ m →
       ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
         (α : ℝ) (q : Fin m → ℚ) (ε : ℝ),
       P ≠ 0 → 0 < ε →
       (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
       (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
       T5_DenominatorGrowthCondition q ε →
       T5_DegreeHeightBalanceCondition R q ε →
       rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) →
       rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
         (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε)) :=
  ⟨@T5_BlockC_rothIndex_at_q_tuple_bound,
   @T5_BlockC_rothIndex_at_q_tuple_simplified⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_IndexAtQTupleBound
