/-
  OmegaTheory.Capstones.PiSqrt2LinearIndependence

  Cycle 64 (Pisces) Phase B Wave T-4b session 65 — π and √2 are
  ℚ-linearly independent.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  **`pi_sqrt2_linearly_independent`**: for any rationals q, r,
  if `q * π + r * √2 = 0` (with at least one nonzero), then a
  contradiction with π transcendental.

  Proof outline:
  - If q = 0 and r ≠ 0, then r·√2 = 0 → √2 = 0 (false).
  - If q ≠ 0 and r = 0, then q·π = 0 → π = 0 (false, π > 0).
  - If both nonzero, then π = -r·√2/q is algebraic (since √2 algebraic,
    -r/q rational, product/sum of algebraics is algebraic).
    Contradicts π transcendental.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Analysis.SpecialFunctions.Pow.NNReal
import OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

namespace OmegaTheory.Capstones.PiSqrt2LinearIndependence

open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

/-! ## √2 is algebraic over ℚ -/

/-- **√2 is algebraic over ℚ** — root of `X² - 2`.

    This uses Mathlib's `Real.sqrt 2` and shows it's algebraic via the
    fact that `Real.sqrt 2 ^ 2 = 2`. -/
theorem sqrt2_isAlgebraic : IsAlgebraic ℚ (Real.sqrt 2) := by
  -- Use IsAlgebraic.of_pow: if (sqrt 2)^2 is algebraic, then sqrt 2 is.
  -- (sqrt 2)^2 = 2 (rational, hence algebraic).
  have h_sq : (Real.sqrt 2) ^ 2 = (2 : ℝ) := by
    rw [sq]; exact Real.mul_self_sqrt (by norm_num : (0 : ℝ) ≤ 2)
  apply IsAlgebraic.of_pow (n := 2) (by omega : (1 : ℕ) ≤ 2)
  rw [h_sq]
  -- Goal: IsAlgebraic ℚ (2 : ℝ)
  exact_mod_cast isAlgebraic_algebraMap (2 : ℚ)

/-! ## π and √2 linear independence over ℚ -/

/-- **Wave T4b session 65 — π and √2 are ℚ-linearly independent**.

    For any q, r : ℚ with `q * π + r * √2 = 0`, both q = 0 and r = 0. -/
theorem pi_sqrt2_linearly_independent (q r : ℚ)
    (h_eq : (q : ℝ) * (Real.pi : ℝ) + (r : ℝ) * Real.sqrt 2 = 0) :
    q = 0 ∧ r = 0 := by
  by_contra h_not_both
  push_neg at h_not_both
  -- Case 1: q = 0
  by_cases hq : q = 0
  · -- Then r ≠ 0 (from h_not_both)
    have hr : r ≠ 0 := h_not_both hq
    rw [hq, Rat.cast_zero, zero_mul, zero_add] at h_eq
    -- h_eq : (r : ℝ) * Real.sqrt 2 = 0
    have hr_C : (r : ℝ) ≠ 0 := by exact_mod_cast hr
    have hsqrt2_ne : Real.sqrt 2 ≠ 0 := by
      have : (0 : ℝ) < Real.sqrt 2 := Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 2)
      linarith
    exact (mul_ne_zero hr_C hsqrt2_ne) h_eq
  · -- q ≠ 0
    -- π = -r/q · √2  (an algebraic combination)
    -- → π is algebraic, contradicting transcendental
    apply pi_transcendence_axiom_retired_unconditional
    -- Goal: IsAlgebraic ℚ (Real.pi : ℝ)
    have hq_C : (q : ℝ) ≠ 0 := by exact_mod_cast hq
    -- From q·π + r·√2 = 0: q·π = -r·√2, so π = -r·√2/q = (-r/q)·√2
    have h_pi_eq : (Real.pi : ℝ) = -((r : ℝ) / (q : ℝ)) * Real.sqrt 2 := by
      field_simp at h_eq
      field_simp
      linarith [h_eq]
    rw [h_pi_eq]
    -- Goal: IsAlgebraic ℚ (-(r/q) * √2)
    -- This is the product of an algebraic (-r/q rational) and an algebraic (√2)
    -- IsAlgebraic.mul gives the product
    apply IsAlgebraic.mul
    · -- IsAlgebraic ℚ (-(r/q)) — rational, hence algebraic
      have h_eq_rat : (-((r : ℝ) / (q : ℝ))) = (((-(r / q) : ℚ)) : ℝ) := by
        push_cast
        ring
      rw [h_eq_rat]
      exact isAlgebraic_algebraMap (-(r / q))
    · exact sqrt2_isAlgebraic

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 65 — π and √2 ℚ-linear independence**.

    The two principal substrate-irrationals (π for heaviest channel, √2
    for lightest channel in the 4-irrational hierarchy) are linearly
    independent over ℚ.  This is a foundational fact for the
    Pi-Hunch hierarchy and the substrate-irrationals duality. -/
theorem session_65_pi_sqrt2_lin_indep_headline :
    ∀ q r : ℚ, (q : ℝ) * (Real.pi : ℝ) + (r : ℝ) * Real.sqrt 2 = 0 →
      q = 0 ∧ r = 0 :=
  pi_sqrt2_linearly_independent

end OmegaTheory.Capstones.PiSqrt2LinearIndependence
