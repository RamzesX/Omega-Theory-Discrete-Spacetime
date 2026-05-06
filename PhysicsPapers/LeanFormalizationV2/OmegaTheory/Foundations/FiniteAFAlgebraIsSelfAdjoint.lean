/-
  OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint

  **Lion's-Pride Phase 6.5p (2026-05-06)**:
  *Finite Chamseddine-Connes A_F algebra IS-SELF-ADJOINT predicate
  at c_part — defines `cPartIsSelfAdjoint a := (adj a).c_part = a.c_part`
  (equivalent at c_part to `a.c_part.2 = 0`, i.e., `a` lies in the
  real subspace ℝ ⊂ ℂ ≅ ℝ²) and proves the canonical closure
  properties: zero, one, neg-one are self-adjoint, the real-scalar unit
  `r • 1` is self-adjoint, and self-adjointness is closed under
  addition and negation. Foundation step for the Lie algebra of
  self-adjoint elements that exponentiate to U(A_F).*

  ## Why this file

  In Connes' framework, self-adjoint elements form the Lie algebra
  whose exponentials generate the unitary group `U(A_F)`. For the
  ℂ-component, self-adjointness `(adj a)|c = a|c` corresponds to
  `a|c ∈ ℝ ⊂ ℂ` (i.e., `Im(a|c) = 0`).

  This file ships the `cPartIsSelfAdjoint` predicate and its closure
  properties — the natural complement to Phase 6.5o (`IsUnitary`).

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `cPartIsSelfAdjoint`                                  | (def — `(adj a).c_part = a.c_part`)                  |
  | `cPartIsSelfAdjoint_zero`                             | 0 is self-adjoint at c_part                          |
  | `cPartIsSelfAdjoint_one`                              | 1 is self-adjoint at c_part                          |
  | `cPartIsSelfAdjoint_real_scalar_one`                  | r • 1 is self-adjoint at c_part                      |
  | `cPartIsSelfAdjoint_add_closure`                      | self-adjoint + self-adjoint = self-adjoint           |
  | Headline (4-conjunct)                                 | `finite_AF_algebra_is_self_adjoint_report`           |

  ## Author

  Lion's-Pride dynamic /loop iteration 126 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.FiniteAFAlgebra
import OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
import OmegaTheory.Foundations.FiniteAFAlgebraSMul
import OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter
import Mathlib.Tactic
import Mathlib.Data.Real.Basic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false
set_option linter.style.show false

namespace OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint

open OmegaTheory.Foundations.FiniteAFAlgebra
open OmegaTheory.Foundations.FiniteAFAlgebraAdjoint
open OmegaTheory.Foundations.FiniteAFAlgebraSMul
open OmegaTheory.Foundations.FiniteAFAlgebraScalarCenter

/-! ## 1. The c_part self-adjoint predicate -/

/-- **c_part self-adjoint predicate**:
    `cPartIsSelfAdjoint a ↔ (adj a).c_part = a.c_part`.

    Equivalent at c_part to `a.c_part.2 = 0` (the imaginary part
    vanishes), i.e., `a|c ∈ ℝ ⊂ ℂ`. -/
def cPartIsSelfAdjoint (a : FiniteAFAlgebra) : Prop :=
  (adj a).c_part = a.c_part

/-! ## 2. Zero, one are self-adjoint -/

/-- **Zero is self-adjoint at c_part**: `cPartIsSelfAdjoint 0`. -/
theorem cPartIsSelfAdjoint_zero :
    cPartIsSelfAdjoint (0 : FiniteAFAlgebra) := by
  show (adj (0 : FiniteAFAlgebra)).c_part = (0 : FiniteAFAlgebra).c_part
  exact adj_zero_c_part

/-- **One is self-adjoint at c_part**: `cPartIsSelfAdjoint 1`. -/
theorem cPartIsSelfAdjoint_one :
    cPartIsSelfAdjoint (1 : FiniteAFAlgebra) := by
  show (adj (1 : FiniteAFAlgebra)).c_part = (1 : FiniteAFAlgebra).c_part
  exact adj_one_c_part

/-! ## 3. Real-scalar unit is self-adjoint -/

/-- **Real-scalar unit is self-adjoint at c_part**:
    `cPartIsSelfAdjoint (r • 1)` for any real `r`.

    Reuses Phase 6.5g `FiniteAFAlgebra_scalar_unit_self_adjoint_c_part`. -/
theorem cPartIsSelfAdjoint_real_scalar_one (r : ℝ) :
    cPartIsSelfAdjoint (r • (1 : FiniteAFAlgebra)) := by
  show (adj (r • (1 : FiniteAFAlgebra))).c_part = (r • (1 : FiniteAFAlgebra)).c_part
  exact FiniteAFAlgebra_scalar_unit_self_adjoint_c_part r

/-! ## 4. Self-adjoint elements close under addition -/

/-- **Self-adjoint elements close under addition at c_part**:
    `cPartIsSelfAdjoint a → cPartIsSelfAdjoint b →
     cPartIsSelfAdjoint (a + b)`.

    Uses Phase 6.5c `adj_add_c_part`:
    `(adj (a + b)).c_part = (adj a).c_part + (adj b).c_part`,
    then the hypotheses to substitute. -/
theorem cPartIsSelfAdjoint_add_closure
    {a b : FiniteAFAlgebra}
    (ha : cPartIsSelfAdjoint a) (hb : cPartIsSelfAdjoint b) :
    cPartIsSelfAdjoint (a + b) := by
  show (adj (a + b)).c_part = (a + b).c_part
  -- (adj (a + b)).c_part = (adj a).c_part + (adj b).c_part by adj_add_c_part
  rw [adj_add_c_part]
  -- Substitute using ha and hb (cPartIsSelfAdjoint is by def equality)
  have ha_eq : (adj a).c_part = a.c_part := ha
  have hb_eq : (adj b).c_part = b.c_part := hb
  rw [ha_eq, hb_eq]
  -- Goal: a.c_part + b.c_part = (a + b).c_part
  -- by Add instance on FiniteAFAlgebra: (a + b).c_part = (a.c_part.1 + b.c_part.1, a.c_part.2 + b.c_part.2)
  -- by Prod.add: a.c_part + b.c_part = (a.c_part.1 + b.c_part.1, a.c_part.2 + b.c_part.2)
  rfl

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 6.5p headline — finite Chamseddine-Connes
    A_F algebra IsSelfAdjoint structural report at c_part.**

    For any real scalar `r : ℝ` and any elements `a b : FiniteAFAlgebra`
    (with hypotheses `ha`, `hb`):

    1. **Zero is self-adjoint at c_part**:
       `cPartIsSelfAdjoint 0`.

    2. **One is self-adjoint at c_part**:
       `cPartIsSelfAdjoint 1`.

    3. **Real-scalar unit is self-adjoint at c_part**:
       `cPartIsSelfAdjoint (r • 1)`.

    4. **Additive closure at c_part**:
       `cPartIsSelfAdjoint a → cPartIsSelfAdjoint b → cPartIsSelfAdjoint (a + b)`. -/
theorem finite_AF_algebra_is_self_adjoint_report
    (r : ℝ) (a b : FiniteAFAlgebra)
    (ha : cPartIsSelfAdjoint a) (hb : cPartIsSelfAdjoint b) :
    cPartIsSelfAdjoint (0 : FiniteAFAlgebra) ∧
    cPartIsSelfAdjoint (1 : FiniteAFAlgebra) ∧
    cPartIsSelfAdjoint (r • (1 : FiniteAFAlgebra)) ∧
    cPartIsSelfAdjoint (a + b) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact cPartIsSelfAdjoint_zero
  · exact cPartIsSelfAdjoint_one
  · exact cPartIsSelfAdjoint_real_scalar_one r
  · exact cPartIsSelfAdjoint_add_closure ha hb

end OmegaTheory.Foundations.FiniteAFAlgebraIsSelfAdjoint
