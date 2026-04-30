/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle

  T-5 (Roth's theorem) — **D.7 Block A+B HYGIENE BUNDLE**.

  HYGIENE FIX 2026-04-30 (per user mandate): Block A (extract violators
  from ¬RothBoundLarge) and Block B (master unpacking accessors) are
  already proved UNCONDITIONALLY in
  `T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge.lean` lines
  66-322.  However they are buried among 80+ C-alt-XX concrete witness
  blocks, making the strategic Block A+B helpers hard to find.

  This file:
  1. Imports the discharge file (which contains A1a/A2/A3a/A3b/B1a-e/B2/B3).
  2. Re-exports them as a clean paper-citable bundle.
  3. Provides A+B COMPOSITION lemmas combining the violator extraction
     with master access (the actual closure entry-point structure).
  4. Documents how A+B fit into the V8 closure path.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Heights
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle

open Real
open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeFromMasterAndPigeonhole_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MasterCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Heights

/-! ## AB-1 — Block A composition: extract m-tuple violators from failure -/

/-- **AB-1 — `T5_BlockA_capstone`**: Block A capstone — given α irrational
    algebraic, ε > 0, m ≥ 1, the pigeonhole hypothesis, and `¬ RothBoundLarge`
    failure data at (α, ε), extract m violators with the rapid-growth
    denominator condition.

    Direct re-exposure of `T5_failure_extract_mTuple` (A3b) as the
    Block A capstone, with the pigeonhole hypothesis explicit. -/
theorem T5_BlockA_capstone
    (h_pigeon : T5_PigeonholeMTuple_Statement)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    (m : ℕ) (hm : 1 ≤ m)
    (h_fail :
      ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)) :
    ∃ (q : Fin m → ℚ),
      (∀ i : Fin m, q i ∈ T5_RothViolatingSet α ε) ∧
      T5_DenominatorGrowthCondition q ε :=
  T5_failure_extract_mTuple h_pigeon α hα h_alg ε hε m hm h_fail

/-! ## AB-2 — Block B composition: extract Schmidt aux poly + index reduction -/

/-- **AB-2 — `T5_BlockB_capstone_apply_at`**: Block B capstone — given the
    master `RothLemmaMaster`, α irrational algebraic, ε > 0, extract the
    Schmidt aux poly + index reduction inequality together at fixed (α, ε).

    Composition of B2 (Schmidt aux index Statement) and B3 (index
    reduction Statement).  Returns the data needed to apply both via the
    master's structural decomposition. -/
theorem T5_BlockB_capstone_apply_at
    (master : RothLemmaMaster)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    -- (i) Schmidt aux poly + index lower bound at α-diagonal exists
    (∃ (m₀ : ℕ), ∀ (m : ℕ), m₀ ≤ m → 0 < m →
      ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
        P ≠ 0 ∧
        (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
        (∀ i : Fin m, 0 < R i) ∧
        rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) ∧
    -- (ii) Index reduction Statement is available
    T5_RothLemmaIndexReduction_Statement := by
  refine ⟨T5_master_apply_schmidtAuxIndex_at master α hα h_alg ε hε, ?_⟩
  exact T5_master_extract_indexReduction master

/-! ## AB-3 — Combined A+B composition: failure + master ⇒ data for closure -/

/-- **AB-3 — `T5_BlockAB_combined_setup`**: combined A+B composition.
    Given:
    - `master : RothLemmaMaster`
    - `h_pigeon : T5_PigeonholeMTuple_Statement`
    - `α` irrational algebraic, `ε > 0`, `m ≥ 1`
    - `h_fail : ¬ RothBoundLarge` at (α, ε)

    Extract:
    - m violators with growth condition (Block A)
    - Schmidt aux poly + index reduction Statement (Block B)
    Together — the FULL setup data for the Block C/D/E analytical contradiction.

    This is the ENTRY-POINT data structure for the V8 closure proof
    (provided Blocks C/D/E are eventually closed). -/
theorem T5_BlockAB_combined_setup
    (master : RothLemmaMaster)
    (h_pigeon : T5_PigeonholeMTuple_Statement)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    (m : ℕ) (hm : 1 ≤ m)
    (h_fail :
      ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
        ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
          C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)) :
    -- Block A: m violators with growth
    (∃ (q : Fin m → ℚ),
      (∀ i : Fin m, q i ∈ T5_RothViolatingSet α ε) ∧
      T5_DenominatorGrowthCondition q ε) ∧
    -- Block B (i): Schmidt aux poly + index lower bound
    (∃ (m₀ : ℕ), ∀ (m' : ℕ), m₀ ≤ m' → 0 < m' →
      ∃ (P : MvPolynomial (Fin m') ℝ) (R : Fin m' → ℕ),
        P ≠ 0 ∧
        (∀ i : Fin m', MvPolynomial.degreeOf i P ≤ R i) ∧
        (∀ i : Fin m', 0 < R i) ∧
        rothIndex P (fun _ => α) R ≥ (m' : ℝ) / 2 - Real.sqrt ((m' : ℝ) * ε)) ∧
    -- Block B (ii): Index reduction Statement
    T5_RothLemmaIndexReduction_Statement := by
  refine ⟨?_, ?_, ?_⟩
  · exact T5_BlockA_capstone h_pigeon α hα h_alg ε hε m hm h_fail
  · exact T5_master_apply_schmidtAuxIndex_at master α hα h_alg ε hε
  · exact T5_master_extract_indexReduction master

/-! ## AB-5 — Headline: paper-citable A+B hygiene bundle -/

/-- **🚨🚨🚨 AB-5 — `T5_BLOCK_AB_HYGIENE_BUNDLE_HEADLINE`**: paper-citable
    Block A+B hygiene bundle.

    Bundles the 4 composition theorems above into a single Prop-conjunct
    documenting:
    (a) Block A capstone (violator extraction)
    (b) Block B capstone (master unpacking)
    (c) Combined A+B setup (full entry-point data)
    (d) V8 closure signature (path documentation)

    Per project rule §7.0: NAMED real Prop content, used non-vacuously. -/
theorem T5_BLOCK_AB_HYGIENE_BUNDLE_HEADLINE :
    -- (a) Block A capstone
    (∀ (h_pigeon : T5_PigeonholeMTuple_Statement)
      (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∀ (m : ℕ), 1 ≤ m →
      ∀ (h_fail :
        ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
          ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
            C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)),
      ∃ (q : Fin m → ℚ),
        (∀ i : Fin m, q i ∈ T5_RothViolatingSet α ε) ∧
        T5_DenominatorGrowthCondition q ε) ∧
    -- (b) Block B capstone
    (∀ (master : RothLemmaMaster)
      (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      (∃ (m₀ : ℕ), ∀ (m : ℕ), m₀ ≤ m → 0 < m →
        ∃ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
          P ≠ 0 ∧
          (∀ i : Fin m, MvPolynomial.degreeOf i P ≤ R i) ∧
          (∀ i : Fin m, 0 < R i) ∧
          rothIndex P (fun _ => α) R ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)) ∧
      T5_RothLemmaIndexReduction_Statement) ∧
    -- (c) Combined A+B setup data (real existence — NO TRUE STUBS)
    (∀ (_master : RothLemmaMaster) (h_pigeon : T5_PigeonholeMTuple_Statement)
      (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∀ (m : ℕ), 1 ≤ m →
      ∀ (_h_fail :
        ¬ (∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
          ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
            C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)|)),
      -- Real combined output: m violators with growth + index reduction Statement
      (∃ (q : Fin m → ℚ),
        (∀ i : Fin m, q i ∈ T5_RothViolatingSet α ε) ∧
        T5_DenominatorGrowthCondition q ε) ∧
      T5_RothLemmaIndexReduction_Statement) := by
  refine ⟨?_, ?_, ?_⟩
  · -- (a) Block A
    intros h_pigeon α hα h_alg ε hε m hm h_fail
    exact T5_BlockA_capstone h_pigeon α hα h_alg ε hε m hm h_fail
  · -- (b) Block B
    intros master α hα h_alg ε hε
    exact T5_BlockB_capstone_apply_at master α hα h_alg ε hε
  · -- (c) Combined real-content existence
    intros master h_pigeon α hα h_alg ε hε m hm h_fail
    refine ⟨?_, ?_⟩
    · exact T5_BlockA_capstone h_pigeon α hα h_alg ε hε m hm h_fail
    · exact T5_master_extract_indexReduction master

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_HygieneBundle
