/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicSchmidtKOneEpsGtOne

  T-5 (Roth's theorem) — **Phase 7 ext #169: Cubic Schmidt discharge
  for k=1 + ε > 1 (cubic+ chain partial discharge)**, sub session
  559qqqqqqqqq — STRICT critical-path #316 (T-5) Phase 7 ext #169.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Discharge of SchmidtAuxPolyExists conditions for IsCubicAlgebraic α
  with k=1 + ε > 1:

  For α : ℝ with IsCubicAlgebraic α and ε > 1:
  ∃ p ∈ ℤ[X] (degree 3), k = 1:
    - Roth budget: `1·(2+ε) > 3` ✓ (ext #168, since ε > 1)
    - Index ≥ 1 ↔ root condition (s122)
    - M_pos (s129 with k = 1 ≤ 3 = p.natDegree)

  PARTIAL discharge for cubic case (ε > 1 only).

  Single derivation:
  1. `T5_cubic_schmidt_k_one_eps_gt_one`: composes ext #168 + s122 + s129.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #169 — cubic Schmidt discharge for k=1 + ε > 1.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicAlgebraicEpsGtOneBudget
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicSchmidtKOneEpsGtOne

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicAlgebraicEpsGtOneBudget
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly

/-! ## Cubic Schmidt discharge for k=1 + ε > 1 -/

/-- **🚨 Wave T5 session 559qqqqqqqqq — Cubic Schmidt discharge k=1 + ε > 1**.

    For IsCubicAlgebraic α and ε > 1:
    ∃ p ∈ ℤ[X] (degree 3), all SchmidtAuxPolyExists conditions discharged
    with k = 1. -/
theorem T5_cubic_schmidt_k_one_eps_gt_one
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = 3 ∧
      ((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < (1 : ℕ) → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      (0 : ℝ) < ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
  obtain ⟨p, hp_ne, hp_root, hp_deg, hk_bound⟩ :=
    T5_cubic_algebraic_eps_gt_one_budget α h_cubic ε hε
  refine ⟨p, hp_ne, hp_root, hp_deg, hk_bound, ?_, ?_⟩
  · -- Index ≥ 1 ↔ root: applies ext #122 backward
    rw [T5_schmidt_index_one_iff_root]
    have h := hp_root
    rw [Polynomial.aeval_def] at h
    rw [← Polynomial.eval_map] at h
    convert h using 2
  · -- M_pos via ext #129 (k = 1 ≤ p.natDegree = 3)
    apply T5_taylor_M_positive_int_poly α p hp_ne 1
    rw [hp_deg]; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559qqqqqqqqq — T-5 Phase 7 ext #169**.

    🏆 PARTIAL DISCHARGE — cubic Schmidt discharge for k=1 + ε > 1.

    Strategy: ext #168 (Roth budget for ε > 1) + ext #122 (index ↔ root)
    + ext #129 (M-positivity).

    Combined with conditional capstone (s116/s117), gives UNCONDITIONAL
    Roth bound for cubic α with ε > 1. For ε ∈ (0, 1], need k ≥ 2 via
    Schmidt-Wirsing-Roth multivariate machinery (NOT here).

    Sub-lemma 342/N. Lean-core only. -/
theorem session_559qqqqqqqqq_T5_phase7_cubic_schmidt_k_one_eps_gt_one_headline
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = 3 ∧
      ((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < (1 : ℕ) → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      (0 : ℝ) < ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
  T5_cubic_schmidt_k_one_eps_gt_one α h_cubic ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicSchmidtKOneEpsGtOne
