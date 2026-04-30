/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase

  T-5 (Roth's theorem) — **V7-N2 DC-1 discharge for general MONOMIAL case**.

  Most general single-monomial discharge of `T5_NAMED_BlockD_multivariate_clearance`:
  for `p = MvPolynomial.monomial d c` with arbitrary multi-index `d : Fin m →₀ ℕ`
  and `c : ℤ`, clearance holds with witness
    `k = c · ∏ j ∈ Finset.univ, (q j).num ^ (d j)`.

  Subsumes:
  - DCC (constant): d = 0, ∏ collapses to 1, k = c
  - DCX (X variable): d = Finsupp.single i 1, c = 1, k = (q i).num
  - DCMX (c · X i): d = Finsupp.single i 1, k = c · (q i).num

  Proof core:
  - degreeOf j (monomial d c) = d j (Mathlib `degreeOf_monomial_eq`,
    needs c ≠ 0; c = 0 case reduces to zero)
  - aeval (q-cast) (monomial d c) = (c : ℝ) · ∏ (q j : ℝ)^(d j)
    (via `aeval_monomial` + `Finsupp.prod_fintype`)
  - Combined product: ∏ q_j.den^(d j) · ∏ (q_j : ℝ)^(d j) = ∏ (q_j.num : ℝ)^(d j)
    (via `Finset.prod_mul_distrib` + `mul_pow` + DCX-1 per factor)

  This + sum-of-monomials decomposition closes V7-N2 multivariate.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase

/-! ## DCM-1 — Combined product identity -/

/-- **DCM-1 — `T5_tuple_qden_qcast_pow_prod_eq_num`**: per-factor DCX-1
    lifted to product form.
    `∏_j (q_j.den)^(d_j) · ∏_j (q_j : ℝ)^(d_j) = ∏_j (q_j.num : ℝ)^(d_j)`.

    Combines `Finset.prod_mul_distrib` (combining two products) with
    `mul_pow` (per-factor commutation) and DCX-1 (per-factor rational
    arith identity). -/
theorem T5_tuple_qden_qcast_pow_prod_eq_num
    {m : ℕ} (q : Fin m → ℚ) (d : Fin m → ℕ) :
    (∏ j, ((q j).den : ℝ) ^ (d j)) * (∏ j, ((q j : ℚ) : ℝ) ^ (d j)) =
      ∏ j, ((q j).num : ℝ) ^ (d j) := by
  rw [← Finset.prod_mul_distrib]
  apply Finset.prod_congr rfl
  intros j _
  rw [← mul_pow]
  congr 1
  exact T5_qden_mul_qcast_eq_qnum (q j)

/-! ## DCM-2 — DC-1 holds for general monomial -/

/-- **DCM-2 — `T5_BlockD_clearance_monomial`**: the multivariate
    denominator clearance DC-1 holds for `p = monomial d c` with
    witness `k = c · ∏ j, (q j).num^(d j)`. -/
theorem T5_BlockD_clearance_monomial
    {m : ℕ} (d : Fin m →₀ ℕ) (c : ℤ) (q : Fin m → ℚ) :
    ∃ k : ℤ,
      (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ))) : ℕ)) *
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) = (k : ℝ) := by
  refine ⟨c * ∏ j, (q j).num ^ (d j), ?_⟩
  by_cases hc : c = 0
  · subst hc
    simp [MvPolynomial.monomial_zero]
  · -- c ≠ 0
    have h_alg_c_ne : (algebraMap ℤ ℝ c) ≠ 0 := by simp; exact hc
    -- (monomial d c).map ℝ = monomial d (algebraMap ℤ ℝ c)
    rw [MvPolynomial.map_monomial]
    -- aeval (q-cast) (monomial d r) = r * d.prod (fun j k => (q j : ℝ)^k)
    rw [MvPolynomial.aeval_monomial]
    -- d.prod = ∏ over univ via Finsupp.prod_fintype
    rw [Finsupp.prod_fintype d (fun j k => ((q j : ℚ) : ℝ) ^ k)
      (fun _ => pow_zero _)]
    -- degreeOf j (monomial d (algebraMap c)) = d j when c ≠ 0
    have h_D_R : ∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          (MvPolynomial.monomial d (algebraMap ℤ ℝ c) :
            MvPolynomial (Fin m) ℝ) : ℕ) =
        ∏ j, ((q j).den : ℝ) ^ (d j) := by
      apply Finset.prod_congr rfl
      intros j _
      rw [MvPolynomial.degreeOf_monomial_eq d j h_alg_c_ne]
    rw [h_D_R]
    -- algebraMap ℝ ℝ x = x
    have h_alg_id : algebraMap ℝ ℝ (algebraMap ℤ ℝ c) = ((c : ℤ) : ℝ) := by simp
    rw [h_alg_id]
    -- Goal: ∏ q_j.den^{d j} · ((c : ℝ) · ∏ (q j : ℝ)^{d j}) = (c · ∏ q_j.num^{d j} : ℝ)
    rw [show (∏ j, ((q j).den : ℝ) ^ (d j)) *
        (((c : ℤ) : ℝ) * ∏ j, ((q j : ℚ) : ℝ) ^ (d j)) =
        ((c : ℤ) : ℝ) *
        ((∏ j, ((q j).den : ℝ) ^ (d j)) *
          (∏ j, ((q j : ℚ) : ℝ) ^ (d j))) from by ring]
    rw [T5_tuple_qden_qcast_pow_prod_eq_num q d]
    push_cast
    ring

/-! ## DCM-3 — Headline -/

/-- **🚨🚨🚨 DCM-3 — `T5_DCM_BLOCK_D_MONOMIAL_HEADLINE`**: paper-citable
    monomial-case clearance bundle.

    Strategic significance: GENERAL MONOMIAL CASE — single most
    important sub-case for V7-N2 multivariate clearance.  Combined
    with sum-of-monomials decomposition (next-fire work via
    induction over support), this gives full DC-1 discharge. -/
theorem T5_DCM_BLOCK_D_MONOMIAL_HEADLINE :
    -- (a) DCM-1 product identity
    (∀ {m : ℕ} (q : Fin m → ℚ) (d : Fin m → ℕ),
      (∏ j, ((q j).den : ℝ) ^ (d j)) * (∏ j, ((q j : ℚ) : ℝ) ^ (d j)) =
        ∏ j, ((q j).num : ℝ) ^ (d j)) ∧
    -- (b) DCM-2 monomial clearance
    (∀ {m : ℕ} (d : Fin m →₀ ℕ) (c : ℤ) (q : Fin m → ℚ),
      ∃ k : ℤ,
        (∏ j, ((q j).den : ℝ) ^
          (MvPolynomial.degreeOf j
            (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
              (algebraMap ℤ ℝ))) : ℕ)) *
        aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ))) = (k : ℝ)) :=
  ⟨fun {m} q d => T5_tuple_qden_qcast_pow_prod_eq_num q d,
   fun {m} d c q => T5_BlockD_clearance_monomial d c q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase
