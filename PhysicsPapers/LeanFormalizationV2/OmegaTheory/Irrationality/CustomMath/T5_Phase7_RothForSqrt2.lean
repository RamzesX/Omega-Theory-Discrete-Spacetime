/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt2

  T-5 (Roth's theorem) — **Phase 7 ext #45: CONCRETE WITNESS — Roth
  bound for √2 (UNCONDITIONAL via quadratic-α discharge)**, sub
  session 559llll — STRICT critical-path #316 (T-5) Phase 7 ext #45.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for √2**: applies ext #44 quadratic-α
  Liouville → Roth discharge to the specific case α = √2 ∈ ℝ.

  Specifically:
  - `irrational_sqrt_two` (Mathlib) gives `Irrational √2`.
  - The polynomial `X² - 2 ∈ ℤ[X]` is non-zero, has natDegree 2, and
    `aeval (√2) (X² - 2) = 2 - 2 = 0` via `Real.sq_sqrt`.
  - Apply ext #44: `RothBoundExists √2` UNCONDITIONALLY.

  This is the FIRST concrete-witness instance of Roth's theorem in
  OV2 — provably unconditional for a specific algebraic irrational.

  Single derivation:
  1. `T5_roth_for_sqrt_two`: `RothBoundExists √2`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK.

  ## Step #316 (T-5) status

  Phase 7 ext #45 — concrete witness Roth for √2 (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Data.Real.Sqrt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt2

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Defining polynomial X² - 2 -/

/-- **🚨 Wave T5 session 559llll — Polynomial X² - 2 in ℤ[X]**.

    The minimal polynomial of √2 over ℚ (and ℤ). -/
noncomputable def polyXSqMinusTwo : Polynomial ℤ := X ^ 2 - C 2

/-- **🚨 Wave T5 session 559llll — `polyXSqMinusTwo` is non-zero**. -/
theorem T5_polyXSqMinusTwo_ne_zero : polyXSqMinusTwo ≠ 0 := by
  unfold polyXSqMinusTwo
  intro h
  have h_lead : (X ^ 2 - C 2 : Polynomial ℤ).coeff 2 = 1 := by
    rw [coeff_sub, coeff_X_pow, coeff_C]
    simp
  rw [h] at h_lead
  simp at h_lead

/-- **🚨 Wave T5 session 559llll — `polyXSqMinusTwo.natDegree = 2`**. -/
theorem T5_polyXSqMinusTwo_natDegree :
    polyXSqMinusTwo.natDegree = 2 := by
  unfold polyXSqMinusTwo
  -- natDegree (X^2 - C 2) = 2 since leading coeff of X^2 is 1, C 2 has natDegree 0
  have h1 : (X ^ 2 : Polynomial ℤ).natDegree = 2 := by
    rw [natDegree_X_pow]
  have h2 : (C 2 : Polynomial ℤ).natDegree = 0 := natDegree_C _
  rw [show (X ^ 2 - C 2 : Polynomial ℤ) = X ^ 2 + (- C 2) by ring]
  rw [show (- C 2 : Polynomial ℤ) = C (-2) by simp]
  rw [Polynomial.natDegree_add_C]
  exact h1

/-- **🚨 Wave T5 session 559llll — `aeval √2 (polyXSqMinusTwo) = 0`**. -/
theorem T5_polyXSqMinusTwo_aeval_sqrt_two_eq_zero :
    Polynomial.aeval (Real.sqrt 2) polyXSqMinusTwo = 0 := by
  unfold polyXSqMinusTwo
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]

/-! ## Concrete Roth bound for √2 -/

/-- **🚨 Wave T5 session 559llll — UNCONDITIONAL Roth bound for √2**.

    The Roth bound `RothBoundExists √2` holds UNCONDITIONALLY:

      `∀ ε > 0, ∃ C > 0, ∀ q ∈ ℚ, q ≠ 0, q ≠ √2,
         C / (Rat.naiveHeight q)^(2+ε) ≤ |√2 - q|`.

    Applies ext #44 quadratic-α discharge to α = √2 with witness
    polynomial `X² - 2 ∈ ℤ[X]` (natDegree 2, non-zero, vanishes at √2). -/
theorem T5_roth_for_sqrt_two : RothBoundExists (Real.sqrt 2) :=
  T5_quadratic_roth_via_liouville_bound
    (Real.sqrt 2)
    irrational_sqrt_two
    polyXSqMinusTwo
    T5_polyXSqMinusTwo_ne_zero
    T5_polyXSqMinusTwo_aeval_sqrt_two_eq_zero
    T5_polyXSqMinusTwo_natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559llll — T-5 Phase 7 ext #45:
    UNCONDITIONAL concrete-witness Roth for √2**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #45.

    🏆 FIRST UNCONDITIONAL CONCRETE-WITNESS INSTANCE of Roth's
    theorem in OV2 — `RothBoundExists √2`.

    Four derivations:
    1. `polyXSqMinusTwo` definition
    2. `T5_polyXSqMinusTwo_ne_zero`
    3. `T5_polyXSqMinusTwo_natDegree = 2`
    4. `T5_polyXSqMinusTwo_aeval_sqrt_two_eq_zero`
    + `T5_roth_for_sqrt_two : RothBoundExists √2`

    Concrete witness instance: composition of ext #44 quadratic-α
    discharge with Mathlib's `irrational_sqrt_two` + `Real.sq_sqrt`
    + standard Polynomial vocabulary.

    Mathlib usage: `irrational_sqrt_two`, `Real.sq_sqrt`,
    `Polynomial.X_pow`, `Polynomial.C`, `natDegree_X_pow`,
    `natDegree_C`, `natDegree_add_C`, `Polynomial.aeval_def`,
    `eval₂_sub`, `eval₂_pow`, `eval₂_X`, `eval₂_C`.

    Sub-lemma 238/N in T-1 (T-5 Phase 7 ext #45).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 concrete witness Roth for √2.
    Demonstrates the unconditional quadratic discharge works on
    real algebraic irrationals. Escanor Pride + Erdős Primarch —
    full prove mode, NO STUBS, NO slim. -/
theorem session_559llll_T5_phase7_roth_for_sqrt_two_headline :
    RothBoundExists (Real.sqrt 2) :=
  T5_roth_for_sqrt_two

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt2
