/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic

  T-5 (Roth's theorem) — **Phase 7 ext #166: IsCubicAlgebraic Prop
  definition (cubic+ chain prep)**, sub session 559nnnnnnnnn —
  STRICT critical-path #316 (T-5) Phase 7 ext #166.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Named Prop for "α has a degree-exactly-3 ℤ-poly with α as root":

  ```lean
  def IsCubicAlgebraic (α : ℝ) : Prop :=
    ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 3
  ```

  Companion to `IsQuadraticAlgebraic` (ext #133). Used to prepare for
  cubic+ Schmidt-Wirsing-Roth machinery (k ≥ 2 with multivariate
  index theorem).

  Per anti-pattern lock 2026-04-29: real Prop with full quantifier
  content, not `:= True`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #166 — IsCubicAlgebraic Prop definition.
-/

import Mathlib.RingTheory.Algebraic.Basic
import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic

open Polynomial

/-! ## IsCubicAlgebraic Prop -/

/-- **IsCubicAlgebraic** [NAMED Prop, real content per §7.0]:
    α : ℝ has a degree-exactly-3 ℤ-poly with α as root. -/
def IsCubicAlgebraic (α : ℝ) : Prop :=
  ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 3

/-- **🚨 Wave T5 session 559nnnnnnnnn — IsCubicAlgebraic → IsAlgebraic ℤ**.

    Forward implication. -/
theorem T5_isCubicAlgebraic_implies_isAlgebraic
    (α : ℝ) (h : IsCubicAlgebraic α) : IsAlgebraic ℤ α := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := h
  exact ⟨p, hp_ne, hp_root⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559nnnnnnnnn — T-5 Phase 7 ext #166**.

    🏆 IsCubicAlgebraic NAMED Prop + forward implication.

    Per anti-pattern lock 2026-04-29: NAMED Prop with full quantifier content.
    Cubic+ Schmidt-Wirsing-Roth requires k ≥ 2 with multivariate index
    theorem (NOT covered by quadratic discharge ext #130).

    Sub-lemma 339/N. Lean-core only. -/
theorem session_559nnnnnnnnn_T5_phase7_isCubicAlgebraic_headline
    (α : ℝ) (h : IsCubicAlgebraic α) : IsAlgebraic ℤ α :=
  T5_isCubicAlgebraic_implies_isAlgebraic α h

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
