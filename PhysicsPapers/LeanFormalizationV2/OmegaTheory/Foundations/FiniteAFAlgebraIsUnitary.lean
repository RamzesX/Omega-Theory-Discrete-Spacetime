/-
  OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary

  **Lion's-Pride Phase 6.5o (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra IS-UNITARY predicate at
  c_part — defines `cPartIsUnitary u := ‖u‖²|c = 1` (the standard
  unitary condition `u* · u = 1` rephrased through the squared-norm
  on the ℂ-component) and proves the canonical unitary properties:
  the identity is unitary, its negation is unitary, the adjoint of
  a unitary is unitary, and the real scalar `r • 1` is unitary iff
  `r² = 1`. Foundation step toward the unitary group U(A_F)|c
  whose modulo-center quotient gives the gauge group.*

  ## Why this file

  In Connes' framework the gauge group is extracted as the unitary
  group `U(A_F) := { u ∈ A_F | u* u = 1 = u u* }` modulo the center
  `Z(A_F)`. For the ℂ-component (c_part), `u* u = 1` reduces to
  `|u|² = 1` (modulus-squared), which is exactly what
  `cPartSquaredNorm` captures.

  This file ships the `cPartIsUnitary` predicate and its basic
  closure properties — the next step after Phase 6.5n
  (`FiniteAFAlgebraSquaredNorm.lean`, iter 124).

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `cPartIsUnitary`                                      | (def — `‖u‖²|c = 1`)                                 |
  | `cPartIsUnitary_one`                                  | 1 is unitary at c_part                               |
  | `cPartIsUnitary_neg_one`                              | -1 is unitary at c_part                              |
  | `cPartIsUnitary_adj`                                  | adj preserves unitary at c_part                      |
  | `cPartIsUnitary_scalar_one_iff`                       | r • 1 unitary at c_part ↔ r² = 1                     |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_is_unitary_report`                |

  ## Author

  Lion's-Pride dynamic /loop iteration 125 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm

/-! ## 1. The c_part unitary predicate -/

/-- **c_part unitary predicate**:
    `cPartIsUnitary u ↔ ‖u‖²|c = 1`.

    This is the standard unitary condition `u* · u = 1` rephrased
    through the squared-norm on the ℂ-component of A_F. -/
def cPartIsUnitary (u : FiniteAFAlgebra) : Prop :=
  cPartSquaredNorm u = 1

/-! ## 2. Identity and its negation are unitary -/

/-- **The identity is unitary at c_part**: `cPartIsUnitary 1`. -/
theorem cPartIsUnitary_one :
    cPartIsUnitary (1 : FiniteAFAlgebra) := by
  show cPartSquaredNorm (1 : FiniteAFAlgebra) = 1
  exact cPartSquaredNorm_one

/-- **The negation of the identity is unitary at c_part**:
    `cPartIsUnitary (-1)`. -/
theorem cPartIsUnitary_neg_one :
    cPartIsUnitary (-(1 : FiniteAFAlgebra)) := by
  show cPartSquaredNorm (-(1 : FiniteAFAlgebra)) = 1
  -- (-1).c_part = (-1, -0) = (-1, 0)
  show (-(1 : ℝ))^2 + (-(0 : ℝ))^2 = 1
  ring

/-! ## 3. Adjoint preserves unitary -/

/-- **Adjoint of a unitary is unitary at c_part**:
    `cPartIsUnitary u → cPartIsUnitary (adj u)`.

    Follows from adjoint-invariance of the squared-norm
    (`cPartSquaredNorm_adj`). -/
theorem cPartIsUnitary_adj {u : FiniteAFAlgebra}
    (h : cPartIsUnitary u) :
    cPartIsUnitary (adj u) := by
  show cPartSquaredNorm (adj u) = 1
  rw [cPartSquaredNorm_adj]
  exact h

/-! ## 4. Real-scalar unit unitary characterization -/

/-- **Real-scalar unit unitary characterization at c_part**:
    `cPartIsUnitary (r • 1) ↔ r² = 1`. -/
theorem cPartIsUnitary_scalar_one_iff (r : ℝ) :
    cPartIsUnitary (r • (1 : FiniteAFAlgebra)) ↔ r^2 = 1 := by
  constructor
  · intro h
    -- Extract the underlying squared-norm equality from the definition
    have h_norm : cPartSquaredNorm (r • (1 : FiniteAFAlgebra)) = 1 := h
    -- by smul: cPartSquaredNorm (r • 1) = r^2 * cPartSquaredNorm 1 = r^2
    have h1 : cPartSquaredNorm (r • (1 : FiniteAFAlgebra)) = r^2 := by
      rw [cPartSquaredNorm_smul, cPartSquaredNorm_one, mul_one]
    linarith
  · intro h_r_sq
    -- h_r_sq : r^2 = 1
    show cPartSquaredNorm (r • (1 : FiniteAFAlgebra)) = 1
    have h1 : cPartSquaredNorm (r • (1 : FiniteAFAlgebra)) = r^2 := by
      rw [cPartSquaredNorm_smul, cPartSquaredNorm_one, mul_one]
    rw [h1]
    exact h_r_sq

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5o headline — finite Chamseddine-Connes
    A_F algebra IsUnitary structural report at c_part.**

    For any element `u : FiniteAFAlgebra` (with hypothesis `h_u`)
    and any real scalar `r : ℝ`:

    1. **Identity is unitary at c_part**:
       `cPartIsUnitary 1`.

    2. **Negation of identity is unitary at c_part**:
       `cPartIsUnitary (-1)`.

    3. **Adjoint preserves unitary at c_part**:
       `cPartIsUnitary u → cPartIsUnitary (adj u)`.

    4. **Real-scalar unit unitary characterization**:
       `cPartIsUnitary (r • 1) ↔ r² = 1`. -/
theorem finite_AF_algebra_is_unitary_report (u : FiniteAFAlgebra)
    (h_u : cPartIsUnitary u) (r : ℝ) :
    cPartIsUnitary (1 : FiniteAFAlgebra) ∧
    cPartIsUnitary (-(1 : FiniteAFAlgebra)) ∧
    cPartIsUnitary (adj u) ∧
    (cPartIsUnitary (r • (1 : FiniteAFAlgebra)) ↔ r^2 = 1) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact cPartIsUnitary_one
  · exact cPartIsUnitary_neg_one
  · exact cPartIsUnitary_adj h_u
  · exact cPartIsUnitary_scalar_one_iff r

end OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
