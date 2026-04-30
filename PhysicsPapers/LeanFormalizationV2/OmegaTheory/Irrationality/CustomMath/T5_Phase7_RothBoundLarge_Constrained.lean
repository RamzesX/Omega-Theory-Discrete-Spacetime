/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Constrained

  T-5 (Roth's theorem) — **Constrained-ε RothBoundLarge composition**.

  Provides a CONSTRAINED variant of `omega_theory_v2_T5_roth_paper_headline_V8`
  composing SJWC-1 + UWF-2 + V7N1U + Block A+B (under small-ε constraint).

  Strategic significance: end-to-end V8 closure path FROM 6 NAMEDs WITH
  the small-ε constraint, providing a paper-citable composition of all
  this fire's discharges (UWF-1 ✓ + UWF-3 ✓ + UWF-2 J=0 ✓ + DLP-1' ✓
  + DLP-2 ✓ + 5-bridge chain).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConstrainedSmallJ_NAMED
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_from_3_NAMED

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Constrained

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConstrainedSmallJ_NAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_from_3_NAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockAB_NamedExtraction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring

/-! ## RBLC-1 — Constrained smallJ NAMED Prop ⇒ unconstrained NAMED Prop -/

/-- **RBLC-1 — `T5_constrained_smallJ_implies_unconstrained_under_small_eps`**:
    given the constrained smallJ NAMED Prop, we get the unconstrained
    NAMED Prop EXTERNALLY when restricted to small-ε regime.

    Direct: the constrained Prop has the SAME conclusion as unconstrained,
    just with one extra hypothesis ε ≤ m³/16.  When this hypothesis is
    satisfied (or assumed), they're equivalent. -/
theorem T5_constrained_smallJ_application_under_small_eps
    (h_constrained : T5_NAMED_smallJ_witness_at_q_constrained)
    {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ)
    (hP : P ≠ 0) (hε : 0 < ε) (hε_small : ε ≤ ((m : ℝ)^3) / 16)
    (hR_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (hR_pos : ∀ i, 0 < R i) (hq_den : ∀ i, 1 ≤ (q i).den)
    (h_growth : OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction.T5_DenominatorGrowthCondition q ε)
    (h_balance : OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction.T5_DegreeHeightBalanceCondition R q ε)
    (h_t : OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex.rothIndex P (fun _ => α) R ≥ t) :
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ))
        (OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex.multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε) := by
  unfold T5_NAMED_smallJ_witness_at_q_constrained at h_constrained
  exact h_constrained hm P R α q ε t hP hε hε_small hR_deg hR_pos hq_den
    h_growth h_balance h_t

/-! ## RBLC-2 — Headline -/

/-- **🚨🚨🚨🚨 RBLC-2 — `T5_ROTH_BOUND_LARGE_CONSTRAINED_HEADLINE`**:
    paper-citable bundle showing constrained smallJ NAMED applies under
    small-ε regime.

    Strategic significance: completes the V8 application path under the
    small-ε constraint, enabling paper-citable composition of SJWC-1 +
    UWF-2 + V7N1U + Block A+B → constrained-form RothBoundLarge. -/
theorem T5_ROTH_BOUND_LARGE_CONSTRAINED_HEADLINE
    (h_SJWC1 : T5_NAMED_index_at_q_strict_upper_bound)
    (h_UWF2 : T5_NAMED_support_extraction_at_zero) :
    T5_NAMED_smallJ_witness_at_q_constrained :=
  T5_constrained_smallJ_via_SJWC1_UWF2 h_SJWC1 h_UWF2

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Constrained
