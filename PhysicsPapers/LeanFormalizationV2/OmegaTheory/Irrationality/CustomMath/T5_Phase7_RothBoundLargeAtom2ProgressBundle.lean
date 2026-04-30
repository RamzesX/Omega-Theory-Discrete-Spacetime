/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeAtom2ProgressBundle

  T-5 (Roth's theorem) — **D.7 atom-2 closure progress bundle 2026-04-30**.

  Paper-citable unified bundle of THIS-FIRE atom-2 closure work:
  - Block A+B hygiene (entry-point data extraction, clean re-exposure)
  - Block C entry-point bound (rothIndex P at q-tuple ≤ m/2 - 2√(mε))
  - Block C bridge to Block D (low-index witness extraction)
  - Block D pre-foundation (rothIndex contrapositives + sub-threshold vanish)

  REMAINING for atom-2 unconditional discharge:
  - Block C content proper: multivariate Taylor at REAL α giving
    |P(q-tuple)| ≤ analytical bound
  - Block D content proper: integer non-vanishing |P(q-tuple)| ≥ ∏ d_i^{-R_i}
  - Block E: contradiction collide (upper vs lower bound)
  - V7 capstone: omega_theory_v2_T5_roth_paper_headline_V7

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_IndexAtQTupleBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeAtom2ProgressBundle

open Real
open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_IndexAtQTupleBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_RothIndexPosVanish

/-! ## A2P-1 — Combined entry-point + entry-bound chain -/

/-- **A2P-1 — `T5_atom2_BlockAB_to_C_entry_chain`**: end-to-end chain from
    (master + ¬RothBoundLarge + pigeonhole) through Block A+B to the
    Block C entry-point bound.

    Given:
    - master, h_pigeon, α, ε, m, ¬RothBoundLarge data
    - The Schmidt aux poly P, R extracted via master with Schmidt aux index
    - Growth + balance + den-pos + extracted q from Block A
    Derive:
    - rothIndex P at q-tuple ≤ m/2 - 2√(mε)

    This is the PROVABLE chain: NO Block C content needed yet, just
    composition of master accessors + Schmidt aux + index reduction. -/
theorem T5_atom2_BlockAB_to_C_entry_chain
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
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) :=
  T5_BlockC_rothIndex_at_q_tuple_simplified master hm P R α q ε
    hP hε h_deg h_R_pos h_q_pos h_growth h_balance h_lower

/-! ## A2P-2 — Block D pre-foundation entry: aeval-zero from rothIndex bound -/

/-- **A2P-2 — `T5_atom2_aeval_zero_from_not_in_rothIndex_set`**: clean form
    of the rothIndex-set non-membership ⇒ vanishing implication.

    For any j NOT representing a non-vanishing-derivative witness in the
    rothIndex set, `aeval (q-tuple) (multiIteratedPDeriv j P) = 0`.

    Direct contrapositive of the rothIndex set membership definition.
    Used in Block D analytical work to identify which j's give vanishing
    multi-derivatives. -/
theorem T5_atom2_aeval_zero_from_not_in_rothIndex_set
    {m : ℕ}
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (q : Fin m → ℚ)
    (j : Fin m → ℕ)
    (h_not_in_set :
      ¬ (∃ j' : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j' P) ≠ 0 ∧
          (∑ i, (j i : ℝ) / (R i : ℝ)) = ∑ i, (j' i : ℝ) / (R i : ℝ))) :
    aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) = 0 := by
  by_contra h_ne
  apply h_not_in_set
  exact ⟨j, h_ne, rfl⟩

/-! ## A2P-3 — Combined witness extraction (composition of A2P-1 + D-pre-aux8) -/

/-- **A2P-3 — `T5_atom2_low_index_witness_via_master`**: same as
    `T5_BlockC_low_index_witness_at_q_tuple` but from the atom2-progress
    namespace.  Provides the concrete j with non-vanishing derivative
    AND ∑ j_i/R_i < m/2 - 2√(mε) + 1. -/
theorem T5_atom2_low_index_witness_via_master
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
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) + 1 :=
  T5_BlockC_low_index_witness_at_q_tuple master hm P R α q ε
    hP hε h_deg h_R_pos h_q_pos h_growth h_balance h_lower h_aeval_q_ne

/-! ## A2P-4 — Headline: D.7 atom-2 closure progress bundle -/

/-- **🚨🚨🚨🚨 A2P-4 — `T5_ATOM2_PROGRESS_BUNDLE_HEADLINE`**: paper-citable
    progress bundle headline for atom-2 D.7 closure work as of 2026-04-30.

    Bundles the 3 progress theorems above into a 3-conjunct paper-citable
    headline.

    Per project rule §7.0: NAMED real Prop content. -/
theorem T5_ATOM2_PROGRESS_BUNDLE_HEADLINE :
    -- (a) Block A+B → C entry-point chain
    (∀ (master : RothLemmaMaster) {m : ℕ}, 1 ≤ m →
      ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
        (α : ℝ) (q : Fin m → ℚ) (ε : ℝ),
        P ≠ 0 → 0 < ε →
        (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
        (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
        T5_DenominatorGrowthCondition q ε →
        T5_DegreeHeightBalanceCondition R q ε →
        rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) →
        rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
          (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε)) ∧
    -- (b) Block D pre-foundation: not-in-set ⇒ aeval = 0
    (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
      (q : Fin m → ℚ) (j : Fin m → ℕ),
      ¬ (∃ j' : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j' P) ≠ 0 ∧
          (∑ i, (j i : ℝ) / (R i : ℝ)) = ∑ i, (j' i : ℝ) / (R i : ℝ)) →
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) = 0) ∧
    -- (c) Combined low-index witness extraction
    (∀ (master : RothLemmaMaster) {m : ℕ}, 1 ≤ m →
      ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
        (α : ℝ) (q : Fin m → ℚ) (ε : ℝ),
        P ≠ 0 → 0 < ε →
        (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
        (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
        T5_DenominatorGrowthCondition q ε →
        T5_DegreeHeightBalanceCondition R q ε →
        rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) →
        aeval (fun i => ((q i : ℚ) : ℝ)) P ≠ 0 →
        ∃ (j : Fin m → ℕ),
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          (∑ i, (j i : ℝ) / (R i : ℝ)) <
            (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) + 1) :=
  ⟨@T5_atom2_BlockAB_to_C_entry_chain,
   @T5_atom2_aeval_zero_from_not_in_rothIndex_set,
   @T5_atom2_low_index_witness_via_master⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeAtom2ProgressBundle
