/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_ZeroJCase

  T-5 (Roth's theorem) — **UWF-2 J=0 special case** (constant-term Q nonzero).

  Concrete discharge of UWF-2 in the special case where Q has a nonzero
  constant term: pick J = 0 (zero multi-index), then
  multiIteratedPDeriv 0 Q = Q, and aeval 0 Q = Q.coeff 0 ≠ 0.

  Strategic significance: covers the case `Q.coeff 0 ≠ 0` directly,
  reducing UWF-2 to: "Q ≠ 0 AND Q.coeff 0 = 0 ⇒ ∃ J ≠ 0 with witness".
  The latter case is a strict subcase of UWF-2.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_PartialDischarge

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_ZeroJCase

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_PartialDischarge
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## UWF2Z-1 — multiIteratedPDeriv 0 = id -/

/-- **UWF2Z-1 — `T5_multiIteratedPDeriv_zero_eq_self`**: applying
    multiIteratedPDeriv with the zero multi-index leaves Q unchanged.

    Direct from definition: foldr over an empty list of derivatives.
    Note: multiIteratedPDeriv folds (pderiv k)^[J k] over List.finRange n;
    when J = 0, each iterate is identity. -/
theorem T5_multiIteratedPDeriv_zero_eq_self {n : ℕ}
    (Q : MvPolynomial (Fin n) ℝ) :
    multiIteratedPDeriv (fun _ => 0) Q = Q := by
  unfold multiIteratedPDeriv
  -- foldr (fun k acc => (pderiv k)^[(fun _ => 0) k] acc) Q (List.finRange n)
  -- (pderiv k)^[0] = id, so each step is identity, giving Q
  induction (List.finRange n) with
  | nil => rfl
  | cons k l ih =>
    rw [List.foldr_cons]
    show ((pderiv k)^[(fun _ => 0) k]) (List.foldr _ Q l) = Q
    -- (fun _ => 0) k = 0, so (pderiv k)^[0] = id
    show ((pderiv k)^[0]) (List.foldr _ Q l) = Q
    rw [Function.iterate_zero, id_eq]
    exact ih

/-! ## UWF2Z-2 — UWF-2 special case: nonzero constant term -/

/-- **UWF2Z-2 — `T5_UWF2_via_constant_term`**: UWF-2 holds for Q with
    Q.coeff 0 ≠ 0, witnessed by J = 0.

    Direct: multiIteratedPDeriv 0 Q = Q (UWF2Z-1), and aeval 0 Q
    evaluates the constant term, which is nonzero. -/
theorem T5_UWF2_via_constant_term {n : ℕ}
    (Q : MvPolynomial (Fin n) ℝ)
    (h_const_ne : Q.coeff 0 ≠ 0) :
    ∃ J : Fin n → ℕ,
      aeval (fun _ => (0 : ℝ)) (multiIteratedPDeriv J Q) ≠ 0 := by
  refine ⟨(fun _ => 0), ?_⟩
  rw [T5_multiIteratedPDeriv_zero_eq_self]
  -- Goal: aeval (fun _ => 0) Q ≠ 0
  rw [MvPolynomial.aeval_zero']
  -- Goal: algebraMap ℝ ℝ (constantCoeff Q) ≠ 0
  -- algebraMap ℝ ℝ is identity, and constantCoeff Q = Q.coeff 0
  simp [MvPolynomial.constantCoeff_eq]
  exact h_const_ne

/-! ## UWF2Z-3 — Headline -/

/-- **🚨🚨 UWF2Z-3 — `T5_UWF2_ZERO_J_HEADLINE`**: paper-citable special
    case of UWF-2 covering the constant-term-nonzero case.

    Strategic significance: UWF-2 reduces further to "Q ≠ 0 AND
    Q.coeff 0 = 0 ⇒ ∃ J > 0 witness".  The non-constant-term case is
    a smaller sub-NAMED. -/
theorem T5_UWF2_ZERO_J_HEADLINE {n : ℕ}
    (Q : MvPolynomial (Fin n) ℝ)
    (h_const_ne : Q.coeff 0 ≠ 0) :
    ∃ J : Fin n → ℕ,
      aeval (fun _ => (0 : ℝ)) (multiIteratedPDeriv J Q) ≠ 0 :=
  T5_UWF2_via_constant_term Q h_const_ne

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UWF2_ZeroJCase
