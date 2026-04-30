/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring

  T-5 (Roth's theorem) — **Universal aeval-witness factoring**.

  Documents a subtle decomposition: the `T5_NAMED_universal_aeval_witness`
  Prop (P ≠ 0 ⇒ ∃ J, aeval q (∂^J P) ≠ 0) is NOT trivially Tier-99 —
  it requires translation invariance + Mathlib's multiIteratedPDeriv
  at-zero evaluation.

  The factoring isolates these analytical facts:
    1. **Q-shift-nonzero**: shiftPoly q P ≠ 0 if P ≠ 0
    2. **Q-support-nonempty**: Q ≠ 0 ⇒ ∃ J ∈ Q.support
    3. **Aeval-at-zero formula**: aeval 0 (∂^J Q) = J! · coeff(J in Q)
    4. **Translation**: aeval q (∂^J P) = aeval 0 (∂^J (shiftPoly q P))

  Combining: pick J ∈ (shiftPoly q P).support; via translation +
  aeval-at-zero, aeval q (∂^J P) = J! · coeff(J in shiftPoly q P) ≠ 0.

  This factoring is a Hindry-Silverman-style analytical decomposition.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS — only NAMED Prop with explicit factoring.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus
import OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus
open OmegaTheory.Irrationality.CustomMath.T5_Phase6_BindOneShift
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex

/-! ## UWF-1 — Translation-invariance NAMED leaf -/

/-- **UWF-1 — `T5_NAMED_aeval_translate_via_shiftPoly`** [NAMED HYPOTHESIS,
    routine real-analysis fact].

    For any P, J, q-real, q-shift point γ:
      aeval γ (multiIteratedPDeriv J P) = aeval (γ - α) (multiIteratedPDeriv J (shiftPoly α P))

    This is the standard partial-derivative translation-invariance.
    Discharge: chain-rule argument or direct unfolding of shiftPoly +
    multiIteratedPDeriv definitions.  -/
def T5_NAMED_aeval_translate_via_shiftPoly : Prop :=
  ∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (J : Fin m → ℕ)
    (γ α : Fin m → ℝ),
    aeval γ (multiIteratedPDeriv J P) =
      aeval (fun i => γ i - α i)
        (multiIteratedPDeriv J (shiftPoly α P))

/-! ## UWF-2 — Support-extraction NAMED leaf -/

/-- **UWF-2 — `T5_NAMED_support_extraction_at_zero`** [NAMED HYPOTHESIS,
    routine MvPolynomial fact].

    For any nonzero Q : MvPolynomial (Fin m) ℝ, there exists a multi-index
    J such that aeval 0 (multiIteratedPDeriv J Q) ≠ 0.

    Standard fact: take J in Q.support — multiIteratedPDeriv J at 0
    evaluates Q's J-th coefficient times J! (factorial), which is nonzero.

    Discharge: Q ≠ 0 ⇒ Q.support ≠ ∅ (via Mathlib `MvPolynomial.support_eq_empty`),
    pick J ∈ Q.support, use Mathlib `MvPolynomial.eval_iteratedPDeriv` family. -/
def T5_NAMED_support_extraction_at_zero : Prop :=
  ∀ {m : ℕ} (Q : MvPolynomial (Fin m) ℝ),
    Q ≠ 0 →
    ∃ J : Fin m → ℕ,
      aeval (fun _ => (0 : ℝ)) (multiIteratedPDeriv J Q) ≠ 0

/-! ## UWF-3 — shiftPoly-preserves-nonzero NAMED leaf -/

/-- **UWF-3 — `T5_NAMED_shiftPoly_preserves_nonzero`** [NAMED HYPOTHESIS,
    routine algebra fact].

    The shiftPoly automorphism (substitution X_i ↦ X_i + α_i) preserves
    nonzero-ness: P ≠ 0 ⇒ shiftPoly α P ≠ 0.

    Discharge: shiftPoly is an algebra isomorphism (with inverse shiftPoly (-α)).
    Algebra isomorphisms preserve nonzero. -/
def T5_NAMED_shiftPoly_preserves_nonzero : Prop :=
  ∀ {m : ℕ} (α : Fin m → ℝ) (P : MvPolynomial (Fin m) ℝ),
    P ≠ 0 → shiftPoly α P ≠ 0

/-! ## UWF-4 — Composition: 3 sub-NAMEDs ⇒ universal-witness -/

/-- **UWF-4 — `T5_universal_witness_via_3_subleaves`**: composition theorem.

    Given the 3 sub-NAMEDs (translate, support-extract, shift-preserve),
    the universal aeval-witness Prop holds. -/
theorem T5_universal_witness_via_3_subleaves
    (h_translate : T5_NAMED_aeval_translate_via_shiftPoly)
    (h_support_ext : T5_NAMED_support_extraction_at_zero)
    (h_shift_ne : T5_NAMED_shiftPoly_preserves_nonzero) :
    T5_NAMED_universal_aeval_witness := by
  intros m hm P q hP
  unfold T5_NAMED_aeval_translate_via_shiftPoly at h_translate
  unfold T5_NAMED_support_extraction_at_zero at h_support_ext
  unfold T5_NAMED_shiftPoly_preserves_nonzero at h_shift_ne
  -- Define qReal explicitly (not as let — to control the goal)
  set qReal : Fin m → ℝ := fun i => ((q i : ℚ) : ℝ) with hqReal
  -- shiftPoly qReal P is nonzero
  have hQ_ne : shiftPoly qReal P ≠ 0 := h_shift_ne qReal P hP
  -- extract witness J
  obtain ⟨J, hJ⟩ := h_support_ext (shiftPoly qReal P) hQ_ne
  refine ⟨J, ?_⟩
  -- translate via NAMED leaf with γ = qReal, α = qReal
  rw [h_translate P J qReal qReal]
  -- Goal: aeval (fun i => qReal i - qReal i) (∂^J (shiftPoly qReal P)) ≠ 0
  -- The function (fun i => qReal i - qReal i) = (fun _ => 0) by sub_self
  have h_sub_zero : (fun i => qReal i - qReal i) = (fun _ => (0 : ℝ)) := by
    funext i; ring
  rw [h_sub_zero]
  exact hJ

/-! ## UWF-5 — Headline: factoring documentation -/

/-- **🚨🚨 UWF-5 — `T5_UNIVERSAL_WITNESS_FACTORING_HEADLINE`**:
    paper-citable bundle showing universal-witness factors into 3
    smaller NAMED leaves.

    Strategic significance: discovers that universal-witness is NOT
    Tier-99 trivial.  It decomposes into:
    - translation invariance (UWF-1, routine real-analysis)
    - support extraction at zero (UWF-2, routine MvPolynomial)
    - shiftPoly preserves nonzero (UWF-3, routine algebra) -/
theorem T5_UNIVERSAL_WITNESS_FACTORING_HEADLINE :
    T5_NAMED_aeval_translate_via_shiftPoly →
    T5_NAMED_support_extraction_at_zero →
    T5_NAMED_shiftPoly_preserves_nonzero →
    T5_NAMED_universal_aeval_witness :=
  T5_universal_witness_via_3_subleaves

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
