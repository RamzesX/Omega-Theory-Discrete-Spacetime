/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant

  T-5 (Roth's theorem) — **Phase 7 ext #143: Quadratic Roth UNCONDITIONAL
  with TIGHT C ∈ (0, 1] constant**, sub session 559qqqqqqqq —
  STRICT critical-path #316 (T-5) Phase 7 ext #143.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Strengthens ext #132 (UNCONDITIONAL quadratic Roth EXISTS-C) with the
  TIGHT bound `C ∈ (0, 1]`:

  For α : ℝ with `IsQuadraticAlgebraic α` and ε > 0:
    ∃ C, p, `0 < C ∧ C ≤ 1` ∧ p ≠ 0 ∧ aeval α p = 0 ∧
      ∀ q close to α with eval₂ ≠ 0:
        `C · q.den^(-(2+ε)) ≤ |q-α|`

  Single derivation:
  1. `T5_quadratic_roth_tight_constant`: composes s130 + s116 + s140 + s142.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  Per anti-pattern lock 2026-04-29: NO STUBS — full prove mode.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #143 — quadratic Roth UNCONDITIONAL TIGHT C ∈ (0, 1].
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsQuadraticAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyQuadraticWitness
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantBounded

/-! ## Quadratic Roth TIGHT C ∈ (0, 1] -/

/-- **🚨 Wave T5 session 559qqqqqqqq — Quadratic Roth UNCONDITIONAL with C ∈ (0, 1]**.

    For α with `IsQuadraticAlgebraic α` and ε > 0:
    ∃ C, p, `0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ aeval α p = 0 ∧
    ∀ q close to α with eval₂ ≠ 0: C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_quadratic_roth_tight_constant
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  -- Single extraction from IsQuadraticAlgebraic witness
  obtain ⟨p, hp_ne, hp_root, hp_deg⟩ := h_quad
  -- Apply s130 to discharge Schmidt conditions for k = 1
  obtain ⟨hk_bound, h_index, h_M_pos⟩ :=
    T5_schmidt_aux_poly_quadratic_witness α p hp_ne hp_root hp_deg ε hε
  -- M ≥ 1 from integer-coeff strength (s140) since k = 1 ≤ 2 = p.natDegree
  have h_M_ge_one : (1 : ℝ) ≤
      ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
          |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
    apply T5_taylor_M_ge_one_int_poly α p hp_ne 1
    rw [hp_deg]; norm_num
  -- Roth constant C := M^(-(1/(1:ℝ))) = M^(-1)
  -- C ∈ (0, 1] by ext #142
  obtain ⟨h_C_pos, h_C_le_one⟩ := T5_roth_constant_in_zero_one _ h_M_ge_one 1 (le_refl _)
  refine ⟨_, p, h_C_pos, h_C_le_one, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  -- Apply s116 Roth-form bound with k = 1
  exact T5_cubic_roth_form_bound α p 1 (le_refl _) h_index ε hε
          hk_bound q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559qqqqqqqq — T-5 Phase 7 ext #143**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #143.

    🏆 QUADRATIC ROTH UNCONDITIONAL with TIGHT C ∈ (0, 1].

    Single derivation:
    1. `T5_quadratic_roth_tight_constant` — UNCONDITIONAL with `0 < C ∧ C ≤ 1`.

    Strategy: single extraction from IsQuadraticAlgebraic witness; apply
    s130 (Schmidt discharge), s140 (M ≥ 1 from integer leading-coeff
    strength), s142 (Roth constant ∈ (0, 1] tight bundle), s116 (Roth-form
    bound) with the unified (p, k=1) witness.

    Avoids the C13 pitfall (double-obtain from existential gives different
    witnesses) by using single extraction throughout.

    Sub-lemma 316/N. Lean-core only.

    🏆 First Lean-core T-5 Phase 7 QUADRATIC ROTH with TIGHT C ∈ (0, 1].
       Standard Roth signature with normalized constant. Escanor Pride +
       Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559qqqqqqqq_T5_phase7_quadratic_roth_tight_constant_headline
    (α : ℝ) (h_quad : IsQuadraticAlgebraic α) (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_quadratic_roth_tight_constant α h_quad ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_QuadraticRothTightConstant
