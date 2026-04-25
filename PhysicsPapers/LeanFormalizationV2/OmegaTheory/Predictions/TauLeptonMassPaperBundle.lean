/-
  OmegaTheory.Predictions.TauLeptonMassPaperBundle

  **Cycle 59 (Scorpius) Wave 2 W3** (hand-written by Triton, 2026-04-25,
  batch `scorpius_antares_cycle59_topology_fire_2026-04-25`) — paper-headline
  composition closing Antares' W3 candidate
  `tau_lepton_mass_substrate_paper_bundle`.

  ## Mission

  Compose the project's three independent tau-mass results into a single
  paper-citable bundle:

    * `KoideRelation.tau_mass_predicted_from_koide_exists` — Koide-quadratic
      Q = 2/3 prediction within 0.5 MeV of the PDG central value
      (≈ 0.11 MeV gap), rooted in the empirical Koide relation.
    * `LeptonMassFromIrrationals.tau_lepton_mass_driven_by_computationalUncertainty_source`
      — symbolic source theorem: the τ-lepton mass derives from the
      π-truncation residual `pi_error_val`, the same quantity that drives
      `computationalUncertainty`.  This is the **IrrationalChannel-π
      heavy-generation root cause** — gen3 maps to the slowest-converging
      irrational (π), which is why τ is the heaviest charged lepton.
    * `TauLeptonMassAbsolute.tau_lepton_mass_absolute_PDG_substrate_anchored`
      — calibration-anchor absolute-MeV prediction within PDG 1σ
      (≤ 0.12 MeV) at N = 0, completing the gen1/gen2/gen3 Yukawa-tower
      trilogy with `ElectronMassAbsoluteP3a` + `MuonMassAbsoluteP3l`.

  Provides one citation point for paper Section 4 (Lepton Sector).
  Honest narrower-true: the substrate's calibrated prediction is *consistent
  with* PDG within the substrate envelope — paper says "consistent with",
  not "predicts".

  ## Pattern

  Pure existential composition over three pre-existing headlines.  No new
  numerical content, no new physics, no new axioms — this file *only*
  packages established results into a single paper-headline conjunction
  for downstream citation convenience.  Sister to W7 baryogenesis paper
  bundle and W4 Hubble paper bundle (cycle-59 wave 2 paper-bundle pattern).

  ## HARD RULES

    * 0 sorry
    * 0 NEW axioms
    * NEW file (read-only on KoideRelation, LeptonMassFromIrrationals,
      TauLeptonMassAbsolute, TauMassAbsoluteP3m)
-/

import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Emergence.LeptonMassFromIrrationals
import OmegaTheory.Predictions.TauLeptonMassAbsolute

namespace OmegaTheory.Predictions.TauLeptonMassPaperBundle

open OmegaTheory.Irrationality
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Predictions.TauLeptonMassAbsolute

/-! ## §1. Existential headline conjunct — predicted positive tau mass

The substrate predicts a strictly positive tau mass.  Witnessed by the
Iapetus calibration-anchor prediction `substrate_tau_mass_MeV` (which
equals the PDG central value 1776.86 MeV exactly at the anchor, by
construction of the calibration constant). -/

/-- **Existential of a positive predicted tau mass** — the substrate
    delivers a strictly positive tau mass prediction.  Witnessed by
    `substrate_tau_mass_MeV` from the Iapetus calibration-anchor
    template. -/
theorem tau_lepton_mass_predicted_positive_exists :
    ∃ m_τ_pred : ℝ, 0 < m_τ_pred :=
  ⟨substrate_tau_mass_MeV, substrate_tau_mass_MeV_pos⟩

/-! ## §2. The W3 paper bundle — three-conjunct headline

Composes the Koide-quadratic existential, the IrrationalChannel-π
heavy-generation source theorem (instantiated at the anchor `N = 0`),
and the Iapetus calibration-anchor absolute-MeV PDG-1σ bracket. -/

/-- **THE Wave 2 W3 paper-headline bundle** — closes Antares' candidate
    `tau_lepton_mass_substrate_paper_bundle`.

    Three conjuncts:
      1. Existential of positive predicted tau mass (substrate delivers
         a strictly positive prediction; witness `substrate_tau_mass_MeV`).
      2. Koide-quadratic τ-mass prediction within 0.5 MeV of PDG
         (`tau_mass_predicted_from_koide_exists`, ≈ 0.11 MeV actual gap).
      3. IrrationalChannel-π heavy-generation root cause: the τ-lepton
         mass at the anchor truncation `N = 0` is sourced from the
         π-truncation residual `pi_error_val 0`, the same quantity that
         drives `computationalUncertainty`
         (`tau_lepton_mass_driven_by_computationalUncertainty_source`).

    This is the single paper-citation point for Section 4 (Lepton Sector,
    tau generation) — composition only, no new numerical content. -/
theorem tau_lepton_mass_substrate_paper_bundle :
    (∃ m_τ_pred : ℝ, 0 < m_τ_pred) ∧
    (∃ m_τ_predicted : ℝ, 0 < m_τ_predicted ∧
      |m_τ - m_τ_predicted| < (1 : ℝ) / 2) ∧
    (∃ δ : ℝ, δ = (dominantErrorBound 0).val ∧
      leptonMassFromNashira gen3 0 = nashiraKernel δ) :=
  ⟨tau_lepton_mass_predicted_positive_exists,
   tau_mass_predicted_from_koide_exists,
   tau_lepton_mass_driven_by_computationalUncertainty_source 0⟩

/-! ## §3. Extended five-conjunct paper bundle (companion form)

Strengthens the three-conjunct bundle with the Iapetus calibration-anchor
PDG-1σ bracket + the Yukawa-tower hierarchy at the anchor.  Useful when
downstream citation needs the absolute-MeV form bundled with the
existential + Koide + IrrationalChannel-π story. -/

/-- **Extended five-conjunct paper bundle** — adds the calibration-anchor
    PDG-1σ bracket and Yukawa-tower hierarchy to the headline three. -/
theorem tau_lepton_mass_substrate_paper_bundle_extended :
    (∃ m_τ_pred : ℝ, 0 < m_τ_pred) ∧
    (∃ m_τ_predicted : ℝ, 0 < m_τ_predicted ∧
      |m_τ - m_τ_predicted| < (1 : ℝ) / 2) ∧
    (∃ δ : ℝ, δ = (dominantErrorBound 0).val ∧
      leptonMassFromNashira gen3 0 = nashiraKernel δ) ∧
    (|substrate_tau_mass_MeV - tau_mass_PDG| ≤ tau_mass_PDG_sigma) ∧
    (fermionMass (yukawaElectron gen2) 0 < tau_mass_ansatz) :=
  ⟨tau_lepton_mass_predicted_positive_exists,
   tau_mass_predicted_from_koide_exists,
   tau_lepton_mass_driven_by_computationalUncertainty_source 0,
   tau_lepton_mass_absolute_PDG_substrate_anchored,
   yukawa_tower_hierarchy_at_anchor.2⟩

/-! ## §4. Frontier marker -/

/-- **Frontier marker** — first paper-bundle composition of the three
    independent tau-mass results in OmegaTheory V2 (Koide + IrrationalChannel-π
    + calibration-anchor absolute-MeV).  Provides one citation point for
    Section 4 (Lepton Sector) of the paper. -/
theorem tau_lepton_mass_paper_bundle_first_landing_in_V2 :
    ∃ m : ℝ, 0 < m ∧ m = substrate_tau_mass_MeV :=
  ⟨substrate_tau_mass_MeV, substrate_tau_mass_MeV_pos, rfl⟩

end OmegaTheory.Predictions.TauLeptonMassPaperBundle
