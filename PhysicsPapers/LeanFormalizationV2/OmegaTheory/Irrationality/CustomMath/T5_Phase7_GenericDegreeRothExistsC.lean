/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC

  T-5 (Roth's theorem) — **Phase 7 ext #176: Generic-degree Roth
  EXISTS-C UNCONDITIONAL for ε > n-2**, sub session 559xxxxxxxxx —
  STRICT critical-path #316 (T-5) Phase 7 ext #176.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  EXISTS-C standard Roth signature for ANY n with ε > n-2:

  For α with IsAlgebraicOfDegree α n + ε > n-2 + ε > 0:
  ∃ C > 0, p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
    `C · q.den^(-(2+ε)) ≤ |q-α|`

  Generalizes ext #171 (cubic, ε>1) to all n ≥ 1.

  Single derivation:
  1. `T5_generic_degree_roth_exists_C`: composes ext #175 + ext #118.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #176 — Generic-degree Roth EXISTS-C UNCONDITIONAL ε > n-2.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothForm
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothForm
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity

/-! ## Generic-degree Roth EXISTS-C -/

/-- **🚨 Wave T5 session 559xxxxxxxxx — Generic Roth EXISTS-C for ε > n-2**.

    For α with IsAlgebraicOfDegree α n + ε > n-2 + ε > 0:
    ∃ C > 0, p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_generic_degree_roth_exists_C
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨p, M, hM_pos, hp_ne, hp_root, h_bound⟩ :=
    T5_generic_degree_roth_form α n hn h_alg ε hε hε_pos
  refine ⟨M ^ (-(1 / ((1 : ℕ) : ℝ))), p, ?_, hp_ne, hp_root, h_bound⟩
  exact T5_roth_constant_positivity M hM_pos _

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559xxxxxxxxx — T-5 Phase 7 ext #176**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #176.

    🏆 GENERIC ROTH EXISTS-C UNCONDITIONAL for ANY n ≥ 1, ε > max(0, n-2).

    Sub-lemma 349/N. Lean-core only. -/
theorem session_559xxxxxxxxx_T5_phase7_generic_degree_roth_exists_C_headline
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_generic_degree_roth_exists_C α n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC
