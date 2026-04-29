/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition

  T-5 (Roth's theorem) — **D.6.1 HEART composition layer**.

  Composition of strengthened HEART recursion forms.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate

/-! ## CO-1 — HEART recursion under Θ ≤ Φ -/

theorem T5_HEART_recursion_Theta_le_Phi
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ Φ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## CO-2 — HEART recursion under Θ ≤ Φ + 1 -/

theorem T5_HEART_recursion_Theta_le_Phi_plus_one
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ Φ + 1) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ + 1) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## CO-3 — HEART recursion under Θ ≤ √Φ + √δ -/

theorem T5_HEART_recursion_Theta_le_sqrt_sum
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ Real.sqrt Φ + Real.sqrt δ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## CO-4 — HEART recursion under Θ = 0 -/

theorem T5_HEART_recursion_Theta_zero
    (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    (0 : ℝ) ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) :=
  T5_HEART_MV_zero_case Φ δ hΦ hδ

/-! ## CO-5 — HEART composition: 4 sources combined -/

theorem T5_HEART_composition_4sources
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ Φ ∨ Θ ≤ 2 * Real.sqrt δ ∨ Θ ≤ 2 * Φ ∨ Θ ≤ Real.sqrt Φ + Real.sqrt δ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  rcases h with h | h | h | h
  · exact T5_HEART_recursion_Theta_le_Phi Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_MV_inductive_bound Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_MV_inductive_from_Phi Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_recursion_Theta_le_sqrt_sum Θ Φ δ hΘ hΦ hδ h

/-! ## CO-6 — Composition headline -/

theorem T5_D61_HEART_COMPOSITION_HEADLINE :
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      Θ ≤ Φ → Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      (Θ ≤ Φ ∨ Θ ≤ 2 * Real.sqrt δ ∨ Θ ≤ 2 * Φ ∨ Θ ≤ Real.sqrt Φ + Real.sqrt δ) →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :=
  ⟨T5_HEART_recursion_Theta_le_Phi, T5_HEART_composition_4sources⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition
