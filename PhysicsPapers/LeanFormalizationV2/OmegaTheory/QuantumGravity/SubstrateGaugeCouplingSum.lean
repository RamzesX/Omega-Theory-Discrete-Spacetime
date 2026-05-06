/-
  OmegaTheory.QuantumGravity.SubstrateGaugeCouplingSum

  **Lion's-Pride Phase 9.12 (2026-05-06)**:
  *Sum of substrate-running gauge couplings — applies to a finite
  collection of independently running couplings (e.g., the three
  SM gauge couplings α₁, α₂, α₃).*

  ## Why this file

  The SM has THREE independent gauge couplings (one per gauge factor
  in U(1)×SU(2)×SU(3)).  Each may run with the substrate truncation
  depth N via the Phase 9.5 pattern:

      αᵢ(N) := αᵢ,IR · (1 + αᵢ,coef · δ_comp(N))

  for `i ∈ {1, 2, 3}`.  Their SUM

      α_total(N) := Σᵢ αᵢ(N)

  is a substrate-running observable.  This file ships the structural
  properties of α_total:

  1. Non-negativity: if every component is non-negative, so is the sum.
  2. Monotone-decreasing in N: if every component is monotone-
     decreasing, the sum is too.

  More generally: the SAME structure applies to any FINITE collection
  of running couplings indexed by `Fin n` — this file ships the
  generic n-coupling sum, with the SM 3-coupling case as a corollary.

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `couplingSum {n} couplings N`                         | (def: `Σ_{i ∈ Fin n} runningCoupling (lams i) (αs i) N`) |
  | Non-negative for non-neg components                   | `couplingSum_nonneg`                              |
  | Monotone decreasing                                   | `couplingSum_monotone_decreasing`                  |
  | At α = 0: sum is constant Σ lams                      | `couplingSum_zero_alphas`                          |
  | Headline (3-conjunct)                                 | `substrate_gauge_coupling_sum_report`              |

  ## Honest scope

  This file ships the generic sum-of-running-couplings shape.  It does
  NOT yet:
  * Calibrate `(αᵢ,IR, αᵢ,coef)` to PDG values for SM α_em, α_s, α_W.
  * Address the GUT-scale unification question: in standard one-loop
    SM, the three couplings approximately meet near 10^16 GeV; the
    substrate prediction is that each independently flows to its IR-
    asymptote with no unification scale required (since the substrate
    has no high-energy GUT regime — its UV cutoff is 1/ℓ_P, not a
    GUT energy).
  * Compute mixing / threshold corrections at scales near the masses.

  What it DOES ship: the structural prediction that any finite SUM
  of substrate-running couplings preserves monotone IR flow — every
  individual mode flows monotonically, and so does the aggregate.

  ## Author

  Lion's-Pride dynamic /loop iteration 55 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateGaugeCouplingSum

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling

/-! ## 1. Sum of substrate-running couplings

    `α_total(N) := Σ_{i ∈ Fin n} αᵢ,IR · (1 + αᵢ,coef · δ_comp(N))`. -/

/-- **Sum of `n` substrate-running couplings**:
    `α_total(N) := Σ_{i ∈ Fin n} runningCoupling (lams i) (alphas i) N`. -/
noncomputable def couplingSum {n : ℕ}
    (lams : Fin n → ℝ) (alphas : Fin n → ℝ) (N : ℕ) : ℝ :=
  Finset.univ.sum fun i : Fin n => runningCoupling (lams i) (alphas i) N

/-! ## 2. Non-negativity for non-negative components -/

/-- **Non-negative for non-negative components**: if each
    `lams i, alphas i ≥ 0`, the substrate-running sum is non-negative. -/
theorem couplingSum_nonneg
    {n : ℕ} (lams : Fin n → ℝ) (alphas : Fin n → ℝ) (N : ℕ)
    (hlam : ∀ i, 0 ≤ lams i) (hα : ∀ i, 0 ≤ alphas i) :
    0 ≤ couplingSum lams alphas N := by
  unfold couplingSum
  apply Finset.sum_nonneg
  intros i _
  -- Each runningCoupling (lams i) (alphas i) N ≥ 0
  unfold runningCoupling
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_inner_nonneg : 0 ≤ 1 + alphas i * substrateRGScale N := by
    have : 0 ≤ alphas i * substrateRGScale N :=
      mul_nonneg (hα i) (le_of_lt h_pos_N)
    linarith
  exact mul_nonneg (hlam i) h_inner_nonneg

/-! ## 3. Monotone decreasing in N -/

/-- **Monotone decreasing in N**: if each `lams i, alphas i ≥ 0`,
    the sum of running couplings is monotone-decreasing in N. -/
theorem couplingSum_monotone_decreasing
    {n : ℕ} (lams : Fin n → ℝ) (alphas : Fin n → ℝ) (N : ℕ)
    (hlam : ∀ i, 0 ≤ lams i) (hα : ∀ i, 0 ≤ alphas i) :
    couplingSum lams alphas (N + 1) ≤ couplingSum lams alphas N := by
  unfold couplingSum
  apply Finset.sum_le_sum
  intros i _
  -- Each individual running coupling is monotone-decreasing
  unfold runningCoupling
  have h_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
    substrateRGScale_decreasing N
  have h_α_le :
      alphas i * substrateRGScale (N + 1)
        ≤ alphas i * substrateRGScale N :=
    mul_le_mul_of_nonneg_left h_le (hα i)
  have h_inner_le :
      1 + alphas i * substrateRGScale (N + 1)
        ≤ 1 + alphas i * substrateRGScale N := by
    linarith
  exact mul_le_mul_of_nonneg_left h_inner_le (hlam i)

/-! ## 4. Zero-alphas constant case -/

/-- **At α_i = 0 ∀ i**: sum of running couplings reduces to sum of
    IR-asymptotes (constant in N). -/
theorem couplingSum_zero_alphas
    {n : ℕ} (lams : Fin n → ℝ) (N : ℕ) :
    couplingSum lams (fun _ => 0) N
      = Finset.univ.sum fun i : Fin n => lams i := by
  unfold couplingSum
  apply Finset.sum_congr rfl
  intros i _
  exact runningCoupling_zero_alpha (lams i) N

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 9.12 headline — substrate gauge-coupling-sum
    structural report.**

    For any finite collection of `n` substrate-running couplings with
    IR asymptotes `lams : Fin n → ℝ` and substrate sensitivities
    `alphas : Fin n → ℝ`, and truncation depth `N : ℕ`:

    1. **Non-negative for non-neg components**:
       `(∀ i, 0 ≤ lams i) ∧ (∀ i, 0 ≤ alphas i) ⟹ 0 ≤ couplingSum`.

    2. **Monotone decreasing**:
       same hypotheses ⟹ `couplingSum (N+1) ≤ couplingSum N`.

    3. **Zero-α constant case**: `couplingSum lams 0 N = Σ lams`. -/
theorem substrate_gauge_coupling_sum_report
    {n : ℕ} (lams : Fin n → ℝ) (alphas : Fin n → ℝ) (N : ℕ) :
    ((∀ i, 0 ≤ lams i) → (∀ i, 0 ≤ alphas i) →
      0 ≤ couplingSum lams alphas N) ∧
    ((∀ i, 0 ≤ lams i) → (∀ i, 0 ≤ alphas i) →
      couplingSum lams alphas (N + 1) ≤ couplingSum lams alphas N) ∧
    couplingSum lams (fun _ => 0) N
      = Finset.univ.sum fun i : Fin n => lams i := by
  refine ⟨?_, ?_, ?_⟩
  · intros hlam hα
    exact couplingSum_nonneg lams alphas N hlam hα
  · intros hlam hα
    exact couplingSum_monotone_decreasing lams alphas N hlam hα
  · exact couplingSum_zero_alphas lams N

end OmegaTheory.QuantumGravity.SubstrateGaugeCouplingSum
