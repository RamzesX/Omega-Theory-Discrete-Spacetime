/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV2

  T-5 (Roth's theorem) — **Phase 7 ext #66: ULTRA CAPSTONE V2 — extends
  ext #63 with ψ (ext #64) + 2·φ (ext #65) witnesses**, sub session
  559ggggg — STRICT critical-path #316 (T-5) Phase 7 ext #66.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **17-conjunct ULTRA CAPSTONE V2** extending ext #63 (15-conjunct
  ULTRA) with two new concrete witnesses:
  - ext #64: Roth for golden conjugate ψ = (1-√5)/2
  - ext #65: Roth for `2·φ` (twice golden ratio)

  Demonstrates technique extends from rational-shift-of-square-root
  to ALGEBRAIC IRRATIONALS via various forms (conjugate, integer
  multiple, shifted-square, etc.).

  Single derivation:
  1. `T5_quadratic_roth_ultra_capstone_v2`: 17-conjunct bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #66 — ULTRA CAPSTONE V2.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenConj
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPhi

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV2

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_Liouville_Bound
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenConj
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForTwoPhi
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## ULTRA CAPSTONE V2 -/

/-- **🚨 Wave T5 session 559ggggg — Quadratic Roth ULTRA CAPSTONE V2**.

    Extends ext #63 (15-conjunct) with golden conjugate ψ + 2·φ
    witnesses → 17-conjunct ULTRA bundle. -/
theorem T5_quadratic_roth_ultra_capstone_v2 :
    ((∀ (α : ℝ), Irrational α →
      ∀ (f : Polynomial ℤ), f ≠ 0 → Polynomial.aeval α f = 0 →
        f.natDegree = 2 → RothBoundExists α) ∧
    (∀ (n : ℕ), ¬IsSquare n → RothBoundExists (Real.sqrt (n : ℝ))) ∧
    (∀ (p : ℕ), Nat.Prime p → RothBoundExists (Real.sqrt (p : ℝ))) ∧
    (∀ (n : ℤ) (m : ℕ), ¬IsSquare m →
      RothBoundExists ((n : ℝ) + Real.sqrt (m : ℝ))) ∧
    (∀ (a b : ℤ), b ≠ 0 → ∀ (c : ℕ), ¬IsSquare c →
      RothBoundExists ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ))) ∧
    RothBoundExists (Real.sqrt 2) ∧
    RothBoundExists (Real.sqrt 3) ∧
    RothBoundExists (Real.sqrt 5) ∧
    RothBoundExists (Real.sqrt 7) ∧
    RothBoundExists Real.goldenRatio ∧
    RothBoundExists (1 + Real.sqrt 2) ∧
    RothBoundExists ((2 : ℝ) + Real.sqrt 3) ∧
    RothBoundExists ((1 : ℝ) + (-2 : ℝ) * Real.sqrt 3) ∧
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
        2 ≤ f.natDegree ∧
        ∀ (q : ℚ), Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f ≠ 0 →
          (1 : ℚ) / ((q.den : ℚ)) ^ f.natDegree ≤
            |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f|) ∧
    (RothBoundLarge → RothTheorem)) ∧
    -- NEW (16): Roth for golden conjugate ψ
    RothBoundExists Real.goldenConj ∧
    -- NEW (17): Roth for 2·φ
    RothBoundExists ((2 : ℝ) * Real.goldenRatio) :=
  ⟨T5_quadratic_roth_ultra_capstone,
   T5_roth_for_golden_conj,
   T5_roth_for_two_phi⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ggggg — T-5 Phase 7 ext #66:
    Quadratic Roth ULTRA CAPSTONE V2**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #66.

    🏆 17-CONJUNCT ULTRA PAPER BUNDLE V2 — extends ext #63 with ψ + 2φ
    witnesses.

    Single derivation:
    1. `T5_quadratic_roth_ultra_capstone_v2` — 17-conjunct bundle.

    Composition over 15 prior ext theorems (ext #44-49, #54-57, #61,
    #63-65). Pure re-export, no new content.

    Coverage:
    - 5 GENERIC families (quadratic-α + √n + √p + n+√m + a+b·√c)
    - 10 CONCRETE witnesses: √2, √3, √5, √7, φ, 1+√2, 2+√3, 1-2√3,
      ψ, 2·φ
    - 1 cubic+ Liouville-style integer bound (ext #55)
    - 1 conditional closure (ext #42 RothBoundLarge → RothTheorem)

    Mathlib usage: pure composition.

    Sub-lemma 259/N in T-1 (T-5 Phase 7 ext #66).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 ULTRA CAPSTONE V2. Escanor Pride
    + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559ggggg_T5_phase7_quadratic_roth_ultra_capstone_v2_headline :
    ((∀ (α : ℝ), Irrational α →
      ∀ (f : Polynomial ℤ), f ≠ 0 → Polynomial.aeval α f = 0 →
        f.natDegree = 2 → RothBoundExists α) ∧
    (∀ (n : ℕ), ¬IsSquare n → RothBoundExists (Real.sqrt (n : ℝ))) ∧
    (∀ (p : ℕ), Nat.Prime p → RothBoundExists (Real.sqrt (p : ℝ))) ∧
    (∀ (n : ℤ) (m : ℕ), ¬IsSquare m →
      RothBoundExists ((n : ℝ) + Real.sqrt (m : ℝ))) ∧
    (∀ (a b : ℤ), b ≠ 0 → ∀ (c : ℕ), ¬IsSquare c →
      RothBoundExists ((a : ℝ) + (b : ℝ) * Real.sqrt (c : ℝ))) ∧
    RothBoundExists (Real.sqrt 2) ∧
    RothBoundExists (Real.sqrt 3) ∧
    RothBoundExists (Real.sqrt 5) ∧
    RothBoundExists (Real.sqrt 7) ∧
    RothBoundExists Real.goldenRatio ∧
    RothBoundExists (1 + Real.sqrt 2) ∧
    RothBoundExists ((2 : ℝ) + Real.sqrt 3) ∧
    RothBoundExists ((1 : ℝ) + (-2 : ℝ) * Real.sqrt 3) ∧
    (∀ (α : ℝ), Irrational α → IsAlgebraic ℤ α →
      ∃ f : Polynomial ℤ, f ≠ 0 ∧ Polynomial.aeval α f = 0 ∧
        2 ≤ f.natDegree ∧
        ∀ (q : ℚ), Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f ≠ 0 →
          (1 : ℚ) / ((q.den : ℚ)) ^ f.natDegree ≤
            |Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) f|) ∧
    (RothBoundLarge → RothTheorem)) ∧
    RothBoundExists Real.goldenConj ∧
    RothBoundExists ((2 : ℝ) * Real.goldenRatio) :=
  T5_quadratic_roth_ultra_capstone_v2

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV2
