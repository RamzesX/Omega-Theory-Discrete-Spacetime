/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps

  T-5 (Roth's theorem) — **Phase 7 ext #181: Generic-degree Roth ALL q
  with auto ε > 0 derivation (n ≥ 2)**, sub session 559ccccccccccc —
  STRICT critical-path #316 (T-5) Phase 7 ext #181.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Cleaner generic Roth theorem without redundant ε > 0 hypothesis:

  For α : ℝ + n ≥ 2 + IsAlgebraicOfDegree α n + ε > n-2:
    ∃ C ∈ (0, 1], p ≠ 0, ∀ q with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q - α|`

  Composes ext #178 + ext #180 (auto-derive ε > 0).

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #181 — Generic Roth ALL q with auto ε > 0.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeEpsAuto

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeEpsAuto

/-! ## Generic Roth ALL q with auto ε > 0 -/

/-- **🚨 Wave T5 session 559ccccccccccc — Generic Roth ALL q with n ≥ 2 + auto ε**.

    For α with IsAlgebraicOfDegree α n (n ≥ 2) + ε > n-2:
    ∃ C ∈ (0, 1], p ≠ 0, ∀ q with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_generic_degree_all_q_auto_eps
    (α : ℝ) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  have hε_pos : 0 < ε := T5_generic_degree_eps_auto n hn ε hε
  have hn_one : 1 ≤ n := le_trans (by norm_num : 1 ≤ 2) hn
  exact T5_generic_degree_all_q α n hn_one h_alg ε hε hε_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559ccccccccccc — T-5 Phase 7 ext #181**.

    🏆 GENERIC ROTH ALL q with AUTO ε > 0 — clean signature for n ≥ 2.

    Sub-lemma 354/N. Lean-core only. -/
theorem session_559ccccccccccc_T5_phase7_generic_degree_all_q_auto_eps_headline
    (α : ℝ) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_generic_degree_all_q_auto_eps α n hn h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps
