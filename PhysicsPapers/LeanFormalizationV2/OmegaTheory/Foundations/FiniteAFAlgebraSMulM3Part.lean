/-
  OmegaTheory.Foundations.FiniteAFAlgebraSMulM3Part

  **Lion's-Pride Phase 6.5k (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra ℝ-SCALAR MULTIPLICATION
  module-compatibility laws extended to the m3_part field
  (the M_3(ℂ) ≅ Matrix (Fin 3) (Fin 3) (ℝ × ℝ) component) —
  tenth step of multi-iteration Phase 6.5.  Mirrors the c_part-level
  laws from Phase 6.5h and h_part-level laws from Phase 6.5j, now
  proved at the matrix-entry level (i j : Fin 3) over the
  3 × 3 complex-pair matrix.

  This completes the full ℝ-module-compatibility coverage across
  all 3 direct-sum components of A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ).*

  ## Why this file

  Phase 6.5h (`FiniteAFAlgebraSMul.lean`, iter 110) shipped the
  ℝ-scalar action and 5 module-compatibility laws at c_part.
  Phase 6.5j (`FiniteAFAlgebraSMulHPart.lean`, iter 112) extended
  to h_part. This file ships the parallel laws at m3_part —
  matrix-entry level (i j : Fin 3) over (ℝ × ℝ) entries —
  completing the ℝ-module compatibility coverage across all
  3 components of A_F.

  Pointwise module-compatibility laws shipped at m3_part:

  1. **Zero-scalar absorbs**: `((0:ℝ) • a).m3_part i j = (0, 0)`.
  2. **One-scalar identity**: `((1:ℝ) • a).m3_part i j = a.m3_part i j`.
  3. **Distrib over `+` in A_F**: `(r • (a + b)).m3_part i j = (r • a).m3_part i j + (r • b).m3_part i j`.
  4. **Distrib over `+` in ℝ**: `((r + s) • a).m3_part i j = (r • a).m3_part i j + (s • a).m3_part i j`.
  5. **Multiplicative associativity**: `((r * s) • a).m3_part i j = (r • (s • a)).m3_part i j`.

  ## What this file ships

  | Property                                                  | Theorem                                              |
  |-----------------------------------------------------------|------------------------------------------------------|
  | `FiniteAFAlgebra_zero_smul_m3_part`                       | (0 • a).m3_part i j = (0, 0)                         |
  | `FiniteAFAlgebra_one_smul_m3_part`                        | (1 • a).m3_part i j = a.m3_part i j                  |
  | `FiniteAFAlgebra_smul_add_m3_part`                        | (r • (a+b)).m3_part i j = (r • a).m3_part i j + (r • b).m3_part i j |
  | `FiniteAFAlgebra_add_smul_m3_part`                        | ((r+s) • a).m3_part i j = (r • a).m3_part i j + (s • a).m3_part i j |
  | `FiniteAFAlgebra_mul_smul_m3_part`                        | ((r*s) • a).m3_part i j = (r • (s • a)).m3_part i j  |
  | Headline (5-conjunct)                                     | `finite_AF_algebra_smul_m3_part_report`              |

  ## Author

  Lion's-Pride dynamic /loop iteration 113 (2026-05-06).
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

namespace OmegaTheory.Foundations.FiniteAFAlgebraSMulM3Part

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraSMul

/-! ## Module compatibility laws at m3_part (pointwise i j : Fin 3) -/

/-- **Zero-scalar absorbs at m3_part**:
    `((0 : ℝ) • a).m3_part i j = (0, 0)`. -/
theorem FiniteAFAlgebra_zero_smul_m3_part (a : FiniteAFAlgebra) (i j : Fin 3) :
    ((0 : ℝ) • a).m3_part i j = (0, 0) := by
  show ((0 : ℝ) * (a.m3_part i j).1, (0 : ℝ) * (a.m3_part i j).2) = (0, 0)
  ext
  · show (0 : ℝ) * (a.m3_part i j).1 = 0
    ring
  · show (0 : ℝ) * (a.m3_part i j).2 = 0
    ring

/-- **One-scalar identity at m3_part**:
    `((1 : ℝ) • a).m3_part i j = a.m3_part i j`. -/
theorem FiniteAFAlgebra_one_smul_m3_part (a : FiniteAFAlgebra) (i j : Fin 3) :
    ((1 : ℝ) • a).m3_part i j = a.m3_part i j := by
  show ((1 : ℝ) * (a.m3_part i j).1, (1 : ℝ) * (a.m3_part i j).2) = a.m3_part i j
  ext
  · show (1 : ℝ) * (a.m3_part i j).1 = (a.m3_part i j).1
    ring
  · show (1 : ℝ) * (a.m3_part i j).2 = (a.m3_part i j).2
    ring

