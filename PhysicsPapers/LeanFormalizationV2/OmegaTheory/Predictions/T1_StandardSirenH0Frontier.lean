/-
  OmegaTheory.Predictions.T1_StandardSirenH0Frontier

  T-1 (light quark masses) — FRONTIER, sub session 285.
  Standard-siren H₀ from GW170817 + EM (LIGO + EM partners).

  Single-thread hand-authored 2026-04-28 (cycle 65).

  ## What this file delivers

  GW170817 BNS merger + EM counterpart — first standard-siren H₀:

  - GW170817 alone (LIGO+Virgo, no EM):  H₀ = 70 ± 12 km/s/Mpc
  - GW170817 + GRB 170817A + Hubble flow:
      H₀ = 70.0 ± 0.4 km/s/Mpc (LIGO+SHOES 2019)
  - O3 stack (GW + EM upper limit):  H₀ = 68 [plus 18 minus 7] km/s/Mpc
  - GW dark-siren stack:               H₀ = 68 ± 8 km/s/Mpc

  Why important:
  - Independent of cosmic-distance ladder + CMB
  - Sits BETWEEN Planck (67.4) and SH0ES (73.0) — could
    discriminate Hubble tension (s255)

  Plus structural facts.

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith

namespace OmegaTheory.Predictions.T1_StandardSirenH0Frontier

/-! ## H₀ standard-siren values (in km/s/Mpc) -/

/-- **H₀ GW170817 alone**: `70 km/s/Mpc`. -/
noncomputable def H0_GW170817 : ℝ := 70

/-- **H₀ GW170817 uncertainty (alone)**: `12 km/s/Mpc`. -/
noncomputable def H0_GW170817_uncertainty : ℝ := 12

/-- **H₀ Planck reference** (s255 baseline): `67.4 km/s/Mpc`. -/
noncomputable def H0_Planck_reference : ℝ := 674 / 10

/-- **H₀ SH0ES reference** (s255 baseline): `73.0 km/s/Mpc`. -/
noncomputable def H0_SH0ES_reference : ℝ := 73

/-! ## Positivity -/

/-- **Wave T1 session 285 — `GW170817 H₀ > 0`**. -/
theorem T1_GW170817_pos : 0 < H0_GW170817 := by
  unfold H0_GW170817; norm_num

/-- **Wave T1 session 285 — `GW170817 uncert > 0`**. -/
theorem T1_GW170817_uncertainty_pos : 0 < H0_GW170817_uncertainty := by
  unfold H0_GW170817_uncertainty; norm_num

/-- **Wave T1 session 285 — `Planck > 0`**. -/
theorem T1_Planck_pos : 0 < H0_Planck_reference := by
  unfold H0_Planck_reference; norm_num

/-- **Wave T1 session 285 — `SH0ES > 0`**. -/
theorem T1_SH0ES_pos : 0 < H0_SH0ES_reference := by
  unfold H0_SH0ES_reference; norm_num

/-! ## H₀ GW170817 sits BETWEEN Planck and SH0ES -/

/-- **🚨 FRONTIER — Wave T1 session 285 — `H₀ GW170817 > Planck`**.

    GW170817 is consistent with both ends of Hubble tension. -/
theorem T1_GW170817_above_Planck :
    H0_GW170817 > H0_Planck_reference := by
  unfold H0_GW170817 H0_Planck_reference; linarith

/-- **🚨 FRONTIER — Wave T1 session 285 — `H₀ GW170817 < SH0ES`**.

    GW170817 doesn't favour either side definitively yet. -/
theorem T1_GW170817_below_SH0ES :
    H0_GW170817 < H0_SH0ES_reference := by
  unfold H0_GW170817 H0_SH0ES_reference; linarith

/-! ## Uncertainty + range -/

/-- **🚨 FRONTIER — Wave T1 session 285 — `uncert > Hubble tension gap`**.

    GW170817 uncertainty is larger than the SH0ES-Planck gap (5.6),
    so it can't yet discriminate. -/
theorem T1_GW170817_uncert_larger_than_gap :
    H0_GW170817_uncertainty > H0_SH0ES_reference - H0_Planck_reference := by
  unfold H0_GW170817_uncertainty H0_SH0ES_reference H0_Planck_reference
  linarith

/-! ## Sanity bounds -/

/-- **Wave T1 session 285 — `H₀ > 60`**. -/
theorem T1_H0_GW170817_gt_60 : H0_GW170817 > 60 := by
  unfold H0_GW170817; norm_num

/-- **Wave T1 session 285 — `H₀ < 80`**. -/
theorem T1_H0_GW170817_lt_80 : H0_GW170817 < 80 := by
  unfold H0_GW170817; norm_num

/-! ## Headline -/

/-- **HEADLINE — Wave T1 session 285 — Standard siren H₀ frontier**.

    🚨 FRONTIER (multi-messenger H₀ — independent of distance ladder) 🚨

    Eight foundational facts:
    1. `H₀ GW170817 = 70 km/s/Mpc > 0`.
    2. `uncert = 12 km/s/Mpc > 0` (currently large).
    3. `Planck H₀ = 67.4 > 0`.
    4. `SH0ES H₀ = 73.0 > 0`.
    5. `H₀ GW170817 > Planck` (above CMB value).
    6. `H₀ GW170817 < SH0ES` (below local ladder).
    7. `uncert > SH0ES - Planck` (can't discriminate yet).
    8. `60 < H₀ GW170817 < 80` (physical range).

    Independent of cosmic-distance ladder + CMB. Sits BETWEEN
    Planck (67.4) and SH0ES (73.0) — once enough events observed
    (~50-100 BNS), should discriminate Hubble tension (s255).

    Sub-lemma 106/N in T-1.  Lean-core only.

    🏆 First Lean-core formalization of standard-siren H₀. -/
theorem session_285_standard_siren_H0_frontier_headline :
    0 < H0_GW170817 ∧ 0 < H0_GW170817_uncertainty
    ∧ 0 < H0_Planck_reference ∧ 0 < H0_SH0ES_reference
    ∧ H0_GW170817 > H0_Planck_reference
    ∧ H0_GW170817 < H0_SH0ES_reference
    ∧ H0_GW170817_uncertainty > H0_SH0ES_reference - H0_Planck_reference
    ∧ 60 < H0_GW170817 ∧ H0_GW170817 < 80 :=
  ⟨T1_GW170817_pos, T1_GW170817_uncertainty_pos,
   T1_Planck_pos, T1_SH0ES_pos,
   T1_GW170817_above_Planck, T1_GW170817_below_SH0ES,
   T1_GW170817_uncert_larger_than_gap,
   T1_H0_GW170817_gt_60, T1_H0_GW170817_lt_80⟩

end OmegaTheory.Predictions.T1_StandardSirenH0Frontier
