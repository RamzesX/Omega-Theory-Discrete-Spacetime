# OmegaTheory V2 Codebase Map

**Generated**: 2026-04-15 by Opus Code Crawler
**Source**: Full crawl of `OmegaTheory/` directory tree

## Summary

| Metric | Count |
|--------|-------|
| .lean files | 135 |
| Theorems (`^theorem`) | 1,682 |
| Lemmas (`^lemma`) | 27 |
| Definitions/structures/instances | 810 |
| Axioms (`^axiom`) | 24 (9 core + 15 HermitePade research) |
| `sorry` | **0** |
| Build jobs | 3,454 (GREEN) |
| Lean version | v4.29.0 |
| Mathlib version | v4.29.0 |

### Axiom Budget

| Category | Count | Where |
|----------|-------|-------|
| Physical constants (c, hbar, G_N, k_B) | 4 | `Spacetime/Constants.lean` |
| Positivity axioms (c_pos, hbar_pos, G_N_pos, k_B_pos) | 4 | `Spacetime/Constants.lean` |
| HPW Laplacian-Ricci convergence | 1 | `Emergence/LaplacianRicci.lean` |
| Pi irrationality research conjectures | 15 | `Irrationality/HermitePade/*.lean` (isolated) |
| **Total** | **24** | |

The 9 core axioms are the foundation of OmegaTheory. The 15 HermitePade axioms are research conjectures in a self-contained subtree not imported by the main build.

---

## Architecture (12 Layers)

```
Layer 0:  Foundations/         (5 files)  -- Error algebra, Lie algebra, Taylor, Hopf, forms
Layer 1:  Spacetime/           (4 files)  -- Z^4 lattice, constants, operators, causal structure
Layer 2:  Tensor/              (4 files)  -- Error-propagating tensors, valued geometry/curvature
Layer 3:  Geometry/           (22 files)  -- Metric, connection, curvature, Weyl, Hodge, Poincare,
                                             continuum Christoffel/Riemann/Ricci stack
Layer 5:  Defects/             (2 files)  -- DefectTensor, sparsity bounds
Layer 6:  Conservation/        (8 files)  -- Noether, stress-energy, KL information, correspondence
Layer 7:  HealingFlow/         (6 files)  -- Lyapunov, LaSalle, convergence to equilibrium
Layer 8:  Emergence/          (57 files)  -- GR emergence + QM bridge + dispersion + predictions
Layer 9:  Predictions/         (8 files)  -- Falsifiable testable predictions (5-15 yr horizon)
Layer 10: Torsion/             (3 files)  -- Einstein-Cartan, spin-torsion, Poplawski bounce
Layer 11: Irrationality/      (34 files)  -- Pi/e/sqrt2 approximations, HermitePade subtree
Layer 12: Variational/         (3 files)  -- Graph action, discrete Noether, info geodesics
          Paper/               (2 files)  -- Manuscript headline re-exports
```

Each layer depends only on layers above it. `Emergence/` is the largest subsystem with 57 files spanning GR emergence and QM bridge.

---

## Module Dependency Graph

### Core Chain (GR emergence)
```
ErrorAlgebra
    |
Lattice --> Constants --> Operators
    |           |            |
  Metric --> Connection --> Curvature --> CurvatureSymmetries
    |                          |                |
DefectTensor --> Sparsity   Weyl/WeylGeneral  StressEnergy
    |                                           |
 CoarseGrain                   Information --> NoetherMetaStructure
    |                              |
LaplacianRicci (AXIOM) -----> EinsteinEmergence (THE PRIZE)
    |                              |
HpwHypothesis                CosmologicalConstant --> NegativePressure
    |                                                     |
HpwElimSummary <-- {7 regime instances}            BigBounce (Torsion)
```

### QM Bridge Chain (axiom-free)
```
InformationKL --> CoarseGrainingMap --> SnapshotDynamics
                       |                      |
            SnapshotPropagator    SchrodingerFromLattice
                                         |
                   BornRule <----+--- Interference
                       |              |
              Measurement      Entanglement --> CHSHBell
                  |                |
           HilbertEmergence   Decoherence
                  |
       QuantumMechanicsCapstone (CAPSTONE: grand_qm_emergence)
```

### Continuum Geometry Stack (Mizar, Apr 15)
```
SmoothMetric --> Christoffel --> RiemannCurvature --> RicciTensor
                                                        |
                                         HarmonicGaugeContinuum
                                                        |
                                              RicciProperties
                                                        |
                                            WeinbergLinearised
```

### HPW Elimination Chain
```
LaplacianRicci
    |
HpwHypothesis (typeclass: HpwEliminableRegime)
    |
+-- HpwMinkowski      (flat)
+-- HpwLinearised      (linearised, imports HpwMinkowski)
+-- HpwSchwarzschild   (static spherical vacuum)
+-- HpwFRW             (cosmological)
+-- HpwBianchiI        (anisotropic, imports HpwFRW)
+-- HpwDeSitter        (de Sitter, imports HpwFRW)
+-- HpwKerr            (rotating black hole)
    |
HpwElimSummary (dispatch umbrella)
    |
EinsteinEmergence (_regime variants: axiom-free)
```

### Dispersion / SR Chain
```
Constants --> SpecialRelativity --> DispersionFromLattice --> DispersionBridge
                    |                                              |
               MassAsDelay                              KleinGordon --> DiracOptional
                    |
             Redshift --> RedshiftFloor (Prediction)
```

### Irrationality/HermitePade Subtree (ISOLATED)
```
Decoupling -----> PiStratum
    |                  
    +----------> UniversalSiegelBarrier
    
F27_LegendreSlope --> F27_LucasSeparation
    |                        |
F27_TaylorPartialSum --> F27_E_Denominator --> F27_G_Denominator
    |                        |                       |
    +----> F27_E_Dominates_G <-----------------------+
    |
F27_Quantitative

F54_SlicePrime --> F54_AlphaSlope --> F54_AlphaSlope_ClosedForm
    |                  |
    +----------> F54_Parity
    |
F52_P3_Rescue
    |
F51_Denominator --> F51_Effective_Denominator

F26_MahlerEquation --> F26_MahlerEquation_convergent
F49_Existence, F50_Cauchy, F50_Contour_Integral, F50_Decay
F56_StokesClosedForm
Conj_4A4_Statement --> Attack13_SliceOneThird
Niven_Arctan, SSReduction
GAP_M_Conjecture, GAP_N_Conjecture
BridgeTheorem, BridgeTheorem_Frequencies
```

---

## Theorem Density (top 15 files)

| File | Theorems | Defs | Note |
|------|----------|------|------|
| `Geometry/PoincareLemma.lean` | 92 | 16 | H^0=R, H^1=H^2=H^3=0 |
| `Conservation/Correspondence.lean` | 42 | 13 | Discrete-continuum correspondence |
| `Emergence/QmBridgePaper.lean` | 42 | 10 | Paper re-exports |
| `Spacetime/Operators.lean` | 36 | 9 | Discrete differential operators |
| `Emergence/Entanglement.lean` | 29 | 12 | Bell + CHSH |
| `Emergence/SchrodingerFromLattice.lean` | 28 | 9 | Schrodinger emergence |
| `Emergence/CoarseGrainingMap.lean` | 27 | 12 | DynamicalSnapshotSequence |
| `Emergence/SpecialRelativity.lean` | 26 | 3 | Lorentz factor |
| `Emergence/KleinGordon.lean` | 25 | 10 | Relativistic wave equation |
| `Foundations/ErrorForms.lean` | 25 | 18 | Error-propagating forms |
| `Emergence/BekensteinBound.lean` | 24 | 8 | Entropy bound |
| `Emergence/HilbertEmergence.lean` | 24 | 6 | Hilbert space emergence |
| `Emergence/Measurement.lean` | 24 | 6 | Wavefunction collapse |
| `HealingFlow/Lyapunov.lean` | 21 | 5 | dF/dt <= 0 |
| `Emergence/DimensionalFlow.lean` | 21 | 3 | d_eff(E) |
| `Emergence/ErrorGaugeField.lean` | 21 | 11 | Error as gauge field |

---

## Gaps and Orphans

### Files NOT imported by Basic.lean (orphan candidates)

| File | Reason | Risk |
|------|--------|------|
| `HealingFlow/LaSalle.lean` | Not in main import list | LOW -- used by LaSalleKLBridge; omitted from Basic but still in build |
| `Conservation/LaSalleKLBridge.lean` | Not in main import list | LOW -- imports LaSalle + InformationKLBridge |
| `Emergence/WhitneyInterpolant.lean` | Not in main import list | LOW -- alternative interpolation scheme |
| `Irrationality/HermitePade/*.lean` (28 files) | Entirely separate research track | NONE -- intentionally isolated |

### Modules with no downstream consumers (leaf nodes)

| File | What it provides | Assessment |
|------|-----------------|------------|
| `Variational/InformationGeodesics.lean` | Fisher metric geodesics | Theoretical endpoint -- no consumer yet |
| `Geometry/GaussBonnet.lean` | Discrete Gauss-Bonnet | Complete in itself |
| `Geometry/HodgeDecomposition.lean` | Hodge decomposition | Complete in itself |
| `Geometry/Examples.lean` | Worked examples | Pedagogical, no consumers needed |
| `Geometry/WeinbergLinearised.lean` | Weinberg linearised | End of continuum chain |
| `Conservation/LaSalleKLBridge.lean` | LaSalle-KL bridge | End of LaSalle chain |
| `Emergence/Inflation.lean` | Inflationary era | End of cosmological chain |
| `Emergence/ConnesSpectralAction.lean` | Spectral action | Standalone result |

### README outdated counts

The README.md reports "~81 files" and "~1450 theorems" -- the actual counts are 135 files and 1,682 theorems. This should be updated.

---

## 6-Entity Model Classification

| Symbol | Category | Node Count | Key Entry Point |
|--------|----------|-----------|-----------------|
| **C** | Controller | 7 | `Basic.lean` (113 imports), `OmegaGrandEmergence.lean`, `QuantumMechanicsCapstone.lean` |
| **F** | Configuration | 4 | `Constants.lean` (8 axioms), `LaplacianRicci.lean` (1 axiom) |
| **S** | Security | 10 | `HpwHypothesis.lean` -> 7 regime instances -> `HpwElimSummary.lean` |
| **I** | Implementation | 109 | 12 layers, 135 files. Largest: `Emergence/` (57), `Geometry/` (22) |
| **D** | Diagnostics | 3 | `AXIOM_TRANSPARENCY_AUDIT.md`, `CONSTANT_CHAIN_AUDIT.md`, `.neo4j/` |
| **L** | Lifecycle | 4 | HealingFlow chain, HPW elimination chain, QM bridge chain, continuum geometry chain |

---

## Neo4j Graph

Load the authoritative graph with:
```bash
docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
  < .neo4j/navigation_master_v2.cypher
```

Query entry point:
```cypher
MATCH (nav:NavigationMaster {namespace: 'OmegaTheoryV2'})
RETURN nav.file_count, nav.theorem_count, nav.axiom_count, nav.sorry_count
```

Discover subsystems:
```cypher
MATCH (nav:NavigationMaster {namespace: 'OmegaTheoryV2'})-[:GUIDES]->(e:EntityNavigator)
RETURN e.name, e.entity_type, e.symbol, e.ai_description
ORDER BY e.entity_type
```

Find all implementations in a category:
```cypher
MATCH (e:EntityNavigator {namespace: 'OmegaTheoryV2', name: 'ImplementationLayer'})-[:IMPLEMENTS]->(c:ConcreteImpl)
RETURN c.name, c.path, c.theorem_count, c.arch_layer
ORDER BY c.arch_layer, c.name
```
