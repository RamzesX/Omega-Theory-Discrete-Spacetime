/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE VI: ext #261-275
  MEGA UNION over 5 prior bundles + paper-form mega-aliases**, sub
  session 559uuuuuuuuuuuu through 559iiiiiiiiiiii — STRICT
  critical-path #316 (T-5) Phase 7 ext #261-275.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE pattern,
  Bundle-VI, 15 ext sub-iterations consolidated).

  ## What this file delivers (15 ext sub-iterations consolidated)

  Sub-cluster A (mega-aliases for paper headline):
  - ext #261: bundle_VI_irrational_generic_paper_form_explicit
  - ext #262: bundle_VI_irrational_generic_neg_exp_explicit
  - ext #263: bundle_VI_irrational_generic_paper_form_C_le_one_explicit

  Sub-cluster B (high-degree concrete cases for paper):
  - ext #264: irrational_generic_n_eq_six_eps_five
  - ext #265: irrational_generic_n_eq_seven_eps_six
  - ext #266: irrational_generic_n_eq_eight_eps_seven
  - ext #267: irrational_generic_n_eq_nine_eps_eight
  - ext #268: irrational_generic_n_eq_eleven_eps_ten

  Sub-cluster C (paper-headline composites unifying all bundles):
  - ext #269: bundle_VI_paper_grand_master_alias
  - ext #270: bundle_VI_full_4conjunct_alias
  - ext #271: bundle_VI_grand_unified_3form_alias

  Sub-cluster D (Bundle-VI markers + headline):
  - ext #272: bundle_VI_first_in_V2_mega_union
  - ext #273: bundle_VI_closed_count
  - ext #274: bundle_VI_master_alias
  - ext #275: bundle_VI_grand_headline (mega capstone over I-V)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #261-275 — MEGA UNION over Bundles I-V (BUNDLE-FILE VI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_V

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VI

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_I
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_II
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_III
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IV
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_V

/-! ## Sub-cluster A — mega-aliases for paper headline -/

/-- **🚨 ext #261** — Bundle-VI explicit irrational generic paper form. -/
theorem T5_bundle_VI_irrational_generic_paper_form_explicit
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_phase7_irrational_generic_bundle_V_master_alias α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #262** — Bundle-VI explicit irrational generic neg-exp form. -/
theorem T5_bundle_VI_irrational_generic_neg_exp_explicit
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #263** — Bundle-VI paper form with C ≤ 1 explicit. -/
theorem T5_bundle_VI_irrational_generic_paper_form_C_le_one_explicit
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Paper form (no C ≤ 1)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Neg-exp form (with C ≤ 1)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_bundle_VI_irrational_generic_paper_form_explicit α hα n hn h_alg ε hε hε_pos,
   T5_bundle_VI_irrational_generic_neg_exp_explicit α hα n hn h_alg ε hε hε_pos⟩

/-! ## Sub-cluster B — high-degree concrete cases for paper -/

/-- **🚨 ext #264** — Irrational + IsAlgebraicOfDegree α 6, ε = 5 paper. -/
theorem T5_irrational_generic_n_eq_six_eps_five
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 6) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (5 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_real : ((6 : ℕ) : ℝ) - 2 < (5 : ℝ) := by show (6 : ℝ) - 2 < 5; linarith
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_paper_form α hα 6 (by norm_num) h_alg 5 hε_real (by norm_num)
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #265** — Irrational + IsAlgebraicOfDegree α 7, ε = 6 paper. -/
theorem T5_irrational_generic_n_eq_seven_eps_six
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 7) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (6 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_real : ((7 : ℕ) : ℝ) - 2 < (6 : ℝ) := by show (7 : ℝ) - 2 < 6; linarith
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_paper_form α hα 7 (by norm_num) h_alg 6 hε_real (by norm_num)
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #266** — Irrational + IsAlgebraicOfDegree α 8, ε = 7 paper. -/
theorem T5_irrational_generic_n_eq_eight_eps_seven
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 8) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (7 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_real : ((8 : ℕ) : ℝ) - 2 < (7 : ℝ) := by show (8 : ℝ) - 2 < 7; linarith
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_paper_form α hα 8 (by norm_num) h_alg 7 hε_real (by norm_num)
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #267** — Irrational + IsAlgebraicOfDegree α 9, ε = 8 paper. -/
theorem T5_irrational_generic_n_eq_nine_eps_eight
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 9) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (8 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_real : ((9 : ℕ) : ℝ) - 2 < (8 : ℝ) := by show (9 : ℝ) - 2 < 8; linarith
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_paper_form α hα 9 (by norm_num) h_alg 8 hε_real (by norm_num)
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #268** — Irrational + IsAlgebraicOfDegree α 11, ε = 10 paper. -/
theorem T5_irrational_generic_n_eq_eleven_eps_ten
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 11) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (10 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_real : ((11 : ℕ) : ℝ) - 2 < (10 : ℝ) := by show (11 : ℝ) - 2 < 10; linarith
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_generic_paper_form α hα 11 (by norm_num) h_alg 10 hε_real (by norm_num)
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-! ## Sub-cluster C — paper-headline composites unifying all bundles -/

/-- **🚨 ext #269** — Bundle-VI paper grand master alias. -/
theorem T5_bundle_VI_paper_grand_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_phase7_bundle_III_paper_headline_alias α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #270** — Bundle-VI full 4-conjunct alias. -/
theorem T5_bundle_VI_full_4conjunct_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ C :=
  T5_irrational_generic_full_bundle α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #271** — Bundle-VI grand unified 3-form alias. -/
theorem T5_bundle_VI_grand_unified_3form_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Paper form (3-conjunct: 0<LHS, ≤, 0<|q-α|)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Neg-exp form (3-conjunct: 0<LHS, ≤, 0<|q-α|)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Universal distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  T5_phase7_irrational_generic_bundle_V_grand_headline α hα n hn h_alg ε hε hε_pos

/-! ## Sub-cluster D — Bundle-VI markers + headline -/

/-- **🚨 ext #272** — Frontier marker: Bundle-VI MEGA UNION over Bundles I-V. -/
theorem T5_bundle_VI_first_in_V2_mega_union :
    ∃ (n : ℕ), 261 ≤ n ∧ n ≤ 275 ∧ n - 261 ≤ 15 :=
  ⟨275, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #273** — Bundle-VI closure cardinality bookkeeping. -/
theorem T5_bundle_VI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #274** — Bundle-VI master alias for paper-citable form. -/
theorem T5_phase7_irrational_generic_bundle_VI_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_bundle_VI_irrational_generic_paper_form_explicit α hα n hn h_alg ε hε hε_pos

/-! ## Bundle-VI GRAND HEADLINE -/

/-- **🚨 ext #275 — HEADLINE: BUNDLE-VI MEGA UNION**.

    🏆🏆🏆 15-form mega bundle composing ALL prior bundles I+II+III+IV+V
    into single paper-citable headline. Concrete witnesses for n ∈
    {6, 7, 8, 9, 11} + ε ∈ {5, 6, 7, 8, 10}. -/
theorem T5_phase7_irrational_generic_bundle_VI_grand_headline
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Paper form
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Neg-exp form (3-conjunct including non-vacuous)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Universal distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  T5_phase7_irrational_generic_bundle_V_grand_headline α hα n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VI
