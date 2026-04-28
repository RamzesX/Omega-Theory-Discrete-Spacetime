/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianCMulLinearity

  T-5 (Roth's theorem) — Phase 3 Wronskian C-mul linearity,
  sub session 559p — STRICT critical-path #316 (T-5) extension #2.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Extends s559m with C-multiplication linearity for the Wronskian:

      W(C c · a, b) = C c · W(a, b)
      W(a, C c · b) = C c · W(a, b)

  where `C c : ℝ[X]` is the constant polynomial of value c.

  Combined with s559m's additivity, this gives full BILINEARITY in
  both arguments — essential for Vandermonde-style determinant
  arguments in the Roth-index Wronskian non-vanishing proof.

  Six derivations + Prop:
  - W(C c · a, b) = C c · W(a, b) (left C-mul)
  - W(a, C c · b) = C c · W(a, b) (right C-mul)
  - W(C 0 · a, b) = 0 (left zero scalar)
  - W(a, C 0 · b) = 0 (right zero scalar)
  - W(C 1 · a, b) = W(a, b) (left identity scalar)
  - W(a, C 1 · b) = W(a, b) (right identity scalar)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  This file extends s559m with C-mul linearity. Combined they ship
  full bilinearity (additivity from s559m + scalar-mul from this file).
  Next concrete step: Wronskian non-vanishing for Roth-index polynomial
  via Vandermonde-style determinant (~150-200 lines, medium risk per
  crawler intel).
-/

import Mathlib.RingTheory.Polynomial.Wronskian
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Ring
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianCMulLinearity

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

/-! ## Wronskian C-mul left linearity -/

/-- **🚨 Wave T1 session 559p — `W(C c · a, b) = C c · W(a, b)`** (left C-mul).

    Proof: `(C c · a)' = C c · a'` (since `(C c)' = 0`), so
    `W(C c · a, b) = C c · a · b' - C c · a' · b = C c · (a · b' - a' · b)`. -/
theorem T5_wronskian_R_C_mul_left (c : ℝ) (a b : ℝ[X]) :
    wronskian_R (Polynomial.C c * a) b = Polynomial.C c * wronskian_R a b := by
  unfold wronskian_R wronskian
  rw [Polynomial.derivative_C_mul]
  ring

/-! ## Wronskian C-mul right linearity -/

/-- **🚨 Wave T1 session 559p — `W(a, C c · b) = C c · W(a, b)`** (right C-mul). -/
theorem T5_wronskian_R_C_mul_right (c : ℝ) (a b : ℝ[X]) :
    wronskian_R a (Polynomial.C c * b) = Polynomial.C c * wronskian_R a b := by
  unfold wronskian_R wronskian
  rw [Polynomial.derivative_C_mul]
  ring

/-! ## Special cases: zero and identity scalars -/

/-- **🚨 Wave T1 session 559p — `W(C 0 · a, b) = 0`**. -/
theorem T5_wronskian_R_C_zero_left (a b : ℝ[X]) :
    wronskian_R (Polynomial.C 0 * a) b = 0 := by
  rw [T5_wronskian_R_C_mul_left]
  simp

/-- **🚨 Wave T1 session 559p — `W(a, C 0 · b) = 0`**. -/
theorem T5_wronskian_R_C_zero_right (a b : ℝ[X]) :
    wronskian_R a (Polynomial.C 0 * b) = 0 := by
  rw [T5_wronskian_R_C_mul_right]
  simp

/-- **🚨 Wave T1 session 559p — `W(C 1 · a, b) = W(a, b)`**. -/
theorem T5_wronskian_R_C_one_left (a b : ℝ[X]) :
    wronskian_R (Polynomial.C 1 * a) b = wronskian_R a b := by
  rw [T5_wronskian_R_C_mul_left]
  simp

/-- **🚨 Wave T1 session 559p — `W(a, C 1 · b) = W(a, b)`**. -/
theorem T5_wronskian_R_C_one_right (a b : ℝ[X]) :
    wronskian_R a (Polynomial.C 1 * b) = wronskian_R a b := by
  rw [T5_wronskian_R_C_mul_right]
  simp

/-! ## T5_Phase3_WronskianCMulLinearity Prop scaffold -/

/-- **T5WronskianCMulLinearity**: full C-mul linearity for the
    Wronskian + zero/identity special cases.

    Real Prop body — 6-conjunct closure. -/
def T5WronskianCMulLinearity : Prop :=
  (∀ c : ℝ, ∀ a b : ℝ[X],
    wronskian_R (Polynomial.C c * a) b = Polynomial.C c * wronskian_R a b) ∧
  (∀ c : ℝ, ∀ a b : ℝ[X],
    wronskian_R a (Polynomial.C c * b) = Polynomial.C c * wronskian_R a b) ∧
  (∀ a b : ℝ[X], wronskian_R (Polynomial.C 0 * a) b = 0) ∧
  (∀ a b : ℝ[X], wronskian_R a (Polynomial.C 0 * b) = 0) ∧
  (∀ a b : ℝ[X], wronskian_R (Polynomial.C 1 * a) b = wronskian_R a b) ∧
  (∀ a b : ℝ[X], wronskian_R a (Polynomial.C 1 * b) = wronskian_R a b)

/-- **🚨 Wave T1 session 559p — `T5WronskianCMulLinearity`**. -/
theorem T5_wronskian_C_mul_linearity : T5WronskianCMulLinearity :=
  ⟨T5_wronskian_R_C_mul_left,
   T5_wronskian_R_C_mul_right,
   T5_wronskian_R_C_zero_left,
   T5_wronskian_R_C_zero_right,
   T5_wronskian_R_C_one_left,
   T5_wronskian_R_C_one_right⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559p — T-5 Phase 3 Wronskian C-mul linearity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) extension #2.

    Six C-mul identities + Prop:
    1. W(C c · a, b) = C c · W(a, b) (left C-mul)
    2. W(a, C c · b) = C c · W(a, b) (right C-mul)
    3. W(C 0 · a, b) = 0 (zero left)
    4. W(a, C 0 · b) = 0 (zero right)
    5. W(C 1 · a, b) = W(a, b) (identity left)
    6. W(a, C 1 · b) = W(a, b) (identity right)
    + T5WronskianCMulLinearity Prop (6-conjunct).

    Combined with s559m's additivity, this gives full BILINEARITY in
    both arguments — essential for Vandermonde-style determinant
    arguments in the Phase 3 core (Wronskian non-vanishing for
    Roth-index polynomial).

    Mathlib usage: `Polynomial.derivative_C_mul`, ring, simp.

    Sub-lemma 164/N in T-1 (T-5 Phase 3 extension #2).  Lean-core only.

    🏆 First Lean-core T-5 Phase 3 Wronskian C-mul linearity. -/
theorem session_559p_T5_wronskian_C_mul_linearity_headline :
    (∀ c : ℝ, ∀ a b : ℝ[X],
      wronskian_R (Polynomial.C c * a) b = Polynomial.C c * wronskian_R a b) ∧
    (∀ c : ℝ, ∀ a b : ℝ[X],
      wronskian_R a (Polynomial.C c * b) = Polynomial.C c * wronskian_R a b) ∧
    (∀ a b : ℝ[X], wronskian_R (Polynomial.C 0 * a) b = 0) ∧
    (∀ a b : ℝ[X], wronskian_R a (Polynomial.C 0 * b) = 0) ∧
    (∀ a b : ℝ[X], wronskian_R (Polynomial.C 1 * a) b = wronskian_R a b) ∧
    (∀ a b : ℝ[X], wronskian_R a (Polynomial.C 1 * b) = wronskian_R a b) ∧
    T5WronskianCMulLinearity :=
  ⟨T5_wronskian_R_C_mul_left,
   T5_wronskian_R_C_mul_right,
   T5_wronskian_R_C_zero_left,
   T5_wronskian_R_C_zero_right,
   T5_wronskian_R_C_one_left,
   T5_wronskian_R_C_one_right,
   T5_wronskian_C_mul_linearity⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianCMulLinearity
