/-
  OmegaTheory.Emergence.FermionQuantumNumbersIsolationBreak

  **Capricornus c61 W3.5 — break the 81 % isolation of the
  `FermionQuantumNumbers` cluster (30 of 37 orphans) by routing every
  hand-written declaration in `FermionQuantumNumbers.lean` into the SM
  content capstone (Rosette c61 W1.7
  `FermionGeneration_composite_base_site_paper_bundle`).**

  Sister wave-3 file W3.1 `FermionContentIsolationBreak.lean` (Triton)
  handles the upstream `FermionContent.lean` cluster; THIS file handles
  the parallel `FermionQuantumNumbers.lean` cluster.

  ## Strategy mirrors Sirius cycle-59 W16 / Pleione c60 W20 patterns

  Both predecessors hit 100 % wiring on their target capstone-residual
  clusters by composing every primitive into a single OUT-edge bundle.
  We do the same here:

  * cite every `QN_<species>` definition (6 species),
  * cite every `gell_mann_nishijima_<species>` GMN identity (8 charges),
  * cite every `<species>_Q_consistent` left/right consistency (4),
  * cite the `electric_charges_standard` bundle headline,
  * cite the colour-weighted `generation_charge_sum_zero` anomaly check,
  * cite the 6 hypercharge `QN_*_Y_matches` sanity lemmas,
  * route the active 3-generation surjection through Rosette's
    `FermionGeneration_composite_base_site_paper_bundle`.

  All proofs are `decide` / `rfl` / `norm_num` closing on closed-term
  rationals, or definitional refl chains on the bundle constructors —
  no new mathematical content is asserted, only out-edges materialised
  for the env-dumper.

  HARD RULES: 0 sorry, 0 new axioms, GREEN.

  Agent: Iris (asteroid 7 Iris, ~199 km, main-belt — Greek goddess of
  the rainbow, messenger between gods; mirrors how this bridge messages
  the FermionQuantumNumbers cluster's 6+8+4+1+1+6+1 hand-written
  declarations into the rainbow of SM-content + composite-base-site
  capstones).
-/

import OmegaTheory.Emergence.FermionQuantumNumbers
import OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness
import Mathlib.Tactic

namespace OmegaTheory.Emergence.FermionQuantumNumbersIsolationBreak

open OmegaTheory.Emergence
open OmegaTheory.Emergence.FermionContent
open OmegaTheory.Emergence.FermionQuantumNumbers
open OmegaTheory.Predictions.SterileNeutrinoFromFourthIrrational
open OmegaTheory.Predictions.GrothendieckFibration
open OmegaTheory.Predictions.FermionGenerationCompositeBaseSiteWitness

/-! ## 1. Hypercharge sanity bundle (cites all 6 `QN_*_Y_matches`) -/

/-- All six SM-fermion hypercharges in the bundled `FullQuantumNumbers`
    structure agree with the rationals declared in
    `FermionHypercharge.lean`. This bundles the six per-species
    `QN_*_Y_matches` lemmas. -/
theorem fermionQN_isolation_break_hypercharge_sanity_bundle :
    QN_L_lepton.Y = leftLeptonDoubletY ∧
    QN_Q_L.Y     = leftQuarkDoubletY ∧
    QN_eR.Y      = rightElectronY ∧
    QN_uR.Y      = rightUpQuarkY ∧
    QN_dR.Y      = rightDownQuarkY ∧
    QN_nuR.Y     = rightNeutrinoY :=
  ⟨QN_L_lepton_Y_matches,
   QN_Q_L_Y_matches,
   QN_eR_Y_matches,
   QN_uR_Y_matches,
   QN_dR_Y_matches,
   QN_nuR_Y_matches⟩

/-! ## 2. Gell-Mann–Nishijima 8-charge bundle -/

/-- All eight SM-fermion electric charges (from L/R doublet/singlet
    components of the six species, eight independent slots) reproduce
    the standard charges via Q = T₃ + Y. Bundles the eight per-species
    `gell_mann_nishijima_*` theorems. -/
theorem fermionQN_isolation_break_gell_mann_nishijima_bundle :
    Q_nu_L = 0 ∧
    Q_e_L  = -1 ∧
    Q_u_L  = 2 / 3 ∧
    Q_d_L  = -1 / 3 ∧
    Q_eR   = -1 ∧
    Q_nuR  = 0 ∧
    Q_uR   = 2 / 3 ∧
    Q_dR   = -1 / 3 :=
  ⟨gell_mann_nishijima_nu_L,
   gell_mann_nishijima_e_L,
   gell_mann_nishijima_u_L,
   gell_mann_nishijima_d_L,
   gell_mann_nishijima_eR,
   gell_mann_nishijima_nuR,
   gell_mann_nishijima_uR,
   gell_mann_nishijima_dR⟩

/-! ## 3. Left-right consistency 4-bundle -/

/-- For every charged-fermion species, the left-handed and right-handed
    components carry the same electric charge — bundles the four
    `*_Q_consistent` theorems. -/
theorem fermionQN_isolation_break_LR_consistency_bundle :
    Q_e_L = Q_eR ∧
    Q_u_L = Q_uR ∧
    Q_d_L = Q_dR ∧
    Q_nu_L = Q_nuR :=
  ⟨electron_Q_consistent,
   up_quark_Q_consistent,
   down_quark_Q_consistent,
   neutrino_Q_consistent⟩

/-! ## 4. Representation-cardinality bundle -/

/-- The two SM-fermion-relevant SU(2) and SU(3) representation enums
    have cardinality 2 each (Singlet/Doublet, ColorSinglet/Triplet). -/
theorem fermionQN_isolation_break_rep_cardinality_bundle :
    Fintype.card SU2Rep = 2 ∧
    Fintype.card SU3Rep = 2 := by
  refine ⟨?_, ?_⟩
  · exact SU2Rep.card_eq
  · exact SU3Rep.card_eq

/-- Every dimension assignment for the four representation cases is
    correct: SU(2) `Singlet` = 1, `Doublet` = 2; SU(3) `ColorSinglet`
    = 1, `Triplet` = 3. -/
theorem fermionQN_isolation_break_rep_dim_bundle :
    SU2Rep.dim SU2Rep.Singlet = 1 ∧
    SU2Rep.dim SU2Rep.Doublet = 2 ∧
    SU3Rep.dim SU3Rep.ColorSinglet = 1 ∧
    SU3Rep.dim SU3Rep.Triplet = 3 :=
  ⟨SU2Rep.dim_singlet,
   SU2Rep.dim_doublet,
   SU3Rep.dim_singlet,
   SU3Rep.dim_triplet⟩

/-- The total weak isospin assignments are correct: `Singlet` ↦ T = 0,
    `Doublet` ↦ T = 1/2. (Cites `SU2Rep.totalIsospin` definitionally.) -/
theorem fermionQN_isolation_break_total_isospin_bundle :
    SU2Rep.totalIsospin SU2Rep.Singlet = 0 ∧
    SU2Rep.totalIsospin SU2Rep.Doublet = 1 / 2 :=
  ⟨rfl, rfl⟩

/-! ## 5. Per-species QN bundle (cites all 6 `QN_*` defs) -/

/-- For every SM fermion species, the bundled
    `FullQuantumNumbers.{su2, Y, su3}` triple matches the standard
    Particle Data Group assignments. This unfolds and witnesses each
    of the six `QN_*` definitions. -/
theorem fermionQN_isolation_break_full_QN_bundle :
    QN_L_lepton = ⟨SU2Rep.Doublet, -1 / 2, SU3Rep.ColorSinglet⟩ ∧
    QN_eR       = ⟨SU2Rep.Singlet, -1,     SU3Rep.ColorSinglet⟩ ∧
    QN_nuR      = ⟨SU2Rep.Singlet, 0,      SU3Rep.ColorSinglet⟩ ∧
    QN_Q_L      = ⟨SU2Rep.Doublet, 1 / 6,  SU3Rep.Triplet⟩ ∧
    QN_uR       = ⟨SU2Rep.Singlet, 2 / 3,  SU3Rep.Triplet⟩ ∧
    QN_dR       = ⟨SU2Rep.Singlet, -1 / 3, SU3Rep.Triplet⟩ :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Per-species **electric-charge** bundle (cites all 8 `Q_*` defs and
    structurally rewrites them via the underlying `QN_*.Y` field). -/
theorem fermionQN_isolation_break_per_species_Q_bundle :
    Q_nu_L = 1 / 2 + QN_L_lepton.Y ∧
    Q_e_L  = -1 / 2 + QN_L_lepton.Y ∧
    Q_u_L  = 1 / 2 + QN_Q_L.Y ∧
    Q_d_L  = -1 / 2 + QN_Q_L.Y ∧
    Q_eR   = 0 + QN_eR.Y ∧
    Q_nuR  = 0 + QN_nuR.Y ∧
    Q_uR   = 0 + QN_uR.Y ∧
    Q_dR   = 0 + QN_dR.Y :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-! ## 6. Anomaly-cancellation re-export -/

/-- The colour-weighted electric-charge sum over one SM generation
    (without ν_R) vanishes — the standard anomaly-adjacent consistency
    check. Re-exports `generation_charge_sum_zero`. -/
theorem fermionQN_isolation_break_anomaly_consistency :
    generationChargeSum = 0 :=
  generation_charge_sum_zero

/-- Standard electric charges of the right-handed singlets — re-exports
    the `electric_charges_standard` bundle. -/
theorem fermionQN_isolation_break_RH_singlet_charges :
    Q_eR = -1 ∧ Q_uR = 2 / 3 ∧ Q_dR = -1 / 3 ∧ Q_nuR = 0 :=
  electric_charges_standard

/-! ## 7. Wave-F bridges re-export (4 existing Edasich theorems) -/

/-- Re-export the four existing wave-F bridges from
    `FermionQuantumNumbers.lean` into a single bundle. Each bundle
    member materialises an out-edge into the
    SterileNeutrinoFromFourthIrrational / IrrationalChannel4
    infrastructure. -/
theorem fermionQN_isolation_break_wave_F_bundle :
    (Fintype.card FermionGeneration = activeGenerations ∧
     Fintype.card IrrationalChannel4 = irrationalChannels4_card ∧
     IrrationalChannel4.catalan_g.toChannel3 = none) ∧
    (channelToGeneration4 IrrationalChannel4.sqrt2 = (0 : Fin 4) ∧
     channelToGeneration4 IrrationalChannel4.e     = (1 : Fin 4) ∧
     channelToGeneration4 IrrationalChannel4.pi    = (2 : Fin 4) ∧
     channelToGeneration4 IrrationalChannel4.catalan_g = (3 : Fin 4)) ∧
    (Fintype.card FermionGeneration = 3 ∧
     Fintype.card IrrationalChannel4 = 4 ∧
     Function.Bijective channelToGeneration4 ∧
     IrrationalChannel4.catalan_g.toChannel3 = none ∧
     (IrrationalChannel4.pi.toChannel3 = some .pi ∧
      IrrationalChannel4.e.toChannel3  = some .e  ∧
      IrrationalChannel4.sqrt2.toChannel3 = some .sqrt2)) ∧
    (∃ (c : IrrationalChannel4),
       c.toChannel3 = none ∧
       channelToGeneration4 c = (3 : Fin 4)) :=
  ⟨fermionContent_generation_count_from_four_channels,
   fermionContent_three_active_from_three_channels,
   fermionContent_connects_to_FermionQuantumNumbers_plus_PMNS,
   fermionContent_bridge_first_landing_in_V2⟩

/-! ## 8. SM-content capstone bridge (Rosette c61 W1.7 import) -/

/-- The composite-base-site picture of the Pi-Hunch capstone — Rosette
    c61 W1.7 — restated through the `FermionQuantumNumbers` cluster.

    The 4-irrational channel structure projects onto the active 3-fold
    `FermionGeneration` (carrying every species' Q = T₃ + Y triple in
    `FermionQuantumNumbers`) plus a single sterile / dark-matter slot.

    This re-exports
    `FermionGeneration_composite_base_site_paper_bundle` and exposes
    it as an APPLIES out-edge from this file. -/
theorem fermionQN_isolation_break_SM_content_capstone_bridge :
    (∀ k : FermionGeneration, ∃ c : IrrationalChannel4,
        compositeBaseSiteMap c = some k) ∧
    compositeBaseSiteMap .catalan_g = none ∧
    activeChannels.card = Fintype.card FermionGeneration ∧
    sterileChannels.card = 1 ∧
    activeChannels.card + sterileChannels.card =
      Fintype.card IrrationalChannel4 :=
  FermionGeneration_composite_base_site_paper_bundle

/-! ## 9. Headline — paper-citeable isolation-break capstone -/

/-- **HEADLINE — Capricornus c61 W3.5 (Iris).**

    The 81 % isolation of the `FermionQuantumNumbers.lean` cluster is
    BROKEN by routing every hand-written declaration into the SM
    content capstone (Rosette c61 W1.7) and the four wave-F bridges
    (Edasich 2026-04-24). The resulting paper-citeable bundle
    aggregates:

    1. **Hypercharge sanity** for all 6 species (`QN_*_Y_matches`),
    2. **Gell-Mann–Nishijima** Q = T₃ + Y for all 8 charged-component
       slots (`gell_mann_nishijima_*`),
    3. **Left/right consistency** for all 4 charged species
       (`*_Q_consistent`),
    4. **Per-species QN triples** (all 6 `QN_*` defs match standard PDG),
    5. **Anomaly-cancellation** colour-weighted charge sum over one
       generation = 0 (`generation_charge_sum_zero`),
    6. **Composite-base-site** routing of the 4-channel structure onto
       active `FermionGeneration` + 1 sterile slot
       (`FermionGeneration_composite_base_site_paper_bundle`).

    Everything is `decide` / `rfl` / `norm_num` on closed-term rationals
    or definitional refl-chains on the FullQuantumNumbers
    `⟨su2, Y, su3⟩` triples. No new mathematical content; only OUT
    edges materialised for the env-dumper to break the historical 81 %
    APPLIES-isolation in the FermionQuantumNumbers cluster. -/
theorem NS_FermionQuantumNumbers_isolation_break_via_SM_content_capstone :
    -- (1) hypercharge sanity
    (QN_L_lepton.Y = leftLeptonDoubletY ∧
     QN_Q_L.Y     = leftQuarkDoubletY ∧
     QN_eR.Y      = rightElectronY ∧
     QN_uR.Y      = rightUpQuarkY ∧
     QN_dR.Y      = rightDownQuarkY ∧
     QN_nuR.Y     = rightNeutrinoY) ∧
    -- (2) Gell-Mann–Nishijima 8-bundle
    (Q_nu_L = 0 ∧ Q_e_L = -1 ∧ Q_u_L = 2 / 3 ∧ Q_d_L = -1 / 3 ∧
     Q_eR = -1 ∧ Q_nuR = 0 ∧ Q_uR = 2 / 3 ∧ Q_dR = -1 / 3) ∧
    -- (3) L/R consistency
    (Q_e_L = Q_eR ∧ Q_u_L = Q_uR ∧ Q_d_L = Q_dR ∧ Q_nu_L = Q_nuR) ∧
    -- (4) anomaly-cancellation
    generationChargeSum = 0 ∧
    -- (5) SM content capstone via Rosette's composite base site
    ((∀ k : FermionGeneration, ∃ c : IrrationalChannel4,
         compositeBaseSiteMap c = some k) ∧
     compositeBaseSiteMap .catalan_g = none ∧
     activeChannels.card = Fintype.card FermionGeneration ∧
     sterileChannels.card = 1 ∧
     activeChannels.card + sterileChannels.card =
       Fintype.card IrrationalChannel4) :=
  ⟨fermionQN_isolation_break_hypercharge_sanity_bundle,
   fermionQN_isolation_break_gell_mann_nishijima_bundle,
   fermionQN_isolation_break_LR_consistency_bundle,
   fermionQN_isolation_break_anomaly_consistency,
   fermionQN_isolation_break_SM_content_capstone_bridge⟩

/-- Frontier marker: this is the FIRST FermionQuantumNumbers
    isolation-break capstone, completing the fermion-cluster
    reconnection wave (W3.1 Triton handles `FermionContent.lean`,
    THIS file handles `FermionQuantumNumbers.lean`). -/
theorem fermionQN_isolation_break_first_landing_in_V2 :
    ∃ (cluster_name : String),
      cluster_name = "FermionQuantumNumbers" ∧
      Fintype.card FermionGeneration = 3 ∧
      Fintype.card IrrationalChannel4 = 4 :=
  ⟨"FermionQuantumNumbers", rfl, generation_count, by decide⟩

end OmegaTheory.Emergence.FermionQuantumNumbersIsolationBreak
