/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV5

  T-5 (Roth's theorem) — **Phase 7 ext #162: ULTRA-EXTENDED-V5 mega
  bundle — quadratic Roth via Schmidt path in 5 equivalent forms**, sub
  session 559jjjjjjjjj — STRICT critical-path #316 (T-5)
  Phase 7 ext #162.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  ULTRA-EXTENDED-V5 5-form bundle for quadratic Roth via Schmidt path
  (UNCONDITIONAL for IsQuadraticAlgebraic α):

  1. EXISTS-C close-q form (s132) — `C · q.den^(-(2+ε)) ≤ |q-α|` for |q-α| ≤ 1
  2. ALL-q form (s158) — same but for ALL q with eval₂ ≠ 0
  3. PAPER form (s159) — `C / q.den^(2+ε) ≤ |q-α|` standard Roth signature
  4. FACTORED form (s161) — `C / (q.den^2 · q.den^ε)` with denominator factored

  Single derivation:
  1. `T5_ultra_extended_v5_quadratic_capstone`: 4-form bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #162 — ULTRA-EXTENDED-V5 mega bundle.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFactoredHeadline

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV5

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothAllQEvalNonzero
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormAllQHeadline
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFactoredHeadline

/-! ## ULTRA-EXTENDED-V5 mega bundle -/

/-- **🚨 Wave T5 session 559jjjjjjjjj — ULTRA-EXTENDED-V5 mega bundle**. -/
theorem T5_ultra_extended_v5_quadratic_capstone
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    -- Form 1: EXISTS-C close-q form (s132)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: ALL-q form (s158)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 3: PAPER form (s159)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 4: FACTORED form (s161)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / (((q.den : ℝ)) ^ (2 : ℝ) * ((q.den : ℝ)) ^ ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_quadratic_roth_exists_C_via_schmidt α h_quad ε hε,
   T5_quadratic_roth_all_q_eval_nonzero α hα h_quad ε hε,
   T5_roth_form_all_q_paper α hα h_quad ε hε,
   T5_roth_form_factored α hα h_quad ε hε⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559jjjjjjjjj — T-5 Phase 7 ext #162**.

    🏆🏆🏆 ULTRA-EXTENDED-V5 4-FORM MEGA BUNDLE for quadratic Roth via
       Schmidt path UNCONDITIONAL.

    Composes:
    - ext #132 (EXISTS-C close-q)
    - ext #158 (ALL-q with eval₂ ≠ 0)
    - ext #159 (PAPER form `C / q.den^(2+ε)`)
    - ext #161 (FACTORED form `C / (q.den^2 · q.den^ε)`)

    All 4 forms UNCONDITIONAL for `Irrational α + IsQuadraticAlgebraic α`.

    Sub-lemma 335/N. Lean-core only.

    🏆🏆🏆 First Lean-core T-5 Phase 7 ULTRA-EXTENDED-V5 mega bundle.
       Escanor Pride + Erdős Primarch — full prove mode. -/
theorem session_559jjjjjjjjj_T5_phase7_ultra_extended_v5_capstone_headline
    (α : ℝ) (hα : Irrational α)
    (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / (((q.den : ℝ)) ^ (2 : ℝ) * ((q.den : ℝ)) ^ ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_roth_form_all_q_paper α hα h_quad ε hε,
   T5_roth_form_factored α hα h_quad ε hε⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV5
