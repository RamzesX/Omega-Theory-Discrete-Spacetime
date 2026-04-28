/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly

  T-5 (Roth's theorem) — **Phase 7 ext #129: M-positivity for ℤ-poly
  cast to ℝ (cubic+ chain Schmidt witness construction)**, sub session
  559cccccccc — STRICT critical-path #316 (T-5) Phase 7 ext #129.

  Single-thread hand-authored 2026-04-29.

  ## What this file delivers

  Composes ext #127 (M-positivity for ℝ-poly) + ext #128 (Int → ℝ map
  preserves non-zero):

  For p ∈ ℤ[X] with p ≠ 0, k : ℕ with k ≤ p.natDegree, α : ℝ:
    `0 < ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i|`

  This is the EXACT form of M used throughout cubic+ Roth chain,
  letting downstream theorems discharge M_pos hypothesis directly
  from `p ≠ 0 + k ≤ p.natDegree`.

  Single derivation:
  1. `T5_taylor_M_positive_int_poly`: composes s127 + s128.

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #129 — M-positivity for ℤ-poly cast to ℝ.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositive
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly

open Polynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositive
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IntPolyMapNonzero

/-! ## M-positivity for ℤ-poly cast -/

/-- **🚨 Wave T5 session 559cccccccc — `0 < M` for cast ℤ-poly**.

    For p ∈ ℤ[X] with p ≠ 0, k ≤ p.natDegree, α : ℝ:
      `0 < ∑ i ∈ Ico k ((p.map ℝ).natDegree + 1), |(taylor α (p.map ℝ)).coeff i|`. -/
theorem T5_taylor_M_positive_int_poly
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0)
    (k : ℕ) (hk : k ≤ p.natDegree) :
    (0 : ℝ) < ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| := by
  -- (p.map ℝ) ≠ 0 from ext #128
  have hp_real_ne : (p.map (Int.castRingHom ℝ)) ≠ 0 :=
    T5_int_poly_map_real_ne_zero p hp_ne
  -- (p.map ℝ).natDegree = p.natDegree from ext #128
  have h_nd_eq : (p.map (Int.castRingHom ℝ)).natDegree = p.natDegree :=
    T5_int_poly_map_real_natDegree_eq p
  -- Apply ext #127 with k ≤ (p.map ℝ).natDegree
  have hk_real : k ≤ (p.map (Int.castRingHom ℝ)).natDegree := by
    rw [h_nd_eq]; exact hk
  exact T5_taylor_M_positive_from_natDegree_le α (p.map (Int.castRingHom ℝ))
          hp_real_ne k hk_real

/-! ## Headline -/

/-- **HEADLINE — Wave T5 session 559cccccccc — T-5 Phase 7 ext #129**.

    🏆 BOOKKEEPING — M > 0 for cast ℤ-poly.

    Strategy: composes ext #127 (M-positivity for ℝ-poly) + ext #128
    (Int → ℝ map preserves non-zero + degree).

    This is the exact form of M used throughout cubic+ Roth chain.
    Downstream theorems can discharge M_pos directly from p ≠ 0 +
    k ≤ p.natDegree.

    Sub-lemma 302/N. Lean-core only. -/
theorem session_559cccccccc_T5_phase7_taylor_M_positive_int_poly_headline
    (α : ℝ) (p : Polynomial ℤ) (hp_ne : p ≠ 0)
    (k : ℕ) (hk : k ≤ p.natDegree) :
    (0 : ℝ) < ∑ i ∈ Finset.Ico k ((p.map (Int.castRingHom ℝ)).natDegree + 1),
              |(Polynomial.taylor α (p.map (Int.castRingHom ℝ))).coeff i| :=
  T5_taylor_M_positive_int_poly α p hp_ne k hk

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_TaylorMPositiveIntPoly
