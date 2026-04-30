/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockCDE_Composition

  T-5 (Roth's theorem) — **V7 BLOCK CDE COMPOSITION THEOREM**.

  Combines V7-N1-uniform hypothesis + V7-N2 unconditional + V7-N3
  unconditional (via SEQ-3) into a single composition theorem deriving
  False from a Roth-violating sequence setup.

  This is the V7 capstone Block C+D+E, leaving only Block A+B (extract
  m-tuple sequence from ¬RothBoundLarge + master) as remaining work
  for full V7 composition.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real composition proof.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockE_SequenceApplications
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockCDE_Composition

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockE_SequenceApplications
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

/-! ## CDE-1 — V7 Block CDE composition deriving False -/

/-- **🚨🚨🚨 CDE-1 — `T5_V7_BlockCDE_compose_False`**: V7 Block CDE
    composition theorem.

    Given:
    - V7-N1-uniform hypothesis (uniform κ Block C upper bound)
    - α algebraic irrational, ε > 0, m ≥ 1
    - Integer polynomial P_int : MvPolynomial (Fin m) ℤ (e.g., Schmidt
      aux polynomial), with P_int.map ℝ ≠ 0
    - Sequence of m-tuples q_seq : ℕ → Fin m → ℚ satisfying:
      * Per-n violator: q_seq n j ∈ RothViolatingSet α ε
      * Per-n growth + balance + index bound conditions
      * Per-n aeval ≠ 0 (so V7-N2 lower bound applies)
      * D := ∏ q_j.den^{degreeOf j P} unbounded as n grows
    - Block A+B output: a Roth-violating m-tuple sequence
    derive False.

    Proof:
    1. Extract uniform (C_upper, κ) from V7-N1-uniform (V7N1U-3)
    2. Apply SEQ-3 (V7-N2 baked in for lower bound, V7-N3 collide)
    3. Per-n upper bound from V7-N1-uniform.

    Strategic significance: V7 capstone Block CDE is FULLY MACHINE-CHECKED.
    Only Block A+B (extracting the m-tuple sequence) remains as
    independent infrastructure work. -/
theorem T5_V7_BlockCDE_compose_False
    (h_V7N1_uniform : T5_NAMED_BlockC_Taylor_upper_bound_uniform)
    (α : ℝ) (h_irr : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε)
    {m : ℕ} (hm : 1 ≤ m)
    (P_int : MvPolynomial (Fin m) ℤ)
    (h_P_ne : (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0)
    (h_R_pos : ∀ i, 0 <
      MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ)))
    (q_seq : ℕ → Fin m → ℚ)
    (h_violator : ∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε)
    (h_growth : ∀ n, T5_DenominatorGrowthCondition (q_seq n) ε)
    (h_balance : ∀ n, T5_DegreeHeightBalanceCondition
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
      (q_seq n) ε)
    (h_index : ∀ n, rothIndex (P_int.map (algebraMap ℤ ℝ))
      (fun j => ((q_seq n j : ℚ) : ℝ))
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≤
      (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε))
    (h_eval_ne : ∀ n, aeval (fun j => ((q_seq n j : ℚ) : ℝ))
      ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0)
    (h_unbounded : ∀ M : ℝ, ∃ n,
      M < ∏ j, ((q_seq n j).den : ℝ) ^
        (MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)) : ℕ)) :
    False := by
  -- Setup
  set P : MvPolynomial (Fin m) ℝ := P_int.map (algebraMap ℤ ℝ) with hP_def
  set R : Fin m → ℕ := fun j => MvPolynomial.degreeOf j P with hR_def
  -- V7-N1-uniform extraction: (C_upper, κ) uniform across q_seq
  obtain ⟨C_upper, κ, hC, hκ, h_bound⟩ :=
    T5_V7N1_uniform_extract h_V7N1_uniform α h_irr h_alg ε hε hm P R
      h_P_ne (fun i => le_refl _) h_R_pos
  -- Apply SEQ-3 (V7-N2 + V7-N3 collide)
  apply T5_V7N3_collide_with_V7N2_lower_per_poly hm P_int q_seq
    C_upper κ hC hκ h_eval_ne h_unbounded
  -- Per-n upper bound from V7-N1-uniform
  intro n
  exact h_bound (q_seq n) (h_violator n) (h_growth n) (h_balance n)
    (h_index n)

/-! ## CDE-2 — Headline -/

/-- **🚨🚨🚨🚨 CDE-2 — `T5_CDE_BLOCK_CDE_COMPOSITION_HEADLINE`**:
    paper-citable Block CDE composition headline.

    V7 capstone Block CDE composition is now MACHINE-CHECKED.  Given:
    - V7-N1-uniform hypothesis (multivariate Taylor upper bound, uniform κ)
    - Block A+B output: Roth-violating sequence with growth + balance
      + index bound + unbounded D-set
    derive False.

    Remaining work for full V7 capstone: Block A+B (extract sequence
    from ¬RothBoundLarge + master) and discharge V7-N1-uniform itself. -/
theorem T5_CDE_BLOCK_CDE_COMPOSITION_HEADLINE :
    T5_NAMED_BlockC_Taylor_upper_bound_uniform →
    ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
    ∀ (ε : ℝ), 0 < ε →
    ∀ {m : ℕ}, 1 ≤ m →
    ∀ (P_int : MvPolynomial (Fin m) ℤ),
      (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      (∀ i, 0 < MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ))) →
    ∀ (q_seq : ℕ → Fin m → ℚ),
      (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) →
      (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) →
      (∀ n, T5_DegreeHeightBalanceCondition
        (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
        (q_seq n) ε) →
      (∀ n, rothIndex (P_int.map (algebraMap ℤ ℝ))
        (fun j => ((q_seq n j : ℚ) : ℝ))
        (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≤
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε)) →
      (∀ n, aeval (fun j => ((q_seq n j : ℚ) : ℝ))
        ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) →
      (∀ M : ℝ, ∃ n,
        M < ∏ j, ((q_seq n j).den : ℝ) ^
          (MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)) : ℕ)) →
      False := by
  intros h_V7N1_uniform α h_irr h_alg ε hε m hm P_int h_P_ne h_R_pos
    q_seq h_violator h_growth h_balance h_index h_eval_ne h_unbounded
  exact T5_V7_BlockCDE_compose_False h_V7N1_uniform α h_irr h_alg ε hε hm
    P_int h_P_ne h_R_pos q_seq h_violator h_growth h_balance h_index
    h_eval_ne h_unbounded

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockCDE_Composition
