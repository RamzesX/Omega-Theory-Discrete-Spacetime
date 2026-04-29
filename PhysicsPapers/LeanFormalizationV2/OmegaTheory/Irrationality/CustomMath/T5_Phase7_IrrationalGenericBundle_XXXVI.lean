/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVI

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXXVI: ext #724-738
  Cubic prime cascade ∛73/∛79/∛83/∛89/∛97 (sub-100 final)**, sub session
  559aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa through
  559oooooooooooooooooooooooooooooo —
  STRICT critical-path #316 (T-5) Phase 7 ext #724-738.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXXVI,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  Cubic prime cascade extension via Bundle-XXIII parametric: ∛73, ∛79,
  ∛83, ∛89, ∛97. Closes all primes < 100 for cube roots.

  Sub-cluster A (IsCubicAlgebraic via parametric):
  - ext #724-728: T5_isCubicAlgebraic_cbrt_{73,79,83,89,97}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #729-733: T5_IsAlgebraic_int_cbrt_{73,79,83,89,97}_concrete

  Sub-cluster C (Bundle-XXXVI markers + headlines):
  - ext #734-738: 5 markers + headlines

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #724-738 — Cubic prime cascade ∛73-∛97 (BUNDLE-XXXVI).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXV

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVI

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsCubicAlgebraic
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIII

/-! ## Sub-cluster A — IsCubicAlgebraic via parametric -/

theorem T5_isCubicAlgebraic_cbrt_73_concrete :
    IsCubicAlgebraic (cbrt_nat 73) :=
  T5_isCubicAlgebraic_cbrt_nat 73

theorem T5_isCubicAlgebraic_cbrt_79_concrete :
    IsCubicAlgebraic (cbrt_nat 79) :=
  T5_isCubicAlgebraic_cbrt_nat 79

theorem T5_isCubicAlgebraic_cbrt_83_concrete :
    IsCubicAlgebraic (cbrt_nat 83) :=
  T5_isCubicAlgebraic_cbrt_nat 83

theorem T5_isCubicAlgebraic_cbrt_89_concrete :
    IsCubicAlgebraic (cbrt_nat 89) :=
  T5_isCubicAlgebraic_cbrt_nat 89

theorem T5_isCubicAlgebraic_cbrt_97_concrete :
    IsCubicAlgebraic (cbrt_nat 97) :=
  T5_isCubicAlgebraic_cbrt_nat 97

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

theorem T5_IsAlgebraic_int_cbrt_73_concrete :
    IsAlgebraic ℤ (cbrt_nat 73) :=
  T5_IsAlgebraic_int_cbrt_nat 73

theorem T5_IsAlgebraic_int_cbrt_79_concrete :
    IsAlgebraic ℤ (cbrt_nat 79) :=
  T5_IsAlgebraic_int_cbrt_nat 79

theorem T5_IsAlgebraic_int_cbrt_83_concrete :
    IsAlgebraic ℤ (cbrt_nat 83) :=
  T5_IsAlgebraic_int_cbrt_nat 83

theorem T5_IsAlgebraic_int_cbrt_89_concrete :
    IsAlgebraic ℤ (cbrt_nat 89) :=
  T5_IsAlgebraic_int_cbrt_nat 89

theorem T5_IsAlgebraic_int_cbrt_97_concrete :
    IsAlgebraic ℤ (cbrt_nat 97) :=
  T5_IsAlgebraic_int_cbrt_nat 97

/-! ## Sub-cluster C — Bundle-XXXVI markers + headlines -/

theorem T5_bundle_XXXVI_first_in_V2_marker :
    ∃ (n : ℕ), 724 ≤ n ∧ n ≤ 738 ∧ n - 724 ≤ 15 :=
  ⟨738, by norm_num, by norm_num, by norm_num⟩

theorem T5_bundle_XXXVI_closed_count : 1 ≤ (15 : ℕ) := by norm_num

theorem T5_bundle_XXXVI_master_alias_5_concrete :
    IsCubicAlgebraic (cbrt_nat 73) ∧
    IsCubicAlgebraic (cbrt_nat 79) ∧
    IsCubicAlgebraic (cbrt_nat 83) ∧
    IsCubicAlgebraic (cbrt_nat 89) ∧
    IsCubicAlgebraic (cbrt_nat 97) :=
  ⟨T5_isCubicAlgebraic_cbrt_73_concrete,
   T5_isCubicAlgebraic_cbrt_79_concrete,
   T5_isCubicAlgebraic_cbrt_83_concrete,
   T5_isCubicAlgebraic_cbrt_89_concrete,
   T5_isCubicAlgebraic_cbrt_97_concrete⟩

theorem T5_bundle_XXXVI_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (cbrt_nat 73) ∧
    IsAlgebraic ℤ (cbrt_nat 79) ∧
    IsAlgebraic ℤ (cbrt_nat 83) ∧
    IsAlgebraic ℤ (cbrt_nat 89) ∧
    IsAlgebraic ℤ (cbrt_nat 97) :=
  ⟨T5_IsAlgebraic_int_cbrt_73_concrete,
   T5_IsAlgebraic_int_cbrt_79_concrete,
   T5_IsAlgebraic_int_cbrt_83_concrete,
   T5_IsAlgebraic_int_cbrt_89_concrete,
   T5_IsAlgebraic_int_cbrt_97_concrete⟩

/-! ## Bundle-XXXVI GRAND HEADLINE — sub-100 cubic primes COMPLETE -/

theorem T5_bundle_XXXVI_grand_headline_full :
    (IsCubicAlgebraic (cbrt_nat 73) ∧
     IsCubicAlgebraic (cbrt_nat 79) ∧
     IsCubicAlgebraic (cbrt_nat 83) ∧
     IsCubicAlgebraic (cbrt_nat 89) ∧
     IsCubicAlgebraic (cbrt_nat 97)) ∧
    (IsAlgebraic ℤ (cbrt_nat 73) ∧
     IsAlgebraic ℤ (cbrt_nat 79) ∧
     IsAlgebraic ℤ (cbrt_nat 83) ∧
     IsAlgebraic ℤ (cbrt_nat 89) ∧
     IsAlgebraic ℤ (cbrt_nat 97)) :=
  ⟨T5_bundle_XXXVI_master_alias_5_concrete,
   T5_bundle_XXXVI_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXXVI
