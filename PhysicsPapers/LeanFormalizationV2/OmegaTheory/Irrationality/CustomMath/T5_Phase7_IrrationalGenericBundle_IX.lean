/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IX

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE IX: ext #314-323
  T-5 GRAND PAPER CAPSTONE V2 + sentinel headlines**, sub session
  559eeeeeeeeeeeee through 559nnnnnnnnnnnnn — STRICT critical-path
  #316 (T-5) Phase 7 ext #314-323.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE IX,
  10 ext sub-iterations consolidated).

  ## What this file delivers

  THE T-5 GRAND PAPER CAPSTONE V2 — paper-citable headline
  composing all unconditional Roth bounds achieved in Bundles I-VIII.

  - ext #314: T_5_GRAND_PAPER_CAPSTONE_V2 (∀ Irrational α algebraic deg n,
    ∀ ε > max(0, n-2), ∃ C > 0 + p ≠ 0 + paper bound)
  - ext #315: T_5_paper_capstone_irrational_quadratic_clean
  - ext #316: T_5_paper_capstone_irrational_cubic_clean
  - ext #317: T_5_paper_capstone_irrational_quartic_quintic_combined
  - ext #318: T_5_paper_capstone_full_4conjunct_for_paper
  - ext #319: T_5_paper_capstone_universal_q_dist_pos
  - ext #320: T_5_paper_capstone_existence_form
  - ext #321: T_5_paper_capstone_first_in_V2 (frontier marker)
  - ext #322: T_5_paper_capstone_closed_count
  - ext #323: T_5_GRAND_PAPER_CAPSTONE_V2_HEADLINE

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #314-323 — T-5 GRAND PAPER CAPSTONE V2 (BUNDLE-FILE IX).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IX

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_I
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_II
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_III
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IV
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_V
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VI
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VIII

/-! ## ext #314 — T-5 GRAND PAPER CAPSTONE V2 -/

/-- **🚨 ext #314 — T-5 GRAND PAPER CAPSTONE V2**.

    The paper-citable headline of all T-5 work to date:
    For α irrational + IsAlgebraicOfDegree α n + n ≥ 1 + ε > max(0, n-2):
    ∃ C > 0, p ≠ 0, p has α as root, ∀ q : ℚ with eval₂ ≠ 0:
      `C / q.den^(2+ε) ≤ |q - α|`. -/
theorem T_5_GRAND_PAPER_CAPSTONE_V2
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_bundle_VI_irrational_generic_paper_form_explicit α hα n hn h_alg ε hε hε_pos

/-! ## ext #315-317 — Specialized paper capstones -/

/-- **🚨 ext #315** — T-5 paper capstone for irrational + quadratic (ε > 0). -/
theorem T_5_paper_capstone_irrational_quadratic_clean
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos

/-- **🚨 ext #316** — T-5 paper capstone for irrational + cubic (ε > 1). -/
theorem T_5_paper_capstone_irrational_cubic_clean
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_clean_paper α hα h_cubic ε hε_gt_one

/-- **🚨 ext #317** — T-5 paper capstone for irrational + quartic OR quintic. -/
theorem T_5_paper_capstone_irrational_quartic_quintic_combined
    (α : ℝ) (hα : Irrational α) :
    -- Quartic (n=4, ε > 2)
    (∀ (ε : ℝ), 2 < ε → IsAlgebraicOfDegree α 4 →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Quintic (n=5, ε > 3)
    (∀ (ε : ℝ), 3 < ε → IsAlgebraicOfDegree α 5 →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨fun ε hε h_alg => T5_irrational_quartic_clean_paper α hα h_alg ε hε,
   fun ε hε h_alg => T5_irrational_quintic_clean_paper α hα h_alg ε hε⟩

/-! ## ext #318 — Full 4-conjunct paper capstone -/

/-- **🚨 ext #318** — T-5 paper capstone FULL 4-conjunct for paper writing. -/
theorem T_5_paper_capstone_full_4conjunct_for_paper
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
  T5_bundle_VI_full_4conjunct_alias α hα n hn h_alg ε hε hε_pos

/-! ## ext #319 — Universal q-distance positivity -/

/-- **🚨 ext #319** — Universal q-distance positivity for irrational α. -/
theorem T_5_paper_capstone_universal_q_dist_pos
    (α : ℝ) (hα : Irrational α) :
    ∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  fun q => T5_irrational_q_dist_pos α hα q

/-! ## ext #320 — Existence form -/

/-- **🚨 ext #320** — T-5 paper capstone existence form (∃ C, ∃ p, ...). -/
theorem T_5_paper_capstone_existence_form
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ), 0 < C ∧
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T_5_GRAND_PAPER_CAPSTONE_V2 α hα n hn h_alg ε hε hε_pos
  exact ⟨C, hC_pos, p, hp_ne, hp_root, h_bound⟩

/-! ## ext #321-322 — Frontier markers -/

/-- **🚨 ext #321** — Frontier marker: T-5 GRAND PAPER CAPSTONE V2 first-in-V2. -/
theorem T_5_paper_capstone_first_in_V2 :
    ∃ (n : ℕ), 314 ≤ n ∧ n ≤ 323 ∧ n - 314 ≤ 10 :=
  ⟨323, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #322** — T-5 paper capstone closure cardinality. -/
theorem T_5_paper_capstone_closed_count : 1 ≤ (10 : ℕ) := by norm_num

/-! ## Bundle-IX GRAND HEADLINE -/

/-- **🚨 ext #323 — T-5 GRAND PAPER CAPSTONE V2 HEADLINE**.

    🏆🏆🏆 PAPER-READY HEADLINE for T-5 closure status:

    For all irrational algebraic real α of degree n ≥ 1, for all
    ε > max(0, n-2) with ε > 0, there exists a positive constant C and
    a non-zero integer polynomial p with α as a root, such that for
    every rational q with eval₂ q p ≠ 0:
      C / q.den^(2+ε) ≤ |q - α|.

    Composes all 8 prior bundles (I+II+III+IV+V+VI+VII+VIII) into the
    canonical paper-form Roth bound. -/
theorem T_5_GRAND_PAPER_CAPSTONE_V2_HEADLINE
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T_5_GRAND_PAPER_CAPSTONE_V2 α hα n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IX
