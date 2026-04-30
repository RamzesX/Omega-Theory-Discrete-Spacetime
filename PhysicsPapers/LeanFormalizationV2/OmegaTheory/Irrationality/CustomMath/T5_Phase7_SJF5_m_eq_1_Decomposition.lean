/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJF5_m_eq_1_Decomposition

  T-5 (Roth's theorem) — **SJF-5 (aeval ≠ 0) m=1 case decomposition**.

  SJF-5 (T5_NAMED_Schmidt_joint_e_aeval_nonzero) for m=1 reduces to
  showing ∃ q_seq from D4's pigeonhole chain (shifted past finite root
  set) such that violator + aeval ≠ 0 per-n.

  This file:
    1. Defines T5_NAMED_Schmidt_joint_e_aeval_nonzero_m_eq_1 Prop.
    2. Decomposes into 2 sub-NAMEDs:
       - SJF5M1-A: ∃ skip such that all D4-chain positions ≥ skip have
                   aeval P_real ≠ 0 (HEART, requires finite-root argument)
       - SJF5M1-B: shifted chain `λ n, chain (n + skip)` satisfies
                   violator condition (UNCONDITIONAL via D4)
    3. Proves SJF5M1-A + SJF5M1-B → SJF-5 m=1 case.

  Strategic significance: factors HEART (finite-root skip) out of
  SJF-5 m=1 case, making the analytical content explicit.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJF5_m_eq_1_Decomposition

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_D4_PigeonholeSequence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring

/-! ## SJF5M1-1 — m=1 case Prop -/

/-- **SJF5M1-1 — `T5_NAMED_Schmidt_joint_e_aeval_nonzero_m_eq_1`**
    [m=1 case of SJF-5].

    For α irrational, ε > 0, P_int : MvPolynomial (Fin 1) ℤ nonzero,
    ∃ q_seq : ℕ → Fin 1 → ℚ satisfying violator + aeval ≠ 0 per-n. -/
def T5_NAMED_Schmidt_joint_e_aeval_nonzero_m_eq_1 : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ (P_int : MvPolynomial (Fin 1) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin 1) ℝ) ≠ 0 →
  T5_HasUnboundedDenominators (T5_RothViolatingSet α ε) →
  ∃ (q_seq : ℕ → Fin 1 → ℚ),
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
    (∀ n, MvPolynomial.aeval (fun j => ((q_seq n j : ℚ) : ℝ))
            ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin 1) ℝ) ≠ 0)

/-! ## SJF5M1-2 — Sub-NAMED A: skip existence (HEART) -/

/-- **SJF5M1-2 — `T5_NAMED_skip_for_aeval_nonzero_m_eq_1`** [HEART].

    For nonzero univariate polynomial P_real over ℝ (with integer
    coefficient origin), ∃ skip : ℕ such that for all n ≥ skip, the
    bumped pigeonhole chain at position n evaluates P_real to nonzero.

    Discharge plan (~80 lines, finite-root + Mathlib roots):
    1. P_real has finite real roots (≤ deg P).
    2. Pigeonhole chain has strictly monotone denominators, hence
       distinct rational values.
    3. At most |roots(P_real) ∩ ℚ| ≤ deg(P_real) chain positions hit
       roots.
    4. Take skip := max(bad positions) + 1. -/
def T5_NAMED_skip_for_aeval_nonzero_m_eq_1 : Prop :=
  ∀ (α : ℝ), ∀ (ε : ℝ), 0 < ε →
  ∀ (P_int : MvPolynomial (Fin 1) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin 1) ℝ) ≠ 0 →
  ∀ (h_unbd : T5_HasUnboundedDenominators (T5_RothViolatingSet α ε)),
  ∃ (skip : ℕ), ∀ (n : ℕ),
    MvPolynomial.aeval
      (fun _ : Fin 1 => ((T5_pigeonholeSeq_bumped h_unbd ε (n + skip) : ℚ) : ℝ))
      ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin 1) ℝ) ≠ 0

/-! ## SJF5M1-3 — Composition: SJF5M1-2 ⇒ SJF5M1-1 -/

/-- **SJF5M1-3 — `T5_SJF5_m_eq_1_via_skip`**: composition theorem.

    Given the skip existence (SJF5M1-2), SJF-5 m=1 case follows by
    taking q_seq := λ n j, T5_pigeonholeSeq_bumped (n + skip).

    Violator condition: pigeonhole chain ⊆ violator set (D4 lemma).
    aeval ≠ 0: directly from skip property. -/
theorem T5_SJF5_m_eq_1_via_skip
    (h_skip : T5_NAMED_skip_for_aeval_nonzero_m_eq_1) :
    T5_NAMED_Schmidt_joint_e_aeval_nonzero_m_eq_1 := by
  intros α _hα ε hε P_int hP_ne h_unbd
  obtain ⟨skip, h_aeval⟩ := h_skip α ε hε P_int hP_ne h_unbd
  -- q_seq n j := T5_pigeonholeSeq_bumped h_unbd ε (n + skip)
  refine ⟨fun n _ => T5_pigeonholeSeq_bumped h_unbd ε (n + skip), ?_, ?_⟩
  · -- Violator: every chain position is a violator
    intros n _j
    exact T5_pigeonholeSeq_bumped_mem h_unbd ε (n + skip)
  · -- aeval ≠ 0: from skip property
    intros n
    exact h_aeval n

/-! ## SJF5M1-4 — Headline -/

/-- **🚨🚨🚨 SJF5M1-4 — `T5_SJF5_M_EQ_1_DECOMPOSITION_HEADLINE`**:
    paper-citable factoring of SJF-5 m=1 case.

    Strategic significance: SJF-5 m=1 case factors into ONE atomic
    HEART sub-NAMED (skip existence via finite-root argument). The
    rest (violator condition, q_seq construction) is UNCONDITIONAL via
    D4 + composition.

    Future fire: ~80 lines on skip discharge using Mathlib
    `Polynomial.setOf_isRoot_finite` + chain distinctness gives
    SJF-5 m=1 case UNCONDITIONALLY closed. -/
theorem T5_SJF5_M_EQ_1_DECOMPOSITION_HEADLINE :
    T5_NAMED_skip_for_aeval_nonzero_m_eq_1 →
    T5_NAMED_Schmidt_joint_e_aeval_nonzero_m_eq_1 :=
  T5_SJF5_m_eq_1_via_skip

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJF5_m_eq_1_Decomposition
