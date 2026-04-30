/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_PartialDischarge

  T-5 (Roth's theorem) — **UWF-2 partial discharge** (factor through Taylor identity).

  UWF-2 (`T5_NAMED_support_extraction_at_zero`) says: Q ≠ 0 ⇒ ∃ J,
  aeval 0 (multiIteratedPDeriv J Q) ≠ 0.

  This file factors UWF-2 through the Taylor-coefficient identity:
    aeval 0 (multiIteratedPDeriv J Q) = J! · Q.coeff J     (∀ J)

  Given that identity, the discharge is direct: pick J ∈ Q.support
  (which is nonempty since Q ≠ 0), then Q.coeff J ≠ 0 and J! ≠ 0
  (in ℝ), so the product is nonzero.

  Strategic significance: factors UWF-2 into a single Mathlib-lookup
  NAMED leaf (the Taylor coefficient identity), reducing the OPEN
  set of universal-witness sub-NAMEDs to ONE Mathlib gap.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — NEW NAMED Prop with explicit Mathlib
  reference for discharge.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_PartialDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## UWF2D-1 — Taylor coefficient identity NAMED leaf -/

/-- **UWF2D-1 — `T5_NAMED_aeval_zero_multiIteratedPDeriv_formula`**
    [NAMED HYPOTHESIS, Mathlib lookup].

    The standard multivariate Taylor coefficient identity:
      aeval 0 (multiIteratedPDeriv J Q) = (∏ i, J i !) · Q.coeff J

    This is provable from Mathlib's polynomial-evaluation-at-zero +
    `iteratedPDeriv_X_pow` family.  Sketch:
    - `multiIteratedPDeriv J Q = ∏ X^(J' - J) · (J'! / (J' - J)!) · coeff(J')`
      summed over J' ≥ J in Q.support
    - At 0, the only surviving term is J' = J: factor X^(J' - J) = X^0 = 1,
      coefficient = J! · coeff(J)

    Confidence interval [85-95%]: Mathlib likely has this directly, but
    needs a name search. -/
def T5_NAMED_aeval_zero_multiIteratedPDeriv_formula : Prop :=
  ∀ {m : ℕ} (J : Fin m →₀ ℕ) (Q : MvPolynomial (Fin m) ℝ),
    aeval (fun _ => (0 : ℝ)) (multiIteratedPDeriv (fun i => J i) Q) =
      (∏ i, ((J i).factorial : ℝ)) * Q.coeff J

/-! ## UWF2D-2 — Composition: Taylor identity ⇒ UWF-2 -/

/-- **UWF2D-2 — `T5_UWF2_via_Taylor_identity`**: composition theorem.

    Given the Taylor coefficient identity, UWF-2 follows: pick J ∈ Q.support
    (nonempty since Q ≠ 0), then Q.coeff J ≠ 0 and ∏ J!! ≠ 0 in ℝ. -/
theorem T5_UWF2_via_Taylor_identity
    (h_taylor_id : T5_NAMED_aeval_zero_multiIteratedPDeriv_formula) :
    T5_NAMED_support_extraction_at_zero := by
  intros m Q hQ_ne
  unfold T5_NAMED_aeval_zero_multiIteratedPDeriv_formula at h_taylor_id
  -- Q ≠ 0 ⇒ Q.support is nonempty (Mathlib MvPolynomial.support_nonempty)
  have h_supp_ne : Q.support.Nonempty := by
    by_contra h_empty
    rw [Finset.not_nonempty_iff_eq_empty] at h_empty
    apply hQ_ne
    rw [← MvPolynomial.support_eq_empty]
    exact h_empty
  obtain ⟨J_finsupp, hJ_supp⟩ := h_supp_ne
  -- J_finsupp : Fin m →₀ ℕ; coerce to Fin m → ℕ via (fun i => J_finsupp i)
  -- J_finsupp ∈ Q.support means Q.coeff J_finsupp ≠ 0
  have hJ_coeff_finsupp : Q.coeff J_finsupp ≠ 0 :=
    MvPolynomial.mem_support_iff.mp hJ_supp
  -- Witness: take (fun i => J_finsupp i) : Fin m → ℕ
  refine ⟨(fun i => J_finsupp i), ?_⟩
  -- Apply Taylor identity at J_finsupp (the NAMED takes Finsupp)
  rw [h_taylor_id J_finsupp Q]
  -- Goal: (∏ i, (J_finsupp i)!) * Q.coeff J_finsupp ≠ 0
  apply mul_ne_zero
  · -- ∏ J! ≠ 0 since each J i ! ≥ 1
    apply Finset.prod_ne_zero_iff.mpr
    intros i _
    exact_mod_cast (Nat.factorial_pos (J_finsupp i)).ne'
  · exact hJ_coeff_finsupp

/-! ## UWF2D-3 — Headline -/

/-- **🚨🚨 UWF2D-3 — `T5_UWF2_PARTIAL_DISCHARGE_HEADLINE`**: paper-citable
    bundle showing UWF-2 reduces to ONE Mathlib-lookup NAMED leaf.

    Strategic significance: combined with UWF-1 + UWF-3 (both
    UNCONDITIONALLY closed), the universal-witness sub-NAMEDs are
    reduced to a single Mathlib gap (Taylor coefficient identity).
    Confidence [85-95%] this exists in Mathlib. -/
theorem T5_UWF2_PARTIAL_DISCHARGE_HEADLINE :
    T5_NAMED_aeval_zero_multiIteratedPDeriv_formula →
    T5_NAMED_support_extraction_at_zero :=
  T5_UWF2_via_Taylor_identity

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_PartialDischarge
