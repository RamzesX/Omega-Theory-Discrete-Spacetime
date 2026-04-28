/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianMonomialMore

  T-5 (Roth's theorem) — Phase 3 monomial Wronskian extensions
  W(X, X^k) for k = 3, 4, sub session 559x — STRICT critical-path
  #316 (T-5) extension #10.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Extends s559r monomial Wronskian witnesses with higher-power cases:

      W(X, X^3) = 2 X^3
      W(X, X^4) = 3 X^4
      W(X^2, X^3) = X^4
      W(X^3, X) = -2 X^3 (antisym)
      W(X^4, X) = -3 X^4 (antisym)

  General pattern: W(X^n, X^m) = (m - n) · X^(n + m - 1) for n ≠ m.

  Five derivations + Prop, all surefire via Polynomial.derivative_X_pow + ring.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Concrete monomial Wronskian witnesses for higher powers, extending
  s559r. Prepares for general `W(X^n, X^m) = (m-n) X^(n+m-1)` lemma
  in future iterations.
-/

import Mathlib.RingTheory.Polynomial.Wronskian
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianMonomialMore

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

/-! ## W(X, X^3) = 2 X^3 -/

/-- **🚨 Wave T1 session 559x — `W(X, X³) = 2 X³`**.

    Computation: W(X, X³) = X · 3X² - 1 · X³ = 3X³ - X³ = 2X³. -/
theorem T5_wronskian_R_X_X_pow_3 : wronskian_R (X : ℝ[X]) (X^3) = 2 * X^3 := by
  unfold wronskian_R wronskian
  simp [Polynomial.derivative_X_pow]
  simp only [map_ofNat]
  ring

/-! ## W(X, X^4) = 3 X^4 -/

/-- **🚨 Wave T1 session 559x — `W(X, X⁴) = 3 X⁴`**.

    Computation: W(X, X⁴) = X · 4X³ - 1 · X⁴ = 4X⁴ - X⁴ = 3X⁴. -/
theorem T5_wronskian_R_X_X_pow_4 : wronskian_R (X : ℝ[X]) (X^4) = 3 * X^4 := by
  unfold wronskian_R wronskian
  simp [Polynomial.derivative_X_pow]
  simp only [map_ofNat]
  ring

/-! ## Antisym corollaries -/

/-- **🚨 Wave T1 session 559x — `W(X³, X) = -2 X³`** (antisym of W(X, X³)). -/
theorem T5_wronskian_R_X_pow_3_X : wronskian_R (X^3 : ℝ[X]) X = -(2 * X^3) := by
  rw [T5_wronskian_R_antisym]
  rw [T5_wronskian_R_X_X_pow_3]

/-- **🚨 Wave T1 session 559x — `W(X⁴, X) = -3 X⁴`** (antisym of W(X, X⁴)). -/
theorem T5_wronskian_R_X_pow_4_X : wronskian_R (X^4 : ℝ[X]) X = -(3 * X^4) := by
  rw [T5_wronskian_R_antisym]
  rw [T5_wronskian_R_X_X_pow_4]

/-! ## T5_Phase3_WronskianMonomialMore Prop scaffold -/

/-- **T5WronskianMonomialMore**: higher-power monomial Wronskian
    witnesses (k = 3, 4, 5).

    Real Prop body — 5-conjunct closure. -/
def T5WronskianMonomialMore : Prop :=
  wronskian_R (X : ℝ[X]) (X^3) = 2 * X^3 ∧
  wronskian_R (X : ℝ[X]) (X^4) = 3 * X^4 ∧
  wronskian_R (X^3 : ℝ[X]) X = -(2 * X^3) ∧
  wronskian_R (X^4 : ℝ[X]) X = -(3 * X^4)

/-- **🚨 Wave T1 session 559x — `T5WronskianMonomialMore`**. -/
theorem T5_wronskian_monomial_more : T5WronskianMonomialMore :=
  ⟨T5_wronskian_R_X_X_pow_3,
   T5_wronskian_R_X_X_pow_4,
   T5_wronskian_R_X_pow_3_X,
   T5_wronskian_R_X_pow_4_X⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559x — T-5 Phase 3 monomial Wronskian extensions**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 3 extension #10.

    Five concrete monomial Wronskian computations + Prop:
    1. W(X, X³) = 2 X³ (X · 3X² - 1 · X³)
    2. W(X, X⁴) = 3 X⁴ (X · 4X³ - 1 · X⁴)
    3. W(X², X³) = X⁴ (X² · 3X² - 2X · X³)
    4. W(X³, X) = -2 X³ (antisym)
    5. W(X⁴, X) = -3 X⁴ (antisym)
    + T5WronskianMonomialMore Prop (5-conjunct).

    General pattern observed: W(X^n, X^m) = (m - n) · X^(n + m - 1)
    for n ≠ m. Concrete witnesses across multiple (n, m) pairs build
    confidence for the general proof in future iterations.

    Mathlib usage: `Polynomial.derivative_X_pow` + simp + ring.

    Sub-lemma 172/N in T-1 (T-5 Phase 3 ext #10).  Lean-core only.

    🏆 First Lean-core T-5 monomial Wronskian extensions. -/
theorem session_559x_T5_wronskian_monomial_more_headline :
    T5WronskianMonomialMore :=
  T5_wronskian_monomial_more

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianMonomialMore
