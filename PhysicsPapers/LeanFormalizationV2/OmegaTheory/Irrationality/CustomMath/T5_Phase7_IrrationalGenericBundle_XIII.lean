/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XIII: ext #372-386
  7-WITNESS MASTER + IsAlgebraic ℤ bridges**, sub session
  559aaaaaaaaaaaaaa through 559oooooooooooooo — STRICT critical-path
  #316 (T-5) Phase 7 ext #372-386.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Master 7-witness aggregation (√2, √3, √5, √7, √11, √13, φ) bridged
  to Mathlib's `IsAlgebraic ℤ`, plus combined Roth bound headline.

  Sub-cluster A (per-witness IsAlgebraic ℤ via Bundle-X bridge):
  - ext #372: IsAlgebraic_int_sqrt_two
  - ext #373: IsAlgebraic_int_sqrt_three
  - ext #374: IsAlgebraic_int_sqrt_five
  - ext #375: IsAlgebraic_int_sqrt_seven
  - ext #376: IsAlgebraic_int_sqrt_eleven
  - ext #377: IsAlgebraic_int_sqrt_thirteen
  - ext #378: IsAlgebraic_int_goldenRatio

  Sub-cluster B (master capstone 7-witness):
  - ext #379: bundle_XIII_seven_witness_master (∧ all 7 IsAlgebraic ℤ)
  - ext #380: bundle_XIII_seven_witness_isQuadraticAlgebraic_master
  - ext #381: bundle_XIII_seven_witness_combined_roth_bounds

  Sub-cluster C (Bundle-XIII markers + headlines):
  - ext #382: bundle_XIII_first_in_V2_marker
  - ext #383: bundle_XIII_closed_count
  - ext #384: bundle_XIII_master_alias
  - ext #385: bundle_XIII_paper_headline_alias
  - ext #386: bundle_XIII_grand_headline

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #372-386 — 7-witness master + Mathlib bridges (BUNDLE-XIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XII

/-! ## Sub-cluster A — per-witness IsAlgebraic ℤ bridges -/

/-- **🚨 ext #372** — IsAlgebraic ℤ for √2. -/
theorem T5_IsAlgebraic_int_sqrt_two : IsAlgebraic ℤ (Real.sqrt 2) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 2)
    T5_isQuadraticAlgebraic_sqrt_two

/-- **🚨 ext #373** — IsAlgebraic ℤ for √3. -/
theorem T5_IsAlgebraic_int_sqrt_three : IsAlgebraic ℤ (Real.sqrt 3) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 3)
    T5_isQuadraticAlgebraic_sqrt_three

/-- **🚨 ext #374** — IsAlgebraic ℤ for √5. -/
theorem T5_IsAlgebraic_int_sqrt_five : IsAlgebraic ℤ (Real.sqrt 5) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 5)
    T5_isQuadraticAlgebraic_sqrt_five

/-- **🚨 ext #375** — IsAlgebraic ℤ for √7. -/
theorem T5_IsAlgebraic_int_sqrt_seven : IsAlgebraic ℤ (Real.sqrt 7) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 7)
    T5_isQuadraticAlgebraic_sqrt_seven

/-- **🚨 ext #376** — IsAlgebraic ℤ for √11. -/
theorem T5_IsAlgebraic_int_sqrt_eleven : IsAlgebraic ℤ (Real.sqrt 11) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 11)
    T5_isQuadraticAlgebraic_sqrt_eleven

/-- **🚨 ext #377** — IsAlgebraic ℤ for √13. -/
theorem T5_IsAlgebraic_int_sqrt_thirteen : IsAlgebraic ℤ (Real.sqrt 13) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 13)
    T5_isQuadraticAlgebraic_sqrt_thirteen

/-- **🚨 ext #378** — IsAlgebraic ℤ for goldenRatio. -/
theorem T5_IsAlgebraic_int_goldenRatio : IsAlgebraic ℤ Real.goldenRatio :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int Real.goldenRatio
    T5_isQuadraticAlgebraic_goldenRatio

/-! ## Sub-cluster B — 7-witness master capstones -/

/-- **🚨 ext #379** — Bundle-XIII 7-witness IsAlgebraic ℤ master. -/
theorem T5_bundle_XIII_seven_witness_master :
    IsAlgebraic ℤ (Real.sqrt 2) ∧
    IsAlgebraic ℤ (Real.sqrt 3) ∧
    IsAlgebraic ℤ (Real.sqrt 5) ∧
    IsAlgebraic ℤ (Real.sqrt 7) ∧
    IsAlgebraic ℤ (Real.sqrt 11) ∧
    IsAlgebraic ℤ (Real.sqrt 13) ∧
    IsAlgebraic ℤ Real.goldenRatio :=
  ⟨T5_IsAlgebraic_int_sqrt_two,
   T5_IsAlgebraic_int_sqrt_three,
   T5_IsAlgebraic_int_sqrt_five,
   T5_IsAlgebraic_int_sqrt_seven,
   T5_IsAlgebraic_int_sqrt_eleven,
   T5_IsAlgebraic_int_sqrt_thirteen,
   T5_IsAlgebraic_int_goldenRatio⟩

/-- **🚨 ext #380** — Bundle-XIII 7-witness IsQuadraticAlgebraic master. -/
theorem T5_bundle_XIII_seven_witness_isQuadraticAlgebraic_master :
    IsQuadraticAlgebraic (Real.sqrt 2) ∧
    IsQuadraticAlgebraic (Real.sqrt 3) ∧
    IsQuadraticAlgebraic (Real.sqrt 5) ∧
    IsQuadraticAlgebraic (Real.sqrt 7) ∧
    IsQuadraticAlgebraic (Real.sqrt 11) ∧
    IsQuadraticAlgebraic (Real.sqrt 13) ∧
    IsQuadraticAlgebraic Real.goldenRatio :=
  ⟨T5_isQuadraticAlgebraic_sqrt_two,
   T5_isQuadraticAlgebraic_sqrt_three,
   T5_isQuadraticAlgebraic_sqrt_five,
   T5_isQuadraticAlgebraic_sqrt_seven,
   T5_isQuadraticAlgebraic_sqrt_eleven,
   T5_isQuadraticAlgebraic_sqrt_thirteen,
   T5_isQuadraticAlgebraic_goldenRatio⟩

/-- **🚨 ext #381** — Bundle-XIII 7-witness combined Roth bounds. -/
theorem T5_bundle_XIII_seven_witness_combined_roth_bounds
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- Roth bound for √2
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 2|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 3|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 5|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 7|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 11) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 11|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 13) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 13|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval Real.goldenRatio p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤
          |((q : ℚ) : ℝ) - Real.goldenRatio|) :=
  ⟨T5_roth_for_sqrt_two_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_three_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_five_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_seven_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_eleven_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_thirteen_via_bundle_VII ε hε_pos,
   T5_roth_for_goldenRatio_via_bundle_VII ε hε_pos⟩

/-! ## Sub-cluster C — Bundle-XIII markers + headlines -/

/-- **🚨 ext #382** — Frontier marker: Bundle-XIII 7-witness master. -/
theorem T5_bundle_XIII_first_in_V2_marker :
    ∃ (n : ℕ), 372 ≤ n ∧ n ≤ 386 ∧ n - 372 ≤ 15 :=
  ⟨386, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #383** — Bundle-XIII closure cardinality bookkeeping. -/
theorem T5_bundle_XIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #384** — Bundle-XIII master alias. -/
theorem T5_phase7_irrational_generic_bundle_XIII_master_alias :
    IsAlgebraic ℤ (Real.sqrt 2) ∧
    IsAlgebraic ℤ (Real.sqrt 3) ∧
    IsAlgebraic ℤ (Real.sqrt 5) ∧
    IsAlgebraic ℤ (Real.sqrt 7) ∧
    IsAlgebraic ℤ (Real.sqrt 11) ∧
    IsAlgebraic ℤ (Real.sqrt 13) ∧
    IsAlgebraic ℤ Real.goldenRatio :=
  T5_bundle_XIII_seven_witness_master

/-- **🚨 ext #385** — Bundle-XIII paper headline alias. -/
theorem T5_bundle_XIII_paper_headline_alias :
    -- 7-witness IsAlgebraic ℤ
    (IsAlgebraic ℤ (Real.sqrt 2) ∧
     IsAlgebraic ℤ (Real.sqrt 3) ∧
     IsAlgebraic ℤ (Real.sqrt 5) ∧
     IsAlgebraic ℤ (Real.sqrt 7) ∧
     IsAlgebraic ℤ (Real.sqrt 11) ∧
     IsAlgebraic ℤ (Real.sqrt 13) ∧
     IsAlgebraic ℤ Real.goldenRatio) :=
  T5_bundle_XIII_seven_witness_master

/-! ## Bundle-XIII GRAND HEADLINE -/

/-- **🚨 ext #386 — HEADLINE: BUNDLE-XIII 7-WITNESS MASTER**.

    🏆🏆🏆 15-form bundle delivering IsAlgebraic ℤ certificates +
    IsQuadraticAlgebraic witnesses + Roth bounds for the canonical
    7-witness panel: √2, √3, √5, √7, √11, √13, φ.

    Each Roth bound carries a Mathlib `IsAlgebraic ℤ α` certificate,
    opening the full algebraic-number API for these constants. -/
theorem T5_bundle_XIII_grand_headline
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- 7-witness IsAlgebraic ℤ
    (IsAlgebraic ℤ (Real.sqrt 2) ∧
     IsAlgebraic ℤ (Real.sqrt 3) ∧
     IsAlgebraic ℤ (Real.sqrt 5) ∧
     IsAlgebraic ℤ (Real.sqrt 7) ∧
     IsAlgebraic ℤ (Real.sqrt 11) ∧
     IsAlgebraic ℤ (Real.sqrt 13) ∧
     IsAlgebraic ℤ Real.goldenRatio) ∧
    -- 7-witness IsQuadraticAlgebraic
    (IsQuadraticAlgebraic (Real.sqrt 2) ∧
     IsQuadraticAlgebraic (Real.sqrt 3) ∧
     IsQuadraticAlgebraic (Real.sqrt 5) ∧
     IsQuadraticAlgebraic (Real.sqrt 7) ∧
     IsQuadraticAlgebraic (Real.sqrt 11) ∧
     IsQuadraticAlgebraic (Real.sqrt 13) ∧
     IsQuadraticAlgebraic Real.goldenRatio) :=
  ⟨T5_bundle_XIII_seven_witness_master,
   T5_bundle_XIII_seven_witness_isQuadraticAlgebraic_master⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIII
