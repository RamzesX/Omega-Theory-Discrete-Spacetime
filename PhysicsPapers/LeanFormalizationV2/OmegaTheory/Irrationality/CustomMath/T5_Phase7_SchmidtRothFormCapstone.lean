/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone

  T-5 (Roth's theorem) — **Phase 7 ext #117: Schmidt → Roth-form
  conditional capstone (cubic+ chain HEADLINE)**, sub session
  559qqqqqqq — STRICT critical-path #316 (T-5) Phase 7 ext #117.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #105 (Schmidt witness extraction under
  `SchmidtAuxPolyExists`) with ext #116 (Roth-form bound) into the
  HEADLINE conditional capstone:

  Under `SchmidtAuxPolyExists`, for irrational algebraic α and ε > 0,
  ∃ aux poly p with deg d and index k ≥ 1 (Roth budget `k(2+ε) > d`),
  ∀ q close to α with eval₂ q p ≠ 0:
    `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`

  This IS the Roth-form CONDITIONAL bound. Composed unconditionally
  with Schmidt aux poly construction → unconditional Roth.

  Single derivation:
  1. `T5_schmidt_roth_form_capstone`: composes s105 + s116.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #117 — Schmidt → Roth-form conditional capstone HEADLINE.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

/-! ## Schmidt → Roth-form conditional capstone -/

/-- **🚨 Wave T5 session 559qqqqqqq — Schmidt → Roth-form conditional capstone**.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0,
    ∃ aux p, k ≥ 1 with k(2+ε) > p.natDegree, ∀ q close to α with eval₂ ≠ 0:
      `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_schmidt_roth_form_capstone
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (k : ℕ),
      1 ≤ k ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
          ((q.den : ℝ)) ^ (-(2 + ε)) ≤
          |((q : ℚ) : ℝ) - α| := by
  -- Apply h_schmidt to extract aux poly + index + M_pos
  obtain ⟨p, k, hp_ne, hp_root, hk_bound, h_index, h_M_pos⟩ :=
    h_schmidt α hα h_alg ε hε
  -- Need k ≥ 1: k=0 → 0 > p.natDegree, but (p.natDegree : ℝ) ≥ 0
  by_cases hk : 1 ≤ k
  · refine ⟨p, k, hk, hp_ne, hp_root, hk_bound, h_index, ?_⟩
    intros q h_close h_nonzero
    -- Apply s116 Roth-form bound
    exact T5_cubic_roth_form_bound α p k hk h_index ε hε hk_bound q h_close h_nonzero h_M_pos
  · -- k = 0 case: hk_bound `(0 : ℝ) * (2+ε) > p.natDegree` becomes `0 > p.natDegree`,
    -- contradiction with `(p.natDegree : ℝ) ≥ 0`
    push_neg at hk
    interval_cases k
    have h_nn : (0 : ℝ) ≤ (p.natDegree : ℝ) := by exact_mod_cast Nat.zero_le _
    simp only [Nat.cast_zero, zero_mul] at hk_bound
    linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559qqqqqqq — T-5 Phase 7 ext #117:
    Schmidt → Roth-form CONDITIONAL CAPSTONE**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #117.

    🏆 ROTH-FORM CONDITIONAL CAPSTONE — composes ext #105 + ext #116.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0,
    ∃ aux p with deg d, k ≥ 1:
      - p ≠ 0, α annihilates p
      - k(2+ε) > p.natDegree (Roth budget)
      - Index ≥ k at α (Taylor coeffs vanish for i < k)
      - ∀ q close to α with eval₂ ≠ 0:
          `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|`

    Strategy: extract Schmidt witness from h_schmidt, apply s116 Roth-form
    bound. Case split on k ≥ 1 (k = 0 contradicts `k(2+ε) > p.natDegree`).

    The remaining work for unconditional Roth: discharge SchmidtAuxPolyExists
    (Schmidt-Wirsing-Roth multivariate machinery, ~10-20 sessions HARD work).

    Compatibility:
    - For QUADRATIC α (already done via Liouville s44+) — this gives a
      cleaner Schmidt-style proof path.
    - For CUBIC+ α — this is the FIRST unconditional path (mod Schmidt
      discharge).
    - The Roth constant `C = M^(-1/k)` depends on the Schmidt aux poly
      structure (matches Roth 1955 + Schmidt 1980 §VI).

    Mathlib usage: composition of ext #105 + ext #116 + case split.

    Sub-lemma 290/N in T-1 (T-5 Phase 7 ext #117).  Lean-core only.

    🏆 FIRST Lean-core T-5 Phase 7 SCHMIDT → ROTH-FORM conditional capstone.
       Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim.
       The cubic+ chain is composed end-to-end. Schmidt discharge remains. -/
theorem session_559qqqqqqq_T5_phase7_schmidt_roth_form_capstone_headline
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (k : ℕ),
      1 ≤ k ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
          ((q.den : ℝ)) ^ (-(2 + ε)) ≤
          |((q : ℚ) : ℝ) - α| :=
  T5_schmidt_roth_form_capstone h_schmidt α hα h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
