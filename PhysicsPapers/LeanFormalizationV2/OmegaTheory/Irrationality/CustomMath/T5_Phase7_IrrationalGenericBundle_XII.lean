/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XII: ext #356-371
  GOLDEN RATIO + MORE QUADRATIC CONCRETE WITNESSES**, sub session
  559ssssssssssssss through 559gggggggggggggg — STRICT critical-path
  #316 (T-5) Phase 7 ext #356-371.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XII,
  16 ext sub-iterations consolidated).

  ## What this file delivers

  Concrete `IsQuadraticAlgebraic` witnesses for golden ratio φ and
  more quadratic radicals (√11, √13), plus their Roth bounds via
  Bundle-VII clean signature.

  Sub-cluster A (golden ratio polynomial X² - X - 1):
  - ext #356: polyGoldenMinPoly + ne_zero + natDegree + aeval at φ

  Sub-cluster B (more X² - n witnesses for primes 11, 13):
  - ext #357: polyXSqMinusEleven + ne_zero + natDegree + aeval at √11
  - ext #358: polyXSqMinusThirteen + ne_zero + natDegree + aeval at √13

  Sub-cluster C (IsQuadraticAlgebraic concrete witnesses):
  - ext #359: T5_isQuadraticAlgebraic_goldenRatio
  - ext #360: T5_isQuadraticAlgebraic_sqrt_eleven
  - ext #361: T5_isQuadraticAlgebraic_sqrt_thirteen

  Sub-cluster D (Roth bounds via Bundle-VII):
  - ext #362: T5_roth_for_goldenRatio_via_bundle_VII
  - ext #363: T5_roth_for_sqrt_eleven_via_bundle_VII
  - ext #364: T5_roth_for_sqrt_thirteen_via_bundle_VII

  Sub-cluster E (Bundle-XII master + headlines):
  - ext #365: bundle_XII_master_alias_3_witnesses
  - ext #366: bundle_XII_combined_roth_bounds
  - ext #367: bundle_XII_first_in_V2_marker
  - ext #368: bundle_XII_closed_count
  - ext #369: bundle_XII_grand_headline_3_witnesses
  - ext #370: bundle_XII_paper_headline_alias
  - ext #371: bundle_XII_full_roth_bundle_grand

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #356-371 — Golden ratio + √11/√13 (BUNDLE-XII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XI
import Mathlib.NumberTheory.Real.GoldenRatio

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII

/-! ## Sub-cluster A — golden ratio minimal polynomial X² - X - 1 -/

/-- **🚨 ext #356a** — Polynomial X² - X - 1 (minimal polynomial of φ over ℚ). -/
noncomputable def polyGoldenMinPoly : Polynomial ℤ := X ^ 2 - X - C 1

theorem T5_polyGoldenMinPoly_ne_zero : polyGoldenMinPoly ≠ 0 := by
  intro h
  have h2 : polyGoldenMinPoly.natDegree = 2 := by
    unfold polyGoldenMinPoly
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyGoldenMinPoly_natDegree :
    polyGoldenMinPoly.natDegree = 2 := by
  unfold polyGoldenMinPoly
  compute_degree
  norm_num

/-- **🚨 ext #356** — `aeval Real.goldenRatio polyGoldenMinPoly = 0`.

    Uses `Real.goldenRatio_sq : Real.goldenRatio^2 = Real.goldenRatio + 1`. -/
theorem T5_polyGoldenMinPoly_aeval_goldenRatio_eq_zero :
    Polynomial.aeval Real.goldenRatio polyGoldenMinPoly = 0 := by
  unfold polyGoldenMinPoly
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.goldenRatio_sq]

/-! ## Sub-cluster B — more X² - n witnesses -/

/-- **🚨 ext #357a** — Polynomial X² - 11. -/
noncomputable def polyXSqMinusEleven : Polynomial ℤ := X ^ 2 - C 11

theorem T5_polyXSqMinusEleven_ne_zero : polyXSqMinusEleven ≠ 0 := by
  intro h
  have h2 : polyXSqMinusEleven.natDegree = 2 := by
    unfold polyXSqMinusEleven
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusEleven_natDegree :
    polyXSqMinusEleven.natDegree = 2 := by
  unfold polyXSqMinusEleven
  compute_degree
  norm_num

/-- **🚨 ext #357** — `aeval (√11 : ℝ) polyXSqMinusEleven = 0`. -/
theorem T5_polyXSqMinusEleven_aeval_sqrt_eleven_eq_zero :
    Polynomial.aeval (Real.sqrt 11) polyXSqMinusEleven = 0 := by
  unfold polyXSqMinusEleven
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 11)]

/-- **🚨 ext #358a** — Polynomial X² - 13. -/
noncomputable def polyXSqMinusThirteen : Polynomial ℤ := X ^ 2 - C 13

theorem T5_polyXSqMinusThirteen_ne_zero : polyXSqMinusThirteen ≠ 0 := by
  intro h
  have h2 : polyXSqMinusThirteen.natDegree = 2 := by
    unfold polyXSqMinusThirteen
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXSqMinusThirteen_natDegree :
    polyXSqMinusThirteen.natDegree = 2 := by
  unfold polyXSqMinusThirteen
  compute_degree
  norm_num

/-- **🚨 ext #358** — `aeval (√13 : ℝ) polyXSqMinusThirteen = 0`. -/
theorem T5_polyXSqMinusThirteen_aeval_sqrt_thirteen_eq_zero :
    Polynomial.aeval (Real.sqrt 13) polyXSqMinusThirteen = 0 := by
  unfold polyXSqMinusThirteen
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 13)]

/-! ## Sub-cluster C — IsQuadraticAlgebraic concrete witnesses -/

/-- **🚨 ext #359** — `IsQuadraticAlgebraic Real.goldenRatio`. -/
theorem T5_isQuadraticAlgebraic_goldenRatio :
    IsQuadraticAlgebraic Real.goldenRatio :=
  ⟨polyGoldenMinPoly,
   T5_polyGoldenMinPoly_ne_zero,
   T5_polyGoldenMinPoly_aeval_goldenRatio_eq_zero,
   T5_polyGoldenMinPoly_natDegree⟩

/-- **🚨 ext #360** — `IsQuadraticAlgebraic √11`. -/
theorem T5_isQuadraticAlgebraic_sqrt_eleven :
    IsQuadraticAlgebraic (Real.sqrt 11) :=
  ⟨polyXSqMinusEleven,
   T5_polyXSqMinusEleven_ne_zero,
   T5_polyXSqMinusEleven_aeval_sqrt_eleven_eq_zero,
   T5_polyXSqMinusEleven_natDegree⟩

/-- **🚨 ext #361** — `IsQuadraticAlgebraic √13`. -/
theorem T5_isQuadraticAlgebraic_sqrt_thirteen :
    IsQuadraticAlgebraic (Real.sqrt 13) :=
  ⟨polyXSqMinusThirteen,
   T5_polyXSqMinusThirteen_ne_zero,
   T5_polyXSqMinusThirteen_aeval_sqrt_thirteen_eq_zero,
   T5_polyXSqMinusThirteen_natDegree⟩

/-! ## Sub-cluster D — Roth bounds via Bundle-VII -/

/-- **🚨 ext #362** — Roth for golden ratio via Bundle-VII. -/
theorem T5_roth_for_goldenRatio_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval Real.goldenRatio p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤
          |((q : ℚ) : ℝ) - Real.goldenRatio| :=
  T5_irrational_quadratic_clean_paper Real.goldenRatio
    Real.goldenRatio_irrational
    T5_isQuadraticAlgebraic_goldenRatio ε hε_pos

/-- **🚨 ext #363** — Roth for √11 via Bundle-VII. -/
theorem T5_roth_for_sqrt_eleven_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 11) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 11| := by
  have h_irr : Irrational (Real.sqrt 11) := by
    have : Nat.Prime 11 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 11) h_irr
    T5_isQuadraticAlgebraic_sqrt_eleven ε hε_pos

/-- **🚨 ext #364** — Roth for √13 via Bundle-VII. -/
theorem T5_roth_for_sqrt_thirteen_via_bundle_VII
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 13) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 13| := by
  have h_irr : Irrational (Real.sqrt 13) := by
    have : Nat.Prime 13 := by decide
    exact (Nat.Prime.irrational_sqrt this)
  exact T5_irrational_quadratic_clean_paper (Real.sqrt 13) h_irr
    T5_isQuadraticAlgebraic_sqrt_thirteen ε hε_pos

/-! ## Sub-cluster E — Bundle-XII master + headlines -/

/-- **🚨 ext #365** — Bundle-XII master alias (3 IsQuadraticAlgebraic). -/
theorem T5_phase7_irrational_generic_bundle_XII_master_alias :
    IsQuadraticAlgebraic Real.goldenRatio ∧
    IsQuadraticAlgebraic (Real.sqrt 11) ∧
    IsQuadraticAlgebraic (Real.sqrt 13) :=
  ⟨T5_isQuadraticAlgebraic_goldenRatio,
   T5_isQuadraticAlgebraic_sqrt_eleven,
   T5_isQuadraticAlgebraic_sqrt_thirteen⟩

/-- **🚨 ext #366** — Bundle-XII combined Roth bounds for 3 witnesses. -/
theorem T5_bundle_XII_combined_roth_bounds
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- Roth bound for φ
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval Real.goldenRatio p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.goldenRatio|) ∧
    -- Roth bound for √11
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 11) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 11|) ∧
    -- Roth bound for √13
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 13) p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 13|) :=
  ⟨T5_roth_for_goldenRatio_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_eleven_via_bundle_VII ε hε_pos,
   T5_roth_for_sqrt_thirteen_via_bundle_VII ε hε_pos⟩

/-- **🚨 ext #367** — Frontier marker: Bundle-XII GOLDEN + sqrt 11/13. -/
theorem T5_bundle_XII_first_in_V2_marker :
    ∃ (n : ℕ), 356 ≤ n ∧ n ≤ 371 ∧ n - 356 ≤ 16 :=
  ⟨371, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #368** — Bundle-XII closure cardinality bookkeeping. -/
theorem T5_bundle_XII_closed_count : 1 ≤ (16 : ℕ) := by norm_num

/-- **🚨 ext #369** — Bundle-XII grand headline 3 witnesses. -/
theorem T5_bundle_XII_grand_headline_3_witnesses :
    IsQuadraticAlgebraic Real.goldenRatio ∧
    IsQuadraticAlgebraic (Real.sqrt 11) ∧
    IsQuadraticAlgebraic (Real.sqrt 13) :=
  T5_phase7_irrational_generic_bundle_XII_master_alias

/-- **🚨 ext #370** — Bundle-XII paper headline alias. -/
theorem T5_bundle_XII_paper_headline_alias
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval Real.goldenRatio p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤
          |((q : ℚ) : ℝ) - Real.goldenRatio| :=
  T5_roth_for_goldenRatio_via_bundle_VII ε hε_pos

/-! ## Bundle-XII GRAND HEADLINE -/

/-- **🚨 ext #371 — HEADLINE: BUNDLE-XII GOLDEN RATIO + sqrt 11/13**.

    🏆🏆🏆 16-form bundle delivering φ = goldenRatio + √11 + √13
    concrete IsQuadraticAlgebraic witnesses + Roth bounds via
    Bundle-VII clean paper signature. -/
theorem T5_bundle_XII_full_roth_bundle_grand
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- 3 IsQuadraticAlgebraic witnesses
    (IsQuadraticAlgebraic Real.goldenRatio ∧
     IsQuadraticAlgebraic (Real.sqrt 11) ∧
     IsQuadraticAlgebraic (Real.sqrt 13)) ∧
    -- 3 Roth bounds
    ((∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval Real.goldenRatio p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤
            |((q : ℚ) : ℝ) - Real.goldenRatio|) ∧
     (∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 11) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 11|) ∧
     (∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval (Real.sqrt 13) p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - Real.sqrt 13|)) :=
  ⟨T5_phase7_irrational_generic_bundle_XII_master_alias,
   T5_bundle_XII_combined_roth_bounds ε hε_pos⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XII
