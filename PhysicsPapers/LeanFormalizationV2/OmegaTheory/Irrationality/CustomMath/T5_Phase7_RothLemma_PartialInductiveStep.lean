/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_PartialInductiveStep

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 PARTIAL INDUCTIVE
  STEP** — uses the m=2 and m=3 direct constructions to provide a
  partial discharge of `T5_RothWronskianInductiveStep` for the special
  cases `m+1 ∈ {2, 3}` (i.e., `m ∈ {1, 2}`).

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  A **bounded inductive step** Prop: `T5_RothWronskianInductiveStepUpToM`
  parameterised by an upper bound on m+1. For the upper bound 3,
  unconditionally discharged via m=2 and m=3 direct witnesses.

  This DOES NOT discharge the full unbounded `T5_RothWronskianInductiveStep`
  (which requires general Hindry-Silverman D.6.4 induction), but it
  provides explicit progress for the small-m portion.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Tactic.IntervalCases
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_PartialInductiveStep

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish

/-! ## Bounded inductive step Prop -/

/-- **`T5_RothWronskianInductiveStepUpTo`** (bounded version) — for m
    in [1, K], given IH(m), conclude Goal(m+1). When K ≤ 2, this is
    UNCONDITIONALLY discharged via m=2 and m=3 direct constructions. -/
def T5_RothWronskianInductiveStepUpTo (K : ℕ) : Prop :=
  ∀ {m : ℕ}, 1 ≤ m → m ≤ K →
  -- IH: Wronskian non-vanishing holds for m
  (∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
    P ≠ 0 → (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    ∃ (J : Fin m → (Fin m → ℕ)),
      (∀ i k, J i k ≤ R k) ∧ mvPolyWronskian m P J ≠ 0) →
  -- Conclusion: holds for m+1
  ∀ (P : MvPolynomial (Fin (m+1)) ℝ) (R : Fin (m+1) → ℕ),
    P ≠ 0 → (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
    (∀ i, 0 < R i) →
    ∃ (J : Fin (m+1) → (Fin (m+1) → ℕ)),
      (∀ i k, J i k ≤ R k) ∧ mvPolyWronskian (m+1) P J ≠ 0

/-- **🚨 Partial inductive step UPTO=2 unconditional discharge**.

    For m ∈ {1, 2}, the Goal(m+1) (i.e., for m+1 ∈ {2, 3}) is
    discharged DIRECTLY via the m=2 and m=3 concrete witnesses.
    The IH is therefore consumed but unused. -/
theorem T5_RothWronskianInductiveStepUpTo_2 :
    T5_RothWronskianInductiveStepUpTo 2 := by
  intros m hm hm_le _IH P R hP h_deg h_R_pos
  -- Cases on m: m = 1 or m = 2
  interval_cases m
  · -- m = 1, so m + 1 = 2; use m=2 direct witness
    exact T5_RothWronskian_m2 P hP R h_deg h_R_pos
  · -- m = 2, so m + 1 = 3; use m=3 direct witness
    exact T5_RothWronskian_m3 P hP R h_deg h_R_pos

/-! ## Trivial-bound NAMED -/

/-- **`T5_RothWronskianInductiveStepUpTo_NAMED`** — paper-grade NAMED
    Prop bundling the partial inductive step closure. -/
def T5_RothWronskianInductiveStepUpTo_NAMED : Prop :=
  T5_RothWronskianInductiveStepUpTo 2

/-- **🚨 NAMED discharge**. -/
theorem T5_RothWronskianInductiveStepUpTo_NAMED_holds :
    T5_RothWronskianInductiveStepUpTo_NAMED :=
  T5_RothWronskianInductiveStepUpTo_2

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 PARTIAL INDUCTIVE STEP**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 partial.

    Two derivations:
    1. `T5_RothWronskianInductiveStepUpTo` (bounded inductive step Prop)
    2. `T5_RothWronskianInductiveStepUpTo_2` (UNCONDITIONAL for K=2)

    For m ∈ {1, 2}, Goal(m+1) (m+1 ∈ {2, 3}) is discharged DIRECTLY
    via the m=2 and m=3 concrete witnesses (factor preservation pattern):
    - m=2 witness: J=(0, e_0), det = -X 1 · P²
    - m=3 witness: J=(0, e_0, e_1), det = X 2 · P³

    This DOES NOT discharge the full unbounded `T5_RothWronskianInductiveStep`
    (which requires Hindry-Silverman D.6.4 — multi-day analytical work
    for general m), but it establishes the small-m portion empirically.

    Sub-lemma 308/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_partial_inductive_step_headline :
    T5_RothWronskianInductiveStepUpTo_NAMED :=
  T5_RothWronskianInductiveStepUpTo_NAMED_holds

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_PartialInductiveStep
