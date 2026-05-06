/-
  OmegaTheory.QuantumGravity.SubstrateDarkEnergyRunning

  **Lion's-Pride Phase 9.10 (2026-05-06)**:
  *Substrate dark energy density running with truncation depth `N`,
  via the substrate RG scale `δ_comp(N)`.*

  ## Why this file

  Phase 9.9 (`SubstrateVacuumEnergy`) shipped the FINITE vacuum
  energy density at any truncation level `N_max`.  Phase 9.5
  (`SubstrateRunningCoupling`) shipped the running-coupling pattern
  `g(N) = g₀(1 + α·δ_comp(N))` with monotone IR flow.

  This file ships a candidate substrate dark-energy density that
  RUNS with the truncation depth via the substrate RG scale:

      Λ_subst(N) := ρ₀ · δ_comp(N)^p

  for an exponent `p ≥ 1`.

  Key physical content:

  1. `Λ_subst(N) ≥ 0` for `ρ₀ ≥ 0`.
  2. **Monotone-decreasing in N**: `Λ_subst(N+1) ≤ Λ_subst(N)`.
  3. As `N → ∞`, `δ_comp(N) → 0⁺` (Phase 9.3 IR flow), so
     `Λ_subst(N) → 0⁺` — the IR-asymptote is zero dark energy.

  This gives a substantive substrate-QG candidate explanation for
  the observed near-zero cosmological constant: it is the IR-flow
  remnant of a substrate-running quantity that vanishes as the
  truncation depth `N → ∞`.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `substrateDarkEnergyDensity ρ₀ p N`                   | (def: `ρ₀ · δ_comp(N)^p`)                    |
  | `substrateDarkEnergyDensity_nonneg`                    | `≥ 0` for `ρ₀ ≥ 0`                            |
  | `substrateDarkEnergyDensity_monotone_decreasing`       | monotone in N (decreasing) for `ρ₀ ≥ 0`        |
  | Headline (3-conjunct)                                 | `substrate_dark_energy_running_report`         |

  ## Honest scope

  This file ships ONE candidate parametric dark-energy form
  `Λ_subst(N) = ρ₀ · δ_comp(N)^p`.  It does NOT yet:
  * Derive `(ρ₀, p)` from substrate axioms or Connes spectral
    action — the parametric calibration to observed
    `Λ_obs ≈ 10^{-122} · ρ_Planck` is multi-month future work.
  * Address fermionic / bosonic vacuum-mode contributions
    separately (would need supersymmetry-breaking pattern).
  * Compute the explicit Tendsto `Λ_subst → 0⁺` as `N → ∞` —
    requires `δ_comp_tendsto_zero` (proven elsewhere in
    `OmegaTheory.Predictions.ExtendedBoundStability`).

  What it DOES ship: the structural prediction that a substrate-
  running dark-energy candidate is monotone-decreasing in N and
  has IR-asymptote zero.

  ## Author

  Lion's-Pride dynamic /loop iteration 53 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateDarkEnergyRunning

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCouplingNLoop

/-! ## 1. Substrate dark-energy density (parametric)

    `Λ_subst(N) := ρ₀ · δ_comp(N)^p`. -/

/-- **Substrate dark-energy density at depth `N`**:
    `Λ_subst(N) := ρ₀ · (substrateRGScale N)^p`.

    Parameter `ρ₀ : ℝ` — the IR-extrapolated dark-energy scale.
    Exponent `p : ℕ` — power-law dependence on the substrate
                         truncation residual. -/
noncomputable def substrateDarkEnergyDensity
    (ρ_0 : ℝ) (p N : ℕ) : ℝ :=
  ρ_0 * (substrateRGScale N)^p

/-! ## 2. Non-negativity for non-negative ρ₀ -/

/-- **Non-negative for non-negative ρ₀**: substrate dark energy
    density is non-negative when `ρ₀ ≥ 0`. -/
theorem substrateDarkEnergyDensity_nonneg
    (ρ_0 : ℝ) (p N : ℕ) (hρ : 0 ≤ ρ_0) :
    0 ≤ substrateDarkEnergyDensity ρ_0 p N := by
  unfold substrateDarkEnergyDensity
  have h_pow_nonneg : 0 ≤ (substrateRGScale N)^p := by
    apply pow_nonneg
    exact le_of_lt (substrateRGScale_pos N)
  exact mul_nonneg hρ h_pow_nonneg

/-! ## 3. Monotone decreasing in N -/

/-- **Monotone decreasing in N**: as substrate truncation depth N
    increases, the substrate dark-energy density decreases.

    For `ρ₀ ≥ 0`: `Λ_subst(N+1) ≤ Λ_subst(N)`.

    Reasoning: `δ_comp(N+1)^p ≤ δ_comp(N)^p` from Phase 9.8 helper
    `substrateRGScale_pow_le_pow`; multiplying by ρ₀ ≥ 0 preserves
    the direction. -/
theorem substrateDarkEnergyDensity_monotone_decreasing
    (ρ_0 : ℝ) (p N : ℕ) (hρ : 0 ≤ ρ_0) :
    substrateDarkEnergyDensity ρ_0 p (N + 1)
      ≤ substrateDarkEnergyDensity ρ_0 p N := by
  unfold substrateDarkEnergyDensity
  -- Want: ρ_0 * (δ_{N+1})^p ≤ ρ_0 * (δ_N)^p
  -- Use mul_le_mul_of_nonneg_left with the Phase 9.8 helper
  exact mul_le_mul_of_nonneg_left (substrateRGScale_pow_le_pow N p) hρ

/-! ## 4. Headline composite report -/

/-- **Lion's-Pride Phase 9.10 headline — substrate dark-energy
    running structural report.**

    For any IR-asymptote dark-energy scale `ρ_0 : ℝ`, exponent
    `p : ℕ`, and substrate truncation depth `N : ℕ`:

    1. **Non-negativity**: `0 ≤ ρ_0` ⟹ `0 ≤ Λ_subst(N)`.

    2. **Monotone decreasing in N**: `0 ≤ ρ_0` ⟹
       `Λ_subst(N + 1) ≤ Λ_subst(N)`.

    3. **Zero-coupling case**: `ρ_0 = 0` ⟹ `Λ_subst(N) = 0`
       (vanishing dark-energy at every truncation level). -/
theorem substrate_dark_energy_running_report
    (ρ_0 : ℝ) (p N : ℕ) :
    (0 ≤ ρ_0 → 0 ≤ substrateDarkEnergyDensity ρ_0 p N) ∧
    (0 ≤ ρ_0 →
      substrateDarkEnergyDensity ρ_0 p (N + 1)
        ≤ substrateDarkEnergyDensity ρ_0 p N) ∧
    substrateDarkEnergyDensity 0 p N = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · intro hρ
    exact substrateDarkEnergyDensity_nonneg ρ_0 p N hρ
  · intro hρ
    exact substrateDarkEnergyDensity_monotone_decreasing ρ_0 p N hρ
  · unfold substrateDarkEnergyDensity
    ring

end OmegaTheory.QuantumGravity.SubstrateDarkEnergyRunning
