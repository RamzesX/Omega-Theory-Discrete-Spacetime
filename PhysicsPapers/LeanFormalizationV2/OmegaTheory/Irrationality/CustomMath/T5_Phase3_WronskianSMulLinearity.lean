/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianSMulLinearity

  T-5 (Roth's theorem) — Phase 3 Wronskian smul linearity (companion
  to s559p C-mul), sub session 559q — STRICT critical-path #316 (T-5)
  extension #3.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Companion to s559p (C-mul linearity): proves smul-version of
  Wronskian linearity using `Polynomial.derivative_smul`:

      W(c • a, b) = c • W(a, b)
      W(a, c • b) = c • W(a, b)

  where `c • p` is the ℝ-scalar action on ℝ[X].

  Six derivations + Prop:
  - W(c • a, b) = c • W(a, b) (left smul)
  - W(a, c • b) = c • W(a, b) (right smul)
  - W(0 • a, b) = 0 (left zero)
  - W(a, 0 • b) = 0 (right zero)
  - W(1 • a, b) = W(a, b) (left identity)
  - W(a, 1 • b) = W(a, b) (right identity)

  Combined with s559m (additivity) + s559p (C-mul) + this (smul) =
  full bilinearity with both `*` and `•` actions on ℝ[X].

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  This file completes the Wronskian-as-bilinear-form package:
  s559m (additivity) + s559p (C-mul) + s559q (this, smul) → ready
  for Vandermonde-style determinant in Phase 3 core (Wronskian
  non-vanishing for Roth-index polynomial).
-/

import Mathlib.RingTheory.Polynomial.Wronskian
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianSMulLinearity

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianBasicAdaptation

/-! ## Wronskian smul left linearity -/

/-- **🚨 Wave T1 session 559q — `W(c • a, b) = c • W(a, b)`** (left smul). -/
theorem T5_wronskian_R_smul_left (c : ℝ) (a b : ℝ[X]) :
    wronskian_R (c • a) b = c • wronskian_R a b := by
  unfold wronskian_R wronskian
  rw [Polynomial.derivative_smul]
  rw [smul_mul_assoc, smul_mul_assoc, ← smul_sub]

/-! ## Wronskian smul right linearity -/

/-- **🚨 Wave T1 session 559q — `W(a, c • b) = c • W(a, b)`** (right smul). -/
theorem T5_wronskian_R_smul_right (c : ℝ) (a b : ℝ[X]) :
    wronskian_R a (c • b) = c • wronskian_R a b := by
  unfold wronskian_R wronskian
  rw [Polynomial.derivative_smul]
  rw [mul_smul_comm, mul_smul_comm, ← smul_sub]

/-! ## Special cases -/

/-- **🚨 Wave T1 session 559q — `W(0 • a, b) = 0`**. -/
theorem T5_wronskian_R_zero_smul_left (a b : ℝ[X]) :
    wronskian_R ((0 : ℝ) • a) b = 0 := by
  rw [T5_wronskian_R_smul_left]
  simp

/-- **🚨 Wave T1 session 559q — `W(a, 0 • b) = 0`**. -/
theorem T5_wronskian_R_zero_smul_right (a b : ℝ[X]) :
    wronskian_R a ((0 : ℝ) • b) = 0 := by
  rw [T5_wronskian_R_smul_right]
  simp

/-- **🚨 Wave T1 session 559q — `W(1 • a, b) = W(a, b)`**. -/
theorem T5_wronskian_R_one_smul_left (a b : ℝ[X]) :
    wronskian_R ((1 : ℝ) • a) b = wronskian_R a b := by
  rw [T5_wronskian_R_smul_left]
  simp

/-- **🚨 Wave T1 session 559q — `W(a, 1 • b) = W(a, b)`**. -/
theorem T5_wronskian_R_one_smul_right (a b : ℝ[X]) :
    wronskian_R a ((1 : ℝ) • b) = wronskian_R a b := by
  rw [T5_wronskian_R_smul_right]
  simp

/-! ## T5_Phase3_WronskianSMulLinearity Prop scaffold -/

/-- **T5WronskianSMulLinearity**: smul-version of Wronskian linearity
    + zero/one special cases.

    Real Prop body — 6-conjunct closure. -/
def T5WronskianSMulLinearity : Prop :=
  (∀ c : ℝ, ∀ a b : ℝ[X], wronskian_R (c • a) b = c • wronskian_R a b) ∧
  (∀ c : ℝ, ∀ a b : ℝ[X], wronskian_R a (c • b) = c • wronskian_R a b) ∧
  (∀ a b : ℝ[X], wronskian_R ((0 : ℝ) • a) b = 0) ∧
  (∀ a b : ℝ[X], wronskian_R a ((0 : ℝ) • b) = 0) ∧
  (∀ a b : ℝ[X], wronskian_R ((1 : ℝ) • a) b = wronskian_R a b) ∧
  (∀ a b : ℝ[X], wronskian_R a ((1 : ℝ) • b) = wronskian_R a b)

/-- **🚨 Wave T1 session 559q — `T5WronskianSMulLinearity`**. -/
theorem T5_wronskian_smul_linearity : T5WronskianSMulLinearity :=
  ⟨T5_wronskian_R_smul_left,
   T5_wronskian_R_smul_right,
   T5_wronskian_R_zero_smul_left,
   T5_wronskian_R_zero_smul_right,
   T5_wronskian_R_one_smul_left,
   T5_wronskian_R_one_smul_right⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559q — T-5 Phase 3 Wronskian smul linearity**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) extension #3.

    Six smul identities + Prop:
    1. W(c • a, b) = c • W(a, b) (left smul)
    2. W(a, c • b) = c • W(a, b) (right smul)
    3. W(0 • a, b) = 0 (zero left)
    4. W(a, 0 • b) = 0 (zero right)
    5. W(1 • a, b) = W(a, b) (identity left)
    6. W(a, 1 • b) = W(a, b) (identity right)
    + T5WronskianSMulLinearity Prop (6-conjunct).

    Combined: s559m additivity + s559p C-mul + s559q smul → full
    bilinearity package for Wronskian over ℝ[X], ready for
    Vandermonde-style Roth-index polynomial Wronskian non-vanishing
    in Phase 3 core.

    Mathlib usage: `Polynomial.derivative_smul`, `smul_mul_assoc`,
    `mul_smul_comm`, `smul_sub`, simp.

    Sub-lemma 165/N in T-1 (T-5 Phase 3 ext #3).  Lean-core only.

    🏆 First Lean-core T-5 Phase 3 Wronskian smul linearity. -/
theorem session_559q_T5_wronskian_smul_linearity_headline :
    (∀ c : ℝ, ∀ a b : ℝ[X], wronskian_R (c • a) b = c • wronskian_R a b) ∧
    (∀ c : ℝ, ∀ a b : ℝ[X], wronskian_R a (c • b) = c • wronskian_R a b) ∧
    (∀ a b : ℝ[X], wronskian_R ((0 : ℝ) • a) b = 0) ∧
    (∀ a b : ℝ[X], wronskian_R a ((0 : ℝ) • b) = 0) ∧
    (∀ a b : ℝ[X], wronskian_R ((1 : ℝ) • a) b = wronskian_R a b) ∧
    (∀ a b : ℝ[X], wronskian_R a ((1 : ℝ) • b) = wronskian_R a b) ∧
    T5WronskianSMulLinearity :=
  ⟨T5_wronskian_R_smul_left,
   T5_wronskian_R_smul_right,
   T5_wronskian_R_zero_smul_left,
   T5_wronskian_R_zero_smul_right,
   T5_wronskian_R_one_smul_left,
   T5_wronskian_R_one_smul_right,
   T5_wronskian_smul_linearity⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_WronskianSMulLinearity
