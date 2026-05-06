/-
  OmegaTheory.QuantumGravity.MandelstamInvariants

  **Lion's-Pride Phase 8.5 (2026-05-06)**:
  *Mandelstam invariants `s, t, u` for 2 → 2 scattering and the
  kinematic conservation identity `s + t + u = m₁² + m₂² + m₃² + m₄²`.*

  ## Why this file

  In 2 → 2 scattering with on-shell external particles of squared
  masses `m₁², m₂², m₃², m₄²`, the Mandelstam invariants are

      s := (p₁ + p₂)²       (s-channel: incoming centre-of-mass²)
      t := (p₁ - p₃)²       (t-channel: momentum transfer²)
      u := (p₁ - p₄)²       (u-channel: alternative transfer²)

  They satisfy the kinematic identity (Weinberg vol I §6, Peskin §5)

      s + t + u  =  m₁² + m₂² + m₃² + m₄²

  This identity follows from 4-momentum conservation `p₁+p₂ = p₃+p₄`
  combined with on-shell `p_i² = m_i²` and bilinearity of the
  Minkowski inner product.

  The massless special case `m_i² = 0` for all i gives `s + t + u = 0`.

  This file ships the identity in scalar/bilinear form: we treat the
  Lorentz-invariant scalar products as inputs and the conservation
  constraint as a linear hypothesis, then derive the identity via
  `ring`.  The full 4-vector concrete model is downstream — out of
  scope for this scaffold.

  ## What this file ships

  | Property                                              | Theorem                                    |
  |-------------------------------------------------------|--------------------------------------------|
  | `mandelstamS_scalar p1_sq p2_sq p1_dot_p2`            | `:= p1² + 2·p1·p2 + p2²`                    |
  | `mandelstamT_scalar p1_sq p3_sq p1_dot_p3`            | `:= p1² - 2·p1·p3 + p3²`                    |
  | `mandelstamU_scalar p1_sq p4_sq p1_dot_p4`            | `:= p1² - 2·p1·p4 + p4²`                    |
  | Conservation form: `p1·p2 = p1·p3 + p1·p4 - p1²`      | (def + interpretation)                     |
  | Sum identity                                          | `mandelstam_sum_eq_total_mass_sq`           |
  | Massless special case: `s + t + u = 0`                | `mandelstam_sum_zero_massless`              |
  | Headline (3-conjunct)                                 | `mandelstam_invariants_report`              |

  ## Honest scope

  This file ships the SCALAR-BILINEAR form of the Mandelstam identity
  using Lorentz-invariant inner products as inputs.  It does NOT yet:
  * Build the full 4-vector concrete model with `Fin 4 → ℝ` and
    Minkowski bilinear `η_μν p^μ q^ν = p⁰q⁰ - p¹q¹ - p²q² - p³q³`.
    (Tractable port: ~150 more LOC; deferred.)
  * Prove the conservation hypothesis from `p₁+p₂ = p₃+p₄` (which
    requires the concrete 4-vector model).
  * Identify the parametrization in centre-of-mass frame
    (`s = E_CM²`, etc.) — out of scope.

  What it DOES ship: the rigorous algebraic CONTENT of the identity,
  given the conservation hypothesis as a scalar constraint.

  ## Author

  Lion's-Pride dynamic /loop iteration 44 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.MandelstamInvariants

/-! ## 1. Mandelstam invariants in scalar/bilinear form

    Given Lorentz-invariant inner products `p_i² = m_i²` (on-shell)
    and crossed terms `p_i · p_j`, the Mandelstam invariants are
    bilinear combinations. -/

/-- **s-channel Mandelstam invariant**: `s = (p₁+p₂)² = p₁² + 2 p₁·p₂ + p₂²`. -/
def mandelstamS_scalar (p1_sq p2_sq p1_dot_p2 : ℝ) : ℝ :=
  p1_sq + 2 * p1_dot_p2 + p2_sq

/-- **t-channel Mandelstam invariant**: `t = (p₁-p₃)² = p₁² - 2 p₁·p₃ + p₃²`. -/
def mandelstamT_scalar (p1_sq p3_sq p1_dot_p3 : ℝ) : ℝ :=
  p1_sq - 2 * p1_dot_p3 + p3_sq

/-- **u-channel Mandelstam invariant**: `u = (p₁-p₄)² = p₁² - 2 p₁·p₄ + p₄²`. -/
def mandelstamU_scalar (p1_sq p4_sq p1_dot_p4 : ℝ) : ℝ :=
  p1_sq - 2 * p1_dot_p4 + p4_sq

/-! ## 2. Conservation hypothesis as scalar constraint

    From `p₁ + p₂ = p₃ + p₄` (4-momentum conservation), dotting both
    sides with `p₁` gives:
        p₁·p₁ + p₁·p₂ = p₁·p₃ + p₁·p₄
    i.e.,
        p₁·p₂  =  p₁·p₃ + p₁·p₄ - p₁²

    This SCALAR form is the conservation constraint we will use. -/

/-- **Conservation constraint** in scalar form (derived from
    `p₁ + p₂ = p₃ + p₄` by dotting with `p₁`):
        `p₁·p₂ = p₁·p₃ + p₁·p₄ - p₁²`. -/
def isConservedScalar
    (p1_sq p1_dot_p2 p1_dot_p3 p1_dot_p4 : ℝ) : Prop :=
  p1_dot_p2 = p1_dot_p3 + p1_dot_p4 - p1_sq

/-! ## 3. The Mandelstam sum identity

    `s + t + u = m₁² + m₂² + m₃² + m₄²`. -/

/-- **Mandelstam sum identity** (scalar/bilinear form):
    given on-shell external particles and 4-momentum conservation,
    `s + t + u = m₁² + m₂² + m₃² + m₄²`.

    Proof: expand `s + t + u` to get
       `3·p₁² + p₂² + p₃² + p₄² + 2·(p₁·p₂ - p₁·p₃ - p₁·p₄)`.
    Substitute conservation `p₁·p₂ = p₁·p₃ + p₁·p₄ - p₁²` to get
       `3·p₁² + p₂² + p₃² + p₄² - 2·p₁²
            = p₁² + p₂² + p₃² + p₄²`.

    The on-shell identification `p_i² = m_i²` is then pointwise. -/
theorem mandelstam_sum_eq_total_mass_sq
    (p1_sq p2_sq p3_sq p4_sq
     p1_dot_p2 p1_dot_p3 p1_dot_p4 : ℝ)
    (h_conserve : isConservedScalar p1_sq p1_dot_p2 p1_dot_p3 p1_dot_p4) :
    mandelstamS_scalar p1_sq p2_sq p1_dot_p2
      + mandelstamT_scalar p1_sq p3_sq p1_dot_p3
      + mandelstamU_scalar p1_sq p4_sq p1_dot_p4
      = p1_sq + p2_sq + p3_sq + p4_sq := by
  unfold isConservedScalar at h_conserve
  unfold mandelstamS_scalar mandelstamT_scalar mandelstamU_scalar
  rw [h_conserve]
  ring

/-! ## 4. Massless special case

    For massless external particles `p_i² = 0` all i, the Mandelstam
    sum is `s + t + u = 0`. -/

/-- **Mandelstam sum vanishes in the massless case**: when all
    on-shell `p_i² = 0`, the Mandelstam sum `s + t + u = 0`. -/
theorem mandelstam_sum_zero_massless
    (p1_dot_p2 p1_dot_p3 p1_dot_p4 : ℝ)
    (h_conserve : isConservedScalar 0 p1_dot_p2 p1_dot_p3 p1_dot_p4) :
    mandelstamS_scalar 0 0 p1_dot_p2
      + mandelstamT_scalar 0 0 p1_dot_p3
      + mandelstamU_scalar 0 0 p1_dot_p4
      = 0 := by
  have h := mandelstam_sum_eq_total_mass_sq 0 0 0 0
              p1_dot_p2 p1_dot_p3 p1_dot_p4 h_conserve
  rw [h]; ring

/-! ## 5. Determined-fourth-from-three corollary

    Given conservation + 3 of {s, t, u}, the fourth is determined. -/

/-- **`u` determined from `s, t` and total mass-squared**:
    `u = m₁² + m₂² + m₃² + m₄² - s - t`. -/
theorem mandelstamU_eq_total_minus_S_minus_T
    (p1_sq p2_sq p3_sq p4_sq
     p1_dot_p2 p1_dot_p3 p1_dot_p4 : ℝ)
    (h_conserve : isConservedScalar p1_sq p1_dot_p2 p1_dot_p3 p1_dot_p4) :
    mandelstamU_scalar p1_sq p4_sq p1_dot_p4
      = (p1_sq + p2_sq + p3_sq + p4_sq)
        - mandelstamS_scalar p1_sq p2_sq p1_dot_p2
        - mandelstamT_scalar p1_sq p3_sq p1_dot_p3 := by
  have h := mandelstam_sum_eq_total_mass_sq p1_sq p2_sq p3_sq p4_sq
              p1_dot_p2 p1_dot_p3 p1_dot_p4 h_conserve
  linarith [h]

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 8.5 headline — Mandelstam invariants
    structural report.**

    For Lorentz-invariant scalar products `p_i² = m_i²` (on-shell)
    and crossed terms `p_i · p_j`, with 4-momentum conservation
    `p₁ + p₂ = p₃ + p₄`:

    1. **Sum identity**: `s + t + u = m₁² + m₂² + m₃² + m₄²`.

    2. **Massless special case**: all `m_i = 0` ⟹ `s + t + u = 0`.

    3. **Determined-fourth**: `u = total - s - t`. -/
theorem mandelstam_invariants_report
    (p1_sq p2_sq p3_sq p4_sq
     p1_dot_p2 p1_dot_p3 p1_dot_p4 : ℝ)
    (h_conserve : isConservedScalar p1_sq p1_dot_p2 p1_dot_p3 p1_dot_p4)
    (q_dot_p2 q_dot_p3 q_dot_p4 : ℝ)
    (h_massless_conserve :
      isConservedScalar 0 q_dot_p2 q_dot_p3 q_dot_p4) :
    -- (1) Sum identity
    mandelstamS_scalar p1_sq p2_sq p1_dot_p2
      + mandelstamT_scalar p1_sq p3_sq p1_dot_p3
      + mandelstamU_scalar p1_sq p4_sq p1_dot_p4
      = p1_sq + p2_sq + p3_sq + p4_sq ∧
    -- (2) Massless case
    mandelstamS_scalar 0 0 q_dot_p2
      + mandelstamT_scalar 0 0 q_dot_p3
      + mandelstamU_scalar 0 0 q_dot_p4
      = 0 ∧
    -- (3) Determined fourth
    mandelstamU_scalar p1_sq p4_sq p1_dot_p4
      = (p1_sq + p2_sq + p3_sq + p4_sq)
        - mandelstamS_scalar p1_sq p2_sq p1_dot_p2
        - mandelstamT_scalar p1_sq p3_sq p1_dot_p3 := by
  refine ⟨?_, ?_, ?_⟩
  · exact mandelstam_sum_eq_total_mass_sq p1_sq p2_sq p3_sq p4_sq
            p1_dot_p2 p1_dot_p3 p1_dot_p4 h_conserve
  · exact mandelstam_sum_zero_massless q_dot_p2 q_dot_p3 q_dot_p4
            h_massless_conserve
  · exact mandelstamU_eq_total_minus_S_minus_T p1_sq p2_sq p3_sq p4_sq
            p1_dot_p2 p1_dot_p3 p1_dot_p4 h_conserve

end OmegaTheory.QuantumGravity.MandelstamInvariants
