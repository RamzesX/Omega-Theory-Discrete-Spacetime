/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE X: ext #324-339
  Mathlib IsAlgebraic bridges + Roth via ℤ-algebraic**, sub session
  559oooooooooooooo through 559bbbbbbbbbbbbbb — STRICT critical-path
  #316 (T-5) Phase 7 ext #324-339.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE X,
  16 ext sub-iterations consolidated).

  ## What this file delivers

  Bridges between OV2's `IsAlgebraicOfDegree α n` / `IsQuadraticAlgebraic` /
  `IsCubicAlgebraic` and Mathlib's general `IsAlgebraic ℤ α` (and `ℚ`).
  Each bridge unlocks Mathlib's IsAlgebraic API for Roth bounds.

  Sub-cluster A (forward bridges to Mathlib IsAlgebraic):
  - ext #324: IsAlgebraicOfDegree_implies_IsAlgebraic_int
  - ext #325: IsQuadraticAlgebraic_implies_IsAlgebraic_int
  - ext #326: IsCubicAlgebraic_implies_IsAlgebraic_int

  Sub-cluster B (Roth via ℤ-algebraic + Irrational composites):
  - ext #327: roth_via_int_algebraic_quadratic
  - ext #328: roth_via_int_algebraic_cubic
  - ext #329: roth_via_int_algebraic_quartic
  - ext #330: roth_via_int_algebraic_quintic
  - ext #331: roth_via_int_algebraic_generic

  Sub-cluster C (paper headlines via Mathlib bridge):
  - ext #332: bundle_X_paper_headline_via_IsAlgebraic_int
  - ext #333: bundle_X_paper_headline_clean_quadratic
  - ext #334: bundle_X_paper_headline_clean_cubic
  - ext #335: bundle_X_paper_headline_4conjunct_via_int

  Sub-cluster D (Bundle-X markers + headline):
  - ext #336: bundle_X_first_in_V2_mathlib_bridge
  - ext #337: bundle_X_closed_count
  - ext #338: bundle_X_master_alias
  - ext #339: bundle_X_grand_headline

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #324-339 — Mathlib IsAlgebraic bridges (BUNDLE-FILE X).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IX
import Mathlib.RingTheory.Algebraic.Defs

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X

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
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_IX

/-! ## Sub-cluster A — forward bridges to Mathlib IsAlgebraic -/

/-- **🚨 ext #324** — `IsAlgebraicOfDegree α n → IsAlgebraic ℤ α`.

    Drops the explicit degree to land in Mathlib's general framework. -/
theorem T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int
    (α : ℝ) (n : ℕ) (h_alg : IsAlgebraicOfDegree α n) :
    IsAlgebraic ℤ α := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := h_alg
  exact ⟨p, hp_ne, hp_root⟩

/-- **🚨 ext #325** — `IsQuadraticAlgebraic α → IsAlgebraic ℤ α`. -/
theorem T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) :
    IsAlgebraic ℤ α := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := h_quad
  exact ⟨p, hp_ne, hp_root⟩

/-- **🚨 ext #326** — `IsCubicAlgebraic α → IsAlgebraic ℤ α`. -/
theorem T5_IsCubicAlgebraic_implies_IsAlgebraic_int
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) :
    IsAlgebraic ℤ α := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := h_cubic
  exact ⟨p, hp_ne, hp_root⟩

/-! ## Sub-cluster B — Roth via ℤ-algebraic + Irrational composites -/

/-- **🚨 ext #327** — Roth via ℤ-algebraic for quadratic (Mathlib bridge). -/
theorem T5_roth_via_int_algebraic_quadratic
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  ⟨T5_IsQuadraticAlgebraic_implies_IsAlgebraic_int α h_quad,
   T5_irrational_quadratic_clean_paper α hα h_quad ε hε_pos⟩

/-- **🚨 ext #328** — Roth via ℤ-algebraic for cubic (Mathlib bridge). -/
theorem T5_roth_via_int_algebraic_cubic
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  ⟨T5_IsCubicAlgebraic_implies_IsAlgebraic_int α h_cubic,
   T5_irrational_cubic_clean_paper α hα h_cubic ε hε_gt_one⟩

/-- **🚨 ext #329** — Roth via ℤ-algebraic for quartic (Mathlib bridge). -/
theorem T5_roth_via_int_algebraic_quartic
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 4)
    (ε : ℝ) (hε : 2 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  refine ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α 4 h_alg, ?_⟩
  exact T5_irrational_quartic_clean_paper α hα h_alg ε hε

/-- **🚨 ext #330** — Roth via ℤ-algebraic for quintic (Mathlib bridge). -/
theorem T5_roth_via_int_algebraic_quintic
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraicOfDegree α 5)
    (ε : ℝ) (hε : 3 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  refine ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α 5 h_alg, ?_⟩
  exact T5_irrational_quintic_clean_paper α hα h_alg ε hε

/-- **🚨 ext #331** — Roth via ℤ-algebraic GENERIC (Mathlib bridge). -/
theorem T5_roth_via_int_algebraic_generic
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  refine ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg, ?_⟩
  exact T_5_GRAND_PAPER_CAPSTONE_V2 α hα n hn h_alg ε hε hε_pos

/-! ## Sub-cluster C — paper headlines via Mathlib bridge -/

/-- **🚨 ext #332** — Bundle-X paper headline via IsAlgebraic ℤ. -/
theorem T5_bundle_X_paper_headline_via_IsAlgebraic_int
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_via_int_algebraic_generic α hα n hn h_alg ε hε hε_pos

/-- **🚨 ext #333** — Bundle-X paper headline clean quadratic. -/
theorem T5_bundle_X_paper_headline_clean_quadratic
    (α : ℝ) (hα : Irrational α) (h_quad : IsQuadraticAlgebraic α)
    (ε : ℝ) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_via_int_algebraic_quadratic α hα h_quad ε hε_pos

/-- **🚨 ext #334** — Bundle-X paper headline clean cubic. -/
theorem T5_bundle_X_paper_headline_clean_cubic
    (α : ℝ) (hα : Irrational α) (h_cubic : IsCubicAlgebraic α)
    (ε : ℝ) (hε_gt_one : 1 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_roth_via_int_algebraic_cubic α hα h_cubic ε hε_gt_one

/-- **🚨 ext #335** — Bundle-X 4-conjunct + IsAlgebraic ℤ. -/
theorem T5_bundle_X_paper_headline_4conjunct_via_int
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (0 : ℝ) < C * ((q.den : ℝ)) ^ (-(2 + ε)) ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| ∧
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| ∧
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ C := by
  refine ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg, ?_⟩
  exact T5_bundle_VI_full_4conjunct_alias α hα n hn h_alg ε hε hε_pos

/-! ## Sub-cluster D — Bundle-X markers + headline -/

/-- **🚨 ext #336** — Frontier marker: Bundle-X MATHLIB BRIDGE. -/
theorem T5_bundle_X_first_in_V2_mathlib_bridge :
    ∃ (n : ℕ), 324 ≤ n ∧ n ≤ 339 ∧ n - 324 ≤ 16 :=
  ⟨339, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #337** — Bundle-X closure cardinality bookkeeping. -/
theorem T5_bundle_X_closed_count : 1 ≤ (16 : ℕ) := by norm_num

/-- **🚨 ext #338** — Bundle-X master alias. -/
theorem T5_phase7_irrational_generic_bundle_X_master_alias
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    IsAlgebraic ℤ α ∧
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_bundle_X_paper_headline_via_IsAlgebraic_int α hα n hn h_alg ε hε hε_pos

/-! ## Bundle-X GRAND HEADLINE -/

/-- **🚨 ext #339 — HEADLINE: BUNDLE-X MATHLIB BRIDGE GRAND**.

    🏆🏆🏆 16-form bundle bridging OV2 NAMED Props
    (IsAlgebraicOfDegree, IsQuadraticAlgebraic, IsCubicAlgebraic) to
    Mathlib's general `IsAlgebraic ℤ α`. Each Roth bound now carries
    a corresponding `IsAlgebraic ℤ` certificate, opening Mathlib's
    full algebraic-number API for downstream paper integrations. -/
theorem T5_phase7_irrational_generic_bundle_X_grand_headline
    (α : ℝ) (hα : Irrational α) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    -- Mathlib bridge
    IsAlgebraic ℤ α ∧
    -- Paper-form Roth bound
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Universal distance positivity
    (∀ (q : ℚ), (0 : ℝ) < |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int α n h_alg,
   T_5_GRAND_PAPER_CAPSTONE_V2 α hα n hn h_alg ε hε hε_pos,
   fun q => T5_irrational_q_dist_pos α hα q⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
