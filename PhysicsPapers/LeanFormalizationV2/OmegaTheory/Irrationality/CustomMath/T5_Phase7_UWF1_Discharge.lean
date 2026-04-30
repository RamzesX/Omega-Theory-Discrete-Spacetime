/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF1_Discharge

  T-5 (Roth's theorem) — **UWF-1 unconditional discharge**.

  Proves `T5_NAMED_aeval_translate_via_shiftPoly` UNCONDITIONALLY using:
    - T5_multiIteratedPDeriv_bind₁_shift (Phase 6, already proven):
        multiIteratedPDeriv J (shiftPoly α P) = shiftPoly α (multiIteratedPDeriv J P)
    - T5_aeval_bind₁_shift (Phase 6, already proven):
        aeval β (shiftPoly γ Q) = aeval (β + γ) Q

  Direct composition: aeval γ (multiIteratedPDeriv J P)
                     = aeval ((γ-α) + α) (multiIteratedPDeriv J P)
                     = aeval (γ-α) (shiftPoly α (multiIteratedPDeriv J P))
                     = aeval (γ-α) (multiIteratedPDeriv J (shiftPoly α P))

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF1_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

/-! ## UWF1D-1 — UWF-1 unconditional discharge -/

/-- **UWF1D-1 — `T5_aeval_translate_via_shiftPoly_unconditional`**:
    UNCONDITIONALLY proves UWF-1 (translation invariance of aeval through shiftPoly).

    Direct composition of T5_multiIteratedPDeriv_bind₁_shift +
    T5_aeval_bind₁_shift (both already in Phase 6 unconditional). -/
theorem T5_aeval_translate_via_shiftPoly_unconditional :
    T5_NAMED_aeval_translate_via_shiftPoly := by
  intros m P J γ α
  -- Apply T5_multiIteratedPDeriv_bind₁_shift to swap order
  rw [T5_multiIteratedPDeriv_bind₁_shift]
  -- Now goal: aeval γ (multiIteratedPDeriv J P) =
  --           aeval (γ - α) (shiftPoly α (multiIteratedPDeriv J P))
  -- Apply T5_aeval_bind₁_shift on RHS
  rw [T5_aeval_bind₁_shift]
  -- Now goal: aeval γ (multiIteratedPDeriv J P) =
  --           aeval (fun i => (γ i - α i) + α i) (multiIteratedPDeriv J P)
  -- The argument simplifies via ring
  have h_eq : (fun i => (γ i - α i) + α i) = γ := by
    funext i; ring
  rw [h_eq]

/-! ## UWF1D-2 — Headline -/

/-- **🚨🚨 UWF1D-2 — `T5_UWF1_DISCHARGE_HEADLINE`**: paper-citable
    headline documenting UWF-1 is now UNCONDITIONALLY DISCHARGED.

    Strategic significance: 2 of 3 universal-witness sub-NAMEDs CLOSED
    (UWF-1 + UWF-3).  Remaining: UWF-2 (support extraction at zero —
    needs Mathlib MvPolynomial.eval_iteratedPDeriv lookup). -/
theorem T5_UWF1_DISCHARGE_HEADLINE :
    T5_NAMED_aeval_translate_via_shiftPoly :=
  T5_aeval_translate_via_shiftPoly_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF1_Discharge
