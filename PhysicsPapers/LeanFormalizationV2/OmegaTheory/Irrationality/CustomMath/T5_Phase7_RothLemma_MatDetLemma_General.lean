/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 MATRIX DET LEMMA GENERAL m**:
  unconditional discharge of the matrix det lemma for the polynomial-coefficient
  identity-witness Wronskian matrix at ARBITRARY m ≥ 1.

  Single-thread hand-authored 2026-04-29.

  ## Strategy: rank-1 charpoly formula

  For any P : MvPolynomial (Fin m) ℝ, the matrix M with
    M_{ij} = δ_{ij} P + (pderiv i P) · X j
  satisfies det M = P^(m-1) · (P + ∑ X_i · pderiv_i P).

  Proof via Mathlib's `Matrix.charpoly_vecMulVec`:
  - charpoly(vecMulVec u v) = X^m - ⟨u,v⟩ · X^(m-1)
  - eval_charpoly: eval t (charpoly M) = (scalar t - M).det
  - Trick: apply to -vecMulVec u v (which is vecMulVec (-u) v), so
    (scalar P - (-vecMulVec u v)).det = (scalar P + vecMulVec u v).det = our matrix.

  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General

open MvPolynomial Matrix Finset Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_EulerGeneral

/-! ## General m matrix det lemma — UNCONDITIONAL via rank-1 charpoly -/

/-- Auxiliary: identify our matrix as `scalar P + vecMulVec u v`. -/
private theorem matrix_eq_scalar_add_vecMulVec {m : ℕ} (P : MvPolynomial (Fin m) ℝ) :
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)) =
    Matrix.scalar (Fin m) P + Matrix.vecMulVec (fun i => pderiv i P) (fun j => X j) := by
  ext i j
  simp [Matrix.of_apply, Matrix.add_apply, Matrix.scalar_apply,
        Matrix.diagonal, Matrix.vecMulVec_apply]

/-- **General m matrix det lemma** —
    `det(P·I + outer(d, X)) = P^(m-1) · (P + ∑ X_i · d_iP)` for m ≥ 1. -/
theorem T5_matDetLemma_general {m : ℕ} (hm : 1 ≤ m) (P : MvPolynomial (Fin m) ℝ) :
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det =
    P^(m-1) * (P + ∑ i : Fin m, X i * pderiv i P) := by
  rw [matrix_eq_scalar_add_vecMulVec]
  -- Step 1: scalar P + vecMulVec u v = scalar P - (-vecMulVec u v)
  have h_eq : Matrix.scalar (Fin m) P + Matrix.vecMulVec (fun i => pderiv i P) (fun j => X j)
            = Matrix.scalar (Fin m) P
            - (-Matrix.vecMulVec (fun i => pderiv i P) (fun j => X j)) := by
    abel
  rw [h_eq]
  -- Step 2: -vecMulVec u v = vecMulVec (-u) v (using neg_vecMulVec : vecMulVec (-w) v = -vecMulVec w v)
  have h_neg : -Matrix.vecMulVec (fun i => pderiv i P) (fun j => X j)
             = Matrix.vecMulVec (fun i => -(pderiv i P)) (fun j => X j) := by
    rw [show (fun i : Fin m => -(pderiv i P)) = -(fun i : Fin m => pderiv i P) from rfl]
    exact (Matrix.neg_vecMulVec _ _).symm
  rw [h_neg]
  -- Step 3: apply eval_charpoly in reverse
  rw [← Matrix.eval_charpoly]
  -- Step 4: charpoly_vecMulVec
  rw [Matrix.charpoly_vecMulVec]
  -- Step 5: simplify Fintype.card (Fin m) = m
  simp only [Fintype.card_fin]
  -- Step 6: evaluate
  rw [Polynomial.eval_sub, Polynomial.eval_pow, Polynomial.eval_X, Polynomial.eval_smul,
      Polynomial.eval_pow, Polynomial.eval_X, smul_eq_mul]
  -- LHS now: P^m - ((fun i => -(pderiv i P)) ⬝ᵥ (fun j => X j)) · P^(m-1)
  -- Compute the dot product
  have h_dot : ((fun i => -(pderiv i P)) ⬝ᵥ (fun j : Fin m => X j))
             = -(∑ i : Fin m, X i * pderiv i P) := by
    simp only [dotProduct]
    rw [← Finset.sum_neg_distrib]
    congr 1
    ext i
    ring
  rw [h_dot]
  -- Now: P^m - (-(∑ X i * pderiv i P)) · P^(m-1)
  -- Replace m with succ form via Nat.sub_one_add_one_eq_of_pos
  obtain ⟨k, rfl⟩ : ∃ k, m = k + 1 := ⟨m - 1, by omega⟩
  simp only [Nat.add_sub_cancel]
  ring

/-- **General m Wronskian non-vanish** via matrix det lemma + Euler kernel —
    UNCONDITIONAL. -/
theorem T5_matDetLemma_general_nonzero {m : ℕ} (hm : 1 ≤ m)
    (P : MvPolynomial (Fin m) ℝ) (hP : P ≠ 0) :
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 := by
  rw [T5_matDetLemma_general hm]
  apply mul_ne_zero
  · exact pow_ne_zero (m - 1) hP
  · exact T5_GeneralEulerShifted_holds P hP

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 GENERAL m MATRIX DET LEMMA UNCONDITIONAL**.

    🏆🏆🏆🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 GENERAL m unconditional.

    For any m ≥ 1 and any P : MvPolynomial (Fin m) ℝ:
    1. `T5_matDetLemma_general` — explicit formula
       `det(P·I + outer(d, X)) = P^(m-1) · (P + ∑ X_i · d_iP)`
    2. `T5_matDetLemma_general_nonzero` — non-vanishing for P ≠ 0
       (combines with `T5_GeneralEulerShifted_holds` Euler kernel)

    **Strategic significance**: this DISCHARGES the matrix det lemma
    NAMED hypothesis `T5_MatrixDetLemma_for_VarP_NAMED` UNCONDITIONALLY
    via Mathlib's rank-1 charpoly formula `Matrix.charpoly_vecMulVec`.
    No fraction-field lift needed — direct proof via `eval_charpoly`
    composed with characteristic polynomial of rank-1 perturbation.

    Combined with the Euler kernel `T5_GeneralEulerShifted_holds` (UNCONDITIONAL,
    commit 7d950e3), this gives the multivariate Wronskian non-vanish
    for the identity-witness construction at ALL m ≥ 1 unconditionally.

    Sub-lemma 320/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_matdet_lemma_general_headline :
    ∀ {m : ℕ}, 1 ≤ m → ∀ (P : MvPolynomial (Fin m) ℝ), P ≠ 0 →
    (Matrix.of (fun (i j : Fin m) =>
      (if i = j then P else 0) + (pderiv i P) * X j)).det ≠ 0 :=
  fun {_} hm P hP => T5_matDetLemma_general_nonzero hm P hP

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_MatDetLemma_General
