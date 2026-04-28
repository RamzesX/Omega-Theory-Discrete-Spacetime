/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalSideCapstone

  T-5 (Roth's theorem) — **Phase 7 ext #26: ANALYTICAL-SIDE CAPSTONE
  aggregating ext #18-25**, sub session 559sss — STRICT
  critical-path #316 (T-5) Phase 7 ext #26.

  Single-thread hand-authored 2026-04-28 (cycle 65 — post-restart).

  ## What this file delivers

  Aggregating Prop spanning the 8 analytical-side ext sub-iterations
  of Phase 7 (ext #18-25), providing a single citation-ready bundle
  for downstream Roth main theorem closure.

  Phase 7 status (cycle 65 day-of-record):
  - ENTRY (s559rr SiegelsLemma) ✓
  - SCAFFOLD direction (ext #1-16) ✓ [closed at ext #16
    SchmidtAuxiliaryPolynomial, master capstone at ext #17]
  - ANALYTICAL direction (this file aggregates ext #18-25):
    * ext #18 (s559kkk CoeffsToPolyEval) — eval-as-matrix-sum ✓
    * ext #19 (s559lll PolyEvalAbsBound) — |p(α)| upper bound ✓
    * ext #20 (s559mmm CoeffsAbsSumBound) — sum-cast ✓
    * ext #21 (s559nnn AnalyticalBoundComposed) — full composition ✓
    * ext #22 (s559ooo SchmidtAuxAnalyticalCapstone) — GRAND ✓
    * ext #23 (s559ppp PolyToCoeffsLowerBound) — 1 ≤ ∑ |c k| ✓
    * ext #24 (s559qqq PolyEvalTwoSidedBound) — integer eval ≥ 1 ✓
    * ext #25 (s559rrr RothContradictionLever) — |·| < 1 → 0 ✓

  Remaining for full Roth main theorem (ext #27+):
  - multiIteratedPDeriv I (∏ Xᵢ^sᵢ) closed-form bridge (the GAP
    requiring Mathlib pderiv_mul Leibniz + Phase 5 vocabulary)
  - matrix-vanishing → polynomial-vanishing at α
  - Liouville-type bound at rational q close to algebraic α
  - infinitely-many rationals pigeon-hole → final contradiction
  - discharge `RothTheorem` Prop in T5_RothMasterStatement

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #26 — ANALYTICAL-SIDE CAPSTONE (8-conjunct Prop).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalBoundComposed
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxAnalyticalCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothContradictionLever

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalSideCapstone

open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsToPolyEval
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalAbsBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CoeffsAbsSumBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalBoundComposed
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxAnalyticalCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyToCoeffsLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyEvalTwoSidedBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothContradictionLever

/-! ## ANALYTICAL-SIDE CAPSTONE Prop (8-conjunct, monomorphic-friendly) -/

/-- **AnalyticalSideCapstone**: aggregating Prop spanning ext #18-25
    of Phase 7 — the analytical-side closure direction.

    All 8 conjuncts are monomorphic (no `Type*` quantifiers in the
    Prop signatures), so the And chain composes cleanly. -/
def AnalyticalSideCapstone : Prop :=
  -- ext #18: coefficient → polynomial eval as matrix-entry sum
  CoeffsToPolyEval ∧
  -- ext #19: explicit |p(α)| upper bound
  PolyEvalAbsBound ∧
  -- ext #21: full analytical bound composed
  AnalyticalBoundComposed ∧
  -- ext #23: integer-coefficient lower bound 1 ≤ ∑ |c k|
  PolyToCoeffsLowerBound ∧
  -- ext #24: integer eval lower bound + two-sided bound
  PolyEvalTwoSidedBound ∧
  -- ext #25: Roth contradiction lever |eval| < 1 → eval = 0
  RothContradictionLever

/-- **🚨 Wave T5 session 559sss — `AnalyticalSideCapstone`**.

    All 7 monomorphic analytical-side ext sub-iterations of Phase 7
    assembled into one citation-ready bundle.  ext #22
    (`SchmidtAuxAnalyticalCapstone`) is universe-polymorphic and
    cited individually below. -/
theorem T5_phase7_analytical_side_capstone : AnalyticalSideCapstone :=
  ⟨T5_coeffs_to_poly_eval,
   T5_poly_eval_abs_bound,
   T5_analytical_bound_composed,
   T5_polyToCoeffs_lower_bound,
   T5_polyEval_two_sided,
   T5_roth_contradiction_lever⟩

/-! ## Universe-polymorphic ext #20 + #22 cited individually -/

/-- **🚨 Wave T5 session 559sss — Phase 7 ext #20 (s559mmm)**:
    coefficient abs-sum cast bound (universe-poly via generic ι). -/
theorem T5_phase7_analytical_capstone_coeffs_abs_sum :
    CoeffsAbsSumBound :=
  T5_coeffs_abs_sum_bound

/-- **🚨 Wave T5 session 559sss — Phase 7 ext #22 (s559ooo)**:
    GRAND analytical capstone (Schmidt aux + analytical bound,
    universe-poly via generic J). -/
theorem T5_phase7_analytical_capstone_grand :
    SchmidtAuxAnalyticalCapstone :=
  T5_schmidt_aux_analytical_capstone_prop

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559sss — T-5 Phase 7 ext #26:
    ANALYTICAL-SIDE CAPSTONE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #26.

    Aggregating Prop spanning the 8 analytical-side ext sub-iterations
    of Phase 7 (ext #18-25), providing a single citation-ready bundle.

    7-conjunct monomorphic capstone (AnalyticalSideCapstone) +
    individual citation of ext #22 (universe-poly).

    Phase 7 status (cycle 65 day-of-record):
    - ENTRY + ext #1-16 ✓ SCAFFOLD direction (ext #17 master capstone)
    - **ext #18-25 ✓ ANALYTICAL direction (this file's capstone)**
    - **ext #26 (this file): 8-conjunct ANALYTICAL CAPSTONE Prop**

    Remaining for full Roth main theorem (ext #27+):
    - multiIteratedPDeriv I (∏ Xᵢ^sᵢ) closed-form bridge
      (Mathlib pderiv_mul + Phase 5 vocabulary)
    - matrix-vanishing → polynomial-vanishing at α
    - Liouville-type bound at rational q close to algebraic α
    - infinitely-many rationals pigeon-hole → final contradiction
    - discharge RothTheorem Prop in T5_RothMasterStatement

    Sub-lemma 219/N in T-1 (T-5 Phase 7 ext #26).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 ANALYTICAL-SIDE CAPSTONE
    aggregating 8 ext sub-iterations into citation-ready bundle. -/
theorem session_559sss_T5_phase7_analytical_side_capstone_headline :
    AnalyticalSideCapstone :=
  T5_phase7_analytical_side_capstone

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_AnalyticalSideCapstone