/-- **Distributivity of `•` over `+` in A_F at m3_part**:
    `(r • (a + b)).m3_part i j = (r • a).m3_part i j + (r • b).m3_part i j`. -/
theorem FiniteAFAlgebra_smul_add_m3_part (r : ℝ) (a b : FiniteAFAlgebra) (i j : Fin 3) :
    (r • (a + b)).m3_part i j = (r • a).m3_part i j + (r • b).m3_part i j := by
  show (r * ((a.m3_part i j).1 + (b.m3_part i j).1),
        r * ((a.m3_part i j).2 + (b.m3_part i j).2)) =
       (r * (a.m3_part i j).1, r * (a.m3_part i j).2) +
       (r * (b.m3_part i j).1, r * (b.m3_part i j).2)
  ext
  · simp only [Prod.fst_add]; ring
  · simp only [Prod.snd_add]; ring

/-- **Distributivity of `•` over `+` in ℝ at m3_part**:
    `((r + s) • a).m3_part i j = (r • a).m3_part i j + (s • a).m3_part i j`. -/
theorem FiniteAFAlgebra_add_smul_m3_part (r s : ℝ) (a : FiniteAFAlgebra) (i j : Fin 3) :
    ((r + s) • a).m3_part i j = (r • a).m3_part i j + (s • a).m3_part i j := by
  show ((r + s) * (a.m3_part i j).1, (r + s) * (a.m3_part i j).2) =
       (r * (a.m3_part i j).1, r * (a.m3_part i j).2) +
       (s * (a.m3_part i j).1, s * (a.m3_part i j).2)
  ext
  · simp only [Prod.fst_add]; ring
  · simp only [Prod.snd_add]; ring

/-- **Multiplicative associativity of `•` at m3_part**:
    `((r * s) • a).m3_part i j = (r • (s • a)).m3_part i j`. -/
theorem FiniteAFAlgebra_mul_smul_m3_part (r s : ℝ) (a : FiniteAFAlgebra) (i j : Fin 3) :
    ((r * s) • a).m3_part i j = (r • (s • a)).m3_part i j := by
  show ((r * s) * (a.m3_part i j).1, (r * s) * (a.m3_part i j).2) =
       (r * (s * (a.m3_part i j).1), r * (s * (a.m3_part i j).2))
  ext
  · show (r * s) * (a.m3_part i j).1 = r * (s * (a.m3_part i j).1)
    ring
  · show (r * s) * (a.m3_part i j).2 = r * (s * (a.m3_part i j).2)
    ring

/-! ## Headline composite report -/

/-- **Lion's-Pride Phase 6.5k headline — finite Chamseddine-Connes
    A_F algebra ℝ-module-compatibility structural report at m3_part
    (pointwise i j : Fin 3).**

    For any scalars `r s : ℝ`, any elements `a b : FiniteAFAlgebra`,
    and any matrix-row-column indices `i j : Fin 3`:

    1. **Zero-scalar absorbs at m3_part**:
       `((0 : ℝ) • a).m3_part i j = (0, 0)`.

    2. **One-scalar identity at m3_part**:
       `((1 : ℝ) • a).m3_part i j = a.m3_part i j`.

    3. **Distrib over `+` in A_F at m3_part**:
       `(r • (a + b)).m3_part i j = (r • a).m3_part i j + (r • b).m3_part i j`.

    4. **Distrib over `+` in ℝ at m3_part**:
       `((r + s) • a).m3_part i j = (r • a).m3_part i j + (s • a).m3_part i j`.

    5. **Multiplicative associativity at m3_part**:
       `((r * s) • a).m3_part i j = (r • (s • a)).m3_part i j`. -/
theorem finite_AF_algebra_smul_m3_part_report
    (r s : ℝ) (a b : FiniteAFAlgebra) (i j : Fin 3) :
    ((0 : ℝ) • a).m3_part i j = (0, 0) ∧
    ((1 : ℝ) • a).m3_part i j = a.m3_part i j ∧
    (r • (a + b)).m3_part i j = (r • a).m3_part i j + (r • b).m3_part i j ∧
    ((r + s) • a).m3_part i j = (r • a).m3_part i j + (s • a).m3_part i j ∧
    ((r * s) • a).m3_part i j = (r • (s • a)).m3_part i j := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_zero_smul_m3_part a i j
  · exact FiniteAFAlgebra_one_smul_m3_part a i j
  · exact FiniteAFAlgebra_smul_add_m3_part r a b i j
  · exact FiniteAFAlgebra_add_smul_m3_part r s a i j
  · exact FiniteAFAlgebra_mul_smul_m3_part r s a i j

end OmegaTheory.Foundations.FiniteAFAlgebraSMulM3Part
