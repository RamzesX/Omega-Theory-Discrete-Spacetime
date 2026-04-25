# Cycle-59 (Scorpius) Phase A — Antares batch index

**Sage:** Antares (grothendieck-sage; α Scorpii — red supergiant heart of Scorpius, ~600 ly, R~700 R☉)
**Cycle:** 59 · **Zodiac:** Scorpius · **Date:** 2026-04-25 (evening)
**Build pre-fire:** 4,011 jobs GREEN · 0 sorry · 1 paper-headline axiom (`Real.pi_transcendental`, Path-A retirement c60-c62)
**Graph:** 10,142 OV2 + 175,137 Mathlib · 7.65M edges · post-c58 refresh `refresh_graph-f3d804a0` clean (missing_emb=0)
**Batch id (Neo4j):** `scorpius_antares_cycle59_topology_fire_2026-04-25`

---

## Phase A protocol (binding)

This is Phase A under the locked 5-step pattern (CLAUDE.md §2): graph refreshed
end of cycle 58, sage TOPOLOGY analysis NOW, 20 briefings, parallel wizard waves
in Phase B. Phase B servers OFF, Phase A+C servers ON. No B/A overlap.

## Staleness audit (free wins, 14 candidates flipped to CLOSED_BY_LEAN_LANDING)

| Pre-status | Candidate | Landed at |
|---|---|---|
| PROPOSED | `CKM_three_angles_numerical_PDG_simultaneous` | `OmegaTheory/Predictions/CKMAllThreeAnglesPDGSimultaneous.lean` |
| PROPOSED | `PMNS_three_angles_numerical_PDG_simultaneous` | `OmegaTheory/Predictions/PMNSAllThreeAnglesPDGSimultaneous.lean` |
| PROPOSED | `kaon_mass_chiral_GMOR_substrate` | `OmegaTheory/Predictions/KaonMassChiralGMOR.lean` |
| PROPOSED | `top_quark_mass_absolute_yukawa_one_substrate` | `OmegaTheory/Predictions/TopYukawaUnityAbsolute.lean` |
| PROPOSED | `alphaEM_substrate_at_MZ_one_loop_consistent` | `OmegaTheory/Predictions/AlphaEMRunningOneLoop.lean` |
| PROPOSED | `alphaS_at_MZ_substrate_value_within_PDG` | `OmegaTheory/Predictions/AlphaSAtMZAbsolute.lean` |
| PROPOSED | `higgs_mass_125GeV_from_lambda_quartic_substrate` | `OmegaTheory/Predictions/HiggsMassAbsolute125.lean` |
| PROPOSED | `jarlskog_J_CKM_numerical_3sigma_PDG` | `OmegaTheory/Predictions/JarlskogJCKMAbsolute3Sigma.lean` |
| PROPOSED | `m_n_minus_m_p_minus_m_e_substrate_triple_identity` | `OmegaTheory/Predictions/NeutronProtonElectronTripleIdentity.lean` |
| PROPOSED | `neutrino_delta_m_squared_from_4th_irrational_substrate` | `OmegaTheory/Predictions/NeutrinoMassDifferencesFromIrrationals.lean` |
| PROPOSED | `pion_mass_from_chiral_substrate_GMOR` | `OmegaTheory/Predictions/PionMassChiralGMOR.lean` |
| PROPOSED | `omega_algebra_unification_law_for_15_arrows` | `OmegaTheory/Algebra/QuiverArrowIdentities.lean` (untracked, 373 lines) |
| PROPOSED | `nesterenko_1996_decompose_to_lean_sized_sublemmas` | `OmegaTheory/Irrationality/HermitePade/NesterenkoSubLemmas.lean` (untracked, 370 lines) |
| PROPOSED | `siegel_shidlovskii_decompose_to_lean_sized_sublemmas` | `OmegaTheory/Irrationality/HermitePade/SiegelShidlovskiiSubLemmas.lean` (untracked, 426 lines) |

Remaining PROPOSED post-audit: 5 (4 from cycle-53 zubeneschamali genuinely
unfired + 0 from cycle 57/58). Phase B fires fresh briefings on top.

## Topology gap detection findings (5 axes, post-c58 graph snapshot)

1. **PoincareLemma orphans GREW post-Whirlpool** — graph still shows **78
   isolated** post-c58 refresh (Whirlpool wired 25 in c58 but new theorems were
   added by capstone, so net orphan count remained high). Still the largest
   compose-into-capstone target on the geometry side.
2. **Spacetime/Operators is biggest orphan cluster: 151 isolated theorems** —
   cycle-57 W15 was never fired (Cygnus-X1's plan stalled at 7 of 20). Largest
   single Track-3 lever.
3. **YukawaMatrix has 44 isolated theorems** — and Connes D_F → absolute mass is
   the biggest precision lever. The chain is `YukawaMatrix.eigenvalues →
   ConnesDFYukawaMass.mass_ratio_e_mu → MassRatioPrecisionBridge.electron_mass_eq_bound_absolute_MeV_within_PDG`.
   Wiring YukawaMatrix orphans into the precision bridge is the **highest-leverage
   single Track-1 fire**.
4. **Per-file orphan top-12 in Predictions/** (>20 orphans each, all candidates
   for capstone wiring):
   ProtonDecayLowerBound (40) · NeutrinoLessDoubleBetaBound (32) ·
   HubbleTensionFromSubstrateDEGain (32) · PrecisionPhysicsAbsoluteWaveP2 (30) ·
   NewtonConstantFit (29) · Lithium7AbundanceFromSubstrateBBN (28) ·
   AdditionalPredictions (27) · ElectronEDMBound (27) · QuarkMassRatioNumerical (26) ·
   GWPolarizationModes (26) · GravitonEnsembleBoundLIGO (26) · StochasticTeleportation (25).
5. **Mathlib `Lindemann.AnalyticalPart` is present and verified** — Yuyang Zhao
   2022's `exp_polynomial_approx` reachable, used by Sedna's Wave-1 skeleton in
   `Irrationality/CustomMath/LindemannBasic.lean`. Mathlib v4.29.0 does NOT
   ship the full transcendental-pi corollary (Galois-conjugation step) —
   that's the W11/W12 gap to fill manually over cycles 60-62.

---

## 20 wizard briefings (8 T1 / 6 T2 / 1 T3-mandated + 5 T3-orphan)

### Track-1 — physics precision (8)

| # | Wave | Wizard ID | Candidate | Target file | Complexity |
|---|---|---|---|---|---|
| W1 | 1 | T1-yukawa-precision | `yukawa_orphan_audit_compose_into_mass_precision_bridge` | `OmegaTheory/Emergence/YukawaMatrixPrecisionBundleCapstone.lean` (NEW) | M |
| W2 | 1 | T1-quarkbeta-bridge | `quark_beta_from_connesD_F_orphan_compose_capstone` | `OmegaTheory/Predictions/QuarkBetaConnesD_FCapstone.lean` (NEW) | M |
| W3 | 1 | T1-tau-mass-bridge | `tau_lepton_mass_substrate_paper_bundle` | `OmegaTheory/Predictions/TauLeptonMassPaperBundle.lean` (NEW) | M |
| W4 | 2 | T1-hubble-precision | `hubble_constant_67_4_paper_bundle_within_PDG` | `OmegaTheory/Predictions/HubbleConstantPaperBundle.lean` (NEW) | M |
| W5 | 2 | T1-cmb-anisot-bundle | `cmb_DeltaT_T_substrate_paper_bundle` | `OmegaTheory/Predictions/CMBAnisotropyPaperBundle.lean` (NEW) | M |
| W6 | 2 | T1-bbn-helium-Yp | `BBN_Yp_helium4_substrate_paper_bundle` | `OmegaTheory/Predictions/BBNHelium4PaperBundle.lean` (NEW) | M |
| W7 | 2 | T1-eta-B-bary | `baryogenesis_eta_B_paper_bundle_window` | `OmegaTheory/Predictions/BaryogenesisEtaBPaperBundle.lean` (NEW) | M |
| W8 | 2 | T1-fine-struct-zero | `fine_structure_alpha_zero_paper_bundle` | `OmegaTheory/Predictions/FineStructureAlphaZeroPaperBundle.lean` (NEW) | M |

### Track-2 — axiom elimination (6)

| # | Wave | Wizard ID | Candidate | Target file | Complexity |
|---|---|---|---|---|---|
| W9 | 1 | T2-pi-stratum-D4 | `pi_stratum_degree_four_decoupling` | `OmegaTheory/IrrationalityClasses/PiStratumDegreeFour.lean` (NEW) | M |
| W10 | 1 | T2-LindemannCD-bridge | `pi_transcendental_layer_CD_corollary_skeleton` | `OmegaTheory/Irrationality/HermitePade/PiTranscendentalLayerCD.lean` (NEW) | L |
| W11 | 2 | T2-galois-conj-step | `lindemann_galois_conjugation_step_skeleton` | `OmegaTheory/Irrationality/CustomMath/LindemannGaloisConjugation.lean` (NEW) | L |
| W12 | 2 | T2-pi-niven-irr-only | `pi_irrational_only_via_niven_re_export_layer` | `OmegaTheory/Irrationality/CustomMath/PiIrrationalNivenLayer.lean` (NEW) | S |
| W13 | 2 | T2-icthree-narrow | `ic_three_constants_narrowed_to_two_axiom_dependencies` | `OmegaTheory/IrrationalityClasses/ICThreeConstantsAxiomNarrowed.lean` (NEW) | S |
| W14 | 2 | T2-pi-blast-radius | `pi_transcendental_blast_radius_audit_dump_csv` | `OmegaTheory/Irrationality/HermitePade/PiTranscendentalBlastRadiusAudit.lean` (NEW) | M |

### Track-3 — research/infra/topology meta (1 mandated + 5 orphan)

| # | Wave | Wizard ID | Candidate | Target file | Complexity |
|---|---|---|---|---|---|
| W15 | 1 | **T3-dump-arrows-perf** (USER-MANDATED) | `dump_arrows_perf_optimization_mathlib_cache_plus_task_spawn` | `OmegaTheory/Meta/DumpArrows.lean` + `omega_orchestrator/pipeline.py` | L |
| W16 | 1 | T3-spacetime-ops-cap | `spacetime_operators_orphan_compose_into_capstone` | `OmegaTheory/Spacetime/OperatorsCapstoneIndex.lean` (NEW) | L |
| W17 | 2 | T3-poincare-cap-2 | `poincare_lemma_orphan_capstone_wave_2_residual` | `OmegaTheory/Geometry/PoincareLemmaCapstoneResidual.lean` (NEW) | M |
| W18 | 2 | T3-yukawa-orphan-fix | `yukawa_orphan_compose_into_FermionContent_calc_capstone` | `OmegaTheory/Emergence/YukawaCalculationCapstone.lean` (NEW) | M |
| W19 | 2 | T3-redshift-cap | `redshift_orphan_compose_into_redshift_capstone` | `OmegaTheory/Emergence/RedshiftOrphansCapstone.lean` (NEW) | M |
| W20 | 2 | T3-protondecay-cap | `proton_decay_orphan_compose_into_capstone` | `OmegaTheory/Predictions/ProtonDecayOrphansCapstone.lean` (NEW) | M |

---

## Per-briefing template

Each per-wizard `.md` follows the locked template (see CLAUDE.md §3):

1. Candidate name & graph node
2. Priority + complexity
3. Target file (NEW)
4. `statement_lean` skeleton (signature only, wizard fills proof)
5. Premise candidates (top-5 from omega-search)
6. Proof sketch (≤6 bullets)
7. Off-limits files (binding) — ALL cycle 52-58 wizard-owned files (see explicit list per brief)
8. Build expectation — `lake build` GREEN, 0 sorry, axiom 1 unchanged
9. Graph register Cypher

---

## Off-limits files (cumulative through cycle 58 — read-only by all c59 wizards)

**Cycle 58 (Libra, just landed):**
- `OmegaTheory/Geometry/PoincareLemmaCapstone.lean` (Whirlpool)
- `OmegaTheory/Predictions/HiggsSelfCouplingAbsolute.lean` (Kepler-22b)
- `OmegaTheory/Predictions/SterileNeutrinoMassAbsolute.lean` (Hyakutake)
- `OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean` (Sedna)
- `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` (Vesta — edited)
- `OmegaTheory/IrrationalityClasses/Wave4LandingsHeadline.lean` (Hyades)
- `PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md` (Pleiades)

**Cycle 57 (Virgo):** All 7 cycle-57 landed files (see `CYCLE57_BATCH_INDEX_2026-04-25.md` for the list). Notable: `OmegaTheory/Irrationality/HermitePade/PiTranscendentalLayerB.lean` (Ganymede).

**Cycle 56 (Leo) and earlier:** ALL files in `OmegaTheory/Irrationality/HermitePade/` (sealed by Maia/Ganymede/etc.) except W10/W11/W12 NEW files; `OmegaTheory/Irrationality/CustomMath/` Galois subdir (cycle 56 Maia).

**`OmegaTheory/Basic.lean` is parent-only** (all wizards flag import additions
in their final report; parent batches them post-Phase-B).

---

## Wave dispatch recommendation (parallel)

**Wave 1 (parallel, 6 wizards on disjoint files):**
W1 (yukawa-precision) · W2 (quarkbeta-bridge) · W9 (pi-stratum-D4) ·
W10 (LindemannCD-bridge) · W15 (dump-arrows-perf) · W16 (spacetime-ops-cap)

**Wave 2 (parallel, 7 wizards after Wave 1 lands + Phase C refresh):**
W3 (tau-mass-bridge) · W4 (hubble-precision) · W7 (eta-B-bary) ·
W8 (fine-struct-zero) · W11 (galois-conj-step) · W12 (pi-niven-irr-only) ·
W13 (icthree-narrow)

**Wave 3 (parallel, 7 wizards after Wave 2 lands):**
W5 (cmb-anisot-bundle) · W6 (bbn-helium-Yp) · W14 (pi-blast-radius) ·
W17 (poincare-cap-2) · W18 (yukawa-orphan-fix) · W19 (redshift-cap) ·
W20 (protondecay-cap)

**Stretch goal pattern (per wizard):** if PRIMARY target lands cleanly with
≥40% time/context remaining, pick ONE of the unfired briefings from a later
wave (NEVER from a sister wizard's primary file).

**Verdict on Track-3 dump_arrows perf wizard placement:** **WAVE 1**.
Reason: Phase C of cycle 58 took 21 minutes (76% on dump_arrows). If W15 lands
in Wave 1, Phase C of cycle 59 closes ~20 min faster, and every subsequent
cycle saves 15 minutes per refresh. **Highest infra ROI of the batch.**

---

## Briefing files (next page)

20 files in `plans/SAGE_BRIEFING_<wizard-id>_2026-04-25.md`. See per-file
content in this directory. All registered as `:TheoremCandidate {batch_id:
'scorpius_antares_cycle59_topology_fire_2026-04-25', status: 'PROPOSED'}`.
