/-
  OmegaTheory.Emergence.SU3JacobiDefs

  Shared definitions for the rational + √3 decomposition of the Gell-Mann
  structure constants `su3f`. Split out of `SU3JacobiFull` so that both
  `SU3JacobiFull` (native_decide-free public-facing theorem) and
  `SU3JacobiViaMatrix` (matrix-Lie-algebra derivation of the same identities)
  can share the schemas `su3f_rat`, `su3f_sqrt3`, `jacobiRatSum`,
  `jacobiSqrt3Sum`, and the decomposition `su3f_decomp`.

  Original defs and `su3f_decomp` are due to Almach² (γ And), April 17, 2026.
  Split into this defs-only module in cycle-49 P3t to enable matrix-route
  derivation of `jacobi_rat_zero` / `jacobi_sqrt3_zero` without `native_decide`.

  No sorry, no new axioms.
-/

import OmegaTheory.Emergence.ErrorGaugeSU3
import OmegaTheory.Emergence.SU3JacobiHelper
import Mathlib.Tactic

namespace OmegaTheory.Emergence.SU3JacobiDefs

open OmegaTheory.Emergence.ErrorGaugeSU3
open OmegaTheory.Emergence.SU3JacobiHelper
open OmegaTheory.Foundations

/-! ## §1. Rational + √3 decomposition of `su3f` -/

/-- Rational part of the Gell-Mann structure constants. -/
def su3f_rat : Fin 8 → Fin 8 → Fin 8 → ℚ :=
  fun i j k =>
    if i = 0 ∧ j = 1 ∧ k = 2 then 1
    else if i = 1 ∧ j = 2 ∧ k = 0 then 1
    else if i = 2 ∧ j = 0 ∧ k = 1 then 1
    else if i = 1 ∧ j = 0 ∧ k = 2 then -1
    else if i = 0 ∧ j = 2 ∧ k = 1 then -1
    else if i = 2 ∧ j = 1 ∧ k = 0 then -1
    else if i = 0 ∧ j = 3 ∧ k = 6 then 1/2
    else if i = 3 ∧ j = 6 ∧ k = 0 then 1/2
    else if i = 6 ∧ j = 0 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 0 ∧ k = 6 then -(1/2)
    else if i = 0 ∧ j = 6 ∧ k = 3 then -(1/2)
    else if i = 6 ∧ j = 3 ∧ k = 0 then -(1/2)
    else if i = 0 ∧ j = 4 ∧ k = 5 then -(1/2)
    else if i = 4 ∧ j = 5 ∧ k = 0 then -(1/2)
    else if i = 5 ∧ j = 0 ∧ k = 4 then -(1/2)
    else if i = 4 ∧ j = 0 ∧ k = 5 then 1/2
    else if i = 0 ∧ j = 5 ∧ k = 4 then 1/2
    else if i = 5 ∧ j = 4 ∧ k = 0 then 1/2
    else if i = 1 ∧ j = 3 ∧ k = 5 then 1/2
    else if i = 3 ∧ j = 5 ∧ k = 1 then 1/2
    else if i = 5 ∧ j = 1 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 1 ∧ k = 5 then -(1/2)
    else if i = 1 ∧ j = 5 ∧ k = 3 then -(1/2)
    else if i = 5 ∧ j = 3 ∧ k = 1 then -(1/2)
    else if i = 1 ∧ j = 4 ∧ k = 6 then 1/2
    else if i = 4 ∧ j = 6 ∧ k = 1 then 1/2
    else if i = 6 ∧ j = 1 ∧ k = 4 then 1/2
    else if i = 4 ∧ j = 1 ∧ k = 6 then -(1/2)
    else if i = 1 ∧ j = 6 ∧ k = 4 then -(1/2)
    else if i = 6 ∧ j = 4 ∧ k = 1 then -(1/2)
    else if i = 2 ∧ j = 3 ∧ k = 4 then 1/2
    else if i = 3 ∧ j = 4 ∧ k = 2 then 1/2
    else if i = 4 ∧ j = 2 ∧ k = 3 then 1/2
    else if i = 3 ∧ j = 2 ∧ k = 4 then -(1/2)
    else if i = 2 ∧ j = 4 ∧ k = 3 then -(1/2)
    else if i = 4 ∧ j = 3 ∧ k = 2 then -(1/2)
    else if i = 2 ∧ j = 5 ∧ k = 6 then -(1/2)
    else if i = 5 ∧ j = 6 ∧ k = 2 then -(1/2)
    else if i = 6 ∧ j = 2 ∧ k = 5 then -(1/2)
    else if i = 5 ∧ j = 2 ∧ k = 6 then 1/2
    else if i = 2 ∧ j = 6 ∧ k = 5 then 1/2
    else if i = 6 ∧ j = 5 ∧ k = 2 then 1/2
    else 0

/-- √3-coefficient part of the Gell-Mann structure constants.
    Nonzero exactly on permutations of {3,4,7} and {5,6,7} (the λ₈
    mixings), with value ±1/2. -/
def su3f_sqrt3 : Fin 8 → Fin 8 → Fin 8 → ℚ :=
  fun i j k =>
    if i = 3 ∧ j = 4 ∧ k = 7 then 1/2
    else if i = 4 ∧ j = 7 ∧ k = 3 then 1/2
    else if i = 7 ∧ j = 3 ∧ k = 4 then 1/2
    else if i = 4 ∧ j = 3 ∧ k = 7 then -(1/2)
    else if i = 3 ∧ j = 7 ∧ k = 4 then -(1/2)
    else if i = 7 ∧ j = 4 ∧ k = 3 then -(1/2)
    else if i = 5 ∧ j = 6 ∧ k = 7 then 1/2
    else if i = 6 ∧ j = 7 ∧ k = 5 then 1/2
    else if i = 7 ∧ j = 5 ∧ k = 6 then 1/2
    else if i = 6 ∧ j = 5 ∧ k = 7 then -(1/2)
    else if i = 5 ∧ j = 7 ∧ k = 6 then -(1/2)
    else if i = 7 ∧ j = 6 ∧ k = 5 then -(1/2)
    else 0

-- 512 cases (8^3) at depth-3 ifs; ring normalisation adds overhead.
set_option maxHeartbeats 1000000 in
/-- `su3f = ↑su3f_rat + √3 · ↑su3f_sqrt3` pointwise in `ℝ`. -/
theorem su3f_decomp (i j k : Fin 8) :
    su3f i j k = (↑(su3f_rat i j k) : ℝ) +
                 Real.sqrt 3 * (↑(su3f_sqrt3 i j k) : ℝ) := by
  unfold su3f su3f_rat su3f_sqrt3
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    simp_all <;> push_cast <;> ring

/-! ## §2. Jacobi sums over ℚ. -/

/-- Rational-component Jacobi sum; absorbs the `3·(√3)² = 3` cross-term. -/
def jacobiRatSum (a b c d : Fin 8) : ℚ :=
  ∑ e : Fin 8, (su3f_rat a b e * su3f_rat e c d +
                su3f_rat b c e * su3f_rat e a d +
                su3f_rat c a e * su3f_rat e b d +
                3 * (su3f_sqrt3 a b e * su3f_sqrt3 e c d +
                     su3f_sqrt3 b c e * su3f_sqrt3 e a d +
                     su3f_sqrt3 c a e * su3f_sqrt3 e b d))

/-- √3-component Jacobi sum. -/
def jacobiSqrt3Sum (a b c d : Fin 8) : ℚ :=
  ∑ e : Fin 8, (su3f_rat a b e * su3f_sqrt3 e c d +
                su3f_sqrt3 a b e * su3f_rat e c d +
                su3f_rat b c e * su3f_sqrt3 e a d +
                su3f_sqrt3 b c e * su3f_rat e a d +
                su3f_rat c a e * su3f_sqrt3 e b d +
                su3f_sqrt3 c a e * su3f_rat e b d)

end OmegaTheory.Emergence.SU3JacobiDefs
