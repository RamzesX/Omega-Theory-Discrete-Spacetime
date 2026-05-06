/-
  OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning

  **Lion's-Pride Phase 9.14 (2026-05-06)**:
  *Substrate three-generation Yukawa running — applies Phase 9.13
  Yukawa-running pattern to the SM's three fermion generations
  (e.g., electron/muon/tau or up/charm/top), with mass-ordering
  preservation under independent running.*

  ## Why this file

  The SM has THREE fermion generations.  Each fermion sector
  (charged leptons, up-quarks, down-quarks, neutrinos) has three
  generations with different masses spanning ~6 orders of magnitude
  (e.g., m_e/m_τ ≈ 3 × 10^{-4}).

  Phase 9.13 (`SubstrateYukawaRunning`) shipped the substrate-running
  pattern for one Yukawa coupling.  This file applies it to all
  three generations independently:

      y_g(N) := y_g,IR · (1 + α_g · δ_comp(N))   for g ∈ {1, 2, 3}
      m_g(N) := y_g(N) · v

  Each generation runs INDEPENDENTLY, allowing different
  IR-asymptotes (= the observed PDG fermion masses) and different
  substrate sensitivities α_g.

  The substrate's "Pi Hunch" suggests that the 3 generations
  correspond to 3 irrationals (gen 1 ↔ √2, gen 2 ↔ e, gen 3 ↔ π)
  with descending convergence rates → ascending masses.  This file
  ships the SCAFFOLD that supports this hypothesis structurally;
  specific (y_g,IR, α_g) calibration to PDG values is multi-month
  future work.

  Properties shipped:

  1. **Each generation runs independently**: pull-out per-gen run.
  2. **Monotone IR flow per generation**: each y_g(N) ≥ 0 and
     y_g(N+1) ≤ y_g(N) for non-negative parameters.
  3. **Mass ordering preserved**: if `y_1,IR ≤ y_2,IR ≤ y_3,IR`
     and SAME `α_g = α` for all g, the relative ordering is
     preserved at every N.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `threeGenYukawa yIRs αs N`                            | (def: 3-generation Yukawa running)            |
  | `threeGenFermionMass yIRs αs v N`                     | (def: 3-generation fermion mass via tree-level)|
  | Per-gen non-negativity                                | `threeGenYukawa_nonneg`                        |
  | Per-gen monotone decreasing                           | `threeGenYukawa_monotone_decreasing`            |
  | Mass ordering preservation under uniform α            | `threeGenYukawa_ordering_preserved`             |
  | Headline (3-conjunct)                                 | `substrate_three_generation_running_report`     |

  ## Honest scope

  This file ships the structural 3-generation shape.  It does NOT yet:
  * Map (y_g,IR, α_g) to specific irrational values (√2/e/π for
    Pi-Hunch hypothesis) — multi-month calibration.
  * Address Yukawa hierarchy ratios (m_e:m_μ:m_τ ≈ 1:200:3500)
    quantitatively.
  * Couple to CKM/PMNS mixing matrices.

  What it DOES ship: the structural prediction that ALL three SM
  generations run monotonically toward their (different) IR-asymptotes.

  ## Author

  Lion's-Pride dynamic /loop iteration 57 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateRunningCoupling
import OmegaTheory.QuantumGravity.SubstrateYukawaRunning
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateRunningCoupling
open OmegaTheory.QuantumGravity.SubstrateYukawaRunning

/-! ## 1. Three-generation Yukawa running

    `y_g(N) = y_g,IR · (1 + α_g · δ_comp(N))` for `g : Fin 3`. -/

/-- **Three-generation Yukawa running**:
    `y_g^subst(N) := yukawaRunning (yIRs g) (αs g) N`. -/
noncomputable def threeGenYukawa
    (yIRs αs : Fin 3 → ℝ) (N : ℕ) (g : Fin 3) : ℝ :=
  yukawaRunning (yIRs g) (αs g) N

/-- **Three-generation fermion mass running**:
    `m_g^subst(N) := y_g^subst(N) · v`. -/
noncomputable def threeGenFermionMass
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ) (g : Fin 3) : ℝ :=
  threeGenYukawa yIRs αs N g * v

/-! ## 2. Per-generation non-negativity -/

/-- **Per-generation non-negativity**: each generation's Yukawa is
    non-negative when its parameters are non-negative. -/
theorem threeGenYukawa_nonneg
    (yIRs αs : Fin 3 → ℝ) (N : ℕ) (g : Fin 3)
    (hyIR : 0 ≤ yIRs g) (hα : 0 ≤ αs g) :
    0 ≤ threeGenYukawa yIRs αs N g := by
  unfold threeGenYukawa
  exact yukawaRunning_nonneg (yIRs g) (αs g) hyIR hα N

/-! ## 3. Per-generation monotone decreasing -/

/-- **Per-generation monotone decreasing**: each generation's Yukawa
    is monotone-decreasing in N when its parameters are non-negative. -/
theorem threeGenYukawa_monotone_decreasing
    (yIRs αs : Fin 3 → ℝ) (N : ℕ) (g : Fin 3)
    (hyIR : 0 ≤ yIRs g) (hα : 0 ≤ αs g) :
    threeGenYukawa yIRs αs (N + 1) g ≤ threeGenYukawa yIRs αs N g := by
  unfold threeGenYukawa
  exact yukawaRunning_monotone_decreasing (yIRs g) (αs g) hyIR hα N

/-! ## 4. Mass ordering preservation under uniform α -/

/-- **Mass ordering preserved under uniform α**: when all three
    generations share the SAME substrate sensitivity `α`, the relative
    mass ordering at the IR-asymptote is preserved at every N.

    For `αs = (fun _ => α)` and `0 ≤ α`:
    `yIRs g₁ ≤ yIRs g₂` ⟹
        `threeGenYukawa yIRs (fun _ => α) N g₁ ≤ threeGenYukawa yIRs (fun _ => α) N g₂`. -/
theorem threeGenYukawa_ordering_preserved
    (yIRs : Fin 3 → ℝ) (α : ℝ) (N : ℕ) (g1 g2 : Fin 3)
    (hα : 0 ≤ α) (h_ord : yIRs g1 ≤ yIRs g2) :
    threeGenYukawa yIRs (fun _ => α) N g1
      ≤ threeGenYukawa yIRs (fun _ => α) N g2 := by
  unfold threeGenYukawa yukawaRunning runningCoupling
  -- yIRs g1 · (1 + α · δ) ≤ yIRs g2 · (1 + α · δ)
  -- factor: 1 + α · δ ≥ 0 always (positive δ, non-neg α)
  have h_pos_N : 0 < substrateRGScale N := substrateRGScale_pos N
  have h_inner_nonneg : 0 ≤ 1 + α * substrateRGScale N := by
    have : 0 ≤ α * substrateRGScale N :=
      mul_nonneg hα (le_of_lt h_pos_N)
    linarith
  exact mul_le_mul_of_nonneg_right h_ord h_inner_nonneg

/-! ## 5. Headline composite report -/

/-- **Lion's-Pride Phase 9.14 headline — substrate three-generation
    Yukawa running structural report.**

    For any IR-asymptote Yukawa values `yIRs : Fin 3 → ℝ`, substrate
    sensitivities `αs : Fin 3 → ℝ`, generation indices `g₁ g₂ : Fin 3`,
    truncation depth `N : ℕ`, and uniform `α ≥ 0`:

    1. **Per-generation non-negativity**:
       `0 ≤ yIRs g ∧ 0 ≤ αs g` ⟹ `0 ≤ threeGenYukawa yIRs αs N g`.

    2. **Per-generation monotone decreasing**:
       same hypotheses ⟹ `threeGenYukawa(N+1, g) ≤ threeGenYukawa(N, g)`.

    3. **Mass ordering preserved under uniform α**:
       `α ≥ 0 ∧ yIRs g₁ ≤ yIRs g₂` ⟹
       `threeGenYukawa yIRs (fun _ => α) N g₁ ≤ threeGenYukawa yIRs (fun _ => α) N g₂`. -/
theorem substrate_three_generation_running_report
    (yIRs αs : Fin 3 → ℝ) (α : ℝ) (N : ℕ) (g g1 g2 : Fin 3) :
    (0 ≤ yIRs g → 0 ≤ αs g → 0 ≤ threeGenYukawa yIRs αs N g) ∧
    (0 ≤ yIRs g → 0 ≤ αs g →
      threeGenYukawa yIRs αs (N + 1) g ≤ threeGenYukawa yIRs αs N g) ∧
    (0 ≤ α → yIRs g1 ≤ yIRs g2 →
      threeGenYukawa yIRs (fun _ => α) N g1
        ≤ threeGenYukawa yIRs (fun _ => α) N g2) := by
  refine ⟨?_, ?_, ?_⟩
  · intros hyIR hα
    exact threeGenYukawa_nonneg yIRs αs N g hyIR hα
  · intros hyIR hα
    exact threeGenYukawa_monotone_decreasing yIRs αs N g hyIR hα
  · intros hα h_ord
    exact threeGenYukawa_ordering_preserved yIRs α N g1 g2 hα h_ord

end OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
