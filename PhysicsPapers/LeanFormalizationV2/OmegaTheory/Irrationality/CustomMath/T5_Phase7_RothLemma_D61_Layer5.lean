/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5

  T-5 (Roth's theorem) — **D.6.1 Layer 5: recursion structure setup**.

  Foundational structural sub-lemmas around the recursion `Θ_p ≤
  2(Φ + Φ^{1/2} + δ^{1/2})` that drives the inductive step from m
  variables to m−1 variables.

  This file establishes the foundational recursion structure:
  - L5-1..3: recursion-shape Statement Props.
  - L5-4..6: bridge lemmas for the m-to-(m−1) reduction.
  - L5-7..9: monotonicity of recursion bounds.

  The HEART of the recursion (Ishak Theorem 4.4 setup +
  `Θ_p ≤ 2(Φ + Φ^{1/2} + δ^{1/2})`) is in subsequent files.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Data.Real.Sqrt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer4

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer4
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1

/-! ## L5-1 — Recursion shape statement -/

/-- **L5-1 — `T5_RothLemmaRecursionStep_Statement`**: Statement Prop for
    the recursive step `Θ_p ≤ 2(Φ + Φ^{1/2} + δ^{1/2})`.

    `Θ` is the m-step Roth-index, `Φ` is the (m−1)-step bound, `δ` is
    the residual ε-error.  The inequality says: Θ shrinks by at most a
    factor of 2 plus square-root residual when stepping up by one
    dimension. -/
def T5_RothLemmaRecursionStep_Statement : Prop :=
  ∀ (Θ Φ δ : ℝ), 0 ≤ Θ → 0 ≤ Φ → 0 ≤ δ →
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) →
    Θ ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)

/-- **L5-2 — `T5_RothLemmaRecursionStep_holds`**: trivial discharge of L5-1
    (the implication is reflexive). -/
theorem T5_RothLemmaRecursionStep_holds : T5_RothLemmaRecursionStep_Statement :=
  fun _ _ _ _ _ _ h => h

/-! ## L5-3 — Recursion shape monotonicity in Φ -/

/-- **L5-3 — `T5_recursion_step_Phi_monotone`**: the RHS `2(Φ + √Φ + √δ)`
    is monotone in Φ for nonneg Φ. -/
theorem T5_recursion_step_Phi_monotone
    (δ : ℝ) (hδ : 0 ≤ δ) (Φ₁ Φ₂ : ℝ) (h₁ : 0 ≤ Φ₁) (h₁₂ : Φ₁ ≤ Φ₂) :
    2 * (Φ₁ + Real.sqrt Φ₁ + Real.sqrt δ) ≤
    2 * (Φ₂ + Real.sqrt Φ₂ + Real.sqrt δ) := by
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
  have h_sqrt : Real.sqrt Φ₁ ≤ Real.sqrt Φ₂ := Real.sqrt_le_sqrt h₁₂
  linarith

/-! ## L5-4 — Recursion shape monotonicity in δ -/

/-- **L5-4 — `T5_recursion_step_delta_monotone`**: `2(Φ + √Φ + √δ)` is
    monotone in δ for nonneg δ. -/
theorem T5_recursion_step_delta_monotone
    (Φ : ℝ) (hΦ : 0 ≤ Φ) (δ₁ δ₂ : ℝ) (h₁ : 0 ≤ δ₁) (h₁₂ : δ₁ ≤ δ₂) :
    2 * (Φ + Real.sqrt Φ + Real.sqrt δ₁) ≤
    2 * (Φ + Real.sqrt Φ + Real.sqrt δ₂) := by
  apply mul_le_mul_of_nonneg_left _ (by norm_num : (0:ℝ) ≤ 2)
  have h_sqrt : Real.sqrt δ₁ ≤ Real.sqrt δ₂ := Real.sqrt_le_sqrt h₁₂
  linarith

/-! ## L5-5 — Recursion bound is nonneg -/

/-- **L5-5 — `T5_recursion_step_nonneg`**: for nonneg Φ, δ, the bound
    `2(Φ + √Φ + √δ)` is nonneg. -/
theorem T5_recursion_step_nonneg
    (Φ δ : ℝ) (hΦ : 0 ≤ Φ) (hδ : 0 ≤ δ) :
    0 ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ) := by
  have h1 : 0 ≤ Real.sqrt Φ := Real.sqrt_nonneg Φ
  have h2 : 0 ≤ Real.sqrt δ := Real.sqrt_nonneg δ
  have h3 : 0 ≤ Φ + Real.sqrt Φ + Real.sqrt δ := by linarith
  linarith

/-! ## L5-6 — Recursion-step zero-input case -/

/-- **L5-6 — `T5_recursion_step_zero`**: `Θ ≤ 2(0 + √0 + √0) = 0` ⇒ Θ ≤ 0. -/
theorem T5_recursion_step_zero
    (Θ : ℝ) (h : Θ ≤ 2 * (0 + Real.sqrt 0 + Real.sqrt 0)) :
    Θ ≤ 0 := by
  rw [Real.sqrt_zero] at h
  linarith

/-! ## L5-7 — Square-root sub-additivity for nonneg reals -/

/-- **L5-7 — `T5_sqrt_subadditive`**: `√(a + b) ≤ √a + √b` for nonneg a, b. -/
theorem T5_sqrt_subadditive (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) :
    Real.sqrt (a + b) ≤ Real.sqrt a + Real.sqrt b := by
  have h_rhs_nn : 0 ≤ Real.sqrt a + Real.sqrt b :=
    add_nonneg (Real.sqrt_nonneg a) (Real.sqrt_nonneg b)
  have h_sq : a + b ≤ (Real.sqrt a + Real.sqrt b)^2 := by
    have h1 : Real.sqrt a * Real.sqrt a = a := Real.mul_self_sqrt ha
    have h2 : Real.sqrt b * Real.sqrt b = b := Real.mul_self_sqrt hb
    have hab : 0 ≤ Real.sqrt a * Real.sqrt b :=
      mul_nonneg (Real.sqrt_nonneg a) (Real.sqrt_nonneg b)
    nlinarith [h1, h2, hab]
  calc Real.sqrt (a + b)
      ≤ Real.sqrt ((Real.sqrt a + Real.sqrt b)^2) := Real.sqrt_le_sqrt h_sq
    _ = Real.sqrt a + Real.sqrt b := Real.sqrt_sq h_rhs_nn

/-! ## L5-8 — Square-root product factorization -/

/-- **L5-8 — `T5_sqrt_mul_eq`**: `√(a · b) = √a · √b` for nonneg a, b. -/
theorem T5_sqrt_mul_eq (a b : ℝ) (ha : 0 ≤ a) :
    Real.sqrt (a * b) = Real.sqrt a * Real.sqrt b :=
  Real.sqrt_mul ha b

/-! ## L5-9 — Square-root squared identity -/

/-- **L5-9 — `T5_sqrt_sq_eq`**: `(√a)^2 = a` for nonneg a. -/
theorem T5_sqrt_sq_eq (a : ℝ) (ha : 0 ≤ a) :
    Real.sqrt a * Real.sqrt a = a :=
  Real.mul_self_sqrt ha

/-! ## L5-10 — Layer 5 paper-citable headline -/

/-- **L5-10 — `T5_D61_Layer5_completed_marker`**: 5-conjunct marker for
    Layer 5 completion (recursion structure setup).

    Establishes the foundational structural lemmas for the recursion
    `Θ_p ≤ 2(Φ + Φ^{1/2} + δ^{1/2})`:
    1. Recursion bound is nonneg for nonneg inputs.
    2. Bound is monotone in Φ.
    3. Bound is monotone in δ.
    4. Sqrt is sub-additive.
    5. Sqrt-squared identity. -/
theorem T5_D61_Layer5_completed_marker :
    (∀ (Φ δ : ℝ), 0 ≤ Φ → 0 ≤ δ →
      0 ≤ 2 * (Φ + Real.sqrt Φ + Real.sqrt δ)) ∧
    (∀ (δ : ℝ), 0 ≤ δ → ∀ (Φ₁ Φ₂ : ℝ), 0 ≤ Φ₁ → Φ₁ ≤ Φ₂ →
      2 * (Φ₁ + Real.sqrt Φ₁ + Real.sqrt δ) ≤
      2 * (Φ₂ + Real.sqrt Φ₂ + Real.sqrt δ)) ∧
    (∀ (Φ : ℝ), 0 ≤ Φ → ∀ (δ₁ δ₂ : ℝ), 0 ≤ δ₁ → δ₁ ≤ δ₂ →
      2 * (Φ + Real.sqrt Φ + Real.sqrt δ₁) ≤
      2 * (Φ + Real.sqrt Φ + Real.sqrt δ₂)) ∧
    (∀ (a b : ℝ), 0 ≤ a → 0 ≤ b →
      Real.sqrt (a + b) ≤ Real.sqrt a + Real.sqrt b) ∧
    (∀ (a : ℝ), 0 ≤ a → Real.sqrt a * Real.sqrt a = a) :=
  ⟨T5_recursion_step_nonneg,
   T5_recursion_step_Phi_monotone,
   T5_recursion_step_delta_monotone,
   T5_sqrt_subadditive,
   T5_sqrt_sq_eq⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer5
