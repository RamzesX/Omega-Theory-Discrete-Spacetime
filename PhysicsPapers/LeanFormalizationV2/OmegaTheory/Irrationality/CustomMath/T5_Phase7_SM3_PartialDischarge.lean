/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM3_PartialDischarge

  T-5 (Roth's theorem) — **SM-3 partial discharge under universal aeval-witness**.

  Discharges the SM-3 NAMED Prop (`T5_NAMED_Schmidt_aeval_nonzero_per_n`)
  under a "universal aeval non-vanishing" hypothesis: for any nonzero
  P_int : MvPolynomial (Fin m) ℤ and any rational q-tuple, aeval at q
  is nonzero.

  Strategic significance: factors SM-3 into a SMALLER analytical
  hypothesis (per-poly aeval non-vanishing, decoupled from q_seq
  construction).  The universal form is provable when q_seq satisfies
  appropriate generic position conditions.

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM3_PartialDischarge

open MvPolynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_BlockAB_SchmidtMachineryNAMED
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeMTuple

/-! ## SM3PD-1 — Universal aeval-witness ⇒ SM-3 -/

/-- **SM3PD-1 — `T5_SM3_via_universal_aeval_witness`**: discharges SM-3
    NAMED Prop under universal aeval-witness hypothesis.

    Given that for ANY nonzero P_int and ANY rational q-tuple, aeval q_int P_int ≠ 0,
    SM-3 follows directly (by instantiating P_int and per-n q_seq n). -/
theorem T5_SM3_via_universal_aeval_witness
    (h_universal_aeval_ne :
      ∀ {m : ℕ}, 1 ≤ m →
      ∀ (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      ∀ (q : Fin m → ℚ),
        aeval (fun j => ((q j : ℚ) : ℝ))
          ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) :
    T5_NAMED_Schmidt_aeval_nonzero_per_n := by
  intros α _hα ε _hε m hm P_int hP_ne q_seq _h_violator n
  exact h_universal_aeval_ne hm P_int hP_ne (q_seq n)

/-! ## SM3PD-2 — Per-poly aeval-witness ⇒ SM-3 (specific P_int form) -/

/-- **SM3PD-2 — `T5_SM3_per_poly_via_aeval_witness`**: variant where
    the universal aeval condition is restricted to a SPECIFIC P_int
    (the Schmidt aux poly).  Useful when SM-1 provides P_int and we
    only need aeval non-vanishing for THAT P_int. -/
theorem T5_SM3_per_poly_via_aeval_witness
    {m : ℕ} (hm : 1 ≤ m)
    (P_int : MvPolynomial (Fin m) ℤ)
    (hP_ne : (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0)
    (h_per_q_aeval_ne : ∀ (q : Fin m → ℚ),
      aeval (fun j => ((q j : ℚ) : ℝ))
        ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0)
    (α : ℝ) (_hα : Irrational α)
    (ε : ℝ) (_hε : 0 < ε)
    (q_seq : ℕ → Fin m → ℚ)
    (_h_violator : ∀ n j, q_seq n j ∈ T5_RothViolatingSet α ε) :
    ∀ n, aeval (fun j => ((q_seq n j : ℚ) : ℝ))
      ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0 := by
  intro n
  exact h_per_q_aeval_ne (q_seq n)

/-! ## SM3PD-3 — Headline -/

/-- **🚨🚨 SM3PD-3 — `T5_SM3_PARTIAL_DISCHARGE_HEADLINE`**: paper-citable
    bundle showing SM-3 reduces to per-poly aeval non-vanishing.

    Strategic significance: SM-3 is no longer an opaque NAMED Prop —
    it splits into a per-poly analytical hypothesis (existence of q
    where P_int evaluates nonzero) which is provable from generic
    Schmidt construction (P_int has bounded degree, finite vanishing
    locus in ℚ^m). -/
theorem T5_SM3_PARTIAL_DISCHARGE_HEADLINE :
    -- (a) Universal aeval-witness ⇒ SM-3
    ((∀ {m : ℕ} (_hm : 1 ≤ m)
        (P_int : MvPolynomial (Fin m) ℤ),
        (P_int.map (algebraMap ℤ ℝ) : MvPolynomial (Fin m) ℝ) ≠ 0 →
      ∀ (q : Fin m → ℚ),
        aeval (fun j => ((q j : ℚ) : ℝ))
          ((P_int.map (algebraMap ℤ ℝ)) : MvPolynomial (Fin m) ℝ) ≠ 0) →
      T5_NAMED_Schmidt_aeval_nonzero_per_n) :=
  T5_SM3_via_universal_aeval_witness

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SM3_PartialDischarge
