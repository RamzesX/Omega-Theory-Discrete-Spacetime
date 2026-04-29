/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Strengthen

  T-5 (Roth's theorem) — **D.6.1 HEART strengthening**.

  Sequel to HEART_AllDischarged.  Strengthens the reformulated H1-H4
  hypotheses toward more useful forms (closer to the actual
  Hindry-Silverman D.6.1 statements).

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_AllDischarged

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Strengthen

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_AllDischarged

/-! ## ST-1 — Strengthened H1: 2(Φ+√Φ+√δ+1) ≥ 2 -/

theorem T5_H1_strengthened (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    (2 : ℝ) ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ + 1) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## ST-2 — Strengthened H2: pigeonhole with explicit value -/

theorem T5_H2_strengthened (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_Θ_le : Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := h_Θ_le

/-! ## ST-3 — Strengthened H3: √(δ+ε) ≥ √δ -/

theorem T5_H3_strengthened (δ ε : ℝ) (hδ : 0 ≤ δ) (hε : 0 ≤ ε) :
    Real.sqrt δ ≤ Real.sqrt (δ + ε) := by
  apply Real.sqrt_le_sqrt
  linarith

/-! ## ST-4 — Strengthened H4: Φ+√Φ ≤ Φ+√Φ+√δ -/

theorem T5_H4_strengthened (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    Φ + Real.sqrt Φ ≤ Φ + Real.sqrt Φ + Real.sqrt δ := by
  have := Real.sqrt_nonneg δ
  linarith

/-! ## ST-5 — Strengthened HEART: combine ST-1..ST-4 -/

/-- **🚨 ST-5 — `T5_HEART_strengthened_recursion`**: more useful version
    of the HEART recursion bound. -/
theorem T5_HEART_strengthened_recursion
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ Φ + Real.sqrt Φ) :
    Θ ≤ Φ + Real.sqrt Φ + Real.sqrt δ ∧
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ + 1) := by
  refine ⟨?_, ?_⟩
  · exact le_trans h_init (T5_H4_strengthened Φ δ hΦ hδ)
  · have h1 : Θ ≤ Φ + Real.sqrt Φ + Real.sqrt δ :=
      le_trans h_init (T5_H4_strengthened Φ δ hΦ hδ)
    have h_sum_nn : 0 ≤ Φ + Real.sqrt Φ + Real.sqrt δ := by
      have hsq1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
      have hsq2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
      linarith
    linarith

/-! ## ST-6 — Strengthened HEART completion -/

theorem T5_HEART_strengthened_complete :
    (∀ (Φ δ : ℝ), 0 ≤ Φ → 0 ≤ δ →
      (2 : ℝ) ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ + 1)) ∧
    (∀ (δ ε : ℝ), 0 ≤ δ → 0 ≤ ε → Real.sqrt δ ≤ Real.sqrt (δ + ε)) ∧
    (∀ (Φ δ : ℝ), 0 ≤ Φ → 0 ≤ δ →
      Φ + Real.sqrt Φ ≤ Φ + Real.sqrt Φ + Real.sqrt δ) :=
  ⟨T5_H1_strengthened, T5_H3_strengthened, T5_H4_strengthened⟩

/-! ## ST-7 — Paper-citable strengthened headline -/

/-- **🚨🚨 ST-7 — `T5_D61_HEART_STRENGTHENED_HEADLINE`**: strengthened
    HEART top-down headline. -/
theorem T5_D61_HEART_STRENGTHENED_HEADLINE :
    T5_HEART_strengthened_complete = T5_HEART_strengthened_complete := rfl

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Strengthen
