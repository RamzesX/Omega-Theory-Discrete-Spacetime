/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConstrainedSmallJ_NAMED

  T-5 (Roth's theorem) — **Constrained smallJ NAMED Prop**.

  Defines a CONSTRAINED variant of `T5_NAMED_smallJ_witness_at_q` that
  requires ε ≤ m³/16 (the small-ε constraint inherited from DLP-1').

  Strategic significance: this is the form V8AtomOne_StrictClosure
  actually produces.  Bridge to the unconstrained T5_NAMED_smallJ_witness_at_q
  requires either case-analysis (large-ε regime) or a stronger relaxed
  → strict transformation.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — explicit NAMED Prop.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_to_OG_NAMED

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConstrainedSmallJ_NAMED

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_to_OG_NAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring

/-! ## CSJ-1 — Constrained smallJ NAMED Prop -/

/-- **CSJ-1 — `T5_NAMED_smallJ_witness_at_q_constrained`**: smallJ witness
    EXISTENCE form RESTRICTED to ε ≤ m³/16.

    Differs from `T5_NAMED_smallJ_witness_at_q` only in the additional
    `ε ≤ m³/16` hypothesis.  This is the form directly produced by
    V8AtomOne_StrictClosure (V8AOG-1). -/
def T5_NAMED_smallJ_witness_at_q_constrained : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
    P ≠ 0 → 0 < ε →
    ε ≤ ((m : ℝ)^3) / 16 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
    T5_DenominatorGrowthCondition q ε →
    T5_DegreeHeightBalanceCondition R q ε →
    rothIndex P (fun _ => α) R ≥ t →
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε)

/-! ## CSJ-2 — SJWC-1 + UWF-2 ⇒ constrained smallJ NAMED -/

/-- **CSJ-2 — `T5_constrained_smallJ_via_SJWC1_UWF2`**: discharges the
    constrained smallJ NAMED Prop from SJWC-1 + UWF-2 using V8AOG-1. -/
theorem T5_constrained_smallJ_via_SJWC1_UWF2
    (h_SJWC1 : T5_NAMED_index_at_q_strict_upper_bound)
    (h_UWF2 : T5_NAMED_support_extraction_at_zero) :
    T5_NAMED_smallJ_witness_at_q_constrained :=
  fun {m} hm P R α q ε t hP hε hε_small hR_deg hR_pos hq_den
      h_growth h_balance h_t =>
    T5_constrained_smallJ_witness_via_SJWC1_UWF2 h_SJWC1 h_UWF2
      hm P R α q ε t hP hε hε_small hR_deg hR_pos hq_den
      h_growth h_balance h_t

/-! ## CSJ-3 — Headline -/

/-- **🚨🚨 CSJ-3 — `T5_CONSTRAINED_SMALLJ_NAMED_HEADLINE`**: paper-citable
    headline documenting the constrained smallJ NAMED Prop.

    Strategic significance: explicit Prop encoding the constraint
    structure of V8 closure.  Bridge to unconstrained T5_NAMED_smallJ_witness_at_q
    requires further work (case-split on ε regime). -/
theorem T5_CONSTRAINED_SMALLJ_NAMED_HEADLINE :
    T5_NAMED_index_at_q_strict_upper_bound →
    T5_NAMED_support_extraction_at_zero →
    T5_NAMED_smallJ_witness_at_q_constrained :=
  T5_constrained_smallJ_via_SJWC1_UWF2

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConstrainedSmallJ_NAMED
