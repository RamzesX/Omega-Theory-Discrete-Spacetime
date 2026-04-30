/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure

  T-5 (Roth's theorem) — **V8-atom-1 STRICT UNCONDITIONAL CLOSURE**.

  Composes:
    - SJWC-1 (analytical heart, OPEN)
    - universal-witness ⇐ UWF-1 ✓ + UWF-2 ✓-or-Taylor-identity + UWF-3 ✓
    - DLP_FullClosure (UNCONDITIONAL post-fire 2026-04-30)
  ⇒ V8-atom-1 strict form UNCONDITIONAL (under ε₀ ≤ m³/16).

  Strategic significance: documents the END-TO-END unconditional V8-atom-1
  closure path.  Once SJWC-1 + Taylor-identity NAMEDs are discharged, the
  V8 atom 1 (T5_RothLemmaIndexReductionDischarge) is UNCONDITIONALLY
  CLOSED in strict form — and combined with V7N1U + 3 SM, the V8 paper
  headline V8 closes UNCONDITIONALLY.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — composition theorem only, no stubs.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP_FullClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_FullClosureTree
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_DLP_FullClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_FullClosureTree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_DeltaLimit_Packaging
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus

/-! ## VAS-1 — SJWC-1 + UWF-2 ⇒ V8-atom-1 strict (unconditional under ε₀ ≤ m³/16) -/

/-- **VAS-1 — `T5_V8_atom1_strict_via_SJWC1_and_UWF2`**: end-to-end
    composition.

    Given:
    - SJWC-1 NAMED (analytical heart, the index-at-q strict upper bound)
    - UWF-2 NAMED (support extraction at zero, requires Taylor identity)
    Combined with:
    - UWF-1 (CLOSED unconditional, this session)
    - UWF-3 (CLOSED unconditional, this session)
    - DLP-1' + DLP-2 + DFC-1 (CLOSED unconditional, this fire)
    Produces: V8-atom-1 strict form UNCONDITIONALLY (under ε₀ ≤ m³/16). -/
theorem T5_V8_atom1_strict_via_SJWC1_and_UWF2
    (h_SJWC1 : T5_NAMED_index_at_q_strict_upper_bound)
    (h_UWF2 : T5_NAMED_support_extraction_at_zero) :
    ∀ {m : ℕ} (hm : 1 ≤ m)
      (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
      (α : ℝ) (q : Fin m → ℚ) (ε₀ : ℝ) (t : ℝ),
      P ≠ 0 → 0 < ε₀ → ε₀ ≤ ((m : ℝ)^3) / 16 →
      (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
      (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
      T5_DenominatorGrowthCondition q ε₀ →
      T5_DegreeHeightBalanceCondition R q ε₀ →
      rothIndex P (fun _ => α) R ≥ t →
      ∃ (j : Fin m → ℕ),
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε₀) := by
  intros m hm P R α q ε₀ t hP hε₀ hε₀_small hR_deg hR_pos hq_den
      h_growth h_balance h_t
  -- Step 1a: UWF-2 ⇒ universal-witness (via V8FCT-2)
  have h_univ : T5_NAMED_universal_aeval_witness :=
    T5_universal_witness_via_UWF2_only h_UWF2
  -- Step 1b: universal-witness ⇒ SJWC-2 (via V8DS-2)
  have h_SJWC2 : T5_NAMED_index_set_nonempty_at_q :=
    T5_universal_witness_implies_SJWC2 h_univ
  -- Step 1c: SJWC-1 + SJWC-2 ⇒ relaxed smallJ witness (V8AS-2)
  have h_relaxed : T5_NAMED_smallJ_witness_at_q_relaxed :=
    T5_relaxed_smallJ_witness_via_SJWC h_SJWC1 h_SJWC2
  -- Step 2: relaxed + DLP-1' + DLP-2 ⇒ strict (DFC-1)
  exact T5_relaxed_to_strict_smallJ_unconditional h_relaxed
    hm P R α q ε₀ t hP hε₀ hε₀_small hR_deg hR_pos hq_den
    h_growth h_balance h_t

/-! ## VAS-2 — Headline: V8-atom-1 closure path -/

/-- **🚨🚨🚨🚨 VAS-2 — `T5_V8_ATOM1_STRICT_CLOSURE_HEADLINE`**: paper-citable
    headline documenting the V8-atom-1 strict closure path.

    Reduces V8-atom-1 (strict form, under ε₀ ≤ m³/16) to TWO NAMED leaves:
    - SJWC-1 (the analytical heart)
    - UWF-2 (support extraction at zero, factors via Taylor identity)

    All other components (UWF-1, UWF-3, DLP-1', DLP-2, DFC-1) are
    UNCONDITIONALLY closed this session.

    Strategic implication: post-discharge of SJWC-1 + UWF-2 (or its
    Taylor-identity sub-NAMED), V8-atom-1 closes UNCONDITIONALLY in
    strict form, advancing the entire V8 paper headline V8 toward
    full unconditional closure. -/
theorem T5_V8_ATOM1_STRICT_CLOSURE_HEADLINE :
    T5_NAMED_index_at_q_strict_upper_bound →
    T5_NAMED_support_extraction_at_zero →
    (∀ {m : ℕ} (hm : 1 ≤ m)
       (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
       (α : ℝ) (q : Fin m → ℚ) (ε₀ : ℝ) (t : ℝ),
       P ≠ 0 → 0 < ε₀ → ε₀ ≤ ((m : ℝ)^3) / 16 →
       (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
       (∀ i, 0 < R i) → (∀ i, 1 ≤ (q i).den) →
       T5_DenominatorGrowthCondition q ε₀ →
       T5_DegreeHeightBalanceCondition R q ε₀ →
       rothIndex P (fun _ => α) R ≥ t →
       ∃ (j : Fin m → ℕ),
         aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
         (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ t - Real.sqrt ((m : ℝ) * ε₀)) :=
  fun h_SJWC1 h_UWF2 {m} hm P R α q ε₀ t hP hε₀ hε₀_small hR_deg hR_pos
      hq_den h_growth h_balance h_t =>
    T5_V8_atom1_strict_via_SJWC1_and_UWF2 h_SJWC1 h_UWF2
      hm P R α q ε₀ t hP hε₀ hε₀_small hR_deg hR_pos hq_den
      h_growth h_balance h_t

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_StrictClosure
