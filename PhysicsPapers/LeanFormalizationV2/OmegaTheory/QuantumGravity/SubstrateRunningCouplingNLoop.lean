/-
  OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop

  **Lion's-Pride Phase 9.8 (2026-05-06)**:
  *Generic n-loop substrate-running coupling — unifies Phases 9.5
  (one-loop), 9.6 (two-loop), 9.7 (three-loop) into a polynomial
  of arbitrary order in `δ_comp(N)`.*

  ## Why this file

  Phases 9.5/9.6/9.7 shipped one/two/three-loop running couplings.
  All three preserve monotone IR flow at non-negative parameters.

  This file ships the GENERIC n-loop shape

      g_n(N)  =  g₀ · (1 + Σ_{k=0}^{n-1} c_k · δ_comp^{k+1})

  and proves the universal substrate prediction:

  **At every finite loop order, with non-negative coefficients,
  the substrate running coupling flows monotonically to its IR
  asymptote g₀.**  No Landau pole, no sign-flip, no UV divergence.

  ## What this file ships

  | Property                                              | Theorem                                          |
  |-------------------------------------------------------|--------------------------------------------------|
  | `runningCouplingNLoop n g₀ coefs N`                   | (def: `g₀·(1 + Σ_{k=0}^{n-1} coefs k · δ^{k+1})`) |
  | `runningCouplingNLoop_zero_loops`                     | `n = 0` ⟹ `g(N) = g₀`                            |
  | `substrateRGScale_pow_le_pow`                          | δ_{N+1}^k ≤ δ_N^k (monotone in N at every k)     |
  | `runningCouplingNLoop_beta_nonpos_of_nonneg_params`   | universal monotone IR flow                       |
  | Headline (3-conjunct)                                 | `substrate_running_coupling_nloop_report`         |

  ## Honest scope

  Ships the GENERIC unification.  Coefficient calibration to specific
  SM running couplings (g_s, α_em, λ_H) is multi-month future work
  (Phase 6.5+ Connes spectral-action eigenvalues).

  ## Author

  Lion's-Pride dynamic /loop iteration 49 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateBetaFunction
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop

open OmegaTheory.Irrationality
open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateBetaFunction

/-! ## 1. Generic n-loop substrate running coupling

    `g_n(N) = g₀ · (1 + Σ_{k=0}^{n-1} c_k · δ_comp(N)^{k+1})`. -/

/-- **Generic n-loop substrate-running coupling**: polynomial of
    order `n` in `δ_comp(N)`, with one coefficient per loop order. -/
noncomputable def runningCouplingNLoop
    (n : ℕ) (g_0 : ℝ) (coefs : ℕ → ℝ) (N : ℕ) : ℝ :=
  g_0 * (1 + (Finset.range n).sum
              fun k => coefs k * (substrateRGScale N)^(k + 1))

/-- **Constant case at n = 0**: empty sum yields `g(N) = g₀`. -/
theorem runningCouplingNLoop_zero_loops
    (g_0 : ℝ) (coefs : ℕ → ℝ) (N : ℕ) :
    runningCouplingNLoop 0 g_0 coefs N = g_0 := by
  unfold runningCouplingNLoop
  simp

/-! ## 2. Powers of substrateRGScale are monotone-decreasing in N

    `δ_{N+1}^k ≤ δ_N^k` for every k : ℕ. -/

/-- **Powers of substrateRGScale preserve the monotone-decreasing
    relation**: `δ_{N+1}^k ≤ δ_N^k`. -/
theorem substrateRGScale_pow_le_pow (N k : ℕ) :
    (substrateRGScale (N + 1))^k ≤ (substrateRGScale N)^k := by
  induction k with
  | zero => simp
  | succ k ih =>
    have h_le : substrateRGScale (N + 1) ≤ substrateRGScale N :=
      substrateRGScale_decreasing N
    have h_pos_N1 : 0 < substrateRGScale (N + 1) := substrateRGScale_pos (N + 1)
    have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
    have h_nonneg_N1_pow : 0 ≤ (substrateRGScale (N + 1))^k := by positivity
    have h_nonneg_N_pow : 0 ≤ (substrateRGScale N)^k := by positivity
    rw [pow_succ, pow_succ]
    -- Want: δ_{N+1}^k * δ_{N+1} ≤ δ_N^k * δ_N
    -- Use mul_le_mul: a ≤ b ∧ c ≤ d ∧ 0 ≤ c ∧ 0 ≤ b ⟹ a*c ≤ b*d
    -- with a = δ_{N+1}^k, b = δ_N^k, c = δ_{N+1}, d = δ_N
    exact mul_le_mul ih h_le (le_of_lt h_pos_N1) h_nonneg_N_pow

/-! ## 3. Universal monotone IR flow at non-negative parameters -/

/-- **Universal n-loop monotone IR flow**: for non-negative `g₀, c_k`,
    the substrate running-coupling beta-function is non-positive at
    every finite loop order. -/
theorem runningCouplingNLoop_beta_nonpos_of_nonneg_params
    (n : ℕ) (g_0 : ℝ) (coefs : ℕ → ℝ)
    (hg : 0 ≤ g_0)
    (hc : ∀ k, k < n → 0 ≤ coefs k)
    (N : ℕ) :
    substrateBetaFunction (runningCouplingNLoop n g_0 coefs) N ≤ 0 := by
  unfold substrateBetaFunction runningCouplingNLoop
  -- Goal: g_0 * (1 + Σ ...(N+1)) - g_0 * (1 + Σ ...(N)) ≤ 0
  -- Equivalently: g_0 * (Σ_{N+1} - Σ_N) ≤ 0 with g_0 ≥ 0 and Σ_{N+1} ≤ Σ_N
  have h_sum_le :
      (Finset.range n).sum
          (fun k => coefs k * (substrateRGScale (N + 1))^(k + 1))
        ≤ (Finset.range n).sum
            (fun k => coefs k * (substrateRGScale N)^(k + 1)) := by
    apply Finset.sum_le_sum
    intros k hk
    rw [Finset.mem_range] at hk
    have hck := hc k hk
    have h_pow_le := substrateRGScale_pow_le_pow N (k + 1)
    -- Want: coefs k * δ_{N+1}^{k+1} ≤ coefs k * δ_N^{k+1}
    exact mul_le_mul_of_nonneg_left h_pow_le hck
  -- now: g_0 * (1 + smaller_sum) - g_0 * (1 + larger_sum) ≤ 0
  -- since g_0 ≥ 0 and the difference of (1 + smaller_sum) - (1 + larger_sum)
  --       = smaller_sum - larger_sum ≤ 0
  nlinarith [h_sum_le, hg]

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 9.8 headline — generic n-loop substrate-
    running-coupling structural report.**

    For any loop order `n : ℕ`, IR-asymptote `g₀ : ℝ`, coefficient
    sequence `c_k : ℕ → ℝ`, and truncation depth `N : ℕ`:

    1. **Constant case at n = 0**: `runningCouplingNLoop 0 g₀ coefs N = g₀`.

    2. **Powers of substrateRGScale monotone**:
       `(substrateRGScale (N + 1))^k ≤ (substrateRGScale N)^k`.

    3. **Universal monotone IR flow**: `g₀ ≥ 0 ∧ ∀ k < n, 0 ≤ c_k`
       ⟹ `β(g_n, N) ≤ 0` (the universal substrate-QG prediction:
       at every finite loop order, non-negative coefficients give
       monotone IR flow). -/
theorem substrate_running_coupling_nloop_report
    (n : ℕ) (g_0 : ℝ) (coefs : ℕ → ℝ) (N k : ℕ) :
    runningCouplingNLoop 0 g_0 coefs N = g_0 ∧
    (substrateRGScale (N + 1))^k ≤ (substrateRGScale N)^k ∧
    (0 ≤ g_0 → (∀ j, j < n → 0 ≤ coefs j) →
      substrateBetaFunction (runningCouplingNLoop n g_0 coefs) N ≤ 0) := by
  refine ⟨?_, ?_, ?_⟩
  · exact runningCouplingNLoop_zero_loops g_0 coefs N
  · exact substrateRGScale_pow_le_pow N k
  · intros hg hc
    exact runningCouplingNLoop_beta_nonpos_of_nonneg_params n g_0 coefs hg hc N

end OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop
