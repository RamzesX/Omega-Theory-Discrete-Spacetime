/-
  OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter

  **Lion's-Pride Phase 6.5g (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra REAL-SCALAR EMBEDDING into
  the center at c_part — proving that elements of the form `r • 1`
  (for `r : ℝ`) are CENTRAL (commute with every element at the
  c_part level) and SELF-ADJOINT, establishing the embedding
  ℝ ↪ Z(A_F) at the c_part field level — the foundation for the
  inner-automorphism analysis (gauge group extraction) in future
  iterations of Phase 6.5.*

  ## Why this file

  In Connes' noncommutative-geometry framework, the gauge group of
  the spectral triple (A_F, H_F, D_F) is extracted as the group
  of inner automorphisms of A_F modulo the center.  The first step
  is identifying which elements are CENTRAL.

  For the ℂ-component of A_F (the c_part field):
  * `r • 1` for `r : ℝ` lies in `ℝ ⊂ ℂ`, hence in the center of ℂ
    (since ℂ is commutative — every element is central).
  * Self-adjoint: `(r)* = r` for real `r`.

  This file ships these 4 substantive properties at the c_part level,
  establishing the real-scalar embedding ℝ ↪ Z(A_F)|c_part.  The
  full ℂ-center analysis (where the *whole* ℂ component is central
  since ℂ is abelian, even before restricting to ℝ) is deferred to
  a future iteration when we promote A_F to a `Module ℝ` and analyze
  the algebra-of-functions side.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `FiniteAFAlgebra_scalar_one_c_part_eq`                | (r • 1).c_part = (r, 0)                              |
  | `FiniteAFAlgebra_scalar_unit_central_c_part`          | (r•1) · a and a · (r•1) coincide at c_part           |
  | `FiniteAFAlgebra_scalar_unit_self_adjoint_c_part`     | adj (r • 1) = r • 1 at c_part                        |
  | `FiniteAFAlgebra_scalar_unit_compose_c_part`          | (r•1) · (s•1) = (r·s) • 1 at c_part                  |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_scalar_center_report`             |

  ## Author

  Lion's-Pride dynamic /loop iteration 123 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Matrix.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
open OmegaTheory.Foundations.FiniteAFAlgebraSMul

/-! ## 1. Real-scalar unit explicit form -/

/-- **Real-scalar unit explicit form at c_part**:
    `(r • (1 : FiniteAFAlgebra)).c_part = (r, 0)`. -/
theorem FiniteAFAlgebra_scalar_one_c_part_eq (r : ℝ) :
    (r • (1 : FiniteAFAlgebra)).c_part = (r, 0) := by
  show (r * (1 : ℝ), r * (0 : ℝ)) = (r, 0)
  ext
  · show r * (1 : ℝ) = r
    ring
  · show r * (0 : ℝ) = 0
    ring

/-! ## 2. Real-scalar unit centrality -/

/-- **Real-scalar unit centrality at c_part**:
    `((r • 1) · a).c_part = (a · (r • 1)).c_part`.

    The element `r • 1` commutes with every `a` at the c_part level —
    establishing that `r • 1 ∈ Z(A_F)|c_part`. -/
theorem FiniteAFAlgebra_scalar_unit_central_c_part (r : ℝ) (a : FiniteAFAlgebra) :
    ((r • (1 : FiniteAFAlgebra)) * a).c_part =
    (a * (r • (1 : FiniteAFAlgebra))).c_part := by
  show complexMulPair (r * (1 : ℝ), r * (0 : ℝ)) a.c_part =
       complexMulPair a.c_part (r * (1 : ℝ), r * (0 : ℝ))
  unfold complexMulPair
  ext
  · show (r * 1) * a.c_part.1 - (r * 0) * a.c_part.2 =
         a.c_part.1 * (r * 1) - a.c_part.2 * (r * 0)
    ring
  · show (r * 1) * a.c_part.2 + (r * 0) * a.c_part.1 =
         a.c_part.1 * (r * 0) + a.c_part.2 * (r * 1)
    ring

/-! ## 3. Real-scalar unit self-adjointness -/

/-- **Real-scalar unit self-adjointness at c_part**:
    `(adj (r • 1)).c_part = (r • 1).c_part`.

    The real-scalar unit is its own adjoint at the c_part level —
    consistent with `r* = r` for real `r ∈ ℝ ⊂ ℂ`. -/
theorem FiniteAFAlgebra_scalar_unit_self_adjoint_c_part (r : ℝ) :
    (adj (r • (1 : FiniteAFAlgebra))).c_part =
    (r • (1 : FiniteAFAlgebra)).c_part := by
  show complexAdj (r * (1 : ℝ), r * (0 : ℝ)) = (r * (1 : ℝ), r * (0 : ℝ))
  unfold complexAdj
  ext
  · show r * (1 : ℝ) = r * 1
    rfl
  · show -(r * (0 : ℝ)) = r * 0
    ring

/-! ## 4. Real-scalar unit composition -/

/-- **Real-scalar unit composition at c_part**:
    `((r • 1) · (s • 1)).c_part = ((r · s) • 1).c_part`.

    Multiplication of two real-scalar units is the real-scalar unit
    of the product — establishing the multiplicative homomorphism
    ℝ → A_F via `r ↦ r • 1`. -/
theorem FiniteAFAlgebra_scalar_unit_compose_c_part (r s : ℝ) :
    ((r • (1 : FiniteAFAlgebra)) * (s • (1 : FiniteAFAlgebra))).c_part =
    ((r * s) • (1 : FiniteAFAlgebra)).c_part := by
  show complexMulPair (r * (1 : ℝ), r * (0 : ℝ)) (s * (1 : ℝ), s * (0 : ℝ)) =
       (r * s * (1 : ℝ), r * s * (0 : ℝ))
  unfold complexMulPair
  ext
  · show (r * 1) * (s * 1) - (r * 0) * (s * 0) = r * s * 1
    ring
  · show (r * 1) * (s * 0) + (r * 0) * (s * 1) = r * s * 0
    ring

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5g headline — finite Chamseddine-Connes
    A_F algebra real-scalar embedding into the center structural
    report at c_part.**

    For any real scalars `r s : ℝ` and any element `a : FiniteAFAlgebra`:

    1. **Real-scalar unit explicit form at c_part**:
       `(r • 1).c_part = (r, 0)`.

    2. **Real-scalar unit centrality at c_part**:
       `((r • 1) · a).c_part = (a · (r • 1)).c_part`.

    3. **Real-scalar unit self-adjointness at c_part**:
       `(adj (r • 1)).c_part = (r • 1).c_part`.

    4. **Real-scalar unit composition at c_part**:
       `((r • 1) · (s • 1)).c_part = ((r · s) • 1).c_part`. -/
theorem finite_AF_algebra_scalar_center_report (r s : ℝ) (a : FiniteAFAlgebra) :
    (r • (1 : FiniteAFAlgebra)).c_part = (r, 0) ∧
    ((r • (1 : FiniteAFAlgebra)) * a).c_part =
      (a * (r • (1 : FiniteAFAlgebra))).c_part ∧
    (adj (r • (1 : FiniteAFAlgebra))).c_part = (r • (1 : FiniteAFAlgebra)).c_part ∧
    ((r • (1 : FiniteAFAlgebra)) * (s • (1 : FiniteAFAlgebra))).c_part =
      ((r * s) • (1 : FiniteAFAlgebra)).c_part := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_scalar_one_c_part_eq r
  · exact FiniteAFAlgebra_scalar_unit_central_c_part r a
  · exact FiniteAFAlgebra_scalar_unit_self_adjoint_c_part r
  · exact FiniteAFAlgebra_scalar_unit_compose_c_part r s

end OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter
