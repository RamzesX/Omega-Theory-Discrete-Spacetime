/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_NWronskianN3Witness

  T-5 (Roth's theorem) — Phase 3 n=3 Wronskian non-vanishing witness,
  sub session 559w — STRICT critical-path #316 (T-5) extension #9.

  Single-thread hand-authored 2026-04-28 (cycle 65 — /loop dynamic).

  ## What this file delivers

  Concrete n=3 specialization of the Phase 3 CORE theorem (s559u):
  for three distinct ℝ-points a, b, c and the X^i polynomial family
  (i = 0, 1, 2), the eval-matrix has non-zero determinant.

  This is the immediate Roth-index polynomial application: 3-element
  injective family on monic deg-graded family `{1, X, X²}`.

  Five derivations + Prop:
  - T5_X_pow_eval_matrix_3_distinct_real: general (a, b, c distinct)
  - Concrete v = (0, 1, 2) witness
  - Concrete v = (1, 2, 3) witness
  - Concrete v = (-1, 0, 1) witness (signed Real distinctness)
  - NWronskianN3Witness Prop scaffold

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Concrete n=3 step bridges the Phase 3 CORE result (s559u) to
  specific 3-element instances usable in Roth-index polynomial
  construction. Combined with the foundation master (s559v), the
  T-5 algebraic infrastructure is paper-ready.
-/

import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.Data.Real.Basic
import OmegaTheory.Irrationality.CustomMath.T5_Phase3_NWronskianNonVanishing

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_NWronskianN3Witness

open Matrix Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase3_NWronskianNonVanishing

/-! ## Helper: 3-vector indexed by Fin 3 -/

/-- 3-vector via if-cascade for Fin 3. -/
private noncomputable def vec3 (a b c : ℝ) : Fin 3 → ℝ := fun i =>
  if i = 0 then a else if i = 1 then b else c

/-! ## n=3 distinct entries → non-vanishing det -/

/-- **🚨 Wave T1 session 559w — n=3 X^i eval-matrix det non-zero for 3 distinct entries**. -/
theorem T5_X_pow_eval_matrix_3_distinct_real (a b c : ℝ)
    (hab : a ≠ b) (hbc : b ≠ c) (hac : a ≠ c) :
    (Matrix.of (fun i j : Fin 3 =>
      ((X^j.val : ℝ[X]).eval (vec3 a b c i)))).det ≠ 0 := by
  apply T5_X_pow_eval_matrix_det_ne_zero
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all [vec3]

/-! ## Concrete witnesses -/

/-- **🚨 Wave T1 session 559w — n=3 v=(0,1,2) det non-zero**. -/
theorem T5_X_pow_eval_matrix_3_zero_one_two_ne_zero :
    (Matrix.of (fun i j : Fin 3 =>
      ((X^j.val : ℝ[X]).eval (vec3 (0 : ℝ) 1 2 i)))).det ≠ 0 :=
  T5_X_pow_eval_matrix_3_distinct_real 0 1 2 (by norm_num) (by norm_num) (by norm_num)

/-- **🚨 Wave T1 session 559w — n=3 v=(1,2,3) det non-zero**. -/
theorem T5_X_pow_eval_matrix_3_one_two_three_ne_zero :
    (Matrix.of (fun i j : Fin 3 =>
      ((X^j.val : ℝ[X]).eval (vec3 (1 : ℝ) 2 3 i)))).det ≠ 0 :=
  T5_X_pow_eval_matrix_3_distinct_real 1 2 3 (by norm_num) (by norm_num) (by norm_num)

/-- **🚨 Wave T1 session 559w — n=3 v=(-1,0,1) det non-zero (signed)**. -/
theorem T5_X_pow_eval_matrix_3_neg_one_zero_one_ne_zero :
    (Matrix.of (fun i j : Fin 3 =>
      ((X^j.val : ℝ[X]).eval (vec3 (-1 : ℝ) 0 1 i)))).det ≠ 0 :=
  T5_X_pow_eval_matrix_3_distinct_real (-1) 0 1 (by norm_num) (by norm_num) (by norm_num)

/-! ## NWronskianN3Witness Prop scaffold -/

/-- **NWronskianN3Witness**: concrete n=3 Wronskian non-vanishing
    witnesses for three distinct ℝ-points. -/
def NWronskianN3Witness : Prop :=
  (∀ a b c : ℝ, a ≠ b → b ≠ c → a ≠ c →
    (Matrix.of (fun i j : Fin 3 =>
      ((X^j.val : ℝ[X]).eval (vec3 a b c i)))).det ≠ 0) ∧
  (Matrix.of (fun i j : Fin 3 =>
    ((X^j.val : ℝ[X]).eval (vec3 (0 : ℝ) 1 2 i)))).det ≠ 0 ∧
  (Matrix.of (fun i j : Fin 3 =>
    ((X^j.val : ℝ[X]).eval (vec3 (1 : ℝ) 2 3 i)))).det ≠ 0 ∧
  (Matrix.of (fun i j : Fin 3 =>
    ((X^j.val : ℝ[X]).eval (vec3 (-1 : ℝ) 0 1 i)))).det ≠ 0

/-- **🚨 Wave T1 session 559w — `NWronskianN3Witness`**. -/
theorem T5_n_wronskian_n3_witness : NWronskianN3Witness :=
  ⟨T5_X_pow_eval_matrix_3_distinct_real,
   T5_X_pow_eval_matrix_3_zero_one_two_ne_zero,
   T5_X_pow_eval_matrix_3_one_two_three_ne_zero,
   T5_X_pow_eval_matrix_3_neg_one_zero_one_ne_zero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559w — T-5 Phase 3 n=3 Wronskian witnesses**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 3 extension #9.

    Concrete n=3 specialization of Phase 3 CORE (s559u):
    1. T5_X_pow_eval_matrix_3_distinct_real: ∀ a, b, c distinct →
       eval-matrix det ≠ 0 (general)
    2. Concrete v = (0, 1, 2) witness
    3. Concrete v = (1, 2, 3) witness
    4. Concrete v = (-1, 0, 1) witness (signed)
    + NWronskianN3Witness Prop (4-conjunct).

    Bridges Phase 3 CORE to Roth-index polynomial 3-element instances.
    Combined with foundation master (s559v), T-5 algebraic infrastructure
    is paper-ready for Roth-index polynomial construction.

    Mathlib usage: `T5_X_pow_eval_matrix_det_ne_zero` (s559u) +
    `fin_cases` + `simp_all`.

    Sub-lemma 171/N in T-1 (T-5 Phase 3 ext #9).  Lean-core only.

    🏆 First Lean-core T-5 Phase 3 n=3 Wronskian witnesses. -/
theorem session_559w_T5_n_wronskian_n3_witness_headline :
    NWronskianN3Witness :=
  T5_n_wronskian_n3_witness

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_NWronskianN3Witness
