/-
  OmegaTheory.Irrationality.StrictMonotonicity

  Strict monotone-decreasing versions of the three per-tick error-bound
  values `pi_error_val`, `e_error_val`, `sqrt2_error_val`.

  The non-strict versions `{pi,e,sqrt2}_error_decreasing` live in
  `OmegaTheory/Predictions/JarlskogFromIrrationals.lean`.  The strict
  version for `sqrt2_error_val` already lives in
  `OmegaTheory/Predictions/LeptonN4Uniqueness.lean` as
  `sqrt2_error_val_strict_mono_decr`.  Here we close the symmetry by
  adding the strict versions for `pi_error_val` and `e_error_val`, plus
  a strict product-decreasing corollary.

  Target closure (2026-04-19):
    - Gacrux proof-hunter-research Target #8 family
    - Method M4 (Mendeleev completion): π and √2 had strict lemmas, `e`
      was the missing cell; added.

  0 sorry, 0 new axioms.  Builds against OmegaTheory V2 as of 2026-04-19.
-/

import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Predictions.JarlskogFromIrrationals

namespace OmegaTheory.Irrationality

open Real

/-! ## 1. Strict monotonicity for `pi_error_val` -/

/-- `pi_error_val N = 4 / (2N + 3)` is strictly decreasing.  The denominator
    `2N + 3` strictly grows with `N`, so the quotient of a positive numerator
    by a strictly larger positive denominator strictly shrinks. -/
theorem pi_error_val_strict_mono_decr (N : ℕ) :
    pi_error_val (N + 1) < pi_error_val N := by
  unfold pi_error_val
  have hN_pos : (0 : ℝ) < 2 * (N : ℝ) + 3 := by
    have : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
    linarith
  have hN1_pos : (0 : ℝ) < 2 * ((N + 1 : ℕ) : ℝ) + 3 := by
    push_cast; linarith
  have hlt : 2 * (N : ℝ) + 3 < 2 * ((N + 1 : ℕ) : ℝ) + 3 := by
    push_cast; linarith
  exact div_lt_div_of_pos_left (by norm_num : (0 : ℝ) < 4) hN_pos hlt

/-! ## 2. Strict monotonicity for `e_error_val` -/

/-- `e_error_val N = 3 / (N+1)!` is strictly decreasing.  The factorial
    `(N+1)!` is strictly less than `(N+2)! = (N+2) · (N+1)!` (since `N+2 ≥ 2
    > 1`), so the quotient of a positive numerator by a strictly larger
    positive denominator strictly shrinks. -/
theorem e_error_val_strict_mono_decr (N : ℕ) :
    e_error_val (N + 1) < e_error_val N := by
  unfold e_error_val
  have hfact_pos : (0 : ℝ) < ((N + 1).factorial : ℝ) :=
    Nat.cast_pos.mpr (Nat.factorial_pos _)
  have hfact1_pos : (0 : ℝ) < ((N + 1 + 1).factorial : ℝ) :=
    Nat.cast_pos.mpr (Nat.factorial_pos _)
  -- (N+1)! < (N+2)! because (N+2)! = (N+2) * (N+1)! and (N+2) ≥ 2 > 1.
  have hlt_nat : (N + 1).factorial < (N + 1 + 1).factorial := by
    have hmul : (N + 1 + 1).factorial = (N + 1 + 1) * (N + 1).factorial :=
      Nat.factorial_succ _
    have hfact_nat_pos : 0 < (N + 1).factorial := Nat.factorial_pos _
    have hge_two : 2 ≤ N + 1 + 1 := by omega
    calc (N + 1).factorial
        = 1 * (N + 1).factorial := by ring
      _ < (N + 1 + 1) * (N + 1).factorial := by
            apply Nat.mul_lt_mul_of_pos_right _ hfact_nat_pos
            omega
      _ = (N + 1 + 1).factorial := hmul.symm
  have hlt : ((N + 1).factorial : ℝ) < ((N + 1 + 1).factorial : ℝ) := by
    exact_mod_cast hlt_nat
  exact div_lt_div_of_pos_left (by norm_num : (0 : ℝ) < 3) hfact_pos hlt

/-! ## 3. Strict product-decreasing corollary

The three error values multiply to the geometric "total error tick"
used throughout the Irrationality chain.  Since each factor is strictly
decreasing and strictly positive, the product is strictly decreasing. -/

/-- The product `pi_error_val · e_error_val · sqrt2_error_val` is strictly
    monotone decreasing in `N`.  This is the strict version of
    `Predictions.errorProduct_decreasing`.

    Note: we cannot directly use `sqrt2_error_val_strict_mono_decr` from
    `LeptonN4Uniqueness` because that would introduce a cyclic import;
    we instead chain strict-on-π with non-strict-on-e-and-√2. -/
theorem pi_error_val_strict_drives_product (N : ℕ) :
    pi_error_val (N + 1) * e_error_val (N + 1) * sqrt2_error_val (N + 1)
      < pi_error_val N * e_error_val N * sqrt2_error_val N := by
  -- Strict on π, non-strict on e and √2 from JarlskogFromIrrationals.
  have h_pi_strict : pi_error_val (N + 1) < pi_error_val N :=
    pi_error_val_strict_mono_decr N
  have h_e  : e_error_val (N + 1)    ≤ e_error_val N    :=
    Predictions.JarlskogFromIrrationals.e_error_decreasing N
  have h_s  : sqrt2_error_val (N + 1) ≤ sqrt2_error_val N :=
    Predictions.JarlskogFromIrrationals.sqrt2_error_decreasing N
  -- positivity on all six factors
  have h_pi_next_pos : 0 < pi_error_val (N + 1) := pi_error_pos _
  have h_pi_pos      : 0 < pi_error_val N       := pi_error_pos _
  have h_e_next_pos  : 0 < e_error_val (N + 1)  := e_error_pos _
  have h_e_pos       : 0 < e_error_val N        := e_error_pos _
  have h_s_next_pos  : 0 < sqrt2_error_val (N + 1) := sqrt2_error_pos _
  have h_s_pos       : 0 < sqrt2_error_val N       := sqrt2_error_pos _
  -- Chain:  π(N+1)·e(N+1)·√2(N+1)
  --       < π(N  )·e(N+1)·√2(N+1)   [strict via π]
  --       ≤ π(N  )·e(N  )·√2(N+1)   [non-strict via e]
  --       ≤ π(N  )·e(N  )·√2(N  )   [non-strict via √2]
  have h_pos_es_next : 0 < e_error_val (N + 1) * sqrt2_error_val (N + 1) :=
    mul_pos h_e_next_pos h_s_next_pos
  have step1 :
      pi_error_val (N + 1) * (e_error_val (N + 1) * sqrt2_error_val (N + 1))
        < pi_error_val N * (e_error_val (N + 1) * sqrt2_error_val (N + 1)) := by
    exact mul_lt_mul_of_pos_right h_pi_strict h_pos_es_next
  have step2 :
      pi_error_val N * (e_error_val (N + 1) * sqrt2_error_val (N + 1))
        ≤ pi_error_val N * (e_error_val N * sqrt2_error_val (N + 1)) := by
    apply mul_le_mul_of_nonneg_left _ h_pi_pos.le
    exact mul_le_mul_of_nonneg_right h_e h_s_next_pos.le
  have step3 :
      pi_error_val N * (e_error_val N * sqrt2_error_val (N + 1))
        ≤ pi_error_val N * (e_error_val N * sqrt2_error_val N) := by
    apply mul_le_mul_of_nonneg_left _ h_pi_pos.le
    exact mul_le_mul_of_nonneg_left h_s h_e_pos.le
  -- Reassociate: a·b·c = a·(b·c) for the final LHS/RHS match.
  have lhs_eq :
      pi_error_val (N + 1) * e_error_val (N + 1) * sqrt2_error_val (N + 1) =
      pi_error_val (N + 1) * (e_error_val (N + 1) * sqrt2_error_val (N + 1)) := by
    ring
  have rhs_eq :
      pi_error_val N * e_error_val N * sqrt2_error_val N =
      pi_error_val N * (e_error_val N * sqrt2_error_val N) := by
    ring
  rw [lhs_eq, rhs_eq]
  calc pi_error_val (N + 1) * (e_error_val (N + 1) * sqrt2_error_val (N + 1))
      < pi_error_val N * (e_error_val (N + 1) * sqrt2_error_val (N + 1)) := step1
    _ ≤ pi_error_val N * (e_error_val N * sqrt2_error_val (N + 1))       := step2
    _ ≤ pi_error_val N * (e_error_val N * sqrt2_error_val N)             := step3

end OmegaTheory.Irrationality
