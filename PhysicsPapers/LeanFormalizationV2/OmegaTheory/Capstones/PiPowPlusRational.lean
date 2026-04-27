/-
  OmegaTheory.Capstones.PiPowPlusRational

  Cycle 64 extension session 105 — π^n + q is transcendental.

  Single-thread hand-authored 2026-04-27.

  ## What this file delivers

  Composing s62 (π^n transcendental) with s64 (π + algebraic transcendental):

  **`pi_pow_plus_rat_transcendental`** : for any `n ≥ 1` and `q : ℚ`,
  `π^n + q` is transcendental over ℚ.

  Combined with `IsAlgebraic.add` closure under sum, this gives the
  full pattern: `α₁ + α₂ + ... + π^n + q + ...` is transcendental
  whenever the algebraic part doesn't cancel with the π^n.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Capstones.PiTranscendenceConsequences
import OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences

namespace OmegaTheory.Capstones.PiPowPlusRational

open OmegaTheory.Capstones.PiTranscendenceConsequences
open OmegaTheory.Capstones.PiTranscendenceAlgebraicConsequences
open OmegaTheory.Capstones.PiTranscendenceAxiomRetirementFinal

/-! ## π^n + algebraic transcendental -/

/-- **Wave T4b session 105 — π^n + α transcendental (n ≥ 1, α algebraic)**.

    For any `n ≥ 1` and any algebraic `α`, the value `π^n + α` is
    transcendental over ℚ.

    Proof: if π^n + α were algebraic, then π^n = (π^n + α) - α would
    be algebraic (sum/sub of algebraic). But π^n is transcendental
    (s62). Contradiction. -/
theorem pi_pow_plus_algebraic_transcendental
    (n : ℕ) (hn : 1 ≤ n)
    {α : ℝ} (h_alg : IsAlgebraic ℚ α) :
    Transcendental ℚ ((Real.pi : ℝ) ^ n + α) := by
  intro h_pi_pow_alg
  apply pi_pow_n_transcendental n hn
  have : (Real.pi : ℝ) ^ n = ((Real.pi : ℝ) ^ n + α) - α := by ring
  rw [this]
  exact h_pi_pow_alg.sub h_alg

/-! ## π^n + q transcendental for q : ℚ -/

/-- **Wave T4b session 105 — π^n + q transcendental (n ≥ 1, q : ℚ)**. -/
theorem pi_pow_plus_rat_transcendental (n : ℕ) (hn : 1 ≤ n) (q : ℚ) :
    Transcendental ℚ ((Real.pi : ℝ) ^ n + (q : ℝ)) :=
  pi_pow_plus_algebraic_transcendental n hn (isAlgebraic_algebraMap q)

/-! ## π² + q -/

/-- **Wave T4b session 105 — π² + q transcendental for q : ℚ**. -/
theorem pi_sq_plus_rat_transcendental (q : ℚ) :
    Transcendental ℚ ((Real.pi : ℝ) ^ 2 + (q : ℝ)) :=
  pi_pow_plus_rat_transcendental 2 (by omega) q

/-! ## π · α + β transcendental -/

/-- **Wave T4b session 105 — π · α + β transcendental (α ≠ 0 algebraic, β algebraic)**.

    For nonzero algebraic α and any algebraic β, the value `π · α + β`
    is transcendental. -/
theorem pi_mul_plus_alg_transcendental
    {α β : ℝ}
    (hα_alg : IsAlgebraic ℚ α) (hα_ne : α ≠ 0)
    (hβ_alg : IsAlgebraic ℚ β) :
    Transcendental ℚ ((Real.pi : ℝ) * α + β) := by
  intro h
  apply pi_mul_algebraic_transcendental hα_alg hα_ne
  -- Goal: IsAlgebraic ℚ (Real.pi * α)
  have : (Real.pi : ℝ) * α = ((Real.pi : ℝ) * α + β) - β := by ring
  rw [this]
  exact h.sub hβ_alg

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 105 — π linear-combination consequences**.

    Three useful generalizations:
    1. π^n + α transcendental (n ≥ 1, α algebraic)
    2. π^n + q transcendental (n ≥ 1, q : ℚ)
    3. π·α + β transcendental (α ≠ 0 algebraic, β algebraic)

    Lean-core only. -/
theorem session_105_pi_pow_plus_rational_headline :
    -- (1) π^n + α
    (∀ n : ℕ, 1 ≤ n →
      ∀ α : ℝ, IsAlgebraic ℚ α →
        Transcendental ℚ ((Real.pi : ℝ) ^ n + α))
    -- (2) π^n + q
    ∧ (∀ n : ℕ, 1 ≤ n → ∀ q : ℚ,
        Transcendental ℚ ((Real.pi : ℝ) ^ n + (q : ℝ)))
    -- (3) π·α + β
    ∧ (∀ α β : ℝ, IsAlgebraic ℚ α → α ≠ 0 → IsAlgebraic ℚ β →
        Transcendental ℚ ((Real.pi : ℝ) * α + β)) := by
  refine ⟨?_, ?_, ?_⟩
  · intros n hn α h_alg; exact pi_pow_plus_algebraic_transcendental n hn h_alg
  · exact pi_pow_plus_rat_transcendental
  · intros α β hα hα_ne hβ; exact pi_mul_plus_alg_transcendental hα hα_ne hβ

end OmegaTheory.Capstones.PiPowPlusRational
