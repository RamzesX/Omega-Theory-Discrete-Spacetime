/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 29 — esymm of
  f.aroots ℂ is rational for any nonzero f : ℤ[X].

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Proves: for any nonzero `f : Polynomial ℤ` and any `k : ℕ`:

      `∃ q : ℚ, (f.aroots ℂ).esymm k = (q : ℂ)`

  via s17's `aroots_esymm_D_scaled_is_integer_all`:
  - `D · (f.aroots ℂ).esymm k ∈ ℤ` (call it M)
  - So `(f.aroots ℂ).esymm k = M / D` (in ℂ)
  - With D ≠ 0 (since f ≠ 0 → leadingCoeff ≠ 0), this is rational.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPolynomialEvalScaledIntSum

/-! ## esymm of aroots is rational -/

/-- **Wave T4b session 29 — esymm of aroots is rational**.

    For any nonzero `f : Polynomial ℤ` and any `k : ℕ`, the value
    `(f.aroots ℂ).esymm k` is a rational number (cast to ℂ).

    Proof: by s17, `D · esymm k = (M : ℂ)` for some integer M (where
    D = leadingCoeff).  Since D ≠ 0, esymm k = M/D, which is the
    rational number `(M : ℚ) / (D : ℚ)`. -/
theorem aroots_esymm_is_rational
    (f : Polynomial ℤ) (h_ne : f ≠ 0) (k : ℕ) :
    ∃ q : ℚ, (f.aroots ℂ).esymm k = (q : ℂ) := by
  obtain ⟨M, hM⟩ := aroots_esymm_D_scaled_is_integer_all f h_ne k
  -- hM : (f.leadingCoeff : ℂ) * (f.aroots ℂ).esymm k = (M : ℂ)
  have h_D_ne : f.leadingCoeff ≠ 0 := Polynomial.leadingCoeff_ne_zero.mpr h_ne
  have h_D_ne_C : (f.leadingCoeff : ℂ) ≠ 0 := by exact_mod_cast h_D_ne
  -- esymm k = M / D in ℂ
  refine ⟨(M : ℚ) / (f.leadingCoeff : ℚ), ?_⟩
  -- Goal: (f.aroots ℂ).esymm k = ((M : ℚ) / (f.leadingCoeff : ℚ) : ℂ)
  have h_esymm_eq : (f.aroots ℂ).esymm k = (M : ℂ) / (f.leadingCoeff : ℂ) := by
    rw [eq_div_iff h_D_ne_C]
    linear_combination hM
  rw [h_esymm_eq]
  push_cast
  rfl

/-! ## Headline -/

/-- **HEADLINE — Wave T4b session 29**.  esymm of aroots is rational
    for any nonzero integer polynomial.  This is the rationality piece
    that, combined with the fundamental theorem of symmetric polynomials,
    will give "any symmetric polynomial in f.aroots is rational" — a key
    cycle-64 ingredient. -/
theorem session_29_aroots_esymm_rational_headline
    (f : Polynomial ℤ) (h_ne : f ≠ 0) (k : ℕ) :
    ∃ q : ℚ, (f.aroots ℂ).esymm k = (q : ℂ) :=
  aroots_esymm_is_rational f h_ne k

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational
