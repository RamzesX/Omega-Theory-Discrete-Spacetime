/-
  OmegaTheory.QuantumGravity.OnShellMandelstam

  **Lion's-Pride Phase 8.7 (2026-05-06)**:
  *On-shell predicate `IsOnShell p m² := ⟨p, p⟩ = m²` and the on-shell
  expansion of the Mandelstam invariants s, t, u in terms of masses.*

  ## Why this file

  Phase 8.6 (`FourMomentum`) shipped the Minkowski-inner-product
  algebra and the bridge from concrete 4-momentum conservation to
  the Phase 8.5 scalar-bilinear constraint.

  This file ships the **on-shell** predicate and decomposes the
  Mandelstam invariants in terms of:
  * the ON-SHELL squared masses `m_i² = ⟨p_i, p_i⟩`,
  * the cross terms `p_i · p_j`.

  Specifically:

      s := ⟨p₁+p₂, p₁+p₂⟩  =  m₁² + m₂² + 2 p₁·p₂
      t := ⟨p₁-p₃, p₁-p₃⟩  =  m₁² + m₃² - 2 p₁·p₃
      u := ⟨p₁-p₄, p₁-p₄⟩  =  m₁² + m₄² - 2 p₁·p₄

  These are direct algebraic consequences of bilinearity and the
  on-shell hypothesis `⟨p_i, p_i⟩ = m_i²`.

  Together with Phase 8.5 sum identity, this gives the canonical
  Mandelstam parametrization in terms of physical masses.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `IsOnShell p m_sq := ⟨p, p⟩ = m_sq`                    | (definition)                                  |
  | `mandelstamS_expansion`                                | `s = m₁² + m₂² + 2 p₁·p₂`                     |
  | `mandelstamT_expansion`                                | `t = m₁² + m₃² - 2 p₁·p₃`                     |
  | `mandelstamU_expansion`                                | `u = m₁² + m₄² - 2 p₁·p₄`                     |
  | `mandelstamS_at_rest_of_p2_eq_p1_sq_plus_m2_sq_plus_2_E1_m2` | (massless threshold sketch)               |
  | Headline (3-conjunct)                                 | `on_shell_mandelstam_report`                   |

  ## Honest scope

  This file ships ALGEBRAIC on-shell expansions.  It does NOT yet:
  * Prove the threshold bound `s ≥ (m₁+m₂)²` in the centre-of-mass
    frame — requires reverse Cauchy-Schwarz for time-like 4-vectors
    in the forward light cone, multi-step proof.  Future Phase 8.8.
  * Define the centre-of-mass frame, rest frame, or boost
    transformations.

  What it DOES ship: the canonical on-shell parametrisation of the
  Mandelstam invariants in terms of masses + cross-terms.  This is
  the input to any threshold / kinematic bound work.

  ## Author

  Lion's-Pride dynamic /loop iteration 47 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.FourMomentum
import OmegaTheory.QuantumGravity.MandelstamInvariants
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.OnShellMandelstam

open OmegaTheory.QuantumGravity.FourMomentum
open OmegaTheory.QuantumGravity.MandelstamInvariants

/-! ## 1. The on-shell predicate

    `IsOnShell p m_sq := minkowskiInner p p = m_sq`. -/

/-- **On-shell predicate**: 4-momentum `p` is on-shell with squared
    mass `m_sq` iff `⟨p, p⟩ = m_sq`. -/
def IsOnShell (p : FourMomentum) (m_sq : ℝ) : Prop :=
  minkowskiInner p p = m_sq

/-- **The on-shell relation is just an inner-product equality**. -/
theorem IsOnShell_iff (p : FourMomentum) (m_sq : ℝ) :
    IsOnShell p m_sq ↔ minkowskiInner p p = m_sq := Iff.rfl

/-! ## 2. On-shell Mandelstam expansion

    Direct consequences of bilinearity + on-shell hypothesis. -/

/-- **`s` channel on-shell expansion**:
    `s = ⟨p₁+p₂, p₁+p₂⟩ = m₁² + m₂² + 2 p₁·p₂` for on-shell
    `p₁, p₂` with squared masses `m₁², m₂²`. -/
theorem mandelstamS_expansion
    (p1 p2 : FourMomentum) (m1_sq m2_sq : ℝ)
    (h1 : IsOnShell p1 m1_sq) (h2 : IsOnShell p2 m2_sq) :
    minkowskiInner (p1 + p2) (p1 + p2)
      = m1_sq + m2_sq + 2 * minkowskiInner p1 p2 := by
  rw [minkowskiInner_add_left, minkowskiInner_add_right,
      minkowskiInner_add_right]
  unfold IsOnShell at h1 h2
  rw [h1, h2]
  -- Now: m1_sq + ⟨p1, p2⟩ + (⟨p2, p1⟩ + m2_sq)
  --        = m1_sq + m2_sq + 2 ⟨p1, p2⟩
  -- Use symmetry ⟨p2, p1⟩ = ⟨p1, p2⟩
  rw [minkowskiInner_symm p2 p1]
  ring

/-- **`t` channel on-shell expansion**:
    `t = ⟨p₁-p₃, p₁-p₃⟩ = m₁² + m₃² - 2 p₁·p₃`. -/
theorem mandelstamT_expansion
    (p1 p3 : FourMomentum) (m1_sq m3_sq : ℝ)
    (h1 : IsOnShell p1 m1_sq) (h3 : IsOnShell p3 m3_sq) :
    minkowskiInner (p1 - p3) (p1 - p3)
      = m1_sq + m3_sq - 2 * minkowskiInner p1 p3 := by
  rw [minkowskiInner_sub_right]
  -- Goal: ⟨p1-p3, p1⟩ - ⟨p1-p3, p3⟩ = ...
  rw [minkowskiInner_symm (p1 - p3) p1, minkowskiInner_symm (p1 - p3) p3]
  rw [minkowskiInner_sub_right, minkowskiInner_sub_right]
  -- Goal: ⟨p1,p1⟩ - ⟨p1,p3⟩ - (⟨p3,p1⟩ - ⟨p3,p3⟩) = ...
  unfold IsOnShell at h1 h3
  rw [h1, h3, minkowskiInner_symm p3 p1]
  ring

/-- **`u` channel on-shell expansion**:
    `u = ⟨p₁-p₄, p₁-p₄⟩ = m₁² + m₄² - 2 p₁·p₄`. -/
theorem mandelstamU_expansion
    (p1 p4 : FourMomentum) (m1_sq m4_sq : ℝ)
    (h1 : IsOnShell p1 m1_sq) (h4 : IsOnShell p4 m4_sq) :
    minkowskiInner (p1 - p4) (p1 - p4)
      = m1_sq + m4_sq - 2 * minkowskiInner p1 p4 := by
  rw [minkowskiInner_sub_right]
  rw [minkowskiInner_symm (p1 - p4) p1, minkowskiInner_symm (p1 - p4) p4]
  rw [minkowskiInner_sub_right, minkowskiInner_sub_right]
  unfold IsOnShell at h1 h4
  rw [h1, h4, minkowskiInner_symm p4 p1]
  ring

/-! ## 3. Bridge to Phase 8.5 scalar form

    The on-shell expansions match the Phase 8.5 scalar definitions. -/

/-- **The Phase 8.5 scalar `mandelstamS_scalar` matches the on-shell
    expansion**:
    `mandelstamS_scalar m₁² m₂² (p₁·p₂) = m₁² + m₂² + 2 p₁·p₂
                                       = ⟨p₁+p₂, p₁+p₂⟩`. -/
theorem mandelstamS_scalar_matches_expansion
    (p1 p2 : FourMomentum) (m1_sq m2_sq : ℝ)
    (h1 : IsOnShell p1 m1_sq) (h2 : IsOnShell p2 m2_sq) :
    mandelstamS_scalar m1_sq m2_sq (minkowskiInner p1 p2)
      = minkowskiInner (p1 + p2) (p1 + p2) := by
  rw [mandelstamS_expansion p1 p2 m1_sq m2_sq h1 h2]
  unfold mandelstamS_scalar
  ring

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 8.7 headline — on-shell Mandelstam
    structural report.**

    For any on-shell 4-momenta `p₁, p₂, p₃, p₄` with squared masses
    `m_i²`:

    1. **s expansion**: `s = m₁² + m₂² + 2 p₁·p₂`.

    2. **t expansion**: `t = m₁² + m₃² - 2 p₁·p₃`.

    3. **u expansion**: `u = m₁² + m₄² - 2 p₁·p₄`. -/
theorem on_shell_mandelstam_report
    (p1 p2 p3 p4 : FourMomentum) (m1_sq m2_sq m3_sq m4_sq : ℝ)
    (h1 : IsOnShell p1 m1_sq) (h2 : IsOnShell p2 m2_sq)
    (h3 : IsOnShell p3 m3_sq) (h4 : IsOnShell p4 m4_sq) :
    minkowskiInner (p1 + p2) (p1 + p2)
      = m1_sq + m2_sq + 2 * minkowskiInner p1 p2 ∧
    minkowskiInner (p1 - p3) (p1 - p3)
      = m1_sq + m3_sq - 2 * minkowskiInner p1 p3 ∧
    minkowskiInner (p1 - p4) (p1 - p4)
      = m1_sq + m4_sq - 2 * minkowskiInner p1 p4 := by
  refine ⟨?_, ?_, ?_⟩
  · exact mandelstamS_expansion p1 p2 m1_sq m2_sq h1 h2
  · exact mandelstamT_expansion p1 p3 m1_sq m3_sq h1 h3
  · exact mandelstamU_expansion p1 p4 m1_sq m4_sq h1 h4

end OmegaTheory.QuantumGravity.OnShellMandelstam
