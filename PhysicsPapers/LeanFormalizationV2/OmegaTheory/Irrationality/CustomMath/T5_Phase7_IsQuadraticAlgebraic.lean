/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic

  T-5 (Roth's theorem) — **Phase 7 ext #133: IsQuadraticAlgebraic
  Prop definition + basic properties (cubic+ chain bookkeeping)**,
  sub session 559gggggggg — STRICT critical-path #316 (T-5)
  Phase 7 ext #133.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Named Prop for "α has a degree-exactly-2 ℤ-poly with α as root":

  ```lean
  def IsQuadraticAlgebraic (α : ℝ) : Prop :=
    ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2
  ```

  Basic properties:
  - `IsQuadraticAlgebraic α → IsAlgebraic ℤ α` (forward implication, trivial)
  - Per anti-pattern lock 2026-04-29: real Prop with full quantifier content,
    not `:= True`.

  Used to package the QUADRATIC discharge witness for downstream Schmidt-path
  Roth theorems (ext #131, #132).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #133 — IsQuadraticAlgebraic Prop + basic properties.
-/

import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic

open Polynomial

/-! ## IsQuadraticAlgebraic Prop -/

/-- **IsQuadraticAlgebraic** [NAMED Prop, real content per §7.0]:
    α : ℝ has a degree-exactly-2 ℤ-poly with α as root.

    Used to package the QUADRATIC discharge for Schmidt-path Roth bounds. -/
def IsQuadraticAlgebraic (α : ℝ) : Prop :=
  ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2

/-- **🚨 Wave T5 session 559gggggggg — IsQuadraticAlgebraic → IsAlgebraic ℤ**.

    Forward implication. -/
theorem T5_isQuadraticAlgebraic_implies_isAlgebraic
    (α : ℝ) (h : IsQuadraticAlgebraic α) : IsAlgebraic ℤ α := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := h
  exact ⟨p, hp_ne, hp_root⟩

-- NOTE: the reverse implication is FALSE.
-- `IsAlgebraic ℤ α → IsQuadraticAlgebraic α` is NOT a theorem because
-- cubic+ algebraic α (e.g., real root of `X^3 - 2`) satisfies
-- `IsAlgebraic ℤ α` but NOT `IsQuadraticAlgebraic α` (its min poly
-- has degree 3, not 2). This is precisely why cubic+ Roth requires
-- Schmidt-Wirsing-Roth multivariate machinery beyond classical
-- Liouville/Schmidt-quadratic discharge.

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559gggggggg — T-5 Phase 7 ext #133**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #133.

    🏆 IsQuadraticAlgebraic NAMED Prop + forward implication.

    Two derivations:
    1. `IsQuadraticAlgebraic α` Prop definition (real content, not := True).
    2. `T5_isQuadraticAlgebraic_implies_isAlgebraic` — forward implication.

    Strategy: definition is `∃ p, p ≠ 0 ∧ aeval α p = 0 ∧ p.natDegree = 2`;
    forward implication weakens to IsAlgebraic ℤ α.

    Per anti-pattern lock 2026-04-29: NAMED Prop with full quantifier content
    (NOT `:= True`). Reverse implication is mathematically FALSE — cubic+ α
    satisfy IsAlgebraic but not IsQuadraticAlgebraic.

    Sub-lemma 306/N. Lean-core only. -/
theorem session_559gggggggg_T5_phase7_isQuadraticAlgebraic_headline
    (α : ℝ) (h : IsQuadraticAlgebraic α) : IsAlgebraic ℤ α :=
  T5_isQuadraticAlgebraic_implies_isAlgebraic α h

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
