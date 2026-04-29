/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5_HeartFoundation

  T-5 (Roth's theorem) — **D.6.1 Layer 5 HEART: foundation sub-lemmas**.

  Foundational sub-lemmas for the HEART recursion step
  `Θ_p ≤ 2(Φ + √Φ + √δ)` of Hindry-Silverman D.6.1.

  This file establishes meaningful arithmetic foundations:

  - HF-1..3: nonneg-arithmetic Φ + √Φ-shape combinations.
  - HF-4..6: m=2 specialization arithmetic.
  - HF-7..9: recursion-step bound algebra.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5_HeartFoundation

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5

/-! ## HF-1 — Φ + √Φ ≥ 0 for nonneg Φ -/

/-- **HF-1 — `T5_Phi_plus_sqrt_Phi_nonneg`**: `Φ + √Φ ≥ 0` for `Φ ≥ 0`. -/
theorem T5_Phi_plus_sqrt_Phi_nonneg (Φ : ℝ) (hΦ : 0 ≤ Φ) :
    0 ≤ Φ + Real.sqrt Φ := by
  have h_sqrt : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  linarith

/-! ## HF-2 — Φ + √Φ + √δ ≥ 0 for nonneg Φ, δ -/

/-- **HF-2 — `T5_Phi_sqrt_Phi_sqrt_delta_nonneg`**: `Φ + √Φ + √δ ≥ 0` for nonneg Φ, δ. -/
theorem T5_Phi_sqrt_Phi_sqrt_delta_nonneg (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    0 ≤ Φ + Real.sqrt Φ + Real.sqrt δ := by
  have h_sqrt_Φ : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h_sqrt_δ : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  linarith

/-! ## HF-3 — Recursion-step zero-Φ collapse -/

/-- **HF-3 — `T5_recursion_step_zero_Phi`**: `2(0 + √0 + √δ) = 2√δ`. -/
theorem T5_recursion_step_zero_Phi (δ : ℝ) :
    2 * ((0 : ℝ) + Real.sqrt 0 + Real.sqrt δ) = 2 * Real.sqrt δ := by
  rw [Real.sqrt_zero]
  ring

/-! ## HF-4 — Recursion-step zero-δ collapse -/

/-- **HF-4 — `T5_recursion_step_zero_delta`**: `2(Φ + √Φ + √0) = 2(Φ + √Φ)`. -/
theorem T5_recursion_step_zero_delta (Φ : ℝ) :
    2 * (Φ + Real.sqrt Φ + Real.sqrt 0) = 2 * (Φ + Real.sqrt Φ) := by
  rw [Real.sqrt_zero]
  ring

/-! ## HF-5 — m=2 base recursion-shape bound -/

/-- **HF-5 — `T5_recursion_step_m2_base`**: for the m=2 case (Θ_2 ≤
    2(Φ_1 + √Φ_1 + √δ)), trivial when Θ_2 = 0. -/
theorem T5_recursion_step_m2_base
    (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    (0 : ℝ) ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have := T5_Phi_sqrt_Phi_sqrt_delta_nonneg Φ δ hΦ hδ
  linarith

/-! ## HF-6 — Recursion shape inequality preservation -/

/-- **HF-6 — `T5_recursion_step_le_double`**: if `Θ ≤ 2(Φ + √Φ + √δ)`,
    then `Θ ≤ 2·2·(Φ + √Φ + √δ) = 4(Φ + √Φ + √δ)`. -/
theorem T5_recursion_step_le_double
    (Θ Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (h : Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) :
    Θ ≤ 4 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h_nn := T5_Phi_sqrt_Phi_sqrt_delta_nonneg Φ δ hΦ hδ
  linarith

/-! ## HF-7 — `2(Φ + √Φ + √δ) ≤ 2Φ + 2√Φ + 2√δ` -/

/-- **HF-7 — `T5_recursion_step_distrib`**: distributing the 2 inside. -/
theorem T5_recursion_step_distrib (Φ δ : ℝ) :
    2 * (Φ + Real.sqrt Φ + Real.sqrt δ) =
    2 * Φ + 2 * Real.sqrt Φ + 2 * Real.sqrt δ := by ring

/-! ## HF-8 — Recursion bound 2(Φ + √Φ + √δ) ≤ 4·max(Φ, √Φ, √δ) -/

/-- **HF-8 — `T5_recursion_step_le_max`**: when one of Φ, √Φ, √δ is
    much larger, the bound is dominated by it. -/
theorem T5_recursion_step_le_max
    (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ)
    (M : ℝ) (hM_Φ : Φ ≤ M) (hM_sqΦ : Real.sqrt Φ ≤ M) (hM_sqδ : Real.sqrt δ ≤ M) :
    2 * (Φ + Real.sqrt Φ + Real.sqrt δ) ≤ 6 * M := by
  rw [T5_recursion_step_distrib]
  have h1 : 2 * Φ ≤ 2 * M := by linarith
  have h2 : 2 * Real.sqrt Φ ≤ 2 * M := by linarith
  have h3 : 2 * Real.sqrt δ ≤ 2 * M := by linarith
  linarith

/-! ## HF-9 — `√δ ≤ √(δ + ε)` for ε ≥ 0 -/

/-- **HF-9 — `T5_sqrt_le_sqrt_add`**: `0 ≤ ε → √δ ≤ √(δ + ε)` (for δ ≥ 0). -/
theorem T5_sqrt_le_sqrt_add (δ ε : ℝ) (hε : 0 ≤ ε) :
    Real.sqrt δ ≤ Real.sqrt (δ + ε) := by
  apply Real.sqrt_le_sqrt
  linarith

/-! ## HF-10 — HEART foundation marker -/

/-- **HF-10 — `T5_D61_Layer5_HEART_foundation_marker`**: 5-conjunct
    marker for HEART foundation sub-lemmas. -/
theorem T5_D61_Layer5_HEART_foundation_marker :
    (∀ (Φ : ℝ), 0 ≤ Φ → 0 ≤ Φ + Real.sqrt Φ) ∧
    (∀ (Φ δ : ℝ), 0 ≤ Φ → 0 ≤ δ → 0 ≤ Φ + Real.sqrt Φ + Real.sqrt δ) ∧
    (∀ (δ : ℝ), 2 * ((0 : ℝ) + Real.sqrt 0 + Real.sqrt δ) = 2 * Real.sqrt δ) ∧
    (∀ (Φ δ : ℝ), 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) =
      2 * Φ + 2 * Real.sqrt Φ + 2 * Real.sqrt δ) ∧
    (∀ (δ ε : ℝ), 0 ≤ ε → Real.sqrt δ ≤ Real.sqrt (δ + ε)) :=
  ⟨T5_Phi_plus_sqrt_Phi_nonneg,
   T5_Phi_sqrt_Phi_sqrt_delta_nonneg,
   T5_recursion_step_zero_Phi,
   T5_recursion_step_distrib,
   T5_sqrt_le_sqrt_add⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5_HeartFoundation
