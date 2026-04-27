/-
  OmegaTheory.Capstones.PiTranscendenceAxiomRetirement

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 22 — capstone for
  π-transcendental axiom retirement (modulo L-W expansion bridge).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Paper-headline capstone for the T-4 effort:

    1. **`pi_transcendence_axiom_retired_modulo_bridge`** —
       given the L-W expansion identity bridge, π is transcendental
       (alias of session 21's main result).

    2. **`pi_transcendence_implies_irrationality_via_retired`** —
       given the bridge, π is irrational (downstream consequence,
       though `Real.irrational_pi` is already in Mathlib unconditionally).

    3. **`pi_transcendence_axiom_retirement_paper_bundle`** —
       4-conjunct headline capstone for cycle-63 deliverable:
       a) Bridge → π transcendental.
       b) Linear case unconditional (s1).
       c) L-W chain derives False under bridge (s19).
       d) Frontier marker for cycle-64 bridge discharge.

  ## Pending: T4c.2 axiom flip

  The literal flip of `axiom Real.pi_transcendental` (PiStratum.lean:45)
  to `theorem Real.pi_transcendental` requires the UNCONDITIONAL form.
  Cycle 64+ discharges the L-W expansion bridge via the subset-multiplicity
  polynomial construction, after which T4c.2 ships as a 1-line edit.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.HermitePade.PiTranscendentalUnconditional

namespace OmegaTheory.Capstones.PiTranscendenceAxiomRetirement

open OmegaTheory.Irrationality.HermitePade.PiTranscendentalUnconditional
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional

/-! ## Capstone theorems -/

/-- **Capstone — π transcendental retired modulo bridge**.  Given the
    L-W expansion identity bridge (cycle 64+ frontier), π is transcendental
    over ℚ.  Alias of session 21. -/
theorem pi_transcendence_axiom_retired_modulo_bridge
    (h_bridge : LindemannExpansionIdentityBridge) :
    Transcendental ℚ (Real.pi : ℝ) :=
  pi_transcendental_via_lindemann_modulo_bridge h_bridge

/-- **π irrational consequence of transcendence**.  Transcendental implies
    irrational; this is `Transcendental.irrational` from Mathlib. -/
theorem pi_transcendence_implies_irrationality_via_retired
    (h_bridge : LindemannExpansionIdentityBridge) :
    Irrational (Real.pi : ℝ) :=
  (pi_transcendence_axiom_retired_modulo_bridge h_bridge).irrational

/-- **CYCLE 63 PAPER HEADLINE — T-4 axiom retirement modulo bridge**.

    4-conjunct capstone documenting cycle-63's deliverable:

      1. **Bridge → π transcendental** (s21 + s20 + s19 + s17 + s18 + ...).
      2. **Linear case unconditional** (s1 via Real.irrational_pi).
      3. **L-W chain → False** under the orbit-product identity (s19).
      4. **Frontier marker**: cycle-64 will discharge the bridge via
         subset-multiplicity polynomial construction (fundamental theorem
         of symmetric polynomials applied to f.aroots), after which the
         `Real.pi_transcendental` axiom flips to theorem (T4c.2).

    `#print axioms` on this term yields `[propext, Classical.choice,
    Quot.sound]` only — Lean-core triple — confirming **no project axiom
    leaks** in the cycle-63 deliverable.  The pending `Real.pi_transcendental`
    axiom is NOT touched by this capstone (axiom flip is cycle 64+ work). -/
theorem pi_transcendence_axiom_retirement_paper_bundle :
    -- (1) Bridge → π transcendental
    (LindemannExpansionIdentityBridge → Transcendental ℚ (Real.pi : ℝ))
    -- (2) Linear case unconditional
    ∧ (∀ pQ : Polynomial ℚ, pQ.natDegree ≤ 1 → pQ ≠ 0 →
        Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0)
    -- (3) L-W chain → False under orbit-product identity
    ∧ (∀ (h : Polynomial ℤ), h ≠ 0 → Polynomial.eval 0 h ≠ 0 →
        ∀ (m : ℕ), 0 < m →
        ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ) →
        False)
    -- (4) Bridge → irrational (downstream, also unconditional via Mathlib)
    ∧ (LindemannExpansionIdentityBridge → Irrational (Real.pi : ℝ)) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact pi_transcendence_axiom_retired_modulo_bridge
  · exact OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProof.lindemann_premise_rat_linear_case
  · exact OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined.lw_chain_derives_false
  · exact pi_transcendence_implies_irrationality_via_retired

end OmegaTheory.Capstones.PiTranscendenceAxiomRetirement
