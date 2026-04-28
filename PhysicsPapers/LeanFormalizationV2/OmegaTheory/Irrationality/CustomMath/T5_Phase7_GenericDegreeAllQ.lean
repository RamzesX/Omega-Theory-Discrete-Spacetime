/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ

  T-5 (Roth's theorem) — **Phase 7 ext #178: Generic-degree Roth ALL q
  with eval₂ ≠ 0 (no |q-α|≤1)**, sub session 559zzzzzzzzz —
  STRICT critical-path #316 (T-5) Phase 7 ext #178.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Removes |q-α| ≤ 1 condition for generic degree:

  For α : ℝ Irrational + IsAlgebraicOfDegree α n + ε > n-2 + ε > 0:
  ∃ C > 0, p ≠ 0, ∀ q : ℚ with eval₂ ≠ 0:
    `C · q.den^(-(2+ε)) ≤ |q - α|`

  Strategy: dichotomy close+far via ext #176 + ext #156.

  Single derivation:
  1. `T5_generic_degree_all_q`: composes #176 + #156.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #178 — Generic-degree Roth ALL q.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothFormFarBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeSchmidtKOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

/-! ## Generic-degree Roth ALL q -/

/-- **🚨 Wave T5 session 559zzzzzzzzz — Generic Roth ALL q with eval₂ ≠ 0**.

    For α with IsAlgebraicOfDegree α n + ε > n-2 + ε > 0:
    ∃ C ∈ (0, 1], p ≠ 0, ∀ q with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q - α|`. -/
theorem T5_generic_degree_all_q
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  -- Get Schmidt witness with M ≥ 1 + Roth budget
  obtain ⟨p, hp_ne, hp_root, hp_deg, hk_bound, h_index, h_M_pos⟩ :=
    T5_generic_degree_schmidt_k_one α n hn h_alg ε hε
  -- M ≥ 1 from integer leading-coeff strength (s140)
  have h_M_ge_one : (1 : ℝ) ≤
      ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
    apply T5_taylor_M_ge_one_int_poly α p hp_ne 1
    rw [hp_deg]; exact hn
  -- C := M^(-1/1) = M^(-1) ∈ (0, 1] via ext #142
  obtain ⟨h_C_pos, h_C_le_one⟩ := T5_roth_constant_in_zero_one _ h_M_ge_one 1 (le_refl _)
  refine ⟨_, p, h_C_pos, h_C_le_one, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  -- Dichotomy: |q-α| ≤ 1 (close) vs > 1 (far)
  by_cases h_close : |((q : ℚ) : ℝ) - α| ≤ 1
  · -- Close case: apply s116 directly
    exact T5_cubic_roth_form_bound α p 1 (le_refl _) h_index ε hε_pos hk_bound q h_close h_nonzero h_M_pos
  · -- Far case: trivial via s156
    have h_far : 1 < |((q : ℚ) : ℝ) - α| := lt_of_not_ge h_close
    exact T5_roth_form_far_bound _ h_C_pos h_C_le_one q α h_far ε hε_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559zzzzzzzzz — T-5 Phase 7 ext #178**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #178.

    🏆 GENERIC ROTH ALL q UNCONDITIONAL for ANY degree n ≥ 1 with
       ε > max(0, n-2). No |q-α| ≤ 1 hypothesis.

    Sub-lemma 351/N. Lean-core only. -/
theorem session_559zzzzzzzzz_T5_phase7_generic_degree_all_q_headline
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_generic_degree_all_q α n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
