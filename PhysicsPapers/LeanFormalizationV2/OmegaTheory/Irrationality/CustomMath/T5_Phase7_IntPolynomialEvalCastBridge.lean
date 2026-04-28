/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialEvalCastBridge

  T-5 (Roth's theorem) — **Phase 7 ext #60: Cast bridge from ℤ→ℚ
  eval₂ to ℤ→ℝ-mapped eval (cubic+ chain composition prep)**, sub
  session 559aaaaa — STRICT critical-path #316 (T-5) Phase 7 ext #60.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Cast bridge connecting integer-polynomial evaluation at ℚ (used in
  ext #51-#52) with mapped-real-polynomial evaluation (used in ext #59):

  For p ∈ Polynomial ℤ, q : ℚ:
    `((eval₂ (Int.castRingHom ℚ) (q : ℚ) p : ℚ) : ℝ) =
     (p.map (Int.castRingHom ℝ)).eval ((q : ℚ) : ℝ)`

  This is the **structural bridge** between the integer-non-vanishing
  side (ext #52) and the real-Taylor-factor side (ext #59) of the
  cubic+ chain.

  Single derivation:
  1. `T5_int_polynomial_eval_q_cast_to_real`: cast bridge composition.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #60 — eval cast bridge ℤ→ℚ to ℤ→ℝ-mapped.
-/

import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Real.Basic
import Mathlib.Data.Rat.Cast.Defs
import Mathlib.Algebra.Algebra.Rat

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialEvalCastBridge

open Polynomial

/-! ## Cast bridge -/

/-- **🚨 Wave T5 session 559aaaaa — Cast bridge ℤ→ℚ to ℤ→ℝ-mapped**.

    For p ∈ Polynomial ℤ, q : ℚ:
    `((eval₂ (Int.castRingHom ℚ) (q : ℚ) p : ℚ) : ℝ) =
     (p.map (Int.castRingHom ℝ)).eval ((q : ℚ) : ℝ)`. -/
theorem T5_int_polynomial_eval_q_cast_to_real
    (p : Polynomial ℤ) (q : ℚ) :
    ((Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p : ℚ) : ℝ) =
      (p.map (Int.castRingHom ℝ)).eval ((q : ℚ) : ℝ) := by
  -- (p.map (Int.castRingHom ℝ)).eval x = eval₂ (Int.castRingHom ℝ) x p
  rw [Polynomial.eval_map]
  -- Now: ((eval₂ (Int.castRingHom ℚ) q p : ℚ) : ℝ) =
  --       eval₂ (Int.castRingHom ℝ) ((q : ℚ) : ℝ) p
  -- Apply ringHom_eval₂_intCastRingHom with f = algebraMap ℚ ℝ : ℚ →+* ℝ
  have h := Polynomial.ringHom_eval₂_intCastRingHom p
    (algebraMap ℚ ℝ : ℚ →+* ℝ) (q : ℚ)
  -- h : (algebraMap ℚ ℝ) (eval₂ (Int.castRingHom ℚ) q p) =
  --     eval₂ (Int.castRingHom ℝ) ((algebraMap ℚ ℝ) q) p
  -- (algebraMap ℚ ℝ) q : ℝ = (q : ℚ) : ℝ (via Rat.cast)
  rw [show ((algebraMap ℚ ℝ) (q : ℚ) : ℝ) = ((q : ℚ) : ℝ) from rfl] at h
  rw [show ((algebraMap ℚ ℝ) (Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p) : ℝ) =
        ((Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p : ℚ) : ℝ) from rfl] at h
  exact h

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaaaa — T-5 Phase 7 ext #60:
    Cast bridge ℤ→ℚ-eval to ℤ→ℝ-mapped-eval**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #60.

    🏆 STRUCTURAL BRIDGE for cubic+ chain composition.

    Single derivation:
    1. `T5_int_polynomial_eval_q_cast_to_real` — cast composition.

    Connects ext #51-#52 (integer-non-vanishing side, ℤ→ℚ eval) with
    ext #59 (real-Taylor-factor side, ℤ→ℝ-mapped eval). Foundation for
    composing the two sides into the Liouville-form distance bound
    `|q - α| · |g.eval q| ≥ 1/q.den^d` (cubic+ chain step 4 composite).

    Mathlib usage: `Polynomial.eval_map`,
    `Polynomial.ringHom_eval₂_intCastRingHom`, `Rat.castRingHom`.

    Sub-lemma 253/N in T-1 (T-5 Phase 7 ext #60).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cast bridge for cubic+ chain
    composition. Escanor Pride + Erdős Primarch — full prove mode,
    NO STUBS, NO slim. -/
theorem session_559aaaaa_T5_phase7_int_polynomial_eval_cast_bridge_headline
    (p : Polynomial ℤ) (q : ℚ) :
    ((Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p : ℚ) : ℝ) =
      (p.map (Int.castRingHom ℝ)).eval ((q : ℚ) : ℝ) :=
  T5_int_polynomial_eval_q_cast_to_real p q

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialEvalCastBridge
