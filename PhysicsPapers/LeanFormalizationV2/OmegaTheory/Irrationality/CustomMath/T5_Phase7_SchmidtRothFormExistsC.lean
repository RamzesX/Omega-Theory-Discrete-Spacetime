/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormExistsC

  T-5 (Roth's theorem) — **Phase 7 ext #119: Schmidt → Roth-form
  EXISTS-C form (cubic+ chain existential capstone)**, sub session
  559sssssss — STRICT critical-path #316 (T-5) Phase 7 ext #119.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Repackages the Schmidt → Roth-form conditional capstone (ext #117) into
  the EXISTS-C form matching standard Roth signatures:

  Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0,
  ∃ C > 0, ∃ p ≠ 0 (with α annihilator), ∀ q close to α with eval₂ ≠ 0:
    `C · q.den^(-(2+ε)) ≤ |q-α|`

  This is the EXISTENCE form (Roth-form) — direct match for
  `RothBoundExists` Prop signatures.

  Single derivation:
  1. `T5_schmidt_roth_form_exists_C`: composes s117 + C extraction.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #119 — Schmidt → Roth-form EXISTS-C capstone.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormExistsC

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothConstantPositivity
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothFormBound

/-! ## Existence-form capstone -/

/-- **🚨 Wave T5 session 559sssssss — Schmidt → Roth-form EXISTS-C capstone**.

    Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0:
    ∃ C > 0, ∃ p ≠ 0 (annihilating α), ∀ q close to α with eval₂ ≠ 0:
      `C · q.den^(-(2+ε)) ≤ |q-α|`. -/
theorem T5_schmidt_roth_form_exists_C
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| := by
  -- Apply h_schmidt ONCE to get the witness with M_pos
  obtain ⟨p, k, hp_ne, hp_root, hk_bound, h_index, h_M_pos⟩ :=
    h_schmidt α hα h_alg ε hε
  -- Need k ≥ 1: from hk_bound `(k : ℝ) * (2+ε) > p.natDegree` and (p.natDegree : ℝ) ≥ 0
  have hk : 1 ≤ k := by
    by_contra hk_nope
    push_neg at hk_nope
    interval_cases k
    have h_nn : (0 : ℝ) ≤ (p.natDegree : ℝ) := by exact_mod_cast Nat.zero_le _
    simp only [Nat.cast_zero, zero_mul] at hk_bound
    linarith
  -- Roth constant C := M^(-1/k)
  set M := ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| with hM_def
  refine ⟨M ^ (-(1 / (k : ℝ))), p, ?_, hp_ne, hp_root, ?_⟩
  · -- C > 0
    exact T5_roth_constant_neg_inv_k_pos M h_M_pos k
  · -- bound: apply s116 directly with the (p, k) witness
    intros q h_close h_nonzero
    exact T5_cubic_roth_form_bound α p k hk h_index ε hε hk_bound q h_close h_nonzero h_M_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559sssssss — T-5 Phase 7 ext #119:
    Schmidt → Roth-form EXISTS-C capstone**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #119.

    🏆 EXISTENCE-FORM ROTH BOUND — `∃ C > 0, ∃ p ≠ 0, ∀ q…`.

    Single derivation:
    1. `T5_schmidt_roth_form_exists_C` — existence form Roth bound.

    Strategy: extract Schmidt witness (p', k') from h_schmidt; show k' ≥ 1
    (via Roth budget contradicting k = 0); apply ext #116 directly with
    (p', k') witness; package M^(-1/k') as the Roth constant C, with
    positivity from ext #118.

    This signature directly matches `∃ C > 0, ∃ p, ...` style of standard
    Roth bounds. Combined with Schmidt aux poly discharge (multi-day),
    yields unconditional Roth.

    Mathlib usage: composition of ext #117 + ext #118 + ext #116.

    Sub-lemma 292/N in T-1 (T-5 Phase 7 ext #119).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 EXISTENCE-FORM Roth conditional capstone.
       Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559sssssss_T5_phase7_schmidt_roth_form_exists_C_headline
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    ∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α| :=
  T5_schmidt_roth_form_exists_C h_schmidt α hα h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormExistsC
