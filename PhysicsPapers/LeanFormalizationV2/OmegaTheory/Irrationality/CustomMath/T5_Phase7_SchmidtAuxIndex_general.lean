/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general

  T-5 (Roth's theorem) — **GENERAL m structural Schmidt aux scaffold**.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Structural infrastructure for the m≥3 + m≥4 cases:
  - `T5_schmidtAuxPoly_general m α := ∏ i : Fin m, (X i - C α)` — the
    canonical aux poly construction that works for all m.
  - `T5_exists_zero_of_sum_lt` — pigeonhole: sum < m ⇒ ∃ k with j k = 0.
  - `T5_schmidtAuxPoly_general_aeval_at_alpha` — P_m vanishes at (α,...,α).
  - `T5_schmidtAuxPoly_general_degreeOf` — degreeOf bound for ALL m.
  - `T5_schmidtAuxPoly_general_ne_zero` — P_m ≠ 0 for m ≥ 1.

  Plus two NAMED Props for the deep analytical content:
  - `T5_SchmidtAuxIndex_factor_preserved_NAMED` — multiIteratedPDeriv j
    preserves the (X k - C α) factor when j k = 0.
  - `T5_SchmidtAuxIndex_AllOnesNonZero_NAMED` — multiIteratedPDeriv on
    all-ones gives 1.

  Per project rule §7.0 NO STUBS — both NAMED Props are real Props
  with explicit construction plans.

  ## Why this scaffold suffices for m=3 + m≥4

  Once the two NAMED Props are discharged, the rothIndex bound for ANY
  m ≥ 1 follows uniformly:
  - Non-emptiness via the all-ones witness (∑ = m).
  - Universal vanish via factor preservation + sum < m/2 < m bound.

  Discharge plans documented inline.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general

open MvPolynomial Real Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndexZeroJ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothIndexLeOfSubsetVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_m3

/-! ## General aux poly P_m via Finset.prod -/

/-- The Schmidt aux poly P_m := ∏_{i ∈ Fin m} (X i - C α). -/
noncomputable def T5_schmidtAuxPoly_general (m : ℕ) (α : ℝ) :
    MvPolynomial (Fin m) ℝ :=
  ∏ i : Fin m, (X i - C α)

/-! ## Pigeonhole: sum < m ⇒ ∃ k with j k = 0 -/

theorem T5_exists_zero_of_sum_lt {m : ℕ} (j : Fin m → ℕ)
    (h : ∑ i : Fin m, j i < m) : ∃ k : Fin m, j k = 0 := by
  by_contra h_all_pos
  push_neg at h_all_pos
  have h_each_ge_one : ∀ k : Fin m, 1 ≤ j k := by
    intro k
    exact Nat.one_le_iff_ne_zero.mpr (h_all_pos k)
  have h_sum_ge : m ≤ ∑ i : Fin m, j i := by
    calc m = ∑ _ : Fin m, 1 := by simp
      _ ≤ ∑ i : Fin m, j i := Finset.sum_le_sum (fun i _ => h_each_ge_one i)
  omega

/-! ## P_m vanishes at (α, ..., α) -/

theorem T5_schmidtAuxPoly_general_aeval_at_alpha (m : ℕ) (α : ℝ) (h_m : 0 < m) :
    aeval (fun _ : Fin m => α) (T5_schmidtAuxPoly_general m α) = 0 := by
  unfold T5_schmidtAuxPoly_general
  rw [map_prod]
  apply Finset.prod_eq_zero (i := ⟨0, h_m⟩) (Finset.mem_univ _)
  simp

/-! ## degreeOf bound for general P_m -/

theorem T5_schmidtAuxPoly_general_degreeOf (m : ℕ) (α : ℝ) (i : Fin m) :
    MvPolynomial.degreeOf i (T5_schmidtAuxPoly_general m α) ≤ 1 := by
  unfold T5_schmidtAuxPoly_general
  have h_each : ∀ k : Fin m, MvPolynomial.degreeOf i (X k - C α : MvPolynomial (Fin m) ℝ) ≤
      if i = k then 1 else 0 := by
    intro k
    calc MvPolynomial.degreeOf i (X k - C α : MvPolynomial (Fin m) ℝ)
        ≤ max (MvPolynomial.degreeOf i (X k : MvPolynomial (Fin m) ℝ))
               (MvPolynomial.degreeOf i (C α : MvPolynomial (Fin m) ℝ)) :=
          MvPolynomial.degreeOf_sub_le i (X k) (C α)
      _ ≤ if i = k then 1 else 0 := by
          rw [MvPolynomial.degreeOf_X i k, MvPolynomial.degreeOf_C]
          by_cases hik : i = k
          · subst hik; simp
          · simp [if_neg hik]
  calc MvPolynomial.degreeOf i (∏ k : Fin m, (X k - C α : MvPolynomial (Fin m) ℝ))
      ≤ ∑ k : Fin m, MvPolynomial.degreeOf i (X k - C α : MvPolynomial (Fin m) ℝ) :=
        MvPolynomial.degreeOf_prod_le i (s := (Finset.univ : Finset (Fin m)))
          (f := fun k => X k - C α)
    _ ≤ ∑ k : Fin m, (if i = k then 1 else 0) :=
        Finset.sum_le_sum (fun k _ => h_each k)
    _ = 1 := by
        simp [Finset.sum_ite_eq, Finset.mem_univ]

/-! ## P_m ≠ 0 -/

theorem T5_schmidtAuxPoly_general_ne_zero (m : ℕ) (_h_m : 0 < m) (α : ℝ) :
    T5_schmidtAuxPoly_general m α ≠ 0 := by
  intro h_eq
  have h : aeval (fun _ : Fin m => (α + 1 : ℝ)) (T5_schmidtAuxPoly_general m α) = 1 := by
    unfold T5_schmidtAuxPoly_general
    rw [map_prod]
    apply Finset.prod_eq_one
    intros i _
    simp
  rw [h_eq] at h
  simp at h

/-! ## NAMED Prop 1: factor preservation -/

/-- **`T5_SchmidtAuxIndex_factor_preserved_NAMED`** [NAMED — to discharge].

    The structural fact: for any j : Fin m → ℕ with j k = 0 for some
    k : Fin m, the (X k - C α) factor is preserved in
    `multiIteratedPDeriv j (∏ i, (X i - C α))`, so the result vanishes
    at (α, ..., α).

    **Discharge plan**:
    1. Define helper: `pderiv i ((X k - C α) * Q) = (X k - C α) * pderiv i Q`
       when i ≠ k. (Via Leibniz + smul_eq_mul + pderiv_X off-diag = 0.)
    2. Induction on the foldr structure: at each step, either i = k
       (apply (pderiv k)^[0] = id, factor preserved) or i ≠ k (apply
       pderiv i, factor preserved by the helper).
    3. Final aeval: factor (α - α) = 0.

    Per project rule §7.0: real ∀-quantified Prop with non-vacuous
    content. -/
def T5_SchmidtAuxIndex_factor_preserved_NAMED : Prop :=
  ∀ (m : ℕ) (α : ℝ) (j : Fin m → ℕ),
    (∃ k : Fin m, j k = 0) →
    aeval (fun _ : Fin m => α)
      (multiIteratedPDeriv j (T5_schmidtAuxPoly_general m α)) = 0

/-! ## NAMED Prop 2: all-ones gives non-zero -/

/-- **`T5_SchmidtAuxIndex_AllOnesNonZero_NAMED`** [NAMED — to discharge].

    For any m ≥ 1: aeval at (α, ..., α) of multiIteratedPDeriv (const 1) P_m
    is 1 (not 0).

    **Discharge plan**: induction on m.
    - m=0: vacuous.
    - m=1: shown in `T5_Phase7_SchmidtAuxIndex_m1`.
    - m=2: shown in `T5_Phase7_SchmidtAuxIndex_m2_Discharge`.
    - m≥3: induction step using the m-1 case + factor decomposition.

    Per project rule §7.0. -/
def T5_SchmidtAuxIndex_AllOnesNonZero_NAMED : Prop :=
  ∀ (m : ℕ) (α : ℝ),
    aeval (fun _ : Fin m => α)
      (multiIteratedPDeriv (fun _ : Fin m => 1) (T5_schmidtAuxPoly_general m α)) = 1

/-! ## Universal vanish for sum < m via factor preservation -/

theorem T5_schmidtAuxPoly_general_aeval_zero_of_sum_lt
    (h_factor : T5_SchmidtAuxIndex_factor_preserved_NAMED)
    (m : ℕ) (α : ℝ) (j : Fin m → ℕ) (h_sum : ∑ i : Fin m, j i < m) :
    aeval (fun _ : Fin m => α)
      (multiIteratedPDeriv j (T5_schmidtAuxPoly_general m α)) = 0 := by
  obtain ⟨k, hk⟩ := T5_exists_zero_of_sum_lt j h_sum
  exact h_factor m α j ⟨k, hk⟩

/-! ## rothIndex bound for general m via the two NAMED Props -/

theorem T5_schmidtAuxPoly_general_rothIndex_ge
    (h_factor : T5_SchmidtAuxIndex_factor_preserved_NAMED)
    (h_allones : T5_SchmidtAuxIndex_AllOnesNonZero_NAMED)
    (α : ℝ) (m : ℕ) (h_m : 0 < m) (ε : ℝ) (_hε : 0 < ε) :
    rothIndex (T5_schmidtAuxPoly_general m α) (fun _ : Fin m => α)
      (fun _ : Fin m => 1) ≥ (m : ℝ) / 2 - Real.sqrt ((m : ℝ) * ε) := by
  rw [ge_iff_le]
  -- Non-emptiness witness: j = const 1, gives aeval = 1 ≠ 0, ∑ = m.
  have h_non_empty : { r : ℝ | ∃ j : Fin m → ℕ,
      aeval (fun _ : Fin m => α) (multiIteratedPDeriv j (T5_schmidtAuxPoly_general m α)) ≠ 0 ∧
      r = ∑ i, (j i : ℝ) / ((1 : ℕ) : ℝ) }.Nonempty := by
    refine ⟨(m : ℝ), fun _ => 1, ?_, ?_⟩
    · rw [h_allones]; exact one_ne_zero
    · simp
  rw [T5_rothIndex_ge_iff_all_lt_vanish _ _ _ h_non_empty]
  intro j hj_lt
  -- ∑ ji/1 = ∑ ji as ℝ
  have h_simp : ∑ i : Fin m, (j i : ℝ) / ((fun _ : Fin m => (1 : ℕ)) i : ℝ) =
      ((∑ i : Fin m, j i : ℕ) : ℝ) := by
    push_cast
    simp
  rw [h_simp] at hj_lt
  -- hj_lt : ((∑ i, j i : ℕ) : ℝ) < (m : ℝ) / 2 - √(m·ε) ≤ (m : ℝ) / 2
  set sε := Real.sqrt ((m : ℝ) * ε) with hsε
  have h_sε_nn : 0 ≤ sε := Real.sqrt_nonneg _
  have h_simp_t : (m : ℝ) / 2 - sε ≤ (m : ℝ) / 2 := by linarith
  have h_jsum_lt : ((∑ i : Fin m, j i : ℕ) : ℝ) < (m : ℝ) / 2 :=
    lt_of_lt_of_le hj_lt h_simp_t
  -- (m : ℝ) / 2 < m for m ≥ 1
  have h_jsum_lt_m : ((∑ i : Fin m, j i : ℕ) : ℝ) < (m : ℝ) := by
    have h_half_lt_m : (m : ℝ) / 2 < (m : ℝ) := by
      have : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast h_m
      linarith
    linarith
  have h_jsum_lt_m_nat : ∑ i : Fin m, j i < m := by exact_mod_cast h_jsum_lt_m
  exact T5_schmidtAuxPoly_general_aeval_zero_of_sum_lt h_factor m α j h_jsum_lt_m_nat

/-! ## NAMED hypothesis for m≥3 + m≥4 closure via the structural NAMEDs -/

/-- **`T5_SchmidtAuxIndex_mGe3_via_general`** — composes the two NAMED
    Props into m≥3 sub-NAMED discharge. -/
theorem T5_SchmidtAuxIndex_mGe3_via_general
    (h_factor : T5_SchmidtAuxIndex_factor_preserved_NAMED)
    (h_allones : T5_SchmidtAuxIndex_AllOnesNonZero_NAMED) :
    T5_SchmidtAuxIndex_mGe3_Discharge := by
  intros α _hα _h_alg ε hε m hm
  refine ⟨T5_schmidtAuxPoly_general m α, fun _ => 1, ?_, ?_, ?_, ?_⟩
  · exact T5_schmidtAuxPoly_general_ne_zero m (by omega) α
  · exact T5_schmidtAuxPoly_general_degreeOf m α
  · intro _; exact Nat.one_pos
  · exact T5_schmidtAuxPoly_general_rothIndex_ge h_factor h_allones α m (by omega) ε hε

/-! ## Headline -/

/-- **🚨 HEADLINE — m=3 + m≥4 GENERAL structural decomposition**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.4 m≥3 closure scaffold.

    Net: T5_SchmidtAuxIndex_mGe3_Discharge is now reduced to TWO
    structural NAMED Props that handle ALL m ≥ 3 simultaneously:
    1. `T5_SchmidtAuxIndex_factor_preserved_NAMED` — factor preservation
    2. `T5_SchmidtAuxIndex_AllOnesNonZero_NAMED` — all-ones non-zero

    Both NAMEDs have explicit discharge plans documented in their
    docstrings.  Once discharged in successor 10-min ticks, m=3 and
    ALL m≥4 cases close uniformly.

    Sub-lemma 298/N in T-5 Phase 7.  Lean-core only.  NO STUBS — both
    NAMEDs are real ∀-quantified Props with non-vacuous content. -/
theorem session_W2_phase_2_4_general_scaffold_headline :
    T5_SchmidtAuxIndex_factor_preserved_NAMED →
    T5_SchmidtAuxIndex_AllOnesNonZero_NAMED →
    T5_SchmidtAuxIndex_mGe3_Discharge :=
  T5_SchmidtAuxIndex_mGe3_via_general

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxIndex_general
