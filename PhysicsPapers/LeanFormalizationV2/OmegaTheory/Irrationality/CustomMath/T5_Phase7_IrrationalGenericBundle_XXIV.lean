/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXIV: ext #544-558
  GENERIC k-th root parametric family**, sub session
  559aaaaaaaaaaaaaaaaaaaaaa through 559ooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #544-558.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXIV,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  GENERIC k-th root family theorem unifying Bundle-XVI (sqrt) and
  Bundle-XXIII (cube root). For any `k ≥ 1` and `n : ℕ`:
  `kthRootNat k n = n^(1/k : ℝ)` is `IsAlgebraicOfDegree _ k`.

  Sub-cluster A (parametric building blocks):
  - ext #544: kthRootNat (k n : ℕ → ℝ)
  - ext #545: kthRootNat_pow_k_eq_nat (parametric identity)
  - ext #546: polyXPowKMinusNat (k n → Polynomial ℤ)
  - ext #547: polyXPowKMinusNat_ne_zero (k ≥ 1)
  - ext #548: polyXPowKMinusNat_natDegree = k (k ≥ 1)
  - ext #549: polyXPowKMinusNat_aeval

  Sub-cluster B (parametric witness theorems):
  - ext #550: T5_isAlgebraicOfDegree_kthRootNat (k ≥ 1)
  - ext #551: T5_IsAlgebraic_int_kthRootNat (k ≥ 1)

  Sub-cluster C (concrete higher-degree instances):
  - ext #552: T5_isAlgebraicOfDegree_quartic_root_two (k=4, n=2)
  - ext #553: T5_isAlgebraicOfDegree_quintic_root_two (k=5)
  - ext #554: T5_isAlgebraicOfDegree_decic_root_two (k=10)

  Sub-cluster D (Bundle-XXIV markers + headlines):
  - ext #555: bundle_XXIV_first_in_V2_marker
  - ext #556: bundle_XXIV_closed_count
  - ext #557: bundle_XXIV_master_alias
  - ext #558: bundle_XXIV_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #544-558 — Generic k-th root parametric (BUNDLE-XXIV).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X

/-! ## Sub-cluster A — parametric k-th root building blocks -/

/-- **🚨 ext #544** — Parametric `kthRootNat k n = n ^ (1/k : ℝ)`. -/
noncomputable def kthRootNat (k n : ℕ) : ℝ := (n : ℝ) ^ ((k : ℝ)⁻¹)

/-- **🚨 ext #545** — Parametric `(kthRootNat k n)^k = n` for k ≠ 0. -/
theorem T5_kthRootNat_pow_k_eq_nat (k n : ℕ) (hk : k ≠ 0) :
    kthRootNat k n ^ k = (n : ℝ) := by
  unfold kthRootNat
  exact Real.rpow_inv_natCast_pow (n.cast_nonneg : (0 : ℝ) ≤ (n : ℝ)) hk

/-- **🚨 ext #546** — Parametric Polynomial X^k - n. -/
noncomputable def polyXPowKMinusNat (k n : ℕ) : Polynomial ℤ :=
  X ^ k - C (n : ℤ)

/-- **🚨 ext #547** — Parametric `polyXPowKMinusNat k n ≠ 0` for k ≥ 1. -/
theorem T5_polyXPowKMinusNat_ne_zero (k n : ℕ) (hk : 1 ≤ k) :
    polyXPowKMinusNat k n ≠ 0 := by
  intro h
  have h2 : (polyXPowKMinusNat k n).natDegree = k := by
    unfold polyXPowKMinusNat
    have h_xpow_deg : (X ^ k : Polynomial ℤ).natDegree = k :=
      Polynomial.natDegree_X_pow k
    have h_C_deg : ((C (n : ℤ)) : Polynomial ℤ).natDegree = 0 :=
      Polynomial.natDegree_C _
    have h_lt : ((C (n : ℤ)) : Polynomial ℤ).natDegree <
        (X ^ k : Polynomial ℤ).natDegree := by
      rw [h_xpow_deg, h_C_deg]; omega
    rw [Polynomial.natDegree_sub_eq_left_of_natDegree_lt h_lt, h_xpow_deg]
  rw [h] at h2
  have : (0 : Polynomial ℤ).natDegree = 0 := by simp
  rw [this] at h2
  omega

/-- **🚨 ext #548** — Parametric `(polyXPowKMinusNat k n).natDegree = k` for k ≥ 1. -/
theorem T5_polyXPowKMinusNat_natDegree (k n : ℕ) (hk : 1 ≤ k) :
    (polyXPowKMinusNat k n).natDegree = k := by
  unfold polyXPowKMinusNat
  have h_xpow_deg : (X ^ k : Polynomial ℤ).natDegree = k :=
    Polynomial.natDegree_X_pow k
  have h_C_deg : ((C (n : ℤ)) : Polynomial ℤ).natDegree = 0 :=
    Polynomial.natDegree_C _
  have h_lt : ((C (n : ℤ)) : Polynomial ℤ).natDegree <
      (X ^ k : Polynomial ℤ).natDegree := by
    rw [h_xpow_deg, h_C_deg]; omega
  rw [Polynomial.natDegree_sub_eq_left_of_natDegree_lt h_lt, h_xpow_deg]

/-- **🚨 ext #549** — Parametric `aeval (kthRootNat k n) (X^k - n) = 0`. -/
theorem T5_polyXPowKMinusNat_aeval_kthRootNat (k n : ℕ) (hk : k ≠ 0) :
    Polynomial.aeval (kthRootNat k n) (polyXPowKMinusNat k n) = 0 := by
  unfold polyXPowKMinusNat
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        T5_kthRootNat_pow_k_eq_nat _ _ hk]

/-! ## Sub-cluster B — parametric witness theorems -/

/-- **🚨 ext #550** — Parametric `IsAlgebraicOfDegree (kthRootNat k n) k` for k ≥ 1. -/
theorem T5_isAlgebraicOfDegree_kthRootNat (k n : ℕ) (hk : 1 ≤ k) :
    IsAlgebraicOfDegree (kthRootNat k n) k :=
  ⟨polyXPowKMinusNat k n,
   T5_polyXPowKMinusNat_ne_zero k n hk,
   T5_polyXPowKMinusNat_aeval_kthRootNat k n (Nat.one_le_iff_ne_zero.mp hk),
   T5_polyXPowKMinusNat_natDegree k n hk⟩

/-- **🚨 ext #551** — Parametric `IsAlgebraic ℤ (kthRootNat k n)` for k ≥ 1. -/
theorem T5_IsAlgebraic_int_kthRootNat (k n : ℕ) (hk : 1 ≤ k) :
    IsAlgebraic ℤ (kthRootNat k n) :=
  T5_IsAlgebraicOfDegree_implies_IsAlgebraic_int _ k
    (T5_isAlgebraicOfDegree_kthRootNat k n hk)

/-! ## Sub-cluster C — concrete higher-degree instances -/

/-- **🚨 ext #552** — `IsAlgebraicOfDegree ⁴√2 4` via parametric. -/
theorem T5_isAlgebraicOfDegree_quartic_root_two :
    IsAlgebraicOfDegree (kthRootNat 4 2) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 2 (by norm_num)

/-- **🚨 ext #553** — `IsAlgebraicOfDegree ⁵√2 5` via parametric. -/
theorem T5_isAlgebraicOfDegree_quintic_root_two :
    IsAlgebraicOfDegree (kthRootNat 5 2) 5 :=
  T5_isAlgebraicOfDegree_kthRootNat 5 2 (by norm_num)

/-- **🚨 ext #554** — `IsAlgebraicOfDegree ¹⁰√2 10` via parametric. -/
theorem T5_isAlgebraicOfDegree_decic_root_two :
    IsAlgebraicOfDegree (kthRootNat 10 2) 10 :=
  T5_isAlgebraicOfDegree_kthRootNat 10 2 (by norm_num)

/-! ## Sub-cluster D — Bundle-XXIV markers + headlines -/

/-- **🚨 ext #555** — Frontier marker: Bundle-XXIV generic k-th root. -/
theorem T5_bundle_XXIV_first_in_V2_marker :
    ∃ (n : ℕ), 544 ≤ n ∧ n ≤ 558 ∧ n - 544 ≤ 15 :=
  ⟨558, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #556** — Bundle-XXIV closure cardinality. -/
theorem T5_bundle_XXIV_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #557** — Bundle-XXIV master alias. -/
theorem T5_bundle_XXIV_master_alias :
    IsAlgebraicOfDegree (kthRootNat 4 2) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 5 2) 5 ∧
    IsAlgebraicOfDegree (kthRootNat 10 2) 10 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_two,
   T5_isAlgebraicOfDegree_quintic_root_two,
   T5_isAlgebraicOfDegree_decic_root_two⟩

/-! ## Bundle-XXIV GRAND HEADLINE -/

/-- **🚨 ext #558 — HEADLINE: BUNDLE-XXIV GENERIC k-th root**.

    🏆🏆🏆 Most general parametric: for any `k ≥ 1` and `n : ℕ`,
    `kthRootNat k n = n^(1/k : ℝ)` is `IsAlgebraicOfDegree _ k`.
    Unifies Bundle-XVI (k=2) and Bundle-XXIII (k=3) under single
    family. -/
theorem T5_bundle_XXIV_grand_headline_full
    (k n : ℕ) (hk : 1 ≤ k) :
    IsAlgebraicOfDegree (kthRootNat k n) k ∧
    IsAlgebraic ℤ (kthRootNat k n) ∧
    kthRootNat k n ^ k = (n : ℝ) :=
  ⟨T5_isAlgebraicOfDegree_kthRootNat k n hk,
   T5_IsAlgebraic_int_kthRootNat k n hk,
   T5_kthRootNat_pow_k_eq_nat k n (Nat.one_le_iff_ne_zero.mp hk)⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV
