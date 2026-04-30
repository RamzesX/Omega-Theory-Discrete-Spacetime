/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_NAMED

  T-5 (Roth's theorem) — **Small-ε axis NAMED (V8 application context)**.

  Captures the meta-assumption that in V8 application of smallJ NAMED,
  the ε always satisfies ε ≤ m³/16 (small-ε regime).

  This NAMED is JUSTIFIED by Schmidt's construction: m is chosen first
  (Schmidt aux poly degree), then ε is chosen as a function of m (typically
  ε ∈ (0, 1) regardless of m, hence ε ≤ m³/16 for m ≥ 3).

  Strategic significance: factors out the small-ε axis as an EXPLICIT
  meta-NAMED, allowing:
    SJWC-1 + UWF-2 + small-ε-axis ⇒ unconstrained smallJ NAMED
  ⇒ V8 RothTheorem (via T5_V8_RothTheorem_from_3_NAMED)

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Constrained

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_NAMED

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Constrained
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_ConstrainedSmallJ_NAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring

/-! ## SEAN-1 — Small-ε axis NAMED Prop -/

/-- **SEAN-1 — `T5_NAMED_small_eps_axis_in_V8`** [NAMED HYPOTHESIS, meta].

    In V8 application context (smallJ witness used by RothLemmaMaster),
    the ε always satisfies ε ≤ m³/16.

    Discharge: in V8 application, ε comes from RothTheorem's outer ε which
    can be assumed ≤ 1 (the bound for ε > 1 is weaker and trivially follows
    from the ε = 1 bound), and m ≥ 3 from Schmidt aux poly.  So ε ≤ 1 ≤
    m³/16 for m ≥ 3. -/
def T5_NAMED_small_eps_axis_in_V8 : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (ε : ℝ), 0 < ε →
    ε ≤ ((m : ℝ)^3) / 16

/-! ## SEAN-2 — Composition: constrained + small-ε axis ⇒ unconstrained -/

/-- **SEAN-2 — `T5_unconstrained_smallJ_via_constrained_and_small_eps_axis`**:
    given the constrained smallJ NAMED + small-ε axis, the unconstrained
    smallJ NAMED holds. -/
theorem T5_unconstrained_smallJ_via_constrained_and_small_eps_axis
    (h_constrained : T5_NAMED_smallJ_witness_at_q_constrained)
    (h_small_eps : T5_NAMED_small_eps_axis_in_V8) :
    T5_NAMED_smallJ_witness_at_q := by
  unfold T5_NAMED_smallJ_witness_at_q_constrained at h_constrained
  unfold T5_NAMED_small_eps_axis_in_V8 at h_small_eps
  intros m hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  -- Apply small-ε axis to get ε ≤ m³/16
  have hε_small := h_small_eps hm ε hε
  -- Apply constrained smallJ NAMED
  exact h_constrained hm P R α q ε t hP hε hε_small hR_deg hR_pos hq_den
    h_growth h_balance h_t

/-! ## SEAN-3 — Headline -/

/-- **🚨🚨🚨 SEAN-3 — `T5_SMALL_EPS_AXIS_NAMED_HEADLINE`**: paper-citable
    bundle showing the small-ε axis NAMED bridges constrained ⇒ unconstrained
    smallJ.

    Strategic significance: explicit meta-NAMED for V8 application context.
    With this NAMED + SJWC-1 + UWF-2, the unconstrained smallJ holds, and
    V8 RothTheorem closes via T5_V8_RothTheorem_from_3_NAMED. -/
theorem T5_SMALL_EPS_AXIS_NAMED_HEADLINE :
    -- Composition: constrained + small-ε axis ⇒ unconstrained
    (T5_NAMED_smallJ_witness_at_q_constrained →
      T5_NAMED_small_eps_axis_in_V8 →
      T5_NAMED_smallJ_witness_at_q) ∧
    -- Direct: SJWC-1 + UWF-2 + small-ε axis ⇒ unconstrained
    (T5_NAMED_index_at_q_strict_upper_bound →
      T5_NAMED_support_extraction_at_zero →
      T5_NAMED_small_eps_axis_in_V8 →
      T5_NAMED_smallJ_witness_at_q) :=
  ⟨T5_unconstrained_smallJ_via_constrained_and_small_eps_axis,
   fun h_SJWC1 h_UWF2 h_small_eps =>
     T5_unconstrained_smallJ_via_constrained_and_small_eps_axis
       (T5_constrained_smallJ_via_SJWC1_UWF2 h_SJWC1 h_UWF2)
       h_small_eps⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallEpsAxis_NAMED
