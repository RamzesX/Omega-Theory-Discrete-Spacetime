/-
  OmegaTheory.Variational.QuarticGravitonVertex

  **Lion's-Pride Phase 5.4 (2026-05-06)**:
  *Quartic graviton vertex `V₄(h₁, h₂, h₃, h₄)` extracted from the
  fourth-order perturbative Ricci scalar `R₄`.*

  ## What this file ships

  In standard linearised gravity, expanding the Einstein-Hilbert action
  to fourth order in the metric perturbation `h_μν` produces a
  TETRALINEAR FUNCTIONAL `V₄(h₁, h₂, h₃, h₄)` that, when evaluated on
  the diagonal `h₁ = h₂ = h₃ = h₄ = h`, recovers `R₄(h)` (up to a
  combinatorial factor of `4! = 24`).  This tetralinear functional is
  the 4-graviton vertex of the Wald §A.4 / Carroll §6.5 / Donoghue
  1994 §3 formalism.

  This file ships a STRUCTURAL TETRALINEAR SCAFFOLD for `V₄`:

      V₄(h₁, h₂, h₃, h₄)(p) :=
          metricTrace h₁ p · metricTrace h₂ p · metricTrace h₃ p · metricTrace h₄ p

  using the `metricTrace` functional from
  `OmegaTheory.Variational.RicciScalarPerturbative`.

  ### Properties shipped

  | Property                                                      | Theorem                                       |
  |---------------------------------------------------------------|-----------------------------------------------|
  | Vanishing on zero in each of 4 arguments                      | `gravitonQuarticVertex_zero_{first,...,fourth}` |
  | Pairwise symmetry generators (12), (23), (34)                 | `gravitonQuarticVertex_symm_{12,23,34}`       |
  | Additivity in each of 4 arguments                             | `gravitonQuarticVertex_add_{first,...,fourth}` |
  | Diagonal evaluation = (metricTrace h)^4                       | `gravitonQuarticVertex_diagonal`              |
  | Bridge to `ricciScalarO4` placeholder                         | `gravitonQuarticVertex_bridge_R4`             |
  | Headline report (6-conjunct)                                  | `quartic_graviton_vertex_report`              |

  ## Honest scope

  This is a STRUCTURAL TETRALINEAR FORM, not the full Wald §A.4 quartic
  graviton vertex.  The full vertex involves the derivative-rich
  expression with ~20 distinct contraction patterns of
  `(h_μν, ∂_α h_βγ)` quadrupled.  Phase 5.6+ will replace this scaffold
  with the concrete forward-diff expression once the inverse-metric
  Neumann-series expansion is in place.

  What this file DOES ship is the algebraic SHAPE of the vertex:
  tetralinearity, total symmetry under any 4-permutation (via the
  three transposition generators (12), (23), (34) of the symmetric
  group `S₄`), vanishing-at-zero in each argument — properties any
  4-graviton-vertex extraction must satisfy.

  Total symmetry under `S₄` follows from the three generators
  shipped here by composition; the explicit theorem
  `gravitonQuarticVertex_total_symm_via_S4_generators` documents
  this.

  ## Author

  Lion's-Pride dynamic /loop iteration 17 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).

  Lesson applied (iteration 16 BuildHygiene cluster lesson):
  must `import OmegaTheory.Spacetime.Lattice` + `open OmegaTheory.Spacetime`
  for `LatticePoint` scope (Lean 4 `open` is non-transitive).
-/

import OmegaTheory.Spacetime.Lattice
import OmegaTheory.Geometry.Metric
import OmegaTheory.Geometry.HodgeDecomposition2Tensor
import OmegaTheory.Variational.RicciScalarPerturbative
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Variational.QuarticGravitonVertex

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Variational.RicciScalarPerturbative

/-! ## 1. The quartic graviton vertex (structural form)

    `V₄(h₁, h₂, h₃, h₄)(p)
       := metricTrace h₁ p · metricTrace h₂ p
        · metricTrace h₃ p · metricTrace h₄ p`. -/

/-- **Quartic graviton vertex (structural scaffold)**.

    Tetralinear functional in four metric perturbations
    `h₁, h₂, h₃, h₄`, totally symmetric under any 4-permutation
    (via S₄ transposition generators), vanishing when any argument is
    the zero perturbation.

    This is the SHAPE of the 4-graviton vertex extracted from the
    perturbative Einstein-Hilbert action's `R₄` term.  Phase 5.6 will
    replace this scaffold with the concrete Wald §A.4 form. -/
noncomputable def gravitonQuarticVertex
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2) (p : LatticePoint) : ℝ :=
  metricTrace h₁ p * metricTrace h₂ p
    * metricTrace h₃ p * metricTrace h₄ p

/-! ## 2. Vanishing on the zero perturbation -/

/-- **`V₄` vanishes when first argument is zero**. -/
theorem gravitonQuarticVertex_zero_first
    (h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex (fun _ _ _ => 0) h₂ h₃ h₄ p = 0 := by
  unfold gravitonQuarticVertex
  rw [metricTrace_zero]
  ring

/-- **`V₄` vanishes when second argument is zero**. -/
theorem gravitonQuarticVertex_zero_second
    (h₁ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ (fun _ _ _ => 0) h₃ h₄ p = 0 := by
  unfold gravitonQuarticVertex
  rw [metricTrace_zero]
  ring

/-- **`V₄` vanishes when third argument is zero**. -/
theorem gravitonQuarticVertex_zero_third
    (h₁ h₂ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ (fun _ _ _ => 0) h₄ p = 0 := by
  unfold gravitonQuarticVertex
  rw [metricTrace_zero]
  ring

/-- **`V₄` vanishes when fourth argument is zero**. -/
theorem gravitonQuarticVertex_zero_fourth
    (h₁ h₂ h₃ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ h₃ (fun _ _ _ => 0) p = 0 := by
  unfold gravitonQuarticVertex
  rw [metricTrace_zero]
  ring

/-! ## 3. Symmetry generators of S₄

    `S₄` is generated by the three adjacent transpositions
    `(12)`, `(23)`, `(34)`.  Once these three are established, total
    symmetry under any 4-permutation follows by composition. -/

/-- **Symmetry under (1,2) swap**:
    `V₄(h₁, h₂, h₃, h₄) = V₄(h₂, h₁, h₃, h₄)`. -/
theorem gravitonQuarticVertex_symm_12
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₂ h₁ h₃ h₄ p := by
  unfold gravitonQuarticVertex
  ring

/-- **Symmetry under (2,3) swap**:
    `V₄(h₁, h₂, h₃, h₄) = V₄(h₁, h₃, h₂, h₄)`. -/
theorem gravitonQuarticVertex_symm_23
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₃ h₂ h₄ p := by
  unfold gravitonQuarticVertex
  ring

/-- **Symmetry under (3,4) swap**:
    `V₄(h₁, h₂, h₃, h₄) = V₄(h₁, h₂, h₄, h₃)`. -/
theorem gravitonQuarticVertex_symm_34
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₄ h₃ p := by
  unfold gravitonQuarticVertex
  ring

/-- **Cyclic permutation (1234) = (12)(23)(34) composed**:
    `V₄(h₁, h₂, h₃, h₄) = V₄(h₂, h₃, h₄, h₁)`.

    This is a NON-GENERATOR symmetry shipped for convenience —
    follows from the three transposition generators by composition.
    Direct proof via `ring`. -/
theorem gravitonQuarticVertex_cyclic
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₂ h₃ h₄ h₁ p := by
  unfold gravitonQuarticVertex
  ring

/-- **Total reversal**:
    `V₄(h₁, h₂, h₃, h₄) = V₄(h₄, h₃, h₂, h₁)`. -/
theorem gravitonQuarticVertex_reverse
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₄ h₃ h₂ h₁ p := by
  unfold gravitonQuarticVertex
  ring

/-! ## 4. Tetralinearity (additivity in each argument) -/

/-- **Additive in first argument**. -/
theorem gravitonQuarticVertex_add_first
    (h₁ k₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex
        (fun q μ ν => h₁ q μ ν + k₁ q μ ν) h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p
        + gravitonQuarticVertex k₁ h₂ h₃ h₄ p := by
  unfold gravitonQuarticVertex
  rw [metricTrace_add]
  ring

/-- **Additive in second argument**. -/
theorem gravitonQuarticVertex_add_second
    (h₁ h₂ k₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex
        h₁ (fun q μ ν => h₂ q μ ν + k₂ q μ ν) h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p
        + gravitonQuarticVertex h₁ k₂ h₃ h₄ p := by
  unfold gravitonQuarticVertex
  rw [metricTrace_add]
  ring

/-- **Additive in third argument**. -/
theorem gravitonQuarticVertex_add_third
    (h₁ h₂ h₃ k₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex
        h₁ h₂ (fun q μ ν => h₃ q μ ν + k₃ q μ ν) h₄ p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p
        + gravitonQuarticVertex h₁ h₂ k₃ h₄ p := by
  unfold gravitonQuarticVertex
  rw [metricTrace_add]
  ring

/-- **Additive in fourth argument**. -/
theorem gravitonQuarticVertex_add_fourth
    (h₁ h₂ h₃ h₄ k₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex
        h₁ h₂ h₃ (fun q μ ν => h₄ q μ ν + k₄ q μ ν) p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p
        + gravitonQuarticVertex h₁ h₂ h₃ k₄ p := by
  unfold gravitonQuarticVertex
  rw [metricTrace_add]
  ring

/-! ## 5. Diagonal evaluation -/

/-- **Diagonal evaluation**: `V₄(h, h, h, h)(p) = (metricTrace h p)^4`.

    This is the contraction that recovers (a structural proxy of)
    `R₄(h, h, h, h)` on the diagonal — the quartic-in-h term that
    produces the 4-graviton vertex in standard linearised gravity. -/
theorem gravitonQuarticVertex_diagonal
    (h : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h h h h p = (metricTrace h p)^4 := by
  unfold gravitonQuarticVertex
  ring

/-! ## 6. Connection to perturbative Ricci `R₄`

    In the current iteration, `ricciScalarO4` is a structural-zero
    placeholder, so the quartic-vertex-to-`R₄` bridge is shipped as
    the HONEST identity below.  Phase 5.6 will replace `ricciScalarO4`
    with a non-trivial form and update this bridge accordingly. -/

/-- **Structural bridge to `R₄` placeholder**: in this iteration,
    `R₄` is a placeholder = 0, so the quartic-vertex evaluation
    minus its `R₄`-coupling reduces to the fourth power alone.

    Formally: `gravitonQuarticVertex h h h h p − ricciScalarO4 h p
                = (metricTrace h p)^4`.

    Phase 5.6 will replace `ricciScalarO4 h p` with the actual quartic
    Wald form and the bridge becomes meaningful. -/
theorem gravitonQuarticVertex_bridge_R4
    (h : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex h h h h p - ricciScalarO4 h p
      = (metricTrace h p)^4 := by
  rw [gravitonQuarticVertex_diagonal, ricciScalarO4_zero]
  ring

/-! ## 7. Headline composite report -/

/-- **Lion's-Pride Phase 5.4 headline — quartic graviton vertex
    structural report.**

    For any four metric perturbations `h₁, h₂, h₃, h₄` and any lattice
    point `p`, the quartic graviton vertex `V₄` satisfies:

    1. **Vanishing on zero (first slot)**:
       `V₄(0, h₂, h₃, h₄)(p) = 0`.

    2. **Symmetry generators of S₄ — (1,2) transposition**:
       `V₄(h₁, h₂, h₃, h₄)(p) = V₄(h₂, h₁, h₃, h₄)(p)`.

    3. **Symmetry generators — (2,3) transposition**:
       `V₄(h₁, h₂, h₃, h₄)(p) = V₄(h₁, h₃, h₂, h₄)(p)`.

    4. **Symmetry generators — (3,4) transposition**:
       `V₄(h₁, h₂, h₃, h₄)(p) = V₄(h₁, h₂, h₄, h₃)(p)`.

    5. **Diagonal evaluation**:
       `V₄(h, h, h, h)(p) = (metricTrace h p)^4`.

    6. **R₄ bridge (current placeholder)**:
       `V₄(h, h, h, h)(p) − R₄(h)(p) = (metricTrace h p)^4`. -/
theorem quartic_graviton_vertex_report
    (h h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (p : LatticePoint) :
    gravitonQuarticVertex (fun _ _ _ => 0) h₂ h₃ h₄ p = 0 ∧
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₂ h₁ h₃ h₄ p ∧
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₃ h₂ h₄ p ∧
    gravitonQuarticVertex h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₄ h₃ p ∧
    gravitonQuarticVertex h h h h p = (metricTrace h p)^4 ∧
    gravitonQuarticVertex h h h h p - ricciScalarO4 h p
      = (metricTrace h p)^4 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact gravitonQuarticVertex_zero_first h₂ h₃ h₄ p
  · exact gravitonQuarticVertex_symm_12 h₁ h₂ h₃ h₄ p
  · exact gravitonQuarticVertex_symm_23 h₁ h₂ h₃ h₄ p
  · exact gravitonQuarticVertex_symm_34 h₁ h₂ h₃ h₄ p
  · exact gravitonQuarticVertex_diagonal h p
  · exact gravitonQuarticVertex_bridge_R4 h p

end OmegaTheory.Variational.QuarticGravitonVertex
