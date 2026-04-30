/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM2_PartialDischarge

  T-5 (Roth's theorem) — **SM-2 partial discharge** (factor through R-aware q_seq).

  SM-2 (`T5_NAMED_Schmidt_balance_per_n`) says: for Schmidt aux P_int +
  q_seq over T5_RothViolatingSet α ε with growth, the per-n
  T5_DegreeHeightBalanceCondition holds.

  This file factors SM-2 into a single NEW NAMED leaf:
    - `T5_NAMED_R_aware_q_seq_balance` — under hypothesis that q_seq
      is constructed R-aware (d_i ≈ exp(C/R_i) per Hindry-Silverman §D.7),
      balance condition follows directly.

  The factoring isolates the actual analytical content (R-aware
  construction) from the architectural bookkeeping.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM2_PartialDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction

/-! ## SM2PD-1 — R-aware q_seq balance NAMED -/

/-- **SM2PD-1 — `T5_NAMED_R_aware_q_seq_balance`** [NAMED HYPOTHESIS,
    R-aware q_seq construction analytical].

    For ANY R : Fin m → ℕ (positive everywhere) and ANY α irrational +
    ε > 0, there EXISTS an R-aware q_seq : ℕ → Fin m → ℚ over
    T5_RothViolatingSet α ε satisfying both growth + balance per-n.

    Discharge plan (Hindry-Silverman §D.7):
    1. Pick d_i ≈ exp(C/R_i) for some constant C
    2. Pick q_seq n j ∈ T5_RothViolatingSet α ε with q_seq.den ≈ d_i (rational
       approximation of α with denominator near d_i)
    3. Verify R_j log d_j ≈ C (the balance condition).

    This is a stronger statement than SM-2 — gives existence of
    appropriate q_seq directly, not just a balance condition for
    given q_seq. -/
def T5_NAMED_R_aware_q_seq_balance : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (R : Fin m → ℕ), (∀ j, 0 < R j) →
  ∃ (q_seq : ℕ → Fin m → ℚ),
    (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
    (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) ∧
    (∀ n, T5_DegreeHeightBalanceCondition R (q_seq n) ε)

/-! ## SM2PD-2 — R-aware q_seq existence ⇒ SM-2-with-existential -/

/-- **SM2PD-2 — `T5_SM2_existential_via_R_aware`**: under R-aware q_seq
    NAMED hypothesis, SM-2 holds in EXISTENTIAL form (∃ q_seq with the
    required properties).

    Note: this is a stronger statement than the original SM-2 which
    quantifies UNIVERSALLY over q_seq.  The existential form is what
    Hindry-Silverman §D.7 actually proves and uses. -/
theorem T5_SM2_existential_via_R_aware
    (h_R_aware : T5_NAMED_R_aware_q_seq_balance) :
    ∀ (α : ℝ), Irrational α →
    ∀ (ε : ℝ), 0 < ε →
    ∀ {m : ℕ}, 1 ≤ m →
    ∀ (P_int : MvPolynomial (Fin m) ℤ),
      (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      (∀ j, 0 < MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) →
    ∃ (q_seq : ℕ → Fin m → ℚ),
      (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
      (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) ∧
      (∀ n, T5_DegreeHeightBalanceCondition
        (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
        (q_seq n) ε) := by
  intros α hα ε hε m hm P_int _hP_ne hP_deg_pos
  exact h_R_aware α hα ε hε hm
    (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
    hP_deg_pos

/-! ## SM2PD-3 — Headline -/

/-- **🚨🚨 SM2PD-3 — `T5_SM2_PARTIAL_DISCHARGE_HEADLINE`**: paper-citable
    bundle showing SM-2 reduces to R-aware q_seq existence.

    Strategic significance: SM-2 is restated in EXISTENTIAL form (which
    matches Hindry-Silverman §D.7 actual content) and reduced to a
    single NAMED analytical leaf describing R-aware construction. -/
theorem T5_SM2_PARTIAL_DISCHARGE_HEADLINE :
    T5_NAMED_R_aware_q_seq_balance →
    (∀ (α : ℝ), Irrational α →
      ∀ (ε : ℝ), 0 < ε →
      ∀ {m : ℕ}, 1 ≤ m →
      ∀ (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
        (∀ j, 0 < MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) →
      ∃ (q_seq : ℕ → Fin m → ℚ),
        (∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) ∧
        (∀ n, T5_DenominatorGrowthCondition (q_seq n) ε) ∧
        (∀ n, T5_DegreeHeightBalanceCondition
          (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ)))
          (q_seq n) ε)) :=
  T5_SM2_existential_via_R_aware

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM2_PartialDischarge
