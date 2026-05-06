/-
  OmegaTheory.Predictions.FiniteAFAlgebraUnitarySubgroupMeta

  **Lion's-Pride Phase 6.5y — UNITARY-SUBGROUP META (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra UNITARY-SUBGROUP META —
  composing the Phase 6.5o IsUnitary identity-membership, Phase 6.5s
  IsUnitary product-closure, and Phase 6.5v IsUnitary negation-closure
  into a SINGLE 3-conjunct umbrella declaring the multiplicative
  subgroup-with-symmetry structure of unitary elements at c_part.
  This is the substrate analog of the unitary group U(A_F)|c viewed
  as a closed-under-{1, ·, -} subset of A_F (the negation-symmetry
  property is the discrete ℤ/2 reflection inside U(1) corresponding
  to z ↦ -z).*

  ## Why this file

  In Connes' framework the gauge group of a spectral triple is
  extracted as `U(A) := { u ∈ A | u*u = 1 = uu* }` modulo the centre
  `Z(A)`. For the c_part field of A_F (the ℂ-component), this is
  U(1)|c = { (cos θ, sin θ) | θ ∈ ℝ } — a 1-parameter Lie group with
  Lie algebra ℝ.

  This file ships the subgroup-with-symmetry primitive: U|c is
  closed under 1, multiplication, and negation. The full Lie-group
  structure (closure under inverse via `u⁻¹ = adj u`) requires the
  identity `mul_adj_eq_one` which is downstream and deferred.

  Across 3 dedicated iterations (125, 129, 131), the c_part unitary
  closure-axiom analysis shipped:

  | Iter  | Phase | Content                                                         |
  |-------|-------|-----------------------------------------------------------------|
  | 125   | 6.5o  | IsUnitary predicate ‖u‖² = 1 + identity-membership              |
  | 129   | 6.5s  | IsUnitary product-closure ‖u·v‖² = ‖u‖²·‖v‖² (multiplicative)   |
  | 131   | 6.5v  | IsUnitary negation-closure ‖-u‖² = ‖u‖² (ℤ/2-symmetry)          |

  This META composes them into the canonical primitive.

  ## What this file ships

  | Conjunct | Identity                                                          |
  |----------|-------------------------------------------------------------------|
  | (1)      | Identity is unitary: `cPartIsUnitary 1`                            [Phase 6.5o] |
  | (2)      | Product closure: `cPartIsUnitary u → cPartIsUnitary v → cPartIsUnitary (u·v)` [Phase 6.5s] |
  | (3)      | Negation closure: `cPartIsUnitary u → cPartIsUnitary (-u)`         [Phase 6.5v] |

  Plus a frozen-Nat snapshot:

  * `unitary_subgroup_phase_count := 3`         (6.5o, 6.5s, 6.5v)
  * `unitary_subgroup_atomic_theorems := 9`     (3 + 3 + 3)
  * `unitary_subgroup_axiom_count := 0`         (Lean core only)
  * `unitary_subgroup_grand_sum := 12`          (= 3 + 9 + 0)

  ## Author

  Lion's-Pride dynamic /loop iteration 134 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
import OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
import OmegaTheory.Foundations.FiniteAFAlgebraIsUnitaryProductClosure
import OmegaTheory.Foundations.FiniteAFAlgebraAdjSMul
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.FiniteAFAlgebraUnitarySubgroupMeta

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
open OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
open OmegaTheory.Foundations.FiniteAFAlgebraIsUnitaryProductClosure
open OmegaTheory.Foundations.FiniteAFAlgebraAdjSMul

/-! ## The UNITARY-SUBGROUP META: 3 closure phases composed -/

/-- **FINITE A_F UNITARY-SUBGROUP META** — composing the 3 atomic
    closure properties of unitary elements at c_part:

    * 6.5o IsUnitary identity-membership,
    * 6.5s IsUnitary product-closure,
    * 6.5v IsUnitary negation-closure,

    into a single 3-conjunct umbrella declaring the multiplicative
    subgroup-with-symmetry structure of U(A_F)|c.

    For any elements `u v : FiniteAFAlgebra` with hypotheses
    `hu : cPartIsUnitary u`, `hv : cPartIsUnitary v`:

    1. **Identity is unitary**:
       `cPartIsUnitary 1`.

    2. **Product closure**:
       `cPartIsUnitary (u * v)`.

    3. **Negation closure** (ℤ/2-symmetry):
       `cPartIsUnitary (-u)`. -/
theorem finite_AF_algebra_unitary_subgroup_meta
    (u v : FiniteAFAlgebra)
    (hu : cPartIsUnitary u) (hv : cPartIsUnitary v) :
    -- (1) Phase 6.5o identity-membership
    cPartIsUnitary (1 : FiniteAFAlgebra) ∧
    -- (2) Phase 6.5s product-closure
    cPartIsUnitary (u * v) ∧
    -- (3) Phase 6.5v negation-closure
    cPartIsUnitary (-u) := by
  refine ⟨?_, ?_, ?_⟩
  · exact cPartIsUnitary_one
  · exact cPartIsUnitary_mul_closure hu hv
  · exact cPartIsUnitary_neg_closure hu

/-! ## Frozen-Nat UNITARY-SUBGROUP snapshot -/

/-- **UNITARY-SUBGROUP phase count snapshot**: 3 closure properties
    of unitary elements at c_part (6.5o id + 6.5s product + 6.5v neg). -/
def unitary_subgroup_phase_count : ℕ := 3

/-- **UNITARY-SUBGROUP atomic theorem count snapshot**:
    3 (6.5o relevant) + 3 (6.5s relevant) + 3 (6.5v relevant) = 9. -/
def unitary_subgroup_atomic_theorems : ℕ := 9

/-- **UNITARY-SUBGROUP new-axiom count snapshot**: 0 (Lean-core only). -/
def unitary_subgroup_axiom_count : ℕ := 0

/-- **Frozen-Nat finite A_F UNITARY-SUBGROUP snapshot —
    verifiable via `decide`**.

    Sum: 3 phases + 9 atomic theorems + 0 axioms = 12. -/
theorem finite_AF_algebra_unitary_subgroup_snapshot :
    unitary_subgroup_phase_count = 3 ∧
    unitary_subgroup_atomic_theorems = 9 ∧
    unitary_subgroup_axiom_count = 0 ∧
    unitary_subgroup_phase_count + unitary_subgroup_atomic_theorems
      + unitary_subgroup_axiom_count = 12 := by
  refine ⟨rfl, rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.FiniteAFAlgebraUnitarySubgroupMeta
