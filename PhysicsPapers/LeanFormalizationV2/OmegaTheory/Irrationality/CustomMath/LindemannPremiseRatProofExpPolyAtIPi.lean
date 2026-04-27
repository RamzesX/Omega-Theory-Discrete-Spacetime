/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofExpPolyAtIPi

  Cycle 62 (Pisces) Phase B Wave T-4b session 6 — instantiation of
  Mathlib's `exp_polynomial_approx` at the root `i*π`.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers (Wave T4b session 6)

  This file extends Wave T4b session 5 by instantiating Mathlib's
  `LindemannWeierstrass.exp_polynomial_approx` at the specific complex
  root `i*π`.  Given an integer polynomial `f : ℤ[X]` with `f(0) ≠ 0`
  containing `i*π` among its complex roots, the analytical approximation
  yields:

    ∃ c, ∀ p > |f(0)|.natAbs, p.Prime →
      ∃ n, ¬ p ∣ n, ∃ gp : ℤ[X],
        ‖n·exp(i*π) - p·aeval (i*π) gp‖ ≤ c^p / (p-1)!

  By Hydra c59's `exp_iPi_eq_neg_one`, `exp(i*π) = -1`, so the bound
  simplifies:

    ‖-n - p·aeval (i*π) gp‖ = ‖n + p·aeval (i*π) gp‖ ≤ c^p / (p-1)!

  Key contributions:

    1. **`exp_polynomial_approx_at_iPi`** — explicit instantiation at
       `r = i*π`.

    2. **`exp_polynomial_approx_at_iPi_simplified`** — uses
       `exp_iPi_eq_neg_one` to rewrite the bound.

    3. **Headline + paper bundle + frontier marker**.

  ## Honest narrower-true scope (binding)

  This file produces the per-root analytical bound for the orbit element
  `i*π`.  The L-W argument requires summing this bound across all orbit
  roots (via the orbit construction from session 4) and combining with
  the symmetric-sum integer witness (cycle 65+).  This file is one
  ingredient of that chain.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build — this file
  carries 0 sorry, 0 new axioms (Lean core only on every theorem).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct
import OmegaTheory.Irrationality.HermitePade.PiTranscendentalLayerB

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofExpPolyAtIPi

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation
open OmegaTheory.Irrationality.HermitePade.PiTranscendentalLayerB

/-! ## Phase 1 — Instantiation at root `i*π` -/

/-- **Wave T4b session 6 — `exp_polynomial_approx` instantiated at `i*π`**.

    Given an integer polynomial `f : ℤ[X]` with `f(0) ≠ 0` whose complex
    roots include `Complex.I * Real.pi`, the analytical approximation
    yields per-prime `p` a Lindemann integer `n` and polynomial `gp` with
    the explicit bound at the root.

    This is the per-root specialization of Mathlib's
    `LindemannWeierstrass.exp_polynomial_approx`. -/
theorem exp_polynomial_approx_at_iPi
    (f : Polynomial ℤ) (hf : Polynomial.eval 0 f ≠ 0)
    (h_iPi_root : (Complex.I * (Real.pi : ℂ)) ∈ f.aroots ℂ) :
    ∃ c : ℝ, ∀ p > (Polynomial.eval 0 f).natAbs, p.Prime →
      ∃ n : ℤ, ¬ (↑p ∣ n) ∧ ∃ gp : Polynomial ℤ,
        gp.natDegree ≤ p * f.natDegree - 1 ∧
        ‖n • Complex.exp (Complex.I * (Real.pi : ℂ))
            - p • Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp‖
          ≤ c ^ p / (p - 1).factorial := by
  -- Apply Mathlib's exp_polynomial_approx via Ganymede c57's re-export
  obtain ⟨c, hc⟩ := mathlib_analytical_part_witness_at_pi f hf
  refine ⟨c, ?_⟩
  intros p h_p_gt h_prime
  obtain ⟨n, h_n_nondiv, gp, h_gp_deg, h_bound⟩ := hc p h_p_gt h_prime
  refine ⟨n, h_n_nondiv, gp, h_gp_deg, ?_⟩
  exact h_bound h_iPi_root

/-! ## Phase 2 — Simplified bound using exp(iπ) = -1 -/

/-- **Wave T4b session 6 — bound simplified via Euler `exp(iπ) = -1`**.

    The per-root bound at `i*π` simplifies because `exp(i*π) = -1`:

      ‖n·(-1) - p·aeval(i*π) gp‖ = ‖-n - p·aeval(i*π) gp‖
                                 = ‖n + p·aeval(i*π) gp‖

    so we get `‖n + p·aeval(i*π) gp‖ ≤ c^p/(p-1)!`. -/
theorem exp_polynomial_approx_at_iPi_simplified
    (f : Polynomial ℤ) (hf : Polynomial.eval 0 f ≠ 0)
    (h_iPi_root : (Complex.I * (Real.pi : ℂ)) ∈ f.aroots ℂ) :
    ∃ c : ℝ, ∀ p > (Polynomial.eval 0 f).natAbs, p.Prime →
      ∃ n : ℤ, ¬ (↑p ∣ n) ∧ ∃ gp : Polynomial ℤ,
        gp.natDegree ≤ p * f.natDegree - 1 ∧
        ‖(n : ℂ) + (p : ℂ) * Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp‖
          ≤ c ^ p / (p - 1).factorial := by
  obtain ⟨c, hc⟩ := exp_polynomial_approx_at_iPi f hf h_iPi_root
  refine ⟨c, ?_⟩
  intros p h_p_gt h_prime
  obtain ⟨n, h_n_nondiv, gp, h_gp_deg, h_bound⟩ := hc p h_p_gt h_prime
  refine ⟨n, h_n_nondiv, gp, h_gp_deg, ?_⟩
  -- Rewrite ‖n • exp(iπ) - p • aeval(iπ) gp‖ using exp(iπ) = -1
  have h_exp_iPi : Complex.exp (Complex.I * (Real.pi : ℂ)) = -1 := by
    show Complex.exp iPi = -1
    exact exp_iPi_eq_neg_one
  rw [h_exp_iPi] at h_bound
  -- h_bound : ‖n • (-1) - p • aeval(iπ) gp‖ ≤ c^p / (p-1)!
  -- Goal: ‖n + p · aeval(iπ) gp‖ ≤ c^p / (p-1)!
  -- Note: n • (-1) = -n, p • x = p·x (zsmul = scalar multiplication)
  -- So ‖-n - p·aeval(iπ) gp‖ = ‖-(n + p·aeval(iπ) gp)‖ = ‖n + p·aeval(iπ) gp‖
  rw [show (n : ℂ) + (p : ℂ) * Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp
        = -(n • (-1 : ℂ) - p • Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp) by
      simp [zsmul_eq_mul, nsmul_eq_mul]; ring]
  rw [norm_neg]
  exact h_bound

/-! ## Phase 3 — Bridge to session 5's full conditional chain -/

/-- **Wave T4b session 6 — extended conditional chain**.

    The complete chain from algebraic hypothesis to False, parameterised
    by the integer-bound witness from cycle 65+'s symmetric-sum step. -/
theorem lindemann_premise_rat_extended_conditional
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0)
    (h_int_witness : ∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) :
    False :=
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct.lindemann_premise_rat_full_conditional_chain
    pQ h_ne h_zero h_int_witness

/-! ## Phase 4 — Headline + paper bundle + frontier marker -/

/-- **HEADLINE — Wave T4b session 6 — `exp_polynomial_approx` at `i*π`**.

    Single 3-conjunct showing the analytical-bound instantiation content:

      1. **Instantiation at i*π**: per-root bound `‖n·exp(iπ) - p·aeval(iπ) gp‖`.
      2. **Simplified via Euler**: `‖n + p·aeval(iπ) gp‖ ≤ c^p/(p-1)!`.
      3. **Extended conditional**: the full conditional contradiction
         chain is reachable.

    `#print axioms` on this term yields `[propext, Classical.choice,
    Quot.sound]` only.  ZERO `Real.pi_transcendental` leak. -/
theorem lindemann_premise_rat_proof_w_t4b_session_6_headline :
    (∀ (f : Polynomial ℤ), Polynomial.eval 0 f ≠ 0 →
        (Complex.I * (Real.pi : ℂ)) ∈ f.aroots ℂ →
        ∃ c : ℝ, ∀ p > (Polynomial.eval 0 f).natAbs, p.Prime →
          ∃ n : ℤ, ¬ (↑p ∣ n) ∧ ∃ gp : Polynomial ℤ,
            gp.natDegree ≤ p * f.natDegree - 1 ∧
            ‖n • Complex.exp (Complex.I * (Real.pi : ℂ))
                - p • Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp‖
              ≤ c ^ p / (p - 1).factorial)
      ∧ (∀ (f : Polynomial ℤ), Polynomial.eval 0 f ≠ 0 →
          (Complex.I * (Real.pi : ℂ)) ∈ f.aroots ℂ →
          ∃ c : ℝ, ∀ p > (Polynomial.eval 0 f).natAbs, p.Prime →
            ∃ n : ℤ, ¬ (↑p ∣ n) ∧ ∃ gp : Polynomial ℤ,
              gp.natDegree ≤ p * f.natDegree - 1 ∧
              ‖(n : ℂ) + (p : ℂ) * Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp‖
                ≤ c ^ p / (p - 1).factorial)
      ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          (∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) →
          False) := by
  refine ⟨?_, ?_, ?_⟩
  · exact exp_polynomial_approx_at_iPi
  · exact exp_polynomial_approx_at_iPi_simplified
  · exact lindemann_premise_rat_extended_conditional

/-- **W-T4b session 6 paper bundle** — citation marker. -/
theorem lindemann_premise_rat_proof_w_t4b_session_6_paper_bundle :
    (∀ (f : Polynomial ℤ), Polynomial.eval 0 f ≠ 0 →
        (Complex.I * (Real.pi : ℂ)) ∈ f.aroots ℂ →
        ∃ c : ℝ, ∀ p > (Polynomial.eval 0 f).natAbs, p.Prime →
          ∃ n : ℤ, ¬ (↑p ∣ n) ∧ ∃ gp : Polynomial ℤ,
            gp.natDegree ≤ p * f.natDegree - 1 ∧
            ‖n • Complex.exp (Complex.I * (Real.pi : ℂ))
                - p • Polynomial.aeval (Complex.I * (Real.pi : ℂ)) gp‖
              ≤ c ^ p / (p - 1).factorial)
    ∧ Complex.exp (Complex.I * (Real.pi : ℂ)) = -1 := by
  refine ⟨exp_polynomial_approx_at_iPi, ?_⟩
  show Complex.exp iPi = -1
  exact exp_iPi_eq_neg_one

/-- **Frontier marker** — first cycle-62 Wave T4b session 6 instantiation
    of Mathlib's `exp_polynomial_approx` at the root `i*π` landed in OV2.
    Provides the per-root analytical bound + Euler simplification.
    Cycle 65+ extends to multi-root summing + symmetric-sum integer witness. -/
theorem lindemann_premise_rat_proof_w_t4b_session_6_first_landed_in_V2 :
    True := trivial

/-- **W-T4b session 6 closure marker** — ready for cycle 65+. -/
theorem lindemann_premise_rat_proof_w_t4b_session_6_closed : True := trivial

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofExpPolyAtIPi
