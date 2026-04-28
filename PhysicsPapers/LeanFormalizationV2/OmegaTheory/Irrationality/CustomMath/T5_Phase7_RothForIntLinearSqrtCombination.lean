/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntLinearSqrtCombination

  T-5 (Roth's theorem) — **Phase 7 ext #61: GENERIC UNCONDITIONAL Roth
  for `a + b·√c` (a : ℤ, b : ℤ ≠ 0, c : ℕ non-square)**, sub session
  559bbbbb — STRICT critical-path #316 (T-5) Phase 7 ext #61.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Generic UNCONDITIONAL Roth for the `a + b·√c` family: for any
  a : ℤ, b : ℤ ≠ 0, c : ℕ with `¬IsSquare c`, the value
  `(a : ℝ) + (b : ℝ) · √c` is irrational algebraic of degree 2 with
  witness polynomial `(X - C a)² - C (b² · c) ∈ ℤ[X]`.

  Strategy:
  - α = a + b√c.
  - (α - a)² = b²·c.
  - So (X - a)² - b²c vanishes at α.

  Combined with ext #44 quadratic discharge, gives RothBoundExists for
  any α in this family.

  Concrete instances: `2 + 3·√5`, `1 - 2·√7`, etc.

  Two derivations:
  1. `T5_roth_for_int_linear_sqrt` — generic theorem
  2. `T5_roth_for_one_minus_two_sqrt_three` — concrete witness `1 - 2√3`

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #61 — generic Roth for `a + b·√c` family.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Algebra.Polynomial.Monic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntLinearSqrtCombination

open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement
open Polynomial

/-! ## Defining polynomial (X - a)² - b²·c -/

/-- **🚨 Wave T5 session 559bbbbb — Polynomial (X - a)² - b²·c in ℤ[X]**.

    Minimal polynomial of `a + b·√c` over ℚ in shifted-square form
    (for a, b : ℤ, c : ℕ). -/
noncomputable def polyXMinusASqMinusBSqC (a b : ℤ) (c : ℕ) : Polynomial ℤ :=
  (X - C a) ^ 2 - C (b ^ 2 * (c : ℤ))

/-- **🚨 Wave T5 session 559bbbbb — natDegree = 2**. -/
theorem T5_polyXMinusASqMinusBSqC_natDegree (a b : ℤ) (c : ℕ) :
    (polyXMinusASqMinusBSqC a b c).natDegree = 2 := by
  unfold polyXMinusASqMinusBSqC
  rw [natDegree_sub_C, Polynomial.Monic.natDegree_pow (monic_X_sub_C a),
      natDegree_X_sub_C]

/-- **🚨 Wave T5 session 559bbbbb — non-zero**. -/
theorem T5_polyXMinusASqMinusBSqC_ne_zero (a b : ℤ) (c : ℕ) :
    polyXMinusASqMinusBSqC a b c ≠ 0 := by
  intro h
  have h_natDegree := T5_polyXMinusASqMinusBSqC_natDegree a b c
  rw [h] at h_natDegree
  simp at h_natDegree

/-- **🚨 Wave T5 session 559bbbbb — `a + b·√c` is irrational**
    (a : ℤ, b : ℤ ≠ 0, c : ℕ non-square). -/
theorem T5_int_linear_sqrt_irrational (a b : ℤ) (hb : b ≠ 0) (c : ℕ)
    (hc : ¬IsSquare c) :
    Irrational ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ)) := by
  -- √c irrational
  have h_sqrt_irr : Irrational (Real.sqrt (c : ℝ)) :=
    irrational_sqrt_natCast_iff.mpr hc
  -- b · √c irrational (b ≠ 0, ℤ-mult of irrational)
  have h_b_sqrt_irr : Irrational ((b : ℝ) * Real.sqrt (c : ℝ)) := by
    have h_b_int_form : (b : ℝ) * Real.sqrt (c : ℝ) =
                        ((b : ℤ) : ℝ) * Real.sqrt (c : ℝ) := by push_cast; rfl
    rw [h_b_int_form]
    exact h_sqrt_irr.intCast_mul hb
  -- a + (b√c) = (a : ℤ) + (b√c) irrational
  have h_eq : ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ)) =
              ((a : ℤ) : ℝ) + ((b : ℝ) * Real.sqrt (c : ℝ)) := by
    push_cast; ring
  rw [h_eq]
  exact h_b_sqrt_irr.intCast_add a

/-- **🚨 Wave T5 session 559bbbbb — `aeval (a+b√c) ((X-a)² - b²c) = 0`**. -/
theorem T5_polyXMinusASqMinusBSqC_aeval_eq_zero (a b : ℤ) (c : ℕ) :
    Polynomial.aeval ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ))
        (polyXMinusASqMinusBSqC a b c) = 0 := by
  unfold polyXMinusASqMinusBSqC
  rw [map_sub, map_pow, map_sub, Polynomial.aeval_X, Polynomial.aeval_C,
      Polynomial.aeval_C]
  -- Goal: ((a + b√c) - (algebraMap ℤ ℝ) a)^2 - (algebraMap ℤ ℝ) (b²c) = 0
  rw [show ((algebraMap ℤ ℝ) a : ℝ) = (a : ℝ) from by simp,
      show ((algebraMap ℤ ℝ) (b^2 * (c : ℤ)) : ℝ) =
            ((b : ℝ))^2 * ((c : ℕ) : ℝ) from by
        push_cast
        rfl]
  -- Goal: ((a + b√c) - a)^2 - b^2 · c = 0
  have h_simp : ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ) - (a : ℝ)) =
                (b : ℝ) * Real.sqrt (c : ℝ) := by ring
  rw [h_simp]
  have h_sqrt_sq : Real.sqrt (c : ℝ) ^ 2 = (c : ℝ) := by
    apply Real.sq_sqrt
    exact_mod_cast Nat.zero_le c
  have h_pow_eq : ((b : ℝ) * Real.sqrt (c : ℝ)) ^ 2 = (b : ℝ)^2 * (c : ℝ) := by
    rw [mul_pow, h_sqrt_sq]
  rw [h_pow_eq]
  ring

/-! ## Generic Roth for `a + b·√c` -/

/-- **🚨 Wave T5 session 559bbbbb — UNCONDITIONAL Roth for `a + b·√c`**. -/
theorem T5_roth_for_int_linear_sqrt (a b : ℤ) (hb : b ≠ 0) (c : ℕ)
    (hc : ¬IsSquare c) :
    RothBoundExists ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ)) :=
  T5_quadratic_roth_via_liouville_bound
    ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ))
    (T5_int_linear_sqrt_irrational a b hb c hc)
    (polyXMinusASqMinusBSqC a b c)
    (T5_polyXMinusASqMinusBSqC_ne_zero a b c)
    (T5_polyXMinusASqMinusBSqC_aeval_eq_zero a b c)
    (T5_polyXMinusASqMinusBSqC_natDegree a b c)

/-! ## Concrete instance: 1 - 2·√3 -/

unseal Nat.sqrt.iter in
/-- **🚨 Wave T5 session 559bbbbb — Roth for `1 - 2·√3`**. -/
theorem T5_roth_for_one_minus_two_sqrt_three :
    RothBoundExists ((1 : ℝ) + (-2 : ℝ) * Real.sqrt 3) := by
  have h3 : ¬IsSquare (3 : ℕ) := by decide
  have hb : (-2 : ℤ) ≠ 0 := by decide
  have h_eq : ((1 : ℝ) + (-2 : ℝ) * Real.sqrt 3) =
              ((1 : ℤ) : ℝ) + ((-2 : ℤ) : ℝ) * Real.sqrt ((3 : ℕ) : ℝ) := by
    push_cast; ring
  rw [h_eq]
  exact T5_roth_for_int_linear_sqrt 1 (-2) hb 3 h3

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbbbb — T-5 Phase 7 ext #61:
    GENERIC UNCONDITIONAL Roth for `a + b·√c`**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #61.

    🏆 GENERIC UNCONDITIONAL CONCRETE-WITNESS Roth for ALL `a + b·√c`
    (a : ℤ, b : ℤ ≠ 0, c : ℕ non-square).

    Five derivations + concrete instance:
    1. `polyXMinusASqMinusBSqC` parametrized def
    2. `_natDegree = 2` via `Monic.natDegree_pow` chain
    3. `_ne_zero`
    4. `T5_int_linear_sqrt_irrational` via `Irrational.rat_mul` +
       `Irrational.intCast_add`
    5. `T5_polyXMinusASqMinusBSqC_aeval_eq_zero`
    + `T5_roth_for_int_linear_sqrt` generic theorem
    + `T5_roth_for_one_minus_two_sqrt_three : RothBoundExists (1 - 2√3)`

    Covers infinitely many concrete irrationals: `2 + 3√5`, `1 - 2√7`,
    `5 + √11`, etc. Generalizes ext #57 (n + √m, b = 1 case).

    Mathlib usage: `Irrational.rat_mul`, `Irrational.intCast_add`,
    `Real.sq_sqrt`, `Polynomial.Monic.natDegree_pow`, `monic_X_sub_C`,
    `unseal Nat.sqrt.iter`.

    Sub-lemma 254/N in T-1 (T-5 Phase 7 ext #61).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 fully-generic `a + b·√c` Roth witness.
    Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559bbbbb_T5_phase7_roth_for_int_linear_sqrt_headline :
    (∀ (a b : ℤ), b ≠ 0 → ∀ (c : ℕ), ¬IsSquare c →
      RothBoundExists ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ))) ∧
    RothBoundExists ((1 : ℝ) + (-2 : ℝ) * Real.sqrt 3) :=
  ⟨T5_roth_for_int_linear_sqrt,
   T5_roth_for_one_minus_two_sqrt_three⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForIntLinearSqrtCombination
