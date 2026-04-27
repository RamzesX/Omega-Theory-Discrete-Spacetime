/-
  OmegaTheory.Capstones.PiTranscendenceConsequences

  Cycle 64 (Pisces) Phase B Wave T-4b session 62 — concrete consequences
  of the unconditional π-transcendence.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Demonstrates the IMMEDIATE power of `pi_transcendental_unconditional`:

  1. **`pi_pow_n_not_rational`** — for any `n ≥ 1`, π^n ∉ ℚ.
  2. **`pi_pow_n_irrational`** — for any `n ≥ 1`, π^n is irrational.
  3. **`pi_pow_n_transcendental`** — for any `n ≥ 1`, π^n is transcendental.

  All three follow directly from π being transcendental: if π^n = q
  rational, then π is a root of (X^n - q) ∈ ℚ[X], hence algebraic,
  contradicting transcendence.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal
import Mathlib.RingTheory.Algebraic.Basic

namespace OmegaTheory.Capstones.PiTranscendenceConsequences

open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

/-! ## π^n is transcendental for any positive n -/

/-- **Wave T4b session 62 — π^n is transcendental for n ≥ 1**.

    Proof: π^n is the image of π under the algebraic operation x ↦ x^n,
    so if π^n were algebraic, then by composing with the inverse algebraic
    map x ↦ x^(1/n), π would be algebraic.  Contradiction with
    `pi_transcendental_unconditional`. -/
theorem pi_pow_n_transcendental (n : ℕ) (hn : 1 ≤ n) :
    Transcendental ℚ ((Real.pi : ℝ) ^ n) := by
  intro h_alg
  -- h_alg : IsAlgebraic ℚ (π^n)
  -- We want: π is algebraic, then derive contradiction with pi_transcendental
  -- π is the n-th root of π^n. If π^n is algebraic, π is algebraic over ℚ(π^n),
  -- and ℚ(π^n) is algebraic over ℚ, so π is algebraic over ℚ.
  apply pi_transcendence_axiom_retired_unconditional
  -- Goal: IsAlgebraic ℚ (Real.pi : ℝ)
  -- π is a root of X^n - (π^n), where (π^n) is algebraic.
  -- More precisely: extract a polynomial p ∈ ℚ[X] with aeval (π^n) p = 0.
  -- Then π is algebraic via composition with x ↦ x^n.
  -- Use IsAlgebraic.pow_iff or similar.
  -- Simpler approach: π^n = π * π^{n-1}, and IsAlgebraic.pow takes the n-th power.
  -- Actually, the cleanest approach: π^n algebraic + π real → π algebraic via
  -- the polynomial p(X) = X^n - (π^n)_rational_coefficient_form, but this needs
  -- π^n in a specific algebraic shape.
  -- Use Mathlib's IsAlgebraic.of_pow / isAlgebraic_iff_isIntegral.
  -- For ℝ which is a Q-algebra, IsAlgebraic ℚ (x^n) → IsAlgebraic ℚ x
  -- when n ≥ 1 by standard algebraic-extension reasoning.
  -- Formal Lean version: use `IsAlgebraic.of_pow`.
  have := IsAlgebraic.of_pow (n := n) hn h_alg
  exact this

/-! ## π^n ∉ ℚ for n ≥ 1 -/

/-- **Wave T4b session 62 — π^n ∉ ℚ for n ≥ 1**.

    Proof: any rational number is algebraic over ℚ. -/
theorem pi_pow_n_not_rational (n : ℕ) (hn : 1 ≤ n) :
    ¬ ∃ q : ℚ, (Real.pi : ℝ) ^ n = (q : ℝ) := by
  intro ⟨q, hq⟩
  apply pi_pow_n_transcendental n hn
  -- Goal: IsAlgebraic ℚ (π^n)
  rw [hq]
  -- Goal: IsAlgebraic ℚ ((q : ℝ))
  exact isAlgebraic_algebraMap q

/-! ## π^n is irrational for n ≥ 1 -/

/-- **Wave T4b session 62 — π^n is irrational for n ≥ 1**.

    Direct via `Transcendental.irrational`. -/
theorem pi_pow_n_irrational (n : ℕ) (hn : 1 ≤ n) :
    Irrational ((Real.pi : ℝ) ^ n) :=
  (pi_pow_n_transcendental n hn).irrational

/-! ## Specialization: π² is transcendental + irrational -/

/-- **Wave T4b session 62 — π² is transcendental**. -/
theorem pi_sq_transcendental : Transcendental ℚ ((Real.pi : ℝ) ^ 2) :=
  pi_pow_n_transcendental 2 (by omega)

/-- **Wave T4b session 62 — π² is irrational**. -/
theorem pi_sq_irrational : Irrational ((Real.pi : ℝ) ^ 2) :=
  pi_pow_n_irrational 2 (by omega)

/-- **Wave T4b session 62 — π² ∉ ℚ**. -/
theorem pi_sq_not_rational : ¬ ∃ q : ℚ, (Real.pi : ℝ) ^ 2 = (q : ℝ) :=
  pi_pow_n_not_rational 2 (by omega)

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 62 — concrete consequences**.

    π^n is transcendental, irrational, ∉ ℚ for any n ≥ 1.  All
    three follow from `pi_transcendental_unconditional` (cycle 64
    closure) via Mathlib's `IsAlgebraic.of_pow` + `isAlgebraic_algebraMap`. -/
theorem session_62_pi_pow_consequences_headline :
    -- (1) π^2 transcendental
    Transcendental ℚ ((Real.pi : ℝ) ^ 2)
    -- (2) π^2 irrational
    ∧ Irrational ((Real.pi : ℝ) ^ 2)
    -- (3) π^2 ∉ ℚ
    ∧ (¬ ∃ q : ℚ, (Real.pi : ℝ) ^ 2 = (q : ℝ))
    -- (4) π^3 transcendental (showcasing arbitrary n)
    ∧ Transcendental ℚ ((Real.pi : ℝ) ^ 3) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact pi_sq_transcendental
  · exact pi_sq_irrational
  · exact pi_sq_not_rational
  · exact pi_pow_n_transcendental 3 (by omega)

end OmegaTheory.Capstones.PiTranscendenceConsequences
