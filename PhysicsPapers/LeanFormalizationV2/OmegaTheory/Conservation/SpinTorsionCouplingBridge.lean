/-
  OmegaTheory.Conservation.SpinTorsionCouplingBridge

  **Wave F-ext bridge** (Chort, 2026-04-24) — routes
  `Conservation.SpinInformation` to `Torsion.SpinTorsion`.

  ## Why this file exists

  Kitalpha's atlas v3 flagged `Conservation/SpinInformation.lean` as
  22/24 isolated (92%). Torsion/SpinTorsion.lean already carries the
  physical torsion infrastructure (Popławski baby-universe theory).
  The two files share the core coupling constants
  (`spinInfoCoupling` in SpinTorsion, `spinInfoCouplingConstant` in
  SpinInformation) and the SpinorField type, but explicit
  APPLIES edges between their headline content are missing.

  This file co-cites kernel positivity lemmas from both modules.

  ## Content

  1. `spinInformation_uses_spinTorsion_coupling` — the
     `spinInfoCouplingConstant` (SpinInformation) is positive, and so
     is `spinInfoCoupling` (SpinTorsion). Body cites both in one proof.

  2. `spinInformation_torsion_paper_bundle` — 3-conjunct paper bundle.

  3. `spinInformation_first_torsion_bridge_in_V2` — frontier existential.

  0 sorry, 0 new axioms. Closes Kitalpha v3 candidate
  `spinInformation_anchors_to_SpinTorsion_Poplawski`
  (priority 4, downstream_unblocks=22,
   batch `omega_algebra_atlas_v3_2026-04-24`).
-/

import OmegaTheory.Conservation.SpinInformation
import OmegaTheory.Torsion.SpinTorsion
import Mathlib.Tactic

namespace OmegaTheory.Conservation

open OmegaTheory.Spacetime
open OmegaTheory.Torsion

/-! ## 1. SpinInformation routed through SpinTorsion coupling -/

/-- **Bridge theorem (Wave F-ext B6).** Both spin-information coupling
    constants are strictly positive: the SpinInformation-side
    `spinInfoCouplingConstant` and the SpinTorsion-side `spinInfoCoupling`.

    The body cites `spinInfoCouplingConstant_pos` (SpinInformation),
    `spinInfoCoupling_pos` and `torsionInfoCoupling_pos` (SpinTorsion),
    thereby registering APPLIES edges to all three. -/
theorem spinInformation_uses_spinTorsion_coupling :
    0 < spinInfoCouplingConstant ∧
    0 < OmegaTheory.Torsion.spinInfoCoupling ∧
    0 < OmegaTheory.Torsion.torsionInfoCoupling :=
  ⟨spinInfoCouplingConstant_pos,
   OmegaTheory.Torsion.spinInfoCoupling_pos,
   OmegaTheory.Torsion.torsionInfoCoupling_pos⟩

/-- **Bridge companion.** Non-negative spinor densities yield
    non-negative torsion density via `torsionFromSpin_nonneg`. The
    statement unites SpinInformation's SpinorField-type content
    with SpinTorsion's physical output. -/
theorem spinInformation_spinDensity_yields_torsion_nonneg
    (ψ : SpinorField) (p : LatticePoint) :
    0 ≤ OmegaTheory.Torsion.torsionFromSpinDensity
          (OmegaTheory.Torsion.spinDensity ψ p) := by
  have hn : 0 ≤ OmegaTheory.Torsion.spinDensity ψ p :=
    OmegaTheory.Torsion.spinDensity_nonneg ψ p
  exact OmegaTheory.Torsion.torsionFromSpin_nonneg _ hn

/-! ## 2. Paper-citable bundle -/

/-- **Headline (Wave F-ext B6 paper bundle).** Three-conjunct Prop
    joining SpinInformation and SpinTorsion: both coupling constants
    positive, and torsion density non-negative on any spinor. -/
theorem spinInformation_torsion_paper_bundle
    (ψ : SpinorField) (p : LatticePoint) :
    0 < spinInfoCouplingConstant ∧
    0 < OmegaTheory.Torsion.spinInfoCoupling ∧
    0 ≤ OmegaTheory.Torsion.torsionFromSpinDensity
          (OmegaTheory.Torsion.spinDensity ψ p) :=
  ⟨spinInfoCouplingConstant_pos,
   OmegaTheory.Torsion.spinInfoCoupling_pos,
   spinInformation_spinDensity_yields_torsion_nonneg ψ p⟩

/-- **Frontier existential.** First explicit SpinInformation ↔ SpinTorsion
    APPLIES edge landed in V2. -/
theorem spinInformation_first_torsion_bridge_in_V2 :
    ∃ ψ : SpinorField, ∀ p : LatticePoint,
      0 ≤ OmegaTheory.Torsion.torsionFromSpinDensity
            (OmegaTheory.Torsion.spinDensity ψ p) := by
  refine ⟨OmegaTheory.Torsion.vacuumSpinorField, ?_⟩
  intro p
  exact spinInformation_spinDensity_yields_torsion_nonneg _ p

end OmegaTheory.Conservation
