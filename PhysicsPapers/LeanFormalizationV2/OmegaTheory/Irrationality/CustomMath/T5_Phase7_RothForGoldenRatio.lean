/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenRatio

  T-5 (Roth's theorem) — **Phase 7 ext #48: CONCRETE WITNESS — Roth
  bound for the GOLDEN RATIO φ = (1+√5)/2 (UNCONDITIONAL via
  quadratic-α discharge)**, sub session 559oooo — STRICT critical-path
  #316 (T-5) Phase 7 ext #48.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for golden ratio φ**: applies ext #44
  quadratic-α Liouville → Roth discharge to α = φ = (1+√5)/2.

  Specifically:
  - `goldenRatio_irrational` (Mathlib) gives `Irrational φ`.
  - The polynomial `X² - X - 1 ∈ ℤ[X]` is non-zero, has natDegree 2, and
    `aeval φ (X² - X - 1) = φ² - φ - 1 = (φ+1) - φ - 1 = 0` via
    `goldenRatio_sq`.
  - Apply ext #44: `RothBoundExists φ` UNCONDITIONALLY.

  Cited frequently in Diophantine approximation theory: φ achieves
  the EXACT classical Liouville exponent (cannot be approximated
  better than 1/q² up to constants — φ is the "worst" irrational
  for rational approximation in this sense).

  Single derivation:
  1. `T5_roth_for_golden_ratio`: `RothBoundExists φ`

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK.

  ## Step #316 (T-5) status

  Phase 7 ext #48 — concrete witness Roth for golden ratio (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.GoldenRatio

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenRatio

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial
open scoped goldenRatio

/-! ## Defining polynomial X² - X - 1 -/

/-- **🚨 Wave T5 session 559oooo — Polynomial X² - X - 1 in ℤ[X]**.

    The minimal polynomial of φ = (1+√5)/2 over ℚ. -/
noncomputable def polyXSqMinusXMinusOne : Polynomial ℤ :=
  X ^ 2 - X - C 1

/-- **🚨 Wave T5 session 559oooo — `polyXSqMinusXMinusOne` is non-zero**. -/
theorem T5_polyXSqMinusXMinusOne_ne_zero : polyXSqMinusXMinusOne ≠ 0 := by
  unfold polyXSqMinusXMinusOne
  intro h
  have h_lead : (X ^ 2 - X - C 1 : Polynomial ℤ).coeff 2 = 1 := by
    rw [coeff_sub, coeff_sub, coeff_X_pow, coeff_X, coeff_C]
    simp
  rw [h] at h_lead
  simp at h_lead

/-- **🚨 Wave T5 session 559oooo — `polyXSqMinusXMinusOne.natDegree = 2`**. -/
theorem T5_polyXSqMinusXMinusOne_natDegree :
    polyXSqMinusXMinusOne.natDegree = 2 := by
  unfold polyXSqMinusXMinusOne
  -- (X^2 - X - 1).natDegree = 2
  -- = (X^2 + (-X) + (-C 1)).natDegree = 2 (leading X^2)
  rw [show (X ^ 2 - X - C 1 : Polynomial ℤ) = X ^ 2 + (- X - C 1) by ring]
  rw [show (-X - C 1 : Polynomial ℤ) = -(X + C 1) by ring]
  rw [show (X ^ 2 + -(X + C 1) : Polynomial ℤ) = X ^ 2 - (X + C 1) by ring]
  -- Use natDegree_X_pow_sub_C-style or compute directly
  have h_pow : (X ^ 2 : Polynomial ℤ).natDegree = 2 := natDegree_X_pow 2
  have h_X : (X : Polynomial ℤ).natDegree = 1 := natDegree_X
  have h_C : (C 1 : Polynomial ℤ).natDegree = 0 := natDegree_C _
  -- (X + C 1).natDegree = 1 (using natDegree_add_C if X has natDegree ≥ 1)
  have h_add : (X + C 1 : Polynomial ℤ).natDegree = 1 := by
    rw [Polynomial.natDegree_add_C, h_X]
  -- (X^2 - (X + C 1)).natDegree = 2 since 2 > 1
  rw [Polynomial.natDegree_sub_eq_left_of_natDegree_lt
        (by rw [h_pow, h_add]; norm_num)]
  exact h_pow

/-- **🚨 Wave T5 session 559oooo — `aeval φ (polyXSqMinusXMinusOne) = 0`**. -/
theorem T5_polyXSqMinusXMinusOne_aeval_phi_eq_zero :
    Polynomial.aeval (Real.goldenRatio) polyXSqMinusXMinusOne = 0 := by
  unfold polyXSqMinusXMinusOne
  -- aeval φ (X^2 - X - 1) = φ^2 - φ - 1 = 0 since φ^2 = φ + 1
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X, Real.goldenRatio_sq]

/-! ## Concrete Roth bound for golden ratio -/

/-- **🚨 Wave T5 session 559oooo — UNCONDITIONAL Roth bound for φ**.

    The Roth bound `RothBoundExists φ` holds UNCONDITIONALLY for the
    golden ratio φ = (1+√5)/2.

    Applies ext #44 quadratic-α discharge to α = φ with witness
    polynomial `X² - X - 1 ∈ ℤ[X]` (natDegree 2, non-zero,
    vanishes at φ via `goldenRatio_sq`). -/
theorem T5_roth_for_golden_ratio : RothBoundExists Real.goldenRatio :=
  T5_quadratic_roth_via_liouville_bound
    Real.goldenRatio
    Real.goldenRatio_irrational
    polyXSqMinusXMinusOne
    T5_polyXSqMinusXMinusOne_ne_zero
    T5_polyXSqMinusXMinusOne_aeval_phi_eq_zero
    T5_polyXSqMinusXMinusOne_natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559oooo — T-5 Phase 7 ext #48:
    UNCONDITIONAL Roth for golden ratio φ**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #48.

    🏆 UNCONDITIONAL CONCRETE-WITNESS Roth for golden ratio φ =
    (1+√5)/2.

    Four derivations:
    1. `polyXSqMinusXMinusOne` definition
    2. `T5_polyXSqMinusXMinusOne_ne_zero`
    3. `T5_polyXSqMinusXMinusOne_natDegree = 2`
    4. `T5_polyXSqMinusXMinusOne_aeval_phi_eq_zero`
    + `T5_roth_for_golden_ratio : RothBoundExists φ`

    Number-theoretic significance: φ is the "worst" irrational for
    rational approximation — its continued-fraction expansion is
    [1; 1, 1, 1, ...]. Classical Liouville bound `1/q²` is essentially
    tight for φ; Roth's `1/q^(2+ε)` improvement is the strongest
    possible exponent.

    Mathlib usage: `goldenRatio_irrational`, `goldenRatio_sq`,
    `Real.goldenRatio`, `Polynomial.X`, `Polynomial.C`,
    `natDegree_X_pow`, `natDegree_X`, `natDegree_C`,
    `natDegree_add_C`, `Polynomial.natDegree_sub_eq_left_of_natDegree_lt`,
    `Polynomial.aeval_def`, `eval₂_sub`, `eval₂_pow`, `eval₂_X`.

    Sub-lemma 241/N in T-1 (T-5 Phase 7 ext #48).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 unconditional Roth for golden
    ratio φ. Escanor Pride + Erdős Primarch — full prove mode,
    NO STUBS, NO slim. -/
theorem session_559oooo_T5_phase7_roth_for_golden_ratio_headline :
    RothBoundExists Real.goldenRatio :=
  T5_roth_for_golden_ratio

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenRatio
