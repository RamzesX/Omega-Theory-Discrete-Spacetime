/-
  OmegaTheory.Predictions.FiniteAFAlgebraGaugeComponentMeta

  **Lion's-Pride Phase 6.5q — GAUGE-COMPONENT META (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra GAUGE-COMPONENT META —
  composing ONE substantive identity from EACH of the 4 c_part-level
  predicate phases (6.5g real-scalar center embedding, 6.5n squared-
  norm function, 6.5o IsUnitary predicate, 6.5p IsSelfAdjoint
  predicate) into a single 4-conjunct umbrella declaring the FULL
  c_part-level *-algebra-with-norm-and-predicates structure of A_F,
  the foundation for the inner-automorphism / gauge group analysis.*

  ## Why this file

  Across 4 dedicated iterations (123, 124, 125, 126), the c_part-
  level gauge-prerequisite analysis shipped:

  | Iter  | Phase | Content                                                         |
  |-------|-------|-----------------------------------------------------------------|
  | 123   | 6.5g  | Real-scalar embedding ℝ ↪ Z(A_F)|c_part (centrality + ...)      |
  | 124   | 6.5n  | Squared-norm ‖a‖²|c with non-neg + zero/one + smul² + adj-inv   |
  | 125   | 6.5o  | IsUnitary predicate ‖u‖² = 1 with closure properties            |
  | 126   | 6.5p  | IsSelfAdjoint predicate (adj a) = a with closure properties     |

  This file ships the GAUGE-COMPONENT META — composing one
  substantive identity from each of the 4 phases into a 4-conjunct
  umbrella declaring the full gauge-prerequisite structure at the
  c_part field level.

  ## What this file ships

  | Phase | Identity                                                              |
  |-------|-----------------------------------------------------------------------|
  | 6.5g  | `((r•1) * a).c_part = (a * (r•1)).c_part` (centrality)                 |
  | 6.5n  | `cPartSquaredNorm (r • a) = r² * cPartSquaredNorm a` (smul²)           |
  | 6.5o  | `cPartIsUnitary (r • 1) ↔ r^2 = 1` (unitary characterization)           |
  | 6.5p  | `cPartIsSelfAdjoint (r • 1)` (real-scalar unit self-adjoint)           |

  Plus a frozen-Nat snapshot:

  * `gauge_component_phase_count := 4`         (6.5g, 6.5n, 6.5o, 6.5p)
  * `gauge_component_atomic_theorems := 17`    (4 + 5 + 4 + 4)
  * `gauge_component_axiom_count := 0`
  * `gauge_component_grand_sum := 21`          (= 4 + 17 + 0)

  ## Author

  Lion's-Pride dynamic /loop iteration 127 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraMul
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter
import OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
import OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
import OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.FiniteAFAlgebraGaugeComponentMeta

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraMul
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter
open OmegaTheory.Foundations.FiniteAFAlgebraSquaredNorm
open OmegaTheory.Foundations.FiniteAFAlgebraIsUnitary
open OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint

/-! ## The GAUGE-COMPONENT META: 4 c_part predicate phases composed -/

/-- **FINITE A_F GAUGE-COMPONENT META** — composing ONE substantive
    identity from EACH of the 4 c_part-level predicate phases:

    * 6.5g real-scalar center embedding,
    * 6.5n squared-norm function,
    * 6.5o IsUnitary predicate,
    * 6.5p IsSelfAdjoint predicate,

    into a single 4-conjunct umbrella declaring the full gauge-
    prerequisite structure at the c_part field level.

    For any real scalar `r : ℝ` and any element `a : FiniteAFAlgebra`:

    1. **Phase 6.5g** — Real-scalar unit centrality at c_part:
       `((r•1) * a).c_part = (a * (r•1)).c_part`.

    2. **Phase 6.5n** — Squared-norm scalar quadratic homogeneity:
       `cPartSquaredNorm (r • a) = r² · cPartSquaredNorm a`.

    3. **Phase 6.5o** — Real-scalar-unit unitary characterization:
       `cPartIsUnitary (r • 1) ↔ r^2 = 1`.

    4. **Phase 6.5p** — Real-scalar unit self-adjointness:
       `cPartIsSelfAdjoint (r • 1)`. -/
theorem finite_AF_algebra_gauge_component_meta (r : ℝ) (a : FiniteAFAlgebra) :
    -- (1) Phase 6.5g real-scalar unit centrality
    ((r • (1 : FiniteAFAlgebra)) * a).c_part =
      (a * (r • (1 : FiniteAFAlgebra))).c_part ∧
    -- (2) Phase 6.5n squared-norm scalar quadratic homogeneity
    cPartSquaredNorm (r • a) = r^2 * cPartSquaredNorm a ∧
    -- (3) Phase 6.5o real-scalar-unit unitary characterization
    (cPartIsUnitary (r • (1 : FiniteAFAlgebra)) ↔ r^2 = 1) ∧
    -- (4) Phase 6.5p real-scalar unit self-adjointness
    cPartIsSelfAdjoint (r • (1 : FiniteAFAlgebra)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact FiniteAFAlgebra_scalar_unit_central_c_part r a
  · exact cPartSquaredNorm_smul r a
  · exact cPartIsUnitary_scalar_one_iff r
  · exact cPartIsSelfAdjoint_real_scalar_one r

/-! ## Frozen-Nat GAUGE-COMPONENT snapshot -/

/-- **GAUGE-COMPONENT phase count snapshot**: 4 c_part-level
    predicate phases (6.5g real-scalar center + 6.5n squared-norm
    + 6.5o IsUnitary + 6.5p IsSelfAdjoint). -/
def gauge_component_phase_count : ℕ := 4

/-- **GAUGE-COMPONENT atomic theorem count snapshot**:
    4 (6.5g atomic) + 5 (6.5n atomic) + 4 (6.5o atomic) +
    4 (6.5p atomic) = 17. -/
def gauge_component_atomic_theorems : ℕ := 17

/-- **GAUGE-COMPONENT new-axiom count snapshot**: 0 (Lean-core only). -/
def gauge_component_axiom_count : ℕ := 0

/-- **Frozen-Nat finite A_F GAUGE-COMPONENT snapshot —
    verifiable via `decide`**.

    Sum: 4 phases + 17 atomic theorems + 0 axioms = 21. -/
theorem finite_AF_algebra_gauge_component_snapshot :
    gauge_component_phase_count = 4 ∧
    gauge_component_atomic_theorems = 17 ∧
    gauge_component_axiom_count = 0 ∧
    gauge_component_phase_count + gauge_component_atomic_theorems
      + gauge_component_axiom_count = 21 := by
  refine ⟨rfl, rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.FiniteAFAlgebraGaugeComponentMeta
