/-
  OmegaTheory.Foundations.FiniteAFAlgebraAdjoint

  **Lion's-Pride Phase 6.5c (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra ADJOINT involution
  structure — third step of multi-iteration Phase 6.5. Defines
  component-wise adjoint (involution `*`) on A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ)
  via complex-conjugation on ℂ ≅ ℝ × ℝ, quaternion-conjugation
  on ℍ ≅ Fin 4 → ℝ, and conjugate-transpose on M_3(ℂ).*

  ## Why this file

  Phase 6.5a (`FiniteAFAlgebra.lean`) shipped the additive group
  structure. Phase 6.5b (`FiniteAFAlgebraMul.lean`) shipped the
  multiplicative structure. This file ships the THIRD step:
  the ADJOINT involution `*` required for the spectral triple
  `(A_F, H_F, D_F)` to be a REAL spectral triple.

  Component-wise adjoint:

  * **ℂ component** — `(a, b)* = (a, -b)`, standard complex
    conjugation.
  * **ℍ component** — `(h₀, h₁, h₂, h₃)* = (h₀, -h₁, -h₂, -h₃)`,
    Hamilton 1843 quaternion conjugation.
  * **M_3(ℂ) component** — `(A*)_{ij} = complexAdj (A_{ji})`,
    conjugate-transpose.

  Properties shipped at the c_part field level:

  1. **Involution**: `(a*)* = a`.
  2. **One self-adjoint**: `1* = 1`.
  3. **Zero self-adjoint**: `0* = 0`.
  4. **Adjoint additivity**: `(a + b)* = a* + b*`.

  (Anti-multiplicativity `(a · b)* = b* · a*` requires more
  involved proof and is deferred to a future iteration.)

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `complexAdj`                                          | (def — ℂ-conjugation on ℝ × ℝ)                       |
  | `quaternionAdjFn`                                     | (def — Hamilton ℍ-conjugation)                       |
  | `matrix3ComplexAdj`                                   | (def — conjugate-transpose)                          |
  | `adj` on `FiniteAFAlgebra`                            | (def composing all three)                            |
  | `adj_adj_c_part`                                      | (adj (adj a)).c_part = a.c_part                      |
  | `adj_one_c_part`                                      | (adj 1).c_part = (1).c_part                          |
  | `adj_zero_c_part`                                     | (adj 0).c_part = (0).c_part                          |
  | `adj_add_c_part`                                      | (adj (a+b)).c_part = (adj a).c_part + (adj b).c_part |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_adjoint_report`                   |

  ## Author

  Lion's-Pride dynamic /loop iteration 105 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraAdjoint

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul

/-! ## 1. Component-wise adjoint helpers -/

/-- **ℂ-conjugation on ℝ × ℝ pair**: `(a, b)* = (a, -b)`. -/
def complexAdj (z : ℝ × ℝ) : ℝ × ℝ := (z.1, -z.2)

/-- **Quaternion conjugation on Fin 4 → ℝ** (Hamilton 1843):
    `(h₀, h₁, h₂, h₃)* = (h₀, -h₁, -h₂, -h₃)`. -/
def quaternionAdjFn (q : Fin 4 → ℝ) : Fin 4 → ℝ := fun i =>
  if i = 0 then q 0 else -(q i)

/-- **3×3 matrix conjugate-transpose over ℂ ≅ ℝ × ℝ**:
    `(A*)_{ij} = complexAdj (A_{ji})`. -/
def matrix3ComplexAdj (A : Matrix (Fin 3) (Fin 3) (ℝ × ℝ)) :
    Matrix (Fin 3) (Fin 3) (ℝ × ℝ) :=
  fun i j => complexAdj (A j i)

/-! ## 2. Adjoint operation on A_F -/

/-- **Adjoint involution on A_F**: component-wise via the three
    helpers above. -/
def adj (a : FiniteAFAlgebra) : FiniteAFAlgebra := {
  c_part := complexAdj a.c_part
  h_part := quaternionAdjFn a.h_part
  m3_part := matrix3ComplexAdj a.m3_part
}

/-! ## 3. Adjoint properties at c_part -/

/-- **Adjoint involution at c_part**: `(adj (adj a)).c_part = a.c_part`. -/
theorem adj_adj_c_part (a : FiniteAFAlgebra) :
    (adj (adj a)).c_part = a.c_part := by
  show complexAdj (complexAdj a.c_part) = a.c_part
  unfold complexAdj
  ext
  · rfl
  · show -(-a.c_part.2) = a.c_part.2
    ring

/-- **One is self-adjoint at c_part**:
    `(adj (1 : FiniteAFAlgebra)).c_part = (1 : FiniteAFAlgebra).c_part`. -/
theorem adj_one_c_part :
    (adj (1 : FiniteAFAlgebra)).c_part = (1 : FiniteAFAlgebra).c_part := by
  show complexAdj (1, 0) = (1, 0)
  unfold complexAdj
  ext
  · rfl
  · show -(0 : ℝ) = 0
    ring

/-- **Zero is self-adjoint at c_part**:
    `(adj (0 : FiniteAFAlgebra)).c_part = (0 : FiniteAFAlgebra).c_part`. -/
theorem adj_zero_c_part :
    (adj (0 : FiniteAFAlgebra)).c_part = (0 : FiniteAFAlgebra).c_part := by
  show complexAdj (0, 0) = (0, 0)
  unfold complexAdj
  ext
  · rfl
  · show -(0 : ℝ) = 0
    ring

/-- **Adjoint additivity at c_part**:
    `(adj (a + b)).c_part = (adj a).c_part + (adj b).c_part`. -/
theorem adj_add_c_part (a b : FiniteAFAlgebra) :
    (adj (a + b)).c_part = (adj a).c_part + (adj b).c_part := by
  show complexAdj (a.c_part.1 + b.c_part.1, a.c_part.2 + b.c_part.2) =
       complexAdj a.c_part + complexAdj b.c_part
  unfold complexAdj
  ext
  · rfl
  · show -(a.c_part.2 + b.c_part.2) = -a.c_part.2 + -b.c_part.2
    ring

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6.5c headline — finite Chamseddine-Connes
    A_F algebra adjoint structural report.**

    For any elements `a b : FiniteAFAlgebra`:

    1. **Involution at c_part**:
       `(adj (adj a)).c_part = a.c_part`.

    2. **One self-adjoint at c_part**:
       `(adj (1 : FiniteAFAlgebra)).c_part = (1 : FiniteAFAlgebra).c_part`.

    3. **Zero self-adjoint at c_part**:
       `(adj (0 : FiniteAFAlgebra)).c_part = (0 : FiniteAFAlgebra).c_part`.

    4. **Adjoint additivity at c_part**:
       `(adj (a + b)).c_part = (adj a).c_part + (adj b).c_part`. -/
theorem finite_AF_algebra_adjoint_report (a b : FiniteAFAlgebra) :
    (adj (adj a)).c_part = a.c_part ∧
    (adj (1 : FiniteAFAlgebra)).c_part = (1 : FiniteAFAlgebra).c_part ∧
    (adj (0 : FiniteAFAlgebra)).c_part = (0 : FiniteAFAlgebra).c_part ∧
    (adj (a + b)).c_part = (adj a).c_part + (adj b).c_part := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact adj_adj_c_part a
  · exact adj_one_c_part
  · exact adj_zero_c_part
  · exact adj_add_c_part a b

end OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
