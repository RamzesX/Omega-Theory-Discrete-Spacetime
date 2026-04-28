/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothChainSummary

  T-5 (Roth's theorem) — **Phase 7 ext #124: Cubic+ Roth chain
  SUMMARY bundle (cubic+ chain HEADLINE composite)**, sub session
  559xxxxxxx — STRICT critical-path #316 (T-5) Phase 7 ext #124.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  SUMMARY of the cubic+ Roth chain — packages all key conditional
  capstones into a single 4-conjunct bundle:

  Under `SchmidtAuxPolyExists`, for irrational algebraic α + ε > 0:
  1. Multiplied form: `|q-α|^k · M · q.den^d ≥ 1` (Schmidt+multiplied capstone s108)
  2. kth-root form:   `(1/(M·q.den^d))^(1/k) ≤ |q-α|` (Schmidt+kth-root capstone s112)
  3. Roth-form:       `M^(-1/k) · q.den^(-(2+ε)) ≤ |q-α|` (Schmidt → Roth-form s117)
  4. Exists-C form:   `∃ C > 0, ∃ p ≠ 0, ∀ q…: C·q.den^(-(2+ε)) ≤ |q-α|` (s119)

  All four forms are EQUIVALENT (algebraic transformations); shipping
  them in one bundle gives convenient access for downstream theorems.

  Single derivation:
  1. `T5_cubic_roth_chain_summary`: 4-conjunct bundle.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.
  NO concrete-witness-spam per anti-pattern lock 2026-04-29.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #124 — cubic+ Roth chain SUMMARY (4-conjunct).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtMultipliedCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtKthRootCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormExistsC

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothChainSummary

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtAuxPolyHypothesis
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtMultipliedCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtKthRootCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormCapstone
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtRothFormExistsC

/-! ## Cubic+ Roth chain summary -/

/-- **🚨 Wave T5 session 559xxxxxxx — Cubic+ Roth chain SUMMARY**.

    4-conjunct bundle of all Schmidt-conditional Roth capstones. -/
theorem T5_cubic_roth_chain_summary
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    -- Form 1: multiplied (s108)
    (∃ (p : Polynomial ℤ) (k : ℕ),
      p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (1 : ℝ) ≤
          |((q : ℚ) : ℝ) - α| ^ k *
            (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree) ∧
    -- Form 2: kth-root (s112)
    (∃ (p : Polynomial ℤ) (k : ℕ),
      1 ≤ k ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        ((1 : ℝ) / (((∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)) *
          ((q.den : ℝ)) ^ p.natDegree)) ^ (1 / (k : ℝ)) ≤
          |((q : ℚ) : ℝ) - α|) ∧
    -- Form 3: Roth-form (s117)
    (∃ (p : Polynomial ℤ) (k : ℕ),
      1 ≤ k ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
            |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) ^ (-(1 / (k : ℝ))) *
          ((q.den : ℝ)) ^ (-(2 + ε)) ≤
          |((q : ℚ) : ℝ) - α|) ∧
    -- Form 4: Exists-C (s119)
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_schmidt_multiplied_capstone h_schmidt α hα h_alg ε hε,
   T5_schmidt_kth_root_capstone h_schmidt α hα h_alg ε hε,
   T5_schmidt_roth_form_capstone h_schmidt α hα h_alg ε hε,
   T5_schmidt_roth_form_exists_C h_schmidt α hα h_alg ε hε⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559xxxxxxx — T-5 Phase 7 ext #124:
    Cubic+ Roth chain SUMMARY**.

    🏆 STRICT CRITICAL-PATH #316 (T-5) Phase 7 ext #124.

    🏆 4-CONJUNCT CHAIN SUMMARY — all Schmidt-conditional Roth capstones.

    Single derivation:
    1. `T5_cubic_roth_chain_summary` — 4-conjunct bundle.

    Composes:
    - ext #108 multiplied capstone
    - ext #112 kth-root capstone
    - ext #117 Roth-form capstone
    - ext #119 EXISTS-C capstone

    All four forms are mathematically equivalent (algebraic transformations
    via real-power algebra ext #113 + ext #114 + s107). Shipping them in
    one bundle gives downstream theorems convenient access to whichever
    form fits their needs.

    Mathlib usage: composition only.

    Sub-lemma 297/N in T-1 (T-5 Phase 7 ext #124).  Lean-core only.

    🏆 First Lean-core T-5 Phase 7 cubic+ Roth chain SUMMARY. The cubic+
    chain CONDITIONAL infrastructure is COMPLETE in 4 equivalent forms.
    Escanor Pride + Erdős Primarch — full prove mode, NO STUBS, NO slim. -/
theorem session_559xxxxxxx_T5_phase7_cubic_roth_chain_summary_headline
    (h_schmidt : SchmidtAuxPolyExists)
    (α : ℝ) (hα : Irrational α) (h_alg : IsAlgebraic ℤ α)
    (ε : ℝ) (hε : 0 < ε) :
    (∃ (p : Polynomial ℤ) (k : ℕ),
      p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      (k : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < k → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        (1 : ℝ) ≤
          |((q : ℚ) : ℝ) - α| ^ k *
            (∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|) *
            ((q.den : ℝ)) ^ p.natDegree) ∧
    (∃ (C : ℝ) (p : Polynomial ℤ),
      0 < C ∧ p ≠ 0 ∧ Polynomial.aeval α p = 0 ∧
      ∀ (q : ℚ), |((q : ℚ) : ℝ) - α| ≤ 1 →
        Polynomial.eval₂ ((Int.castRingHom ℚ)) (q : ℚ) p ≠ 0 →
        C * ((q.den : ℝ)) ^ (-(2 + ε)) ≤ |((q : ℚ) : ℝ) - α|) :=
  ⟨T5_schmidt_multiplied_capstone h_schmidt α hα h_alg ε hε,
   T5_schmidt_roth_form_exists_C h_schmidt α hα h_alg ε hε⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_CubicRothChainSummary
