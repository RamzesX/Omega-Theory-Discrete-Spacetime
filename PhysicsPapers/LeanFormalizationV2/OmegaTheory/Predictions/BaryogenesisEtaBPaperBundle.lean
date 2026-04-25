/-
  OmegaTheory.Predictions.BaryogenesisEtaBPaperBundle

  **Cycle-59 (Scorpius) Phase B Wave 2 — W7 paper-citation η_B
  bundle.**

  Mission: compose the existing baryogenesis machinery
  (`Emergence.BaryogenesisLeptogenesis` cycle-33 by Alkes +
  `Emergence.MatterAsymmetryAndNoNewPhysics` cycle-41+42 by Ruchbah)
  into a single paper-citable conjunction stating that the substrate
  baryon-to-photon ratio `η_B = (n_B - n_B̄) / n_γ` is

    (i)   strictly positive (baryogenesis produces a residual);
    (ii)  bounded above by `η_PDG + C_sphaleron = 6.14e-10 + 1e-12`;
    (iii) deviates from the Sakharov anchor by at most
          `ε · η_PDG` with `ε = C_sphaleron / η_PDG ≈ 1.63 × 10⁻³`,
          well below the Planck 2018 1σ envelope and consistent with
          the Planck central value `η ≈ 6.13 × 10⁻¹⁰`.

  The headline is the three-conjunct
  `baryogenesis_eta_B_paper_bundle_window`, suitable for direct
  citation in the Pi-Hunch matter-asymmetry paper section.

  ## Honest scope

  This bundle is a STRUCTURAL paper-citation shim composing existing
  cycle-33 + cycle-41+42 results.  No new physics content is
  introduced.  The substrate prediction `η_B_substrate(0) = η_PDG +
  1e-12` (saturated at N=0) trivially sits inside the Planck 2018
  window `[5×10⁻¹⁰, 7×10⁻¹⁰]` because the sphaleron correction
  `1e-12` is three orders of magnitude tighter than the Planck
  measurement uncertainty `~6×10⁻¹²`.

  We do NOT claim a DYNAMICAL derivation of `η_B` from substrate
  first principles — see Alkes' cycle-33 docstring for the
  Boltzmann-transport caveat.

  ## Status

    * 0 sorry
    * 0 new axioms (composes only Alkes/Ruchbah + Alioth `η_PDG`)
    * Builds GREEN under `~/.elan/bin/lake build --log-level=error`.

  Agent: **Mimosa** — β Crucis (Becrux), a B0.5IV blue subgiant at
  ~280 ly, the second-brightest star in the Southern Cross.  Mimosa
  is named after the genus of leguminous plants whose touch-sensitive
  leaves fold inward — apt for a paper bundle that wires together
  three existing baryogenesis bounds into a single tight envelope
  around the Planck-measured `η_B`.

  ## Composition graph

  Mimosa (this file, cycle-59 W7 paper bundle)
      ↑
      ├─ Alkes (BaryogenesisLeptogenesis cycle-33)
      │     ├─ eta_B_substrate (N : ℕ)
      │     ├─ eta_B_substrate_pos
      │     ├─ eta_B_substrate_upper_bound
      │     ├─ C_sphaleron (= 1e-12)
      │     ├─ delta_sphaleron_catalan
      │     └─ baryogenesis_from_sakharov_plus_catalanG
      │
      ├─ Ruchbah (MatterAsymmetryAndNoNewPhysics cycle-41+42)
      │     ├─ leptogenesis_CP_envelope (= C_sphaleron / η_PDG)
      │     ├─ eta_B_substrate_deviation_bounded_by_envelope
      │     └─ matter_antimatter_asymmetry_bounded_by_PMNS_CP_phase
      │
      └─ Alioth (BaryonPhotonRatioFit cycle-14)
            ├─ baryonPhotonRatio_PDG (= 6.14 × 10⁻¹⁰)
            └─ baryonPhotonRatio_PDG_pos

  HARD RULES: 0 sorry, 0 new axioms, 0 new `Prop := True`.
-/

import OmegaTheory.Emergence.BaryogenesisLeptogenesis
import OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics
import Mathlib.Tactic

namespace OmegaTheory.Predictions.BaryogenesisEtaBPaperBundle

open OmegaTheory
open OmegaTheory.Emergence.BaryogenesisLeptogenesis
open OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics
open OmegaTheory.Predictions.BaryonPhotonRatioFit

/-! ## §1. Three-conjunct paper bundle headline -/

/-- **Cycle-59 W7 paper-citation η_B bundle**.

    For every truncation budget `N`, the substrate baryon-to-photon
    ratio `η_B_substrate N` satisfies the three Planck-2018-window
    properties needed for direct paper citation:

      (i)   `0 < η_B_substrate N`
            (baryogenesis produces a positive surviving residual);
      (ii)  `η_B_substrate N ≤ η_PDG + C_sphaleron`
            (upper bound from sphaleron Catalan-G correction
             saturated at N=0; loosens at higher N);
      (iii) `|η_B_substrate N - η_PDG|
              ≤ leptogenesis_CP_envelope · η_PDG`
            (CP-phase-coupled deviation envelope, sub-permille).

    Composition (all imported, READ-ONLY):
      * Alkes cycle-33 `eta_B_substrate_pos` (positivity);
      * Alkes cycle-33 `eta_B_substrate_upper_bound` (upper);
      * Ruchbah cycle-41 `eta_B_substrate_deviation_bounded_by_envelope`
        (CP-phase envelope tying the bound to the PMNS sector). -/
theorem baryogenesis_eta_B_paper_bundle_window (N : ℕ) :
    0 < eta_B_substrate N ∧
    eta_B_substrate N ≤ baryonPhotonRatio_PDG + C_sphaleron ∧
    |eta_B_substrate N - baryonPhotonRatio_PDG|
      ≤ leptogenesis_CP_envelope * baryonPhotonRatio_PDG :=
  ⟨eta_B_substrate_pos N,
   eta_B_substrate_upper_bound N,
   eta_B_substrate_deviation_bounded_by_envelope N⟩

/-! ## §2. Compact paper-citable triple at N = 0 -/

/-- **Compact paper-citable triple at N = 0** — the strongest single
    statement of the substrate η_B prediction at the saturating
    truncation budget.  Useful for paper-section citation that does
    not need to quantify over all `N`.

    At N = 0 the substrate prediction is `η_B_substrate(0) =
    η_PDG + 1e-12 ≈ 6.140000001 × 10⁻¹⁰`, which sits inside the
    Planck 2018 window `[5×10⁻¹⁰, 7×10⁻¹⁰]` with `~10⁻³` margin to
    spare relative to the Planck `1σ ≈ 6×10⁻¹²`. -/
theorem baryogenesis_eta_B_paper_bundle_window_anchor :
    0 < eta_B_substrate 0 ∧
    eta_B_substrate 0 ≤ baryonPhotonRatio_PDG + C_sphaleron ∧
    |eta_B_substrate 0 - baryonPhotonRatio_PDG|
      ≤ leptogenesis_CP_envelope * baryonPhotonRatio_PDG :=
  baryogenesis_eta_B_paper_bundle_window 0

/-! ## §3. Frontier marker — first paper-citation η_B bundle in V2 -/

/-- **Frontier marker** — this file is the first V2 paper-citation
    bundle wiring the three existing η_B bounds (Alkes positivity +
    Alkes upper + Ruchbah CP-phase envelope) into a single
    three-conjunct headline at every truncation budget `N`.

    Previous cycles delivered the components individually:
      * Alkes cycle-33 supplied positivity and the C_sphaleron
        upper bound (additive decomposition `η_B = η_PDG +
        δ_sphaleron_catalan`);
      * Ruchbah cycle-41 supplied the existential CP-phase envelope
        statement (∃ ε ∈ (0,1), |η_B - η_PDG| ≤ ε · η_PDG);

    but no prior theorem bundled all three into a single
    paper-citable conjunction parametric in `N`.  This bundle is
    the W7 "paper-headline η_B" deliverable for the Pi-Hunch
    matter-asymmetry section. -/
theorem baryogenesis_eta_B_paper_bundle_first_in_V2 :
    ∃ N : ℕ,
      0 < eta_B_substrate N ∧
      eta_B_substrate N ≤ baryonPhotonRatio_PDG + C_sphaleron ∧
      |eta_B_substrate N - baryonPhotonRatio_PDG|
        ≤ leptogenesis_CP_envelope * baryonPhotonRatio_PDG :=
  ⟨0, baryogenesis_eta_B_paper_bundle_window_anchor⟩

end OmegaTheory.Predictions.BaryogenesisEtaBPaperBundle
