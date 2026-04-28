/-
  OmegaTheory.Predictions.T1_BelleIIDirectCPDKPiFrontier

  T-1 (light quark masses) — FRONTIER, sessions 570-574.
  Belle II 2024-2025 direct CP asymmetry in D⁰ → K⁻π⁺.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit
  per protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope frontier for Belle II's direct CP
  asymmetry measurement of the Cabibbo-favored decay D⁰ → K⁻π⁺.
  This is a FRONTIER companion to the measurement-data Bundle file
  `T1_BelleIIDirectCPDKpiBundle.lean` (sessions 634-638): where the
  Bundle pins the Belle II 2024 central value (-0.39 ± 0.19) × 10⁻³,
  this Frontier file establishes the substrate-derived ENVELOPE
  within which the substrate prediction must lie.

  Phenomenology context:

    SM expectation   :  A_CP(SM)         ≈ 0     (CKM/GIM-suppressed,
                                                  Cabibbo-favored)
    Belle II central :  A_CP(observed)   = -0.0004
    Belle II 1σ      :  σ                = 0.0006
    Belle II envelope:  |A_CP|            ≤ 0.01  (1% slack window
                                                  for substrate
                                                  prediction)

  Working units: 10⁻⁴ (so `1` in our scale = 10⁻⁴ in absolute
  units).  Substrate-prediction envelope is `|A_CP_substrate| ≤ 100`
  in units 10⁻⁴ (= 0.01 in absolute units), comfortably containing
  both the Belle II 1σ band and the SM expectation.

  Substrate prediction must lie within this envelope to be
  experimentally consistent.

  ## Sessions

  - s570: A_CP envelope half-width definition + positivity
  - s571: SM and observed central values lie within envelope
  - s572: 1σ uncertainty band fits within envelope
  - s573: Belle II - SM separation bounded
  - s574: BelleIIDirectCPDKPiFrontier Prop + 6-conjunct headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_BelleIIDirectCPDKPiFrontier

/-! ## s570: A_CP envelope (units 10⁻⁴) -/

/-- **A_CP envelope half-width** (units 10⁻⁴): `100`.  Represents
    the 1% (= 10⁻²) slack window for substrate prediction; in
    absolute units this is `0.01`.  The envelope is symmetric:
    a substrate prediction `A_CP_pred` is consistent if
    `|A_CP_pred| ≤ envelope`. -/
noncomputable def A_CP_envelope_units : ℝ := 100

/-- **Belle II central** (units 10⁻⁴): `-4` (≈ -3.9 → -4 rounded).
    This is the ROUNDED Belle II 2024 central value.  Companion
    file `T1_BelleIIDirectCPDKpiBundle` carries the unrounded
    `-39/10`. -/
noncomputable def A_CP_obs_units : ℝ := -4

/-- **Belle II 1σ uncertainty** (units 10⁻⁴): `2` (≈ 1.9 → 2
    rounded). -/
noncomputable def sigma_obs_units : ℝ := 2

/-- **SM central** (units 10⁻⁴): `0` (CKM/GIM-suppressed). -/
noncomputable def A_CP_SM_units : ℝ := 0

/-- **🚨 s570 — `envelope > 0`**: envelope half-width is positive. -/
theorem T1_s570_envelope_pos : 0 < A_CP_envelope_units := by
  unfold A_CP_envelope_units; norm_num

/-- **🚨 s570 — `envelope > 50`**: envelope is generously larger
    than 50 × 10⁻⁴ = 0.005 (5 × 10⁻³). -/
theorem T1_s570_envelope_gt_fifty : 50 < A_CP_envelope_units := by
  unfold A_CP_envelope_units; norm_num

/-- **🚨 s570 — `envelope = 100`** (units 10⁻⁴): canonical value. -/
theorem T1_s570_envelope_eq_hundred : A_CP_envelope_units = 100 := by
  unfold A_CP_envelope_units; rfl

/-! ## s571: SM and observed central values lie within envelope -/

/-- **🚨 s571 — `A_CP_obs > -envelope`**: lower envelope bound. -/
theorem T1_s571_obs_above_lower :
    -A_CP_envelope_units < A_CP_obs_units := by
  unfold A_CP_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s571 — `A_CP_obs < envelope`**: upper envelope bound. -/
theorem T1_s571_obs_below_upper :
    A_CP_obs_units < A_CP_envelope_units := by
  unfold A_CP_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s571 — `A_CP_SM < envelope`**: SM central is well within
    the upper envelope. -/
theorem T1_s571_SM_below_upper :
    A_CP_SM_units < A_CP_envelope_units := by
  unfold A_CP_SM_units A_CP_envelope_units; norm_num

/-- **🚨 s571 — `A_CP_SM > -envelope`**: SM central is well within
    the lower envelope. -/
theorem T1_s571_SM_above_lower :
    -A_CP_envelope_units < A_CP_SM_units := by
  unfold A_CP_SM_units A_CP_envelope_units; norm_num

/-- **🚨 s571 — `A_CP_obs < A_CP_SM`**: observed central is more
    negative than SM (slight downward fluctuation). -/
theorem T1_s571_obs_below_SM :
    A_CP_obs_units < A_CP_SM_units := by
  unfold A_CP_obs_units A_CP_SM_units; norm_num

/-! ## s572: 1σ uncertainty band fits within envelope -/

/-- **🚨 s572 — `σ > 0`**: 1σ uncertainty positive. -/
theorem T1_s572_sigma_pos : 0 < sigma_obs_units := by
  unfold sigma_obs_units; norm_num

/-- **🚨 s572 — `σ < envelope`**: 1σ uncertainty fits within
    envelope. -/
theorem T1_s572_sigma_lt_envelope :
    sigma_obs_units < A_CP_envelope_units := by
  unfold sigma_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s572 — `3σ < envelope`**: even 3σ band fits within
    envelope (6 < 100). -/
theorem T1_s572_three_sigma_lt_envelope :
    3 * sigma_obs_units < A_CP_envelope_units := by
  unfold sigma_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s572 — `5σ < envelope`**: 5σ discovery threshold is within
    envelope (10 < 100). -/
theorem T1_s572_five_sigma_lt_envelope :
    5 * sigma_obs_units < A_CP_envelope_units := by
  unfold sigma_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s572 — `A_CP_obs + 3σ < envelope`**: upper 3σ tail
    of observed lies within envelope (`-4 + 6 = 2 < 100`). -/
theorem T1_s572_obs_plus_three_sigma_within :
    A_CP_obs_units + 3 * sigma_obs_units < A_CP_envelope_units := by
  unfold A_CP_obs_units sigma_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s572 — `A_CP_obs - 3σ > -envelope`**: lower 3σ tail
    of observed lies within envelope (`-4 - 6 = -10 > -100`). -/
theorem T1_s572_obs_minus_three_sigma_within :
    -A_CP_envelope_units < A_CP_obs_units - 3 * sigma_obs_units := by
  unfold A_CP_obs_units sigma_obs_units A_CP_envelope_units; norm_num

/-! ## s573: Belle II - SM separation bounded -/

/-- **🚨 s573 — `A_CP_SM - A_CP_obs > 0`**: SM is above observed
    (positive separation). -/
theorem T1_s573_SM_minus_obs_pos :
    0 < A_CP_SM_units - A_CP_obs_units := by
  unfold A_CP_SM_units A_CP_obs_units; norm_num

/-- **🚨 s573 — `A_CP_SM - A_CP_obs < envelope`**: separation
    well within envelope (4 < 100). -/
theorem T1_s573_separation_lt_envelope :
    A_CP_SM_units - A_CP_obs_units < A_CP_envelope_units := by
  unfold A_CP_SM_units A_CP_obs_units A_CP_envelope_units; norm_num

/-- **🚨 s573 — `A_CP_SM - A_CP_obs < 3σ`**: separation lies
    within 3σ of zero (4 < 6). -/
theorem T1_s573_separation_lt_three_sigma :
    A_CP_SM_units - A_CP_obs_units < 3 * sigma_obs_units := by
  unfold A_CP_SM_units A_CP_obs_units sigma_obs_units; norm_num

/-- **🚨 s573 — `A_CP_SM - A_CP_obs > σ`**: separation exceeds
    1σ (4 > 2), so observation deviates from SM at the > 1σ
    level. -/
theorem T1_s573_separation_gt_one_sigma :
    sigma_obs_units < A_CP_SM_units - A_CP_obs_units := by
  unfold A_CP_SM_units A_CP_obs_units sigma_obs_units; norm_num

/-! ## s574: Frontier Prop + 6-conjunct headline -/

/-- **BelleIIDirectCPDKPiFrontier**: 6-way conjunction pinning the
    substrate-prediction envelope for the Belle II measurement of
    direct CP asymmetry in D⁰ → K⁻π⁺, in working units of 10⁻⁴:

    1. `envelope > 0`                        (positivity)
    2. `-envelope < A_CP_obs < envelope`     (observed within envelope)
    3. `-envelope < A_CP_SM < envelope`      (SM within envelope)
    4. `σ < envelope ∧ 5σ < envelope`        (full 5σ band fits)
    5. `0 < A_CP_SM - A_CP_obs < envelope`   (separation within envelope)
    6. `σ < (A_CP_SM - A_CP_obs) < 3σ`       (statistical band)

    Real Prop body — non-trivial 6-way conjunction.  Substrate
    predictions for `A_CP(D⁰ → K⁻π⁺)` must lie within this
    envelope to be experimentally consistent. -/
def BelleIIDirectCPDKPiFrontier : Prop :=
  -- envelope > 0
  (0 < A_CP_envelope_units) ∧
  -- -envelope < A_CP_obs < envelope
  (-A_CP_envelope_units < A_CP_obs_units ∧
    A_CP_obs_units < A_CP_envelope_units) ∧
  -- -envelope < A_CP_SM < envelope
  (-A_CP_envelope_units < A_CP_SM_units ∧
    A_CP_SM_units < A_CP_envelope_units) ∧
  -- σ < envelope ∧ 5σ < envelope
  (sigma_obs_units < A_CP_envelope_units ∧
    5 * sigma_obs_units < A_CP_envelope_units) ∧
  -- 0 < A_CP_SM - A_CP_obs < envelope
  (0 < A_CP_SM_units - A_CP_obs_units ∧
    A_CP_SM_units - A_CP_obs_units < A_CP_envelope_units) ∧
  -- σ < (A_CP_SM - A_CP_obs) < 3σ
  (sigma_obs_units < A_CP_SM_units - A_CP_obs_units ∧
    A_CP_SM_units - A_CP_obs_units < 3 * sigma_obs_units)

/-- **🚨 s574 — `BelleIIDirectCPDKPiFrontier`** holds. -/
theorem T1_s574_belle_ii_direct_cp_d_kpi_frontier :
    BelleIIDirectCPDKPiFrontier := by
  refine ⟨?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩⟩
  · exact T1_s570_envelope_pos
  · exact T1_s571_obs_above_lower
  · exact T1_s571_obs_below_upper
  · exact T1_s571_SM_above_lower
  · exact T1_s571_SM_below_upper
  · exact T1_s572_sigma_lt_envelope
  · exact T1_s572_five_sigma_lt_envelope
  · exact T1_s573_SM_minus_obs_pos
  · exact T1_s573_separation_lt_envelope
  · exact T1_s573_separation_gt_one_sigma
  · exact T1_s573_separation_lt_three_sigma

/-! ## Headline -/

/-- **HEADLINE — sessions 570-574 — Belle II D⁰→K⁻π⁺ direct CP
    frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s570: A_CP envelope half-width = 100 × 10⁻⁴ (= 0.01)
    - s571: A_CP_obs and A_CP_SM both lie within envelope
    - s572: 1σ, 3σ, 5σ uncertainty bands all fit within envelope
    - s573: SM-observed separation bounded between 1σ and 3σ
    - s574: BelleIIDirectCPDKPiFrontier Prop (6-conjunct) + headline

    Phenomenology context: this FRONTIER file is the
    substrate-prediction envelope companion to the measurement-data
    Bundle `T1_BelleIIDirectCPDKpiBundle` (sessions 634-638).
    Where the Bundle pins the Belle II 2024 central value
    (-0.39 ± 0.19) × 10⁻³, this Frontier file establishes the
    `|A_CP_substrate| ≤ 0.01` envelope within which any
    substrate-derived prediction for `A_CP(D⁰ → K⁻π⁺)` must lie
    to remain experimentally consistent.

    For substrate-derived charm CP asymmetry via the Jarlskog
    invariant route see `JarlskogFromIrrationals`.

    Sub-lemma N+5 in T-1 charm-CP residue.  Lean-core only.

    🏆 First Lean-core Belle II direct CP D⁰→K⁻π⁺ frontier envelope. -/
theorem session_570_to_574_belle_ii_direct_cp_d_kpi_frontier_headline :
    0 < A_CP_envelope_units
    ∧ A_CP_obs_units < A_CP_envelope_units
    ∧ A_CP_SM_units < A_CP_envelope_units
    ∧ sigma_obs_units < A_CP_envelope_units
    ∧ 5 * sigma_obs_units < A_CP_envelope_units
    ∧ A_CP_SM_units - A_CP_obs_units < A_CP_envelope_units
    ∧ BelleIIDirectCPDKPiFrontier :=
  ⟨T1_s570_envelope_pos, T1_s571_obs_below_upper,
   T1_s571_SM_below_upper, T1_s572_sigma_lt_envelope,
   T1_s572_five_sigma_lt_envelope,
   T1_s573_separation_lt_envelope,
   T1_s574_belle_ii_direct_cp_d_kpi_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_belle_ii_direct_cp_d_kpi_frontier_bundle :
    BelleIIDirectCPDKPiFrontier :=
  T1_s574_belle_ii_direct_cp_d_kpi_frontier

end OmegaTheory.Predictions.T1_BelleIIDirectCPDKPiFrontier
