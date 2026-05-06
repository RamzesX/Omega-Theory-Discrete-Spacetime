/-
  OmegaTheory.QuantumGravity.SubstrateDecayRateRunning

  **Lion's-Pride Phase 9.18 (2026-05-06)**:
  *Substrate decay-rate running — applies the substrate-running
  pattern to particle decay rates via tree-level Fermi-style
  `Γ ∼ k · m^p` (e.g., muon decay `Γ_μ ∼ G_F² m_μ^5 / 192π³` has p=5).*

  ## Why this file

  Particle decay rates in the SM scale as a power of the parent
  particle mass: muon decay `Γ_μ ∝ m_μ^5`, β-decay `Γ ∝ Q^5`, etc.
  When the parent mass runs with the substrate truncation depth N
  (Phase 9.13 Yukawa running → fermion mass), the decay rate inherits
  the running with an amplified power.

  This file ships:

      Γ_subst(N) := k · (m_IR · (1 + α · δ_comp(N)))^p

  for power `p : ℕ` (typically 5 for Fermi-style, 3 for boson, etc.)
  and overall coefficient `k : ℝ`.

  Properties:

  1. Non-negativity for non-negative `k, m_IR, α`.
  2. Constant case at α = 0: `Γ_subst(N) = k · m_IR^p`.
  3. Monotone-decreasing in N (substrate IR flow lifts to power p).

  Physical content: the substrate predicts that lifetimes (= 1/Γ)
  INCREASE with N (substrate IR-asymptote → smaller decay rate →
  longer lifetime).  This is a quantitative substrate-QG prediction
  for any decay observable that is a power of the running parent
  mass.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `decayRateFromMass k m_IR α p N`                      | (def: `k · (m_IR · (1+α·δ))^p`)               |
  | Non-negativity                                         | `decayRateFromMass_nonneg`                     |
  | Constant case at α = 0                                | `decayRateFromMass_zero_alpha`                  |
  | Monotone decreasing                                   | `decayRateFromMass_monotone_decreasing`         |
  | Headline (3-conjunct)                                 | `substrate_decay_rate_running_report`           |

  ## Honest scope

  This file ships the structural shape.  It does NOT yet:
  * Calibrate `(k, m_IR, α, p)` to specific SM decays
    (Γ_μ at p=5, Γ_W at p=3, Γ_H at p=3, etc.).
  * Connect to substrate Yukawa running (Phase 9.13) explicitly.
  * Address radiative corrections.

  ## Author

  Lion's-Pride dynamic /loop iteration 62 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateDecayRateRunning

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop

/-! ## 1. Substrate decay-rate running from mass power

    `Γ_subst(N) = k · (m_IR · (1 + α · δ_comp(N)))^p`. -/

/-- **Substrate decay-rate running**: tree-level Fermi-style decay
    rate proportional to a power of the running mass.

    `k` is the dimensional coefficient (e.g., G_F²/192π³ for muon decay).
    `m_IR` is the IR-asymptote parent mass.
    `α` is the substrate sensitivity for the parent mass.
    `p` is the mass power (typically 5 for Fermi-style, 3 for boson). -/
noncomputable def decayRateFromMass
    (k m_IR α : ℝ) (p N : ℕ) : ℝ :=
  k * (runningCoupling m_IR α N)^p

/-! ## 2. Non-negativity -/

/-- **Non-negative for non-negative parameters**:
    `k, m_IR, α ≥ 0` ⟹ `Γ_subst(N) ≥ 0`. -/
theorem decayRateFromMass_nonneg
    (k m_IR α : ℝ) (p N : ℕ)
    (hk : 0 ≤ k) (hm : 0 ≤ m_IR) (hα : 0 ≤ α) :
    0 ≤ decayRateFromMass k m_IR α p N := by
  unfold decayRateFromMass
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_run : 0 ≤ runningCoupling m_IR α N := by
    unfold runningCoupling
    have h_inner : 0 ≤ 1 + α * substrateRGScale N := by
      have : 0 ≤ α * substrateRGScale N :=
        mul_nonneg hα (le_of_lt h_pos_N)
      linarith
    exact mul_nonneg hm h_inner
  have h_pow : 0 ≤ (runningCoupling m_IR α N)^p := pow_nonneg h_run p
  exact mul_nonneg hk h_pow

/-! ## 3. Constant case at α = 0 -/

/-- **Constant case at α = 0**: no running, `Γ_subst(N) = k · m_IR^p`. -/
theorem decayRateFromMass_zero_alpha (k m_IR : ℝ) (p N : ℕ) :
    decayRateFromMass k m_IR 0 p N = k * m_IR^p := by
  unfold decayRateFromMass
  rw [runningCoupling_zero_alpha]

/-! ## 4. Monotone decreasing in N -/

/-- **Monotone decreasing in N**: substrate decay rate decreases with
    truncation depth (substrate IR flow, lifted to power p). -/
theorem decayRateFromMass_monotone_decreasing
    (k m_IR α : ℝ) (p N : ℕ)
    (hk : 0 ≤ k) (hm : 0 ≤ m_IR) (hα : 0 ≤ α) :
    decayRateFromMass k m_IR α p (N + 1)
      ≤ decayRateFromMass k m_IR α p N := by
  unfold decayRateFromMass
  -- Want: k · run(N+1)^p ≤ k · run(N)^p
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_run_N : 0 ≤ runningCoupling m_IR α N := by
    unfold runningCoupling
    have : 0 ≤ 1 + α * substrateRGScale N := by
      have : 0 ≤ α * substrateRGScale N :=
        mul_nonneg hα (le_of_lt h_pos_N)
      linarith
    exact mul_nonneg hm this
  -- run is monotone-decreasing
  have h_run_le : runningCoupling m_IR α (N + 1) ≤ runningCoupling m_IR α N := by
    -- runningCoupling beta nonpos ⟹ run(N+1) ≤ run(N)
    have h_β := runningCoupling_beta_nonpos_of_nonneg_params m_IR α hm hα N
    have h_eq := runningCoupling_beta_eq_alpha_g0_RG_diff m_IR α N
    -- β = m_IR · α · (δ_{N+1} - δ_N)
    -- β ≤ 0 ⟺ run(N+1) - run(N) ≤ 0  (after unfolding substrateBetaFunction)
    -- Use direct calc:
    unfold runningCoupling
    have h_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
      substrateRGScale_decreasing N
    have : α * substrateRGScale (N + 1) ≤ α * substrateRGScale N :=
      mul_le_mul_of_nonneg_left h_le hα
    have : 1 + α * substrateRGScale (N + 1) ≤ 1 + α * substrateRGScale N := by
      linarith
    exact mul_le_mul_of_nonneg_left this hm
  -- pow preserves order for non-negs (Phase 9.8 helper-style induction)
  have h_pow_le :
      (runningCoupling m_IR α (N + 1))^p ≤ (runningCoupling m_IR α N)^p := by
    induction p with
    | zero => simp
    | succ q ih =>
      have h_run_N1 : 0 ≤ runningCoupling m_IR α (N + 1) := by
        unfold runningCoupling
        have h_pos_N1 : 0 < substrateRGScale (N + 1) := substrateRGScale_pos (N + 1)
        have : 0 ≤ 1 + α * substrateRGScale (N + 1) := by
          have : 0 ≤ α * substrateRGScale (N + 1) :=
            mul_nonneg hα (le_of_lt h_pos_N1)
          linarith
        exact mul_nonneg hm this
      have h_pow_q_nonneg : 0 ≤ (runningCoupling m_IR α N)^q := pow_nonneg h_run_N q
      rw [pow_succ, pow_succ]
      exact mul_le_mul ih h_run_le h_run_N1 h_pow_q_nonneg
  exact mul_le_mul_of_nonneg_left h_pow_le hk

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 9.18 headline — substrate decay-rate
    running structural report.**

    For dimensional coefficient `k : ℝ`, IR-asymptote mass
    `m_IR : ℝ`, substrate sensitivity `α : ℝ`, mass power `p : ℕ`,
    and truncation depth `N : ℕ`:

    1. **Non-negativity**: `k, m_IR, α ≥ 0` ⟹ `Γ_subst(N) ≥ 0`.

    2. **Constant case**: `α = 0` ⟹
       `decayRateFromMass k m_IR 0 p N = k · m_IR^p`.

    3. **Monotone decreasing**: `k, m_IR, α ≥ 0` ⟹
       `Γ_subst(N+1) ≤ Γ_subst(N)`. -/
theorem substrate_decay_rate_running_report
    (k m_IR α : ℝ) (p N : ℕ) :
    (0 ≤ k → 0 ≤ m_IR → 0 ≤ α → 0 ≤ decayRateFromMass k m_IR α p N) ∧
    decayRateFromMass k m_IR 0 p N = k * m_IR^p ∧
    (0 ≤ k → 0 ≤ m_IR → 0 ≤ α →
      decayRateFromMass k m_IR α p (N + 1)
        ≤ decayRateFromMass k m_IR α p N) := by
  refine ⟨?_, ?_, ?_⟩
  · intros hk hm hα
    exact decayRateFromMass_nonneg k m_IR α p N hk hm hα
  · exact decayRateFromMass_zero_alpha k m_IR p N
  · intros hk hm hα
    exact decayRateFromMass_monotone_decreasing k m_IR α p N hk hm hα

end OmegaTheory.QuantumGravity.SubstrateDecayRateRunning
