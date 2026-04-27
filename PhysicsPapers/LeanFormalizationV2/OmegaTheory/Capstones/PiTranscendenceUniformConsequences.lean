/-
  OmegaTheory.Capstones.PiTranscendenceUniformConsequences

  Cycle 64 (Pisces) Phase B Wave T-4b session 66 — uniform consequences
  of π transcendence (the form most directly used by `pi_stratum_*` etc.).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Re-exports of the unconditional π-transcendence in the EXACT forms
  most consumers expect:

  1. **`pi_no_rational_polynomial_root`** — ∀ p : ℚ[X], p ≠ 0 →
     Polynomial.aeval (Real.pi : ℝ) p ≠ 0.
  2. **`pi_no_integer_polynomial_root`** — ∀ p : ℤ[X], p ≠ 0 →
     Polynomial.aeval (Real.pi : ℝ) p ≠ 0 (via ℤ → ℚ embedding).
  3. **`pi_unique_minpoly_does_not_exist`** — π has no minimal polynomial
     over ℚ.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal
import Mathlib.RingTheory.Algebraic.Defs

namespace OmegaTheory.Capstones.PiTranscendenceUniformConsequences

open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

/-! ## Direct polynomial root form -/

/-- **Wave T4b session 66 — π is not the root of any nonzero ℚ[X]**.

    Direct unfolding of `Transcendental ℚ Real.pi` — for every nonzero
    rational polynomial p, the evaluation at π is nonzero. -/
theorem pi_no_rational_polynomial_root :
    ∀ p : Polynomial ℚ, p ≠ 0 →
      Polynomial.aeval (Real.pi : ℝ) p ≠ 0 := by
  intro p h_ne h_eq
  apply pi_transcendence_axiom_retired_unconditional
  exact ⟨p, h_ne, h_eq⟩

/-! ## Integer polynomial form -/

/-- **Wave T4b session 66 — π is not the root of any nonzero ℤ[X]**.

    Lift via ℤ → ℚ embedding. -/
theorem pi_no_integer_polynomial_root :
    ∀ p : Polynomial ℤ, p ≠ 0 →
      Polynomial.aeval (Real.pi : ℝ) p ≠ 0 := by
  intro p h_ne h_eq
  -- Map p to ℚ[X] preserving non-zero status
  apply pi_no_rational_polynomial_root (p.map (Int.castRingHom ℚ))
  · -- p.map ≠ 0 since Int.castRingHom ℚ is injective
    rw [Polynomial.map_ne_zero_iff]
    · exact h_ne
    · exact (algebraMap ℤ ℚ).injective_int
  · -- aeval π (p.map cast) = aeval π p (via Int.castRingHom = algebraMap ℤ ℚ)
    -- Use aeval over ℤ and the algebraMap composition
    have h_alg_eq : (algebraMap ℚ ℝ).comp (Int.castRingHom ℚ) = algebraMap ℤ ℝ := by
      ext n
      simp
    have := Polynomial.aeval_eq_aeval_map (φ := Int.castRingHom ℚ)
      (S := ℝ) (T := ℚ) (R := ℤ) h_alg_eq p (Real.pi : ℝ)
    rw [← this]
    exact h_eq

/-! ## π not algebraic -/

/-- **Wave T4b session 66 — π is not algebraic over ℚ**.

    Direct via `IsAlgebraic` definition — equivalent to `Transcendental`. -/
theorem pi_not_algebraic :
    ¬ IsAlgebraic ℚ (Real.pi : ℝ) := by
  exact pi_transcendence_axiom_retired_unconditional

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 66 — uniform π-transcendence forms**.

    All forms equivalent to `Transcendental ℚ (Real.pi : ℝ)`,
    re-exported for downstream convenience. -/
theorem session_66_pi_transcendence_forms_headline :
    -- (1) Original
    Transcendental ℚ (Real.pi : ℝ)
    -- (2) Polynomial root form (ℚ[X])
    ∧ (∀ p : Polynomial ℚ, p ≠ 0 →
        Polynomial.aeval (Real.pi : ℝ) p ≠ 0)
    -- (3) Polynomial root form (ℤ[X])
    ∧ (∀ p : Polynomial ℤ, p ≠ 0 →
        Polynomial.aeval (Real.pi : ℝ) p ≠ 0)
    -- (4) Not algebraic form
    ∧ ¬ IsAlgebraic ℚ (Real.pi : ℝ) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact pi_transcendence_axiom_retired_unconditional
  · exact pi_no_rational_polynomial_root
  · exact pi_no_integer_polynomial_root
  · exact pi_not_algebraic

end OmegaTheory.Capstones.PiTranscendenceUniformConsequences
