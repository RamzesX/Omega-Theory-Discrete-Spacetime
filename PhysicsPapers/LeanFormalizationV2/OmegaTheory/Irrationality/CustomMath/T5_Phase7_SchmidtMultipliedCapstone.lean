/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtMultipliedCapstone

  T-5 (Roth's theorem) — **Phase 7 ext #108: Schmidt + multiplied
  conditional capstone (cubic+ chain composite)**, sub session
  559hhhhhhh — STRICT critical-path #316 (T-5) Phase 7 ext #108.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #105 (Schmidt aux poly conditional capstone) with
  ext #106 (multiplied bound) into a SINGLE product-form conditional
  capstone:

  Under `SchmidtAuxPolyExists`, for irrational algebraic α and ε > 0,
  ∃ aux poly p with deg d and index k > d/(2+ε), such that ∀ q close
  to α with eval₂ q p ≠ 0:
    `|q-α|^k · M · q.den^d ≥ 1`

  Plus the Roth-budget bookkeeping:
    `k · (2+ε) > d`

  This is the PRODUCT-FORM capstone — building block for kth-root /
  real-power step.

  Single derivation:
  1. `T5_schmidt_multiplied_capstone`: composes s105 + s106.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #108 — Schmidt + multiplied conditional composite.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothMultipliedBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtMultipliedCapstone

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothMultipliedBound

/-! ## Schmidt + multiplied conditional capstone -/

/-- **🚨 Wave T5 session 559hhhhhhh — Schmidt + multiplied conditional capstone**.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α and ε > 0,
    ∃ aux poly p with deg d and index k > d/(2+ε), s.t. ∀ q close to α
    with eval₂ q p ≠ 0:
      `1 ≤ |q-α|^k · M · q.den^d`
    AND `k · (2+ε) > d`. -/
theorem T5_schmidt_multiplied_capstone
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
        (1 : ℝ) ≤
          |((q : ℚ) : ℝ) - α| ^ k *
            (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree := by
  -- Apply h_schmidt to extract aux poly + index + M_pos
  obtain ⟨p, k, hp_ne, hp_root, hk_bound, h_index, h_M_pos⟩ :=
    h_schmidt α hα h_alg ε hε
  refine ⟨p, k, hp_ne, hp_root, hk_bound, h_index, ?_⟩
  intros q h_close h_nonzero
  -- Apply s106 multiplied bound
  exact T5_cubic_roth_multiplied_bound α p k h_index q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hhhhhhh — T-5 Phase 7 ext #108:
    Schmidt + multiplied conditional capstone**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #108.

    🏆 PRODUCT-FORM CONDITIONAL CAPSTONE — composes ext #105 + ext #106.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0,
    ∃ aux poly p (with deg d) and index k:
      - p ≠ 0
      - α annihilates p
      - k(2+ε) > d              (Roth budget condition)
      - Index ≥ k at α          (Taylor coefficients vanish for i < k)
      - ∀ q close to α with `eval₂ q p ≠ 0`:
          `|q-α|^k · M · q.den^d ≥ 1`

    Strategy: extract Schmidt witness from h_schmidt, apply s106 inline.

    The remaining gap to unconditional Roth-form bound `|q-α| ≥ C · q.den^(-(2+ε))`:
    1. ext #109: kth-root flip via `Real.rpow` (extract `|q-α| ≥ M^(-1/k) · q.den^(-d/k)`).
    2. ext #110: combine `d/k < 2+ε` + `q.den ≥ 1` → `q.den^(-d/k) ≥ q.den^(-(2+ε))`.
    3. ext #111: wrap as RothBoundLarge.
    4. ext #112+: discharge SchmidtAuxPolyExists (multi-day Schmidt-Wirsing-Roth).

    Mathlib usage: composition of ext #105 + ext #106.

    Sub-lemma 281/N in T-1 (T-5 Phase 7 ext #108).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 product-form conditional capstone — the
    KEY composite preparing real-power step. Escanor Pride + Erdős Primarch. -/
theorem session_559hhhhhhh_T5_phase7_schmidt_multiplied_capstone_headline
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
        (1 : ℝ) ≤
          |((q : ℚ) : ℝ) - α| ^ k *
            (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree :=
  T5_schmidt_multiplied_capstone h_schmidt α hα h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtMultipliedCapstone
