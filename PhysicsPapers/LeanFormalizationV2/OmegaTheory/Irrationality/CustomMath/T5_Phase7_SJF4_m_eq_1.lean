/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJF4_m_eq_1

  T-5 (Roth's theorem) — **SJF-4 (balance) m=1 case UNCONDITIONALLY DISCHARGED**.

  For m=1, the balance condition is trivially satisfied:
    ∃ C > 0, |R 0 · log d - C| ≤ C · ε
  Take C := R 0 · log d. Then |0| = 0 ≤ C · ε.
  C > 0 requires d ≥ 2 (so log d > 0). D4's bumped pigeonhole sequence
  starts with denominator ≥ 2 (chooses M=1 threshold), satisfying this.

  The growth condition for m=1 is VACUOUS (no `i+1 < 1` for i : Fin 1
  with i.val=0).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJF4_m_eq_1

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## SJF4M1-1 — Schmidt joint d (balance) m=1 NAMED Prop -/

/-- **SJF4M1-1 — `T5_NAMED_Schmidt_joint_d_balance_m_eq_1`** [m=1 case].

    For m=1, balance + growth + violator existence reduces to:
    - violator: q_seq n 0 ∈ T5_RothViolatingSet α ε
    - growth: vacuous (no i+1 < 1)
    - balance: ∃ C > 0, |R 0 · log d - C| ≤ C · ε

    For m=1 with d ≥ 2: take C := R 0 · log d, get |0| ≤ Cε. -/
def T5_NAMED_Schmidt_joint_d_balance_m_eq_1 : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ (R : Fin 1 → ℕ), 0 < R 0 →
  T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) →
  ∃ (q_seq : ℕ → Fin 1 → ℚ),
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
    (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) ∧
    (∀ n, T5_DegreeHeightBalanceCondition R (q_seq n) ε)

/-! ## SJF4M1-2 — Growth condition is vacuous for m=1 -/

/-- For m=1, the growth condition holds trivially since there's no
    `i+1 < 1` for i : Fin 1. -/
theorem growth_vacuous_m_eq_1
    (q : Fin 1 → ℚ) (ε : ℝ) :
    T5_DenominatorGrowthCondition q ε := by
  unfold T5_DenominatorGrowthCondition
  intros i h_succ
  -- i : Fin 1, so i.val = 0; i.val + 1 = 1; 1 < 1 is False
  exfalso
  have : i.val < 1 := i.isLt
  omega

/-! ## SJF4M1-3 — Balance for m=1 with d ≥ 2 -/

/-- For m=1 with q.den ≥ 2 and R 0 > 0, the balance condition holds via
    C := R 0 · log d. -/
theorem balance_m_eq_1_of_den_ge_2
    (R : Fin 1 → ℕ) (hR_pos : 0 < R 0)
    (q : Fin 1 → ℚ) (h_den_ge : 2 ≤ (q 0).den)
    (ε : ℝ) (hε : 0 < ε) :
    T5_DegreeHeightBalanceCondition R q ε := by
  unfold T5_DegreeHeightBalanceCondition
  -- Take C := R 0 · log (q 0).den
  refine ⟨(R 0 : ℝ) * Real.log ((q 0).den : ℝ), ?_, ?_⟩
  · -- C > 0: R 0 ≥ 1, log d > 0 since d ≥ 2 > 1
    have h_R_pos : (0 : ℝ) < (R 0 : ℝ) := by exact_mod_cast hR_pos
    have h_log_pos : (0 : ℝ) < Real.log ((q 0).den : ℝ) := by
      apply Real.log_pos
      have : (2 : ℝ) ≤ ((q 0).den : ℝ) := by exact_mod_cast h_den_ge
      linarith
    exact mul_pos h_R_pos h_log_pos
  · intro i
    -- For i : Fin 1, i = 0, so the term is exactly C, |0| = 0 ≤ Cε
    have h_eq : (R i : ℝ) * Real.log ((q i).den : ℝ) =
                (R 0 : ℝ) * Real.log ((q 0).den : ℝ) := by
      have : i = 0 := by
        ext
        have := i.isLt
        omega
      rw [this]
    rw [h_eq]
    simp only [sub_self, abs_zero]
    -- 0 ≤ C * ε with C > 0 and ε > 0
    have h_R_pos : (0 : ℝ) < (R 0 : ℝ) := by exact_mod_cast hR_pos
    have h_log_pos : (0 : ℝ) < Real.log ((q 0).den : ℝ) := by
      apply Real.log_pos
      have : (2 : ℝ) ≤ ((q 0).den : ℝ) := by exact_mod_cast h_den_ge
      linarith
    have h_C_pos : (0 : ℝ) < (R 0 : ℝ) * Real.log ((q 0).den : ℝ) :=
      mul_pos h_R_pos h_log_pos
    have h_Ce_pos : (0 : ℝ) < (R 0 : ℝ) * Real.log ((q 0).den : ℝ) * ε :=
      mul_pos h_C_pos hε
    linarith

/-! ## SJF4M1-4 — Discharge using D4 pigeonhole + balance witness -/

/-- **🚨🚨🚨 SJF4M1-4 — `T5_Schmidt_joint_d_balance_m_eq_1_unconditional`**:
    UNCONDITIONAL discharge of SJF-4 m=1 case.

    Witness: D4's bumped pigeonhole sequence (T5_pigeonholeSeq_diagonal)
    gives violator + unbounded denominators. Growth is vacuous for m=1.
    Balance derives from `R 0 · log d_n` per-n. -/
theorem T5_Schmidt_joint_d_balance_m_eq_1_unconditional :
    T5_NAMED_Schmidt_joint_d_balance_m_eq_1 := by
  intros α _hα ε hε R hR_pos h_unbd
  -- Use D4's pigeonhole_diagonal sequence at m=1
  refine ⟨T5_pigeonholeSeq_diagonal h_unbd ε 1, ?_, ?_, ?_⟩
  · -- Violator membership
    intros n j
    exact T5_pigeonholeSeq_diagonal_mem h_unbd ε 1 n j
  · -- Growth: vacuous for m=1
    intro n
    exact growth_vacuous_m_eq_1 _ ε
  · -- Balance: per-n witness C := R 0 · log d_n with d_n ≥ 2
    intro n
    apply balance_m_eq_1_of_den_ge_2 R hR_pos _ ?_ ε hε
    -- Need: 2 ≤ (T5_pigeonholeSeq_diagonal ... n 0).den
    -- D4's bumped chain starts with den > 1, i.e., den ≥ 2, then strictly monotone increasing
    -- T5_pigeonholeSeq_diagonal h_unbd ε 1 n j = T5_pigeonholeSeq_bumped h_unbd ε (n*1 + j.val)
    -- For j = 0: = T5_pigeonholeSeq_bumped h_unbd ε n
    -- T5_pigeonholeSeq_bumped 0 = Classical.choose (h_unbd 1) which has den > 1, i.e., den ≥ 2
    -- For n ≥ 1, strict monotonicity gives den > prev.den ≥ 2
    have h_den_ge_2 : 2 ≤ (T5_pigeonholeSeq_bumped h_unbd ε n).den := by
      induction n with
      | zero =>
        -- T5_pigeonholeSeq_bumped 0 = Classical.choose (h_unbd 1)
        -- (Classical.choose_spec (h_unbd 1)).2 : 1 < (Classical.choose (h_unbd 1)).den
        show 2 ≤ (Classical.choose (h_unbd 1)).den
        have h_spec := (Classical.choose_spec (h_unbd 1)).2
        -- h_spec : 1 < ...
        omega
      | succ k ih =>
        have h_mono := T5_pigeonholeSeq_bumped_strict_mono h_unbd ε k
        omega
    -- T5_pigeonholeSeq_diagonal h_unbd ε 1 n 0 = T5_pigeonholeSeq_bumped h_unbd ε (n*1 + 0) = T5_pigeonholeSeq_bumped h_unbd ε n
    show 2 ≤ (T5_pigeonholeSeq_diagonal h_unbd ε 1 n 0).den
    unfold T5_pigeonholeSeq_diagonal
    -- n*1 + 0 = n
    simp
    exact h_den_ge_2

/-! ## SJF4M1-5 — Headline -/

/-- **🚨🚨🚨🚨 SJF4M1-5 — `T5_SJF4_M_EQ_1_DISCHARGE_HEADLINE`**:
    paper-citable m=1 case discharge.

    Strategic significance: closes the m=1 sub-case of SJF-4 (Schmidt
    joint balance) UNCONDITIONALLY. The m≥2 case remains HEART
    (R-aware d_i ≈ exp(C/R_i) tuning per Hindry-Silverman §D.7). -/
theorem T5_SJF4_M_EQ_1_DISCHARGE_HEADLINE :
    T5_NAMED_Schmidt_joint_d_balance_m_eq_1 :=
  T5_Schmidt_joint_d_balance_m_eq_1_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJF4_m_eq_1
