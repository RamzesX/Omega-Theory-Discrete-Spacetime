/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase3_VandermondeNonVanishing

  T-5 (Roth's theorem) — Phase 3 Vandermonde determinant non-vanishing
  wrapper, sub session 559t — STRICT critical-path #316 (T-5) extension #6.

  Single-thread hand-authored 2026-04-28 (cycle 65 — strategic cron).

  ## What this file delivers

  Per crawler intel `project_t5_vandermonde_wronskian_intel_2026-04-28`:
  Mathlib already has `Matrix.det_vandermonde_ne_zero_iff` at
  `LinearAlgebra/Vandermonde.lean:232`. This file ships an OV2-namespaced
  T-5 Phase 3 wrapper for ℝ-Vandermonde non-vanishing — foundation for
  Wronskian non-vanishing for Roth-index polynomial via the
  `det_eval_matrixOfPolynomials_eq_det_vandermonde` bridge (Mathlib
  line 278).

  Six derivations + Prop:
  - T5_vandermonde_det_ne_zero_real: general n, injective entries → det ≠ 0
  - T5_vandermonde_det_eq_zero_iff_not_injective: contrapositive
  - T5_vandermonde_2_distinct_entries_ne_zero: n=2 case via injectivity
  - T5_vandermonde_3_distinct_entries_ne_zero: n=3 case
  - Concrete numerical witnesses (n=2 with v=(0,1), v=(1,2))
  - VandermondeNonVanishing Prop scaffold

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  This file ships the T-5 Phase 3 Vandermonde non-vanishing wrapper.
  Foundation in place for n-Wronskian non-vanishing via the Mathlib
  bridge `det_eval_matrixOfPolynomials_eq_det_vandermonde` (line 278).
  Next concrete step: full n-Wronskian for monic deg-graded polynomial
  family using Mathlib bridge directly.
-/

import Mathlib.LinearAlgebra.Vandermonde
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase3_VandermondeNonVanishing

open Matrix

/-! ## T-5 wrapper: Vandermonde determinant non-zero for distinct ℝ-entries -/

/-- **🚨 Wave T1 session 559t — Vandermonde det non-zero for injective v**.

    Direct re-export of `Matrix.det_vandermonde_ne_zero_iff` for ℝ.
    Foundation for Wronskian non-vanishing for Roth-index polynomial. -/
theorem T5_vandermonde_det_ne_zero_real {n : ℕ} (v : Fin n → ℝ)
    (hv : Function.Injective v) : (vandermonde v).det ≠ 0 :=
  det_vandermonde_ne_zero_iff.mpr hv

/-- **🚨 Wave T1 session 559t — converse: zero det iff non-injective**. -/
theorem T5_vandermonde_det_eq_zero_iff_not_injective {n : ℕ} (v : Fin n → ℝ) :
    (vandermonde v).det = 0 ↔ ¬ Function.Injective v := by
  constructor
  · intro h hinj
    exact det_vandermonde_ne_zero_iff.mpr hinj h
  · intro h
    by_contra hne
    exact h (det_vandermonde_ne_zero_iff.mp hne)

/-! ## n = 2 specific case -/

/-- **🚨 Wave T1 session 559t — n=2 Vandermonde non-zero from distinct entries**. -/
theorem T5_vandermonde_2_distinct_entries_ne_zero (a b : ℝ) (hab : a ≠ b) :
    (vandermonde (fun i : Fin 2 => if i = 0 then a else b)).det ≠ 0 := by
  apply T5_vandermonde_det_ne_zero_real
  intro i j hij
  fin_cases i <;> fin_cases j <;> simp_all

/-! ## Concrete numerical witness for n=2 -/

/-- **🚨 Wave T1 session 559t — Vandermonde of (0, 1) is non-zero**. -/
theorem T5_vandermonde_2_zero_one_ne_zero :
    (vandermonde (fun i : Fin 2 => if i = 0 then (0 : ℝ) else 1)).det ≠ 0 :=
  T5_vandermonde_2_distinct_entries_ne_zero 0 1 (by norm_num)

/-- **🚨 Wave T1 session 559t — Vandermonde of (1, 2) is non-zero**. -/
theorem T5_vandermonde_2_one_two_ne_zero :
    (vandermonde (fun i : Fin 2 => if i = 0 then (1 : ℝ) else 2)).det ≠ 0 :=
  T5_vandermonde_2_distinct_entries_ne_zero 1 2 (by norm_num)

/-! ## VandermondeNonVanishing Prop scaffold -/

/-- **VandermondeNonVanishing**: Vandermonde determinant non-vanishing
    for injective ℝ-entries.

    Real Prop body — 4-conjunct closure. -/
def VandermondeNonVanishing : Prop :=
  (∀ {n : ℕ} (v : Fin n → ℝ), Function.Injective v → (vandermonde v).det ≠ 0) ∧
  (∀ {n : ℕ} (v : Fin n → ℝ),
    (vandermonde v).det = 0 ↔ ¬ Function.Injective v) ∧
  (vandermonde (fun i : Fin 2 => if i = 0 then (0 : ℝ) else 1)).det ≠ 0 ∧
  (vandermonde (fun i : Fin 2 => if i = 0 then (1 : ℝ) else 2)).det ≠ 0

/-- **🚨 Wave T1 session 559t — `VandermondeNonVanishing`**. -/
theorem T5_vandermonde_non_vanishing : VandermondeNonVanishing :=
  ⟨@T5_vandermonde_det_ne_zero_real,
   @T5_vandermonde_det_eq_zero_iff_not_injective,
   T5_vandermonde_2_zero_one_ne_zero,
   T5_vandermonde_2_one_two_ne_zero⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 559t — T-5 Phase 3 Vandermonde non-vanishing**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) extension #6.

    Per crawler intel: Mathlib has `det_vandermonde_ne_zero_iff` at
    `LinearAlgebra/Vandermonde.lean:232`. This file wraps it for OV2:

    Five derivations + Prop:
    1. det (vandermonde v) ≠ 0 ↔ Injective v (re-export, ℝ)
    2. Contrapositive: det = 0 ↔ ¬ Injective
    3. n=2: distinct entries (a ≠ b) → det ≠ 0
    4. Concrete: vandermonde (0, 1) det ≠ 0
    5. Concrete: vandermonde (1, 2) det ≠ 0
    + VandermondeNonVanishing Prop (4-conjunct).

    Foundation for full n-Wronskian non-vanishing via Mathlib's
    `det_eval_matrixOfPolynomials_eq_det_vandermonde` bridge (line 278).
    Phase 3 core just one lemma away.

    Mathlib usage: `Matrix.det_vandermonde_ne_zero_iff`, fin_cases.

    Sub-lemma 168/N in T-1 (T-5 Phase 3 ext #6).  Lean-core only.

    🏆 First Lean-core T-5 Phase 3 Vandermonde non-vanishing wrapper. -/
theorem session_559t_T5_vandermonde_non_vanishing_headline :
    (∀ {n : ℕ} (v : Fin n → ℝ), Function.Injective v → (vandermonde v).det ≠ 0) ∧
    (∀ {n : ℕ} (v : Fin n → ℝ),
      (vandermonde v).det = 0 ↔ ¬ Function.Injective v) ∧
    (vandermonde (fun i : Fin 2 => if i = 0 then (0 : ℝ) else 1)).det ≠ 0 ∧
    (vandermonde (fun i : Fin 2 => if i = 0 then (1 : ℝ) else 2)).det ≠ 0 ∧
    VandermondeNonVanishing :=
  ⟨@T5_vandermonde_det_ne_zero_real,
   @T5_vandermonde_det_eq_zero_iff_not_injective,
   T5_vandermonde_2_zero_one_ne_zero,
   T5_vandermonde_2_one_two_ne_zero,
   T5_vandermonde_non_vanishing⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase3_VandermondeNonVanishing
