/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF3_Discharge

  T-5 (Roth's theorem) — **UWF-3 unconditional discharge**.

  Proves `T5_NAMED_shiftPoly_preserves_nonzero` UNCONDITIONALLY: shiftPoly
  is an algebra automorphism with inverse `shiftPoly (-γ)`.

  Strategy: if shiftPoly γ P = 0, then aeval β (shiftPoly γ P) = 0 for
  any β.  By T5_aeval_bind₁_shift, this gives aeval (β + γ) P = 0.  Since
  β ranges over all functions, β + γ ranges over all functions too,
  so aeval β' P = 0 for all β'.  By Mathlib funext, P = 0.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
import Mathlib.Algebra.MvPolynomial.Funext

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF3_Discharge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

/-! ## UWF3D-1 — shiftPoly preserves nonzero (unconditional discharge) -/

/-- **UWF3D-1 — `T5_shiftPoly_preserves_nonzero_unconditional`**:
    UNCONDITIONALLY proves UWF-3 (the shiftPoly-preserves-nonzero NAMED Prop).

    Strategy: shiftPoly is an algebra automorphism — composition with
    inverse `shiftPoly (-γ)` cancels.  Direct contradiction approach
    via aeval-bind-shift composition. -/
theorem T5_shiftPoly_preserves_nonzero_unconditional :
    T5_NAMED_shiftPoly_preserves_nonzero := by
  intros m γ P hP_ne
  -- By contradiction: suppose shiftPoly γ P = 0
  intro h_shift_zero
  apply hP_ne
  -- Show P = 0 by funext: ∀ β, eval β P = 0 (using MvPolynomial.funext)
  apply MvPolynomial.funext
  intro β
  show MvPolynomial.eval β P = MvPolynomial.eval β 0
  rw [map_zero]
  -- Convert eval to aeval (they agree when ring is base ring of algebra)
  have h_eval_aeval : MvPolynomial.eval β P = aeval β P := by
    rw [← MvPolynomial.coe_aeval_eq_eval]
    rfl
  rw [h_eval_aeval]
  -- Use β' = β - γ so β = β' + γ; then aeval β P = aeval (β' + γ) P
  have h_aeval_eq : aeval β P = aeval (fun i => (β i - γ i) + γ i) P := by
    have h_eq : (fun i => (β i - γ i) + γ i) = β := by
      funext i; ring
    rw [h_eq]
  rw [h_aeval_eq, ← T5_aeval_bind₁_shift γ (fun i => β i - γ i) P, h_shift_zero,
      map_zero]

/-! ## UWF3D-2 — Headline -/

/-- **🚨🚨 UWF3D-2 — `T5_UWF3_DISCHARGE_HEADLINE`**: paper-citable
    headline documenting UWF-3 is now UNCONDITIONALLY DISCHARGED.

    Strategic significance: one of the 3 sub-NAMEDs of universal-witness
    factoring is now closed.  Remaining: UWF-1 (translation) + UWF-2
    (support extraction). -/
theorem T5_UWF3_DISCHARGE_HEADLINE :
    T5_NAMED_shiftPoly_preserves_nonzero :=
  T5_shiftPoly_preserves_nonzero_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF3_Discharge
