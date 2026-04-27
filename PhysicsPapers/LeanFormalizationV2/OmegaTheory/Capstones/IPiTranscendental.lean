/-
  OmegaTheory.Capstones.IPiTranscendental

  Cycle 64 extension session 104 — i·π is transcendental over ℚ.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  **`iPi_transcendental`** : `Complex.I * (Real.pi : ℂ)` is transcendental
  over ℚ.

  Proof: π is transcendental over ℚ (in ℂ, by s103). i ≠ 0 is algebraic
  (root of `X² + 1`). Therefore i·π is transcendental (cycle 64 s64
  algebraic-closure consequence).

  This is the form used in cycle 64 closure (s58) for the
  Lindemann-Weierstrass orbit construction.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendentalOverComplex
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofStructural

namespace OmegaTheory.Capstones.IPiTranscendental

open OmegaTheory.Capstones.PiTranscendentalOverComplex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofStructural

/-! ## i·π is transcendental -/

/-- **Wave T4b session 104 — i·π is transcendental over ℚ**.

    Proof: applies `iMul_isAlgebraic_of_isAlgebraic` (from s2 structural
    chain in cycle 64) in contrapositive direction.

    If i·π were algebraic, then π = (i·π) · i^{-1} = -i · (i·π) would
    also be algebraic (using -i is algebraic from i² = -1, and
    products of algebraics are algebraic).  Contradicts s103. -/
theorem iPi_transcendental :
    Transcendental ℚ (Complex.I * (Real.pi : ℂ)) := by
  intro h_alg
  -- h_alg : IsAlgebraic ℚ (i*π)
  apply pi_complex_transcendental
  -- Goal: IsAlgebraic ℚ ((Real.pi : ℂ))
  -- Use the bidirectional from s2: IsAlgebraic ℚ (i*z) ↔ IsAlgebraic ℚ z
  exact (isAlgebraic_iMul_iff (Real.pi : ℂ)).mp h_alg

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 104 — i·π transcendental**.

    `Complex.I * (Real.pi : ℂ)` is transcendental over ℚ.

    Lean-core only. -/
theorem session_104_iPi_transcendental_headline :
    Transcendental ℚ (Complex.I * (Real.pi : ℂ)) :=
  iPi_transcendental

end OmegaTheory.Capstones.IPiTranscendental
