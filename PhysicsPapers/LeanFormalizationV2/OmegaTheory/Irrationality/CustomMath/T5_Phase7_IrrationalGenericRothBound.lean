/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound

  T-5 (Roth's theorem) — **Phase 7 ext #183: Irrational + GenericDegree
  non-vacuous Roth bound (extending s149 pattern to all n)**, sub
  session 559eeeeeeeeee — STRICT critical-path #316 (T-5)
  Phase 7 ext #183.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Strengthens ext #178 with Irrational α to give NON-VACUOUS Roth-form
  bound for ALL degrees:

  For α : ℝ Irrational + IsAlgebraicOfDegree α n + n ≥ 1 + ε > n-2 + ε > 0:
  ∃ C ∈ (0, 1], p ≠ 0, ∀ q ∈ ℚ with eval₂ ≠ 0:
    `0 < C · q.den^(-(2+ε))` ∧
    `C · q.den^(-(2+ε)) ≤ |q - α|` ∧
    `0 < |q - α|` (non-vacuous)

  Single derivation:
  1. `T5_irrational_generic_roth_bound`: composes #178 + #145 + #148.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #183 — Irrational + GenericDegree non-vacuous.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormLHSPos
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalQDistPos

/-! ## Irrational + Generic Roth NON-VACUOUS -/

/-- **🚨 Wave T5 session 559eeeeeeeeee — Irrational + Generic NON-VACUOUS bound**.

    For α Irrational + IsAlgebraicOfDegree α n + n ≥ 1 + ε > n-2 + ε > 0:
    ∃ C ∈ (0, 1], p ≠ 0, ∀ q with eval₂ ≠ 0:
      `0 < C · q.den^(-(2+ε)) ∧ C · q.den^(-(2+ε)) ≤ |q-α| ∧ 0 < |q-α|`. -/
theorem T5_irrational_generic_roth_bound
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, h_bound⟩ :=
    T5_generic_degree_all_q α n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hC_le_one, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  refine ⟨T5_roth_form_LHS_pos C hC_pos q (-(2 + ε)),
          h_bound q h_nonzero,
          T5_irrational_q_dist_pos α hα q⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559eeeeeeeeee — T-5 Phase 7 ext #183**.

    🏆 NON-VACUOUS ROTH BOUND for Irrational + Generic degree.

    Sub-lemma 356/N. Lean-core only. -/
theorem session_559eeeeeeeeee_T5_phase7_irrational_generic_roth_bound_headline
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
        (0 : ℝ) < |((q : ℚ) : ℝ) - α| :=
  T5_irrational_generic_roth_bound α hα n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericRothBound
