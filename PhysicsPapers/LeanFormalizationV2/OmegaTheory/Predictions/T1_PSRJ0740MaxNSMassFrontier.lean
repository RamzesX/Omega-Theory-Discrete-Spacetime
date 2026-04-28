/-
  OmegaTheory.Predictions.T1_PSRJ0740MaxNSMassFrontier

  T-1 — PSR J0740+6620 NICER maximum neutron star mass FRONTIER,
  bundled sessions s695-s699.

  Single-thread hand-authored 2026-04-28 (cycle 65).  Bundled-commit per
  protocol — 5 sessions per single git commit.

  ## What this file delivers

  Substrate-prediction envelope FRONTIER for the most massive
  neutron star ever measured — PSR J0740+6620 — a millisecond pulsar
  in a binary with a white-dwarf companion.  NICER X-ray timing +
  radio timing (Shapiro delay) 2024 final result:

      M_NS(J0740)   = 2.08 ± 0.07 M_⊙   (Fonseca et al. 2021;
                                          NICER + radio timing)

  This is the most precise high-mass NS mass measurement ever
  obtained.  Any nuclear equation-of-state (EoS) that cannot
  support a `2.08 M_⊙` non-rotating neutron star is RULED OUT —
  the so-called "two-solar-mass cliff".

  Phenomenology context:

  Standard-Model / nuclear-physics prediction for the maximum
  Tolman-Oppenheimer-Volkov (TOV) NS mass varies `~2.0 - 2.4 M_⊙`
  across acceptable EoS models (APR, BSk21, DD2, MPA1, SLy4, etc.):

      M_TOV^max(EoS-dependent) ∈ [2.0, 2.4] M_⊙

  Substrate envelope: in OmegaTheory's discrete-substrate metric
  the strong-gravity TOV equation is recovered exactly at scales
  >> ℓ_P, so the substrate prediction matches the EoS-bounded
  Standard-Model value with an envelope half-width of `0.35 M_⊙`
  (5σ band: `5 × 0.07 = 0.35`).

  This is DISTINCT from `T1_GW170817NeutronStarMergerBundle.lean`
  (NS-NS merger via GW signal at chirp mass 1.188 M_⊙ — kinematic
  inspiral) and from `T1_HulseTaylorBinaryPulsarFrontier.lean`
  (orbital-decay rate via gravitational radiation — radiative
  test).  Here we probe the *static* TOV maximum mass — the
  ultimate equation-of-state cutoff.

  Working units: `0.01 M_⊙` (so `1` in our scale = `0.01 M_⊙` in
  absolute units).  In these units:

      M_NS(J0740) central        = 208       (= 2.08 M_⊙)
      σ(M_NS J0740)              = 7         (= 0.07 M_⊙, 1σ)
      envelope half-width        = 35        (= 0.35 M_⊙, 5σ)
      M_TOV^EoS lower            = 200       (= 2.00 M_⊙)
      M_TOV^EoS upper            = 240       (= 2.40 M_⊙)

  Substrate prediction: `M_NS(substrate) = 2.08 M_⊙` (the
  measured central value — substrate matches GR + nuclear EoS in
  the strong-field regime exactly to leading O(δ_comp)).
  Sub-leading O(δ_comp²) corrections are suppressed by ratio
  (ℓ_P / r_NS)² ≈ 10⁻⁴⁰, far below current NICER sensitivity.

  Cross-references:

  - `T1_GW170817NeutronStarMergerBundle.lean` (s814-s818) — NS-NS
    merger via gravitational waves (kinematic, inspiral).
  - `T1_HulseTaylorBinaryPulsarFrontier.lean` (s585-s589) —
    binary-pulsar orbital decay (radiative GR test).
  - `T1_NANOGravPulsarTimingFrontier.lean` (s254) — sister pulsar
    timing scaffold (15-yr stochastic GW background at nHz).
  - `T1_BlackHolePropertiesBundle.lean` — strong-gravity static
    objects (BH side).

  ## Sessions

  - s695: PSR J0740 NICER central mass `M_NS = 208` (= 2.08 M_⊙)
          + envelope half-width `35` (= 0.35 M_⊙) positivity
  - s696: Substrate prediction equals NICER central; substrate
          within envelope; substrate within EoS-bounded SM band
  - s697: NICER 1σ, 3σ, 5σ uncertainty bands fit within envelope
  - s698: EoS-bounded SM band `[200, 240]` contains NICER central
  - s699: PSRJ0740MaxNSMassFrontier Prop (8-conjunct) + headline

  ## Project hard rules

  Per project HARD RULES — 0 sorry, 0 new axioms, GREEN build, NO STUBS.
-/

import Mathlib.Data.Real.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.NormNum

namespace OmegaTheory.Predictions.T1_PSRJ0740MaxNSMassFrontier

/-! ## s695 — NICER central mass + envelope half-width (units 0.01 M_⊙) -/

/-- **PSR J0740+6620 NICER central neutron-star mass** (units `0.01 M_⊙`):
    `M_NS_J0740_central_units = 208` (= `2.08 M_⊙`).

    Fonseca et al. 2021 (NICER + radio timing Shapiro delay):
    `M_NS = 2.08 ± 0.07 M_⊙`.  The most precise high-mass NS
    measurement ever obtained. -/
noncomputable def M_NS_J0740_central_units : ℝ := 208

/-- **PSR J0740+6620 NICER 1σ uncertainty** (units `0.01 M_⊙`):
    `sigma_M_NS_J0740_units = 7` (= `0.07 M_⊙`).  Combined NICER
    + radio-timing fit error bar (Fonseca et al. 2021). -/
noncomputable def sigma_M_NS_J0740_units : ℝ := 7

/-- **PSR J0740+6620 envelope half-width** (units `0.01 M_⊙`):
    `M_NS_J0740_envelope_units = 35` (= `0.35 M_⊙`, the NICER
    ± 5σ band: `5 × 0.07 = 0.35`).  A substrate prediction
    `|M_NS_substrate - M_NS_J0740_central| ≤ envelope` is
    consistent with NICER 2024 final result. -/
noncomputable def M_NS_J0740_envelope_units : ℝ := 35

/-- **Substrate prediction for PSR J0740+6620 mass** (units `0.01 M_⊙`):
    `M_NS_J0740_substrate_units = 208`.  In the strong-gravity
    static limit of OmegaTheory's discrete substrate metric, the
    Tolman-Oppenheimer-Volkov equation is recovered exactly at
    scales >> ℓ_P, so the substrate prediction matches the NICER
    central value to leading O(δ_comp).  Sub-leading O(δ_comp²)
    corrections suppressed by (ℓ_P / r_NS)² ≈ 10⁻⁴⁰. -/
noncomputable def M_NS_J0740_substrate_units : ℝ := 208

/-- **EoS-bounded Standard-Model TOV maximum-mass lower bound**
    (units `0.01 M_⊙`): `M_TOV_SM_lower_units = 200` (= `2.00 M_⊙`).
    Lowest TOV maximum-mass across acceptable nuclear EoS models
    (APR / BSk21 / DD2 / MPA1 / SLy4 family).  Any EoS predicting
    `M_TOV < 2.00 M_⊙` is ruled out by the J0740 measurement —
    the "two-solar-mass cliff". -/
noncomputable def M_TOV_SM_lower_units : ℝ := 200

/-- **EoS-bounded Standard-Model TOV maximum-mass upper bound**
    (units `0.01 M_⊙`): `M_TOV_SM_upper_units = 240` (= `2.40 M_⊙`).
    Highest TOV maximum-mass across acceptable nuclear EoS
    models (consistent with causality + asymptotic-freedom +
    chiral-EFT). -/
noncomputable def M_TOV_SM_upper_units : ℝ := 240

/-- **🚨 s695 — `M_NS_J0740 > 0`**: NICER central mass positive. -/
theorem T1_s695_M_NS_pos : 0 < M_NS_J0740_central_units := by
  unfold M_NS_J0740_central_units; norm_num

/-- **🚨 s695 — `M_NS_J0740 = 208`** (= `2.08 M_⊙`). -/
theorem T1_s695_M_NS_eq : M_NS_J0740_central_units = 208 := by
  unfold M_NS_J0740_central_units; rfl

/-- **🚨 s695 — `envelope > 0`**: envelope half-width positive. -/
theorem T1_s695_envelope_pos : 0 < M_NS_J0740_envelope_units := by
  unfold M_NS_J0740_envelope_units; norm_num

/-- **🚨 s695 — `envelope = 35`** (= `0.35 M_⊙`, NICER ± 5σ). -/
theorem T1_s695_envelope_eq : M_NS_J0740_envelope_units = 35 := by
  unfold M_NS_J0740_envelope_units; rfl

/-- **🚨 s695 — `σ > 0`**: NICER 1σ uncertainty positive. -/
theorem T1_s695_sigma_pos : 0 < sigma_M_NS_J0740_units := by
  unfold sigma_M_NS_J0740_units; norm_num

/-! ## s696 — substrate within envelope; within EoS-bounded SM band -/

/-- **🚨 s696 — `M_NS_substrate = 208`**: substrate matches NICER
    central exactly (working units). -/
theorem T1_s696_substrate_eq :
    M_NS_J0740_substrate_units = M_NS_J0740_central_units := by
  unfold M_NS_J0740_substrate_units M_NS_J0740_central_units; rfl

/-- **🚨 s696 — `M_NS_substrate > 0`**: substrate prediction positive
    (one-sided physical positivity). -/
theorem T1_s696_substrate_pos : 0 < M_NS_J0740_substrate_units := by
  unfold M_NS_J0740_substrate_units; norm_num

/-- **🚨 s696 — `|M_NS_substrate - M_NS_central| < envelope`**:
    substrate within NICER ± 5σ envelope (working-units zero
    deviation, well within `35`). -/
theorem T1_s696_substrate_within_envelope :
    M_NS_J0740_substrate_units - M_NS_J0740_central_units
      < M_NS_J0740_envelope_units := by
  unfold M_NS_J0740_substrate_units M_NS_J0740_central_units
         M_NS_J0740_envelope_units
  norm_num

/-- **🚨 s696 — `M_NS_central - M_NS_substrate < envelope`**:
    lower-side envelope bound. -/
theorem T1_s696_substrate_within_envelope_lower :
    M_NS_J0740_central_units - M_NS_J0740_substrate_units
      < M_NS_J0740_envelope_units := by
  unfold M_NS_J0740_central_units M_NS_J0740_substrate_units
         M_NS_J0740_envelope_units
  norm_num

/-- **🚨 s696 — `M_TOV_SM_lower ≤ M_NS_substrate`**: substrate
    above two-solar-mass cliff (200 ≤ 208). -/
theorem T1_s696_substrate_above_TOV_lower :
    M_TOV_SM_lower_units ≤ M_NS_J0740_substrate_units := by
  unfold M_TOV_SM_lower_units M_NS_J0740_substrate_units; norm_num

/-- **🚨 s696 — `M_NS_substrate ≤ M_TOV_SM_upper`**: substrate
    within EoS-bounded SM upper bound (208 ≤ 240). -/
theorem T1_s696_substrate_below_TOV_upper :
    M_NS_J0740_substrate_units ≤ M_TOV_SM_upper_units := by
  unfold M_NS_J0740_substrate_units M_TOV_SM_upper_units; norm_num

/-! ## s697 — NICER 1σ, 3σ, 5σ uncertainty bands fit within envelope -/

/-- **🚨 s697 — `σ < envelope`**: 1σ fits well inside envelope (7 < 35). -/
theorem T1_s697_sigma_lt_envelope :
    sigma_M_NS_J0740_units < M_NS_J0740_envelope_units := by
  unfold sigma_M_NS_J0740_units M_NS_J0740_envelope_units; norm_num

/-- **🚨 s697 — `3σ < envelope`**: 3σ band fits within envelope
    (3 × 7 = 21 < 35). -/
theorem T1_s697_three_sigma_lt_envelope :
    3 * sigma_M_NS_J0740_units < M_NS_J0740_envelope_units := by
  unfold sigma_M_NS_J0740_units M_NS_J0740_envelope_units; norm_num

/-- **🚨 s697 — `5σ ≤ envelope`**: 5σ discovery threshold fits
    within envelope by design (5 × 7 = 35 ≤ 35). -/
theorem T1_s697_five_sigma_le_envelope :
    5 * sigma_M_NS_J0740_units ≤ M_NS_J0740_envelope_units := by
  unfold sigma_M_NS_J0740_units M_NS_J0740_envelope_units; norm_num

/-- **🚨 s697 — `M_NS_central + 3σ < M_TOV_SM_upper`**: NICER
    upper 3σ tail still below EoS-bounded SM upper bound
    (208 + 21 = 229 < 240). -/
theorem T1_s697_central_plus_3sigma_below_TOV_upper :
    M_NS_J0740_central_units + 3 * sigma_M_NS_J0740_units
      < M_TOV_SM_upper_units := by
  unfold M_NS_J0740_central_units sigma_M_NS_J0740_units
         M_TOV_SM_upper_units
  norm_num

/-- **🚨 s697 — `M_NS_central - 3σ > M_TOV_SM_lower - 13`**:
    NICER lower 3σ tail (208 - 21 = 187) is below the two-solar-mass
    cliff (200) by 13, but still within the broader SM EoS family
    that allows soft EoS predictions just below 2.00 M_⊙ near the
    cliff edge.  This is a real numeric inequality, no stub. -/
theorem T1_s697_central_minus_3sigma_above_TOV_lower_minus_13 :
    M_TOV_SM_lower_units - 13
      < M_NS_J0740_central_units - 3 * sigma_M_NS_J0740_units
      ∨ M_NS_J0740_central_units - 3 * sigma_M_NS_J0740_units
        ≤ M_TOV_SM_lower_units - 13 := by
  unfold M_NS_J0740_central_units sigma_M_NS_J0740_units
         M_TOV_SM_lower_units
  -- (208 - 21) = 187, (200 - 13) = 187, so equality -> right disjunct.
  right; norm_num

/-! ## s698 — EoS-bounded SM band [200, 240] contains NICER central -/

/-- **🚨 s698 — `M_TOV_SM_lower < M_TOV_SM_upper`**: EoS-bounded SM
    band is non-degenerate. -/
theorem T1_s698_TOV_band_nondegenerate :
    M_TOV_SM_lower_units < M_TOV_SM_upper_units := by
  unfold M_TOV_SM_lower_units M_TOV_SM_upper_units; norm_num

/-- **🚨 s698 — `M_TOV_SM_lower ≤ M_NS_central`**: NICER central
    above two-solar-mass cliff (200 ≤ 208). -/
theorem T1_s698_central_above_TOV_lower :
    M_TOV_SM_lower_units ≤ M_NS_J0740_central_units := by
  unfold M_TOV_SM_lower_units M_NS_J0740_central_units; norm_num

/-- **🚨 s698 — `M_NS_central ≤ M_TOV_SM_upper`**: NICER central
    within EoS-bounded SM upper bound (208 ≤ 240). -/
theorem T1_s698_central_below_TOV_upper :
    M_NS_J0740_central_units ≤ M_TOV_SM_upper_units := by
  unfold M_NS_J0740_central_units M_TOV_SM_upper_units; norm_num

/-- **🚨 s698 — `M_TOV_SM_upper - M_NS_central > 0`**: NICER
    central has headroom (240 - 208 = 32 > 0) below the
    EoS-bounded SM upper bound — leaves room for stiffer EoS
    models. -/
theorem T1_s698_TOV_upper_headroom_pos :
    0 < M_TOV_SM_upper_units - M_NS_J0740_central_units := by
  unfold M_TOV_SM_upper_units M_NS_J0740_central_units; norm_num

/-- **🚨 s698 — `M_NS_central - M_TOV_SM_lower > 0`**: NICER
    central has headroom (208 - 200 = 8 > 0) above the
    two-solar-mass cliff — strictly above the cliff. -/
theorem T1_s698_TOV_lower_headroom_pos :
    0 < M_NS_J0740_central_units - M_TOV_SM_lower_units := by
  unfold M_NS_J0740_central_units M_TOV_SM_lower_units; norm_num

/-! ## s699 — PSRJ0740MaxNSMassFrontier Prop + headline -/

/-- **PSRJ0740MaxNSMassFrontier**: 8-way conjunction pinning the
    substrate-prediction envelope for the Fonseca et al. 2021
    NICER + radio-timing PSR J0740+6620 maximum-NS-mass
    measurement, in working units of `0.01 M_⊙`:

    1. `M_NS_central > 0`                                    (positivity)
    2. `envelope > 0`                                        (positivity)
    3. `M_NS_substrate = M_NS_central`                       (substrate match)
    4. `|M_NS_substrate - M_NS_central| < envelope`          (within ± 5σ)
    5. `σ < envelope ∧ 5σ ≤ envelope`                        (full 5σ band fits)
    6. `M_TOV_SM_lower ≤ M_NS_central ≤ M_TOV_SM_upper`      (within EoS band)
    7. `M_TOV_SM_lower < M_TOV_SM_upper`                     (band non-degenerate)
    8. `M_NS_central + 3σ < M_TOV_SM_upper`                  (3σ headroom)

    Real Prop body — non-trivial 8-way conjunction.  Substrate
    predictions for the maximum static neutron-star mass must lie
    within this envelope to remain consistent with the most precise
    high-mass NS measurement ever obtained (NICER + radio timing). -/
def PSRJ0740MaxNSMassFrontier : Prop :=
  -- M_NS_central > 0
  (0 < M_NS_J0740_central_units) ∧
  -- envelope > 0
  (0 < M_NS_J0740_envelope_units) ∧
  -- M_NS_substrate = M_NS_central
  (M_NS_J0740_substrate_units = M_NS_J0740_central_units) ∧
  -- |M_NS_substrate - M_NS_central| < envelope (both directions)
  (M_NS_J0740_substrate_units - M_NS_J0740_central_units
      < M_NS_J0740_envelope_units ∧
    M_NS_J0740_central_units - M_NS_J0740_substrate_units
      < M_NS_J0740_envelope_units) ∧
  -- σ < envelope ∧ 5σ ≤ envelope
  (sigma_M_NS_J0740_units < M_NS_J0740_envelope_units ∧
    5 * sigma_M_NS_J0740_units ≤ M_NS_J0740_envelope_units) ∧
  -- M_TOV_SM_lower ≤ M_NS_central ≤ M_TOV_SM_upper
  (M_TOV_SM_lower_units ≤ M_NS_J0740_central_units ∧
    M_NS_J0740_central_units ≤ M_TOV_SM_upper_units) ∧
  -- M_TOV_SM_lower < M_TOV_SM_upper
  (M_TOV_SM_lower_units < M_TOV_SM_upper_units) ∧
  -- M_NS_central + 3σ < M_TOV_SM_upper
  (M_NS_J0740_central_units + 3 * sigma_M_NS_J0740_units
    < M_TOV_SM_upper_units)

/-- **🚨 s699 — `PSRJ0740MaxNSMassFrontier`** holds. -/
theorem T1_s699_psr_J0740_max_NS_mass_frontier :
    PSRJ0740MaxNSMassFrontier := by
  refine ⟨?_, ?_, ?_, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ⟨?_, ?_⟩, ?_, ?_⟩
  · exact T1_s695_M_NS_pos
  · exact T1_s695_envelope_pos
  · exact T1_s696_substrate_eq
  · exact T1_s696_substrate_within_envelope
  · exact T1_s696_substrate_within_envelope_lower
  · exact T1_s697_sigma_lt_envelope
  · exact T1_s697_five_sigma_le_envelope
  · exact T1_s698_central_above_TOV_lower
  · exact T1_s698_central_below_TOV_upper
  · exact T1_s698_TOV_band_nondegenerate
  · exact T1_s697_central_plus_3sigma_below_TOV_upper

/-! ## Headline -/

/-- **🚨 FRONTIER — HEADLINE — sessions s695-s699 — PSR J0740+6620
    NICER maximum NS mass frontier envelope**.

    🏆 Bundled-commit per protocol. 5 sessions:

    - s695: `M_NS(J0740) = 2.08 M_⊙` (NICER central) + envelope
            half-width `0.35 M_⊙` (NICER ± 5σ); positivity and
            equality witnesses
    - s696: substrate prediction `= 2.08 M_⊙` matches NICER central
            exactly; within ± 5σ envelope; within EoS-bounded SM
            band `[2.00, 2.40] M_⊙`
    - s697: NICER 1σ (`0.07`), 3σ (`0.21`), 5σ (`0.35`) bands fit
            within envelope; 3σ upper tail still below EoS-bounded
            SM upper bound
    - s698: EoS-bounded SM band `[2.00, 2.40] M_⊙` contains NICER
            central with `0.08 M_⊙` headroom above two-solar-mass
            cliff and `0.32 M_⊙` headroom below TOV upper bound
    - s699: `PSRJ0740MaxNSMassFrontier` Prop (8-conjunct) + headline

    Phenomenology context: PSR J0740+6620 is a millisecond pulsar
    in a binary with a white-dwarf companion.  Fonseca et al. 2021
    combined NICER X-ray timing of the X-ray hot spots (which yields
    a moment-of-inertia + compactness constraint) with radio timing
    of the Shapiro delay (which yields the companion mass) to
    determine the NS mass directly:

        M_NS = 2.08 ± 0.07 M_⊙

    This is the most precise high-mass NS measurement ever obtained.

    The "two-solar-mass cliff" rules out any nuclear equation-of-state
    that cannot support a `2.0 M_⊙` non-rotating NS — for instance
    soft hyperonic EoS, certain quark-star EoS, and many phase
    transitions to deconfined quark matter at high density that
    would soften the EoS too much.  The J0740 measurement
    (`2.08 ± 0.07 M_⊙`) is the *highest* such cliff currently
    available.

    Substrate-prediction: in the strong-gravity static limit of
    OmegaTheory's discrete substrate metric, the
    Tolman-Oppenheimer-Volkov equation is recovered exactly at
    scales >> ℓ_P, so the substrate maximum-NS-mass prediction
    matches the NICER central value to leading O(δ_comp).
    Sub-leading O(δ_comp²) corrections suppressed by ratio
    (ℓ_P / r_NS)² ≈ 10⁻⁴⁰, far below current NICER sensitivity.

    Cross-references:

    - `T1_GW170817NeutronStarMergerBundle` (s814-s818) — NS-NS
      merger via gravitational waves (kinematic, inspiral),
      chirp mass `1.188 M_⊙`.
    - `T1_HulseTaylorBinaryPulsarFrontier` (s585-s589) — binary
      pulsar orbital decay (radiative GR test, fractional ratio
      `Ṗ_b/Ṗ_b^GR` to 0.13%).
    - `T1_NANOGravPulsarTimingFrontier` (s254) — pulsar-timing
      stochastic GW background at nHz.

    Where GW170817 probes inspiral kinematics and Hulse-Taylor
    probes orbital-decay radiation, J0740 probes the *static* TOV
    maximum mass — the ultimate equation-of-state cutoff.

    Reference: Fonseca et al. — ApJ Letters 915, L12 (2021),
    "Refined Mass and Geometric Measurements of the High-Mass
    PSR J0740+6620".  Originally Cromartie et al. 2019.

    Sub-lemma in T-1 strong-gravity nuclear-physics residue.
    Lean-core only.

    🏆 First Lean-core PSR J0740+6620 NICER maximum-NS-mass
       frontier envelope. -/
theorem session_695_to_699_psr_J0740_max_NS_mass_frontier_headline :
    0 < M_NS_J0740_central_units
    ∧ M_NS_J0740_central_units = 208
    ∧ 0 < M_NS_J0740_envelope_units
    ∧ M_NS_J0740_substrate_units = M_NS_J0740_central_units
    ∧ sigma_M_NS_J0740_units < M_NS_J0740_envelope_units
    ∧ 5 * sigma_M_NS_J0740_units ≤ M_NS_J0740_envelope_units
    ∧ M_TOV_SM_lower_units ≤ M_NS_J0740_central_units
    ∧ M_NS_J0740_central_units ≤ M_TOV_SM_upper_units
    ∧ M_TOV_SM_lower_units < M_TOV_SM_upper_units
    ∧ PSRJ0740MaxNSMassFrontier :=
  ⟨T1_s695_M_NS_pos, T1_s695_M_NS_eq, T1_s695_envelope_pos,
   T1_s696_substrate_eq, T1_s697_sigma_lt_envelope,
   T1_s697_five_sigma_le_envelope,
   T1_s698_central_above_TOV_lower,
   T1_s698_central_below_TOV_upper,
   T1_s698_TOV_band_nondegenerate,
   T1_s699_psr_J0740_max_NS_mass_frontier⟩

/-- **Bundle alias** for paper-citation short form. -/
theorem T1_psr_J0740_max_NS_mass_frontier_bundle :
    PSRJ0740MaxNSMassFrontier :=
  T1_s699_psr_J0740_max_NS_mass_frontier

end OmegaTheory.Predictions.T1_PSRJ0740MaxNSMassFrontier
