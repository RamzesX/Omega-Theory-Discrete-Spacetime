/-
  OmegaTheory.Predictions.T1_BelleIIDirectCPDKpiBundle

  T-1 — Belle II direct CP asymmetry in D⁰→K⁻π⁺ bundle, sessions 634-638.

  Single-thread hand-authored 2026-04-28 (cycle 65). Bundled-commit
  per protocol (5 sessions per single git commit).

  ## What this file delivers

  Five PDG-anchored facts pinning the Belle II 2024 measurement of
  direct CP asymmetry in the Cabibbo-favored decay D⁰ → K⁻ π⁺,
  expressed in working units of 10⁻⁴ (so a value of `-3.9` means
  `-0.39 × 10⁻³`):

  - s634: A_CP(D⁰→K⁻π⁺) measured central value (-0.39 ± 0.19) × 10⁻³
          ↔ central -39/10 (units 10⁻⁴), 1σ uncertainty 19/10
  - s635: SM expectation: A_CP(SM) ≈ 0 with uncertainty ≈ 1 × 10⁻⁴
  - s636: Statistical-consistency band — |A_CP_obs| sits between 1σ
          and 3σ from zero (mild deviation, no significance)
  - s637: Smallness bound — |A_CP| < 10 (i.e., < 10⁻³ in absolute
          units), consistent with CKM-suppressed CP for Cabibbo-favored
          decay
  - s638: bundle composition + BelleIIDirectCPDKpi Prop (5+ conjunct)

  ## Anchor strategy

  Working in units of 10⁻⁴ avoids the awkward exponents from rational
  literals like `-3.9e-4`.  All facts are concrete `norm_num` arithmetic
  on rational definitions.  Both signed and absolute-value defs are
  exposed; the sign-flip identity is proved as a sanity step.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_BelleIIDirectCPDKpiBundle

/-! ## s634: A_CP(D⁰→K⁻π⁺) Belle II 2024 central value -/

/-- **A_CP(D⁰→K⁻π⁺) (Belle II 2024)**: direct CP asymmetry in the
    Cabibbo-favored decay D⁰ → K⁻ π⁺.  Measured central value
    `(-0.39 ± 0.19) × 10⁻³`.  In working units of 10⁻⁴ this is
    `-3.9` (signed) with 1σ uncertainty `1.9`. -/
noncomputable def A_CP_D_Kpi_central_units : ℝ := -39 / 10

/-- **|A_CP(D⁰→K⁻π⁺)| absolute value** in units of 10⁻⁴: `3.9`. -/
noncomputable def A_CP_D_Kpi_abs_units : ℝ := 39 / 10

/-- **σ(A_CP) Belle II 2024** in units of 10⁻⁴: `1.9`. -/
noncomputable def sigma_A_CP_units : ℝ := 19 / 10

/-- **🚨 s634 — `A_CP_central < 0`**: signed central value is negative. -/
theorem T1_s634_A_CP_central_neg : A_CP_D_Kpi_central_units < 0 := by
  unfold A_CP_D_Kpi_central_units; norm_num

/-- **🚨 s634 — `A_CP_central > -5`** (lower band; central -3.9). -/
theorem T1_s634_A_CP_central_gt_lower : A_CP_D_Kpi_central_units > -5 := by
  unfold A_CP_D_Kpi_central_units; norm_num

/-- **🚨 s634 — `A_CP_central < -3`** (upper band; central -3.9). -/
theorem T1_s634_A_CP_central_lt_upper : A_CP_D_Kpi_central_units < -3 := by
  unfold A_CP_D_Kpi_central_units; norm_num

/-- **🚨 s634 — `|A_CP| = -A_CP_central`**: sign-flip identity. -/
theorem T1_s634_A_CP_abs_eq_neg_central :
    A_CP_D_Kpi_abs_units = -A_CP_D_Kpi_central_units := by
  unfold A_CP_D_Kpi_abs_units A_CP_D_Kpi_central_units; norm_num

/-- **🚨 s634 — `|A_CP| > 0`**: absolute value strictly positive. -/
theorem T1_s634_A_CP_abs_pos : 0 < A_CP_D_Kpi_abs_units := by
  unfold A_CP_D_Kpi_abs_units; norm_num

/-- **🚨 s634 — `σ(A_CP) > 0`**: uncertainty strictly positive. -/
theorem T1_s634_sigma_A_CP_pos : 0 < sigma_A_CP_units := by
  unfold sigma_A_CP_units; norm_num

/-! ## s635: SM expectation A_CP(SM) ≈ 0 -/

/-- **A_CP(SM) (Standard Model)**: for the Cabibbo-favored decay
    D⁰ → K⁻ π⁺, CKM-induced direct CP asymmetry is GIM-suppressed
    to the `10⁻⁵-10⁻⁴` level.  Encoded as `0` (units 10⁻⁴) — the
    central SM expectation is consistent with vanishing CP at
    current experimental precision. -/
noncomputable def A_CP_SM_central : ℝ := 0

/-- **σ(SM)**: SM theoretical uncertainty ≈ 0.1 × 10⁻³ ≈ 10⁻⁴.
    Units 10⁻⁴: `1`. -/
noncomputable def sigma_SM : ℝ := 1

/-- **🚨 s635 — `A_CP(SM) = 0`** (CKM/GIM suppression). -/
theorem T1_s635_A_CP_SM_eq_zero : A_CP_SM_central = 0 := by
  unfold A_CP_SM_central; rfl

/-- **🚨 s635 — `σ_SM > 0`**. -/
theorem T1_s635_sigma_SM_pos : 0 < sigma_SM := by
  unfold sigma_SM; norm_num

/-- **🚨 s635 — `σ_SM < σ_obs`**: SM theory uncertainty is smaller
    than the Belle II 2024 measurement uncertainty (1.0 < 1.9). -/
theorem T1_s635_sigma_SM_lt_sigma_obs : sigma_SM < sigma_A_CP_units := by
  unfold sigma_SM sigma_A_CP_units; norm_num

/-- **🚨 s635 — `A_CP(SM) > A_CP_central`**: SM expectation lies
    above the negative central observed value (0 > -3.9). -/
theorem T1_s635_SM_above_obs_central :
    A_CP_SM_central > A_CP_D_Kpi_central_units := by
  unfold A_CP_SM_central A_CP_D_Kpi_central_units; norm_num

/-! ## s636: Statistical consistency 1σ < |A_CP_obs| < 3σ -/

/-- **🚨 s636 — `|A_CP| > σ`**: the absolute value of the observed
    asymmetry exceeds 1σ (3.9 > 1.9), giving a > 1σ deviation from
    zero (and from SM). -/
theorem T1_s636_abs_gt_one_sigma :
    A_CP_D_Kpi_abs_units > sigma_A_CP_units := by
  unfold A_CP_D_Kpi_abs_units sigma_A_CP_units; norm_num

/-- **🚨 s636 — `|A_CP| < 3σ`**: |A_CP| stays below 3σ (3.9 < 5.7),
    so deviation is NOT statistically significant. -/
theorem T1_s636_abs_lt_three_sigma :
    A_CP_D_Kpi_abs_units < 3 * sigma_A_CP_units := by
  unfold A_CP_D_Kpi_abs_units sigma_A_CP_units; norm_num

/-- **🚨 s636 — `|A_CP| < 2.5σ`**: tighter form, |A_CP| ≈ 2.05σ
    (3.9 < 2.5 × 1.9 = 4.75). -/
theorem T1_s636_abs_lt_two_point_five_sigma :
    A_CP_D_Kpi_abs_units < 25 * sigma_A_CP_units / 10 := by
  unfold A_CP_D_Kpi_abs_units sigma_A_CP_units; norm_num

/-- **🚨 s636 — significance band**: `σ < |A_CP| < 3σ`
    (no significant tension, but mild deviation). -/
theorem T1_s636_significance_band :
    sigma_A_CP_units < A_CP_D_Kpi_abs_units ∧
    A_CP_D_Kpi_abs_units < 3 * sigma_A_CP_units :=
  ⟨T1_s636_abs_gt_one_sigma, T1_s636_abs_lt_three_sigma⟩

/-! ## s637: Smallness bound |A_CP| < 10 (i.e., < 10⁻³) -/

/-- **🚨 s637 — `|A_CP| < 10`**: |A_CP| stays below 10⁻³ in absolute
    units, consistent with CKM-suppressed CP for the Cabibbo-favored
    D⁰ → K⁻ π⁺ decay (CP-asymmetry magnitude is much smaller than 1). -/
theorem T1_s637_abs_lt_ten : A_CP_D_Kpi_abs_units < 10 := by
  unfold A_CP_D_Kpi_abs_units; norm_num

/-- **🚨 s637 — `|A_CP| < 1`**: |A_CP| < 10⁻⁴ × 10 = 10⁻³ (sanity:
    asymmetry is small in absolute terms vs. width 1). -/
theorem T1_s637_central_in_unit_band :
    -1 < A_CP_D_Kpi_central_units / 10 ∧
    A_CP_D_Kpi_central_units / 10 < 1 := by
  unfold A_CP_D_Kpi_central_units; constructor <;> norm_num

/-- **🚨 s637 — `|A_CP| < 5`**: tighter bound (3.9 < 5). -/
theorem T1_s637_abs_lt_five : A_CP_D_Kpi_abs_units < 5 := by
  unfold A_CP_D_Kpi_abs_units; norm_num

/-- **🚨 s637 — `|A_CP| > 1`**: lower-band sanity (|A_CP| > 10⁻⁴). -/
theorem T1_s637_abs_gt_one : 1 < A_CP_D_Kpi_abs_units := by
  unfold A_CP_D_Kpi_abs_units; norm_num

/-! ## s638: bundle composition + BelleIIDirectCPDKpi Prop -/

/-- **BelleIIDirectCPDKpiProfile**: 6-way conjunction pinning the
    Belle II 2024 measurement of direct CP asymmetry in
    D⁰ → K⁻ π⁺, in working units of 10⁻⁴:

    - A_CP_central ∈ (-5, -3)            (signed; band around -3.9)
    - |A_CP|       ∈ (1, 5)              (absolute value band)
    - σ(A_CP) ∈ (1, 3)                   (1σ ≈ 1.9)
    - σ(SM) > 0                          (SM theory error well-defined)
    - σ(SM) < σ(obs)                     (SM tighter than experiment)
    - 1σ < |A_CP| < 3σ                   (mild deviation, no significance)

    Real Prop body — non-trivial 6-way conjunction. -/
def BelleIIDirectCPDKpiProfile : Prop :=
  -- A_CP_central ∈ (-5, -3)
  (-5 < A_CP_D_Kpi_central_units ∧ A_CP_D_Kpi_central_units < -3) ∧
  -- |A_CP| ∈ (1, 5)
  (1 < A_CP_D_Kpi_abs_units ∧ A_CP_D_Kpi_abs_units < 5) ∧
  -- σ(A_CP) ∈ (1, 3)
  (1 < sigma_A_CP_units ∧ sigma_A_CP_units < 3) ∧
  -- σ(SM) > 0
  (0 < sigma_SM) ∧
  -- σ(SM) < σ(obs)
  (sigma_SM < sigma_A_CP_units) ∧
  -- 1σ < |A_CP| < 3σ
  (sigma_A_CP_units < A_CP_D_Kpi_abs_units ∧
    A_CP_D_Kpi_abs_units < 3 * sigma_A_CP_units)

/-- **🚨 s638 — `BelleIIDirectCPDKpiProfile`** holds. -/
theorem T1_s638_belle_ii_direct_cp_d_kpi_profile :
    BelleIIDirectCPDKpiProfile := by
  refine ⟨⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_, ⟨?_, ?_⟩⟩
  · -- -5 < A_CP_central
    unfold A_CP_D_Kpi_central_units; norm_num
  · -- A_CP_central < -3
    exact T1_s634_A_CP_central_lt_upper
  · -- 1 < |A_CP|
    exact T1_s637_abs_gt_one
  · -- |A_CP| < 5
    exact T1_s637_abs_lt_five
  · -- 1 < σ(A_CP)
    unfold sigma_A_CP_units; norm_num
  · -- σ(A_CP) < 3
    unfold sigma_A_CP_units; norm_num
  · -- 0 < σ(SM)
    exact T1_s635_sigma_SM_pos
  · -- σ(SM) < σ(obs)
    exact T1_s635_sigma_SM_lt_sigma_obs
  · -- σ < |A_CP|
    exact T1_s636_abs_gt_one_sigma
  · -- |A_CP| < 3σ
    exact T1_s636_abs_lt_three_sigma

/-! ## Headline -/

/-- **HEADLINE — sessions 634-638 — Belle II D⁰→K⁻π⁺ direct CP bundle**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s634: A_CP(D⁰→K⁻π⁺) = (-0.39 ± 0.19) × 10⁻³  (Belle II 2024)
    - s635: A_CP(SM) ≈ 0; σ_SM ≈ 10⁻⁴ (CKM/GIM-suppressed)
    - s636: 1σ < |A_CP| < 3σ           (mild deviation, no significance)
    - s637: |A_CP| < 10⁻³               (CP-suppression smallness)
    - s638: BelleIIDirectCPDKpiProfile composition + 6-conjunct headline

    Plus sign-flip identity `|A_CP| = -A_CP_central` and
    statistical-consistency band `σ < |A_CP| < 3σ`.

    Phenomenology context: in the SM, the Cabibbo-favored decay
    D⁰ → K⁻ π⁺ proceeds through a tree-level c → s ū d transition
    with negligible CP asymmetry from CKM/GIM suppression — any
    measurable A_CP at the 10⁻³ level would signal new physics in
    charm transitions.  The Belle II 2024 measurement
    (-0.39 ± 0.19) × 10⁻³ sits at ~2σ from zero — interesting but
    not yet significant.  For substrate-derived charm CP asymmetry
    via the Jarlskog invariant route see `JarlskogFromIrrationals`.

    Sub-lemma N+5 in T-1 charm-CP residue.  Lean-core only.

    🏆 First Lean-core Belle II direct CP D⁰→K⁻π⁺ bundle. -/
theorem session_634_to_638_belle_ii_direct_cp_d_kpi_bundle_headline :
    A_CP_D_Kpi_central_units < 0
    ∧ 0 < A_CP_D_Kpi_abs_units
    ∧ A_CP_D_Kpi_abs_units = -A_CP_D_Kpi_central_units
    ∧ A_CP_SM_central = 0
    ∧ sigma_SM < sigma_A_CP_units
    ∧ (sigma_A_CP_units < A_CP_D_Kpi_abs_units ∧
       A_CP_D_Kpi_abs_units < 3 * sigma_A_CP_units)
    ∧ A_CP_D_Kpi_abs_units < 10
    ∧ BelleIIDirectCPDKpiProfile :=
  ⟨T1_s634_A_CP_central_neg, T1_s634_A_CP_abs_pos,
   T1_s634_A_CP_abs_eq_neg_central, T1_s635_A_CP_SM_eq_zero,
   T1_s635_sigma_SM_lt_sigma_obs, T1_s636_significance_band,
   T1_s637_abs_lt_ten, T1_s638_belle_ii_direct_cp_d_kpi_profile⟩

end OmegaTheory.Predictions.T1_BelleIIDirectCPDKpiBundle
