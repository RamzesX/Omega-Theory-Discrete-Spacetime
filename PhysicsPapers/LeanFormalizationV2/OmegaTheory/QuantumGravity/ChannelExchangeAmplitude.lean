/-
  OmegaTheory.QuantumGravity.ChannelExchangeAmplitude

  **Lion's-Pride Phase 8.2 (2026-05-06)**:
  *Channel-exchange amplitude `V₃ · G(k²) · V₃` composing the cubic
  graviton vertex with the substrate-regulated propagator.*

  ## Why this file

  Phase 8.1 shipped the direct (contact) `V₃` and `V₄` Feynman rules.
  The full 2 → 2 graviton scattering amplitude additionally includes
  three exchange-channel diagrams:

      M_{1+2 → 3+4}^{s-channel}  =  V₃(h₁, h₂, h_X) · G(k_s²) · V₃(h_X, h₃, h₄)
      M_{1+2 → 3+4}^{t-channel}  =  V₃(h₁, h₃, h_X) · G(k_t²) · V₃(h_X, h₂, h₄)
      M_{1+2 → 3+4}^{u-channel}  =  V₃(h₁, h₄, h_X) · G(k_u²) · V₃(h_X, h₂, h₃)

  where `h_X` is the virtual intermediate graviton and `k_{s,t,u}²`
  are the Mandelstam invariants.

  This file ships the s-channel scaffold using:
  * `gravitonCubicVertex` from Phase 5.3
  * `gravitonPropagator` from Phase 7.5

  The t- and u-channel forms differ only by leg permutation, so the
  Phase-8.1 S₃ symmetry of `V₃` makes them straightforward variants.

  ## What this file ships

  | Property                                              | Theorem                                  |
  |-------------------------------------------------------|------------------------------------------|
  | `channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_sq p`    | (definition)                             |
  | `channelExchangeAmplitude_s_zero_leg`                  | (vanishes if first leg is zero)           |
  | `channelExchangeAmplitude_s_propagator_positive`        | (positivity contribution from G(k²))      |
  | Headline (3-conjunct)                                 | `channel_exchange_amplitude_report`        |

  ## Honest scope

  This file ships the s-CHANNEL scaffold.  The t- and u-channels are
  simple permutations.  The full 2 → 2 amplitude

      M_{2→2} = V₄ + (s-channel + t-channel + u-channel)

  is shipped via the headline-composition pattern as Phase 8.3 work
  (it requires Mandelstam-invariant Lorentz-invariant integrand
  conventions — multi-week port).

  ## Author

  Lion's-Pride dynamic /loop iteration 34 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Variational.CubicGravitonVertex
import OmegaTheory.Foundations.SubstratePropagator
import OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.ChannelExchangeAmplitude

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Variational.CubicGravitonVertex
open OmegaTheory.Foundations.SubstratePropagator
open OmegaTheory.QuantumGravity.GravitonScatteringTreeLevel

/-! ## 1. The s-channel exchange amplitude

    `M_s := V₃(h₁, h₂, h_X) · G(k_s²) · V₃(h_X, h₃, h₄)`. -/

/-- **s-channel exchange amplitude**.

    The virtual graviton `h_X` is exchanged between the
    `(h₁, h₂)`-vertex and the `(h₃, h₄)`-vertex; the amplitude is
    the product of the two cubic vertices and the substrate-regulated
    propagator at the s-channel Mandelstam invariant `k_s² = (p₁ + p₂)²`. -/
noncomputable def channelExchangeAmplitude_s
    (h₁ h₂ h_X h₃ h₄ : SymmetricTensorField2)
    (k_sq : ℝ) (p : LatticePoint) : ℝ :=
  gravitonCubicVertex h₁ h₂ h_X p
    * gravitonPropagator k_sq
    * gravitonCubicVertex h_X h₃ h₄ p

/-- **s-channel amplitude vanishes when first leg is zero**. -/
theorem channelExchangeAmplitude_s_zero_leg
    (h₂ h_X h₃ h₄ : SymmetricTensorField2)
    (k_sq : ℝ) (p : LatticePoint) :
    channelExchangeAmplitude_s (fun _ _ _ => 0) h₂ h_X h₃ h₄ k_sq p = 0 := by
  unfold channelExchangeAmplitude_s
  rw [gravitonCubicVertex_zero_left h₂ h_X p]
  ring

/-- **s-channel amplitude factorises as `V₃ · G · V₃`**. -/
theorem channelExchangeAmplitude_s_factorises
    (h₁ h₂ h_X h₃ h₄ : SymmetricTensorField2)
    (k_sq : ℝ) (p : LatticePoint) :
    channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_sq p
      = gravitonCubicVertex h₁ h₂ h_X p
        * gravitonPropagator k_sq
        * gravitonCubicVertex h_X h₃ h₄ p := rfl

/-- **s-channel amplitude positivity** when both cubic vertices are
    positive AND `k² > 0`. -/
theorem channelExchangeAmplitude_s_pos
    (h₁ h₂ h_X h₃ h₄ : SymmetricTensorField2)
    (k_sq : ℝ) (p : LatticePoint)
    (h_v1 : 0 < gravitonCubicVertex h₁ h₂ h_X p)
    (h_v2 : 0 < gravitonCubicVertex h_X h₃ h₄ p)
    (hk : 0 < k_sq) :
    0 < channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_sq p := by
  unfold channelExchangeAmplitude_s
  have hG : 0 < gravitonPropagator k_sq := gravitonPropagator_pos k_sq hk
  have h_v1_G : 0 < gravitonCubicVertex h₁ h₂ h_X p * gravitonPropagator k_sq :=
    mul_pos h_v1 hG
  exact mul_pos h_v1_G h_v2

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 8.2 headline — channel-exchange amplitude
    structural report.**

    For any metric perturbations `h₁, h₂, h_X, h₃, h₄`,
    momentum-squared `k_sq : ℝ`, and lattice point `p : LatticePoint`:

    1. **s-channel factorises as `V₃ · G · V₃`**:
       `channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_sq p
          = V₃(h₁, h₂, h_X) · G(k²) · V₃(h_X, h₃, h₄)`.

    2. **Vanishes on zero first leg**:
       `channelExchangeAmplitude_s 0 h₂ h_X h₃ h₄ k_sq p = 0`.

    3. **Reciprocal-momentum identity**:
       `gravitonPropagator k² · k² = 1` for `k² > 0`. -/
theorem channel_exchange_amplitude_report
    (h₁ h₂ h_X h₃ h₄ : SymmetricTensorField2)
    (k_sq : ℝ) (hk : 0 < k_sq) (p : LatticePoint) :
    channelExchangeAmplitude_s h₁ h₂ h_X h₃ h₄ k_sq p
      = gravitonCubicVertex h₁ h₂ h_X p
        * gravitonPropagator k_sq
        * gravitonCubicVertex h_X h₃ h₄ p ∧
    channelExchangeAmplitude_s (fun _ _ _ => 0) h₂ h_X h₃ h₄ k_sq p = 0 ∧
    gravitonPropagator k_sq * k_sq = 1 := by
  refine ⟨?_, ?_, ?_⟩
  · exact channelExchangeAmplitude_s_factorises h₁ h₂ h_X h₃ h₄ k_sq p
  · exact channelExchangeAmplitude_s_zero_leg h₂ h_X h₃ h₄ k_sq p
  · exact gravitonPropagator_inv k_sq (ne_of_gt hk)

end OmegaTheory.QuantumGravity.ChannelExchangeAmplitude
