/-
  OmegaTheory.Foundations.CKMRowOneUnitarity

  **Lion's-Pride Phase 6.5w (2026-05-06)**:
  *First-row unitarity of the standard CKM parametrization,
  proved unconditionally — closes the "Conditional unitarity:
  hypothesis" gap in `Emergence/CKMMatrix.lean`.*

  ## Why this file

  Audit of `Emergence/CKMMatrix.lean` (line 148-151): file admits

      "Conditional unitarity: we assert the standard CKM parametrization
       is unitary as a hypothesis. Future work can establish this by
       direct computation."

  This is an honest gap. The first-row unitarity — namely

      |V_ud|² + |V_us|² + |V_ub|² = 1

  — is a STRUCTURAL identity that follows from `cos² + sin² = 1`
  alone, with no dependence on the PDG numerical angles or the CP
  phase δ.  Proving it here closes the most accessible piece of the
  unitarity gap.

  ## What this file ships

  Real algebraic verification:

  | Property                                      | Theorem                              |
  |-----------------------------------------------|--------------------------------------|
  | `|V_ud|² = c12² · c13²`                       | (norm-sq of `(0,0)` entry)            |
  | `|V_us|² = s12² · c13²`                       | (norm-sq of `(0,1)` entry)            |
  | `|V_ub|² = s13²`                              | (norm-sq of `(0,2)` entry, |e^{-iδ}|=1)|
  | Row-1 unitarity sum = 1                        | `ckm_row1_unitarity_sum`             |
  | Column-3 unitarity sum = 1                     | `ckm_col3_unitarity_sum`             |
  | Headline                                       | `ckm_row1_col3_unitarity_grand`      |

  ## Honest scope

  This file ships ROW-1 + COLUMN-3 unitarity (two of six unitarity
  equations from `V V† = I`).  It does NOT ship full CKM unitarity
  (rows 2,3 + columns 1,2 + 6 off-diagonal vanishings).  The
  remaining 4 unitarity equations involve 4-term entries with phase-
  mixing and require longer expansions.

  What it DOES ship: the simplest, structurally-cleanest pieces of
  CKM unitarity — derived from `Real.cos_sq_add_sin_sq` plus
  `Complex.norm_exp_I_mul_ofReal` (|e^{iθ}| = 1).

  ## Lion's-Pride doctrine applied

  Rule 1: zero `sorry`.  Rule 2: zero new axioms.
  Pure trigonometric identity verification.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.Emergence.CKMMatrix
import Mathlib.Analysis.Complex.Norm
import Mathlib.Analysis.Complex.Trigonometric
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Foundations.CKMRowOneUnitarity

open Complex
open OmegaTheory.Emergence

/-! ## 1. Norm-squared of the (0,0), (0,1), (0,2) entries

    The standard CKM parametrization defines
      V_ud := c12 c13                  (entry [0,0])
      V_us := s12 c13                  (entry [0,1])
      V_ub := s13 · exp(-iδ)           (entry [0,2])

    We compute their complex norm-squares. -/

/-- **Norm² of V_ud**: `|c12 c13|² = c12² · c13²`. -/
theorem ckm_V00_normsq (a : CKMAngles) :
    Complex.normSq (ckmStandard a 0 0) =
      (Real.cos a.theta12) ^ 2 * (Real.cos a.theta13) ^ 2 := by
  unfold ckmStandard
  rw [Complex.normSq_mul, Complex.normSq_ofReal, Complex.normSq_ofReal]
  ring

/-- **Norm² of V_us**: `|s12 c13|² = s12² · c13²`. -/
theorem ckm_V01_normsq (a : CKMAngles) :
    Complex.normSq (ckmStandard a 0 1) =
      (Real.sin a.theta12) ^ 2 * (Real.cos a.theta13) ^ 2 := by
  unfold ckmStandard
  rw [Complex.normSq_mul, Complex.normSq_ofReal, Complex.normSq_ofReal]
  ring

/-- **Norm² of V_ub**: `|s13 · exp(-iδ)|² = s13²` (the phase factor
    has unit modulus). -/
theorem ckm_V02_normsq (a : CKMAngles) :
    Complex.normSq (ckmStandard a 0 2) = (Real.sin a.theta13) ^ 2 := by
  unfold ckmStandard
  rw [Complex.normSq_mul, Complex.normSq_ofReal]
  -- goal: Real.sin a.theta13 * Real.sin a.theta13 * normSq(cexp(-(I*δ))) = sin²
  have h_normsq_one :
      Complex.normSq (Complex.exp (-(Complex.I * (a.deltaCP : ℂ)))) = 1 := by
    rw [show -(Complex.I * (a.deltaCP : ℂ)) = Complex.I * ((-a.deltaCP : ℝ) : ℂ) by
        push_cast; ring]
    rw [Complex.normSq_eq_norm_sq]
    rw [Complex.norm_exp_I_mul_ofReal]
    norm_num
  rw [h_normsq_one]
  ring

/-! ## 2. Row-1 unitarity sum

    `Σ_j |V_0j|² = c12² c13² + s12² c13² + s13²
                = c13² (c12² + s12²) + s13²
                = c13² · 1 + s13²
                = c13² + s13²
                = 1`. -/

/-- **First-row unitarity sum**: `|V_ud|² + |V_us|² + |V_ub|² = 1`.

    Proof: factor out `c13²` from the first two terms, use
    `c12² + s12² = 1`, then `c13² + s13² = 1`. -/
theorem ckm_row1_unitarity_sum (a : CKMAngles) :
    Complex.normSq (ckmStandard a 0 0) +
    Complex.normSq (ckmStandard a 0 1) +
    Complex.normSq (ckmStandard a 0 2) = 1 := by
  rw [ckm_V00_normsq, ckm_V01_normsq, ckm_V02_normsq]
  -- Goal: c12²·c13² + s12²·c13² + s13² = 1
  have h12 : (Real.cos a.theta12) ^ 2 + (Real.sin a.theta12) ^ 2 = 1 :=
    Real.cos_sq_add_sin_sq a.theta12
  have h13 : (Real.cos a.theta13) ^ 2 + (Real.sin a.theta13) ^ 2 = 1 :=
    Real.cos_sq_add_sin_sq a.theta13
  nlinarith [h12, h13]

/-! ## 3. Right-column unitarity (the third column)

    Column-2 (V_ub, V_cb, V_tb) has |V_ub|² = s13², |V_cb|² = s23² c13²,
    |V_tb|² = c23² c13². Sum = s13² + c13²(s23² + c23²) = 1.

    This is structurally as clean as row 1 and a useful companion. -/

/-- **Norm² of V_cb (entry [1,2])**: `|s23 c13|² = s23² · c13²`. -/
theorem ckm_V12_normsq (a : CKMAngles) :
    Complex.normSq (ckmStandard a 1 2) =
      (Real.sin a.theta23) ^ 2 * (Real.cos a.theta13) ^ 2 := by
  unfold ckmStandard
  rw [Complex.normSq_mul, Complex.normSq_ofReal, Complex.normSq_ofReal]
  ring

/-- **Norm² of V_tb (entry [2,2])**: `|c23 c13|² = c23² · c13²`. -/
theorem ckm_V22_normsq (a : CKMAngles) :
    Complex.normSq (ckmStandard a 2 2) =
      (Real.cos a.theta23) ^ 2 * (Real.cos a.theta13) ^ 2 := by
  unfold ckmStandard
  rw [Complex.normSq_mul, Complex.normSq_ofReal, Complex.normSq_ofReal]
  ring

/-- **Third-column unitarity sum**: `|V_ub|² + |V_cb|² + |V_tb|² = 1`. -/
theorem ckm_col3_unitarity_sum (a : CKMAngles) :
    Complex.normSq (ckmStandard a 0 2) +
    Complex.normSq (ckmStandard a 1 2) +
    Complex.normSq (ckmStandard a 2 2) = 1 := by
  rw [ckm_V02_normsq, ckm_V12_normsq, ckm_V22_normsq]
  -- Goal: s13² + s23²·c13² + c23²·c13² = 1
  have h23 : (Real.cos a.theta23) ^ 2 + (Real.sin a.theta23) ^ 2 = 1 :=
    Real.cos_sq_add_sin_sq a.theta23
  have h13 : (Real.cos a.theta13) ^ 2 + (Real.sin a.theta13) ^ 2 = 1 :=
    Real.cos_sq_add_sin_sq a.theta13
  nlinarith [h23, h13]

/-! ## 4. Composite headline — both row and column unitarity -/

/-- **Lion's-Pride Phase 6.5w GRAND headline** — first-row + third-column
    CKM unitarity.

    Two of the six unitarity equations of `V V† = I` are unconditional:

    1. **Row-1 unitarity**: |V_ud|² + |V_us|² + |V_ub|² = 1.
       (light-quark mass-eigenstate normalization)

    2. **Column-3 unitarity**: |V_ub|² + |V_cb|² + |V_tb|² = 1.
       (b-quark weak-eigenstate normalization)

    These are the two cleanest entries because they avoid the
    4-term phase-mixing entries V_(1,0), V_(1,1), V_(2,0), V_(2,1)
    that involve `e^{iδ}` cross-terms.  The remaining 4 unitarity
    equations (rows 2,3 + columns 1,2 + 6 off-diagonal vanishings)
    require longer expansions of those 4-term entries. -/
theorem ckm_row1_col3_unitarity_grand (a : CKMAngles) :
    Complex.normSq (ckmStandard a 0 0) +
      Complex.normSq (ckmStandard a 0 1) +
      Complex.normSq (ckmStandard a 0 2) = 1 ∧
    Complex.normSq (ckmStandard a 0 2) +
      Complex.normSq (ckmStandard a 1 2) +
      Complex.normSq (ckmStandard a 2 2) = 1 := by
  exact ⟨ckm_row1_unitarity_sum a, ckm_col3_unitarity_sum a⟩

end OmegaTheory.Foundations.CKMRowOneUnitarity
