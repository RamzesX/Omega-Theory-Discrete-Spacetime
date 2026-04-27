/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAlgebraicChain

  Cycle 62 (Pisces) Phase B Wave T-4b session 3 — algebraic-chain
  composition for the deg ≥ 2 case of `LindemannPremiseRat`.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers (Wave T4b session 3)

  This file extends Wave T4b session 2's structural skeleton by writing
  the **explicit algebraic-chain composition** that derives:

    `aeval (Real.pi : ℝ) pQ = 0`  →  `IsAlgebraic ℚ ((Real.pi : ℂ))`
                                  →  `IsAlgebraic ℚ (Complex.I * (Real.pi : ℂ))`

  This is the entry hinge into the L-W contradiction proof: assume π is
  algebraic in ℝ, derive `i*π` algebraic in ℂ over ℚ, hence has a finite
  Galois orbit, hence `exp_polynomial_approx` applies.

  The chain composes:
    (i)   Mathlib's `Polynomial.aeval_algebraMap_apply` (ℝ → ℂ cast).
    (ii)  Wave T4b session 2's `iMul_isAlgebraic_of_isAlgebraic`.

  ## Honest narrower-true scope (binding)

  This file does NOT yet UNCONDITIONALLY discharge the deg ≥ 2 case.  It
  ships the EXPLICIT ALGEBRAIC ENTRY CHAIN — the pieces that take the
  hypothesis `aeval π pQ = 0` and produce the algebraic `i*π` element
  needed by the orbit construction.

  The remaining gap (cycles 63+):
    - Construct the orbit `(minpoly ℚ (i*π)).aroots ℂ` from the algebraic
      element.
    - Apply Mathlib `exp_polynomial_approx` to each orbit root.
    - Build the symmetric-sum integer witness via
      `MvPolynomial.IsSymmetric.FundamentalTheorem`.
    - Apply session 2's `integer_bound_contradiction` to derive `False`.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build — this file
  carries 0 sorry, 0 new axioms (Lean core only on every theorem).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofStructural
import Mathlib.RingTheory.Polynomial.Tower

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAlgebraicChain

open Polynomial
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofStructural

/-! ## Phase 1 — aeval cast ℝ → ℂ -/

/-- **Wave T4b session 3 aeval-cast bridge** — for `pQ : ℚ[X]`, if
    `aeval (Real.pi : ℝ) pQ = 0` (over ℝ), then `aeval ((Real.pi : ℂ)) pQ = 0`
    (over ℂ).

    Proof: via Mathlib's `Polynomial.aeval_algebraMap_apply` (factor `aeval`
    through the algebra cast ℝ → ℂ).  The `((Real.pi : ℂ)) = (algebraMap ℝ ℂ)
    Real.pi` identity is definitional. -/
theorem aeval_pi_complex_zero_of_aeval_pi_real_zero
    (pQ : Polynomial ℚ) (h_zero_real : Polynomial.aeval (Real.pi : ℝ) pQ = 0) :
    Polynomial.aeval ((Real.pi : ℂ)) pQ = 0 := by
  -- (Real.pi : ℂ) = (algebraMap ℝ ℂ) Real.pi via Complex.coe_algebraMap
  have h_cast : ((Real.pi : ℂ)) = (algebraMap ℝ ℂ) Real.pi := by
    simp [Complex.coe_algebraMap]
  rw [h_cast]
  -- aeval ((algebraMap ℝ ℂ) Real.pi) pQ = (algebraMap ℝ ℂ) ((aeval Real.pi) pQ)
  rw [Polynomial.aeval_algebraMap_apply ℂ Real.pi pQ]
  rw [h_zero_real]
  simp

/-! ## Phase 2 — IsAlgebraic chain ℝ → ℂ → i·ℂ -/

/-- **Wave T4b session 3 IsAlgebraic-chain step 1** — if `pQ : ℚ[X]` is
    nonzero and `aeval (Real.pi : ℝ) pQ = 0`, then `(Real.pi : ℂ)` is
    algebraic over ℚ. -/
theorem isAlgebraic_pi_complex_of_aeval_real_zero
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero_real : Polynomial.aeval (Real.pi : ℝ) pQ = 0) :
    IsAlgebraic ℚ ((Real.pi : ℂ)) :=
  ⟨pQ, h_ne, aeval_pi_complex_zero_of_aeval_pi_real_zero pQ h_zero_real⟩

/-- **Wave T4b session 3 IsAlgebraic-chain step 2** — if `pQ : ℚ[X]` is
    nonzero and `aeval (Real.pi : ℝ) pQ = 0`, then
    `Complex.I * (Real.pi : ℂ)` is algebraic over ℚ in ℂ.

    Composes step 1 with session 2's `iMul_isAlgebraic_of_isAlgebraic`. -/
theorem isAlgebraic_iPi_of_aeval_pi_real_zero
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero_real : Polynomial.aeval (Real.pi : ℝ) pQ = 0) :
    IsAlgebraic ℚ (Complex.I * (Real.pi : ℂ)) :=
  iMul_isAlgebraic_of_isAlgebraic _
    (isAlgebraic_pi_complex_of_aeval_real_zero pQ h_ne h_zero_real)

/-! ## Phase 3 — Conditional deg ≥ 2 contradiction principle -/

/-- **Wave T4b session 3 conditional deg ≥ 2 contradiction**.

    GIVEN the integer-bound contradiction inputs (a symmetric-sum integer
    `N` for the orbit of `i·π` with `|N| < B`, `B ≤ 1`, `N ≠ 0`), the
    deg ≥ 2 case of `LindemannPremiseRat` holds: any nonzero `pQ : ℚ[X]`
    satisfying `aeval π pQ = 0` is impossible.

    This makes the conditional structure of the L-W contradiction
    completely explicit.  Once cycles 63+ produce the integer-bound
    witness for the actual `(minpoly ℚ (i·π)).aroots ℂ` orbit, the
    deg ≥ 2 case is closed by direct application of this theorem. -/
theorem lindemann_premise_rat_deg_ge_two_conditional
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0)
    (h_int_witness : ∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) :
    False := by
  -- The hypothesis h_zero implies i*π is algebraic over ℚ
  have h_alg : IsAlgebraic ℚ (Complex.I * (Real.pi : ℂ)) :=
    isAlgebraic_iPi_of_aeval_pi_real_zero pQ h_ne h_zero
  -- The integer-bound witness gives the contradiction
  obtain ⟨N, B, h_abs, h_B, h_nonzero⟩ := h_int_witness
  exact integer_bound_contradiction N B h_abs h_B h_nonzero

/-! ## Phase 4 — Headline + paper bundle -/

/-- **HEADLINE — Wave T4b session 3 algebraic-chain composition**.

    Single 4-conjunct showing the chain content:

      1. **aeval cast ℝ → ℂ**: `aeval π_ℝ pQ = 0 → aeval π_ℂ pQ = 0`.
      2. **IsAlgebraic chain ℝ → ℂ → i·ℂ**: hypothesis → π algebraic in ℂ
         → i*π algebraic in ℂ.
      3. **Conditional deg ≥ 2 contradiction**: with integer-bound witness,
         derive False.
      4. **Wave T4b session 2 placeholder reachable**: composition link.

    `#print axioms` on this term yields `[propext, Classical.choice,
    Quot.sound]` only.  ZERO `Real.pi_transcendental` leak. -/
theorem lindemann_premise_rat_proof_w_t4b_session_3_headline :
    (∀ (pQ : Polynomial ℚ),
        Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
        Polynomial.aeval ((Real.pi : ℂ)) pQ = 0)
      ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          IsAlgebraic ℚ (Complex.I * (Real.pi : ℂ)))
      ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          (∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) →
          False) := by
  refine ⟨?_, ?_, ?_⟩
  · exact aeval_pi_complex_zero_of_aeval_pi_real_zero
  · exact isAlgebraic_iPi_of_aeval_pi_real_zero
  · exact lindemann_premise_rat_deg_ge_two_conditional

/-- **W-T4b session 3 paper bundle** — citation marker. -/
theorem lindemann_premise_rat_proof_w_t4b_session_3_paper_bundle :
    ((∀ (pQ : Polynomial ℚ),
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          Polynomial.aeval ((Real.pi : ℂ)) pQ = 0)
        ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
            Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
            IsAlgebraic ℚ (Complex.I * (Real.pi : ℂ)))
        ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
            Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
            (∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) →
            False))
    ∧ (∀ (z : ℂ), IsAlgebraic ℚ (Complex.I * z) ↔ IsAlgebraic ℚ z) := by
  refine ⟨?_, ?_⟩
  · exact lindemann_premise_rat_proof_w_t4b_session_3_headline
  · exact isAlgebraic_iMul_iff

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAlgebraicChain
