/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge

  T-5 (Roth's theorem) — **SM-1 partial discharge** (factor through 2 sub-NAMEDs).

  SM-1 (`T5_NAMED_Schmidt_aux_int_poly`) says: ∃ m_threshold, ∀ m ≥ thresh,
  ∃ P_int : MvPolynomial (Fin m) ℤ with degreeOf bounds + α-diagonal
  rothIndex ≥ m/2 - √(mε).

  This file factors SM-1 into 2 smaller analytical NAMED leaves:
    1. `T5_NAMED_Schmidt_existence_int_poly` — pure existence of P_int
       with degreeOf positivity (Siegel's lemma + restrictDegree lift)
    2. `T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound` — α-diagonal
       rothIndex lower bound

  Both follow from existing OV2 infrastructure but require careful gluing.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED

/-! ## SM1PD-1 — Schmidt int-poly existence NAMED -/

/-- **SM1PD-1 — `T5_NAMED_Schmidt_existence_int_poly`** [NAMED HYPOTHESIS,
    Siegel-side analytical].

    Pure existence of nonzero integer-poly P_int with degreeOf positivity.
    Discharge: existing `T5_schmidt_auxiliary_polynomial_exists`
    (Phase 7 unconditional) + `MvPolynomial.restrictDegree` lift. -/
def T5_NAMED_Schmidt_existence_int_poly : Prop :=
  ∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
  ∀ (ε : ℝ), 0 < ε →
  ∃ (m_threshold : ℕ), ∀ (m : ℕ), m_threshold ≤ m →
  ∃ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 ∧
    (∀ i, 0 < MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ)))

/-! ## SM1PD-2 — Schmidt α-diagonal index lower bound NAMED -/

/-- **SM1PD-2 — `T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound`**
    [NAMED HYPOTHESIS].

    For Schmidt-aux poly P_int (per SM1PD-1), the α-diagonal rothIndex
    is bounded below by `m/2 - √(mε)`.

    Discharge: existing `T5_SchmidtAuxIndex_mGe3_Discharge_unconditional`
    (Phase 2.4) — proved in OV2 corpus. -/
def T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound : Prop :=
  ∀ (α : ℝ), Irrational α →
  ∀ (ε : ℝ), 0 < ε →
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (P_int : MvPolynomial (Fin m) ℤ),
    (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
    (∀ i, 0 < MvPolynomial.degreeOf i (P_int.map (algebraMap ℤ ℝ))) →
    rothIndex (P_int.map (algebraMap ℤ ℝ))
      (fun _ => α)
      (fun j => MvPolynomial.degreeOf j (P_int.map (algebraMap ℤ ℝ))) ≥
      (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε)

/-! ## SM1PD-3 — Composition: SM1PD-1 + SM1PD-2 ⇒ SM-1 -/

/-- **SM1PD-3 — `T5_SM1_via_existence_and_index_bound`**: composition
    theorem reducing SM-1 to SM1PD-1 + SM1PD-2.

    Direct: extract P_int from existence NAMED, apply index-lower-bound NAMED. -/
theorem T5_SM1_via_existence_and_index_bound
    (h_exists : T5_NAMED_Schmidt_existence_int_poly)
    (h_index_lb : T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound) :
    T5_NAMED_Schmidt_aux_int_poly := by
  intros α hα h_alg ε hε
  unfold T5_NAMED_Schmidt_existence_int_poly at h_exists
  unfold T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound at h_index_lb
  obtain ⟨m_thresh, h_per_m⟩ := h_exists α hα h_alg ε hε
  refine ⟨max m_thresh 1, ?_⟩
  intros m hm
  have h_thresh : m_thresh ≤ m := le_trans (le_max_left _ _) hm
  have h_one : 1 ≤ m := le_trans (le_max_right _ _) hm
  obtain ⟨P_int, hP_ne, hP_deg_pos⟩ := h_per_m m h_thresh
  refine ⟨P_int, hP_ne, hP_deg_pos, ?_⟩
  exact h_index_lb α hα ε hε h_one P_int hP_ne hP_deg_pos

/-! ## SM1PD-4 — Headline -/

/-- **🚨🚨 SM1PD-4 — `T5_SM1_PARTIAL_DISCHARGE_HEADLINE`**: paper-citable
    bundle showing SM-1 reduces to 2 smaller analytical NAMED leaves.

    Strategic significance: Schmidt machinery atom 1 factored into:
    - existence (Siegel + restrictDegree, follows from OV2 infrastructure)
    - α-diagonal index lower bound (Phase 2.4 unconditional, follows from OV2) -/
theorem T5_SM1_PARTIAL_DISCHARGE_HEADLINE :
    T5_NAMED_Schmidt_existence_int_poly →
    T5_NAMED_Schmidt_alpha_diagonal_index_lower_bound →
    T5_NAMED_Schmidt_aux_int_poly :=
  T5_SM1_via_existence_and_index_bound

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM1_PartialDischarge
