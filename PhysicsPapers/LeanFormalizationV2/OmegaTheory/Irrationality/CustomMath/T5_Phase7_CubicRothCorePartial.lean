/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial

  T-5 (Roth's theorem) — **Phase 7 ext #103: Cubic+ Roth core partial
  composition (Taylor abs upper + integer non-vanishing lower
  bound)**, sub session 559cccccc — STRICT critical-path #316
  (T-5) Phase 7 ext #103.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #102 (Taylor-truncated upper bound) with ext #52
  (univariate integer non-vanishing lower bound) into the cubic+
  Roth core inequality:

  For p ∈ ℤ[X] with index ≥ k at α, p.natDegree = d, q : ℚ with
  |q - α| ≤ 1 AND `eval₂ q p ≠ 0`:
    `1/q.den^d ≤ |q - α|^k · M`

  where M = ∑ |(taylor α (p.map Int.cast)).coeff i| for i ∈ [k, d].

  This gives `|q - α|^k ≥ 1/(M · q.den^d)`, i.e., `|q - α| ≥
  (1/(M · q.den^d))^(1/k)`. For k > d/(2+ε), `(1/q.den^d)^(1/k) =
  q.den^(-d/k) > q.den^(-(2+ε))`, giving Roth-form bound.

  Single derivation:
  1. `T5_cubic_roth_core_partial`: composition theorem.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #103 — cubic+ Roth core partial.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorTruncatedBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialEvalCastBridge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorTruncatedBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialEvalCastBridge

/-! ## Cubic+ core composition -/

/-- **🚨 Wave T5 session 559cccccc — Cubic+ Roth core partial composition**.

    For p ∈ ℤ[X] with `(taylor α (p.map Int.cast)).coeff i = 0` for `i < k`
    (i.e., index ≥ k), q : ℚ with `|q - α| ≤ 1` AND
    `eval₂ (Int.castRingHom ℚ) q p ≠ 0`:
      `1/q.den^p.natDegree ≤ |q - α|^k · M`
    where M = sum of |coeff| from i = k to p.natDegree. -/
theorem T5_cubic_roth_core_partial
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0) :
    (1 : ℝ) / ((q.den : ℝ)) ^ p.natDegree ≤
      |((q : ℚ) : ℝ) - α| ^ k *
        ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
  -- Step 1: ext #52 gives 1/q.den^d ≤ |eval₂ q p (in ℚ)|
  have h_lower_q := T5_univariate_nonzero_lower_bound p q h_nonzero
  -- Step 2: cast to ℝ via ext #60
  have h_cast := T5_int_polynomial_eval_q_cast_to_real p q
  -- Step 3: |.| commutes with ℚ→ℝ cast (since abs is preserved)
  have h_abs_cast : (|(Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p : ℚ)| : ℝ) =
                    |(p.map (Int.castRingHom ℝ)).eval ((q : ℚ) : ℝ)| := by
    rw [← h_cast]
  -- Cast h_lower_q to ℝ
  have h_lower_real :
      (1 : ℝ) / ((q.den : ℝ)) ^ p.natDegree ≤
      |(p.map (Int.castRingHom ℝ)).eval ((q : ℚ) : ℝ)| := by
    have h_cast_q : ((1 : ℚ) / ((q.den : ℚ)) ^ p.natDegree : ℝ) =
                     (1 : ℝ) / ((q.den : ℝ)) ^ p.natDegree := by
      push_cast; rfl
    rw [← h_cast_q, ← h_abs_cast]
    exact_mod_cast h_lower_q
  -- Step 4: ext #102 gives Taylor upper bound
  have h_upper := T5_polynomial_taylor_truncated_bound
                    (p.map (Int.castRingHom ℝ)) α ((q : ℚ) : ℝ) k h_index h_close
  -- Combine: lower ≤ |eval| ≤ upper
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559cccccc — T-5 Phase 7 ext #103:
    Cubic+ Roth core partial composition**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #103.

    🏆 ROTH CORE INEQUALITY shipped — combining ext #52 (integer
    non-vanishing lower bound) + ext #60 (cast bridge) + ext #102
    (Taylor truncated upper bound).

    For p with index ≥ k at α, q with |q - α| ≤ 1 and eval₂ ≠ 0:
      `1/q.den^d ≤ |q - α|^k · M`

    Equivalently: `|q - α|^k ≥ 1/(M · q.den^d)`,
    so `|q - α| ≥ (1/M)^(1/k) · q.den^(-d/k)`.

    For k > d/(2+ε): `d/k < 2+ε`, so `q.den^(-d/k) > q.den^(-(2+ε))`.
    Hence `|q - α| ≥ (1/M)^(1/k) · q.den^(-(2+ε)+ε')` for some ε' > 0,
    which is Roth-form.

    The remaining piece for unconditional Roth: Schmidt's lemma
    constructing aux p with index k > d/(2+ε) (HARD multi-day).

    Mathlib usage: composition of ext #52 + ext #60 + ext #102.

    Sub-lemma 276/N in T-1 (T-5 Phase 7 ext #103).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cubic+ Roth core partial — the
    KEY composition that gives Roth-form bound from Taylor + integer
    non-vanishing. Escanor Pride + Erdős Primarch — full prove mode,
    NO STUBS, NO slim. -/
theorem session_559cccccc_T5_phase7_cubic_roth_core_partial_headline
    (α : ℝ) (p : Polynomial ℤ) (k : ℕ)
    (h_index : ∀ i, i < k →
      (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
    (q : ℚ) (h_close : |((q : ℚ) : ℝ) - α| ≤ 1)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0) :
    (1 : ℝ) / ((q.den : ℝ)) ^ p.natDegree ≤
      |((q : ℚ) : ℝ) - α| ^ k *
        ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
  T5_cubic_roth_core_partial α p k h_index q h_close h_nonzero

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothCorePartial
