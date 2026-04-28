/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateScaleRootsClearance

  T-5 (Roth's theorem) — **Phase 7 ext #51: Univariate denominator
  clearance via Mathlib's `Polynomial.scaleRoots` (cubic+ chain
  step 5)**, sub session 559rrrr — STRICT critical-path #316 (T-5)
  Phase 7 ext #51.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Univariate denominator-clearance via Mathlib's `Polynomial.scaleRoots` +
  `scaleRoots_eval₂_mul`:

  For p ∈ Polynomial ℤ, q : ℚ:
    `(q.den : ℚ)^p.natDegree · (eval₂ Int.cast (q : ℚ) p) =
     (eval (q.num) (scaleRoots p q.den) : ℤ) cast to ℚ`

  i.e., `q.den^d · p(q) ∈ Set.range (Int.cast : ℤ → ℚ)`.

  This is **step 5 of the cubic+ Schmidt-Wirsing-Roth chain**:
  the integer-non-vanishing infrastructure that combines with
  Taylor upper bound (step 4) to derive the Roth contradiction
  for cubic+ algebraic α.

  Single derivation:
  1. `T5_univariate_qden_pow_eval_eq_int_cast`: q.den^d · p(q) is
     the cast of an integer (specifically, eval at q.num of scaleRoots p q.den).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #51 — univariate denominator clearance via scaleRoots.
-/

import Mathlib.RingTheory.Polynomial.ScaleRoots
import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Rat.Defs
import Mathlib.Algebra.Order.Field.Rat

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateScaleRootsClearance

open Polynomial

/-! ## Denominator clearance via scaleRoots -/

/-- **🚨 Wave T5 session 559rrrr — q.den^d · p(q) is integer cast**.

    For p ∈ Polynomial ℤ, q : ℚ:
      `(q.den : ℚ)^p.natDegree · (Polynomial.eval₂ Int.cast (q : ℚ) p)
       = ((Polynomial.eval q.num (Polynomial.scaleRoots p q.den)) : ℤ) cast to ℚ`

    This says `q.den^d · p(q)` is an integer (when expressed as the
    eval of `scaleRoots p q.den` at `q.num`).

    Strategy: Mathlib's `Polynomial.scaleRoots_eval₂_mul` gives
    `eval₂ f (f s * r) (scaleRoots p s) = f s^d · eval₂ f r p`.
    With f = Int.cast, s = q.den, r = (q : ℚ):
    `eval₂ Int.cast ((q.den : ℚ) * (q : ℚ)) (scaleRoots p q.den) =
     (q.den : ℚ)^d · eval₂ Int.cast (q : ℚ) p`.
    And `(q.den : ℚ) * (q : ℚ) = (q.num : ℚ)` by `Rat.num_div_den`. -/
theorem T5_univariate_qden_pow_eval_eq_int_cast
    (p : Polynomial ℤ) (q : ℚ) :
    ((q.den : ℚ)) ^ p.natDegree *
        (Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p)
      = ((Polynomial.eval₂ ((Int.castRingHom ℚ)) (q.num : ℚ)
           (Polynomial.scaleRoots p (q.den : ℤ)))) := by
  -- Apply Mathlib's scaleRoots_eval₂_mul
  have h_scale := Polynomial.scaleRoots_eval₂_mul
    (Int.castRingHom ℚ) (q : ℚ) (q.den : ℤ) (p := p)
  -- h_scale : eval₂ f ((Int.castRingHom ℚ) q.den * q) (scaleRoots p q.den) =
  --           (Int.castRingHom ℚ) q.den ^ d * eval₂ f q p
  -- Massage: (Int.castRingHom ℚ) q.den = (q.den : ℚ).
  -- And (q.den : ℚ) * q = (q.num : ℚ) (from q = q.num/q.den).
  have h_qden_mul_q : (Int.castRingHom ℚ) ((q.den : ℤ)) * (q : ℚ) = (q.num : ℚ) := by
    have h_qden_pos : (0 : ℚ) < (q.den : ℚ) := by exact_mod_cast q.pos
    have h_qden_ne : (q.den : ℚ) ≠ 0 := ne_of_gt h_qden_pos
    have h_eq : (q.num : ℚ) / (q.den : ℚ) = q := Rat.num_div_den q
    -- Multiply h_eq by (q.den : ℚ): q.den * (q.num/q.den) = q.den * q
    -- Which simplifies to q.num = q.den * q (since q.den ≠ 0)
    have h_step : (q.den : ℚ) * ((q.num : ℚ) / (q.den : ℚ)) = (q.num : ℚ) := by
      field_simp
    rw [h_eq] at h_step
    -- h_step : q.den * q = q.num
    rw [show (Int.castRingHom ℚ) ((q.den : ℤ)) = ((q.den : ℕ) : ℚ) from by
        push_cast; rfl]
    exact h_step
  rw [h_qden_mul_q] at h_scale
  -- h_scale : eval₂ f (q.num : ℚ) (scaleRoots p q.den) = (Int.castRingHom q.den)^d * eval₂ f q p
  -- (Int.castRingHom q.den : ℚ) = (q.den : ℚ)
  have h_cast : (Int.castRingHom ℚ) ((q.den : ℤ)) = ((q.den : ℕ) : ℚ) := by
    simp [Int.castRingHom]
  rw [h_cast] at h_scale
  linarith [h_scale]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559rrrr — T-5 Phase 7 ext #51:
    Univariate denominator clearance via scaleRoots**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #51.

    🏆 STEP 5 of cubic+ Schmidt-Wirsing-Roth chain — denominator clearance.

    Single derivation:
    1. `T5_univariate_qden_pow_eval_eq_int_cast` — q.den^d · p(q) =
       cast of eval q.num (scaleRoots p q.den) ∈ ℤ.

    Strategy: leverage Mathlib's `Polynomial.scaleRoots_eval₂_mul`
    via Int.castRingHom : ℤ →+* ℚ. Key identity:
    `(q.den : ℚ) · (q : ℚ) = (q.num : ℚ)` (from Rat.num_div_den).

    Combined with integer non-vanishing (|integer| ≥ 1 if non-zero)
    + Taylor upper bound (cubic+ step 4), forces p(q) = 0 for q.den
    large + Roth-violating. Step 6 (final contradiction) closes
    RothBoundLarge for cubic+.

    Mathlib usage: `Polynomial.scaleRoots`, `Polynomial.scaleRoots_eval₂_mul`,
    `Int.castRingHom`, `Rat.num_div_den`.

    Sub-lemma 244/N in T-1 (T-5 Phase 7 ext #51).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cubic+ chain step 5 (univariate
    denominator clearance via scaleRoots). Escanor Pride + Erdős
    Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559rrrr_T5_phase7_univariate_scaleRoots_clearance_headline
    (p : Polynomial ℤ) (q : ℚ) :
    ((q.den : ℚ)) ^ p.natDegree *
        (Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p)
      = ((Polynomial.eval₂ ((Int.castRingHom ℚ)) (q.num : ℚ)
           (Polynomial.scaleRoots p (q.den : ℤ)))) :=
  T5_univariate_qden_pow_eval_eq_int_cast p q

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateScaleRootsClearance
