/-
  OmegaTheory.QuantumGravity.SubstrateVacuumEnergy

  **Lion's-Pride Phase 9.9 (2026-05-06)**:
  *Substrate vacuum energy density — finite zero-point sum over a
  truncated set of bosonic modes, regulated by the substrate UV
  cutoff.*

  ## Why this file

  In standard continuum QFT, the vacuum energy density of a scalar
  field is the divergent sum

      ρ_vac  =  Σ_k  (1/2) ω_k

  over all momentum modes `k`.  This is the famous "zero-point
  energy / cosmological-constant problem": the sum diverges as
  `~ Λ_UV^4` and is ~120 orders of magnitude larger than the
  observed cosmological constant.

  In the substrate, modes are TRUNCATED at the UV cutoff `Ω_max =
  1/ℓ_P` (Phase 9.1 `substrateUVCutoff`).  The vacuum energy density
  becomes the FINITE sum

      ρ_vac^subst  =  Σ_{n=0}^{N_max-1}  (1/2) ω_n

  This file ships the substrate vacuum energy density and proves:

  1. **Finite at every finite `N_max`** (definitional).
  2. **Non-negative** for non-negative mode-frequency sequences.
  3. **Monotone-increasing in `N_max`**:
     `ρ_vac^subst(N_max+1) ≥ ρ_vac^subst(N_max)` for non-negative ω.
  4. **Bounded by `N_max · ω_max / 2`** if all `ω_n ≤ ω_max`.

  The substrate's UV cutoff thus EXPLICITLY regulates the vacuum
  energy — no need for renormalisation, no Λ_UV → ∞ problem.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `substrateVacuumEnergyDensity ω N_max`                | (def: `Σ_{n=0}^{N_max-1} ω_n / 2`)            |
  | `substrateVacuumEnergyDensity_nonneg`                  | non-negative for non-neg ω                     |
  | `substrateVacuumEnergyDensity_monotone`                | monotone-increasing in N_max                   |
  | `substrateVacuumEnergyDensity_bounded`                 | ≤ N_max · ω_max / 2                            |
  | Headline (3-conjunct)                                 | `substrate_vacuum_energy_density_report`        |

  ## Honest scope

  This file ships the FINITE sum scaffold.  It does NOT yet:
  * Identify `ω_n` from a specific substrate dispersion relation
    (Phase 4.2 `latticePlaneWave1D` would give a candidate).
  * Compute the explicit cosmological constant value
    `Λ_obs ≈ 10^{-122} · Λ_Planck` from substrate axioms — that
    requires deriving the running of vacuum energy with the
    substrate RG flow (Phase 9.5+ pipeline) and is multi-month
    future work.
  * Address fermionic vacuum contributions (negative sign, would
    need Pauli antisymmetry).

  What it DOES ship: the FINITE-VACUUM-ENERGY structural prediction
  that the substrate's UV cutoff makes ρ_vac mathematically rigorous
  (no Λ_UV → ∞ pathology).

  ## Author

  Lion's-Pride dynamic /loop iteration 51 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateUVRegularisation
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateVacuumEnergy

open OmegaTheory.QuantumGravity.SubstrateUVRegularisation

/-! ## 1. Substrate vacuum energy density

    `ρ_vac^subst(ω, N_max) := (1/2) Σ_{n=0}^{N_max-1} ω_n`. -/

/-- **Substrate vacuum energy density**: finite zero-point sum
    `Σ_{n=0}^{N_max-1} ω_n / 2` over a truncated set of bosonic
    modes.

    Each mode contributes `ω_n / 2` to the zero-point energy.
    The substrate UV cutoff truncates the sum at `N_max` modes,
    giving a FINITE vacuum energy density. -/
noncomputable def substrateVacuumEnergyDensity
    (ω : ℕ → ℝ) (N_max : ℕ) : ℝ :=
  (Finset.range N_max).sum fun n => ω n / 2

/-! ## 2. Non-negativity for non-negative mode frequencies -/

/-- **Non-negative for non-negative mode frequencies**:
    `(∀ n, 0 ≤ ω n) ⟹ 0 ≤ ρ_vac^subst(ω, N_max)`. -/
theorem substrateVacuumEnergyDensity_nonneg
    (ω : ℕ → ℝ) (N_max : ℕ) (hω : ∀ n, 0 ≤ ω n) :
    0 ≤ substrateVacuumEnergyDensity ω N_max := by
  unfold substrateVacuumEnergyDensity
  apply Finset.sum_nonneg
  intros n _
  linarith [hω n]

/-! ## 3. Monotone-increasing in N_max -/

/-- **Monotone-increasing in N_max**: adding more modes (with
    non-negative frequencies) only increases the vacuum energy. -/
theorem substrateVacuumEnergyDensity_monotone
    (ω : ℕ → ℝ) (N_max : ℕ) (hω : ∀ n, 0 ≤ ω n) :
    substrateVacuumEnergyDensity ω N_max
      ≤ substrateVacuumEnergyDensity ω (N_max + 1) := by
  unfold substrateVacuumEnergyDensity
  rw [Finset.sum_range_succ]
  -- Σ_{n=0}^{N-1} ω_n / 2 ≤ Σ_{n=0}^{N-1} ω_n / 2 + ω_{N_max} / 2
  have h_last : 0 ≤ ω N_max / 2 := by linarith [hω N_max]
  linarith

/-! ## 4. Upper bound: N_max · ω_max / 2 -/

/-- **Bounded by `N_max · ω_max / 2`**: if every mode frequency is
    bounded by `ω_max`, the vacuum energy density is bounded
    above by `N_max · ω_max / 2`. -/
theorem substrateVacuumEnergyDensity_bounded
    (ω : ℕ → ℝ) (N_max : ℕ) (ω_max : ℝ)
    (hω_le : ∀ n, n < N_max → ω n ≤ ω_max) :
    substrateVacuumEnergyDensity ω N_max ≤ N_max * ω_max / 2 := by
  unfold substrateVacuumEnergyDensity
  have h_sum_le :
      (Finset.range N_max).sum (fun n => ω n / 2)
        ≤ (Finset.range N_max).sum (fun _ => ω_max / 2) := by
    apply Finset.sum_le_sum
    intros n hn
    rw [Finset.mem_range] at hn
    have := hω_le n hn
    linarith
  calc (Finset.range N_max).sum (fun n => ω n / 2)
      ≤ (Finset.range N_max).sum (fun _ => ω_max / 2) := h_sum_le
    _ = (Finset.range N_max).card * (ω_max / 2) := by rw [Finset.sum_const]; ring
    _ = N_max * (ω_max / 2) := by rw [Finset.card_range]
    _ = N_max * ω_max / 2 := by ring

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 9.9 headline — substrate vacuum energy
    density structural report.**

    For any mode-frequency sequence `ω : ℕ → ℝ`, truncation count
    `N_max : ℕ`, and bound `ω_max : ℝ`:

    1. **Non-negativity**: `(∀ n, 0 ≤ ω n) ⟹ 0 ≤ ρ_vac^subst(ω, N_max)`.

    2. **Monotone increasing**: `(∀ n, 0 ≤ ω n) ⟹
       ρ_vac^subst(ω, N_max) ≤ ρ_vac^subst(ω, N_max + 1)`.

    3. **Upper bound**: if every mode `ω_n ≤ ω_max`, then
       `ρ_vac^subst(ω, N_max) ≤ N_max · ω_max / 2`. -/
theorem substrate_vacuum_energy_density_report
    (ω : ℕ → ℝ) (N_max : ℕ) (ω_max : ℝ) :
    ((∀ n, 0 ≤ ω n) → 0 ≤ substrateVacuumEnergyDensity ω N_max) ∧
    ((∀ n, 0 ≤ ω n) →
      substrateVacuumEnergyDensity ω N_max
        ≤ substrateVacuumEnergyDensity ω (N_max + 1)) ∧
    ((∀ n, n < N_max → ω n ≤ ω_max) →
      substrateVacuumEnergyDensity ω N_max ≤ N_max * ω_max / 2) := by
  refine ⟨?_, ?_, ?_⟩
  · intro hω
    exact substrateVacuumEnergyDensity_nonneg ω N_max hω
  · intro hω
    exact substrateVacuumEnergyDensity_monotone ω N_max hω
  · intro hω_le
    exact substrateVacuumEnergyDensity_bounded ω N_max ω_max hω_le

end OmegaTheory.QuantumGravity.SubstrateVacuumEnergy
