/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntPlusSqrt

  T-5 (Roth's theorem) — **Phase 7 ext #57: GENERIC UNCONDITIONAL Roth
  for `n + √m` (n : ℤ, m : ℕ non-square)**, sub session 559xxxx —
  STRICT critical-path #316 (T-5) Phase 7 ext #57.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Generic UNCONDITIONAL Roth for the `n + √m` family: for any
  n : ℤ and m : ℕ with `¬IsSquare m`, the value `(n : ℝ) + √m` is
  irrational algebraic of degree 2, with witness polynomial
  `(X - C n)^2 - C m ∈ ℤ[X]`.

  Combined with ext #44 quadratic discharge, gives RothBoundExists
  for any α in this family.

  Concrete instances: `1 + √2`, `2 + √3`, `5 + √7`, `10 + √11`, etc.

  Two derivations:
  1. `T5_roth_for_int_plus_sqrt_nonsquare` — generic theorem
  2. `T5_roth_for_two_plus_sqrt_three` — concrete witness 2 + √3

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #57 — generic Roth for `n + √m` family.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Algebra.Polynomial.Monic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntPlusSqrt

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Defining polynomial (X - n)² - m -/

/-- **🚨 Wave T5 session 559xxxx — Polynomial (X - n)² - m in ℤ[X]**.

    The minimal polynomial of `n + √m` over ℚ in shifted-square form
    (for n : ℤ, m : ℕ non-square). -/
noncomputable def polyXMinusNSqMinusM (n : ℤ) (m : ℕ) : Polynomial ℤ :=
  (X - C n) ^ 2 - C (m : ℤ)

/-- **🚨 Wave T5 session 559xxxx — `polyXMinusNSqMinusM.natDegree = 2`**. -/
theorem T5_polyXMinusNSqMinusM_natDegree (n : ℤ) (m : ℕ) :
    (polyXMinusNSqMinusM n m).natDegree = 2 := by
  unfold polyXMinusNSqMinusM
  rw [natDegree_sub_C, Polynomial.Monic.natDegree_pow (monic_X_sub_C n),
      natDegree_X_sub_C]

/-- **🚨 Wave T5 session 559xxxx — `polyXMinusNSqMinusM` is non-zero**. -/
theorem T5_polyXMinusNSqMinusM_ne_zero (n : ℤ) (m : ℕ) :
    polyXMinusNSqMinusM n m ≠ 0 := by
  intro h
  have h_natDegree := T5_polyXMinusNSqMinusM_natDegree n m
  rw [h] at h_natDegree
  simp at h_natDegree

/-- **🚨 Wave T5 session 559xxxx — `n + √m` is irrational**
    (n : ℤ, m : ℕ non-square). -/
theorem T5_int_plus_sqrt_nonsquare_irrational (n : ℤ) (m : ℕ)
    (hm : ¬IsSquare m) :
    Irrational ((n : ℝ) + Real.sqrt (m : ℝ)) := by
  have h_irr : Irrational (Real.sqrt (m : ℝ)) :=
    irrational_sqrt_natCast_iff.mpr hm
  have h_eq : ((n : ℝ) + Real.sqrt (m : ℝ)) =
              ((n : ℤ) : ℝ) + Real.sqrt (m : ℝ) := by
    push_cast; ring
  rw [h_eq]
  exact h_irr.intCast_add n

/-- **🚨 Wave T5 session 559xxxx — `aeval (n+√m) ((X-n)² - m) = 0`**. -/
theorem T5_polyXMinusNSqMinusM_aeval_eq_zero (n : ℤ) (m : ℕ) :
    Polynomial.aeval ((n : ℝ) + Real.sqrt (m : ℝ)) (polyXMinusNSqMinusM n m) = 0 := by
  unfold polyXMinusNSqMinusM
  rw [map_sub, map_pow, map_sub, Polynomial.aeval_X, Polynomial.aeval_C,
      Polynomial.aeval_C]
  -- Goal: ((n+√m) - (algebraMap ℤ ℝ) n)^2 - (algebraMap ℤ ℝ) m = 0
  rw [show ((algebraMap ℤ ℝ) n : ℝ) = (n : ℝ) from by simp,
      show ((algebraMap ℤ ℝ) (m : ℤ) : ℝ) = ((m : ℕ) : ℝ) from by
        push_cast; rfl]
  -- Goal: ((n+√m) - n)^2 - m = 0
  have h_simp : ((n : ℝ) + Real.sqrt (m : ℝ) - (n : ℝ) : ℝ) =
                Real.sqrt (m : ℝ) := by ring
  rw [h_simp]
  rw [Real.sq_sqrt (by exact_mod_cast Nat.zero_le m : (0 : ℝ) ≤ (m : ℝ))]
  ring

/-! ## Generic Roth for `n + √m` (n : ℤ, m : ℕ non-square) -/

/-- **🚨 Wave T5 session 559xxxx — UNCONDITIONAL Roth for `n + √m`**. -/
theorem T5_roth_for_int_plus_sqrt_nonsquare (n : ℤ) (m : ℕ)
    (hm : ¬IsSquare m) :
    RothBoundExists ((n : ℝ) + Real.sqrt (m : ℝ)) :=
  T5_quadratic_roth_via_liouville_bound
    ((n : ℝ) + Real.sqrt (m : ℝ))
    (T5_int_plus_sqrt_nonsquare_irrational n m hm)
    (polyXMinusNSqMinusM n m)
    (T5_polyXMinusNSqMinusM_ne_zero n m)
    (T5_polyXMinusNSqMinusM_aeval_eq_zero n m)
    (T5_polyXMinusNSqMinusM_natDegree n m)

/-! ## Concrete instance: 2 + √3 -/

unseal Nat.sqrt.iter in
/-- **🚨 Wave T5 session 559xxxx — Roth for `2 + √3`**. -/
theorem T5_roth_for_two_plus_sqrt_three :
    RothBoundExists ((2 : ℝ) + Real.sqrt 3) := by
  have h3 : ¬IsSquare (3 : ℕ) := by decide
  have h_eq : ((2 : ℝ) + Real.sqrt 3) =
              ((2 : ℤ) : ℝ) + Real.sqrt ((3 : ℕ) : ℝ) := by
    push_cast; ring
  rw [h_eq]
  exact T5_roth_for_int_plus_sqrt_nonsquare 2 3 h3

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559xxxx — T-5 Phase 7 ext #57:
    Generic UNCONDITIONAL Roth for `n + √m`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #57.

    🏆 GENERIC UNCONDITIONAL CONCRETE-WITNESS Roth for ALL
    `n + √m` with n : ℤ and m : ℕ non-square.

    Five derivations + concrete instance:
    1. `polyXMinusNSqMinusM` parametrized def
    2. `_natDegree = 2` via `Monic.natDegree_pow` chain
    3. `_ne_zero`
    4. `T5_int_plus_sqrt_nonsquare_irrational`
    5. `T5_polyXMinusNSqMinusM_aeval_eq_zero`
    + `T5_roth_for_int_plus_sqrt_nonsquare` generic theorem
    + `T5_roth_for_two_plus_sqrt_three : RothBoundExists (2 + √3)`

    Covers infinitely many concrete irrationals: 1+√2, 2+√3, 3+√5,
    -1+√7, 5+√11, etc. Foundation pattern: shifted-square minimal
    polynomial for any rational-shift-of-square-root.

    Mathlib usage: `irrational_sqrt_natCast_iff`,
    `Irrational.intCast_add`, `Real.sq_sqrt`,
    `Polynomial.Monic.natDegree_pow`, `monic_X_sub_C`,
    `natDegree_X_sub_C`, `natDegree_sub_C`,
    `Polynomial.aeval_C`, `Polynomial.aeval_X`,
    `unseal Nat.sqrt.iter`.

    Sub-lemma 250/N in T-1 (T-5 Phase 7 ext #57).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 generic `n + √m` Roth witness +
    concrete `2 + √3` instance. Escanor Pride + Erdős Primarch —
    full prove mode, NO STUBS, NO slim. -/
theorem session_559xxxx_T5_phase7_roth_for_int_plus_sqrt_nonsquare_headline :
    (∀ (n : ℤ) (m : ℕ), ¬IsSquare m →
      RothBoundExists ((n : ℝ) + Real.sqrt (m : ℝ))) ∧
    RothBoundExists ((2 : ℝ) + Real.sqrt 3) :=
  ⟨T5_roth_for_int_plus_sqrt_nonsquare,
   T5_roth_for_two_plus_sqrt_three⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntPlusSqrt
