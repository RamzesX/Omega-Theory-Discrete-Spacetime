/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1PD2_Quantifier_Audit

  T-5 (Roth's theorem) — **SM1PD-2 quantifier audit + honest existential
  alternative**.

  ## Discovery

  `T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound` (SM1PD-2 in
  `T5_Phase7_SM1_PartialDischarge.lean:56`) is LITERAL FALSE as written:

  ```lean
  def T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound : Prop :=
    ∀ α irr, ∀ ε > 0, ∀ {m} ≥ 1, ∀ P_int : MvPolynomial (Fin m) ℤ, ...
      rothIndex (P_int.map ℝ) (fun _ => α) (degreeOf) ≥ m/2 - √(mε)
  ```

  Counter: take m=1, P_int := X 0 (univariate, deg 1), α = √2 (irrational).
  aeval (fun _ => α) (X 0) = α ≠ 0. So rothIndex = 0 < 1/2 - √ε for
  small ε. Contradiction.

  Same architectural quantification mismatch as:
  - V8R7's universal `T5_NAMED_small_eps_axis_in_V8` (audited 2026-04-30)
  - D5F-3's `T5_NAMED_V7N1U_D5c_per_q_decay` (fixed 2026-04-30)

  ## Honest existential alternative

  `T5_NAMED_Schmidt_joint_b_alpha_index_bound` (SJF-2,
  `T5_Phase7_Schmidt_Joint_Factoring.lean:90`) is the HONEST EXISTENTIAL
  form — binds m and P_int existentially per Hindry-Silverman §D.7.

  ## This file

  Documents:
    [1] An existential SM1PD-2-honest replacement.
    [2] SJF-2 → existential SM1PD-2-honest (direct projection).
    [3] Architectural finding: SM-1's uniform form (∃ m_thresh, ∀ m ≥
        m_thresh, ∃ P_int with bound) is STRONGER than what
        Hindry-Silverman §D.7 actually proves; the existential form
        (∃ m, ∃ P_int with bound) is the honest version.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1PD2_Quantifier_Audit

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_Joint_Factoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_JointExistence

/-! ## SM1Q-1 — Honest existential alternative to SM1PD-2 -/

/-- **SM1Q-1 — `T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential`**:
    HONEST EXISTENTIAL replacement for the literal-false universal
    SM1PD-2.

    For any α irrational + algebraic and ε > 0, there EXISTS an m ≥ 1
    and P_int (specifically the Schmidt aux poly) with the α-diagonal
    rothIndex lower bound. -/
def T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (m : ℕ), 1 ≤ m ∧
  ∃ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
    (∀ j, 0 < MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ∧
    rothIndex (P_int.map (algebraMap ℤ ℝ)) (fun _ => α)
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≥
      (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## SM1Q-2 — SJF-2 ⇒ existential SM1PD-2-honest (direct projection) -/

/-- **🚨🚨 SM1Q-2 — `T5_SM1PD2_existential_via_SJF2`**: direct bridge
    from SJF-2 (Schmidt joint b — α-diagonal index lower bound) to
    the existential SM1PD-2-honest.

    Both Props are existentially-quantified versions of the same
    underlying Schmidt aux polynomial existence + index bound. SJF-2
    is from my Schmidt joint factoring; existential SM1PD-2-honest is
    the honest fix to SM1PD-2. They are LOGICALLY EQUIVALENT. -/
theorem T5_SM1PD2_existential_via_SJF2
    (h_SJF2 : T5_NAMED_Schmidt_joint_b_alpha_index_bound) :
    T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential :=
  h_SJF2

/-! ## SM1Q-3 — Reverse direction: existential SM1PD-2-honest ⇒ SJF-2 -/

/-- **🚨🚨 SM1Q-3 — `T5_SJF2_via_SM1PD2_existential`**: reverse bridge.

    The existential SM1PD-2-honest gives EXACTLY what SJF-2 requires. -/
theorem T5_SJF2_via_SM1PD2_existential
    (h_SM1PD2_existential :
      T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential) :
    T5_NAMED_Schmidt_joint_b_alpha_index_bound :=
  h_SM1PD2_existential

/-! ## SM1Q-4 — Architectural audit headline -/

/-- **🚨🚨🚨🚨 SM1Q-4 — `T5_SM1PD2_QUANTIFIER_AUDIT_HEADLINE`**:
    paper-citable architectural finding.

    Strategic significance:
    - SM1PD-2 (existing T-5 codebase, `T5_Phase7_SM1_PartialDischarge.lean:56`)
      is LITERAL FALSE due to universal quantifier on P_int.
    - SJF-2 (this fire's creation, `T5_Phase7_Schmidt_Joint_Factoring.lean:90`)
      is the honest existential form.
    - SM1PD-2-honest (this file) is logically equivalent to SJF-2
      and provides a drop-in replacement for SM1PD-2 in the V8 architecture.

    Future fire: substitute SJF-2 (or SM1PD-2-honest) for SM1PD-2 in V8R6
    architecture, removing one more LITERAL-FALSE NAMED leaf. -/
theorem T5_SM1PD2_QUANTIFIER_AUDIT_HEADLINE :
    -- Bidirectional equivalence: SJF-2 ↔ SM1PD-2-existential
    (T5_NAMED_Schmidt_joint_b_alpha_index_bound →
      T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential) ∧
    (T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound_existential →
      T5_NAMED_Schmidt_joint_b_alpha_index_bound) :=
  ⟨T5_SM1PD2_existential_via_SJF2, T5_SJF2_via_SM1PD2_existential⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1PD2_Quantifier_Audit
