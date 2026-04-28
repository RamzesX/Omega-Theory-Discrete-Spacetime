/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtKthRootCapstone

  T-5 (Roth's theorem) — **Phase 7 ext #112: Schmidt → kth-root form
  conditional capstone (cubic+ chain composite real-power)**, sub
  session 559lllllll — STRICT critical-path #316 (T-5) Phase 7 ext #112.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #105 (Schmidt conditional capstone) with ext #110
  (kth-root form distance lower bound) into a SINGLE real-power
  conditional capstone:

  Under `SchmidtAuxPolyExists`, for irrational algebraic α and ε > 0,
  ∃ aux poly p with deg d, index k ≥ 1, k(2+ε) > d, ∀ q close to α
  with eval₂ q p ≠ 0:
    `(1/(M · q.den^d))^(1/k) ≤ |q-α|`

  This is the REAL-POWER FORM of the conditional capstone, ready for
  the Roth-form upgrade `q.den^(-d/k) ≥ q.den^(-(2+ε))` step.

  Single derivation:
  1. `T5_schmidt_kth_root_capstone`: composes s105 + s110.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #112 — Schmidt + kth-root form composite capstone.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtKthRootCapstone

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothKthRootForm

/-! ## Schmidt + kth-root capstone -/

/-- **🚨 Wave T5 session 559lllllll — Schmidt + kth-root conditional capstone**.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0,
    ∃ aux p, k ≥ 1 with k(2+ε) > d, ∀ q close to α with eval₂ ≠ 0:
      `(1/(M · q.den^d))^(1/k) ≤ |q-α|`. -/
theorem T5_schmidt_kth_root_capstone
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
        ((1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
          ((q.den : ℝ)) ^ p.natDegree)) ^ (1 / (k : ℝ)) ≤
          |((q : ℚ) : ℝ) - α| := by
  -- Apply h_schmidt to extract aux poly + index + M_pos
  obtain ⟨p, k, hp_ne, hp_root, hk_bound, h_index, h_M_pos⟩ :=
    h_schmidt α hα h_alg ε hε
  -- Need k ≥ 1: from hk_bound `(k : ℝ) * (2+ε) > p.natDegree` and p ≠ 0,
  -- it follows that p.natDegree ≥ 1 (since p has α as a root and α irrational
  -- means p.natDegree ≥ 2; even just p ≠ 0 + α algebraic root gives natDegree ≥ 1).
  -- For now: if k = 0, then 0 > p.natDegree means p.natDegree < 0 in ℝ, but
  -- (p.natDegree : ℝ) ≥ 0 always, contradiction with hk_bound when k = 0
  -- if p.natDegree ≥ 1.
  --
  -- Actually: if k = 0, hk_bound becomes 0 > p.natDegree (since 0 * _ = 0),
  -- but p.natDegree ≥ 0 always. So hk_bound would fail if p.natDegree = 0.
  -- BUT the Schmidt aux poly construction always gives k ≥ 1 (you need
  -- at least one Taylor coefficient to vanish, namely the constant term
  -- since p(α) = 0).
  --
  -- We deduce k ≥ 1 from hk_bound: if k = 0, then (0 : ℝ) > p.natDegree,
  -- but p.natDegree ≥ 0 always (Nat). So p.natDegree = 0, but then from
  -- hp_ne and hp_root α irrational... actually constant nonzero polynomials
  -- can't have any root, so p.natDegree ≥ 1.
  --
  -- Cleanest: the index condition `∀ i < k, taylor_i = 0` for k = 0 is vacuous,
  -- but the Schmidt construction guarantees the coefficient sum is positive
  -- (h_M_pos holds for the sum from k to d), implying nonempty range, hence
  -- d ≥ k. Combined with hp_root + α algebraic irrational, p.natDegree ≥ 1
  -- and k ≥ 1.
  --
  -- For this conditional capstone, we IMPOSE k ≥ 1 via the case split:
  -- if k = 0, the inequality 1/(M · q.den^d) ≤ |q-α|^0 = 1 still holds but
  -- doesn't give Roth-form. The Schmidt construction always picks k ≥ 1.
  --
  -- TECHNICAL: we need to prove k ≥ 1. Use hk_bound + hp_ne + α algebraic.
  by_cases hk : 1 ≤ k
  · refine ⟨p, k, hk, hp_ne, hp_root, hk_bound, h_index, ?_⟩
    intros q h_close h_nonzero
    -- Apply s110 kth-root form
    exact T5_cubic_roth_kth_root_form α p k hk h_index q h_close h_nonzero h_M_pos
  · -- k = 0 case: hk_bound `(0 : ℝ) * (2+ε) > p.natDegree` becomes `0 > p.natDegree`,
    -- but p.natDegree : ℕ implies (p.natDegree : ℝ) ≥ 0, contradiction
    push_neg at hk
    interval_cases k
    -- k = 0: hk_bound is now `(0 : ℝ) * (2+ε) > (p.natDegree : ℝ)`
    have h_nn : (0 : ℝ) ≤ (p.natDegree : ℝ) := by exact_mod_cast Nat.zero_le _
    simp only [Nat.cast_zero, zero_mul] at hk_bound
    linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559lllllll — T-5 Phase 7 ext #112:
    Schmidt + kth-root conditional capstone**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #112.

    🏆 REAL-POWER CONDITIONAL CAPSTONE — composes ext #105 + ext #110.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0,
    ∃ aux p with deg d, k ≥ 1:
      - k(2+ε) > d              (Roth budget)
      - ∀ q close to α with eval₂ ≠ 0:
          `(1/(M · q.den^d))^(1/k) ≤ |q-α|`

    Strategy: extract Schmidt witness; case split on k ≥ 1 (k = 0 contradicts
    `k(2+ε) > p.natDegree` since p ≠ 0 + p annihilates α + α irrational
    forces `p.natDegree ≥ 2 > 0`). For k ≥ 1, apply s110 directly.

    Mathlib usage: composition of ext #105 + ext #110 + case split on k = 0.

    Sub-lemma 285/N in T-1 (T-5 Phase 7 ext #112).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 SCHMIDT REAL-POWER conditional capstone.
    Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559lllllll_T5_phase7_schmidt_kth_root_capstone_headline
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
        ((1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
          ((q.den : ℝ)) ^ p.natDegree)) ^ (1 / (k : ℝ)) ≤
          |((q : ℚ) : ℝ) - α| :=
  T5_schmidt_kth_root_capstone h_schmidt α hα h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtKthRootCapstone
