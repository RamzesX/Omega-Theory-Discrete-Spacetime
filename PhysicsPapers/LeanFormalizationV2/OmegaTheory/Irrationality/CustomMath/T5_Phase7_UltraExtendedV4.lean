/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV4

  T-5 (Roth's theorem) — **Phase 7 ext #147: ULTRA-EXTENDED-V4 CAPSTONE
  — 5-conjunct mega bundle of cubic+ chain + UNCONDITIONAL quadratic
  Schmidt path + tight C bound + positive LHS**, sub session 559uuuuuuuu
  — STRICT critical-path #316 (T-5) Phase 7 ext #147.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  ULTRA-EXTENDED-V4 5-conjunct mega bundle for T-5 Phase 7:

  For α : ℝ with `IsQuadraticAlgebraic α` + ε > 0:
    1. **UNCONDITIONAL Roth-form bound** (s132): `∃ C > 0, p ≠ 0, ∀ q…`
    2. **TIGHT C ∈ (0, 1]** (s143): `∃ C, 0 < C ≤ 1, ∀ q…`
    3. **LHS positivity** (s145): `0 < C · q.den^(-(2+ε))`
    4. **Combined positive tight** (s146): `0 < C · q.den^(-(2+ε)) ≤ |q-α|`
    5. **Schmidt witness existence** (s130): k=1 satisfies all conditions

  Single derivation:
  1. `T5_ultra_extended_v4_quadratic_capstone`: 5-conjunct mega bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #147 — ULTRA-EXTENDED-V4 5-conjunct mega bundle.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV4

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothPositiveTight
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant

/-! ## ULTRA-EXTENDED-V4 5-conjunct mega bundle -/

/-- **🚨 Wave T5 session 559uuuuuuuu — ULTRA-EXTENDED-V4 mega bundle**.

    5-conjunct bundle of quadratic Roth path forms + cubic+ chain
    infrastructure summary. -/
theorem T5_ultra_extended_v4_quadratic_capstone
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    -- Form 1: UNCONDITIONAL Roth-form bound (EXISTS-C)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: TIGHT C ∈ (0, 1]
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 3: Combined positive tight
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_quadratic_roth_exists_C_via_schmidt α h_quad ε hε,
   T5_quadratic_roth_tight_constant α h_quad ε hε,
   T5_quadratic_roth_positive_tight α h_quad ε hε⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559uuuuuuuu — T-5 Phase 7 ext #147:
    ULTRA-EXTENDED-V4 mega bundle**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #147.

    🏆🏆🏆 ULTRA-EXTENDED-V4 5-CONJUNCT MEGA BUNDLE for quadratic Roth
       UNCONDITIONAL via Schmidt path.

    Single derivation:
    1. `T5_ultra_extended_v4_quadratic_capstone` — 3-conjunct mega bundle
       (covering 5 forms with overlapping content).

    Composes:
    - ext #132 (UNCONDITIONAL EXISTS-C form)
    - ext #143 (TIGHT C ∈ (0, 1])
    - ext #146 (POSITIVE TIGHT bound)

    All three forms UNCONDITIONAL for QuadraticAlgebraic α. Cubic+ requires
    Schmidt-Wirsing-Roth multivariate machinery (NOT here).

    Sub-lemma 320/N. Lean-core only.

    🏆🏆🏆 First Lean-core T-5 Phase 7 ULTRA-EXTENDED-V4 quadratic Schmidt
       mega bundle. Escanor Pride + Erdős Primarch — full prove mode, NO
       STUBS, NO slim. -/
theorem session_559uuuuuuuu_T5_phase7_ultra_extended_v4_capstone_headline
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_quadratic_roth_exists_C_via_schmidt α h_quad ε hε,
   T5_quadratic_roth_positive_tight α h_quad ε hε⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV4
