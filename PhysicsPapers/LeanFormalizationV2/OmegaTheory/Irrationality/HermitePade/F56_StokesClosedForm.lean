/-
  OmegaTheory.Irrationality.HermitePade.F56_StokesClosedForm

  F56 — Stokes multiplier closed form (Attack 20).

  Informal statement
  ------------------
  In the Hermite-Padé attack on π-opacity, Attack 20 identifies the
  Stokes multiplier of the Kummer confluent hypergeometric

      ₁F₁(1/3 ; 4/3 ; z)

  as `S = 2π / 3`.  The closed-form computation reduces to a single
  Γ-arithmetic identity, which is the only content we need to record
  in Lean:

      Γ(4/3)
    ─────────────────  =  1/3.
      Γ(1/3) · Γ(1)

  Proof sketch
  ------------
  By the functional equation `Γ(x + 1) = x · Γ(x)` with `x = 1/3`,

      Γ(4/3) = Γ(1 + 1/3) = (1/3) · Γ(1/3).

  Combined with `Γ(1) = 1` and the positivity `Γ(1/3) > 0` (so the
  denominator is nonzero), the identity collapses to `1/3` by field
  arithmetic.

  Dependencies: Mathlib v4.29 (`Real.Gamma_add_one`, `Real.Gamma_one`,
  `Real.Gamma_pos_of_pos`).  No sorries, no axioms beyond Mathlib.
-/

import Mathlib.Analysis.SpecialFunctions.Gamma.Basic

namespace OmegaTheory.Irrationality.HermitePade

open Real

/--
**F56 core — the Γ-ratio behind the Attack 20 Stokes multiplier.**

The Γ-arithmetic identity `Γ(4/3) / (Γ(1/3) · Γ(1)) = 1/3`, which is the
closed-form heart of the discovery that the Stokes multiplier of
`₁F₁(1/3 ; 4/3 ; z)` equals `2π/3`.

Proof.  Apply `Real.Gamma_add_one` at `x = 1/3` to rewrite `Γ(4/3)` as
`(1/3) · Γ(1/3)`, use `Real.Gamma_one = 1`, and cancel `Γ(1/3)` (nonzero
by `Real.Gamma_pos_of_pos`).
-/
theorem stokes_gamma_ratio :
    Real.Gamma (4 / 3) / (Real.Gamma (1 / 3) * Real.Gamma 1) = 1 / 3 := by
  -- Rewrite 4/3 as 1/3 + 1 so the functional equation applies.
  have h43 : (4 : ℝ) / 3 = 1 / 3 + 1 := by ring
  -- 1/3 is positive, hence nonzero — needed for `Gamma_add_one`.
  have h13_pos : (0 : ℝ) < 1 / 3 := by norm_num
  have h13_ne : (1 : ℝ) / 3 ≠ 0 := ne_of_gt h13_pos
  -- Γ(1/3) > 0, hence nonzero — needed to cancel in the division.
  have hΓ13_pos : 0 < Real.Gamma (1 / 3) := Real.Gamma_pos_of_pos h13_pos
  have hΓ13_ne : Real.Gamma (1 / 3) ≠ 0 := ne_of_gt hΓ13_pos
  -- Γ(4/3) = (1/3) · Γ(1/3).
  have hstep : Real.Gamma (4 / 3) = (1 / 3) * Real.Gamma (1 / 3) := by
    rw [h43]; exact Real.Gamma_add_one h13_ne
  -- Assemble: substitute Γ(4/3), Γ(1), then cancel Γ(1/3).
  rw [hstep, Real.Gamma_one]
  field_simp

end OmegaTheory.Irrationality.HermitePade
