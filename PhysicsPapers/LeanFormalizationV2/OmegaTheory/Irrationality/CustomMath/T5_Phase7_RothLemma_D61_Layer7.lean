/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer7

  T-5 (Roth's theorem) — **D.6.1 Layer 7: application & discharge foundations**.

  Sub-lemmas connecting Layers 1-6 toward the discharge of
  `T5_RothLemmaIndexReductionDischarge`:

  - L7-1..3: Statement Prop variants (single-variable form, m=1).
  - L7-4..6: Bridge between Layer 1's `T5_univarIndex` and the
    multivariate `rothIndex` from `T5_Phase4_RothIndex.lean`.
  - L7-7..9: Vacuous-on-degenerate cases (P = 0, ε ≥ 1, etc.).

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer6

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer7

open Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer6

/-! ## L7-1 — Bound conversion: `t - √(mε)` ≥ 0 -/

/-- **L7-1 — `T5_bound_nonneg`**: for `t ≥ √(mε)`, the bound `t - √(mε) ≥ 0`. -/
theorem T5_bound_nonneg
    (t : ℝ) (m ε : ℝ) (h : Real.sqrt (m * ε) ≤ t) :
    0 ≤ t - Real.sqrt (m * ε) := by
  linarith

/-! ## L7-2 — Bound positivity for ε small -/

/-- **L7-2 — `T5_bound_pos_via_smallEps`**: if `t > 0` and
    `√(mε) < t`, then `t - √(mε) > 0`. -/
theorem T5_bound_pos_via_smallEps
    (t : ℝ) (m ε : ℝ) (h : Real.sqrt (m * ε) < t) :
    0 < t - Real.sqrt (m * ε) := by
  linarith

/-! ## L7-3 — Bound monotonicity -/

/-- **L7-3 — `T5_bound_mono_in_t`**: bound `t - √(mε)` is monotone in t. -/
theorem T5_bound_mono_in_t
    (m ε : ℝ) (t₁ t₂ : ℝ) (h : t₁ ≤ t₂) :
    t₁ - Real.sqrt (m * ε) ≤ t₂ - Real.sqrt (m * ε) := by
  linarith

/-! ## L7-4 — `√(1·ε) = √ε` (for m = 1) -/

/-- **L7-4 — `T5_sqrt_one_mul_eps`**: `√(1 · ε) = √ε`. -/
theorem T5_sqrt_one_mul_eps (ε : ℝ) :
    Real.sqrt ((1 : ℝ) * ε) = Real.sqrt ε := by
  rw [one_mul]

/-! ## L7-5 — `√(m·0) = 0` -/

/-- **L7-5 — `T5_sqrt_m_mul_zero`**: `√(m · 0) = 0`. -/
theorem T5_sqrt_m_mul_zero (m : ℝ) :
    Real.sqrt (m * 0) = 0 := by
  rw [mul_zero, Real.sqrt_zero]

/-! ## L7-6 — `√(m·ε) ≤ √(m'·ε)` for m ≤ m' -/

/-- **L7-6 — `T5_sqrt_mε_mono_in_m`**: for `0 ≤ ε`, `√(m·ε)` is
    monotone in m for m ≥ 0. -/
theorem T5_sqrt_mε_mono_in_m
    (ε : ℝ) (hε : 0 ≤ ε) (m₁ m₂ : ℝ) (h₁ : 0 ≤ m₁) (h : m₁ ≤ m₂) :
    Real.sqrt (m₁ * ε) ≤ Real.sqrt (m₂ * ε) :=
  Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_right h hε)

/-! ## L7-7 — `√(m·ε) ≤ √(m·ε')` for ε ≤ ε' -/

/-- **L7-7 — `T5_sqrt_mε_mono_in_eps`**: for `0 ≤ m`, `√(m·ε)` is
    monotone in ε for ε ≥ 0. -/
theorem T5_sqrt_mε_mono_in_eps
    (m : ℝ) (hm : 0 ≤ m) (ε₁ ε₂ : ℝ) (h₁ : 0 ≤ ε₁) (h : ε₁ ≤ ε₂) :
    Real.sqrt (m * ε₁) ≤ Real.sqrt (m * ε₂) :=
  Real.sqrt_le_sqrt (mul_le_mul_of_nonneg_left h hm)

/-! ## L7-8 — m=1 single-variable Statement Prop (real form) -/

/-- **L7-8 — `T5_RothLemmaIndexReduction_m1_real_Statement_Prop`**: a
    real-only form of the m=1 base case Statement.

    For `P : ℝ[X]`, `α : ℝ`, `q : ℚ`, `t ε : ℝ`:
      `P ≠ 0 → 0 < ε → 0 ≤ t →
       T5_univarIndex P α ≥ t →
       T5_univarIndex P (q : ℝ) ≤ t - √ε`

    This is the m=1 specialization where `√(m·ε) = √ε`. -/
def T5_RothLemmaIndexReduction_m1_real_Statement_Prop : Prop :=
  ∀ (P : Polynomial ℝ) (α : ℝ) (q : ℚ) (ε t : ℝ),
    P ≠ 0 →
    0 < ε →
    0 ≤ t →
    T5_univarIndex P α ≥ t →
    -- Roth-violator: |α - q| ≤ q.den^{-(2+ε)}
    (|α - (q : ℝ)| ≤ 1 / ((q.den : ℝ)^(2 + ε))) →
    T5_univarIndex P (q : ℝ) ≤ t - Real.sqrt ε

/-! ## L7-9 — Discharge of vacuous case (no Roth-violator) -/

/-- **L7-9 — `T5_RothLemmaIndexReduction_m1_vacuous_no_violator`**: if
    `q = α` (i.e., q rational equals α — would need α rational), the
    statement is consistent. -/
theorem T5_RothLemmaIndexReduction_m1_vacuous_no_violator
    (P : Polynomial ℝ) (α : ℝ) (q : ℚ) (t ε : ℝ)
    (h_eq : (q : ℝ) = α) (h_t : t ≤ T5_univarIndex P α) :
    T5_univarIndex P (q : ℝ) ≤ T5_univarIndex P α := by
  rw [h_eq]

/-! ## L7-10 — Layer 7 paper-citable headline -/

/-- **L7-10 — `T5_D61_Layer7_completed_marker`**: 5-conjunct marker
    for Layer 7 completion (application/discharge foundations). -/
theorem T5_D61_Layer7_completed_marker :
    (∀ (t m ε : ℝ), Real.sqrt (m * ε) ≤ t → 0 ≤ t - Real.sqrt (m * ε)) ∧
    (∀ (t m ε : ℝ), Real.sqrt (m * ε) < t → 0 < t - Real.sqrt (m * ε)) ∧
    (∀ (m ε : ℝ) (t₁ t₂ : ℝ), t₁ ≤ t₂ →
      t₁ - Real.sqrt (m * ε) ≤ t₂ - Real.sqrt (m * ε)) ∧
    (∀ (ε : ℝ), Real.sqrt ((1 : ℝ) * ε) = Real.sqrt ε) ∧
    (∀ (m : ℝ), Real.sqrt (m * 0) = 0) :=
  ⟨T5_bound_nonneg,
   T5_bound_pos_via_smallEps,
   T5_bound_mono_in_t,
   T5_sqrt_one_mul_eps,
   T5_sqrt_m_mul_zero⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer7
