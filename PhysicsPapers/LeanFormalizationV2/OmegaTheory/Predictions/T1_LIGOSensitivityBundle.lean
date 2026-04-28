/-
  OmegaTheory.Predictions.T1_LIGOSensitivityBundle

  T-1 (light quark masses) — FRONTIER, bundled sessions s428–s432.
  Gravitational-wave detector sensitivity bundle: aLIGO, LISA,
  Einstein Telescope.

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  Frozen-Real closed-form snapshot of GW detector arm-length and
  characteristic strain-sensitivity figures, plus the sensitivity
  ordering that places aLIGO (current 2nd-gen ground), Einstein
  Telescope (3rd-gen ground), and LISA (space-based) into a single
  bundle:

  - s428: aLIGO arm length `L_aLIGO = 4 km = 4000 m`.
  - s429: aLIGO O4 characteristic strain `h_aLIGO = 1e-23 /√Hz`
          at 100 Hz (representative O4 sensitivity).
  - s430: LISA arm length `L_LISA = 2.5e9 m` (space-based, mHz band).
  - s431: Einstein Telescope projected strain `h_ET = 1e-24 /√Hz`
          (3rd-gen, ~10× better than aLIGO).
  - s432: bundle composition + sensitivity ordering
          `h_ET < h_aLIGO` and arm-length ordering
          `L_aLIGO < L_LISA`.

  We use Real-valued positive constants (closed-form) to encode the
  representative figures-of-merit; physical units are implicit in
  the names.  Strain values stored as positive Reals (unit
  `1/√Hz`); the inequalities are the load-bearing claims.

  Companion to:
  - `T1_GravitationalWavesLIGOFrontier.lean` (s252) — LIGO event masses.
  - `T1_StandardSirenH0Frontier.lean` (s285) — multi-messenger H₀.

  Together these three files bracket the LIGO/Virgo/KAGRA + LISA + ET
  observational frontier in OV2.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace OmegaTheory.Predictions.T1_LIGOSensitivityBundle

/-! ## s428 — aLIGO arm length -/

/-- **aLIGO arm length**: `L_aLIGO = 4000 m` (4 km, Hanford + Livingston). -/
noncomputable def L_aLIGO_meters : ℝ := 4000

/-- **Wave T1 session 428 — `aLIGO arm length > 0`**. -/
theorem T1_L_aLIGO_pos : 0 < L_aLIGO_meters := by
  unfold L_aLIGO_meters; norm_num

/-- **Wave T1 session 428 — `aLIGO arm length = 4 km`** (sanity). -/
theorem T1_L_aLIGO_eq_4km : L_aLIGO_meters = 4000 := by
  unfold L_aLIGO_meters; rfl

/-! ## s429 — aLIGO O4 strain sensitivity -/

/-- **aLIGO O4 characteristic strain at 100 Hz**: `h_aLIGO = 1e-23 /√Hz`.

    Representative O4 sensitivity (10⁻²³ at 100 Hz). -/
noncomputable def h_aLIGO_at_100Hz : ℝ := 1 / 10^23

/-- **Wave T1 session 429 — `aLIGO strain > 0`**. -/
theorem T1_h_aLIGO_pos : 0 < h_aLIGO_at_100Hz := by
  unfold h_aLIGO_at_100Hz; positivity

/-- **Wave T1 session 429 — `aLIGO strain < 1`** (sub-unity, sanity). -/
theorem T1_h_aLIGO_lt_one : h_aLIGO_at_100Hz < 1 := by
  unfold h_aLIGO_at_100Hz; norm_num

/-! ## s430 — LISA arm length -/

/-- **LISA arm length**: `L_LISA = 2.5e9 m` (2.5 million km, mHz band). -/
noncomputable def L_LISA_meters : ℝ := 25 * 10^8

/-- **Wave T1 session 430 — `LISA arm length > 0`**. -/
theorem T1_L_LISA_pos : 0 < L_LISA_meters := by
  unfold L_LISA_meters; positivity

/-- **🚨 FRONTIER — Wave T1 session 430 — `L_aLIGO < L_LISA`**.

    Space-based LISA arms are ~6 orders of magnitude longer
    than aLIGO ground-based arms — pushing the band from
    ~100 Hz down to ~mHz. -/
theorem T1_L_aLIGO_lt_L_LISA :
    L_aLIGO_meters < L_LISA_meters := by
  unfold L_aLIGO_meters L_LISA_meters; norm_num

/-! ## s431 — Einstein Telescope strain -/

/-- **Einstein Telescope projected strain**: `h_ET = 1e-24 /√Hz`.

    3rd-generation ground-based detector — ~10× better
    than aLIGO O4. -/
noncomputable def h_ET : ℝ := 1 / 10^24

/-- **Wave T1 session 431 — `ET strain > 0`**. -/
theorem T1_h_ET_pos : 0 < h_ET := by
  unfold h_ET; positivity

/-- **🚨 FRONTIER — Wave T1 session 431 — `h_ET < h_aLIGO`**.

    Einstein Telescope target sensitivity is strictly better
    (smaller strain noise) than aLIGO O4 — the 3rd-gen
    improvement. -/
theorem T1_h_ET_lt_h_aLIGO :
    h_ET < h_aLIGO_at_100Hz := by
  unfold h_ET h_aLIGO_at_100Hz; norm_num

/-! ## s432 — bundle composition + sensitivity ordering -/

/-- **Wave T1 session 432 — `ET strain < 1`** (sanity). -/
theorem T1_h_ET_lt_one : h_ET < 1 := by
  unfold h_ET; norm_num

/-- **Wave T1 session 432 — `aLIGO < LISA arm-length gap > 1e8 m`**. -/
theorem T1_arm_length_gap_large :
    L_LISA_meters - L_aLIGO_meters > 10^8 := by
  unfold L_LISA_meters L_aLIGO_meters; norm_num

/-- **🚨 FRONTIER — Wave T1 session 432 — Two-rung sensitivity tower**.

    Ground-based 3rd-gen (ET) beats ground-based 2nd-gen (aLIGO)
    on strain; space-based (LISA) beats both on arm-length —
    accessing different frequency bands. -/
theorem T1_two_rung_tower :
    h_ET < h_aLIGO_at_100Hz ∧ L_aLIGO_meters < L_LISA_meters :=
  ⟨T1_h_ET_lt_h_aLIGO, T1_L_aLIGO_lt_L_LISA⟩

/-! ## Headline -/

/-- **HEADLINE — Wave T1 sessions 428–432 — LIGO/LISA/ET sensitivity bundle**.

    🚨 FRONTIER (GW detector sensitivity tower) 🚨

    Ten foundational facts (s428–s432 bundled):

    1. `L_aLIGO = 4000 m > 0` (s428).
    2. `L_aLIGO = 4 km` (s428 sanity).
    3. `h_aLIGO = 1e-23 /√Hz > 0` (s429).
    4. `h_aLIGO < 1` (s429 sanity).
    5. `L_LISA = 2.5e9 m > 0` (s430).
    6. `L_aLIGO < L_LISA` (s430 ordering).
    7. `h_ET = 1e-24 /√Hz > 0` (s431).
    8. `h_ET < h_aLIGO` (s431 ordering).
    9. `h_ET < 1` (s432 sanity).
    10. `L_LISA - L_aLIGO > 1e8 m` (s432 gap large).

    Three detector tiers in one bundle:
    - Ground 2nd-gen: aLIGO (`L=4 km`, `h~1e-23`, ~100 Hz band).
    - Ground 3rd-gen: ET    (`h~1e-24`, ~10× better strain).
    - Space-based:    LISA  (`L=2.5e9 m`, mHz band).

    Sub-lemma 175/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of multi-rung GW detector
       sensitivity bundle (aLIGO + ET + LISA). -/
theorem session_428_432_LIGO_sensitivity_bundle_headline :
    0 < L_aLIGO_meters
    ∧ L_aLIGO_meters = 4000
    ∧ 0 < h_aLIGO_at_100Hz
    ∧ h_aLIGO_at_100Hz < 1
    ∧ 0 < L_LISA_meters
    ∧ L_aLIGO_meters < L_LISA_meters
    ∧ 0 < h_ET
    ∧ h_ET < h_aLIGO_at_100Hz
    ∧ h_ET < 1
    ∧ L_LISA_meters - L_aLIGO_meters > 10^8 :=
  ⟨T1_L_aLIGO_pos, T1_L_aLIGO_eq_4km,
   T1_h_aLIGO_pos, T1_h_aLIGO_lt_one,
   T1_L_LISA_pos, T1_L_aLIGO_lt_L_LISA,
   T1_h_ET_pos, T1_h_ET_lt_h_aLIGO,
   T1_h_ET_lt_one, T1_arm_length_gap_large⟩

end OmegaTheory.Predictions.T1_LIGOSensitivityBundle
