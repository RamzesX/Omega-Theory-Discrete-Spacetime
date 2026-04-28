/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExistsCEpsGtOne

  T-5 (Roth's theorem) — **Phase 7 ext #171: Cubic Roth EXISTS-C
  UNCONDITIONAL for ε > 1**, sub session 559sssssssss —
  STRICT critical-path #316 (T-5) Phase 7 ext #171.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  EXISTS-C standard form of cubic Roth for ε > 1:

  For α : ℝ Irrational with IsCubicAlgebraic α and ε > 1:
    ∃ C > 0, p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q-α|`

  Single derivation:
  1. `T5_cubic_roth_exists_C_eps_gt_one`: composes ext #170 + ext #118.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #171 — Cubic Roth EXISTS-C for ε > 1.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormEpsGtOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExistsCEpsGtOne

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormEpsGtOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

/-! ## Cubic Roth EXISTS-C for ε > 1 -/

/-- **🚨 Wave T5 session 559sssssssss — Cubic Roth EXISTS-C for ε > 1**.

    For IsCubicAlgebraic α and ε > 1:
    ∃ C > 0, p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_cubic_roth_exists_C_eps_gt_one
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨p, M, hM_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_cubic_roth_form_eps_gt_one α h_cubic ε hε
  refine ⟨M ^ (-(1 / ((1 : ℕ) : ℝ))), p, ?_, hp_ne, hp_root, h_bound⟩
  exact T5_roth_constant_positivity M hM_pos _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559sssssssss — T-5 Phase 7 ext #171**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #171.

    🏆 CUBIC ROTH UNCONDITIONAL EXISTS-C for ε > 1.

    Strategy: composes ext #170 + ext #118 (Roth constant positivity).

    PARTIAL closure: ε > 1 case for cubic. Schmidt-Wirsing-Roth multivariate
    machinery (k ≥ 2) needed for ε ∈ (0, 1].

    Sub-lemma 344/N. Lean-core only. -/
theorem session_559sssssssss_T5_phase7_cubic_roth_exists_C_eps_gt_one_headline
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_cubic_roth_exists_C_eps_gt_one α h_cubic ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExistsCEpsGtOne
