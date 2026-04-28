/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAbsBound

  T-5 (Roth's theorem) — **Phase 7 ext #101: Taylor absolute-value
  triangle bound (cubic+ chain step 4 — abs bound)**, sub session
  559aaaaaa — STRICT critical-path #316 (T-5) Phase 7 ext #101.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Triangle-inequality bound on the Taylor sum:

  For p ∈ ℝ[X] with index ≥ k at α, q : ℝ:
    `|p.eval q| ≤ ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                     |(taylor α p).coeff i| * |q - α|^i`

  This is the **TRIANGLE-INEQUALITY ABS BOUND** for the Taylor sum,
  one step before the final cubic+ contradiction.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #101 — Taylor abs bound (cubic+ step 4 abs).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorHighIndex
import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAbsBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorHighIndex

/-! ## Triangle inequality bound on Taylor sum -/

/-- **🚨 Wave T5 session 559aaaaaa — Triangle bound on Taylor sum**.

    For p ∈ ℝ[X], α, q : ℝ, k : ℕ with `(taylor α p).coeff i = 0` for `i < k`:
      `|p.eval q| ≤ ∑ i ∈ Ico k (d+1), |(taylor α p).coeff i| · |q - α|^i`. -/
theorem T5_polynomial_taylor_abs_bound
    (p : Polynomial ℝ) (α q : ℝ) (k : ℕ)
    (h_index : ∀ i, i < k → (Polynomial.taylor α p).coeff i = 0) :
    |p.eval q| ≤ ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                     |(Polynomial.taylor α p).coeff i| * |q - α| ^ i := by
  rw [T5_polynomial_taylor_high_index_eval p α q k h_index]
  -- Triangle inequality on Finset.sum
  apply (Finset.abs_sum_le_sum_abs _ _).trans
  apply Finset.sum_le_sum
  intro i _
  rw [abs_mul, abs_pow]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaaaaa — T-5 Phase 7 ext #101:
    Taylor abs bound on high-index sum**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #101.

    🏆 ABS-BOUND step in cubic+ Roth chain.

    Single derivation:
    1. `T5_polynomial_taylor_abs_bound` — triangle inequality on
       Taylor sum, term-by-term.

    Strategy: ext #100 high-index sum → triangle inequality
    (Finset.abs_sum_le_sum_abs) → term-by-term abs_mul + abs_pow.

    Combined with `|q - α|^i ≤ |q - α|^k` (when |q-α| ≤ 1, for i ≥ k):
    `|p.eval q| ≤ |q - α|^k · ∑ |(taylor α p).coeff i|`
                = |q - α|^k · M.

    For Schmidt aux poly with high index k > d/(2+ε) and Roth-violating
    `|q - α| < q.den^(-(2+ε))`:
    |p.eval q| ≤ q.den^(-k(2+ε)) · M < 1/q.den^d for q.den large.

    Mathlib usage: `Finset.abs_sum_le_sum_abs`, `Finset.sum_le_sum`,
    `abs_mul`, `abs_pow`.

    Sub-lemma 274/N in T-1 (T-5 Phase 7 ext #101).  Lean-core only. -/
theorem session_559aaaaaa_T5_phase7_polynomial_taylor_abs_bound_headline
    (p : Polynomial ℝ) (α q : ℝ) (k : ℕ)
    (h_index : ∀ i, i < k → (Polynomial.taylor α p).coeff i = 0) :
    |p.eval q| ≤ ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                     |(Polynomial.taylor α p).coeff i| * |q - α| ^ i :=
  T5_polynomial_taylor_abs_bound p α q k h_index

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAbsBound
