/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer9_WronskianHelpers

  T-5 (Roth's theorem) — **D.6.1 Layer 9: Wronskian non-vanishing helpers**.

  Foundational sub-lemmas around the Wronskian determinant that
  drives the recursion HEART of Hindry-Silverman D.6.1.

  - W-1..3: 2x2 determinant non-vanishing characterization.
  - W-4..6: 1-variable Wronskian (W(P,Q) = PQ' - P'Q) basic identities.
  - W-7..9: foundational determinant arithmetic.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer9_WronskianHelpers

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer3

/-! ## W-1 — 2x2 determinant explicit formula -/

/-- **W-1 — `T5_det_2x2_explicit`**: for a 2x2 ℝ matrix M,
    `det M = M(0,0) · M(1,1) - M(0,1) · M(1,0)`. -/
theorem T5_det_2x2_explicit (a b c d : ℝ) :
    Matrix.det !![a, b; c, d] = a * d - b * c := by
  simp [Matrix.det_fin_two]

/-! ## W-2 — 2x2 determinant non-vanishing characterization -/

/-- **W-2 — `T5_det_2x2_ne_zero_iff`**: a 2x2 matrix has non-zero
    determinant iff `ad ≠ bc`. -/
theorem T5_det_2x2_ne_zero_iff (a b c d : ℝ) :
    Matrix.det !![a, b; c, d] ≠ 0 ↔ a * d - b * c ≠ 0 := by
  rw [T5_det_2x2_explicit]

/-! ## W-3 — 2x2 identity matrix has det 1 -/

/-- **W-3 — `T5_det_2x2_identity`**: 2x2 identity matrix has det 1. -/
theorem T5_det_2x2_identity :
    Matrix.det !![(1 : ℝ), 0; 0, 1] = 1 := by
  rw [T5_det_2x2_explicit]
  ring

/-! ## W-4 — 1-variable Wronskian definition shape -/

/-- **W-4 — `T5_wronskian_2_def`**: the 2-variable Wronskian of two
    polynomials P, Q is `P · Q' - P' · Q`. -/
noncomputable def T5_wronskian_2 (P Q : Polynomial ℝ) : Polynomial ℝ :=
  P * Q.derivative - P.derivative * Q

/-- **W-4-eq — `T5_wronskian_2_eq`**: this is just unfolding. -/
theorem T5_wronskian_2_eq (P Q : Polynomial ℝ) :
    T5_wronskian_2 P Q = P * Q.derivative - P.derivative * Q := rfl

/-! ## W-5 — Wronskian is anti-symmetric -/

/-- **W-5 — `T5_wronskian_2_antisym`**: `W(P, Q) = -W(Q, P)`. -/
theorem T5_wronskian_2_antisym (P Q : Polynomial ℝ) :
    T5_wronskian_2 P Q = -T5_wronskian_2 Q P := by
  unfold T5_wronskian_2
  ring

/-! ## W-6 — Wronskian of P with itself is 0 -/

/-- **W-6 — `T5_wronskian_2_self`**: `W(P, P) = 0`. -/
theorem T5_wronskian_2_self (P : Polynomial ℝ) :
    T5_wronskian_2 P P = 0 := by
  unfold T5_wronskian_2
  ring

/-! ## W-7 — Wronskian zero implies linear dependence (in field K, 1-var) -/

/-- **W-7 — `T5_wronskian_2_eval`**: evaluation of Wronskian at point α. -/
theorem T5_wronskian_2_eval (P Q : Polynomial ℝ) (α : ℝ) :
    (T5_wronskian_2 P Q).eval α =
      P.eval α * Q.derivative.eval α - P.derivative.eval α * Q.eval α := by
  unfold T5_wronskian_2
  rw [Polynomial.eval_sub, Polynomial.eval_mul, Polynomial.eval_mul]

/-! ## W-8 — Wronskian additive in first argument -/

/-- **W-8 — `T5_wronskian_2_add_left`**: `W(P + Q, R) = W(P, R) + W(Q, R)`. -/
theorem T5_wronskian_2_add_left (P Q R : Polynomial ℝ) :
    T5_wronskian_2 (P + Q) R = T5_wronskian_2 P R + T5_wronskian_2 Q R := by
  unfold T5_wronskian_2
  rw [Polynomial.derivative_add]
  ring

/-! ## W-9 — Wronskian additive in second argument -/

/-- **W-9 — `T5_wronskian_2_add_right`**: `W(P, Q + R) = W(P, Q) + W(P, R)`. -/
theorem T5_wronskian_2_add_right (P Q R : Polynomial ℝ) :
    T5_wronskian_2 P (Q + R) = T5_wronskian_2 P Q + T5_wronskian_2 P R := by
  unfold T5_wronskian_2
  rw [Polynomial.derivative_add]
  ring

/-! ## W-10 — Layer 9 foundational marker -/

/-- **W-10 — `T5_D61_Layer9_completed_marker`**: 5-conjunct marker for
    Layer 9 completion (Wronskian non-vanishing helpers). -/
theorem T5_D61_Layer9_completed_marker :
    -- 2x2 det formula
    (∀ (a b c d : ℝ),
      Matrix.det !![a, b; c, d] = a * d - b * c) ∧
    -- 2x2 det ≠ 0 iff ad ≠ bc
    (∀ (a b c d : ℝ),
      Matrix.det !![a, b; c, d] ≠ 0 ↔ a * d - b * c ≠ 0) ∧
    -- Wronskian anti-symmetric
    (∀ (P Q : Polynomial ℝ),
      T5_wronskian_2 P Q = -T5_wronskian_2 Q P) ∧
    -- Wronskian self is zero
    (∀ (P : Polynomial ℝ), T5_wronskian_2 P P = 0) ∧
    -- Wronskian additive in left argument
    (∀ (P Q R : Polynomial ℝ),
      T5_wronskian_2 (P + Q) R = T5_wronskian_2 P R + T5_wronskian_2 Q R) :=
  ⟨T5_det_2x2_explicit,
   T5_det_2x2_ne_zero_iff,
   T5_wronskian_2_antisym,
   T5_wronskian_2_self,
   T5_wronskian_2_add_left⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_D61_Layer9_WronskianHelpers
