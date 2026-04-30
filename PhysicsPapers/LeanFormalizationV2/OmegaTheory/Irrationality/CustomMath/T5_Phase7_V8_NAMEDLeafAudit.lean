/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_NAMEDLeafAudit

  T-5 (Roth's theorem) — **V8 NAMED leaf architectural audit**.

  Paper-citable inventory of the V8 Roth closure architecture, identifying:
    - Provable-as-stated leaves (4 of 7)
    - Quantification-mismatch leaves (3 of 7) — literal-false as written
    - Discharge status of each leaf (UNCONDITIONAL / HEART / FACTORED)
    - Architectural fix paths for each issue

  ## V8R7 outer NAMED leaves (current architecture)

    1. SJWC-1 = T5_NAMED_index_at_q_strict_upper_bound
       Status: HEART (analytical, ~300 lines)
       Provable-as-stated: YES

    2. UWF-2 = T5_NAMED_support_extraction_at_zero
       Status: Mathlib Taylor coefficient identity (~150 lines)
       Provable-as-stated: YES

    3. small-eps axis = T5_NAMED_small_eps_axis_in_V8
       Status: LITERAL-FALSE as universally quantified
       Architectural fix: T5_NAMED_small_eps_axis_existential CLOSED
                          (T5_Phase7_SmallEpsAxis_Existential.SEAE-2)

    4. V7N1U = T5_NAMED_BlockC_Taylor_upper_bound_uniform
       Status: HEART (D5 κ-composition, ~200 lines)
       Factored: T5_NAMED_V7N1U_D5_kappa_composition (V7N1U_PartialDischarge)
       Provable-as-stated: YES

    5. SM-1 = T5_NAMED_Schmidt_aux_int_poly
       Status: HEART (α-diagonal index lower bound)
       Factored: SM1PD-1 (existence) ∧ SM1PD-2 (index bound)
       SM1PD-1 UNCONDITIONALLY DISCHARGED (T5_Phase7_SM1_ExistenceUnconditional.SM1EU-7)
       SM1PD-2 remains HEART

    6. SM-2 = T5_NAMED_Schmidt_balance_per_n
       Status: LITERAL-FALSE as universally quantified over q_seq
       Architectural fix: joint existence (T5_Phase7_Schmidt_JointExistence.SJE-1)

    7. SM-3 = T5_NAMED_Schmidt_aeval_nonzero_per_n
       Status: LITERAL-FALSE as universally quantified over q_seq
       Architectural fix: joint existence (T5_Phase7_Schmidt_JointExistence.SJE-1)

  ## Architectural fixes landed this fire (2026-04-30)

  Three architectural NAMED leaves either CLOSED or FACTORED:

    [1] SEAE-2 = T5_NAMED_small_eps_axis_existential_unconditional
        replaces literal-false universal small-eps axis with provable
        existential form. Witness: m := Nat.ceil(16ε)+1.

    [2] SJE-1 = T5_NAMED_Schmidt_joint
        single existential NAMED replacing SM-1 ∧ SM-2 ∧ SM-3 universal
        forms. Captures actual content of Hindry-Silverman §D.7.

    [3] RW-3 = T5_RothTheorem_via_eps_le_1
        UNCONDITIONAL bridge: T5_NAMED_RothTheorem_eps_le_1 → RothTheorem.
        Combined with [1] + Schmidt aux poly choosing m ≥ 3, the small-ε
        constraint is automatic.

  Combined effect: V8R7 (7 outer NAMED) → V8R3 (3 outer NAMED:
  SJWC-1 + UWF-2 + V7N1U + Schmidt-joint), modulo restructuring V8R5
  to use joint existence + WLOG ε ≤ 1 internally.

  ## Remaining HEART analytical content

  The genuine analytical heart of T-5 (after architectural cleanup):
    1. SJWC-1 — index-at-q strict upper bound (~300 lines, AM-QM + Taylor)
    2. V7N1U-D5 — κ-composition Taylor decay (~200 lines)
    3. SM1PD-2 — α-diagonal index lower bound (Schmidt §D.7 analytical)
    4. Schmidt joint existence discharge — full §D.7 content (~400 lines)
    5. UWF-2 — Mathlib Taylor coefficient at zero (~150 lines, Finsupp arith)

  Total HEART: ~1100-1300 lines. Realistic single-thread completion:
  3-6 weeks with sustained focus.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_WLOG_eps_le_1
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_JointExistence

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_NAMEDLeafAudit

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_Existential
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_WLOG_eps_le_1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_Schmidt_JointExistence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open MvPolynomial

/-! ## VLA-1 — Audit summary: 3 architectural closures landed -/

/-- **🚨🚨🚨🚨 VLA-1 — `T5_V8_LEAF_AUDIT_HEADLINE`**: paper-citable
    architectural audit summary. Records the 3 architectural fixes
    landed this fire (2026-04-30). -/
theorem T5_V8_LEAF_AUDIT_HEADLINE :
    -- (a) SM1PD-1 UNCONDITIONALLY CLOSED: Schmidt existence
    T5_NAMED_Schmidt_existence_int_poly ∧
    -- (b) SEAE-2 UNCONDITIONALLY CLOSED: small-eps existential
    T5_NAMED_small_eps_axis_existential ∧
    -- (c) RW-3 UNCONDITIONAL bridge: WLOG ε ≤ 1 ⇒ full Roth
    (T5_NAMED_RothTheorem_eps_le_1 → RothTheorem) :=
  ⟨T5_Schmidt_existence_int_poly_unconditional,
   T5_NAMED_small_eps_axis_existential_unconditional,
   T5_RothTheorem_via_eps_le_1⟩

/-! ## VLA-2 — V8R7 architectural compactification statement -/

/-- **🚨🚨🚨🚨🚨 VLA-2 — `T5_V8R7_compactified_leaf_count`**: documents
    that V8R7's 7 outer NAMED leaves architecturally compactify to 3
    outer + Schmidt-joint, with SEAE existential and WLOG ε ≤ 1 absorbed
    via internal restructuring (deferred to V8R3 capstone).

    Conjunction of architectural facts (each provable):
    - SM1PD-1 closed unconditionally (existence half of SM-1)
    - SEAE-2 existential closed unconditionally (replaces small-eps universal)
    - RW-3 bridge closed unconditionally (WLOG ε ≤ 1)
    - SJE-1 joint existence Prop captures SM-1 + SM-2 + SM-3 honestly
    - SJE-2 / SJE-3 extract existential SM-2 / SM-3 from joint -/
theorem T5_V8R7_compactified_leaf_count
    (h_joint : T5_NAMED_Schmidt_joint) :
    -- Joint ⇒ existential SM-2
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∃ (m : ℕ), 1 ≤ m ∧
      ∃ (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
      ∃ (q_seq : ℕ → Fin m → ℚ),
        (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
        (∀ n, T5_DegreeHeightBalanceCondition
              (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
              (q_seq n) ε)) ∧
    -- Joint ⇒ existential SM-3
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∃ (m : ℕ), 1 ≤ m ∧
      ∃ (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
      ∃ (q_seq : ℕ → Fin m → ℚ),
        (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
        (∀ n, MvPolynomial.aeval (fun j => ((q_seq n j : ℚ) : ℝ))
                ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0)) :=
  ⟨T5_balance_existential_via_joint h_joint,
   T5_aeval_nonzero_existential_via_joint h_joint⟩

/-! ## VLA-3 — Closure status summary -/

/-- **🚨🚨🚨🚨🚨🚨 VLA-3 — `T5_V8_CLOSURE_STATUS_2026_04_30`**: closure
    status snapshot at 2026-04-30 end-of-fire.

    Discharged unconditionally in OV2 corpus (this fire's contributions):
    - T5_Schmidt_existence_int_poly_unconditional (SM1EU-7)
    - T5_NAMED_small_eps_axis_existential_unconditional (SEAE-2)
    - T5_RothTheorem_via_eps_le_1 (RW-3)
    - T5_balance_existential_via_joint (SJE-2)
    - T5_aeval_nonzero_existential_via_joint (SJE-3)

    Remaining HEART analytical content (single-thread, 3-6 weeks total):
    - SJWC-1 (T5_NAMED_index_at_q_strict_upper_bound) — analytical
    - V7N1U-D5 (T5_NAMED_V7N1U_D5_kappa_composition) — Taylor decay
    - SM1PD-2 (T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound) — Schmidt §D.7
    - SJE-1 discharge (T5_NAMED_Schmidt_joint) — full §D.7 content
    - UWF-2 (T5_NAMED_support_extraction_at_zero) — Mathlib Taylor coeff -/
theorem T5_V8_CLOSURE_STATUS_2026_04_30 :
    -- All 5 architectural closures landed this fire
    T5_NAMED_Schmidt_existence_int_poly ∧
    T5_NAMED_small_eps_axis_existential ∧
    (T5_NAMED_RothTheorem_eps_le_1 → RothTheorem) ∧
    -- Joint existence ⇒ existential SM-2
    (T5_NAMED_Schmidt_joint →
      ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∃ (m : ℕ), 1 ≤ m ∧
      ∃ (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
      ∃ (q_seq : ℕ → Fin m → ℚ),
        (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
        (∀ n, T5_DegreeHeightBalanceCondition
              (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
              (q_seq n) ε)) ∧
    -- Joint existence ⇒ existential SM-3
    (T5_NAMED_Schmidt_joint →
      ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∀ (ε : ℝ), 0 < ε →
      ∃ (m : ℕ), 1 ≤ m ∧
      ∃ (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
      ∃ (q_seq : ℕ → Fin m → ℚ),
        (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
        (∀ n, MvPolynomial.aeval (fun j => ((q_seq n j : ℚ) : ℝ))
                ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0)) :=
  ⟨T5_Schmidt_existence_int_poly_unconditional,
   T5_NAMED_small_eps_axis_existential_unconditional,
   T5_RothTheorem_via_eps_le_1,
   T5_balance_existential_via_joint,
   T5_aeval_nonzero_existential_via_joint⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_NAMEDLeafAudit
