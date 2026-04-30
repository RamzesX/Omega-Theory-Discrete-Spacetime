/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase

  T-5 (Roth's theorem) — **V7-N2 DC-1 discharge for CONSTANT polynomial**.

  Concrete sanity-check discharge of `T5_NAMED_BlockD_multivariate_clearance`
  for the case `p = MvPolynomial.C c`.  For constant integer polynomials,
  the integer clearance is trivial: `k = c`.

  Validates that DC-1 (NAMED clearance hypothesis) is consistent with
  the univariate baseline + monomial machinery, and provides a concrete
  WORKED EXAMPLE before tackling the full polynomial case via
  `MvPolynomial.eval₂_eq'`.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof, no sorry.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
import Mathlib.Algebra.MvPolynomial.Basic
import Mathlib.Algebra.MvPolynomial.Equiv
import Mathlib.Algebra.MvPolynomial.Degrees

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition

/-! ## DCC-1 — DC-1 holds for constant polynomial p = C c -/

/-- **DCC-1 — `T5_BlockD_clearance_constant`**: the multivariate
    denominator clearance DC-1 holds for `p = MvPolynomial.C c` with
    witness `k = c`.

    Strategy: `(C c).map ℝ = C ((c : ℤ) : ℝ)`.  `degreeOf i (C ((c : ℤ) : ℝ)) = 0`
    for all i.  So `(q_i.den : ℝ)^0 = 1` and `∏ ... = 1`.
    `aeval (q-cast) (C ((c : ℤ) : ℝ)) = ((c : ℤ) : ℝ)`.  So
    `1 · ((c : ℤ) : ℝ) = ((c : ℤ) : ℝ)` matching `k = c`. -/
theorem T5_BlockD_clearance_constant
    {m : ℕ} (c : ℤ) (q : Fin m → ℚ) :
    ∃ k : ℤ,
      (∏ i, ((q i).den : ℝ) ^
        (MvPolynomial.degreeOf i
          ((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) *
      aeval (fun i => ((q i : ℚ) : ℝ))
        (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) = (k : ℝ) := by
  refine ⟨c, ?_⟩
  rw [MvPolynomial.map_C]
  rw [MvPolynomial.aeval_C]
  -- ∏ ... = 1 since degreeOf i (C ...) = 0
  have h_prod : ∏ i, ((q i).den : ℝ) ^
      (MvPolynomial.degreeOf i (MvPolynomial.C (algebraMap ℤ ℝ c) :
        MvPolynomial (Fin m) ℝ) : ℕ) = 1 := by
    apply Finset.prod_eq_one
    intros i _
    rw [MvPolynomial.degreeOf_C]
    simp
  rw [h_prod, one_mul]
  simp

/-! ## DCC-2 — DC-1 holds for zero polynomial p = 0 -/

/-- **DCC-2 — `T5_BlockD_clearance_zero`**: the multivariate denominator
    clearance DC-1 holds for `p = 0` with witness `k = 0`.

    Special case of DCC-1 with `c = 0`. -/
theorem T5_BlockD_clearance_zero
    {m : ℕ} (q : Fin m → ℚ) :
    ∃ k : ℤ,
      (∏ i, ((q i).den : ℝ) ^
        (MvPolynomial.degreeOf i
          ((0 : MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ)) : ℕ)) *
      aeval (fun i => ((q i : ℚ) : ℝ))
        (((0 : MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) = (k : ℝ) := by
  -- Reduce to constant case with c = 0
  have h : (0 : MvPolynomial (Fin m) ℤ) = MvPolynomial.C 0 := by simp
  rw [h]
  exact T5_BlockD_clearance_constant 0 q

/-! ## DCC-3 — Headline -/

/-- **🚨 DCC-3 — `T5_DCC_BLOCK_D_CLEARANCE_CONSTANT_HEADLINE`**:
    paper-citable bundle of constant + zero clearance discharges.

    Demonstrates that DC-1 is CONSISTENT for the simplest cases.
    Sanity check + concrete worked examples for the full clearance
    discharge work next-fire. -/
theorem T5_DCC_BLOCK_D_CLEARANCE_CONSTANT_HEADLINE :
    -- (a) Constant polynomial clearance
    (∀ {m : ℕ} (c : ℤ) (q : Fin m → ℚ),
      ∃ k : ℤ,
        (∏ i, ((q i).den : ℝ) ^
          (MvPolynomial.degreeOf i
            ((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
              (algebraMap ℤ ℝ)) : ℕ)) *
        aeval (fun i => ((q i : ℚ) : ℝ))
          (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ))) = (k : ℝ)) ∧
    -- (b) Zero polynomial clearance
    (∀ {m : ℕ} (q : Fin m → ℚ),
      ∃ k : ℤ,
        (∏ i, ((q i).den : ℝ) ^
          (MvPolynomial.degreeOf i
            ((0 : MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ)) : ℕ)) *
        aeval (fun i => ((q i : ℚ) : ℝ))
          (((0 : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ))) = (k : ℝ)) :=
  ⟨fun {m} c q => T5_BlockD_clearance_constant c q,
   fun {m} q => T5_BlockD_clearance_zero q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
