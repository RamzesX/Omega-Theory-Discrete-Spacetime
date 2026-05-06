/-
  OmegaTheory.Foundations.FiniteAFAlgebraAdjAntiMul

  **Lion's-Pride Phase 6.5e (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra ANTI-MULTIPLICATIVITY of
  adjoint at c_part — fifth step of multi-iteration Phase 6.5.
  Proves `(a · b)* = b* · a*` at c_part — the key compatibility
  condition between the multiplicative structure (Phase 6.5b) and
  the involution structure (Phase 6.5c) required for A_F to be a
  *-algebra (and hence for the spectral triple to be REAL).*

  ## Why this file

  Phase 6.5b (`FiniteAFAlgebraMul.lean`) shipped multiplication.
  Phase 6.5c (`FiniteAFAlgebraAdjoint.lean`) shipped the adjoint
  involution.  This file ships the FIFTH step: the anti-
  multiplicativity law `(a · b)* = b* · a*` at c_part — making A_F
  a *-algebra at the c_part field level.

  Algebraic identity:

  * `((a, b) · (c, d))* = (ac - bd, ad + bc)* = (ac - bd, -(ad + bc))`
  * `(c, d)* · (a, b)* = (c, -d) · (a, -b) = (ca - (-d)(-b), c(-b) + (-d)a)`
                     `= (ca - db, -cb - da) = (ac - bd, -(ad + bc))` ✓

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `FiniteAFAlgebra_adj_mul_c_part`                      | (adj (a*b)).c_part = (adj b * adj a).c_part          |
  | `FiniteAFAlgebra_adj_mul_self_c_part`                 | (adj (a*a)).c_part = (adj a * adj a).c_part          |
  | `FiniteAFAlgebra_adj_zero_mul_c_part`                 | (adj (0*a)).c_part = (0).c_part                      |
  | `FiniteAFAlgebra_adj_one_mul_c_part`                  | (adj (1*a)).c_part = (adj a).c_part                  |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_adj_anti_mul_report`              |

  ## Author

  Lion's-Pride dynamic /loop iteration 107 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraAdjAntiMul

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint

/-! ## 1. Anti-multiplicativity of adjoint at c_part -/

/-- **Anti-multiplicativity of adjoint at c_part**:
    `(adj (a · b)).c_part = ((adj b) · (adj a)).c_part`.

    This is the *-algebra compatibility condition between the
    multiplicative structure (Phase 6.5b) and the involution
    structure (Phase 6.5c). -/
theorem FiniteAFAlgebra_adj_mul_c_part (a b : FiniteAFAlgebra) :
    (adj (a * b)).c_part = ((adj b) * (adj a)).c_part := by
  show complexAdj (complexMulPair a.c_part b.c_part) =
       complexMulPair (complexAdj b.c_part) (complexAdj a.c_part)
  unfold complexAdj complexMulPair
  ext
  · ring
  · ring

/-! ## 2. Anti-multiplicativity special cases -/

/-- **Anti-multiplicativity for self-product at c_part**:
    `(adj (a · a)).c_part = ((adj a) · (adj a)).c_part`.

    Direct corollary of `FiniteAFAlgebra_adj_mul_c_part` with b := a. -/
theorem FiniteAFAlgebra_adj_mul_self_c_part (a : FiniteAFAlgebra) :
    (adj (a * a)).c_part = ((adj a) * (adj a)).c_part :=
  FiniteAFAlgebra_adj_mul_c_part a a

/-- **Adjoint of zero-product at c_part**:
    `(adj (0 · a)).c_part = (0 : FiniteAFAlgebra).c_part`. -/
theorem FiniteAFAlgebra_adj_zero_mul_c_part (a : FiniteAFAlgebra) :
    (adj ((0 : FiniteAFAlgebra) * a)).c_part = (0 : FiniteAFAlgebra).c_part := by
  show complexAdj (complexMulPair (0, 0) a.c_part) = (0, 0)
  unfold complexAdj complexMulPair
  ext
  · ring
  · ring

/-- **Adjoint of one-product at c_part**:
    `(adj (1 · a)).c_part = (adj a).c_part`.

    Derived by composing iter 104 one_mul with the adjoint def. -/
theorem FiniteAFAlgebra_adj_one_mul_c_part (a : FiniteAFAlgebra) :
    (adj ((1 : FiniteAFAlgebra) * a)).c_part = (adj a).c_part := by
  show complexAdj ((1 : FiniteAFAlgebra) * a).c_part = complexAdj a.c_part
  rw [FiniteAFAlgebra_one_mul_c_part]

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.5e headline — finite Chamseddine-Connes
    A_F algebra adjoint anti-multiplicativity structural report at
    c_part.**

    For any elements `a b : FiniteAFAlgebra`:

    1. **Anti-multiplicativity at c_part**:
       `(adj (a * b)).c_part = ((adj b) * (adj a)).c_part`.

    2. **Anti-multiplicativity self-product at c_part**:
       `(adj (a * a)).c_part = ((adj a) * (adj a)).c_part`.

    3. **Adjoint of zero-product at c_part**:
       `(adj (0 * a)).c_part = (0).c_part`.

    4. **Adjoint of one-product at c_part**:
       `(adj (1 * a)).c_part = (adj a).c_part`. -/
theorem finite_AF_algebra_adj_anti_mul_report (a b : FiniteAFAlgebra) :
    (adj (a * b)).c_part = ((adj b) * (adj a)).c_part ∧
    (adj (a * a)).c_part = ((adj a) * (adj a)).c_part ∧
    (adj ((0 : FiniteAFAlgebra) * a)).c_part = (0 : FiniteAFAlgebra).c_part ∧
    (adj ((1 : FiniteAFAlgebra) * a)).c_part = (adj a).c_part := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_adj_mul_c_part a b
  · exact FiniteAFAlgebra_adj_mul_self_c_part a
  · exact FiniteAFAlgebra_adj_zero_mul_c_part a
  · exact FiniteAFAlgebra_adj_one_mul_c_part a

end OmegaTheory.Foundations.FiniteAFAlgebraAdjAntiMul
