/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAlgebraicRothBundle

  T-5 (Roth's theorem) — **Phase 7 ext #134: Clean Quadratic Roth
  bundle using IsQuadraticAlgebraic Prop (cubic+ chain wrapper)**, sub
  session 559hhhhhhhh — STRICT critical-path #316 (T-5) Phase 7 ext #134.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Repackages ext #131 + ext #132 with `IsQuadraticAlgebraic α` as the
  hypothesis (instead of the explicit `∃ p, ...` quadratic witness).
  Cleaner statement; matches Prop signature.

  Two derivations:
  1. `T5_quadratic_algebraic_roth_form`: `IsQuadraticAlgebraic α + ε > 0
     → ∃ p, M > 0, ... |q-α| ≥ M^(-1) · q.den^(-(2+ε))`
  2. `T5_quadratic_algebraic_roth_exists_C`: same with `∃ C > 0` form.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #134 — IsQuadraticAlgebraic Roth bundle.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAlgebraicRothBundle

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothFormSchmidtPath
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt

/-! ## Quadratic-algebraic Roth bundle -/

/-- **🚨 Wave T5 session 559hhhhhhhh — Clean quadratic-algebraic Roth-form**.

    For α : ℝ with `IsQuadraticAlgebraic α` and ε > 0:
      ∃ M > 0, p ≠ 0, ∀ q close to α with eval₂ ≠ 0:
        `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_quadratic_algebraic_roth_form
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_form_via_schmidt_path α h_quad ε hε

/-- **🚨 EXISTS-C variant**.

    For α : ℝ with `IsQuadraticAlgebraic α` and ε > 0:
      ∃ C > 0, p ≠ 0, ∀ q close to α with eval₂ ≠ 0:
        `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_quadratic_algebraic_roth_exists_C
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_exists_C_via_schmidt α h_quad ε hε

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559hhhhhhhh — T-5 Phase 7 ext #134**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #134.

    🏆 IsQuadraticAlgebraic ROTH BUNDLE — clean wrapper using NAMED Prop.

    Two derivations:
    1. `T5_quadratic_algebraic_roth_form` — Roth-form bound with M.
    2. `T5_quadratic_algebraic_roth_exists_C` — EXISTS-C standard form.

    Strategy: trivial composition of ext #131 + ext #132 with
    IsQuadraticAlgebraic in place of explicit witness extraction.

    Sub-lemma 307/N. Lean-core only. -/
theorem session_559hhhhhhhh_T5_phase7_quadratic_algebraic_roth_bundle_headline
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    (∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_quadratic_algebraic_roth_form α h_quad ε hε,
   T5_quadratic_algebraic_roth_exists_C α h_quad ε hε⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAlgebraicRothBundle
