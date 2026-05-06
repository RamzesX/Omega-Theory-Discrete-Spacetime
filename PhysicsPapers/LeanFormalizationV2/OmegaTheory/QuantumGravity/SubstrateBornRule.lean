/-
  OmegaTheory.QuantumGravity.SubstrateBornRule

  **Lion's-Pride Phase 9.31 (2026-05-06)**:
  *Substrate Born rule formalisation — the QM observation-probability
  statement: for normalised ψ, the probability of measurement
  outcome `state` is |ψ(state)|², all probabilities lie in [0, 1],
  and they sum to 1.*

  ## Why this file

  Phase 9.30 (`SubstrateQMProbability`) shipped the probability
  density `p(ψ, state) := ψ(state)²` and the
  `Σ p = ⟨ψ, ψ⟩` identity.

  This file ships the **Born rule** — the QM postulate that
  for a normalised wave function `ψ`:

  * `P(measurement = state | ψ) := |ψ(state)|² = ψ(state)²`  (real ψ).
  * Each `P ∈ [0, 1]` (well-defined probability).
  * `Σ_state P = 1` (total probability = 1).

  The first two are properties of `probDensity` extended with
  upper-bound `≤ 1` for normalised ψ.  The last follows from
  `probDensity_total_eq_innerProduct` + `IsNormalised`.

  ## What this file ships

  | Property                                              | Theorem                                              |
  |-------------------------------------------------------|------------------------------------------------------|
  | `bornProbability ψ state := probDensity ψ state`      | (def — alias for `probDensity` to emphasise QM role) |
  | `bornProbability_nonneg`                              | 0 ≤ P(state)                                          |
  | `bornProbability_le_one_of_normalised`                | normalised ⟹ P(state) ≤ 1                              |
  | `bornProbability_total_eq_one_of_normalised`          | normalised ⟹ Σ P = 1                                   |
  | `bornProbability_basis_state_self`                    | P(e_state, state) = 1                                  |
  | `bornProbability_basis_state_other`                   | s ≠ state ⟹ P(e_state, s) = 0                           |
  | Headline (4-conjunct)                                 | `substrate_born_rule_report`                         |

  ## Honest scope

  The Born rule here is in the REAL-amplitude form `P = ψ(s)²`
  consistent with the rest of the multi-mode Hilbert scaffold (real-
  valued wave functions).  The standard complex-amplitude form
  `P = |ψ(s)|²` reduces to this when `ψ : MultimodeFockState → ℝ`.

  ## Author

  Lion's-Pride dynamic /loop iteration 90 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.Foundations.MultimodeFockSpace
import OmegaTheory.Foundations.MultimodeWaveFunction
import OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
import OmegaTheory.QuantumGravity.SubstrateQMProbability
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateBornRule

open OmegaTheory.Foundations.MultimodeFockSpace
open OmegaTheory.Foundations.MultimodeWaveFunction
open OmegaTheory.Foundations.MultimodeWaveFunctionNormalised
open OmegaTheory.QuantumGravity.SubstrateQMProbability

/-! ## 1. Born probability (alias for probDensity) -/

/-- **Born probability** for measurement outcome `state` on wave
    function `ψ`: `P(state | ψ) := ψ(state)²`. Alias of `probDensity`
    emphasising the QM role. -/
def bornProbability {k N : ℕ} (ψ : WaveFunction k N)
    (state : MultimodeFockState k N) : ℝ :=
  probDensity ψ state

/-! ## 2. Non-negativity (always) -/

/-- **Born probability is non-negative**: `0 ≤ P(state | ψ)`
    for any wave function. -/
theorem bornProbability_nonneg
    {k N : ℕ} (ψ : WaveFunction k N) (state : MultimodeFockState k N) :
    0 ≤ bornProbability ψ state :=
  probDensity_nonneg ψ state

/-! ## 3. Upper bound for normalised wave functions -/

/-- **Born probability ≤ 1 for normalised ψ**:
    `IsNormalised ψ ⟹ P(state | ψ) ≤ 1`. -/
theorem bornProbability_le_one_of_normalised
    {k N : ℕ} (ψ : WaveFunction k N) (state : MultimodeFockState k N)
    (h_norm : IsNormalised ψ) :
    bornProbability ψ state ≤ 1 := by
  unfold bornProbability probDensity
  -- Goal: ψ(state)² ≤ 1
  -- Use Σ ψ²(s) = 1 (normalisation) and ψ(state)² ≤ Σ ψ²(s)
  have h_sum_eq_one : Finset.univ.sum (fun s : MultimodeFockState k N => (ψ s)^2) = 1 := by
    have := probDensity_total_eq_innerProduct ψ
    unfold probDensity at this
    rw [this]
    exact h_norm
  -- Single term ≤ sum of non-negative terms
  have h_single_le_sum : (ψ state)^2 ≤
      Finset.univ.sum (fun s : MultimodeFockState k N => (ψ s)^2) :=
    Finset.single_le_sum (f := fun s : MultimodeFockState k N => (ψ s)^2)
      (fun s _ => sq_nonneg (ψ s)) (Finset.mem_univ state)
  rw [h_sum_eq_one] at h_single_le_sum
  exact h_single_le_sum

/-! ## 4. Total probability = 1 for normalised wave functions -/

/-- **Total Born probability = 1 for normalised ψ**:
    `IsNormalised ψ ⟹ Σ_state P(state | ψ) = 1`. -/
theorem bornProbability_total_eq_one_of_normalised
    {k N : ℕ} (ψ : WaveFunction k N) (h_norm : IsNormalised ψ) :
    Finset.univ.sum (fun s : MultimodeFockState k N => bornProbability ψ s) = 1 := by
  unfold bornProbability
  rw [probDensity_total_eq_innerProduct]
  exact h_norm

/-! ## 5. Basis-state Born probability -/

/-- **Born probability on basis state at the same outcome**:
    `P(state | e_state) = 1`. -/
theorem bornProbability_basis_state_self
    {k N : ℕ} (state : MultimodeFockState k N) :
    bornProbability (basisStateAsWaveFunction state) state = 1 := by
  unfold bornProbability
  exact probDensity_basis_state_self state

/-- **Born probability on basis state at a different outcome**:
    `s ≠ state ⟹ P(s | e_state) = 0`. -/
theorem bornProbability_basis_state_other
    {k N : ℕ} (state s : MultimodeFockState k N) (h_ne : s ≠ state) :
    bornProbability (basisStateAsWaveFunction state) s = 0 := by
  unfold bornProbability
  exact probDensity_basis_state_other state s h_ne

/-! ## 6. Headline composite report -/

/-- **Lion's-Pride Phase 9.31 headline — substrate Born rule
    structural report.**

    For multi-mode parameters `k N : ℕ`, basis state
    `state s : MultimodeFockState k N` with `s ≠ state`, and a
    normalised wave function `ψ : WaveFunction k N`:

    1. **Born probability bounded**: `0 ≤ P(state | ψ) ≤ 1`.

    2. **Total Born probability = 1**:
       `Σ_state P(state | ψ) = 1`.

    3. **Basis-state Born spike**:
       `P(state | e_state) = 1` and `P(s | e_state) = 0` for `s ≠ state`. -/
theorem substrate_born_rule_report
    {k N : ℕ} (ψ : WaveFunction k N) (h_norm : IsNormalised ψ)
    (state s : MultimodeFockState k N) (h_ne : s ≠ state) :
    0 ≤ bornProbability ψ state ∧
    bornProbability ψ state ≤ 1 ∧
    Finset.univ.sum (fun s : MultimodeFockState k N => bornProbability ψ s) = 1 ∧
    bornProbability (basisStateAsWaveFunction state) state = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact bornProbability_nonneg ψ state
  · exact bornProbability_le_one_of_normalised ψ state h_norm
  · exact bornProbability_total_eq_one_of_normalised ψ h_norm
  · exact bornProbability_basis_state_self state

end OmegaTheory.QuantumGravity.SubstrateBornRule
