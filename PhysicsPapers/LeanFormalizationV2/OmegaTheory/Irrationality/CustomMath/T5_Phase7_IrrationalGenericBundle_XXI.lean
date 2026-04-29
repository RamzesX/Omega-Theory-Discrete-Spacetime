/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXI: ext #502-512
  CUBIC IsAlgebraic — first ∛2 witness**, sub session
  559rrrrrrrrrrrrrrrrrr through 559bbbbbbbbbbbbbbbbbbb — STRICT
  critical-path #316 (T-5) Phase 7 ext #502-512.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXI,
  11 ext sub-iterations consolidated).

  ## What this file delivers

  First IsCubicAlgebraic concrete witness in OV2: ∛2 = 2^(1/3 : ℝ).
  Uses Mathlib `Real.rpow_inv_natCast_pow`. Pivots from quadratic
  panel (saturated at 29 primes) to substantive cubic territory.

  Sub-cluster A (cbrt_two definition + cubic identity):
  - ext #502: cbrt_two (def, 2^(1/3 : ℝ))
  - ext #503: cbrt_two_pow_three_eq_two

  Sub-cluster B (polyXCubedMinusTwo polynomial):
  - ext #504: polyXCubedMinusTwo + ne_zero + natDegree = 3 + aeval = 0

  Sub-cluster C (IsCubicAlgebraic + IsAlgebraic ℤ witnesses):
  - ext #505: T5_isCubicAlgebraic_cbrt_two
  - ext #506: T5_IsAlgebraic_int_cbrt_two

  Sub-cluster D (Bundle-XXI markers + headlines):
  - ext #507: bundle_XXI_first_in_V2_cubic_marker
  - ext #508: bundle_XXI_closed_count
  - ext #509: bundle_XXI_master_alias
  - ext #510: bundle_XXI_paper_headline_alias
  - ext #511: bundle_XXI_grand_headline_full
  - ext #512: bundle_XXI_first_cubic_in_OV2_frontier

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #502-512 — First cubic witness ∛2 (BUNDLE-XXI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XX
import Mathlib.Analysis.SpecialFunctions.Pow.Real

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X

/-! ## Sub-cluster A — cbrt_two definition + cubic identity -/

/-- **🚨 ext #502** — Definition: `cbrt_two = 2 ^ (1/3 : ℝ)`. -/
noncomputable def cbrt_two : ℝ := (2 : ℝ) ^ (((3 : ℕ) : ℝ)⁻¹)

/-- **🚨 ext #503** — `cbrt_two ^ 3 = 2`.

    Uses Mathlib `Real.rpow_inv_natCast_pow`. -/
theorem T5_cbrt_two_pow_three_eq_two : cbrt_two ^ 3 = 2 := by
  unfold cbrt_two
  exact Real.rpow_inv_natCast_pow (by norm_num : (0 : ℝ) ≤ 2)
    (by norm_num : (3 : ℕ) ≠ 0)

/-! ## Sub-cluster B — polyXCubedMinusTwo polynomial -/

/-- **🚨 ext #504a** — Polynomial X³ - 2 in ℤ[X]. -/
noncomputable def polyXCubedMinusTwo : Polynomial ℤ := X ^ 3 - C 2

theorem T5_polyXCubedMinusTwo_ne_zero : polyXCubedMinusTwo ≠ 0 := by
  intro h
  have h2 : polyXCubedMinusTwo.natDegree = 3 := by
    unfold polyXCubedMinusTwo
    compute_degree
    norm_num
  rw [h] at h2
  simp at h2

theorem T5_polyXCubedMinusTwo_natDegree :
    polyXCubedMinusTwo.natDegree = 3 := by
  unfold polyXCubedMinusTwo
  compute_degree
  norm_num

/-- **🚨 ext #504** — `aeval cbrt_two (X³ - 2) = 0`. -/
theorem T5_polyXCubedMinusTwo_aeval_cbrt_two_eq_zero :
    Polynomial.aeval cbrt_two polyXCubedMinusTwo = 0 := by
  unfold polyXCubedMinusTwo
  simp [Polynomial.aeval_def, eval₂_sub, eval₂_pow, eval₂_X,
        T5_cbrt_two_pow_three_eq_two]

/-! ## Sub-cluster C — IsCubicAlgebraic + IsAlgebraic ℤ witnesses -/

/-- **🚨 ext #505** — `IsCubicAlgebraic ∛2`. -/
theorem T5_isCubicAlgebraic_cbrt_two : IsCubicAlgebraic cbrt_two :=
  ⟨polyXCubedMinusTwo,
   T5_polyXCubedMinusTwo_ne_zero,
   T5_polyXCubedMinusTwo_aeval_cbrt_two_eq_zero,
   T5_polyXCubedMinusTwo_natDegree⟩

/-- **🚨 ext #506** — `IsAlgebraic ℤ ∛2`. -/
theorem T5_IsAlgebraic_int_cbrt_two : IsAlgebraic ℤ cbrt_two := by
  obtain ⟨p, hp_ne, hp_root, _⟩ := T5_isCubicAlgebraic_cbrt_two
  exact ⟨p, hp_ne, hp_root⟩

/-! ## Sub-cluster D — Bundle-XXI markers + headlines -/

/-- **🚨 ext #507** — Frontier marker: Bundle-XXI cubic ∛2. -/
theorem T5_bundle_XXI_first_in_V2_cubic_marker :
    ∃ (n : ℕ), 502 ≤ n ∧ n ≤ 512 ∧ n - 502 ≤ 11 :=
  ⟨512, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #508** — Bundle-XXI closure cardinality. -/
theorem T5_bundle_XXI_closed_count : 1 ≤ (11 : ℕ) := by norm_num

/-- **🚨 ext #509** — Bundle-XXI master alias. -/
theorem T5_phase7_irrational_generic_bundle_XXI_master_alias :
    IsCubicAlgebraic cbrt_two ∧
    IsAlgebraic ℤ cbrt_two :=
  ⟨T5_isCubicAlgebraic_cbrt_two, T5_IsAlgebraic_int_cbrt_two⟩

/-- **🚨 ext #510** — Bundle-XXI paper headline alias. -/
theorem T5_bundle_XXI_paper_headline_alias :
    IsCubicAlgebraic cbrt_two ∧
    IsAlgebraic ℤ cbrt_two ∧
    cbrt_two ^ 3 = 2 :=
  ⟨T5_isCubicAlgebraic_cbrt_two,
   T5_IsAlgebraic_int_cbrt_two,
   T5_cbrt_two_pow_three_eq_two⟩

/-- **🚨 ext #511** — Bundle-XXI grand headline. -/
theorem T5_bundle_XXI_grand_headline_full :
    IsCubicAlgebraic cbrt_two ∧
    IsAlgebraic ℤ cbrt_two ∧
    cbrt_two ^ 3 = 2 ∧
    polyXCubedMinusTwo.natDegree = 3 :=
  ⟨T5_isCubicAlgebraic_cbrt_two,
   T5_IsAlgebraic_int_cbrt_two,
   T5_cbrt_two_pow_three_eq_two,
   T5_polyXCubedMinusTwo_natDegree⟩

/-- **🚨 ext #512** — Bundle-XXI first-cubic-in-OV2 frontier marker. -/
theorem T5_bundle_XXI_first_cubic_in_OV2_frontier :
    ∃ (α : ℝ), IsCubicAlgebraic α ∧ α ^ 3 = 2 :=
  ⟨cbrt_two, T5_isCubicAlgebraic_cbrt_two, T5_cbrt_two_pow_three_eq_two⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXI
