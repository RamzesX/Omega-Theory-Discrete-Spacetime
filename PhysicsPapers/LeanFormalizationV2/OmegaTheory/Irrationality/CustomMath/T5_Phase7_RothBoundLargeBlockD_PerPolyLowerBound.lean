/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound

  T-5 (Roth's theorem) — **V7-N2 PER-POLYNOMIAL LOWER BOUND**.

  Per-polynomial version of `T5_NAMED_BlockD_via_clearance`: takes a
  per-polynomial clearance witness (for a SPECIFIC p, NOT universal)
  and derives the V7-N2 lower bound for THAT p.

  Critical for V7-N2 framework application: lets us apply the V7-N2
  conclusion to specific concrete polynomials (e.g., X i, C c, monomial
  d c) once we have their individual clearance witnesses.

  Combined with DCX-2 (X i clearance) and DCC-1 (constant clearance),
  this lands V7-N2 conclusion for the corresponding polynomial cases.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proof.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntCastAbsHelpers
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceConstantCase
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceXVariableCase

/-! ## PPL-1 — Per-polynomial lower bound from per-clearance -/

/-- **PPL-1 — `T5_BlockD_lower_bound_from_clearance`**: per-polynomial
    V7-N2 lower bound derived from per-polynomial clearance witness.

    Given p : MvPolynomial (Fin m) ℤ, q : Fin m → ℚ, and:
    (1) per-p clearance: ∃ k : ℤ, D_R · aeval(q-cast)(p.map ℝ) = (k : ℝ)
    (2) non-vanishing: aeval(q-cast)(p.map ℝ) ≠ 0
    derive:
      1 / D_R ≤ |aeval(q-cast)(p.map ℝ)|

    where D_R = ∏ q_i.den^{degreeOf i (p.map ℝ)}.

    This is the per-polynomial form of `T5_NAMED_BlockD_via_clearance`
    (which is universal). Useful for applying V7-N2 conclusion to
    specific polynomials. -/
theorem T5_BlockD_lower_bound_from_clearance
    {m : ℕ} (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ)
    (h_clearance : ∃ k : ℤ,
      (∏ i, ((q i).den : ℝ) ^
        (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) *
      aeval (fun i => ((q i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) = (k : ℝ))
    (h_eval_ne : aeval (fun i => ((q i : ℚ) : ℝ))
      ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) :
    1 / (∏ i, ((q i).den : ℝ) ^
      (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun i => ((q i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ)| := by
  set D_R : ℝ := ∏ i, ((q i).den : ℝ) ^
    (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ) with hD_R_def
  set V : ℝ := aeval (fun i => ((q i : ℚ) : ℝ))
    ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) with hV_def
  -- DPP-4: D_R > 0
  have h_DR_pos : 0 < D_R := by
    rw [hD_R_def]
    exact T5_tuple_qden_pow_prod_pos q
      (fun i => MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)))
  -- Clearance: ∃ k : ℤ, D_R · V = (k : ℝ)
  obtain ⟨k, hk⟩ := h_clearance
  -- D_R · V ≠ 0
  have h_DR_V_ne : D_R * V ≠ 0 := mul_ne_zero (ne_of_gt h_DR_pos) h_eval_ne
  -- k ≠ 0
  have h_k_ne : k ≠ 0 := by
    intro hk_zero
    apply h_DR_V_ne
    rw [hk, hk_zero]
    simp
  -- ICA-1: 1 ≤ |(k : ℝ)|
  have h_abs_k_ge : (1 : ℝ) ≤ |((k : ℤ) : ℝ)| :=
    T5_int_cast_abs_ge_one k h_k_ne
  -- 1 ≤ |D_R · V|
  have h_one_le : (1 : ℝ) ≤ |D_R * V| := by rw [hk]; exact h_abs_k_ge
  -- |D_R · V| = D_R · |V|
  have h_abs_split : |D_R * V| = D_R * |V| := by
    rw [abs_mul, abs_of_pos h_DR_pos]
  rw [h_abs_split] at h_one_le
  -- Conclude 1/D_R ≤ |V|
  rw [div_le_iff₀ h_DR_pos]
  linarith

/-! ## PPL-2 — Application: V7-N2 lower bound for p = X i -/

/-- **PPL-2 — `T5_BlockD_lower_bound_for_X`**: V7-N2 conclusion for
    `p = MvPolynomial.X i`.

    Direct application of PPL-1 with DCX-2 clearance witness. -/
theorem T5_BlockD_lower_bound_for_X
    {m : ℕ} (i : Fin m) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun j => ((q j : ℚ) : ℝ))
      (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
        (algebraMap ℤ ℝ))) ≠ 0) :
    1 / (∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j
        ((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)))| :=
  T5_BlockD_lower_bound_from_clearance _ q
    (T5_BlockD_clearance_X i q) h_eval_ne

/-! ## PPL-3 — Application: V7-N2 lower bound for p = C c (constant) -/

/-- **PPL-3 — `T5_BlockD_lower_bound_for_constant`**: V7-N2 conclusion
    for `p = MvPolynomial.C c`.

    Direct application of PPL-1 with DCC-1 clearance witness. -/
theorem T5_BlockD_lower_bound_for_constant
    {m : ℕ} (c : ℤ) (q : Fin m → ℚ)
    (h_eval_ne : aeval (fun j => ((q j : ℚ) : ℝ))
      (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
        (algebraMap ℤ ℝ))) ≠ 0) :
    1 / (∏ j, ((q j).den : ℝ) ^
      (MvPolynomial.degreeOf j
        ((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)) : ℕ)) ≤
      |aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ)))| :=
  T5_BlockD_lower_bound_from_clearance _ q
    (T5_BlockD_clearance_constant c q) h_eval_ne

/-! ## PPL-4 — Headline -/

/-- **🚨🚨 PPL-4 — `T5_PPL_BLOCK_D_PER_POLY_LOWER_BOUND_HEADLINE`**:
    paper-citable bundle of the per-polynomial V7-N2 lower bound + 2
    concrete applications.

    Strategic significance: PPL-1 IS the workhorse — given a per-p
    clearance witness, V7-N2 conclusion follows automatically.  PPL-2
    and PPL-3 demonstrate this for specific polynomials.

    Validates that the V7-N2 framework correctly composes: clearance
    witness + non-vanishing → integer non-vanishing lower bound. -/
theorem T5_PPL_BLOCK_D_PER_POLY_LOWER_BOUND_HEADLINE :
    -- (a) PPL-1: per-p lower bound from per-p clearance
    (∀ {m : ℕ} (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ),
      (∃ k : ℤ,
        (∏ i, ((q i).den : ℝ) ^
          (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) *
        aeval (fun i => ((q i : ℚ) : ℝ))
          ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) = (k : ℝ)) →
      aeval (fun i => ((q i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      1 / (∏ i, ((q i).den : ℝ) ^
        (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun i => ((q i : ℚ) : ℝ))
          ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ)|) ∧
    -- (b) PPL-2: V7-N2 for p = X i
    (∀ {m : ℕ} (i : Fin m) (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) ≠ 0 →
      1 / (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          ((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.X i : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)))|) ∧
    -- (c) PPL-3: V7-N2 for p = C c
    (∀ {m : ℕ} (c : ℤ) (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
          (algebraMap ℤ ℝ))) ≠ 0 →
      1 / (∏ j, ((q j).den : ℝ) ^
        (MvPolynomial.degreeOf j
          ((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)) : ℕ)) ≤
        |aeval (fun j => ((q j : ℚ) : ℝ))
          (((MvPolynomial.C c : MvPolynomial (Fin m) ℤ).map
            (algebraMap ℤ ℝ)))|) :=
  ⟨fun {m} p q => T5_BlockD_lower_bound_from_clearance p q,
   fun {m} i q => T5_BlockD_lower_bound_for_X i q,
   fun {m} c q => T5_BlockD_lower_bound_for_constant c q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyLowerBound
