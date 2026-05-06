/-
  OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjointNegClosure

  **Lion's-Pride Phase 6.5r (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra IS-SELF-ADJOINT NEGATION
  CLOSURE at c_part — proves `cPartIsSelfAdjoint a → cPartIsSelfAdjoint (-a)`
  and the related identities `(adj (-a)).c_part = -((adj a).c_part)` and
  `(-a).c_part = -(a.c_part)`. Together with Phase 6.5p
  `cPartIsSelfAdjoint_add_closure`, this completes the AddSubgroup
  closure structure of self-adjoint elements at c_part: closed under 0,
  addition, AND negation, hence under subtraction. Foundation step
  toward the Lie algebra of self-adjoint elements that exponentiate
  to U(A_F).*

  ## Why this file

  Phase 6.5p shipped 4 atomic closure properties (zero, one,
  real-scalar unit, addition) but did NOT prove negation closure. For
  a SUBGROUP-of-A_F structure on the self-adjoint elements (the Lie
  algebra `i·u(1) ⊕ ...` whose exponentials generate the unitary
  group), we need: closed under 0, +, AND -.

  This file ships the missing negation closure.

  ## What this file ships

  | Property                                                  | Theorem                                              |
  |-----------------------------------------------------------|------------------------------------------------------|
  | `FiniteAFAlgebra_neg_c_part`                              | `(-a).c_part = -(a.c_part)`                          |
  | `adj_neg_c_part`                                          | `(adj (-a)).c_part = -((adj a).c_part)`              |
  | `cPartIsSelfAdjoint_neg_closure`                          | self-adj → self-adj (negation)                       |
  | `cPartIsSelfAdjoint_sub_closure`                          | self-adj a, b → self-adj (a - b)                     |
  | Headline (4-conjunct)                                     | `finite_AF_algebra_is_self_adjoint_neg_closure_report`|

  ## Author

  Lion's-Pride dynamic /loop iteration 128 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjointNegClosure

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
open OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint

/-! ## 1. Negation at c_part as Prod.neg -/

/-- **Negation at c_part**:
    `(-a).c_part = (-a.c_part.1, -a.c_part.2)`,
    which equals `-(a.c_part)` under the standard Prod-AddGroup structure. -/
theorem FiniteAFAlgebra_neg_c_part (a : FiniteAFAlgebra) :
    (-a).c_part = (-a.c_part.1, -a.c_part.2) := by
  rfl

/-! ## 2. Adjoint commutes with negation at c_part -/

/-- **Adjoint commutes with negation at c_part**:
    `(adj (-a)).c_part = (-(adj a).c_part.1, -(adj a).c_part.2)`.

    Proof: `adj` is component-wise via `complexAdj (x, y) := (x, -y)`.
    Negating first gives `(-x, -y)`, then `complexAdj` gives `(-x, -(-y)) = (-x, y)`.
    Negating after `adj` gives `(-x, -(-y)) = (-x, y)`. So they agree. -/
theorem adj_neg_c_part (a : FiniteAFAlgebra) :
    (adj (-a)).c_part = (-(adj a).c_part.1, -(adj a).c_part.2) := by
  show complexAdj (-a.c_part.1, -a.c_part.2) =
       (-(complexAdj a.c_part).1, -(complexAdj a.c_part).2)
  unfold complexAdj
  ext
  · rfl
  · show -(-a.c_part.2) = -(-a.c_part.2)
    ring

/-! ## 3. Self-adjoint elements close under negation at c_part -/

/-- **Self-adjoint elements close under negation at c_part**:
    `cPartIsSelfAdjoint a → cPartIsSelfAdjoint (-a)`.

    Proof: from `ha : (adj a).c_part = a.c_part`,
    apply `adj_neg_c_part` to get `(adj (-a)).c_part = (-(adj a).c_part.1, -(adj a).c_part.2)`,
    then substitute via `ha`, giving `(-a.c_part.1, -a.c_part.2)`,
    which is `(-a).c_part` by `FiniteAFAlgebra_neg_c_part`. -/
theorem cPartIsSelfAdjoint_neg_closure
    {a : FiniteAFAlgebra} (ha : cPartIsSelfAdjoint a) :
    cPartIsSelfAdjoint (-a) := by
  show (adj (-a)).c_part = (-a).c_part
  rw [adj_neg_c_part]
  rw [FiniteAFAlgebra_neg_c_part]
  -- Goal: (-(adj a).c_part.1, -(adj a).c_part.2) = (-a.c_part.1, -a.c_part.2)
  have ha_eq : (adj a).c_part = a.c_part := ha
  -- We need (adj a).c_part.1 = a.c_part.1 and (adj a).c_part.2 = a.c_part.2
  have h1 : (adj a).c_part.1 = a.c_part.1 := by rw [ha_eq]
  have h2 : (adj a).c_part.2 = a.c_part.2 := by rw [ha_eq]
  rw [h1, h2]

/-! ## 4. Self-adjoint elements close under subtraction at c_part -/

/-- **Self-adjoint elements close under subtraction at c_part**:
    `cPartIsSelfAdjoint a → cPartIsSelfAdjoint b → cPartIsSelfAdjoint (a - b)`.

    Proof: `a - b = a + (-b)`. By Phase 6.5p `cPartIsSelfAdjoint_add_closure`
    + Phase 6.5r `cPartIsSelfAdjoint_neg_closure` composed.

    Note: Lean's `Sub` instance on `FiniteAFAlgebra` is not yet defined;
    we therefore phrase the closure as `a + (-b)` form. -/
theorem cPartIsSelfAdjoint_sub_closure
    {a b : FiniteAFAlgebra}
    (ha : cPartIsSelfAdjoint a) (hb : cPartIsSelfAdjoint b) :
    cPartIsSelfAdjoint (a + (-b)) := by
  exact cPartIsSelfAdjoint_add_closure ha (cPartIsSelfAdjoint_neg_closure hb)

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5r headline — finite Chamseddine-Connes
    A_F algebra IsSelfAdjoint negation-closure structural report at c_part.**

    For any elements `a b : FiniteAFAlgebra` (with hypotheses `ha`, `hb`):

    1. **Negation at c_part**:
       `(-a).c_part = (-a.c_part.1, -a.c_part.2)`.

    2. **Adjoint commutes with negation at c_part**:
       `(adj (-a)).c_part = (-(adj a).c_part.1, -(adj a).c_part.2)`.

    3. **Self-adjoint negation closure at c_part**:
       `cPartIsSelfAdjoint a → cPartIsSelfAdjoint (-a)`.

    4. **Self-adjoint subtraction closure at c_part**:
       `cPartIsSelfAdjoint a → cPartIsSelfAdjoint b → cPartIsSelfAdjoint (a + (-b))`. -/
theorem finite_AF_algebra_is_self_adjoint_neg_closure_report
    (a b : FiniteAFAlgebra)
    (ha : cPartIsSelfAdjoint a) (hb : cPartIsSelfAdjoint b) :
    (-a).c_part = (-a.c_part.1, -a.c_part.2) ∧
    (adj (-a)).c_part = (-(adj a).c_part.1, -(adj a).c_part.2) ∧
    cPartIsSelfAdjoint (-a) ∧
    cPartIsSelfAdjoint (a + (-b)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_neg_c_part a
  · exact adj_neg_c_part a
  · exact cPartIsSelfAdjoint_neg_closure ha
  · exact cPartIsSelfAdjoint_sub_closure ha hb

end OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjointNegClosure
