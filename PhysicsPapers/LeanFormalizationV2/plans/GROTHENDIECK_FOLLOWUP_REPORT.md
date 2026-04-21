# Grothendieck Follow-up — OmegaAlgebra Completeness

**Author**: Algieba (γ Leonis), grothendieck-sage — 2026-04-20
**Follow-up to**: Achird's Full Power analysis (cycle-23 snapshot)
**Method**: Cypher-native + GDS + APOC; zero Python; zero Lean edits
**Findings persisted as**: `:GraphFinding {name: algieba_F1_*, algieba_F2_*, algieba_F3_*}`

---

## F1 — Complete generator list

Achird's top-17 was a strong first pass but missed eighteen primitive generators
(usage ≥ 58 across the corpus) and fifteen heavily-used derived generators. The
complete audit, restricted to definitions with `outdeg > 30` downstream usage, gives
**26 primitive + 24 derived = 50 generators**.

### Classification

A generator is **primitive** when it depends on at most one other top-50 generator.
A generator is **derived** when it applies two or more top-50 generators.
The primitive/derived split was computed via:

```cypher
MATCH (d:Definition {namespace: 'OmegaTheoryV2'}) WHERE d.name IN $top50
OPTIONAL MATCH (d)-[:APPLIES|UNFOLDS]->(d2:Definition) WHERE d2.name IN $top50
WITH d, count(DISTINCT d2) AS dep_on_top
RETURN d.name, dep_on_top
```

### Table — 26 primitive generators

| # | Generator | Usage | Tier | Category |
|---|---|---|---|---|
| 1 | `LatticePoint` | 1724 | 0 | spacetime lattice |
| 2 | `l_P` | 698 | 0 | Planck length |
| 3 | `sqrt2_error_val` | 206 | 0 | irrational residual |
| 4 | `pi_error_val` | 202 | 0 | irrational residual |
| 5 | `FermionGeneration` | 200 | 0 | generation label |
| 6 | `ErrorBound` | 197 | 0 | error type |
| 7 | `ErrorBoundedSmoothMetric` | 172 | 1 | metric variant |
| 8 | `PhotonCoherenceWorldline` | 165 | 3 | photon infrastructure |
| 9 | `Event` | 160 | 0 | event structure |
| 10 | `ScalarField` | 156 | 1 | real scalar field |
| 11 | `HealingParams` | 153 | 1 | healing flow tuple |
| 12 | `e_error_val` | 129 | 0 | irrational residual |
| 13 | `gravRedshiftCost` | 120 | 2 | DE reservoir carrier |
| 14 | `SmoothMetric` | 107 | 1 | metric variant |
| 15 | `SemiSmoothMetric` | 104 | 1 | metric variant |
| 16 | `IrrationalChannel` | 99 | 0 | channel type (π/e/√2/G) |
| 17 | `MetricTensor` | 95 | 1 | metric variant |
| 18 | `SnapshotSequence` | 88 | 2 | RG sequence |
| 19 | `SmoothMetricField` | 81 | 2 | field of metrics |
| 20 | `BlackHole` | 79 | 3 | BH structure |
| 21 | `DynamicalSnapshotSequence` | 77 | 3 | dynamical RG |
| 22 | `relativisticEnergy` | 68 | 3 | relativistic E |
| 23 | `M_GUT_substrate` | 64 | 3 | GUT scale |
| 24 | `alpha_EM_PDG` | 61 | 3 | measured α_EM |
| 25 | `PhotonWorldline` | 59 | 2 | photon path |
| 26 | `SubstrateState` | 58 | 2 | substrate state |

Plus classical constants not present as standalone definitions but used as literal values:
`c`, `hbar`, `G_N`, `k_B`.

### Table — 24 derived generators

| # | Generator | Usage | Tier | Dependencies |
|---|---|---|---|---|
| 1 | `DiscreteMetric` | 567 | 1 | LatticePoint, MetricTensor |
| 2 | `computationalUncertainty` | 322 | 1 | l_P |
| 3 | `shiftFin` | 198 | 1 | LatticePoint |
| 4 | `discreteLaplacian` | 156 | 2 | ScalarField, LatticePoint |
| 5 | `InformationDensity` | 154 | 2 | ScalarField |
| 6 | `ricciTensor` | 131 | 2 | DiscreteMetric, LatticePoint |
| 7 | `shiftBackFin` | 130 | 1 | LatticePoint |
| 8 | `LatticeComplexField` | 129 | 2 | LatticePoint |
| 9 | `PhotonWorldline.pathLength` | 129 | 3 | PhotonWorldline |
| 10 | `Discrete1Form` | 128 | 2 | LatticePoint |
| 11 | `Discrete2Form` | 100 | 2 | LatticePoint |
| 12 | `forwardDiff` | 100 | 1 | ScalarField, LatticePoint, l_P, shiftFin |
| 13 | `E_P` | 95 | 1 | t_P |
| 14 | `latticeEmbed` | 94 | 3 | l_P, LatticePoint |
| 15 | `informationDensityKL` | 77 | 3 | DiscreteMetric, LatticePoint |
| 16 | `HpwEliminableRegime` | 74 | 3 | DiscreteMetric |
| 17 | `IrrationalChannel.sqrt2` | 73 | 0 | IrrationalChannel |
| 18 | `inverseMetric` | 72 | 1 | MetricTensor |
| 19 | `channelToGeneration` | 72 | 2 | IrrationalChannel |
| 20 | `MetricPath` | 68 | 3 | DiscreteMetric |
| 21 | `Discrete0Form` | 66 | 1 | ScalarField |
| 22 | `t_P` | 64 | 1 | l_P |
| 23 | `higgs_vev` | 64 | 3 | computationalUncertainty |
| 24 | `defectTensor` | 63 | 3 | DiscreteMetric, LatticePoint |
| 25 | `coarseGrain` | 59 | 3 | SnapshotSequence, LatticePoint, LatticeComplexField |

### Redundancy check

Composite-embedding cosine-similarity scan on the 50-generator set returned three
pairs above 0.85:

| A | B | cosine | verdict |
|---|---|---|---|
| `gravRedshiftCost` | `E_P` | 0.952 | NOT redundant — E_P is energy unit, gravRedshiftCost the reservoir integral |
| `E_P` | `t_P` | 0.942 | NOT redundant — E_P = ℏ/t_P, dimensionally derived |
| `gravRedshiftCost` | `t_P` | 0.862 | NOT redundant — shared-usage pattern only |

**Conclusion**: the 50-generator set is non-redundant. The high cosines reflect
co-occurrence in the same proofs, not definitional overlap.

---

## F2 — Canonical naming scheme

Each generator carries three handles: **ASCII symbol** for code/LaTeX source,
**LaTeX command** for the paper, and **role gloss** for docs. Greek letters for
fields and couplings, Roman for observables, fraktur for tier-0 primitives.

### Master renaming table (55 rows)

| Lean name | ASCII | LaTeX | Role |
|---|---|---|---|
| `LatticePoint` | `L` | `\mathfrak{L}` | tier-0 ℤ^4 Planck lattice |
| `l_P` | `lP` | `\ell_P` | tier-0 Planck length |
| `c` | `c` | `c` | tier-0 speed of light |
| `hbar` | `hbar` | `\hbar` | tier-0 Planck constant |
| `G_N` | `G` | `G_N` | tier-0 Newton constant |
| `k_B` | `kB` | `k_B` | tier-0 Boltzmann constant |
| `E_P` | `EP` | `E_P = \hbar/t_P` | tier-1 derived Planck energy |
| `t_P` | `tP` | `t_P = \ell_P/c` | tier-1 derived Planck time |
| `DiscreteMetric` | `d` | `d_P` | tier-1 discrete metric on L |
| `MetricTensor` | `g` | `g_{\mu\nu}` | tier-1 smooth metric field |
| `SmoothMetric` | `g_sm` | `g^{\mathrm{sm}}` | tier-1 coarse-grained metric |
| `ErrorBoundedSmoothMetric` | `g_E` | `g^{E}` | tier-1 ErrorBound-bounded metric |
| `SemiSmoothMetric` | `g_def` | `g^{\mathrm{def}}` | tier-1 defect-allowing metric |
| `inverseMetric` | `g_inv` | `g^{\mu\nu}` | tier-1 inverse metric |
| `ricciTensor` | `Ric` | `R_{\mu\nu}` | tier-2 curvature |
| `computationalUncertainty` | `epsilon` | `\varepsilon_{\mathrm{comp}}` | tier-1 aggregate error |
| `ErrorBound` | `E` | `\mathcal{E}` | tier-0 error type |
| `pi_error_val` | `delta_pi` | `\delta_\pi` | tier-0 π residual |
| `e_error_val` | `delta_e` | `\delta_e` | tier-0 e residual |
| `sqrt2_error_val` | `delta_r2` | `\delta_{\sqrt{2}}` | tier-0 √2 residual |
| `IrrationalChannel` | `chi` | `\chi` | tier-0 channel label (π/e/√2/G) |
| `channelToGeneration` | `kappa` | `\kappa\colon\chi\to\mathcal{F}` | tier-2 channel→generation bijection |
| `FermionGeneration` | `F` | `\mathcal{F}` | tier-0 generation labels |
| `ScalarField` | `Phi` | `\Phi` | tier-1 real scalar |
| `LatticeComplexField` | `Psi` | `\Psi` | tier-2 complex lattice wavefunction |
| `higgs_vev` | `v` | `v_H` | tier-3 Higgs vev |
| `InformationDensity` | `rho_I` | `\rho_{\mathcal{I}}` | tier-2 info density |
| `informationDensityKL` | `rho_KL` | `\rho^{\mathrm{KL}}` | tier-3 KL info density |
| `HealingParams` | `H` | `\mathsf{H}` | tier-1 healing tuple (μ, ρ, …) |
| `HealingParams.mu` | `mu` | `\mu` | tier-1 healing damping |
| `PhotonCoherenceWorldline` | `Gamma_ph` | `\Gamma_\gamma` | tier-3 photon coherent worldline |
| `PhotonWorldline` | `gamma` | `\gamma` | tier-2 underlying photon path |
| `PhotonWorldline.pathLength` | `ell_gamma` | `\ell_\gamma` | tier-3 photon worldline length |
| `PhotonCoherenceWorldline.energy` | `E_gamma` | `E_\gamma` | tier-3 photon energy |
| `gravRedshiftCost` | `Delta_rs` | `\Delta_{\mathrm{rs}}` | tier-2 DE reservoir gain |
| `relativisticEnergy` | `E_rel` | `E^{\mathrm{rel}}` | tier-3 relativistic energy |
| `shiftFin` | `S_plus` | `S^{+}_\mu` | tier-1 forward lattice shift |
| `shiftBackFin` | `S_minus` | `S^{-}_\mu` | tier-1 backward lattice shift |
| `discreteLaplacian` | `Box_L` | `\Box_{\mathfrak{L}}` | tier-2 discrete d'Alembertian |
| `forwardDiff` | `d_plus` | `\mathrm{d}^{+}_\mu` | tier-1 forward difference |
| `Discrete0Form` | `Omega0` | `\Omega^0` | tier-1 discrete 0-form |
| `Discrete1Form` | `Omega1` | `\Omega^1` | tier-2 discrete 1-form |
| `Discrete2Form` | `Omega2` | `\Omega^2` | tier-2 discrete 2-form |
| `defectTensor` | `D_def` | `D_{\mathrm{def}}` | tier-3 defect tensor |
| `HpwEliminableRegime` | `R_HPW` | `\mathcal{R}_{\mathrm{HPW}}` | tier-3 HPW-bypass regime |
| `SnapshotSequence` | `Sigma` | `\Sigma_n` | tier-2 RG snapshot sequence |
| `DynamicalSnapshotSequence` | `Sigma_dyn` | `\Sigma^{\mathrm{dyn}}_n` | tier-3 dynamical snapshots |
| `SmoothMetricField` | `G_sm` | `\mathcal{G}^{\mathrm{sm}}` | tier-2 smooth metric field |
| `coarseGrain` | `C` | `\mathcal{C}` | tier-3 coarse-graining functor |
| `latticeEmbed` | `iota` | `\iota` | tier-3 lattice→continuum embedding |
| `Event` | `Ev` | `\mathrm{Ev}` | tier-0 error-bounded smooth event |
| `BlackHole` | `BH` | `\mathcal{B}` | tier-3 black hole structure |
| `SubstrateState` | `sigma` | `\sigma` | tier-2 substrate state |
| `MetricPath` | `gamma_g` | `\gamma_g` | tier-3 metric path |
| `alpha_EM_PDG` | `alpha_EM` | `\alpha_{\mathrm{EM}}^{\mathrm{PDG}}` | tier-3 measured fine structure |
| `M_GUT_substrate` | `M_GUT` | `M_{\mathrm{GUT}}^{\mathrm{sub}}` | tier-3 substrate GUT scale |

### Naming principles
1. **Tier-0** (fundamental): fraktur or single Roman letter (L, c, ℏ, G, k_B) or δ_·
2. **Tier-1** (metrics, errors, first derivatives): lowercase Roman (g, d) with variant superscripts
3. **Tier-2** (operators, forms, curvature): Greek caps for forms (Ω^k, Σ_n), operators as 𝗗 or □
4. **Tier-3** (composed structures): calligraphic or subscripted (𝓑, 𝓒, γ_g)
5. **Greek allocation fully consistent with standard physics**: α (coupling), δ (residual),
   ε (uncertainty), κ (map), Λ (CC, elsewhere), μ (damping/muon), ν (neutrino), π (irrational),
   ρ (density), σ (state), Φ (scalar), Ψ (wavefunction), χ (channel), γ (photon).
   No collision with Λ-CC because Λ is not a generator — it is an observable that equals
   `gravRedshiftCost · (lookback_integral)` in the reservoir derivation.

---

## F3 — Cross-sector interactions

Semantic clusters built by regex over theorem names (robust alternative to
Achird's SubtopologyV3 numeric IDs, since SubtopologyV3 nodes have no `:CONTAINS`
edges to individual theorems):

| Cluster | Regex pattern | # theorems |
|---|---|---|
| EM | photon, U1Gauge, AlphaEM, electromagnet, Maxwell, ChargeQuantiz | 286 |
| Weak (W) | SU2, weakCoupling, WBoson, ZBoson, ElectroWeak, WeinbergAngle, MNS, PMNS | 308 |
| Strong (S) | SU3, strongCoupl, QCD, gluon, NonAbelianGauge, colorConfin | 176 |
| Gravity (G) | ricci, curv, Einstein, metric, geodesic, Schwarzschild, BlackHole | 857 |
| Dark Energy (DE) | darkEnergy, CosmologicalConstant, reservoir, gravRedshift, HubbleTens | 301 |
| Dark Matter (DM) | sterileNeutrino, darkMatter, fourthIrrational, FourthChannel | 30 |
| Fermion/Higgs (F) | fermion, quark, lepton, Yukawa, electronMass, higgs, CKM | 849 |

### Cross-sector APPLIES matrix (directed edges)

```
                TO
           EM    W    S    G   DE   DM    F
     EM     -    0    2    4   27    0    2
     W      2    -    0    0    0    0   31
FROM S      4    0    -    4    0    0    3
     G      6    0   15    -    1    0    3
     DE    10    0    0   16    -    0    0
     DM     0    0    0    0    0    -    0
     F      0   30    3    3    0    0    -
```

**Total edges per pair (undirected):**
- W↔F: 61 (Yukawa, strongest intra-matter)
- EM↔DE: 37 (reservoir, strongest inter-sector)
- G↔S: 19 (non-abelian gauge on curved background)
- DE↔G: 17 (Hawking, Λ)
- EM↔G: 10 (photon redshift)
- S↔EM: 6 (photon no-self-coupling, BaryonPhoton ratio)
- F↔S: 6 (top width)
- **EM↔W DIRECT: 2** — the critical gap
- **DM↔anything: 0** — the predicted decoupling
- **DE↔F: 0** — no direct coupling

---

### 3a. EM ↔ Weak

- **Direct APPLIES edges**: 2 (W→EM both from Predictions.BaryonPhotonRatio)
- **Does `electroweak_unification` exist?** — PARTIAL. Found:
  - `SymmetryBreaking.electroweakDim_eq` (dimension counting)
  - `SymmetryBreaking.electroweak_goldstones_eq_weak_bosons` (Goldstone count)
  - `HiggsSelfCouplingFit.electroweak_vacuum_stable`
- **Weinberg angle at runtime?** — yes: 20 theorems including
  `weinberg_angle_at_GUT_substrate`, `sin2_theta_W_GUT_SU5_eq_three_eighths`.
  BUT they bind Weinberg to the SU(5) GUT window, not to the substrate-level
  U(1)_Y × SU(2)_L → U(1)_EM symmetry breaking.
- **Missing**: a single `substrate_electroweak_unification_theorem` showing that
  U(1) and SU(2) substrate connections share `Aut(OmegaErrorAlgebra)` origin.
- **Priority**: **HIGH — cycle 24**.

### 3b. EM ↔ Gravity

- **Direct APPLIES edges**: 10 (EM→G: 4, G→EM: 6)
- **Does `PhotonGravityCoupling` exist?** — **YES**:
  `OmegaTheory.Emergence.PhotonGravitationalFieldCoupling_holds`. Plus:
  - `photon_grav_field_matches_alnasl_mediator`
  - `photon_grav_field_matches_alcor_reverse`
  - `PhotonRedshiftForField_nonneg / _le_ceiling`
  - `photon_energy_transfer_to_gravitational_field`
  - `u1_maxwell_noether_from_potential_closed_on_compact_patch`
- **Expected bridge (photon redshift in metric)** — COMPLETE.
- **Priority**: **MEDIUM** — `photonSubstrateMassBound` should couple directly to
  `ricciTensor`; currently the route goes through `gravRedshiftCost` as intermediate.
  Nice-to-have, not a blocker.

### 3c. Dark Matter ↔ Dark Energy

- **Direct APPLIES edges**: 0.
- **Bridging theorem?** — **NONE EXISTS**. No Ω_total=1 closure theorem anywhere
  in the corpus. `HubbleConstantFit`, `CosmologicalHorizon`, `CosmologicalConstantFit`,
  `DESI substrate signature` are all present individually but no theorem combines
  them into Ω_M + Ω_DM + Ω_Λ = 1.
- **Expected bridge**: `omega_total_closure_theorem : Ω_M + Ω_DM + Ω_Λ = 1`
  with DM mass-floor from `SterileNeutrinoFromFourthIrrational.sterileNeutrinoMassFloor_pos`
  and DE amplitude from `HubbleTension.H0amplitude`.
- **Priority**: **HIGH — cycle 25**.
  Requires: an Ω_M definition (absent), Ω_DM link to sterile-neutrino energy density,
  Ω_Λ link to `gravRedshiftCost` lookback integral.

### 3d. Dark Matter ↔ SM (gauge, other than gravity)

- **Direct APPLIES edges**: 0 (confirmed across DM→SU2, DM→SU3, DM→Fermion, DM→EM).
- **Named bridge?** — the anti-bridge exists and is PROVED:
  - `OmegaTheory.Predictions.HeavyNeutralLeptonBound.sterile_decoupled_from_SM`
  - `OmegaTheory.Predictions.DarkPhotonKineticMixingBound.dark_sector_decoupled_strict`
