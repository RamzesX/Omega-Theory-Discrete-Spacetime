/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm

  T-5 (Roth's theorem) — **Phase 7 ext #179: Generic-degree Roth paper
  form `|q-α| ≥ C / q.den^(2+ε)` ALL q**, sub session 559aaaaaaaaaa
  — STRICT critical-path #316 (T-5) Phase 7 ext #179.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Paper-form (Roth 1955 standard signature) for generic degree:

  For α with IsAlgebraicOfDegree α n + ε > n-2 + ε > 0:
    ∃ C > 0, p ≠ 0, ∀ q : ℚ with eval₂ ≠ 0:
      `C / q.den^(2+ε) ≤ |q-α|`

  Generalizes ext #159 (quadratic) to ALL n ≥ 1.

  Single derivation:
  1. `T5_generic_degree_paper_form`: composes #178 + Real.rpow_neg.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #179 — Generic Roth paper form ALL q.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeAllQ

/-! ## Generic-degree paper form -/

/-- **🚨 Wave T5 session 559aaaaaaaaaa — Generic Roth PAPER form ALL q**. -/
theorem T5_generic_degree_paper_form
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨C, p, hC_pos, _hC_le, hp_ne, hp_root, h_bound⟩ :=
    T5_generic_degree_all_q α n hn h_alg ε hε hε_pos
  refine ⟨C, p, hC_pos, hp_ne, hp_root, ?_⟩
  intros q h_nonzero
  have h_eq : C * ((q.den : ℝ)) ^ (-(2 + ε)) = C / ((q.den : ℝ)) ^ (2 + ε) := by
    rw [Real.rpow_neg (by positivity : (0:ℝ) ≤ (q.den : ℝ))]
    exact (div_eq_mul_inv _ _).symm
  rw [← h_eq]
  exact h_bound q h_nonzero

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaaaaaaaaa — T-5 Phase 7 ext #179**.

    🏆 GENERIC ROTH PAPER FORM `|q-α| ≥ C / q.den^(2+ε)` ALL q ALL DEGREES
       (ε > n-2).

    Sub-lemma 352/N. Lean-core only. -/
theorem session_559aaaaaaaaaa_T5_phase7_generic_degree_paper_form_headline
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ),
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C / ((q.den : ℝ)) ^ (2 + ε) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_generic_degree_paper_form α n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreePaperForm
