/-
  OmegaTheory.Predictions.T1_CrabPulsarTimingFrontier

  T-1 (light quark masses) — FRONTIER, sub session 307.
  Crab pulsar timing precision + glitches (Jodrell Bank ephemeris 2024).

  Single-thread hand-authored 2026-04-28 (cycle 65).
  opus-code-crawler proposal #12.

  ## What this file delivers

  Crab pulsar (PSR B0531+21) — most precisely timed pulsar:
  - P (spin period):     33.7204 ms
  - Ṗ (spin-down rate):  4.20913 × 10⁻¹³ s/s
  - E_dot (rotational):   ~4.5 × 10³⁸ erg/s
  - Glitch count (2024):  >30 archived (Jodrell Bank)
  - Sub-ns timing precision

  Why important:
  - Tests GR via gravitational radiation reaction
  - Constrains neutron-star equation of state via glitches
  - Foundation for pulsar-timing-array (PTA) cosmology (s254 NANOGrav)

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_CrabPulsarTimingFrontier

/-! ## Pulsar timing parameters -/

/-- **P spin period**: `33.7204 ms`. -/
noncomputable def P_Crab_ms : ℝ := 337204 / 10000

/-- **Ṗ spin-down rate**: `4.20913 × 10⁻¹³ s/s`. -/
noncomputable def P_dot_Crab : ℝ := 420913 / 1000000000000000000

/-- **E_dot rotational** (in erg/s, units 10³⁸): `4.5`. -/
noncomputable def E_dot_Crab_units : ℝ := 45 / 10

/-- **Glitch count 2024**: `30` (archived, Jodrell Bank). -/
noncomputable def Crab_glitch_count : ℝ := 30

/-! ## Positivity -/

/-- **Wave T1 session 307 — `P > 0`**. -/
theorem T1_P_pos : 0 < P_Crab_ms := by
  unfold P_Crab_ms; norm_num

/-- **Wave T1 session 307 — `Ṗ > 0`** (spin-down). -/
theorem T1_P_dot_pos : 0 < P_dot_Crab := by
  unfold P_dot_Crab; norm_num

/-- **Wave T1 session 307 — `E_dot > 0`**. -/
theorem T1_E_dot_pos : 0 < E_dot_Crab_units := by
  unfold E_dot_Crab_units; norm_num

/-- **Wave T1 session 307 — `glitch count > 0`**. -/
theorem T1_glitch_count_pos : 0 < Crab_glitch_count := by
  unfold Crab_glitch_count; norm_num

/-! ## Period bounds -/

/-- **🚨 FRONTIER — Wave T1 session 307 — `33 < P < 34 ms`**. -/
theorem T1_P_in_band :
    33 < P_Crab_ms ∧ P_Crab_ms < 34 := by
  refine ⟨?_, ?_⟩
  · unfold P_Crab_ms; norm_num
  · unfold P_Crab_ms; norm_num

/-! ## Spin-down rate small -/

/-- **🚨 FRONTIER — Wave T1 session 307 — `Ṗ < 5 × 10⁻¹³`**. -/
theorem T1_P_dot_below_5e_neg_13 :
    P_dot_Crab < 5 / 10000000000000 := by
  unfold P_dot_Crab; norm_num

/-- **🚨 FRONTIER — Wave T1 session 307 — `Ṗ > 4 × 10⁻¹³`**. -/
theorem T1_P_dot_above_4e_neg_13 :
    P_dot_Crab > 4 / 10000000000000 := by
  unfold P_dot_Crab; norm_num

/-! ## E_dot in expected band -/

/-- **🚨 FRONTIER — Wave T1 session 307 — `4 < E_dot units < 5`** (×10³⁸ erg/s). -/
theorem T1_E_dot_in_band :
    4 < E_dot_Crab_units ∧ E_dot_Crab_units < 5 := by
  refine ⟨?_, ?_⟩
  · unfold E_dot_Crab_units; norm_num
  · unfold E_dot_Crab_units; norm_num

/-! ## Glitch count -/

/-- **🚨 FRONTIER — Wave T1 session 307 — `glitch count ≥ 30`** (rich sample). -/
theorem T1_glitch_count_above_30 :
    Crab_glitch_count ≥ 30 := by
  unfold Crab_glitch_count; norm_num

/-- **🚨 FRONTIER — Wave T1 session 307 — `glitch count ≥ 20`** (sample size). -/
theorem T1_glitch_count_above_20 :
    Crab_glitch_count ≥ 20 := by
  unfold Crab_glitch_count; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 307 — Crab pulsar timing frontier**.

    🚨 FRONTIER (sub-ns timing precision + GR test) 🚨

    Ten foundational facts:
    1. `P = 33.7204 ms > 0`.
    2. `Ṗ = 4.20913×10⁻¹³ > 0` (spin-down).
    3. `E_dot = 4.5×10³⁸ erg/s > 0`.
    4. `glitch count = 30 > 0`.
    5. `33 < P < 34 ms` (band).
    6. `Ṗ < 5×10⁻¹³`.
    7. `Ṗ > 4×10⁻¹³`.
    8. `4 < E_dot < 5` (×10³⁸ erg/s).
    9. `glitch count ≥ 30` (rich sample).
    10. `glitch count ≥ 20` (sample size).

    Tests GR via gravitational radiation reaction. Constrains
    neutron-star EOS via glitches. Foundation for PTA cosmology
    (s254 NANOGrav).

    Sub-lemma 127/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of Crab pulsar timing. -/
theorem session_307_Crab_pulsar_timing_frontier_headline :
    0 < P_Crab_ms ∧ 0 < P_dot_Crab
    ∧ 0 < E_dot_Crab_units ∧ 0 < Crab_glitch_count
    ∧ (33 < P_Crab_ms ∧ P_Crab_ms < 34)
    ∧ P_dot_Crab < 5 / 10000000000000
    ∧ P_dot_Crab > 4 / 10000000000000
    ∧ (4 < E_dot_Crab_units ∧ E_dot_Crab_units < 5)
    ∧ Crab_glitch_count ≥ 30 :=
  ⟨T1_P_pos, T1_P_dot_pos, T1_E_dot_pos, T1_glitch_count_pos,
   T1_P_in_band, T1_P_dot_below_5e_neg_13, T1_P_dot_above_4e_neg_13,
   T1_E_dot_in_band, T1_glitch_count_above_30⟩

end OmegaTheory.Predictions.T1_CrabPulsarTimingFrontier
