/-
  OmegaTheory.Irrationality.CustomMath.T5_Phase7_RootMBirth

  T-5 (Roth's theorem) — **THE √m BIRTH composition** (H_c-4).

  Combines H_c-1 (pigeonhole on Fin m), H_c-2 (Taylor offsets), AM-QM
  (Cauchy-Schwarz √m factor), and weighted-sum scaling to show how
  the gap `√(mε)` arises naturally from the multivariate Roth-index
  reduction.

  This is the analytical HEART of the V8-D5 smallJ witness derivation.
  Given a multi-index `J : Fin m → ℕ` with weighted sum `≥ t`, we
  extract a coordinate `i` whose ratio `J_i / R_i ≥ t/m`, and apply
  the AM-QM inequality to convert ε-level bounds at the R-level into
  √(mε)-level bounds at the m-coordinate level.

  H_c-4 packaging — single-thread hand-authored 2026-04-30.
  Per project rule §7.0 NO STUBS.
-/

import OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets
import OmegaTheory.Irrationality.CustomMath.T5_Phase7_AM_QM_Helpers

namespace OmegaTheory.Irrationality.CustomMath.T5_Phase7_RootMBirth

open Finset
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeFinM_Helpers
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_PigeonholeTaylorOffsets
open OmegaTheory.Irrationality.CustomMath.T5_Phase7_AM_QM_Helpers

/-! ## RMB-1 — Threshold gap survives pigeonhole -/

/-- **`T5_threshold_gap_survives_pigeonhole`**: if `∑_i J_i/R_i ≥ t - √(mε)`,
    then there exists a coordinate `i` with `J_i / R_i ≥ (t - √(mε)) / m`.

    Direct consequence of H_c-2 (`T5_pigeonhole_taylor_offset_max`) at
    `T = t - √(mε)`.  Used in V8-D5 to extract a distinguished Taylor
    coordinate after the √(mε) gap has been subtracted from the
    rothIndex lower bound. -/
theorem T5_threshold_gap_survives_pigeonhole
    {m : ℕ} (hm : 0 < m) (J R : Fin m → ℕ)
    (t ε : ℝ) (hε : 0 ≤ ε)
    (h_lower : t - Real.sqrt ((m : ℝ) * ε) ≤ ∑ i, (J i : ℝ) / (R i : ℝ)) :
    ∃ i : Fin m, (t - Real.sqrt ((m : ℝ) * ε)) / (m : ℝ) ≤
      (J i : ℝ) / (R i : ℝ) := by
  exact T5_pigeonhole_taylor_offset_max hm J R (t - Real.sqrt ((m : ℝ) * ε)) h_lower

/-! ## RMB-2 — Per-coord scaling of weighted-sum bound -/

/-- **`T5_per_coord_weighted_bound`**: when `∑ aᵢ ≥ T`, the max
    coordinate satisfies `aᵢ ≥ T/m`, and squaring this gives
    `aᵢ² ≥ (T/m)²`.

    Used to feed the AM-QM lower-bound into the per-coord bound chain. -/
theorem T5_per_coord_weighted_bound
    {m : ℕ} (hm : 0 < m) (a : Fin m → ℝ)
    (h_nn : ∀ i, 0 ≤ a i) (T : ℝ) (h_T_nn : 0 ≤ T)
    (h_lower : T ≤ ∑ i, a i) :
    ∃ i, (T / (m : ℝ)) ^ 2 ≤ (a i) ^ 2 := by
  obtain ⟨i, h_max⟩ :=
    T5_pigeonhole_max_at_least_average hm a
  refine ⟨i, ?_⟩
  -- T ≤ ∑ a ≤ m · a i, so T/m ≤ a i
  have h_m_pos : (0 : ℝ) < (m : ℝ) := by exact_mod_cast hm
  have h_T_le_m_ai : T ≤ (m : ℝ) * a i := le_trans h_lower h_max
  have h_T_div_m_le : T / (m : ℝ) ≤ a i := by
    rw [div_le_iff₀ h_m_pos]; linarith
  have h_T_div_m_nn : 0 ≤ T / (m : ℝ) := div_nonneg h_T_nn (le_of_lt h_m_pos)
  exact pow_le_pow_left₀ h_T_div_m_nn h_T_div_m_le 2

/-! ## RMB-3 — √m birth via Cauchy-Schwarz -/

/-- **`T5_sqrt_m_birth_via_cauchy_schwarz`**: the √m factor in the
    smallJ-witness bound emerges from Cauchy-Schwarz applied to the
    1-norm vs 2-norm comparison.

    Given `∑ aᵢ ≥ T` and `∑ aᵢ² ≤ S`, we have `T ≤ ∑ aᵢ ≤ √m · √S`.
    Squaring: `T² ≤ m · S`.

    This is the algebraic identity that converts ε-level Taylor
    bounds (∑ a²) into √(mε)-level pigeonhole bounds (∑ a). -/
theorem T5_sqrt_m_birth_via_cauchy_schwarz
    {m : ℕ} (a : Fin m → ℝ)
    (T S : ℝ) (h_nn : ∀ i, 0 ≤ a i)
    (h_T_lower : T ≤ ∑ i, a i)
    (h_S_upper : ∑ i, (a i) ^ 2 ≤ S)
    (h_T_nn : 0 ≤ T) :
    T ^ 2 ≤ (m : ℝ) * S := by
  -- (∑ a)² ≤ m · (∑ a²) by AM-QM
  have h_AM_QM := T5_AM_QM_squared (m := m) a
  -- T ≤ ∑ a ≥ 0
  have h_sum_nn : 0 ≤ ∑ i, a i := Finset.sum_nonneg (fun i _ => h_nn i)
  have h_T_le_sum_sq : T ^ 2 ≤ (∑ i, a i) ^ 2 :=
    pow_le_pow_left₀ h_T_nn h_T_lower 2
  -- (∑ a)² ≤ m · ∑ a² ≤ m · S
  have h_m_nn : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg _
  have h_m_S : (m : ℝ) * (∑ i, (a i) ^ 2) ≤ (m : ℝ) * S :=
    mul_le_mul_of_nonneg_left h_S_upper h_m_nn
  linarith

/-! ## RMB-4 — Headline -/

/-- **🚨🚨🚨 RMB-4 — `T5_ROOT_M_BIRTH_HEADLINE`**: paper-citable bundle
    documenting the √m birth composition.

    Three forms:
    (a) Threshold gap survives pigeonhole — H_c-2 at `T - √(mε)`.
    (b) Per-coord weighted-sum scaling — squaring the max-coord bound.
    (c) √m birth via Cauchy-Schwarz — the algebraic identity converting
        ε-level 2-norm bounds into √(mε)-level 1-norm bounds.

    Strategic significance: documents how the H_c-1, H_c-2, AM-QM
    machinery composes into the √m birth needed for the V8-D5
    smallJ witness discharge. -/
theorem T5_ROOT_M_BIRTH_HEADLINE
    {m : ℕ} (hm : 0 < m) (J R : Fin m → ℕ)
    (t ε : ℝ) (hε : 0 ≤ ε) :
    -- (a) threshold gap survives pigeonhole
    (t - Real.sqrt ((m : ℝ) * ε) ≤ ∑ i, (J i : ℝ) / (R i : ℝ) →
      ∃ i, (t - Real.sqrt ((m : ℝ) * ε)) / (m : ℝ) ≤
        (J i : ℝ) / (R i : ℝ)) ∧
    -- (b) per-coord weighted-sum scaling
    (∀ (a : Fin m → ℝ) (h_nn : ∀ i, 0 ≤ a i) (T : ℝ) (h_T_nn : 0 ≤ T),
      T ≤ ∑ i, a i →
      ∃ i, (T / (m : ℝ)) ^ 2 ≤ (a i) ^ 2) ∧
    -- (c) √m birth via Cauchy-Schwarz
    (∀ (a : Fin m → ℝ) (T S : ℝ),
      (∀ i, 0 ≤ a i) → T ≤ ∑ i, a i →
      ∑ i, (a i) ^ 2 ≤ S → 0 ≤ T →
      T ^ 2 ≤ (m : ℝ) * S) :=
  ⟨T5_threshold_gap_survives_pigeonhole hm J R t ε hε,
   fun a h_nn T h_T_nn => T5_per_coord_weighted_bound hm a h_nn T h_T_nn,
   fun a T S h_nn h_T_lower h_S_upper h_T_nn =>
     T5_sqrt_m_birth_via_cauchy_schwarz a T S h_nn h_T_lower h_S_upper h_T_nn⟩

end OmegaTheory.Irrationality.CustomMath.T5_Phase7_RootMBirth
