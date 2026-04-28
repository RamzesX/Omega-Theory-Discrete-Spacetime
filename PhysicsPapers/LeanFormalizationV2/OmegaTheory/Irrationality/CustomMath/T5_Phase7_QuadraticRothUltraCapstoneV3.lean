/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV3

  T-5 (Roth's theorem) — **Phase 7 ext #71: ULTRA CAPSTONE V3 — extends
  V2 with `1/φ` (ext #67) + `-φ` (ext #70) Pell-family witnesses**, sub
  session 559lllll — STRICT critical-path #316 (T-5) Phase 7 ext #71.

  Single-thread hand-authored 2026-04-28 (cycle 65 → 66 transition).

  ## What this file delivers

  **19-conjunct ULTRA CAPSTONE V3** extending ext #66 (17-conjunct V2)
  with two more Pell-family witnesses:
  - ext #67: Roth for `1/φ = φ - 1` (golden inverse)
  - ext #70: Roth for `-φ` (negative golden ratio)

  **Pell quadratic family COMPLETE** — all four roots of X²-X-1 and
  X²+X-1 unconditionally proved.

  Single derivation:
  1. `T5_quadratic_roth_ultra_capstone_v3`: 19-conjunct bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28:
  full prove mode, NO STUBS, NO slim.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #71 — ULTRA CAPSTONE V3 (Pell family complete).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV2
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForNegPhi

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV3

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Heights
open OmegaTheory.Irrationality.CustomMath.T5_LiouvilleHeightBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothViaLouville
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV2
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForGoldenInverse
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForNegPhi
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothTheoremClosure
open OmegaTheory.Irrationality.CustomMath.T5_RothMasterStatement

/-! ## ULTRA CAPSTONE V3 -/

/-- **🚨 Wave T5 session 559lllll — Quadratic Roth ULTRA CAPSTONE V3**.

    Extends ext #66 (V2 17-conjunct) with 1/φ + -φ → 19-conjunct
    PELL-family-complete bundle. -/
theorem T5_quadratic_roth_ultra_capstone_v3 :
    -- V2 17-conjunct preserved
    (((∀ (α : ℝ), Irrational α →
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
    RothBoundExists ((2 : ℝ) * Real.goldenRatio)) ∧
    -- NEW (18): Roth for 1/φ = φ - 1
    RothBoundExists (Real.goldenRatio - 1) ∧
    -- NEW (19): Roth for -φ
    RothBoundExists (-Real.goldenRatio) :=
  ⟨T5_quadratic_roth_ultra_capstone_v2,
   T5_roth_for_golden_inverse,
   T5_roth_for_neg_phi⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559lllll — T-5 Phase 7 ext #71:
    Quadratic Roth ULTRA CAPSTONE V3 (Pell family complete)**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #71.

    🏆 19-CONJUNCT ULTRA PAPER BUNDLE V3 — extends V2 with full
    PELL FAMILY (φ, ψ, 1/φ, -φ all roots of X²±X-1).

    Single derivation:
    1. `T5_quadratic_roth_ultra_capstone_v3` — 19-conjunct bundle.

    Composition over 17 prior ext theorems (V2 + ext #67, #70).

    Coverage:
    - 5 GENERIC families: quadratic-α, √n, √p, n+√m, a+b·√c
    - 12 CONCRETE witnesses: √2, √3, √5, √7, φ, 1+√2, 2+√3, 1-2√3,
      ψ, 2·φ, 1/φ, -φ
    - 1 cubic+ Liouville-style integer bound
    - 1 conditional closure (RothBoundLarge → RothTheorem)

    Sub-lemma 264/N in T-1 (T-5 Phase 7 ext #71).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 ULTRA CAPSTONE V3 with COMPLETE
    Pell quadratic family. -/
theorem session_559lllll_T5_phase7_quadratic_roth_ultra_capstone_v3_headline :
    (((∀ (α : ℝ), Irrational α →
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
    RothBoundExists ((2 : ℝ) * Real.goldenRatio)) ∧
    RothBoundExists (Real.goldenRatio - 1) ∧
    RothBoundExists (-Real.goldenRatio) :=
  T5_quadratic_roth_ultra_capstone_v3

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothUltraCapstoneV3
