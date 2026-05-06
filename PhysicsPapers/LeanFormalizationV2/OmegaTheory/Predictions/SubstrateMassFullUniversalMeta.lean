/-
  OmegaTheory.Predictions.SubstrateMassFullUniversalMeta

  **Lion's-Pride Phase 9.40 (2026-05-06)**:
  *Substrate-running mass FULL UNIVERSAL META — composing six
  substantive identities from Phase 9.14 + 9.16 + 9.27 + 9.35 +
  9.36 + 9.39 into a single 6-conjunct theorem capturing the
  COMPLETE substrate-running mass machinery.*

  ## Why this file

  Across Phases 9.14-9.39, the substrate-running fermion mass
  machinery accumulated:

  * 9.14 — 3-gen Yukawa non-negativity
  * 9.15 — mass-ratio invariance under uniform α (deferred from META)
  * 9.16 — cross-difference identity (non-uniform α)
  * 9.27 — Pi-Hunch general sign theorem
  * 9.28 — concrete Pi-Hunch witness
  * 9.35 — IR-floor `y_g·v ≤ m_g(N)`
  * 9.36 — UV-ceiling `m_g(N) ≤ y_g·(1+α_g·δ_0)·v`
  * 9.37 — FINITE WINDOW META combining 9.35+9.36
  * 9.38 — CENTENARY META (iter 100 milestone)
  * 9.39 — excess-above-floor exact formula + monotone-decay

  This file ships the FULL UNIVERSAL META composing the most
  substantive computational identities into one umbrella theorem.

  ## What this file ships

  | Phase | Identity                                                              |
  |-------|-----------------------------------------------------------------------|
  | 9.14  | `threeGenYukawa_nonneg`: 0 ≤ y_g(N)                                    |
  | 9.16  | `mass_cross_difference_identity`: factored cross-diff                  |
  | 9.27  | `pi_hunch_general_cross_difference_nonneg`: universal sign theorem     |
  | 9.35  | `threeGenFermionMass_ge_yIR_v`: IR-floor                                |
  | 9.36  | `threeGenFermionMass_le_yIR_v_uv`: UV-ceiling                          |
  | 9.39  | `threeGenFermionMass_excess_eq`: excess exact formula                  |

  ## Author

  Lion's-Pride dynamic /loop iteration 102 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
import OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
import OmegaTheory.QuantumGravity.SubstratePiHunchGeneralCrossDifference
import OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor
import OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling
import OmegaTheory.QuantumGravity.SubstrateFermionMassExcess
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.SubstrateMassFullUniversalMeta

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
open OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
open OmegaTheory.QuantumGravity.SubstratePiHunchGeneralCrossDifference
open OmegaTheory.QuantumGravity.SubstrateFermionMassIRFloor
open OmegaTheory.QuantumGravity.SubstrateFermionMassUVCeiling
open OmegaTheory.QuantumGravity.SubstrateFermionMassExcess

/-! ## The substrate-running mass FULL UNIVERSAL META -/

/-- **SUBSTRATE-RUNNING MASS FULL UNIVERSAL META** — composing
    six substantive identities from Phase 9.14 + 9.16 + 9.27 +
    9.35 + 9.36 + 9.39 into a single 6-conjunct theorem.

    For non-negative IR-Yukawa, non-negative substrate sensitivity,
    non-negative Higgs VEV, depth `N : ℕ`, generation `g : Fin 3`,
    and an arbitrary pair `g₁, g₂ : Fin 3` with `αs g₁ < αs g₂`:

    1. **Phase 9.14** — Yukawa non-negativity:
       `0 ≤ threeGenYukawa yIRs αs N g`.

    2. **Phase 9.16** — cross-difference identity:
       cross-diff = `y_g₁·y_g₂·v²·(α_g₁-α_g₂)·(δ_{N+1}-δ_N)`.

    3. **Phase 9.27** — Pi-Hunch GENERAL sign theorem:
       any pair (g₁, g₂) with αs g₁ < αs g₂ and non-neg IR-Yukawa
       gives cross-diff ≥ 0.

    4. **Phase 9.35** — IR-floor:
       `y_g · v ≤ m_g^subst(N)`.

    5. **Phase 9.36** — UV-ceiling:
       `m_g^subst(N) ≤ y_g · (1 + α_g · δ_0) · v`.

    6. **Phase 9.39** — excess-above-floor exact formula:
       `m_g^subst(N) - y_g·v = y_g · α_g · δ_N · v`. -/
theorem substrate_mass_full_universal_meta
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g g₁ g₂ : Fin 3)
    (hy : 0 ≤ yIRs g) (hα : 0 ≤ αs g) (hv : 0 ≤ v)
    (h_α_lt : αs g₁ < αs g₂)
    (hy1 : 0 ≤ yIRs g₁) (hy2 : 0 ≤ yIRs g₂) :
    -- (1) Phase 9.14 Yukawa non-neg
    0 ≤ threeGenYukawa yIRs αs N g ∧
    -- (2) Phase 9.16 cross-difference identity
    threeGenFermionMass yIRs αs v (N + 1) g₁
        * threeGenFermionMass yIRs αs v N g₂
      - threeGenFermionMass yIRs αs v N g₁
        * threeGenFermionMass yIRs αs v (N + 1) g₂
      = yIRs g₁ * yIRs g₂ * v^2 * (αs g₁ - αs g₂)
        * (substrateRGScale (N + 1) - substrateRGScale N) ∧
    -- (3) Phase 9.27 Pi-Hunch GENERAL sign theorem
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) g₁
          * threeGenFermionMass yIRs αs v N g₂
        - threeGenFermionMass yIRs αs v N g₁
          * threeGenFermionMass yIRs αs v (N + 1) g₂ ∧
    -- (4) Phase 9.35 IR-floor
    yIRs g * v ≤ threeGenFermionMass yIRs αs v N g ∧
    -- (5) Phase 9.36 UV-ceiling
    threeGenFermionMass yIRs αs v N g ≤
      yIRs g * (1 + αs g * substrateRGScale 0) * v ∧
    -- (6) Phase 9.39 excess exact formula
    threeGenFermionMass yIRs αs v N g - yIRs g * v
      = yIRs g * αs g * substrateRGScale N * v := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact threeGenYukawa_nonneg yIRs αs N g hy hα
  · exact mass_cross_difference_identity yIRs αs v N g₁ g₂
  · exact pi_hunch_general_cross_difference_nonneg yIRs αs v N g₁ g₂ h_α_lt hy1 hy2
  · exact threeGenFermionMass_ge_yIR_v yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_le_yIR_v_uv yIRs αs v N g hy hα hv
  · exact threeGenFermionMass_excess_eq yIRs αs v N g

/-! ## Frozen-Nat substrate-running mass FULL UNIVERSAL snapshot -/

/-- **Substrate-running mass FULL UNIVERSAL phase count**:
    9.13 + 9.14 + 9.15 + 9.16 + 9.27 + 9.28 + 9.35 + 9.36 + 9.37 +
    9.38 + 9.39 + 9.40 = 12 phases. -/
def substrateMassFullUniversal_phase_count : ℕ := 12

/-- **Substrate-running mass FULL UNIVERSAL identity count**:
    6 conjuncts. -/
def substrateMassFullUniversal_identity_count : ℕ := 6

/-- **Frozen-Nat substrate-running mass FULL UNIVERSAL snapshot —
    verifiable via `decide`**. -/
theorem substrate_mass_full_universal_snapshot :
    substrateMassFullUniversal_phase_count = 12 ∧
    substrateMassFullUniversal_identity_count = 6 ∧
    substrateMassFullUniversal_phase_count + substrateMassFullUniversal_identity_count = 18 := by
  refine ⟨rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.SubstrateMassFullUniversalMeta
