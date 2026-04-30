/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge

  T-5 (Roth's theorem) — **V7-N2 FULL UNCONDITIONAL DISCHARGE**.

  Final discharge of `T5_NAMED_BlockD_multivariate_clearance` via:
  1. Generalized monomial clearance `T5_BlockD_clearance_monomial_at_R`:
     for monomial d c with R ≥ d, clearance_at_R holds.
  2. Linearity (DCL): clearance_at_R closed under Finset.sum.
  3. Support induction via MvPolynomial.as_sum:
     p = ∑ d ∈ p.support, monomial d (coeff p d), and R := degreeOf p
     bounds d_j for each d ∈ support.
  4. Bridge (DCL-5): clearance_at_R p (degreeOf p) ≡ DC-1 component.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof, no sorry.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceLinearity
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
import Mathlib.Algebra.MvPolynomial.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceMonomialCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceLinearity
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft

/-! ## DCFD-1 — Monomial clearance with arbitrary R bound -/

/-- **DCFD-1 — `T5_BlockD_clearance_monomial_at_R`**: clearance for
    `p = monomial d c` holds with ANY R ≥ d (per-j) — generalization
    of DCM-2 which used R = d.

    Witness: `k = c · ∏ q_j.den^(R_j - d_j) · ∏ q_j.num^(d_j)`.

    Strategy:
    - Case c = 0: monomial d 0 = 0, k = 0.
    - Case c ≠ 0:
      * (monomial d c).map ℝ = monomial d (algebraMap ℤ ℝ c)
      * aeval = (c:ℝ) · ∏ (q_j:ℝ)^(d_j)
      * D_R = ∏ q_j.den^(R_j) = ∏ q_j.den^(R_j - d_j) · ∏ q_j.den^(d_j)
        via Nat.sub_add_cancel + pow_add (R_j ≥ d_j)
      * Combined: k = c · ∏ q_j.den^(R_j - d_j) · ∏ q_j.num^(d_j) (DCM-1) -/
theorem T5_BlockD_clearance_monomial_at_R
    {m : ℕ} (d : Fin m →₀ ℕ) (c : ℤ) (R : Fin m → ℕ) (q : Fin m → ℚ)
    (h_R : ∀ j, d j ≤ R j) :
    T5_clearance_at_R (MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ)
      R q := by
  show ∃ k : ℤ, _ = (k : ℝ)
  refine ⟨c * (∏ j, ((q j).den : ℤ) ^ (R j - d j)) *
    (∏ j, (q j).num ^ (d j)), ?_⟩
  by_cases hc : c = 0
  · subst hc
    simp [MvPolynomial.monomial_zero]
  · -- c ≠ 0
    have h_alg_c_ne : (algebraMap ℤ ℝ c) ≠ 0 := by simp; exact hc
    rw [MvPolynomial.map_monomial]
    rw [MvPolynomial.aeval_monomial]
    rw [Finsupp.prod_fintype d (fun j k => ((q j : ℚ) : ℝ) ^ k)
      (fun _ => pow_zero _)]
    -- algebraMap ℝ ℝ x = x
    rw [show algebraMap ℝ ℝ (algebraMap ℤ ℝ c) = ((c : ℤ) : ℝ) by simp]
    -- Split q_j.den^(R_j) = q_j.den^(R_j - d_j) · q_j.den^(d_j)
    have h_den_split : ∀ j,
        ((q j).den : ℝ) ^ (R j) =
        ((q j).den : ℝ) ^ (R j - d j) * ((q j).den : ℝ) ^ (d j) := by
      intro j
      rw [← pow_add, Nat.sub_add_cancel (h_R j)]
    have h_prod_split : ∏ j, ((q j).den : ℝ) ^ (R j) =
        (∏ j, ((q j).den : ℝ) ^ (R j - d j)) *
        (∏ j, ((q j).den : ℝ) ^ (d j)) := by
      rw [← Finset.prod_mul_distrib]
      apply Finset.prod_congr rfl
      intros j _
      exact h_den_split j
    rw [h_prod_split]
    -- Now: (∏ q_j.den^(R_j - d_j) · ∏ q_j.den^(d_j)) · ((c:ℝ) · ∏ (q_j:ℝ)^(d_j)) = ?
    rw [show (∏ j, ((q j).den : ℝ) ^ (R j - d j)) *
        (∏ j, ((q j).den : ℝ) ^ (d j)) *
        (((c : ℤ) : ℝ) * ∏ j, ((q j : ℚ) : ℝ) ^ (d j)) =
        ((c : ℤ) : ℝ) * (∏ j, ((q j).den : ℝ) ^ (R j - d j)) *
        ((∏ j, ((q j).den : ℝ) ^ (d j)) *
          (∏ j, ((q j : ℚ) : ℝ) ^ (d j))) by ring]
    rw [T5_tuple_qden_qcast_pow_prod_eq_num q d]
    push_cast
    ring

/-! ## DCFD-2 — degreeOf-bound for monomials in support of polynomial -/

/-- **DCFD-2 — `T5_degreeOf_p_ge_d_in_support`**: for any d ∈ p.support,
    R_j := degreeOf j p ≥ d j.

    Direct from `MvPolynomial.monomial_le_degreeOf` (max definition of degreeOf). -/
theorem T5_degreeOf_p_ge_d_in_support
    {m : ℕ} (p : MvPolynomial (Fin m) ℝ) (d : Fin m →₀ ℕ)
    (h_mem : d ∈ p.support) :
    ∀ j, d j ≤ MvPolynomial.degreeOf j p := by
  intro j
  exact MvPolynomial.monomial_le_degreeOf j h_mem

/-! ## DCFD-3 — Full V7-N2 unconditional discharge -/

/-- **🚨🚨🚨 DCFD-3 — `T5_NAMED_BlockD_multivariate_clearance_unconditional`**:
    THE MAIN THEOREM — V7-N2 NAMED clearance hypothesis is
    UNCONDITIONALLY DISCHARGED.

    Proof:
    1. p = ∑ d ∈ p.support, monomial d (coeff p d) (MvPolynomial.as_sum).
    2. R := fun j => degreeOf j (p.map ℝ).  For each d ∈ support of (p.map ℝ),
       R_j ≥ d_j (DCFD-2).
    3. Each `monomial d (coeff (p.map ℝ) d)` has clearance_at_R via
       a integer-version: we work with the original ℤ coefficients.
    4. Linearity (DCL-4) over Finset.sum gives clearance_at_R for the
       full sum, which equals p.map ℝ.
    5. Bridge to DC-1 form (DCL-5).

    HOWEVER: subtle point — the support is over `p.map ℝ`, not p.
    The integer coefficients are at `coeff p d` in ℤ, while
    `coeff (p.map ℝ) d = (coeff p d : ℝ)`.  We keep things in the ℤ
    polynomial p and use the integer monomial form. -/
theorem T5_NAMED_BlockD_multivariate_clearance_unconditional :
    T5_NAMED_BlockD_multivariate_clearance := by
  intros m hm p q
  -- R := fun j => degreeOf j (p.map ℝ)
  set R : Fin m → ℕ := fun j =>
    MvPolynomial.degreeOf j (p.map (algebraMap ℤ ℝ)) with hR_def
  -- Goal: ∃ k, ∏ q_j.den^(R j) · aeval (p.map ℝ) = (k : ℝ)
  -- Equivalent to: T5_clearance_at_R p R q
  suffices h : T5_clearance_at_R p R q by
    obtain ⟨k, hk⟩ := h
    exact ⟨k, hk⟩
  -- Express p as sum of monomials over support
  have h_as_sum : p = ∑ d ∈ p.support,
      MvPolynomial.monomial d (p.coeff d) := MvPolynomial.as_sum p
  rw [h_as_sum]
  -- Apply linearity (DCL-4) over Finset.sum
  apply T5_clearance_at_R_sum
  intros d hd_mem
  -- For each d ∈ p.support, monomial d (coeff p d) has clearance_at_R
  -- with R := degreeOf · (p.map ℝ).  Need R_j ≥ d j.
  apply T5_BlockD_clearance_monomial_at_R d (p.coeff d) R q
  intro j
  -- Need: d j ≤ R j = degreeOf j (p.map ℝ)
  -- The support of p.map ℝ is the same as p.support in this context,
  -- since algebraMap ℤ ℝ is injective on non-zero coefficients.
  -- Actually we use: d j ≤ degreeOf j p (since d ∈ p.support),
  -- then degreeOf j p ≤ degreeOf j (p.map ℝ).
  -- Or directly: for d ∈ p.support, d j ≤ degreeOf j (p.map ℝ) via
  -- MvPolynomial.degreeOf_map_eq when algebraMap ℤ ℝ is faithful.
  rw [hR_def]
  -- d ∈ p.support ⇒ p.coeff d ≠ 0 ⇒ (p.map ℝ).coeff d = algebraMap ℤ ℝ (p.coeff d) ≠ 0
  have h_coeff_ne : (p.map (algebraMap ℤ ℝ)).coeff d ≠ 0 := by
    rw [MvPolynomial.coeff_map]
    have : p.coeff d ≠ 0 := by
      rw [← MvPolynomial.mem_support_iff]
      exact hd_mem
    simp; exact this
  have hd_in_map : d ∈ (p.map (algebraMap ℤ ℝ)).support := by
    rw [MvPolynomial.mem_support_iff]
    exact h_coeff_ne
  exact MvPolynomial.monomial_le_degreeOf j hd_in_map

/-! ## DCFD-4 — V7-N2 lower bound UNCONDITIONALLY -/

/-- **🚨🚨🚨 DCFD-4 — `T5_NAMED_BlockD_integer_lower_bound_unconditional`**:
    V7-N2 (multivariate integer non-vanishing lower bound) is now
    UNCONDITIONAL via DCFD-3 (clearance discharge) + DC-2 (composition). -/
theorem T5_NAMED_BlockD_integer_lower_bound_unconditional :
    T5_NAMED_BlockD_integer_lower_bound :=
  T5_NAMED_BlockD_via_clearance T5_NAMED_BlockD_multivariate_clearance_unconditional

/-! ## DCFD-5 — Headline: V7-N2 closure -/

/-- **🚨🚨🚨🚨🚨 DCFD-5 — `T5_DCFD_BLOCK_D_V7N2_CLOSURE_HEADLINE`**:
    paper-citable V7-N2 CLOSURE headline.

    Bundles:
    (a) DCFD-1 monomial clearance with arbitrary R bound
    (b) DCFD-3 V7-N2 NAMED clearance UNCONDITIONALLY DISCHARGED
    (c) DCFD-4 V7-N2 lower bound UNCONDITIONALLY

    **STRATEGIC MILESTONE**: V7-N2 (Block D multivariate integer
    non-vanishing lower bound) CLOSED.  V7 capstone now requires
    only V7-N1 (Block C Taylor upper bound) — closer to T-5
    UNCONDITIONAL closure. -/
theorem T5_DCFD_BLOCK_D_V7N2_CLOSURE_HEADLINE :
    -- (a) DCFD-1 monomial clearance with arbitrary R bound
    (∀ {m : ℕ} (d : Fin m →₀ ℕ) (c : ℤ) (R : Fin m → ℕ) (q : Fin m → ℚ),
      (∀ j, d j ≤ R j) →
      T5_clearance_at_R
        (MvPolynomial.monomial d c : MvPolynomial (Fin m) ℤ) R q) ∧
    -- (b) DCFD-3 V7-N2 NAMED clearance UNCONDITIONAL
    T5_NAMED_BlockD_multivariate_clearance ∧
    -- (c) DCFD-4 V7-N2 lower bound UNCONDITIONAL
    T5_NAMED_BlockD_integer_lower_bound :=
  ⟨fun {m} d c R q h_R => T5_BlockD_clearance_monomial_at_R d c R q h_R,
   T5_NAMED_BlockD_multivariate_clearance_unconditional,
   T5_NAMED_BlockD_integer_lower_bound_unconditional⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
