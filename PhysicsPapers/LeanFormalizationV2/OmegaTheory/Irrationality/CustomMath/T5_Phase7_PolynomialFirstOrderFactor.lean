/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialFirstOrderFactor

  T-5 (Roth's theorem) — **Phase 7 ext #58: Polynomial first-order
  factorization at root α (cubic+ chain step 4 prep)**, sub session
  559yyyy — STRICT critical-path #316 (T-5) Phase 7 ext #58.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Univariate polynomial first-order factorization at a root:

  For p : Polynomial R (R commutative ring), α : R with p.IsRoot α
  (i.e., p.eval α = 0), there exists g : Polynomial R such that
  `p = (X - C α) * g`. Hence `p.eval q = (q - α) * g.eval q` for any
  q : R.

  This is **step 4 prep of the cubic+ Schmidt-Wirsing-Roth chain**:
  the foundation for Taylor expansion at α (we need the higher-order
  Taylor for cubic+ Roth, but first-order is the structural starting
  point).

  Two derivations:
  1. `T5_polynomial_first_order_factor`: ∃ g, p = (X - C α) * g
  2. `T5_polynomial_eval_at_q_minus_alpha`: p.eval q = (q - α) * g.eval q

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #58 — polynomial first-order factor (cubic+ step 4 prep).
-/

import Mathlib.Algebra.Polynomial.Div

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialFirstOrderFactor

open Polynomial

/-! ## First-order factorization at root α -/

/-- **🚨 Wave T5 session 559yyyy — First-order factor at root α**.

    For p : R[X] (R commutative ring) with p.IsRoot α (i.e., p.eval α = 0),
    there exists g : R[X] such that `p = (X - C α) * g`. -/
theorem T5_polynomial_first_order_factor {R : Type*} [CommRing R]
    (p : Polynomial R) (α : R) (hα : p.IsRoot α) :
    ∃ g : Polynomial R, p = (X - C α) * g := by
  -- Use Polynomial.dvd_iff_isRoot: (X - C α) ∣ p ↔ p.IsRoot α
  have h_dvd : (X - C α) ∣ p := Polynomial.dvd_iff_isRoot.mpr hα
  exact h_dvd

/-- **🚨 Wave T5 session 559yyyy — Eval as `(q - α) · g(q)`**.

    For p with root α, p.eval q factorizes as `(q - α) · g.eval q`. -/
theorem T5_polynomial_eval_at_q_minus_alpha {R : Type*} [CommRing R]
    (p : Polynomial R) (α : R) (hα : p.IsRoot α) (q : R) :
    ∃ g : Polynomial R, p.eval q = (q - α) * g.eval q := by
  obtain ⟨g, hg⟩ := T5_polynomial_first_order_factor p α hα
  refine ⟨g, ?_⟩
  rw [hg]
  rw [Polynomial.eval_mul, Polynomial.eval_sub, Polynomial.eval_X,
      Polynomial.eval_C]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559yyyy — T-5 Phase 7 ext #58:
    Polynomial first-order factor at root α**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #58.

    🏆 STEP 4 PREP of cubic+ Schmidt-Wirsing-Roth chain.

    Two derivations:
    1. `T5_polynomial_first_order_factor` — ∃ g, p = (X - C α) * g
       when p has α as root.
    2. `T5_polynomial_eval_at_q_minus_alpha` — eval factorization:
       p.eval q = (q - α) * g.eval q.

    Foundation for Taylor first-order expansion at α: `|p(q)| =
    |q - α| · |g(q)|`, where `g(q)` can be bounded above on any
    bounded interval. Combined with cubic+ chain step 5 (integer
    non-vanishing |p(q)| ≥ 1/q.den^d) gives the Liouville-form bound
    `|q - α| ≥ 1/(M · q.den^d)` for some constant M depending on g.

    For Roth's improvement to `1/H^(2+ε)`, requires HIGHER-ORDER
    Taylor (step 4 + Schmidt index argument).

    Mathlib usage: `Polynomial.dvd_iff_isRoot`, `Polynomial.eval_mul`,
    `Polynomial.eval_sub`, `Polynomial.eval_X`, `Polynomial.eval_C`.

    Sub-lemma 251/N in T-1 (T-5 Phase 7 ext #58).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 polynomial first-order factor at
    root — opens cubic+ Taylor expansion infrastructure. Escanor
    Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559yyyy_T5_phase7_polynomial_first_order_factor_headline
    {R : Type*} [CommRing R] (p : Polynomial R) (α : R) (hα : p.IsRoot α) :
    (∃ g : Polynomial R, p = (X - C α) * g) ∧
    (∀ (q : R), ∃ g : Polynomial R, p.eval q = (q - α) * g.eval q) :=
  ⟨T5_polynomial_first_order_factor p α hα,
   fun q => T5_polynomial_eval_at_q_minus_alpha p α hα q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialFirstOrderFactor
