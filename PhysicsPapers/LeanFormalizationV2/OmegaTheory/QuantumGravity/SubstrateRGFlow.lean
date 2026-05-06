/-
  OmegaTheory.QuantumGravity.SubstrateRGFlow

  **Lion's-Pride Phase 9.3 (2026-05-06)**:
  *Substrate truncation `N → ∞` as IR renormalisation-group flow.*

  ## Why this file

  The substrate truncation depth `N : ℕ` controls the resolution of the
  computational-uncertainty residual `δ_comp(N) = ℓ_P · 4/(2N+3)`.

  As `N → ∞`:
    `δ_comp(N) → 0⁺`

  This is the IR (long-distance, low-energy) limit of substrate-QG:
  the truncation precision saturates, and the substrate's lattice-
  scale ambiguity vanishes.  In the language of renormalisation
  groups:
    * `N` is an inverse RG scale (small N = large scale = UV;
      large N = small scale = IR).
    * The "RG flow" is parametric in `N`, with one-step `N → N+1`
      decreasing `δ_comp`.
    * The IR fixed point is `δ_comp = 0`.

  This file ships the foundational MONOTONE-DECREASING property of
  the substrate RG scale, plus its strict positivity at every finite
  N.  The IR-fixed-point statement `δ_comp → 0` requires the Tendsto
  machinery which is present elsewhere in the project; we cite it
  rather than re-derive it here.

  ## What this file ships

  | Property                                              | Theorem                                  |
  |-------------------------------------------------------|------------------------------------------|
  | `substrateRGScale N := computationalUncertainty N`     | (definition)                             |
  | `substrateRGScale_pos`                                 | scale > 0 at every N                     |
  | `substrateRGScale_decreasing`                          | scale(N+1) ≤ scale(N) (monotone IR flow) |
  | Headline (3-conjunct)                                 | `substrate_rg_flow_report`                |

  ## Honest scope

  This file ships the foundational monotone-decreasing identity.
  It does NOT yet:
  * Prove `substrateRGScale → 0` as `N → ∞` (Tendsto — proven
    elsewhere in `OmegaTheory/Predictions/ExtendedBoundStability.lean`).
  * Compute concrete RG-flow trajectories of running couplings
    (Phase 9.4 — multi-month).
  * Identify the IR fixed point as a critical universality class
    (Phase 9.4+).

  What it DOES ship: the substrate RG scale is monotone, positive,
  and approaches the IR fixed point `δ_comp = 0` as `N → ∞` (cited).

  ## Author

  Lion's-Pride dynamic /loop iteration 36 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Irrationality.Uncertainty
import OmegaTheory.QuantumGravity.SubstrateUVRegularisation
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRGFlow

open OmegaTheory.Irrationality
open OmegaTheory.QuantumGravity.SubstrateUVRegularisation

/-! ## 1. The substrate RG scale

    `substrateRGScale N := computationalUncertainty N`. -/

/-- **Substrate RG scale at depth `N`**: identifies the substrate's
    truncation residual `δ_comp(N)` as the running RG scale.

    `N` interpreted as inverse RG depth: small N = UV, large N = IR. -/
noncomputable def substrateRGScale (N : ℕ) : ℝ :=
  computationalUncertainty N

/-- **Substrate RG scale is positive at every finite N**. -/
theorem substrateRGScale_pos (N : ℕ) : 0 < substrateRGScale N :=
  computationalUncertainty_pos N

/-- **Substrate RG scale is monotone decreasing**: `scale(N+1) ≤ scale(N)`.

    This is the IR direction of the RG flow: incrementing N decreases
    the truncation residual `δ_comp`, moving toward the IR fixed point. -/
theorem substrateRGScale_decreasing (N : ℕ) :
    substrateRGScale (N + 1) ≤ substrateRGScale N := by
  unfold substrateRGScale
  exact computationalUncertainty_decreasing N

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 9.3 headline — substrate RG flow structural
    report.**

    For any truncation depth `N : ℕ`:

    1. **Substrate RG scale is positive**: `substrateRGScale N > 0`.

    2. **Monotone IR flow**: `substrateRGScale (N+1) ≤ substrateRGScale N`.

    3. **Substrate RG scale identifies as `δ_comp(N)`**:
       `substrateRGScale N = computationalUncertainty N`. -/
theorem substrate_rg_flow_report (N : ℕ) :
    0 < substrateRGScale N ∧
    substrateRGScale (N + 1) ≤ substrateRGScale N ∧
    substrateRGScale N = computationalUncertainty N := by
  refine ⟨?_, ?_, ?_⟩
  · exact substrateRGScale_pos N
  · exact substrateRGScale_decreasing N
  · rfl

end OmegaTheory.QuantumGravity.SubstrateRGFlow
