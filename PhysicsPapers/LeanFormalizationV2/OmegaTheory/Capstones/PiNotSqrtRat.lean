/-
  OmegaTheory.Capstones.PiNotSqrtRat

  Cycle 64 extension session 101 — π is not the square root of any rational.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Direct consequence of `Real.pi_transcendental` (cycle 64 retirement):

  **`pi_not_sqrt_of_rat`** : there is no `q : ℚ` such that `Real.pi = Real.sqrt q`.

  Proof: if π = √q for rational q, then π² = q (rational), contradicting
  that π² is transcendental (a corollary of π transcendental).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceConsequences
import Mathlib.Analysis.SpecialFunctions.Pow.NNReal

namespace OmegaTheory.Capstones.PiNotSqrtRat

open OmegaTheory.Capstones.PiTranscendenceConsequences

/-! ## π is not a rational square root -/

/-- **Wave T4b session 101 — π is NOT the square root of any rational**.

    Proof: if `π = √q` for some rational `q`, then `q ≥ 0` (since √
    in ℝ returns non-negative) and `π² = q`. But π² is transcendental
    (s62 `pi_sq_transcendental`), and rationals are algebraic, so `π² ≠
    rational`. Contradiction. -/
theorem pi_not_sqrt_of_rat :
    ¬ ∃ q : ℚ, (Real.pi : ℝ) = Real.sqrt (q : ℝ) := by
  intro ⟨q, hq⟩
  -- π = √q → π² = q (when q ≥ 0)
  -- For π² to equal rational q, we'd need π² to be algebraic (= IsAlgebraic)
  -- But π² is transcendental — direct contradiction.
  apply pi_sq_transcendental
  -- Goal: IsAlgebraic ℚ (Real.pi ^ 2)
  -- π² = q (rational), and rationals are algebraic
  have h_pi_sq_eq : (Real.pi : ℝ) ^ 2 = (q : ℝ) := by
    rw [sq, hq]
    -- (√q)² = q (when q ≥ 0)
    -- Need to show (√q)·(√q) = q, but only if q ≥ 0
    -- Actually π > 0, so π² > 0, so q must equal π² > 0 ≥ 0
    have h_pi_pos : (0 : ℝ) < (Real.pi : ℝ) := Real.pi_pos
    have h_q_eq : Real.sqrt (q : ℝ) = Real.pi := hq.symm
    have h_q_nn : (0 : ℝ) ≤ (q : ℝ) := by
      have : (0 : ℝ) ≤ Real.sqrt (q : ℝ) := Real.sqrt_nonneg _
      rw [h_q_eq] at this
      -- but we need q ≥ 0, not π ≥ 0. Use that Real.sqrt q = π > 0 → q ≥ 0
      -- Actually if q < 0, sqrt q = 0 ≠ π. So q ≥ 0.
      by_contra h_q_neg
      push_neg at h_q_neg
      have : Real.sqrt (q : ℝ) = 0 := Real.sqrt_eq_zero_of_nonpos (le_of_lt h_q_neg)
      rw [this] at h_q_eq
      linarith
    rw [Real.mul_self_sqrt h_q_nn]
  rw [h_pi_sq_eq]
  exact_mod_cast isAlgebraic_algebraMap (q : ℚ)

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 101 — π not √q for q : ℚ**.

    Direct consequence of `pi_transcendental_unconditional` via π²
    transcendence (s62). Lean-core only. -/
theorem session_101_pi_not_sqrt_rat_headline :
    ¬ ∃ q : ℚ, (Real.pi : ℝ) = Real.sqrt (q : ℝ) :=
  pi_not_sqrt_of_rat

end OmegaTheory.Capstones.PiNotSqrtRat
