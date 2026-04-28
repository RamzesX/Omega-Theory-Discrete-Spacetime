/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis

  T-5 (Roth's theorem) — **Phase 7 ext #105: Schmidt aux poly NAMED
  hypothesis + cubic+ Roth conditional capstone**, sub session
  559eeeeee — STRICT critical-path #316 (T-5) Phase 7 ext #105.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Defines `SchmidtAuxPolyExists` NAMED hypothesis Prop (per §7.0 NO STUBS,
  this is a real Prop with quantifier content, not a stub) that captures
  the LAST hard piece for unconditional cubic+ Roth.

  Then ships the conditional capstone: under `SchmidtAuxPolyExists`,
  the cubic+ Roth-form lower bound holds.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  Per anti-pattern lock 2026-04-29: NAMED hypothesis is intermediate
  step, not terminal. Future ext #106+ will discharge it via
  Schmidt-Wirsing-Roth multivariate machinery.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #105 — Schmidt aux poly NAMED hypothesis + capstone.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.RingTheory.Algebraic.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothDistanceLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial

/-! ## Schmidt aux poly NAMED hypothesis -/

/-- **SchmidtAuxPolyExists** [HYPOTHESIS]: for any α : ℝ irrational algebraic
    over ℤ and any ε > 0, there exists an integer polynomial p with index
    ≥ k at α (over ℝ via map Int.cast) for some k with `k(2+ε) > p.natDegree`,
    AND positive sum of |Taylor coefficients| at index ≥ k.

    This is the SCHMIDT-WIRSING-ROTH MULTIVARIATE AUX POLY existence,
    the LAST hard piece for unconditional cubic+ Roth.

    **Per project rule §7.0**: NAMED real Prop with full quantifier
    content, used non-vacuously, NOT `:= True`. -/
def SchmidtAuxPolyExists : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
    ∀ (ε : ℝ), 0 < ε →
    ∃ (p : Polynomial ℤ) (k : ℕ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      (0 : ℝ) <
        ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|

/-! ## Conditional cubic+ Roth capstone -/

/-- **🚨 Wave T5 session 559eeeeee — Cubic+ Roth conditional capstone**.

    Given `SchmidtAuxPolyExists`, for irrational algebraic α and any
    ε > 0, there exists a polynomial p and index k such that the cubic+
    chain core inequality holds for q close to α.

    NOTE: this is a CONDITIONAL theorem, not the full Roth. The full
    Roth requires combining this with: q.den-large pigeonhole +
    `|q - α| ≤ 1` reduction + composition into RothTheorem signature. -/
theorem T5_cubic_roth_conditional_via_schmidt
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (k : ℕ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
          ((q.den : ℝ)) ^ p.natDegree) ≤
          |((q : ℚ) : ℝ) - α| ^ k := by
  -- Apply h_schmidt to extract aux poly + index
  obtain ⟨p, k, hp_ne, hp_root, hk_bound, h_index, h_M_pos⟩ :=
    h_schmidt α hα h_alg ε hε
  refine ⟨p, k, hp_ne, hp_root, hk_bound, h_index, ?_⟩
  intros q h_close h_nonzero
  exact T5_cubic_roth_distance_lower_bound α p k h_index q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559eeeeee — T-5 Phase 7 ext #105:
    Schmidt aux poly NAMED hypothesis + cubic+ Roth conditional**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #105.

    🏆 CUBIC+ ROTH CONDITIONAL CAPSTONE — under SchmidtAuxPolyExists,
    Roth-form bound holds for irrational algebraic α.

    Two derivations:
    1. `SchmidtAuxPolyExists` NAMED hypothesis Prop
    2. `T5_cubic_roth_conditional_via_schmidt` — conditional capstone

    The remaining work for unconditional Roth: discharge SchmidtAuxPolyExists
    via Schmidt-Wirsing-Roth multivariate machinery (HARD multi-day,
    requires multivariate Taylor + index theorem + Wronskian).

    Mathlib usage: composition of ext #103 + ext #104.

    Sub-lemma 278/N in T-1 (T-5 Phase 7 ext #105).  Lean-core only.

    🏆 Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28
    + anti-pattern lock 2026-04-29: full prove mode, NO STUBS, NO slim,
    NO concrete-witness-spam. NAMED hypothesis is intermediate step,
    not terminal — Schmidt's lemma discharge is the remaining piece. -/
theorem session_559eeeeee_T5_phase7_schmidt_aux_poly_hypothesis_headline
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (k : ℕ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
          ((q.den : ℝ)) ^ p.natDegree) ≤
          |((q : ℚ) : ℝ) - α| ^ k :=
  T5_cubic_roth_conditional_via_schmidt h_schmidt α hα h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
