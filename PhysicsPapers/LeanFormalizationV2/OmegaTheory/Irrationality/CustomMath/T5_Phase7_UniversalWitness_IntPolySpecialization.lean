/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitness_IntPolySpecialization

  T-5 (Roth's theorem) — **universal-witness specialization to ℤ-poly coercion**.

  Specializes the universal-witness Prop (for ℝ-polys) to integer-coefficient
  polynomials via .map (algebraMap ℤ ℝ): for any nonzero P_int, ∃ J with
  aeval q (∂^J (P_int.map)) ≠ 0.

  This provides a stepping-stone toward the SM-3 sub-leaf, isolating the
  "iterated derivative existence" part from the "no-derivative aeval" part.

  Strategic significance: shows the universal-witness specializes
  cleanly to ℤ-poly coercion case.  Combined with future SM-3 analytical
  refinements (Schmidt's specific construction guarantees aeval ≠ 0 not
  just SOME derivative ≠ 0), this maps SM-3 to a structural composition.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitness_IntPolySpecialization

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitnessFactoring
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_V8_DecompositionStatus

/-! ## UWIPS-1 — universal-witness specialization to ℤ-poly coercion -/

/-- **UWIPS-1 — `T5_universal_witness_specialized_to_int_poly`**: under
    universal-witness for ℝ-polys, any nonzero ℤ-poly coercion has SOME
    iterated derivative non-vanishing at any rational q-tuple.

    Direct specialization: P_int.map is an ℝ-poly, apply universal-witness. -/
theorem T5_universal_witness_specialized_to_int_poly
    (h_univ : T5_NAMED_universal_aeval_witness)
    {m : ℕ} (hm : 1 ≤ m)
    (P_int : MvPolynomial (Fin m) ℤ)
    (hP_ne : (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0)
    (q : Fin m → ℚ) :
    ∃ (j : Fin m → ℕ),
      aeval (fun i => ((q i : ℚ) : ℝ))
        (multiIteratedPDeriv j (P_int.map (algebraMap ℤ ℝ))) ≠ 0 := by
  unfold T5_NAMED_universal_aeval_witness at h_univ
  exact h_univ hm (P_int.map (algebraMap ℤ ℝ)) q hP_ne

/-! ## UWIPS-2 — Headline -/

/-- **🚨🚨 UWIPS-2 — `T5_UNIVERSAL_WITNESS_INT_POLY_SPECIALIZATION_HEADLINE`**:
    paper-citable bundle showing universal-witness specializes to ℤ-poly.

    Strategic significance: maps the SM-3 sub-leaf (universal-aeval-ℤ)
    architecture to a structural composition over universal-witness +
    "no-derivative aeval" refinement. -/
theorem T5_UNIVERSAL_WITNESS_INT_POLY_SPECIALIZATION_HEADLINE :
    T5_NAMED_universal_aeval_witness →
    (∀ {m : ℕ} (hm : 1 ≤ m)
       (P_int : MvPolynomial (Fin m) ℤ),
       (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
       ∀ (q : Fin m → ℚ),
       ∃ (j : Fin m → ℕ),
         aeval (fun i => ((q i : ℚ) : ℝ))
           (multiIteratedPDeriv j (P_int.map (algebraMap ℤ ℝ))) ≠ 0) :=
  fun h_univ {m} hm P_int hP_ne q =>
    T5_universal_witness_specialized_to_int_poly h_univ hm P_int hP_ne q

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UniversalWitness_IntPolySpecialization
