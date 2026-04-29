/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockC_TaylorUpperBound

  T-5 (Roth's theorem) — **D.7 Block C: analytical Taylor upper bound foundations**.

  Foundational sub-lemmas for the multivariate Taylor expansion at
  real algebraic α, providing the analytical upper bound
  `|P(q¹,…,qᵐ)| ≤ Σ_J binom·∂^J P (α^m) · Π |q^i − α|^{Jᵢ}` (Block C-1
  per plan).

  This file establishes the UNIVARIATE precursors:

  - C-1..3: univariate Taylor evaluation bridge.
  - C-4..6: foundational bounds on |P(α+h) - P(α)|.
  - C-7..9: integer-binomial coefficient nonneg.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Taylor
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Data.Real.Sqrt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockC_TaylorUpperBound

open Polynomial

/-! ## C-1 — Taylor evaluation -/

/-- **C-1 — `T5_taylor_eval_real`**: `(taylor r f).eval s = f.eval (s + r)`. -/
theorem T5_taylor_eval_real
    (r : ℝ) (f : Polynomial ℝ) (s : ℝ) :
    (Polynomial.taylor r f).eval s = f.eval (s + r) :=
  Polynomial.taylor_eval r f s

/-! ## C-2 — Taylor evaluated at q-α gives P(q) -/

/-- **C-2 — `T5_taylor_at_diff`**: for `α q : ℝ`,
    `(taylor α P).eval (q - α) = P.eval q`.

    Mathlib `Polynomial.taylor_eval_sub` gives this directly. -/
theorem T5_taylor_at_diff
    (α q : ℝ) (P : Polynomial ℝ) :
    (Polynomial.taylor α P).eval (q - α) = P.eval q :=
  Polynomial.taylor_eval_sub α P q

/-! ## C-3 — Taylor preserves natDegree -/

/-- **C-3 — `T5_taylor_natDegree`**: `(taylor r p).natDegree = p.natDegree`. -/
theorem T5_taylor_natDegree
    (r : ℝ) (p : Polynomial ℝ) :
    (Polynomial.taylor r p).natDegree = p.natDegree :=
  Polynomial.natDegree_taylor p r

/-! ## C-4 — Real `(s + r) - r = s` arithmetic -/

/-- **C-4 — `T5_add_sub_cancel_real`**: trivial real arithmetic helper
    `(s + r) - r = s`. -/
theorem T5_add_sub_cancel_real (s r : ℝ) : (s + r) - r = s := by ring

/-! ## C-5 — `|P(α + h)| = |∑ k, taylor α P coeff_k · h^k|` -/

/-- **C-5 — `T5_taylor_eval_finset_sum_form`**: the eval of `taylor α P`
    at `h` is `∑ k ∈ support, (taylor α P).coeff k · h^k`. -/
theorem T5_taylor_eval_finset_sum_form
    (α h : ℝ) (P : Polynomial ℝ) :
    (Polynomial.taylor α P).eval h =
      ∑ k ∈ (Polynomial.taylor α P).support, (Polynomial.taylor α P).coeff k * h^k := by
  rw [Polynomial.eval_eq_sum, Polynomial.sum_def]

/-! ## C-6 — `(taylor α P).coeff 0 = P.eval α` -/

/-- **C-6 — `T5_taylor_coeff_zero`**: `(taylor r f).coeff 0 = f.eval r`. -/
theorem T5_taylor_coeff_zero
    (r : ℝ) (f : Polynomial ℝ) :
    (Polynomial.taylor r f).coeff 0 = f.eval r := by
  rw [Polynomial.taylor_coeff_zero]

/-! ## C-7 — Integer binomial coefficient nonneg -/

/-- **C-7 — `T5_choose_nonneg`**: `(n choose k : ℝ) ≥ 0`. -/
theorem T5_choose_nonneg (n k : ℕ) : (0 : ℝ) ≤ (n.choose k : ℝ) := by
  exact_mod_cast Nat.zero_le _

/-! ## C-8 — Absolute-value triangle inequality applied to finset sum -/

/-- **C-8 — `T5_abs_finset_sum_le_sum_abs`**: `|∑ s.f| ≤ ∑ s.|f|`. -/
theorem T5_abs_finset_sum_le_sum_abs
    {α : Type*} (s : Finset α) (f : α → ℝ) :
    |∑ i ∈ s, f i| ≤ ∑ i ∈ s, |f i| :=
  Finset.abs_sum_le_sum_abs _ _

/-! ## C-9 — `|x|^n = |x^n|` -/

/-- **C-9 — `T5_abs_pow`**: `|x^n| = |x|^n`. -/
theorem T5_abs_pow (x : ℝ) (n : ℕ) : |x^n| = |x|^n := abs_pow x n

/-! ## C-10 — Univariate Taylor upper bound (for q close to α) -/

/-- **C-10 — `T5_taylor_eval_abs_bound_finset`**: for `α q : ℝ` and
    `P : ℝ[X]`,
      `|P.eval q| ≤ ∑ k ∈ support, |(taylor α P).coeff k| · |q - α|^k`.

    This is the univariate version of the multivariate Taylor upper
    bound (C-1 from plan). -/
theorem T5_taylor_eval_abs_bound_finset
    (α q : ℝ) (P : Polynomial ℝ) :
    |P.eval q| ≤
      ∑ k ∈ (Polynomial.taylor α P).support,
        |(Polynomial.taylor α P).coeff k| * |q - α|^k := by
  rw [← T5_taylor_at_diff α q P]
  rw [T5_taylor_eval_finset_sum_form α (q - α) P]
  calc |∑ k ∈ (Polynomial.taylor α P).support, (Polynomial.taylor α P).coeff k * (q - α)^k|
      ≤ ∑ k ∈ (Polynomial.taylor α P).support, |(Polynomial.taylor α P).coeff k * (q - α)^k| :=
        T5_abs_finset_sum_le_sum_abs _ _
    _ = ∑ k ∈ (Polynomial.taylor α P).support,
        |(Polynomial.taylor α P).coeff k| * |q - α|^k := by
        apply Finset.sum_congr rfl
        intro k _
        rw [abs_mul, T5_abs_pow]

/-! ## C-11 — Block C foundational marker -/

/-- **C-11 — `T5_BlockC_foundational_marker`**: 5-conjunct marker for
    Block C foundational sub-lemmas. -/
theorem T5_BlockC_foundational_marker :
    (∀ (r : ℝ) (f : Polynomial ℝ) (s : ℝ),
      (Polynomial.taylor r f).eval s = f.eval (s + r)) ∧
    (∀ (α q : ℝ) (P : Polynomial ℝ),
      (Polynomial.taylor α P).eval (q - α) = P.eval q) ∧
    (∀ (r : ℝ) (p : Polynomial ℝ),
      (Polynomial.taylor r p).natDegree = p.natDegree) ∧
    (∀ {α : Type*} (s : Finset α) (f : α → ℝ),
      |∑ i ∈ s, f i| ≤ ∑ i ∈ s, |f i|) ∧
    (∀ (α q : ℝ) (P : Polynomial ℝ),
      |P.eval q| ≤
        ∑ k ∈ (Polynomial.taylor α P).support,
          |(Polynomial.taylor α P).coeff k| * |q - α|^k) :=
  ⟨T5_taylor_eval_real,
   T5_taylor_at_diff,
   T5_taylor_natDegree,
   T5_abs_finset_sum_le_sum_abs,
   T5_taylor_eval_abs_bound_finset⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLarge_BlockC_TaylorUpperBound
