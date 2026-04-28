/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse

  T-5 (Roth's theorem) — **Phase 7 ext #67: CONCRETE WITNESS — Roth
  bound for `φ - 1 = 1/φ` (UNCONDITIONAL via quadratic-α discharge)**,
  sub session 559hhhhh — STRICT critical-path #316 (T-5) Phase 7 ext #67.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for `φ - 1 = 1/φ`** (golden ratio's
  reciprocal).

  Specifically:
  - α = φ - 1 = 1/φ (since φ² - φ - 1 = 0 → φ(φ-1) = 1 → φ-1 = 1/φ).
  - Min poly: X² + X - 1.
    Verification: (φ-1)² + (φ-1) - 1 = φ² - 2φ + 1 + φ - 1 - 1
                = φ² - φ - 1 = 0 (using φ² = φ+1).
  - α irrational (φ irrational + integer subtraction).
  - Apply ext #44 quadratic discharge.

  Number-theoretic significance: `1/φ` = φ - 1 is the small root of
  X² + X - 1, paired with the big root via inversion.

  Five derivations:
  1. `polyXSqPlusXMinusOne := X² + X - 1`
  2. `_natDegree = 2` via natDegree_add_eq_left_of_natDegree_lt
  3. `_ne_zero`
  4. `T5_phi_minus_one_irrational` via `Irrational.intCast_add`
  5. `_aeval_eq_zero` via goldenRatio_sq

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #67 — concrete witness Roth for φ - 1 (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.GoldenRatio
import Mathlib.Algebra.Polynomial.Monic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial
open scoped goldenRatio

/-! ## Defining polynomial X² + X - 1 -/

/-- **🚨 Wave T5 session 559hhhhh — Polynomial X² + X - 1 in ℤ[X]**.

    Min poly of `φ - 1 = 1/φ`. -/
noncomputable def polyXSqPlusXMinusOne : Polynomial ℤ :=
  X ^ 2 + X - C 1

/-- **🚨 Wave T5 session 559hhhhh — natDegree = 2**. -/
theorem T5_polyXSqPlusXMinusOne_natDegree :
    polyXSqPlusXMinusOne.natDegree = 2 := by
  unfold polyXSqPlusXMinusOne
  -- X² + X - C 1 = X² + (X - C 1)
  rw [show (X ^ 2 + X - C 1 : Polynomial ℤ) = X ^ 2 + (X - C 1) by ring]
  rw [Polynomial.natDegree_add_eq_left_of_natDegree_lt
        (by
          rw [natDegree_X_pow]
          have h1 : (X - C 1 : Polynomial ℤ).natDegree ≤ 1 :=
            Polynomial.natDegree_X_sub_C_le 1
          omega)]
  rw [natDegree_X_pow]

/-- **🚨 Wave T5 session 559hhhhh — non-zero**. -/
theorem T5_polyXSqPlusXMinusOne_ne_zero :
    polyXSqPlusXMinusOne ≠ 0 := by
  intro h
  have h_natDegree := T5_polyXSqPlusXMinusOne_natDegree
  rw [h] at h_natDegree
  simp at h_natDegree

/-- **🚨 Wave T5 session 559hhhhh — `φ - 1` is irrational**. -/
theorem T5_phi_minus_one_irrational : Irrational (Real.goldenRatio - 1) := by
  have h_phi_irr : Irrational Real.goldenRatio := Real.goldenRatio_irrational
  -- φ - 1 = φ + (-1 : ℤ). Use Irrational.add_intCast
  have h_eq : (Real.goldenRatio - 1 : ℝ) = Real.goldenRatio + ((-1 : ℤ) : ℝ) := by
    push_cast; ring
  rw [h_eq]
  exact h_phi_irr.add_intCast (-1)

/-- **🚨 Wave T5 session 559hhhhh — `aeval (φ-1) (X² + X - 1) = 0`**. -/
theorem T5_polyXSqPlusXMinusOne_aeval_phi_minus_one_eq_zero :
    Polynomial.aeval (Real.goldenRatio - 1) polyXSqPlusXMinusOne = 0 := by
  unfold polyXSqPlusXMinusOne
  rw [map_sub, map_add, map_pow, Polynomial.aeval_X, Polynomial.aeval_C]
  -- Goal: (φ - 1)² + (φ - 1) - (algebraMap ℤ ℝ) 1 = 0
  rw [show ((algebraMap ℤ ℝ) 1 : ℝ) = (1 : ℝ) from by simp]
  -- Goal: (φ - 1)² + (φ - 1) - 1 = 0
  have h_phi_sq : Real.goldenRatio ^ 2 = Real.goldenRatio + 1 := Real.goldenRatio_sq
  -- (φ - 1)² + (φ - 1) - 1 = φ² - 2φ + 1 + φ - 1 - 1 = φ² - φ - 1
  -- = (φ + 1) - φ - 1 = 0
  nlinarith [h_phi_sq]

/-! ## Concrete Roth bound for φ - 1 -/

/-- **🚨 Wave T5 session 559hhhhh — UNCONDITIONAL Roth for φ - 1**. -/
theorem T5_roth_for_golden_inverse : RothBoundExists (Real.goldenRatio - 1) :=
  T5_quadratic_roth_via_liouville_bound
    (Real.goldenRatio - 1)
    T5_phi_minus_one_irrational
    polyXSqPlusXMinusOne
    T5_polyXSqPlusXMinusOne_ne_zero
    T5_polyXSqPlusXMinusOne_aeval_phi_minus_one_eq_zero
    T5_polyXSqPlusXMinusOne_natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hhhhh — T-5 Phase 7 ext #67:
    UNCONDITIONAL Roth for `φ - 1 = 1/φ`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #67.

    🏆 UNCONDITIONAL Roth for golden ratio's reciprocal.

    Five derivations + concrete witness theorem.

    Number-theoretic note: `1/φ = φ - 1` is one of the two roots of
    X² + X - 1 (the other being `-φ`). Together with φ and ψ from
    ext #48, #64, gives the complete Pell-related quadratic family.

    Mathlib usage: `Real.goldenRatio_irrational`, `Real.goldenRatio_sq`,
    `Irrational.add_intCast`, `Polynomial.natDegree_add_eq_left_of_natDegree_lt`,
    `Polynomial.natDegree_X_sub_C_le`, `nlinarith`.

    Sub-lemma 260/N in T-1 (T-5 Phase 7 ext #67).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 unconditional Roth for golden ratio
    inverse. Escanor Pride + Erdős Primarch — full prove mode, NO STUBS,
    NO slim. -/
theorem session_559hhhhh_T5_phase7_roth_for_golden_inverse_headline :
    RothBoundExists (Real.goldenRatio - 1) :=
  T5_roth_for_golden_inverse

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse
