/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge

  T-5 (Roth's theorem) — **D.6.1 HEART bridge to V8**.

  Bridge sub-lemmas connecting HEART recursion to V8 closure shape.

  Single-thread hand-authored 2026-04-29.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Convergence
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Convergence
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Composition

/-! ## BR-1 — HEART bridge: recursion + ε > 0 -/

theorem T5_HEART_bridge_eps_pos
    (Φ ε : ℝ) (hΦ : 0 ≤ Φ) (hε : 0 < ε) :
    0 < 2 * (Φ + Real.sqrt Φ + Real.sqrt ε) :=
  T5_HEART_recursion_pos_lhs Φ ε hΦ hε

/-! ## BR-2 — HEART bridge: m=1 specialization -/

theorem T5_HEART_bridge_m_eq_one
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h_init : Θ ≤ Φ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) :=
  T5_HEART_recursion_Theta_le_Phi Θ Φ δ hΘ hΦ hδ h_init

/-! ## BR-3 — HEART bridge: half-step Φ → Φ/2 reduction -/

theorem T5_HEART_bridge_half_step
    (Φ : ℝ) (hΦ : 0 ≤ Φ) :
    Φ / 2 ≤ Φ := by
  have : Φ - Φ / 2 = Φ / 2 := by ring
  linarith

/-! ## BR-4 — HEART bridge: scaled recursion bound -/

theorem T5_HEART_bridge_scale
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ Φ + Real.sqrt Φ + Real.sqrt δ) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## BR-5 — HEART bridge: pre-recursion bound (input form) -/

theorem T5_HEART_bridge_pre_recursion
    (Θ Φ δ : ℝ) (hΘ : 0 ≤ Θ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ 0) :
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have hzero := T5_HEART_recursion_Theta_zero Φ δ hΦ hδ
  linarith

/-! ## BR-6 — HEART bridge headline -/

theorem T5_D61_HEART_BRIDGE_HEADLINE :
    (∀ (Φ ε : ℝ), 0 ≤ Φ → 0 < ε →
      0 < 2 * (Φ + Real.sqrt Φ + Real.sqrt ε)) ∧
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ → Θ ≤ Φ →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    (∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
      Θ ≤ Φ + Real.sqrt Φ + Real.sqrt δ →
      Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :=
  ⟨T5_HEART_bridge_eps_pos,
   T5_HEART_bridge_m_eq_one,
   T5_HEART_bridge_scale⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_HEART_Bridge
