/-
  OmegaTheory.Foundations.FiniteAFAlgebraSMul

  **Lion's-Pride Phase 6.5h (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra SCALAR-MULTIPLICATION
  structure ℝ • FiniteAFAlgebra — eighth step of multi-iteration
  Phase 6.5. Defines the component-wise ℝ-scalar action on
  A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ), making A_F a real vector space (and a
  candidate for ℝ-module / ℝ-algebra promotion).*

  ## Why this file

  Phase 6.5a-f shipped:
  * additive group structure (Zero/Add/Neg)
  * multiplicative structure (One/Mul)
  * adjoint involution (`adj`)
  * multiplicative properties (comm at c_part, assoc, distrib)
  * adjoint anti-multiplicativity (`(a · b)* = b* · a*`)
  * META-CAPSTONE composing 5 phases

  This file ships the SMul (scalar mul) instance ℝ → FiniteAFAlgebra
  → FiniteAFAlgebra, completing the ℝ-module compatibility laws
  needed before A_F can be promoted to a `Module ℝ FiniteAFAlgebra`
  in a future iteration.

  Component-wise scalar multiplication:

  * **ℂ component** — `r • (a, b) = (r·a, r·b)` on ℝ × ℝ.
  * **ℍ component** — `(r • q)(i) = r · q(i)` on Fin 4 → ℝ.
  * **M_3(ℂ) component** — `(r • A)_{ij} = r • A_{ij}` pointwise.

  Module compatibility laws shipped at the c_part field level:

  1. **Zero-scalar absorbs**: `(0 • a).c_part = (0, 0)`.
  2. **One-scalar identity**: `(1 • a).c_part = a.c_part`.
  3. **Distrib over `+` in A_F**: `(r • (a + b)).c_part = (r • a).c_part + (r • b).c_part`.
  4. **Distrib over `+` in ℝ**: `((r + s) • a).c_part = (r • a).c_part + (s • a).c_part`.
  5. **Multiplicative associativity**: `((r · s) • a).c_part = (r • (s • a)).c_part`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `SMul ℝ FiniteAFAlgebra` instance                     | (def — component-wise ℝ-scalar action)               |
  | `FiniteAFAlgebra_zero_smul_c_part`                    | (0 • a).c_part = (0, 0)                              |
  | `FiniteAFAlgebra_one_smul_c_part`                     | (1 • a).c_part = a.c_part                            |
  | `FiniteAFAlgebra_smul_add_c_part`                     | (r • (a+b)).c_part = (r • a).c_part + (r • b).c_part |
  | `FiniteAFAlgebra_add_smul_c_part`                     | ((r+s) • a).c_part = (r • a).c_part + (s • a).c_part |
  | `FiniteAFAlgebra_mul_smul_c_part`                     | ((r*s) • a).c_part = (r • (s • a)).c_part            |
  | Headline (5-conjunct)                                 | `finite_AF_algebra_smul_report`                      |

  ## Author

  Lion's-Pride dynamic /loop iteration 110 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraSMul

open OmegaTheory.Foundations.FiniteAFAlgebra

/-! ## 1. Scalar multiplication ℝ on A_F -/

/-- **ℝ-scalar multiplication on A_F**: component-wise. -/
instance : SMul ℝ FiniteAFAlgebra where
  smul r a := {
    c_part := (r * a.c_part.1, r * a.c_part.2)
    h_part := fun i => r * a.h_part i
    m3_part := fun i j => (r * (a.m3_part i j).1, r * (a.m3_part i j).2)
  }

/-! ## 2. Module compatibility laws at c_part -/

/-- **Zero-scalar absorbs at c_part**: `(0 • a).c_part = (0, 0)`. -/
theorem FiniteAFAlgebra_zero_smul_c_part (a : FiniteAFAlgebra) :
    ((0 : ℝ) • a).c_part = (0, 0) := by
  show ((0 : ℝ) * a.c_part.1, (0 : ℝ) * a.c_part.2) = (0, 0)
  ext
  · show (0 : ℝ) * a.c_part.1 = 0
    ring
  · show (0 : ℝ) * a.c_part.2 = 0
    ring

/-- **One-scalar identity at c_part**: `(1 • a).c_part = a.c_part`. -/
theorem FiniteAFAlgebra_one_smul_c_part (a : FiniteAFAlgebra) :
    ((1 : ℝ) • a).c_part = a.c_part := by
  show ((1 : ℝ) * a.c_part.1, (1 : ℝ) * a.c_part.2) = a.c_part
  ext
  · show (1 : ℝ) * a.c_part.1 = a.c_part.1
    ring
  · show (1 : ℝ) * a.c_part.2 = a.c_part.2
    ring

/-- **Distributivity of `•` over `+` in A_F at c_part**:
    `(r • (a + b)).c_part = (r • a).c_part + (r • b).c_part`. -/
theorem FiniteAFAlgebra_smul_add_c_part (r : ℝ) (a b : FiniteAFAlgebra) :
    (r • (a + b)).c_part = (r • a).c_part + (r • b).c_part := by
  show (r * (a.c_part.1 + b.c_part.1), r * (a.c_part.2 + b.c_part.2)) =
       (r * a.c_part.1, r * a.c_part.2) + (r * b.c_part.1, r * b.c_part.2)
  ext
  · simp only [Prod.fst_add]; ring
  · simp only [Prod.snd_add]; ring

/-- **Distributivity of `•` over `+` in ℝ at c_part**:
    `((r + s) • a).c_part = (r • a).c_part + (s • a).c_part`. -/
theorem FiniteAFAlgebra_add_smul_c_part (r s : ℝ) (a : FiniteAFAlgebra) :
    ((r + s) • a).c_part = (r • a).c_part + (s • a).c_part := by
  show ((r + s) * a.c_part.1, (r + s) * a.c_part.2) =
       (r * a.c_part.1, r * a.c_part.2) + (s * a.c_part.1, s * a.c_part.2)
  ext
  · simp only [Prod.fst_add]; ring
  · simp only [Prod.snd_add]; ring

/-- **Multiplicative associativity of `•` at c_part**:
    `((r · s) • a).c_part = (r • (s • a)).c_part`. -/
theorem FiniteAFAlgebra_mul_smul_c_part (r s : ℝ) (a : FiniteAFAlgebra) :
    ((r * s) • a).c_part = (r • (s • a)).c_part := by
  show ((r * s) * a.c_part.1, (r * s) * a.c_part.2) =
       (r * (s * a.c_part.1), r * (s * a.c_part.2))
  ext
  · show (r * s) * a.c_part.1 = r * (s * a.c_part.1)
    ring
  · show (r * s) * a.c_part.2 = r * (s * a.c_part.2)
    ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.5h headline — finite Chamseddine-Connes
    A_F algebra ℝ-module-compatibility structural report at c_part.**

    For any scalars `r s : ℝ` and any elements `a b : FiniteAFAlgebra`:

    1. **Zero-scalar absorbs at c_part**:
       `((0 : ℝ) • a).c_part = (0, 0)`.

    2. **One-scalar identity at c_part**:
       `((1 : ℝ) • a).c_part = a.c_part`.

    3. **Distrib over `+` in A_F at c_part**:
       `(r • (a + b)).c_part = (r • a).c_part + (r • b).c_part`.

    4. **Distrib over `+` in ℝ at c_part**:
       `((r + s) • a).c_part = (r • a).c_part + (s • a).c_part`.

    5. **Multiplicative associativity at c_part**:
       `((r * s) • a).c_part = (r • (s • a)).c_part`. -/
theorem finite_AF_algebra_smul_report (r s : ℝ) (a b : FiniteAFAlgebra) :
    ((0 : ℝ) • a).c_part = (0, 0) ∧
    ((1 : ℝ) • a).c_part = a.c_part ∧
    (r • (a + b)).c_part = (r • a).c_part + (r • b).c_part ∧
    ((r + s) • a).c_part = (r • a).c_part + (s • a).c_part ∧
    ((r * s) • a).c_part = (r • (s • a)).c_part := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_zero_smul_c_part a
  · exact FiniteAFAlgebra_one_smul_c_part a
  · exact FiniteAFAlgebra_smul_add_c_part r a b
  · exact FiniteAFAlgebra_add_smul_c_part r s a
  · exact FiniteAFAlgebra_mul_smul_c_part r s a

end OmegaTheory.Foundations.FiniteAFAlgebraSMul
