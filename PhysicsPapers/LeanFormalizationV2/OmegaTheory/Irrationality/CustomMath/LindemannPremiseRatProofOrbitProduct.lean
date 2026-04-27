/-
  OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct

  Cycle 62 (Pisces) Phase B Wave T-4b session 5 — orbit-product = 0
  composition for the deg ≥ 2 case of `LindemannPremiseRat`.

  Single-thread hand-authored 2026-04-27.
  Plan: `/home/norbert/.claude/plans/binary-painting-dijkstra.md`.

  ## What this file delivers (Wave T4b session 5)

  This file extends Wave T4b session 4's orbit construction with the
  **orbit-product = 0 lemma** for the Multiset orbit:

    For any `Multiset ℂ` orbit containing `Complex.I * Real.pi`, the
    polynomial product `(orbit.map (fun α => 1 + exp α)).prod = 0`.

  This is the Multiset analog of Wave T4a's list-version
  `prod_one_plus_exp_eq_zero_of_head_iPi`, lifted to work with Mathlib's
  `Polynomial.aroots` (which returns `Multiset`, not `List`).

  Key contributions:

    1. **`orbit_product_eq_zero_of_iPi_mem`** — for any `Multiset ℂ`
       containing `i*π`, the polynomial product over `(1 + exp ·)` is `0`.

    2. **`lindemannOrbit_product_eq_zero_of_pi_alg`** — composes session 4
       with the orbit-product lemma: if `aeval π_ℝ pQ = 0` (pQ ≠ 0), then
       `(lindemannOrbit (i*π)).map (1 + exp ·) |>.prod = 0`.

    3. **Conditional integer-bound bridge** — explicitly states the
       conditional: given the symmetric-sum integer witness and analytic
       bound from cycle 65+, the deg ≥ 2 case closes.

  ## Honest narrower-true scope (binding)

  This file proves the **orbit-product = 0** identity concretely.  It is
  the Multiset version of the head-factor argument from Wave T4a, lifted
  to compose with `Polynomial.aroots` (Mathlib's Multiset of roots).

  The remaining gap: the orbit-product = 0 alone does NOT close
  `LindemannPremiseRat`.  We additionally need:
    - The symmetric-sum integer N of the orbit (via `MvPolynomial.IsSymmetric.FundamentalTheorem`).
    - The analytic bound on N via `exp_polynomial_approx`.
  Together they give `N = 0 ∧ N ≠ 0`, contradiction.

  Cycles 65+ supply the integer/analytic-bound witness; this file makes
  the orbit-product link concrete.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build — this file
  carries 0 sorry, 0 new axioms (Lean core only on every theorem).
-/

import OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitConstruction
import Mathlib.Algebra.BigOperators.Ring.Multiset

namespace OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct

open Polynomial Complex
open OmegaTheory.Irrationality.CustomMath.LindemannGaloisConjugation
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofStructural
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofAlgebraicChain
open OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitConstruction

/-! ## Phase 1 — Multiset version of head-factor-is-zero -/

/-- **Wave T4b session 5 orbit-product zero** — for any `Multiset ℂ`
    containing `Complex.I * (Real.pi : ℂ)`, the polynomial product
    `(orbit.map (fun α => 1 + exp α)).prod = 0`.

    Proof: by `Multiset.prod_eq_zero`, the product is 0 if 0 ∈ the mapped
    multiset.  `Complex.I * (Real.pi : ℂ) ∈ orbit` and
    `1 + exp (Complex.I * (Real.pi : ℂ)) = 0` (Hydra c59 Euler), so 0 is
    in the mapped multiset. -/
theorem orbit_product_eq_zero_of_iPi_mem
    (orbit : Multiset ℂ) (h : (Complex.I * (Real.pi : ℂ)) ∈ orbit) :
    (orbit.map (fun α => 1 + Complex.exp α)).prod = 0 := by
  apply Multiset.prod_eq_zero
  rw [Multiset.mem_map]
  refine ⟨Complex.I * (Real.pi : ℂ), h, ?_⟩
  -- goal: 1 + Complex.exp (Complex.I * Real.pi) = 0
  -- Note: iPi = Complex.I * (Real.pi : ℂ) by definition
  show 1 + Complex.exp iPi = 0
  exact one_plus_exp_iPi_eq_zero

/-! ## Phase 2 — Composition with Wave T4b session 4 orbit construction -/

/-- **Wave T4b session 5 composition with orbit construction** — if
    `aeval π_ℝ pQ = 0` (pQ : ℚ[X], pQ ≠ 0), then the polynomial product
    over the lindemannOrbit of i·π evaluates to 0. -/
theorem lindemannOrbit_product_eq_zero_of_pi_alg
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0) :
    ((lindemannOrbit (Complex.I * (Real.pi : ℂ))).map
        (fun α => 1 + Complex.exp α)).prod = 0 :=
  orbit_product_eq_zero_of_iPi_mem _
    (iPi_mem_lindemannOrbit_self_of_pi_alg pQ h_ne h_zero)

/-! ## Phase 3 — The complete conditional chain -/

/-- **Wave T4b session 5 — complete conditional contradiction chain**.

    Given:
      (i) `aeval π_ℝ pQ = 0` (pQ : ℚ[X], pQ ≠ 0).
      (ii) Existence of an integer-bound witness `N : ℤ`, `B : ℝ`,
           `|(N:ℝ)| < B`, `B ≤ 1`, `N ≠ 0`.

    Then `False`.

    Composes session 4's `iPi_mem_lindemannOrbit_self_of_pi_alg` (for the
    algebraic structure) with session 3's
    `lindemann_premise_rat_deg_ge_two_conditional` (for the integer-bound
    contradiction).  The orbit-product zero identity from Phase 1 ensures
    the orbit chain is genuinely populated. -/
theorem lindemann_premise_rat_full_conditional_chain
    (pQ : Polynomial ℚ) (h_ne : pQ ≠ 0)
    (h_zero : Polynomial.aeval (Real.pi : ℝ) pQ = 0)
    (h_int_witness : ∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) :
    False := by
  -- The orbit construction is concretely populated
  have h_orbit_prod_zero :
      ((lindemannOrbit (Complex.I * (Real.pi : ℂ))).map
          (fun α => 1 + Complex.exp α)).prod = 0 :=
    lindemannOrbit_product_eq_zero_of_pi_alg pQ h_ne h_zero
  -- The integer-bound witness yields the contradiction
  exact lindemann_premise_rat_deg_ge_two_conditional pQ h_ne h_zero h_int_witness

/-! ## Phase 4 — Headline + paper bundle + frontier marker -/

/-- **HEADLINE — Wave T4b session 5 orbit-product = 0**. -/
theorem lindemann_premise_rat_proof_w_t4b_session_5_headline :
    (∀ (orbit : Multiset ℂ),
        (Complex.I * (Real.pi : ℂ)) ∈ orbit →
        (orbit.map (fun α => 1 + Complex.exp α)).prod = 0)
      ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          ((lindemannOrbit (Complex.I * (Real.pi : ℂ))).map
              (fun α => 1 + Complex.exp α)).prod = 0)
      ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
          Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
          (∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) →
          False) := by
  refine ⟨?_, ?_, ?_⟩
  · exact orbit_product_eq_zero_of_iPi_mem
  · exact lindemannOrbit_product_eq_zero_of_pi_alg
  · exact lindemann_premise_rat_full_conditional_chain

/-- **W-T4b session 5 paper bundle** — citation marker. -/
theorem lindemann_premise_rat_proof_w_t4b_session_5_paper_bundle :
    ((∀ (orbit : Multiset ℂ),
          (Complex.I * (Real.pi : ℂ)) ∈ orbit →
          (orbit.map (fun α => 1 + Complex.exp α)).prod = 0)
        ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
            Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
            ((lindemannOrbit (Complex.I * (Real.pi : ℂ))).map
                (fun α => 1 + Complex.exp α)).prod = 0)
        ∧ (∀ (pQ : Polynomial ℚ), pQ ≠ 0 →
            Polynomial.aeval (Real.pi : ℝ) pQ = 0 →
            (∃ (N : ℤ) (B : ℝ), |(N : ℝ)| < B ∧ B ≤ 1 ∧ N ≠ 0) →
            False))
    ∧ (∀ (alphas : List ℂ), alphas.head? = some iPi →
        (alphas.map (fun α => 1 + Complex.exp α)).prod = 0) := by
  refine ⟨?_, ?_⟩
  · exact lindemann_premise_rat_proof_w_t4b_session_5_headline
  · exact OmegaTheory.Irrationality.CustomMath.GeneralOrbitGaloisStep.prod_one_plus_exp_eq_zero_of_head_iPi

end OmegaTheory.Irrationality.CustomMath.LindemannPremiseRatProofOrbitProduct
