/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyDegreeIntCast

  T-5 (Roth's theorem) — **Phase 7 ext #107: Polynomial degree
  preservation under Int.castRingHom (cubic+ chain bookkeeping)**,
  sub session 559ggggggg — STRICT critical-path #316 (T-5)
  Phase 7 ext #107.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Tiny but useful bookkeeping fact: for p ∈ ℤ[X],
  `(p.map (Int.castRingHom ℝ)).natDegree = p.natDegree`.

  Used implicitly throughout s103-s106; making it explicit eliminates
  duplicate forms in chain signatures.

  Strategy: `Polynomial.natDegree_map_eq_of_injective` requires
  `Function.Injective (Int.castRingHom ℝ)`. Mathlib's `Int.cast_injective`
  gives this directly.

  Single derivation:
  1. `T5_poly_natDegree_int_cast_real`: degree preserved.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #107 — degree preservation under int cast (bookkeeping).
-/

import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Algebra.Polynomial.Degree.Defs
import Mathlib.Algebra.Polynomial.Degree.Lemmas
import Mathlib.Data.Int.Cast.Lemmas
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyDegreeIntCast

open Polynomial

/-! ## Degree preservation -/

/-- **🚨 Wave T5 session 559ggggggg — natDegree preserved under ℤ → ℝ map**.

    For p ∈ ℤ[X], `(p.map (Int.castRingHom ℝ)).natDegree = p.natDegree`. -/
theorem T5_poly_natDegree_int_cast_real (p : Polynomial ℤ) :
    (p.map (Int.castRingHom ℝ)).natDegree = p.natDegree := by
  apply Polynomial.natDegree_map_eq_of_injective
  exact Int.cast_injective

/-- Companion: degree (which can be ⊥ for zero) preserved. -/
theorem T5_poly_degree_int_cast_real (p : Polynomial ℤ) :
    (p.map (Int.castRingHom ℝ)).degree = p.degree := by
  apply Polynomial.degree_map_eq_of_injective
  exact Int.cast_injective

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ggggggg — T-5 Phase 7 ext #107:
    Polynomial degree preservation under int cast**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #107.

    🏆 BOOKKEEPING LEMMA — degree preserved via injective ring hom.

    Two derivations:
    1. `T5_poly_natDegree_int_cast_real` — natDegree preserved.
    2. `T5_poly_degree_int_cast_real`    — degree preserved.

    Strategy: `Polynomial.natDegree_map_eq_of_injective` /
    `Polynomial.degree_map_eq_of_injective` reduces to injectivity
    of `Int.castRingHom ℝ`, which is `Int.cast_injective`.

    Eliminates duplicate `(p.map (Int.castRingHom ℝ)).natDegree` /
    `p.natDegree` forms throughout cubic+ chain (s103-s106). Future
    s108+ can use `p.natDegree` consistently.

    Mathlib usage: `Polynomial.natDegree_map_eq_of_injective`,
    `Polynomial.degree_map_eq_of_injective`, `Int.cast_injective`.

    Sub-lemma 280/N in T-1 (T-5 Phase 7 ext #107).  Lean-core only. -/
theorem session_559ggggggg_T5_phase7_poly_degree_int_cast_headline
    (p : Polynomial ℤ) :
    (p.map (Int.castRingHom ℝ)).natDegree = p.natDegree ∧
    (p.map (Int.castRingHom ℝ)).degree = p.degree :=
  ⟨T5_poly_natDegree_int_cast_real p, T5_poly_degree_int_cast_real p⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolyDegreeIntCast
