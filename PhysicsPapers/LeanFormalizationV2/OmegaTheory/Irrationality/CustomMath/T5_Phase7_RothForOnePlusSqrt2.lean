/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForOnePlusSqrt2

  T-5 (Roth's theorem) — **Phase 7 ext #56: CONCRETE WITNESS — Roth
  bound for `1 + √2` via `(X-1)² - 2` form (UNCONDITIONAL via
  quadratic-α discharge)**, sub session 559wwww — STRICT critical-path
  #316 (T-5) Phase 7 ext #56.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for `1 + √2`** via clean `(X - 1)² - 2`
  polynomial form (avoids the natDegree complications of the expanded
  `X² - 2X - 1` form by using monic polynomial composition).

  Specifically:
  - `1 + √2` is irrational (sum of integer + irrational).
  - The polynomial `(X - C 1)^2 - C 2 ∈ ℤ[X]` is non-zero, has
    natDegree 2 (via Monic.natDegree_pow + natDegree_sub_C +
    natDegree_X_sub_C), and `aeval (1+√2) ((X-1)² - 2) = (√2)² - 2 = 0`.
  - Apply ext #44: `RothBoundExists (1 + √2)` UNCONDITIONALLY.

  Single derivation:
  1. `T5_roth_for_one_plus_sqrt_two`: `RothBoundExists (1 + √2)`

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #56 — concrete witness Roth for `1 + √2` (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Algebra.Polynomial.Monic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForOnePlusSqrt2

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Defining polynomial (X - 1)² - 2 -/

/-- **🚨 Wave T5 session 559wwww — Polynomial (X - 1)² - 2 in ℤ[X]**.

    The minimal polynomial of `1 + √2` over ℚ in shifted-square form. -/
noncomputable def polyXMinusOneSqMinusTwo : Polynomial ℤ :=
  (X - C 1) ^ 2 - C 2

/-- **🚨 Wave T5 session 559wwww — `polyXMinusOneSqMinusTwo.natDegree = 2`**.

    Via Polynomial.Monic.natDegree_pow (X - 1 is monic) + natDegree_sub_C. -/
theorem T5_polyXMinusOneSqMinusTwo_natDegree :
    polyXMinusOneSqMinusTwo.natDegree = 2 := by
  unfold polyXMinusOneSqMinusTwo
  rw [natDegree_sub_C, Polynomial.Monic.natDegree_pow (monic_X_sub_C (1 : ℤ)),
      natDegree_X_sub_C]

/-- **🚨 Wave T5 session 559wwww — `polyXMinusOneSqMinusTwo` is non-zero**. -/
theorem T5_polyXMinusOneSqMinusTwo_ne_zero :
    polyXMinusOneSqMinusTwo ≠ 0 := by
  intro h
  have h_natDegree := T5_polyXMinusOneSqMinusTwo_natDegree
  rw [h] at h_natDegree
  simp at h_natDegree

/-- **🚨 Wave T5 session 559wwww — `1 + √2` is irrational**. -/
theorem T5_one_plus_sqrt_two_irrational :
    Irrational (1 + Real.sqrt 2) := by
  have h_irr : Irrational (Real.sqrt 2) := irrational_sqrt_two
  have h_eq : (1 : ℝ) + Real.sqrt 2 = ((1 : ℤ) : ℝ) + Real.sqrt 2 := by
    push_cast; ring
  rw [h_eq]
  exact h_irr.intCast_add 1

/-- **🚨 Wave T5 session 559wwww — `aeval (1+√2) ((X-1)² - 2) = 0`**. -/
theorem T5_polyXMinusOneSqMinusTwo_aeval_eq_zero :
    Polynomial.aeval (1 + Real.sqrt 2) polyXMinusOneSqMinusTwo = 0 := by
  unfold polyXMinusOneSqMinusTwo
  -- aeval (1+√2) ((X - C 1)^2 - C 2) = (1+√2 - 1)^2 - 2 = (√2)^2 - 2 = 0
  rw [map_sub, map_pow, map_sub, Polynomial.aeval_X, Polynomial.aeval_C,
      Polynomial.aeval_C]
  -- Goal: ((1 + √2) - (algebraMap ℤ ℝ) 1)^2 - (algebraMap ℤ ℝ) 2 = 0
  have h_sqrt : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)
  -- Simplify algebraMap applications
  rw [show ((algebraMap ℤ ℝ) 1 : ℝ) = (1 : ℝ) from by simp,
      show ((algebraMap ℤ ℝ) 2 : ℝ) = (2 : ℝ) from by simp]
  -- Goal: ((1 + √2) - 1)^2 - 2 = 0
  have h_simp : (1 + Real.sqrt 2 - 1 : ℝ) = Real.sqrt 2 := by ring
  rw [h_simp, h_sqrt]
  ring

/-! ## Concrete Roth bound for `1 + √2` -/

/-- **🚨 Wave T5 session 559wwww — UNCONDITIONAL Roth bound for `1 + √2`**. -/
theorem T5_roth_for_one_plus_sqrt_two :
    RothBoundExists (1 + Real.sqrt 2) :=
  T5_quadratic_roth_via_liouville_bound
    (1 + Real.sqrt 2)
    T5_one_plus_sqrt_two_irrational
    polyXMinusOneSqMinusTwo
    T5_polyXMinusOneSqMinusTwo_ne_zero
    T5_polyXMinusOneSqMinusTwo_aeval_eq_zero
    T5_polyXMinusOneSqMinusTwo_natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559wwww — T-5 Phase 7 ext #56:
    UNCONDITIONAL Roth for `1 + √2` via shifted-square form**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #56.

    🏆 UNCONDITIONAL Roth for `1 + √2` (rational + sqrt shift).

    Five derivations:
    1. `polyXMinusOneSqMinusTwo := (X - 1)^2 - 2` definition
    2. `_ne_zero`
    3. `_natDegree = 2` via `Monic.natDegree_pow` + `natDegree_sub_C`
    4. `T5_one_plus_sqrt_two_irrational` via `Irrational.intCast_add`
    5. `T5_polyXMinusOneSqMinusTwo_aeval_eq_zero`
    + `T5_roth_for_one_plus_sqrt_two : RothBoundExists (1+√2)`

    Demonstrates the SHIFTED-SQUARE form `(X - n)^2 - m` for
    `α = n + √m` (avoiding the expanded `X² - 2nX + (n² - m)` form
    which has natDegree complications). Foundation for further
    quadratic shifted-witness instances.

    Mathlib usage: `irrational_sqrt_two`, `Irrational.intCast_add`,
    `Real.sq_sqrt`, `Polynomial.X`, `Polynomial.C`,
    `Polynomial.monic_X_sub_C`, `Polynomial.Monic.pow`,
    `Polynomial.Monic.natDegree_eq`, `Polynomial.natDegree_X_sub_C`,
    `Polynomial.natDegree_sub_C`, `Polynomial.aeval_X`,
    `Polynomial.aeval_C`, `map_sub`, `map_pow`.

    Sub-lemma 249/N in T-1 (T-5 Phase 7 ext #56).  Lean-core only.

    🏆 Cubic+ chain corollary — quadratic-α discharge applies to
    rational-shift-of-square-root irrationals. Escanor Pride + Erdős
    Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559wwww_T5_phase7_roth_for_one_plus_sqrt_two_headline :
    RothBoundExists (1 + Real.sqrt 2) :=
  T5_roth_for_one_plus_sqrt_two

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForOnePlusSqrt2
