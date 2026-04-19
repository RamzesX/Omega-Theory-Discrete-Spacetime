/-
  OmegaTheory.Emergence.KoideRelation

  **The Koide lepton-mass formula (1981, arXiv:hep-ph/0509043).**

  Yoshio Koide's parameter-free relation among the three charged-lepton masses:

      Q = (m_e + m_μ + m_τ) / (√m_e + √m_μ + √m_τ)²  =  2/3

  holds experimentally (PDG 2024) to roughly 0.9 σ, with no adjustable
  parameter. This file provides the first PDG-anchored numerical
  theorem in OmegaTheory V2's matter sector.

  Content:

  1. PDG 2024 central values for `m_e`, `m_μ`, `m_τ` in MeV (as
     `noncomputable def` real constants that equal rational literals —
     kept rational so `norm_num` can operate).
  2. Positivity of the three masses.
  3. The Koide ratio `koideQ m₁ m₂ m₃`.
  4. Positivity `koideQ_pos`.
  5. Rational brackets for each `Real.sqrt m_i` (verified by
     `Real.sqrt_lt_sqrt` + `norm_num`).
  6. Main numerical theorem `koide_formula_holds`:
         |koideQ m_e m_μ m_τ − 2/3| < 10⁻⁴.
     Honest: the PDG-level precision is ~10⁻⁵, but the 10⁻⁴ bound
     is what this formalization proves via interval-bracketing. The
     actual arithmetic (with the chosen rational sqrt brackets)
     delivers < 10⁻⁵; the stated bound is 10⁻⁴ for safety margin
     against rational-arithmetic round-off.
  7. Tau-mass predicted from Koide's equation with 0.5-MeV tolerance
     (`tau_mass_predicted_from_koide`).

  Strategy: rational interval arithmetic. For each lepton mass
  `m_i` we provide `a_i, b_i ∈ ℚ` with `a_i² < m_i < b_i²` so that
  `a_i < √m_i < b_i`. Summing we bracket `S := Σ √m_i ∈ [S_lo, S_hi]`
  and hence `S² ∈ [S_lo², S_hi²]`. The ratio `num/S²` then lies in
  `[num/S_hi², num/S_lo²]`, and both endpoints are within `10⁻⁵`
  of 2/3 by rational arithmetic (confirmed via `norm_num`).

  HARD RULES: **0 sorry, 0 new axioms**.

  Agent: Elnath (β Tauri / γ Aurigae, "the butting horn"), 2026-04-17.
-/

import Mathlib.Data.Real.Sqrt
import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic

namespace OmegaTheory.Emergence.KoideRelation

/-! ## 1. PDG 2024 charged-lepton masses (MeV / c²)

Central values taken from the Particle Data Group 2024 review:
  * m_e   = 0.51099895 MeV   (well-measured: electron mass)
  * m_μ   = 105.6583755 MeV  (muon, from g−2/magic-ring fits)
  * m_τ   = 1776.86 MeV      (tau, from B-factory kinematic fits)

We keep these as **rational literals** on `ℝ`, so `norm_num` can
operate directly on them. -/

/-- PDG 2024 electron mass in MeV. -/
noncomputable def m_e : ℝ := 0.51099895

/-- PDG 2024 muon mass in MeV. -/
noncomputable def m_μ : ℝ := 105.6583755

/-- PDG 2024 tau mass in MeV. -/
noncomputable def m_τ : ℝ := 1776.86

/-! ## 2. Positivity of all three masses -/

theorem m_e_pos : 0 < m_e := by unfold m_e; norm_num
theorem m_μ_pos : 0 < m_μ := by unfold m_μ; norm_num
theorem m_τ_pos : 0 < m_τ := by unfold m_τ; norm_num

theorem m_e_nonneg : 0 ≤ m_e := m_e_pos.le
theorem m_μ_nonneg : 0 ≤ m_μ := m_μ_pos.le
theorem m_τ_nonneg : 0 ≤ m_τ := m_τ_pos.le

/-! ## 3. The Koide Q ratio -/

/-- **Koide's charged-lepton ratio.** For three positive masses
    `m₁, m₂, m₃` define

        Q = (m₁ + m₂ + m₃) / (√m₁ + √m₂ + √m₃)²

    Koide (1981) conjectured `Q = 2/3` for the charged-lepton tower. -/
noncomputable def koideQ (m₁ m₂ m₃ : ℝ) : ℝ :=
  (m₁ + m₂ + m₃) / (Real.sqrt m₁ + Real.sqrt m₂ + Real.sqrt m₃) ^ 2

/-- The theoretical Koide value. -/
noncomputable def koideTheoretical : ℝ := 2 / 3

/-! ## 4. Well-definedness: Q is strictly positive for positive masses. -/

/-- The denominator sum of square roots is strictly positive if at least
    one mass is strictly positive (we only need any single mass
    positive — but state it for the common case of three positive). -/
theorem sqrt_sum_pos {m₁ m₂ m₃ : ℝ}
    (h₁ : 0 < m₁) (h₂ : 0 < m₂) (h₃ : 0 < m₃) :
    0 < Real.sqrt m₁ + Real.sqrt m₂ + Real.sqrt m₃ := by
  have s₁ : 0 < Real.sqrt m₁ := Real.sqrt_pos.mpr h₁
  have s₂ : 0 < Real.sqrt m₂ := Real.sqrt_pos.mpr h₂
  have s₃ : 0 < Real.sqrt m₃ := Real.sqrt_pos.mpr h₃
  linarith

/-- **Koide Q is strictly positive for positive masses.** -/
theorem koideQ_pos {m₁ m₂ m₃ : ℝ}
    (h₁ : 0 < m₁) (h₂ : 0 < m₂) (h₃ : 0 < m₃) :
    0 < koideQ m₁ m₂ m₃ := by
  unfold koideQ
  have hS : 0 < Real.sqrt m₁ + Real.sqrt m₂ + Real.sqrt m₃ :=
    sqrt_sum_pos h₁ h₂ h₃
  have hSq : 0 < (Real.sqrt m₁ + Real.sqrt m₂ + Real.sqrt m₃) ^ 2 := by
    positivity
  have hNum : 0 < m₁ + m₂ + m₃ := by linarith
  exact div_pos hNum hSq

/-! ## 5. Rational brackets for each √m_i

We choose tight rational bounds `a_i ≤ √m_i ≤ b_i` by squaring
candidate rationals and applying `Real.sqrt_lt_sqrt`. -/

/-- Lower bound: `0.71484 < √m_e`. -/
theorem sqrt_m_e_lb : (71484 : ℝ) / 100000 < Real.sqrt m_e := by
  have h_nn : (0 : ℝ) ≤ 71484 / 100000 := by norm_num
  rw [show Real.sqrt m_e = Real.sqrt m_e from rfl,
      show ((71484 : ℝ) / 100000) = Real.sqrt (((71484 : ℝ) / 100000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt (by positivity)
  unfold m_e; norm_num

/-- Upper bound: `√m_e < 0.71485`. -/
theorem sqrt_m_e_ub : Real.sqrt m_e < (71485 : ℝ) / 100000 := by
  have h_nn : (0 : ℝ) ≤ 71485 / 100000 := by norm_num
  rw [show ((71485 : ℝ) / 100000) = Real.sqrt (((71485 : ℝ) / 100000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt m_e_nonneg
  unfold m_e; norm_num

/-- Lower bound: `10.27902 < √m_μ`. -/
theorem sqrt_m_μ_lb : (1027902 : ℝ) / 100000 < Real.sqrt m_μ := by
  have h_nn : (0 : ℝ) ≤ 1027902 / 100000 := by norm_num
  rw [show ((1027902 : ℝ) / 100000)
        = Real.sqrt (((1027902 : ℝ) / 100000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt (by positivity)
  unfold m_μ; norm_num

/-- Upper bound: `√m_μ < 10.27904`. -/
theorem sqrt_m_μ_ub : Real.sqrt m_μ < (1027904 : ℝ) / 100000 := by
  have h_nn : (0 : ℝ) ≤ 1027904 / 100000 := by norm_num
  rw [show ((1027904 : ℝ) / 100000)
        = Real.sqrt (((1027904 : ℝ) / 100000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt m_μ_nonneg
  unfold m_μ; norm_num

/-- Lower bound: `42.1527 < √m_τ`. -/
theorem sqrt_m_τ_lb : (421527 : ℝ) / 10000 < Real.sqrt m_τ := by
  have h_nn : (0 : ℝ) ≤ 421527 / 10000 := by norm_num
  rw [show ((421527 : ℝ) / 10000)
        = Real.sqrt (((421527 : ℝ) / 10000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt (by positivity)
  unfold m_τ; norm_num

/-- Upper bound: `√m_τ < 42.1529`. -/
theorem sqrt_m_τ_ub : Real.sqrt m_τ < (421529 : ℝ) / 10000 := by
  have h_nn : (0 : ℝ) ≤ 421529 / 10000 := by norm_num
  rw [show ((421529 : ℝ) / 10000)
        = Real.sqrt (((421529 : ℝ) / 10000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt m_τ_nonneg
  unfold m_τ; norm_num

/-! ## 6. Brackets for the sum S := √m_e + √m_μ + √m_τ

  `S_lo := 0.71484 + 10.27902 + 42.1527 = 53.14656`
  `S_hi := 0.71485 + 10.27904 + 42.1529 = 53.14679` -/

/-- Lower bound for `S`. -/
theorem S_lb :
    (5314656 : ℝ) / 100000
      < Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ := by
  have h1 := sqrt_m_e_lb
  have h2 := sqrt_m_μ_lb
  have h3 := sqrt_m_τ_lb
  -- 71484/100000 + 1027902/100000 + 421527/10000 = 5314656/100000
  have : (71484 : ℝ) / 100000 + 1027902 / 100000 + 421527 / 10000
      = 5314656 / 100000 := by norm_num
  linarith

/-- Upper bound for `S`. -/
theorem S_ub :
    Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ
      < (5314679 : ℝ) / 100000 := by
  have h1 := sqrt_m_e_ub
  have h2 := sqrt_m_μ_ub
  have h3 := sqrt_m_τ_ub
  have : (71485 : ℝ) / 100000 + 1027904 / 100000 + 421529 / 10000
      = 5314679 / 100000 := by norm_num
  linarith

/-- The sum S is strictly positive (derived directly for convenience). -/
theorem S_pos :
    0 < Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ :=
  sqrt_sum_pos m_e_pos m_μ_pos m_τ_pos

/-! ## 7. Brackets for S² -/

/-- Lower bound `S² > S_lo²` (since `S_lo > 0` and `S > S_lo`). -/
theorem S_sq_lb :
    ((5314656 : ℝ) / 100000) ^ 2
      < (Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ) ^ 2 := by
  have h1 := S_lb
  have h0 : (0 : ℝ) ≤ 5314656 / 100000 := by norm_num
  -- We have 0 ≤ S_lo < S, so S_lo² < S² via strict monotonicity.
  have hS : 0 < Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ := S_pos
  have hSlo : (0 : ℝ) < 5314656 / 100000 := by norm_num
  nlinarith [sq_nonneg (5314656 / 100000 - (Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ)),
             sq_nonneg (5314656 / 100000 + (Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ)),
             S_lb, S_pos]

/-- Upper bound `S² < S_hi²` (since `S < S_hi`, `S ≥ 0`, `S_hi > 0`). -/
theorem S_sq_ub :
    (Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ) ^ 2
      < ((5314679 : ℝ) / 100000) ^ 2 := by
  have h1 := S_ub
  have hS : 0 < Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ := S_pos
  nlinarith [sq_nonneg (5314679 / 100000 - (Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ)),
             S_ub, S_pos]

/-! ## 8. The main Koide theorem

The arithmetic we need (all rational):

* `num := m_e + m_μ + m_τ = 1883.02937445`
* `S_lo² = (5314656/100000)² = 2824.5568398336`
* `S_hi² = (5314679/100000)² = 2824.5812873041`
* `Q_max = num/S_lo² ≈ 0.666664`
* `Q_min = num/S_hi² ≈ 0.666658`

Both within 10⁻⁵ of 2/3.
The safer 10⁻⁴ bound we prove gives generous headroom
for any interval-arithmetic slack.
-/

/-- The numerator `m_e + m_μ + m_τ` equals `1883.02937445`. -/
theorem koide_numerator_value :
    m_e + m_μ + m_τ = (188302937445 : ℝ) / 100000000 := by
  unfold m_e m_μ m_τ; norm_num

/-- Numerator is positive. -/
theorem koide_numerator_pos : 0 < m_e + m_μ + m_τ := by
  rw [koide_numerator_value]; norm_num

/-- **Koide's formula holds to within 10⁻⁵ for PDG lepton masses.**

    By the interval arithmetic established above:
    * `Q_max = num / S_lo²`: deviation from 2/3 is `≈ −3.02 × 10⁻⁶`.
    * `Q_min = num / S_hi²`: deviation from 2/3 is `≈ −8.78 × 10⁻⁶`.

    Both are within `10⁻⁵` of `2/3`, confirming Koide's 1981
    conjecture at the precision quoted by the PDG 2024 review
    (central PDG value: `Q = 0.666661 ± 0.000007`). -/
theorem koide_formula_holds :
    |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 := by
  unfold koideQ koideTheoretical
  set num : ℝ := m_e + m_μ + m_τ with hnum_def
  set S : ℝ := Real.sqrt m_e + Real.sqrt m_μ + Real.sqrt m_τ with hS_def
  have hS_pos : 0 < S := S_pos
  have hS_sq_pos : 0 < S ^ 2 := by positivity
  -- Numerator value
  have hnum_val : num = (188302937445 : ℝ) / 100000000 :=
    koide_numerator_value
  -- S² brackets
  have hS_sq_lb : ((5314656 : ℝ) / 100000) ^ 2 < S ^ 2 := S_sq_lb
  have hS_sq_ub : S ^ 2 < ((5314679 : ℝ) / 100000) ^ 2 := S_sq_ub
  have hSlo_pos : (0 : ℝ) < ((5314656 : ℝ) / 100000) ^ 2 := by norm_num
  have hShi_pos : (0 : ℝ) < ((5314679 : ℝ) / 100000) ^ 2 := by norm_num
  have hnum_pos : 0 < num := by rw [hnum_val]; norm_num
  -- num/S² < num/S_lo² (smaller denominator → larger quotient)
  have h_Q_upper : num / S ^ 2 < num / ((5314656 : ℝ) / 100000) ^ 2 :=
    div_lt_div_of_pos_left hnum_pos hSlo_pos hS_sq_lb
  -- num/S_hi² < num/S² (larger denominator → smaller quotient)
  have h_Q_lower : num / ((5314679 : ℝ) / 100000) ^ 2 < num / S ^ 2 :=
    div_lt_div_of_pos_left hnum_pos hS_sq_pos hS_sq_ub
  -- Rational values of the squared endpoints
  have hSlo_sq_val : ((5314656 : ℝ) / 100000) ^ 2
      = 28245568398336 / 10000000000 := by norm_num
  have hShi_sq_val : ((5314679 : ℝ) / 100000) ^ 2
      = 28245812873041 / 10000000000 := by norm_num
  -- |Q_max - 2/3| < 10⁻⁵
  have h_upper_dist :
      |num / ((5314656 : ℝ) / 100000) ^ 2 - 2/3| < 1 / 100000 := by
    rw [hnum_val, hSlo_sq_val, abs_sub_lt_iff]
    refine ⟨?_, ?_⟩ <;> norm_num
  -- |Q_min - 2/3| < 10⁻⁵
  have h_lower_dist :
      |num / ((5314679 : ℝ) / 100000) ^ 2 - 2/3| < 1 / 100000 := by
    rw [hnum_val, hShi_sq_val, abs_sub_lt_iff]
    refine ⟨?_, ?_⟩ <;> norm_num
  -- Extract pointwise signed bounds from the absolute-value bounds
  have h_upper_A : num / ((5314656 : ℝ) / 100000) ^ 2 - 2/3 < 1 / 100000 :=
    (abs_sub_lt_iff.mp h_upper_dist).1
  have h_upper_B :
      -(1 / 100000 : ℝ) < num / ((5314656 : ℝ) / 100000) ^ 2 - 2/3 := by
    have := (abs_sub_lt_iff.mp h_upper_dist).2
    linarith
  have h_lower_A : num / ((5314679 : ℝ) / 100000) ^ 2 - 2/3 < 1 / 100000 :=
    (abs_sub_lt_iff.mp h_lower_dist).1
  have h_lower_B :
      -(1 / 100000 : ℝ) < num / ((5314679 : ℝ) / 100000) ^ 2 - 2/3 := by
    have := (abs_sub_lt_iff.mp h_lower_dist).2
    linarith
  -- The actual ratio lies between the endpoint ratios.
  rw [abs_sub_lt_iff]
  refine ⟨?_, ?_⟩
  · -- num / S² - 2/3 < 10⁻⁵
    linarith
  · -- -(num / S² - 2/3) < 10⁻⁵
    linarith

/-! ## 9. τ-mass prediction from the Koide quadratic

Given `Q = 2/3` and two of the three masses, Koide's formula
becomes a quadratic equation in the third.  Writing `x := √m_τ`,

    3·(m_e + m_μ + x²) = 2·(√m_e + √m_μ + x)²

expands to the quadratic

    x² − 4·(√m_e + √m_μ)·x + 3·(m_e + m_μ) − 2·(√m_e + √m_μ)² = 0.

Its positive root (the "heavy" branch corresponding to τ) is

    x = 2·(√m_e + √m_μ) + √(3·(m_e + m_μ + 4·√(m_e·m_μ))).

Squaring gives the **Koide-predicted tau mass** `koidePredictedTau`.

The numerical computation delivers `m_τ^{pred} ≈ 1776.97 MeV`,
about `0.11 MeV` above the PDG central value `m_τ = 1776.86 MeV`. -/

/-- The Koide-quadratic's positive (heavy-branch) root in the
    variable `x = √m_τ`, using only the observed electron and
    muon masses. -/
noncomputable def koidePredictedSqrtTau : ℝ :=
  2 * (Real.sqrt m_e + Real.sqrt m_μ)
    + Real.sqrt (3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)))

/-- The Koide-quadratic's prediction for `m_τ` derived from
    `m_e`, `m_μ`, and `Q = 2/3`. -/
noncomputable def koidePredictedTau : ℝ := koidePredictedSqrtTau ^ 2

/-- Positivity: the predicted `√m_τ` is strictly positive. -/
theorem koidePredictedSqrtTau_pos : 0 < koidePredictedSqrtTau := by
  unfold koidePredictedSqrtTau
  have h₁ : 0 < Real.sqrt m_e := Real.sqrt_pos.mpr m_e_pos
  have h₂ : 0 < Real.sqrt m_μ := Real.sqrt_pos.mpr m_μ_pos
  have h₃ : 0 ≤ Real.sqrt (3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ))) :=
    Real.sqrt_nonneg _
  linarith

/-- Positivity: the predicted `m_τ` is strictly positive. -/
theorem koidePredictedTau_pos : 0 < koidePredictedTau := by
  unfold koidePredictedTau
  exact pow_pos koidePredictedSqrtTau_pos 2

/-! ### Brackets for the ingredients of `koidePredictedSqrtTau`

To bound `|m_τ − koidePredictedTau|` we need rational brackets for
each sub-expression. -/

/-- Bracket for `√(m_e * m_μ)`: `7.3478 < √(m_e·m_μ)`. -/
theorem sqrt_m_e_m_μ_lb : (73478 : ℝ) / 10000 < Real.sqrt (m_e * m_μ) := by
  have h_nn : (0 : ℝ) ≤ 73478 / 10000 := by norm_num
  rw [show ((73478 : ℝ) / 10000)
        = Real.sqrt (((73478 : ℝ) / 10000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt (by positivity)
  unfold m_e m_μ; norm_num

/-- Bracket for `√(m_e * m_μ)`: `√(m_e·m_μ) < 7.3479`. -/
theorem sqrt_m_e_m_μ_ub : Real.sqrt (m_e * m_μ) < (73479 : ℝ) / 10000 := by
  have h_nn : (0 : ℝ) ≤ 73479 / 10000 := by norm_num
  have hm_pos : (0 : ℝ) ≤ m_e * m_μ := mul_nonneg m_e_nonneg m_μ_nonneg
  rw [show ((73479 : ℝ) / 10000)
        = Real.sqrt (((73479 : ℝ) / 10000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt hm_pos
  unfold m_e m_μ; norm_num

/-- Bracket for `m_e + m_μ + 4·√(m_e·m_μ)` from below:
    > 135.5605 (using `√(m_e·m_μ) > 7.3478`). -/
theorem koide_p_lb :
    (13556057445 : ℝ) / 100000000
      < m_e + m_μ + 4 * Real.sqrt (m_e * m_μ) := by
  have h := sqrt_m_e_m_μ_lb
  -- m_e + m_μ = 106.16937445 exactly
  have hsum : m_e + m_μ = (10616937445 : ℝ) / 100000000 := by
    unfold m_e m_μ; norm_num
  linarith

/-- Bracket for `m_e + m_μ + 4·√(m_e·m_μ)` from above:
    < 135.5609 (using `√(m_e·m_μ) < 7.3479`). -/
theorem koide_p_ub :
    m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)
      < (13556097445 : ℝ) / 100000000 := by
  have h := sqrt_m_e_m_μ_ub
  have hsum : m_e + m_μ = (10616937445 : ℝ) / 100000000 := by
    unfold m_e m_μ; norm_num
  linarith

/-- Bracket for `3·(m_e + m_μ + 4·√(m_e·m_μ))` from below. -/
theorem koide_3p_lb :
    (40668172335 : ℝ) / 100000000
      < 3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)) := by
  have h := koide_p_lb
  linarith

/-- Bracket for `3·(m_e + m_μ + 4·√(m_e·m_μ))` from above. -/
theorem koide_3p_ub :
    3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ))
      < (40668292335 : ℝ) / 100000000 := by
  have h := koide_p_ub
  linarith

/-- Positivity of `3·(m_e + m_μ + 4·√(m_e·m_μ))`. -/
theorem koide_3p_pos :
    0 < 3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)) := by
  have h := koide_3p_lb
  linarith

/-- Lower bound on `√(3·(m_e + m_μ + 4·√(m_e·m_μ)))`.
    The inner quantity `>= 406.68172335`, and `20.1663² = 406.67809... < 406.68172`. -/
theorem sqrt_koide_3p_lb :
    (201663 : ℝ) / 10000
      < Real.sqrt (3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ))) := by
  have h_nn : (0 : ℝ) ≤ 201663 / 10000 := by norm_num
  have hpos : 0 < 3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)) := koide_3p_pos
  -- We want 201663/10000 < sqrt(inner)
  -- Equivalent to (201663/10000)² < inner
  rw [show ((201663 : ℝ) / 10000)
        = Real.sqrt (((201663 : ℝ) / 10000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt (by positivity)
  -- Need: (201663/10000)² < 3 * (...)
  -- (201663/10000)² = 40668,... / 10⁸
  have h_sq_val : ((201663 : ℝ) / 10000) ^ 2
      = (40667965569 : ℝ) / 100000000 := by norm_num
  have h_lb := koide_3p_lb
  linarith

/-- Upper bound on `√(3·(m_e + m_μ + 4·√(m_e·m_μ)))`.
    The inner `≤ 406.68293`, and `20.1665² = 406.68... > 406.68293`. -/
theorem sqrt_koide_3p_ub :
    Real.sqrt (3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)))
      < (201665 : ℝ) / 10000 := by
  have h_nn : (0 : ℝ) ≤ 201665 / 10000 := by norm_num
  have hpos : 0 ≤ 3 * (m_e + m_μ + 4 * Real.sqrt (m_e * m_μ)) :=
    koide_3p_pos.le
  rw [show ((201665 : ℝ) / 10000)
        = Real.sqrt (((201665 : ℝ) / 10000) ^ 2)
        from (Real.sqrt_sq h_nn).symm]
  apply Real.sqrt_lt_sqrt hpos
  -- Need: 3 * (...) < (201665/10000)² = 406.68617... ≈ 40668617... / 10⁸
  have h_sq_val : ((201665 : ℝ) / 10000) ^ 2
      = (40668772225 : ℝ) / 100000000 := by norm_num
  have h_ub := koide_3p_ub
  linarith

/-! ### Bracketing `koidePredictedSqrtTau`

Using

* `√m_e ∈ (0.71484, 0.71485)`,
* `√m_μ ∈ (10.27902, 10.27904)`,
* `√(3·p) ∈ (20.1663, 20.1665)`,

the sum `2·(√m_e + √m_μ) + √(3·p)` lies in `(42.15402, 42.15428)`. -/

/-- Lower bound on the predicted `√m_τ`: `> 42.15402`. -/
theorem koidePredictedSqrtTau_lb :
    (42154020 : ℝ) / 1000000 < koidePredictedSqrtTau := by
  unfold koidePredictedSqrtTau
  have h1 := sqrt_m_e_lb        -- 71484/100000 < √m_e
  have h2 := sqrt_m_μ_lb        -- 1027902/100000 < √m_μ
  have h3 := sqrt_koide_3p_lb   -- 201663/10000 < √(3p)
  -- 2·(71484/10⁵ + 1027902/10⁵) + 201663/10⁴
  -- = 2·(71484 + 1027902)/10⁵ + 201663/10⁴
  -- = 2·1099386/10⁵ + 201663/10⁴
  -- = 2198772/10⁵ + 201663/10⁴
  -- = 2198772/10⁵ + 2016630/10⁵
  -- = 4215402/10⁵ = 42154020/10⁶
  linarith

/-- Upper bound on the predicted `√m_τ`: `< 42.15428`. -/
theorem koidePredictedSqrtTau_ub :
    koidePredictedSqrtTau < (42154280 : ℝ) / 1000000 := by
  unfold koidePredictedSqrtTau
  have h1 := sqrt_m_e_ub
  have h2 := sqrt_m_μ_ub
  have h3 := sqrt_koide_3p_ub
  linarith

/-! ### Main prediction theorem: `|m_τ − koidePredictedTau| < 0.5` -/

/-- Squaring the lower/upper brackets on `koidePredictedSqrtTau`
    using monotonicity on `ℝ_{≥0}`. -/
theorem koidePredictedTau_lb :
    ((42154020 : ℝ) / 1000000) ^ 2 < koidePredictedTau := by
  unfold koidePredictedTau
  have hlb := koidePredictedSqrtTau_lb
  have hlb_nonneg : (0 : ℝ) ≤ 42154020 / 1000000 := by norm_num
  nlinarith [sq_nonneg (42154020 / 1000000 - koidePredictedSqrtTau),
             koidePredictedSqrtTau_pos, hlb]

theorem koidePredictedTau_ub :
    koidePredictedTau < ((42154280 : ℝ) / 1000000) ^ 2 := by
  unfold koidePredictedTau
  have hub := koidePredictedSqrtTau_ub
  nlinarith [sq_nonneg (koidePredictedSqrtTau - 42154280 / 1000000),
             koidePredictedSqrtTau_pos, hub]

/-- **Headline prediction theorem**: the Koide-quadratic τ-mass
    prediction `koidePredictedTau` computed from `m_e`, `m_μ`,
    and `Q = 2/3` agrees with the PDG-2024 central value
    `m_τ = 1776.86 MeV` to within **0.5 MeV**.

    By the brackets above, `koidePredictedTau ∈ (1776.961, 1776.984)`
    and so `|m_τ − koidePredictedTau| ∈ (0.101, 0.124)` — roughly
    **0.11 MeV**, well within the 0.5-MeV budget. -/
theorem tau_mass_predicted_from_koide :
    |m_τ - koidePredictedTau| < (1 : ℝ) / 2 := by
  have hlb := koidePredictedTau_lb
  have hub := koidePredictedTau_ub
  -- (42154020/10⁶)² = 1776.96114 ..., (42154280/10⁶)² = 1776.98325...
  have hlb_val : ((42154020 : ℝ) / 1000000) ^ 2
      = (1776961402160400 : ℝ) / 10 ^ 12 := by norm_num
  have hub_val : ((42154280 : ℝ) / 1000000) ^ 2
      = (1776983322318400 : ℝ) / 10 ^ 12 := by norm_num
  -- m_τ = 1776.86 = 1776860000000000 / 10¹²
  have hm_τ_val : m_τ = (1776860000000000 : ℝ) / 10 ^ 12 := by
    unfold m_τ; norm_num
  rw [abs_sub_lt_iff]
  refine ⟨?_, ?_⟩
  · -- m_τ - koidePredictedTau < 0.5
    --   m_τ - (LB) < m_τ - (LB) < 0.5?  Actually LB < koidePredictedTau
    --   means m_τ - koidePredictedTau < m_τ - LB.
    --   m_τ - LB = 1776.86 - 1776.96114 ≈ -0.10114 < 0.5. ✓
    have : m_τ - ((42154020 : ℝ) / 1000000) ^ 2 < 1 / 2 := by
      rw [hm_τ_val, hlb_val]; norm_num
    linarith
  · -- -(m_τ - koidePredictedTau) < 0.5, i.e. koidePredictedTau - m_τ < 0.5
    --   koidePredictedTau - m_τ < UB - m_τ < 0.5?
    --   UB - m_τ = 1776.98333 - 1776.86 ≈ 0.12333 < 0.5. ✓
    have : ((42154280 : ℝ) / 1000000) ^ 2 - m_τ < 1 / 2 := by
      rw [hm_τ_val, hub_val]; norm_num
    linarith

/-- **Final packaging**: existence of a Koide-quadratic τ-mass
    prediction, strictly positive, within 0.5 MeV of the PDG
    central value `m_τ = 1776.86 MeV`. -/
theorem tau_mass_predicted_from_koide_exists :
    ∃ m_τ_predicted : ℝ, 0 < m_τ_predicted ∧
      |m_τ - m_τ_predicted| < (1 : ℝ) / 2 :=
  ⟨koidePredictedTau, koidePredictedTau_pos, tau_mass_predicted_from_koide⟩

/-! ## 11. PDG numerical lepton mass hierarchy

The `electronTower_mass_hierarchy` result in `Emergence/YukawaMatrix.lean`
establishes the hierarchy in terms of the Yukawa-bridged `fermionMass`
function. Here we record the direct PDG-numeric counterpart: the observed
charged-lepton masses satisfy `m_e < m_μ < m_τ`. Companion to the bridged
statement via `MASS_HIERARCHY_PDG ≡ electronTower_mass_hierarchy` — no new
physics, just the concrete PDG inequality expected by downstream code that
unfolds `m_e, m_μ, m_τ` directly (Koide bounds, Nashira fits). -/

theorem m_e_lt_m_μ : m_e < m_μ := by
  unfold m_e m_μ; norm_num

theorem m_μ_lt_m_τ : m_μ < m_τ := by
  unfold m_μ m_τ; norm_num

/-- **PDG charged-lepton mass hierarchy** (numeric).  The three observed
    charged-lepton masses form a strictly ascending chain. -/
theorem pdg_lepton_hierarchy : m_e < m_μ ∧ m_μ < m_τ :=
  ⟨m_e_lt_m_μ, m_μ_lt_m_τ⟩

/-- Strict ordering at the level of square roots — mirrors the strict
    ordering at the mass level, useful for Koide-denominator bounds. -/
theorem sqrt_lepton_hierarchy :
    Real.sqrt m_e < Real.sqrt m_μ ∧ Real.sqrt m_μ < Real.sqrt m_τ := by
  refine ⟨?_, ?_⟩
  · exact Real.sqrt_lt_sqrt m_e_nonneg m_e_lt_m_μ
  · exact Real.sqrt_lt_sqrt m_μ_nonneg m_μ_lt_m_τ

end OmegaTheory.Emergence.KoideRelation
