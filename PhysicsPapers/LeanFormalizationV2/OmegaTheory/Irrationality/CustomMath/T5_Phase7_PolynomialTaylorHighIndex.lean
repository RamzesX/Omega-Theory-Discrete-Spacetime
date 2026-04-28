/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorHighIndex

  T-5 (Roth's theorem) — **Phase 7 ext #100: Taylor-truncated sum for
  high-index roots (cubic+ chain step 4 — index argument core)**, sub
  session 559zzzzz — STRICT critical-path #316 (T-5) Phase 7 ext #100.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Index argument core: when α is a root of p with index ≥ k (i.e.,
  `(taylor α p).coeff i = 0` for all `i < k`), the Taylor sum form
  truncates to start from i = k:

  `p.eval q = ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                (taylor α p).coeff i * (q - α)^i`

  This is the **CORE OF THE INDEX ARGUMENT** for cubic+ Roth: combined
  with `|q - α| ≤ 1 → |q - α|^i ≤ |q - α|^k` for i ≥ k, gives
  `|p.eval q| ≤ |q - α|^k · M` where M = sum of tail-coeff abs values.

  Single derivation:
  1. `T5_polynomial_taylor_high_index_eval`: high-index sum form.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #100 — Taylor high-index sum (cubic+ index argument core).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorSumForm

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorHighIndex

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorSumForm

/-! ## Taylor sum truncated by high-index hypothesis -/

/-- **🚨 Wave T5 session 559zzzzz — High-index Taylor sum**.

    For p ∈ R[X] (R CommRing), α, q : R, k : ℕ with `(taylor α p).coeff i = 0`
    for all `i < k`:
      p.eval q = ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                    (taylor α p).coeff i * (q - α)^i. -/
theorem T5_polynomial_taylor_high_index_eval
    {R : Type*} [CommRing R] (p : Polynomial R) (α q : R) (k : ℕ)
    (h_index : ∀ i, i < k → (Polynomial.taylor α p).coeff i = 0) :
    p.eval q = ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                  (Polynomial.taylor α p).coeff i * (q - α) ^ i := by
  rw [T5_polynomial_taylor_eval_sum_form_natDegree p α q]
  -- Split range(d+1) = Ico 0 k ∪ Ico k (d+1) and show the first half is 0
  by_cases h_le : k ≤ p.natDegree + 1
  · -- Ico-decomposition holds when k ≤ d+1
    rw [show (Finset.range (p.natDegree + 1) : Finset ℕ) =
            Finset.Ico 0 k ∪ Finset.Ico k (p.natDegree + 1) by
      rw [show (Finset.range (p.natDegree + 1) : Finset ℕ) =
              Finset.Ico 0 (p.natDegree + 1) by rw [Finset.range_eq_Ico]]
      rw [← Finset.Ico_union_Ico_eq_Ico (Nat.zero_le k) h_le]]
    rw [Finset.sum_union (Finset.Ico_disjoint_Ico_consecutive 0 k (p.natDegree + 1))]
    -- Show first sum = 0
    have h_first : (∑ i ∈ Finset.Ico 0 k,
                     (Polynomial.taylor α p).coeff i * (q - α) ^ i) = 0 := by
      apply Finset.sum_eq_zero
      intro i hi
      rw [Finset.mem_Ico] at hi
      rw [h_index i hi.2]
      ring
    rw [h_first, zero_add]
  · -- k > p.natDegree + 1: Ico k (d+1) is empty, sum = 0
    push_neg at h_le
    have h_empty : Finset.Ico k (p.natDegree + 1) = ∅ := by
      apply Finset.Ico_eq_empty
      omega
    rw [h_empty, Finset.sum_empty]
    -- LHS: ∑ range(d+1) of coeff * (q-α)^i. All coeffs are 0 since i < k.
    apply Finset.sum_eq_zero
    intro i hi
    rw [Finset.mem_range] at hi
    have h_lt_k : i < k := by omega
    rw [h_index i h_lt_k]
    ring

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zzzzz — T-5 Phase 7 ext #100:
    Taylor-truncated sum for high-index roots**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #100.

    🏆 INDEX ARGUMENT CORE for cubic+ Roth chain.

    Single derivation:
    1. `T5_polynomial_taylor_high_index_eval` — high-index Taylor sum
       starting from i = k.

    Strategy: range(d+1) = Ico 0 k ∪ Ico k (d+1); apply h_index to
    show first half sums to 0; second half is the high-index sum.
    Edge case k > d+1: Ico k (d+1) = ∅, all coeffs 0 → sum = 0.

    Combined with `|q - α| ≤ 1` triangle inequality:
    |p.eval q| ≤ |q - α|^k · ∑_{i ≥ k} |(taylor α p).coeff i|
              ≤ |q - α|^k · M (finite sum).

    For Schmidt aux poly with high index k > d/(2+ε) and Roth-violating
    `|q - α| < q.den^(-(2+ε))`:
    |p.eval q| ≤ q.den^(-k(2+ε)) · M < 1/q.den^d (for q.den large).

    Combined with cubic+ step 5 (s52 integer non-vanishing
    |p.eval q| ≥ 1/q.den^d when ≠ 0): contradiction → p.eval q = 0.

    Mathlib usage: `Finset.range_eq_Ico`, `Finset.Ico_union_Ico_eq_Ico`,
    `Finset.sum_union`, `Finset.Ico_disjoint_Ico_consecutive`,
    `Finset.sum_eq_zero`, `Finset.Ico_eq_empty`.

    Sub-lemma 273/N in T-1 (T-5 Phase 7 ext #100).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 INDEX ARGUMENT CORE — the Taylor
    truncation that drives Roth's improvement over Liouville. -/
theorem session_559zzzzz_T5_phase7_polynomial_taylor_high_index_headline
    {R : Type*} [CommRing R] (p : Polynomial R) (α q : R) (k : ℕ)
    (h_index : ∀ i, i < k → (Polynomial.taylor α p).coeff i = 0) :
    p.eval q = ∑ i ∈ Finset.Ico k (p.natDegree + 1),
                  (Polynomial.taylor α p).coeff i * (q - α) ^ i :=
  T5_polynomial_taylor_high_index_eval p α q k h_index

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorHighIndex
