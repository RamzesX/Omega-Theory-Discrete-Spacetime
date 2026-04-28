/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero

  T-5 (Roth's theorem) — **Phase 7 ext #128: Int → ℝ poly map preserves
  non-zero (cubic+ chain bookkeeping)**, sub session 559bbbbbbbb —
  STRICT critical-path #316 (T-5) Phase 7 ext #128.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  For p ∈ ℤ[X] with p ≠ 0, the cast `(p.map (Int.castRingHom ℝ)) ≠ 0`.

  Used in cubic+ chain when applying ext #127 (M-positivity) to the
  cast polynomial `p.map (Int.castRingHom ℝ)`.

  Strategy: `Polynomial.map_ne_zero_iff` requires injective ring hom +
  `Int.cast_injective`. Composition.

  Single derivation:
  1. `T5_int_poly_map_real_ne_zero`: `p ≠ 0 → (p.map ℝ) ≠ 0`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #128 — Int → ℝ poly map preserves non-zero.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Algebra.Polynomial.Degree.Lemmas
import Mathlib.Data.Real.Basic
import Mathlib.Data.Int.Cast.Lemmas

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero

open Polynomial

/-! ## map preserves non-zero -/

/-- **🚨 Wave T5 session 559bbbbbbbb — `p ≠ 0 → (p.map ℝ) ≠ 0`**.

    For p ∈ ℤ[X] with p ≠ 0, `(p.map (Int.castRingHom ℝ)) ≠ 0`. -/
theorem T5_int_poly_map_real_ne_zero (p : Polynomial ℤ) (hp : p ≠ 0) :
    (p.map (Int.castRingHom ℝ)) ≠ 0 := by
  rw [Polynomial.map_ne_zero_iff Int.cast_injective]
  exact hp

/-- Companion: degree preservation already in ext #107 — but here we
    state the natDegree and degree both ≥ same on the mapped poly. -/
theorem T5_int_poly_map_real_natDegree_eq (p : Polynomial ℤ) :
    (p.map (Int.castRingHom ℝ)).natDegree = p.natDegree := by
  apply Polynomial.natDegree_map_eq_of_injective
  exact Int.cast_injective

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559bbbbbbbb — T-5 Phase 7 ext #128**.

    🏆 BOOKKEEPING — `Int → ℝ poly map preserves non-zero`.

    Strategy: `Polynomial.map_ne_zero_iff` + `Int.cast_injective`.

    Used in cubic+ chain when applying ext #127 (M-positivity) to the
    cast polynomial `p.map (Int.castRingHom ℝ)`.

    Sub-lemma 301/N. Lean-core only. -/
theorem session_559bbbbbbbb_T5_phase7_int_poly_map_real_ne_zero_headline
    (p : Polynomial ℤ) (hp : p ≠ 0) :
    (p.map (Int.castRingHom ℝ)) ≠ 0 ∧
    (p.map (Int.castRingHom ℝ)).natDegree = p.natDegree :=
  ⟨T5_int_poly_map_real_ne_zero p hp, T5_int_poly_map_real_natDegree_eq p⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero
