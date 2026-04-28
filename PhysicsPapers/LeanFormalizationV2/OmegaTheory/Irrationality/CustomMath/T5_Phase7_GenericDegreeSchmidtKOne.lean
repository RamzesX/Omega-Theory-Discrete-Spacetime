/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeSchmidtKOne

  T-5 (Roth's theorem) — **Phase 7 ext #174: Generic-degree Schmidt
  discharge for k=1 + ε > n-2**, sub session 559vvvvvvvvv —
  STRICT critical-path #316 (T-5) Phase 7 ext #174.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Generic Schmidt aux poly conditions discharged for any n with k=1 + ε > n-2:

  For α : ℝ with IsAlgebraicOfDegree α n (n ≥ 1) and ε > n-2:
  ∃ p ∈ ℤ[X] (degree n), all SchmidtAuxPolyExists conditions hold with k=1.

  Single derivation:
  1. `T5_generic_degree_schmidt_k_one`: composes ext #173 + ext #122 + ext #129.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #174 — Generic-degree Schmidt discharge k=1 + ε > n-2.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothBudget
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeSchmidtKOne

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeRothBudget
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SchmidtIndexOneRoot
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly

/-! ## Generic-degree Schmidt discharge -/

/-- **🚨 Wave T5 session 559vvvvvvvvv — Generic Schmidt discharge for k=1 + ε > n-2**.

    For α with IsAlgebraicOfDegree α n (n ≥ 1) and ε > n-2:
    ∃ p ∈ ℤ[X] (degree n), all SchmidtAuxPolyExists conditions discharge
    with k = 1. -/
theorem T5_generic_degree_schmidt_k_one
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n) (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = n ∧
      ((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < (1 : ℕ) → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      (0 : ℝ) < ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
  obtain ⟨p, hp_ne, hp_root, hp_deg, hk_bound⟩ :=
    T5_generic_degree_roth_budget α n h_alg ε hε
  refine ⟨p, hp_ne, hp_root, hp_deg, hk_bound, ?_, ?_⟩
  · -- Index ≥ 1 ↔ root condition
    rw [T5_schmidt_index_one_iff_root]
    have h := hp_root
    rw [Polynomial.aeval_def] at h
    rw [← Polynomial.eval_map] at h
    convert h using 2
  · -- M_pos via ext #129
    apply T5_taylor_M_positive_int_poly α p hp_ne 1
    rw [hp_deg]; exact hn

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559vvvvvvvvv — T-5 Phase 7 ext #174**.

    🏆 GENERIC SCHMIDT DISCHARGE for ANY n ≥ 1, k=1, ε > n-2.

    Generalizes:
    - n = 2 (quadratic): ε > 0 → s130
    - n = 3 (cubic): ε > 1 → s169
    - n ≥ 4 (quartic+): ε > n-2 → NEW

    Sub-lemma 347/N. Lean-core only. -/
theorem session_559vvvvvvvvv_T5_phase7_generic_degree_schmidt_k_one_headline
    (α : ℝ) (n : ℕ) (hn : 1 ≤ n) (h_alg : IsAlgebraicOfDegree α n)
    (ε : ℝ) (hε : ((n : ℝ) - 2) < ε) :
    ∃ (p : Polynomial ℤ),
      p ≠ 0 ∧
      Polynomial.aeval α p = 0 ∧
      p.natDegree = n ∧
      ((1 : ℕ) : ℝ) * (2 + ε) > p.natDegree ∧
      (∀ i, i < (1 : ℕ) → (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i = 0) ∧
      (0 : ℝ) < ∑ i ∈ Finset.Ico 1 ((p.map (Int.castRingHom ℝ)).natDegree + 1),
                |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
  T5_generic_degree_schmidt_k_one α n hn h_alg ε hε

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_GenericDegreeSchmidtKOne
