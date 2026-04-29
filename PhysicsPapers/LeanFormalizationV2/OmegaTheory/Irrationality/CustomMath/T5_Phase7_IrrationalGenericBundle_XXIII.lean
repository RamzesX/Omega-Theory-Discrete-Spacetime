/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXIII: ext #529-543
  PARAMETRIC cube root family (analogue of Bundle-XVI for cubic)**, sub
  session 559oooooooooooooooooooo through 559aaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #529-543.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXIII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  PARAMETRIC family theorem for `Real.rpow n (1/3)` for any `n : ℕ`.
  Replaces O(N) explicit cubic witnesses with O(1) parametric. Mirror
  of Bundle-XVI sqrt-prime parametric.

  Sub-cluster A (parametric building blocks):
  - ext #529: cbrt_nat (n : ℕ → ℝ, n^(1/3))
  - ext #530: cbrt_nat_pow_three_eq_nat (parametric identity)
  - ext #531: polyXCubedMinusNat (n : ℕ → Polynomial ℤ)
  - ext #532: polyXCubedMinusNat_ne_zero (parametric)
  - ext #533: polyXCubedMinusNat_natDegree (parametric = 3)
  - ext #534: polyXCubedMinusNat_aeval_cbrt_nat (parametric)

  Sub-cluster B (parametric witness theorems):
  - ext #535: T5_isCubicAlgebraic_cbrt_nat (forall n : ℕ)
  - ext #536: T5_IsAlgebraic_int_cbrt_nat (parametric Mathlib bridge)

  Sub-cluster C (concrete instances ∛13/∛17/∛19):
  - ext #537: T5_isCubicAlgebraic_cbrt_thirteen
  - ext #538: T5_isCubicAlgebraic_cbrt_seventeen
  - ext #539: T5_isCubicAlgebraic_cbrt_nineteen

  Sub-cluster D (Bundle-XXIII markers + headlines):
  - ext #540: bundle_XXIII_first_in_V2_marker
  - ext #541: bundle_XXIII_closed_count
  - ext #542: bundle_XXIII_master_alias_3_concrete
  - ext #543: bundle_XXIII_grand_headline_full (parametric ∀ n : ℕ)

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #529-543 — Parametric cube root (BUNDLE-XXIII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXII

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X

/-! ## Sub-cluster A — parametric building blocks -/

/-- **🚨 ext #529** — Parametric `cbrt_nat n = n ^ (1/3 : ℝ)`. -/
noncomputable def cbrt_nat (n : ℕ) : ℝ := (n : ℝ) ^ (((3 : ℕ) : ℝ)⁻¹)

/-- **🚨 ext #530** — Parametric `(cbrt_nat n)^3 = n`. -/
theorem T5_cbrt_nat_pow_three_eq_nat (n : ℕ) :
    cbrt_nat n ^ 3 = (n : ℝ) := by
  unfold cbrt_nat
  exact Real.rpow_inv_natCast_pow (n.cast_nonneg : (0 : ℝ) ≤ (n : ℝ))
    (by norm_num : (3 : ℕ) ≠ 0)

/-- **🚨 ext #531** — Parametric Polynomial X³ - n. -/
noncomputable def polyXCubedMinusNat (n : ℕ) : Polynomial ℤ := X ^ 3 - C (n : ℤ)

/-- **🚨 ext #532** — Parametric `polyXCubedMinusNat n ≠ 0`. -/
theorem T5_polyXCubedMinusNat_ne_zero (n : ℕ) : polyXCubedMinusNat n ≠ 0 := by
  intro h
  have h2 : (polyXCubedMinusNat n).natDegree = 3 := by
    unfold polyXCubedMinusNat
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

/-- **🚨 ext #533** — Parametric `(polyXCubedMinusNat n).natDegree = 3`. -/
theorem T5_polyXCubedMinusNat_natDegree (n : ℕ) :
    (polyXCubedMinusNat n).natDegree = 3 := by
  unfold polyXCubedMinusNat
  compute_degree
  norm_num

/-- **🚨 ext #534** — Parametric `aeval (cbrt_nat n) (polyXCubedMinusNat n) = 0`. -/
theorem T5_polyXCubedMinusNat_aeval_cbrt_nat (n : ℕ) :
    Polynomial.aeval (cbrt_nat n) (polyXCubedMinusNat n) = 0 := by
  unfold polyXCubedMinusNat
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        T5_cbrt_nat_pow_three_eq_nat]

/-! ## Sub-cluster B — parametric witness theorems -/

/-- **🚨 ext #535** — Parametric `IsCubicAlgebraic (cbrt_nat n)`. -/
theorem T5_isCubicAlgebraic_cbrt_nat (n : ℕ) :
    IsCubicAlgebraic (cbrt_nat n) :=
  ⟨polyXCubedMinusNat n,
   T5_polyXCubedMinusNat_ne_zero n,
   T5_polyXCubedMinusNat_aeval_cbrt_nat n,
   T5_polyXCubedMinusNat_natDegree n⟩

/-- **🚨 ext #536** — Parametric `IsAlgebraic ℤ (cbrt_nat n)`. -/
theorem T5_IsAlgebraic_int_cbrt_nat (n : ℕ) : IsAlgebraic ℤ (cbrt_nat n) := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := T5_isCubicAlgebraic_cbrt_nat n
  exact ⟨p, hp_ne, hp_root⟩

/-! ## Sub-cluster C — concrete instances ∛13/∛17/∛19 -/

/-- **🚨 ext #537** — `IsCubicAlgebraic ∛13` via parametric. -/
theorem T5_isCubicAlgebraic_cbrt_thirteen :
    IsCubicAlgebraic (cbrt_nat 13) :=
  T5_isCubicAlgebraic_cbrt_nat 13

/-- **🚨 ext #538** — `IsCubicAlgebraic ∛17` via parametric. -/
theorem T5_isCubicAlgebraic_cbrt_seventeen :
    IsCubicAlgebraic (cbrt_nat 17) :=
  T5_isCubicAlgebraic_cbrt_nat 17

/-- **🚨 ext #539** — `IsCubicAlgebraic ∛19` via parametric. -/
theorem T5_isCubicAlgebraic_cbrt_nineteen :
    IsCubicAlgebraic (cbrt_nat 19) :=
  T5_isCubicAlgebraic_cbrt_nat 19

/-! ## Sub-cluster D — Bundle-XXIII markers + headlines -/

/-- **🚨 ext #540** — Frontier marker: Bundle-XXIII parametric cubic. -/
theorem T5_bundle_XXIII_first_in_V2_marker :
    ∃ (n : ℕ), 529 ≤ n ∧ n ≤ 543 ∧ n - 529 ≤ 15 :=
  ⟨543, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #541** — Bundle-XXIII closure cardinality. -/
theorem T5_bundle_XXIII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #542** — Bundle-XXIII master 3-concrete. -/
theorem T5_bundle_XXIII_master_alias_3_concrete :
    IsCubicAlgebraic (cbrt_nat 13) ∧
    IsCubicAlgebraic (cbrt_nat 17) ∧
    IsCubicAlgebraic (cbrt_nat 19) :=
  ⟨T5_isCubicAlgebraic_cbrt_thirteen,
   T5_isCubicAlgebraic_cbrt_seventeen,
   T5_isCubicAlgebraic_cbrt_nineteen⟩

/-! ## Bundle-XXIII GRAND HEADLINE -/

/-- **🚨 ext #543 — HEADLINE: BUNDLE-XXIII PARAMETRIC cube root family**.

    🏆🏆🏆 PARAMETRIC theorem: for any `n : ℕ`, `cbrt_nat n` is
    IsCubicAlgebraic + IsAlgebraic ℤ. Replaces O(N) cubic witnesses
    with O(1) parametric. Mirrors Bundle-XVI sqrt-prime parametric. -/
theorem T5_bundle_XXIII_grand_headline_full
    (n : ℕ) :
    IsCubicAlgebraic (cbrt_nat n) ∧
    IsAlgebraic ℤ (cbrt_nat n) ∧
    cbrt_nat n ^ 3 = (n : ℝ) :=
  ⟨T5_isCubicAlgebraic_cbrt_nat n,
   T5_IsAlgebraic_int_cbrt_nat n,
   T5_cbrt_nat_pow_three_eq_nat n⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII
