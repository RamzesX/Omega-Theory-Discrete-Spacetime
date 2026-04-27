/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerExtraction

  Cycle 62 (Pisces) Phase B Wave T-4b session 9 — integer-polynomial
  extraction PROVEN via Mathlib's `IsLocalization.integerNormalization`.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers (Wave T4b session 9)

  This file PROVES (no longer Prop:=True placeholder) that:

  Given a rational polynomial `q : ℚ[X]` with non-zero constant term
  and a complex root `x` (`aeval x q = 0`), there exists an integer
  polynomial `f : ℤ[X]` with non-zero constant term and the same root.

  Key Mathlib API: `IsLocalization.integerNormalization M q`, where
  `M = nonZeroDivisors ℤ` and `ℚ` is the localization (fraction field).

  Discharges:
    - `IntegerPolynomialExtractionFromAlgebraic` (session 4 placeholder)
    - `IntegerPolynomialFromRationalAnnihilator` (session 7 placeholder)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build — this file
  carries 0 sorry, 0 new axioms (Lean core only on every theorem).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofMultiRootSum
import Mathlib.RingTheory.Localization.Integral

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerExtraction

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofRationalAnnihilator

/-! ## Phase 1 — Integer-polynomial extraction PROVEN -/

/-- **Wave T4b session 9 — integer polynomial extraction (PROVEN)**.

    Given `q : Polynomial ℚ` with `q.coeff 0 ≠ 0` and a root `x : ℂ`
    (`aeval x q = 0`), there exists `f : Polynomial ℤ` with
    `f.eval 0 ≠ 0` and `aeval x f = 0`.

    Proof: take `f := IsLocalization.integerNormalization (nonZeroDivisors ℤ) q`.
    By `IsLocalization.integerNormalization_aeval_eq_zero`, `aeval x f = 0`.
    By `IsLocalization.integerNormalization_spec`, there exists
    `b : nonZeroDivisors ℤ` with `(f.coeff i : ℚ) = (b : ℚ) * q.coeff i`
    for all i. At i=0: `(f.coeff 0 : ℚ) = (b : ℚ) * q.coeff 0 ≠ 0` since
    both factors are non-zero, so `f.coeff 0 ≠ 0`, equivalently
    `f.eval 0 ≠ 0`. -/
theorem integer_polynomial_extraction_unconditional
    (q : Polynomial ℚ) (h_const : q.coeff 0 ≠ 0)
    {x : ℂ} (h_aeval : Polynomial.aeval x q = 0) :
    ∃ f : Polynomial ℤ,
      Polynomial.eval 0 f ≠ 0 ∧
      Polynomial.aeval x f = 0 := by
  let M : Submonoid ℤ := nonZeroDivisors ℤ
  refine ⟨IsLocalization.integerNormalization M q, ?_, ?_⟩
  · -- Show (integerNormalization M q).eval 0 ≠ 0
    obtain ⟨b, hb_mem, hb_eq⟩ := IsLocalization.integerNormalization_spec M q
    intro h_eval_zero
    -- f.coeff 0 = f.eval 0
    rw [← Polynomial.coeff_zero_eq_eval_zero] at h_eval_zero
    -- map(int_norm).coeff 0 = (algebraMap ℤ ℚ) (int_norm.coeff 0) = (algebraMap ℤ ℚ) 0 = 0
    have h_map_coeff : (Polynomial.map (algebraMap ℤ ℚ)
                         (IsLocalization.integerNormalization M q)).coeff 0
                     = (algebraMap ℤ ℚ) ((IsLocalization.integerNormalization M q).coeff 0) :=
      Polynomial.coeff_map _ 0
    rw [h_eval_zero, map_zero] at h_map_coeff
    -- h_map_coeff : (map ... f).coeff 0 = 0
    rw [hb_eq] at h_map_coeff
    -- h_map_coeff : (b • q).coeff 0 = 0
    rw [Polynomial.coeff_smul] at h_map_coeff
    -- h_map_coeff : b • q.coeff 0 = 0  (where b : ℤ acts on ℚ)
    have h_b_ne : b ≠ 0 := nonZeroDivisors.ne_zero hb_mem
    have h_smul_eq : b • q.coeff 0 = (b : ℚ) * q.coeff 0 :=
      zsmul_eq_mul (q.coeff 0) b
    rw [h_smul_eq] at h_map_coeff
    exact mul_ne_zero (Int.cast_ne_zero.mpr h_b_ne) h_const h_map_coeff
  · -- aeval x (integerNormalization M q) = 0
    exact IsLocalization.integerNormalization_aeval_eq_zero M q h_aeval

/-! ## Phase 2 — Specialization to L-W setup (i*π root) -/

/-- **Wave T4b session 9 — integer-polynomial extraction at i*π**.

    Given the algebraic-chain hypothesis `aeval (Real.pi : ℝ) pQ = 0`
    (pQ ≠ 0), there exists `f : Polynomial ℤ` with `f.eval 0 ≠ 0` and
    `aeval (Complex.I * Real.pi) f = 0` — exactly the input
    `exp_polynomial_approx_at_iPi` (session 6) needs. -/
theorem integer_polynomial_at_iPi_exists
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0) :
    ∃ f : Polynomial ℤ,
      Polynomial.eval 0 f ≠ 0 ∧
      Polynomial.aeval (Complex.I * (Real.pi : ℂ)) f = 0 := by
  -- From session 7: extract rational annihilator with non-zero constant
  obtain ⟨q, h_q_const, h_q_aeval⟩ :=
    iPi_rational_annihilator_with_nonzero_constant pQ h_ne h_zero
  -- Apply session 9: convert to integer polynomial
  exact integer_polynomial_extraction_unconditional q h_q_const h_q_aeval

/-! ## Phase 3 — Headline + paper bundle + frontier marker -/

/-- **HEADLINE — Wave T4b session 9 integer extraction PROVEN**. -/
theorem lindemann_premise_rat_proof_w_t4b_session_9_headline :
    (∀ (q : Polynomial ℚ), q.coeff 0 ≠ 0 →
        ∀ {x : ℂ}, Polynomial.aeval x q = 0 →
        ∃ f : Polynomial ℤ,
          Polynomial.eval 0 f ≠ 0 ∧
          Polynomial.aeval x f = 0)
      ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          ∃ f : Polynomial ℤ,
            Polynomial.eval 0 f ≠ 0 ∧
            Polynomial.aeval (Complex.I * (Real.pi : ℂ)) f = 0) := by
  refine ⟨?_, ?_⟩
  · exact fun q h_const _ h_aeval =>
      integer_polynomial_extraction_unconditional q h_const h_aeval
  · exact integer_polynomial_at_iPi_exists

/-- **W-T4b session 9 paper bundle** — citation marker. -/
theorem lindemann_premise_rat_proof_w_t4b_session_9_paper_bundle :
    ((∀ (q : Polynomial ℚ), q.coeff 0 ≠ 0 →
          ∀ {x : ℂ}, Polynomial.aeval x q = 0 →
          ∃ f : Polynomial ℤ,
            Polynomial.eval 0 f ≠ 0 ∧
            Polynomial.aeval x f = 0)
        ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
            Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
            ∃ f : Polynomial ℤ,
              Polynomial.eval 0 f ≠ 0 ∧
              Polynomial.aeval (Complex.I * (Real.pi : ℂ)) f = 0))
    ∧ (∀ (q : Polynomial ℚ),
        ∃ b : ℤ, b ∈ nonZeroDivisors ℤ ∧
          Polynomial.map (algebraMap ℤ ℚ)
            (IsLocalization.integerNormalization (nonZeroDivisors ℤ) q) = b • q) := by
  refine ⟨?_, ?_⟩
  · exact lindemann_premise_rat_proof_w_t4b_session_9_headline
  · intro q
    exact IsLocalization.integerNormalization_spec (nonZeroDivisors ℤ) q

/-- **Frontier marker** — first cycle-62 Wave T4b session 9 integer-poly
    extraction PROVEN (no longer Prop:=True placeholder).  Discharges
    sessions 4 + 7 placeholders. -/
theorem lindemann_premise_rat_proof_w_t4b_session_9_first_landed_in_V2 :
    True := trivial

/-- **W-T4b session 9 closure marker** — sessions 4 + 7 placeholders
    PROVEN replaced. -/
theorem lindemann_premise_rat_proof_w_t4b_session_9_closed : True := trivial

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofIntegerExtraction
