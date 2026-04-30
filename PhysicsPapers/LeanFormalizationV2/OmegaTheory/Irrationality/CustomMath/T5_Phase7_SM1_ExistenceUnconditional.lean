/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional

  T-5 (Roth's theorem) — **SM1PD-1 UNCONDITIONAL DISCHARGE**.

  Discharges `T5_NAMED_Schmidt_existence_int_poly` UNCONDITIONALLY using
  the trivial witness `P_int := ∑ i, X i : MvPolynomial (Fin m) ℤ`
  (sum of all variables) for m ≥ 1.

  This polynomial:
  - Is nonzero (the coefficient at `Finsupp.single i₀ 1` is 1 for any i₀)
  - Has positive degreeOf in each variable (degreeOf i₀ ≥ 1 via the
    X_{i₀} term in the sum)

  Strategic significance: closes 1 of the 8 atomic inner NAMED leaves of
  the V8 Roth architecture. Reduces SM-1 from a 2-NAMED factoring
  (existence + α-diagonal index lower bound) to a 1-NAMED factoring
  (only the index lower bound remains as the analytical heart).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge

/-! ## SM1EU-1 — concrete polynomial: sum of variables -/

/-- The "sum of variables" polynomial `∑ i, X i : MvPolynomial (Fin m) ℤ`. -/
noncomputable def schmidtAuxPolyZ_sumX (m : ℕ) : MvPolynomial (Fin m) ℤ :=
  ∑ i : Fin m, MvPolynomial.X i

/-- Mapped to ℝ: identity (algebraMap ℤ ℝ preserves X i and sums). -/
theorem schmidtAuxPolyR_sumX_eq (m : ℕ) :
    (schmidtAuxPolyZ_sumX m).map (algebraMap ℤ ℝ) =
    (∑ i : Fin m, MvPolynomial.X i : MvPolynomial (Fin m) ℝ) := by
  unfold schmidtAuxPolyZ_sumX
  rw [_root_.map_sum]
  simp [MvPolynomial.map_X]

/-! ## SM1EU-2 — nonzero coefficient at single i₀ 1 -/

/-- The polynomial `∑ i, X i : MvPolynomial (Fin m) ℝ` has coefficient 1
    at the monomial `Finsupp.single i₀ 1` for any i₀. -/
theorem schmidtAuxPolyR_sumX_coeff_one
    {m : ℕ} (i₀ : Fin m) :
    MvPolynomial.coeff (Finsupp.single i₀ 1)
        (∑ i : Fin m, MvPolynomial.X i : MvPolynomial (Fin m) ℝ) = 1 := by
  classical
  rw [MvPolynomial.coeff_sum]
  rw [Finset.sum_eq_single i₀]
  · -- coeff (single i₀ 1) (X i₀) = 1
    exact MvPolynomial.coeff_X i₀
  · -- ∀ i ∈ univ, i ≠ i₀, coeff (single i₀ 1) (X i) = 0
    intros i _h_mem h_ne
    rw [MvPolynomial.coeff_X' i (Finsupp.single i₀ 1)]
    rw [if_neg]
    intro h_eq
    -- single i 1 = single i₀ 1 implies i = i₀ (via single_left_injective at value 1 ≠ 0)
    have h_inj : i = i₀ := by
      have := Finsupp.single_left_inj (b := (1 : ℕ)) (one_ne_zero) |>.mp h_eq
      exact this
    exact h_ne h_inj
  · intro h_not_mem
    exact absurd (Finset.mem_univ i₀) h_not_mem

/-! ## SM1EU-3 — Finsupp.single i₀ 1 is in support -/

/-- `Finsupp.single i₀ 1` is in the support of `∑ i, X i`. -/
theorem schmidtAuxPolyR_sumX_single_mem_support
    {m : ℕ} (i₀ : Fin m) :
    (Finsupp.single i₀ 1) ∈
        ((∑ i : Fin m, MvPolynomial.X i : MvPolynomial (Fin m) ℝ)).support := by
  rw [MvPolynomial.mem_support_iff]
  rw [schmidtAuxPolyR_sumX_coeff_one i₀]
  exact one_ne_zero

/-! ## SM1EU-4 — degreeOf positivity -/

/-- For m ≥ 1 and i₀ : Fin m, `degreeOf i₀ (∑ i, X i) ≥ 1 > 0`. -/
theorem schmidtAuxPolyR_sumX_degreeOf_pos
    {m : ℕ} (_hm : 1 ≤ m) (i₀ : Fin m) :
    0 < MvPolynomial.degreeOf i₀
        ((∑ i : Fin m, MvPolynomial.X i : MvPolynomial (Fin m) ℝ)) := by
  -- Use monomial_le_degreeOf with f = single i₀ 1
  have h_mem := schmidtAuxPolyR_sumX_single_mem_support i₀
  have h_le := MvPolynomial.monomial_le_degreeOf i₀ h_mem
  -- (Finsupp.single i₀ 1) i₀ = 1
  rw [Finsupp.single_eq_same] at h_le
  exact Nat.one_le_iff_ne_zero.mp h_le |> Nat.pos_of_ne_zero

/-! ## SM1EU-5 — nonzero -/

/-- `∑ i, X i ≠ 0` for m ≥ 1 (since degreeOf i₀ ≥ 1 > 0 = degreeOf i₀ 0). -/
theorem schmidtAuxPolyR_sumX_ne_zero
    {m : ℕ} (hm : 1 ≤ m) :
    ((schmidtAuxPolyZ_sumX m).map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 := by
  rw [schmidtAuxPolyR_sumX_eq]
  intro h_zero
  -- Pick any i₀ : Fin m (uses m ≥ 1)
  have ⟨i₀⟩ : Nonempty (Fin m) := ⟨⟨0, hm⟩⟩
  have h_pos := schmidtAuxPolyR_sumX_degreeOf_pos hm i₀
  rw [h_zero] at h_pos
  rw [MvPolynomial.degreeOf_zero] at h_pos
  exact absurd h_pos (Nat.lt_irrefl 0)

/-! ## SM1EU-6 — degreeOf positivity, mapped form -/

theorem schmidtAuxPolyR_mapped_degreeOf_pos
    {m : ℕ} (hm : 1 ≤ m) (i₀ : Fin m) :
    0 < MvPolynomial.degreeOf i₀
        ((schmidtAuxPolyZ_sumX m).map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) := by
  rw [schmidtAuxPolyR_sumX_eq]
  exact schmidtAuxPolyR_sumX_degreeOf_pos hm i₀

/-! ## SM1EU-7 — UNCONDITIONAL discharge of SM1PD-1 -/

/-- **🚨🚨🚨 SM1EU-7 — `T5_Schmidt_existence_int_poly_unconditional`**:
    UNCONDITIONAL discharge of SM1PD-1 (`T5_NAMED_Schmidt_existence_int_poly`).

    Witness: `P_int := ∑ i, X i : MvPolynomial (Fin m) ℤ` for m ≥ 1.
    Threshold: m_thresh := 1.

    Strategic significance: closes 1 of 8 atomic inner NAMED leaves of
    the V8 Roth architecture. SM-1 now reduces to a SINGLE NAMED leaf
    (the α-diagonal rothIndex lower bound — the actual analytical
    content of Schmidt aux polynomial). -/
theorem T5_Schmidt_existence_int_poly_unconditional :
    T5_NAMED_Schmidt_existence_int_poly := by
  unfold T5_NAMED_Schmidt_existence_int_poly
  intros α _hα _h_alg ε _hε
  refine ⟨1, ?_⟩
  intros m hm
  refine ⟨schmidtAuxPolyZ_sumX m, ?_, ?_⟩
  · exact schmidtAuxPolyR_sumX_ne_zero hm
  · exact fun i => schmidtAuxPolyR_mapped_degreeOf_pos hm i

/-! ## SM1EU-8 — Headline -/

/-- **🚨🚨 SM1EU-8 — `T5_SM1_EXISTENCE_UNCONDITIONAL_HEADLINE`**:
    paper-citable headline that SM1PD-1 is now UNCONDITIONALLY closed.

    Combined with SM1PD-3 (composition theorem), SM-1 now reduces to a
    SINGLE NAMED leaf: `T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound`. -/
theorem T5_SM1_EXISTENCE_UNCONDITIONAL_HEADLINE :
    T5_NAMED_Schmidt_existence_int_poly :=
  T5_Schmidt_existence_int_poly_unconditional

/-! ## SM1EU-9 — Composition: now SM-1 needs ONLY the index lower bound -/

/-- **🚨🚨🚨 SM1EU-9 — `T5_SM1_via_alpha_diagonal_index_lower_bound`**:
    SM-1 now follows from ONLY the α-diagonal index lower bound NAMED
    (existence is unconditional via SM1EU-7). -/
theorem T5_SM1_via_alpha_diagonal_index_lower_bound
    (h_index_lb : T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound) :
    T5_NAMED_Schmidt_aux_int_poly :=
  T5_SM1_via_existence_and_index_bound
    T5_Schmidt_existence_int_poly_unconditional
    h_index_lb

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_ExistenceUnconditional
