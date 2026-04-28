/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree

  T-5 (Roth's theorem) — **Phase 7 ext #167: Generic IsAlgebraicOfDegree
  Prop (cubic+ chain general degree)**, sub session 559ooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #167.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Generic NAMED Prop for "α has a degree-exactly-n ℤ-poly with α as root":

  ```lean
  def IsAlgebraicOfDegree (α : ℝ) (n : ℕ) : Prop :=
    ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = n
  ```

  Specializations:
  - `IsAlgebraicOfDegree α 2` ↔ `IsQuadraticAlgebraic α` (ext #133)
  - `IsAlgebraicOfDegree α 3` ↔ `IsCubicAlgebraic α` (ext #166)
  - `IsAlgebraicOfDegree α 1` ↔ "α is a rational" (NOT for irrational α)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #167 — Generic IsAlgebraicOfDegree Prop.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic

/-! ## Generic IsAlgebraicOfDegree Prop -/

/-- **IsAlgebraicOfDegree** [generic NAMED Prop]: α has a degree-exactly-n
    ℤ-poly with α as root. -/
def IsAlgebraicOfDegree (α : ℝ) (n : ℕ) : Prop :=
  ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = n

/-! ## Specializations -/

/-- IsAlgebraicOfDegree 2 ↔ IsQuadraticAlgebraic. -/
theorem T5_isAlgebraicOfDegree_two_iff_quadratic (α : ℝ) :
    IsAlgebraicOfDegree α 2 ↔ IsQuadraticAlgebraic α :=
  Iff.rfl

/-- IsAlgebraicOfDegree 3 ↔ IsCubicAlgebraic. -/
theorem T5_isAlgebraicOfDegree_three_iff_cubic (α : ℝ) :
    IsAlgebraicOfDegree α 3 ↔ IsCubicAlgebraic α :=
  Iff.rfl

/-- Forward implication: IsAlgebraicOfDegree α n → IsAlgebraic ℤ α (any n). -/
theorem T5_isAlgebraicOfDegree_implies_isAlgebraic
    (α : ℝ) (n : ℕ) (h : IsAlgebraicOfDegree α n) : IsAlgebraic ℤ α := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := h
  exact ⟨p, hp_ne, hp_root⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ooooooooo — T-5 Phase 7 ext #167**.

    🏆 GENERIC `IsAlgebraicOfDegree α n` NAMED Prop.

    Two derivations:
    1. Specialization to quadratic (n = 2) ↔ IsQuadraticAlgebraic.
    2. Specialization to cubic (n = 3) ↔ IsCubicAlgebraic.

    Plus forward implication to IsAlgebraic ℤ α (any n).

    Per anti-pattern lock 2026-04-29: NAMED Prop with full quantifier
    content. Reverse implication FALSE for n = min poly degree of α.

    Sub-lemma 340/N. Lean-core only. -/
theorem session_559ooooooooo_T5_phase7_isAlgebraicOfDegree_headline
    (α : ℝ) :
    (IsAlgebraicOfDegree α 2 ↔ IsQuadraticAlgebraic α) ∧
    (IsAlgebraicOfDegree α 3 ↔ IsCubicAlgebraic α) :=
  ⟨T5_isAlgebraicOfDegree_two_iff_quadratic α,
   T5_isAlgebraicOfDegree_three_iff_cubic α⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
