/-
  OmegaTheory.Foundations.FiniteAFAlgebraAdjSMul

  **Lion's-Pride Phase 6.5v (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra ADJOINT-SMUL INTERACTION
  + LIE-ℝ-MODULE CLOSURE at c_part — proves that the adjoint is
  ℝ-linear at c_part: `(adj (r • a)).c_part = (r • adj a).c_part`
  (the standard fact that complex conjugation is ℝ-linear, ported
  through the ℝ × ℝ ≅ ℂ representation), and uses it to derive
  the Lie-ℝ-module closure of the self-adjoint set:
  `cPartIsSelfAdjoint a → cPartIsSelfAdjoint (r • a)`. Also proves
  squared-norm negation invariance `‖-a‖² = ‖a‖²` and unitary negation
  closure `cPartIsUnitary u → cPartIsUnitary (-u)`. Foundation step
  for the FULL ℝ-Lie-algebra structure of self-adjoint elements.*

  ## Why this file

  The adjoint operation `adj : A_F → A_F` is the substrate's analog
  of complex conjugation (extended to quaternionic and matrix
  components). For physics, this map is *antilinear* over ℂ but
  *linear* over ℝ. This ℝ-linearity is what makes the self-adjoint
  set a ℝ-Lie-subalgebra of A_F.

  Phase 6.5p (iter 126) shipped `cPartIsSelfAdjoint_add_closure`
  (additive closure). Phase 6.5r (iter 128) shipped
  `cPartIsSelfAdjoint_neg_closure` (negation closure). Together they
  make self-adjoint elements an AddSubgroup of A_F at c_part. To
  upgrade to a ℝ-Lie-submodule we need: closure under ℝ-scalar
  multiplication.

  This file ships exactly that.

  ## What this file ships

  | Property                                                  | Theorem                                              |
  |-----------------------------------------------------------|------------------------------------------------------|
  | `adj_smul_c_part`                                         | `(adj (r • a)).c_part = (r • adj a).c_part`          |
  | `cPartIsSelfAdjoint_smul_real_closure`                    | self-adj a → self-adj (r • a) (Lie-ℝ-submodule)      |
  | `cPartSquaredNorm_neg`                                    | `‖-a‖² = ‖a‖²`                                       |
  | `cPartIsUnitary_neg_closure`                              | unitary u → unitary (-u)                             |
  | Headline (4-conjunct)                                     | `finite_AF_algebra_adj_smul_report`                  |

  ## Author

  Lion's-Pride dynamic /loop iteration 131 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
import OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
import OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraAdjSMul

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
open OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
open OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint

/-! ## 1. Adjoint commutes with ℝ-scalar multiplication at c_part -/

/-- **Adjoint is ℝ-linear at c_part**:
    `(adj (r • a)).c_part = (r • adj a).c_part`.

    Proof: `adj` is component-wise via `complexAdj (x, y) := (x, -y)`.
    Applied to `r • a` (which has c_part `(r·a.1, r·a.2)`) gives
    `(r·a.1, -(r·a.2))`. Applying `r • _` to `adj a` (which has c_part
    `(a.1, -a.2)`) gives `(r·a.1, r·(-a.2))`. By ring, `-(r·a.2) = r·(-a.2)`,
    so the two agree.

    This is the ℝ-linearity of complex conjugation: while `adj` is ℂ-
    antilinear (`adj(z·a) = z̄·adj a`), it remains ℝ-linear because
    `r̄ = r` for `r ∈ ℝ`. -/
theorem adj_smul_c_part (r : ℝ) (a : FiniteAFAlgebra) :
    (adj (r • a)).c_part = (r • adj a).c_part := by
  show complexAdj (r * a.c_part.1, r * a.c_part.2) =
       (r * (complexAdj a.c_part).1, r * (complexAdj a.c_part).2)
  unfold complexAdj
  ext
  · rfl
  · show -(r * a.c_part.2) = r * -a.c_part.2
    ring

/-! ## 2. Self-adjoint elements close under ℝ-scalar multiplication -/

/-- **Self-adjoint elements close under ℝ-scalar multiplication at c_part**:
    `cPartIsSelfAdjoint a → cPartIsSelfAdjoint (r • a)`.

    Combined with Phase 6.5p `cPartIsSelfAdjoint_add_closure` and
    Phase 6.5r `cPartIsSelfAdjoint_neg_closure`, this completes the
    ℝ-Lie-submodule structure of self-adjoint elements at c_part.

    Proof: from `ha : (adj a).c_part = a.c_part` and `adj_smul_c_part`,
    we get `(adj (r • a)).c_part = (r • adj a).c_part`. The latter is
    `(r * (adj a).c_part.1, r * (adj a).c_part.2)` which under `ha`
    equals `(r * a.c_part.1, r * a.c_part.2) = (r • a).c_part`. -/
theorem cPartIsSelfAdjoint_smul_real_closure
    {a : FiniteAFAlgebra} (ha : cPartIsSelfAdjoint a) (r : ℝ) :
    cPartIsSelfAdjoint (r • a) := by
  show (adj (r • a)).c_part = (r • a).c_part
  rw [adj_smul_c_part]
  -- Goal: (r • adj a).c_part = (r • a).c_part
  -- Both unfold to (r * _.1, r * _.2); we need (adj a).c_part = a.c_part, which is ha
  show (r * (adj a).c_part.1, r * (adj a).c_part.2) =
       (r * a.c_part.1, r * a.c_part.2)
  have h1 : (adj a).c_part.1 = a.c_part.1 := by rw [ha]
  have h2 : (adj a).c_part.2 = a.c_part.2 := by rw [ha]
  rw [h1, h2]

/-! ## 3. Squared-norm negation invariance -/

/-- **Squared-norm is negation-invariant at c_part**:
    `cPartSquaredNorm (-a) = cPartSquaredNorm a`.

    Proof: `(-a).c_part = (-a.c_part.1, -a.c_part.2)`, so
    `‖-a‖² = (-a.1)² + (-a.2)² = a.1² + a.2² = ‖a‖²`. -/
theorem cPartSquaredNorm_neg (a : FiniteAFAlgebra) :
    cPartSquaredNorm (-a) = cPartSquaredNorm a := by
  show (-a.c_part.1)^2 + (-a.c_part.2)^2 = a.c_part.1^2 + a.c_part.2^2
  ring

/-! ## 4. Unitary elements close under negation -/

/-- **Unitary elements close under negation at c_part**:
    `cPartIsUnitary u → cPartIsUnitary (-u)`.

    Follows from `cPartSquaredNorm_neg`: `‖-u‖² = ‖u‖² = 1`. -/
theorem cPartIsUnitary_neg_closure
    {u : FiniteAFAlgebra} (hu : cPartIsUnitary u) :
    cPartIsUnitary (-u) := by
  show cPartSquaredNorm (-u) = 1
  rw [cPartSquaredNorm_neg]
  exact hu

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5v headline — finite Chamseddine-Connes
    A_F algebra adjoint-SMul interaction + Lie-ℝ-submodule structural
    report at c_part.**

    For any real scalar `r : ℝ` and any elements
    `a u : FiniteAFAlgebra` with hypotheses `ha : cPartIsSelfAdjoint a`,
    `hu : cPartIsUnitary u`:

    1. **Adjoint is ℝ-linear at c_part**:
       `(adj (r • a)).c_part = (r • adj a).c_part`.

    2. **Self-adjoint Lie-ℝ-submodule closure**:
       `cPartIsSelfAdjoint a → cPartIsSelfAdjoint (r • a)`.

    3. **Squared-norm negation invariance**:
       `cPartSquaredNorm (-a) = cPartSquaredNorm a`.

    4. **Unitary negation closure**:
       `cPartIsUnitary u → cPartIsUnitary (-u)`. -/
theorem finite_AF_algebra_adj_smul_report
    (r : ℝ) (a u : FiniteAFAlgebra)
    (ha : cPartIsSelfAdjoint a) (hu : cPartIsUnitary u) :
    (adj (r • a)).c_part = (r • adj a).c_part ∧
    cPartIsSelfAdjoint (r • a) ∧
    cPartSquaredNorm (-a) = cPartSquaredNorm a ∧
    cPartIsUnitary (-u) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact adj_smul_c_part r a
  · exact cPartIsSelfAdjoint_smul_real_closure ha r
  · exact cPartSquaredNorm_neg a
  · exact cPartIsUnitary_neg_closure hu

end OmegaTheory.Foundations.FiniteAFAlgebraAdjSMul
