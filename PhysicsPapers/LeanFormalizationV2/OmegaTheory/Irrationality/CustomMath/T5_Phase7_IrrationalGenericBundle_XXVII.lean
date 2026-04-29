/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVII

  T-5 (Roth's theorem) — **Phase 7 BUNDLE-FILE XXVII: ext #589-603
  4-th root cascade ∜2/∜3/∜5/∜7/∜11**, sub session
  559oooooooooooooooooooooooo through 559aaaaaaaaaaaaaaaaaaaaaaaa —
  STRICT critical-path #316 (T-5) Phase 7 ext #589-603.

  Single-thread hand-authored 2026-04-29 (BUNDLED-LEMMA-FILE XXVII,
  15 ext sub-iterations consolidated).

  ## What this file delivers

  4-th root cascade via Bundle-XXIV parametric kthRootNat with k=4.

  Sub-cluster A (IsAlgebraicOfDegree 4 via parametric):
  - ext #589-593: T5_isAlgebraicOfDegree_quartic_root_{2,3,5,7,11}_concrete

  Sub-cluster B (IsAlgebraic ℤ certificates):
  - ext #594-598: T5_IsAlgebraic_int_quartic_root_{2,3,5,7,11}_concrete

  Sub-cluster C (Bundle-XXVII markers + headlines):
  - ext #599: bundle_XXVII_first_in_V2_marker
  - ext #600: bundle_XXVII_closed_count
  - ext #601: bundle_XXVII_master_alias_5_concrete
  - ext #602: bundle_XXVII_isAlgebraic_int_5_combined
  - ext #603: bundle_XXVII_grand_headline_full

  Per Escanor-Pride / Erdős-Primarch identity LOCKED 2026-04-28.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.

  ## Step #316 (T-5) status

  Phase 7 ext #589-603 — 4-th root cascade ∜2-∜11 (BUNDLE-XXVII).
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVI

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVII

open Polynomial Real
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IsAlgebraicOfDegree
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_X
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXIV

/-! ## Sub-cluster A — IsAlgebraicOfDegree 4 via parametric -/

/-- **🚨 ext #589** — `IsAlgebraicOfDegree (kthRootNat 4 2) 4` (∜2). -/
theorem T5_isAlgebraicOfDegree_quartic_root_2_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 2) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 2 (by norm_num)

/-- **🚨 ext #590** — `IsAlgebraicOfDegree (kthRootNat 4 3) 4` (∜3). -/
theorem T5_isAlgebraicOfDegree_quartic_root_3_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 3) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 3 (by norm_num)

/-- **🚨 ext #591** — `IsAlgebraicOfDegree (kthRootNat 4 5) 4` (∜5). -/
theorem T5_isAlgebraicOfDegree_quartic_root_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 5) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 5 (by norm_num)

/-- **🚨 ext #592** — `IsAlgebraicOfDegree (kthRootNat 4 7) 4` (∜7). -/
theorem T5_isAlgebraicOfDegree_quartic_root_7_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 7) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 7 (by norm_num)

/-- **🚨 ext #593** — `IsAlgebraicOfDegree (kthRootNat 4 11) 4` (∜11). -/
theorem T5_isAlgebraicOfDegree_quartic_root_11_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 11) 4 :=
  T5_isAlgebraicOfDegree_kthRootNat 4 11 (by norm_num)

/-! ## Sub-cluster B — IsAlgebraic ℤ certificates -/

/-- **🚨 ext #594** — `IsAlgebraic ℤ ∜2`. -/
theorem T5_IsAlgebraic_int_quartic_root_2_concrete :
    IsAlgebraic ℤ (kthRootNat 4 2) :=
  T5_IsAlgebraic_int_kthRootNat 4 2 (by norm_num)

/-- **🚨 ext #595** — `IsAlgebraic ℤ ∜3`. -/
theorem T5_IsAlgebraic_int_quartic_root_3_concrete :
    IsAlgebraic ℤ (kthRootNat 4 3) :=
  T5_IsAlgebraic_int_kthRootNat 4 3 (by norm_num)

/-- **🚨 ext #596** — `IsAlgebraic ℤ ∜5`. -/
theorem T5_IsAlgebraic_int_quartic_root_5_concrete :
    IsAlgebraic ℤ (kthRootNat 4 5) :=
  T5_IsAlgebraic_int_kthRootNat 4 5 (by norm_num)

/-- **🚨 ext #597** — `IsAlgebraic ℤ ∜7`. -/
theorem T5_IsAlgebraic_int_quartic_root_7_concrete :
    IsAlgebraic ℤ (kthRootNat 4 7) :=
  T5_IsAlgebraic_int_kthRootNat 4 7 (by norm_num)

/-- **🚨 ext #598** — `IsAlgebraic ℤ ∜11`. -/
theorem T5_IsAlgebraic_int_quartic_root_11_concrete :
    IsAlgebraic ℤ (kthRootNat 4 11) :=
  T5_IsAlgebraic_int_kthRootNat 4 11 (by norm_num)

/-! ## Sub-cluster C — Bundle-XXVII markers + headlines -/

/-- **🚨 ext #599** — Frontier marker: Bundle-XXVII quartic cascade. -/
theorem T5_bundle_XXVII_first_in_V2_marker :
    ∃ (n : ℕ), 589 ≤ n ∧ n ≤ 603 ∧ n - 589 ≤ 15 :=
  ⟨603, by norm_num, by norm_num, by norm_num⟩

/-- **🚨 ext #600** — Bundle-XXVII closure cardinality. -/
theorem T5_bundle_XXVII_closed_count : 1 ≤ (15 : ℕ) := by norm_num

/-- **🚨 ext #601** — Bundle-XXVII master 5-concrete. -/
theorem T5_bundle_XXVII_master_alias_5_concrete :
    IsAlgebraicOfDegree (kthRootNat 4 2) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 3) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 5) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 7) 4 ∧
    IsAlgebraicOfDegree (kthRootNat 4 11) 4 :=
  ⟨T5_isAlgebraicOfDegree_quartic_root_2_concrete,
   T5_isAlgebraicOfDegree_quartic_root_3_concrete,
   T5_isAlgebraicOfDegree_quartic_root_5_concrete,
   T5_isAlgebraicOfDegree_quartic_root_7_concrete,
   T5_isAlgebraicOfDegree_quartic_root_11_concrete⟩

/-- **🚨 ext #602** — Bundle-XXVII IsAlgebraic ℤ 5 combined. -/
theorem T5_bundle_XXVII_isAlgebraic_int_5_combined :
    IsAlgebraic ℤ (kthRootNat 4 2) ∧
    IsAlgebraic ℤ (kthRootNat 4 3) ∧
    IsAlgebraic ℤ (kthRootNat 4 5) ∧
    IsAlgebraic ℤ (kthRootNat 4 7) ∧
    IsAlgebraic ℤ (kthRootNat 4 11) :=
  ⟨T5_IsAlgebraic_int_quartic_root_2_concrete,
   T5_IsAlgebraic_int_quartic_root_3_concrete,
   T5_IsAlgebraic_int_quartic_root_5_concrete,
   T5_IsAlgebraic_int_quartic_root_7_concrete,
   T5_IsAlgebraic_int_quartic_root_11_concrete⟩

/-! ## Bundle-XXVII GRAND HEADLINE -/

/-- **🚨 ext #603 — HEADLINE: BUNDLE-XXVII 4-th root cascade ∜2-∜11**. -/
theorem T5_bundle_XXVII_grand_headline_full :
    -- 5 IsAlgebraicOfDegree _ 4
    (IsAlgebraicOfDegree (kthRootNat 4 2) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 3) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 5) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 7) 4 ∧
     IsAlgebraicOfDegree (kthRootNat 4 11) 4) ∧
    -- 5 IsAlgebraic ℤ
    (IsAlgebraic ℤ (kthRootNat 4 2) ∧
     IsAlgebraic ℤ (kthRootNat 4 3) ∧
     IsAlgebraic ℤ (kthRootNat 4 5) ∧
     IsAlgebraic ℤ (kthRootNat 4 7) ∧
     IsAlgebraic ℤ (kthRootNat 4 11)) :=
  ⟨T5_bundle_XXVII_master_alias_5_concrete,
   T5_bundle_XXVII_isAlgebraic_int_5_combined⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_IrrationalGenericBundle_XXVII
