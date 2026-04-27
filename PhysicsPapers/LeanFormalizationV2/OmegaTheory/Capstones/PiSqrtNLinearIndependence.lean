/-
  OmegaTheory.Capstones.PiSqrtNLinearIndependence

  Cycle 64 extension session 102 — π and √n are ℚ-linearly independent
  for any positive integer n.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Generalization of s65 (π + √2 lin indep) to:

  **`pi_sqrtN_linearly_independent_of_pos`** : for any `n : ℕ` with
  `0 < n`, π and √n are ℚ-linearly independent.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences
import Mathlib.Analysis.SpecialFunctions.Pow.NNReal

namespace OmegaTheory.Capstones.PiSqrtNLinearIndependence

open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal
open OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences

/-! ## √n is algebraic over ℚ for any n : ℕ -/

/-- **Wave T4b session 102 — √n is algebraic over ℚ**.

    For any natural number n, `Real.sqrt n` is algebraic over ℚ
    (it's a root of `X² - n`).

    Proof: `(√n)² = n` (in ℝ, n ≥ 0). Apply `IsAlgebraic.of_pow`. -/
theorem sqrtN_isAlgebraic (n : ℕ) :
    IsAlgebraic ℚ (Real.sqrt (n : ℝ)) := by
  have h_sq : (Real.sqrt (n : ℝ)) ^ 2 = (n : ℝ) := by
    rw [sq]; exact Real.mul_self_sqrt (by exact_mod_cast Nat.zero_le n)
  apply IsAlgebraic.of_pow (n := 2) (by omega : (1 : ℕ) ≤ 2)
  rw [h_sq]
  exact_mod_cast isAlgebraic_algebraMap (n : ℚ)

/-! ## π and √n linearly independent (n positive) -/

/-- **Wave T4b session 102 — π and √n ℚ-linearly independent for n > 0**.

    For any q, r : ℚ with `q * π + r * √n = 0` and `n > 0`, both q = 0 and r = 0.

    Proof: case-split on q.
    - If q = 0: r·√n = 0 → r = 0 (since √n > 0 for n > 0).
    - If q ≠ 0: π = -(r/q)·√n algebraic, contradicting transcendence. -/
theorem pi_sqrtN_linearly_independent_of_pos (n : ℕ) (h_n_pos : 0 < n) (q r : ℚ)
    (h_eq : (q : ℝ) * (Real.pi : ℝ) + (r : ℝ) * Real.sqrt (n : ℝ) = 0) :
    q = 0 ∧ r = 0 := by
  by_contra h_not_both
  push_neg at h_not_both
  by_cases hq : q = 0
  · -- Then r ≠ 0
    have hr : r ≠ 0 := h_not_both hq
    rw [hq, Rat.cast_zero, zero_mul, zero_add] at h_eq
    have hr_C : (r : ℝ) ≠ 0 := by exact_mod_cast hr
    have hsqrtN_ne : Real.sqrt (n : ℝ) ≠ 0 := by
      have h_pos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast h_n_pos
      have : (0 : ℝ) < Real.sqrt (n : ℝ) := Real.sqrt_pos.mpr h_pos
      linarith
    exact (mul_ne_zero hr_C hsqrtN_ne) h_eq
  · -- q ≠ 0
    apply pi_transcendence_axiom_retired_unconditional
    have hq_C : (q : ℝ) ≠ 0 := by exact_mod_cast hq
    have h_pi_eq : (Real.pi : ℝ) = -((r : ℝ) / (q : ℝ)) * Real.sqrt (n : ℝ) := by
      field_simp at h_eq
      field_simp
      linarith [h_eq]
    rw [h_pi_eq]
    apply IsAlgebraic.mul
    · -- IsAlgebraic ℚ (-(r/q))
      have h_eq_rat : (-((r : ℝ) / (q : ℝ))) = (((-(r / q) : ℚ)) : ℝ) := by
        push_cast
        ring
      rw [h_eq_rat]
      exact isAlgebraic_algebraMap (-(r / q))
    · exact sqrtN_isAlgebraic n

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 102 — π and √n lin-indep for n > 0**.

    Generalizes s65 to all positive integers n. Lean-core only. -/
theorem session_102_pi_sqrtN_lin_indep_headline :
    ∀ n : ℕ, 0 < n → ∀ q r : ℚ,
      (q : ℝ) * (Real.pi : ℝ) + (r : ℝ) * Real.sqrt (n : ℝ) = 0 →
      q = 0 ∧ r = 0 :=
  pi_sqrtN_linearly_independent_of_pos

end OmegaTheory.Capstones.PiSqrtNLinearIndependence
