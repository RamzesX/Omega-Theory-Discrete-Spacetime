/-
  OmegaTheory.Foundations.FiniteAFAlgebraSMulMulHPart

  **Lion's-Pride Phase 6.7 (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra SMUL-MUL INTERACTION at
  h_part — proves the ℝ-bilinearity of the quaternion multiplication
  with respect to ℝ-scalar multiplication: `((r • a) * b).h_part i =
  (r • (a * b)).h_part i` (left ℝ-linearity) and `(a * (r • b)).h_part
  i = (r • (a * b)).h_part i` (right ℝ-linearity), at every component
  index `i : Fin 4`. Companion to Phase 6.5x (c_part bilinearity)
  for the quaternionic ℍ ≅ ℝ⁴ middle factor of A_F.*

  ## Why this file

  Phase 6.5x (iter 133) shipped the ℝ-bilinearity of A_F multiplication
  at the c_part field (the ℂ-component). For an ℝ-algebra structure
  on the FULL A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ), we need parallel bilinearity at
  each of the three component fields.

  This file ships the h_part (quaternionic) component. The quaternion
  product `quaternionMulFn` is defined componentwise via Hamilton's
  formulas:

    (a · b)_0 := a_0·b_0 - a_1·b_1 - a_2·b_2 - a_3·b_3
    (a · b)_1 := a_0·b_1 + a_1·b_0 + a_2·b_3 - a_3·b_2
    (a · b)_2 := a_0·b_2 - a_1·b_3 + a_2·b_0 + a_3·b_1
    (a · b)_3 := a_0·b_3 + a_1·b_2 - a_2·b_1 + a_3·b_0

  Each component is ℝ-bilinear in (a, b), so scaling either argument
  by `r ∈ ℝ` distributes through.

  The remaining m3_part (M_3(ℂ) matrix-product) component will be
  shipped in a future phase (it requires `Finset.mul_sum` manipulation
  on the matrix-multiplication double sum).

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `smul_mul_h_part`                                     | `((r • a) * b).h_part i = (r • (a * b)).h_part i`     |
  | `mul_smul_h_part`                                     | `(a * (r • b)).h_part i = (r • (a * b)).h_part i`     |
  | Headline (2-conjunct)                                 | `finite_AF_algebra_smul_mul_h_part_report`           |

  ## Author

  Lion's-Pride dynamic /loop iteration 139 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMulHPart
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraSMulMulHPart

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMulHPart

/-! ## 1. Left ℝ-linearity of quaternion product at h_part -/

/-- **Left ℝ-linearity of quaternion product at h_part**:
    `((r • a) * b).h_part i = (r • (a * b)).h_part i` for every
    component `i : Fin 4`.

    Proof: by direct computation through `quaternionMulFn`. The
    h_part of `(r • a)` at index `j` is `r * a.h_part j`, so the
    h_part of `(r • a) * b` at index `i` is the standard quaternion
    product formula evaluated with `r * a.h_part j` in place of
    `a.h_part j`. By distributing `r` out of every product term, the
    result equals `r * quaternionMulFn a.h_part b.h_part i`, which
    is `(r • (a * b)).h_part i`. The `split_ifs + ring` tactic
    chain closes each of the 4 cases. -/
theorem smul_mul_h_part (r : ℝ) (a b : FiniteAFAlgebra) (i : Fin 4) :
    ((r • a) * b).h_part i = (r • (a * b)).h_part i := by
  show quaternionMulFn (fun j => r * a.h_part j) b.h_part i =
       r * quaternionMulFn a.h_part b.h_part i
  unfold quaternionMulFn
  split_ifs <;> ring

/-! ## 2. Right ℝ-linearity of quaternion product at h_part -/

/-- **Right ℝ-linearity of quaternion product at h_part**:
    `(a * (r • b)).h_part i = (r • (a * b)).h_part i` for every
    component `i : Fin 4`.

    Proof: parallel to `smul_mul_h_part` with `r` on the right
    argument; ring distributes `r` through each cross-product term. -/
theorem mul_smul_h_part (r : ℝ) (a b : FiniteAFAlgebra) (i : Fin 4) :
    (a * (r • b)).h_part i = (r • (a * b)).h_part i := by
  show quaternionMulFn a.h_part (fun j => r * b.h_part j) i =
       r * quaternionMulFn a.h_part b.h_part i
  unfold quaternionMulFn
  split_ifs <;> ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.7 headline — finite Chamseddine-Connes
    A_F algebra SMul-Mul interaction structural report at h_part.**

    For any real scalar `r : ℝ`, any elements `a b : FiniteAFAlgebra`,
    and any component index `i : Fin 4`:

    1. **Left ℝ-linearity of quaternion product**:
       `((r • a) * b).h_part i = (r • (a * b)).h_part i`.

    2. **Right ℝ-linearity of quaternion product**:
       `(a * (r • b)).h_part i = (r • (a * b)).h_part i`. -/
theorem finite_AF_algebra_smul_mul_h_part_report
    (r : ℝ) (a b : FiniteAFAlgebra) (i : Fin 4) :
    ((r • a) * b).h_part i = (r • (a * b)).h_part i ∧
    (a * (r • b)).h_part i = (r • (a * b)).h_part i := by
  refine ⟨?_, ?_⟩
  · exact smul_mul_h_part r a b i
  · exact mul_smul_h_part r a b i

end OmegaTheory.Foundations.FiniteAFAlgebraSMulMulHPart
