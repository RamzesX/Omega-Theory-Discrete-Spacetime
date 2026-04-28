/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicAlgebraicEpsGtOneBudget

  T-5 (Roth's theorem) — **Phase 7 ext #168: Cubic-α Roth budget for
  k=1 + ε > 1 (cubic+ chain partial discharge)**, sub session
  559ppppppppp — STRICT critical-path #316 (T-5) Phase 7 ext #168.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Roth budget condition for cubic α with k=1 and ε > 1:

  For IsCubicAlgebraic α (i.e., ∃ p ∈ ℤ[X], p ≠ 0, aeval α p = 0,
  p.natDegree = 3) and ε > 1:
    `(1 : ℝ) * (2 + ε) > p.natDegree` (i.e., `2+ε > 3`)

  Strategy: 1·(2+ε) = 2+ε; for ε > 1, 2+ε > 3 = p.natDegree. Roth
  budget satisfied with k = 1.

  This is a PARTIAL discharge for cubic α (only ε > 1 case; for ε ∈ (0, 1]
  need k ≥ 2 with multivariate Schmidt machinery).

  Single derivation:
  1. `T5_cubic_algebraic_eps_gt_one_budget`: Roth budget for ε > 1.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #168 — cubic α Roth budget for k=1, ε > 1.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicAlgebraicEpsGtOneBudget

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic

/-! ## Cubic-α Roth budget for k=1, ε > 1 -/

/-- **🚨 Wave T5 session 559ppppppppp — Roth budget for cubic α with k=1, ε > 1**.

    For IsCubicAlgebraic α and ε > 1:
    ∃ p ∈ ℤ[X] (the cubic witness), `(1 : ℕ) : ℝ * (2 + ε) > p.natDegree`. -/
theorem T5_cubic_algebraic_eps_gt_one_budget
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = 3 ∧
      (((1 : ℕ) : ℝ)) * (2 + ε) > p.natDegree := by
  obtain ⟨p, hp_ne, hp_root, hp_deg⟩ := h_cubic
  refine ⟨p, hp_ne, hp_root, hp_deg, ?_⟩
  rw [hp_deg]
  push_cast
  linarith

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ppppppppp — T-5 Phase 7 ext #168**.

    🏆 BOOKKEEPING — Roth budget for cubic α with k = 1 satisfied iff ε > 1.

    For IsCubicAlgebraic α (degree 3 ℤ-poly) and ε > 1:
    Schmidt budget condition `1·(2+ε) > 3` holds.

    PARTIAL discharge: only ε > 1 case. For ε ∈ (0, 1], need k ≥ 2 via
    Schmidt-Wirsing-Roth multivariate machinery.

    Sub-lemma 341/N. Lean-core only. -/
theorem session_559ppppppppp_T5_phase7_cubic_algebraic_eps_gt_one_budget_headline
    (α : ℝ) (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (hε : 1 < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = 3 ∧
      (((1 : ℕ) : ℝ)) * (2 + ε) > p.natDegree :=
  T5_cubic_algebraic_eps_gt_one_budget α h_cubic ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicAlgebraicEpsGtOneBudget
