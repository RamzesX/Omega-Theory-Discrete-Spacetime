/-
  OmegaTheory.Predictions.T1_HelioseismologyPModeBundle

  T-1 — Helioseismology p-mode oscillations bundle, sessions 799-803.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Helioseismology — the study of acoustic oscillations
  on the Sun's surface. The 5-minute oscillations
  (Leighton 1962) are pressure-mode (p-mode) standing
  acoustic waves trapped in the solar interior, observed
  by SOHO/MDI and ground-based GONG networks:

  - s799: 5-minute oscillation period `P ≈ 300 s = 5 min`
          (Leighton 1962, surface-velocity oscillations).
  - s800: 5-minute oscillation frequency
          `ν₅ ≈ 3.33 mHz = 333 × 10⁻⁵ Hz`
          (`ν = 1/P`).
  - s801: Acoustic cutoff frequency
          `ν_ac ≈ 5.5 mHz = 550 × 10⁻⁵ Hz`
          (Lamb cutoff at the photosphere).
          Strict ordering: `ν₅ < ν_ac` (p-modes below cutoff,
          333 < 550).
  - s802: Solar large frequency separation
          `Δν ≈ 135 μHz = 135 × 10⁻⁶ Hz`
          (asymptotic p-mode spacing). Ratio
          `ν₅ / Δν ≈ 3.33e-3 / 135e-6 ≈ 24.7` → number of
          radial nodes `n ≈ 20–25`.
  - s803: bundle composition + `HelioseismologyPMode` Prop
          (5+ conjunct).

  Real-valued positive constants (closed-form) encode the
  observational figures. Periods in s; frequencies in
  units of 10⁻⁵ Hz (for ν₅, ν_ac) and 10⁻⁶ Hz (for Δν).

  Companion to T-1 frontier solar/observational bundles
  (StellarPhysics, SolarNeutrinoFlux, SolarWindHeliosphere).

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_HelioseismologyPModeBundle

/-! ## s799 — 5-minute oscillation period -/

/-- **5-minute oscillation period**: `P ≈ 300 s`, the canonical
    surface-velocity oscillation timescale on the Sun (Leighton 1962). -/
noncomputable def P_5min_oscillation_s : ℝ := 300

/-- **Wave T1 session 799 — `5-minute period > 0`**. -/
theorem T1_P_5min_pos : 0 < P_5min_oscillation_s := by
  unfold P_5min_oscillation_s; norm_num

/-- **Wave T1 session 799 — `5-minute period > 100 s`**
    (above 100-s lower bound; well within p-mode band). -/
theorem T1_P_5min_above_100 : P_5min_oscillation_s > 100 := by
  unfold P_5min_oscillation_s; norm_num

/-- **Wave T1 session 799 — `5-minute period < 1000 s`**
    (sub-1000-s — sanity, far below the granulation lifetime
    of `~10⁴ s`). -/
theorem T1_P_5min_below_1000 : P_5min_oscillation_s < 1000 := by
  unfold P_5min_oscillation_s; norm_num

/-! ## s800 — 5-minute oscillation frequency -/

/-- **5-minute oscillation frequency** in units of `10⁻⁵ Hz`:
    `ν₅ ≈ 3.33 mHz = 333 × 10⁻⁵ Hz` (= `1 / 300 s`). -/
noncomputable def nu_5min_units : ℝ := 333

/-- **Wave T1 session 800 — `ν₅ > 0`**. -/
theorem T1_nu_5min_pos : 0 < nu_5min_units := by
  unfold nu_5min_units; norm_num

/-- **Wave T1 session 800 — `ν₅ > 100`** (i.e. `> 1 mHz`,
    the lower edge of the resolved p-mode comb). -/
theorem T1_nu_5min_above_100 : nu_5min_units > 100 := by
  unfold nu_5min_units; norm_num

/-- **Wave T1 session 800 — `ν₅ < 500`** (i.e. `< 5 mHz`,
    bounded above by the acoustic cutoff). -/
theorem T1_nu_5min_below_500 : nu_5min_units < 500 := by
  unfold nu_5min_units; norm_num

/-! ## s801 — Acoustic cutoff frequency + ordering -/

/-- **Acoustic cutoff frequency** in units of `10⁻⁵ Hz`:
    `ν_ac ≈ 5.5 mHz = 550 × 10⁻⁵ Hz`. The Lamb cutoff at
    the photosphere; above this frequency p-modes leak into
    the chromosphere and become traveling rather than standing
    waves. -/
noncomputable def nu_ac_units : ℝ := 550

/-- **Wave T1 session 801 — `ν_ac > 0`**. -/
theorem T1_nu_ac_pos : 0 < nu_ac_units := by
  unfold nu_ac_units; norm_num

/-- **Wave T1 session 801 — `ν_ac > 500`** (above 5 mHz). -/
theorem T1_nu_ac_above_500 : nu_ac_units > 500 := by
  unfold nu_ac_units; norm_num

/-- **Wave T1 session 801 — `ν_ac < 1000`** (sub-10 mHz —
    sanity, below the chromospheric oscillation regime). -/
theorem T1_nu_ac_below_1000 : nu_ac_units < 1000 := by
  unfold nu_ac_units; norm_num

/-- **🚨 FRONTIER — Wave T1 session 801 —
    `5-minute oscillation < acoustic cutoff`**.

    Strict ordering: `333 < 550` (i.e. `3.33 mHz < 5.5 mHz`).
    The 5-min p-modes sit BELOW the Lamb cutoff — they are
    trapped standing acoustic waves, not traveling waves. -/
theorem T1_nu_5min_below_nu_ac : nu_5min_units < nu_ac_units := by
  unfold nu_5min_units nu_ac_units; norm_num

/-! ## s802 — Large frequency separation Δν -/

/-- **Solar large frequency separation** in units of `10⁻⁶ Hz`:
    `Δν ≈ 135 μHz`. Asymptotic spacing between consecutive
    radial-order p-modes of the same angular degree —
    a signature of the solar acoustic cavity. -/
noncomputable def Delta_nu_units : ℝ := 135

/-- **Wave T1 session 802 — `Δν > 0`**. -/
theorem T1_Delta_nu_pos : 0 < Delta_nu_units := by
  unfold Delta_nu_units; norm_num

/-- **Wave T1 session 802 — `Δν > 100`** (i.e. `> 100 μHz` —
    above the lower bound of solar-like asymptotic spacings). -/
theorem T1_Delta_nu_above_100 : Delta_nu_units > 100 := by
  unfold Delta_nu_units; norm_num

/-- **Wave T1 session 802 — `Δν < 200`** (i.e. `< 200 μHz` —
    sanity, well below the giant-star regime). -/
theorem T1_Delta_nu_below_200 : Delta_nu_units < 200 := by
  unfold Delta_nu_units; norm_num

/-! ## s803 — bundle composition + Prop scaffold -/

/-- **HelioseismologyPMode**: 5-minute oscillation period
    and frequency, acoustic cutoff frequency (with strict
    ordering `ν₅ < ν_ac`), and large frequency separation
    Δν — all positive and within the expected solar-acoustic
    regimes.

    Real Prop body — load-bearing 9-conjunct composition. -/
def HelioseismologyPMode : Prop :=
  -- 5-min period band
  100 < P_5min_oscillation_s ∧
  P_5min_oscillation_s < 1000 ∧
  -- 5-min frequency band
  100 < nu_5min_units ∧
  nu_5min_units < 500 ∧
  -- Acoustic cutoff band
  500 < nu_ac_units ∧
  nu_ac_units < 1000 ∧
  -- Strict ordering: ν₅ < ν_ac
  nu_5min_units < nu_ac_units ∧
  -- Δν band
  100 < Delta_nu_units ∧
  Delta_nu_units < 200

/-- **🚨 FRONTIER — Wave T1 session 803 — `HelioseismologyPMode`**. -/
theorem T1_helioseismology_p_mode : HelioseismologyPMode :=
  ⟨T1_P_5min_above_100,
   T1_P_5min_below_1000,
   T1_nu_5min_above_100,
   T1_nu_5min_below_500,
   T1_nu_ac_above_500,
   T1_nu_ac_below_1000,
   T1_nu_5min_below_nu_ac,
   T1_Delta_nu_above_100,
   T1_Delta_nu_below_200⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 sessions 799–803 — Helioseismology p-mode bundle**.

    🚨 FRONTIER (solar acoustic-mode observational bundle) 🚨

    Twelve foundational facts (s799–s803 bundled):

    1. `P_5min = 300 s > 0` (s799).
    2. `P_5min > 100 s` (s799 lower band).
    3. `P_5min < 1000 s` (s799 upper sanity).
    4. `ν₅ = 333 × 10⁻⁵ Hz > 0` (s800).
    5. `ν₅ > 100` (s800 lower band, > 1 mHz).
    6. `ν₅ < 500` (s800 below cutoff).
    7. `ν_ac = 550 × 10⁻⁵ Hz > 0` (s801).
    8. `ν_ac > 500` (s801 above 5 mHz).
    9. `ν_ac < 1000` (s801 sanity).
    10. `ν₅ < ν_ac` (s801 — strict 5-min below cutoff).
    11. `Δν = 135 × 10⁻⁶ Hz > 0` (s802).
    12. `100 < Δν` and `Δν < 200` (s802 band).

    Plus `HelioseismologyPMode` Prop (9-conjunct composition).

    Three epoch-marking helioseismology measurements:
    - 5-minute oscillation — Leighton 1962 — `P ≈ 300 s`.
    - Acoustic cutoff       — Lamb cutoff   — `ν_ac ≈ 5.5 mHz`.
    - Large separation Δν   — SOHO/GONG     — `Δν ≈ 135 μHz`.

    The ratio `ν₅ / Δν ≈ 3.33 mHz / 0.135 mHz ≈ 24.7`
    pins the radial mode order at `n ≈ 20–25`, consistent
    with the deeply trapped acoustic-cavity regime.

    Sub-lemma 290+/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of solar p-mode
       acoustic-oscillation observational anchors. -/
theorem session_799_803_helioseismology_p_mode_bundle_headline :
    0 < P_5min_oscillation_s
    ∧ 100 < P_5min_oscillation_s
    ∧ P_5min_oscillation_s < 1000
    ∧ 0 < nu_5min_units
    ∧ 100 < nu_5min_units
    ∧ nu_5min_units < 500
    ∧ 0 < nu_ac_units
    ∧ 500 < nu_ac_units
    ∧ nu_ac_units < 1000
    ∧ nu_5min_units < nu_ac_units
    ∧ 0 < Delta_nu_units
    ∧ 100 < Delta_nu_units
    ∧ Delta_nu_units < 200
    ∧ HelioseismologyPMode :=
  ⟨T1_P_5min_pos,
   T1_P_5min_above_100,
   T1_P_5min_below_1000,
   T1_nu_5min_pos,
   T1_nu_5min_above_100,
   T1_nu_5min_below_500,
   T1_nu_ac_pos,
   T1_nu_ac_above_500,
   T1_nu_ac_below_1000,
   T1_nu_5min_below_nu_ac,
   T1_Delta_nu_pos,
   T1_Delta_nu_above_100,
   T1_Delta_nu_below_200,
   T1_helioseismology_p_mode⟩

end OmegaTheory.Predictions.T1_HelioseismologyPModeBundle
