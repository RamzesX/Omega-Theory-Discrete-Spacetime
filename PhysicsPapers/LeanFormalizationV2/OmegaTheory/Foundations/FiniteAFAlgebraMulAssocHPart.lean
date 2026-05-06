/-
  OmegaTheory.Foundations.FiniteAFAlgebraMulAssocHPart

  **Lion's-Pride Phase 6.9 (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra HAMILTON QUATERNION
  ASSOCIATIVITY at h_part — proves
  `((a * b) * c).h_part i = (a * (b * c)).h_part i` for every component
  index `i : Fin 4`. This is the famous Hamilton-1843 result that
  the quaternion product (defined by `quaternionMulFn`) is associative.
  Companion to Phase 6.5d c_part associativity.*

  ## Why this file

  The quaternions `ℍ ≅ ℝ⁴` form a non-commutative associative division
  algebra. Hamilton's 1843 product formulas:

    (a · b)_0 := a_0·b_0 - a_1·b_1 - a_2·b_2 - a_3·b_3
    (a · b)_1 := a_0·b_1 + a_1·b_0 + a_2·b_3 - a_3·b_2
    (a · b)_2 := a_0·b_2 - a_1·b_3 + a_2·b_0 + a_3·b_1
    (a · b)_3 := a_0·b_3 + a_1·b_2 - a_2·b_1 + a_3·b_0

  satisfy the associativity axiom `(a · b) · c = a · (b · c)`. This
  file ships that fact for the substrate-encoded `quaternionMulFn`
  via `split_ifs + ring`: the polynomial identity holds at every
  component index `i : Fin 4`.

  Phase 6.5d (iter 106) shipped commutativity + associativity at
  c_part (where the multiplication is just complex multiplication).
  This Phase 6.9 ships associativity at h_part (where the
  multiplication is non-commutative but still associative). The
  m3_part associativity (3×3 matrix multiplication) would follow the
  standard Mathlib `Matrix.mul_assoc`, but is deferred to a future
  iteration since it requires Finset.sum manipulation similar to
  Phase 6.7b.

  ## What this file ships

  | Property                                          | Theorem                                              |
  |---------------------------------------------------|------------------------------------------------------|
  | `mul_assoc_h_part`                                | `((a * b) * c).h_part i = (a * (b * c)).h_part i`     |
  | Headline (1-conjunct)                             | `finite_AF_algebra_mul_assoc_h_part_report`          |

  ## Author

  Lion's-Pride dynamic /loop iteration 144 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false
set_option linter.style.maxHeartbeats false
-- Quaternion associativity polynomial identity at h_part requires
-- expanded simp+ring across 4 components × 12 variables;
-- raise maxHeartbeats to accommodate the algebraic burden.
set_option maxHeartbeats 800000

namespace OmegaTheory.Foundations.FiniteAFAlgebraMulAssocHPart

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul

/-! ## 1. Hamilton quaternion associativity at h_part -/

/-- **Hamilton quaternion associativity at h_part**:
    `((a * b) * c).h_part i = (a * (b * c)).h_part i` for every
    component `i : Fin 4`.

    Proof: by direct unfolding of `quaternionMulFn` (the Hamilton
    componentwise product), case analysis on `i ∈ {0, 1, 2, 3}` via
    `split_ifs`, and closing each polynomial identity by `ring`.

    The 4 cases correspond to the 4 quaternion components, each of
    which is a polynomial identity in 12 variables (a₀..a₃, b₀..b₃,
    c₀..c₃). Hamilton's 1843 multiplication is associative because
    these polynomials match by ring algebra. -/
theorem mul_assoc_h_part (a b c : FiniteAFAlgebra) (i : Fin 4) :
    ((a * b) * c).h_part i = (a * (b * c)).h_part i := by
  show quaternionMulFn (quaternionMulFn a.h_part b.h_part) c.h_part i =
       quaternionMulFn a.h_part (quaternionMulFn b.h_part c.h_part) i
  fin_cases i <;> (simp [quaternionMulFn]) <;> ring

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 6.9 headline — finite Chamseddine-Connes
    A_F algebra Hamilton quaternion associativity structural report
    at h_part.**

    For any elements `a b c : FiniteAFAlgebra` and any component
    index `i : Fin 4`:

    1. **Hamilton quaternion associativity at h_part**:
       `((a * b) * c).h_part i = (a * (b * c)).h_part i`. -/
theorem finite_AF_algebra_mul_assoc_h_part_report
    (a b c : FiniteAFAlgebra) (i : Fin 4) :
    ((a * b) * c).h_part i = (a * (b * c)).h_part i :=
  mul_assoc_h_part a b c i

end OmegaTheory.Foundations.FiniteAFAlgebraMulAssocHPart
