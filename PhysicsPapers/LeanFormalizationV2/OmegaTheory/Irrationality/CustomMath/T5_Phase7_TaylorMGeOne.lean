/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne

  T-5 (Roth's theorem) — **Phase 7 ext #140: M ≥ 1 for ℤ-poly with
  p ≠ 0 + k ≤ natDegree (cubic+ chain Roth constant bound)**, sub
  session 559nnnnnnnn — STRICT critical-path #316 (T-5) Phase 7 ext #140.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Lower bound on M for cubic+ chain (cast ℤ-poly):

  For p ∈ ℤ[X] with p ≠ 0, k : ℕ with k ≤ p.natDegree, α : ℝ:
    `1 ≤ ∑ i ∈ Finset.Ico k ((p.map ℝ).natDegree + 1), |(taylor α (p.map ℝ)).coeff i|`

  Combined with `M^(-1/k) ≤ 1` (since M ≥ 1, 1/k > 0): the Roth constant
  `C = M^(-1/k) ≤ 1` always.

  Strategy: the leading-coeff term contributes `|(p.leadingCoeff : ℝ)| ≥ 1`
  (from ext #139), other terms ≥ 0.

  Single derivation:
  1. `T5_taylor_M_ge_one_int_poly`: `1 ≤ M`.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #140 — M ≥ 1 for ℤ-poly cast.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapCoeff
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntLeadingCoeffAbsGeOne
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapCoeff
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntLeadingCoeffAbsGeOne
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorLeadingCoeff
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero

/-! ## M ≥ 1 -/

/-- **🚨 Wave T5 session 559nnnnnnnn — `1 ≤ M` for ℤ-poly cast**.

    For p ∈ ℤ[X] with p ≠ 0, k ≤ p.natDegree, α : ℝ:
      `1 ≤ ∑ i ∈ Ico k ((p.map ℝ).natDegree + 1), |(taylor α (p.map ℝ)).coeff i|`. -/
theorem T5_taylor_M_ge_one_int_poly
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0)
    (k : ℕ) (hk : k ≤ p.natDegree) :
    (1 : ℝ) ≤ ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
  -- (p.map ℝ).natDegree = p.natDegree
  have h_nd_eq : (p.map (Int.castRingHom ℝ)).natDegree = p.natDegree :=
    T5_int_poly_map_real_natDegree_eq p
  -- The term at i = p.natDegree contributes |leading coeff| ≥ 1
  have hd_mem : p.natDegree ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1) := by
    rw [Finset.mem_Ico, h_nd_eq]; exact ⟨hk, Nat.lt_succ_self _⟩
  -- (taylor α (p.map ℝ)).coeff p.natDegree = (p.map ℝ).leadingCoeff
  have h_taylor_lead : (Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff p.natDegree =
                       (p.map (Int.castRingHom ℝ)).leadingCoeff := by
    have := T5_taylor_coeff_natDegree_eq α (p.map (Int.castRingHom ℝ))
    rwa [h_nd_eq] at this
  -- (p.map ℝ).leadingCoeff = (p.leadingCoeff : ℝ)
  have h_lead_cast : (p.map (Int.castRingHom ℝ)).leadingCoeff = ((p.leadingCoeff : ℤ) : ℝ) :=
    T5_int_poly_map_leadingCoeff p
  -- |(p.leadingCoeff : ℝ)| ≥ 1
  have h_abs_ge : (1 : ℝ) ≤ |((p.leadingCoeff : ℤ) : ℝ)| :=
    T5_int_leadingCoeff_abs_ge_one p hp_ne
  -- Combine: |(taylor α ..).coeff p.natDegree| ≥ 1
  have h_term_ge : (1 : ℝ) ≤ |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff p.natDegree| := by
    rw [h_taylor_lead, h_lead_cast]
    exact h_abs_ge
  -- The leading-coeff term is in the sum and is ≥ 1; other terms ≥ 0.
  -- So sum ≥ |leading-coeff term| ≥ 1.
  calc (1 : ℝ)
      ≤ |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff p.natDegree| := h_term_ge
    _ ≤ ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
        Finset.single_le_sum (f := fun i => |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|)
          (fun i _ => abs_nonneg _) hd_mem

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559nnnnnnnn — T-5 Phase 7 ext #140**.

    🏆 BOOKKEEPING — `1 ≤ M` for ℤ-poly cast (cubic+ Roth constant ≤ 1).

    Strategy: the leading-coeff term in the sum contributes
    `|(taylor α (p.map ℝ)).coeff p.natDegree| = |(p.leadingCoeff : ℝ)| ≥ 1`
    (from ext #139). Other terms in the sum are ≥ 0. So `M ≥ 1`.

    Implication: `M^(-1/k) ≤ 1` always, so the Roth constant `C ≤ 1`.

    Mathlib usage: composition of ext #126 + #128 + #138 + #139 +
    `Finset.single_le_sum` + `abs_nonneg`.

    Sub-lemma 313/N. Lean-core only. -/
theorem session_559nnnnnnnn_T5_phase7_taylor_M_ge_one_int_poly_headline
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0)
    (k : ℕ) (hk : k ≤ p.natDegree) :
    (1 : ℝ) ≤ ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
  T5_taylor_M_ge_one_int_poly α p hp_ne k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMGeOne
