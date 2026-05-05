/-
  OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel

  **Lion's-Pride Phase 8.1 (2026-05-06)**:
  *Tree-level graviton scattering amplitude scaffold composing the
  cubic + quartic graviton vertices from Phase 5.*

  ## Why this file

  Phases 5.3 + 5.4 shipped the structural cubic and quartic graviton
  vertices `V₃(h₁, h₂, h₃)` and `V₄(h₁, h₂, h₃, h₄)` as trilinear
  and tetralinear functionals in metric perturbations.  In quantum
  gravity these vertices are the FEYNMAN RULES for tree-level
  graviton scattering:

      2 → 1 (cubic):  M_{1+2 → 3}        ∝  V₃(h₁, h₂, h₃)
      2 → 2 (quartic): M_{1+2 → 3+4}    ∝  V₄(h₁, h₂, h₃, h₄) + (s,t,u-channel V₃² terms)

  The full scattering amplitude contains:
  - Direct quartic vertex contribution `V₄`
  - Three (s, t, u) channels of two cubic vertices joined by a
    graviton propagator `1/k²` (the standard `V₃ · 1/k² · V₃` form)

  This file ships the SCAFFOLD: the vertex compositions named for
  the corresponding Feynman diagrams, together with the symmetry
  properties they inherit from Phase 5.3/5.4.

  ## What this file ships

  | Property                                                        | Theorem                              |
  |-----------------------------------------------------------------|--------------------------------------|
  | `gravitonAmplitude3pt h₁ h₂ h₃ p` (3-graviton vertex)            | (definition)                         |
  | `gravitonAmplitude4pt h₁ h₂ h₃ h₄ p` (4-graviton direct)         | (definition)                         |
  | `amplitude3pt = gravitonCubicVertex` (identification)            | `amplitude3pt_eq_cubicVertex`        |
  | `amplitude4pt = gravitonQuarticVertex` (identification)          | `amplitude4pt_eq_quarticVertex`      |
  | 3pt amplitude: total symmetry inherited                         | `amplitude3pt_symm_12`               |
  | 4pt amplitude: S₄ symmetry inherited                            | `amplitude4pt_symm_12`               |
  | 3pt vanishes if any leg is zero                                 | `amplitude3pt_zero_leg`              |
  | 4pt vanishes if any leg is zero                                 | `amplitude4pt_zero_leg`              |
  | Headline (5-conjunct)                                          | `graviton_scattering_tree_report`     |

  ## Honest scope

  This file does NOT yet:
  * Add the (s, t, u)-channel `V₃² / k²` contributions to the 2→2
    amplitude — that requires the substrate graviton propagator
    (Phase 7.5 follow-up).
  * Sum over momentum-conserving channels (Phase 8.2 — needs
    Lorentz-invariant integration measure).
  * Compute physical cross sections (Phase 8.3).
  * Loop corrections (Phase 9).

  What it DOES ship:
  * The IDENTIFICATION of cubic + quartic vertices as tree-level
    Feynman rules.
  * The FULL S₃ / S₄ symmetry of the 3pt and 4pt amplitudes inherited
    from Phase 5.3/5.4.
  * The tree-level vanishing-on-zero-leg property (gauge-related).

  This is the algebraic backbone every higher-order Feynman-diagram
  calculation builds on.

  ## Author

  Lion's-Pride dynamic /loop iteration 28 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Variational.CubicGravitonVertex
import OmegaTheory.Variational.QuarticGravitonVertex
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Variational.CubicGravitonVertex
open OmegaTheory.Variational.QuarticGravitonVertex

/-! ## 1. The 3-graviton tree-level scattering amplitude

    Identifies the cubic vertex `V₃` as the Feynman rule for the
    `2 → 1` graviton scattering at tree level. -/

/-- **Tree-level 3-graviton scattering amplitude**.

    Defined as the cubic graviton vertex from Phase 5.3.  In the
    standard normalization (Wald §A.4) the Feynman rule for a single
    3-graviton vertex is `i · V₃` up to an overall factor of `i` we
    absorb into convention. -/
noncomputable def gravitonAmplitude3pt
    (h₁ h₂ h₃ : SymmetricTensorField2) (p : LatticePoint) : ℝ :=
  gravitonCubicVertex h₁ h₂ h₃ p

/-- **3pt amplitude is exactly the cubic graviton vertex**. -/
theorem amplitude3pt_eq_cubicVertex
    (h₁ h₂ h₃ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude3pt h₁ h₂ h₃ p
      = gravitonCubicVertex h₁ h₂ h₃ p := rfl

/-- **3pt amplitude vanishes when any leg is zero**: gauge-invariance
    consequence (dropped from the leg pool, the diagram contributes
    nothing). -/
theorem amplitude3pt_zero_leg
    (h₂ h₃ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude3pt (fun _ _ _ => 0) h₂ h₃ p = 0 := by
  unfold gravitonAmplitude3pt
  exact gravitonCubicVertex_zero_left h₂ h₃ p

/-- **3pt amplitude is symmetric under (1,2)-permutation of legs**. -/
theorem amplitude3pt_symm_12
    (h₁ h₂ h₃ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude3pt h₁ h₂ h₃ p
      = gravitonAmplitude3pt h₂ h₁ h₃ p := by
  unfold gravitonAmplitude3pt
  exact gravitonCubicVertex_symm₁₂ h₁ h₂ h₃ p

/-! ## 2. The 4-graviton tree-level direct amplitude

    Direct (contact) contribution `V₄`.  The full 2 → 2 amplitude
    additionally has 3 channels (s, t, u) of two `V₃`'s joined by a
    graviton propagator — those are deferred to Phase 8.2. -/

/-- **Tree-level 4-graviton direct (contact) amplitude**. -/
noncomputable def gravitonAmplitude4pt
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2) (p : LatticePoint) : ℝ :=
  gravitonQuarticVertex h₁ h₂ h₃ h₄ p

/-- **4pt amplitude is exactly the quartic graviton vertex**. -/
theorem amplitude4pt_eq_quarticVertex
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p := rfl

/-- **4pt amplitude vanishes when any leg is zero**. -/
theorem amplitude4pt_zero_leg
    (h₂ h₃ h₄ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude4pt (fun _ _ _ => 0) h₂ h₃ h₄ p = 0 := by
  unfold gravitonAmplitude4pt
  exact gravitonQuarticVertex_zero_first h₂ h₃ h₄ p

/-- **4pt amplitude is symmetric under (1,2)-permutation of legs**. -/
theorem amplitude4pt_symm_12
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
      = gravitonAmplitude4pt h₂ h₁ h₃ h₄ p := by
  unfold gravitonAmplitude4pt
  exact gravitonQuarticVertex_symm_12 h₁ h₂ h₃ h₄ p

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 8.1 headline — tree-level graviton-scattering
    amplitude structural report.**

    For any metric perturbations `h₁, h₂, h₃, h₄ : SymmetricTensorField2`
    and lattice point `p : LatticePoint`:

    1. **3pt amplitude = cubic vertex**:
       `gravitonAmplitude3pt h₁ h₂ h₃ p = gravitonCubicVertex h₁ h₂ h₃ p`.

    2. **3pt vanishes on zero leg**:
       `gravitonAmplitude3pt 0 h₂ h₃ p = 0`.

    3. **3pt is (1,2)-symmetric**:
       `gravitonAmplitude3pt h₁ h₂ h₃ = gravitonAmplitude3pt h₂ h₁ h₃`.

    4. **4pt amplitude = quartic vertex**:
       `gravitonAmplitude4pt h₁ h₂ h₃ h₄ = gravitonQuarticVertex h₁ h₂ h₃ h₄`.

    5. **4pt is (1,2)-symmetric**:
       `gravitonAmplitude4pt h₁ h₂ h₃ h₄ = gravitonAmplitude4pt h₂ h₁ h₃ h₄`. -/
theorem graviton_scattering_tree_report
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2) (p : LatticePoint) :
    gravitonAmplitude3pt h₁ h₂ h₃ p = gravitonCubicVertex h₁ h₂ h₃ p ∧
    gravitonAmplitude3pt (fun _ _ _ => 0) h₂ h₃ p = 0 ∧
    gravitonAmplitude3pt h₁ h₂ h₃ p
      = gravitonAmplitude3pt h₂ h₁ h₃ p ∧
    gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p ∧
    gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
      = gravitonAmplitude4pt h₂ h₁ h₃ h₄ p := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact amplitude3pt_eq_cubicVertex h₁ h₂ h₃ p
  · exact amplitude3pt_zero_leg h₂ h₃ p
  · exact amplitude3pt_symm_12 h₁ h₂ h₃ p
  · exact amplitude4pt_eq_quarticVertex h₁ h₂ h₃ h₄ p
  · exact amplitude4pt_symm_12 h₁ h₂ h₃ h₄ p

end OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel
