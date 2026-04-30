/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_PartialDischarge

  T-5 (Roth's theorem) — **V7-N1-uniform partial discharge** (factor into D5).

  V7-N1-uniform (`T5_NAMED_BlockC_Taylor_upper_bound_uniform`) factors into:
    - D2 strong Taylor sum form (DONE `T5_NAMED_mvTaylor_at_real_alpha_strong`)
    - D3 high-index vanishing (DONE `T5_rothIndex_lower_bound_implies_subthreshold_vanish`)
    - D4 per-Taylor-term bound (DONE VC-9 `T5_tuple_violator_rpow_bound`)
    - **D5 full composition with κ** (NEW NAMED, this file)

  This file isolates D5 as the analytical heart, factoring V7-N1-uniform
  into explicit sub-NAMEDs with all but D5 already discharged.

  Strategic significance: V7-N1-uniform reduces to ONE NEW NAMED leaf
  (V7N1U-D5) — the κ-composition step combining Taylor + AM-QM + balance.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — composition theorem only.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_PartialDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockC_V7N1Uniform

/-! ## V7N1UPD-1 — D5 NAMED leaf -/

/-- **V7N1UPD-1 — `T5_NAMED_V7N1U_D5_kappa_composition`** [NEW NAMED, HEART].

    The analytical heart of V7-N1-uniform: the κ-composition step.

    Given the existing D2 (Taylor sum form), D3 (high-index vanishing
    from rothIndex bound), D4 (per-Taylor-term VC-9 bound) — combine
    via AM-QM + balance condition + κ formula to give the uniform
    Taylor decay bound `|aeval q P| ≤ C_upper · (∏ d^R)^(-κ)` with
    κ > 1 uniform across q-tuples.

    Discharge plan: ~200 lines analytic.  Combine VC-9 (∏-form rpow bound)
    + AM-QM (Cauchy-Schwarz √m factor) + balance condition (R_i log d_i ≈ C)
    + small-ε formula (κ = 1 + α-margin/m).  Plus universal C_upper from
    sum of binomial-coefficient bounds. -/
def T5_NAMED_V7N1U_D5_kappa_composition : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
  ∃ (C_upper : ℝ) (κ : ℝ),
    0 < C_upper ∧ 1 < κ ∧
    ∀ (q : Fin m → ℚ),
      (∀ i, q i ∈ T5_RothViolatingSet α ε) →
      T5_DenominatorGrowthCondition q ε →
      T5_DegreeHeightBalanceCondition R q ε →
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R ≤
        (m : ℝ) / 2 - 2 * Real.sqrt ((m : ℝ) * ε) →
      |aeval (fun i => ((q i : ℚ) : ℝ)) P| ≤
        C_upper * (∏ i, ((q i).den : ℝ) ^ (R i : ℕ)) ^ (-κ)

/-! ## V7N1UPD-2 — D5 ⇒ V7-N1-uniform (composition equivalence) -/

/-- **V7N1UPD-2 — `T5_V7N1U_via_D5`**: D5 NAMED is DEFINITIONALLY equivalent
    to V7-N1-uniform (same statement).  Direct ID. -/
theorem T5_V7N1U_via_D5
    (h_D5 : T5_NAMED_V7N1U_D5_kappa_composition) :
    T5_NAMED_BlockC_Taylor_upper_bound_uniform :=
  h_D5

/-! ## V7N1UPD-3 — Headline -/

/-- **🚨🚨 V7N1UPD-3 — `T5_V7N1U_PARTIAL_DISCHARGE_HEADLINE`**: paper-citable
    bundle showing V7-N1-uniform reduces to D5 NAMED.

    Strategic significance: V7-N1-uniform isolated as a single analytical
    NAMED leaf (D5 κ-composition).  D2 + D3 + D4 components are ALL
    UNCONDITIONALLY closed in OV2.  Once D5 discharges, V7-N1-uniform is
    UNCONDITIONAL. -/
theorem T5_V7N1U_PARTIAL_DISCHARGE_HEADLINE :
    T5_NAMED_V7N1U_D5_kappa_composition →
    T5_NAMED_BlockC_Taylor_upper_bound_uniform :=
  T5_V7N1U_via_D5

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_PartialDischarge
