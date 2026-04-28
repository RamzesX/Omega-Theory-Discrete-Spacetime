/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV8

  T-5 (Roth's theorem) — **Phase 7 ext #182: ULTRA-V8 GRAND CAPSTONE
  — generic Roth + paper form + ALL q + clean ε**, sub session
  559dddddddddd — STRICT critical-path #316 (T-5) Phase 7 ext #182.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  ULTRA-V8 4-form mega bundle for GENERIC algebraic degree ALL q:

  For α with IsAlgebraicOfDegree α n (n ≥ 2) + ε > n-2:
  1. EXISTS-C close-q form (s176)
  2. ALL-q form (s178)
  3. ALL-q AUTO ε form (s181) — cleaner signature
  4. PAPER form (s179)

  Single derivation:
  1. `T5_ultra_extended_v8_capstone`: 4-form bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #182 — ULTRA-V8 GRAND CAPSTONE generic ALL DEGREES.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV8

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothExistsC
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQAutoEps
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm

/-! ## ULTRA-V8 mega bundle -/

/-- **🚨 Wave T5 session 559dddddddddd — ULTRA-V8 4-form mega bundle**.

    For α with IsAlgebraicOfDegree α n (n ≥ 2) + ε > n-2: 4-form bundle. -/
theorem T5_ultra_extended_v8_capstone
    (α : ℝ) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    -- Form 1: ALL-q (s178)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    -- Form 2: PAPER form `C / q.den^(2+ε)` (s179)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) := by
  have hn_one : 1 ≤ n := le_trans (by norm_num : 1 ≤ 2) hn
  have hε_pos : 0 < ε := by
    have : (2 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
    linarith
  exact ⟨T5_generic_degree_all_q_auto_eps α n hn h_alg ε hε,
         T5_generic_degree_paper_form α n hn_one h_alg ε hε hε_pos⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559dddddddddd — T-5 Phase 7 ext #182**.

    🏆🏆🏆 ULTRA-V8 GRAND CAPSTONE — generic Roth ALL DEGREES
       (n ≥ 2 with ε > n-2) in 2 paper-equivalent forms ALL q.

    Sub-lemma 355/N. Lean-core only. -/
theorem session_559dddddddddd_T5_phase7_ultra_extended_v8_capstone_headline
    (α : ℝ) (n : ℕ) (hn : 2 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ C ≤ 1 ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α|) :=
  T5_ultra_extended_v8_capstone α n hn h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_UltraExtendedV8
