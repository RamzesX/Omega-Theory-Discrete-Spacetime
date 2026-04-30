/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockE_SequenceApplications

  T-5 (Roth's theorem) — **V7-N3 SEQUENCE APPLICATION BRIDGES**.

  Convert V7-N3 unconditional (`T5_NAMED_BlockE_bounds_collide_unconditional`,
  Set form) into ergonomic Sequence forms for downstream V7 capstone
  composition.

  Three forms:
  1. SEQ-1: V7-N3 with sequence D_seq : ℕ → ℝ instead of Set ℝ.
  2. SEQ-2: V7-N3 with explicit val sequence (lower/upper bounds).
  3. SEQ-3: V7-N3 specialized to ∏ q_i.den^{R_i} sequence with V7-N2
     and V7-N1 lower/upper bounds.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — real proofs.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyUnconditional

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockE_SequenceApplications

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_ClearanceFinalDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_PerPolyUnconditional

/-! ## SEQ-1 — V7-N3 with sequence form -/

/-- **SEQ-1 — `T5_V7N3_collide_sequence`**: V7-N3 in sequence form.

    Given an unbounded positive sequence `D_seq : ℕ → ℝ` and per-n
    constraint `1 / D_seq n ≤ C_upper · (D_seq n)^(-κ)` with κ > 1,
    derive False.

    Direct application of V7-N3 unconditional with `Set.range D_seq`. -/
theorem T5_V7N3_collide_sequence
    (C_upper κ : ℝ) (hC : 0 < C_upper) (hκ : 1 < κ)
    (D_seq : ℕ → ℝ)
    (h_pos : ∀ n, 0 < D_seq n)
    (h_unbounded : ∀ M : ℝ, ∃ n, M < D_seq n)
    (h_constraint : ∀ n, 1 / D_seq n ≤ C_upper * (D_seq n) ^ (-κ)) :
    False := by
  apply T5_NAMED_BlockE_bounds_collide_unconditional C_upper hC κ hκ
    (Set.range D_seq)
  · intro M
    obtain ⟨n, hn⟩ := h_unbounded M
    exact ⟨D_seq n, ⟨n, rfl⟩, hn⟩
  · intro d hd _hd_pos
    obtain ⟨n, hn⟩ := hd
    rw [← hn]
    exact h_constraint n

/-! ## SEQ-2 — V7-N3 with explicit val sequence (lower/upper bounds) -/

/-- **SEQ-2 — `T5_V7N3_collide_lower_upper_sequence`**: V7-N3 with
    explicit val function and separate lower/upper bounds.

    Given:
    - Unbounded positive sequence D_seq
    - val_seq : ℕ → ℝ
    - Per-n lower: 1 / D_seq n ≤ |val_seq n|
    - Per-n upper: |val_seq n| ≤ C_upper · (D_seq n)^(-κ)
    derive False.

    This is the form most directly produced by V7-N1 + V7-N2 in
    the Roth contradiction setup. -/
theorem T5_V7N3_collide_lower_upper_sequence
    (C_upper κ : ℝ) (hC : 0 < C_upper) (hκ : 1 < κ)
    (D_seq : ℕ → ℝ) (val_seq : ℕ → ℝ)
    (h_pos : ∀ n, 0 < D_seq n)
    (h_unbounded : ∀ M : ℝ, ∃ n, M < D_seq n)
    (h_lower : ∀ n, 1 / D_seq n ≤ |val_seq n|)
    (h_upper : ∀ n, |val_seq n| ≤ C_upper * (D_seq n) ^ (-κ)) :
    False := by
  apply T5_V7N3_collide_sequence C_upper κ hC hκ D_seq h_pos h_unbounded
  intro n
  exact le_trans (h_lower n) (h_upper n)

/-! ## SEQ-3 — V7-N3 with V7-N2 lower bound baked in (per-poly) -/

/-- **SEQ-3 — `T5_V7N3_collide_with_V7N2_lower_per_poly`**: V7-N3
    with V7-N2 (unconditional) lower bound automatically applied
    for a per-polynomial Roth setup.

    Given a polynomial p : MvPolynomial (Fin m) ℤ, sequence of
    m-tuples q_seq, and an upper bound chain with parameters
    (C_upper, κ), derive False — the V7-N2 lower bound is provided
    automatically via `T5_BlockD_lower_bound_per_p_unconditional`. -/
theorem T5_V7N3_collide_with_V7N2_lower_per_poly
    {m : ℕ} (hm : 1 ≤ m)
    (p : MvPolynomial (Fin m) ℤ) (q_seq : ℕ → Fin m → ℚ)
    (C_upper κ : ℝ) (hC : 0 < C_upper) (hκ : 1 < κ)
    -- Per-n hypothesis: aeval ≠ 0
    (h_eval_ne : ∀ n, aeval (fun i => ((q_seq n i : ℚ) : ℝ))
      ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0)
    -- D_seq from per-n product
    (h_unbounded : ∀ M : ℝ, ∃ n,
      M < ∏ i, ((q_seq n i).den : ℝ) ^
        (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ))
    -- Per-n upper bound (from V7-N1 application)
    (h_upper : ∀ n,
      |aeval (fun i => ((q_seq n i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ)| ≤
        C_upper * (∏ i, ((q_seq n i).den : ℝ) ^
          (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) ^ (-κ)) :
    False := by
  -- Set up sequences
  set D_seq : ℕ → ℝ := fun n => ∏ i, ((q_seq n i).den : ℝ) ^
    (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)
  set val_seq : ℕ → ℝ := fun n => aeval (fun i => ((q_seq n i : ℚ) : ℝ))
    ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ)
  -- D_seq positivity (DPP-4)
  have h_D_pos : ∀ n, 0 < D_seq n := fun n =>
    OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity.T5_tuple_qden_pow_prod_pos
      (q_seq n)
      (fun i => MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)))
  -- V7-N2 lower bound per n (DPU-1)
  have h_lower : ∀ n, 1 / D_seq n ≤ |val_seq n| := fun n =>
    T5_BlockD_lower_bound_per_p_unconditional hm p (q_seq n) (h_eval_ne n)
  -- Apply SEQ-2
  exact T5_V7N3_collide_lower_upper_sequence C_upper κ hC hκ D_seq val_seq
    h_D_pos h_unbounded h_lower h_upper

/-! ## SEQ-4 — Headline -/

/-- **🚨🚨 SEQ-4 — `T5_V7_BLOCK_E_SEQUENCE_APPLICATIONS_HEADLINE`**:
    paper-citable bundle of V7-N3 sequence application bridges.

    Strategic significance: provides ergonomic forms for V7 capstone
    composition.  When V7-N1 lands and produces an upper bound for a
    sequence of q-tuples, applying SEQ-3 (which has V7-N2 baked in)
    directly gives the Block E contradiction. -/
theorem T5_V7_BLOCK_E_SEQUENCE_APPLICATIONS_HEADLINE :
    -- (a) SEQ-1: V7-N3 sequence form
    (∀ (C_upper κ : ℝ), 0 < C_upper → 1 < κ →
      ∀ (D_seq : ℕ → ℝ),
      (∀ n, 0 < D_seq n) →
      (∀ M : ℝ, ∃ n, M < D_seq n) →
      (∀ n, 1 / D_seq n ≤ C_upper * (D_seq n) ^ (-κ)) →
      False) ∧
    -- (b) SEQ-2: lower/upper sequence form
    (∀ (C_upper κ : ℝ), 0 < C_upper → 1 < κ →
      ∀ (D_seq val_seq : ℕ → ℝ),
      (∀ n, 0 < D_seq n) →
      (∀ M : ℝ, ∃ n, M < D_seq n) →
      (∀ n, 1 / D_seq n ≤ |val_seq n|) →
      (∀ n, |val_seq n| ≤ C_upper * (D_seq n) ^ (-κ)) →
      False) :=
  ⟨fun C_upper κ hC hκ D_seq h_pos h_unbd h_constr =>
     T5_V7N3_collide_sequence C_upper κ hC hκ D_seq h_pos h_unbd h_constr,
   fun C_upper κ hC hκ D_seq val_seq h_pos h_unbd h_lower h_upper =>
     T5_V7N3_collide_lower_upper_sequence C_upper κ hC hκ D_seq val_seq
       h_pos h_unbd h_lower h_upper⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockE_SequenceApplications
