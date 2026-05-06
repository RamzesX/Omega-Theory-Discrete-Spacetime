/-
  OmegaTheory.Foundations.FiniteAFAlgebraMulAssocM3Part

  **Lion's-Pride Phase 6.12 (2026-05-06)**:
  *Associativity of the M_3(ℂ) matrix product at the m3_part component
  of the finite Chamseddine-Connes A_F algebra.*

  Companion to Phase 6.9 `FiniteAFAlgebraMulAssocHPart` (Hamilton 1843
  quaternion associativity at h_part). This file ships the corresponding
  result for m3_part: the 3×3 matrix product over ℂ is associative.

  ## What this file ships

  | Lemma                                                     | Statement                                                |
  |-----------------------------------------------------------|----------------------------------------------------------|
  | `complexMulPair_assoc`                                    | `complexMulPair (complexMulPair a b) c = complexMulPair a (complexMulPair b c)` |
  | `mul_assoc_m3_part`                                       | `((a * b) * c).m3_part i j = (a * (b * c)).m3_part i j` |
  | Headline                                                  | `finite_AF_algebra_mul_assoc_m3_part_report`            |

  ## Proof strategy

  The 3×3 matrix product over ℂ is associative because:
  1. ℂ-multiplication on ℝ × ℝ pairs is associative (`complexMulPair_assoc`).
  2. ℂ-multiplication distributes over ℝ × ℝ addition.
  3. Hence `complexMulPair` distributes over `Finset.sum`.
  4. Apply Finset.sum_comm to swap nested sums.

  Implementation: expand both 3-element Finset sums via `Fin.sum_univ_three`,
  unfold `complexMulPair` to ℝ-pair expressions, then `Prod.ext_iff` + `ring`
  closes each component (polynomial identity in 18 ℝ variables — Fin 3 case
  manageable but heart-heavy; raise `maxHeartbeats` accordingly).

  ## Author

  Lion's-Pride dynamic /loop iteration 160 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import Mathlib.Tactic
import Mathlib.Algebra.BigOperators.Fin

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false
set_option linter.style.maxHeartbeats false
-- m3_part associativity is a polynomial identity in 18 ℝ vars after
-- unfolding 3×3 sums; raise maxHeartbeats for ring's resolution.
set_option maxHeartbeats 1600000

namespace OmegaTheory.Foundations.FiniteAFAlgebraMulAssocM3Part

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul

/-! ## 1. Associativity of complexMulPair (ℂ-multiplication on ℝ × ℝ) -/

/-- **complexMulPair is associative**: this is the underlying ℂ-product
    associativity. -/
theorem complexMulPair_assoc (a b c : ℝ × ℝ) :
    complexMulPair (complexMulPair a b) c = complexMulPair a (complexMulPair b c) := by
  unfold complexMulPair
  ext
  · show (a.1 * b.1 - a.2 * b.2) * c.1 - (a.1 * b.2 + a.2 * b.1) * c.2
       = a.1 * (b.1 * c.1 - b.2 * c.2) - a.2 * (b.1 * c.2 + b.2 * c.1)
    ring
  · show (a.1 * b.1 - a.2 * b.2) * c.2 + (a.1 * b.2 + a.2 * b.1) * c.1
       = a.1 * (b.1 * c.2 + b.2 * c.1) + a.2 * (b.1 * c.1 - b.2 * c.2)
    ring

/-! ## 2. Main theorem: associativity at m3_part -/

/-- **Associativity of M_3(ℂ) matrix product at m3_part** —
    Lion's-Pride Phase 6.12 main theorem.

    For all `a b c : FiniteAFAlgebra` and indices `i j : Fin 3`:
        `((a * b) * c).m3_part i j = (a * (b * c)).m3_part i j`.

    Proof strategy: expand the 3-element Finset.sum on both sides via
    `Fin.sum_univ_three`, unfold `complexMulPair` to ℝ-pair expressions,
    then `Prod.ext_iff` + `ring` closes each component (polynomial
    identity in 18 ℝ variables). -/
theorem mul_assoc_m3_part (a b c : FiniteAFAlgebra) (i j : Fin 3) :
    ((a * b) * c).m3_part i j = (a * (b * c)).m3_part i j := by
  show matrix3ComplexMul (matrix3ComplexMul a.m3_part b.m3_part) c.m3_part i j
     = matrix3ComplexMul a.m3_part (matrix3ComplexMul b.m3_part c.m3_part) i j
  unfold matrix3ComplexMul
  simp only [Fin.sum_univ_three, complexMulPair, Prod.mk_add_mk]
  ext
  · ring
  · ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.12 headline — finite Chamseddine-Connes
    A_F algebra m3_part associativity report.**

    For all `a b c : FiniteAFAlgebra` and `i j : Fin 3`:

    1. **m3_part associativity**:
       `((a * b) * c).m3_part i j = (a * (b * c)).m3_part i j`.

    Together with Phase 6.9 `mul_assoc_h_part` (Hamilton 1843 quaternion
    associativity at h_part), this completes the per-component
    associativity ledger for the finite Chamseddine-Connes A_F algebra
    on its non-commutative components. The c_part is automatic since
    ℂ is associative as a field. -/
theorem finite_AF_algebra_mul_assoc_m3_part_report
    (a b c : FiniteAFAlgebra) (i j : Fin 3) :
    ((a * b) * c).m3_part i j = (a * (b * c)).m3_part i j := by
  exact mul_assoc_m3_part a b c i j

end OmegaTheory.Foundations.FiniteAFAlgebraMulAssocM3Part
