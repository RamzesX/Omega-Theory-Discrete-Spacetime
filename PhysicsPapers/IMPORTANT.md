# OmegaTheory V2 — What To Do Next (Master Expansion Roadmap)

**Last updated**: 2026-04-17. Read this FIRST before starting any work.

---

## Current State (verified GREEN, 3475 jobs)

```
8 axioms (physical constants ONLY — c, ℏ, G, k_B + positivity)
0 sorry
0 mathematical axioms (HPW deleted by Atria)
~160 Lean files, ~1750+ theorems
Lean v4.29.0 + Mathlib v4.29.0
```

### What's DONE (don't redo these)

| Area | Status | Key files |
|------|--------|-----------|
| QM (10 postulates) | ✅ | QuantumMechanicsCapstone, HilbertEmergence |
| GR (Einstein eq, 7 regimes) | ✅ | EinsteinEmergence, HpwMinkowski→HpwKerr |
| U(1) gauge + photon mass | ✅ | ErrorGaugeField |
| SU(2) gauge + W/Z mass | ✅ | ErrorGaugeSU2 |
| SU(3) gauge + gluon mass | ✅ | ErrorGaugeSU3 |
| Higgs = δ_comp | ✅ | HiggsFromError, SymmetryBreaking |
| Connes spectral action | ✅ | ConnesSpectralAction (A_F = ℂ⊕ℍ⊕M₃(ℂ)) |
| Dark energy w=-1 | ✅ | CosmologicalConstant |
| Λ problem resolved | ✅ | CosmologicalConstantProblem |
| Inflation | ✅ | Inflation |
| Big Bounce | ✅ | NegativePressure, BigBounce |
| Klein-Gordon | ✅ | KleinGordon |
| Dirac equation | ✅ | DiracEquation |
| Path integral | ✅ | PathIntegral |
| CHSH Bell (2√2) | ✅ | CHSHBell |
| ErrorLieAlgebra | ✅ | ErrorLieAlgebra |
| ErrorForms + Maxwell | ✅ | ErrorForms |
| ErrorHopf | ✅ | ErrorHopfStructure |
| Whitney interpolant | ✅ | WhitneyInterpolant |
| Dark matter framework | ✅ | DarkMatter, RotationCurves |
| 20 predictions | ✅ | Predictions/*.lean |
| PRL letter package | ✅ | Letter-ColdNeutron-*.md/.tex |

---

## TOP PRIORITY: Matter Sector (0% → target 80%)

**The biggest gap**: gauge sector is 100% but matter sector is 0%. No quarks, no leptons, no flavors, no generations, no Yukawa couplings, no CKM/PMNS matrices.

### Phase 1: Fermion content from Connes (weeks)
The finite algebra `A_F = ℂ ⊕ ℍ ⊕ M₃(ℂ)` in `ConnesSpectralAction.lean` already IMPLIES the fermion content. The irreducible representations of A_F give:
- **Left-handed doublets**: (ν_L, e_L) under SU(2)
- **Right-handed singlets**: e_R, ν_R under SU(2)
- **Color triplets**: (u, d) quarks under SU(3)
- **3 generations**: from the multiplicity structure

**Files to create**:
1. `OmegaTheory/Emergence/FermionContent.lean` — derive fermion quantum numbers from A_F representations
2. `OmegaTheory/Emergence/LeptonSector.lean` — electron, muon, tau + neutrinos
3. `OmegaTheory/Emergence/QuarkSector.lean` — up/down × 3 generations × 3 colors
4. `OmegaTheory/Emergence/YukawaCouplings.lean` — fermion masses from Connes D_F operator

### Phase 2: Mixing matrices (weeks)
5. `OmegaTheory/Emergence/CKMMatrix.lean` — quark mixing (Cabibbo-Kobayashi-Maskawa)
6. `OmegaTheory/Emergence/PMNSMatrix.lean` — neutrino mixing (Pontecorvo-Maki-Nakagawa-Sakata)
7. `OmegaTheory/Emergence/AnomalyCancellation.lean` — gauge anomalies cancel (consistency check)

### Phase 3: Mass derivation (months — CAPSTONE)
8. `OmegaTheory/Emergence/FiniteDiracOperator.lean` — D_F on A_F, eigenvalues = Yukawa
9. `OmegaTheory/Emergence/ParticleMasses.lean` — derive actual masses from D_F eigenvalues
10. **3 irrationals → 3 generations hypothesis**: test if π/e/√2 convergence rates map to mass ratios

---

## ALGEBRAIC GAPS (fixable, high impact)

### Gap 1: su(3) Jacobi identity
**File**: `ErrorGaugeSU3.lean`
**Problem**: Jacobi identity is a HYPOTHESIS (`hJ` parameter), not proved
**Fix**: use `fin_cases` with `set_option maxHeartbeats 4000000` — exhaustive check over 8³ = 512 components
**Impact**: removes hypothesis from all downstream SU(3) theorems

### Gap 2: Non-abelian gauge curvature F = dA + [A,A]
**File**: needs `ErrorGaugeNonAbelian.lean`
**Problem**: only abelian F = dA exists (ErrorGaugeField). Non-abelian F = dA + A∧A not assembled
**Fix**: compose `errorD1` from ErrorForms with `errorWedge11` and su2/su3 brackets
**Impact**: enables gluon self-coupling, W self-interaction, full Yang-Mills

### Gap 3: Clifford off-diagonal
**File**: `DiracEquation.lean`
**Problem**: {γ^μ, γ^ν} = 2η^{μν}·I proved for μ=ν (4 cases), hypothesized for μ≠ν (12 cases)
**Fix**: explicit 4×4 matrix multiplication for each of the 12 cases with `native_decide` or `fin_cases`
**Impact**: full D² = Klein-Gordon without hypothesis

---

## PREDICTION EXPANSION

### From existing machinery (session-scale each):
- **Vacuum birefringence** from polarization-dependent error in ErrorForms
- **Holonomy quantization defect** from ErrorGaugeField plaquette error  
- **Graviton detection impossibility** from BekensteinBound + Gravitons
- **Information-theoretic second law** from LaSalleKLBridge entropy ceiling
- **Proton decay rate** from approximate SU(3) gauge symmetry (error-bounded)
- **Neutrinoless double beta decay** from Majorana mass structure
- **Anomalous magnetic moment g-2 correction** from substrate error on electron vertex

### From new machinery (after matter sector):
- **Particle mass predictions** from Connes D_F eigenvalues
- **CKM matrix angles** from D_F off-diagonal structure
- **Neutrino mass hierarchy** from D_F + 3-irrational structure
- **Baryon asymmetry** from CP violation in substrate

---

## TOOLS & TACTICS

### Lean proof automation (USE BEFORE manual proof)
```lean
exact?       -- search 210K+ Mathlib lemmas + local (30s, MOST POWERFUL)
apply?       -- find applicable lemmas
aesop        -- multi-step automated search
grind        -- SMT solver (Gröbner + cutsat)
positivity   -- auto-prove 0 < x
ring         -- ring equalities
field_simp   -- clear denominators
linarith     -- linear arithmetic
decide       -- exhaustive finite check
omega        -- integer arithmetic
```

### Mathlib v4.29.0 name changes (CRITICAL)
```
div_le_iff₀  NOT div_le_iff   (₀ suffix!)
div_lt_iff₀  NOT div_lt_iff
mul_div_cancel₀  NOT mul_div_cancel
Finset.not_mem_empty  NOT Finset.mem_empty
```

### Build (WSL-native, NEVER wsl.exe)
```bash
~/.elan/bin/lake build --log-level=error                    # full
~/.elan/bin/lake build OmegaTheory.Module --log-level=error # single
```

### Hard rules
1. **0 sorry** — absolutely never
2. **0 new axioms** — project has exactly 8 physical constants
3. **Must compile GREEN** before reporting done
4. **Register new files** in `OmegaTheory/Basic.lean`
5. **Quality over speed** — iterate until clean

---

## CUSTOM AGENTS (in `.claude/agents/`)

| Agent | Role | Use when |
|-------|------|----------|
| `lean-proof-wizard` | Lean 4 specialist, all tactics | Proving theorems, fixing builds |
| `quantum-physics-creative` | Wild physics ideas | Finding new connections, literature |

These agents work as a PAIR: creative proposes → wizard formalizes.

---

## ARCHITECTURE OVERVIEW

```
8 AXIOMS (c, ℏ, G, k_B + positivity)
         │
    ℤ⁴ LATTICE × ErrorAlgebra
         │
    ┌────┼────┐
    │    │    │
  ERROR  IRRAT  GAUGE
  GEOM   π/e/√2  Lie+Forms
    │    │    │
    │  δ_comp  CONNES A_F
    │    │    ℂ⊕ℍ⊕M₃(ℂ)
    │    │    │
    ├────┼────┤
    │         │
 HEALING    U(1)×SU(2)×SU(3)
  FLOW         │
    │      HIGGS = δ_comp
    │         │
 ┌──┴──┐   MASSES
 │     │     │
GR    QM    SM ← MATTER SECTOR (TODO!)
 │     │     │
Einstein  10    20
 eqs   post  predictions
```

## NEO4J

NavigationMaster graph loaded (when Docker is up):
```bash
docker exec -i math cypher-shell -u neo4j -p omegatheory2026 \
  < LeanFormalizationV2/.neo4j/navigation_master_v2.cypher
```

## KEY REFERENCE DOCS (in this repo)
- `STRATEGIC_EXPANSION_PLAN.md` — full 1-20 item plan with dependency graph
- `PREDICTION_GAP_ANALYSIS.md` — 20+ unformalised predictions
- `PARTICLE_INTERACTION_MAP.md` — SM coverage: gauge 100%, matter 0%
- `OPERATOR_STRUCTURE_MAP.md` — all operators + algebraic gaps
- `GAUGE_THEORY_RESEARCH.md` — Connes + Wilson + SimilarityAlgebra path
- `CODEBASE_MAP.md` — NavigationMaster 6-entity model
- `AXIOM_TRANSPARENCY_AUDIT.md` — HPW blast radius (now deleted)
- `CONSTANT_CHAIN_AUDIT.md` — 0 discrepancies across 24 constants
- `NOTES_HPW_ELIMINATION.md` — full HPW elimination history

---

**The dream**: derive the masses of ALL elementary particles from first principles.
**The pathway**: Connes D_F eigenvalues + 3 irrationals (π/e/√2) → 3 generations.
**Build the machinery first**, then tackle the capstone.
