/-
  OmegaTheory.Predictions.SubstratePhysicalBoundsMetaCapstone

  **Lion's-Pride Phase 9.34 (2026-05-06)**:
  *Substrate physical-bounds META-CAPSTONE composing one substantive
  identity from EACH of Phase 9.30 (probability density),
  Phase 9.31 (Born rule), Phase 9.32 (expectation bound), and
  Phase 9.33 (uncertainty bounded) into a single 7-conjunct
  theorem — the unified physical-content layer of the substrate
  QM machinery.*

  ## Why this file

  Four physical-content files now exist:

  * **Phase 9.30** — probability density `p(ψ, state) := ψ(state)²`.
  * **Phase 9.31** — Born rule (P ≤ 1, total = 1, basis spike).
  * **Phase 9.32** — expectation bound `⟨N̂⟩(ψ) ≤ k·N`.
  * **Phase 9.33** — uncertainty bounded `0 ≤ Var ≤ ⟨N̂²⟩ ≤ (k·N)²`.

  This file ships the META-CAPSTONE bundling concrete identities
  from each phase into a single 7-conjunct theorem.  Captures the
  FULL physical-content layer of the substrate machinery: probability,
  observation statistics, observable bounds.

  ## What this file ships

  | Phase | Identity                                                              |
  |-------|-----------------------------------------------------------------------|
  | 9.30  | `probDensity_total_eq_innerProduct`: Σ p = ⟨ψ, ψ⟩                       |
  | 9.31  | `bornProbability_le_one_of_normalised`: P ≤ 1                          |
  | 9.31  | `bornProbability_total_eq_one_of_normalised`: Σ P = 1                   |
  | 9.32  | `expectationN_le_kN_of_normalised`: ⟨N̂⟩ ≤ k·N                          |
  | 9.33  | `expectationN_squared_le_kN_sq_of_normalised`: ⟨N̂²⟩ ≤ (k·N)²            |
  | 9.33  | `varianceN_le_kN_sq_of_normalised`: Var ≤ (k·N)²                        |
  | 7.21  | `varianceN_nonneg_of_normalised`: 0 ≤ Var                               |

  ## Author

  Lion's-Pride dynamic /loop iteration 94 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
import OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
import OmegaTheory.Foundations.MultimodeWaveFunctionVariance
import OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
import OmegaTheory.QuantumGravity.SubstrateQMProbability
import OmegaTheory.QuantumGravity.SubstrateBornRule
import OmegaTheory.QuantumGravity.SubstrateExpectationBound
import OmegaTheory.QuantumGravity.SubstrateUncertaintyBound
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.SubstratePhysicalBoundsMetaCapstone

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.Foundations.MultimodeWaveFunctionExpectation
open OmegaTheory.Foundations.MultimodeWaveFunctionSecondMoment
open OmegaTheory.Foundations.MultimodeWaveFunctionVariance
open OmegaTheory.Foundations.MultimodeWaveFunctionVarianceNonneg
open OmegaTheory.QuantumGravity.SubstrateQMProbability
open OmegaTheory.QuantumGravity.SubstrateBornRule
open OmegaTheory.QuantumGravity.SubstrateExpectationBound
open OmegaTheory.QuantumGravity.SubstrateUncertaintyBound

/-! ## The substrate physical-bounds META-CAPSTONE -/

/-- **SUBSTRATE PHYSICAL-BOUNDS META-CAPSTONE** — composing one
    substantive identity from EACH of Phase 9.30, 9.31, 9.32,
    9.33, and the keystone variance non-negativity (7.21) into
    a single 7-conjunct theorem.

    For multi-mode parameters `k N : ℕ` (with `k ≠ 0`), basis state
    `state : MultimodeFockState k N`, and a NORMALISED wave function
    `ψ : WaveFunction k N`:

    1. **Phase 9.30** — total = inner product:
       `Σ_state p(ψ, state) = ⟨ψ, ψ⟩`.

    2. **Phase 9.31** — Born probability ≤ 1:
       `P(state | ψ) ≤ 1`.

    3. **Phase 9.31** — total Born = 1:
       `Σ P = 1`.

    4. **Phase 9.32** — expectation bound:
       `⟨ψ| N̂ |ψ⟩ ≤ k · N`.

    5. **Phase 9.33** — second-moment bound:
       `⟨ψ| N̂² |ψ⟩ ≤ (k · N)²`.

    6. **Phase 9.33** — variance bound:
       `(ΔN̂)²(ψ) ≤ (k · N)²`.

    7. **Phase 7.21** — Heisenberg variance non-negativity:
       `0 ≤ (ΔN̂)²(ψ)`. -/
theorem substrate_physical_bounds_meta_capstone
    {k N : ℕ} [NeZero k] (state : MultimodeFockState k N)
    (ψ : WaveFunction k N) (h_norm : IsNormalised ψ) :
    -- (1) Phase 9.30 total = ⟨ψ, ψ⟩
    Finset.univ.sum (fun s : MultimodeFockState k N => probDensity ψ s)
      = innerProduct ψ ψ ∧
    -- (2) Phase 9.31 Born ≤ 1
    bornProbability ψ state ≤ 1 ∧
    -- (3) Phase 9.31 Σ Born = 1
    Finset.univ.sum (fun s : MultimodeFockState k N => bornProbability ψ s) = 1 ∧
    -- (4) Phase 9.32 expectation bound
    expectationN ψ ≤ (k * N : ℝ) ∧
    -- (5) Phase 9.33 second-moment bound
    expectationN_squared ψ ≤ ((k * N : ℝ))^2 ∧
    -- (6) Phase 9.33 variance bound
    varianceN ψ ≤ ((k * N : ℝ))^2 ∧
    -- (7) Phase 7.21 Heisenberg non-negativity
    0 ≤ varianceN ψ := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact probDensity_total_eq_innerProduct ψ
  · exact bornProbability_le_one_of_normalised ψ state h_norm
  · exact bornProbability_total_eq_one_of_normalised ψ h_norm
  · exact expectationN_le_kN_of_normalised ψ h_norm
  · exact expectationN_squared_le_kN_sq_of_normalised ψ h_norm
  · exact varianceN_le_kN_sq_of_normalised ψ h_norm
  · exact varianceN_nonneg_of_normalised ψ h_norm

/-! ## Frozen-Nat substrate physical-bounds snapshot -/

/-- **Substrate physical-bounds phase count snapshot**:
    9.30 + 9.31 + 9.32 + 9.33 + 7.21 + 9.34 = 6 phases. -/
def substratePhysicalBounds_phase_count : ℕ := 6

/-- **Substrate physical-bounds property count**:
    1 (probDensity) + 2 (Born) + 1 (expectation) + 2 (second + variance bound)
    + 1 (Heisenberg non-neg) = 7 properties. -/
def substratePhysicalBounds_property_count : ℕ := 7

/-- **Frozen-Nat substrate physical-bounds snapshot —
    verifiable via `decide`**. -/
theorem substrate_physical_bounds_snapshot :
    substratePhysicalBounds_phase_count = 6 ∧
    substratePhysicalBounds_property_count = 7 ∧
    substratePhysicalBounds_phase_count + substratePhysicalBounds_property_count = 13 := by
  refine ⟨rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.SubstratePhysicalBoundsMetaCapstone
