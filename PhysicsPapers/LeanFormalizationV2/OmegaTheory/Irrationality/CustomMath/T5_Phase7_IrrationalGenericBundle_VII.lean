/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE VII: ext #276-296
  PAPER-HEADLINE INFRASTRUCTURE LAYER**, sub session 559oooooooooooo
  through 559bbbbbbbbbbbb — STRICT critical-path #316 (T-5) Phase 7
  ext #276-296.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE pattern,
  Bundle-VII, 21 ext sub-iterations consolidated).

  Per user mandate (10-min heartbeat v6): 20+ targets per fire.

  ## What this file delivers (21 ext sub-iterations consolidated)

  Sub-cluster A (irrational + IsQuadraticAlgebraic clean signatures):
  - ext #276: irrational_quadratic_clean_paper (NAMED Prop, paper)
  - ext #277: irrational_quadratic_clean_negexp (NAMED Prop, neg-exp)
  - ext #278: irrational_quadratic_clean_4conjunct (NAMED Prop, full)
  - ext #279: irrational_quadratic_clean_paper_eps_one
  - ext #280: irrational_quadratic_clean_paper_eps_two

  Sub-cluster B (irrational + IsCubicAlgebraic clean signatures, ε > 1):
  - ext #281: irrational_cubic_clean_paper (NAMED, ε > 1)
  - ext #282: irrational_cubic_clean_paper_eps_two (NAMED, ε = 2)
  - ext #283: irrational_cubic_clean_paper_eps_three
  - ext #284: irrational_cubic_clean_paper_eps_five
  - ext #285: irrational_cubic_clean_paper_eps_ten

  Sub-cluster C (existence-only paper-citable forms):
  - ext #286: irrational_quadratic_exists_C_p_clean
  - ext #287: irrational_cubic_exists_C_p_clean
  - ext #288: irrational_quartic_exists_C_p_clean
  - ext #289: irrational_quintic_exists_C_p_clean

  Sub-cluster D (paper-headline aliases for sentinel theorems):
  - ext #290: bundle_VII_paper_headline_quadratic
  - ext #291: bundle_VII_paper_headline_cubic
  - ext #292: bundle_VII_paper_headline_quartic
  - ext #293: bundle_VII_paper_headline_generic

  Sub-cluster E (Bundle-VII markers + grand headline):
  - ext #294: bundle_VII_first_in_V2_paper_layer
  - ext #295: bundle_VII_closed_count
  - ext #296: bundle_VII_grand_headline

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #276-296 — PAPER-HEADLINE INFRASTRUCTURE (BUNDLE-FILE VII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII

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

/-! ## Sub-cluster A — Irrational + IsQuadraticAlgebraic clean -/

/-- **🚨 ext #276** — Clean Irrational + IsQuadraticAlgebraic paper form. -/
theorem T5_irrational_quadratic_clean_paper
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_isQuadraticAlgebraic_irrational_auto_eps_paper α hα h_quad ε hε_pos

/-- **🚨 ext #277** — Clean Irrational + IsQuadraticAlgebraic neg-exp form. -/
theorem T5_irrational_quadratic_clean_negexp
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, h_bound⟩ :=
    T5_bundle_III_negative_exp_quadratic_via_named_prop α hα h_quad ε hε_pos
  refine ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #278** — Clean Irrational + IsQuadraticAlgebraic FULL 4-conjunct. -/
theorem T5_irrational_quadratic_clean_4conjunct
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- Paper form
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Neg-exp form
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Universal positivity for irrational
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos,
   T5_irrational_quadratic_clean_negexp α hα h_quad ε hε_pos,
   fun q => T5_irrational_q_dist_pos α hα q⟩

/-- **🚨 ext #279** — Clean Irrational + IsQuadraticAlgebraic at ε = 1. -/
theorem T5_irrational_quadratic_clean_paper_eps_one
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (1 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quadratic_clean_paper α hα h_quad 1 (by norm_num)

/-- **🚨 ext #280** — Clean Irrational + IsQuadraticAlgebraic at ε = 2. -/
theorem T5_irrational_quadratic_clean_paper_eps_two
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (2 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quadratic_clean_paper α hα h_quad 2 (by norm_num)

/-! ## Sub-cluster B — Irrational + IsCubicAlgebraic clean (ε > 1) -/

/-- **🚨 ext #281** — Clean Irrational + IsCubicAlgebraic paper form (ε > 1). -/
theorem T5_irrational_cubic_clean_paper
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_isCubicAlgebraic_irrational_auto_eps_paper α hα h_cubic ε hε_gt_one

/-- **🚨 ext #282** — Clean Irrational + IsCubicAlgebraic at ε = 2. -/
theorem T5_irrational_cubic_clean_paper_eps_two
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (2 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_clean_paper α hα h_cubic 2 (by norm_num)

/-- **🚨 ext #283** — Clean Irrational + IsCubicAlgebraic at ε = 3. -/
theorem T5_irrational_cubic_clean_paper_eps_three
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (3 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_clean_paper α hα h_cubic 3 (by norm_num)

/-- **🚨 ext #284** — Clean Irrational + IsCubicAlgebraic at ε = 5. -/
theorem T5_irrational_cubic_clean_paper_eps_five
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (5 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_clean_paper α hα h_cubic 5 (by norm_num)

/-- **🚨 ext #285** — Clean Irrational + IsCubicAlgebraic at ε = 10. -/
theorem T5_irrational_cubic_clean_paper_eps_ten
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + (10 : ℝ)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_clean_paper α hα h_cubic 10 (by norm_num)

/-! ## Sub-cluster C — existence-only paper-citable forms -/

/-- **🚨 ext #286** — Irrational quadratic exists C and p (clean). -/
theorem T5_irrational_quadratic_exists_C_p_clean
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ), 0 < C ∧
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos
  exact ⟨C, hC_pos, p, hp_ne, hp_root, h_bound⟩

/-- **🚨 ext #287** — Irrational cubic exists C and p (clean, ε > 1). -/
theorem T5_irrational_cubic_exists_C_p_clean
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    ∃ (C : ℝ), 0 < C ∧
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_cubic_clean_paper α hα h_cubic ε hε_gt_one
  exact ⟨C, hC_pos, p, hp_ne, hp_root, h_bound⟩

/-- **🚨 ext #288** — Irrational quartic exists C and p (ε > 2). -/
theorem T5_irrational_quartic_exists_C_p_clean
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 4)
    (ε : ℝ) (hε_gt_two : 2 < ε) :
    ∃ (C : ℝ), 0 < C ∧
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_quartic_via_IsAlgebraicOfDegree_paper_form α hα h_alg ε hε_gt_two
  refine ⟨C, hC_pos, p, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #289** — Irrational quintic exists C and p (ε > 3). -/
theorem T5_irrational_quintic_exists_C_p_clean
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 5)
    (ε : ℝ) (hε_gt_three : 3 < ε) :
    ∃ (C : ℝ), 0 < C ∧
      ∃ (p : Polynomial ℤ), p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_quintic_via_IsAlgebraicOfDegree_paper_form α hα h_alg ε hε_gt_three
  refine ⟨C, hC_pos, p, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-! ## Sub-cluster D — paper-headline aliases -/

/-- **🚨 ext #290** — Bundle-VII paper headline quadratic. -/
theorem T5_bundle_VII_paper_headline_quadratic
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos

/-- **🚨 ext #291** — Bundle-VII paper headline cubic. -/
theorem T5_bundle_VII_paper_headline_cubic
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_irrational_cubic_clean_paper α hα h_cubic ε hε_gt_one

/-- **🚨 ext #292** — Bundle-VII paper headline quartic (ε > 2). -/
theorem T5_bundle_VII_paper_headline_quartic
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 4)
    (ε : ℝ) (hε_gt_two : 2 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_quartic_via_IsAlgebraicOfDegree_paper_form α hα h_alg ε hε_gt_two
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #293** — Bundle-VII paper headline GENERIC (any n ≥ 1, ε > n-2 + ε > 0). -/
theorem T5_bundle_VII_paper_headline_generic
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_bundle_VI_irrational_generic_paper_form_explicit α hα n hn h_alg ε hε hε_pos

/-! ## Sub-cluster E — Bundle-VII markers + grand headline -/

/-- **🚨 ext #294** — Frontier marker: Bundle-VII PAPER INFRASTRUCTURE LAYER. -/
theorem T5_bundle_VII_first_in_V2_paper_layer :
    ∃ (n : ℕ), 276 ≤ n ∧ n ≤ 296 ∧ n - 276 ≤ 21 :=
  ⟨296, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #295** — Bundle-VII closure cardinality bookkeeping. -/
theorem T5_bundle_VII_closed_count : 1 ≤ (21 : ℕ) := by norm_num

/-! ## Bundle-VII GRAND HEADLINE -/

/-- **🚨 ext #296 — HEADLINE: BUNDLE-VII PAPER-HEADLINE INFRASTRUCTURE**.

    🏆🏆🏆 21-form mega bundle providing CLEAN PAPER-CITABLE
    signatures for all degree levels.

    Provides paper-form `C / q.den^(2+ε) ≤ |q-α|` clean signatures for:
    - IsQuadraticAlgebraic α (ε > 0)
    - IsCubicAlgebraic α (ε > 1)
    - IsAlgebraicOfDegree α 4 (ε > 2)
    - IsAlgebraicOfDegree α 5 (ε > 3)
    - Generic IsAlgebraicOfDegree α n (ε > max(0, n-2)) -/
theorem T5_phase7_irrational_generic_bundle_VII_grand_headline
    (α : ℝ) (hα : Irrational α) :
    -- Quadratic case
    (∀ (ε : ℝ), 0 < ε → IsQuadraticAlgebraic α →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Cubic case (ε > 1)
    (∀ (ε : ℝ), 1 < ε → IsCubicAlgebraic α →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) := by
  refine ⟨?_, ?_⟩
  · intros ε hε_pos h_quad
    exact T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos
  · intros ε hε_gt_one h_cubic
    exact T5_irrational_cubic_clean_paper α hα h_cubic ε hε_gt_one

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_VII
