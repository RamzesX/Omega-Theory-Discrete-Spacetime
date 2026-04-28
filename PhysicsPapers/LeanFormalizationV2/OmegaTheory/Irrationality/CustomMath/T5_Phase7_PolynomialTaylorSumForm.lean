/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorSumForm

  T-5 (Roth's theorem) — **Phase 7 ext #99: Taylor expansion sum form
  at root α (cubic+ chain step 4 core)**, sub session 559yyyyy —
  STRICT critical-path #316 (T-5) Phase 7 ext #99.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Combines ext #98 (Polynomial.taylor at root) with Mathlib's
  `Polynomial.eval_eq_sum_range` to give the explicit sum form:

  For p ∈ R[X] (R CommRing), α, q : R:
    `p.eval q = ∑ i ∈ Finset.range (p.natDegree + 1),
                    (Polynomial.taylor α p).coeff i * (q - α)^i`

  When α is a root of p, the i = 0 term vanishes (coeff 0 = 0).

  Single derivation:
  1. `T5_polynomial_taylor_eval_sum_form`: explicit sum expansion.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #99 — Taylor sum form at root (cubic+ step 4 core).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAtRoot
import Mathlib.Algebra.Polynomial.Eval.Degree

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorSumForm

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorAtRoot

/-! ## Taylor expansion sum form -/

/-- **🚨 Wave T5 session 559yyyyy — Taylor sum form**.

    For p ∈ R[X], α, q : R:
      `p.eval q = ∑ i ∈ range(p.natDegree + 1),
                     (taylor α p).coeff i * (q - α)^i`. -/
theorem T5_polynomial_taylor_eval_sum_form
    {R : Type*} [CommRing R] (p : Polynomial R) (α q : R) :
    p.eval q = ∑ i ∈ Finset.range ((Polynomial.taylor α p).natDegree + 1),
                  (Polynomial.taylor α p).coeff i * (q - α) ^ i := by
  rw [T5_polynomial_eval_eq_taylor_eval p α q]
  exact Polynomial.eval_eq_sum_range (q - α)

/-- **🚨 Wave T5 session 559yyyyy — Taylor sum form using p.natDegree**.

    Convenience: same sum bounded by p.natDegree (taylor preserves natDegree). -/
theorem T5_polynomial_taylor_eval_sum_form_natDegree
    {R : Type*} [CommRing R] (p : Polynomial R) (α q : R) :
    p.eval q = ∑ i ∈ Finset.range (p.natDegree + 1),
                  (Polynomial.taylor α p).coeff i * (q - α) ^ i := by
  rw [T5_polynomial_taylor_eval_sum_form p α q,
      Polynomial.natDegree_taylor]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559yyyyy — T-5 Phase 7 ext #99:
    Polynomial Taylor sum form at root α**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #99.

    🏆 STEP 4 CORE of cubic+ chain — explicit Taylor sum decomposition.

    Two derivations:
    1. `T5_polynomial_taylor_eval_sum_form` — sum bounded by taylor natDegree
    2. `T5_polynomial_taylor_eval_sum_form_natDegree` — sum bounded by p.natDegree

    Foundation: combined with cubic+ chain step 5 (integer non-vanishing
    |p(q)| ≥ 1/q.den^d) + index argument k > d/(2+ε) → Roth contradiction.

    For p with α as root of index ≥ k:
    - (taylor α p).coeff i = 0 for i < k
    - p.eval q = ∑ i ∈ [k, natDegree], (taylor α p).coeff i * (q - α)^i
    - |p.eval q| ≤ |q - α|^k · ∑ |(taylor α p).coeff i|

    Mathlib usage: `Polynomial.eval_eq_sum_range`, `Polynomial.natDegree_taylor`,
    ext #98 `T5_polynomial_eval_eq_taylor_eval`.

    Sub-lemma 272/N in T-1 (T-5 Phase 7 ext #99).  Lean-core only. -/
theorem session_559yyyyy_T5_phase7_polynomial_taylor_sum_form_headline
    {R : Type*} [CommRing R] (p : Polynomial R) (α q : R) :
    p.eval q = ∑ i ∈ Finset.range (p.natDegree + 1),
                  (Polynomial.taylor α p).coeff i * (q - α) ^ i :=
  T5_polynomial_taylor_eval_sum_form_natDegree p α q

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialTaylorSumForm
