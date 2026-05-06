# OmegaTheory V2 — Trash Audit Round 2 (post 2026-05-05 purge)

**Date**: 2026-05-06
**Author**: Lion's-Pride dynamic /loop iter 160 — 4-agent opus-code-crawler parallel audit
**Scope**: ALL OmegaTheory subdirectories at `/home/norbert/lean-v2/OmegaTheory/`
**Total residual trash**: **~290 files / ~80,000 LOC** (comparable in size to the 117K LOC purged 2026-05-05)
**Status**: AUDIT COMPLETE — awaiting user calibration before purge commit

---

## Executive summary

| Bucket | Files | LOC | Pattern |
|---|---:|---:|---|
| **Predictions/** | 205 | ~52,000 | T1_*Frontier PDG numerology + *Fit.lean calibration tautologies + *PaperBundle re-exports + Yoneda mass-batch capstones + graph-cosmetic bridges (some with `: Prop := True` BOOK_VII direct violations) |
| **Foundations/** | 35 | ~9,800 | Cycle 61-62-63 *YonedaDoubleWitness, *CategoricalYonedaWitness, *MayerVietoris*Capstone, *IsolationBreak, *PaperBundleInbound mass-batches |
| **Emergence/** | 25 | ~9,200 | DarkEnergyLocalityEvent (Prop:=True), YonedaOrphanMassBridgeWave[A] mass-batches, Capstone*Inbound towers, redundant capstones (e.g. QmBridgePaperCapstone redundant with QuantumMechanicsCapstone) |
| **Irrationality/** | 12 defs (NO full files) | ~360 | 12 `Prop := True` `_pending` scaffolds in cycle-59 Hydra Lindemann-Galois skeleton — walled off, parallel-vestigial after T-4 retirement via Hermite-Padé chain |
| **Capstones/** | 11 of 13 | ~3,300 | Duplicate T-4 retirement chain (cycle 64) — `Capstones/` is a self-island, only `PiTranscendenceAxiomRetirementFinal.lean` (9 ext inbound) is canonical |
| **Spacetime/Tensor/Geometry/Defects/Conservation/HealingFlow/Probe/IrrationalityClasses** | 15 | ~5,100 | OperatorsCapstone[Index/Residual] orphan-redundancy cascade, *IsolationBreak.lean True∧True conjunctions, Probe/StressTest obsolete files, Wave4Landings.lean::IsMahlerSClass Prop:=True |

**Grand total: ~290 files / ~80,000 LOC trash, ~50% of remaining repo by file-count, ~46% by LOC.**

---

## Critical preservation rule

**The REAL π-transcendence work in `Irrationality/HermitePade/` MUST be preserved.** This includes:

- `Irrationality/HermitePade/Decoupling.lean` — the actual `Real.pi_transcendental` theorem (T-4 retirement, 2026-04-27)
- `Irrationality/HermitePade/PiTranscendentalSeed.lean` — Lindemann-Weierstrass core
- `Irrationality/HermitePade/Layers/*` — the 14-file hand-authored chain that closes Real.pi_transcendental
- `Capstones/PiTranscendenceAxiomRetirementFinal.lean` — the canonical axiom-retirement statement (9 ext inbound) — RENAME and move to `Irrationality/HermitePade/PiTranscendenceFinal.lean`, do NOT delete

Only the **redundant duplicates** in `Capstones/` are flagged for deletion. The mathematical content (the actual transcendence proof) lives in `Irrationality/HermitePade/` and will not be touched.

---

## Bucket A — Predictions/ (205 DELETE / 4 REWIRE / ~52,000 LOC)

### A.1 — `T1_*Frontier.lean` PDG citation files (117 files / ~27,600 LOC)

Pattern: `noncomputable def X_PDG := lit/lit` followed by `theorem X_pos : 0 < X := norm_num`. NO substrate derivation. Pure experimental anchor.

**EXCEPTIONS to keep** within T1_*:
- `T1_LambdaQCDFromAlphaS1Loop.lean`
- `T1_LambdaQCDDeepDecayBound.lean`
- `T1_LambdaQCDTighterDecayBound.lean`
- `T1_Step2_LambdaQCDFromAlphaS_Complete.lean`
- `T1_SubstrateMassHierarchy/Positivity/Values/QuarkRatios/RunningChainConditional.lean`
- `T1_YukawaQuarkValues.lean`
- `T1_ConstituentQuarkBridgeNarrower.lean`
- `T1_CrossChainGen0Equality.lean`
- `T1_AlphaEMMzRunningFrontier.lean` (borderline — keep since ties to substrate alpha_em)

DELETE list (representative, full list ~117 files):
- T1_BKstarP5primeFrontier, T1_BMesonRDStarFrontier, T1_HVPLatticeVsEEFrontier
- T1_NA62KaonRareDecayFrontier, T1_PSRJ0740MaxNSMassFrontier, T1_PentaquarkLHCbFrontier
- T1_RKAnomalyLFUFrontier, T1_StrongCPProblemFrontier, T1_X17AtomkiFrontier
- T1_LIGOGW150914BBHFrontier, T1_DESI_BAO_QuintessenceFrontier, T1_DUNEHyperKProjectionsFrontier
- ...and ~105 more

### A.2 — `*Fit.lean` calibration tautologies (~70 files / ~13,800 LOC)

Pattern: `def calibration := PDG_value / substrate_quantity`, then theorem `calibration · substrate = PDG_value` proved by `div_mul_cancel₀`. Plus `|substrate − PDG| < ε` with ε ≥ 1σ chosen for triviality.

DELETE list:
- HubbleConstantFit, ZBosonMassFit, WBosonMassCDFIIFit, WBosonWidthFit
- CharmQuarkMassFit, BottomQuarkMassFit, UpQuarkMassFit, DownQuarkMassFit
- StrangeQuarkMassFit, TopQuarkMassFit, NeutronLifetimeFit, KaonMassFit
- PionMassFit, PionDecayConstantFit, GUTUnificationScaleFit
- ScalarSpectralIndexFit, BaryonDensityFit, BaryonPhotonRatioFit
- CosmologicalConstantFit, AlphaEMAtMZFit, AlphaSAtMZAbsolute
- AlphaSRunningBeta0Fit, AlphaStrongAtMZFit
- ElectronGminus2SubstrateFit, MuonGminus2SubstrateFit, TauGminus2SubstrateFit
- CKMVcbFit, CKMVubFit, CKMJarlskogFit, CabibboAngleFit
- PMNSDeltaCPFit, PMNSTheta12Solar, PMNSTheta13Reactor, PMNSTheta23MaximalMixing
- ColdNeutronILL_VCN, NewtonConstantFit, HubbleConstantH0Fit
- ...and ~35 more

KEEP (real existential/divergence-theorem content):
- `MassRatioNumerical.lean`
- `QuarkMassRatioNumerical.lean`

### A.3 — `*Absolute*P3*.lean` calibration tautologies (14 files / ~3,500 LOC)

Same pattern as *Fit.lean. Hand-rolled "P3a/b/c…" wave-naming inflates file count but content identical:
- ElectronMassAbsoluteP3a, MuonMassAbsoluteP3l, TauMassAbsoluteP3m
- UpQuarkMassAbsoluteP3b, DownQuarkMassAbsoluteP3c, StrangeQuarkMassAbsoluteP3d
- TopQuarkMassAbsoluteP3n, ProtonMassAbsoluteP3q, MuonGminus2AbsoluteP3e
- NeutrinoDeltaMSquaredAbsoluteP3d, ZBosonMassAbsoluteP3b, WBosonMassAbsoluteP3a
- HubbleConstantAbsoluteP3f, JarlskogJCKMAbsolute3Sigma, DESIY10AbsoluteP3g
- CatalanGIrrationalityAbsoluteP3h, ChernSimonsQuantizationAbsoluteP3k
- InstantonNumberAbsoluteP3i, VacuumBirefringenceAbsoluteP3j
- SeeleyDeWittA4ClosedFormP3s, NonAbelianCurvatureGeneralP3p
- KempfCMBBridgeP3r, AlgebraAtlasMathlibBridgesP3v, MathlibBridgesAtlas
- TauLeptonMassAbsolute, SterileNeutrinoMassAbsolute

### A.4 — `*PaperBundle.lean` citation re-exports (~600 LOC)

DELETE: TauLeptonMassPaperBundle, CMBAnisotropyPaperBundle, QuarkUDAbsoluteMassConnesDFPaperBundle, InformationSecondLawBundle.

### A.5 — `Multimode*MetaCapstone.lean` Yoneda mass-batch (~1,300 LOC)

DELETE: MultimodeWaveFunctionMetaCapstone, MultimodeQMObservableMetaCapstone, MultimodeHilbertCompleteMetaCapstone, MultimodeHilbertGrandUltimateMetaCapstone, MultimodeSuperGrandMetaMetaMeta. **Underlying Phase 7.7-7.20 primitives in `Emergence/Multimode*.lean` are KEEP.**

### A.6 — `FiniteAFAlgebra*Meta*.lean` vacuous-canonical Predictions/ duplicates (~1,800 LOC)

DELETE: AlgebraMeta, AllComponentsBilinearityMeta, GaugeComponentMeta, GaugeGroupMeta, GaugeLiePairGrandMeta, GrandAssociativityMeta, GrandMetaCapstone, LieSubmoduleMeta, MetaCapstone, SMulAllComponentsMeta, TotalAssemblyMeta, UnitarySubgroupMeta. **The real A_F algebra content in `Foundations/FiniteAFAlgebra*.lean` (33 files) is KEEP.** These Predictions/ Meta files re-bundle without theorem content.

### A.7 — `Grothendieck*Wave*.lean` graph-cosmetic citations (~1,200 LOC)

DELETE: GrothendieckWave2, GrothendieckWave2Extras, GrothendieckWave3, GrothendieckWave3Extras, GraphToPhysicsWave5, GaugeDualsWave4, FastRPBridgesWave5.

### A.8 — Atlas / Top-N leverage / Numerical-fits / Cycle-9 wave dispatches (~2,500 LOC)

DELETE: CosmologyWave4Fits, GienahWaveT2Bridges, Top20LeverageMenkib (1 honest piece `four_channel_residual_ordering_full_Nat` to salvage), PrecisionPhysicsAbsoluteWaveP2, NumericalFitsCycle9, AlgebraAtlasMathlibBridgesP3v, MathlibBridgesAtlas.

### A.9 — Cosmetic graph bridges with BOOK_VII direct violations (~7,500 LOC)

DELETE files matching `*Inbound.lean / *OrphanDefBridge.lean / *IsolationBreak.lean / *Capstone*.lean` patterns:

- DiracFromLatticeDataOrphanDefBridge, RequiredIterationsPiInbound, OmegaAlgebraLaplacianHermiticityInbound
- NeutrinoLessDoubleBetaBoundIsolationBreak, GravitonEnsembleBoundLIGOIsolationBreak
- StrongCPH0InboundBridge, CrossSubstrateTrackConnectivityBridge, LandauerConservationBridge
- MagneticLaplacianSubstrateEigenvalueBridge, OmegaAlgebraLaplacianHermiticityInbound
- OmegaSubstrateYonedaFullCapstone, OmegaTheoryGrandCapstone, LionsPrideMachineryCapstone
- FermionGenerationCompositeBaseSiteWitness, SuperpartnerAbsenceFromNoncommutativeSubstrate
- InflationRateFromMu (`healing_flow_mu_drives_inflation_rate : Prop := True` BOOK_VII §1 violation)
- BerryPullbackPathAsymmetry, CocycleNuclei3LevelNavigationAlignment
- CocycleNucleiIndegreeHierarchy, PiErrorGtSqrt2ErrorIndegreeWitness
- LatticePointUniversalBaseSiteDominance, HubbleTensionBridge
- MassDependentDecoherenceBridge, ElectronEDMBridge
- T2_PMNSDeltaCPDegRadBridge, T2_PMNSDeltaCPRefresh
- KKBimoduleBFromConnesStructure, HermitePadeFamilyClosure
- PhaseVCohomologyClosure, EntanglementCriticalDistance
- SubstrateGrandMetaCapstone, SubstrateIrrationalsDualityCompleteness
- SubstrateIrrationalsDualityFromBoundaryBreakers, SubstratePiHunchAllPairsMeta
- SubstratePiHunchCompleteCapstone, SubstratePiHunchCapstone, JointConsistency
- ...and several more

### A.10 — REWIRE candidates (post second-pass verification, 2026-05-06)

**SECOND-PASS VERIFICATION (Lion's-Pride 2026-05-06)**: re-read each of the 4 files claimed by Agent 1 to have `Prop := True` BOOK_VII violations. Result: **3 of 4 are ALREADY CLEAN** — Agent 1 mis-flagged docstring mentions of the historical pattern as code-level violations. Only 1 file (`SterileNeutrinoFromFourthIrrational.lean`) had an actual code-level violation, and it has been fixed in iter 161 (commit pending).

| File | LOC | Status (verified) | Notes |
|---|---:|---|---|
| `Predictions/SterileNeutrinoFromFourthIrrational.lean` | 500 | **REWRITTEN** | `def CatalanGNumericalBound (_N : ℕ) : Prop := True` at line 450 was a real code violation. **Fix applied 2026-05-06**: replaced with `def CatalanGNumericalBound (N : ℕ) : Prop := 0 < catalanGTruncError N` — substantive positivity Prop, discharged by `catalanGTruncError_pos`. Headline `extended_pi_hunch_4channels_paper_headline` 4-conjunct structure preserved with substantive content in conjunct 4 (rate-function positivity). Build 4732 GREEN, axiom Lean-core only. Docstring updated to reflect new substantive scope. |
| `Predictions/InflationRateFromMu.lean` | 397 | **ALREADY CLEAN** (Vega upgrade 2026-05-04) | Line 45 is a TABLE-OF-CONTENTS docstring entry describing the historical `Prop := True` pattern. The actual code at lines 259-262 has `def healing_flow_mu_drives_inflation_rate : Prop := ∀ (mu t C : ℝ), 0 < mu → 0 < t → 0 < C → (0 < eFoldCountLowerBound mu t C ∧ eFoldCountLowerBound mu t C = mu * t / C)` — REAL substantive Prop content, discharged via `eFoldCountLowerBound_pos` + `eFoldCountLowerBound_linear_in_time`. Vega's 2026-05-04 upgrade explicitly "eradicating the cycle-2 `Prop := True` placeholder per BOOK_VII NO_STUBS". KEEP UNCHANGED. |
| `Predictions/SuperpartnerAbsenceFromNoncommutativeSubstrate.lean` | 453 | **ALREADY CLEAN** | Line 46 is a docstring TABLE-OF-CONTENTS entry. Actual code at lines 151-152 has `def NonCommutativityObstruction : Prop := Function.Injective superpartnerOf` — REAL substantive Prop content (injectivity of the SUSY partner map), discharged at line 161 by `superpartnerOf_injective`. The semantic claim: M₃(ℂ)'s non-trivial commutator structure forces distinct SM particles to land in distinct SUSY-partner slots. KEEP UNCHANGED. |
| `Predictions/EntanglementCriticalDistance.lean` | 174 | **ALREADY CLEAN** (BOOK_VII compliant) | Line 172 has `theorem d_crit_first_in_V2 : 1 ≤ 1 := le_refl 1` — this IS BOOK_VII compliant per rule III ("Real Nat bookkeeping for closure markers (1 ≤ N := by norm_num) — non-trivial decidable Prop"). The file's own docstring at line 171 explicitly states "Real Nat bookkeeping (NOT `True := trivial`, per HARD RULE NO STUBS)". Cosmetic marker, technically clean. KEEP UNCHANGED. |

**Net update to total trash count**: original audit estimated 4 REWIRE files. Verified: only 1 needed rewrite (SterileNeutrino, done). 3 are already clean. **No purge needed for these 3 files.**

This confirms the original Agent 1 audit's CASCADE-DELETE list (~205 files / ~52K LOC for full Predictions/ trash) is otherwise accurate — but the agent over-flagged docstring mentions in a few cases. A second-pass read on borderline cases is worth the time before any batch commits.

### A.11 — Stray Python file

DELETE: `Predictions/_phase1_nashira_pdg_scan.py` (not loaded by lake, but pollutes Lean directory).

---

## Bucket B — Foundations/ (35 DELETE / ~9,800 LOC)

| Pattern category | Files | Notes |
|---|---|---|
| **Cycle 62 Aquarius wave** (Yoneda double-witness, isolation-break, paper-bundle inbound) | AFIrreducibilityFirstAlgebraModuleBridgeInbound, BlackHoleYonedaDoubleWitness, CKMAnglesYonedaDoubleWitness, ConformalSmoothMetricYonedaDoubleWitness, DiracOperatorFDoubleWitness, DynamicalSnapshotSequenceYonedaDoubleWitness, ErrorBoundYonedaWitness, ErrorBoundedSmoothMetricDoubleWitness, ErrorFormsIsolationBreak, ErrorGaugeSU2IsolationBreak, FormanRicciSubstrateBridgeAtlas, FourIrrationalsIndexFourCohomologyInbound, HeatKernelSeeleyDeWittBridge, JarlskogInvariantH2AnomalyInbound, MayerVietoris5PairGrandUnifiedCapstone, MayerVietorisH0QMYukawa, OmegaAlgebraB1EightWitness, OmegaAlgebraPhaseIFirstLandingInbound, OmegaAlgebraAbsorbsIrrationalityClassesInbound, OpaqueBundleSubstrateTopologyPreservation, PhaseIVCocycleWitnessesInbound, QMYukawaDisjointViaC145BridgeWitness, Top20SubstrateHubsIrrationalityDominance, YonedaOrphanMassBridgeWaveAFoundations | Cycle 62 W6.1 mass-batch 12-Structure inbound, etc. |
| **Cycle 63 W-TAIL wave** (frozen-Nat persistence-diagrams, c145 bundles) | AppliesDegreeFiltrationPersistenceDiagram, BandlimitedFieldYonedaDoubleWitness, BidirectionalSpecGenCount8Witness, C145SubstrateBridge, C145YonedaOrphanStructureDualBundle, CPViolationPhaseH1CocycleInbound, CechCocycleConcreteWitness, CechCocycleConstantsIrrationalsCompatibility, CosmologicalConstantH1Bridge, EightSpecGenH1WitnessBundle | Stephano Helix-Nebula T-MV-2 paper bundle, etc. |
| **SeeleyDeWitt** | SeeleyDeWittA4Substrate (Cycle-44 spectral-action Wave-D mass-bundle) | OBSOLETE — current Phase 6.x work in `HeatKernel*.lean` is the real port |

### Foundations/ — REWIRE-AUDIT-CANDIDATE (4 files / ~1,300 LOC, deeper review needed)

- `OmegaAlgebraCohomologyWitnesses.lean` (271 LOC) — verify cocycles are real H¹/H² classes vs. canonical-zero
- `OmegaAlgebraCohomologyWitnessesLesath.lean` (317 LOC) — same
- `OmegaAlgebraHopfBridges.lean` (200 LOC) — could be real Hopf-structure or pure naming repair
- `OmegaAlgebraIrrationalityAbsorption.lean` (209 LOC) — could be real `𝒜_Ω` welding or mass-batch
- `WasatTailSadr.lean` (315 LOC) — three lower-priority bridges, tautology=1

---

## Bucket C — Emergence/ (25 DELETE / ~9,200 LOC + 1 REWIRE)

| File | LOC | Pattern |
|---|---:|---|
| `Emergence/BlackHoleFormationIsolationBreak.lean` | 565 | c61 W3-OVERFLOW.2 isolation-break |
| `Emergence/CrossCorpusTests.lean` | 415 | c40 cross-corpus paper-bundle |
| `Emergence/CrossSectorBridges.lean` | 609 | Algieba F3 gap-closure paper-bundle |
| `Emergence/CyclicCosmologyPaperBundleInbound.lean` | 579 | c62 W8.3 cyclic cosmology inbound |
| `Emergence/DarkEnergyLocalityEvent.lean` | 423 | `Prop := True` + `:= trivial` headlines (BOOK_VII direct violation, lines 190, 198, 220, 224, 289, 305) |
| `Emergence/DarkEnergyLocalityAtRedshiftEvent.lean` | ~? | Companion sibling; same trivial-corollary pattern |
| `Emergence/DarkEnergySpatialLocality.lean` | ~? | Companion sibling; same family |
| `Emergence/DarkEnergyToBabyUniverseInbound.lean` | 395 | c61 W4.4 SEC S4 inbound; pure forward composition |
| `Emergence/EinsteinEmergenceResultYonedaWitness.lean` | 352 | c61 W2.7 Quaoar Q2 Witness-Yoneda; 10 yoneda tautology theorems |
| `Emergence/FermionContentIsolationBreak.lean` | 551 | c61 W3.1 isolation-break, Heart-Nebula NS N11 |
| `Emergence/FibrationConnectivity.lean` | 325 | c44 Wave D+E theorem E-1 paper bundle |
| `Emergence/HpwBianchiIOrphansCapstone.lean` | 190 | c60 W17 orphan capstone |
| `Emergence/PropagatorCompositionPropInbound.lean` | 287 | c62 W7-tail.2 Sculptor inbound |
| `Emergence/QCDAsymptoticFreedomCapstoneInbound.lean` | 410 | c62 W8.2 Carme single inbound |
| `Emergence/QmBridgePaperCapstone.lean` | 622 | c60 W16 Kaus-Borealis topology capstone — REDUNDANT with `QuantumMechanicsCapstone.lean` (KEEP the latter) |
| `Emergence/QuarkMassHierarchyFirstLandingInbound.lean` | 391 | c62 W8.4 Capricornus M M6 first-landing |
| `Emergence/RedshiftOrphansCapstone.lean` | 186 | c60 W21 Io 7-orphan capstone |
| `Emergence/RightHandedDoubletCPDualInbound.lean` | 465 | c62 W7-TAIL.3 CP-dual inbound |
| `Emergence/YonedaOrphanMassBridgeWaveAGaugeSector.lean` | 452 | c62 W6.3 14 Gauge-sector orphans, 15 yoneda tautology theorems |
| `Emergence/YonedaOrphanMassBridgeWaveAGravityGR.lean` | 493 | **54 tautology theorems** — pure mass-batch |
| `Emergence/YonedaOrphanMassBridgeWaveAYukawaSector.lean` | 347 | c62 W6.5 13 Yukawa orphans Vega |
| `Emergence/YukawaMatrixPrecisionBundleCapstone.lean` | 311 | c59 W1 Antares precision capstone — REDUNDANT |
| `Emergence/YukawaOrphanCalculationCapstone.lean` | 215 | c60 W22 Kaus-Australis 7-orphan capstone |
| `Emergence/ProtonCriticalityCapstone.lean` | 666 | Cycle-3 Menkar 6/6 unified capstone — vacuous canonical predicate `substrateCriticalBound = 0` |

### Emergence/ — REWIRE (1 file)

- `Emergence/PhotonElectronLoop.lean` (369 LOC) — drop `charge_conserved : True` field (line 146), drop `infoLoop_charge_conserved` theorem (line 258), drop `:= trivial` at line 323. KEEP rest — real `total_info_cost_balanced ≥ 2·m_e·c² − δ_comp(N)`.

---

## Bucket D — Irrationality/ (12 `Prop := True` defs / ~360 LOC, NO full-file deletes)

These are the cycle-59 Hydra Lindemann-Galois `_pending` skeleton — walled off (don't reach Basic.lean as theorems, only mentioned in comments). T-4 was retired via the **independent Hermite-Padé chain** in `Irrationality/HermitePade/`, NOT through this skeleton.

### D.1 — DOWNGRADE candidates (10 in CustomMath/, 2 in HermitePade/)

| File | Line | Def |
|---|---|---|
| `Irrationality/CustomMath/LindemannGaloisConjugation.lean` | 111 | `def Galois_conjugates_of_iPi (_α : ℂ) : Prop := True` |
| `Irrationality/CustomMath/LindemannGaloisConjugation.lean` | 137 | `def galois_conjugation_step : Prop := True` |
| `Irrationality/CustomMath/LindemannGaloisConjugation.lean` | 170 | `def symmetric_sum_integer_witness : Prop := True` |
| `Irrationality/CustomMath/LindemannGaloisConjugation.lean` | 184 | `def analytical_bound_under_conjugation : Prop := True` |
| `Irrationality/CustomMath/LindemannBasic.lean` | 120 | `def stage2_galois_framework : Prop := True` |
| `Irrationality/CustomMath/LindemannBasic.lean` | 147 | `def stage3_pi_transcendental_corollary : Prop := True` |
| `Irrationality/CustomMath/LindemannGaloisConjugationStep.lean` | 126 | `def galois_conjugation_step_degree_ge_three_pending : Prop := True` |
| `Irrationality/CustomMath/SymmetricSumIntegerWitness.lean` | 128 | `def symmetric_sum_two_conjugate_pair : Prop := True` |
| `Irrationality/CustomMath/SymmetricSumIntegerWitness.lean` | 143 | `def symmetric_sum_general_orbit_pending : Prop := True` |
| `Irrationality/CustomMath/AnalyticalBoundUnderConjugation.lean` | 153 | `def analytical_bound_general_orbit_pending : Prop := True` |
| `Irrationality/HermitePade/PiTranscendentalLayerCD.lean` | 149 | `def stage2_integer_bound_engine_pending : Prop := True` (vestigial post T-4 retirement) |
| `Irrationality/HermitePade/PiStratum.lean` | 98 | `def Real.pi_transcendental_research_track_marker : Prop := True` (vestigial post T-4 retirement) |

### D.2 — Strategy

The 8 `_pending` Galois Props can be discharged by a Wave-N `lean-proof-wizard` dispatch using `Polynomial.cyclotomic` / `IsAlgebraic.exists_minpoly` / `AlgEquiv.aut` machinery. The 2 HermitePade scaffolds are **strong DELETE candidates** post T-4 retirement (no transitive caller).

**Out-of-scope but related**: `IrrationalityClasses/Wave4Landings.lean:147` `def IsMahlerSClass (_x : ℝ) : Prop := True` — already axiom-narrowed downstream (`AxiomNarrowing.lean:111`), DELETABLE.

---

## Bucket E — Capstones/ (11 of 13 / ~3,300 LOC duplicate redundant chain)

**CRITICAL**: The real T-4 retirement work lives in `Irrationality/HermitePade/Decoupling.lean` (the actual `Real.pi_transcendental` theorem). The `Capstones/Pi*` files are post-retirement bookkeeping wrappers. 11 of 13 have **0 external inbound** — `Capstones/` is a self-island.

### E.1 — Canonical to KEEP and RENAME

- `Capstones/PiTranscendenceAxiomRetirementFinal.lean` (122 LOC, **9 ext inbound**) — THE canonical T-4 retirement statement.
  - **Action**: rename to `Irrationality/HermitePade/PiTranscendenceFinal.lean`, dissolve `Capstones/` directory.

### E.2 — DELETE (11 files)

| File | LOC | Inbound | Reason |
|---|---:|---:|---|
| `Capstones/IPiTranscendental.lean` | 63 | 0 | iπ ∈ T (one consequence, fold into Final) |
| `Capstones/PiNotSqrtRat.lean` | 77 | 0 | one consequence |
| `Capstones/PiPowPlusRational.lean` | 111 | 0 | one consequence |
| `Capstones/PiSqrtNLinearIndependence.lean` | 97 | 0 | one consequence |
| `Capstones/PiTranscendenceAxiomRetirementCycle63Final.lean` | 95 | 0 | superseded duplicate |
| `Capstones/PiTranscendenceUniformConsequences.lean` | 104 | 1 | folds into Final |
| `Capstones/PiTranscendenceYonedaBridges.lean` | 142 | 1 | 5 bridges; should live in `Predictions/` |
| `Capstones/PiTranscendentalOverComplex.lean` | 84 | 1 | one consequence |
| `Capstones/PiSqrt2LinearIndependence.lean` | 109 | 2 | one consequence |
| `Capstones/PiTranscendenceAxiomRetirement.lean` | 100 | 0 | superseded conditional duplicate |
| `Capstones/PiTranscendenceConsequences.lean` | 125 | 3 | core consequences — could SALVAGE into `Irrationality/HermitePade/Consequences.lean` |
| `Capstones/PiTranscendenceAlgebraicConsequences.lean` | 144 | 4 | similar to above; SALVAGE if needed |

**Total Capstones/ delete**: 11 files / ~3,150 LOC. Move 1 file to Irrationality/HermitePade/.

---

## Bucket F — Other dirs (15 files / ~5,100 LOC)

### F.1 — Spacetime/ (4 files / ~1,250 LOC)

- `Spacetime/YonedaOrphanMassBridgeWaveALatticeSpacetime.lean` (387 LOC) — c62.W6.6 mass-batch
- `Spacetime/OperatorsCapstoneIndex.lean` (397 LOC) — Spica² c57 W15
- `Spacetime/OperatorsCapstoneResidual.lean` (472 LOC) — Sirius c59 W16
- `Spacetime/OperatorsCapstoneResidualWave3.lean` (374 LOC) — Pleione c60 W20

REWIRE: `Spacetime/CoordinationNumberInbound.lean` (219 LOC) — KEEP §1-3 substance; DELETE §4 paper-bundle and §5 frontier marker.

### F.2 — Tensor/ (1 file / 58 LOC)

- `Tensor/ErrorTensorIsolationBreak.lean` — `True ∧ True ∧ ... ∧ True` (11 conjuncts), `1 ≤ 2026` frontier marker.

### F.3 — Geometry/ (4 files / ~1,000 LOC)

- `Geometry/WeylGeneralIsolationBreak.lean` (75 LOC) — same `True ∧ ...` pattern
- `Geometry/ErrorBoundedSmoothMetricCategoricalYonedaWitness.lean` (149 LOC) — REVIEW/REWIRE
- `Geometry/ErrorBoundedSmoothMetricRealCategoricalYonedaWitness.lean` (132 LOC) — REVIEW/REWIRE

**HONEST KEEP**: `Geometry/HodgeStar.lean::IsCoClosed0` — `: Prop := True` is mathematically justified (degree-0 vacuous truth, no `Ω^{-1}`, fully documented in 30-line docstring).

### F.4 — Defects/ (1 file / 188 LOC)

- `Defects/SemiSmoothMetricCategoricalYonedaWitness.lean` — REVIEW/REWIRE

### F.5 — Conservation/ (1 file / 312 LOC)

- `Conservation/CorrespondenceOrphansCapstone.lean` — REVIEW/MERGE into `Correspondence.lean`

### F.6 — HealingFlow/ (3 files / ~1,612 LOC)

- `HealingFlow/IsHealingFlowYonedaWitness.lean` (596 LOC) — REVIEW
- `HealingFlow/HealingFlowBHIsolationBreak.lean` (487 LOC) — REVIEW/MERGE
- `HealingFlow/HealingFlowToSmoothMetric.lean` (529 LOC) — REVIEW; could fold into `Flow.lean`/`SmoothMetric.lean`

### F.7 — Probe/ (4 files / ~370 LOC)

- `Probe/AgentTest.lean` (6 LOC) — DELETE obsolete
- `Probe/StressTest1.lean` (58 LOC) — DELETE obsolete
- `Probe/StressTest2.lean` (22 LOC) — DELETE obsolete
- `Probe/AmbitiousProofs.lean` (199 LOC) — REVIEW/DELETE (mostly commented-out probes)

### F.8 — IrrationalityClasses/ (1 def + 1 file / ~265 LOC)

- `IrrationalityClasses/Wave4Landings.lean:147` — `def IsMahlerSClass (_x : ℝ) : Prop := True` (already axiom-narrowed via `AxiomNarrowing.lean`); DELETABLE
- `IrrationalityClasses/Wave4LandingsHeadline.lean` (96 LOC) — REVIEW; strip `_first_pi_transcendental_free_in_V2 : 1 ≤ 2026` frontier marker, keep substantive theorems

---

## HONEST KEEP — confirmed clean

**Foundations/**:
- All `FiniteAFAlgebra*.lean` (33 files) — Connes A_F = ℂ × ℍ × M_3(ℂ) componentwise, real algebra: ℝ-bilinearity, IsUnitary, IsSelfAdjoint, mul_assoc h_part Hamilton 1843, mul_assoc m3_part 3×3 matrix Finset.sum + ring
- `HeatKernelMinimal.lean` §1-§4 (real Vassilevich SpectralMoments + GeneralizedLaplacian + Bochner formula)
- `HeatKernelBochnerForm.lean`, `HeatKernelCoefficients.lean`, `HeatKernelDerived.lean`, `HeatKernelExtended.lean`, `SpectralActionTruncated.lean` — Phase 6.x current Lion's-Pride work
- `FiniteSpectralTriple.lean`, `QCDRunning.lean`, `AlphaSRunning1Loop.lean`

**Emergence/**:
- `HiggsFromError.lean`, `HiggsVEVSubstrate.lean`, `HiggsAndMassHierarchy.lean` (post-split §1+§4)
- `LeptonMassFromIrrationals.lean`, `QuarkMassFromIrrationals.lean`
- `YukawaMatrix.lean` (KEEP-WITH-WARNING: hand-picked placeholders 1,3,9 / 1,2,5)
- `AnomalyCancellation.lean` (KEYSTONE), `FermionHypercharge.lean`
- `ErrorGaugeSU2.lean`, `ErrorGaugeSU3.lean`, `SU3GellMann*.lean`, `SU3JacobiVia*.lean`
- `ErrorGaugeField.lean`, `NonAbelianGauge.lean`, `SU3ColorAndNonAbelianF.lean`
- `ConnesBimodule.lean`, `DiracFSpectrum.lean`
- `MassAsDelay.lean`
- `QuantumMechanicsCapstone.lean` (THE GRAND_QM_EMERGENCE)
- `EinsteinEmergence.lean`, all `Hpw*.lean` (THE PRIZE + 7 regimes)
- `DarkEnergyToBabyUniverse.lean` (post-audit, real BabyUniverseSpectrum struct)
- `PontryaginForm.lean` (real `tr(F∧F)`)

**Predictions/** (the substrate spine):
- `MassDerivationStatus.lean` (honest non-derivation marker)
- `GravitonDispersionTheorem.lean`, `IRUVDecomposition.lean`
- `RepairQuantumEnergyTheorem.lean`, `RepairEnergyLowerBound.lean`
- `SubstrateDispersion.lean`
- All `SubstrateMachinery*Meta.lean` (top-level frozen-Nat ledgers, axiom-free)
- All `SubstrateRunningCoupling*.lean` (1-11 loop tower with real factored beta-function)
- `MassRatioNumerical.lean`, `QuarkMassRatioNumerical.lean`, `PiHunchMassOrdering.lean`
- All `JarlskogFromIrrationals/MixingAnglesFromIrrationals/NeutrinoMassDifferencesFromIrrationals.lean`
- `AxionFromSlowPiConvergence.lean`, `GenerationMassFromPiError.lean`, `GenerationOrdering.lean`
- All gravity/cosmology/SM physics predictions: `BekensteinHawkingEntropy.lean`, `HawkingTemperature.lean`, `GravDecoherenceTScaling.lean`, `RedshiftFloor.lean`, `UHECRDispersion.lean`, `LorentzInvarianceViolationBound.lean`, `SchwingerPairProductionRate.lean`, `VacuumBirefringence.lean`, etc.
- `WBosonMass.lean` (real composition `M_W = g_W·v/2`, distinct from WBosonMassAbsoluteP3a calibration trash)

**Geometry/**:
- `Christoffel.lean`, `RiemannCurvature.lean`, `RicciTensor.lean` — Mizar's continuum stack
- `PoincareLemma.lean` (H¹=H²=H³=0)
- `HodgeStar.lean`, `HodgeDecomposition.lean`
- `StructureEquation.lean` (Cartan + Bianchi)
- `DiscreteForms.lean`, `DiscreteMaxwell.lean`

**Spacetime/**:
- `Constants.lean` (4 physical opaque bundles c, ℏ, G_N, k_B)

**Tensor/**:
- `ValuedRicci.lean`, `ValuedGeometry.lean`, `ValuedCurvature.lean` — Valued pipeline

**Variational/**:
- `EinsteinHilbertAction.lean`, `CubicGravitonVertex.lean`, `QuarticGravitonVertex.lean`, `RicciScalarPerturbative.lean` — Phase 5.x graviton vertices

**Conservation/**:
- `Information.lean`, `InformationKL*.lean`, `InformationStressEnergyConstructor.lean`

**HealingFlow/**:
- `Lyapunov.lean`, `LaSalle.lean`, `Convergence.lean`, `SpectralLatticeLaplacian.lean`
- `Higgs*.lean`, `Yukawa*.lean` (Phase 3 SSB Mexican-hat)

**Torsion/** — all 4 files clean (Popławski bounce)

**Defects/Sparsity.lean, DefectTensor.lean** — real Markov/Chebyshev work

**QuantumGravity/Substrate*.lean** (45 files, 1-11 loop tower + Substrate Born/QM/Pi-Hunch)

**Irrationality/HermitePade/** — REAL T-4 retirement chain (14 hand-authored files / ~3000 lines, the actual `Real.pi_transcendental` proof, single-day 2026-04-27 by Norbert × Opus 4.7). **DO NOT TOUCH.** Only the 2 HermitePade `_pending` scaffolds (PiTranscendentalLayerCD.lean:149 and PiStratum.lean:98) are vestigial — DOWNGRADE.

**T-5 capstones** (`T5_Phase7_V8Capstone_StrictRegime_Unconditional.lean` 829 LOC / 24 thms, `T5_Phase7_V8R5_Joint_SchmidtD7_WronskianInduction_Discharge.lean` 712 LOC / 17 thms, `T5_Phase7_RothTheorem_FinalCapstone.lean` 469 LOC / 17 thms) — all real composition theorems, 0 internal `Prop := True`.

**Paper/** (re-export aliases, legitimate)

**Meta/** (Neo4j ingest pipeline tooling)

---

## Root-cause categorization

| Root cause | Files | LOC |
|---|---:|---:|
| **(A) Cycle 57-63 graph-density inflation** (Aquarius / Capricornus / Spica² / Hydor / Pollux / Sadalsuud-II waves): `*IsolationBreak`, `*OrphanCapstone`, `*Inbound`, `*YonedaDoubleWitness`, `*CategoricalYonedaWitness`, `*PaperBundle`, `*Atlas`, `*MV-N-pair`, `*Top-N hubs`. The biggest pile by file count. Pure Neo4j fastRP/Leiden community-density cosmetics — no math content. | ~150+ | ~30,000 |
| **(B) PDG citation-numerology**: `T1_*Frontier.lean` + `*Fit.lean` + `*Absolute*P3*.lean`. Calibration tautologies by construction. | ~200 | ~45,000 |
| **(C) T-4 retirement cycle-64 Capstone island**: 11 redundant `Capstones/Pi*` duplicates. | 11 | ~3,300 |
| **(D) Cycle-59 Hydra Lindemann-Galois `_pending` scaffolds**: 12 `Prop := True` defs walled off in `Irrationality/CustomMath/`. | 12 defs | ~360 |
| **(E) April probe junk**: 4 wizard-stress-test files in `Probe/`. | 4 | ~370 |
| **(F) Cycle-44 Wave D+E SeeleyDeWitt/FibrationConnectivity bundles** (cycle-44 spectral-action work, superseded by current Phase 6.x). | 2 | ~543 |
| **(G) Cycle 60 W16-W22 capstone tower** (Kaus-Borealis/Kaus-Australis/Io 7-orphan capstones — REDUNDANT with real `QuantumMechanicsCapstone`). | 4 | ~1,200 |

---

## Recommended purge strategy

**Strategy**: cascade-delete in 5 batches, verify build GREEN at each step, mirror to /mnt/c, commit per batch.

| Batch | Bucket | Files | LOC | Risk |
|---|---|---:|---:|---|
| 1 | A.1 + A.2 + A.3 + A.4 (Predictions PDG numerology) | ~205 | ~45,000 | LOW — most have 0-2 inbound, all consumers in same trash bucket |
| 2 | A.5 + A.6 + A.7 + A.8 + A.9 (Predictions Yoneda mass-batch + graph-cosmetic bridges) | ~50 | ~13,000 | LOW — verify cascade |
| 3 | B (Foundations cycle 61-63 wave-bridges) | 35 | ~9,800 | MEDIUM — some sister files reference each other; cascade-verify |
| 4 | C (Emergence wave-bridges + redundant capstones) | 25 | ~9,200 | MEDIUM — `QmBridgePaperCapstone` redundant check vs `QuantumMechanicsCapstone` |
| 5 | D (Irrationality `_pending` DOWNGRADE) + E (Capstones dissolution + rename Final) + F (other dirs cleanup) | 26 files + 12 defs | ~9,100 | MEDIUM — Capstones rename/move requires Basic.lean import update |

**After batch 5**: Build job count expected to drop from 4732 to ~3500-3700 GREEN. Repo will be ~95% paper-grade substrate-spine, no PDG-numerology trash, no Yoneda mass-batches, no graph-cosmetic bridges.

---

## Honest disclaimer

**This audit is from 4 parallel opus-code-crawler agents. Each agent's verdict reflects its own judgment over its scope.** Some borderline cases:
- A few `T1_*` files might have salvageable RGE-running content (e.g., `T1_AlphaEMMzRunningFrontier`) — flagged KEEP but worth a final read-pass.
- `Top20LeverageMenkib.lean` has 1 honest piece (`four_channel_residual_ordering_full_Nat`) that should be salvaged into `PiHunchMassOrdering.lean`.
- The Foundations REWIRE-AUDIT-CANDIDATE files (5 files / ~1,300 LOC) need a deeper second pass.

**Recommendation**: user reviews this report, identifies any specific files to spare, then proceeds batch-by-batch.

---

## Plan calibration impact

If this purge proceeds, the Phase 1 trash purge (post-graviton-cluster, 2026-05-05) extends into a Phase 1.B "Round 2" multi-day cleanup. The downstream phase numbering (Phase 2 honest status markers → Phase 6 genuine Connes spectral action) is **unchanged**. The new TODO tasks #65-#73 from iter 160 remain valid.

**End of audit report.**
