/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 23 — bridge
  reduction: the linear case of the L-W expansion bridge is discharged
  via `Real.irrational_pi`, reducing the bridge to a HIGH-DEGREE sub-bridge.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Defines `LindemannExpansionIdentityBridge_HighDegree` (named real Prop,
  same shape as bridge but with `2 ≤ pQ.natDegree`) and proves:

      `LindemannExpansionIdentityBridge_HighDegree → LindemannExpansionIdentityBridge`

  via case split on `pQ.natDegree`:
  - `natDegree = 1` (linear case): π = -b/a ∈ ℚ would follow from the
    premise, but `Real.irrational_pi` contradicts.  Exfalso.
  - `natDegree ≥ 2`: apply the sub-bridge.

  This concretely PROGRESSES the L-W axiom retirement: cycle 64+ now
  needs to discharge ONLY the high-degree sub-bridge (the actual
  subset-multiplicity polynomial work), not the full bridge.  The
  reduction is a real structural step.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProof
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional

/-! ## High-degree sub-bridge -/

/-- **High-degree L-W expansion identity sub-bridge** — same shape as
    `LindemannExpansionIdentityBridge` but restricted to `pQ.natDegree ≥ 2`.

    This is the genuine cycle 64+ frontier: requires the subset-multiplicity
    polynomial construction via the fundamental theorem of symmetric
    polynomials applied to f.aroots ℂ, plus `IsLocalization.integerNormalization`
    to clear denominators. -/
def LindemannExpansionIdentityBridge_HighDegree : Prop :=
  ∀ pQ : Polynomial ℚ, pQ ≠ 0 → 2 ≤ pQ.natDegree →
    Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
    ∃ h : Polynomial ℤ, ∃ m : ℕ,
      h ≠ 0 ∧ Polynomial.eval 0 h ≠ 0 ∧ 0 < m ∧
      ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ)

/-! ## Bridge reduction theorem -/

/-- **Wave T4b session 23 — bridge reduction**.

    `LindemannExpansionIdentityBridge_HighDegree → LindemannExpansionIdentityBridge`.

    Proof: case split on `pQ.natDegree`:
    - `natDegree = 1`: linear premise gives π rational → contradicts
      `Real.irrational_pi`.  Exfalso → produce any existential.
    - `natDegree ≥ 2`: directly apply the sub-bridge. -/
theorem bridge_reduction_to_high_degree
    (sub_bridge : LindemannExpansionIdentityBridge_HighDegree) :
    LindemannExpansionIdentityBridge := by
  intros pQ h_ne h_natDeg_ge_1 h_zero
  by_cases h_lin : pQ.natDegree = 1
  · -- Linear case: derive False via s1 (irrational_pi)
    have h_natDeg_le_1 : pQ.natDegree ≤ 1 := by omega
    have h_contra := lindemann_premise_rat_linear_case pQ h_natDeg_le_1 h_ne
    exact (h_contra h_zero).elim
  · -- natDegree ≥ 2 case: apply sub-bridge
    have h_natDeg_ge_2 : 2 ≤ pQ.natDegree := by
      by_contra h_lt
      push_neg at h_lt
      omega
    exact sub_bridge pQ h_ne h_natDeg_ge_2 h_zero

/-! ## Headline + paper bundle -/

/-- **HEADLINE — Wave T4b session 23**.  Reduces the L-W expansion bridge
    to its high-degree sub-bridge.  Cycle 64+ now only needs to handle
    `pQ.natDegree ≥ 2` (the genuine L-W frontier). -/
theorem session_23_bridge_reduction_headline :
    LindemannExpansionIdentityBridge_HighDegree → LindemannExpansionIdentityBridge :=
  bridge_reduction_to_high_degree

/-- **W-T4b session 23 paper bundle** — citation marker. -/
theorem session_23_paper_bundle :
    (LindemannExpansionIdentityBridge_HighDegree →
        LindemannExpansionIdentityBridge)
    ∧ (∀ pQ : Polynomial ℚ, pQ.natDegree ≤ 1 → pQ ≠ 0 →
        Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0)
    ∧ Irrational (Real.pi : ℝ) := by
  refine ⟨?_, ?_, ?_⟩
  · exact bridge_reduction_to_high_degree
  · exact lindemann_premise_rat_linear_case
  · exact irrational_pi

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofBridgeReduction
