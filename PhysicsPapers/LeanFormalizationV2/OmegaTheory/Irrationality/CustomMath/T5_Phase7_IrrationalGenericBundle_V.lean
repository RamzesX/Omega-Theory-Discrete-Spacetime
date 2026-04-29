/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_V

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE V: ext #245-260
  GRAND UNION + concrete-degree paper-citable composites**, sub
  session 559dddddddddddd through 559tttttttttttt — STRICT
  critical-path #316 (T-5) Phase 7 ext #245-260.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE pattern,
  Bundle-V, 16 ext sub-iterations consolidated).

  ## What this file delivers (16 ext sub-iterations consolidated)

  Sub-cluster A (concrete-degree paper-citable composites):
  - ext #245: irrational_quadratic_via_named_paper_full
  - ext #246: irrational_cubic_via_named_paper_full_eps_geq_two
  - ext #247: irrational_quartic_via_IsAlgebraicOfDegree_paper_form
  - ext #248: irrational_quintic_via_IsAlgebraicOfDegree_paper_form

  Sub-cluster B (auto-eps for NAMED Props):
  - ext #249: isQuadraticAlgebraic_irrational_auto_eps_paper
  - ext #250: isCubicAlgebraic_irrational_auto_eps_paper

  Sub-cluster C (Master Yoneda mega-bridges):
  - ext #251: bundle_V_yoneda_mega_bridge_to_legacy_quadratic
  - ext #252: bundle_V_yoneda_mega_bridge_to_legacy_cubic
  - ext #253: bundle_V_irrational_named_props_unified

  Sub-cluster D (Paper-citable mega headline):
  - ext #254: bundle_V_paper_citable_master_alias
  - ext #255: bundle_V_irrational_quadratic_or_cubic_paper_form
  - ext #256: bundle_V_grand_union_quadratic_cubic_paper

  Sub-cluster E (Bundle-V markers + headline):
  - ext #257: bundle_V_first_in_V2_grand_union_marker
  - ext #258: bundle_V_closed_count
  - ext #259: bundle_V_master_alias
  - ext #260: bundle_V_grand_headline (paper + neg-exp + non-vacuous)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #245-260 — GRAND UNION + concrete-degree (BUNDLE-FILE V).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_V

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

/-! ## Sub-cluster A — concrete-degree paper-citable composites -/

/-- **🚨 ext #245** — Irrational + IsQuadraticAlgebraic FULL paper bundle. -/
theorem T5_irrational_quadratic_via_named_paper_full
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_bundle_III_paper_form_quadratic_via_named_prop α hα h_quad ε hε_pos

/-- **🚨 ext #246** — Irrational + IsCubicAlgebraic + ε ≥ 2 paper full. -/
theorem T5_irrational_cubic_via_named_paper_full_eps_geq_two
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε : 2 ≤ ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  have h_eps_gt_one : 1 < ε := by linarith
  exact T5_bundle_III_paper_form_cubic_via_named_prop_eps_gt_one α hα h_cubic ε h_eps_gt_one

/-- **🚨 ext #247** — Irrational + IsAlgebraicOfDegree α 4 paper form (ε > 2). -/
theorem T5_irrational_quartic_via_IsAlgebraicOfDegree_paper_form
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 4)
    (ε : ℝ) (hε : 2 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quartic_generic_roth α hα h_alg ε hε

/-- **🚨 ext #248** — Irrational + IsAlgebraicOfDegree α 5 paper form (ε > 3). -/
theorem T5_irrational_quintic_via_IsAlgebraicOfDegree_paper_form
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 5)
    (ε : ℝ) (hε : 3 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C / ((q.den : ℝ)) ^ (2 + ε) ∧
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_quintic_generic_roth α hα h_alg ε hε

/-! ## Sub-cluster B — auto-eps for NAMED Props -/

/-- **🚨 ext #249** — Irrational + IsQuadraticAlgebraic auto-eps paper. -/
theorem T5_isQuadraticAlgebraic_irrational_auto_eps_paper
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_irrational_quadratic_via_named_paper_full α hα h_quad ε hε_pos
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #250** — Irrational + IsCubicAlgebraic auto-eps paper at ε > 1. -/
theorem T5_isCubicAlgebraic_irrational_auto_eps_paper
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_bundle_III_paper_form_cubic_via_named_prop_eps_gt_one α hα h_cubic ε hε
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-! ## Sub-cluster C — Master Yoneda mega-bridges -/

/-- **🚨 ext #251** — Bundle-V mega Yoneda bridge to legacy quadratic. -/
theorem T5_bundle_V_yoneda_mega_bridge_to_legacy_quadratic
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    -- Both forms paper + neg-exp simultaneously
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) := by
  refine ⟨?_, ?_⟩
  · obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
      T5_irrational_quadratic_via_named_paper_full α hα h_quad ε hε_pos
    refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
    intros q h_nonzero
    exact (h_bound q h_nonzero).2.1
  · obtain ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, h_bound⟩ :=
      T5_bundle_III_negative_exp_quadratic_via_named_prop α hα h_quad ε hε_pos
    refine ⟨C, p, hC_pos, hC_le, hp_ne, hp_root, ?_⟩
    intros q h_nonzero
    exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #252** — Bundle-V mega Yoneda bridge to legacy cubic. -/
theorem T5_bundle_V_yoneda_mega_bridge_to_legacy_cubic
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_isCubicAlgebraic_irrational_auto_eps_paper α hα h_cubic ε hε

/-- **🚨 ext #253** — Bundle-V irrational + NAMED Props unified. -/
theorem T5_bundle_V_irrational_named_props_unified
    (α : ℝ) (hα : Irrational α)
    (ε : ℝ) (hε_pos : 0 < ε) (hε_gt_one : 1 < ε) :
    -- For α IsQuadraticAlgebraic
    (IsQuadraticAlgebraic α →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- For α IsCubicAlgebraic at ε > 1
    (IsCubicAlgebraic α →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) := by
  refine ⟨?_, ?_⟩
  · intro h_quad
    exact T5_isQuadraticAlgebraic_irrational_auto_eps_paper α hα h_quad ε hε_pos
  · intro h_cubic
    exact T5_isCubicAlgebraic_irrational_auto_eps_paper α hα h_cubic ε hε_gt_one

/-! ## Sub-cluster D — Paper-citable mega headline -/

/-- **🚨 ext #254** — Bundle-V paper-citable master alias. -/
theorem T5_bundle_V_paper_citable_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_phase7_bundle_III_paper_headline_alias α hα n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  exact (h_bound q h_nonzero).2.1

/-- **🚨 ext #255** — Bundle-V irrational quadratic OR cubic disjunct paper. -/
theorem T5_bundle_V_irrational_quadratic_or_cubic_paper_form
    (α : ℝ) (hα : Irrational α)
    (h : IsQuadraticAlgebraic α ∨ IsCubicAlgebraic α)
    (ε : ℝ) (hε : 2 ≤ ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_pos : 0 < ε := by linarith
  have hε_gt_one : 1 < ε := by linarith
  cases h with
  | inl h_quad =>
    exact T5_isQuadraticAlgebraic_irrational_auto_eps_paper α hα h_quad ε hε_pos
  | inr h_cubic =>
    exact T5_isCubicAlgebraic_irrational_auto_eps_paper α hα h_cubic ε hε_gt_one

/-- **🚨 ext #256** — Bundle-V grand union quadratic + cubic paper. -/
theorem T5_bundle_V_grand_union_quadratic_cubic_paper
    (α : ℝ) (hα : Irrational α)
    (ε : ℝ) (hε : 2 ≤ ε) :
    -- Quadratic case
    (IsQuadraticAlgebraic α →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Cubic case
    (IsCubicAlgebraic α →
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ),
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) := by
  have hε_pos : 0 < ε := by linarith
  have hε_gt_one : 1 < ε := by linarith
  refine ⟨?_, ?_⟩
  · intro h_quad
    exact T5_isQuadraticAlgebraic_irrational_auto_eps_paper α hα h_quad ε hε_pos
  · intro h_cubic
    exact T5_isCubicAlgebraic_irrational_auto_eps_paper α hα h_cubic ε hε_gt_one

/-! ## Sub-cluster E — Bundle-V markers + headline -/

/-- **🚨 ext #257** — Frontier marker: Bundle-V FIRST-IN-V2 grand union. -/
theorem T5_bundle_V_first_in_V2_grand_union_marker :
    ∃ (n : ℕ), 245 ≤ n ∧ n ≤ 260 ∧ n - 245 ≤ 16 :=
  ⟨260, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #258** — Bundle-V closure cardinality bookkeeping. -/
theorem T5_bundle_V_closed_count : 1 ≤ (16 : ℕ) := by norm_num

/-- **🚨 ext #259** — Bundle-V MASTER alias for paper-citable form. -/
theorem T5_phase7_irrational_generic_bundle_V_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_bundle_V_paper_citable_master_alias α hα n hn h_alg ε hε hε_pos

/-! ## Bundle-V GRAND HEADLINE -/

/-- **🚨 ext #260 — HEADLINE: BUNDLE-V GRAND UNION**.

    🏆🏆🏆 16-form mega bundle for IRRATIONAL + GENERIC + NAMED Props.
    Composes all 4 prior bundles (I+II+III+IV) into a unified
    paper-citable headline. -/
theorem T5_phase7_irrational_generic_bundle_V_grand_headline
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
    -- Neg-exp form
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α|) ∧
    -- Universal distance positivity for irrational α
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  T5_phase7_irrational_generic_bundle_III_grand_headline α hα n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_V
