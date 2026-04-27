/-
  OmegaTheory.Capstones.PiTranscendenceAxiomRetirementCycle63Final

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 33 — final
  capstone reflecting 20-session push.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Final cycle-63 paper-headline capstone with 5 conjunctions:

  1. **Bridge → π transcendental** (s21).
  2. **Linear case unconditional** (s1).
  3. **L-W chain → False under bridge** (s19).
  4. **Bridge sub-case for π² ∈ ℚ DISCHARGED** (s24).
  5. **π transcendental under π² ∈ ℚ** (s32).

  Plus orbit-product algebraic identity (s25), Vieta extraction (s27),
  rationality of esymm of aroots (s29), sum of aroots rational (s30),
  subsetSumPoly_C aroots integral (s31).

  ## Cycle 64 frontier

  Single remaining concrete task: discharge π² ∉ ℚ sub-case via
  `MvPolynomial.esymmAlgEquiv` (fundamental theorem of symmetric polynomials)
  applied to f.aroots ℂ.  Once landed: bridge unconditional, axiom flips,
  first Lean 4 proof of π transcendence ships.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTransUnderPiSqRational
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyArootsAlgebraic
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs
import OmegaTheory.Capstones.PiTranscendenceAxiomRetirement

namespace OmegaTheory.Capstones.PiTranscendenceAxiomRetirementCycle63Final

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofPiTransUnderPiSqRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofArootsEsymmRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumsSumRational
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyArootsAlgebraic
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyCoeffs
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProof
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined
open OmegaTheory.Capstones.PiTranscendenceAxiomRetirement

/-! ## Cycle-63 final headline -/

/-- **CYCLE 63 PAPER HEADLINE — Final capstone (post-20-session push)**.

    7-conjunct documentation of the cycle-63 deliverable for T-4 axiom
    retirement. -/
theorem cycle_63_final_paper_bundle :
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
    -- (4) π transcendental under π² ∈ ℚ
    ∧ ((∃ q : ℚ, (Real.pi : ℝ)^2 = (q : ℝ)) → Transcendental ℚ (Real.pi : ℝ))
    -- (5) esymm of aroots is rational
    ∧ (∀ (f : Polynomial ℤ), f ≠ 0 → ∀ (k : ℕ),
        ∃ q : ℚ, (f.aroots ℂ).esymm k = (q : ℂ))
    -- (6) sum of aroots is rational
    ∧ (∀ (f : Polynomial ℤ), f ≠ 0 →
        ∃ q : ℚ, (f.aroots ℂ).sum = (q : ℂ))
    -- (7) subsetSumPoly_C aroots are integral over ℚ
    ∧ (∀ (f : Polynomial ℤ), f ≠ 0 →
        ∀ σ ∈ (OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofSubsetSumPolyOrbit.subsetSumPoly_C
                 (f.aroots ℂ)).aroots ℂ,
        IsIntegral ℚ σ) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact pi_transcendence_axiom_retired_modulo_bridge
  · exact lindemann_premise_rat_linear_case
  · exact lw_chain_derives_false
  · exact pi_transcendental_under_pi_sq_rational
  · exact aroots_esymm_is_rational
  · exact aroots_sum_is_rational
  · exact session_31_subsetSumPoly_C_aroots_isIntegral_headline

end OmegaTheory.Capstones.PiTranscendenceAxiomRetirementCycle63Final
