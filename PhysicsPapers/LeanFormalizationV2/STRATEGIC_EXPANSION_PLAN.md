# OmegaTheory V2 — Strategic Expansion Plan

**Created**: 2026-04-17 by team-lead. **Scope**: items 1–20 from master TODO.
**Current state**: 3455 jobs GREEN, 0 sorry, 9 axioms, 6 HPW-bypassed regimes.

---

## Dependency Graph

```
Constants.lean ─── ErrorAlgebra.lean ──┬── ErrorLieAlgebra (#4) ──┬── ErrorGaugeField U(1) (#5)
                                       │                          ├── ErrorGaugeField SU(2) (#11)
                                       │                          ├── ErrorGaugeField SU(3) (#14)
                                       │                          └── ErrorHopfStructure (#16)
                                       │
                                       ├── ErrorForms (#13) ──── ErrorMaxwell ── ErrorYangMills
                                       │
                                       └── ErrorTensor ── ValuedGeometry ── HPW chain
                                                                              ├── Ingredients E/F (#8)
                                                                              └── Ingredients G/H (#9)

SpecialRelativity ──┬── KleinGordon (#6) ── Dirac (#12) ── SpinStatistics
                    └── MassAsDelay ── Predictions/*

HealingFlow ──┬── LaSalle ── CosmologicalConstant ── Inflation (#7)
              │                                       └── CosmologicalConstantProblem (#18)
              └── Convergence ── Equilibrium ── DarkMatter? (#20)

Entanglement ── CHSHBell (#10) ── BellNonlocality

HpwHypothesis ──┬── HpwMinkowski ── HpwLinearised ── HpwSchwarzschild
                ├── HpwFRW ── HpwDeSitter ── HpwBianchiI
                ├── HpwKerr (#3)
                └── EinsteinEmergence migration (#1)

ConnesSpectralAction (new) ── FiniteAlgebra_A_F ── GaugeGroupDerivation ── Higgs (#15)

SnapshotPropagator ── Interference ── PathIntegral (#17) ── FeynmanPropagator
```

---

## Wave Schedule

### Wave 8 (CURRENT — 7 agents running)
| # | Item | Agent | Status |
|---|---|---|---|
| 1 | EinsteinEmergence migration | Shaula | running |
| 3 | Kerr HPW | Sargas | running |
| 4 | ErrorLieAlgebra | Nunki | running |
| 6 | Klein-Gordon | Diphda | running |
| 7 | Inflation | Ankaa | running |
| 10 | CHSH Bell | Schedar | running |
| 13 | Error forms | Alpheratz | running |
| R | Gauge research | Wezen | ✅ done |

### Wave 9 (after wave 8 — depends on #4 ErrorLieAlgebra)
| # | Item | Agent name | Depends on |
|---|---|---|---|
| 5 | ErrorGaugeField U(1) | Adhara | #4 |
| 11 | Error SU(2) gauge | Naos | #4 |
| 12 | Dirac from lattice | Regor | #6 |
| 8 | HPW ingredient E (Whitney start) | Avior | independent |
| — | Neo4j NavigationMaster mapping | Tureis | independent |
| — | Connes spectral action setup | Gacrux | Wezen report |

### Wave 10 (after wave 9)
| # | Item | Agent name | Depends on |
|---|---|---|---|
| 14 | Error SU(3) / QCD | TBD | #4, #11 |
| 15 | Higgs mechanism start | TBD | #5, #11 |
| 9 | HPW ingredient G (Ricci-box) | TBD | #8, Fomalhaut |
| 16 | ErrorHopf structure | TBD | #4, #13 |
| — | Paper: gauge theory appendix | TBD | Wezen report |

### Wave 11 (research-grade continuation)
| # | Item | Agent name | Depends on |
|---|---|---|---|
| 17 | Path integral / Feynman | TBD | #10, Propagator |
| 18 | Cosmological constant problem | TBD | #7, Pollux |
| 9 | HPW ingredient H (harmonic gauge) | TBD | #9-G |
| — | Spin-statistics theorem | TBD | #12 |
| — | Anomaly cancellation | TBD | #11, #14 |

### External (user action)
| # | Item | Owner |
|---|---|---|
| 2 | PRL submission | Norbert |
| 19 | Real.pi_transcendental | Mathlib upstream |
| — | ILL PF2 contact | Norbert |
| — | arXiv submission | Norbert |
| — | GitHub public repo | Norbert |

### Frontier (wave 12+, speculative)
| # | Item | Depends on |
|---|---|---|
| 20 | Dark matter from substrate | #18, equilibrium theory |
| — | Graviton mass bound | #5, CosmologicalConstant |
| — | Hawking radiation from substrate | BekensteinBound, #17 |
| — | Black hole information paradox | #17, InformationKL |
| — | Unification coupling constant | #14, #15 |

---

## Strategic Priorities (algebra-first path)

Per Wezen's research, the recommended expansion order:

### Priority A: Error Algebra Extensions (foundation for everything)
1. **ErrorLieAlgebra** (#4) — approximate Jacobi, bracket error → basis for all gauge theory
2. **ErrorForms** (#13) — error-propagating d, ∧ → basis for Maxwell + Yang-Mills
3. **ErrorHopf** (#16) — coalgebra + antipode → renormalization connection

### Priority B: Gauge Theory (Standard Model path)
4. **U(1) gauge** (#5) — photon, EM force, substrate mass bound
5. **SU(2) gauge** (#11) — weak force
6. **Connes spectral action** — derives gauge group from finite algebra classification
7. **Higgs** (#15) — mass generation from error-bounded symmetry breaking
8. **SU(3) gauge** (#14) — strong force / QCD

### Priority C: Relativistic QFT
9. **Klein-Gordon** (#6) — relativistic scalar field
10. **Dirac** (#12) — spinor field, spin-statistics
11. **Path integral** (#17) — from SnapshotPropagator
12. **Feynman propagator** — from path integral + substrate causality

### Priority D: Cosmology
13. **Inflation** (#7) — healing flow → de Sitter → exit
14. **Λ problem** (#18) — why Λ is naturally small
15. **Dark matter** (#20) — information-density inhomogeneities

### Priority E: HPW Full Elimination
16. **Ingredient E** (#8) — Whitney extension
17. **Ingredient F** (#8) — C⁴ bound
18. **Ingredient G** (#9) — Ricci-box in Lean
19. **Ingredient H** (#9) — harmonic gauge in Lean
20. **Axiom removal** — delete axiom, 9→8 axioms

---

## Estimated Totals

| Category | Files | Theorems (est.) | Effort |
|---|---|---|---|
| Error algebra extensions | 4 | ~80 | 1-2 weeks |
| Gauge theory (U(1) → SU(3)) | 8 | ~200 | 2-4 weeks |
| Connes spectral action | 6 | ~150 | 3-6 weeks |
| Higgs mechanism | 4 | ~100 | 2-3 weeks |
| Relativistic QFT | 6 | ~150 | 2-4 weeks |
| Cosmology | 4 | ~80 | 1-2 weeks |
| HPW full elimination | 6 | ~120 | 6-10 weeks |
| Audit + documentation | 4 | — | 1 week |
| **Total** | **~42** | **~880** | **~20-35 weeks** |

Combined with existing V2 (~140 files, ~1660 theorems): target **~180 files, ~2540 theorems**.

---

## Success Metrics

- **Axiom count**: 9 → 8 (HPW eliminated) → potentially 8 forever (physical constants only)
- **Predictions**: 8 → 12+ (gauge-sector predictions: photon mass bound, anomalous magnetic moment substrate correction, proton decay rate)
- **Standard Model coverage**: U(1) + SU(2) + SU(3) + Higgs derived from error algebra
- **Experimental contact**: PRL letter submitted, ILL contacted, cold-neutron test proposed
- **Mathematical novelty**: Error-propagating Lie/Hopf algebra as standalone publishable result

---

*Team-lead, 2026-04-17. Updated after wave 7 + Wezen research.*
