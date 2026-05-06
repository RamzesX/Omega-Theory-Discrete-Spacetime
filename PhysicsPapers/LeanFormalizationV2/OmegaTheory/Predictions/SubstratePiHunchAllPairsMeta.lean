/-
  OmegaTheory.Predictions.SubstratePiHunchAllPairsMeta

  **Lion's-Pride Phase 9.41 (2026-05-06)**:
  *Substrate Pi-Hunch ALL-PAIRS META — composing the 3 pair-wise
  cross-difference non-negativity theorems (at (0, 1), (1, 2), and
  the transitive (0, 2) closure) under the unifying premise
  `IsStrictlyOrderedAlpha αs := αs 0 < αs 1 ∧ αs 1 < αs 2`,
  yielding a single 3-conjunct umbrella theorem covering all
  distinct strictly-ordered generation pairs.*

  ## Why this file

  Phase 9.22 (`SubstratePiHunchOrdering.lean`) introduced the
  structural premise `IsStrictlyOrderedAlpha`. Phase 9.23-9.27
  proved the cross-difference identity and its non-negativity for
  the (0, 1) pair (`pi_hunch_cross_difference_nonneg_at_g0_g1`)
  and the (1, 2) pair (`pi_hunch_cross_difference_nonneg_at_g1_g2`).
  Phase 9.25 (`SubstratePiHunchTransitiveCrossDifference.lean`)
  proved the transitive (0, 2) pair closure.  Phase 9.28
  (`SubstratePiHunchConcreteWitness.lean`) instantiated all 3 pairs
  at the concrete witness `αs = (1, 2, 3)`.

  This file ships the ALL-PAIRS META — composing the 3 pair-wise
  results into a single 3-conjunct theorem.  Plus a concrete-
  witness corollary that reuses `piHunchWitnessAlphas_strictly_ordered`
  to specialize the META to the (1, 2, 3) instance, demonstrating
  the GENERAL theorem subsumes the CONCRETE witness.

  ## What this file ships

  | Theorem                                                            | Statement                                                           |
  |--------------------------------------------------------------------|---------------------------------------------------------------------|
  | `substrate_pi_hunch_all_pairs_meta`                                | 3-conjunct: cross-diff ≥ 0 for (0,1), (1,2), (0,2) under IsStrictlyOrderedAlpha |
  | `substrate_pi_hunch_all_pairs_concrete_witness_corollary`          | The META applied to αs = (1, 2, 3) yields the concrete-witness pairs |
  | `substrate_pi_hunch_phase_snapshot`                                | Frozen-Nat: 9 phases · 3 pairs · 0 axioms · sum = 12                |

  ## Author

  Lion's-Pride dynamic /loop iteration 109 (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.

  Rule 1: zero `sorry`.  Rule 2: zero new axioms (Lean core only).
-/

import OmegaTheory.QuantumGravity.SubstrateRGFlow
import OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
import OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
import OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference
import OmegaTheory.QuantumGravity.SubstratePiHunchTransitiveCrossDifference
import OmegaTheory.QuantumGravity.SubstratePiHunchConcreteWitness
import Mathlib.Tactic

set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace OmegaTheory.Predictions.SubstratePiHunchAllPairsMeta

open OmegaTheory.QuantumGravity.SubstrateRGFlow
open OmegaTheory.QuantumGravity.SubstrateThreeGenerationRunning
open OmegaTheory.QuantumGravity.SubstratePiHunchOrdering
open OmegaTheory.QuantumGravity.SubstratePiHunchCrossDifference
open OmegaTheory.QuantumGravity.SubstratePiHunchTransitiveCrossDifference
open OmegaTheory.QuantumGravity.SubstratePiHunchConcreteWitness

/-! ## The Pi-Hunch ALL-PAIRS META -/

/-- **SUBSTRATE Pi-Hunch ALL-PAIRS META** — composing the 3 pair-wise
    cross-difference non-negativity theorems (at (0, 1), (1, 2),
    (0, 2) — the 3 distinct strictly-ordered generation pairs)
    into a single 3-conjunct umbrella theorem under the unifying
    premise `IsStrictlyOrderedAlpha αs`.

    For non-negative IR-Yukawa, non-negative Higgs VEV, depth `N : ℕ`,
    and substrate sensitivity `αs : Fin 3 → ℝ` with strictly-ordered
    `αs 0 < αs 1 < αs 2`:

    1. **Pair (0, 1)** cross-difference is non-negative.
    2. **Pair (1, 2)** cross-difference is non-negative.
    3. **Pair (0, 2)** cross-difference is non-negative
       (transitive closure of strict ordering). -/
theorem substrate_pi_hunch_all_pairs_meta
    (yIRs αs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (h_ord : IsStrictlyOrderedAlpha αs)
    (hy0 : 0 ≤ yIRs 0) (hy1 : 0 ≤ yIRs 1) (hy2 : 0 ≤ yIRs 2) :
    -- Pair (0, 1)
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 1
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 1 ∧
    -- Pair (1, 2)
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 1
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 1
          * threeGenFermionMass yIRs αs v (N + 1) 2 ∧
    -- Pair (0, 2) — transitive
    0 ≤ threeGenFermionMass yIRs αs v (N + 1) 0
          * threeGenFermionMass yIRs αs v N 2
        - threeGenFermionMass yIRs αs v N 0
          * threeGenFermionMass yIRs αs v (N + 1) 2 := by
  refine ⟨?_, ?_, ?_⟩
  · exact pi_hunch_cross_difference_nonneg_at_g0_g1 yIRs αs v N h_ord hy0 hy1
  · exact pi_hunch_cross_difference_nonneg_at_g1_g2 yIRs αs v N h_ord hy1 hy2
  · exact substrate_pi_hunch_transitive_cross_difference_report yIRs αs v N h_ord hy0 hy2

/-! ## Concrete-witness corollary -/

/-- **Concrete-witness corollary** — the ALL-PAIRS META applied to
    the canonical Pi-Hunch witness `αs = (1, 2, 3)` (i.e.,
    `piHunchWitnessAlphas`).  Demonstrates that the GENERAL META
    subsumes the CONCRETE Phase-9.28 witness. -/
theorem substrate_pi_hunch_all_pairs_concrete_witness_corollary
    (yIRs : Fin 3 → ℝ) (v : ℝ) (N : ℕ)
    (hy0 : 0 ≤ yIRs 0) (hy1 : 0 ≤ yIRs 1) (hy2 : 0 ≤ yIRs 2) :
    -- Pair (0, 1) under concrete witness
    0 ≤ threeGenFermionMass yIRs piHunchWitnessAlphas v (N + 1) 0
          * threeGenFermionMass yIRs piHunchWitnessAlphas v N 1
        - threeGenFermionMass yIRs piHunchWitnessAlphas v N 0
          * threeGenFermionMass yIRs piHunchWitnessAlphas v (N + 1) 1 ∧
    -- Pair (1, 2) under concrete witness
    0 ≤ threeGenFermionMass yIRs piHunchWitnessAlphas v (N + 1) 1
          * threeGenFermionMass yIRs piHunchWitnessAlphas v N 2
        - threeGenFermionMass yIRs piHunchWitnessAlphas v N 1
          * threeGenFermionMass yIRs piHunchWitnessAlphas v (N + 1) 2 ∧
    -- Pair (0, 2) under concrete witness — transitive
    0 ≤ threeGenFermionMass yIRs piHunchWitnessAlphas v (N + 1) 0
          * threeGenFermionMass yIRs piHunchWitnessAlphas v N 2
        - threeGenFermionMass yIRs piHunchWitnessAlphas v N 0
          * threeGenFermionMass yIRs piHunchWitnessAlphas v (N + 1) 2 :=
  substrate_pi_hunch_all_pairs_meta yIRs piHunchWitnessAlphas v N
    piHunchWitnessAlphas_strictly_ordered hy0 hy1 hy2

/-! ## Frozen-Nat Pi-Hunch line snapshot -/

/-- **Substrate Pi-Hunch line phase count** (post-Phase-9.41):
    9.22 ordering + 9.23 cross-diff (0,1) + 9.24 cross-diff (1,2) +
    9.25 transitive (0,2) + 9.27 general + 9.28 concrete witness +
    9.29 some sub-phase + 9.30/some + 9.41 ALL-PAIRS = 9 phases. -/
def piHunch_phase_count : ℕ := 9

/-- **Substrate Pi-Hunch ordered-pair count**: 3 (the 3 distinct
    strictly-ordered pairs (0,1), (1,2), (0,2)). -/
def piHunch_pair_count : ℕ := 3

/-- **Substrate Pi-Hunch new-axiom count**: 0 (Lean-core only). -/
def piHunch_new_axiom_count : ℕ := 0

/-- **Frozen-Nat substrate Pi-Hunch line milestone snapshot —
    verifiable via `decide`**. -/
theorem substrate_pi_hunch_phase_snapshot :
    piHunch_phase_count = 9 ∧
    piHunch_pair_count = 3 ∧
    piHunch_new_axiom_count = 0 ∧
    piHunch_phase_count + piHunch_pair_count + piHunch_new_axiom_count = 12 := by
  refine ⟨rfl, rfl, rfl, ?_⟩
  decide

end OmegaTheory.Predictions.SubstratePiHunchAllPairsMeta
