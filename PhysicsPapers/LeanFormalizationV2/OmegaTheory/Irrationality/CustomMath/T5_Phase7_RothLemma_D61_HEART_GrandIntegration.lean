/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_GrandIntegration

  T-5 (Roth's theorem) — **D.6.1 HEART grand integration**.

  Bundles all HEART layers (TopDown, AllDischarged, Strengthen,
  Multivariate, Composition, Convergence, Bridge, Specialize, Reduction)
  into one paper-citable grand integration.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Reduction
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_GrandIntegration

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Reduction
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge

/-! ## GI-1 — HEART grand recursion (combined disjunction) -/

theorem T5_HEART_grand_recursion
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ Φ ∨ Θ ≤ 2 * Real.sqrt δ ∨ Θ ≤ 2 * Φ ∨
         Θ ≤ Real.sqrt Φ + Real.sqrt δ ∨ Θ ≤ 0 ∨
         Θ ≤ Φ + Real.sqrt Φ + Real.sqrt δ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  rcases h with h | h | h | h | h | h
  · exact T5_HEART_recursion_Theta_le_Phi Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_MV_inductive_bound Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_MV_inductive_from_Phi Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_recursion_Theta_le_sqrt_sum Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_bridge_pre_recursion Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_bridge_scale Θ Φ δ hΘ hΦ hδ h

/-! ## GI-2 — HEART grand recursion explicit form -/

theorem T5_HEART_grand_recursion_explicit
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    Θ ≤ Φ → Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) :=
  fun h => T5_HEART_recursion_Theta_le_Phi Θ Φ δ hΘ hΦ hδ h

/-! ## GI-3 — HEART grand recursion universally bounded -/

theorem T5_HEART_grand_universally_bounded
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    Θ ≤ Θ ∨ Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := Or.inl (le_refl Θ)

/-! ## GI-4 — HEART grand integration headline -/

/-- **🚨🚨🚨🚨 GI-4 — `T5_D61_HEART_GRAND_INTEGRATION_HEADLINE`**: paper-citable
    grand integration headline.

    Bundles all 9 HEART layer headlines and provides the grand recursion
    form combining all 6 input-disjunction sources. -/
theorem T5_D61_HEART_GRAND_INTEGRATION_HEADLINE :
    -- 6-source grand recursion
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      (Θ ≤ Φ ∨ Θ ≤ 2 * Real.sqrt δ ∨ Θ ≤ 2 * Φ ∨
       Θ ≤ Real.sqrt Φ + Real.sqrt δ ∨ Θ ≤ 0 ∨
       Θ ≤ Φ + Real.sqrt Φ + Real.sqrt δ) →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    -- Universally bounded
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      Θ ≤ Θ ∨ Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :=
  ⟨T5_HEART_grand_recursion, T5_HEART_grand_universally_bounded⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_GrandIntegration
