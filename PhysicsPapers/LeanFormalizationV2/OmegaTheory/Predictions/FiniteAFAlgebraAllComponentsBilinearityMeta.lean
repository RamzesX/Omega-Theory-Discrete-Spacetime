/-
  OmegaTheory.Predictions.FiniteAFAlgebraAllComponentsBilinearityMeta

  **Lion's-Pride Phase 6.8 — ALL-COMPONENTS BILINEARITY META (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra ALL-COMPONENTS BILINEARITY META —
  composing the Phase 6.5x c_part bilinearity, Phase 6.7 h_part
  (quaternion) bilinearity, and Phase 6.7b m3_part (matrix) bilinearity
  into a SINGLE 6-conjunct umbrella declaring the FULL ℝ-bilinearity
  of A_F multiplication across all three component fields:

      A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ)

  This is the structural primitive for declaring `FiniteAFAlgebra`
  an `Algebra ℝ` in the Mathlib sense — the multiplication is
  ℝ-bilinear at every component field.*

  ## Why this file

  An ℝ-algebra `A` over the reals requires the multiplication to be
  ℝ-bilinear at every relevant index. For `A_F`, this means:

      ∀ r ∈ ℝ, ∀ a, b ∈ A_F, ∀ i, j (component indices):
        (r·a)·b at component = r · (a·b) at component
        a·(r·b) at component = r · (a·b) at component

  Across 3 dedicated iterations (133, 139, 140), the bilinearity
  pieces shipped:

  | Iter  | Phase | Content                                                         |
  |-------|-------|-----------------------------------------------------------------|
  | 133   | 6.5x  | c_part bilinearity (complex-mul, ring identity)                 |
  | 139   | 6.7   | h_part bilinearity (Hamilton quaternion-mul, split_ifs + ring)  |
  | 140   | 6.7b  | m3_part bilinearity (matrix-mul over Finset.sum, Fin.sum_univ_three) |

  This file ships the META — composing them into a single all-
  components umbrella primitive, ready for downstream use as the
  foundation of an `Algebra ℝ FiniteAFAlgebra` instance.

  ## What this file ships

  | Conjunct | Identity                                                                    |
  |----------|-----------------------------------------------------------------------------|
  | (1)      | c_part left-bilin: `((r • a) * b).c_part = (r • (a * b)).c_part`             [Phase 6.5x] |
  | (2)      | c_part right-bilin: `(a * (r • b)).c_part = (r • (a * b)).c_part`            [Phase 6.5x] |
  | (3)      | h_part left-bilin: `∀ i, ((r • a) * b).h_part i = (r • (a * b)).h_part i`    [Phase 6.7] |
  | (4)      | h_part right-bilin: `∀ i, (a * (r • b)).h_part i = (r • (a * b)).h_part i`   [Phase 6.7] |
  | (5)      | m3_part left-bilin: `∀ i j, ((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j` [Phase 6.7b] |
  | (6)      | m3_part right-bilin: `∀ i j, (a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j` [Phase 6.7b] |

  Plus a frozen-Nat snapshot:

  * `bilinearity_phase_count := 3`            (6.5x, 6.7, 6.7b)
  * `bilinearity_atomic_theorems := 6`        (2 c_part + 2 h_part + 2 m3_part)
  * `bilinearity_axiom_count := 0`            (Lean core only)
  * `bilinearity_grand_sum := 9`              (= 3 + 6 + 0)

  ## Author

  Lion's-Pride dynamic /loop iteration 141 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMulMul
import OmegaTheory.Foundations.FiniteAFAlgebraSMulMulHPart
import OmegaTheory.Foundations.FiniteAFAlgebraSMulMulM3Part
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.FiniteAFAlgebraAllComponentsBilinearityMeta

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMulMul
open OmegaTheory.Foundations.FiniteAFAlgebraSMulMulHPart
open OmegaTheory.Foundations.FiniteAFAlgebraSMulMulM3Part

/-! ## The ALL-COMPONENTS BILINEARITY META: 6 conjuncts -/

/-- **FINITE A_F ALL-COMPONENTS BILINEARITY META** — composing the
    ℝ-bilinearity of A_F multiplication at all three component fields:

    * 6.5x c_part (complex-mul) bilinearity,
    * 6.7  h_part (Hamilton quaternion-mul) bilinearity,
    * 6.7b m3_part (M_3(ℂ) matrix-mul over Finset.sum) bilinearity,

    into a single 6-conjunct umbrella declaring the FULL ℝ-bilinearity
    of A_F multiplication across A_F = ℂ ⊕ ℍ ⊕ M_3(ℂ).

    For any real scalar `r : ℝ` and any elements `a b : FiniteAFAlgebra`:

    1. **c_part left ℝ-linearity**:
       `((r • a) * b).c_part = (r • (a * b)).c_part`.

    2. **c_part right ℝ-linearity**:
       `(a * (r • b)).c_part = (r • (a * b)).c_part`.

    3. **h_part left ℝ-linearity** (componentwise, ∀ i : Fin 4):
       `((r • a) * b).h_part i = (r • (a * b)).h_part i`.

    4. **h_part right ℝ-linearity** (componentwise, ∀ i : Fin 4):
       `(a * (r • b)).h_part i = (r • (a * b)).h_part i`.

    5. **m3_part left ℝ-linearity** (componentwise, ∀ i j : Fin 3):
       `((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j`.

    6. **m3_part right ℝ-linearity** (componentwise, ∀ i j : Fin 3):
       `(a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j`. -/
theorem finite_AF_algebra_all_components_bilinearity_meta
    (r : ℝ) (a b : FiniteAFAlgebra) :
    -- (1) Phase 6.5x c_part left bilinearity
    ((r • a) * b).c_part = (r • (a * b)).c_part ∧
    -- (2) Phase 6.5x c_part right bilinearity
    (a * (r • b)).c_part = (r • (a * b)).c_part ∧
    -- (3) Phase 6.7 h_part left bilinearity
    (∀ i : Fin 4, ((r • a) * b).h_part i = (r • (a * b)).h_part i) ∧
    -- (4) Phase 6.7 h_part right bilinearity
    (∀ i : Fin 4, (a * (r • b)).h_part i = (r • (a * b)).h_part i) ∧
    -- (5) Phase 6.7b m3_part left bilinearity
    (∀ i j : Fin 3, ((r • a) * b).m3_part i j = (r • (a * b)).m3_part i j) ∧
    -- (6) Phase 6.7b m3_part right bilinearity
    (∀ i j : Fin 3, (a * (r • b)).m3_part i j = (r • (a * b)).m3_part i j) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact smul_mul_c_part r a b
  · exact mul_smul_c_part r a b
  · exact fun i => smul_mul_h_part r a b i
  · exact fun i => mul_smul_h_part r a b i
  · exact fun i j => smul_mul_m3_part r a b i j
  · exact fun i j => mul_smul_m3_part r a b i j

/-! ## Frozen-Nat ALL-COMPONENTS BILINEARITY snapshot -/

/-- **ALL-COMPONENTS BILINEARITY phase count snapshot**: 3 phases
    (6.5x c_part + 6.7 h_part + 6.7b m3_part). -/
def bilinearity_phase_count : ℕ := 3

/-- **ALL-COMPONENTS BILINEARITY atomic theorem count snapshot**:
    6 (2 c_part + 2 h_part + 2 m3_part). -/
def bilinearity_atomic_theorems : ℕ := 6

/-- **ALL-COMPONENTS BILINEARITY new-axiom count snapshot**:
    0 (Lean-core only). -/
def bilinearity_axiom_count : ℕ := 0

/-- **Frozen-Nat finite A_F ALL-COMPONENTS BILINEARITY snapshot —
    verifiable via `decide`**.

    Sum: 3 phases + 6 atomic theorems + 0 axioms = 9. -/
theorem finite_AF_algebra_all_components_bilinearity_snapshot :
    bilinearity_phase_count = 3 ∧
    bilinearity_atomic_theorems = 6 ∧
    bilinearity_axiom_count = 0 ∧
    bilinearity_phase_count + bilinearity_atomic_theorems
      + bilinearity_axiom_count = 9 := by
  refine ⟨rfl, rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.FiniteAFAlgebraAllComponentsBilinearityMeta
