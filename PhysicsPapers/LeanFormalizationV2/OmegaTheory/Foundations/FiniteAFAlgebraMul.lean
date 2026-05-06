/-
  OmegaTheory.Foundations.FiniteAFAlgebraMul

  **Lion's-Pride Phase 6.5b (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra MULTIPLICATION structure —
  second step of multi-iteration Phase 6.5. Defines component-wise
  multiplication on A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ) using ℂ-multiplication on
  ℝ × ℝ, quaternion-multiplication on Fin 4 → ℝ, and matrix-product
  multiplication on Matrix (Fin 3) (Fin 3) (ℝ × ℝ).*

  ## Why this file

  Phase 6.5a (`FiniteAFAlgebra.lean`) shipped the finite Chamseddine-
  Connes algebra structure as a real direct-sum vector space with
  additive group structure (Zero/Add/Neg).  This file ships the
  SECOND step: multiplication.

  Component-wise multiplication:

  * **ℂ component** — `(a, b) · (c, d) = (a·c - b·d, a·d + b·c)`.
  * **ℍ component** — Hamilton 1843 quaternion product on Fin 4.
  * **M_3(ℂ) component** — matrix product with complex entries, i.e.,
    `(A · B)_{ij} = Σ_k complexMulPair (A_{ik}) (B_{kj})`.

  Multiplicative identity:

  * **ℂ component** — `(1, 0)`, the real one.
  * **ℍ component** — `(1, 0, 0, 0)`, the real one.
  * **M_3(ℂ) component** — identity matrix with diagonal `(1, 0)` and
    off-diagonal `(0, 0)`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `complexMulPair`                                      | (def — ℂ-multiplication on ℝ × ℝ)                    |
  | `quaternionMulFn`                                     | (def — Hamilton ℍ-multiplication)                    |
  | `matrix3ComplexMul`                                   | (def — 3×3 matrix mul over ℂ)                        |
  | `One` + `Mul` instances on `FiniteAFAlgebra`          | (instances)                                          |
  | `FiniteAFAlgebra_one_mul_c_part`                      | (1 · a).c_part = a.c_part                            |
  | `FiniteAFAlgebra_mul_one_c_part`                      | (a · 1).c_part = a.c_part                            |
  | `FiniteAFAlgebra_zero_mul_c_part`                     | (0 · a).c_part = (0, 0)                              |
  | `FiniteAFAlgebra_add_mul_c_part`                      | ((a+b) · c).c_part = (a·c).c_part + (b·c).c_part     |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_mul_report`                       |

  ## Author

  Lion's-Pride dynamic /loop iteration 104 (2026-05-06).
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

namespace OmegaTheory.Foundations.FiniteAFAlgebraMul

open OmegaTheory.Foundations.FiniteAFAlgebra

/-! ## 1. Component-wise multiplication helpers -/

/-- **ℂ-multiplication on ℝ × ℝ pair**:
    `(a, b) · (c, d) = (a·c - b·d, a·d + b·c)`. -/
def complexMulPair (a b : ℝ × ℝ) : ℝ × ℝ :=
  (a.1 * b.1 - a.2 * b.2, a.1 * b.2 + a.2 * b.1)

/-- **Quaternion multiplication on Fin 4 → ℝ** (Hamilton 1843):
    standard quaternion product formula via if-then-else dispatch. -/
def quaternionMulFn (a b : Fin 4 → ℝ) : Fin 4 → ℝ := fun i =>
  if i = 0 then a 0 * b 0 - a 1 * b 1 - a 2 * b 2 - a 3 * b 3
  else if i = 1 then a 0 * b 1 + a 1 * b 0 + a 2 * b 3 - a 3 * b 2
  else if i = 2 then a 0 * b 2 - a 1 * b 3 + a 2 * b 0 + a 3 * b 1
  else a 0 * b 3 + a 1 * b 2 - a 2 * b 1 + a 3 * b 0

/-- **3×3 matrix multiplication over ℂ ≅ ℝ × ℝ**:
    `(A · B)_{ij} = Σ_k complexMulPair (A_{ik}) (B_{kj})`. -/
def matrix3ComplexMul (A B : Matrix (Fin 3) (Fin 3) (ℝ × ℝ)) :
    Matrix (Fin 3) (Fin 3) (ℝ × ℝ) :=
  fun i j => Finset.sum Finset.univ (fun k => complexMulPair (A i k) (B k j))

/-! ## 2. Multiplicative structure on A_F -/

/-- **One element of A_F**: ℂ-one + ℍ-one + identity matrix. -/
instance : One FiniteAFAlgebra where
  one := {
    c_part := (1, 0)
    h_part := fun i => if i = 0 then 1 else 0
    m3_part := fun i j => if i = j then (1, 0) else (0, 0)
  }

/-- **Component-wise multiplication on A_F**. -/
instance : Mul FiniteAFAlgebra where
  mul a b := {
    c_part := complexMulPair a.c_part b.c_part
    h_part := quaternionMulFn a.h_part b.h_part
    m3_part := matrix3ComplexMul a.m3_part b.m3_part
  }

/-! ## 3. Multiplicative identity at c_part -/

/-- **One left-multiplies at c_part**: `((1·a).c_part = a.c_part`. -/
theorem FiniteAFAlgebra_one_mul_c_part (a : FiniteAFAlgebra) :
    ((1 : FiniteAFAlgebra) * a).c_part = a.c_part := by
  show complexMulPair (1, 0) a.c_part = a.c_part
  unfold complexMulPair
  ext
  · show 1 * a.c_part.1 - 0 * a.c_part.2 = a.c_part.1
    ring
  · show 1 * a.c_part.2 + 0 * a.c_part.1 = a.c_part.2
    ring

/-- **One right-multiplies at c_part**: `(a · 1).c_part = a.c_part`. -/
theorem FiniteAFAlgebra_mul_one_c_part (a : FiniteAFAlgebra) :
    (a * (1 : FiniteAFAlgebra)).c_part = a.c_part := by
  show complexMulPair a.c_part (1, 0) = a.c_part
  unfold complexMulPair
  ext
  · show a.c_part.1 * 1 - a.c_part.2 * 0 = a.c_part.1
    ring
  · show a.c_part.1 * 0 + a.c_part.2 * 1 = a.c_part.2
    ring

/-- **Zero left-multiplies (absorbs) at c_part**: `((0)·a).c_part = (0,0)`. -/
theorem FiniteAFAlgebra_zero_mul_c_part (a : FiniteAFAlgebra) :
    ((0 : FiniteAFAlgebra) * a).c_part = (0, 0) := by
  show complexMulPair (0, 0) a.c_part = (0, 0)
  unfold complexMulPair
  ext
  · show 0 * a.c_part.1 - 0 * a.c_part.2 = 0
    ring
  · show 0 * a.c_part.2 + 0 * a.c_part.1 = 0
    ring

/-- **Left-distributivity at c_part**:
    `((a + b) · c).c_part = (a · c).c_part + (b · c).c_part`. -/
theorem FiniteAFAlgebra_add_mul_c_part (a b c : FiniteAFAlgebra) :
    ((a + b) * c).c_part = (a * c).c_part + (b * c).c_part := by
  show complexMulPair (a.c_part.1 + b.c_part.1, a.c_part.2 + b.c_part.2) c.c_part =
       complexMulPair a.c_part c.c_part + complexMulPair b.c_part c.c_part
  unfold complexMulPair
  ext
  · show (a.c_part.1 + b.c_part.1) * c.c_part.1 - (a.c_part.2 + b.c_part.2) * c.c_part.2 =
         (a.c_part.1 * c.c_part.1 - a.c_part.2 * c.c_part.2) +
         (b.c_part.1 * c.c_part.1 - b.c_part.2 * c.c_part.2)
    ring
  · show (a.c_part.1 + b.c_part.1) * c.c_part.2 + (a.c_part.2 + b.c_part.2) * c.c_part.1 =
         (a.c_part.1 * c.c_part.2 + a.c_part.2 * c.c_part.1) +
         (b.c_part.1 * c.c_part.2 + b.c_part.2 * c.c_part.1)
    ring

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6.5b headline — finite Chamseddine-Connes
    A_F algebra multiplication structural report.**

    For any element `a : FiniteAFAlgebra`:

    1. **One left-identity at c_part**:
       `((1 : FiniteAFAlgebra) * a).c_part = a.c_part`.

    2. **One right-identity at c_part**:
       `(a * (1 : FiniteAFAlgebra)).c_part = a.c_part`.

    3. **Zero absorbs at c_part**:
       `((0 : FiniteAFAlgebra) * a).c_part = (0, 0)`.

    4. **Left-distributivity at c_part** (∀ b c):
       `((a + b) * c).c_part = (a * c).c_part + (b * c).c_part`. -/
theorem finite_AF_algebra_mul_report (a : FiniteAFAlgebra) :
    ((1 : FiniteAFAlgebra) * a).c_part = a.c_part ∧
    (a * (1 : FiniteAFAlgebra)).c_part = a.c_part ∧
    ((0 : FiniteAFAlgebra) * a).c_part = (0, 0) ∧
    ∀ b c : FiniteAFAlgebra,
      ((a + b) * c).c_part = (a * c).c_part + (b * c).c_part := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_one_mul_c_part a
  · exact FiniteAFAlgebra_mul_one_c_part a
  · exact FiniteAFAlgebra_zero_mul_c_part a
  · intro b c
    exact FiniteAFAlgebra_add_mul_c_part a b c

end OmegaTheory.Foundations.FiniteAFAlgebraMul
