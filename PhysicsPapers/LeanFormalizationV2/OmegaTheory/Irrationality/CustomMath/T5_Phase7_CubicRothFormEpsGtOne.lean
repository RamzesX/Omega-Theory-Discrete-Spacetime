/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormEpsGtOne

  T-5 (Roth's theorem) — **Phase 7 ext #170: Cubic Roth-form
  UNCONDITIONAL for ε > 1 (cubic+ chain partial closure)**, sub
  session 559rrrrrrrrr — STRICT critical-path #316 (T-5)
  Phase 7 ext #170.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  UNCONDITIONAL Roth-form bound for IsCubicAlgebraic α and ε > 1:

  For α : ℝ Irrational with IsCubicAlgebraic α and ε > 1:
    ∃ p, M > 0 (the coefficient sum), ∀ q close to α with eval₂ ≠ 0:
      `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`

  PARTIAL closure: only ε > 1 case for cubic. For ε ∈ (0, 1], Schmidt-
  Wirsing-Roth multivariate machinery needed (k ≥ 2).

  Single derivation:
  1. `T5_cubic_roth_form_eps_gt_one`: composes ext #169 + s116.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #170 — Cubic Roth-form UNCONDITIONAL for ε > 1.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicSchmidtKOneEpsGtOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormEpsGtOne

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicSchmidtKOneEpsGtOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

/-! ## Cubic Roth-form UNCONDITIONAL for ε > 1 -/

/-- **🚨 Wave T5 session 559rrrrrrrrr — Cubic Roth-form UNCONDITIONAL for ε > 1**.

    For IsCubicAlgebraic α and ε > 1:
    ∃ p, M > 0, ∀ q close to α with eval₂ ≠ 0:
      `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_cubic_roth_form_eps_gt_one
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  -- Get cubic witness with Schmidt conditions discharged for k = 1
  obtain ⟨p, hp_ne, hp_root, hp_deg, hk_bound, h_index, h_M_pos⟩ :=
    T5_cubic_schmidt_k_one_eps_gt_one α h_cubic ε hε
  -- Need ε > 0 (from hε : 1 < ε)
  have hε_pos : 0 < ε := lt_trans (by norm_num : (0:ℝ) < 1) hε
  -- M from the sum
  set M := ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| with hM_def
  refine ⟨p, M, h_M_pos, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  -- Apply s116 Roth-form bound with k = 1
  exact T5_cubic_roth_form_bound α p 1 (le_refl _) h_index ε hε_pos
          hk_bound q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559rrrrrrrrr — T-5 Phase 7 ext #170**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #170.

    🏆 CUBIC ROTH UNCONDITIONAL for ε > 1 — first cubic-α Roth-form bound!

    Strategy: composes ext #169 (Schmidt discharge k=1 ε > 1) + ext #116
    (Roth-form bound).

    PARTIAL closure: only ε > 1 case (Roth budget `1·(2+ε) > 3` requires
    ε > 1). For ε ∈ (0, 1], need Schmidt-Wirsing-Roth k ≥ 2 machinery.

    Sub-lemma 343/N. Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cubic Roth-form bound (ε > 1). Cubic+
       extension toward full unconditional Roth. -/
theorem session_559rrrrrrrrr_T5_phase7_cubic_roth_form_eps_gt_one_headline
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_cubic_roth_form_eps_gt_one α h_cubic ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormEpsGtOne
