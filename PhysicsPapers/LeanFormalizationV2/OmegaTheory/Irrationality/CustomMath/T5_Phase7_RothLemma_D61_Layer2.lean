/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer2

  T-5 (Roth's theorem) — **D.6.1 Layer 2: index calculus foundations**.

  Index-calculus sub-lemmas for the Hindry-Silverman D.6.1
  inequality:

  - L2-1..3: derivative-vanishing lemmas (Mathlib
    `rootMultiplicity_sub_one_le_derivative_rootMultiplicity_of_ne_zero`).
  - L2-4..6: Taylor-shift evaluation bridge.
  - L2-7..9: index of products with `(X − α)^t`.
  - L2-10..12: foundational univariate index lemmas.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Polynomial.Taylor
import Mathlib.Algebra.Polynomial.RingDivision
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Algebra.Polynomial.FieldDivision
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer2

open Real
open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer1

/-! ## L2-1 — Index of derivative is at least (multiplicity − 1) -/

/-- **L2-1 — `T5_univarIndex_derivative_ge_pred`**: for `P.derivative ≠ 0`,
    if `α` is a root of `P` with multiplicity `k`, then it's a root
    of `P.derivative` with multiplicity at least `k − 1`.

    Mathlib v4.29.0 lemma:
    `Polynomial.rootMultiplicity_sub_one_le_derivative_rootMultiplicity_of_ne_zero`. -/
theorem T5_univarIndex_derivative_ge_pred
    (P : Polynomial ℝ) (hd : P.derivative ≠ 0) (α : ℝ) :
    P.rootMultiplicity α - 1 ≤ P.derivative.rootMultiplicity α :=
  Polynomial.rootMultiplicity_sub_one_le_derivative_rootMultiplicity_of_ne_zero
    P α hd

/-! ## L2-2 — Univariate index drops by at most 1 under derivative -/

/-- **L2-2 — `T5_univarIndex_derivative_drop_le_one`**: for
    `P.derivative ≠ 0`, the ℝ-cast index of the derivative is at least
    (index of P) − 1. -/
theorem T5_univarIndex_derivative_drop_le_one
    (P : Polynomial ℝ) (hd : P.derivative ≠ 0) (α : ℝ) :
    T5_univarIndex P α - 1 ≤ T5_univarIndex P.derivative α := by
  unfold T5_univarIndex
  have h := T5_univarIndex_derivative_ge_pred P hd α
  by_cases hk : P.rootMultiplicity α = 0
  · rw [hk]
    push_cast
    have : (0 : ℝ) ≤ (P.derivative.rootMultiplicity α : ℝ) := Nat.cast_nonneg _
    linarith
  · have hk_ge_one : 1 ≤ P.rootMultiplicity α := Nat.one_le_iff_ne_zero.mpr hk
    have hcast : ((P.rootMultiplicity α - 1 : ℕ) : ℝ) =
                 (P.rootMultiplicity α : ℝ) - 1 := by
      push_cast [Nat.cast_sub hk_ge_one]
      ring
    have h_real : ((P.rootMultiplicity α - 1 : ℕ) : ℝ) ≤
                  (P.derivative.rootMultiplicity α : ℝ) := by exact_mod_cast h
    rw [hcast] at h_real
    exact h_real

/-! ## L2-3 — Iterated derivative vanishes for n < multiplicity -/

/-- **L2-3 — `T5_iterate_derivative_isRoot`**: for `n < rootMultiplicity α P`,
    the n-th derivative of `P` is also a root at `α`.

    Mathlib v4.29.0:
    `Polynomial.isRoot_iterate_derivative_of_lt_rootMultiplicity`. -/
theorem T5_iterate_derivative_isRoot
    (P : Polynomial ℝ) (α : ℝ) (n : ℕ) (hn : n < P.rootMultiplicity α) :
    (Polynomial.derivative^[n] P).IsRoot α :=
  Polynomial.isRoot_iterate_derivative_of_lt_rootMultiplicity hn

/-! ## L2-4 — Taylor evaluation -/

/-- **L2-4 — `T5_taylor_eval`**: `(taylor r f).eval s = f.eval (s + r)`.

    Mathlib v4.29.0: `Polynomial.taylor_eval`. -/
theorem T5_taylor_eval (r : ℝ) (f : Polynomial ℝ) (s : ℝ) :
    (Polynomial.taylor r f).eval s = f.eval (s + r) :=
  Polynomial.taylor_eval r f s

/-! ## L2-5 — Index of `(X - α)^t` at `q ≠ α` -/

/-- **L2-5 — `T5_univarIndex_X_sub_C_pow_at_off`**: if `q ≠ α`, then
    `T5_univarIndex ((X − α)^t) q = 0`.

    Off-target evaluation: `(X − α)^t` evaluated at q ≠ α has no root,
    so multiplicity is 0. -/
theorem T5_univarIndex_X_sub_C_pow_at_off
    (α q : ℝ) (hne : q ≠ α) (t : ℕ) :
    T5_univarIndex ((Polynomial.X - Polynomial.C α)^t) q = 0 := by
  unfold T5_univarIndex
  rcases t with _|t
  · -- t = 0: (X - α)^0 = 1
    simp
  · -- t ≥ 1: (X - α)^(t+1) at q ≠ α evaluates non-zero
    have h_eval : ((Polynomial.X - Polynomial.C α)^(t+1)).eval q = (q - α)^(t+1) := by
      simp
    have h_ne : ((Polynomial.X - Polynomial.C α)^(t+1)).eval q ≠ 0 := by
      rw [h_eval]
      exact pow_ne_zero _ (sub_ne_zero.mpr hne)
    have : ((Polynomial.X - Polynomial.C α)^(t+1)).rootMultiplicity q = 0 := by
      apply Polynomial.rootMultiplicity_eq_zero
      rw [Polynomial.IsRoot.def]
      exact h_ne
    rw [this]
    norm_cast

/-! ## L2-6 — Trivial constant 1 has index 0 -/

/-- **L2-6 — `T5_univarIndex_one`**: the constant polynomial 1 has index 0. -/
theorem T5_univarIndex_one (α : ℝ) :
    T5_univarIndex (1 : Polynomial ℝ) α = 0 := by
  unfold T5_univarIndex
  have h : ((1 : Polynomial ℝ)).rootMultiplicity α = 0 := by
    apply Polynomial.rootMultiplicity_eq_zero
    rw [Polynomial.IsRoot.def, Polynomial.eval_one]
    exact one_ne_zero
  rw [h]
  norm_cast

/-! ## L2-7 — Univariate index congruence -/

/-- **L2-7 — `T5_univarIndex_congr`**: P = Q ⇒ index P α = index Q α. -/
theorem T5_univarIndex_congr
    (P Q : Polynomial ℝ) (h : P = Q) (α : ℝ) :
    T5_univarIndex P α = T5_univarIndex Q α := by
  rw [h]

/-! ## L2-8 — Index of `(X - α) * P` at α -/

/-- **L2-8 — `T5_univarIndex_X_sub_C_mul`**: for `P ≠ 0`,
    `T5_univarIndex ((X − α) * P) α = T5_univarIndex P α + 1`. -/
theorem T5_univarIndex_X_sub_C_mul
    (α : ℝ) (P : Polynomial ℝ) (hP : P ≠ 0) :
    T5_univarIndex ((Polynomial.X - Polynomial.C α) * P) α =
      T5_univarIndex P α + 1 := by
  unfold T5_univarIndex
  have hX : (Polynomial.X - Polynomial.C α) ≠ 0 := Polynomial.X_sub_C_ne_zero α
  have hPQ : (Polynomial.X - Polynomial.C α) * P ≠ 0 := mul_ne_zero hX hP
  rw [Polynomial.rootMultiplicity_mul hPQ]
  have h1 : (Polynomial.X - Polynomial.C α).rootMultiplicity α = 1 := by
    have := Polynomial.rootMultiplicity_X_sub_C_pow (R := ℝ) (a := α) 1
    simpa using this
  rw [h1]
  push_cast
  ring

/-! ## L2-9 — Off-target factor invariance -/

/-- **L2-9 — `T5_univarIndex_X_sub_C_pow_mul_off`**: if `α ≠ q`, then
    `T5_univarIndex ((X − α)^t * P) q = T5_univarIndex P q`. -/
theorem T5_univarIndex_X_sub_C_pow_mul_off
    (α q : ℝ) (hne : α ≠ q) (t : ℕ) (P : Polynomial ℝ) (hP : P ≠ 0) :
    T5_univarIndex ((Polynomial.X - Polynomial.C α)^t * P) q =
      T5_univarIndex P q := by
  unfold T5_univarIndex
  have hX : ((Polynomial.X - Polynomial.C α)^t : Polynomial ℝ) ≠ 0 :=
    pow_ne_zero _ (Polynomial.X_sub_C_ne_zero α)
  have hPQ : ((Polynomial.X - Polynomial.C α)^t * P : Polynomial ℝ) ≠ 0 :=
    mul_ne_zero hX hP
  rw [Polynomial.rootMultiplicity_mul hPQ]
  have h_off : ((Polynomial.X - Polynomial.C α)^t).rootMultiplicity q = 0 := by
    rcases t with _|t
    · simp
    · have h_eval :
          ((Polynomial.X - Polynomial.C α)^(t+1)).eval q = (q - α)^(t+1) := by simp
      have h_ne :
          ((Polynomial.X - Polynomial.C α)^(t+1)).eval q ≠ 0 := by
        rw [h_eval]
        exact pow_ne_zero _ (sub_ne_zero.mpr (Ne.symm hne))
      apply Polynomial.rootMultiplicity_eq_zero
      rw [Polynomial.IsRoot.def]
      exact h_ne
  rw [h_off]
  push_cast
  ring

/-! ## L2-10 — Index of two-factor product at first root -/

/-- **L2-10 — `T5_univarIndex_two_factor_at_first`**: for distinct α, β
    and any t, s, the index of `(X − α)^t * (X − β)^s` at `α` is `t`. -/
theorem T5_univarIndex_two_factor_at_first
    (α β : ℝ) (hαβ : α ≠ β) (t s : ℕ) :
    T5_univarIndex ((Polynomial.X - Polynomial.C α)^t *
                    (Polynomial.X - Polynomial.C β)^s) α = (t : ℝ) := by
  rcases s with _|s'
  · -- s = 0: factor = 1
    have h_simp :
        ((Polynomial.X - Polynomial.C α)^t *
         (Polynomial.X - Polynomial.C β)^(0 : ℕ) : Polynomial ℝ) =
        ((Polynomial.X - Polynomial.C α)^t : Polynomial ℝ) := by
      rw [pow_zero, mul_one]
    rw [h_simp]
    exact T5_univarIndex_X_sub_C_pow α t
  · have hQ : ((Polynomial.X - Polynomial.C β)^(s'+1) : Polynomial ℝ) ≠ 0 :=
      pow_ne_zero _ (Polynomial.X_sub_C_ne_zero β)
    have hQα : ((Polynomial.X - Polynomial.C β)^(s'+1)).eval α ≠ 0 := by
      simp
      exact sub_ne_zero.mpr hαβ
    exact T5_univarIndex_X_sub_C_pow_mul α t _ hQ hQα

/-! ## L2-11 — Layer 2 paper-citable headline -/

/-- **L2-11 — `T5_D61_Layer2_completed_marker`**: 4-conjunct marker
    for Layer 2 completion (index-calculus foundations). -/
theorem T5_D61_Layer2_completed_marker :
    (∀ (P : Polynomial ℝ), P.derivative ≠ 0 → ∀ (α : ℝ),
      T5_univarIndex P α - 1 ≤ T5_univarIndex P.derivative α) ∧
    (∀ (α q : ℝ), q ≠ α → ∀ (t : ℕ),
      T5_univarIndex ((Polynomial.X - Polynomial.C α)^t) q = 0) ∧
    (∀ (α : ℝ), T5_univarIndex (1 : Polynomial ℝ) α = 0) ∧
    (∀ (α : ℝ) (P : Polynomial ℝ), P ≠ 0 →
      T5_univarIndex ((Polynomial.X - Polynomial.C α) * P) α =
        T5_univarIndex P α + 1) :=
  ⟨T5_univarIndex_derivative_drop_le_one,
   T5_univarIndex_X_sub_C_pow_at_off,
   T5_univarIndex_one,
   T5_univarIndex_X_sub_C_mul⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer2
