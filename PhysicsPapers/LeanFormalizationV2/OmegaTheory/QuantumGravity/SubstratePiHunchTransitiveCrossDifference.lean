/-
  OmegaTheory.QuantumGravity.SubstratePiHunchTransitiveCrossDifference

  **Lion's-Pride Phase 9.25 (2026-05-06)**:
  *Substrate Pi-Hunch transitive cross-difference at (g₁=0, g₂=2) —
  completes the cross-difference triple.  Phase 9.23 shipped the
  adjacent pairs (0,1) and (1,2); this file ships the transitive
  pair (0,2) using the strict ordering αs 0 < αs 2 from Phase 9.22.*

  ## Why this file

  Phase 9.23 (`SubstratePiHunchCrossDifference`) shipped TWO of the
  three cross-difference sign theorems under Pi-Hunch ordering:

  * `pi_hunch_cross_difference_nonneg_at_g0_g1`  (adjacent: αs 0 < αs 1)
  * `pi_hunch_cross_difference_nonneg_at_g1_g2`  (adjacent: αs 1 < αs 2)

  This file COMPLETES the triple by shipping the TRANSITIVE case:

  * `pi_hunch_cross_difference_nonneg_at_g0_g2`  (transitive: αs 0 < αs 2)

  The proof structurally mirrors the adjacent cases — the only
  difference is the `αs 0 < αs 2` strict inequality is obtained
  from Phase 9.22's `isStrictlyOrderedAlpha_implies_first_less_third`
  (transitivity of `<`) rather than directly destructuring the
  `IsStrictlyOrderedAlpha` predicate.

  ## What this file ships

  | Property                                              | Theorem                                       |
  |-------------------------------------------------------|-----------------------------------------------|
  | `pi_hunch_cross_difference_nonneg_at_g0_g2`           | (g₁=0, g₂=2) cross-difference ≥ 0              |
  | Headline (1-conjunct)                                 | `substrate_pi_hunch_transitive_cross_difference_report` |

  ## Honest scope

  This file ships the third (transitive) cross-difference sign theorem.
  Combined with Phase 9.23, the COMPLETE triple of cross-difference
  signs under Pi-Hunch ordering is now in V2.

  ## Author

  Lion's-Pride dynamic /loop iteration 71 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
import OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
import OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.QuantumGravity.SubstratePiHunchTransitiveCrossDifference

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstrateNonUniformAlpha
open OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
open OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference

/-! ## 1. Pi-Hunch transitive cross-difference at (g₁=0, g₂=2) -/

/-- **Pi-Hunch transitive cross-difference at (g₁=0, g₂=2)**: under
    Pi-Hunch ordering and non-negative IR-Yukawa values, the cross-
    difference `m_0(N+1)·m_2(N) - m_0(N)·m_2(N+1) ≥ 0`.

    The proof structurally mirrors the (0,1) and (1,2) adjacent cases
    from Phase 9.23.  The only difference is that `αs 0 < αs 2` is
    obtained transitively from `IsStrictlyOrderedAlpha` via
    `isStrictlyOrderedAlpha_implies_first_less_third` (Phase 9.22),
    rather than directly destructuring the predicate. -/
theorem pi_hunch_cross_difference_nonneg_at_g0_g2
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy2 : 0 ≤ yIRs 2) :
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 2 := by
  rw [mass_cross_difference_identity]
  -- Goal: 0 ≤ yIRs 0 · yIRs 2 · v² · (αs 0 - αs 2) · (δ_{N+1} - δ_N)
  have h02 : αs 0 < αs 2 := isStrictlyOrderedAlpha_implies_first_less_third αs h_ord
  have h_α_neg : αs 0 - αs 2 < 0 := by linarith
  have h_δ_diff_le : substrateRGScale (N + 1) - substrateRGScale N ≤ 0 := by
    have := substrateRGScale_decreasing N
    linarith
  have h_y_prod : 0 ≤ yIRs 0 * yIRs 2 := mul_nonneg hy0 hy2
  have h_v_sq : 0 ≤ v^2 := sq_nonneg v
  have h_y_v_sq : 0 ≤ yIRs 0 * yIRs 2 * v^2 := mul_nonneg h_y_prod h_v_sq
  -- Product: (≥0) · (<0) · (≤0) ≥ 0
  nlinarith [h_y_v_sq, h_α_neg, h_δ_diff_le,
             mul_nonpos_of_nonneg_of_nonpos h_y_v_sq (le_of_lt h_α_neg)]

/-! ## 2. Headline composite report -/

/-- **Lion's-Pride Phase 9.25 headline — substrate Pi-Hunch
    transitive cross-difference structural report.**

    For Pi-Hunch ordered substrate sensitivities, non-negative
    IR-Yukawa values, Higgs VEV `v : ℝ`, and truncation depth `N : ℕ`:

    1. **Transitive cross-difference at (g₁=0, g₂=2)**: ≥ 0.

    Combined with Phase 9.23 (adjacent (0,1) and (1,2)), the COMPLETE
    triple of cross-difference signs under Pi-Hunch ordering is now
    in V2. -/
theorem substrate_pi_hunch_transitive_cross_difference_report
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy2 : 0 ≤ yIRs 2) :
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 2 :=
  pi_hunch_cross_difference_nonneg_at_g0_g2 yIRs αs v N h_ord hy0 hy2

/-! ## 3. Complete triple report (composite of 9.23 + 9.25) -/

/-- **COMPLETE TRIPLE of Pi-Hunch cross-difference signs**:
    under Pi-Hunch ordering and non-negative IR-Yukawa values,
    ALL THREE cross-differences (0,1), (1,2), (0,2) are ≥ 0.

    This is the COMPLETE structural Pi-Hunch sign report, combining
    Phase 9.23's adjacent pairs with Phase 9.25's transitive pair. -/
theorem substrate_pi_hunch_complete_triple_cross_difference
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy1 : 0 ≤ yIRs 1) (hy2 : 0 ≤ yIRs 2) :
    -- (g₁=0, g₂=1)
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 1
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 1 ∧
    -- (g₁=1, g₂=2)
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 1
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 1
          * threeGenFermionMass yIRs αs v (N + 1) 2 ∧
    -- (g₁=0, g₂=2) — transitive
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 2 := by
  refine ⟨?_, ?_, ?_⟩
  · exact pi_hunch_cross_difference_nonneg_at_g0_g1 yIRs αs v N h_ord hy0 hy1
  · exact pi_hunch_cross_difference_nonneg_at_g1_g2 yIRs αs v N h_ord hy1 hy2
  · exact pi_hunch_cross_difference_nonneg_at_g0_g2 yIRs αs v N h_ord hy0 hy2

end OmegaTheory.QuantumGravity.SubstratePiHunchTransitiveCrossDifference
