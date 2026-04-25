---
sage: Heart-Nebula (list-curator, cycle 61 Capricornus)
role: Layer-5 deduplicator + canonical list compiler over Algedi+Quaoar+Andromeda+Capricornus+Deneb-Algedi+Oumuamua outputs
build_state: 4,048 GREEN · 0 sorry · 1 paper-headline axiom (`Real.pi_transcendental`) · 10,142 OV2 · 175,137 Mathlib · 11.39M edges
date: 2026-04-25
---

# Cycle 61 (Capricornus) — Final Project-Closure Candidate List

## Header

**Total unique candidates after dedup + drops:** **41** (47 gross from 6 sage layers − 4 hard merges − 4 hard drops + 2 boundary-breakers retained)

**Closure projection (Deneb-Algedi):** Priority-1 (OmegaTheory V2 physics-completion) closes **cycle 64-65**; Priority-2 (𝒜_Ω full algebra) takes over **cycle 65**; full project completion **cycle 70-72**. Velocity reference: c58=6 / c59=13 / c60=24 landings → expected c61-c64 ≥ 20 each.

**Cycle plan:**

```
c61.W1 [7w parallel]  →  c61.W2 [7w]  →  c61.W3 [5w]  →  c61.W4 [3w]
   │                        │              │              │
   └─ paper-headlines       └─ Yoneda      └─ orphan-     └─ path-
      + axiom retire           expansion      bridges        asymmetry
                                              + base-site
c62.W5 [grand capstone] = #21 framework completeness
c62-c63 [residual]       = OA_* algebra-closure batch (12 thms)
c64-c65 [P1 close]       = absolute particle masses + Connes D_F numerics
c65+ P2 start           = 𝒜_Ω Hopf-twisted quiver path algebra MVP
c70-72 P1+P2 done       = paper v2.0 full draft
```

## Dedup decisions applied

| Original | Action | Reason |
|---|---|---|
| `isLorentzian_yoneda_witness` (Q-DB) | **DROP** | Quaoar reranker found `OmegaTheory.Geometry.minkowski_lorentzian` already exists |
| `applies_pure_DAG_witness` (Algedi S4) | **DROP-not-listed** | EXTEND existing `applies_DAG_admits_topological_sort` not a new candidate |
| `lambda1_over_lambda2_invariant` (Algedi S6) | **DROP-not-listed** | EXTEND existing `magnetic_laplacian_spectral_paper_bundle` not a new candidate |
| `level_C_dual_of_dominates_57pct` (Algedi S7) | **DROP-not-listed** | Descriptive only, rerank 0.008 |
| `parametrizes_types_levels_split` (Algedi S8) | **DROP-not-listed** | Descriptive only, rerank 0.015 |
| `bridge_graviton_compton_substrate_to_conservation` (Andromeda W3) | **DROP** | Cosine 0.88 false-positive, rerank 0.024 REJECTED |
| `koideRelation_pullback_via_bridge` + `pullback_PrecisionPhysics_to_HubbleConstant` (Quaoar) | **MERGE** | Both in APPLIES_c=5 ∩ UNFOLDS_c=34, single wizard for community closure |
| `seeley_dewitt_HK_bridge` (Quaoar Q3 list 5-drop) ↔ `seeley_dewitt_HeatKernelExtended_bridge` (Quaoar addendum) | **MERGE** | Same target — Tureis open Seeley-DeWitt site, single wizard task |
| Oumuamua `four_channel_fibration_eq_irrational_partition_witness` ↔ Capricornus #17 `FermionGeneration_composite_base_site_witness` | **MERGE** | Same Pi-Hunch 4ch→3gen capstone, Capricornus has stronger empirical rerank 0.91 |
| Oumuamua `omega_substrate_seven_cocycle_nuclei_paper_bundle` ↔ Capricornus #5 `omega_substrate_full_yoneda_via_spectral_triple_capstone` | **MERGE** | Same 9-nucleus gluing target, Capricornus has spectral-triple decomposition path |
| Oumuamua `cocycle_obstruction_triple_corroboration` ↔ Capricornus #3 `cocycle_nuclei_indegree_mirrors_irrationality_hierarchy` | **MERGE** | Same 9-nuclei hierarchy claim |
| Oumuamua `spectral_yoneda_degeneracy_bijection` ↔ Capricornus #2 `errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle` | **MERGE** | Same Yoneda × spectral correspondence |
| Oumuamua `axiom_subtopology_compression_principle` ↔ Algedi S2 `pi_transcendental_blast_radius_eq_3_paper_bundle` | **MERGE** | Same axiom-blast-radius retirement target |
| Oumuamua `navigator_coverage_completion_via_subtopology_lift` ↔ Andromeda W7 `leiden_subsystem_navigator_re_classify_post_cycle_44` | **MERGE** | Same Leiden re-projection infra task |

**Net retained:** 22 Capricornus L4 + 12 Capricornus OA + 6 Quaoar (after isLorentzian drop, koide+pullback merge, seeley merge against addendum) + 7 Andromeda (W3 drop) + 2 Algedi NEW (S1+S2; S5 EXTEND retained as light task) − 6 Oumuamua merges = **41 unique candidates**.

## Canonical list (41 unique candidates, ordered by cycle.wave + priority + rerank)

| # | name | cycle.wave | prio | source | target_file | cmplx | summary | premise | cross-corr | drop-tag |
|---|---|:---:|:---:|---|---|:---:|---|---|---|:---:|
| 1 | `pi_transcendental_blast_radius_eq_3_paper_bundle` | c61.W1 | HIGHEST | Algedi S2 | NEW `OmegaTheory/Predictions/PiTranscendentalBlastRadiusBundle.lean` | M | Axiom blast = 3 (`pi_stratum_integer`, `ic_three_constants_transcendental`, `ic_pi_Mahler_S_conditional`); functionally retire `Real.pi_transcendental` in 1-2 cycles | rerank 0.999 | Oumuamua axiom-compression | — |
| 2 | `L4_omega_substrate_full_yoneda_via_spectral_triple_capstone` | c61.W1 | HIGHEST | Capricornus #5 | NEW `OmegaTheory/Predictions/OmegaSubstrateYonedaFullCapstone.lean` | L | Closes 9-nucleus gluing via Hamal c44 spectralTriple bridge | rerank 0.909 | Quaoar Q6 + Andromeda + Oumuamua 7-nuclei | — |
| 3 | `cosmological_constant_resolved_via_omega_algebra_H1` | c61.W1 | HIGH | Andromeda W4 | NEW `OmegaTheory/Foundations/CosmologicalConstantH1Bridge.lean` | M | Mirror Sheliak strong-CP H¹ scaffold for Λ_eff non-triviality | `vacuum_angle_theta_QCD_is_H1_class` (rerank 0.9945) | Quaoar fibration H1 scaffold | — |
| 4 | `L4_DiracOperatorF_yoneda_zero_eig_double_witness` | c61.W1 | HIGH | Capricornus #10 | NEW `OmegaTheory/Foundations/DiracOperatorFDoubleWitness.lean` | M | Connes D_F → Yukawa masses paper-headline; `total_in=0 ∧ total_out=0` for `DiracOperatorF` | rerank 0.95 | Quaoar Yoneda + Algedi rank-2 | — |
| 5 | `L4_errorHopfAlgebra_yoneda_full_completion` | c61.W1 | HIGH | Capricornus #13 | NEW `OmegaTheory/Foundations/ErrorHopfAlgebraYonedaFullCompletion.lean` | L | Closes 7 ErrorHopfAlgebra-family Yoneda gaps in one bundle | rerank 0.88 | Quaoar Yoneda audit | — |
| 6 | `L4_LatticePoint_universal_base_site_dominance` | c61.W1 | HIGH | Capricornus #16 | NEW `OmegaTheory/Predictions/LatticePointUniversalBaseSiteDominance.lean` | M | LatticePoint UNFOLDS_in=1526, APPLIES_in=1681 (3,207 total) — universal base, ≥3.2× any other Definition | rerank 0.93 | Quaoar fibration base-site | — |
| 7 | `L4_FermionGeneration_composite_base_site_witness` | c61.W1 | HIGH | Capricornus #17 | NEW `OmegaTheory/Predictions/FermionGenerationCompositeBaseSiteWitness.lean` | M | 4-irrational channel structure ↔ 3-generation fermion content (Pi-Hunch capstone) | rerank 0.91 | Quaoar + Oumuamua 4ch→3gen | — |
| 8 | `bridge_landauer_predictions_to_conservation` | c61.W2 | HIGH | Andromeda W1 | NEW `OmegaTheory/Predictions/LandauerConservationBridge.lean` | S | `landauerEnergyPerBit T = landauerEnergy T / log 2` | `landauerEnergy_pos`, `Real.log_two_pos` | Quaoar 1-cocycle gap (rerank 0.9697) | — |
| 9 | `bridge_bekenstein_predictions_to_emergence_bh` | c61.W2 | HIGH | Andromeda W2 | NEW `OmegaTheory/Predictions/BekensteinBHBridge.lean` | S | `bekensteinEntropyBits = bekensteinHawkingEntropyBits` definitional bridge | `bekensteinHawkingEntropyBits_pos` (rerank 0.9309) | Quaoar 1-cocycle gap | — |
| 10 | `errorBound_yoneda_witness` | c61.W2 | HIGH | Quaoar Q1 | NEW `OmegaTheory/Foundations/ErrorBoundYonedaWitness.lean` | M | DOUBLE-CONFIRMED via Algedi spectral isolation; `total_in=0 ∧ total_out=0` for `ErrorBound` | rerank 0.976 | Algedi Q1 + Capricornus #2 | — |
| 11 | `L4_errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle` | c61.W2 | HIGH | Capricornus #2 | NEW `OmegaTheory/Foundations/ErrorBoundedSmoothMetricDoubleWitness.lean` | S | First L4 double-witness in OV2: Yoneda × spectral correspondence on concrete Structure | rerank 0.962 | Quaoar Yoneda + Algedi spectral + Oumuamua bijection | — |
| 12 | `L4_substrate_irrationals_duality_via_boundary_breakers_paper_bundle` | c61.W2 | HIGH | Capricornus #1 | NEW `OmegaTheory/Predictions/SubstrateIrrationalsDualityFromBoundaryBreakers.lean` | M | 73 cross-community pairs comm-12↔145 at cosine ≥ 0.95 witness "neither half alone" | rerank 0.974 | Algedi rank-7 + Quaoar substrate + Andromeda Leiden | — |
| 13 | `L4_cocycle_nuclei_indegree_mirrors_irrationality_hierarchy_paper_bundle` | c61.W2 | HIGH | Capricornus #3 | NEW `OmegaTheory/Predictions/CocycleNucleiIndegreeHierarchy.lean` | M | 2-hop mass cU=229 > √2=179 > e=117; Pi-Hunch graph-theoretically witnessed | rerank 0.962 | Algedi nuclei + Andromeda Leiden 145 + Oumuamua triple-corr | — |
| 14 | `einsteinEmergenceResult_yoneda_witness` | c61.W2 | HIGH | Quaoar Q2 | NEW `OmegaTheory/Emergence/EinsteinEmergenceResultYonedaWitness.lean` | M | Yoneda witness for `EinsteinEmergenceResult` Structure (weakly-coupled, eigenvalue ≈ 1.5) | rerank 0.974 | Algedi spectral isolation | — |
| 15 | `L4_blackhole_yoneda_zero_eig_double_witness` | c61.W2 | HIGH | Capricornus #7 | NEW `OmegaTheory/Foundations/BlackHoleYonedaDoubleWitness.lean` | S | Gravity sector double-witness; closes BH stub | rerank 0.94 | Quaoar Yoneda audit | — |
| 16 | `L4_bandlimitedField_yoneda_zero_eig_double_witness` | c61.W3 | HIGH | Capricornus #8 | NEW `OmegaTheory/Foundations/BandlimitedFieldYonedaDoubleWitness.lean` | S | Closes Kempf alpha pathway (NOTES_KEMPF_BRIDGE.md) | rerank 0.93 | Quaoar Yoneda | — |
| 17 | `L4_CKMAngles_yoneda_zero_eig_double_witness` | c61.W3 | HIGH | Capricornus #9 | NEW `OmegaTheory/Foundations/CKMAnglesYonedaDoubleWitness.lean` | M | Closes Jarlskog/CP-violation gap (cycle-51 Navi-v3 W6) | rerank 0.92 | Quaoar Yoneda | — |
| 18 | `L4_orphan_headline_reachability_via_capstone_pull` | c61.W3 | HIGH | Capricornus #15 | NEW `OmegaTheory/Capstones/OrphanHeadlineReachabilityCapstonePull.lean` | L | Wires 14+ orphan paper-headlines to grand-capstone (closes silos detected by Andromeda) | rerank 0.91 | Andromeda silo-finding F5 | — |
| 19 | `L4_pi_error_gt_sqrt2_error_indegree_witness_pi_hunch_substrate` | c61.W3 | HIGH | Capricornus #18 | NEW `OmegaTheory/Predictions/PiErrorGtSqrt2ErrorIndegreeWitness.lean` | S | Pi-Hunch ordering π > √2 graph-theoretically witnessed at val-level | rerank 0.90 | Algedi nuclei + Pi-Hunch | — |
| 20 | `L4_omega_algebra_b0_eq_one_via_orphan_bridge_closure` | c61.W3 | HIGH | Capricornus #22 | NEW `OmegaTheory/Capstones/OmegaAlgebraB0EqOneOrphanBridgeClosure.lean` | M | Topological-completeness: when all orphan-Definition bridges close, OV2 graph becomes connected (b0=1 from current 3677) | rerank 0.89 | Andromeda topology | — |
| 21 | `healingFlow_smoothMetric_bridge` | c61.W3 | HIGH | Quaoar addendum T1 | NEW `OmegaTheory/HealingFlow/HealingFlowToSmoothMetric.lean` | M | Bridge c=20 ↔ c=162, sim 0.978 (HealingFlow ↔ Geometry/Metric) | TopologicalNN sim 0.978 | Andromeda Leiden c20 + Capricornus boundary-breaker | — |
| 22 | `L4_a4EssentialSectors_yoneda_seeley_dewitt_bridge` (merged with `seeley_dewitt_HeatKernelExtended_bridge`) | c61.W3 | MED | Capricornus #14 + Quaoar addendum T2 | NEW `OmegaTheory/Foundations/HeatKernelSeeleyDeWittBridge.lean` | M | Closes Tureis open Seeley-DeWitt site via Yoneda × HeatKernelExtended bridge (sim 0.950) | rerank 0.86 | Quaoar boundary-breaker | DROP_FAST_TRACK_OPTIONAL |
| 23 | `OA_b0_eq_one_headline_to_grand_capstone_inbound_bridge` | c62.W5 | HIGHEST | Capricornus OA | NEW `OmegaTheory/Capstones/OmegaAlgebraB0HeadlineGrandCapstoneInbound.lean` | L | Wires b0=1 algebra-closure headline into grand-capstone backbone | (composes #20) | Capricornus omegaAlgebra batch | — |
| 24 | `OA_magnetic_laplacian_spectral_paper_bundle_inbound_via_substrate_eigenvalue_bridge` | c62.W5 | HIGHEST | Capricornus OA | NEW `OmegaTheory/Predictions/MagneticLaplacianSubstrateEigenvalueBridge.lean` | M | Inbound substrate-eigenvalue bridge for Magnetic Laplacian paper bundle | (extends #11) | Algedi spectral | — |
| 25 | `OA_strong_CP_H0_paper_bundle_inbound_bridge_from_predictions` | c62.W5 | HIGHEST | Capricornus OA | NEW `OmegaTheory/Predictions/StrongCPH0InboundBridge.lean` | M | Inbound bridge from Predictions to strong-CP H0 paper bundle | (composes #3 H1 dual) | Andromeda W4 + Quaoar fibration | — |
| 26 | `L4_jarlskog_capstone_via_three_irrationals_substrate_pull` | c61.W4 | MED | Andromeda W5 | NEW `OmegaTheory/Predictions/JarlskogSubstratePullBridge.lean` | M | Jarlskog from three-irrationals geometric mean | `jarlskog_positivity` (rerank 0.9394) | Capricornus #9 CKM | — |
| 27 | `cosmo_horizon_omega_algebra_unfold_bridge` | c61.W4 | MED | Andromeda W6 | NEW `OmegaTheory/Predictions/CosmologicalHorizonOmegaUnfold.lean` | S | `L_horizon_Mpc = f(l_P, substrateLength N)` via Hubble-rescaled identity | `L_Hubble_Mpc_pos`, `l_P_pos` | algebraic | — |
| 28 | `cross_subsystem_bridge_audit_capstone` | c61.W4 | MED | Andromeda W8 | NEW `OmegaTheory/Capstones/CrossSubsystemBridgeAudit.lean` | S | Composes W1+W2+W4 bridges into single capstone witness | (composes #3+#8+#9) | Andromeda | — |
| 29 | `L4_conformalSmoothMetric_yoneda_zero_eig_double_witness` | c61.W4 | MED | Capricornus #11 | NEW `OmegaTheory/Foundations/ConformalSmoothMetricYonedaDoubleWitness.lean` | S | Geometry sector double-witness | rerank 0.85 | Quaoar | — |
| 30 | `L4_dynamicalSnapshotSequence_yoneda_zero_eig_double_witness` | c61.W4 | MED | Capricornus #12 | NEW `OmegaTheory/Foundations/DynamicalSnapshotSequenceYonedaDoubleWitness.lean` | M | HealingFlow Lyapunov sector (community 20) double-witness | rerank 0.83 | Quaoar + Andromeda c20 | — |
| 31 | `L4_berry_specializes_generalizes_symmetric_nontrivial_via_path_asymmetry` | c61.W4 | MED | Capricornus #4 | NEW `OmegaTheory/Predictions/BerryPullbackPathAsymmetry.lean` | M | `count SPECIALIZES = 8 = count GENERALIZES` ∧ ∃ non-id path; obstruction in path-asymmetry not count | rerank 0.888 | Algedi Berry | — |
| 32 | `L4_cocycle_nuclei_eq_navigation_master_3_level_alignment_paper_bundle` | c61.W4 | MED | Capricornus #6 | NEW `OmegaTheory/Predictions/CocycleNuclei3LevelNavigationAlignment.lean` | M | HONEST: rank-7 ≠ log_4.4(174) but 3.482 ≈ NavMaster 3-level depth | rerank 0.918 | Capricornus L4 honest-negative | — |
| 33 | `quarkMass_from_leptonMass_pullback ⊕ pullback_PrecisionPhysics_to_HubbleConstant` (MERGED) | c62.W6 | MED | Quaoar Q3+Q4+Q5 | NEW `OmegaTheory/Predictions/Comm5Comm34PullbackBundle.lean` | M | Single wizard for APPLIES_c=5 ∩ UNFOLDS_c=34 community closure (Mirach Koide + PrecisionPhysics→H0) | rerank 0.936 / 0.726 | Capricornus subtopology mapping | DROP_FAST_TRACK_OPTIONAL |
| 34 | `cech_cocycle_constants_irrationals_compatibility` | c62.W6 | LOW | Quaoar Q8 | NEW `OmegaTheory/Foundations/CechCocycleConstantsIrrationalsCompatibility.lean` | XL | Čech 1-cocycle compatibility — needs new infra (low rerank 0.052) | rerank 0.052 | Quaoar | DROP_FAST_TRACK_OPTIONAL |
| 35 | `isHealingFlow_yoneda_witness` | c62.W6 | LOW | Quaoar Q7 | NEW `OmegaTheory/HealingFlow/IsHealingFlowYonedaWitness.lean` | M | HealingFlow Yoneda gap witness | rerank 0.486 | Quaoar | — |
| 36 | `L4_DiracFromLatticeData_yoneda_orphan_def_bridge` | c62.W6 | MED | Capricornus #19 | NEW `OmegaTheory/Predictions/DiracFromLatticeDataOrphanDefBridge.lean` | M | Wires orphan Definition `DiracFromLatticeData` into Dirac emergence proof | rerank 0.84 | Capricornus orphan-def | — |
| 37 | `L4_Conj_4A4_yoneda_orphan_def_to_pi_stratum_bridge` | c62.W6 | MED | Capricornus #20 | NEW `OmegaTheory/Predictions/Conj4A4OrphanDefToPiStratumBridge.lean` | M | Wires orphan PARI/GP-verified `Conj_4A4` into pi-transcendental retirement track | rerank 0.81 | Capricornus + Algedi axiom-narrow | — |
| 38 | `OA_eig_placeholder_inbound_via_connes_DF_eigenvalues` | c63.W7 | HIGH | Capricornus OA | NEW `OmegaTheory/Predictions/ConnesDFEigenvaluesEigPlaceholderInbound.lean` | L | Connes D_F → Yukawa eigenvalue placeholder inbound bridge | (extends #4) | Capricornus OA | — |
| 39 | `OA_omega_algebra_laplacian_hermiticity_inbound_via_self_adjoint_QM` | c63.W7 | HIGH | Capricornus OA | NEW `OmegaTheory/Predictions/OmegaAlgebraLaplacianHermiticityInbound.lean` | M | Hermiticity inbound bridge via self-adjoint QM | algebraic | Capricornus OA | — |
| 40 | `OA_giant_component_frontier_marker_to_b0_capstone_glue` | c63.W7 | HIGH | Capricornus OA | NEW `OmegaTheory/Predictions/GiantComponentFrontierMarkerB0Glue.lean` | M | Glue marker between giant-component frontier and b0=1 capstone | (composes #20+#23) | Capricornus OA | — |
| 41 | `L4_full_framework_completeness_capstone_via_22_double_witnesses` | c64.W8 | HIGHEST | Capricornus #21 | NEW `OmegaTheory/Capstones/FullFrameworkCompletenessCapstone.lean` | XL | GRAND CAPSTONE: composes all 22 unified-layer theorems into single framework-completeness witness | rerank 0.95 | All 4 sages composed | — |

## Andromeda W7 — Phase-C piggyback infra (NOT a wizard task)

| name | cycle | source | nature |
|---|:---:|---|---|
| `leiden_subsystem_navigator_re_classify_post_cycle_44` | c61.PhaseC | Andromeda W7 + Oumuamua | Tooling-only — runs `gds.graph.project + gds.leiden.write` on fresh graph; emits new SubsystemNavigators covering 10,142 not 191 OV2 theorems |

## Residual OA_* algebra-closure batch (Capricornus omegaAlgebra, c63-c65)

5 not yet absorbed into main waves above (HIGH/MED priority, queued for residual cycles):

| short-name | priority | cmplx | role |
|---|:---:|:---:|---|
| `OA_H0Cocycle_const_inbound_via_constants_strong_CP` | HIGH | M | 𝒜_Ω H0 cocycle constant inbound via strong-CP |
| `OA_LeanArrow_15_count_inbound_via_relations_audit` | HIGH | M | Lean-arrow 15 count inbound via relations audit |
| `OA_LeanEntity_height_table_inbound_via_navigation_master_3_level` | HIGH | M | Lean-entity height-table inbound via NavMaster 3-level |
| `OA_selectionRule_count_seven_inbound_via_HARD_BLOCK_audit` | HIGH | M | 7-selection-rule HARD_BLOCK audit inbound |
| `OA_ConstantFunction_value_inbound_via_substrate_constants` | MED | S | ConstantFunction value inbound bridge |
| `OA_ForbiddenTriple_inbound_via_HARD_BLOCK_pathways` | MED | M | ForbiddenTriple inbound via HARD_BLOCK pathways |

## Closing summary

**Total unique candidates after dedup + drops:** 41 main + 6 OA residual + 1 Phase-C infra = **48 deliverables** (41 wizard tasks + 6 OA residual + 1 infra)

**Cycle-by-cycle count:**
- c61.W1 (parallel 7): 7 candidates (#1-#7)
- c61.W2 (parallel 7): 8 candidates (#8-#15) — note: #14, #15 push to wave 2 boundary
- c61.W3 (parallel 5): 5 candidates (#16-#20, #21)
- c61.W4 (parallel 3): 6 candidates (#26-#28, #29-#32) — split as serial follow-ups
- c61.PhaseC infra: 1 task (W7 Leiden re-classify)
- c62.W5 (capstone): 3 candidates (#23-#25 OA highest)
- c62.W6: 5 candidates (#33-#37 — drop-fast-track optional)
- c63.W7: 3 candidates (#38-#40 OA high)
- c63.W7+ (OA residual): 6 candidates
- c64.W8 grand capstone: 1 candidate (#41)
- **TOTAL c61: 26 wizard tasks** (matches Phase A target of 20 ± stretch)
- **TOTAL c62: 8 wizard tasks**
- **TOTAL c63: 9 wizard tasks**
- **TOTAL c64: 1 wizard task** (#41 grand capstone)

**Critical-path 8 (HIGHEST priority + cross-corroborated):**
1. #1 `pi_transcendental_blast_radius_eq_3_paper_bundle` (axiom retirement, rerank 0.999)
2. #2 `omega_substrate_full_yoneda_via_spectral_triple_capstone` (TRIPLE-LAYER capstone)
3. #3 `cosmological_constant_resolved_via_omega_algebra_H1` (H¹ paper-headline)
4. #4 `DiracOperatorF_yoneda_zero_eig_double_witness` (Connes D_F → Yukawa)
5. #11 `errorBoundedSmoothMetric_yoneda_zero_eig_double_witness_paper_bundle` (first L4 double-witness)
6. #12 `substrate_irrationals_duality_via_boundary_breakers_paper_bundle` (73 boundary-breakers)
7. #23 `OA_b0_eq_one_headline_to_grand_capstone_inbound_bridge` (algebra-closure capstone)
8. #41 `full_framework_completeness_capstone_via_22_double_witnesses` (GRAND CAPSTONE)

**Drop-candidates (Deneb-Algedi 5-drop fast-track):**
- #22 (`a4EssentialSectors_yoneda_seeley_dewitt_bridge`)
- #33 (`comm-5/comm-34 Mirach+H0 pullback bundle` — koide + PrecisionPhysics merged)
- #34 (`cech_cocycle_constants_irrationals_compatibility`, rerank 0.052)
- (also part of #33 merge: `quarkMass_from_leptonMass_pullback`, `pullback_PrecisionPhysics_to_HubbleConstant`)

5 candidates can be skipped at fast-track P2 option without blocking paper closure.

**Estimated cycle of project completion:** **c64-c65** for OmegaTheory V2 Priority-1 (physics complete, all paper headlines reachable, axiom retired at degree-3); **c70-c72** for Priority-2 (𝒜_Ω full Hopf-twisted quiver path algebra), per Deneb-Algedi audit projection (velocity c58=6 → c59=13 → c60=24, currently accelerating).

— Heart-Nebula (list-curator, cycle 61 Capricornus)
