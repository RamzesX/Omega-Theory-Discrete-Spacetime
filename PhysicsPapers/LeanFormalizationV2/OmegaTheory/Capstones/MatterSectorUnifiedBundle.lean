/-
  OmegaTheory.Capstones.MatterSectorUnifiedBundle

  **Matter sector unified capstone bundle.**

  Agent: Mirach (β Andromedae, a red giant in the Andromeda
  constellation, one of the two naked-eye "pointer" stars that
  guide an observer to the Andromeda Galaxy M31).  2026-04-20,
  cycle 6 target 5/6.

  This file unifies the twelve core matter-sector results of the
  OmegaTheory V2 project under a single paper-citable headline
  theorem.  The twelve results — each already formalised by a
  different agent in its own module — span the full matter-sector
  chain from the substrate irrationals (π, e, √2) through the
  Higgs vev to the observed fermion masses, mixing angles, and
  CP phases.  The capstone asserts their simultaneous conjunction
  via the existing upstream proofs.

  ## Coordinate of the capstone

  The capstone sits over the pairing `(IrrationalChannel × ℕ)`,
  where the first factor is Spica's `IrrationalChannel` type
  (π / e / √2) and the second is the substrate truncation level
  `N`.  This pairing already underpins every single upstream
  theorem cited below — `GenerationMap.channelToGeneration`
  acts on the first factor, `Irrationality.computationalUncertainty`
  acts on the second.

  ## The twelve conjuncts

  1. **Electron mass** (Algol cycle 2, Scutulum cycle 4) —
     `electron_gen1_mass_eq_bound` : the gen-1 electron mass
     at truncation `N` equals the π-error-driven bound.
  2. **3-irrational ordering** (Nihal, Sadr) —
     `δ_channel_ordering` : `δ_√2 < δ_e < δ_π` at `N ≥ 2`.
  3. **D_F spectrum real** (Vindemiatrix, Sulafat) —
     `dirac_f_spectrum_real_unified_capstone` : every eigenvalue
     of the finite Dirac operator over every sector is real.
  4. **Yukawa capstone** (Zubenelgenubi, Sirius) —
     `YukawaMatrixFromD_F_electron_mass` : electron mass from
     the sector-specific D_F block is strictly positive.
  5. **Jarlskog** (Enif, Aspidiske) —
     `jarlskog_from_irrationals_pdg_capstone_holds` : positivity
     of the Jarlskog prediction + PDG constants + frontier window.
  6. **Koide relation** (Elnath) —
     `koide_formula_holds` : `|Q − 2/3| < 10⁻⁵` on PDG masses.
  7. **PMNS mixing** (Vindemiatrix) —
     `nufit2024_has_two_large_angles` : the leptonic mixing
     matrix from NuFIT 2024 has two large angles (PMNS signature).
  8. **Lepton hierarchy** (Sadr) —
     `leptonMass_hierarchy` : `m_{gen1} < m_{gen2} < m_{gen3}`
     at `N ≥ 2` under the Nashira kernel.
  9. **Nashira mass formula** (Sadr) —
     `leptonMassFromNashira_pos` : positivity of the Nashira
     prediction at every `N ≥ 2` and every generation.
  10. **FCNC absence** (Sabik) —
      `fcnc_absence_from_substrate_generation_diagonality` : for
      every pair of distinct generations, the neutral-current
      amplitude is bounded by the substrate FCNC suppression (0).
  11. **CP sign opposition** (Acubens) —
      `delta_CP_product_neg` : `δ_CP_CKM · δ_CP_PMNS < 0` from
      PDG constants (Vlasov's sign flip).
  12. **Generation map surjection** (Spica, Keid) —
      `three_irrationals_span_three_generations` : the three
      irrational channels surject onto the three generations.

  ## Content layout

  * `MatterSectorUnified` — a `Prop`-valued structure with twelve
    fields, one per conjunct above.
  * `matter_sector_unified_bundle` — the headline theorem:
    for every truncation level `N ≥ 2`, the `MatterSectorUnified`
    bundle holds.
  * `Mirach.provenance_*` — twelve per-conjunct wrapper lemmas
    that restate each upstream headline in the exact shape the
    bundle requires, so the headline proof is a direct anonymous
    constructor on existing content.

  ## HARD RULES

  * 0 sorry
  * 0 new axioms
  * 0 new `Prop := True` placeholders
  * No upstream file is re-opened or modified.

-/

import OmegaTheory.Emergence.ConnesBimodule
import OmegaTheory.Emergence.DiracFSpectrum
import OmegaTheory.Emergence.DiracFSpectrumReal
import OmegaTheory.Emergence.FermionContent
import OmegaTheory.Emergence.HiggsFromError
import OmegaTheory.Emergence.KoideRelation
import OmegaTheory.Emergence.LeptonMassFromIrrationals
import OmegaTheory.Emergence.PMNSMatrix
import OmegaTheory.Emergence.YukawaMatrix
import OmegaTheory.Irrationality.GenerationMap
import OmegaTheory.Predictions.CPSignFromIrrationalOrdering
import OmegaTheory.Predictions.FCNCAbsence
import OmegaTheory.Predictions.GenerationMassFromPiError
import OmegaTheory.Predictions.JarlskogFromIrrationals

namespace OmegaTheory.Capstones.MatterSectorUnifiedBundle

open OmegaTheory
open OmegaTheory.Emergence
open OmegaTheory.Emergence.DiracFSpectrum
open OmegaTheory.Emergence.DiracFSpectrumReal
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.HiggsFromError
open OmegaTheory.Emergence.KoideRelation
open OmegaTheory.Emergence.LeptonMassFromIrrationals
open OmegaTheory.Emergence.PMNSMatrix
open OmegaTheory.Emergence.YukawaMatrix
open OmegaTheory.Irrationality
open OmegaTheory.Predictions
open OmegaTheory.Predictions.CPSignFromIrrationalOrdering
open OmegaTheory.Predictions.JarlskogFromIrrationals

/-! ## 1.  The unified capstone structure

The `MatterSectorUnified` structure bundles the twelve matter-sector
conjuncts into one record.  A single term of type
`MatterSectorUnified N` witnesses that, at substrate truncation
level `N`, all twelve matter-sector results of the OmegaTheory
formalisation hold simultaneously.

The record is parameterised by `N : ℕ` only — the irrational-channel
factor is universally quantified inside each conjunct where
appropriate.  This matches the shape of every upstream headline
(Jarlskog, Koide, FCNC, electron mass, etc.) which is also either
parameter-free or `∀N`-quantified. -/

/-- **The twelve-conjunct matter-sector bundle at truncation `N`**.

    Every field is directly discharged by an existing upstream
    theorem (see the `Mirach.provenance_*` wrappers below). -/
structure MatterSectorUnified (N : ℕ) : Prop where
  /-- **(1) Electron mass.**  The gen-1 electron mass at truncation
      `N` equals the π-error-driven bound `electronMassScaleBound N`
      (Algol/Scutulum). -/
  electron_mass_eq_bound :
    fermionMass (yukawaElectron gen1) N = electronMassScaleBound N
  /-- **(2) Three-irrational ordering** at `N ≥ 2`:
      `δ_√2 < δ_e < δ_π` (Nihal, Sadr; Spica channel form).  Guarded
      by `hN : 2 ≤ N` so the ordering is vacuous at small `N`. -/
  three_irr_ordering (hN : 2 ≤ N) :
    δ_channel .sqrt2 N < δ_channel .e N
      ∧ δ_channel .e N < δ_channel .pi N
  /-- **(3) D_F spectrum real** — every eigenvalue of the four
      sector-specific finite Dirac operators (electron, up-quark,
      down-quark, neutrino) is a real number embedded in ℂ
      (Vindemiatrix, Sulafat). -/
  dirac_spectrum_real :
    (∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0)
  /-- **(4) Yukawa capstone** — the Yukawa-bundle electron mass is
      strictly positive at every generation and every truncation
      level (Sirius/Zubenelgenubi upgrade to the Connes YukawaBundle). -/
  yukawa_electron_mass :
    ∀ (g : FermionGeneration) (N' : ℕ),
      0 < standardD_F_electron.eigenvalues g * higgs_vev N'
  /-- **(5) Jarlskog invariant** — the Jarlskog prediction is
      strictly positive for every positive `K` and every `N`; the
      PDG-window constants are the right numbers (Enif, Aspidiske). -/
  jarlskog_positivity :
    (∀ K : ℝ, ∀ N' : ℕ, 0 < K → 0 < jarlskogFromIrrationals K N')
    ∧ J_CKM_PDG_low = 2.86e-5
    ∧ J_CKM_PDG_high = 3.33e-5
    ∧ JarlskogPDGWindowConsistency
  /-- **(6) Koide relation** — `|Q − 2/3| < 10⁻⁵` on PDG charged
      lepton masses (Elnath). -/
  koide_relation :
    |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000
  /-- **(7) PMNS mixing large-angle signature** — at least two of
      the three NuFIT 2024 angles exceed 0.2 rad (Vindemiatrix). -/
  pmns_two_large_angles :
    HasTwoLargeAngles PMNSAngles.nufit2024 0.2
  /-- **(8) Lepton hierarchy** at `N ≥ 2`:
      `m_{gen1} < m_{gen2} < m_{gen3}` (Sadr). -/
  lepton_hierarchy (hN : 2 ≤ N) :
    leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N
      ∧ leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N
  /-- **(9) Nashira positivity** at `N ≥ 2`: every generation
      has a strictly positive Nashira-kernel mass (Sadr). -/
  nashira_positive (hN : 2 ≤ N) :
    ∀ g : FermionGeneration, 0 < leptonMassFromNashira g N
  /-- **(10) FCNC absence** — for every pair of distinct fermion
      generations, the substrate structural neutral-current
      amplitude is bounded by the universal FCNC suppression
      (which is zero) (Sabik). -/
  fcnc_absence :
    ∀ (g₁ g₂ : FermionGeneration), g₁ ≠ g₂ →
      neutral_current_amplitude g₁ g₂ ≤ substrate_fcnc_suppression
  /-- **(11) CP sign opposition** — the product of the CKM and PMNS
      CP phases is strictly negative on PDG constants (Acubens). -/
  cp_sign_opposition :
    delta_CP_CKM_PDG * delta_CP_PMNS_PDG < 0
  /-- **(12) Generation map surjection** — the three irrational
      channels surject onto the three fermion generations
      (Spica, Keid). -/
  generation_surjection :
    Function.Surjective channelToGeneration

/-! ## 2.  Per-conjunct provenance wrappers

One wrapper per upstream headline theorem, each giving the exact
shape required by the `MatterSectorUnified` structure field.  The
wrappers are named `Mirach.provenance_*` so they do not collide
with any existing upstream name.

Every wrapper is a single `exact`, which is the whole point of the
capstone: we are **citing**, not reproving. -/

namespace Mirach

/-- **(1) Electron mass provenance** — delegates to
    `electron_gen1_mass_eq_bound` (Algol / Scutulum). -/
theorem provenance_electron_mass (N : ℕ) :
    fermionMass (yukawaElectron gen1) N = electronMassScaleBound N :=
  electron_gen1_mass_eq_bound N

/-- **(2) Three-irrational ordering provenance** — delegates to
    `δ_channel_sqrt2_lt_e` and `δ_channel_e_lt_pi` from
    `Irrationality.GenerationMap` (Nihal, Sadr, Spica). -/
theorem provenance_three_irr_ordering {N : ℕ} (hN : 2 ≤ N) :
    δ_channel .sqrt2 N < δ_channel .e N
      ∧ δ_channel .e N < δ_channel .pi N :=
  ⟨δ_channel_sqrt2_lt_e hN, δ_channel_e_lt_pi hN⟩

/-- **(3) D_F spectrum real provenance** — delegates to
    `dirac_f_spectrum_real_unified_capstone` (Vindemiatrix,
    Sulafat). -/
theorem provenance_dirac_spectrum_real :
    (∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0) :=
  dirac_f_spectrum_real_unified_capstone

/-- **(4) Yukawa capstone provenance** — delegates to
    `YukawaMatrixFromD_F_electron_mass` (Sirius dirac-swap). -/
theorem provenance_yukawa_electron_mass :
    ∀ (g : FermionGeneration) (N' : ℕ),
      0 < standardD_F_electron.eigenvalues g * higgs_vev N' :=
  YukawaMatrixFromD_F_electron_mass

/-- **(5) Jarlskog provenance** — delegates to
    `jarlskog_from_irrationals_pdg_capstone_holds` (Aspidiske). -/
theorem provenance_jarlskog :
    (∀ K : ℝ, ∀ N' : ℕ, 0 < K → 0 < jarlskogFromIrrationals K N')
    ∧ J_CKM_PDG_low = 2.86e-5
    ∧ J_CKM_PDG_high = 3.33e-5
    ∧ JarlskogPDGWindowConsistency :=
  jarlskog_from_irrationals_pdg_capstone_holds

/-- **(6) Koide relation provenance** — delegates to
    `koide_formula_holds` (Elnath). -/
theorem provenance_koide :
    |koideQ m_e m_μ m_τ - koideTheoretical| < 1 / 100000 :=
  koide_formula_holds

/-- **(7) PMNS two-large-angle provenance** — delegates to
    `nufit2024_has_two_large_angles` (Vindemiatrix). -/
theorem provenance_pmns_two_large_angles :
    HasTwoLargeAngles PMNSAngles.nufit2024 0.2 :=
  nufit2024_has_two_large_angles

/-- **(8) Lepton hierarchy provenance** — delegates to
    `leptonMass_hierarchy` (Sadr). -/
theorem provenance_lepton_hierarchy {N : ℕ} (hN : 2 ≤ N) :
    leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N
      ∧ leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N :=
  leptonMass_hierarchy hN

/-- **(9) Nashira positivity provenance** — delegates to
    `leptonMassFromNashira_pos` (Sadr). -/
theorem provenance_nashira_positive {N : ℕ} (hN : 2 ≤ N) :
    ∀ g : FermionGeneration, 0 < leptonMassFromNashira g N :=
  fun g => leptonMassFromNashira_pos hN g

/-- **(10) FCNC absence provenance** — delegates to
    `fcnc_absence_from_substrate_generation_diagonality` (Sabik). -/
theorem provenance_fcnc_absence :
    ∀ (g₁ g₂ : FermionGeneration), g₁ ≠ g₂ →
      neutral_current_amplitude g₁ g₂ ≤ substrate_fcnc_suppression :=
  fcnc_absence_from_substrate_generation_diagonality

/-- **(11) CP sign opposition provenance** — delegates to
    `delta_CP_product_neg` (Acubens). -/
theorem provenance_cp_sign_opposition :
    delta_CP_CKM_PDG * delta_CP_PMNS_PDG < 0 :=
  delta_CP_product_neg

/-- **(12) Generation map surjection provenance** — delegates to
    `three_irrationals_span_three_generations` (Spica, Keid). -/
theorem provenance_generation_surjection :
    Function.Surjective channelToGeneration :=
  three_irrationals_span_three_generations

end Mirach

/-! ## 3.  Headline theorem -/

/-- **HEADLINE.**  The matter-sector unified capstone holds at
    every substrate truncation level `N`.  Every one of the twelve
    conjuncts is an immediate invocation of an existing upstream
    headline through its `Mirach.provenance_*` wrapper — no new
    content, only unification.

    Physically: this is the single theorem a paper reader can cite
    to see that the twelve core matter-sector claims of OmegaTheory
    V2 — electron mass, three-irrational ordering, D_F reality,
    Yukawa positivity, Jarlskog, Koide, PMNS mixing, lepton
    hierarchy, Nashira positivity, FCNC absence, CP sign opposition,
    and the three-to-three generation surjection — live in a single
    formal bundle with a common `(IrrationalChannel × ℕ)` coordinate.

    Agent: Mirach, 2026-04-20, cycle-6 target 5/6. -/
theorem matter_sector_unified_bundle (N : ℕ) :
    MatterSectorUnified N where
  electron_mass_eq_bound    := Mirach.provenance_electron_mass N
  three_irr_ordering        := fun hN => Mirach.provenance_three_irr_ordering hN
  dirac_spectrum_real       := Mirach.provenance_dirac_spectrum_real
  yukawa_electron_mass      := Mirach.provenance_yukawa_electron_mass
  jarlskog_positivity       := Mirach.provenance_jarlskog
  koide_relation            := Mirach.provenance_koide
  pmns_two_large_angles     := Mirach.provenance_pmns_two_large_angles
  lepton_hierarchy          := fun hN => Mirach.provenance_lepton_hierarchy hN
  nashira_positive          := fun hN => Mirach.provenance_nashira_positive hN
  fcnc_absence              := Mirach.provenance_fcnc_absence
  cp_sign_opposition        := Mirach.provenance_cp_sign_opposition
  generation_surjection     := Mirach.provenance_generation_surjection

/-! ## 4.  Paper aliases

Convenience re-exports for the OmegaTheory manuscript. -/

/-- **Paper alias (∀N).**  The matter-sector capstone holds at
    every substrate truncation level, unconditionally. -/
theorem matter_sector_unified_bundle_forall :
    ∀ N : ℕ, MatterSectorUnified N :=
  matter_sector_unified_bundle

/-- **Paper alias (capstone shape).**  At any truncation level
    `N ≥ 2` — the "physically interesting" regime where both the
    three-irrational ordering and the lepton hierarchy are
    non-vacuous — the full twelve-conjunct bundle holds AND both
    `hN`-guarded conjuncts fire, producing a ten-plus-two-strong
    conjunction of physical statements. -/
theorem matter_sector_unified_bundle_at_physical_N
    {N : ℕ} (hN : 2 ≤ N) :
    (MatterSectorUnified N)
    ∧ (δ_channel .sqrt2 N < δ_channel .e N
         ∧ δ_channel .e N < δ_channel .pi N)
    ∧ (leptonMassFromNashira gen1 N < leptonMassFromNashira gen2 N
         ∧ leptonMassFromNashira gen2 N < leptonMassFromNashira gen3 N) := by
  refine ⟨matter_sector_unified_bundle N, ?_, ?_⟩
  · exact (matter_sector_unified_bundle N).three_irr_ordering hN
  · exact (matter_sector_unified_bundle N).lepton_hierarchy hN

/-- **Paper alias (structural backbone).**  The three-to-three
    generation surjection is the structural backbone of the entire
    matter-sector capstone.  Re-exported so the manuscript can cite
    it alongside the numerical headline. -/
theorem matter_sector_generation_surjection :
    Function.Surjective channelToGeneration :=
  (matter_sector_unified_bundle 0).generation_surjection

/-- **Paper alias (D_F reality).**  Re-export of the four-block
    D_F spectrum-real statement, pulled out of the capstone for
    emphasis in the Connes-mass-derivation chapter. -/
theorem matter_sector_dirac_spectrum_real :
    (∀ z ∈ spectrum ℂ electronD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ upQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ downQuarkD_F, Complex.im z = 0)
    ∧ (∀ z ∈ spectrum ℂ neutrinoD_F, Complex.im z = 0) :=
  (matter_sector_unified_bundle 0).dirac_spectrum_real

/-- **Paper alias (FCNC + CP signature).**  Re-export of the two
    experimentally-probed observables that distinguish substrate
    matter sector from a pure Standard Model coupling pattern. -/
theorem matter_sector_fcnc_cp_signature :
    (∀ (g₁ g₂ : FermionGeneration), g₁ ≠ g₂ →
       neutral_current_amplitude g₁ g₂ ≤ substrate_fcnc_suppression)
    ∧ delta_CP_CKM_PDG * delta_CP_PMNS_PDG < 0 :=
  ⟨(matter_sector_unified_bundle 0).fcnc_absence,
   (matter_sector_unified_bundle 0).cp_sign_opposition⟩

end OmegaTheory.Capstones.MatterSectorUnifiedBundle
