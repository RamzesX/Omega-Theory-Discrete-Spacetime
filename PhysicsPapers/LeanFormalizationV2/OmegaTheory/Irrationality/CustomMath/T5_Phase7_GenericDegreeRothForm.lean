/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothForm

  T-5 (Roth's theorem) — **Phase 7 ext #175: Generic-degree Roth-form
  UNCONDITIONAL for ε > n-2**, sub session 559wwwwwwwww —
  STRICT critical-path #316 (T-5) Phase 7 ext #175.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Generic Roth-form bound for ANY n ≥ 2 algebraic α with ε > n-2:

  For α with IsAlgebraicOfDegree α n (n ≥ 1) and ε > n-2:
  ∃ p, M > 0, ∀ q close to α with eval₂ ≠ 0:
    `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`

  Generalizes ext #170 (cubic n=3, ε>1) to all n ≥ 1.

  Single derivation:
  1. `T5_generic_degree_roth_form`: composes ext #174 + s116.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #175 — Generic-degree Roth-form UNCONDITIONAL ε > n-2.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeSchmidtKOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothForm

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeSchmidtKOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

/-! ## Generic-degree Roth-form -/

/-- **🚨 Wave T5 session 559wwwwwwwww — Generic Roth-form UNCONDITIONAL for ε > n-2**.

    For α with IsAlgebraicOfDegree α n (n ≥ 1) and ε > n-2 + ε > 0:
    ∃ p, M > 0, ∀ q close to α with eval₂ ≠ 0:
      `M^(-1) · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_generic_degree_roth_form
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  obtain ⟨p, hp_ne, hp_root, hp_deg, hk_bound, h_index, h_M_pos⟩ :=
    T5_generic_degree_schmidt_k_one α n hn h_alg ε hε
  set M := ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| with hM_def
  refine ⟨p, M, h_M_pos, hp_ne, hp_root, ?_⟩
  intros q h_close h_nonzero
  exact T5_cubic_roth_form_bound α p 1 (le_refl _) h_index ε hε_pos
          hk_bound q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559wwwwwwwww — T-5 Phase 7 ext #175**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #175.

    🏆 GENERIC ROTH-FORM UNCONDITIONAL for ANY n ≥ 1, ε > max(0, n-2).

    Generalizes:
    - n = 2 (quadratic): ε > 0 (s131)
    - n = 3 (cubic): ε > 1 (s170)
    - n ≥ 4 (quartic+): ε > n-2 (NEW)

    Sub-lemma 348/N. Lean-core only. -/
theorem session_559wwwwwwwww_T5_phase7_generic_degree_roth_form_headline
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n)
    (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) (hε_pos : 0 < ε) :
    ∃ (p : Polynomial ℤ) (M : ℝ),
      0 < M ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        M ^ (-(1 / ((1 : ℕ) : ℝ))) * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_generic_degree_roth_form α n hn h_alg ε hε hε_pos

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothForm
