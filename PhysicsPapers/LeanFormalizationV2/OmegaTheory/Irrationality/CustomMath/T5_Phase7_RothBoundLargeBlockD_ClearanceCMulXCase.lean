/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceCMulXCase

  T-5 (Roth's theorem) — **V7-N2 DC-1 discharge for `c · X i` (C c * X i)**.

  Concrete generalization of DCC + DCX: clearance for `p = C c * X i`
  with witness `k = c · (q i).num`.

  Combines DCC (constant) + DCX (variable) into a single monomial-like
  case.  Used for sum-of-monomials decomposition + the support
  induction toward full DC-1 discharge.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound
import Mathlib.Algebra.MvPolynomial.NoZeroDivisors

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceCMulXCase

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound

/-! ## DCMX-1 — DC-1 holds for c · X i (C c * X i) -/

/-- **DCMX-1 — `T5_BlockD_clearance_C_mul_X`**: the multivariate
    denominator clearance DC-1 holds for `p = C c * X i` with witness
    `k = c · (q i).num`.

    Strategy:
    - Case c = 0: C 0 * X i = 0, reduces to zero case (k = 0 = 0 · q.num).
    - Case c ≠ 0:
      * (C c * X i).map ℝ = C ((c : ℤ) : ℝ) * X i (map_mul + map_C + map_X)
      * aeval (q-cast) (C c' * X i) = (c' : ℝ) · (q i : ℝ) (aeval_mul +
        aeval_C + aeval_X)
      * degreeOf j (C c' * X i) = degreeOf j (X i) (degreeOf_C_mul,
        c' ∈ nonZeroDivisors ℝ since c ≠ 0)
      * ∏ q_j.den^{degreeOf j (X i)} = q_i.den (DCX-2 product collapse)
      * D_R · aeval = q_i.den · (c : ℝ) · (q_i : ℝ) = c · (q_i.num : ℝ)
        via DCX-1 rational arithmetic. -/
theorem T5_BlockD_clearance_C_mul_X
    {m : ℕ} (c : ℤ) (i : Fin m) (q : Fin m → ℚ) :
    ∃ k : ℤ,
      (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          (((MvPolynomial.C c * MvPolynomial.X i :
              MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) : ℕ)) *
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c * MvPolynomial.X i :
            MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) = (k : ℝ) := by
  refine ⟨c * (q i).num, ?_⟩
  -- (C c * X i).map ℝ = (C c).map ℝ * (X i).map ℝ = C (c : ℝ) * X i
  rw [_root_.map_mul, MvPolynomial.map_C, MvPolynomial.map_X]
  -- aeval (q-cast) (C c' * X i) = c' * q_i  (where c' = (c : ℤ) : ℝ)
  rw [_root_.map_mul, MvPolynomial.aeval_C, MvPolynomial.aeval_X]
  -- Show: ∏ ... · (algebraMap ℝ ℝ ((c : ℤ) : ℝ)) · (q i : ℝ) = (c · q_i.num : ℝ)
  -- algebraMap ℝ ℝ x = x
  -- Case on c = 0
  by_cases hc : c = 0
  · -- c = 0: both sides equal 0
    subst hc
    simp
  · -- c ≠ 0: use degreeOf_C_mul to reduce ∏ to q_i.den, then DCX-1
    have h_c_alg_ne : (algebraMap ℤ ℝ c) ≠ 0 := by
      simp; exact hc
    have h_c_nzd : (algebraMap ℤ ℝ c) ∈ nonZeroDivisors ℝ :=
      mem_nonZeroDivisors_of_ne_zero h_c_alg_ne
    -- ∏ q_j.den^{degreeOf j (C c' * X i)} = ∏ q_j.den^{degreeOf j (X i)} (for c' ≠ 0)
    have h_prod_eq : ∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          (MvPolynomial.C (algebraMap ℤ ℝ c) * MvPolynomial.X i :
            MvPolynomial (Fin m) ℝ) : ℕ) =
        ∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j (MvPolynomial.X i :
          MvPolynomial (Fin m) ℝ) : ℕ) := by
      apply Finset.prod_congr rfl
      intros j _
      rw [MvPolynomial.degreeOf_C_mul j _ h_c_nzd]
    rw [h_prod_eq]
    -- Now ∏ over X i form = q_i.den (DCX-2's inner step)
    have h_prod_qi : ∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j (MvPolynomial.X i :
          MvPolynomial (Fin m) ℝ) : ℕ) = ((q i).den : ℝ) := by
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
      rw [h_step1, MvPolynomial.degreeOf_X]
      simp
    rw [h_prod_qi]
    -- Goal: (q_i.den : ℝ) · (algebraMap ℝ ℝ (algebraMap ℤ ℝ c)) · (q_i : ℝ) = (c * q_i.num : ℝ)
    have h_alg_id : algebraMap ℝ ℝ (algebraMap ℤ ℝ c) = ((c : ℤ) : ℝ) := by simp
    rw [h_alg_id]
    rw [show ((q i).den : ℝ) * (((c : ℤ) : ℝ) * ((q i : ℚ) : ℝ)) =
        ((c : ℤ) : ℝ) * (((q i).den : ℝ) * ((q i : ℚ) : ℝ)) from by ring]
    rw [T5_qden_mul_qcast_eq_qnum (q i)]
    push_cast
    ring

/-! ## DCMX-2 — V7-N2 conclusion for p = c · X i -/

/-- **DCMX-2 — `T5_BlockD_lower_bound_for_C_mul_X`**: V7-N2 conclusion
    for `p = C c * X i`.

    Direct application of PPL-1 with DCMX-1 clearance witness. -/
theorem T5_BlockD_lower_bound_for_C_mul_X
    {m : ℕ} (c : ℤ) (i : Fin m) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun j => ((q j : ℚ) : ℝ))
      (((MvPolynomial.C c * MvPolynomial.X i :
        MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) ≠ 0) :
    1 / (∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j
        (((MvPolynomial.C c * MvPolynomial.X i :
            MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) : ℕ)) ≤
      |aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c * MvPolynomial.X i :
            MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ)))| :=
  T5_BlockD_lower_bound_from_clearance _ q
    (T5_BlockD_clearance_C_mul_X c i q) h_eval_ne

/-! ## DCMX-3 — Headline -/

/-- **🚨🚨 DCMX-3 — `T5_DCMX_BLOCK_D_C_MUL_X_HEADLINE`**: paper-citable
    bundle for the `c · X i` clearance + V7-N2 conclusion.

    Strategic significance: combines DCC (constant) + DCX (variable)
    into a unified scalar-times-variable case via Mathlib
    `MvPolynomial.degreeOf_C_mul` (requires non-zero divisor) +
    DCX-1 rational arithmetic identity. -/
theorem T5_DCMX_BLOCK_D_C_MUL_X_HEADLINE :
    -- (a) DCMX-1 clearance for c · X i
    (∀ {m : ℕ} (c : ℤ) (i : Fin m) (q : Fin m → ℚ),
      ∃ k : ℤ,
        (∏ j, ((q j).den : ℝ) ^
          (MvPolynomial.degreeOf j
            (((MvPolynomial.C c * MvPolynomial.X i :
                MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) : ℕ)) *
        aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.C c * MvPolynomial.X i :
              MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) = (k : ℝ)) ∧
    -- (b) DCMX-2 V7-N2 conclusion for c · X i
    (∀ {m : ℕ} (c : ℤ) (i : Fin m) (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c * MvPolynomial.X i :
            MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) ≠ 0 →
      1 / (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          (((MvPolynomial.C c * MvPolynomial.X i :
              MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ))) : ℕ)) ≤
        |aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.C c * MvPolynomial.X i :
              MvPolynomial (Fin m) ℤ).map (algebraMap ℤ ℝ)))|) :=
  ⟨fun {m} c i q => T5_BlockD_clearance_C_mul_X c i q,
   fun {m} c i q => T5_BlockD_lower_bound_for_C_mul_X c i q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceCMulXCase
