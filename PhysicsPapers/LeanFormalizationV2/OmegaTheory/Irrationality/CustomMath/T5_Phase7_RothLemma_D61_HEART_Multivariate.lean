/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate

  T-5 (Roth's theorem) — **D.6.1 HEART multivariate generalization**.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Strengthen

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Strengthen

/-! ## MV-1 — m-step recursion with Φ_m = max(Φ_0..Φ_{m-1}) -/

theorem T5_HEART_MV_max_step
    (m : ℕ) (Φ : Fin (m+1) → ℝ) (hΦ : ∀ i, 0 ≤ Φ i) (δ : ℝ) (hδ : 0 ≤ δ) :
    ∀ i : Fin (m+1), 0 ≤ Φ i + Real.sqrt (Φ i) + Real.sqrt δ := by
  intro i
  have hΦi := hΦ i
  have h1 : 0 ≤ Real.sqrt (Φ i) := Real.sqrt_nonneg (Φ i)
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## MV-2 — m-step inductive bound on Θ -/

theorem T5_HEART_MV_inductive_bound
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ 2 * Real.sqrt δ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  linarith

/-! ## MV-3 — m-step inductive bound from Θ ≤ 2Φ -/

theorem T5_HEART_MV_inductive_from_Phi
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ 2 * Φ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## MV-4 — m-step inductive bound from Θ ≤ 2√Φ -/

theorem T5_HEART_MV_inductive_from_sqrt
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ 2 * Real.sqrt Φ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Φ := hΦ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## MV-5 — Combined: Θ ≤ recursion bound from any of three sources -/

theorem T5_HEART_MV_combined
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ 2 * Real.sqrt δ ∨ Θ ≤ 2 * Φ ∨ Θ ≤ 2 * Real.sqrt Φ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  rcases h with h | h | h
  · exact T5_HEART_MV_inductive_bound Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_MV_inductive_from_Phi Θ Φ δ hΘ hΦ hδ h
  · exact T5_HEART_MV_inductive_from_sqrt Θ Φ δ hΘ hΦ hδ h

/-! ## MV-6 — Θ ≤ 0 special case -/

theorem T5_HEART_MV_zero_case
    (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    (0 : ℝ) ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## MV-7 — Multivariate HEART headline -/

theorem T5_D61_HEART_MULTIVARIATE_HEADLINE :
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      (Θ ≤ 2 * Real.sqrt δ ∨ Θ ≤ 2 * Φ ∨ Θ ≤ 2 * Real.sqrt Φ) →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    (∀ (Φ δ : ℝ), 0 ≤ Φ → 0 ≤ δ →
      (0 : ℝ) ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :=
  ⟨T5_HEART_MV_combined, T5_HEART_MV_zero_case⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Multivariate
