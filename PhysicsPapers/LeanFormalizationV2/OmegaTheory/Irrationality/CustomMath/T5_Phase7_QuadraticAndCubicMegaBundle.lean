/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAndCubicMegaBundle

  T-5 (Roth's theorem) — **Phase 7 ext #172: Quadratic + Cubic mega
  bundle ULTRA-V6 (cubic+ chain unified)**, sub session 559ttttttttt
  — STRICT critical-path #316 (T-5) Phase 7 ext #172.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Unified quadratic + cubic Roth UNCONDITIONAL bundle:

  For α : ℝ:
  1. If `IsQuadraticAlgebraic α + Irrational α + ε > 0`: Roth-form
     UNCONDITIONAL via Schmidt path (s132 / s143 / s132 etc.).
  2. If `IsCubicAlgebraic α + ε > 1`: Roth-form UNCONDITIONAL via
     Schmidt path with k = 1 (s171).

  Single derivation:
  1. `T5_quadratic_and_cubic_mega_bundle`: 2-form ULTRA-V6 bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #172 — Quadratic + Cubic ULTRA-V6 mega bundle.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExistsCEpsGtOne

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAndCubicMegaBundle

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothExistsCSchmidt
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothExistsCEpsGtOne

/-! ## Quadratic + Cubic mega bundle -/

/-- **🚨 Wave T5 session 559ttttttttt — Quadratic + Cubic ULTRA-V6 mega bundle**.

    Two-form bundle:
    1. IsQuadraticAlgebraic α + ε > 0 → Roth-form
    2. IsCubicAlgebraic α + ε > 1 → Roth-form. -/
theorem T5_quadratic_and_cubic_mega_bundle (α : ℝ) :
    -- Form 1: Quadratic Roth UNCONDITIONAL (any ε > 0)
    (∀ (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (_hε : 0 < ε),
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: Cubic Roth UNCONDITIONAL (ε > 1 only)
    (∀ (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (_hε : 1 < ε),
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨fun h_quad ε hε => T5_quadratic_roth_exists_C_via_schmidt α (by
    obtain ⟨p, hp_ne, hp_root, hp_deg⟩ := h_quad
    exact ⟨p, hp_ne, hp_root, hp_deg⟩) ε hε,
   fun h_cubic ε hε => T5_cubic_roth_exists_C_eps_gt_one α h_cubic ε hε⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ttttttttt — T-5 Phase 7 ext #172**.

    🏆🏆🏆 ULTRA-V6 MEGA BUNDLE — Quadratic + Cubic Roth UNCONDITIONAL.

    Two forms:
    1. Quadratic UNCONDITIONAL (any ε > 0)
    2. Cubic UNCONDITIONAL (ε > 1 only)

    PARTIAL closure for cubic α: Schmidt-Wirsing-Roth k ≥ 2 needed for
    ε ∈ (0, 1].

    Sub-lemma 345/N. Lean-core only. -/
theorem session_559ttttttttt_T5_phase7_quadratic_and_cubic_mega_bundle_headline
    (α : ℝ) :
    (∀ (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (_hε : 0 < ε),
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    (∀ (h_cubic : IsCubicAlgebraic α) (ε : ℝ) (_hε : 1 < ε),
      ∃ (C : ℝ) (p : Polynomial ℤ),
        0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
        ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
          Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
          C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  T5_quadratic_and_cubic_mega_bundle α

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticAndCubicMegaBundle
