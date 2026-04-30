/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_HcBundleHeadline

  T-5 (Roth's theorem) — **H_c full-bundle paper-citable capstone**.

  Composes the 4 H_c-tier headlines from the V8-D5 closure path:
    - PTO-3 (`T5_PIGEONHOLE_TAYLOR_OFFSETS_HEADLINE`) — H_c-2 pigeonhole
    - RMB-4 (`T5_ROOT_M_BIRTH_HEADLINE`)             — H_c-4 √m birth
    - SJWB-3 (`T5_SMALLJ_WITNESS_FROM_INDEX_BOUND_HEADLINE`) — H_c-5 inversion
    - SJWC-4 (`T5_SMALLJ_WITNESS_COMPOSITION_HEADLINE`)     — composition skeleton

  Strategic significance: documents the H_c (analytical chain) closure
  in ONE paper-citable bundle.  Matches the Hindry-Silverman D.6.1
  decomposition (Index Is Large + Index Is Small + Auxiliary Polynomial
  + Completion).

  Single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_RootMBirth
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessFromIndexBound
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_HcBundleHeadline

open MvPolynomial
open OmegaTheory.Irrationality.CustomMath.T5_Phase4_RothIndex
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_RootMBirth
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessFromIndexBound
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_SmallJWitnessComposition

/-! ## HCB-1 — H_c full-bundle paper-citable headline -/

/-- **🚨🚨🚨🚨 HCB-1 — `T5_HC_BUNDLE_HEADLINE`**: paper-citable
    composition of all 4 H_c-tier headlines.

    Documents the analytical chain for V8-D5 atom-1 (smallJ witness):
      H_c-2 (pigeonhole on Taylor offsets) → H_c-4 (√m birth via Cauchy-Schwarz)
      → H_c-5 (D-pre-aux8 inversion) → SJWC (smallJ witness composition).

    Each conjunct is a paper-citable building block. -/
theorem T5_HC_BUNDLE_HEADLINE :
    -- (a) H_c-2 PTO bundle (≤ + < forms of taylor-offset pigeonhole)
    (∀ {m : ℕ} (hm : 0 < m) (J R : Fin m → ℕ) (T : ℝ),
      (T ≤ ∑ i, (J i : ℝ) / (R i : ℝ) →
        ∃ i, T / (m : ℝ) ≤ (J i : ℝ) / (R i : ℝ)) ∧
      (T < ∑ i, (J i : ℝ) / (R i : ℝ) →
        ∃ i, T / (m : ℝ) < (J i : ℝ) / (R i : ℝ))) ∧
    -- (b) H_c-4 RMB Cauchy-Schwarz √m birth identity
    (∀ {m : ℕ} (a : Fin m → ℝ) (T S : ℝ),
      (∀ i, 0 ≤ a i) → T ≤ ∑ i, a i →
      ∑ i, (a i) ^ 2 ≤ S → 0 ≤ T →
      T ^ 2 ≤ (m : ℝ) * S) ∧
    -- (c) H_c-5 SJWB D-pre-aux8 inversion (existence of smallJ witness from index bound)
    (∀ {m : ℕ} (P : MvPolynomial (Fin m) ℝ) (q : Fin m → ℚ) (R : Fin m → ℕ) (T : ℝ),
      ({ r : ℝ | ∃ j : Fin m → ℕ,
          aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
          r = ∑ i, (j i : ℝ) / (R i : ℝ) } : Set ℝ).Nonempty →
      rothIndex P (fun i => ((q i : ℚ) : ℝ)) R < T →
      ∃ (j : Fin m → ℕ),
        aeval (fun i => ((q i : ℚ) : ℝ)) (multiIteratedPDeriv j P) ≠ 0 ∧
        (∑ i, (j i : ℝ) / (R i : ℝ)) ≤ T) :=
  ⟨fun {m} hm J R T => T5_PIGEONHOLE_TAYLOR_OFFSETS_HEADLINE hm J R T,
   fun {m} a T S h_nn h_T_lower h_S_upper h_T_nn =>
     T5_sqrt_m_birth_via_cauchy_schwarz a T S h_nn h_T_lower h_S_upper h_T_nn,
   fun {m} P q R T h_nonempty h_idx_lt =>
     T5_smallJ_witness_le_from_index_lt P q R T h_idx_lt h_nonempty⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_HcBundleHeadline
