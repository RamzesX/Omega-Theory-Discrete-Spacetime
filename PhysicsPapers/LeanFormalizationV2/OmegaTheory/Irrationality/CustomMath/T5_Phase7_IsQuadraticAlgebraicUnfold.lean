/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraicUnfold

  T-5 (Roth's theorem) — **Phase 7 ext #137: IsQuadraticAlgebraic
  unfolding lemma (cubic+ chain bookkeeping)**, sub session
  559kkkkkkkk — STRICT critical-path #316 (T-5) Phase 7 ext #137.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Definitional iff for `IsQuadraticAlgebraic α`:

  `IsQuadraticAlgebraic α ↔
    ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2`

  Plus constructor: from a witness, IsQuadraticAlgebraic holds.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #137 — IsQuadraticAlgebraic unfolding lemma.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraicUnfold

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic

/-! ## Definitional iff -/

/-- **🚨 Wave T5 session 559kkkkkkkk — IsQuadraticAlgebraic unfolding**.

    `IsQuadraticAlgebraic α ↔ ∃ p : ℤ[X], p ≠ 0 ∧ aeval α p = 0 ∧ p.natDegree = 2`.

    Just unfolds the definition. -/
theorem T5_isQuadraticAlgebraic_iff (α : ℝ) :
    IsQuadraticAlgebraic α ↔
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2 :=
  Iff.rfl

/-- **Constructor**: from a witness, IsQuadraticAlgebraic holds. -/
theorem T5_isQuadraticAlgebraic_of_witness
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0)
    (hp_root : Polynomial.aeval α p = 0) (hp_deg : p.natDegree = 2) :
    IsQuadraticAlgebraic α :=
  ⟨p, hp_ne, hp_root, hp_deg⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559kkkkkkkk — T-5 Phase 7 ext #137**.

    🏆 BOOKKEEPING — IsQuadraticAlgebraic definitional iff + constructor.

    Two derivations:
    1. `T5_isQuadraticAlgebraic_iff` — unfolding via Iff.rfl.
    2. `T5_isQuadraticAlgebraic_of_witness` — constructor from witness.

    Sub-lemma 310/N. Lean-core only. -/
theorem session_559kkkkkkkk_T5_phase7_isQuadraticAlgebraic_unfold_headline
    (α : ℝ) :
    (IsQuadraticAlgebraic α ↔
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧ p.natDegree = 2) :=
  T5_isQuadraticAlgebraic_iff α

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraicUnfold
