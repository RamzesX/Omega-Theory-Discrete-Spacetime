/-
  OmegaTheory.Foundations.FiniteAFAlgebraSMulMul

  **Lion's-Pride Phase 6.5x (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra SMUL-MUL INTERACTION at
  c_part — proves the ℝ-bilinearity of the algebra multiplication
  with respect to ℝ-scalar multiplication: `((r • a) * b).c_part =
  (r • (a * b)).c_part` (left ℝ-linearity), `(a * (r • b)).c_part =
  (r • (a * b)).c_part` (right ℝ-linearity), and the joint identity
  `((r • a) * (s • b)).c_part = ((r * s) • (a * b)).c_part`.
  Foundation step toward declaring `FiniteAFAlgebra` an ℝ-algebra
  in the Mathlib sense (not yet shipped — would require Ring instance
  too, downstream).*

  ## Why this file

  An ℝ-algebra requires the multiplication map to be ℝ-bilinear:
    (r·a) · b = r · (a·b) = a · (r·b)  for all r ∈ ℝ.

  This file ships the c_part component of those identities. Combined
  with the additivity of multiplication (Phase 6.5d for c_part right-
  additivity, plus the symmetric left-additivity), it gives the full
  bilinearity content needed to declare an `Algebra ℝ FiniteAFAlgebra`
  instance — once a Ring instance ships.

  Note: this file establishes only the c_part field. The h_part
  (quaternionic) and m3_part (M_3(ℂ)) fields would need parallel
  files; for now, the c_part suffices to bootstrap the U(1) gauge
  factor.

  ## What this file ships

  | Property                                                  | Theorem                                              |
  |-----------------------------------------------------------|------------------------------------------------------|
  | `smul_mul_c_part`                                         | `((r • a) * b).c_part = (r • (a * b)).c_part`        |
  | `mul_smul_c_part`                                         | `(a * (r • b)).c_part = (r • (a * b)).c_part`        |
  | `smul_mul_smul_c_part`                                    | `((r • a) * (s • b)).c_part = ((r * s) • (a * b)).c_part` |
  | Headline (3-conjunct)                                     | `finite_AF_algebra_smul_mul_report`                  |

  ## Author

  Lion's-Pride dynamic /loop iteration 133 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraSMulMul

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMul

/-! ## 1. Left ℝ-linearity of multiplication at c_part -/

/-- **Left ℝ-linearity of multiplication at c_part**:
    `((r • a) * b).c_part = (r • (a * b)).c_part`.

    Proof: by direct computation through `complexMulPair`. The c_part
    of `(r • a)` is `(r·a.1, r·a.2)`, so the c_part of `(r • a) * b` is
      ((r·a.1)·b.1 - (r·a.2)·b.2,
       (r·a.1)·b.2 + (r·a.2)·b.1).
    The c_part of `a * b` is
      (a.1·b.1 - a.2·b.2, a.1·b.2 + a.2·b.1),
    so the c_part of `r • (a * b)` is
      (r·(a.1·b.1 - a.2·b.2), r·(a.1·b.2 + a.2·b.1)).
    These agree by `ring`. -/
theorem smul_mul_c_part (r : ℝ) (a b : FiniteAFAlgebra) :
    ((r • a) * b).c_part = (r • (a * b)).c_part := by
  show complexMulPair (r * a.c_part.1, r * a.c_part.2) b.c_part =
       (r * (complexMulPair a.c_part b.c_part).1,
        r * (complexMulPair a.c_part b.c_part).2)
  unfold complexMulPair
  ext
  · show (r * a.c_part.1) * b.c_part.1 - (r * a.c_part.2) * b.c_part.2 =
         r * (a.c_part.1 * b.c_part.1 - a.c_part.2 * b.c_part.2)
    ring
  · show (r * a.c_part.1) * b.c_part.2 + (r * a.c_part.2) * b.c_part.1 =
         r * (a.c_part.1 * b.c_part.2 + a.c_part.2 * b.c_part.1)
    ring

/-! ## 2. Right ℝ-linearity of multiplication at c_part -/

/-- **Right ℝ-linearity of multiplication at c_part**:
    `(a * (r • b)).c_part = (r • (a * b)).c_part`.

    Proof: parallel to `smul_mul_c_part` with `r` placed on `b`. -/
theorem mul_smul_c_part (r : ℝ) (a b : FiniteAFAlgebra) :
    (a * (r • b)).c_part = (r • (a * b)).c_part := by
  show complexMulPair a.c_part (r * b.c_part.1, r * b.c_part.2) =
       (r * (complexMulPair a.c_part b.c_part).1,
        r * (complexMulPair a.c_part b.c_part).2)
  unfold complexMulPair
  ext
  · show a.c_part.1 * (r * b.c_part.1) - a.c_part.2 * (r * b.c_part.2) =
         r * (a.c_part.1 * b.c_part.1 - a.c_part.2 * b.c_part.2)
    ring
  · show a.c_part.1 * (r * b.c_part.2) + a.c_part.2 * (r * b.c_part.1) =
         r * (a.c_part.1 * b.c_part.2 + a.c_part.2 * b.c_part.1)
    ring

/-! ## 3. Joint ℝ-linearity at c_part -/

/-- **Joint ℝ-linearity of multiplication at c_part**:
    `((r • a) * (s • b)).c_part = ((r * s) • (a * b)).c_part`.

    Proof: by direct ring computation; this is the corollary of
    left + right ℝ-linearity, but proved directly here for cleanliness. -/
theorem smul_mul_smul_c_part (r s : ℝ) (a b : FiniteAFAlgebra) :
    ((r • a) * (s • b)).c_part = ((r * s) • (a * b)).c_part := by
  show complexMulPair (r * a.c_part.1, r * a.c_part.2)
                      (s * b.c_part.1, s * b.c_part.2) =
       ((r * s) * (complexMulPair a.c_part b.c_part).1,
        (r * s) * (complexMulPair a.c_part b.c_part).2)
  unfold complexMulPair
  ext
  · show (r * a.c_part.1) * (s * b.c_part.1) -
         (r * a.c_part.2) * (s * b.c_part.2) =
         (r * s) * (a.c_part.1 * b.c_part.1 - a.c_part.2 * b.c_part.2)
    ring
  · show (r * a.c_part.1) * (s * b.c_part.2) +
         (r * a.c_part.2) * (s * b.c_part.1) =
         (r * s) * (a.c_part.1 * b.c_part.2 + a.c_part.2 * b.c_part.1)
    ring

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 6.5x headline — finite Chamseddine-Connes
    A_F algebra SMul-Mul interaction structural report at c_part.**

    For any real scalars `r s : ℝ` and any elements
    `a b : FiniteAFAlgebra`:

    1. **Left ℝ-linearity of multiplication**:
       `((r • a) * b).c_part = (r • (a * b)).c_part`.

    2. **Right ℝ-linearity of multiplication**:
       `(a * (r • b)).c_part = (r • (a * b)).c_part`.

    3. **Joint ℝ-linearity of multiplication**:
       `((r • a) * (s • b)).c_part = ((r * s) • (a * b)).c_part`. -/
theorem finite_AF_algebra_smul_mul_report
    (r s : ℝ) (a b : FiniteAFAlgebra) :
    ((r • a) * b).c_part = (r • (a * b)).c_part ∧
    (a * (r • b)).c_part = (r • (a * b)).c_part ∧
    ((r • a) * (s • b)).c_part = ((r * s) • (a * b)).c_part := by
  refine ⟨?_, ?_, ?_⟩
  · exact smul_mul_c_part r a b
  · exact mul_smul_c_part r a b
  · exact smul_mul_smul_c_part r s a b

end OmegaTheory.Foundations.FiniteAFAlgebraSMulMul
