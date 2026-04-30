/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC

  T-5 (Roth's theorem) — **V8-atom-1 RELAXED DISCHARGE via SJWC composition**.

  Composes the SJWC-1 + SJWC-2 NAMED leaves into a relaxed form of
  V8-atom-1 (`T5_RothLemmaIndexReductionDischarge`).

  Strategic significance: documents the V8-atom-1 closure path that
  works through the SJWC factoring of `T5_NAMED_smallJ_witness_at_q`.

  The full strict V8-atom-1 form requires δ → 0 limit (to remove the
  `+ ε/m` slack from SJWC's relaxed form) — separate NAMED leaf for
  future fire.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8D5_SmallJWitness_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_IndexReduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## V8AS-1 — Relaxed-form smallJ witness Prop -/

/-- **V8AS-1 — `T5_NAMED_smallJ_witness_at_q_relaxed`** [NAMED HYPOTHESIS,
    relaxed form].

    Like `T5_NAMED_smallJ_witness_at_q` but with `≤ t - √(mε) + ε/m`
    instead of `≤ t - √(mε)`.  This is what SJWC-1 + SJWC-2 deliver. -/
def T5_NAMED_smallJ_witness_at_q_relaxed : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ)
    (α : ℝ) (q : Fin m → ℚ) (ε : ℝ) (t : ℝ),
    P ≠ 0 →
    0 < ε →
    (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    (∀ i, 1 ≤ (q i).den) →
    T5_DenominatorGrowthCondition q ε →
    T5_DegreeHeightBalanceCondition R q ε →
    rothIndex P (fun _ => α) R ≥ t →
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
      (∑ i, (j i : ℝ) / (R i : ℝ)) ≤
        t - Real.sqrt ((m : ℝ) * ε) + ε / (m : ℝ)

/-! ## V8AS-2 — SJWC-1 + SJWC-2 ⇒ relaxed smallJ witness -/

/-- **V8AS-2 — `T5_relaxed_smallJ_witness_via_SJWC`**: composition
    SJWC-1 + SJWC-2 implies the relaxed-form smallJ witness Prop. -/
theorem T5_relaxed_smallJ_witness_via_SJWC
    (h_idx_bound : T5_NAMED_index_at_q_strict_upper_bound)
    (h_set_nonempty : T5_NAMED_index_set_nonempty_at_q) :
    T5_NAMED_smallJ_witness_at_q_relaxed := by
  intros m hm P R α q ε t hP hε hR_deg hR_pos hq_den h_growth h_balance h_t
  exact T5_smallJ_witness_le_relaxed_form_via_index_bound
    h_idx_bound h_set_nonempty hm P R α q ε t
    hP hε hR_deg hR_pos hq_den h_growth h_balance h_t

/-! ## V8AS-3 — Headline: V8-atom-1 closure path documentation -/

/-- **🚨🚨🚨 V8AS-3 — `T5_V8_ATOM1_CLOSURE_PATH_HEADLINE`**: paper-citable
    bundle documenting the V8-atom-1 closure via SJWC factoring.

    The path:
    SJWC-1 (analytical heart, index-at-q strict upper bound)
      + SJWC-2 (rothIndex set non-emptyness)
      ⇒ relaxed smallJ witness (V8AS-1)
      ⇒ relaxed V8-atom-1 (NAMED leaf δ → 0 limit pending)
      ⇒ V8 paper headline V8 (after composition with V7N1U + 3 SM).

    Strategic significance: The 5-NAMED-leaves V8 closure now further
    decomposes — SJWC-1 isolates the analytical heart (Taylor + AM-QM
    chain), SJWC-2 is generic non-degeneracy (universal-witness). -/
theorem T5_V8_ATOM1_CLOSURE_PATH_HEADLINE :
    -- (a) SJWC-1 + SJWC-2 ⇒ relaxed smallJ witness
    (T5_NAMED_index_at_q_strict_upper_bound →
      T5_NAMED_index_set_nonempty_at_q →
      T5_NAMED_smallJ_witness_at_q_relaxed) ∧
    -- (b) Universal-witness ⇒ SJWC-2 (via SJWC2D-2)
    ((∀ {m : ℕ} (_hm : 1 ≤ m)
        (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ),
        P ≠ 0 →
        ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0) →
      T5_NAMED_index_set_nonempty_at_q) :=
  ⟨T5_relaxed_smallJ_witness_via_SJWC,
   T5_SJWC2_discharge_via_universal_witness⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
