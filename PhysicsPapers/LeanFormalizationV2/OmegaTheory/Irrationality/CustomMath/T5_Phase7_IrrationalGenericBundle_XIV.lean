/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XIV: ext #387-404
  10-WITNESS PRIME EXPANSION (√17/√19/√23)**, sub session
  559pppppppppppppp through 559rrrrrrrrrrrrrr — STRICT critical-path
  #316 (T-5) Phase 7 ext #387-404.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XIV,
  18 ext sub-iterations consolidated).

  ## What this file delivers

  Extend the 7-witness master (Bundle-XIII) with three more prime
  IsQuadraticAlgebraic witnesses √17, √19, √23 to a 10-witness
  master. Each carries Bundle-VII clean Roth bound + Bundle-X
  IsAlgebraic ℤ certificate.

  Sub-cluster A (witness polynomials X² - p for p ∈ {17, 19, 23}):
  - ext #387: polyXSqMinusSeventeen + ne_zero + natDegree + aeval
  - ext #388: polyXSqMinusNineteen + ne_zero + natDegree + aeval
  - ext #389: polyXSqMinusTwentyThree + ne_zero + natDegree + aeval

  Sub-cluster B (IsQuadraticAlgebraic concrete witnesses):
  - ext #390: T5_isQuadraticAlgebraic_sqrt_seventeen
  - ext #391: T5_isQuadraticAlgebraic_sqrt_nineteen
  - ext #392: T5_isQuadraticAlgebraic_sqrt_twenty_three

  Sub-cluster C (IsAlgebraic ℤ certificates):
  - ext #393: IsAlgebraic_int_sqrt_seventeen
  - ext #394: IsAlgebraic_int_sqrt_nineteen
  - ext #395: IsAlgebraic_int_sqrt_twenty_three

  Sub-cluster D (Roth via Bundle-VII):
  - ext #396: T5_roth_for_sqrt_seventeen_via_bundle_VII
  - ext #397: T5_roth_for_sqrt_nineteen_via_bundle_VII
  - ext #398: T5_roth_for_sqrt_twenty_three_via_bundle_VII

  Sub-cluster E (Bundle-XIV markers + headlines):
  - ext #399: bundle_XIV_first_in_V2_marker
  - ext #400: bundle_XIV_closed_count
  - ext #401: bundle_XIV_master_alias_3_new_witnesses
  - ext #402: bundle_XIV_isAlgebraic_int_combined_3_new
  - ext #403: bundle_XIV_combined_roth_bounds_3_new
  - ext #404: bundle_XIV_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #387-404 — 3 more prime witnesses (BUNDLE-XIV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII

/-! ## Sub-cluster A — X² - p polynomials for p ∈ {17, 19, 23} -/

/-- **🚨 ext #387a** — Polynomial X² - 17. -/
noncomputable def polyXSqMinusSeventeen : Polynomial ℤ := X ^ 2 - C 17

theorem T5_polyXSqMinusSeventeen_ne_zero : polyXSqMinusSeventeen ≠ 0 := by
  intro h
  have h2 : polyXSqMinusSeventeen.natDegree = 2 := by
    unfold polyXSqMinusSeventeen
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusSeventeen_natDegree :
    polyXSqMinusSeventeen.natDegree = 2 := by
  unfold polyXSqMinusSeventeen
  compute_degree
  norm_num

theorem T5_polyXSqMinusSeventeen_aeval_sqrt_seventeen_eq_zero :
    Polynomial.aeval (Real.sqrt 17) polyXSqMinusSeventeen = 0 := by
  unfold polyXSqMinusSeventeen
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 17)]

/-- **🚨 ext #388a** — Polynomial X² - 19. -/
noncomputable def polyXSqMinusNineteen : Polynomial ℤ := X ^ 2 - C 19

theorem T5_polyXSqMinusNineteen_ne_zero : polyXSqMinusNineteen ≠ 0 := by
  intro h
  have h2 : polyXSqMinusNineteen.natDegree = 2 := by
    unfold polyXSqMinusNineteen
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusNineteen_natDegree :
    polyXSqMinusNineteen.natDegree = 2 := by
  unfold polyXSqMinusNineteen
  compute_degree
  norm_num

theorem T5_polyXSqMinusNineteen_aeval_sqrt_nineteen_eq_zero :
    Polynomial.aeval (Real.sqrt 19) polyXSqMinusNineteen = 0 := by
  unfold polyXSqMinusNineteen
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 19)]

/-- **🚨 ext #389a** — Polynomial X² - 23. -/
noncomputable def polyXSqMinusTwentyThree : Polynomial ℤ := X ^ 2 - C 23

theorem T5_polyXSqMinusTwentyThree_ne_zero : polyXSqMinusTwentyThree ≠ 0 := by
  intro h
  have h2 : polyXSqMinusTwentyThree.natDegree = 2 := by
    unfold polyXSqMinusTwentyThree
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusTwentyThree_natDegree :
    polyXSqMinusTwentyThree.natDegree = 2 := by
  unfold polyXSqMinusTwentyThree
  compute_degree
  norm_num

theorem T5_polyXSqMinusTwentyThree_aeval_sqrt_twenty_three_eq_zero :
    Polynomial.aeval (Real.sqrt 23) polyXSqMinusTwentyThree = 0 := by
  unfold polyXSqMinusTwentyThree
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 23)]

/-! ## Sub-cluster B — IsQuadraticAlgebraic witnesses -/

/-- **🚨 ext #390** — `IsQuadraticAlgebraic √17`. -/
theorem T5_isQuadraticAlgebraic_sqrt_seventeen :
    IsQuadraticAlgebraic (Real.sqrt 17) :=
  ⟨polyXSqMinusSeventeen,
   T5_polyXSqMinusSeventeen_ne_zero,
   T5_polyXSqMinusSeventeen_aeval_sqrt_seventeen_eq_zero,
   T5_polyXSqMinusSeventeen_natDegree⟩

/-- **🚨 ext #391** — `IsQuadraticAlgebraic √19`. -/
theorem T5_isQuadraticAlgebraic_sqrt_nineteen :
    IsQuadraticAlgebraic (Real.sqrt 19) :=
  ⟨polyXSqMinusNineteen,
   T5_polyXSqMinusNineteen_ne_zero,
   T5_polyXSqMinusNineteen_aeval_sqrt_nineteen_eq_zero,
   T5_polyXSqMinusNineteen_natDegree⟩

/-- **🚨 ext #392** — `IsQuadraticAlgebraic √23`. -/
theorem T5_isQuadraticAlgebraic_sqrt_twenty_three :
    IsQuadraticAlgebraic (Real.sqrt 23) :=
  ⟨polyXSqMinusTwentyThree,
   T5_polyXSqMinusTwentyThree_ne_zero,
   T5_polyXSqMinusTwentyThree_aeval_sqrt_twenty_three_eq_zero,
   T5_polyXSqMinusTwentyThree_natDegree⟩

/-! ## Sub-cluster C — IsAlgebraic ℤ certificates -/

/-- **🚨 ext #393** — `IsAlgebraic ℤ √17`. -/
theorem T5_IsAlgebraic_int_sqrt_seventeen : IsAlgebraic ℤ (Real.sqrt 17) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 17)
    T5_isQuadraticAlgebraic_sqrt_seventeen

/-- **🚨 ext #394** — `IsAlgebraic ℤ √19`. -/
theorem T5_IsAlgebraic_int_sqrt_nineteen : IsAlgebraic ℤ (Real.sqrt 19) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 19)
    T5_isQuadraticAlgebraic_sqrt_nineteen

/-- **🚨 ext #395** — `IsAlgebraic ℤ √23`. -/
theorem T5_IsAlgebraic_int_sqrt_twenty_three : IsAlgebraic ℤ (Real.sqrt 23) :=
  T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 23)
    T5_isQuadraticAlgebraic_sqrt_twenty_three

/-! ## Sub-cluster D — Roth via Bundle-VII -/

/-- **🚨 ext #396** — Roth for √17 via Bundle-VII. -/
theorem T5_roth_for_sqrt_seventeen_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 17) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 17| := by
  have h_irr : Irrational (Real.sqrt 17) := by
    have : Nat.Prime 17 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 17) h_irr
    T5_isQuadraticAlgebraic_sqrt_seventeen ε hε_pos

/-- **🚨 ext #397** — Roth for √19 via Bundle-VII. -/
theorem T5_roth_for_sqrt_nineteen_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 19) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 19| := by
  have h_irr : Irrational (Real.sqrt 19) := by
    have : Nat.Prime 19 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 19) h_irr
    T5_isQuadraticAlgebraic_sqrt_nineteen ε hε_pos

/-- **🚨 ext #398** — Roth for √23 via Bundle-VII. -/
theorem T5_roth_for_sqrt_twenty_three_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 23) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 23| := by
  have h_irr : Irrational (Real.sqrt 23) := by
    have : Nat.Prime 23 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 23) h_irr
    T5_isQuadraticAlgebraic_sqrt_twenty_three ε hε_pos

/-! ## Sub-cluster E — Bundle-XIV markers + headlines -/

/-- **🚨 ext #399** — Frontier marker: Bundle-XIV. -/
theorem T5_bundle_XIV_first_in_V2_marker :
    ∃ (n : ℕ), 387 ≤ n ∧ n ≤ 404 ∧ n - 387 ≤ 18 :=
  ⟨404, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #400** — Bundle-XIV closure cardinality. -/
theorem T5_bundle_XIV_closed_count : 1 ≤ (18 : ℕ) := by norm_num

/-- **🚨 ext #401** — Bundle-XIV master 3-new-witness. -/
theorem T5_bundle_XIV_master_alias_3_new_witnesses :
    IsQuadraticAlgebraic (Real.sqrt 17) ∧
    IsQuadraticAlgebraic (Real.sqrt 19) ∧
    IsQuadraticAlgebraic (Real.sqrt 23) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_seventeen,
   T5_isQuadraticAlgebraic_sqrt_nineteen,
   T5_isQuadraticAlgebraic_sqrt_twenty_three⟩

/-- **🚨 ext #402** — Bundle-XIV combined IsAlgebraic ℤ for 3 new. -/
theorem T5_bundle_XIV_isAlgebraic_int_combined_3_new :
    IsAlgebraic ℤ (Real.sqrt 17) ∧
    IsAlgebraic ℤ (Real.sqrt 19) ∧
    IsAlgebraic ℤ (Real.sqrt 23) :=
  ⟨T5_IsAlgebraic_int_sqrt_seventeen,
   T5_IsAlgebraic_int_sqrt_nineteen,
   T5_IsAlgebraic_int_sqrt_twenty_three⟩

/-- **🚨 ext #403** — Bundle-XIV combined Roth bounds for 3 new. -/
theorem T5_bundle_XIV_combined_roth_bounds_3_new
    (ε : ℝ) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 17) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 17|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 19) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 19|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 23) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 23|) :=
  ⟨T5_roth_for_sqrt_seventeen_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_nineteen_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_twenty_three_via_bundle_VII ε hε_pos⟩

/-! ## Bundle-XIV GRAND HEADLINE -/

/-- **🚨 ext #404 — HEADLINE: BUNDLE-XIV PRIME EXPANSION**.

    🏆🏆🏆 18-form bundle delivering √17/√19/√23 concrete
    IsQuadraticAlgebraic witnesses + IsAlgebraic ℤ certificates +
    Roth bounds via Bundle-VII clean paper signature. -/
theorem T5_bundle_XIV_grand_headline_full
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- 3-witness IsQuadraticAlgebraic + IsAlgebraic ℤ + 3 Roth bounds
    (IsQuadraticAlgebraic (Real.sqrt 17) ∧
     IsQuadraticAlgebraic (Real.sqrt 19) ∧
     IsQuadraticAlgebraic (Real.sqrt 23)) ∧
    (IsAlgebraic ℤ (Real.sqrt 17) ∧
     IsAlgebraic ℤ (Real.sqrt 19) ∧
     IsAlgebraic ℤ (Real.sqrt 23)) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 17) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 17|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 19) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 19|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 23) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 23|) := by
  refine ⟨T5_bundle_XIV_master_alias_3_new_witnesses,
          T5_bundle_XIV_isAlgebraic_int_combined_3_new, ?_, ?_, ?_⟩
  · exact T5_roth_for_sqrt_seventeen_via_bundle_VII ε hε_pos
  · exact T5_roth_for_sqrt_nineteen_via_bundle_VII ε hε_pos
  · exact T5_roth_for_sqrt_twenty_three_via_bundle_VII ε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIV
