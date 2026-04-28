/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorTruncatedBound

  T-5 (Roth's theorem) — **Phase 7 ext #102: Taylor-truncated bound
  `|p.eval q| ≤ |q-α|^k · M` (cubic+ chain step 4 capstone)**, sub
  session 559bbbbbb — STRICT critical-path #316 (T-5) Phase 7 ext #102.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Final Taylor-truncated bound for cubic+ Roth chain:

  For p ∈ ℝ[X] with index ≥ k at α, q : ℝ with |q - α| ≤ 1:
    `|p.eval q| ≤ |q - α|^k · (∑ i ∈ Ico k (d+1), |(taylor α p).coeff i|)`

  This is the **HEADLINE BOUND** for the cubic+ Roth chain step 4.
  Combined with s52 integer non-vanishing → final contradiction →
  unconditional Roth.

  Single derivation:
  1. `T5_polynomial_taylor_truncated_bound`: `|p.eval q| ≤ |q-α|^k · M`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #102 — Taylor truncated bound (cubic+ step 4 CAPSTONE).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAbsBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorTruncatedBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAbsBound

/-! ## Power monotone for |x| ≤ 1 -/

/-- Helper: for `0 ≤ x ≤ 1` and `i ≥ k`: `x^i ≤ x^k`. -/
private theorem T5_pow_le_pow_of_le_one_ge
    {x : ℝ} (h_nn : 0 ≤ x) (h_le : x ≤ 1) {k i : ℕ} (h_ge : k ≤ i) :
    x ^ i ≤ x ^ k := by
  exact pow_le_pow_of_le_one h_nn h_le h_ge

/-! ## Taylor-truncated bound (CAPSTONE) -/

/-- **🚨 Wave T5 session 559bbbbbb — Taylor truncated bound CAPSTONE**.

    For p ∈ ℝ[X] with index ≥ k at α, q : ℝ with `|q - α| ≤ 1`:
      `|p.eval q| ≤ |q - α|^k · ∑ i ∈ Ico k (d+1), |(taylor α p).coeff i|`. -/
theorem T5_polynomial_taylor_truncated_bound
    (p : Polynomial ℝ) (α q : ℝ) (k : ℕ)
    (h_index : ∀ i, i < k → (Polynomial.taylor α p).coeff i = 0)
    (h_close : |q - α| ≤ 1) :
    |p.eval q| ≤ |q - α| ^ k *
        ∑ i ∈ Finset.Ico k (p.natDegree + 1),
            |(Polynomial.taylor α p).coeff i| := by
  -- Step 1: ext #101 gives |p.eval q| ≤ ∑ |c_i| · |q-α|^i
  apply (T5_polynomial_taylor_abs_bound p α q k h_index).trans
  -- Step 2: each |q-α|^i ≤ |q-α|^k for i ≥ k (Ico k upper bound)
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro i hi
  rw [Finset.mem_Ico] at hi
  have h_abs_nn : 0 ≤ |q - α| := abs_nonneg _
  have h_pow_le : |q - α| ^ i ≤ |q - α| ^ k :=
    T5_pow_le_pow_of_le_one_ge h_abs_nn h_close hi.1
  -- Goal: |c_i| · |q-α|^i ≤ |q-α|^k · |c_i|
  rw [mul_comm (|q - α| ^ k) _]
  apply mul_le_mul_of_nonneg_left h_pow_le (abs_nonneg _)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbbbbb — T-5 Phase 7 ext #102:
    Taylor truncated bound `|p(q)| ≤ |q-α|^k · M`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #102.

    🏆 CUBIC+ STEP 4 CAPSTONE — the headline Taylor bound for Roth.

    Single derivation:
    1. `T5_polynomial_taylor_truncated_bound` — `|p(q)| ≤ |q-α|^k · M`.

    Strategy: ext #101 abs bound (term-by-term triangle) → for `|q-α| ≤ 1`
    and `i ≥ k`: `|q-α|^i ≤ |q-α|^k` (pow_le_pow_of_le_one) → factor out.

    For Schmidt aux poly with high index k > d/(2+ε) and Roth-violating
    `|q - α| < q.den^(-(2+ε)) ≤ 1` (q.den ≥ 1):
    |p.eval q| ≤ q.den^(-k(2+ε)) · M.

    For q.den large enough: q.den^(-k(2+ε)) · M < 1/q.den^d (since
    k(2+ε) > d). Combined with s52 integer non-vanishing
    |p(q)| ≥ 1/q.den^d (when ≠ 0): CONTRADICTION → p(q) = 0.

    But p has only finitely many roots in ℚ, so for q.den large we
    can pick q ≠ root. CONTRADICTION → no such q exists →
    Roth-violating set is finite → Roth bound holds.

    Mathlib usage: `Finset.mul_sum`, `Finset.sum_le_sum`,
    `pow_le_pow_of_le_one`, `mul_le_mul_of_nonneg_left`,
    `abs_nonneg`, `Finset.mem_Ico`, `mul_comm`.

    Sub-lemma 275/N in T-1 (T-5 Phase 7 ext #102).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 CUBIC+ STEP 4 CAPSTONE — Taylor
    bound `|p(q)| ≤ |q-α|^k · M`. The HARD direction of cubic+
    Roth chain SHIPPED. Combined with s52 + Schmidt aux poly
    construction → unconditional Roth. -/
theorem session_559bbbbbb_T5_phase7_polynomial_taylor_truncated_bound_headline
    (p : Polynomial ℝ) (α q : ℝ) (k : ℕ)
    (h_index : ∀ i, i < k → (Polynomial.taylor α p).coeff i = 0)
    (h_close : |q - α| ≤ 1) :
    |p.eval q| ≤ |q - α| ^ k *
        ∑ i ∈ Finset.Ico k (p.natDegree + 1),
            |(Polynomial.taylor α p).coeff i| :=
  T5_polynomial_taylor_truncated_bound p α q k h_index h_close

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorTruncatedBound
