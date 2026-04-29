/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_PartialInductiveStepAlt

  T-5 (Roth's theorem) — **Phase 7 Wave-2 Phase 2.2 PARTIAL INDUCTIVE
  STEP via alt-witnesses** — uses the m=2-alt and m=3-alt direct
  constructions to provide a partial discharge of
  `T5_RothWronskianInductiveStep` for `m+1 ∈ {2, 3}` (i.e., `m ∈ {1, 2}`)
  using the cleaner `det = X_0 · P^m` formula.

  Single-thread hand-authored 2026-04-29.

  Per project rule §7.0 NO STUBS.
-/

import Mathlib.Tactic.IntervalCases
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_PartialInductiveStepAlt

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_InductiveSetup
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_WronskianNonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_NonVanish
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M2_AltWitness
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_M3_AltWitness

/-! ## m=2 Alt Witness instance of Wronskian non-vanish -/

theorem T5_RothWronskian_m2_alt
    (P : MvPolynomial (Fin 2) ℝ) (hP : P ≠ 0)
    (R : Fin 2 → ℕ) (_h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i) :
    ∃ (J : Fin 2 → (Fin 2 → ℕ)),
      (∀ i k, J i k ≤ R k) ∧
      mvPolyWronskian 2 P J ≠ 0 := by
  refine ⟨m2_alt_witness_J, ?_, T5_m2_alt_wronskian_ne_zero P hP⟩
  intro i k
  unfold m2_alt_witness_J
  by_cases h_i : i = 0
  · simp [h_i]
  · simp [h_i]
    by_cases h_k : k = 1
    · simp [h_k]; exact h_R_pos 1
    · simp [h_k]

/-! ## m=3 Alt Witness instance of Wronskian non-vanish -/

theorem T5_RothWronskian_m3_alt
    (P : MvPolynomial (Fin 3) ℝ) (hP : P ≠ 0)
    (R : Fin 3 → ℕ) (_h_deg : ∀ i, MvPolynomial.degreeOf i P ≤ R i)
    (h_R_pos : ∀ i, 0 < R i) :
    ∃ (J : Fin 3 → (Fin 3 → ℕ)),
      (∀ i k, J i k ≤ R k) ∧
      mvPolyWronskian 3 P J ≠ 0 := by
  refine ⟨m3_alt_witness_J, ?_, T5_m3_alt_wronskian_ne_zero P hP⟩
  intro i k
  unfold m3_alt_witness_J
  by_cases h_i0 : i = 0
  · simp [h_i0]
  · by_cases h_i1 : i = 1
    · simp [h_i0, h_i1]
      by_cases h_k : k = 1
      · simp [h_k]; exact h_R_pos 1
      · simp [h_k]
    · simp [h_i0, h_i1]
      by_cases h_k : k = 2
      · simp [h_k]; exact h_R_pos 2
      · simp [h_k]

/-! ## Combined m ≤ 3 ALT closure -/

/-- **m ≤ 3 ALT-witness Wronskian non-vanish**. -/
theorem T5_RothWronskian_m_le_3_alt_unconditional :
    ∀ {m : ℕ}, 0 < m → m ≤ 3 →
    ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
      P ≠ 0 →
      (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
      (∀ i, 0 < R i) →
    ∃ (J : Fin m → (Fin m → ℕ)),
      (∀ i k, J i k ≤ R k) ∧
      mvPolyWronskian m P J ≠ 0 := by
  intros m hm hm_le P R hP h_deg h_R_pos
  interval_cases m
  · exact T5_RothWronskian_base_m1 P hP R h_deg h_R_pos
  · exact T5_RothWronskian_m2_alt P hP R h_deg h_R_pos
  · exact T5_RothWronskian_m3_alt P hP R h_deg h_R_pos

/-! ## Headline -/

/-- **🚨 HEADLINE — Wave-2 Phase 2.2 ALT m ≤ 3 partial closure**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Wave-2 Phase 2.2 ALT partial.

    Three derivations:
    1. `T5_RothWronskian_m2_alt` (m=2 alt witness instance)
    2. `T5_RothWronskian_m3_alt` (m=3 alt witness instance)
    3. `T5_RothWronskian_m_le_3_alt_unconditional` (combined m ≤ 3)

    Both witness families (e_{i-1} and e_i) provide independent
    confirmations of Wronskian non-vanishing for m ∈ {1, 2, 3}.

    Sub-lemma 314/N in T-5 Phase 7. Lean-core only. NO STUBS. -/
theorem session_W2_phase_2_2_alt_m_le_3_partial_closure_headline :
    ∀ {m : ℕ}, 0 < m → m ≤ 3 →
    ∀ (P : MvPolynomial (Fin m) ℝ) (R : Fin m → ℕ),
      P ≠ 0 →
      (∀ i, MvPolynomial.degreeOf i P ≤ R i) →
      (∀ i, 0 < R i) →
    ∃ (J : Fin m → (Fin m → ℕ)),
      (∀ i k, J i k ≤ R k) ∧
      mvPolyWronskian m P J ≠ 0 :=
  T5_RothWronskian_m_le_3_alt_unconditional

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RothLemma_PartialInductiveStepAlt
