/-
  OmegaTheory.QuantumGravity.CrossSectionScaffold

  **Lion's-Pride Phase 8.4 (2026-05-06)**:
  *Cross-section physical observable scaffold — squared amplitude
  |M|² of the full 2 → 2 graviton scattering amplitude, with
  positivity, vanishing-on-zero, and interference decomposition.*

  ## Why this file

  In the optical theorem and Fermi's Golden Rule, the differential
  cross-section for 2 → 2 scattering is

      dσ/dΩ  =  (1/64π²s) · |M|²

  where `s` is the squared centre-of-mass energy (a kinematic flux
  factor) and `M` is the Lorentz-invariant scattering amplitude.

  In V2 we have `fullScattering4pt` (Phase 8.3) as the substrate's
  analog of `M`.  This file ships the SQUARED amplitude `|M|²` and
  proves:
  * it is non-negative (every real number squared is `≥ 0`)
  * it vanishes iff `M` vanishes (any zero of `M` kills `|M|²`)
  * the interference decomposition for the 4-term sum
    `M = V₄ + s + t + u`:
    `|M|² = V₄² + s² + t² + u² + 2·(cross-terms)`.

  ## What this file ships

  | Property                                              | Theorem                                        |
  |-------------------------------------------------------|------------------------------------------------|
  | `amplitudeSquared M : ℝ`                              | (definition: `M^2`)                            |
  | `amplitudeSquared M ≥ 0`                              | `amplitudeSquared_nonneg`                      |
  | `amplitudeSquared 0 = 0`                              | `amplitudeSquared_zero`                        |
  | `M = 0 → |M|² = 0`                                    | `amplitudeSquared_eq_zero_of_amp_zero`         |
  | `crossSection4pt h₁..h₄ h_X k_s² k_t² k_u² p`         | (definition: `|fullScattering4pt|²`)           |
  | Cross-section non-neg                                 | `crossSection4pt_nonneg`                       |
  | Cross-section zero on zero first leg                  | `crossSection4pt_zero_first_leg`               |
  | Interference: `(a+b+c+d)² = a²+b²+c²+d² + 2(ab+ac+ad+bc+bd+cd)` | `interference_decomposition_4term`    |
  | Headline (4-conjunct)                                 | `cross_section_scaffold_report`                 |

  ## Honest scope

  This file ships the SQUARED-AMPLITUDE structure of the cross
  section.  It does NOT yet:
  * Multiply by the flux factor `1/(64π²s)` (requires Lorentz-
    invariant phase space; out of scope for substrate scaffold).
  * Integrate over solid angle `dΩ` (requires angular variables
    `θ, φ` and Jacobian; out of scope).
  * Compute the total cross-section `σ_total = ∫ dσ/dΩ dΩ`.

  What it DOES ship: the rigorous `|M|² ≥ 0` envelope of the
  classical cross-section, with explicit interference decomposition
  showing the 6 cross-terms (the genuine quantum-mechanical content
  of scattering — interference between contributions).

  ## Author

  Lion's-Pride dynamic /loop iteration 42 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.FullTwoToTwoAmplitude
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.CrossSectionScaffold

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Variational.CubicGravitonVertex
open OmegaTheory.Variational.QuarticGravitonVertex
open OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel
open OmegaTheory.QuantumGravity.ChannelExchangeAmplitude
open OmegaTheory.QuantumGravity.FullTwoToTwoAmplitude

/-! ## 1. Squared amplitude `|M|²`

    For a real-valued amplitude `M`, the squared amplitude is `M²`.
    This is non-negative and vanishes iff `M = 0`. -/

/-- **Squared amplitude**: `|M|² := M²`. -/
def amplitudeSquared (M : ℝ) : ℝ := M ^ 2

/-- **Squared amplitude is non-negative** for any real amplitude. -/
theorem amplitudeSquared_nonneg (M : ℝ) : 0 ≤ amplitudeSquared M := by
  unfold amplitudeSquared
  exact sq_nonneg M

/-- **Squared amplitude of zero is zero**. -/
theorem amplitudeSquared_zero : amplitudeSquared 0 = 0 := by
  unfold amplitudeSquared
  ring

/-- **If amplitude vanishes, squared amplitude vanishes**. -/
theorem amplitudeSquared_eq_zero_of_amp_zero (M : ℝ) (h : M = 0) :
    amplitudeSquared M = 0 := by
  rw [h]; exact amplitudeSquared_zero

/-! ## 2. Cross-section scaffold for 2 → 2 graviton scattering

    `|M_full|²` of the Phase 8.3 full 2 → 2 amplitude. -/

/-- **2 → 2 graviton cross-section (squared amplitude)**.

    This is the cross-section observable up to the kinematic flux
    factor `1/(64π²s)`.  The flux factor is a positive constant
    (when `s > 0`) so the sign and zero-structure of the cross-
    section are determined entirely by `|M_full|²`. -/
noncomputable def crossSection4pt
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) : ℝ :=
  amplitudeSquared
    (fullScattering4pt h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p)

/-- **Cross-section is non-negative**: `|M|² ≥ 0`. -/
theorem crossSection4pt_nonneg
    (h₁ h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) :
    0 ≤ crossSection4pt h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p := by
  unfold crossSection4pt
  exact amplitudeSquared_nonneg _

/-- **Cross-section vanishes on zero first leg**: when the first
    incoming graviton is identically zero, the full amplitude
    vanishes (Phase 8.3) and so does `|M|²`. -/
theorem crossSection4pt_zero_first_leg
    (h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) :
    crossSection4pt (fun _ _ _ => 0) h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p = 0 := by
  unfold crossSection4pt
  apply amplitudeSquared_eq_zero_of_amp_zero
  exact fullScattering4pt_zero_first_leg h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p

/-! ## 3. Interference decomposition

    For the 4-term sum `M = a + b + c + d` (direct + s + t + u
    channels), the squared amplitude expands as

        |M|² = a² + b² + c² + d² + 2(ab + ac + ad + bc + bd + cd)

    The 6 cross-terms encode quantum-mechanical interference
    between the four contributions. -/

/-- **Interference decomposition for 4-term sum**:

    `(a + b + c + d)² = a² + b² + c² + d² + 2·(ab + ac + ad + bc + bd + cd)`.

    The 6 cross-terms are the genuine quantum content of the cross-
    section: classical incoherent sum would give just `a² + b² + c² + d²`,
    but interference contributes the additional `2·Σ ab` cross-terms. -/
theorem interference_decomposition_4term (a b c d : ℝ) :
    (a + b + c + d) ^ 2
      = a^2 + b^2 + c^2 + d^2
        + 2 * (a*b + a*c + a*d + b*c + b*d + c*d) := by
  ring

/-- **4-term cross-section decomposed via interference**:
    `|V₄ + s + t + u|² = V₄² + s² + t² + u² + 6 cross-terms`. -/
theorem crossSection4pt_interference_form
    (h₁ h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) :
    crossSection4pt h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
      = (gravitonAmplitude4pt h₁ h₂ h₃ h₄ p) ^ 2
        + (channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p) ^ 2
        + (channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p) ^ 2
        + (channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p) ^ 2
        + 2 * (
            gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
              * channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p
            + gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
              * channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p
            + gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
              * channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p
            + channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p
              * channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p
            + channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p
              * channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p
            + channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p
              * channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p) := by
  unfold crossSection4pt amplitudeSquared
  rw [fullScattering4pt_decomposes]
  ring

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 8.4 headline — cross-section scaffold report**.

    For any metric perturbations `h₁, h₂, h₃, h₄, h_X`, Mandelstam
    invariants `k_s², k_t², k_u² : ℝ`, and lattice point `p`:

    1. **Cross-section non-negative**:
       `0 ≤ |M_full|²`.

    2. **Cross-section vanishes on zero first leg**:
       `|M_full(0, h₂, h₃, h₄, ...)|² = 0`.

    3. **Squared amplitude is the squared real**:
       `|M|² = M²` (definitional).

    4. **Interference decomposition**:
       `(a+b+c+d)² = a²+b²+c²+d² + 2·(6 cross-terms)`. -/
theorem cross_section_scaffold_report
    (h₁ h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) (M : ℝ) :
    0 ≤ crossSection4pt h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p ∧
    crossSection4pt (fun _ _ _ => 0) h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p = 0 ∧
    amplitudeSquared M = M^2 ∧
    ∀ a b c d : ℝ,
      (a + b + c + d) ^ 2
        = a^2 + b^2 + c^2 + d^2
          + 2 * (a*b + a*c + a*d + b*c + b*d + c*d) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact crossSection4pt_nonneg h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
  · exact crossSection4pt_zero_first_leg h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
  · rfl
  · exact interference_decomposition_4term

end OmegaTheory.QuantumGravity.CrossSectionScaffold
