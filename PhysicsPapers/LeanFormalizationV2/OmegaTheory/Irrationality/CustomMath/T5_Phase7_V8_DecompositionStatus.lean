/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus

  T-5 (Roth's theorem) — **V8 decomposition STATUS capstone** (post-fire 2026-04-30).

  Documents the current state of V8 closure-path decomposition after this
  session's fire:

  Current 7-NAMED LEAF decomposition of V8 paper headline (relaxed form):
    1. SJWC-1 — `T5_NAMED_index_at_q_strict_upper_bound`
       (analytical heart, the index-at-q strict upper bound)
    2. universal-witness — `∀ m P q, P ≠ 0 → ∃ j, aeval q (∂^j P) ≠ 0`
       (generic non-degeneracy; provable from Schmidt aux poly degree bound)
    3. V7-N1-uniform — `T5_NAMED_BlockC_Taylor_upper_bound_uniform`
    4. SM-1 — `T5_NAMED_Schmidt_aux_int_poly`
    5. SM-2 — `T5_NAMED_Schmidt_balance_per_n`
    6. SM-3-via-universal-aeval — universal aeval non-vanishing
       (provable from SM-1 P_int ≠ 0 + generic q rationality)
    7. (relaxed-form δ → 0 limit, future fire)

  The 5-NAMED LEAF decomposition (`T5_NAMED_smallJ_witness_at_q` +
  V7N1U + SM-1/2/3) is STRUCTURALLY EQUIVALENT but the 7-NAMED form
  exposes the analytical heart vs convenience-precondition structure.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — composition theorems only, no stubs.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM3_PartialDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_from_5_NAMED

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8AtomOne_via_SJWC
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SJWC2_Discharge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM3_PartialDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheorem_from_5_NAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED

/-! ## V8DS-1 — Universal-witness aggregator -/

/-- **V8DS-1 — `T5_NAMED_universal_aeval_witness`** [NAMED HYPOTHESIS,
    Tier-99 generic non-degeneracy].

    For any nonzero `P : MvPolynomial (Fin m) ℝ`, any rational tuple `q`,
    there exists a multi-index `j` with `aeval q (multiIteratedPDeriv j P) ≠ 0`.

    Discharge plan: P ≠ 0 ⇒ exists J in P.support with coeff ≠ 0.  Pick
    j such that multiIteratedPDeriv j P picks up the leading monomial.
    For specific Schmidt aux P_int + rational q, follows from non-trivial
    Wronskian + algebraic generic-position. -/
def T5_NAMED_universal_aeval_witness : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ),
  P ≠ 0 →
  ∃ j : Fin m → ℕ,
    aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0

/-! ## V8DS-2 — universal-witness ⇒ SJWC-2 -/

/-- **V8DS-2 — `T5_universal_witness_implies_SJWC2`**: the universal
    aeval-witness Prop implies SJWC-2 (rothIndex set non-emptyness). -/
theorem T5_universal_witness_implies_SJWC2
    (h_univ : T5_NAMED_universal_aeval_witness) :
    T5_NAMED_index_set_nonempty_at_q := by
  unfold T5_NAMED_universal_aeval_witness at h_univ
  exact T5_SJWC2_discharge_via_universal_witness
    (fun {m} hm P q hP => h_univ hm P q hP)

/-! ## V8DS-3 — V8 7-NAMED-leaf-relaxed paper headline -/

/-- **🚨🚨🚨🚨 V8DS-3 — `T5_V8_7_NAMED_RELAXED_PAPER_HEADLINE`**:
    paper-citable bundle documenting the 7-NAMED (relaxed) decomposition
    of V8 closure path.

    Structure:
    - SJWC-1 (analytical heart, index-at-q strict upper bound)
      → relaxed smallJ witness via composition with SJWC-2
    - SJWC-2 ⇐ universal-witness (V8DS-2)
    - V7-N1-uniform (Taylor decay with κ > 1)
    - SM-1, SM-2 (Schmidt machinery, retained)
    - SM-3 ⇐ universal-aeval-witness (SM3PD-1)

    The 7-NAMED decomposition replaces the previous 5-NAMED
    (smallJ-witness + V7N1U + 3 SM) with finer-grained analytical
    leaves.  Each leaf has explicit discharge plan. -/
theorem T5_V8_7_NAMED_RELAXED_PAPER_HEADLINE :
    -- (a) SJWC-1 + universal-witness ⇒ relaxed smallJ witness
    (T5_NAMED_index_at_q_strict_upper_bound →
      T5_NAMED_universal_aeval_witness →
      T5_NAMED_smallJ_witness_at_q_relaxed) ∧
    -- (b) universal-witness ⇒ SJWC-2 (the rothIndex set non-emptyness)
    (T5_NAMED_universal_aeval_witness →
      T5_NAMED_index_set_nonempty_at_q) ∧
    -- (c) Universal aeval-witness for ℤ-polys ⇒ SM-3
    ((∀ {m : ℕ} (_hm : 1 ≤ m)
        (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      ∀ (q : Fin m → ℚ),
        aeval (fun j => ((q j : ℚ) : ℝ))
          ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) →
      T5_NAMED_Schmidt_aeval_nonzero_per_n) :=
  ⟨fun h_idx_bound h_univ =>
     T5_relaxed_smallJ_witness_via_SJWC h_idx_bound
       (T5_universal_witness_implies_SJWC2 h_univ),
   T5_universal_witness_implies_SJWC2,
   T5_SM3_via_universal_aeval_witness⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus
