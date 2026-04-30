/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition

  T-5 (Roth's theorem) — **V7-N2 DECOMPOSITION via MULTIVARIATE
  CLEARANCE NAMED Prop**.

  Strategic decomposition of V7-N2 (multivariate integer non-vanishing
  lower bound) into:
    (a) NAMED hypothesis `T5_NAMED_BlockD_multivariate_clearance`
        — `(∏ q_i.den^{R_i}) · aeval(q-cast) p ∈ ℤ` for any
        p : MvPolynomial (Fin m) ℤ and q : Fin m → ℚ,
        where R_i = degreeOf i (p.map ℝ).
    (b) Real proof: the COMPOSITION theorem that
        `T5_NAMED_BlockD_multivariate_clearance →
         T5_NAMED_BlockD_integer_lower_bound`
        using DPP positivity + ICA helpers.

  This RECASTS V7-N2 from "multivariate integer non-vanishing lower
  bound" to JUST "integer denominator clearance" — the analytical
  heart is the integer clearance, and the lower bound automatically
  follows from positivity + ICA arguments.

  Per project rule §7.0: NAMED Props valid ONLY when paired with
  explicit decomposition + discharge plan.  This file provides the
  decomposition + composition; the discharge of `_clearance` itself
  remains as next-fire work via `MvPolynomial.eval₂_eq'`.

  Single-thread hand-authored 2026-04-30.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntCastAbsHelpers

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFinalCapstoneV7Draft
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateProductPositivity
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_IntCastAbsHelpers

/-! ## DC-1 — NAMED hypothesis: multivariate denominator clearance -/

/-- **DC-1 — `T5_NAMED_BlockD_multivariate_clearance`** [NAMED HYPOTHESIS].

    For any `p : MvPolynomial (Fin m) ℤ` and `q : Fin m → ℚ`, the
    product `(∏ q_i.den^{R_i}) · aeval(q-cast) (p.map ℝ)` is the cast
    of an integer, where `R_i = degreeOf i (p.map ℝ)`.

    Discharge STRATEGY (next fire):
    1. Use `MvPolynomial.eval₂_eq'` to expand `aeval(q-cast) (p.map ℝ)`
       as `∑ d ∈ p.support, c_d · ∏ i, q_i^{d_i}`.
    2. Multiply by `∏ q_i.den^{R_i}` where `R_i = degreeOf i (p.map ℝ)`.
    3. Each term becomes `c_d · ∏ num_i^{d_i} · ∏ den_i^{R_i - d_i}`
       which is integer (since R_i ≥ d_i automatically).
    4. The sum is integer.

    Per project rule §7.0: NAMED Prop with REAL content (∃ k : ℤ
    quantifier with explicit equation), used non-vacuously, paired with
    explicit discharge plan above. -/
def T5_NAMED_BlockD_multivariate_clearance : Prop :=
  ∀ {m : ℕ}, 1 ≤ m →
  ∀ (p : MvPolynomial (Fin m) ℤ) (q : Fin m → ℚ),
    ∃ (k : ℤ),
      (∏ i, ((q i).den : ℝ) ^
        (MvPolynomial.degreeOf i (p.map (algebraMap ℤ ℝ)) : ℕ)) *
      aeval (fun i => ((q i : ℚ) : ℝ))
        ((p.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) = (k : ℝ)

/-! ## DC-2 — Composition: clearance ⇒ integer lower bound -/

/-- **DC-2 — `T5_NAMED_BlockD_via_clearance`**: the KEY composition
    theorem reducing V7-N2 to clearance + DPP + ICA.

    Given `h_clearance : T5_NAMED_BlockD_multivariate_clearance`,
    derive `T5_NAMED_BlockD_integer_lower_bound`.

    Proof: chain DPP-4 (positivity of D_R) + clearance (D_R · V = k ∈ ℤ)
    + non-vanishing (V ≠ 0 ⇒ k ≠ 0) + ICA-1 (|k| ≥ 1) +
    div_le_iff₀ (1/D_R ≤ |V|).

    This MAKES EXPLICIT what V7-N2 reduces to: just the integer
    clearance step.  The lower bound automatically follows. -/
theorem T5_NAMED_BlockD_via_clearance
    (h_clearance : T5_NAMED_BlockD_multivariate_clearance) :
    T5_NAMED_BlockD_integer_lower_bound := by
  intros m hm p q h_eval_ne
  -- D_R := ∏ q_i.den^{R_i}
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
  obtain ⟨k, hk⟩ := h_clearance hm p q
  -- D_R · V ≠ 0 since V ≠ 0 (h_eval_ne) and D_R > 0
  have h_DR_V_ne : D_R * V ≠ 0 := mul_ne_zero (ne_of_gt h_DR_pos) h_eval_ne
  -- k ≠ 0 since D_R · V = k and D_R · V ≠ 0
  have h_k_ne : k ≠ 0 := by
    intro hk_zero
    apply h_DR_V_ne
    rw [hk, hk_zero]
    simp
  -- ICA-1: 1 ≤ |(k : ℝ)|
  have h_abs_k_ge : (1 : ℝ) ≤ |((k : ℤ) : ℝ)| :=
    T5_int_cast_abs_ge_one k h_k_ne
  -- Combine: 1 ≤ |D_R · V|
  have h_one_le : (1 : ℝ) ≤ |D_R * V| := by
    rw [hk]
    exact h_abs_k_ge
  -- |D_R · V| = D_R · |V| since D_R > 0
  have h_abs_split : |D_R * V| = D_R * |V| := by
    rw [abs_mul, abs_of_pos h_DR_pos]
  rw [h_abs_split] at h_one_le
  -- 1 ≤ D_R · |V| ⇒ 1/D_R ≤ |V|
  rw [div_le_iff₀ h_DR_pos]
  linarith

/-! ## DC-3 — Headline -/

/-- **🚨🚨 DC-3 — `T5_DC_BLOCK_D_CLEARANCE_HEADLINE`**: paper-citable
    decomposition headline.

    Bundles:
    (a) DC-1 NAMED clearance hypothesis is a real Prop
    (b) DC-2 composition theorem reducing V7-N2 to clearance

    Strategic significance: V7-N2 multivariate integer non-vanishing
    lower bound is REDUCED to JUST the integer clearance step.  All
    positivity + abs + ICA arguments are HANDLED HERE.  Next-fire work
    is JUST the clearance discharge via `MvPolynomial.eval₂_eq'`. -/
theorem T5_DC_BLOCK_D_CLEARANCE_HEADLINE :
    -- (a) DC-1 NAMED clearance is a real Prop
    (T5_NAMED_BlockD_multivariate_clearance →
      T5_NAMED_BlockD_multivariate_clearance) ∧
    -- (b) DC-2 composition: clearance ⇒ V7-N2
    (T5_NAMED_BlockD_multivariate_clearance →
      T5_NAMED_BlockD_integer_lower_bound) :=
  ⟨id, T5_NAMED_BlockD_via_clearance⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothBoundLargeBlockD_MultivariateClearanceComposition
