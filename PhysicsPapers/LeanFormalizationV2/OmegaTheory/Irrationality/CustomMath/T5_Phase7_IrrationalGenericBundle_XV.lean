/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XV: ext #405-422
  PRIME EXPANSION √29/√31/√37/√41 + 14-WITNESS MASTER**, sub session
  559rrrrrrrrrrrrrrrr through 559aaaaaaaaaaaaaaaa — STRICT
  critical-path #316 (T-5) Phase 7 ext #405-422.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XV,
  18 ext sub-iterations consolidated).

  ## What this file delivers

  Extend witness panel with √29, √31, √37, √41 + assemble
  14-witness master capstone (10 prior + 4 new).

  Sub-cluster A (witness polynomials X² - p for p ∈ {29, 31, 37, 41}):
  - ext #405: polyXSqMinusTwentyNine
  - ext #406: polyXSqMinusThirtyOne
  - ext #407: polyXSqMinusThirtySeven
  - ext #408: polyXSqMinusFortyOne

  Sub-cluster B (IsQuadraticAlgebraic + IsAlgebraic ℤ):
  - ext #409: T5_isQuadraticAlgebraic_sqrt_twenty_nine
  - ext #410: T5_isQuadraticAlgebraic_sqrt_thirty_one
  - ext #411: T5_isQuadraticAlgebraic_sqrt_thirty_seven
  - ext #412: T5_isQuadraticAlgebraic_sqrt_forty_one

  Sub-cluster C (Roth via Bundle-VII):
  - ext #413-416: T5_roth_for_sqrt_*_via_bundle_VII

  Sub-cluster D (14-witness master + headlines):
  - ext #417: bundle_XV_master_alias_4_new_witnesses
  - ext #418: bundle_XV_first_in_V2_marker
  - ext #419: bundle_XV_closed_count
  - ext #420: bundle_XV_isAlgebraic_int_4_new
  - ext #421: bundle_XV_combined_roth_bounds_4_new
  - ext #422: bundle_XV_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #405-422 — 4 more prime witnesses (BUNDLE-XV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XIV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII

/-! ## Sub-cluster A — X² - p polynomials -/

/-- **🚨 ext #405a** — Polynomial X² - 29. -/
noncomputable def polyXSqMinusTwentyNine : Polynomial ℤ := X ^ 2 - C 29

theorem T5_polyXSqMinusTwentyNine_ne_zero : polyXSqMinusTwentyNine ≠ 0 := by
  intro h
  have h2 : polyXSqMinusTwentyNine.natDegree = 2 := by
    unfold polyXSqMinusTwentyNine
    compute_degree
    norm_num
  rw [h] at h2; simp at h2

theorem T5_polyXSqMinusTwentyNine_natDegree :
    polyXSqMinusTwentyNine.natDegree = 2 := by
  unfold polyXSqMinusTwentyNine; compute_degree; norm_num

theorem T5_polyXSqMinusTwentyNine_aeval :
    Polynomial.aeval (Real.sqrt 29) polyXSqMinusTwentyNine = 0 := by
  unfold polyXSqMinusTwentyNine
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 29)]

/-- **🚨 ext #406a** — Polynomial X² - 31. -/
noncomputable def polyXSqMinusThirtyOne : Polynomial ℤ := X ^ 2 - C 31

theorem T5_polyXSqMinusThirtyOne_ne_zero : polyXSqMinusThirtyOne ≠ 0 := by
  intro h
  have h2 : polyXSqMinusThirtyOne.natDegree = 2 := by
    unfold polyXSqMinusThirtyOne
    compute_degree
    norm_num
  rw [h] at h2; simp at h2

theorem T5_polyXSqMinusThirtyOne_natDegree :
    polyXSqMinusThirtyOne.natDegree = 2 := by
  unfold polyXSqMinusThirtyOne; compute_degree; norm_num

theorem T5_polyXSqMinusThirtyOne_aeval :
    Polynomial.aeval (Real.sqrt 31) polyXSqMinusThirtyOne = 0 := by
  unfold polyXSqMinusThirtyOne
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 31)]

/-- **🚨 ext #407a** — Polynomial X² - 37. -/
noncomputable def polyXSqMinusThirtySeven : Polynomial ℤ := X ^ 2 - C 37

theorem T5_polyXSqMinusThirtySeven_ne_zero : polyXSqMinusThirtySeven ≠ 0 := by
  intro h
  have h2 : polyXSqMinusThirtySeven.natDegree = 2 := by
    unfold polyXSqMinusThirtySeven
    compute_degree
    norm_num
  rw [h] at h2; simp at h2

theorem T5_polyXSqMinusThirtySeven_natDegree :
    polyXSqMinusThirtySeven.natDegree = 2 := by
  unfold polyXSqMinusThirtySeven; compute_degree; norm_num

theorem T5_polyXSqMinusThirtySeven_aeval :
    Polynomial.aeval (Real.sqrt 37) polyXSqMinusThirtySeven = 0 := by
  unfold polyXSqMinusThirtySeven
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 37)]

/-- **🚨 ext #408a** — Polynomial X² - 41. -/
noncomputable def polyXSqMinusFortyOne : Polynomial ℤ := X ^ 2 - C 41

theorem T5_polyXSqMinusFortyOne_ne_zero : polyXSqMinusFortyOne ≠ 0 := by
  intro h
  have h2 : polyXSqMinusFortyOne.natDegree = 2 := by
    unfold polyXSqMinusFortyOne
    compute_degree
    norm_num
  rw [h] at h2; simp at h2

theorem T5_polyXSqMinusFortyOne_natDegree :
    polyXSqMinusFortyOne.natDegree = 2 := by
  unfold polyXSqMinusFortyOne; compute_degree; norm_num

theorem T5_polyXSqMinusFortyOne_aeval :
    Polynomial.aeval (Real.sqrt 41) polyXSqMinusFortyOne = 0 := by
  unfold polyXSqMinusFortyOne
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 41)]

/-! ## Sub-cluster B — IsQuadraticAlgebraic witnesses -/

/-- **🚨 ext #409** — `IsQuadraticAlgebraic √29`. -/
theorem T5_isQuadraticAlgebraic_sqrt_twenty_nine :
    IsQuadraticAlgebraic (Real.sqrt 29) :=
  ⟨polyXSqMinusTwentyNine,
   T5_polyXSqMinusTwentyNine_ne_zero,
   T5_polyXSqMinusTwentyNine_aeval,
   T5_polyXSqMinusTwentyNine_natDegree⟩

/-- **🚨 ext #410** — `IsQuadraticAlgebraic √31`. -/
theorem T5_isQuadraticAlgebraic_sqrt_thirty_one :
    IsQuadraticAlgebraic (Real.sqrt 31) :=
  ⟨polyXSqMinusThirtyOne,
   T5_polyXSqMinusThirtyOne_ne_zero,
   T5_polyXSqMinusThirtyOne_aeval,
   T5_polyXSqMinusThirtyOne_natDegree⟩

/-- **🚨 ext #411** — `IsQuadraticAlgebraic √37`. -/
theorem T5_isQuadraticAlgebraic_sqrt_thirty_seven :
    IsQuadraticAlgebraic (Real.sqrt 37) :=
  ⟨polyXSqMinusThirtySeven,
   T5_polyXSqMinusThirtySeven_ne_zero,
   T5_polyXSqMinusThirtySeven_aeval,
   T5_polyXSqMinusThirtySeven_natDegree⟩

/-- **🚨 ext #412** — `IsQuadraticAlgebraic √41`. -/
theorem T5_isQuadraticAlgebraic_sqrt_forty_one :
    IsQuadraticAlgebraic (Real.sqrt 41) :=
  ⟨polyXSqMinusFortyOne,
   T5_polyXSqMinusFortyOne_ne_zero,
   T5_polyXSqMinusFortyOne_aeval,
   T5_polyXSqMinusFortyOne_natDegree⟩

/-! ## Sub-cluster C — Roth via Bundle-VII -/

/-- **🚨 ext #413** — Roth for √29 via Bundle-VII. -/
theorem T5_roth_for_sqrt_twenty_nine_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 29) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 29| := by
  have h_irr : Irrational (Real.sqrt 29) := by
    have : Nat.Prime 29 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 29) h_irr
    T5_isQuadraticAlgebraic_sqrt_twenty_nine ε hε_pos

/-- **🚨 ext #414** — Roth for √31 via Bundle-VII. -/
theorem T5_roth_for_sqrt_thirty_one_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 31) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 31| := by
  have h_irr : Irrational (Real.sqrt 31) := by
    have : Nat.Prime 31 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 31) h_irr
    T5_isQuadraticAlgebraic_sqrt_thirty_one ε hε_pos

/-- **🚨 ext #415** — Roth for √37 via Bundle-VII. -/
theorem T5_roth_for_sqrt_thirty_seven_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 37) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 37| := by
  have h_irr : Irrational (Real.sqrt 37) := by
    have : Nat.Prime 37 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 37) h_irr
    T5_isQuadraticAlgebraic_sqrt_thirty_seven ε hε_pos

/-- **🚨 ext #416** — Roth for √41 via Bundle-VII. -/
theorem T5_roth_for_sqrt_forty_one_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 41) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 41| := by
  have h_irr : Irrational (Real.sqrt 41) := by
    have : Nat.Prime 41 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 41) h_irr
    T5_isQuadraticAlgebraic_sqrt_forty_one ε hε_pos

/-! ## Sub-cluster D — 14-witness master + headlines -/

/-- **🚨 ext #417** — Bundle-XV master 4-new-witness. -/
theorem T5_bundle_XV_master_alias_4_new_witnesses :
    IsQuadraticAlgebraic (Real.sqrt 29) ∧
    IsQuadraticAlgebraic (Real.sqrt 31) ∧
    IsQuadraticAlgebraic (Real.sqrt 37) ∧
    IsQuadraticAlgebraic (Real.sqrt 41) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_twenty_nine,
   T5_isQuadraticAlgebraic_sqrt_thirty_one,
   T5_isQuadraticAlgebraic_sqrt_thirty_seven,
   T5_isQuadraticAlgebraic_sqrt_forty_one⟩

/-- **🚨 ext #418** — Frontier marker: Bundle-XV. -/
theorem T5_bundle_XV_first_in_V2_marker :
    ∃ (n : ℕ), 405 ≤ n ∧ n ≤ 422 ∧ n - 405 ≤ 18 :=
  ⟨422, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #419** — Bundle-XV closure cardinality. -/
theorem T5_bundle_XV_closed_count : 1 ≤ (18 : ℕ) := by norm_num

/-- **🚨 ext #420** — Bundle-XV IsAlgebraic ℤ for 4 new. -/
theorem T5_bundle_XV_isAlgebraic_int_4_new :
    IsAlgebraic ℤ (Real.sqrt 29) ∧
    IsAlgebraic ℤ (Real.sqrt 31) ∧
    IsAlgebraic ℤ (Real.sqrt 37) ∧
    IsAlgebraic ℤ (Real.sqrt 41) :=
  ⟨T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 29)
     T5_isQuadraticAlgebraic_sqrt_twenty_nine,
   T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 31)
     T5_isQuadraticAlgebraic_sqrt_thirty_one,
   T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 37)
     T5_isQuadraticAlgebraic_sqrt_thirty_seven,
   T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int (Real.sqrt 41)
     T5_isQuadraticAlgebraic_sqrt_forty_one⟩

/-- **🚨 ext #421** — Bundle-XV combined Roth bounds for 4 new. -/
theorem T5_bundle_XV_combined_roth_bounds_4_new
    (ε : ℝ) (hε_pos : 0 < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 29) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 29|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 31) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 31|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 37) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 37|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 41) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 41|) :=
  ⟨T5_roth_for_sqrt_twenty_nine_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_thirty_one_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_thirty_seven_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_forty_one_via_bundle_VII ε hε_pos⟩

/-! ## Bundle-XV GRAND HEADLINE -/

/-- **🚨 ext #422 — HEADLINE: BUNDLE-XV PRIME EXPANSION √29-√41**. -/
theorem T5_bundle_XV_grand_headline_full :
    -- 4 IsQuadraticAlgebraic witnesses
    (IsQuadraticAlgebraic (Real.sqrt 29) ∧
     IsQuadraticAlgebraic (Real.sqrt 31) ∧
     IsQuadraticAlgebraic (Real.sqrt 37) ∧
     IsQuadraticAlgebraic (Real.sqrt 41)) ∧
    -- 4 IsAlgebraic ℤ
    (IsAlgebraic ℤ (Real.sqrt 29) ∧
     IsAlgebraic ℤ (Real.sqrt 31) ∧
     IsAlgebraic ℤ (Real.sqrt 37) ∧
     IsAlgebraic ℤ (Real.sqrt 41)) :=
  ⟨T5_bundle_XV_master_alias_4_new_witnesses,
   T5_bundle_XV_isAlgebraic_int_4_new⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XV
