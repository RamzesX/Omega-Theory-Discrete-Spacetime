/-
  OmegaTheory.Foundations.FiniteAFAlgebraMulProperties

  **Lion's-Pride Phase 6.5d (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra MULTIPLICATIVE
  PROPERTIES at c_part — fourth step of multi-iteration Phase 6.5.
  Proves commutativity (at c_part — the ℂ component), associativity
  (at c_part), right-distributivity (at c_part), and the
  `(1+1)·a = a+a` corollary derived by composing iter 104 left-
  distributivity with iter 104 one-mul.*

  ## Why this file

  Phase 6.5b (`FiniteAFAlgebraMul.lean`) shipped the Mul + One
  instances + 4 c_part-level identities (one left/right, zero
  absorbs, left-distributivity).  This file ships the COMPLEMENTARY
  c_part-level multiplicative properties needed before the structure
  could be promoted to a `Ring` instance at c_part:

  1. **Commutativity at c_part**: `(a · b).c_part = (b · a).c_part`.
     Note: A_F is NOT globally commutative because M_3(ℂ) is not.
     But the ℂ component IS commutative, and that lives at c_part.

  2. **Associativity at c_part**: `((a · b) · c).c_part = (a · (b · c)).c_part`.

  3. **Right-distributivity at c_part**:
     `(a · (b + c)).c_part = (a · b).c_part + (a · c).c_part`.

  4. **(1+1)·a = a+a at c_part** (composition):
     derived by composing Phase 6.5b's left-distributivity
     `((x+y)·z).c_part = (x·z).c_part + (y·z).c_part` with
     `(1·z).c_part = z.c_part`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `FiniteAFAlgebra_mul_comm_c_part`                     | (a*b).c_part = (b*a).c_part                          |
  | `FiniteAFAlgebra_mul_assoc_c_part`                    | ((a*b)*c).c_part = (a*(b*c)).c_part                  |
  | `FiniteAFAlgebra_mul_add_c_part`                      | (a*(b+c)).c_part = (a*b).c_part + (a*c).c_part       |
  | `FiniteAFAlgebra_two_mul_eq_add_self_c_part`          | ((1+1)*a).c_part = (a+a).c_part                      |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_mul_properties_report`            |

  ## Author

  Lion's-Pride dynamic /loop iteration 106 (2026-05-06).
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

namespace OmegaTheory.Foundations.FiniteAFAlgebraMulProperties

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul

/-! ## 1. Commutativity at c_part -/

/-- **ℂ-multiplicative commutativity at c_part**:
    `(a · b).c_part = (b · a).c_part`. -/
theorem FiniteAFAlgebra_mul_comm_c_part (a b : FiniteAFAlgebra) :
    (a * b).c_part = (b * a).c_part := by
  show complexMulPair a.c_part b.c_part = complexMulPair b.c_part a.c_part
  unfold complexMulPair
  ext
  · ring
  · ring

/-! ## 2. Associativity at c_part -/

/-- **ℂ-multiplicative associativity at c_part**:
    `((a · b) · c).c_part = (a · (b · c)).c_part`. -/
theorem FiniteAFAlgebra_mul_assoc_c_part (a b c : FiniteAFAlgebra) :
    ((a * b) * c).c_part = (a * (b * c)).c_part := by
  show complexMulPair (complexMulPair a.c_part b.c_part) c.c_part =
       complexMulPair a.c_part (complexMulPair b.c_part c.c_part)
  unfold complexMulPair
  ext
  · ring
  · ring

/-! ## 3. Right-distributivity at c_part -/

/-- **ℂ-multiplicative right-distributivity at c_part**:
    `(a · (b + c)).c_part = (a · b).c_part + (a · c).c_part`. -/
theorem FiniteAFAlgebra_mul_add_c_part (a b c : FiniteAFAlgebra) :
    (a * (b + c)).c_part = (a * b).c_part + (a * c).c_part := by
  show complexMulPair a.c_part (b.c_part.1 + c.c_part.1, b.c_part.2 + c.c_part.2) =
       complexMulPair a.c_part b.c_part + complexMulPair a.c_part c.c_part
  unfold complexMulPair
  ext
  · simp only [Prod.fst_add]; ring
  · simp only [Prod.snd_add]; ring

/-! ## 4. (1+1)·a = a+a at c_part (composition) -/

/-- **(1+1)·a = a+a at c_part**, derived by composing Phase 6.5b
    left-distributivity (`add_mul_c_part`) with Phase 6.5b
    one-mul (`one_mul_c_part`). -/
theorem FiniteAFAlgebra_two_mul_eq_add_self_c_part (a : FiniteAFAlgebra) :
    (((1 : FiniteAFAlgebra) + (1 : FiniteAFAlgebra)) * a).c_part = (a + a).c_part := by
  rw [FiniteAFAlgebra_add_mul_c_part]
  rw [FiniteAFAlgebra_one_mul_c_part]
  rfl

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5d headline — finite Chamseddine-Connes
    A_F algebra multiplicative-properties structural report at
    c_part.**

    For any elements `a b c : FiniteAFAlgebra`:

    1. **Commutativity at c_part**:
       `(a * b).c_part = (b * a).c_part`.

    2. **Associativity at c_part**:
       `((a * b) * c).c_part = (a * (b * c)).c_part`.

    3. **Right-distributivity at c_part**:
       `(a * (b + c)).c_part = (a * b).c_part + (a * c).c_part`.

    4. **(1+1)·a = a+a at c_part** (composition):
       `(((1 : FiniteAFAlgebra) + 1) * a).c_part = (a + a).c_part`. -/
theorem finite_AF_algebra_mul_properties_report (a b c : FiniteAFAlgebra) :
    (a * b).c_part = (b * a).c_part ∧
    ((a * b) * c).c_part = (a * (b * c)).c_part ∧
    (a * (b + c)).c_part = (a * b).c_part + (a * c).c_part ∧
    (((1 : FiniteAFAlgebra) + (1 : FiniteAFAlgebra)) * a).c_part = (a + a).c_part := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_mul_comm_c_part a b
  · exact FiniteAFAlgebra_mul_assoc_c_part a b c
  · exact FiniteAFAlgebra_mul_add_c_part a b c
  · exact FiniteAFAlgebra_two_mul_eq_add_self_c_part a

end OmegaTheory.Foundations.FiniteAFAlgebraMulProperties
