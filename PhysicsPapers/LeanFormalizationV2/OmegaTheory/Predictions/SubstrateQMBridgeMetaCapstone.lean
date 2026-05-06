/-
  OmegaTheory.Predictions.SubstrateQMBridgeMetaCapstone

  **Lion's-Pride Phase 7.24 (2026-05-06)**:
  *Substrate QM-bridge META-CAPSTONE composing one substantive
  identity from EACH of Phase 9.30 (probability density),
  Phase 9.31 (Born rule), and Phase 7.21 (Heisenberg variance
  non-negativity) into a single 6-conjunct theorem — the unified
  bridge between multi-mode Hilbert structure and QM observation
  statistics.*

  ## Why this file

  Three QM-bridge files connect the multi-mode Hilbert scaffold
  (7.7-7.23) to physical QM observation statistics:

  * **Phase 9.30** — probability density `p(ψ, state) := ψ(state)²`
    with non-negativity, total = ⟨ψ,ψ⟩, basis spike.
  * **Phase 9.31** — Born rule statement: P(state | ψ) = ψ(state)²
    with normalised bounds 0 ≤ P ≤ 1, total = 1, basis spike.
  * **Phase 7.21** — Heisenberg variance non-negativity:
    `0 ≤ (ΔN̂)²(ψ)` for normalised `ψ` via discrete Cauchy-Schwarz.

  This file ships the META-CAPSTONE composing concrete identities
  from each phase into one 6-conjunct theorem.  Captures the FULL
  QM-bridge content of the substrate machinery.

  ## What this file ships

  | Phase | Identity                                                              |
  |-------|-----------------------------------------------------------------------|
  | 9.30  | `probDensity_nonneg`: 0 ≤ p(ψ, state)                                  |
  | 9.30  | `probDensity_total_eq_innerProduct`: Σ p = ⟨ψ, ψ⟩                       |
  | 9.31  | `bornProbability_le_one_of_normalised`: P ≤ 1 normalised                |
  | 9.31  | `bornProbability_total_eq_one_of_normalised`: Σ P = 1                   |
  | 9.31  | `bornProbability_basis_state_self`: P(state | e_state) = 1              |
  | 7.21  | `varianceN_nonneg_of_normalised`: 0 ≤ (ΔN̂)²(ψ) normalised                |

  ## Author

  Lion's-Pride dynamic /loop iteration 91 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import OmegaTheory.Foundations.MultimodeWaveFunctionVariance
import OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
import OmegaTheory.QuantumGravity.SubstrateQMProbability
import OmegaTheory.QuantumGravity.SubstrateBornRule
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.SubstrateQMBridgeMetaCapstone

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.Foundations.MultimodeWaveFunctionVariance
open OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
open OmegaTheory.QuantumGravity.SubstrateQMProbability
open OmegaTheory.QuantumGravity.SubstrateBornRule

/-! ## The substrate QM-bridge META-CAPSTONE -/

/-- **SUBSTRATE QM-BRIDGE META-CAPSTONE** — composing one
    substantive identity from EACH of Phase 9.30 (probability
    density), Phase 9.31 (Born rule), and Phase 7.21 (Heisenberg
    variance non-negativity) into a single 6-conjunct theorem.

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`), basis state
    `state : MultimodeFockState k N`, and a NORMALISED wave function
    `ψ : WaveFunction k N`:

    1. **Phase 9.30** — probability density non-negativity:
       `0 ≤ p(ψ, state)`.

    2. **Phase 9.30** — total = inner product:
       `Σ_state p(ψ, state) = ⟨ψ, ψ⟩`.

    3. **Phase 9.31** — Born probability ≤ 1 (normalised):
       `P(state | ψ) ≤ 1`.

    4. **Phase 9.31** — total Born probability = 1:
       `Σ_state P(state | ψ) = 1`.

    5. **Phase 9.31** — basis-state Born spike:
       `P(state | e_state) = 1`.

    6. **Phase 7.21** — Heisenberg variance non-negativity:
       `0 ≤ (ΔN̂)²(ψ)`. -/
theorem substrate_qm_bridge_meta_capstone
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N)
    (ψ : WaveFunction k N) (h_norm : IsNormalised ψ) :
    -- (1) Phase 9.30 probDensity non-neg
    0 ≤ probDensity ψ state ∧
    -- (2) Phase 9.30 total probability = ⟨ψ, ψ⟩
    Finset.univ.sum (fun s : MultimodeFockState k N => probDensity ψ s)
      = innerProduct ψ ψ ∧
    -- (3) Phase 9.31 Born probability ≤ 1
    bornProbability ψ state ≤ 1 ∧
    -- (4) Phase 9.31 Born total = 1
    Finset.univ.sum (fun s : MultimodeFockState k N => bornProbability ψ s) = 1 ∧
    -- (5) Phase 9.31 basis-state Born spike
    bornProbability (basisStateAsWaveFunction state) state = 1 ∧
    -- (6) Phase 7.21 Heisenberg variance non-neg
    0 ≤ varianceN ψ := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact probDensity_nonneg ψ state
  · exact probDensity_total_eq_innerProduct ψ
  · exact bornProbability_le_one_of_normalised ψ state h_norm
  · exact bornProbability_total_eq_one_of_normalised ψ h_norm
  · exact bornProbability_basis_state_self state
  · exact varianceN_nonneg_of_normalised ψ h_norm

/-! ## Frozen-Nat substrate QM-bridge snapshot -/

/-- **Substrate QM-bridge phase count snapshot**:
    9.30 + 9.31 + 7.21 + 7.24 = 4 phases. -/
def substrateQMBridge_phase_count : ℕ := 4

/-- **Substrate QM-bridge property count**:
    probDensity (3) + Born rule (4) + Heisenberg (1) = 8 properties. -/
def substrateQMBridge_property_count : ℕ := 8

/-- **Frozen-Nat substrate QM-bridge snapshot —
    verifiable via `decide`**. -/
theorem substrate_qm_bridge_snapshot :
    substrateQMBridge_phase_count = 4 ∧
    substrateQMBridge_property_count = 8 ∧
    substrateQMBridge_phase_count + substrateQMBridge_property_count = 12 := by
  refine ⟨rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.SubstrateQMBridgeMetaCapstone
