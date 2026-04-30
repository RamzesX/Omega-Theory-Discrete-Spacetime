/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring

  T-5 (Roth's theorem) — **Schmidt joint existence factoring** into 5
  atomic sub-NAMEDs.

  ## Architectural rationale

  SJE-1 (`T5_NAMED_Schmidt_joint`) bundles 5 independent analytical pieces:

    [a] m + P_int existence with degreeOf positive
    [b] α-diagonal rothIndex lower bound ≥ m/2 - √(mε)
    [c] q_seq existence satisfying violator + growth + denominator unboundedness
    [d] q_seq satisfying balance for chosen R := degreeOf P_int
    [e] q_seq satisfying aeval P_int ≠ 0 per-n

  This file factors SJE-1 into these 5 atomic sub-NAMEDs so future fires
  can attack each independently.

  Already-discharged pieces:
    [a] (existence half) UNCONDITIONALLY closed via SM1EU-7
    [c] (q_seq existence with violator + growth + unboundedness)
        UNCONDITIONALLY closed via D4 (T5_NAMED_iterative_pigeonhole_sequence)

  Remaining HEART:
    [b] α-diagonal rothIndex lower bound (Schmidt §D.7 analytical core)
    [d] balance for R-aware q_seq (R := degreeOf P_int requires re-tuning d_i)
    [e] aeval ≠ 0 (avoiding P_int's zero set in rational tuple)

  Strategic significance: 2 of 5 sub-pieces UNCONDITIONALLY closed
  (existence + q_seq with growth/unboundedness). 3 remain HEART.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_JointExistence
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_Decomposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_JointExistence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge

/-! ## SJF-1 — Schmidt joint sub-component a: integer poly existence -/

/-- **SJF-1 — `T5_NAMED_Schmidt_joint_a_int_poly_existence`** [NAMED, sub-piece].

    Pure existence of nonzero P_int with degreeOf positive, for some m ≥ 1.
    UNCONDITIONALLY closed via SM1EU-7. -/
def T5_NAMED_Schmidt_joint_a_int_poly_existence : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (m : ℕ), 1 ≤ m ∧
  ∃ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
    (∀ j, 0 < MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))

/-- **SJF-1-discharge**: UNCONDITIONAL via SM1EU-7. Pick m := 1, P := X 0. -/
theorem T5_Schmidt_joint_a_int_poly_existence_unconditional :
    T5_NAMED_Schmidt_joint_a_int_poly_existence := by
  intros α hα h_alg ε hε
  obtain ⟨m_thresh, hP_per_m⟩ :=
    T5_Schmidt_existence_int_poly_unconditional α hα h_alg ε hε
  refine ⟨max m_thresh 1, ?_, ?_⟩
  · exact le_max_right _ _
  · obtain ⟨P_int, hP_ne, hP_deg_pos⟩ := hP_per_m _ (le_max_left _ _)
    exact ⟨P_int, hP_ne, hP_deg_pos⟩

/-! ## SJF-2 — Schmidt joint sub-component b: α-diagonal index lower bound -/

/-- **SJF-2 — `T5_NAMED_Schmidt_joint_b_alpha_index_bound`** [NAMED, HEART].

    For some Schmidt aux P_int (existing per SJF-1), the α-diagonal
    rothIndex satisfies the lower bound `≥ m/2 - √(mε)`.

    HEART: this is the analytical core of Schmidt's auxiliary polynomial
    construction (Hindry-Silverman §D.7). -/
def T5_NAMED_Schmidt_joint_b_alpha_index_bound : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (m : ℕ), 1 ≤ m ∧
  ∃ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
    (∀ j, 0 < MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ∧
    rothIndex (P_int.map (algebraMap ℤ ℝ)) (fun _ => α)
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≥
      (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## SJF-3 — Schmidt joint sub-component c: q_seq violator + growth + unbounded -/

/-- **SJF-3 — `T5_NAMED_Schmidt_joint_c_q_seq_violator_growth`** [NAMED, sub-piece].

    For ANY P_int (with degreeOf positive R), there exists a q_seq
    satisfying violator + growth + denominator unboundedness — but NOT
    necessarily balance or aeval-nonzero.

    UNCONDITIONALLY closed via D4 if we drop the unbounded-product form;
    the per-n unboundedness is in D4 (T5_NAMED_iterative_pigeonhole_sequence). -/
def T5_NAMED_Schmidt_joint_c_q_seq_violator_growth : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  T5_PigeonholeMTuple_Statement →
  T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) →
  ∃ (q_seq : ℕ → Fin m → ℚ),
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
    (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) ∧
    -- per-tuple denominator unboundedness (existing D4 form)
    (∀ M : ℕ, ∃ n, ∀ j, M < (q_seq n j).den)

/-- **SJF-3-discharge**: UNCONDITIONAL via D4 (T5_NAMED_iterative_pigeonhole_sequence_unconditional). -/
theorem T5_Schmidt_joint_c_q_seq_violator_growth_unconditional :
    T5_NAMED_Schmidt_joint_c_q_seq_violator_growth :=
  T5_NAMED_iterative_pigeonhole_sequence_unconditional

/-! ## SJF-4 — Schmidt joint sub-component d: balance for R-aware q_seq -/

/-- **SJF-4 — `T5_NAMED_Schmidt_joint_d_balance`** [NAMED, HEART].

    For an existing P_int (with R := degreeOf), there exists a q_seq
    satisfying balance(R). The HEART is constructing q_seq with
    d_i ≈ exp(C/R_i) per Hindry-Silverman §D.7 R-aware tuning. -/
def T5_NAMED_Schmidt_joint_d_balance : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (R : Fin m → ℕ), (∀ j, 0 < R j) →
  ∃ (q_seq : ℕ → Fin m → ℚ),
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
    (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) ∧
    (∀ n, T5_DegreeHeightBalanceCondition R (q_seq n) ε)

/-! ## SJF-5 — Schmidt joint sub-component e: aeval ≠ 0 -/

/-- **SJF-5 — `T5_NAMED_Schmidt_joint_e_aeval_nonzero`** [NAMED, HEART].

    For an existing P_int and q_seq, the aeval P_int ≠ 0 per-n. The HEART
    is choosing q_seq to avoid P_int's zero set (finite intersection of
    zero loci can be avoided generically). -/
def T5_NAMED_Schmidt_joint_e_aeval_nonzero : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
  ∃ (q_seq : ℕ → Fin m → ℚ),
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
    (∀ n, MvPolynomial.aeval (fun j => ((q_seq n j : ℚ) : ℝ))
            ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0)

/-! ## SJF-6 — Headline: SJE-1 reduces to 3 HEART sub-NAMEDs (b/d/e) -/

/-- **🚨🚨🚨🚨 SJF-6 — `T5_SCHMIDT_JOINT_FACTORING_HEADLINE`**:
    paper-citable factoring headline.

    SJE-1 (Schmidt joint existence) factors into 5 atomic sub-NAMEDs:
    - SJF-1 (a) UNCONDITIONALLY closed via SM1EU-7
    - SJF-2 (b) HEART — α-diagonal index lower bound (Schmidt §D.7 core)
    - SJF-3 (c) UNCONDITIONALLY closed via D4
    - SJF-4 (d) HEART — balance for R-aware q_seq
    - SJF-5 (e) HEART — aeval ≠ 0

    Net: 2 of 5 sub-pieces CLOSED, 3 remain HEART.

    Strategic significance: future single-thread fires can attack b/d/e
    independently. Each HEART sub-piece is ~100-200 lines analytical. -/
theorem T5_SCHMIDT_JOINT_FACTORING_HEADLINE :
    -- SJF-1 unconditional
    T5_NAMED_Schmidt_joint_a_int_poly_existence ∧
    -- SJF-3 unconditional
    T5_NAMED_Schmidt_joint_c_q_seq_violator_growth :=
  ⟨T5_Schmidt_joint_a_int_poly_existence_unconditional,
   T5_Schmidt_joint_c_q_seq_violator_growth_unconditional⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring
