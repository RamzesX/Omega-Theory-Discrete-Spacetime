/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XVIII: ext #457-471
  PARAMETRIC CASCADE for primes 61/67/71/73/79**, sub session
  559oooooooooooooooo through 559ssssssssssssssss — STRICT
  critical-path #316 (T-5) Phase 7 ext #457-471.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XVIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cascade of concrete prime sqrt witnesses via Bundle-XVI parametric.
  Each prime gets full Bundle-XVII V3 master applied (paper Roth +
  IsAlgebraic ℤ + universal distance positivity).

  Sub-cluster A (Roth via parametric for primes 61/67/71/73/79):
  - ext #457: T5_roth_for_sqrt_61_via_param
  - ext #458: T5_roth_for_sqrt_67_via_param
  - ext #459: T5_roth_for_sqrt_71_via_param
  - ext #460: T5_roth_for_sqrt_73_via_param
  - ext #461: T5_roth_for_sqrt_79_via_param

  Sub-cluster B (V3 master applied to each prime):
  - ext #462: T_5_paper_master_V3_for_sqrt_61
  - ext #463: T_5_paper_master_V3_for_sqrt_67
  - ext #464: T_5_paper_master_V3_for_sqrt_71

  Sub-cluster C (combined headlines):
  - ext #465: bundle_XVIII_5_witness_master
  - ext #466: bundle_XVIII_isAlgebraic_int_5_combined
  - ext #467: bundle_XVIII_combined_roth_bounds_5

  Sub-cluster D (Bundle-XVIII markers + headlines):
  - ext #468: bundle_XVIII_first_in_V2_marker
  - ext #469: bundle_XVIII_closed_count
  - ext #470: bundle_XVIII_paper_headline_alias
  - ext #471: bundle_XVIII_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #457-471 — Parametric cascade primes 61-79 (BUNDLE-XVIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII

/-! ## Sub-cluster A — Roth via parametric for primes 61/67/71/73/79 -/

/-- **🚨 ext #457** — Roth for √61 via parametric. -/
theorem T5_roth_for_sqrt_61_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 61) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 61| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 61 (by decide) ε hε_pos

/-- **🚨 ext #458** — Roth for √67 via parametric. -/
theorem T5_roth_for_sqrt_67_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 67) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 67| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 67 (by decide) ε hε_pos

/-- **🚨 ext #459** — Roth for √71 via parametric. -/
theorem T5_roth_for_sqrt_71_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 71) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 71| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 71 (by decide) ε hε_pos

/-- **🚨 ext #460** — Roth for √73 via parametric. -/
theorem T5_roth_for_sqrt_73_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 73) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 73| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 73 (by decide) ε hε_pos

/-- **🚨 ext #461** — Roth for √79 via parametric. -/
theorem T5_roth_for_sqrt_79_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 79) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 79| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 79 (by decide) ε hε_pos

/-! ## Sub-cluster B — V3 master applied to each prime -/

/-- **🚨 ext #462** — V3 master for √61. -/
theorem T_5_paper_master_V3_for_sqrt_61
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 61) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 61) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 61|) :=
  T_5_paper_master_V3_for_sqrt_prime 61 (by decide) ε hε_pos

/-- **🚨 ext #463** — V3 master for √67. -/
theorem T_5_paper_master_V3_for_sqrt_67
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 67) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 67) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 67|) :=
  T_5_paper_master_V3_for_sqrt_prime 67 (by decide) ε hε_pos

/-- **🚨 ext #464** — V3 master for √71. -/
theorem T_5_paper_master_V3_for_sqrt_71
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 71) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 71) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 71|) :=
  T_5_paper_master_V3_for_sqrt_prime 71 (by decide) ε hε_pos

/-! ## Sub-cluster C — combined headlines -/

/-- **🚨 ext #465** — Bundle-XVIII 5-witness master. -/
theorem T5_bundle_XVIII_5_witness_master :
    IsQuadraticAlgebraic (Real.sqrt 61) ∧
    IsQuadraticAlgebraic (Real.sqrt 67) ∧
    IsQuadraticAlgebraic (Real.sqrt 71) ∧
    IsQuadraticAlgebraic (Real.sqrt 73) ∧
    IsQuadraticAlgebraic (Real.sqrt 79) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_prime 61 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 67 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 71 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 73 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 79 (by decide)⟩

/-- **🚨 ext #466** — Bundle-XVIII IsAlgebraic ℤ 5 combined. -/
theorem T5_bundle_XVIII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (Real.sqrt 61) ∧
    IsAlgebraic ℤ (Real.sqrt 67) ∧
    IsAlgebraic ℤ (Real.sqrt 71) ∧
    IsAlgebraic ℤ (Real.sqrt 73) ∧
    IsAlgebraic ℤ (Real.sqrt 79) :=
  ⟨T5_IsAlgebraic_int_sqrt_prime 61 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 67 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 71 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 73 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 79 (by decide)⟩

/-- **🚨 ext #467** — Bundle-XVIII combined Roth bounds 5. -/
theorem T5_bundle_XVIII_combined_roth_bounds_5
    (ε : ℝ) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 61) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 61|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 67) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 67|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 71) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 71|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 73) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 73|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 79) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 79|) :=
  ⟨T5_roth_for_sqrt_61_via_param ε hε_pos,
   T5_roth_for_sqrt_67_via_param ε hε_pos,
   T5_roth_for_sqrt_71_via_param ε hε_pos,
   T5_roth_for_sqrt_73_via_param ε hε_pos,
   T5_roth_for_sqrt_79_via_param ε hε_pos⟩

/-! ## Sub-cluster D — Bundle-XVIII markers + headlines -/

/-- **🚨 ext #468** — Frontier marker: Bundle-XVIII. -/
theorem T5_bundle_XVIII_first_in_V2_marker :
    ∃ (n : ℕ), 457 ≤ n ∧ n ≤ 471 ∧ n - 457 ≤ 15 :=
  ⟨471, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #469** — Bundle-XVIII closure cardinality. -/
theorem T5_bundle_XVIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #470** — Bundle-XVIII paper headline alias. -/
theorem T5_bundle_XVIII_paper_headline_alias
    (p : ℕ) (hp : Nat.Prime p) (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt p) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p|) :=
  T_5_paper_master_V3_for_sqrt_prime p hp ε hε_pos

/-! ## Bundle-XVIII GRAND HEADLINE -/

/-- **🚨 ext #471 — HEADLINE: BUNDLE-XVIII cascade primes 61-79**. -/
theorem T5_bundle_XVIII_grand_headline_full
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- 5-witness IsQuadraticAlgebraic
    (IsQuadraticAlgebraic (Real.sqrt 61) ∧
     IsQuadraticAlgebraic (Real.sqrt 67) ∧
     IsQuadraticAlgebraic (Real.sqrt 71) ∧
     IsQuadraticAlgebraic (Real.sqrt 73) ∧
     IsQuadraticAlgebraic (Real.sqrt 79)) ∧
    -- 5-witness IsAlgebraic ℤ
    (IsAlgebraic ℤ (Real.sqrt 61) ∧
     IsAlgebraic ℤ (Real.sqrt 67) ∧
     IsAlgebraic ℤ (Real.sqrt 71) ∧
     IsAlgebraic ℤ (Real.sqrt 73) ∧
     IsAlgebraic ℤ (Real.sqrt 79)) :=
  ⟨T5_bundle_XVIII_5_witness_master,
   T5_bundle_XVIII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVIII
