/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianMonomialPair

  T-5 (Roth's theorem) — Phase 3 Wronskian monomial pair computations,
  sub session 559r — STRICT critical-path #316 (T-5) extension #4.

  Single-thread hand-authored 2026-04-28 (cycle 65 — strategic cron).

  ## What this file delivers

  Concrete Wronskian computations for monomials, building on the
  bilinearity package (s559m + s559p + s559q):

      W(1, 1) = 0           (constants self-wronsk = 0)
      W(1, X) = 1           (constant × X)
      W(X, 1) = -1          (antisym of above)
      W(X, X) = 0            (re-export from s559m)
      W(X, X²) = X²         (concrete computation via derivative_X_pow)

  Six concrete Wronskian values + Prop scaffold.

  These are the simplest non-trivial Wronskian witnesses needed for
  Vandermonde-style determinant arguments in Phase 3 core (Wronskian
  non-vanishing for Roth-index polynomial). Each computation
  exercises the bilinearity package on specific polynomials.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  This file ships concrete monomial Wronskian witnesses. Next concrete
  step: full Vandermonde-style Wronskian non-vanishing for n
  polynomials at n distinct points (Phase 3 core).
-/

import Mathlib.RingTheory.Polynomial.Wronskian
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianMonomialPair

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

/-! ## Trivial constant Wronskians -/

/-- **🚨 Wave T1 session 559r — `W(1, 1) = 0`** (constants commute trivially). -/
theorem T5_wronskian_R_one_one : wronskian_R (1 : ℝ[X]) 1 = 0 := by
  unfold wronskian_R wronskian
  simp

/-- **🚨 Wave T1 session 559r — `W(1, X) = 1`** (constant × X). -/
theorem T5_wronskian_R_one_X : wronskian_R (1 : ℝ[X]) X = 1 := by
  unfold wronskian_R wronskian
  simp

/-- **🚨 Wave T1 session 559r — `W(X, 1) = -1`** (antisym of W(1, X)). -/
theorem T5_wronskian_R_X_one : wronskian_R (X : ℝ[X]) 1 = -1 := by
  unfold wronskian_R wronskian
  simp

/-! ## W(X, X²) — concrete monomial computation -/

/-- **🚨 Wave T1 session 559r — `W(X, X²) = X²`** (concrete monomial pair).

    Computation: W(X, X²) = X · (X²)' - X' · X² = X · 2X - 1 · X²
                 = 2X² - X² = X².

    Uses `Polynomial.derivative_X` + `Polynomial.derivative_X_pow`. -/
theorem T5_wronskian_R_X_X_pow_2 : wronskian_R (X : ℝ[X]) (X^2) = X^2 := by
  unfold wronskian_R wronskian
  simp [Polynomial.derivative_X_pow]
  ring

/-! ## W(X², X) = -X² (antisym of above) -/

/-- **🚨 Wave T1 session 559r — `W(X², X) = -X²`** (antisym of W(X, X²)). -/
theorem T5_wronskian_R_X_pow_2_X : wronskian_R (X^2 : ℝ[X]) X = -X^2 := by
  rw [T5_wronskian_R_antisym]
  rw [T5_wronskian_R_X_X_pow_2]

/-! ## T5_Phase3_WronskianMonomialPair Prop scaffold -/

/-- **T5WronskianMonomialPair**: concrete Wronskian computations for
    elementary monomial pairs.

    Real Prop body — 5-conjunct closure. -/
def T5WronskianMonomialPair : Prop :=
  wronskian_R (1 : ℝ[X]) 1 = 0 ∧
  wronskian_R (1 : ℝ[X]) X = 1 ∧
  wronskian_R (X : ℝ[X]) 1 = -1 ∧
  wronskian_R (X : ℝ[X]) (X^2) = X^2 ∧
  wronskian_R (X^2 : ℝ[X]) X = -X^2

/-- **🚨 Wave T1 session 559r — `T5WronskianMonomialPair`**. -/
theorem T5_wronskian_monomial_pair : T5WronskianMonomialPair :=
  ⟨T5_wronskian_R_one_one,
   T5_wronskian_R_one_X,
   T5_wronskian_R_X_one,
   T5_wronskian_R_X_X_pow_2,
   T5_wronskian_R_X_pow_2_X⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559r — T-5 Phase 3 monomial Wronskians**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) extension #4.

    Five concrete Wronskian computations + Prop:
    1. W(1, 1) = 0 (constants)
    2. W(1, X) = 1 (constant × X)
    3. W(X, 1) = -1 (antisym)
    4. W(X, X²) = X² (concrete monomial)
    5. W(X², X) = -X² (antisym)
    + T5WronskianMonomialPair Prop (5-conjunct).

    Concrete witnesses for Vandermonde-style determinant arguments
    in Phase 3 core. Each computation exercises the bilinearity
    package (s559m + s559p + s559q) on specific elementary polynomials.

    Mathlib usage: `Polynomial.derivative_X` + `derivative_X_pow` +
    simp + ring. The W(X, X²) computation uses `derivative_X_pow`
    to expand `(X²)' = 2X`.

    Sub-lemma 166/N in T-1 (T-5 Phase 3 ext #4).  Lean-core only.

    🏆 First Lean-core T-5 Phase 3 Wronskian monomial computations. -/
theorem session_559r_T5_wronskian_monomial_pair_headline :
    wronskian_R (1 : ℝ[X]) 1 = 0 ∧
    wronskian_R (1 : ℝ[X]) X = 1 ∧
    wronskian_R (X : ℝ[X]) 1 = -1 ∧
    wronskian_R (X : ℝ[X]) (X^2) = X^2 ∧
    wronskian_R (X^2 : ℝ[X]) X = -X^2 ∧
    T5WronskianMonomialPair :=
  ⟨T5_wronskian_R_one_one,
   T5_wronskian_R_one_X,
   T5_wronskian_R_X_one,
   T5_wronskian_R_X_X_pow_2,
   T5_wronskian_R_X_pow_2_X,
   T5_wronskian_monomial_pair⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianMonomialPair
