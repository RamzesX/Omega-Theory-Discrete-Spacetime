/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapCoeff

  T-5 (Roth's theorem) — **Phase 7 ext #138: Int → ℝ poly map coefficient
  cast (cubic+ chain bookkeeping)**, sub session 559llllllll —
  STRICT critical-path #316 (T-5) Phase 7 ext #138.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Coefficient cast lemma: for p ∈ ℤ[X] and i : ℕ:
    `(p.map (Int.castRingHom ℝ)).coeff i = ((p.coeff i : ℤ) : ℝ)`

  Used in cubic+ chain to relate ℤ-coefficients of p to ℝ-coefficients
  of (p.map ℝ).

  Single derivation:
  1. `T5_int_poly_map_coeff`: coefficient cast.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #138 — Int → ℝ poly map coefficient cast.
-/

import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Degree.Lemmas
import Mathlib.Data.Real.Basic
import Mathlib.Data.Int.Cast.Lemmas

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapCoeff

open Polynomial

/-! ## map coefficient cast -/

/-- **🚨 Wave T5 session 559llllllll — `(p.map ℝ).coeff i = (p.coeff i : ℝ)`**.

    For p ∈ ℤ[X] and i : ℕ. Mathlib direct via `Polynomial.coeff_map`. -/
theorem T5_int_poly_map_coeff (p : Polynomial ℤ) (i : ℕ) :
    (p.map (Int.castRingHom ℝ)).coeff i = ((p.coeff i : ℤ) : ℝ) := by
  rw [Polynomial.coeff_map]; rfl

/-- Companion: leading coefficient cast. -/
theorem T5_int_poly_map_leadingCoeff (p : Polynomial ℤ) :
    (p.map (Int.castRingHom ℝ)).leadingCoeff = ((p.leadingCoeff : ℤ) : ℝ) := by
  rw [Polynomial.leadingCoeff, Polynomial.leadingCoeff,
      Polynomial.natDegree_map_eq_of_injective Int.cast_injective]
  exact T5_int_poly_map_coeff p p.natDegree

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559llllllll — T-5 Phase 7 ext #138**.

    🏆 BOOKKEEPING — coefficient + leading coefficient cast under ℤ → ℝ map.

    Two derivations:
    1. `T5_int_poly_map_coeff` — coefficient cast.
    2. `T5_int_poly_map_leadingCoeff` — leading coefficient cast.

    Sub-lemma 311/N. Lean-core only. -/
theorem session_559llllllll_T5_phase7_int_poly_map_coeff_headline
    (p : Polynomial ℤ) (i : ℕ) :
    (p.map (Int.castRingHom ℝ)).coeff i = ((p.coeff i : ℤ) : ℝ) ∧
    (p.map (Int.castRingHom ℝ)).leadingCoeff = ((p.leadingCoeff : ℤ) : ℝ) :=
  ⟨T5_int_poly_map_coeff p i, T5_int_poly_map_leadingCoeff p⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapCoeff
