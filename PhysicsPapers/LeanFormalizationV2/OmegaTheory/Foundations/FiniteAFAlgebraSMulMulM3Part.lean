/-
  OmegaTheory.Foundations.FiniteAFAlgebraSMulMulM3Part

  **Lion's-Pride Phase 6.7b (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra SMUL-MUL INTERACTION at
  m3_part — proves the ℝ-bilinearity of the M_3(ℂ) matrix product:
  `((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j` (left
  ℝ-linearity) and `(a * (r • b)).m3_part i j = (r • (a * b)).m3_part
  i j` (right ℝ-linearity), at every index `(i, j) : Fin 3 × Fin 3`.
  Companion to Phase 6.5x (c_part bilinearity) and Phase 6.7
  (h_part / quaternionic bilinearity), completing the ℝ-bilinearity
  of A_F multiplication across all three component fields.*

  ## Why this file

  Phase 6.5x (iter 133) shipped c_part bilinearity. Phase 6.7
  (iter 139) shipped h_part (quaternion) bilinearity. The remaining
  m3_part (3×3 matrix over ℂ) component is shipped here.

  The matrix product `matrix3ComplexMul` is a `Finset.sum` over
  `Fin 3`:

      (A · B)_{ij} = Σ_k complexMulPair (A_{ik}) (B_{kj}).

  Bilinearity needs to push the scalar `r` through the sum, which
  requires `Fin.sum_univ_three` to expand to a 3-term sum and `ring`
  to close. The c_part complexMulPair bilinearity from Phase 6.5x
  is reused term-by-term.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `smul_mul_m3_part`                                    | `((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j` |
  | `mul_smul_m3_part`                                    | `(a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j` |
  | Headline (2-conjunct)                                 | `finite_AF_algebra_smul_mul_m3_part_report`          |

  ## Author

  Lion's-Pride dynamic /loop iteration 140 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMulM3Part
import Mathlib.Tactic
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.BigOperators.Fin

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraSMulMulM3Part

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMulM3Part

/-! ## 1. Left ℝ-linearity of matrix product at m3_part -/

/-- **Left ℝ-linearity of M_3(ℂ) matrix product at m3_part**:
    `((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j` for every
    `(i, j) : Fin 3 × Fin 3`.

    Proof: by direct unfolding of `matrix3ComplexMul` (the Finset.sum
    over `Fin 3` of `complexMulPair`), expanding the sum to its 3
    explicit terms via `Fin.sum_univ_three`, and closing each Prod
    component (fst and snd) by `ring` on the complex-mul cross terms. -/
theorem smul_mul_m3_part (r : ℝ) (a b : FiniteAFAlgebra) (i j : Fin 3) :
    ((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j := by
  show Finset.sum Finset.univ (fun k =>
         complexMulPair (r * (a.m3_part i k).1, r * (a.m3_part i k).2)
                        (b.m3_part k j)) =
       (r * (Finset.sum Finset.univ (fun k =>
              complexMulPair (a.m3_part i k) (b.m3_part k j))).1,
        r * (Finset.sum Finset.univ (fun k =>
              complexMulPair (a.m3_part i k) (b.m3_part k j))).2)
  rw [Fin.sum_univ_three (fun k =>
        complexMulPair (r * (a.m3_part i k).1, r * (a.m3_part i k).2)
                       (b.m3_part k j))]
  rw [Fin.sum_univ_three (fun k =>
        complexMulPair (a.m3_part i k) (b.m3_part k j))]
  unfold complexMulPair
  ext
  · show (r * (a.m3_part i 0).1) * (b.m3_part 0 j).1
         - (r * (a.m3_part i 0).2) * (b.m3_part 0 j).2
       + ((r * (a.m3_part i 1).1) * (b.m3_part 1 j).1
         - (r * (a.m3_part i 1).2) * (b.m3_part 1 j).2)
       + ((r * (a.m3_part i 2).1) * (b.m3_part 2 j).1
         - (r * (a.m3_part i 2).2) * (b.m3_part 2 j).2) =
         r * ((a.m3_part i 0).1 * (b.m3_part 0 j).1
              - (a.m3_part i 0).2 * (b.m3_part 0 j).2
            + ((a.m3_part i 1).1 * (b.m3_part 1 j).1
              - (a.m3_part i 1).2 * (b.m3_part 1 j).2)
            + ((a.m3_part i 2).1 * (b.m3_part 2 j).1
              - (a.m3_part i 2).2 * (b.m3_part 2 j).2))
    ring
  · show (r * (a.m3_part i 0).1) * (b.m3_part 0 j).2
         + (r * (a.m3_part i 0).2) * (b.m3_part 0 j).1
       + ((r * (a.m3_part i 1).1) * (b.m3_part 1 j).2
         + (r * (a.m3_part i 1).2) * (b.m3_part 1 j).1)
       + ((r * (a.m3_part i 2).1) * (b.m3_part 2 j).2
         + (r * (a.m3_part i 2).2) * (b.m3_part 2 j).1) =
         r * ((a.m3_part i 0).1 * (b.m3_part 0 j).2
              + (a.m3_part i 0).2 * (b.m3_part 0 j).1
            + ((a.m3_part i 1).1 * (b.m3_part 1 j).2
              + (a.m3_part i 1).2 * (b.m3_part 1 j).1)
            + ((a.m3_part i 2).1 * (b.m3_part 2 j).2
              + (a.m3_part i 2).2 * (b.m3_part 2 j).1))
    ring

/-! ## 2. Right ℝ-linearity of matrix product at m3_part -/

/-- **Right ℝ-linearity of M_3(ℂ) matrix product at m3_part**:
    `(a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j` for every
    `(i, j) : Fin 3 × Fin 3`.

    Proof: parallel to `smul_mul_m3_part` with `r` placed on the
    `b` argument. -/
theorem mul_smul_m3_part (r : ℝ) (a b : FiniteAFAlgebra) (i j : Fin 3) :
    (a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j := by
  show Finset.sum Finset.univ (fun k =>
         complexMulPair (a.m3_part i k)
                        (r * (b.m3_part k j).1, r * (b.m3_part k j).2)) =
       (r * (Finset.sum Finset.univ (fun k =>
              complexMulPair (a.m3_part i k) (b.m3_part k j))).1,
        r * (Finset.sum Finset.univ (fun k =>
              complexMulPair (a.m3_part i k) (b.m3_part k j))).2)
  rw [Fin.sum_univ_three (fun k =>
        complexMulPair (a.m3_part i k)
                       (r * (b.m3_part k j).1, r * (b.m3_part k j).2))]
  rw [Fin.sum_univ_three (fun k =>
        complexMulPair (a.m3_part i k) (b.m3_part k j))]
  unfold complexMulPair
  ext
  · show (a.m3_part i 0).1 * (r * (b.m3_part 0 j).1)
         - (a.m3_part i 0).2 * (r * (b.m3_part 0 j).2)
       + ((a.m3_part i 1).1 * (r * (b.m3_part 1 j).1)
         - (a.m3_part i 1).2 * (r * (b.m3_part 1 j).2))
       + ((a.m3_part i 2).1 * (r * (b.m3_part 2 j).1)
         - (a.m3_part i 2).2 * (r * (b.m3_part 2 j).2)) =
         r * ((a.m3_part i 0).1 * (b.m3_part 0 j).1
              - (a.m3_part i 0).2 * (b.m3_part 0 j).2
            + ((a.m3_part i 1).1 * (b.m3_part 1 j).1
              - (a.m3_part i 1).2 * (b.m3_part 1 j).2)
            + ((a.m3_part i 2).1 * (b.m3_part 2 j).1
              - (a.m3_part i 2).2 * (b.m3_part 2 j).2))
    ring
  · show (a.m3_part i 0).1 * (r * (b.m3_part 0 j).2)
         + (a.m3_part i 0).2 * (r * (b.m3_part 0 j).1)
       + ((a.m3_part i 1).1 * (r * (b.m3_part 1 j).2)
         + (a.m3_part i 1).2 * (r * (b.m3_part 1 j).1))
       + ((a.m3_part i 2).1 * (r * (b.m3_part 2 j).2)
         + (a.m3_part i 2).2 * (r * (b.m3_part 2 j).1)) =
         r * ((a.m3_part i 0).1 * (b.m3_part 0 j).2
              + (a.m3_part i 0).2 * (b.m3_part 0 j).1
            + ((a.m3_part i 1).1 * (b.m3_part 1 j).2
              + (a.m3_part i 1).2 * (b.m3_part 1 j).1)
            + ((a.m3_part i 2).1 * (b.m3_part 2 j).2
              + (a.m3_part i 2).2 * (b.m3_part 2 j).1))
    ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 6.7b headline — finite Chamseddine-Connes
    A_F algebra SMul-Mul interaction structural report at m3_part.**

    For any real scalar `r : ℝ`, any elements `a b : FiniteAFAlgebra`,
    and any indices `(i, j) : Fin 3 × Fin 3`:

    1. **Left ℝ-linearity of matrix product**:
       `((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j`.

    2. **Right ℝ-linearity of matrix product**:
       `(a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j`. -/
theorem finite_AF_algebra_smul_mul_m3_part_report
    (r : ℝ) (a b : FiniteAFAlgebra) (i j : Fin 3) :
    ((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j ∧
    (a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j := by
  refine ⟨?_, ?_⟩
  · exact smul_mul_m3_part r a b i j
  · exact mul_smul_m3_part r a b i j

end OmegaTheory.Foundations.FiniteAFAlgebraSMulMulM3Part
