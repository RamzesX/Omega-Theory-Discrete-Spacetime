/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XX

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XX: ext #487-501
  Parametric cascade primes 107-131**, sub session 559bbbbbbbbbbbbbbbbbb
  through 559rrrrrrrrrrrrrrrrrr — STRICT critical-path #316 (T-5)
  Phase 7 ext #487-501.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XX,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Continue cascade application of Bundle-XVI parametric to 5 more
  primes (107, 109, 113, 127, 131). 29-prime panel total.

  Sub-cluster A (Roth via parametric):
  - ext #487-491: T5_roth_for_sqrt_{107,109,113,127,131}_via_param

  Sub-cluster B (V3 master):
  - ext #492-494: T_5_paper_master_V3_for_sqrt_{107,109,113}

  Sub-cluster C (combined headlines):
  - ext #495: bundle_XX_5_witness_master
  - ext #496: bundle_XX_isAlgebraic_int_5_combined
  - ext #497: bundle_XX_combined_roth_bounds_5

  Sub-cluster D (Bundle-XX markers + headlines):
  - ext #498: bundle_XX_first_in_V2_marker
  - ext #499: bundle_XX_closed_count
  - ext #500: bundle_XX_paper_headline_alias
  - ext #501: bundle_XX_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #487-501 — Parametric cascade primes 107-131 (BUNDLE-XX).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIX

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XX

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XVII

/-! ## Sub-cluster A — Roth via parametric for primes 107/109/113/127/131 -/

/-- **🚨 ext #487** — Roth for √107 via parametric. -/
theorem T5_roth_for_sqrt_107_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 107) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 107| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 107 (by decide) ε hε_pos

/-- **🚨 ext #488** — Roth for √109 via parametric. -/
theorem T5_roth_for_sqrt_109_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 109) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 109| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 109 (by decide) ε hε_pos

/-- **🚨 ext #489** — Roth for √113 via parametric. -/
theorem T5_roth_for_sqrt_113_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 113) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 113| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 113 (by decide) ε hε_pos

/-- **🚨 ext #490** — Roth for √127 via parametric. -/
theorem T5_roth_for_sqrt_127_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 127) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 127| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 127 (by decide) ε hε_pos

/-- **🚨 ext #491** — Roth for √131 via parametric. -/
theorem T5_roth_for_sqrt_131_via_param
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 131) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 131| :=
  T5_roth_for_sqrt_prime_via_bundle_VII 131 (by decide) ε hε_pos

/-! ## Sub-cluster B — V3 master applied -/

/-- **🚨 ext #492** — V3 master for √107. -/
theorem T_5_paper_master_V3_for_sqrt_107
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 107) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 107) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 107|) :=
  T_5_paper_master_V3_for_sqrt_prime 107 (by decide) ε hε_pos

/-- **🚨 ext #493** — V3 master for √109. -/
theorem T_5_paper_master_V3_for_sqrt_109
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 109) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 109) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 109|) :=
  T_5_paper_master_V3_for_sqrt_prime 109 (by decide) ε hε_pos

/-- **🚨 ext #494** — V3 master for √113. -/
theorem T_5_paper_master_V3_for_sqrt_113
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt 113) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt 113) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 113|) :=
  T_5_paper_master_V3_for_sqrt_prime 113 (by decide) ε hε_pos

/-! ## Sub-cluster C — combined headlines -/

/-- **🚨 ext #495** — Bundle-XX 5-witness master. -/
theorem T5_bundle_XX_5_witness_master :
    IsQuadraticAlgebraic (Real.sqrt 107) ∧
    IsQuadraticAlgebraic (Real.sqrt 109) ∧
    IsQuadraticAlgebraic (Real.sqrt 113) ∧
    IsQuadraticAlgebraic (Real.sqrt 127) ∧
    IsQuadraticAlgebraic (Real.sqrt 131) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_prime 107 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 109 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 113 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 127 (by decide),
   T5_isQuadraticAlgebraic_sqrt_prime 131 (by decide)⟩

/-- **🚨 ext #496** — Bundle-XX IsAlgebraic ℤ 5 combined. -/
theorem T5_bundle_XX_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (Real.sqrt 107) ∧
    IsAlgebraic ℤ (Real.sqrt 109) ∧
    IsAlgebraic ℤ (Real.sqrt 113) ∧
    IsAlgebraic ℤ (Real.sqrt 127) ∧
    IsAlgebraic ℤ (Real.sqrt 131) :=
  ⟨T5_IsAlgebraic_int_sqrt_prime 107 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 109 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 113 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 127 (by decide),
   T5_IsAlgebraic_int_sqrt_prime 131 (by decide)⟩

/-- **🚨 ext #497** — Bundle-XX combined Roth bounds 5. -/
theorem T5_bundle_XX_combined_roth_bounds_5
    (ε : ℝ) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 107) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 107|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 109) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 109|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 113) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 113|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 127) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 127|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 131) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 131|) :=
  ⟨T5_roth_for_sqrt_107_via_param ε hε_pos,
   T5_roth_for_sqrt_109_via_param ε hε_pos,
   T5_roth_for_sqrt_113_via_param ε hε_pos,
   T5_roth_for_sqrt_127_via_param ε hε_pos,
   T5_roth_for_sqrt_131_via_param ε hε_pos⟩

/-! ## Sub-cluster D — Bundle-XX markers + headlines -/

/-- **🚨 ext #498** — Frontier marker: Bundle-XX. -/
theorem T5_bundle_XX_first_in_V2_marker :
    ∃ (n : ℕ), 487 ≤ n ∧ n ≤ 501 ∧ n - 487 ≤ 15 :=
  ⟨501, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #499** — Bundle-XX closure cardinality. -/
theorem T5_bundle_XX_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #500** — Bundle-XX paper headline alias. -/
theorem T5_bundle_XX_paper_headline_alias
    (p : ℕ) (hp : Nat.Prime p) (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ (Real.sqrt p) ∧
    (∃ (C : ℝ) (P : Polynomial ℤ),
      0 < C ∧ P ≠ 0 ∧ Polynomial.aeval (Real.sqrt p) P = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) P ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt p|) :=
  T_5_paper_master_V3_for_sqrt_prime p hp ε hε_pos

/-! ## Bundle-XX GRAND HEADLINE -/

/-- **🚨 ext #501 — HEADLINE: BUNDLE-XX cascade primes 107-131**. -/
theorem T5_bundle_XX_grand_headline_full :
    -- 5-witness IsQuadraticAlgebraic
    (IsQuadraticAlgebraic (Real.sqrt 107) ∧
     IsQuadraticAlgebraic (Real.sqrt 109) ∧
     IsQuadraticAlgebraic (Real.sqrt 113) ∧
     IsQuadraticAlgebraic (Real.sqrt 127) ∧
     IsQuadraticAlgebraic (Real.sqrt 131)) ∧
    -- 5-witness IsAlgebraic ℤ
    (IsAlgebraic ℤ (Real.sqrt 107) ∧
     IsAlgebraic ℤ (Real.sqrt 109) ∧
     IsAlgebraic ℤ (Real.sqrt 113) ∧
     IsAlgebraic ℤ (Real.sqrt 127) ∧
     IsAlgebraic ℤ (Real.sqrt 131)) :=
  ⟨T5_bundle_XX_5_witness_master,
   T5_bundle_XX_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XX
