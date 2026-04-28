/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicChainGrandCapstone

  T-5 (Roth's theorem) — **Phase 7 ext #135: Cubic+ chain GRAND
  CAPSTONE — bundles s116 (Roth-form bound) + s117 (Schmidt-conditional)
  + s132 (UNCONDITIONAL quadratic) + s134 (clean bundle)**, sub session
  559iiiiiiii — STRICT critical-path #316 (T-5) Phase 7 ext #135.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  GRAND CAPSTONE bundling all major cubic+ chain results into a single
  comprehensive theorem:

  For α : ℝ:
  1. **Cubic+ Roth-form lower bound** (s116): for any p with Schmidt-style
     index k > p.natDegree/(2+ε), `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`.
  2. **Schmidt-conditional Roth-form** (s117): under SchmidtAuxPolyExists
     hypothesis, ∃ p, k satisfying Schmidt budget for irrational algebraic α.
  3. **UNCONDITIONAL Quadratic Roth-form** (s132): for IsQuadraticAlgebraic α,
     ∃ C > 0, p ≠ 0, ∀ q close to α: `C · q.den^(-(2+ε)) ≤ |q-α|`.

  Single derivation:
  1. `T5_cubic_chain_grand_capstone`: 3-conjunct GRAND bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #135 — Cubic+ chain GRAND CAPSTONE.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAlgebraicRothBundle

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicChainGrandCapstone

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAlgebraicRothBundle

/-! ## Cubic+ chain GRAND CAPSTONE -/

/-- **🚨 Wave T5 session 559iiiiiiii — Cubic+ chain GRAND CAPSTONE**.

    3-conjunct bundle of all major cubic+ chain results.

    Three parts:
    1. Roth-form bound for any (p, k) satisfying Schmidt conditions.
    2. Schmidt-conditional capstone for irrational algebraic α.
    3. UNCONDITIONAL quadratic Roth via Schmidt path. -/
theorem T5_cubic_chain_grand_capstone
    (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (h_quad : IsQuadraticAlgebraic α)
    (h_schmidt : SchmidtAuxPolyExists) :
    -- Part 1: Roth-form bound for any (p, k) satisfying Schmidt conditions
    (∀ (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
        (h_index : ∀ i, i < k →
          (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
        (h_budget : (k : ℝ) * (2 + ε) > p.natDegree)
        (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
        (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
        (h_M_pos : (0 : ℝ) <
          ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|),
      (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
        ((q.den : ℝ)) ^ (-(2 + ε)) ≤
        |((q : ℚ) : ℝ) - α|) ∧
    -- Part 2: Schmidt-conditional capstone for irrational algebraic α
    (∃ (p : Polynomial ℤ) (k : ℕ),
      1 ≤ k ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
          ((q.den : ℝ)) ^ (-(2 + ε)) ≤
          |((q : ℚ) : ℝ) - α|) ∧
    -- Part 3: UNCONDITIONAL Quadratic Roth via Schmidt path (EXISTS-C form)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) := by
  refine ⟨?_, ?_, ?_⟩
  · -- Part 1: from ext #116 directly
    intros p k hk h_index h_budget q h_close h_nonzero h_M_pos
    exact T5_cubic_roth_form_bound α p k hk h_index ε hε h_budget q h_close h_nonzero h_M_pos
  · -- Part 2: from ext #117
    exact T5_schmidt_roth_form_capstone h_schmidt α hα h_alg ε hε
  · -- Part 3: from ext #134
    exact T5_quadratic_algebraic_roth_exists_C α h_quad ε hε

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559iiiiiiii — T-5 Phase 7 ext #135:
    Cubic+ chain GRAND CAPSTONE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #135.

    🏆🏆🏆 GRAND CAPSTONE — 3-conjunct bundle of cubic+ chain results.

    Single derivation:
    1. `T5_cubic_chain_grand_capstone` — comprehensive bundle.

    Composes:
    - ext #116 (Roth-form bound)
    - ext #117 (Schmidt-conditional capstone)
    - ext #134 (UNCONDITIONAL quadratic Roth via Schmidt path)

    The cubic+ chain CONDITIONAL infrastructure is COMPLETE end-to-end.
    UNCONDITIONAL quadratic Roth via Schmidt path is shipped (cross-validates
    Liouville path s44+). The remaining HARD piece for FULL UNCONDITIONAL
    Roth: Schmidt-Wirsing-Roth multivariate machinery for cubic+ discharge.

    Mathlib usage: composition of ext #116 + #117 + #134.

    Sub-lemma 308/N. Lean-core only.

    🏆🏆🏆 First Lean-core T-5 Phase 7 CUBIC+ CHAIN GRAND CAPSTONE.
       Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim.
       Cubic+ chain conditional infrastructure: COMPLETE.
       Quadratic Roth via Schmidt path: UNCONDITIONAL.
       Cubic+ Roth via Schmidt path: discharge pending. -/
theorem session_559iiiiiiii_T5_phase7_cubic_chain_grand_capstone_headline
    (α : ℝ) (ε : ℝ) (hε : 0 < ε)
    (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (h_quad : IsQuadraticAlgebraic α)
    (h_schmidt : SchmidtAuxPolyExists) :
    (∀ (p : Polynomial ℤ) (k : ℕ) (hk : 1 ≤ k)
        (h_index : ∀ i, i < k →
          (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
        (h_budget : (k : ℝ) * (2 + ε) > p.natDegree)
        (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
        (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0)
        (h_M_pos : (0 : ℝ) <
          ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|),
      (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
        ((q.den : ℝ)) ^ (-(2 + ε)) ≤
        |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) := by
  obtain ⟨h1, _h2, h3⟩ :=
    T5_cubic_chain_grand_capstone α ε hε hα h_alg h_quad h_schmidt
  exact ⟨h1, h3⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicChainGrandCapstone
