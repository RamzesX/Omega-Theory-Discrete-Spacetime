/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Quadratic_PartialDischarge

  T-5 (Roth's theorem) — **Phase 7 RothBoundLarge PARTIAL DISCHARGE for QUADRATIC α**.

  Single-thread hand-authored 2026-04-29.

  ## What this delivers

  Proof that the inner ∀-shape of `RothBoundLarge` (i.e., per-α RothBoundLarge)
  holds UNCONDITIONALLY for any QUADRATIC algebraic irrational α via Liouville's
  theorem. Bypasses the W3-D analytical bridge entirely for degree d=2.

  This is a PARTIAL DISCHARGE — does not fully discharge the universal
  `RothBoundLarge` Prop (which requires ALL algebraic α including d ≥ 3),
  but provides a clean Liouville-based path for quadratic case.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundExistsBridge
import OmegaTheory.Irrationality.CustomMath.T5_Heights

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Quadratic_PartialDischarge

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundExistsBridge
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Heights

/-! ## Per-α RothBoundLarge for quadratic α -/

/-- **Per-α RothBoundLarge for QUADRATIC α — UNCONDITIONAL via Liouville**.

    For any irrational α with quadratic minimal polynomial,
    the inner ∀-shape of `RothBoundLarge` (taking N=1, i.e. all q.den ≥ 1)
    holds unconditionally — derived from `T5_quadratic_roth_via_liouville_bound`. -/
theorem T5_RothBoundLarge_per_alpha_quadratic
    (α : ℝ) (hα : Irrational α)
    (f : Polynomial ℤ) (hf : f ≠ 0) (hroot : Polynomial.aeval α f = 0)
    (h_deg2 : f.natDegree = 2) :
    ∀ (ε : ℝ), 0 < ε →
    ∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
      ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| := by
  intro ε hε
  -- Apply quadratic Roth via Liouville to get RothBoundExists α
  have h_exists : RothBoundExists α :=
    T5_quadratic_roth_via_liouville_bound α hα f hf hroot h_deg2
  -- Unfold RothBoundExists at ε to get C, ∀ q with q ≠ 0, q ≠ α: ...
  obtain ⟨C, hC_pos, hC⟩ := h_exists ε hε
  -- Take N = 1 (always satisfied since q ≠ 0 implies q.den ≥ 1)
  refine ⟨C, 1, hC_pos, ?_⟩
  intro q hq_nonzero hq_neq _h_den
  exact hC q hq_nonzero hq_neq

/-! ## Headline -/

/-- **🚨 RothBoundLarge per-α PARTIAL DISCHARGE for QUADRATIC α**.

    🏆🏆🏆🏆🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5).

    Per-α RothBoundLarge derived UNCONDITIONALLY for any quadratic
    algebraic irrational α via Mathlib's Liouville bound. Bypasses the
    W3-D analytical bridge for d=2.

    Sub-lemma 333/N in T-5 Phase 7. NO STUBS. Lean-core only. -/
theorem session_W3_D_T5_rothBoundLarge_quadratic_partial_discharge_headline
    (α : ℝ) (hα : Irrational α)
    (f : Polynomial ℤ) (hf : f ≠ 0) (hroot : Polynomial.aeval α f = 0)
    (h_deg2 : f.natDegree = 2) :
    ∀ (ε : ℝ), 0 < ε →
    ∃ (C₁ : ℝ) (N : ℕ), 0 < C₁ ∧
      ∀ (q : ℚ), q ≠ 0 → (q : ℝ) ≠ α → N ≤ q.den →
        C₁ / ((Rat.naiveHeight q : ℝ) ^ (2 + ε)) ≤ |α - (q : ℝ)| :=
  T5_RothBoundLarge_per_alpha_quadratic α hα f hf hroot h_deg2

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_Quadratic_PartialDischarge