- **Interpretation**: decoupling is a **theorem-level prediction** of the theory,
  not a missing derivation. The fourth irrational (Catalan G / …) does not project
  onto any SM representation. This matches Achird Q2.
- **Priority**: **CLOSED** — nothing to add.

### 3e. Dark Energy ↔ SM matter (fermions / Higgs)

- **Direct APPLIES edges**: 0 (DE→F and F→DE both zero).
- **Indirect chain?** — **YES**: EM→DE (27) + W↔F (61) + DE↔EM (10 back) forms
  the canonical chain DE ← photon → matter via electroweak.
- **Sakharov / baryogenesis bridge?** — PRESENT: 26 baryogenesis theorems including
  `baryogenesis_sakharov_substrate`, `eta_bary_eq_PDG`, `eta_bary_gt_1e_neg_10`.
  These couple CP-violating phases (matter sector) to the baryon asymmetry
  (cosmology), which is the closest we have to direct DE ↔ matter.
- **Interpretation**: the absence of a direct DE↔F edge is a **theorem prediction**:
  dark energy is a geometric reservoir (accumulator of `gravRedshiftCost`), not a
  particle. It couples to matter only through photons (energy loss) and gravity
  (metric).
- **Priority**: **LOW** — not a gap, a prediction.

---

## Summary table — 5 channels ranked

| # | Channel | Direct edges | Bridge exists? | Status | Priority | Roadmap wave |
|---|---|---|---|---|---|---|
| 1 | EM ↔ Weak | 2 | partial (Weinberg, EW dim-count) | **GAP** | HIGH | cycle 24 |
| 2 | EM ↔ Gravity | 10 | `PhotonGravitationalFieldCoupling_holds` | complete | MEDIUM | optional |
| 3 | DM ↔ DE | 0 | none (Ω_total=1 missing) | **GAP** | HIGH | cycle 25 |
| 4 | DM ↔ SM (non-grav) | 0 | `sterile_decoupled_from_SM` proves ABSENCE | complete | CLOSED | — |
| 5 | DE ↔ F (matter) | 0 | Sakharov chain (indirect) | complete | LOW | — |

### Two paper-worthy gaps
1. **`substrate_electroweak_unification_theorem`** — replace dimension-counting +
   GUT-angle with a bona-fide substrate derivation of U(1) × SU(2) → U(1)_EM.
   Required inputs exist (ErrorGaugeField, NonAbelianGauge, HiggsFromError,
   SymmetryBreaking).
2. **`omega_total_closure_theorem`** — Ω_M + Ω_DM + Ω_Λ = 1 from the substrate
   reservoir + sterile-mass-floor + baryogenesis chain. Closes the cosmological
   sector and unifies Enif's cycle-15 cosmology TheoremCandidates.

---

## Methodology notes (Cypher-native, zero Python)

All queries ran in Neo4j. The OmegaAlgebra audit used:
- `MATCH ... APPLIES|UNFOLDS` in-degree aggregation on Definition nodes.
- Self-join on top-50 list to classify primitive vs. derived by depth-1 dependency.
- `reduce(s=0.0, i IN range(0, size(a.composite_proj)-1) | s + a.composite_proj[i]*b.composite_proj[i])`
  for cosine redundancy check, purely in Cypher.
- Regex clustering for F3 rather than chasing Achird's SubtopologyV3 integer IDs
  (those nodes have no `:CONTAINS` edges; Achird correlated via centroid vectors,
  a path that no longer exists for newly-ingested theorems).

The three findings are persisted as GraphFinding nodes under `namespace: OmegaTheoryV2`
and tagged `paper_worthy: true`:
- `algieba_F1_omega_algebra_complete_generator_audit`
- `algieba_F2_omega_algebra_canonical_names`
- `algieba_F3_cross_sector_interaction_audit`
