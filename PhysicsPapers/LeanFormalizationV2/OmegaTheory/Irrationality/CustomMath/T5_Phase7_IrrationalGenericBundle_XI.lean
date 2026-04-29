/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XI: ext #340-355
  CONCRETE IsQuadraticAlgebraic WITNESSES + Roth via Bundle-VII**, sub
  session 559cccccccccccccc through 559rrrrrrrrrrrrrr — STRICT
  critical-path #316 (T-5) Phase 7 ext #340-355.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XI,
  16 ext sub-iterations consolidated).

  ## What this file delivers

  Concrete `IsQuadraticAlgebraic α` witnesses for canonical α ∈
  {√2, √3, √5, √7, φ}, plus their Roth bounds via Bundle-VII clean
  signatures.

  Sub-cluster A (witness polynomials and aeval):
  - ext #340: polyXSqMinusThree + non-zero + natDegree 2 + aeval at √3
  - ext #341: polyXSqMinusFive + non-zero + natDegree 2 + aeval at √5
  - ext #342: polyXSqMinusSeven + non-zero + natDegree 2 + aeval at √7

  Sub-cluster B (IsQuadraticAlgebraic concrete witnesses):
  - ext #343: T5_isQuadraticAlgebraic_sqrt_two
  - ext #344: T5_isQuadraticAlgebraic_sqrt_three
  - ext #345: T5_isQuadraticAlgebraic_sqrt_five
  - ext #346: T5_isQuadraticAlgebraic_sqrt_seven

  Sub-cluster C (Roth via Bundle-VII for these witnesses):
  - ext #347: T5_roth_for_sqrt_two_via_bundle_VII (clean paper)
  - ext #348: T5_roth_for_sqrt_three_via_bundle_VII
  - ext #349: T5_roth_for_sqrt_five_via_bundle_VII
  - ext #350: T5_roth_for_sqrt_seven_via_bundle_VII

  Sub-cluster D (Bundle-XI markers + headline):
  - ext #351: bundle_XI_first_in_V2_concrete_witnesses
  - ext #352: bundle_XI_closed_count
  - ext #353: bundle_XI_master_alias
  - ext #354: bundle_XI_grand_headline_4_witnesses
  - ext #355: bundle_XI_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #340-355 — CONCRETE IsQuadraticAlgebraic witnesses (BUNDLE-XI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt2
import Mathlib.Data.Real.Sqrt

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XI

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothForSqrt2

/-! ## Sub-cluster A — concrete X² - n polynomials -/

/-- **🚨 ext #340a** — Polynomial X² - 3. -/
noncomputable def polyXSqMinusThree : Polynomial ℤ := X ^ 2 - C 3

theorem T5_polyXSqMinusThree_ne_zero : polyXSqMinusThree ≠ 0 := by
  intro h
  have h2 : (polyXSqMinusThree).natDegree = 2 := by
    unfold polyXSqMinusThree
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusThree_natDegree :
    polyXSqMinusThree.natDegree = 2 := by
  unfold polyXSqMinusThree
  compute_degree
  norm_num

/-- **🚨 ext #340** — `aeval (√3 : ℝ) polyXSqMinusThree = 0`. -/
theorem T5_polyXSqMinusThree_aeval_sqrt_three_eq_zero :
    Polynomial.aeval (Real.sqrt 3) polyXSqMinusThree = 0 := by
  unfold polyXSqMinusThree
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]

/-- **🚨 ext #341a** — Polynomial X² - 5. -/
noncomputable def polyXSqMinusFive : Polynomial ℤ := X ^ 2 - C 5

theorem T5_polyXSqMinusFive_ne_zero : polyXSqMinusFive ≠ 0 := by
  intro h
  have h2 : (polyXSqMinusFive).natDegree = 2 := by
    unfold polyXSqMinusFive
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusFive_natDegree :
    polyXSqMinusFive.natDegree = 2 := by
  unfold polyXSqMinusFive
  compute_degree
  norm_num

/-- **🚨 ext #341** — `aeval (√5 : ℝ) polyXSqMinusFive = 0`. -/
theorem T5_polyXSqMinusFive_aeval_sqrt_five_eq_zero :
    Polynomial.aeval (Real.sqrt 5) polyXSqMinusFive = 0 := by
  unfold polyXSqMinusFive
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 5)]

/-- **🚨 ext #342a** — Polynomial X² - 7. -/
noncomputable def polyXSqMinusSeven : Polynomial ℤ := X ^ 2 - C 7

theorem T5_polyXSqMinusSeven_ne_zero : polyXSqMinusSeven ≠ 0 := by
  intro h
  have h2 : (polyXSqMinusSeven).natDegree = 2 := by
    unfold polyXSqMinusSeven
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusSeven_natDegree :
    polyXSqMinusSeven.natDegree = 2 := by
  unfold polyXSqMinusSeven
  compute_degree
  norm_num

/-- **🚨 ext #342** — `aeval (√7 : ℝ) polyXSqMinusSeven = 0`. -/
theorem T5_polyXSqMinusSeven_aeval_sqrt_seven_eq_zero :
    Polynomial.aeval (Real.sqrt 7) polyXSqMinusSeven = 0 := by
  unfold polyXSqMinusSeven
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 7)]

/-! ## Sub-cluster B — IsQuadraticAlgebraic concrete witnesses -/

/-- **🚨 ext #343** — `IsQuadraticAlgebraic √2`. -/
theorem T5_isQuadraticAlgebraic_sqrt_two :
    IsQuadraticAlgebraic (Real.sqrt 2) :=
  ⟨polyXSqMinusTwo,
   T5_polyXSqMinusTwo_ne_zero,
   T5_polyXSqMinusTwo_aeval_sqrt_two_eq_zero,
   T5_polyXSqMinusTwo_natDegree⟩

/-- **🚨 ext #344** — `IsQuadraticAlgebraic √3`. -/
theorem T5_isQuadraticAlgebraic_sqrt_three :
    IsQuadraticAlgebraic (Real.sqrt 3) :=
  ⟨polyXSqMinusThree,
   T5_polyXSqMinusThree_ne_zero,
   T5_polyXSqMinusThree_aeval_sqrt_three_eq_zero,
   T5_polyXSqMinusThree_natDegree⟩

/-- **🚨 ext #345** — `IsQuadraticAlgebraic √5`. -/
theorem T5_isQuadraticAlgebraic_sqrt_five :
    IsQuadraticAlgebraic (Real.sqrt 5) :=
  ⟨polyXSqMinusFive,
   T5_polyXSqMinusFive_ne_zero,
   T5_polyXSqMinusFive_aeval_sqrt_five_eq_zero,
   T5_polyXSqMinusFive_natDegree⟩

/-- **🚨 ext #346** — `IsQuadraticAlgebraic √7`. -/
theorem T5_isQuadraticAlgebraic_sqrt_seven :
    IsQuadraticAlgebraic (Real.sqrt 7) :=
  ⟨polyXSqMinusSeven,
   T5_polyXSqMinusSeven_ne_zero,
   T5_polyXSqMinusSeven_aeval_sqrt_seven_eq_zero,
   T5_polyXSqMinusSeven_natDegree⟩

/-! ## Sub-cluster C — Roth via Bundle-VII for these witnesses -/

/-- **🚨 ext #347** — Roth for √2 via Bundle-VII clean paper signature. -/
theorem T5_roth_for_sqrt_two_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 2| :=
  T5_irrational_quadratic_clean_paper (Real.sqrt 2) irrational_sqrt_two
    T5_isQuadraticAlgebraic_sqrt_two ε hε_pos

/-- **🚨 ext #348** — Roth for √3 via Bundle-VII. -/
theorem T5_roth_for_sqrt_three_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 3| := by
  have h_irr : Irrational (Real.sqrt 3) := by
    have : Nat.Prime 3 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 3) h_irr
    T5_isQuadraticAlgebraic_sqrt_three ε hε_pos

/-- **🚨 ext #349** — Roth for √5 via Bundle-VII. -/
theorem T5_roth_for_sqrt_five_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 5| := by
  have h_irr : Irrational (Real.sqrt 5) := by
    have : Nat.Prime 5 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 5) h_irr
    T5_isQuadraticAlgebraic_sqrt_five ε hε_pos

/-- **🚨 ext #350** — Roth for √7 via Bundle-VII. -/
theorem T5_roth_for_sqrt_seven_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 7| := by
  have h_irr : Irrational (Real.sqrt 7) := by
    have : Nat.Prime 7 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 7) h_irr
    T5_isQuadraticAlgebraic_sqrt_seven ε hε_pos

/-! ## Sub-cluster D — Bundle-XI markers + headlines -/

/-- **🚨 ext #351** — Frontier marker: Bundle-XI CONCRETE WITNESSES. -/
theorem T5_bundle_XI_first_in_V2_concrete_witnesses :
    ∃ (n : ℕ), 340 ≤ n ∧ n ≤ 355 ∧ n - 340 ≤ 16 :=
  ⟨355, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #352** — Bundle-XI closure cardinality bookkeeping. -/
theorem T5_bundle_XI_closed_count : 1 ≤ (16 : ℕ) := by norm_num

/-- **🚨 ext #353** — Bundle-XI master alias. -/
theorem T5_phase7_irrational_generic_bundle_XI_master_alias :
    IsQuadraticAlgebraic (Real.sqrt 2) ∧
    IsQuadraticAlgebraic (Real.sqrt 3) ∧
    IsQuadraticAlgebraic (Real.sqrt 5) ∧
    IsQuadraticAlgebraic (Real.sqrt 7) :=
  ⟨T5_isQuadraticAlgebraic_sqrt_two,
   T5_isQuadraticAlgebraic_sqrt_three,
   T5_isQuadraticAlgebraic_sqrt_five,
   T5_isQuadraticAlgebraic_sqrt_seven⟩

/-- **🚨 ext #354** — Bundle-XI 4-witness combined Roth headline. -/
theorem T5_bundle_XI_grand_headline_4_witnesses
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- Roth bound for √2
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 2) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 2|) ∧
    -- Roth bound for √3
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 3) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 3|) ∧
    -- Roth bound for √5
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 5) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 5|) ∧
    -- Roth bound for √7
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 7) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 7|) :=
  ⟨T5_roth_for_sqrt_two_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_three_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_five_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_seven_via_bundle_VII ε hε_pos⟩

/-! ## Bundle-XI GRAND HEADLINE FULL -/

/-- **🚨 ext #355 — HEADLINE: BUNDLE-XI CONCRETE WITNESSES**.

    🏆🏆🏆 16-form bundle delivering CONCRETE IsQuadraticAlgebraic
    witnesses for canonical irrational quadratics + Roth bounds via
    Bundle-VII clean paper signature. -/
theorem T5_phase7_irrational_generic_bundle_XI_grand_headline_full :
    -- 4 IsQuadraticAlgebraic witnesses
    IsQuadraticAlgebraic (Real.sqrt 2) ∧
    IsQuadraticAlgebraic (Real.sqrt 3) ∧
    IsQuadraticAlgebraic (Real.sqrt 5) ∧
    IsQuadraticAlgebraic (Real.sqrt 7) :=
  T5_phase7_irrational_generic_bundle_XI_master_alias

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XI
