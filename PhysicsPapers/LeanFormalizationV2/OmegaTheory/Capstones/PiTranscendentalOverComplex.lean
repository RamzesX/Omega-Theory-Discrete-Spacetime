/-
  OmegaTheory.Capstones.PiTranscendentalOverComplex

  Cycle 64 extension session 103 — π viewed in ℂ is transcendental over ℚ.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  **`pi_complex_transcendental`** : `Real.pi : ℂ` (the complex
  embedding of π) is transcendental over ℚ.

  Direct from `pi_transcendental_unconditional` + algebra-map transport.

  This is exactly the statement needed by the Lindemann-Weierstrass
  bridge in cycle 64 (where the algebraic chain step uses
  `IsAlgebraic ℚ ((Real.pi : ℂ))`).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal
import Mathlib.RingTheory.Algebraic.Basic

namespace OmegaTheory.Capstones.PiTranscendentalOverComplex

open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

/-! ## π as a complex number is transcendental -/

/-- **Wave T4b session 103 — π : ℂ is transcendental over ℚ**.

    The complex embedding of π (i.e., `(Real.pi : ℂ) = algebraMap ℝ ℂ Real.pi`)
    is transcendental over ℚ.

    Proof: π is transcendental over ℚ in ℝ (cycle 64 retirement).
    The algebra-map ℝ → ℂ is injective. By transport along this map,
    π : ℂ is also transcendental.

    The proof uses Mathlib's
    `Polynomial.aeval_algebraMap_apply` to factor aeval through the
    algebra-map, plus the chain-of-injectivity for transcendence
    transport. -/
theorem pi_complex_transcendental :
    Transcendental ℚ ((Real.pi : ℂ)) := by
  intro h_alg
  -- h_alg : IsAlgebraic ℚ ((Real.pi : ℂ))
  -- Goal: contradiction
  apply pi_transcendence_axiom_retired_unconditional
  -- Goal: IsAlgebraic ℚ (Real.pi : ℝ)
  -- From h_alg: ∃ p : ℚ[X], p ≠ 0 ∧ aeval (π : ℂ) p = 0
  -- Want: ∃ q : ℚ[X], q ≠ 0 ∧ aeval (π : ℝ) q = 0
  -- Take q = p. The aeval evaluations are related by complex casting.
  obtain ⟨p, h_ne, h_zero⟩ := h_alg
  refine ⟨p, h_ne, ?_⟩
  -- aeval (π : ℝ) p = 0
  -- We have aeval (π : ℂ) p = 0
  -- Apply complex cast: ((Real.pi : ℂ) = (algebraMap ℝ ℂ) Real.pi)
  -- via Polynomial.aeval_algebraMap_apply
  have h_cast : ((Real.pi : ℂ)) = (algebraMap ℝ ℂ) Real.pi := by
    simp [Complex.coe_algebraMap]
  rw [h_cast] at h_zero
  rw [Polynomial.aeval_algebraMap_apply ℂ Real.pi p] at h_zero
  -- h_zero : (algebraMap ℝ ℂ) (aeval Real.pi p) = 0
  -- algebraMap ℝ ℂ is injective, so aeval Real.pi p = 0
  have h_inj : Function.Injective (algebraMap ℝ ℂ) :=
    (algebraMap ℝ ℂ).injective
  have h_zero_C : (algebraMap ℝ ℂ) ((Polynomial.aeval Real.pi) p) =
                  (algebraMap ℝ ℂ) 0 := by
    rw [h_zero]; simp
  exact h_inj h_zero_C

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 103 — π in ℂ transcendental**.

    `(Real.pi : ℂ)` is transcendental over ℚ. Lean-core only. -/
theorem session_103_pi_complex_transcendental_headline :
    Transcendental ℚ ((Real.pi : ℂ)) :=
  pi_complex_transcendental

end OmegaTheory.Capstones.PiTranscendentalOverComplex
