/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Reduction

  T-5 (Roth's theorem) — **D.6.1 HEART reduction layer**.

  Reduction sub-lemmas: HEART recursion under reduction operations.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Specialize

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Reduction

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Specialize

/-! ## RD-1 — Reduce Φ by half preserves HEART recursion -/

theorem T5_HEART_reduce_half_Phi
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ 2 * (Φ/2 + Real.sqrt (Φ/2) + Real.sqrt δ)) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have hΦ_2_le_Φ : Φ/2 ≤ Φ := by linarith
  have h_sqrt : Real.sqrt (Φ/2) ≤ Real.sqrt Φ := Real.sqrt_le_sqrt hΦ_2_le_Φ
  linarith

/-! ## RD-2 — Reduce δ to 0 -/

theorem T5_HEART_reduce_delta_zero
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt 0)) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  rw [Real.sqrt_zero] at h
  have h_sqrt : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## RD-3 — Add δ' to δ preserves HEART -/

theorem T5_HEART_extend_delta
    (Θ Φ δ δ' : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) (hδ' : 0 ≤ δ')
    (h : Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt (δ + δ')) := by
  have h_sqrt : Real.sqrt δ ≤ Real.sqrt (δ + δ') := by
    apply Real.sqrt_le_sqrt
    linarith
  linarith

/-! ## RD-4 — Add Φ' to Φ preserves HEART -/

theorem T5_HEART_extend_Phi
    (Θ Φ Φ' δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hΦ' : 0 ≤ Φ') (hδ : 0 ≤ δ)
    (h : Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :
    Θ ≤ 2 * ((Φ + Φ') + Real.sqrt (Φ + Φ') + Real.sqrt δ) := by
  have h_Φ : Φ ≤ Φ + Φ' := by linarith
  have h_sqrt : Real.sqrt Φ ≤ Real.sqrt (Φ + Φ') := Real.sqrt_le_sqrt h_Φ
  linarith

/-! ## RD-5 — Reduction headline -/

theorem T5_D61_HEART_REDUCTION_HEADLINE :
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      Θ ≤ 2 * (Φ/2 + Real.sqrt (Φ/2) + Real.sqrt δ) →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    (∀ (Θ Φ δ δ' : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ → 0 ≤ δ' →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt (δ + δ'))) ∧
    (∀ (Θ Φ Φ' δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ Φ' → 0 ≤ δ →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) →
      Θ ≤ 2 * ((Φ + Φ') + Real.sqrt (Φ + Φ') + Real.sqrt δ)) :=
  ⟨T5_HEART_reduce_half_Phi,
   T5_HEART_extend_delta,
   T5_HEART_extend_Phi⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Reduction
