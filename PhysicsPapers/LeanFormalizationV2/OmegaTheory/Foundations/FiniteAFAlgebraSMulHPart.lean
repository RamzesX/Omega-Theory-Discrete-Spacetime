/-
  OmegaTheory.Foundations.FiniteAFAlgebraSMulHPart

  **Lion's-Pride Phase 6.5j (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra ℝ-SCALAR MULTIPLICATION
  module-compatibility laws extended to the h_part field
  (the quaternion ℍ ≅ Fin 4 → ℝ component) — ninth step of
  multi-iteration Phase 6.5.  Mirrors the c_part-level laws from
  Phase 6.5h, demonstrating the ℝ-module structure of A_F holds
  uniformly across components.*

  ## Why this file

  Phase 6.5h (`FiniteAFAlgebraSMul.lean`, iter 110) shipped
  the ℝ-scalar action and 5 module-compatibility laws at the
  c_part field level. This file ships the parallel laws at
  the h_part field level (any `i : Fin 4`), demonstrating
  that the ℝ-module structure holds uniformly across the
  ℂ ⊕ ℍ direct-sum components.  Phase 6.5k (future) will
  extend to m3_part.

  Pointwise module-compatibility laws shipped at h_part:

  1. **Zero-scalar absorbs**: `((0:ℝ) • a).h_part i = 0`.
  2. **One-scalar identity**: `((1:ℝ) • a).h_part i = a.h_part i`.
  3. **Distrib over `+` in A_F**: `(r • (a + b)).h_part i = (r • a).h_part i + (r • b).h_part i`.
  4. **Distrib over `+` in ℝ**: `((r + s) • a).h_part i = (r • a).h_part i + (s • a).h_part i`.
  5. **Multiplicative associativity**: `((r * s) • a).h_part i = (r • (s • a)).h_part i`.

  ## What this file ships

  | Property                                                  | Theorem                                              |
  |-----------------------------------------------------------|------------------------------------------------------|
  | `FiniteAFAlgebra_zero_smul_h_part`                        | (0 • a).h_part i = 0                                 |
  | `FiniteAFAlgebra_one_smul_h_part`                         | (1 • a).h_part i = a.h_part i                        |
  | `FiniteAFAlgebra_smul_add_h_part`                         | (r • (a+b)).h_part i = (r • a).h_part i + (r • b).h_part i |
  | `FiniteAFAlgebra_add_smul_h_part`                         | ((r+s) • a).h_part i = (r • a).h_part i + (s • a).h_part i |
  | `FiniteAFAlgebra_mul_smul_h_part`                         | ((r*s) • a).h_part i = (r • (s • a)).h_part i        |
  | Headline (5-conjunct)                                     | `finite_AF_algebra_smul_h_part_report`               |

  ## Author

  Lion's-Pride dynamic /loop iteration 112 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraSMulHPart

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraSMul

/-! ## Module compatibility laws at h_part (pointwise i : Fin 4) -/

/-- **Zero-scalar absorbs at h_part**: `((0:ℝ) • a).h_part i = 0`. -/
theorem FiniteAFAlgebra_zero_smul_h_part (a : FiniteAFAlgebra) (i : Fin 4) :
    ((0 : ℝ) • a).h_part i = 0 := by
  show (0 : ℝ) * a.h_part i = 0
  ring

/-- **One-scalar identity at h_part**: `((1:ℝ) • a).h_part i = a.h_part i`. -/
theorem FiniteAFAlgebra_one_smul_h_part (a : FiniteAFAlgebra) (i : Fin 4) :
    ((1 : ℝ) • a).h_part i = a.h_part i := by
  show (1 : ℝ) * a.h_part i = a.h_part i
  ring

/-- **Distributivity of `•` over `+` in A_F at h_part**:
    `(r • (a + b)).h_part i = (r • a).h_part i + (r • b).h_part i`. -/
theorem FiniteAFAlgebra_smul_add_h_part (r : ℝ) (a b : FiniteAFAlgebra) (i : Fin 4) :
    (r • (a + b)).h_part i = (r • a).h_part i + (r • b).h_part i := by
  show r * (a.h_part i + b.h_part i) = r * a.h_part i + r * b.h_part i
  ring

/-- **Distributivity of `•` over `+` in ℝ at h_part**:
    `((r + s) • a).h_part i = (r • a).h_part i + (s • a).h_part i`. -/
theorem FiniteAFAlgebra_add_smul_h_part (r s : ℝ) (a : FiniteAFAlgebra) (i : Fin 4) :
    ((r + s) • a).h_part i = (r • a).h_part i + (s • a).h_part i := by
  show (r + s) * a.h_part i = r * a.h_part i + s * a.h_part i
  ring

/-- **Multiplicative associativity of `•` at h_part**:
    `((r * s) • a).h_part i = (r • (s • a)).h_part i`. -/
theorem FiniteAFAlgebra_mul_smul_h_part (r s : ℝ) (a : FiniteAFAlgebra) (i : Fin 4) :
    ((r * s) • a).h_part i = (r • (s • a)).h_part i := by
  show (r * s) * a.h_part i = r * (s * a.h_part i)
  ring

/-! ## Headline composite report -/

/-- **Lion's-Pride Phase 6.5j headline — finite Chamseddine-Connes
    A_F algebra ℝ-module-compatibility structural report at h_part
    (pointwise i : Fin 4).**

    For any scalars `r s : ℝ`, any elements `a b : FiniteAFAlgebra`,
    and any quaternion-component index `i : Fin 4`:

    1. **Zero-scalar absorbs at h_part**:
       `((0 : ℝ) • a).h_part i = 0`.

    2. **One-scalar identity at h_part**:
       `((1 : ℝ) • a).h_part i = a.h_part i`.

    3. **Distrib over `+` in A_F at h_part**:
       `(r • (a + b)).h_part i = (r • a).h_part i + (r • b).h_part i`.

    4. **Distrib over `+` in ℝ at h_part**:
       `((r + s) • a).h_part i = (r • a).h_part i + (s • a).h_part i`.

    5. **Multiplicative associativity at h_part**:
       `((r * s) • a).h_part i = (r • (s • a)).h_part i`. -/
theorem finite_AF_algebra_smul_h_part_report
    (r s : ℝ) (a b : FiniteAFAlgebra) (i : Fin 4) :
    ((0 : ℝ) • a).h_part i = 0 ∧
    ((1 : ℝ) • a).h_part i = a.h_part i ∧
    (r • (a + b)).h_part i = (r • a).h_part i + (r • b).h_part i ∧
    ((r + s) • a).h_part i = (r • a).h_part i + (s • a).h_part i ∧
    ((r * s) • a).h_part i = (r • (s • a)).h_part i := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_zero_smul_h_part a i
  · exact FiniteAFAlgebra_one_smul_h_part a i
  · exact FiniteAFAlgebra_smul_add_h_part r a b i
  · exact FiniteAFAlgebra_add_smul_h_part r s a i
  · exact FiniteAFAlgebra_mul_smul_h_part r s a i

end OmegaTheory.Foundations.FiniteAFAlgebraSMulHPart
