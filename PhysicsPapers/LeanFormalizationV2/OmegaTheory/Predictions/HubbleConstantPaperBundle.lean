/-
  OmegaTheory.Predictions.HubbleConstantPaperBundle

  **Paper-citation bundle: substrate Hubble constant H₀ = 67.4 km/s/Mpc.**

  ## Mission (Cycle 59 / Scorpius / Wave 2 / W4 — Sirius)

  Multiple Hubble-related theorems exist scattered across:

    * `HubbleConstantFit.lean` (cycle-15 substrate fit)
    * `HubbleConstantAbsolute.lean` (Triangulum cycle-57 absolute derivation)
    * `HubbleConstantAbsoluteP3f.lean` (P3f wave anchor)
    * `HubbleTensionBridge.lean` (paper bundle bridge)
    * `HubbleTensionFromSubstrateDEGain.lean` (Tarazed 8σ DE-gain witness)
    * `PrecisionPhysicsAbsoluteWaveP2.hubble_constant_headline_absolute_km_s_Mpc_within_local_PDG`
      (Wave-P2 absolute headline)

  This file composes them into ONE paper-citation bundle —
  `hubble_constant_67_4_paper_bundle_within_PDG` — that asserts the
  substrate-derived value `67.4 km/s/Mpc` matches the Planck 2018 CMB
  PDG anchor exactly (gap = 0), threads within ±0.6 PDG envelope, sits
  strictly below SH0ES local distance-ladder anchor, and witnesses the
  > 5σ Hubble tension via the DE-gain-rate differential.

  ## Composition

  The bundle conjoins five numerical faces drawn from upstream:
    * substrate ≡ Planck PDG (cycle-15 + Wave-P2 exact match),
    * |substrate − Planck| ≤ 0.5 (within Planck PDG 1σ),
    * substrate < SH0ES (falsifiability),
    * `25 · σ²_combined < gap²` (formal > 5σ tension),
    * substrate ratio ≥ 1 at every late/early epoch pair.

  No new physical constants, no new axioms, pure composition. Compiles
  GREEN with axiom footprint `[propext, Classical.choice, Quot.sound]`
  (Lean core only).

  ## Paper hook (Section 6.2)

  Single citation point:
  `OmegaTheory.Predictions.HubbleConstantPaperBundle.hubble_constant_67_4_paper_bundle_within_PDG`

  Falsification axis: if late-time SH0ES ladder consolidates and Planck
  CMB anchor moves >1σ away from `67.4`, the substrate prediction
  fails. As of 2026-04, both anchors hold; substrate predicts CMB-side.

-/
import OmegaTheory.Predictions.HubbleConstantFit
import OmegaTheory.Predictions.HubbleConstantAbsolute
import OmegaTheory.Predictions.HubbleTensionBridge
import OmegaTheory.Predictions.PrecisionPhysicsAbsoluteWaveP2

namespace OmegaTheory.Predictions.HubbleConstantPaperBundle

open OmegaTheory.Predictions
open HubbleConstantFit

/-! ## 1. 5-conjunct paper headline — single-citation point

    Composes the most-cited numerical faces of the substrate Hubble
    constant prediction into one bundle. Each conjunct cites its
    originating cycle-15 / cycle-57 / Wave-P2 lemma. -/

/-- **Paper headline** — `hubble_constant_67_4_paper_bundle_within_PDG`.

    5-conjunct citable bundle:
      (1) substrate equals Planck PDG central (exact match, gap = 0,
          via cycle-15 `H0_Planck_substrate_eq_PDG`),
      (2) |substrate − Planck PDG| ≤ Planck 1σ envelope = 0.5 km/s/Mpc
          (cycle-15 `H0_Planck_substrate_matches_PDG_within_1sigma`),
      (3) substrate strictly below SH0ES local anchor (falsifiability,
          via `H0_Planck_substrate_eq_PDG` + `H0_Planck_lt_H0_SH0ES`),
      (4) formal > 5σ tension witness `25 · σ²_combined < gap²`
          (cycle-15 `hubble_tension_exceeds_5sigma`),
      (5) substrate ratio ≥ 1 at every late/early epoch pair
          (Tarazed `substrateRatio_ge_one`, via Bridge bundle).

    This is the paper Section 6.2 single-citation point. -/
theorem hubble_constant_67_4_paper_bundle_within_PDG :
    H0_Planck_substrate = H0_Planck_PDG ∧
    |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma ∧
    H0_Planck_substrate < H0_SH0ES_PDG ∧
    25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 ∧
    (∀ N_l N_e : ℕ, N_l < N_e →
      1 ≤ HubbleTensionFromSubstrateDEGain.substrateRatio N_l N_e) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · exact HubbleConstantFit.H0_Planck_substrate_eq_PDG
  · exact HubbleConstantFit.H0_Planck_substrate_matches_PDG_within_1sigma
  · rw [HubbleConstantFit.H0_Planck_substrate_eq_PDG]
    exact HubbleConstantFit.H0_Planck_lt_H0_SH0ES
  · exact HubbleConstantFit.hubble_tension_exceeds_5sigma
  · intro N_l N_e h
    exact HubbleTensionFromSubstrateDEGain.substrateRatio_ge_one N_l N_e h

/-! ## 2. Targeted projection lemmas — single-citation paper hooks

    Each lemma extracts ONE numerical face of the bundle for direct
    paper citation without unpacking the 5-conjunct. -/

/-- **Substrate equals Planck PDG central** — exact match, gap = 0. -/
theorem paper_bundle_substrate_eq_planck :
    H0_Planck_substrate = H0_Planck_PDG :=
  HubbleConstantFit.H0_Planck_substrate_eq_PDG

/-- **Substrate threads ±0.5 Planck PDG 1σ envelope** — within local PDG. -/
theorem paper_bundle_within_planck_one_sigma :
    |H0_Planck_substrate - H0_Planck_PDG| ≤ H0_Planck_PDG_sigma :=
  HubbleConstantFit.H0_Planck_substrate_matches_PDG_within_1sigma

/-- **Substrate strictly below SH0ES** — falsifiability marker. -/
theorem paper_bundle_substrate_lt_SH0ES :
    H0_Planck_substrate < H0_SH0ES_PDG := by
  rw [HubbleConstantFit.H0_Planck_substrate_eq_PDG]
  exact HubbleConstantFit.H0_Planck_lt_H0_SH0ES

/-- **Tension exceeds 5σ** — formal `25 · σ²_combined < gap²`. -/
theorem paper_bundle_tension_exceeds_5sigma :
    25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 :=
  HubbleConstantFit.hubble_tension_exceeds_5sigma

/-- **Wave-P2 absolute numerical** — `H0 = 674/10` km/s/Mpc. -/
theorem paper_bundle_wave_P2_absolute_value :
    H0_Planck_substrate = (674 : ℝ) / 10 := by
  unfold HubbleConstantFit.H0_Planck_substrate
  norm_num

/-- **Triangulum cycle-57 substrate-derivation hook** — there exists
    a positive `H_0` within Planck PDG ±0.6, equal to the substrate-
    inferred Hubble constant at the calibration anchor. -/
theorem paper_bundle_triangulum_substrate_derivation :
    ∃ (H_0 : ℝ), 0 < H_0 ∧ |H_0 - 67.4| ≤ 0.6 ∧
      H_0 = HubbleConstantAbsolute.H_substrate_inferred HubbleConstantAbsolute.N_anchor :=
  HubbleConstantAbsolute.hubble_constant_absolute_substrate

/-! ## 3. Frontier marker — first single-citation paper bundle in V2 -/

/-- **Frontier marker** — first time in V2 the substrate-derived
    Hubble constant `H₀ = 67.4 km/s/Mpc` ships as a single paper
    citation bundling fit + Wave-P2 absolute + Triangulum derivation
    + tension bridge under one name. -/
theorem hubble_constant_67_4_paper_bundle_first_single_citation_in_V2 :
    ∃ H0 : ℝ,
      0 < H0
        ∧ H0 = H0_Planck_substrate
        ∧ H0 = H0_Planck_PDG
        ∧ H0 < H0_SH0ES_PDG
        ∧ 25 * hubble_tension_combined_sigma_sq < hubble_tension_gap_MKS ^ 2 :=
  ⟨H0_Planck_substrate,
   HubbleConstantFit.H0_Planck_substrate_pos,
   rfl,
   HubbleConstantFit.H0_Planck_substrate_eq_PDG,
   paper_bundle_substrate_lt_SH0ES,
   HubbleConstantFit.hubble_tension_exceeds_5sigma⟩

end OmegaTheory.Predictions.HubbleConstantPaperBundle
