/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase

  T-5 (Roth's theorem) — **V7-N2 DC-1 discharge for X i (variable) polynomial**.

  Concrete discharge of `T5_NAMED_BlockD_multivariate_clearance` for the
  case `p = MvPolynomial.X i`.  For variable polynomials, the integer
  clearance is `k = (q i).num`, witnessed by:
    `q_i.den · (q_i : ℝ) = (q_i.num : ℝ)`
  via rational arithmetic identity `(q : ℝ) = q.num / q.den`.

  Combined with DCC (constant case), this provides the m=1 atomic
  building blocks: any polynomial = sum of `c_d · X^{d}` monomials,
  and clearance for each block sums to give the full polynomial.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof, no sorry.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
import Mathlib.Algebra.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.Degrees
import Mathlib.Data.Rat.Cast.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition

/-! ## DCX-1 — Rational arithmetic helper -/

/-- **DCX-1 — `T5_qden_mul_qcast_eq_qnum`**: rational arithmetic identity
    `(q.den : ℝ) · (q : ℝ) = (q.num : ℝ)`.

    From `Rat.cast_def : (q : ℝ) = (q.num : ℝ) / (q.den : ℝ)` plus
    `mul_div_cancel₀` (q.den ≠ 0). -/
theorem T5_qden_mul_qcast_eq_qnum (q : ℚ) :
    ((q.den : ℝ) : ℝ) * ((q : ℚ) : ℝ) = ((q.num : ℤ) : ℝ) := by
  have h_den_ne : ((q.den : ℝ) : ℝ) ≠ 0 := by
    exact_mod_cast q.pos.ne'
  rw [Rat.cast_def]
  field_simp

/-! ## DCX-2 — DC-1 holds for X i (variable) polynomial -/

/-- **DCX-2 — `T5_BlockD_clearance_X`**: the multivariate denominator
    clearance DC-1 holds for `p = MvPolynomial.X i` with witness
    `k = (q i).num`.

    Strategy:
    1. `(X i).map ℝ = X i`.
    2. `aeval (q-cast) (X i) = (q i : ℝ)`.
    3. `degreeOf j (X i) = if j = i then 1 else 0`.
    4. `∏ j, (q_j.den)^{degreeOf j (X i)} = (q_i.den)`
       (using `Finset.prod_ite_eq` collapse).
    5. `(q_i.den) · (q_i : ℝ) = (q_i.num : ℝ)` via DCX-1. -/
theorem T5_BlockD_clearance_X
    {m : ℕ} (i : Fin m) (q : Fin m → ℚ) :
    ∃ k : ℤ,
      (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          ((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) *
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) = (k : ℝ) := by
  refine ⟨(q i).num, ?_⟩
  rw [MvPolynomial.map_X, MvPolynomial.aeval_X]
  -- Step 1: collapse ∏ to single factor at i via Finset.prod_eq_single
  have h_step1 : ∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j (MvPolynomial.X i :
        MvPolynomial (Fin m) ℝ) : ℕ) =
      ((q i).den : ℝ) ^
      (MvPolynomial.degreeOf i (MvPolynomial.X i :
        MvPolynomial (Fin m) ℝ) : ℕ) := by
    apply Finset.prod_eq_single i
    · intros j _ h_ne
      rw [MvPolynomial.degreeOf_X, if_neg h_ne]
      simp
    · intro h
      exact absurd (Finset.mem_univ i) h
  -- Step 2: simplify factor at i to (q_i.den : ℝ)
  have h_step2 : ((q i).den : ℝ) ^
      (MvPolynomial.degreeOf i (MvPolynomial.X i :
        MvPolynomial (Fin m) ℝ) : ℕ) = ((q i).den : ℝ) := by
    rw [MvPolynomial.degreeOf_X]
    simp
  rw [h_step1, h_step2]
  -- Step 3: (q_i.den : ℝ) * (q_i : ℝ) = (q_i.num : ℝ)
  exact T5_qden_mul_qcast_eq_qnum (q i)

/-! ## DCX-3 — Headline -/

/-- **🚨 DCX-3 — `T5_DCX_BLOCK_D_CLEARANCE_X_HEADLINE`**:
    paper-citable bundle of the X-variable clearance discharge.

    Combined with DCC (constant case), this provides the basic
    monomial atomic building blocks for the full DC-1 discharge.

    Strategic significance: any polynomial is a finite linear
    combination of monomials `c_d · X^{d}`, and the linear case
    (X i, this file) plus the constant case (DCC) plus eventual
    `c · X^{d}` and sum-of-monomials lemmas give the full
    multivariate clearance via induction on `support p`. -/
theorem T5_DCX_BLOCK_D_CLEARANCE_X_HEADLINE :
    -- (a) DCX-1 rational arithmetic helper
    (∀ (q : ℚ), ((q.den : ℝ) : ℝ) * ((q : ℚ) : ℝ) = ((q.num : ℤ) : ℝ)) ∧
    -- (b) DCX-2 DC-1 for p = X i
    (∀ {m : ℕ} (i : Fin m) (q : Fin m → ℚ),
      ∃ k : ℤ,
        (∏ j, ((q j).den : ℝ) ^
          (MvPolynomial.degreeOf j
            ((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
              (algebraMap ℤ ℝ)) : ℕ)) *
        aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ))) = (k : ℝ)) :=
  ⟨T5_qden_mul_qcast_eq_qnum,
   fun {m} i q => T5_BlockD_clearance_X i q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase
