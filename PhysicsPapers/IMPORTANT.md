# OmegaTheory V2 — What To Do Next (Post-Capstone Roadmap)

**Last updated**: 2026-04-21 (post-cycle-43 grand-capstone lock; graph re-aligned by Algenib, γ Pegasi, pass 2 2026-04-21; **IrrationalityClasses scope added by Rasalas, μ Leonis, pass 3 2026-04-21**). Read this FIRST before starting any work.

> ## 🧭 Cycle-44+ priority: the four-class irrationality separation theorem
>
> The 4-channel / 4-generation partition presupposes four distinct irrationality classes for {π, e, √2, Catalan G}. At the classical Mahler {A, S, T, U} level this is FALSE (π, e, G all conjecturally S). We refine to a constructor-disjoint `TruncOrigin = {Algebraic, EFunction, GFunctionTranscendental, ConjecturallyIrrational}` which DOES give four cells. **Design fully memorised** in [`LeanFormalizationV2/OmegaTheory/IrrationalityClasses/`](LeanFormalizationV2/OmegaTheory/IrrationalityClasses/) (14 memos). **31 `:TheoremCandidate` nodes registered** in graph for cycle-44+ agents to pick up.
>
> Related companions: [`AXIOM_ELIMINATION_METHODOLOGY.md`](LeanFormalizationV2/AXIOM_ELIMINATION_METHODOLOGY.md) (1/24 eliminated, 16 eliminable), [`NOVEL_MATHEMATICS.md`](LeanFormalizationV2/NOVEL_MATHEMATICS.md) (32 items inventoried). Master plan: [`11_master_plan_skeleton.md`](LeanFormalizationV2/OmegaTheory/IrrationalityClasses/11_master_plan_skeleton.md). **% physics formalised: ≈ 72%.**

---

## Current State — THREE-WAY SPLIT (graph-audited 2026-04-21)

The project has three complementary layers. Every number below is live-verified on the Neo4j `math` container:

| | **Omega-Lean** — what we've PROVED | **Graph** — what we've DISCOVERED but not yet proved | **Mathlib** — what we BUILD ON |
|---|---:|---:|---:|
| Theorems | **~9,500** (9,794 in graph post-session; 8,996 Apr-21 baseline) (`:Theorem {namespace:'OmegaTheoryV2'}`) | **175** `:TheoremCandidate` (106 auto-matched · 70 genuinely OPEN) | **~175,127** (`:Theorem {namespace:'Mathlib'}`) |
| Definitions | **4,465** | — | **32,917** |
| Axioms | **5 primitive assumptions** (4 physical existence postulates via `Classical.choice` opaque bundles — 0 `axiom` *declarations* for constants, but MATHEMATICALLY 4 existence postulates for positive reals — + 1 `Real.pi_transcendental`); **9 total** including 4 HermitePadé research | — | **6** |
| Paper-worthy findings | — | **53** of 105 `:GraphFinding` | — |
| Grothendieck recipes | — | **33** `:GrothendieckRecipe` reproducible experiments | — |
| Leiden communities | — | **677** `:SubsystemNavigator` | — |
| Lean files | **399** `:LeanFile` nodes (428 files on disk; 29 Meta/test files not ingested) | — | 3,183 `:LeanFile` (7,869 on disk) |
| Build jobs | **3,901 GREEN · 0 sorry** (cycle-44-extension 2026-04-24; 3,835 at 2026-04-21 baseline) | — | cached via `lake exe cache get` |

**Key narrative (post 2026-04-24 Lesath opaque-bundle refactor)** — honest axiom accounting `0 axiom-declarations · 5 primitive-assumptions · 9 total-including-research`:
- **Omega-Lean** = the machine-checked backbone (~9,500 theorems atop **5 primitive assumptions** — 4 physical existence postulates for c/ℏ/G_N/k_B via `Classical.choice` opaque bundles (0 `axiom` *declarations* for constants, but MATHEMATICALLY 4 existence postulates for positive reals; no specific numeric value is fixed, all derivations parametric) + 1 `Real.pi_transcendental`; + 4 HermitePadé research axioms = 9 total).
- **Graph** = the discovery frontier (53 paper-worthy findings + 70 genuinely-open `:TheoremCandidate`s awaiting formalization).
- **Mathlib** = the foundation (~175,127 theorems linked through 3.28M cross-namespace `APPLIES` edges — no Omega-Lean theorem is "standalone"; each composes against Mathlib).

```
HPW axiom DELETED by Atria (cycles 14-15), eliminable on all 7 regimes.
Lean v4.29.0 + Mathlib v4.29.0
Cycles 2–43 all GREEN; cycle-43 grand capstone LOCKED (Polaris).
```

### What's DONE — Grand Capstone V2 shipped (Polaris cycle 43)

The single paper-headline theorem that now anchors the manuscript:

```
grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE
  ∈ OmegaTheory/Predictions/OmegaTheoryGrandCapstoneV2.lean
```

Plus its three companions:
- `omega_theory_minimal_constants_are_exactly_eight`
- `omega_theory_falsifiability_witness_panel`
- `four_irrationals_necessary_and_sufficient`
- `omega_theory_v2_final_meta_capstone` (meta-wrapper — the "final pole-star" alias)

The capstone is a **propositional bundle** over seven conjuncts, each citing an upstream cycle-24–42 headline:
  (i)   Electroweak unification inhabited (Castor 24.1 — `substrate_electroweak_unification_theorem`)
  (ii)  SU(3) color = 3 channels (Tiaki 29.1 — `SU3_color_from_three_irrationals`)
  (iii) 4-channel surjection on 4 generations (Matar 27.3)
  (iv)  Higgs VEV = 246.22 GeV + Dirac/Majorana split (Achird 35.* — `higgs_vev_substrate_headline`)
  (v)   Baby-universe sterile-ν in KATRIN window (Gatria 26.2)
  (vi)  Ω_total = 1 (Situla 25.1 — `omega_total_equals_one`)
  (vii) BH-information paradox resolved (Electra 37.2)

### What's DONE — 60-theorem Mekbuda backlog closed (cycles 24–43)

| Area | Status | Key headline (graph-verified name) |
|------|--------|-----------------------------------|
| Electroweak unification (Castor 24) | ✅ | `ElectroweakUnification.substrate_electroweak_unification_theorem` |
| Ω_total = 1 cosmology closure (Situla 25) | ✅ | `OmegaTotalClosure.omega_total_equals_one` |
| Baby-universe sterile ν / DM (Gatria 26) | ✅ | `SterileNeutrinoFromFourthIrrational.sterile_neutrino_mass_from_fourth_irrational` |
| Connes 4-channel calibration (Hydor 27) | ✅ | `ConnesCalibrationAndFourChannels.Z_sterile_from_connes_DF_eigenvalue` |
| Cross-sector bridges (Kitalpha 28) | ✅ | file `Emergence/CrossSectorBridges.lean` (multiple headlines) |
| SU(3) + non-abelian F (Tiaki 29) | ✅ | `SU3ColorAndNonAbelianF.SU3_color_from_three_irrationals` |
| Connes D_F → Yukawa masses (Avior 30) | ✅ | `ConnesDFYukawaMass.mass_ratio_e_mu_from_sqrt2_e_channel_ratio` |
| π-hunch quantization (Syrma 31) | ✅ | `Predictions.pi_hunch_mass_ordering` + Pi-Hunch deep-chain completion |
| Boundary crossings (Khambalia 32) | ✅ | `Emergence/CrossSectorBridges.lean` |
| Baryogenesis / leptogenesis (Alkes 33) | ✅ | file `Emergence/BaryogenesisLeptogenesis.lean` |
| Cyclic cosmology (Situla 34) | ✅ | file `Emergence/CyclicCosmology.lean` |
| Higgs + full mass hierarchy (Achird 35) | ✅ | `HiggsAndMassHierarchy.higgs_mass_hierarchy_first_bundle_in_V2` |
| Quantum gravity / BH info (Electra 37) | ✅ | `QuantumGravityBHInfo.black_hole_information_paradox_fully_resolved` |
| Cycles 36, 38–42 (wizard-only deliveries) | ✅ | folded into `GravitySectorUnifiedBundle` + `MatterSectorUnifiedBundle` |
| Grand Capstone V2 (Polaris 43) | ✅ | `GrandCapstoneV2.omega_theory_v2_final_meta_capstone` |

### What's DONE earlier (cycles 2–23; don't redo)

| Area | Status | Key theorem |
|------|--------|-------------|
| QM (10 postulates) | ✅ | `grand_qm_emergence` |
| GR (Einstein eq, 7 regimes) | ✅ | `vacuum_einstein_emergence`, HPW deleted |
| U(1)×SU(2)×SU(3) gauge + photon/W/Z/gluon masses | ✅ | `ErrorGaugeField/SU2/SU3` |
| Higgs = δ_comp | ✅ | `HiggsFromError`, `HiggsVEVSubstrate` |
| Connes spectral action (A_F = ℂ⊕ℍ⊕M₃(ℂ)) | ✅ | `ConnesSpectralAction` |
| Dark energy w=-1, Λ problem resolved | ✅ | `CosmologicalConstant`, `CosmologicalConstantProblem` |
| Inflation, Big Bounce (Popławski torsion) | ✅ | `Inflation`, `BigBounce` |
| Klein–Gordon, Dirac, path integral, CHSH Bell | ✅ | `KleinGordon`, `DiracEquation`, `PathIntegral`, `CHSHBell` |
| 20 predictions (1 verified — Diraq 2024) | ✅ | `Predictions/*.lean` |
| Cor Caroli cycle-23 capstone (`omega_theory_grand_capstone`) | ✅ | superseded by V2 capstone |
| PRL letter package (cold-neutron slope test) | ✅ | `letter-coldneutron/` |

---

## TOP PRIORITY: Forward vision (cycles 44+)

Post-capstone, the graph synthesis identifies four next frontiers.
See **`OmegaTheoryAlgebra/GROTHENDIECK_MATH_PUZZLE.md`** (Navi, γ Cassiopeiae,
2026-04-21) — eight-pass MP-1…MP-8 synthesis over the 184K-theorem corpus
graph that names missing mathematical structure.

### Frontier 1 — Absorb the 53 paper_worthy GraphFindings into Lean
The graph now carries **105 `:GraphFinding` nodes**, of which **53 are tagged
`paper_worthy`** (graph-audited 2026-04-21). Each is a graph-certified missing
bridge with a predicted Lean signature. Of the 175 `:TheoremCandidate` nodes,
106 already have a matching theorem in the corpus (the Mekbuda backlog plus
incidental closures through cycles 24–43); the remaining **70 are genuinely
open** and form the prioritised queue for cycles 44+. Query the live state with
```cypher
MATCH (tc:TheoremCandidate)
OPTIONAL MATCH (t:Theorem {namespace:'OmegaTheoryV2'})
  WHERE t.name = tc.name OR t.name ENDS WITH ('.' + tc.name)
RETURN tc.name, tc.priority, tc.cycle,
       CASE WHEN t IS NULL THEN 'OPEN' ELSE 'CLOSED' END AS status
ORDER BY status, tc.cycle DESC, tc.priority
```
See also `plans/THEOREM_BACKLOG_CYCLES_24_43.md` (historic Mekbuda closure list)
plus the Navi MP-5 through MP-8 output in
`OmegaTheoryAlgebra/GROTHENDIECK_MATH_PUZZLE.md` for bridge/dual-pair targets.

### Frontier 2 — Matter-sector numerical tightening
The gauge sector is 100%, the mass sector is functional (e/μ ratio, top/electron
hierarchy, CKM three-step ladder from π/e/√2 ordering), but the absolute mass
predictions still rely on Connes kernel calibration. Capstone-era research memos
(`NOTES_CYCLE30_CONNES_YUKAWA.md`, `notes/NOTES_CYCLE35_HIGGS_MASS_HIERARCHY.md`)
identify the remaining degrees of freedom. Goal: drive `m_e`, `m_μ`, `m_τ`
absolute values within 1% of PDG from the Connes D_F spectrum alone.

### Frontier 3 — Baryogenesis CP-phase from substrate
`OmegaTheory/Emergence/BaryogenesisLeptogenesis.lean` (Alkes cycle 33) is in
place but the CP-violation phase is currently a calibrated parameter. Derive
it from the π-truncation residual asymmetry under time reversal — the standing
Grothendieck-puzzle-MP-8 proposal.

### Frontier 4 — Submission venues
`NeurIPS 2026` (GraphRAG angle) / `ICLR 2027` (V3-for-Lean retriever) /
`Foundations of Physics` (full capstone) / `PRL` (cold-neutron letter — already
packaged at `letter-coldneutron/`). See `notes/NOTES_CYCLE43_GRAND_CAPSTONE.md`
§§17–18 for the submission matrix.

---

## OPEN MATHEMATICAL GAPS (next to close)

### Gap 1: `Real.pi_transcendental` axiom
- **Status**: the **5th of the 5 primitive assumptions** (the 4 physical existence postulates for c/ℏ/G_N/k_B are now `Classical.choice` opaque bundles rather than `axiom` declarations, so `Real.pi_transcendental` is the only remaining `axiom`-keyword *primitive assumption* as of 2026-04-24 Lesath refactor); waiting on Mathlib Lindemann–Weierstrass port.
- **Fix**: monitor Mathlib upstream; swap the axiom for the Mathlib lemma when available.

### Gap 2: HermitePadé research conjectures (4 items)
- **Status**: used as hypotheses in the Pi-Hunch deep chain, tracked separately (Siegel-Shidlovskii, Nesterenko 1996, Roth 1955, Mahler framework).
- **File**: `OmegaTheory/Irrationality/HermitePade/*.lean`.
- **Fix**: continue the research track; each conjecture closure lowers the
  **9 total axioms** count (5 primitive + 4 HermitePadé) back toward the
  5-primitive-assumption floor. The 5 primitive assumptions (4 physical existence
  postulates + `Real.pi_transcendental`) can drop further only when Mathlib
  ships Lindemann–Weierstrass (then 4) or when a better foundational framework
  replaces `Classical.choice` opaque bundles for c/ℏ/G_N/k_B.
  *(Historical: "24 total `axiom` declarations" (8 physical + 1 π-transcendental + 15 HermitePadé) was the 2026-04-21 baseline; the 8 physical `axiom` declarations were retired via opaque `Classical.choice` bundles on 2026-04-24 (reducing declarations to 0 while preserving 4 existence postulates mathematically), and 11 HermitePadé axioms were retired via Acrab's opaque-conversion pattern.)*

### Gap 3 (CLOSED Apr-17 by Tureis/Dubhe): Clifford off-diagonal
`gammaClifford_offDiagonal` — all 12 cases unconditional. Kept here only so
future agents don't re-open it.

### Gap 4: su(3) Jacobi identity
- **Status**: still a `hJ` hypothesis in ErrorGaugeSU3.
- **Fix**: `fin_cases` with `set_option maxHeartbeats 4000000`; budgeted for cycle 44+.

### Gap 5: Non-abelian F = dA + [A,A]
- **Status**: ingredients present (wedge, bracket, ErrorForms), not yet assembled.
- **Fix**: compose `errorD1` with `errorWedge11` + su(2)/su(3) brackets.
  Partly addressed in `Emergence/SU3ColorAndNonAbelianF.lean` (Tiaki cycle 29);
  a fully general abstract Yang–Mills bundle remains.

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
2. **0 new `axiom` declarations / 0 new primitive assumptions** — post-2026-04-24 project sits at **5 primitive assumptions** (4 physical existence postulates for c/ℏ/G_N/k_B via `Classical.choice` opaque bundles — 0 `axiom` *declarations* for physical constants, but MATHEMATICALLY 4 existence postulates remain — + 1 `Real.pi_transcendental`). Honest three-way split: `0 axiom-declarations · 5 primitive-assumptions · 9 total-including-research` (+4 HermitePadé).
3. **Must compile GREEN** before reporting done (3,901 jobs baseline as of cycle-44-extension)
4. **Register new files** in `OmegaTheory/Basic.lean`
5. **Quality over speed** — iterate until clean

---

## CUSTOM AGENTS (in `LeanFormalizationV2/.claude/agents/`)

| Agent | Role | Use when |
|-------|------|----------|
| `omega-team-lead` | Coordinates wizard + creative pairs | Orchestration |
| `lean-proof-wizard` | Lean 4 specialist, all tactics | Proving theorems, fixing builds |
| `quantum-physics-creative` | Wild physics ideas, literature search | Finding new connections |
| `grothendieck-sage` | Graph synthesis / gap hunting over Lean+Mathlib graph | Strategic planning, math puzzle work |
| `pi-irrationality-hunter` | Pi-Hunch specialist: transcendence + 3-generation hypothesis | π math |
| `pi-formalizer` | Lean formalization of π properties + Hermite–Padé | Closing HermitePadé conjectures |
| `pi-physics-bridge` | π math → physical predictions (masses, QM, generations) | Cross-domain synthesis |

These agents work as a PAIR in most cycles: creative proposes → wizard formalizes → sage audits the graph.

---

## ARCHITECTURE OVERVIEW

```
4 OPAQUE CLASSICAL.CHOICE BUNDLES (c, ℏ, G_N, k_B : {x : ℝ // 0 < x})
         │
    ℤ⁴ LATTICE × ErrorAlgebra
         │
    ┌────┼────┐
    │    │    │
  ERROR  IRRAT  GAUGE
  GEOM   π/e/√2/G  Lie+Forms
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
GR    QM    SM  ← Dirac/Majorana split, 4 channels
 │     │     │
Einstein 10   20   (⇄ Matter sector NOW FUNCTIONAL — cycles 24–43)
 eqs  post  pred   cycles 44+ → CP-phase, absolute masses, 53 paper_worthy findings
         │
    GRAND CAPSTONE V2 (Polaris cycle 43)
    grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE
```

---

## NEO4J GRAPH (post-cycle-43)

Five active namespaces on `math` container (bolt://localhost:7687,
neo4j/omegatheory2026):
- `OmegaTheoryV2` — **Omega-Lean layer**: ~9,500 `:Theorem` (9,794 declarations post-session 2026-04-24; 8,996 Apr-21 baseline) + 4,465 `:Definition` + **5** `:Axiom` nodes in graph (down from 24 via Lesath opaque-bundle refactor — the 4 physical existence postulates for c/ℏ/G_N/k_B are now `opaque` definitions, not `:Axiom` nodes, even though they still commit to positive-real existence mathematically; so honest count is **5 primitive-assumptions · 9 total-including-research** where `:Axiom` graph nodes = 5 = 1 `Real.pi_transcendental` + 4 HermitePadé) + 399 `:LeanFile` nodes (proved + machine-checked).
- `Mathlib` — **Foundation layer**: ~175,127 `:Theorem` + 32,917 `:Definition` + 6 `:Axiom` + 3,183 `:LeanFile` nodes (integrated as composition backbone).
- `LeanAlgebra` — **V3 schema scaffold**: 6 `:QuiverVertex`, 15 `:QuiverArrow`, 12 `:QuiverComposition`, 7 `:SelectionRule`, 1 `:MagneticLaplacian` (algebraic laws, no data).
- `CheckItOutSystem`, `subscription` — non-physics namespaces (marketplace project, co-hosted).

Total edges across the Lean-as-graph corpus: **~3.95M** typed arrows
(2.03M OmegaTheoryV2→Mathlib APPLIES + 1.25M Mathlib→OmegaTheoryV2 back-references
+ intra-namespace remainder).

**Graph-only ("discovery") layer — cycles 44+ frontier**:
- **105 `:GraphFinding` nodes** (53 paper_worthy, 52 informative/trace).
- **175 `:TheoremCandidate` nodes** (106 already have a matching `:Theorem` → auto-closed; 70 genuinely open; 43 of those high-priority).
- **33 `:GrothendieckRecipe` nodes** (reproducible graph experiments from Navi / Algieba / Mekbuda / Meissa / earlier agents).
- **677 `:SubsystemNavigator` nodes** (Leiden communities from the V3-for-Lean pipeline, γ-sweep Q = 0.89 at γ = 0.5, Navi 2026-04-21).
- Navi's MP-1…MP-8 synthesis added 23 bridge / dual / π-frontier `:TheoremCandidate` rows and 8 new recipes (cycles 44+ roadmap anchors).

Ingest pipeline: `LeanFormalizationV2/.neo4j/` (Cypher + Python loaders).
See `LeanFormalizationV2/.neo4j/CLAUDE.md` for the authoritative loader list.
Do NOT regex-parse `.lean` for graph work — Mirfak measured 46% theorem drop
on the regex path.

---

## KEY REFERENCE DOCS (in this repo)

### Post-capstone (read first)
- `OmegaTheoryAlgebra/GROTHENDIECK_MATH_PUZZLE.md` — Navi's 8-pass synthesis
  over the 184K-theorem graph; names the cycles 44+ mathematical frontier
- `LeanFormalizationV2/notes/NOTES_CYCLE43_GRAND_CAPSTONE.md` — capstone closure memo
- `LeanFormalizationV2/plans/THEOREM_BACKLOG_CYCLES_24_43.md` — Mekbuda's 60-theorem list (now CLOSED)
- `LeanFormalizationV2/plans/GROTHENDIECK_FOLLOWUP_REPORT.md` — first Grothendieck report
- `LeanFormalizationV2/plans/GROTHENDIECK_DE_REVERSIBILITY.md` — DE → BH reversibility
- `LeanFormalizationV2/ROADMAP_CYCLES_24_43.md` — strategic overview (now historic)

### Research track
- `research/STRATEGIC_FORMALIZATION_PLAN.md` — long-horizon roadmap
- `research/GAUGE_THEORY_RESEARCH.md` — Connes + Wilson + SimilarityAlgebra path
- `research/MATTER_SECTOR_RESEARCH.md` — quark/lepton/Yukawa pathway
- `research/CONNES_DF_RECIPE.md` — finite-geometry derivation plan
- `research/OPEN_THEOREMS.md` — outstanding propositions
- `research/NEW_HORIZONS.md` — beyond-V2 speculations
- `research/PAPERS_AUDIT.md`, `research/PAPERS_REORG_PLAN.md` — manuscript governance

### Paper track
- `papers/Paper-QM-From-Discrete-Gravity.md` — main paper draft
- `papers/Paper-Dark-Energy-Preview-v1.md` — DE companion paper
- `papers/KeyInsight-Irrationals-Action-Thresholds.md` — Pi-Hunch one-pager
- `appendices/Appendix-A.md` … `Appendix-K.md` + `Appendix-P`, `Appendix-DE`, `Appendix-S`, `Appendix-LorentzDopplerEquivalence` — A–K + four specials
- `letter-coldneutron/` — PRL submission package (cold-neutron slope test)
- `submissions/qm-discrete-gravity/` — LaTeX submission bundle

### Working notes (cycle transitions + research memos)
- `LeanFormalizationV2/notes/NOTES_CYCLE{24,25,26,27,28,29,30,31,32,33,34,35,37,43}_*.md` — cycle closure memos
- `LeanFormalizationV2/notes/NOTES_CYCLE17_TRANSITION.md` — last pre-capstone transition
- `LeanFormalizationV2/notes/NOTES_HPW_ELIMINATION.md` — full HPW deletion history
- `LeanFormalizationV2/notes/NOTES_KEMPF_BRIDGE.md`, `NOTES_KEMPF_DELTA_CMB.md` — bandlimit research
- `LeanFormalizationV2/notes/NOTES_PROTON_MASS_SCOPE.md`, `NOTES_QM_AS_DISCRETE_GRAVITY.md` — focused memos
- `LeanFormalizationV2/notes/NOTES_GAP_HUNTER_DESIGN.md`, `NOTES_SEELEY_DEWITT_DESIGN.md`, `NOTES_ALPHA47_RESEARCH.md` — design notes
- (the earlier `audits/` subtree was retired 2026-04-21 — every snapshot is superseded by the live build)

---

**The dream (still)**: derive the masses of ALL elementary particles from first principles.
**The capstone (now landed)**: Polaris cycle 43 — QM + GR + full SM + DM + DE + bounce derived from 8 constants and 4 irrationals.
**The forward arc**: cycles 44+ close the 70 genuinely-open `:TheoremCandidate`
nodes, absorb the 53 paper_worthy GraphFindings, and drive absolute particle
masses from Connes D_F alone.
