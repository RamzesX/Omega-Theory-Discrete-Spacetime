/-
  OmegaTheory.QuantumGravity.FourMomentum

  **Lion's-Pride Phase 8.6 (2026-05-06)**:
  *Concrete 4-vector model with Minkowski signature `η = (+,−,−,−)`.
  Derives the Phase 8.5 scalar-bilinear conservation hypothesis
  from `p₁ + p₂ = p₃ + p₄` directly.*

  ## Why this file

  Phase 8.5 (`MandelstamInvariants`) shipped the kinematic identity
  `s + t + u = m₁² + m₂² + m₃² + m₄²` in scalar-bilinear form: the
  conservation hypothesis appeared as `p₁·p₂ = p₁·p₃ + p₁·p₄ - p₁²`
  taken as input.

  This file ships the CONCRETE 4-vector model — `FourMomentum` as
  `Fin 4 → ℝ` with the standard Minkowski inner product
  `η_μν p^μ q^ν = p⁰q⁰ − p¹q¹ − p²q² − p³q³` — and proves:

  1. The Minkowski inner product is a real bilinear form (linearity
     + symmetry).

  2. From `p₁ + p₂ = p₃ + p₄`, the scalar bilinear constraint
     `p₁·p₂ = p₁·p₃ + p₁·p₄ - p₁·p₁` follows by dotting both sides
     with `p₁`.

  Together with Phase 8.5, this closes the chain from concrete
  4-momentum conservation to the Mandelstam sum identity.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `FourMomentum := Fin 4 → ℝ`                            | (type alias)                                  |
  | `minkowskiInner p q := p⁰q⁰ - p¹q¹ - p²q² - p³q³`     | (definition)                                  |
  | `minkowskiInner_symm`                                  | symmetry: `⟨p, q⟩ = ⟨q, p⟩`                    |
  | `minkowskiInner_add_left`                              | linearity in left argument                    |
  | `minkowskiInner_add_right`                             | linearity in right argument                   |
  | `minkowskiInner_sub_right`                             | sub linearity in right argument                |
  | `minkowskiInner_zero_left`                             | zero left ⟹ inner product zero                |
  | `momentum_conservation_implies_scalar_constraint`      | the bridge to Phase 8.5                        |
  | Headline (3-conjunct)                                 | `four_momentum_report`                         |

  ## Honest scope

  This file ships the basic Minkowski-inner-product algebra.  It does
  NOT yet:
  * Define on-shell condition `p² = m²` as a separate predicate
    (we just use `minkowskiInner p p = m²` directly).
  * Prove that `s = (p₁+p₂)² ≥ (m₁+m₂)²` in centre-of-mass frame
    (kinematic-bound corollary; out of scope).
  * Define the rest frame, boost, Lorentz transformations.

  ## Author

  Lion's-Pride dynamic /loop iteration 45 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.MandelstamInvariants
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.FourMomentum

/-! ## 1. The 4-momentum type

    `FourMomentum := Fin 4 → ℝ` with the convention
    `p 0 = E` (energy), `p 1, p 2, p 3 = p_x, p_y, p_z`. -/

/-- **4-momentum**: function `Fin 4 → ℝ` with index 0 = energy,
    indices 1,2,3 = spatial momentum. -/
abbrev FourMomentum := Fin 4 → ℝ

/-- **Minkowski inner product** with metric `η = diag(+1, -1, -1, -1)`:
    `⟨p, q⟩_η = p⁰q⁰ - p¹q¹ - p²q² - p³q³`. -/
def minkowskiInner (p q : FourMomentum) : ℝ :=
  p 0 * q 0 - p 1 * q 1 - p 2 * q 2 - p 3 * q 3

/-! ## 2. Algebraic properties: bilinearity + symmetry -/

/-- **Symmetry**: `⟨p, q⟩ = ⟨q, p⟩`. -/
theorem minkowskiInner_symm (p q : FourMomentum) :
    minkowskiInner p q = minkowskiInner q p := by
  unfold minkowskiInner
  ring

/-- **Linearity in left argument (additive)**:
    `⟨p₁ + p₂, q⟩ = ⟨p₁, q⟩ + ⟨p₂, q⟩`. -/
theorem minkowskiInner_add_left
    (p1 p2 q : FourMomentum) :
    minkowskiInner (p1 + p2) q
      = minkowskiInner p1 q + minkowskiInner p2 q := by
  unfold minkowskiInner
  -- (p1 + p2) i = p1 i + p2 i for Fin 4 → ℝ
  simp [Pi.add_apply]
  ring

/-- **Linearity in right argument (additive)**:
    `⟨p, q₁ + q₂⟩ = ⟨p, q₁⟩ + ⟨p, q₂⟩`. -/
theorem minkowskiInner_add_right
    (p q1 q2 : FourMomentum) :
    minkowskiInner p (q1 + q2)
      = minkowskiInner p q1 + minkowskiInner p q2 := by
  rw [minkowskiInner_symm, minkowskiInner_add_left]
  rw [minkowskiInner_symm p q1, minkowskiInner_symm p q2]

/-- **Sub-linearity in right argument**:
    `⟨p, q₁ - q₂⟩ = ⟨p, q₁⟩ - ⟨p, q₂⟩`. -/
theorem minkowskiInner_sub_right
    (p q1 q2 : FourMomentum) :
    minkowskiInner p (q1 - q2)
      = minkowskiInner p q1 - minkowskiInner p q2 := by
  unfold minkowskiInner
  simp [Pi.sub_apply]
  ring

/-- **Zero left argument**: `⟨0, q⟩ = 0`. -/
theorem minkowskiInner_zero_left (q : FourMomentum) :
    minkowskiInner 0 q = 0 := by
  unfold minkowskiInner
  simp

/-! ## 3. Bridge to Phase 8.5: from 4-momentum conservation to
    scalar-bilinear constraint.

    Given `p₁ + p₂ = p₃ + p₄`, dotting both sides with `p₁` yields
        ⟨p₁, p₁ + p₂⟩ = ⟨p₁, p₃ + p₄⟩
    i.e.,
        ⟨p₁, p₁⟩ + ⟨p₁, p₂⟩ = ⟨p₁, p₃⟩ + ⟨p₁, p₄⟩
    rearranging:
        ⟨p₁, p₂⟩ = ⟨p₁, p₃⟩ + ⟨p₁, p₄⟩ - ⟨p₁, p₁⟩ -/

/-- **Bridge theorem**: 4-momentum conservation `p₁ + p₂ = p₃ + p₄`
    implies the Phase 8.5 scalar-bilinear conservation constraint
    `p₁·p₂ = p₁·p₃ + p₁·p₄ - p₁²`. -/
theorem momentum_conservation_implies_scalar_constraint
    (p1 p2 p3 p4 : FourMomentum)
    (h_conserve : p1 + p2 = p3 + p4) :
    OmegaTheory.QuantumGravity.MandelstamInvariants.isConservedScalar
      (minkowskiInner p1 p1) (minkowskiInner p1 p2)
      (minkowskiInner p1 p3) (minkowskiInner p1 p4) := by
  unfold OmegaTheory.QuantumGravity.MandelstamInvariants.isConservedScalar
  -- Want: p1·p2 = p1·p3 + p1·p4 - p1·p1
  -- From h_conserve: p1 + p2 = p3 + p4
  -- So: ⟨p1, p1+p2⟩ = ⟨p1, p3+p4⟩
  -- LHS by linearity: ⟨p1,p1⟩ + ⟨p1,p2⟩
  -- RHS by linearity: ⟨p1,p3⟩ + ⟨p1,p4⟩
  have h_dot : minkowskiInner p1 (p1 + p2) = minkowskiInner p1 (p3 + p4) := by
    rw [h_conserve]
  rw [minkowskiInner_add_right, minkowskiInner_add_right] at h_dot
  linarith [h_dot]

/-! ## 4. Composed Phase 8.5 + 8.6: full Mandelstam identity from
    concrete 4-momenta -/

/-- **Mandelstam sum identity from concrete 4-momentum conservation**:
    given `p₁ + p₂ = p₃ + p₄` and on-shell `p_i² = m_i²`, then
    `s + t + u = m₁² + m₂² + m₃² + m₄²` where the Mandelstam
    invariants are computed from the actual 4-momenta. -/
theorem mandelstam_sum_from_concrete_conservation
    (p1 p2 p3 p4 : FourMomentum)
    (h_conserve : p1 + p2 = p3 + p4) :
    OmegaTheory.QuantumGravity.MandelstamInvariants.mandelstamS_scalar
        (minkowskiInner p1 p1) (minkowskiInner p2 p2)
        (minkowskiInner p1 p2)
      + OmegaTheory.QuantumGravity.MandelstamInvariants.mandelstamT_scalar
          (minkowskiInner p1 p1) (minkowskiInner p3 p3)
          (minkowskiInner p1 p3)
      + OmegaTheory.QuantumGravity.MandelstamInvariants.mandelstamU_scalar
          (minkowskiInner p1 p1) (minkowskiInner p4 p4)
          (minkowskiInner p1 p4)
      = minkowskiInner p1 p1 + minkowskiInner p2 p2
        + minkowskiInner p3 p3 + minkowskiInner p4 p4 := by
  exact OmegaTheory.QuantumGravity.MandelstamInvariants.mandelstam_sum_eq_total_mass_sq
    (minkowskiInner p1 p1) (minkowskiInner p2 p2)
    (minkowskiInner p3 p3) (minkowskiInner p4 p4)
    (minkowskiInner p1 p2) (minkowskiInner p1 p3)
    (minkowskiInner p1 p4)
    (momentum_conservation_implies_scalar_constraint p1 p2 p3 p4 h_conserve)

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 8.6 headline — concrete 4-vector model
    structural report.**

    For any 4-momenta `p₁, p₂ : FourMomentum` and conservation
    hypothesis `p₁ + p₂ = p₃ + p₄`:

    1. **Symmetry**: `⟨p₁, p₂⟩ = ⟨p₂, p₁⟩`.

    2. **Linearity in right**: `⟨p, q₁ + q₂⟩ = ⟨p, q₁⟩ + ⟨p, q₂⟩`.

    3. **Conservation bridge**: 4-momentum conservation
       `p₁ + p₂ = p₃ + p₄` implies the scalar-bilinear conservation
       `⟨p₁, p₂⟩ = ⟨p₁, p₃⟩ + ⟨p₁, p₄⟩ - ⟨p₁, p₁⟩` (Phase 8.5
       hypothesis derived). -/
theorem four_momentum_report
    (p1 p2 p3 p4 q1 q2 : FourMomentum)
    (h_conserve : p1 + p2 = p3 + p4) :
    minkowskiInner p1 p2 = minkowskiInner p2 p1 ∧
    minkowskiInner p1 (q1 + q2)
      = minkowskiInner p1 q1 + minkowskiInner p1 q2 ∧
    OmegaTheory.QuantumGravity.MandelstamInvariants.isConservedScalar
      (minkowskiInner p1 p1) (minkowskiInner p1 p2)
      (minkowskiInner p1 p3) (minkowskiInner p1 p4) := by
  refine ⟨?_, ?_, ?_⟩
  · exact minkowskiInner_symm p1 p2
  · exact minkowskiInner_add_right p1 q1 q2
  · exact momentum_conservation_implies_scalar_constraint p1 p2 p3 p4 h_conserve

end OmegaTheory.QuantumGravity.FourMomentum
