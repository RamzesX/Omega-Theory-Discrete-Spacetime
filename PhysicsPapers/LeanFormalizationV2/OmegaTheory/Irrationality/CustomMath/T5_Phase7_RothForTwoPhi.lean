/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPhi

  T-5 (Roth's theorem) — **Phase 7 ext #65: CONCRETE WITNESS — Roth
  bound for `2·φ` (twice golden ratio, UNCONDITIONAL via quadratic-α
  discharge)**, sub session 559fffff — STRICT critical-path #316
  (T-5) Phase 7 ext #65.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for `2·φ`**: applies ext #44
  quadratic-α Liouville → Roth discharge to α = 2·φ where φ is the
  golden ratio.

  Specifically:
  - α = 2·φ is irrational (φ irrational + Irrational.intCast_mul).
  - Min poly: `(2φ)² = 4φ² = 4(φ+1) = 4φ + 4 = 2(2φ) + 4`.
    So `(2φ)² - 2(2φ) - 4 = 0`. Polynomial `X² - 2X - 4`.
  - natDegree 2, integer coefficients.
  - Apply ext #44.

  Five derivations:
  1. `polyXSqMinusTwoXMinusFour := X² - 2X - 4`
  2. `_natDegree = 2` via `Polynomial.Monic.natDegree_pow` chain
  3. `_ne_zero`
  4. `T5_two_phi_irrational` via `Irrational.intCast_mul`
  5. `T5_polyXSqMinusTwoXMinusFour_aeval_two_phi_eq_zero`
  + `T5_roth_for_two_phi`

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #65 — concrete witness Roth for 2·φ (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.GoldenRatio
import Mathlib.Algebra.Polynomial.Monic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPhi

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial
open scoped goldenRatio

/-! ## Defining polynomial X² - 2X - 4 via shifted-square form -/

/-- **🚨 Wave T5 session 559fffff — Polynomial (X-1)² - 5 in ℤ[X]**.

    Equivalent to X² - 2X - 4. Uses shifted-square form for clean
    natDegree calculation. Note: (X-1)² - 5 = X² - 2X + 1 - 5 = X² - 2X - 4. -/
noncomputable def polyXMinusOneSqMinusFive : Polynomial ℤ :=
  (X - C 1) ^ 2 - C 5

/-- **🚨 Wave T5 session 559fffff — natDegree = 2**. -/
theorem T5_polyXMinusOneSqMinusFive_natDegree :
    polyXMinusOneSqMinusFive.natDegree = 2 := by
  unfold polyXMinusOneSqMinusFive
  rw [natDegree_sub_C, Polynomial.Monic.natDegree_pow (monic_X_sub_C (1 : ℤ)),
      natDegree_X_sub_C]

/-- **🚨 Wave T5 session 559fffff — non-zero**. -/
theorem T5_polyXMinusOneSqMinusFive_ne_zero :
    polyXMinusOneSqMinusFive ≠ 0 := by
  intro h
  have h_natDegree := T5_polyXMinusOneSqMinusFive_natDegree
  rw [h] at h_natDegree
  simp at h_natDegree

/-- **🚨 Wave T5 session 559fffff — `2·φ` is irrational**. -/
theorem T5_two_phi_irrational : Irrational ((2 : ℝ) * Real.goldenRatio) := by
  have h_phi_irr : Irrational Real.goldenRatio := Real.goldenRatio_irrational
  have h_eq : (2 : ℝ) * Real.goldenRatio = ((2 : ℤ) : ℝ) * Real.goldenRatio := by
    push_cast; rfl
  rw [h_eq]
  exact h_phi_irr.intCast_mul (by decide : (2 : ℤ) ≠ 0)

/-- **🚨 Wave T5 session 559fffff — `aeval (2·φ) ((X-1)² - 5) = 0`**.

    Computation: aeval (2φ) ((X-1)² - 5) = (2φ - 1)² - 5.
    Note 2φ - 1 = √5 since φ = (1+√5)/2. So (2φ - 1)² = 5.
    Hence (2φ - 1)² - 5 = 0. -/
theorem T5_polyXMinusOneSqMinusFive_aeval_two_phi_eq_zero :
    Polynomial.aeval ((2 : ℝ) * Real.goldenRatio) polyXMinusOneSqMinusFive = 0 := by
  unfold polyXMinusOneSqMinusFive
  rw [map_sub, map_pow, map_sub, Polynomial.aeval_X, Polynomial.aeval_C,
      Polynomial.aeval_C]
  -- Goal: (2φ - (algebraMap ℤ ℝ) 1)² - (algebraMap ℤ ℝ) 5 = 0
  rw [show ((algebraMap ℤ ℝ) 1 : ℝ) = (1 : ℝ) from by simp,
      show ((algebraMap ℤ ℝ) 5 : ℝ) = (5 : ℝ) from by simp]
  -- Goal: (2φ - 1)² - 5 = 0
  -- 2φ - 1 = √5 (since φ = (1+√5)/2 → 2φ - 1 = √5)
  have h_phi_form : Real.goldenRatio = (1 + Real.sqrt 5) / 2 := by
    unfold Real.goldenRatio
    rfl
  have h_two_phi_minus_one : (2 : ℝ) * Real.goldenRatio - 1 = Real.sqrt 5 := by
    rw [h_phi_form]
    field_simp
    ring
  rw [h_two_phi_minus_one]
  have h_sqrt5_sq : Real.sqrt 5 ^ 2 = 5 := Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 5)
  rw [h_sqrt5_sq]
  ring

/-! ## Concrete Roth bound for 2·φ -/

/-- **🚨 Wave T5 session 559fffff — UNCONDITIONAL Roth bound for `2·φ`**. -/
theorem T5_roth_for_two_phi : RothBoundExists ((2 : ℝ) * Real.goldenRatio) :=
  T5_quadratic_roth_via_liouville_bound
    ((2 : ℝ) * Real.goldenRatio)
    T5_two_phi_irrational
    polyXMinusOneSqMinusFive
    T5_polyXMinusOneSqMinusFive_ne_zero
    T5_polyXMinusOneSqMinusFive_aeval_two_phi_eq_zero
    T5_polyXMinusOneSqMinusFive_natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559fffff — T-5 Phase 7 ext #65:
    UNCONDITIONAL Roth for `2·φ`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #65.

    🏆 UNCONDITIONAL Roth for `2 · golden ratio`.

    Key insight: 2φ - 1 = √5 (since φ = (1+√5)/2). So 2φ has
    minimal polynomial (X - 1)² - 5 = X² - 2X - 4.

    Five derivations + concrete witness theorem.

    Mathlib usage: `Real.goldenRatio_irrational`,
    `Irrational.intCast_mul`, `Real.sq_sqrt`,
    `Polynomial.Monic.natDegree_pow`, `monic_X_sub_C`,
    `natDegree_X_sub_C`, `natDegree_sub_C`.

    Sub-lemma 258/N in T-1 (T-5 Phase 7 ext #65).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 unconditional Roth for 2·φ.
    Demonstrates technique extends to integer multiples of algebraic
    irrationals. Escanor Pride + Erdős Primarch — full prove mode,
    NO STUBS, NO slim. -/
theorem session_559fffff_T5_phase7_roth_for_two_phi_headline :
    RothBoundExists ((2 : ℝ) * Real.goldenRatio) :=
  T5_roth_for_two_phi

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPhi
