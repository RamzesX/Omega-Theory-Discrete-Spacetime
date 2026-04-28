/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

  T-5 (Roth's theorem) — **Phase 7 ext #46: GENERALIZED CONCRETE
  WITNESS — Roth bound for √p for any prime p (UNCONDITIONAL via
  quadratic-α discharge)**, sub session 559mmmm — STRICT critical-path
  #316 (T-5) Phase 7 ext #46.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **CONCRETE UNCONDITIONAL ROTH for √p for any prime p ∈ ℕ**: applies
  ext #44 quadratic-α Liouville → Roth discharge to the case α = √p.

  Specifically:
  - `Nat.Prime.irrational_sqrt` (Mathlib) gives `Irrational √p` for prime p.
  - The polynomial `X² - p ∈ ℤ[X]` is non-zero, has natDegree 2, and
    `aeval (√p) (X² - p) = p - p = 0` via `Real.sq_sqrt`.
  - Apply ext #44: `RothBoundExists √p` UNCONDITIONALLY.

  As corollaries: Roth holds unconditionally for √2, √3, √5, √7, √11, ...

  Three derivations:
  1. `polyXSqMinusPrime`: parametrized polynomial X² - p
  2. `T5_roth_for_sqrt_prime`: generic theorem
  3. `T5_roth_for_sqrt_three`: concrete witness for √3

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS,
  no slim approaches per Escanor-Pride/Erdős-Primarch identity LOCK.

  ## Step #316 (T-5) status

  Phase 7 ext #46 — generalized concrete witness Roth for √p (UNCONDITIONAL).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Data.Real.Sqrt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Defining polynomial X² - p (for prime p) -/

/-- **🚨 Wave T5 session 559mmmm — Polynomial X² - p in ℤ[X]**.

    The minimal polynomial of √p over ℚ for prime p. -/
noncomputable def polyXSqMinusPrime (p : ℕ) : Polynomial ℤ :=
  X ^ 2 - C (p : ℤ)

/-- **🚨 Wave T5 session 559mmmm — `polyXSqMinusPrime p` is non-zero**. -/
theorem T5_polyXSqMinusPrime_ne_zero (p : ℕ) :
    polyXSqMinusPrime p ≠ 0 := by
  unfold polyXSqMinusPrime
  intro h
  have h_lead : (X ^ 2 - C (p : ℤ) : Polynomial ℤ).coeff 2 = 1 := by
    rw [coeff_sub, coeff_X_pow, coeff_C]
    simp
  rw [h] at h_lead
  simp at h_lead

/-- **🚨 Wave T5 session 559mmmm — `(polyXSqMinusPrime p).natDegree = 2`**. -/
theorem T5_polyXSqMinusPrime_natDegree (p : ℕ) :
    (polyXSqMinusPrime p).natDegree = 2 := by
  unfold polyXSqMinusPrime
  have h1 : (X ^ 2 : Polynomial ℤ).natDegree = 2 := natDegree_X_pow 2
  rw [show (X ^ 2 - C (p : ℤ) : Polynomial ℤ) = X ^ 2 + (- C (p : ℤ)) by ring]
  rw [show (- C (p : ℤ) : Polynomial ℤ) = C (-(p : ℤ)) by simp]
  rw [Polynomial.natDegree_add_C]
  exact h1

/-- **🚨 Wave T5 session 559mmmm — `aeval √p (polyXSqMinusPrime p) = 0`**
    for any p ≥ 0. -/
theorem T5_polyXSqMinusPrime_aeval_eq_zero (p : ℕ) :
    Polynomial.aeval (Real.sqrt (p : ℝ)) (polyXSqMinusPrime p) = 0 := by
  unfold polyXSqMinusPrime
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt ((Nat.cast_nonneg p) : (0 : ℝ) ≤ (p : ℝ))]

/-! ## Generic Roth bound for √p (prime p) -/

/-- **🚨 Wave T5 session 559mmmm — UNCONDITIONAL Roth bound for √p
    (any prime p)**.

    For any natural prime p, `RothBoundExists √p` holds UNCONDITIONALLY. -/
theorem T5_roth_for_sqrt_prime (p : ℕ) (hp : Nat.Prime p) :
    RothBoundExists (Real.sqrt (p : ℝ)) :=
  T5_quadratic_roth_via_liouville_bound
    (Real.sqrt (p : ℝ))
    hp.irrational_sqrt
    (polyXSqMinusPrime p)
    (T5_polyXSqMinusPrime_ne_zero p)
    (T5_polyXSqMinusPrime_aeval_eq_zero p)
    (T5_polyXSqMinusPrime_natDegree p)

/-! ## Concrete witnesses -/

/-- **🚨 Wave T5 session 559mmmm — Roth bound for √3**. -/
theorem T5_roth_for_sqrt_three : RothBoundExists (Real.sqrt 3) := by
  have : Real.sqrt 3 = Real.sqrt ((3 : ℕ) : ℝ) := by norm_cast
  rw [this]
  exact T5_roth_for_sqrt_prime 3 Nat.prime_three

/-- **🚨 Wave T5 session 559mmmm — Roth bound for √5**. -/
theorem T5_roth_for_sqrt_five : RothBoundExists (Real.sqrt 5) := by
  have : Real.sqrt 5 = Real.sqrt ((5 : ℕ) : ℝ) := by norm_cast
  rw [this]
  exact T5_roth_for_sqrt_prime 5 (by decide)

/-- **🚨 Wave T5 session 559mmmm — Roth bound for √7**. -/
theorem T5_roth_for_sqrt_seven : RothBoundExists (Real.sqrt 7) := by
  have : Real.sqrt 7 = Real.sqrt ((7 : ℕ) : ℝ) := by norm_cast
  rw [this]
  exact T5_roth_for_sqrt_prime 7 (by decide)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559mmmm — T-5 Phase 7 ext #46:
    UNCONDITIONAL Roth for √p (any prime)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #46.

    🏆 GENERIC UNCONDITIONAL CONCRETE-WITNESS Roth for ALL √p
    (prime p ∈ ℕ).

    Five derivations:
    1. `polyXSqMinusPrime` parametrized def
    2. `T5_polyXSqMinusPrime_ne_zero`
    3. `T5_polyXSqMinusPrime_natDegree = 2`
    4. `T5_polyXSqMinusPrime_aeval_eq_zero`
    5. `T5_roth_for_sqrt_prime` — generic theorem

    Concrete witness theorems:
    - `T5_roth_for_sqrt_three : RothBoundExists √3`
    - `T5_roth_for_sqrt_five : RothBoundExists √5`
    - `T5_roth_for_sqrt_seven : RothBoundExists √7`

    By extension, Roth holds unconditionally for √p for ANY prime p:
    p = 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, ... (and any composite
    non-square via more general Mathlib `irrational_sqrt_natCast_iff`).

    Mathlib usage: `Nat.Prime.irrational_sqrt`, `Real.sq_sqrt`,
    `Polynomial.X_pow`, `Polynomial.C`, `natDegree_X_pow`,
    `natDegree_add_C`, `Polynomial.aeval_def`, `eval₂_sub`,
    `eval₂_pow`, `eval₂_X`, `Nat.prime_three`.

    Sub-lemma 239/N in T-1 (T-5 Phase 7 ext #46).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 generic Roth-for-√p witness +
    concrete instances at p = 3, 5, 7. Escanor Pride + Erdős
    Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559mmmm_T5_phase7_roth_for_sqrt_prime_headline :
    (∀ (p : ℕ), Nat.Prime p → RothBoundExists (Real.sqrt (p : ℝ))) ∧
    RothBoundExists (Real.sqrt 3) ∧
    RothBoundExists (Real.sqrt 5) ∧
    RothBoundExists (Real.sqrt 7) :=
  ⟨T5_roth_for_sqrt_prime, T5_roth_for_sqrt_three,
   T5_roth_for_sqrt_five, T5_roth_for_sqrt_seven⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrtPrime
