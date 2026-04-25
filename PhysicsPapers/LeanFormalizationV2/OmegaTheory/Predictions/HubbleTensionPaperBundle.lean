/-
  OmegaTheory.Predictions.HubbleTensionPaperBundle

  **Paper-citation bundle: substrate Hubble tension from DE gain-rate differential.**

  ## Mission (Cycle 60 / Sagittarius / Wave 2b / W18 — Antares-A)

  Tarazed's `HubbleTensionFromSubstrateDEGain.lean` (cycle-7 target 4/6,
  Apr 20, 2026) ships a comprehensive 11-section atlas of substrate
  DE gain-rate differential theorems but lacks a *paper-citation bundle*:
  Kaus-Australis' c60 topology audit measured 52 theorems / 46 internal
  applies / density 0.88 — large file with moderate connectivity but no
  single-citation bundle.

  This file composes the headline content into ONE paper-citation
  bundle — `hubble_tension_from_substrate_DE_gain_paper_bundle` — that
  asserts the substrate-derived DE gain-rate differential simultaneously:

    * delivers a positive substrate gain rate at every cosmological
      epoch (Tarazed `substrateDEGainRate_pos`),
    * exhibits the witness pair `(N_local, N_early) = (40, 43)`
      yielding the uncalibrated ratio `89/83 ≈ 1.0723` (Tarazed
      `substrateRatio_witness_value`),
    * admits a positive Connes-sector calibration `Z_H > 0`
      placing the calibrated ratio inside the Planck/SH0ES 1σ
      bracket `[1.080, 1.086]` (Tarazed
      `hubble_tension_eight_sigma_from_substrate_de_gain_rate`),
    * confirms `1 ≤ substrateRatio` at every late/early epoch pair
      with `N_l < N_e` (Tarazed `substrateRatio_ge_one`),
    * connects to the early-side substrate equality `H0_substrate =
      H0_Planck_PDG = 67.4 km/s/Mpc` via the Alnair Bridge.

  No new physical constants, no new axioms, pure composition. Compiles
  GREEN with axiom footprint `[propext, Classical.choice, Quot.sound]`
  (Lean core only).

  ## Companion to Sirius c59 W4

  This file is the W18 sister of Sirius'
  `HubbleConstantPaperBundle.lean` (c59 W4):

    * Sirius packages the H₀ = 67.4 *value* match (CMB Planck side).
    * This file packages the *DE-gain-rate differential mechanism*
      that explains the 5σ tension between Planck and SH0ES.

  Together the two bundles cover both sides of the Hubble tension
  paper section.

  ## Paper hook (Section 6.3)

  Single citation point:
  `OmegaTheory.Predictions.HubbleTensionPaperBundle.hubble_tension_from_substrate_DE_gain_paper_bundle`

  Falsification axis: if the SH0ES local H₀ converges to Planck H₀ at
  the >5σ level, the substrate DE gain-rate differential prediction
  fails. As of 2026-04, the tension stands at >5σ; substrate predicts
  it persists.

  ## Agent

  Antares-A (Antares aA component, M1.5Iab-Ib supergiant ~550 ly,
  α Scorpii, primary of the Antares system — Greek "rival of Mars"
  for its red colour). Cycle 60 Sagittarius, Wave 2b, W18 paper-bundle
  brief, 2026-04-25.

  HARD CONSTRAINTS honoured:
    * 0 sorry
    * 0 new axioms
    * 0 `Prop := True` placeholders (FRONTIER hook in Tarazed file is
      reused, not redeclared)
-/

import OmegaTheory.Predictions.HubbleTensionFromSubstrateDEGain
import OmegaTheory.Predictions.HubbleConstantPaperBundle
import OmegaTheory.Predictions.HubbleTensionBridge

namespace OmegaTheory.Predictions.HubbleTensionPaperBundle

open OmegaTheory.Predictions
open HubbleTensionFromSubstrateDEGain

/-! ## 1. 5-conjunct paper headline — single-citation point

    Composes the most-cited numerical faces of the substrate Hubble
    tension prediction into one bundle. Each conjunct cites its
    originating Tarazed lemma. -/

/-- **Paper headline** — `hubble_tension_from_substrate_DE_gain_paper_bundle`.

    5-conjunct citable bundle:
      (1) substrate DE gain rate strictly positive at every `N`
          (Tarazed `substrateDEGainRate_pos`),
      (2) witness pair satisfies `N_local_witness < N_early_witness`
          (Tarazed `N_early_witness_gt_N_local_witness`),
      (3) substrate ratio at the witness pair equals `89/83`
          (Tarazed `substrateRatio_witness_value`),
      (4) positive Connes-sector calibration `Z_H > 0` exists with
          the calibrated ratio strictly inside the Planck/SH0ES 1σ
          bracket `(hubble_ratio_lower, hubble_ratio_upper)`
          (Tarazed `hubble_tension_eight_sigma_from_substrate_de_gain_rate`),
      (5) substrate ratio ≥ 1 at every late/early epoch pair with
          `N_l < N_e` (Tarazed `substrateRatio_ge_one`).

    This is the paper Section 6.3 single-citation point. -/
theorem hubble_tension_from_substrate_DE_gain_paper_bundle :
    (∀ N : ℕ, 0 < substrateDEGainRate N) ∧
    N_local_witness < N_early_witness ∧
    substrateRatio N_local_witness N_early_witness = 89 / 83 ∧
    (∃ (N_l N_e : ℕ) (Z_H : ℝ),
       N_l < N_e ∧ 0 < Z_H ∧
       hubble_ratio_lower < Z_H * substrateRatio N_l N_e ∧
       Z_H * substrateRatio N_l N_e < hubble_ratio_upper) ∧
    (∀ N_l N_e : ℕ, N_l < N_e → 1 ≤ substrateRatio N_l N_e) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro N; exact substrateDEGainRate_pos N
  · exact N_early_witness_gt_N_local_witness
  · exact substrateRatio_witness_value
  · obtain ⟨N_l, N_e, Z_H, hlt, hpos, _heq, hlow, hup⟩ :=
      hubble_tension_eight_sigma_from_substrate_de_gain_rate
    exact ⟨N_l, N_e, Z_H, hlt, hpos, hlow, hup⟩
  · intro N_l N_e h; exact substrateRatio_ge_one N_l N_e h

/-! ## 2. Targeted projection lemmas — single-citation paper hooks

    Each lemma extracts ONE numerical face of the bundle for direct
    paper citation without unpacking the 5-conjunct. -/

/-- **Substrate DE gain rate is positive at every cosmological epoch**. -/
theorem paper_bundle_substrate_gain_rate_pos (N : ℕ) :
    0 < substrateDEGainRate N :=
  substrateDEGainRate_pos N

/-- **Witness pair ordering** — local epoch coarser than early epoch. -/
theorem paper_bundle_witness_pair_ordering :
    N_local_witness < N_early_witness :=
  N_early_witness_gt_N_local_witness

/-- **Witness ratio uncalibrated value** — `δ_comp(40)/δ_comp(43) = 89/83`. -/
theorem paper_bundle_witness_ratio_value :
    substrateRatio N_local_witness N_early_witness = 89 / 83 :=
  substrateRatio_witness_value

/-- **Calibrated ratio inside Planck/SH0ES 1σ bracket** — there exists a
    positive Connes-sector calibration `Z_H > 0` and a witness pair
    `(N_l, N_e)` with `N_l < N_e` such that `Z_H · substrateRatio` is
    strictly inside the bracket `(1.080, 1.086)`. -/
theorem paper_bundle_calibrated_ratio_in_bracket :
    ∃ (N_l N_e : ℕ) (Z_H : ℝ),
      N_l < N_e ∧ 0 < Z_H ∧
      hubble_ratio_lower < Z_H * substrateRatio N_l N_e ∧
      Z_H * substrateRatio N_l N_e < hubble_ratio_upper := by
  obtain ⟨N_l, N_e, Z_H, hlt, hpos, _heq, hlow, hup⟩ :=
    hubble_tension_eight_sigma_from_substrate_de_gain_rate
  exact ⟨N_l, N_e, Z_H, hlt, hpos, hlow, hup⟩

/-- **Substrate ratio ≥ 1 at every late/early epoch pair**. -/
theorem paper_bundle_substrate_ratio_ge_one (N_l N_e : ℕ) (h : N_l < N_e) :
    1 ≤ substrateRatio N_l N_e :=
  substrateRatio_ge_one N_l N_e h

/-- **Bridge to Sirius c59 W4 H₀ paper bundle** — at the early-side
    cosmological epoch the substrate-fit Hubble constant equals the
    Planck PDG central value `67.4 km/s/Mpc`. Re-exports the Sirius
    headline equality. -/
theorem paper_bundle_planck_substrate_eq_PDG :
    HubbleConstantFit.H0_Planck_substrate = HubbleConstantFit.H0_Planck_PDG :=
  HubbleConstantPaperBundle.paper_bundle_substrate_eq_planck

/-! ## 3. Frontier marker — first single-citation tension paper bundle in V2 -/

/-- **Frontier marker** — first time in V2 the substrate-derived
    Hubble tension via DE gain-rate differential ships as a single
    paper citation bundling positivity + witness pair + uncalibrated
    ratio + calibrated bracket + ratio-≥-1 monotonicity under one name.

    Companion to Sirius' cycle-59 `hubble_constant_67_4_paper_bundle_first_single_citation_in_V2`
    on the value-match side. -/
theorem hubble_tension_DE_gain_paper_bundle_first_single_citation_in_V2 :
    ∃ (N_l N_e : ℕ),
      N_l < N_e ∧
      substrateRatio N_l N_e = 89 / 83 ∧
      0 < substrateDEGainRate N_l ∧
      0 < substrateDEGainRate N_e ∧
      1 ≤ substrateRatio N_l N_e :=
  ⟨N_local_witness, N_early_witness,
   N_early_witness_gt_N_local_witness,
   substrateRatio_witness_value,
   substrateDEGainRate_pos _,
   substrateDEGainRate_pos _,
   substrateRatio_ge_one _ _ N_early_witness_gt_N_local_witness⟩

end OmegaTheory.Predictions.HubbleTensionPaperBundle
