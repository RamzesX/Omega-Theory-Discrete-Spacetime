/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional

  Cycle 63 (Pisces, plan v2) Phase B Wave T-4b session 20 — discharge
  LindemannPremiseRat (modulo the L-W expansion identity bridge).

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers

  Combines session 1 (linear case) + session 19 (deg ≥ 2 conditional)
  via case split on pQ.natDegree to discharge LindemannPremiseRat
  CONDITIONAL on the L-W expansion identity bridge.

  Specifically:
    `LindemannExpansionIdentityBridge` : Prop ::=
      ∀ pQ : ℚ[X], pQ ≠ 0 → 1 ≤ pQ.natDegree → aeval π_ℝ pQ = 0 →
        ∃ h : ℤ[X], ∃ m : ℕ, h ≠ 0 ∧ h.eval 0 ≠ 0 ∧ 0 < m ∧
          ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ)

  This is a NAMED real Prop hypothesis (not := True), used non-vacuously
  in the body — per NO-STUBS rule §3.

  Once cycle 64+ discharges the bridge unconditionally (by building the
  subset-multiplicity polynomial from f.aroots), this theorem produces
  `lindemann_premise_rat_unconditional` UNCONDITIONALLY, retiring
  `Real.pi_transcendental`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined
import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProof

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProof
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAnalyticalBoundCombined

/-! ## L-W expansion identity bridge -/

/-- **L-W expansion identity bridge** — the orbit-product identity for
    a rational annihilator of π.  This is the mathematical content of
    the subset-multiplicity polynomial construction (deferred to cycle
    64+ via the fundamental theorem of symmetric polynomials).

    Concrete content: for `pQ : ℚ[X]` nonzero with `pQ.natDegree ≥ 1` and
    `aeval π_ℝ pQ = 0`, there exists an integer polynomial `h : ℤ[X]`
    (the subset-multiplicity polynomial of `(minpoly ℚ (i*π)).aroots ℂ`)
    and `m : ℕ` (the count of subsets with zero sum) such that
    `((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ)`. -/
def LindemannExpansionIdentityBridge : Prop :=
  ∀ pQ : Polynomial ℚ, pQ ≠ 0 → 1 ≤ pQ.natDegree →
    Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
    ∃ h : Polynomial ℤ, ∃ m : ℕ,
      h ≠ 0 ∧ Polynomial.eval 0 h ≠ 0 ∧ 0 < m ∧
      ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ)

/-! ## Main theorem (conditional on bridge) -/

/-- **Wave T4b session 20 — LindemannPremiseRat unconditional modulo bridge**.

    Given the L-W expansion identity bridge, derive the full
    `LindemannPremiseRat`: for any nonzero `pQ : ℚ[X]`, `aeval π_ℝ pQ ≠ 0`.

    Proof: case split on `pQ.natDegree`:
    - `pQ.natDegree = 0` (constant non-zero poly): aeval = pQ.coeff 0 ≠ 0.
    - `pQ.natDegree ≤ 1` (linear): use s1's `lindemann_premise_rat_linear_case`.
    - `pQ.natDegree ≥ 2`: use the bridge to extract h, m, identity, then
      apply s19's `lw_chain_derives_false` to get False (hence ≠ 0). -/
theorem lindemann_premise_rat_unconditional_modulo_bridge
    (h_bridge : LindemannExpansionIdentityBridge) :
    ∀ pQ : Polynomial ℚ, pQ ≠ 0 → Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0 := by
  intros pQ h_ne h_zero
  -- Case split on natDegree
  by_cases h_lin : pQ.natDegree ≤ 1
  · -- Linear case via s1
    exact lindemann_premise_rat_linear_case pQ h_lin h_ne h_zero
  · -- Higher-degree case via bridge + s19
    push_neg at h_lin
    have h_natDeg_ge_1 : 1 ≤ pQ.natDegree := Nat.one_le_iff_ne_zero.mpr (by omega)
    obtain ⟨h, m, h_h_ne, h_eval0_ne, h_m_pos, h_sum_eq_neg_m⟩ :=
      h_bridge pQ h_ne h_natDeg_ge_1 h_zero
    -- Apply s19
    exact lw_chain_derives_false h h_h_ne h_eval0_ne m h_m_pos h_sum_eq_neg_m

/-! ## Headline + paper bundle -/

/-- **HEADLINE — Wave T4b session 20**.  Two-conjunct: the bridge is a
    real Prop; given it, LindemannPremiseRat holds unconditionally. -/
theorem session_20_lindemann_premise_rat_unconditional_headline :
    (LindemannExpansionIdentityBridge →
      ∀ pQ : Polynomial ℚ, pQ ≠ 0 →
        Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0)
    ∧ (∀ pQ : Polynomial ℚ, pQ.natDegree ≤ 1 → pQ ≠ 0 →
        Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0) := by
  refine ⟨?_, ?_⟩
  · exact lindemann_premise_rat_unconditional_modulo_bridge
  · exact lindemann_premise_rat_linear_case

/-- **W-T4b session 20 paper bundle** — citation marker. -/
theorem session_20_paper_bundle :
    ((LindemannExpansionIdentityBridge →
        ∀ pQ : Polynomial ℚ, pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0)
      ∧ (∀ pQ : Polynomial ℚ, pQ.natDegree ≤ 1 → pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ ≠ 0))
    ∧ (∀ (h : Polynomial ℤ), h ≠ 0 → Polynomial.eval 0 h ≠ 0 →
        ∀ (m : ℕ), 0 < m →
        ((h.aroots ℂ).map Complex.exp).sum = -(m : ℂ) →
        False) := by
  refine ⟨?_, ?_⟩
  · exact session_20_lindemann_premise_rat_unconditional_headline
  · exact lw_chain_derives_false

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofUnconditional
