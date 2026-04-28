/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositive

  T-5 (Roth's theorem) — **Phase 7 ext #127: M-positivity from p ≠ 0
  + k ≤ natDegree (cubic+ chain Schmidt witness construction)**, sub
  session 559aaaaaaaa — STRICT critical-path #316 (T-5) Phase 7 ext #127.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  M-positivity lemma for cubic+ Schmidt chain:

  For p : Polynomial ℝ with p ≠ 0 and k : ℕ with k ≤ p.natDegree:
    `0 < ∑ i ∈ Finset.Ico k (p.natDegree + 1), |(Polynomial.taylor α p).coeff i|`

  Used to discharge the M_pos hypothesis in SchmidtAuxPolyExists when the
  chosen aux poly p has degree ≥ k. Key fact: |coeff_(p.natDegree) of
  taylor| = |p.leadingCoeff| > 0 (from ext #126), and this term is in the
  Ico k (p.natDegree + 1) range when k ≤ p.natDegree.

  Single derivation:
  1. `T5_taylor_M_positive_from_natDegree_le`: `0 < M`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #127 — M-positivity from p ≠ 0 + k ≤ natDegree.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff
import Mathlib.Data.Real.Basic

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositive

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff

/-! ## M-positivity -/

/-- **🚨 Wave T5 session 559aaaaaaaa — `0 < M` for p ≠ 0, k ≤ natDegree**.

    For p : Polynomial ℝ with p ≠ 0 and k : ℕ with k ≤ p.natDegree:
      `0 < ∑ i ∈ Finset.Ico k (p.natDegree + 1), |(taylor α p).coeff i|`. -/
theorem T5_taylor_M_positive_from_natDegree_le
    (α : ℝ) (p : Polynomial ℝ) (hp_ne : p ≠ 0) (k : ℕ) (hk : k ≤ p.natDegree) :
    (0 : ℝ) < ∑ i ∈ Finset.Ico k (p.natDegree + 1), |(Polynomial.taylor α p).coeff i| := by
  -- Strategy: the term at i = p.natDegree contributes |p.leadingCoeff| > 0.
  -- Other terms ≥ 0. Sum of nonneg + one positive = positive.
  have hd_mem : p.natDegree ∈ Finset.Ico k (p.natDegree + 1) := by
    rw [Finset.mem_Ico]; exact ⟨hk, Nat.lt_succ_self _⟩
  have h_lead_eq : (Polynomial.taylor α p).coeff p.natDegree = p.leadingCoeff :=
    T5_taylor_coeff_natDegree_eq α p
  have h_lead_pos : (0 : ℝ) < |p.leadingCoeff| := by
    apply abs_pos.mpr
    exact Polynomial.leadingCoeff_ne_zero.mpr hp_ne
  -- Apply Finset.sum_pos' or split off the natDegree term
  apply Finset.sum_pos' (fun i _ => abs_nonneg _)
  refine ⟨p.natDegree, hd_mem, ?_⟩
  rw [h_lead_eq]
  exact h_lead_pos

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559aaaaaaaa — T-5 Phase 7 ext #127**.

    🏆 BOOKKEEPING — M > 0 from p ≠ 0 + k ≤ natDegree.

    Strategy: the term at i = p.natDegree in the sum equals |p.leadingCoeff| > 0,
    and it lies in [k, natDegree+1) when k ≤ natDegree. Other terms ≥ 0.

    Used in cubic+ chain to DISCHARGE the M_pos hypothesis when the chosen
    aux poly p has degree ≥ k.

    Mathlib usage: `Polynomial.leadingCoeff_ne_zero`, `Finset.sum_pos'`,
    `Finset.mem_Ico`, `abs_nonneg`, `abs_pos`.

    Sub-lemma 300/N. Lean-core only. -/
theorem session_559aaaaaaaa_T5_phase7_taylor_M_positive_headline
    (α : ℝ) (p : Polynomial ℝ) (hp_ne : p ≠ 0) (k : ℕ) (hk : k ≤ p.natDegree) :
    (0 : ℝ) < ∑ i ∈ Finset.Ico k (p.natDegree + 1), |(Polynomial.taylor α p).coeff i| :=
  T5_taylor_M_positive_from_natDegree_le α p hp_ne k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositive
