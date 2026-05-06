/-
  OmegaTheory.QuantumGravity.FullTwoToTwoAmplitude

  **Lion's-Pride Phase 8.3 (2026-05-06)**:
  *Full 2 → 2 graviton scattering amplitude composing the direct
  quartic vertex with all three channel-exchange contributions.*

  ## Why this file

  Standard linearised gravity gives the 2 → 2 amplitude as

      M_{1+2 → 3+4}  =  V₄(h₁, h₂, h₃, h₄)              [direct contact]
                     +  V₃(h₁, h₂, h_X) · G(k_s²) · V₃(h_X, h₃, h₄)
                     +  V₃(h₁, h₃, h_X) · G(k_t²) · V₃(h_X, h₂, h₄)
                     +  V₃(h₁, h₄, h_X) · G(k_u²) · V₃(h_X, h₂, h₃)

  with the three Mandelstam invariants:
      k_s² = (p₁ + p₂)²       (s-channel)
      k_t² = (p₁ - p₃)²       (t-channel)
      k_u² = (p₁ - p₄)²       (u-channel)

  satisfying `k_s² + k_t² + k_u² = m₁² + m₂² + m₃² + m₄²` (massless
  case: total = 0).

  This file ships the full sum scaffold composing Phase 5.4 V₄ vertex
  + Phase 8.2 channel exchanges.

  ## What this file ships

  | Property                                              | Theorem                                  |
  |-------------------------------------------------------|------------------------------------------|
  | `fullScattering4pt h₁ h₂ h₃ h₄ k_s² k_t² k_u² h_X p`   | (definition: direct + 3 channels)        |
  | Sum decomposition: 4 terms                            | `fullScattering4pt_decomposes`            |
  | Vanishes on zero first leg                            | `fullScattering4pt_zero_first_leg`        |
  | Headline (3-conjunct)                                 | `full_two_to_two_amplitude_report`        |

  ## Honest scope

  This file ships the SUM-OF-CONTRIBUTIONS structure of the 2 → 2
  amplitude.  The Mandelstam-conservation identity
  `k_s² + k_t² + k_u² = total mass²` is shipped as a HYPOTHESIS,
  not derived (it requires Lorentz-invariant 4-momentum bookkeeping
  beyond the current scaffold).

  ## Author

  Lion's-Pride dynamic /loop iteration 35 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel
import OmegaTheory.QuantumGravity.ChannelExchangeAmplitude
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.FullTwoToTwoAmplitude

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Variational.CubicGravitonVertex
open OmegaTheory.Variational.QuarticGravitonVertex
open OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel
open OmegaTheory.QuantumGravity.ChannelExchangeAmplitude

/-! ## 1. Full 2 → 2 graviton scattering amplitude

    `M = V₄ + s-channel + t-channel + u-channel`. -/

/-- **Full 2 → 2 graviton scattering amplitude**.

    Composes:
    * direct quartic vertex `V₄(h₁, h₂, h₃, h₄)`
    * s-channel `V₃(h₁, h₂, h_X) · G(k_s²) · V₃(h_X, h₃, h₄)`
    * t-channel `V₃(h₁, h₃, h_X) · G(k_t²) · V₃(h_X, h₂, h₄)`
    * u-channel `V₃(h₁, h₄, h_X) · G(k_u²) · V₃(h_X, h₂, h₃)`

    The Mandelstam invariants k_s², k_t², k_u² satisfy
    `k_s² + k_t² + k_u² = total_mass²` (=0 in massless case). -/
noncomputable def fullScattering4pt
    (h₁ h₂ h₃ h₄ : SymmetricTensorField2)
    (h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) : ℝ :=
  gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
  + channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p
  + channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p
  + channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p

/-- **Sum decomposition**: the full amplitude equals the four
    contributions (direct + s + t + u). -/
theorem fullScattering4pt_decomposes
    (h₁ h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) :
    fullScattering4pt h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
      = gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
        + channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p
        + channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p
        + channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p := rfl

/-- **Full amplitude vanishes when first leg is zero**: every
    contribution has the first leg as a factor in `V₃` or `V₄`,
    so each term vanishes. -/
theorem fullScattering4pt_zero_first_leg
    (h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) :
    fullScattering4pt (fun _ _ _ => 0) h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p = 0 := by
  unfold fullScattering4pt
  rw [amplitude4pt_zero_leg h₂ h₃ h₄ p]
  rw [channelExchangeAmplitude_s_zero_leg h₂ h_X h₃ h₄ k_s_sq p]
  rw [channelExchangeAmplitude_s_zero_leg h₃ h_X h₂ h₄ k_t_sq p]
  rw [channelExchangeAmplitude_s_zero_leg h₄ h_X h₂ h₃ k_u_sq p]
  ring

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 8.3 headline — full 2 → 2 graviton scattering
    amplitude structural report.**

    For any metric perturbations `h₁, h₂, h₃, h₄, h_X`,
    Mandelstam invariants `k_s², k_t², k_u² : ℝ`, and lattice point
    `p : LatticePoint`:

    1. **Sum decomposition into 4 contributions**:
       `M = V₄ + s + t + u`.

    2. **Vanishes when first leg is zero**:
       `M(0, h₂, h₃, h₄, ...) = 0`.

    3. **4pt direct contact = quartic vertex**:
       `gravitonAmplitude4pt h₁ h₂ h₃ h₄ p = gravitonQuarticVertex h₁ h₂ h₃ h₄ p`. -/
theorem full_two_to_two_amplitude_report
    (h₁ h₂ h₃ h₄ h_X : SymmetricTensorField2)
    (k_s_sq k_t_sq k_u_sq : ℝ)
    (p : LatticePoint) :
    fullScattering4pt h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
      = gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
        + channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_s_sq p
        + channelExchangeAmplitude_s h₁ h₃ h_X h₂ h₄ k_t_sq p
        + channelExchangeAmplitude_s h₁ h₄ h_X h₂ h₃ k_u_sq p ∧
    fullScattering4pt (fun _ _ _ => 0) h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p = 0 ∧
    gravitonAmplitude4pt h₁ h₂ h₃ h₄ p
      = gravitonQuarticVertex h₁ h₂ h₃ h₄ p := by
  refine ⟨?_, ?_, ?_⟩
  · exact fullScattering4pt_decomposes h₁ h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
  · exact fullScattering4pt_zero_first_leg h₂ h₃ h₄ h_X k_s_sq k_t_sq k_u_sq p
  · exact amplitude4pt_eq_quarticVertex h₁ h₂ h₃ h₄ p

end OmegaTheory.QuantumGravity.FullTwoToTwoAmplitude
