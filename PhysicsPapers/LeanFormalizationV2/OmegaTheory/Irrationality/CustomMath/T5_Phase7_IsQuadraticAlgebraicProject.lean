/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraicProject

  T-5 (Roth's theorem) — **Phase 7 ext #136: IsQuadraticAlgebraic
  projection lemmas (cubic+ chain bookkeeping)**, sub session
  559jjjjjjjj — STRICT critical-path #316 (T-5) Phase 7 ext #136.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Projection lemmas for `IsQuadraticAlgebraic α`:

  - `IsQuadraticAlgebraic α → ∃ p ∈ ℤ[X], p ≠ 0` (poly existence)
  - `IsQuadraticAlgebraic α → ∃ p ∈ ℤ[X], p.natDegree = 2` (degree existence)
  - `IsQuadraticAlgebraic α → ∃ p ∈ ℤ[X], aeval α p = 0` (root existence)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #136 — IsQuadraticAlgebraic projection lemmas.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraicProject

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic

/-! ## Projection lemmas -/

/-- **🚨 Wave T5 session 559jjjjjjjj — IsQuadraticAlgebraic projects**.

    Three lightweight projections from `IsQuadraticAlgebraic α`. -/
theorem T5_isQuadraticAlgebraic_witness_ne_zero
    (α : ℝ) (h : IsQuadraticAlgebraic α) :
    ∃ (p : Polynomial ℤ), p ≠ 0 := by
  obtain ⟨p, hp_ne, _, _⟩ := h
  exact ⟨p, hp_ne⟩

theorem T5_isQuadraticAlgebraic_witness_natDegree
    (α : ℝ) (h : IsQuadraticAlgebraic α) :
    ∃ (p : Polynomial ℤ), p.natDegree = 2 := by
  obtain ⟨p, _, _, hp_deg⟩ := h
  exact ⟨p, hp_deg⟩

theorem T5_isQuadraticAlgebraic_witness_aeval
    (α : ℝ) (h : IsQuadraticAlgebraic α) :
    ∃ (p : Polynomial ℤ), Polynomial.aeval α p = 0 := by
  obtain ⟨p, _, hp_root, _⟩ := h
  exact ⟨p, hp_root⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559jjjjjjjj — T-5 Phase 7 ext #136**.

    🏆 BOOKKEEPING — 3 projection lemmas from IsQuadraticAlgebraic.

    Strategy: trivial unfolding of the existential.

    Sub-lemma 309/N. Lean-core only. -/
theorem session_559jjjjjjjj_T5_phase7_isQuadraticAlgebraic_project_headline
    (α : ℝ) (h : IsQuadraticAlgebraic α) :
    (∃ (p : Polynomial ℤ), p ≠ 0) ∧
    (∃ (p : Polynomial ℤ), p.natDegree = 2) ∧
    (∃ (p : Polynomial ℤ), Polynomial.aeval α p = 0) :=
  ⟨T5_isQuadraticAlgebraic_witness_ne_zero α h,
   T5_isQuadraticAlgebraic_witness_natDegree α h,
   T5_isQuadraticAlgebraic_witness_aeval α h⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraicProject
