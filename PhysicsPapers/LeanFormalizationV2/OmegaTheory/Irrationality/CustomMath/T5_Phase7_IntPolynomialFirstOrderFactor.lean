/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialFirstOrderFactor

  T-5 (Roth's theorem) — **Phase 7 ext #59: Integer-polynomial
  first-order factor at real root α (cubic+ chain step 4 prep — ℤ→ℝ
  bridge)**, sub session 559zzzz — STRICT critical-path #316 (T-5)
  Phase 7 ext #59.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  Bridge from integer polynomial p ∈ ℤ[X] with `aeval α p = 0` (α : ℝ)
  to the real-coefficient first-order factorization at root α:

  1. `T5_int_polynomial_aeval_zero_iff_map_isRoot`: aeval α p = 0 ↔
     (p.map Int.cast).IsRoot α.
  2. `T5_int_polynomial_first_order_real_factor`: ∃ g ∈ ℝ[X],
     (p.map Int.cast) = (X - C α) * g.
  3. `T5_int_polynomial_real_eval_factor`: For q : ℝ:
     (p.map Int.cast).eval q = (q - α) * g.eval q.

  This bridges ext #58 (general R-coefficient first-order factor) to
  the specific ℤ→ℝ case used in Roth's chain.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #59 — int-poly first-order factor at real root.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialFirstOrderFactor
import Mathlib.Algebra.Polynomial.AlgebraMap
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialFirstOrderFactor

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PolynomialFirstOrderFactor

/-! ## ℤ→ℝ bridge: aeval zero ↔ map.IsRoot -/

/-- **🚨 Wave T5 session 559zzzz — `aeval α p = 0 ↔ (p.map Int.cast).IsRoot α`**.

    For p ∈ Polynomial ℤ and α : ℝ, the algebra evaluation aeval α p = 0
    iff α is a root of the cast-mapped polynomial in ℝ[X]. -/
theorem T5_int_polynomial_aeval_zero_iff_map_isRoot
    (p : Polynomial ℤ) (α : ℝ) :
    Polynomial.aeval α p = 0 ↔ (p.map (Int.castRingHom ℝ)).IsRoot α := by
  unfold Polynomial.IsRoot
  rw [Polynomial.aeval_def]
  -- aeval α p = eval₂ (algebraMap ℤ ℝ) α p
  -- (p.map (Int.castRingHom ℝ)).eval α = eval₂ (Int.castRingHom ℝ) α p
  -- (algebraMap ℤ ℝ) = Int.castRingHom ℝ, definitionally
  rw [show (algebraMap ℤ ℝ : ℤ →+* ℝ) = Int.castRingHom ℝ from rfl]
  rw [← Polynomial.eval_map]

/-! ## First-order factor for ℤ-polynomial at real root -/

/-- **🚨 Wave T5 session 559zzzz — Int-poly first-order factor**.

    For p ∈ Polynomial ℤ with `aeval α p = 0` (α : ℝ), there exists
    g ∈ Polynomial ℝ such that `p.map Int.cast = (X - C α) * g`. -/
theorem T5_int_polynomial_first_order_real_factor
    (p : Polynomial ℤ) (α : ℝ) (hα : Polynomial.aeval α p = 0) :
    ∃ g : Polynomial ℝ,
      p.map ((Int.castRingHom ℝ)) = (X - C α) * g := by
  -- Convert hα to (p.map _).IsRoot α via the bridge above
  have h_root : (p.map (Int.castRingHom ℝ)).IsRoot α :=
    (T5_int_polynomial_aeval_zero_iff_map_isRoot p α).mp hα
  -- Apply ext #58 first-order factor
  exact T5_polynomial_first_order_factor (p.map (Int.castRingHom ℝ)) α h_root

/-- **🚨 Wave T5 session 559zzzz — Int-poly real eval factor**.

    For p ∈ Polynomial ℤ with `aeval α p = 0`, q : ℝ:
    ∃ g, `(p.map Int.cast).eval q = (q - α) * g.eval q`. -/
theorem T5_int_polynomial_real_eval_factor
    (p : Polynomial ℤ) (α : ℝ) (hα : Polynomial.aeval α p = 0) (q : ℝ) :
    ∃ g : Polynomial ℝ,
      (p.map ((Int.castRingHom ℝ))).eval q = (q - α) * g.eval q := by
  obtain ⟨g, hg⟩ := T5_int_polynomial_first_order_real_factor p α hα
  refine ⟨g, ?_⟩
  rw [hg]
  rw [Polynomial.eval_mul, Polynomial.eval_sub, Polynomial.eval_X,
      Polynomial.eval_C]

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zzzz — T-5 Phase 7 ext #59:
    Int-polynomial first-order factor at real root**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #59.

    🏆 ℤ→ℝ BRIDGE for cubic+ chain step 4 (Taylor expansion prep).

    Three derivations:
    1. `T5_int_polynomial_aeval_zero_iff_map_isRoot` — bridge between
       aeval α (over ℤ) and IsRoot of mapped polynomial (over ℝ).
    2. `T5_int_polynomial_first_order_real_factor` — ∃ g ∈ ℝ[X]:
       p.map Int.cast = (X - C α) * g.
    3. `T5_int_polynomial_real_eval_factor` — eval factorization at q.

    Now combinable with ext #52 (univariate integer non-vanishing) +
    ext #55 (Liouville integer bound) to derive the LIOUVILLE-FORM
    REAL DISTANCE BOUND `|q - α| ≥ 1/(M · q.den^d)` for some M
    bounding |g.eval q| on a bounded interval.

    Roth's improvement to `1/H^(2+ε)` requires HIGHER-ORDER Taylor
    (g.eval q decomposes further into derivatives) + Schmidt's index
    argument.

    Mathlib usage: `Polynomial.aeval_def`, `Polynomial.eval_map`,
    `Polynomial.IsRoot`, ext #58 `T5_polynomial_first_order_factor`.

    Sub-lemma 252/N in T-1 (T-5 Phase 7 ext #59).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 ℤ→ℝ bridge for first-order factor
    — opens the Taylor expansion infrastructure for cubic+ Roth.
    Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559zzzz_T5_phase7_int_polynomial_first_order_factor_headline
    (p : Polynomial ℤ) (α : ℝ) (hα : Polynomial.aeval α p = 0) :
    (∃ g : Polynomial ℝ, p.map ((Int.castRingHom ℝ)) = (X - C α) * g) ∧
    (∀ q : ℝ, ∃ g : Polynomial ℝ,
      (p.map ((Int.castRingHom ℝ))).eval q = (q - α) * g.eval q) :=
  ⟨T5_int_polynomial_first_order_real_factor p α hα,
   fun q => T5_int_polynomial_real_eval_factor p α hα q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolynomialFirstOrderFactor
