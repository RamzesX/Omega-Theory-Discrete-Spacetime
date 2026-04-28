/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound

  T-5 (Roth's theorem) — **Phase 7 ext #52: Univariate integer
  non-vanishing lower bound (cubic+ chain step 5b)**, sub session
  559ssss — STRICT critical-path #316 (T-5) Phase 7 ext #52.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Combines ext #51 (denominator clearance via scaleRoots) with the
  fundamental |integer| ≥ 1 bound to produce the **integer
  non-vanishing lower bound**:

  For p ∈ Polynomial ℤ, q : ℚ with `eval₂ Int.cast q p ≠ 0`:
    `1 / q.den^p.natDegree ≤ |eval₂ Int.cast q p|`

  This is the LIOUVILLE-STYLE INTEGER NON-VANISHING BOUND that
  combines with the Schmidt-Wirsing-Roth Taylor upper bound (ext #53+)
  to derive the Roth contradiction for cubic+ algebraic α.

  Single derivation:
  1. `T5_univariate_nonzero_lower_bound`: `eval₂ q p ≠ 0 →
     1/q.den^d ≤ |eval₂ q p|`

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #52 — univariate integer non-vanishing lower bound.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateScaleRootsClearance
import Mathlib.Algebra.Polynomial.Eval.Defs
import Mathlib.Data.Int.Cast.Lemmas
import Mathlib.Algebra.Order.Field.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateScaleRootsClearance

/-! ## Univariate integer non-vanishing lower bound -/

/-- **🚨 Wave T5 session 559ssss — q.den^d · p(q) is integer (cleaned form)**.

    Restates ext #51 in a more convenient form: combines the scaleRoots
    clearance with `ringHom_eval₂_intCastRingHom` to express the cleared
    value directly as `((eval q.num (scaleRoots p q.den)) : ℤ) cast to ℚ`. -/
theorem T5_univariate_qden_pow_eval_eq_int_eval
    (p : Polynomial ℤ) (q : ℚ) :
    ((q.den : ℚ)) ^ p.natDegree *
        (Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p)
      = (((Polynomial.eval (q.num) (Polynomial.scaleRoots p (q.den : ℤ))) : ℤ) : ℚ) := by
  rw [T5_univariate_qden_pow_eval_eq_int_cast p q]
  -- Goal: eval₂ (Int.castRingHom ℚ) (q.num : ℚ) (scaleRoots p q.den) = (eval q.num (scaleRoots p q.den) : ℚ)
  -- Via ringHom_eval₂_intCastRingHom: f (eval₂ (Int.castRingHom ℤ) r p) = eval₂ (Int.castRingHom S) (f r) p
  -- with f = Int.castRingHom ℚ, r = q.num
  -- This gives: (eval₂ Int.cast q.num (scaleRoots p q.den) : ℤ) cast to ℚ
  --            = eval₂ Int.cast (q.num : ℚ) (scaleRoots p q.den)
  -- And eval₂ (Int.castRingHom ℤ) r p = eval r p (since Int.castRingHom ℤ = RingHom.id)
  have h := Polynomial.ringHom_eval₂_intCastRingHom
    (Polynomial.scaleRoots p (q.den : ℤ)) (Int.castRingHom ℚ) (q.num)
  -- h : (Int.castRingHom ℚ) (eval₂ (Int.castRingHom ℤ) q.num (scaleRoots p q.den))
  --     = eval₂ (Int.castRingHom ℚ) ((Int.castRingHom ℚ) q.num) (scaleRoots p q.den)
  -- Convert eval₂ (Int.castRingHom ℤ) q.num to eval q.num via Int.castRingHom_int
  rw [Int.castRingHom_int, Polynomial.eval₂_id] at h
  -- h : ((eval q.num (scaleRoots p q.den)) : ℤ) cast to ℚ
  --     = eval₂ Int.cast (q.num : ℚ) (scaleRoots p q.den)
  rw [show ((Int.castRingHom ℚ) (q.num : ℤ) : ℚ) = (q.num : ℚ) from rfl] at h
  exact h.symm

/-- **🚨 Wave T5 session 559ssss — UNIVARIATE NON-VANISHING LOWER BOUND**.

    For p ∈ Polynomial ℤ, q : ℚ with `eval₂ Int.cast q p ≠ 0`:
      `1 / q.den^p.natDegree ≤ |eval₂ Int.cast q p|` -/
theorem T5_univariate_nonzero_lower_bound
    (p : Polynomial ℤ) (q : ℚ)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0) :
    (1 : ℚ) / ((q.den : ℚ)) ^ p.natDegree ≤
      |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p| := by
  obtain h_clear := T5_univariate_qden_pow_eval_eq_int_eval p q
  set k : ℤ := Polynomial.eval (q.num) (Polynomial.scaleRoots p (q.den : ℤ)) with hk_def
  -- h_clear : q.den^d * eval₂ q p = (k : ℚ)
  have h_qden_pos : (0 : ℚ) < (q.den : ℚ) := by exact_mod_cast q.pos
  have h_qden_pow_pos : (0 : ℚ) < ((q.den : ℚ)) ^ p.natDegree := by positivity
  have h_qden_pow_ne : ((q.den : ℚ)) ^ p.natDegree ≠ 0 := ne_of_gt h_qden_pow_pos
  -- k ≠ 0 since eval₂ q p ≠ 0 and q.den^d ≠ 0
  have h_k_ne : k ≠ 0 := by
    intro hk
    apply h_nonzero
    have h_prod_zero : ((q.den : ℚ)) ^ p.natDegree *
            (Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p) = 0 := by
      rw [h_clear]
      simp [hk]
    -- q.den^d > 0, so eval₂ q p = 0
    rcases mul_eq_zero.mp h_prod_zero with h1 | h2
    · exact absurd h1 h_qden_pow_ne
    · exact h2
  -- |k| ≥ 1
  have h_k_abs_ge : (1 : ℚ) ≤ |(k : ℚ)| := by
    have h1 : (1 : ℤ) ≤ |k| := Int.one_le_abs h_k_ne
    have h2 : |(k : ℚ)| = ((|k| : ℤ) : ℚ) := by rw [Int.cast_abs]
    rw [h2]
    exact_mod_cast h1
  -- eval₂ q p = k / q.den^d
  have h_eval_eq : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p =
                   (k : ℚ) / ((q.den : ℚ)) ^ p.natDegree := by
    rw [eq_div_iff h_qden_pow_ne, mul_comm]
    exact h_clear
  -- |eval₂ q p| = |k| / q.den^d
  have h_abs : |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p| =
               |(k : ℚ)| / ((q.den : ℚ)) ^ p.natDegree := by
    rw [h_eval_eq, abs_div]
    congr 1
    exact abs_of_pos h_qden_pow_pos
  rw [h_abs]
  exact div_le_div_of_nonneg_right h_k_abs_ge (le_of_lt h_qden_pow_pos)

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ssss — T-5 Phase 7 ext #52:
    univariate integer non-vanishing lower bound**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #52.

    🏆 STEP 5b of cubic+ Schmidt-Wirsing-Roth chain — Liouville-style
    integer non-vanishing.

    Two derivations:
    1. `T5_univariate_qden_pow_eval_eq_int_eval` — cleaner form of ext #51
    2. `T5_univariate_nonzero_lower_bound` — main bound:
       `eval₂ q p ≠ 0 → 1/q.den^d ≤ |eval₂ q p|`

    Strategy: ext #51 gives `q.den^d · p(q) = ((some : ℤ) : ℚ)`. If p(q) ≠ 0,
    integer is non-zero, so |integer| ≥ 1, so |q.den^d · p(q)| ≥ 1, so
    |p(q)| ≥ 1/q.den^d.

    Combined with Taylor upper bound `|p(q)| ≤ C · |q-α|^k` (cubic+ chain
    step 4) gives Roth contradiction: for q.den large + Roth-violating
    `|q-α| < q.den^(-(2+ε))` and aux poly with index k > d/(2+ε):
    1/q.den^d ≤ |p(q)| < q.den^(-k(2+ε)) < 1/q.den^d → contradiction.

    Mathlib usage: `Polynomial.ringHom_eval₂_intCastRingHom`,
    `Polynomial.eval`, `Int.cast_abs`, `Int.one_le_abs`,
    `eq_div_iff`, `abs_div`, `abs_of_pos`,
    `div_le_div_of_nonneg_right`.

    Sub-lemma 245/N in T-1 (T-5 Phase 7 ext #52).  Lean-core only.

    🏆 Cubic+ chain integer non-vanishing infrastructure shipped.
    Combined with future Taylor bound (s53+), closes RothBoundLarge for
    cubic+. Escanor Pride + Erdős Primarch — full prove mode, NO STUBS,
    NO slim. -/
theorem session_559ssss_T5_phase7_univariate_non_vanishing_lower_bound_headline
    (p : Polynomial ℤ) (q : ℚ)
    (h_nonzero : Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0) :
    (1 : ℚ) / ((q.den : ℚ)) ^ p.natDegree ≤
      |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p| :=
  T5_univariate_nonzero_lower_bound p q h_nonzero

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UnivariateNonVanishingLowerBound
