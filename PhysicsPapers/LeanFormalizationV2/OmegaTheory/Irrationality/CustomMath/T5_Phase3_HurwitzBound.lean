/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_HurwitzBound

  T-5 (Roth's theorem axiom retirement) — Phase 3 sub session 136.
  Hurwitz κ=2 lower bound on Diophantine approximation.

  Single-thread hand-authored 2026-04-27 (cycle 65).

  ## What this file delivers

  Re-exports of Mathlib's Hurwitz theorem:

  1. **`T5_hurwitz_iff_irrational`** : ξ : ℝ has infinitely many
     rational approximations with `|ξ - p/q| < 1/q²` ↔ ξ is irrational.

  This is the LOWER bound on Roth's theorem (κ = 2).  Roth (1955)
  shows that for algebraic ξ, the bound `1/q²` cannot be improved to
  `1/q^(2+ε)` for any ε > 0 — this is the UPPER bound.

  Combined: for algebraic ξ, the optimal approximation exponent is
  exactly κ = 2.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.NumberTheory.DiophantineApproximation.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_HurwitzBound

/-! ## Hurwitz lower bound -/

/-- **Wave T5 session 136 — Hurwitz κ=2 lower bound** (Hurwitz 1891).

    For ξ : ℝ, infinitely many `p/q ∈ ℚ` satisfy `|ξ - p/q| < 1/q²`
    iff ξ is irrational. -/
theorem T5_hurwitz_iff_irrational (ξ : ℝ) :
    {q : ℚ | |ξ - q| < 1 / (q.den : ℝ) ^ 2}.Infinite ↔ Irrational ξ :=
  Real.infinite_rat_abs_sub_lt_one_div_den_sq_iff_irrational ξ

/-- **Wave T5 session 136 — Hurwitz forward direction**.

    Irrational ξ ⇒ infinitely many rationals approximate ξ to within 1/q². -/
theorem T5_hurwitz_irrational_implies (ξ : ℝ) (h : Irrational ξ) :
    {q : ℚ | |ξ - q| < 1 / (q.den : ℝ) ^ 2}.Infinite :=
  (T5_hurwitz_iff_irrational ξ).mpr h

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 136 — Hurwitz κ=2 attainable**.

    Two formulations:
    1. ↔: infinitely many 1/q² approximations ↔ ξ irrational.
    2. →: Irrational ξ implies the existence.

    Sub-lemma 25/N in T-5 Phase 3.  Lean-core only.

    Hurwitz (1891) is the LOWER bound on Roth's theorem (κ = 2).
    Roth (1955) is the matching UPPER bound for algebraic ξ. -/
theorem session_136_hurwitz_iff_irrational_headline :
    -- (1) iff
    (∀ (ξ : ℝ),
        {q : ℚ | |ξ - q| < 1 / (q.den : ℝ) ^ 2}.Infinite ↔ Irrational ξ)
    -- (2) forward
    ∧ (∀ (ξ : ℝ), Irrational ξ →
        {q : ℚ | |ξ - q| < 1 / (q.den : ℝ) ^ 2}.Infinite) :=
  ⟨T5_hurwitz_iff_irrational, T5_hurwitz_irrational_implies⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_HurwitzBound
