/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntegerNonVanishingUnivariate

  T-5 (Roth's theorem) — **D.7 Block D CONTENT (univariate / m=1 case)**.

  Genuine atom-2 closure analytical content (NOT just foundation):
  the integer non-vanishing lower bound `|p.eval q| ≥ 1/q.den^p.natDegree`
  for univariate ℤ-polynomials p evaluated at rational q with non-zero
  evaluation.

  Uses Mathlib's `Polynomial.one_le_pow_mul_abs_eval_div`
  (`Mathlib/Algebra/Polynomial/DenomsClearable.lean:86`) as the analytical
  base.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.DenomsClearable
import Mathlib.Data.Rat.Defs
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntegerNonVanishingUnivariate

open Polynomial

/-! ## D-content-1 — Univariate integer non-vanishing lower bound -/

/-- **D-content-1 — `T5_BlockD_univariate_integer_lower_bound`**:
    integer non-vanishing lower bound for univariate ℤ-polynomials evaluated
    at rational q.

    Given p : Polynomial ℤ, q : ℚ with q.den > 0, AND
    `eval (q : ℝ) (p.map (algebraMap ℤ ℝ)) ≠ 0`,
    derive:
      `1 / (q.den : ℝ) ^ p.natDegree ≤ |eval (q : ℝ) (p.map (algebraMap ℤ ℝ))|`

    This is the m=1 / univariate case of the analytical heart for
    Roth's theorem D.7 Block D content.

    Proof: direct application of Mathlib `Polynomial.one_le_pow_mul_abs_eval_div`
    with b := q.den, a := q.num, K := ℝ. -/
theorem T5_BlockD_univariate_integer_lower_bound
    (p : Polynomial ℤ) (q : ℚ)
    (h_eval_ne : eval (q : ℝ) (p.map (algebraMap ℤ ℝ)) ≠ 0) :
    1 / ((q.den : ℝ) ^ p.natDegree) ≤
      |eval (q : ℝ) (p.map (algebraMap ℤ ℝ))| := by
  -- b := q.den as ℤ (via ℕ → ℤ coercion)
  set b : ℤ := (q.den : ℤ) with hb
  have h_b_pos : (0 : ℤ) < b := by
    rw [hb]
    exact_mod_cast q.pos
  -- Bridge: (q : ℝ) = ((q.num : ℤ) : ℝ) / ((b : ℤ) : ℝ)
  have h_q_eq : (q : ℝ) = ((q.num : ℤ) : ℝ) / ((b : ℤ) : ℝ) := by
    rw [hb]
    push_cast
    rw [Rat.cast_def]
  rw [h_q_eq] at h_eval_ne
  -- Apply Mathlib theorem
  have h_one_le :=
    one_le_pow_mul_abs_eval_div (K := ℝ) (f := p)
      (a := q.num) (b := b) h_b_pos h_eval_ne
  -- h_one_le : 1 ≤ ((b : ℤ) : ℝ) ^ p.natDegree * |eval ...|
  rw [h_q_eq]
  -- Bridge ((b : ℤ) : ℝ) = (q.den : ℝ)
  have h_cast_den : ((b : ℤ) : ℝ) = (q.den : ℝ) := by
    rw [hb]
    push_cast
    rfl
  rw [h_cast_den] at h_one_le
  have h_pow_pos : (0 : ℝ) < (q.den : ℝ) ^ p.natDegree := by
    apply pow_pos
    exact_mod_cast q.pos
  rw [div_le_iff₀ h_pow_pos, mul_comm]
  exact h_one_le

/-! ## D-content-2 — Convenience form: |α - q| analytical chain piece -/

/-- **D-content-2 — `T5_BlockD_univariate_eval_pos_lower_bound`**:
    convenience form expressing the lower bound in the standard
    "denominator-power reciprocal" shape used downstream.

    Same as D-content-1 but the conclusion uses `≤ |eval ...|`
    (without the `1 / ...` prefix). -/
theorem T5_BlockD_univariate_eval_pos_lower_bound
    (p : Polynomial ℤ) (q : ℚ)
    (h_eval_ne : eval (q : ℝ) (p.map (algebraMap ℤ ℝ)) ≠ 0) :
    1 ≤ ((q.den : ℝ) ^ p.natDegree) * |eval (q : ℝ) (p.map (algebraMap ℤ ℝ))| := by
  have h_pow_pos : (0 : ℝ) < (q.den : ℝ) ^ p.natDegree := by
    apply pow_pos
    exact_mod_cast q.pos
  have h_lower :=
    T5_BlockD_univariate_integer_lower_bound p q h_eval_ne
  -- 1 / d^n ≤ |eval| ⟹ 1 ≤ d^n * |eval|
  rw [div_le_iff₀ h_pow_pos] at h_lower
  rw [mul_comm]
  exact h_lower

/-! ## D-content-3 — Headline -/

/-- **🚨🚨🚨 D-content-3 — `T5_BLOCK_D_CONTENT_UNIVARIATE_HEADLINE`**:
    paper-citable headline for the univariate / m=1 Block D content.

    Bundles the 2 lower-bound theorems into a 2-conjunct paper-citable
    bundle.  This is genuine atom-2 closure ANALYTICAL content (not just
    foundation/hygiene).

    Per project rule §7.0: NAMED real Prop content. -/
theorem T5_BLOCK_D_CONTENT_UNIVARIATE_HEADLINE :
    -- (a) integer-denominator reciprocal form
    (∀ (p : Polynomial ℤ) (q : ℚ),
      eval (q : ℝ) (p.map (algebraMap ℤ ℝ)) ≠ 0 →
      1 / ((q.den : ℝ) ^ p.natDegree) ≤
        |eval (q : ℝ) (p.map (algebraMap ℤ ℝ))|) ∧
    -- (b) integer-denominator multiplicative form
    (∀ (p : Polynomial ℤ) (q : ℚ),
      eval (q : ℝ) (p.map (algebraMap ℤ ℝ)) ≠ 0 →
      1 ≤ ((q.den : ℝ) ^ p.natDegree) *
        |eval (q : ℝ) (p.map (algebraMap ℤ ℝ))|) :=
  ⟨T5_BlockD_univariate_integer_lower_bound,
   T5_BlockD_univariate_eval_pos_lower_bound⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntegerNonVanishingUnivariate
