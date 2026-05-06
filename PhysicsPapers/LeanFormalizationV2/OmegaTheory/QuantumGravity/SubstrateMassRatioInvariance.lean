/-
  OmegaTheory.QuantumGravity.SubstrateMassRatioInvariance

  **Lion's-Pride Phase 9.15 (2026-05-06)**:
  *Substrate fermion-mass-ratio invariance under uniform substrate
  sensitivity α — three-generation Yukawa ratios are PRESERVED at
  every truncation depth N when all generations share the same α.*

  ## Why this file

  Phase 9.14 (`SubstrateThreeGenerationRunning`) shipped three
  independently running Yukawa couplings for the SM's three fermion
  generations.  This file proves a STRUCTURAL invariance property:

  When the substrate sensitivity `α` is the SAME for all three
  generations (uniform α), the mass ratios

      r_{ij}(N) := m_i^subst(N) / m_j^subst(N) = y_i,IR / y_j,IR

  are CONSTANT in N — i.e., the substrate-running preserves all
  fermion-mass ratios.

  Reasoning:
      m_g^subst(N) = y_g,IR · (1 + α · δ_comp(N)) · v
      r_{ij}(N) = [y_i,IR · (1 + α · δ) · v] / [y_j,IR · (1 + α · δ) · v]
              = y_i,IR / y_j,IR

  The common factor `(1 + α · δ) · v` cancels.

  Physical content: if the substrate-QG hypothesis is correct AND all
  three generations have the same substrate sensitivity α, then the
  observed mass RATIOS (m_e:m_μ:m_τ ≈ 1:200:3500 etc.) are FIXED
  regardless of which truncation depth we identify with the
  observed energy scale.  This is a structural prediction
  distinguishing substrate-QG from continuum running (where ratios
  generically change due to different anomalous dimensions per
  generation).

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `threeGenFermionMass_ratio_uniform_alpha`             | mass ratio = Yukawa ratio (uniform α case)    |
  | `threeGenYukawa_ratio_uniform_alpha`                  | Yukawa ratio invariant under uniform α          |
  | Headline (2-conjunct)                                 | `substrate_mass_ratio_invariance_report`        |

  ## Honest scope

  This file ships the UNIFORM-α invariance.  It does NOT yet:
  * Prove that the OBSERVED uniformity of fermion-mass ratios across
    energy scales (a SM phenomenon) is incompatible with non-uniform
    α — that would need a quantitative comparison.
  * Address whether the substrate's 3-irrational generation
    hypothesis actually predicts uniform α (gen 1 ↔ √2 etc).
  * Compute substrate-RG anomalous dimensions per generation
    (would require Phase 9.5+ machinery applied with non-uniform α
    and the deviation analysed quantitatively).

  ## Author

  Lion's-Pride dynamic /loop iteration 58 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateYukawaRunning
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateMassRatioInvariance

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateYukawaRunning
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning

/-! ## 1. Yukawa-ratio invariance under uniform α

    `y_i^subst(N) / y_j^subst(N) = y_i,IR / y_j,IR`. -/

/-- **Yukawa ratio invariant under uniform α**: when all three
    generations share the same substrate sensitivity `α`, the
    Yukawa-ratio between generations is invariant in N.

    Specifically, for `j_y_pos : 0 < yIRs g2`:
        `threeGenYukawa yIRs (fun _ => α) N g1 = (yIRs g1 / yIRs g2) ·
            threeGenYukawa yIRs (fun _ => α) N g2`. -/
theorem threeGenYukawa_ratio_uniform_alpha
    (yIRs : Fin 3 → ℝ) (α : ℝ) (N : ℕ) (g1 g2 : Fin 3)
    (h_y2_pos : 0 < yIRs g2) :
    threeGenYukawa yIRs (fun _ => α) N g1
      = (yIRs g1 / yIRs g2)
        * threeGenYukawa yIRs (fun _ => α) N g2 := by
  unfold threeGenYukawa yukawaRunning runningCoupling
  -- Want: yIRs g1 · (1 + α · δ) = (yIRs g1 / yIRs g2) · yIRs g2 · (1 + α · δ)
  -- (yIRs g1 / yIRs g2) · yIRs g2 = yIRs g1 (since yIRs g2 ≠ 0)
  have h_ne : yIRs g2 ≠ 0 := ne_of_gt h_y2_pos
  field_simp

/-! ## 2. Mass-ratio invariance under uniform α + non-zero v

    `m_i^subst(N) / m_j^subst(N) = y_i,IR / y_j,IR`. -/

/-- **Fermion-mass ratio invariant under uniform α**: the substrate
    fermion-mass ratio between two generations equals the Yukawa
    ratio at the IR-asymptote (uniform α case + non-zero v).

    Specifically, for `h_y2_pos : 0 < yIRs g2`:
        `threeGenFermionMass yIRs (fun _ => α) v N g1
            = (yIRs g1 / yIRs g2) · threeGenFermionMass yIRs (fun _ => α) v N g2`. -/
theorem threeGenFermionMass_ratio_uniform_alpha
    (yIRs : Fin 3 → ℝ) (α v : ℝ) (N : ℕ) (g1 g2 : Fin 3)
    (h_y2_pos : 0 < yIRs g2) :
    threeGenFermionMass yIRs (fun _ => α) v N g1
      = (yIRs g1 / yIRs g2)
        * threeGenFermionMass yIRs (fun _ => α) v N g2 := by
  unfold threeGenFermionMass
  rw [threeGenYukawa_ratio_uniform_alpha yIRs α N g1 g2 h_y2_pos]
  ring

/-! ## 3. Headline composite report -/

/-- **Lion's-Pride Phase 9.15 headline — substrate mass-ratio
    invariance structural report.**

    For any three IR-Yukawa values `yIRs : Fin 3 → ℝ` (with
    `yIRs g₂ > 0`), uniform substrate sensitivity `α : ℝ`, Higgs
    VEV `v : ℝ`, truncation depth `N : ℕ`, and generation indices
    `g₁ g₂ : Fin 3`:

    1. **Yukawa ratio invariance**:
       `y_g₁^subst(N) = (y_g₁,IR / y_g₂,IR) · y_g₂^subst(N)`.

    2. **Fermion-mass ratio invariance**:
       `m_g₁^subst(N) = (y_g₁,IR / y_g₂,IR) · m_g₂^subst(N)`. -/
theorem substrate_mass_ratio_invariance_report
    (yIRs : Fin 3 → ℝ) (α v : ℝ) (N : ℕ) (g1 g2 : Fin 3)
    (h_y2_pos : 0 < yIRs g2) :
    threeGenYukawa yIRs (fun _ => α) N g1
      = (yIRs g1 / yIRs g2)
        * threeGenYukawa yIRs (fun _ => α) N g2 ∧
    threeGenFermionMass yIRs (fun _ => α) v N g1
      = (yIRs g1 / yIRs g2)
        * threeGenFermionMass yIRs (fun _ => α) v N g2 := by
  refine ⟨?_, ?_⟩
  · exact threeGenYukawa_ratio_uniform_alpha yIRs α N g1 g2 h_y2_pos
  · exact threeGenFermionMass_ratio_uniform_alpha yIRs α v N g1 g2 h_y2_pos

end OmegaTheory.QuantumGravity.SubstrateMassRatioInvariance
