/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot

  T-5 (Roth's theorem) — **Phase 7 ext #122: Schmidt index ≥ 1 ↔
  root condition (cubic+ chain bookkeeping)**, sub session 559vvvvvvv
  — STRICT critical-path #316 (T-5) Phase 7 ext #122.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Equivalence between Schmidt index ≥ 1 condition and "α is a root of p":

  For p ∈ ℤ[X] and α ∈ ℝ:
    `(∀ i < 1, (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
       ↔ (p.map (Int.castRingHom ℝ)).eval α = 0`

  This connects the "index k" Schmidt formulation to the standard
  root condition for the simplest case k = 1.

  Strategy: composes ext #121 (taylor coeff 0 = eval at α) with
  i < 1 ↔ i = 0 simplification.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #122 — Schmidt index ≥ 1 ↔ root.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval
import Mathlib.Data.Real.Basic
import Mathlib.Algebra.Polynomial.AlgebraMap

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorCoeffZeroEval

/-! ## Index ≥ 1 ↔ root -/

/-- **🚨 Wave T5 session 559vvvvvvv — Schmidt index ≥ 1 ↔ root**.

    For p ∈ ℤ[X] and α ∈ ℝ:
      `(∀ i < 1, (Polynomial.taylor α (p.map ..)).coeff i = 0)
         ↔ (p.map ..).eval α = 0`. -/
theorem T5_schmidt_index_one_iff_root
    (α : ℝ) (p : Polynomial ℤ) :
    (∀ i, i < 1 → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
      ↔ (p.map (Int.castRingHom ℝ)).eval α = 0 := by
  constructor
  · intro h
    -- Take i = 0
    have h0 := h 0 (by norm_num : (0 : ℕ) < 1)
    -- Apply ext #121
    rw [T5_taylor_coeff_zero_eq_eval] at h0
    exact h0
  · intro h
    intros i hi
    -- i < 1 → i = 0
    have hi0 : i = 0 := Nat.lt_one_iff.mp hi
    rw [hi0, T5_taylor_coeff_zero_eq_eval]
    exact h

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559vvvvvvv — T-5 Phase 7 ext #122**.

    🏆 BOOKKEEPING — Schmidt index ≥ 1 ↔ root condition.

    Strategy: applies ext #121 + interval_cases i < 1 → i = 0.

    For Schmidt aux poly with k = 1, the index condition reduces to
    "α is a root of p" — the simplest case used in quadratic discharge.

    Sub-lemma 295/N. Lean-core only. -/
theorem session_559vvvvvvv_T5_phase7_schmidt_index_one_iff_root_headline
    (α : ℝ) (p : Polynomial ℤ) :
    (∀ i, i < 1 → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0)
      ↔ (p.map (Int.castRingHom ℝ)).eval α = 0 :=
  T5_schmidt_index_one_iff_root α p

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
