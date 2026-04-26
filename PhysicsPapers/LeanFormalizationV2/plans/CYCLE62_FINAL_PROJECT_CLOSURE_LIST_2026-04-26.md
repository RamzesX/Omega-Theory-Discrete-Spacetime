---
sage: Saturn-Nebula (NGC 7009 — "the Cat's Eye Companion in Aquarius")
role: Layer-5 CURATOR, Aquarius cycle 62 — sage-5/5 of sequential collective
build_state: 4,048 GREEN · 0 sorry · 1 paper-headline `:Axiom` (`Real.pi_transcendental`, blast=6) · 10,142 OV2 · 175,137 Mathlib · 7.65M typed edges
date: 2026-04-26
predecessors:
  - sage-1 Albali (ε Aqr, SPECTRAL) — `CYCLE62_SAGE_SPECTRAL_AQUARIUS_2026-04-26.md` — 30 candidates
  - sage-2 Hydor (λ Aqr, FIBRATION) — `CYCLE62_SAGE_FIBRATION_AQUARIUS_2026-04-26.md` — 47 (UP +17, 3 corrections)
  - sage-3 Helix-Nebula (NGC 7293, TOPOLOGY) — `CYCLE62_SAGE_TOPOLOGY_AQUARIUS_2026-04-26.md` — 56 (UP +9, sharp Betti)
  - sage-4 Sadalsuud-II (β Aqr, SYNTHESIZER) — `CYCLE62_SAGE_SYNTHESIZER_AQUARIUS_2026-04-26.md` — 75 (UP +19, full eigh)
predecessor_cycle: c61 close (Algedi+Quaoar+Andromeda+Capricornus+Deneb-Algedi+Heart-Nebula+ʻOumuamua) — 75 deliverables
---

# Cycle 62 (Aquarius) — Final Project-Closure Candidate List

## Header

**Total raw candidates from 4 sages:** 75
**Drops on dedup (10):** 5 c61-duplicates (Hydor Y1/Y2/Y6/Y7/Y8) + 5 sage-rejected (Albali #2/#28/#29, Hydor H4, Helix T-VR-2-recipe)
**Merges (5 sources → 2 entries):** L4-CP-1 absorbs L4-S-1 + L4-M-2 + Albali #1 (4 entries → 1 super-capstone); L4-CP-2 absorbs Hydor Y9 (2 → 1)
**Net candidate compression:** 75 raw → **60 canonical deliverables** (drop 10, merge-3-net = −15)

**Closure projection:**
Sadalsuud-II's full `numpy.linalg.eigh` precision win (Helix-Nebula's Rayleigh estimate was 0.21% off true λ₁=714.47) lets us tighten the c70-c72 P1 completion to **c69-c70** for Priority-1 (physics + axiom retire). At Capricornus c61 saturation velocity (75 deliverables/cycle) the canonical 60 close in **2 cycles** (c62 + c63 cleanup); add 2 cycles for Priority-2 (𝒜_Ω full algebra) → **cycle 67 P1 complete**, **cycle 69 P2 (𝒜_Ω full Hopf-twisted quiver path algebra) — ≈3 weeks realtime**.

**5-wave c62 plan + grand capstone:**

```
c62.W1 [7w parallel]   →  Critical path: super-capstone + spectral foundations + algebra-boundary (#1-#7)
c62.W2 [7w parallel]   →  Cross-lens Yoneda + cohomology + Yoneda-fresh (#8-#14)
c62.W3 [7w parallel]   →  Namespace-isolation + sector closures + Yoneda physics (#15-#21)
c62.W4 [5w parallel]   →  Persistence atlas + opaque-bundle topology + meta foundation (#22-#26)
c62.W5 [3w SUPER]      →  L4 unified mega-capstone composing all 25 prior + 8 fresh (#27)
c63.W6 [7w]            →  Tail: cohomology cocycles + Mayer-Vietoris extensions (#28-#34)
c63.W7 [7w]            →  Forman-Ricci + persistence + sheaf cover (#35-#41)
c63.W8 [7w]            →  Genuine-isolate paper-bundles G1-G4 + Pi-Hunch witnesses (#42-#48)
c64-drop-track [12]    →  optional fast-track tail (#49-#60)
```

## Mandatory dedup decisions applied

### Drop set (10 entries removed from raw 75)

**5 c61-duplicates** (already in cycle-61 closure list, do NOT re-dispatch):
- Hydor Y1 `errorBound_yoneda_witness_canonical` ⇒ DUPLICATE of c61 #10 `errorBound_yoneda_witness` (both Quaoar Q1 + Algedi spectral). DROP.
- Hydor Y2 `einsteinEmergenceResult_yoneda_witness_canonical` ⇒ DUPLICATE of c61 #14 `einsteinEmergenceResult_yoneda_witness`. DROP.
- Hydor Y6 `diracOperatorF_yoneda_witness` ⇒ STRICTLY-WEAKER of c61 #5 `L4_DiracOperatorF_yoneda_zero_eig_double_witness` (already double-witness). DROP.
- Hydor Y7 `blackHole_yoneda_witness` ⇒ STRICTLY-WEAKER of c61 #15 `L4_blackhole_yoneda_zero_eig_double_witness`. DROP.
- Hydor Y8 `bandlimitedField_yoneda_witness` ⇒ DUPLICATE of c61 #37 `L4_bandlimitedField_yoneda_zero_eig_double_witness`. DROP.

**5 sage-rejected drops** (multiple sages flagged or schema-only):
- Albali #2 `eig_placeholder_post_c61_invariance_witness` ⇒ Helix-Nebula T-LIVE-2 KILLED (placeholder is schema, not spectrum; live ratio 4.821, schema 1.167, neither is 1.038). DROP.
- Albali #28 `magnetic_laplacian_post_c62_re_compute_recipe` ⇒ recipe, not theorem; absorbed into L4-CP-1. DROP.
- Albali #29 `lambda1_lambda2_1_038_invariance_predicate` ⇒ empirically false on live matrix (Sadalsuud-II eigh proves it). DROP.
- Hydor H4 `omega_algebra_b2_at_least_one_witness_via_unfolds_folds_pair` ⇒ Helix-Nebula DROPPED (no FOLDS arrow extracted in graph; needs new extraction pipeline). DROP.
- Helix T-VR-2 `vietoris_rips_persistence_landscape_recipe` ⇒ recipe, not theorem; absorbed into T-VR-1 / L4-P-1. DROP.

### Merge set (5 source candidates → 2 canonical entries)

**Merge α (4 → 1):** L4-CP-1 `omega_substrate_grand_unified_capstone_via_4lens_synthesis` ABSORBS Albali #1 `magnetic_laplacian_post_c61_re_encoding_paper_bundle` + L4-S-1 `magnetic_laplacian_full_spectrum_paper_capstone` + L4-M-2 `c145_omega_algebra_boundary_substrate_paper_bundle`. The mega-capstone is THE paper-headline; the three subordinate bundles are written WITHIN the same Lean file as named lemmas. Single wizard, single file, 4 paper-headlines via `And.intro` chain.
- L4-CP-1 stays in the table as the primary entry.
- L4-S-1, L4-M-2, Albali #1 DEMOTED to subordinate-lemma status (still proven, but bundled).

**Merge β (2 → 1):** L4-CP-2 `c145_yoneda_orphan_structure_dual_paper_bundle` ABSORBS Hydor Y9 `omega_algebra_yoneda_total_completeness_capstone`. Both target the 132-Yoneda-orphan ↔ c145 algebra-boundary closure. Sadalsuud-II §11 hot-tip explicitly says Y9 is the "knockout double-witness" version of c145 closure. Single wizard.
- L4-CP-2 stays.
- Y9 DEMOTED.

### Defer set (0 entries — Helix-Nebula's 3 deferred items already absorbed)

Helix-Nebula deferred (3 items): Hydor #29 invariance-predicate, Hydor #16 BFS-reach, Hydor H4 b₂. The first two were absorbed into other entries by Sadalsuud-II; H4 was DROPPED above. **No fresh defers.**

## Critical path top-8 (paper-headline + rerank ≥ 0.90)

| # | candidate | rerank | source | what it locks in for paper v2.0 |
|---:|---|:---:|---|---|
| 1 | `omega_substrate_grand_unified_capstone_via_4lens_synthesis` | 0.95+ | L4-CP-1 (Sadalsuud-II) | THE flagship: b₀=3760, b₁=2779, λ₁=714.47, c145 bridge, 8 H¹ pairs, Pi-Hunch dominance, Frobenius² 533098.5 — single capstone composing all 4 lenses |
| 2 | `c145_yoneda_orphan_structure_dual_paper_bundle` | 0.94 | L4-CP-2 (Sadalsuud-II) | THE algebra-boundary: c145 (734 thms) ⊃ 132 Yoneda-orphans; UNFOLDS witness path |
| 3 | `qm_yukawa_disjoint_via_c145_bridge_unified_witness` | 0.93 | L4-M-4 (Sadalsuud-II) | First topological-isolation theorem in OV2; ∀ APPLIES path c12→c159 traverses c145 OR c1 |
| 4 | `mayer_vietoris_5pair_grand_unified_paper_capstone` | 0.92 | L4-M-1 (Sadalsuud-II) | First multi-pair Mayer-Vietoris computation in OV2; 5 pair signatures with c145+c1 two-pillar substrate scaffold |
| 5 | `magnetic_laplacian_eigenvector_localization_5tier_paper_bundle` | 0.92 | L4-S-2 (Sadalsuud-II) | First eigenvector localization for OV2; mirrors Aludra c44 FastRP {43379, 41787, 1722, 127, 3.83} 5-tier |
| 6 | `pi_transcendental_blast_radius_six_paper_bundle` | 0.91 | Hydor H2 | HONEST-NEGATIVE: Albali's claimed 0 inbound was wrong; actual 6 dependents, narrowness IS the headline |
| 7 | `applies_undirected_b0_eq_3760_witness_paper_bundle` | 0.91 | Helix T-LIVE-3 | First sharp Betti-0 for 10K-theorem Lean corpus |
| 8 | `applies_undirected_b1_eq_2779_witness_paper_bundle` | 0.90 | Helix T-LIVE-4 | First sharp Betti-1 via Euler character |

## Canonical 60-deliverable dispatch table (sortable, ordered by cycle.wave + priority + rerank)

| # | name | cycle.wave | prio | source-sage | target_file | cmplx | summary | premise (rerank) | cross-corr | drop-tag |
|---|---|:---:|:---:|---|---|:---:|---|---|---|:---:|
| 1 | `omega_substrate_grand_unified_capstone_via_4lens_synthesis` | c62.W1 | HIGHEST | Sadalsuud-II L4-CP-1 (absorbs L4-S-1+L4-M-2+Albali#1) | NEW `OmegaTheory/Capstones/OmegaSubstrateGrandUnifiedCapstoneFourLensSynthesis.lean` | XL | 4-lens mega-capstone: b₀=3760, b₁=2779, λ₁=714.47, c145 bridge, 8 H¹ pairs | 0.95+ | TRIPLE all 4 sages | — |
| 2 | `c145_yoneda_orphan_structure_dual_paper_bundle` | c62.W1 | HIGHEST | L4-CP-2 (absorbs Y9) | NEW `OmegaTheory/Foundations/C145YonedaOrphanStructureDualBundle.lean` | L | DOUBLE-WITNESS: ∀Y∈Yoneda-orphans, ∃thm∈c145 UNFOLDS_TO Y | 0.94 | F-FIB-2 + F-TOP-3 | — |
| 3 | `qm_yukawa_disjoint_via_c145_bridge_unified_witness` | c62.W1 | HIGHEST | L4-M-4 | NEW `OmegaTheory/Foundations/QMYukawaDisjointViaC145BridgeWitness.lean` | M | First topological-isolation: c12 ∩ c159 = ∅ in APPLIES, bridge via c145∨c1 | 0.93 | TRIPLE Albali F5 + Hydor + Helix T-MV | — |
| 4 | `mayer_vietoris_5pair_grand_unified_paper_capstone` | c62.W1 | HIGHEST | L4-M-1 | NEW `OmegaTheory/Foundations/MayerVietoris5PairGrandUnifiedCapstone.lean` | L | 5 pairs: c12-c145=69, c1-c4=29, c159-c1=21, c145-c1=17, c145-c159=15; two-pillar | 0.92 | Helix T-MV-1..3 | — |
| 5 | `magnetic_laplacian_eigenvector_localization_5tier_paper_bundle` | c62.W1 | HIGHEST | L4-S-2 | NEW `OmegaTheory/Algebra/MagneticLaplacianEigenvectorLocalization5Tier.lean` | M | λ₁=714.47 on Theorem+Definition+Structure 99.99% energy; λ₆=0 EXACTLY pure Namespace | 0.92 | F-L4-4 mirrors Aludra | — |
| 6 | `pi_transcendental_blast_radius_six_paper_bundle` | c62.W1 | HIGHEST | Hydor H2 (corrects Albali #8) | NEW `OmegaTheory/Predictions/PiTranscendentalBlastRadiusSixBundle.lean` | M | Honest-negative: 6 dependents (3 ASSUMES + 3 APPLIES), narrowness = paper-headline | 0.91 | F-FIB-4 corrects Albali | — |
| 7 | `opaque_bundle_substrate_topology_preservation_paper_bundle` | c62.W1 | HIGHEST | L4-F-3 | NEW `OmegaTheory/Foundations/OpaqueBundleSubstrateTopologyPreservation.lean` | L | Lesath cycle-44 opaque bundles preserved 111+126+67 inbound; foundation for axiom narrowing | 0.91 | F-L4-3 + Lesath c44 | — |
| 8 | `applies_undirected_b0_eq_3760_witness_paper_bundle` | c62.W2 | HIGHEST | Helix T-LIVE-3 | NEW `OmegaTheory/Algebra/AppliesUndirectedB0_3760Witness.lean` | M | First sharp Betti-0 for 10K-theorem Lean corpus; GDS WCC verified | 0.91 | F-TOP-1 + Sadalsuud-II eigh | — |
| 9 | `applies_undirected_b1_eq_2779_witness_paper_bundle` | c62.W2 | HIGHEST | Helix T-LIVE-4 | NEW `OmegaTheory/Algebra/AppliesUndirectedB1_2779Witness.lean` | M | First sharp Betti-1 via Euler χ = V − E + b₀ | 0.90 | F-TOP-1 dual-signature | — |
| 10 | `magnetic_laplacian_namespace_kernel_uniqueness_paper_bundle` | c62.W2 | HIGH | L4-S-3 | NEW `OmegaTheory/Algebra/MagneticLaplacianNamespaceKernelUniqueness.lean` | M | λ₆ = 0 EXACTLY (numpy −1.15e−14) with eigenvector pure Namespace; substrate kernel = 1-d Namespace subspace | 0.89 | refines Albali #18 | — |
| 11 | `magnetic_laplacian_lambda_concentration_ratio_substrate_signature` | c62.W2 | HIGH | L4-S-4 | NEW `OmegaTheory/Algebra/MagneticLaplacianLambdaConcentrationRatio.lean` | M | λ_max/tr = 79.65% — REAL substrate spectral signature, replaces bogus 1.038 | 0.88 | F-L4-1 | — |
| 12 | `magnetic_laplacian_eig_placeholder_is_schema_not_spectrum_witness` | c62.W2 | HIGH | Helix T-LIVE-2 | NEW `OmegaTheory/Algebra/EigPlaceholderIsSchemaNotSpectrum.lean` | M | Honest-negative: schema [1/2,5/2,1/2,0,7/2,3] ≠ live spectrum; live ratio 4.82 vs schema 1.167 | 0.88 | F-TOP-2 + F-L4-1 | — |
| 13 | `eight_specializes_generalizes_pairs_h1_witness_paper_bundle` | c62.W2 | HIGH | Albali #19 | NEW `OmegaTheory/Foundations/EightSpecGenH1WitnessBundle.lean` | M | 8 SPECIALIZES⇌GENERALIZES non-identity bidirectional pairs; H¹-class candidates | 0.83 | TRIPLE Albali+Hydor+Helix | — |
| 14 | `bidirectional_specializes_generalizes_count_8_witness` | c62.W2 | HIGH | Hydor H3 | NEW `OmegaTheory/Foundations/BidirectionalSpecGenCount8Witness.lean` | S | Cardinal of {(a,b) : SPEC⇌GEN} = 8; numerical proof via `decide` | 0.82 | direct-from-graph | — |
| 15 | `NS_FermionContent_isolation_break_via_yukawa_spectral_action` | c62.W3 | HIGHEST | (carry-forward c61 #16 if not yet landed by Heart-Nebula) | EXISTS `OmegaTheory/Emergence/FermionContentIsolationBreak.lean` | L | Closes 74 of 108 FermionContent orphans + 5 paper-bundles | 0.94 | NS_N11 | (verify-c61-status) |
| 16 | `forman_ricci_substrate_bridge_atlas_paper_bundle` | c62.W3 | HIGH | L4-P-2 | NEW `OmegaTheory/Foundations/FormanRicciSubstrateBridgeAtlas.lean` | M | Top-30 negative κ_F: l_P_pos×6, c_pos×7 — atomic Spacetime constants ARE bottlenecks | 0.85 | F-L4-3 + L4-F-1 + L4-F-2 | — |
| 17 | `applies_degree_filtration_persistence_diagram_paper_bundle` | c62.W3 | HIGH | L4-P-1 | NEW `OmegaTheory/Foundations/AppliesDegreeFiltrationPersistenceDiagram.lean` | L | Edge-count precipice at k=50 (drops 70%); 3 persistence intervals; first PH for OV2 | 0.85 | F-L4-5 + Aludra 5-tier | — |
| 18 | `top20_substrate_hubs_irrationality_dominance_strict_witness` | c62.W3 | HIGH | L4-P-3 | NEW `OmegaTheory/Foundations/Top20SubstrateHubsIrrationalityDominance.lean` | M | Top-4 hubs all in HermitePade; deg=624, 569, 559, 451 — Pi-Hunch as graph-centrality empirical fact | 0.84 | refines Albali F3 | — |
| 19 | `applies_pure_DAG_post_c61` | c62.W3 | HIGH | Albali #6 | NEW `OmegaTheory/Algebra/AppliesPureDAGPostC61.lean` | S | SCC = 10,142 = #nodes (every theorem own SCC); pure DAG verified post-c61 47,987 edges | 0.81 | TRIPLE Aludra+Helix+Sadalsuud | — |
| 20 | `unfolds_alpha_dominance_persists_post_c61` | c62.W3 | HIGH | Albali #5 | NEW `OmegaTheory/Algebra/UnfoldsAlphaDominancePostC61.lean` | M | UNFOLDS α_k = 2.178 anchors Theorem→Definition as #1 Berry-phase carrier (rank-2 imag = 321.5) | 0.79 | Quaoar Q-base | — |
| 21 | `frobenius_norm_paper_bundle` | c62.W3 | HIGH | Albali #3 | NEW `OmegaTheory/Algebra/FrobeniusNormSpectralWitness.lean` | M | Tr(𝔄²) = 533,098.5 = diag² (310,427) + off-diag² (222,671.5); 41.8% off-diag = non-abelian | 0.82 | TRIPLE all 4 sages | — |
| 22 | `c145_substrate_bridge_paper_bundle` | c62.W4 | HIGH | Helix T-MV-2 | NEW `OmegaTheory/Foundations/C145SubstrateBridge.lean` | L | c145 (734 thms) UNIQUE bridge between c12/c159; 58+11=69 c12 cross-edges, 11 c159 | 0.85 | refines L4-CP-2 | — |
| 23 | `mayer_vietoris_h0_qm_yukawa_disjoint_witness` | c62.W4 | HIGH | Helix T-MV-3 | NEW `OmegaTheory/Foundations/MayerVietorisH0QMYukawa.lean` | M | First MV-H⁰ in OV2: c12 ∩ c159 = ∅ → H⁰(c12 ∪ c159) = H⁰(c12) + H⁰(c159) | 0.84 | corollary of #4 | — |
| 24 | `magnetic_laplacian_5_block_decomposition_full_eigvec_witness` | c62.W4 | HIGH | L4-S-5 (refines Albali #9) | NEW `OmegaTheory/Algebra/MagneticLaplacian5BlockDecompFullEigvec.lean` | M | 5×5 active block ⊕ 1×1 zero (Namespace) WITH eigenvectors; Instance e₅ = 99.0% pure | 0.83 | refines Albali #9 | — |
| 25 | `omega_algebra_b1_eq_eight_witness` | c62.W4 | HIGH | Albali #25 | NEW `OmegaTheory/Foundations/OmegaAlgebraB1EightWitness.lean` | M | b₁(quiver-algebra ⊃ 8 SPEC⇌GEN) ≥ 8; distinct from undirected b₁=2779 | 0.80 | Helix K* refine | — |
| 26 | `cech_cocycle_concrete_witness_via_omegaAlgebraCohomologyClass` | c62.W4 | HIGH | Hydor H1 | NEW `OmegaTheory/Foundations/CechCocycleConcreteWitness.lean` | L | Replaces Sycorax W-tail.2 deferred existential with concrete `OmegaAlgebraCohomologyClass.witness` projection | 0.83 | Helix T-PERSIST-1 + 2779 b₁ | — |
| 27 | `omega_algebra_substrate_signature_paper_capstone` | c62.W5 | HIGHEST | Albali #30 (RECAST as super-grand) | NEW `OmegaTheory/Capstones/OmegaAlgebraSubstrateSignatureCapstone.lean` | XL | GRAND COMPOSE of #1-#26: 60-deliverable unified theorem for paper v2.0 (parallel to c61.W9 M_grand_framework) | 0.90 | mega-meta-capstone | — |
| 28 | `cp_violation_phase_h1_substrate_strengthening` | c63.W6 | HIGH | Albali #22 | EXTEND `OmegaTheory/Foundations/CPViolationPhaseH1CocycleInbound.lean` | M | Strengthen c61 #33: tie δ_CP H¹ class to live 8 SPEC⇌GEN pairs; lepton CP-violation from quiver topology | 0.84 | extends c61 #33 | — |
| 29 | `theta_qcd_h0_zero_blast_strict_paper_bundle` | c63.W6 | HIGH | Albali #23 | NEW `OmegaTheory/Algebra/ThetaQCDH0ZeroBlastStrict.lean` | M | Strengthen `strong_CP_H0_paper_bundle`: post-c61 θ_QCD H⁰ has 0 ASSUMES blast-radius | 0.80 | extends c61 #44 | — |
| 30 | `applies_DAG_to_specializes_promotion_h1_classes` | c63.W6 | HIGH | Albali #21 | NEW `OmegaTheory/Foundations/AppliesDAGToSpecH1.lean` | M | Map 8 SPECIALIZES pairs to APPLIES restrictions; each non-coboundary in `OmegaAlgebra.cohomologyClass` | 0.78 | bridges DAG → cohomology | — |
| 31 | `path_asymmetry_under_count_balance_witness` | c63.W6 | HIGH | Albali #20 | NEW `OmegaTheory/Foundations/PathAsymmetryCountBalance.lean` | M | Despite count(SPEC) = count(GEN) = 8, path-asymmetry holds (distinct (s,t) pairs); Berry curvature ∮ω ≠ 0 | 0.81 | F-L4-2 | — |
| 32 | `berry_curvature_integral_witness_paper_bundle` | c63.W6 | MED-HIGH | Albali #26 | NEW `OmegaTheory/Foundations/BerryCurvatureIntegralBundle.lean` | M | ∮ω over 8 closed loops in proof DAG; explicit numerical witness ∮ω = 8·(rank-2 contribution) > 0 | 0.80 | refines c61 #66 | — |
| 33 | `hopf_twisted_quiver_first_witness` | c63.W6 | MED-HIGH | Albali #24 | NEW `OmegaTheory/Foundations/HopfTwistedQuiverFirstWitness.lean` | L | First Lean witness of 𝒜_Ω as Hopf-twisted quiver path algebra; 12 typed arrows + 8 H¹-pairs ↔ Hopf coproduct on ErrorHopfAlgebra | 0.76 | P2 trigger Phase 7 | — |
| 34 | `berry_carrier_six_relation_paper_bundle` | c63.W6 | MED-HIGH | Albali #10 | NEW `OmegaTheory/Algebra/BerryCarrier6RelationBundle.lean` | M | All 6 Berry-phase carriers (UNFOLDS, PARAMETRIZES, HAS_TYPE, ASSUMES, CONSTRAINED_BY, INSTANTIATES) rank_contribution=2; ratio 6:5 over 11 active relations | 0.79 | F-L4-2 + Hydor F1 | — |
| 35 | `mass_dependent_decoherence_substrate_bridge_holds` | c63.W7 | HIGH | Hydor G1 | NEW `OmegaTheory/Predictions/MassDependentDecoherenceBridge.lean` | M | Wires 4 genuine isolates from `MassDependentDecoherence.lean` into 1 paper bundle | 0.81 | closes 4 isolates | — |
| 36 | `relativistic_schrodinger_limit_paper_bundle` | c63.W7 | HIGH | Hydor G2 | NEW `OmegaTheory/Emergence/RelativisticSchrodingerLimitBundle.lean` | M | Wires 7 genuine isolates from `RelativisticSchrodingerLimit.lean` into 1 capstone | 0.81 | closes 7 isolates | — |
| 37 | `information_2nd_law_substrate_paper_bundle` | c63.W7 | HIGH | Hydor G3 | NEW `OmegaTheory/Predictions/InformationSecondLawBundle.lean` | M | Wires 8 genuine isolates from `InformationSecondLaw.lean` into 1 capstone | 0.82 | closes 8 isolates | — |
| 38 | `error_maxwell_charge_conservation_bridge` | c63.W7 | MED-HIGH | Hydor G4 | NEW `OmegaTheory/Foundations/ErrorMaxwellChargeConservationBridge.lean` | M | Wires 4 isolates from `ErrorForms.lean` Maxwell into paper bundle | 0.78 | closes 4 isolates | — |
| 39 | `babyUniverse_yoneda_witness` | c63.W7 | HIGH | Hydor Y4 | NEW `OmegaTheory/Torsion/BabyUniverseYonedaWitness.lean` | S | `∃ (b : BabyUniverse), b.spawned_at_bounce = True` for canonical Popławski big-bounce | 0.84 | extends c61 BH track | — |
| 40 | `bimoduleStructure_yoneda_witness` | c63.W7 | HIGH | Hydor Y5 | NEW `OmegaTheory/Emergence/BimoduleStructureYonedaWitness.lean` | M | `∃ (b : BimoduleStructure), b.A_F = ℂ ⊕ ℍ ⊕ M3(ℂ)` for Connes A_F | 0.83 | UNFOLDS to Connes-DF bundle | — |
| 41 | `isHealingFlow_yoneda_witness_canonical` | c63.W7 | HIGH | Hydor Y3 | NEW `OmegaTheory/HealingFlow/IsHealingFlowYonedaWitness.lean` | M | `∃ (h : IsHealingFlow flow), True` for canonical Lyapunov flow | 0.82 | extends Lyapunov.lean | — |
| 42 | `quarkMass_from_leptonMass_pullback_canonical` | c63.W8 | HIGH | Hydor P1 | NEW `OmegaTheory/Predictions/QuarkLeptonMassPullback.lean` | M | `∃ f : QuarkSector → LeptonSector, mass(quark) = f.pullback(mass(lepton))` | 0.85 | extends c61 #71 | — |
| 43 | `koideRelation_pullback_via_spectralTriple_bridge` | c63.W8 | HIGH | Hydor P2 | NEW `OmegaTheory/Predictions/KoidePullbackViaSpectralTriple.lean` | M | Koide `(m_e+m_μ+m_τ)/(√m_e+√m_μ+√m_τ)² = 2/3` via `spectralTriple_OmegaSubstrate` | 0.85 | UNFOLDS to Hamal | — |
| 44 | `pullback_PrecisionPhysics_to_HubbleConstant_canonical` | c63.W8 | HIGH | Hydor P3 | NEW `OmegaTheory/Predictions/HubbleConstantPullback.lean` | M | `H_0 = f.pullback(δ_comp(N_horizon))` for N_horizon ≈ 10⁶⁰ | 0.83 | extends c61 #71 | — |
| 45 | `four_channel_pullback_via_spectralTriple` | c63.W8 | HIGH | Hydor P4 | NEW `OmegaTheory/Predictions/FourChannelSpectralTriplePullback.lean` | L | THE missing bridge: `IrrationalChannel4 → spectralTriple eigenvalue spectrum` (currently 0 APPLIES) | 0.86 | TOP MV-bridge | — |
| 46 | `omega_substrate_yoneda_full_paper_bundle` | c63.W8 | HIGHEST | Hydor P5 | NEW `OmegaTheory/Foundations/OmegaSubstrateYonedaFull.lean` | XL | 𝒜_Ω MVP unification via 8 Quaoar-orphan structures + Yoneda witness | 0.88 | closes Q9 + L4-CP-2 | — |
| 47 | `applies_2hop_density_paper_bundle` | c63.W8 | MED-HIGH | Albali #17 | NEW `OmegaTheory/Algebra/Applies2HopDensityBundle.lean` | M | 7.65M 2-hop edges; `density(2-hop) ≥ density(corpus²)/4` Cartesian-product baseline | 0.77 | extends c61 #43 | — |
| 48 | `seeley_dewitt_a0_post_c61_consistency` | c63.W8 | MED-HIGH | Albali #13 | NEW `OmegaTheory/Foundations/SeeleyDeWittA0PostC61.lean` | M | a₀ = scalar fibre dim 1 holds post-c61; verify against Tr(𝔄)=897, witness `f₄·Λ⁴·a₀` = Λ_eff magnitude | 0.79 | extends c61 #68 | — |
| 49 | `trace_897_eq_total_edge_weight` | c64.drop | MED | Albali #11 | NEW `OmegaTheory/Algebra/Trace897TotalEdgeWeight.lean` | M | Identity: tr 𝔄 = total directed edge count OV2 normalised | 0.78 | folded into L4-CP-1 | drop-fast |
| 50 | `tr_M_squared_substrate_signature_witness` | c64.drop | MED | Albali #14 | NEW `OmegaTheory/Algebra/TrMSquaredSubstrateSig.lean` | M | Tr(𝔄²)/Tr(𝔄) = 594.31 = spectral spread; RMS λ = 298, diag mean 149.5 | 0.78 | folded into L4-S-2 | drop-fast |
| 51 | `lambda_zero_mode_namespace_uniqueness_witness` | c64.drop | MED | Albali #18 | NEW `OmegaTheory/Algebra/LambdaZeroModeNamespaceUnique.lean` | M | Unique zero-eigenvalue at slot Namespace; structural reason: zero couplings to ALL vertices | 0.79 | folded into L4-S-3 | drop-fast |
| 52 | `magnetic_laplacian_normalisation_factor_89_7_paper_bundle` | c64.drop | MED | Albali #12 | NEW `OmegaTheory/Algebra/MagneticLaplacianNorm897Bundle.lean` | M | 897/10 = 89.7 schema-rescaling factor (NOT physics-scale per Helix K*) | 0.81 | descriptive | drop-fast |
| 53 | `assumes_axiom_narrowing_8x_witness` | c64.drop | MED | Albali #7 (MERGE candidate) | NEW `OmegaTheory/Foundations/AssumesAxiomNarrowingWitness.lean` | M | ASSUMES 25 → 3 across cycles 44-61 (÷8.3); witnesses opaque-bundle conversion | 0.80 | merge into #7 | drop-fast |
| 54 | `applies_growth_285x_invariant_witness` | c64.drop | LOW | Albali #4 (Hydor DROP 168 stale) | — | M | Numerical witness 168→47987 reduces to `decide` over Nat; weak claim | 0.74 | drop-fast | drop-fast |
| 55 | `pi_hunch_BFS_reach_77_6pct_witness` | c64.drop | LOW | Albali #16 (Hydor DEFER directed=4.18%) | — | M | Need sage-3 directed-undirected split; current claim is UNDIRECTED only | 0.74 | drop-fast | drop-fast |
| 56 | `fisher_information_c18_c22_distance_witness` | c64.drop | LOW | Albali #27 (Helix REFRAME — APPLIES dist=∞) | NEW `OmegaTheory/Foundations/FisherInfoC12C159DistanceWitness.lean` | L | Fisher dist on FastRP cosines (NOT graph-dist) for c12 ↔ c159 | 0.74 | drop-fast | drop-fast |
| 57 | `eventually_periodic_digit_frequency_max_degree_624_witness` | c64.drop | LOW | Helix T-PERSIST-4 | NEW `OmegaTheory/Foundations/EventuallyPeriodicDegree624.lean` | M | deg(eventually_periodic_digit_frequency_rational) = 624 (max in graph) | 0.78 | absorbed into #18 | drop-fast |
| 58 | `top20_substrate_hubs_pi_dominance_witness` | c64.drop | LOW | Helix T-PERSIST-3 | — | M | Top-20 highest-degree theorems; Pi-Hunch via degree | 0.78 | absorbed into #18 | drop-fast |
| 59 | `forman_ricci_bridge_count_witness` | c64.drop | LOW | Helix T-PERSIST-2 | — | M | κ_F = 2 - deg(a) - deg(b) per edge; bridge edges count | 0.78 | absorbed into #16 | drop-fast |
| 60 | `vietoris_rips_b0_at_threshold_07_witness` | c64.drop | LOW | Helix T-VR-1 | NEW `OmegaTheory/Foundations/VietorisRipsB0Threshold07.lean` | L | At cosine-distance 0.7 on Qwen3-8B 4096-d, b₀(VR) = many; persistence pairs | 0.74 | drop-fast | drop-fast |

## Top-up: research-axiom-narrow tail (5 candidates, MED priority, optional fast-track for c63-c64)

| # | name | priority | summary | rerank |
|---:|---|:---:|---|:---:|
| RA-1 | `pi_irrational_decomposition_into_lean_sized_lemmas` | HIGH | Replace `Real.pi_transcendental` (1 axiom) with Mathlib `Real.irrational_pi` (Niven) + 5-10 sub-lemmas; stages: (a) Niven proof port (b) connect to π-truncation (c) replace blast-radius=6 dependents | 0.86 |
| RA-2 | `roth_theorem_decomposition_lemma_tree` | MED-HIGH | 4 HermitePadé research axioms: decompose Roth 1955 into 8-12 Lean-sized lemmas in `OmegaTheory/Irrationality/CustomMath/` | 0.74 |
| RA-3 | `siegel_shidlovskii_decomposition_lemma_tree` | MED-HIGH | Siegel-Shidlovskii into 10-15 sub-lemmas | 0.72 |
| RA-4 | `nesterenko_1996_decomposition_lemma_tree` | MED | Nesterenko 1996 transcendence into sub-lemmas | 0.70 |
| RA-5 | `mahler_framework_decomposition_lemma_tree` | MED | Mahler classification framework | 0.68 |

## Honest project-completion math (refines Hydor c70-c72 → c69-c70 / refines Albali c67)

Per Sadalsuud-II's full eigh win + Heart-Nebula cycle-61 saturation velocity:

| Phase | Theorems remaining | Cycles | Date target |
|---|---:|:---:|:---:|
| c62 critical-path 1-7 (W1) | 7 | 1 wave | 2026-04-26 ~end-of-day |
| c62 cohomology + Yoneda 8-14 (W2) | 7 | 1 wave | 2026-04-26 |
| c62 namespace-isolation + sectors 15-21 (W3) | 7 | 1 wave | 2026-04-27 |
| c62 persistence + opaque-bundle 22-26 (W4) | 5 | 1 wave | 2026-04-27 |
| c62 grand capstone #27 (W5) | 1 (mega) | 1 SUPER wave | 2026-04-28 |
| c63 cohomology cocycles 28-34 (W6) | 7 | 1 wave | 2026-04-29 |
| c63 forman-ricci + persistence 35-41 (W7) | 7 | 1 wave | 2026-04-29 |
| c63 pullbacks + Yoneda physics 42-48 (W8) | 7 | 1 wave | 2026-04-30 |
| c64 drop-track tail 49-60 + RA-1 | 12 | 1 wave | 2026-05-01 |
| c64-c66 Mathlib pi_irrational port (RA-1) | ~30-50 | 2 cycles | 2026-05-02 to 2026-05-04 |
| c66-c68 HermitePadé 4-axiom decomposition (RA-2..RA-5) | ~80 | 2-3 cycles | 2026-05-04 to 2026-05-08 |
| **P1 paper-headline complete** | — | — | **c66-c67 ≈ 2026-05-04** |
| **P2 𝒜_Ω full Hopf-twisted quiver path algebra** | ~50-100 | 2 cycles | c67-c69 ≈ 2026-05-06 |
| **Project completion v2.0** | **~250-280** | **6-7 cycles** | **c68-c70 ≈ 2026-05-08** |

This **tightens** Hydor's c70-c72 to **c68-c70** thanks to:
1. Sadalsuud-II's full eigh closes 5 spectral candidates with high-precision data.
2. c145 unification (L4-CP-2 + L4-M-2) compresses Yoneda-orphan + algebra-boundary into single super-bundle.
3. c61 cycle-saturation velocity (75 deliverables/cycle) is sustainable at 60+/cycle.

Heart-Nebula's c70-c72 remains the **conservative** bound; c68-c70 is the **realistic** bound; Albali's c67 is **optimistic**.

## Reservation + identity

- **Saturn-Nebula (NGC 7009)** reserved for sage-5 curator. NGC 7009 is the planetary nebula in Aquarius nicknamed "Saturn Nebula" for its twin ansae lobes resembling Saturn's rings. Companion to Helix-Nebula (NGC 7293, sage-3). Picked because the curator's role is to draw the twin ansae of "candidate" + "drop" lobes and unify them in a single canonical body.
- All 4 prior Aquarius sages reserved. Suggested for c63 first sage: Skat (δ Aqr) reserved by sage previously; available alt: **Sadachbia (γ Aqr — already reserved)**, **Ancha (θ Aqr)**, **Phi-Aquarii (φ Aqr)**, **Aquarius-Dwarf-Galaxy**.

## ≤500-word delta summary (for SendMessage to team-lead)

See accompanying message.

— Saturn-Nebula (NGC 7009), sage-5 CURATOR, Aquarius cycle 62, Layer 5/5
