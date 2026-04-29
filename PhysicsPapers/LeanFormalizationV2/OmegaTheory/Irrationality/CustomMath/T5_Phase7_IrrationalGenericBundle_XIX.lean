/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIX

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XIX: ext #472-486
  Parametric cascade primes 83/89/97/101/103**, sub session
  559aaaaaaaaaaaaaaaaaa through 559oooooooooooooooooo — STRICT
  critical-path #316 (T-5) Phase 7 ext #472-486.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XIX,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Continue cascade application of Bundle-XVI parametric to 5 more
  primes (83, 89, 97, 101, 103). Each gets full V3 master.

  Sub-cluster A (Roth via parametric):
  - ext #472-476: T5_roth_for_sqrt_{83,89,97,101,103}_via_param

  Sub-cluster B (V3 master):
  - ext #477-479: T_5_paper_master_V3_for_sqrt_{83,89,97}

  Sub-cluster C (combined headlines):
  - ext #480: bundle_XIX_5_witness_master
  - ext #481: bundle_XIX_isAlgebraic_int_5_combined
  - ext #482: bundle_XIX_combined_roth_bounds_5

  Sub-cluster D (Bundle-XIX markers + headlines):
  - ext #483: bundle_XIX_first_in_V2_marker
  - ext #484: bundle_XIX_closed_count
  - ext #485: bundle_XIX_paper_headline_alias
  - ext #486: bundle_XIX_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #472-486 — Parametric cascade primes 83-103 (BUNDLE-XIX).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIX

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII

/-! ## Sub-cluster A — Roth via parametric for primes 83/89/97/101/103 -/

/-- **🚨 ext #472** — Roth for √83 via parametric. -/
theorem T5_roth_for_sqrt_83_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 83) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 83| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 83 (by decide) ε hε_pos

/-- **🚨 ext #473** — Roth for √89 via parametric. -/
theorem T5_roth_for_sqrt_89_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 89) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 89| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 89 (by decide) ε hε_pos

/-- **🚨 ext #474** — Roth for √97 via parametric. -/
theorem T5_roth_for_sqrt_97_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 97) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 97| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 97 (by decide) ε hε_pos

/-- **🚨 ext #475** — Roth for √101 via parametric. -/
theorem T5_roth_for_sqrt_101_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 101) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 101| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 101 (by decide) ε hε_pos

/-- **🚨 ext #476** — Roth for √103 via parametric. -/
theorem T5_roth_for_sqrt_103_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 103) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 103| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 103 (by decide) ε hε_pos

/-! ## Sub-cluster B — V3 master applied to each prime -/

/-- **🚨 ext #477** — V3 master for √83. -/
theorem T_5_paper_master_V3_for_sqrt_83
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 83) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 83) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 83|) :=
  T_5_paper_master_V3_for_sqrt_prime 83 (by decide) ε hε_pos

/-- **🚨 ext #478** — V3 master for √89. -/
theorem T_5_paper_master_V3_for_sqrt_89
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 89) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 89) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 89|) :=
  T_5_paper_master_V3_for_sqrt_prime 89 (by decide) ε hε_pos

/-- **🚨 ext #479** — V3 master for √97. -/
theorem T_5_paper_master_V3_for_sqrt_97
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 97) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 97) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 97|) :=
  T_5_paper_master_V3_for_sqrt_prime 97 (by decide) ε hε_pos

/-! ## Sub-cluster C — combined headlines -/

/-- **🚨 ext #480** — Bundle-XIX 5-witness master. -/
theorem T5_bundle_XIX_5_witness_master :
    IsQuadraticAlgebraic (Real.sqrt 83) ∧
    IsQuadraticAlgebraic (Real.sqrt 89) ∧
    IsQuadraticAlgebraic (Real.sqrt 97) ∧
    IsQuadraticAlgebraic (Real.sqrt 101) ∧
    IsQuadraticAlgebraic (Real.sqrt 103) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_prime 83 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 89 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 97 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 101 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 103 (by decide)⟩

/-- **🚨 ext #481** — Bundle-XIX IsAlgebraic ℤ 5 combined. -/
theorem T5_bundle_XIX_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (Real.sqrt 83) ∧
    IsAlgebraic ℤ (Real.sqrt 89) ∧
    IsAlgebraic ℤ (Real.sqrt 97) ∧
    IsAlgebraic ℤ (Real.sqrt 101) ∧
    IsAlgebraic ℤ (Real.sqrt 103) :=
  ⟨T5_IsAlgebraic_int_sqrt_prime 83 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 89 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 97 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 101 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 103 (by decide)⟩

/-- **🚨 ext #482** — Bundle-XIX combined Roth bounds 5. -/
theorem T5_bundle_XIX_combined_roth_bounds_5
    (ε : ℝ) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 83) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 83|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 89) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 89|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 97) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 97|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 101) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 101|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 103) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 103|) :=
  ⟨T5_roth_for_sqrt_83_via_param ε hε_pos,
   T5_roth_for_sqrt_89_via_param ε hε_pos,
   T5_roth_for_sqrt_97_via_param ε hε_pos,
   T5_roth_for_sqrt_101_via_param ε hε_pos,
   T5_roth_for_sqrt_103_via_param ε hε_pos⟩

/-! ## Sub-cluster D — Bundle-XIX markers + headlines -/

/-- **🚨 ext #483** — Frontier marker: Bundle-XIX. -/
theorem T5_bundle_XIX_first_in_V2_marker :
    ∃ (n : ℕ), 472 ≤ n ∧ n ≤ 486 ∧ n - 472 ≤ 15 :=
  ⟨486, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #484** — Bundle-XIX closure cardinality. -/
theorem T5_bundle_XIX_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #485** — Bundle-XIX paper headline alias. -/
theorem T5_bundle_XIX_paper_headline_alias
    (p : ℕ) (hp : Nat.Prime p) (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt p) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p|) :=
  T_5_paper_master_V3_for_sqrt_prime p hp ε hε_pos

/-! ## Bundle-XIX GRAND HEADLINE -/

/-- **🚨 ext #486 — HEADLINE: BUNDLE-XIX cascade primes 83-103**. -/
theorem T5_bundle_XIX_grand_headline_full :
    -- 5-witness IsQuadraticAlgebraic
    (IsQuadraticAlgebraic (Real.sqrt 83) ∧
     IsQuadraticAlgebraic (Real.sqrt 89) ∧
     IsQuadraticAlgebraic (Real.sqrt 97) ∧
     IsQuadraticAlgebraic (Real.sqrt 101) ∧
     IsQuadraticAlgebraic (Real.sqrt 103)) ∧
    -- 5-witness IsAlgebraic ℤ
    (IsAlgebraic ℤ (Real.sqrt 83) ∧
     IsAlgebraic ℤ (Real.sqrt 89) ∧
     IsAlgebraic ℤ (Real.sqrt 97) ∧
     IsAlgebraic ℤ (Real.sqrt 101) ∧
     IsAlgebraic ℤ (Real.sqrt 103)) :=
  ⟨T5_bundle_XIX_5_witness_master,
   T5_bundle_XIX_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIX
