# OmegaTheory — Physics Papers & Lean Formalization

## Orchestrator MCP
`omega-orchestrator` MCP exposes 22 tools across 6 buckets (servers / graph / embed
/ inspect / jobs / wizard). For any pipeline operation, prefer MCP over raw
shell+Cypher. Live state via `cycle_state()` / `build_status()` / `axiom_audit()`.
Hammers (`omega_hammer_premise`, `propose_proof`) use composite scoring only —
the `rerank` parameter was removed 2026-04-25.

## Overview
OmegaTheory derives quantum mechanics, general relativity, and the full Standard Model
gauge group + fermion masses + dark matter + dark energy + cyclic cosmology from
**8 physical constants** on a ℤ⁴ Planck lattice. The computational truncation of
**four irrationals** (π, e, √2, Catalan G) produces bounded errors that ARE quantum
uncertainty — and they furnish exactly four channels matching three SM generations
plus one sterile/DM slot.

## Status (2026-04-24, cycle-44-extension post Lesath opaque-bundle refactor)
- **3,901 build jobs GREEN**, 0 sorry. **Primitive-assumption accounting (honest):**
  - **0 `axiom` declarations for physical constants** — c, ℏ, G_N, k_B now realised
    as 4 noncomputable opaque bundles `c_bundle / hbar_bundle / G_N_bundle /
    k_B_bundle : {x : ℝ // 0 < x}`, each a `Classical.choice` witness (Lean core,
    NOT an `axiom` keyword).
  - **MATHEMATICALLY**, these 4 opaque bundles remain **existence postulates** for
    positive reals — no specific numeric value is fixed; all derivations are
    parametric. Call them the **4 physical existence postulates**.
  - **+ 1 transcendence axiom** `Real.pi_transcendental` (blocked on Mathlib
    Lindemann–Weierstrass port) = **5 primitive assumptions** total for the paper.
  - **+ 4 HermitePadé research axioms** (Siegel-Shidlovskii, Nesterenko 1996, Roth
    1955, Mahler framework) sealed in `Irrationality/HermitePade/` as pending
    mathlib-port placeholders = **9 total including research**.
  - **Three-way split:** `0 axiom-declarations · 5 primitive-assumptions · 9
    total-including-research`.
- **~211 Lean files** in `LeanFormalizationV2/`
- **~9,500 OWN OmegaTheoryV2 theorems** (9,794 declarations in graph post-session)
  on top of **~175,127 integrated Mathlib theorems** — the full project compiles
  GREEN as one corpus of **~184,627 Theorems** total with ~3.95M typed edges across
  15 LeanAlgebra arrow-types (of which ~3.3M are cross-namespace).
- **Cycles 2–43 all shipped + cycle-44 extension.** Mekbuda's 60-theorem cycles
  24–43 backlog CLOSED. Grand Capstone V2 (`omega_theory_v2_final_meta_capstone`)
  locked by Polaris. Cycle-44 Kornephoros/Homam/Alkalurops/Acrab/Alphecca/Ain/Lesath
  waves closed 14 + opaque-bundle refactor (axioms 8→0 on physical constants).
- **Graph state** (live via Neo4j `math` container, 2026-04-21 snapshot): 88
  `:GraphFinding` nodes (44 paper_worthy) + 166 `:TheoremCandidate` nodes (52 closed /
  113 open / 1 blocked) + 677 `:SubsystemNavigator` nodes

### Historical baseline (2026-04-21, post-cycle-43 grand capstone)
- 3,835 build jobs GREEN, 0 sorry, 8 physical axioms (+ 15 HermitePadé + 1
  π-transcendental = 24 total). 8,996 OWN + 175,137 Mathlib = 184,133 Theorems.
  Preserved for reference in cycle notes + ROADMAP_CYCLES_24_43.md.

## Repository structure
```
PhysicsPapers/
├── CLAUDE.md                      ← this file
├── IMPORTANT.md                   ← post-capstone roadmap + forward vision
├── README.md                      ← public one-pager
├── Main-Paper-Postulates.md       ← foundational postulates draft
├── Complete-Omega-Theory-Unified-Framework.md   ← framework overview
├── unified-theory-diagram.md      ← architecture diagram
├── LeanFormalizationV2/           ← Lean 4 formalization (v4.29.0 + Mathlib v4.29.0)
│   ├── CLAUDE.md                  ← V2-specific agent onboarding
│   ├── STYLE_GUIDE.md             ← naming + proof governance
│   ├── ROADMAP_CYCLES_24_43.md    ← strategic roadmap (now historic, cycles closed)
│   ├── PROJECT.md                 ← foundational overview
│   ├── README.md                  ← detailed Lean status
│   ├── OmegaTheory/               ← Lean 4 source (211 files)
│   │   ├── Foundations/           ErrorAlgebra, ErrorLieAlgebra, ErrorForms, ErrorHopf
│   │   ├── Spacetime/             Lattice, Constants, Operators, CausalLattice
│   │   ├── Geometry/              Metric → Curvature → Maxwell → Hodge → Poincaré
│   │   ├── Emergence/             Einstein, QM, Higgs, SM gauge + matter, Connes, bridges (132 files)
│   │   ├── Predictions/           20 falsifiable predictions + grand capstones
│   │   ├── Conservation/          Information, Noether, StressEnergy, Correspondence
│   │   ├── HealingFlow/           Lyapunov, LaSalle, Convergence
│   │   ├── Torsion/               SpinTorsion, BigBounce (Popławski), BabyUniverse
│   │   ├── Irrationality/         π/e/√2/G truncation → δ_comp(N), Hermite–Padé
│   │   ├── Variational/           GraphAction, DiscreteNoether
│   │   ├── Paper/                 Headline aliases for manuscript citation
│   │   ├── Meta/                  DumpDeclarations, DumpArrows (graph pipeline)
│   │   └── Probe/                 Proof-search experiments (PiAndOmegaStructure, etc.)
│   ├── notes/                     ← 20 files after 2026-04-21 triage:
│   │                               14 cycle closures (NOTES_CYCLE{24…35,37,43}_*.md),
│   │                               4 open-work design memos (Kempf×2, Seeley-DeWitt,
│   │                               Gap-Hunter, Proton-Mass), NOTES_QM_AS_DISCRETE_GRAVITY
│   │                               (README-cited companion). Earlier audits/ retired
│   │                               2026-04-21 and HPW/cycle17/alpha47 memos deleted
│   ├── plans/                     ← active to-do + follow-up reports:
│   │                               THEOREM_BACKLOG_CYCLES_24_43.md (60 items CLOSED),
│   │                               GROTHENDIECK_FOLLOWUP_REPORT.md,
│   │                               GROTHENDIECK_DE_REVERSIBILITY.md
│   ├── scratch/                   ← one-off scripts (quark_ratios_scan.py, .analyst_hpw.cypher)
│   ├── .neo4j/                    ← Cypher ingest pipeline (V3-for-Lean)
│   └── .claude/agents/            ← 7 custom agents (see below)
├── OmegaTheoryAlgebra/            ← V3-for-Lean / graph-algebra scaffolding
│   └── GROTHENDIECK_MATH_PUZZLE.md   ← Navi's 8-pass synthesis (cycles 44+ frontier)
├── V3-for-Lean/                   ← V3-for-Lean scripts + artefacts
├── appendices/                    ← Appendix-A through Appendix-K + specials
│                                    (DE, LorentzDoppler, P-EinsteinCartan, S-Wormholes)
├── letter-coldneutron/            ← PRL submission package (cold-neutron slope test)
├── papers/                        ← Paper-QM-From-Discrete-Gravity.md + DE-preview + KeyInsight
├── submissions/qm-discrete-gravity/  ← LaTeX submission bundle
├── notes/                         ← top-level research notes (Erdős, continued fractions, lattice curvature)
├── research/                      ← STRATEGIC_FORMALIZATION_PLAN, GAUGE_THEORY_RESEARCH,
│                                    MATTER_SECTOR_RESEARCH, CONNES_DF_RECIPE,
│                                    LEAN_VERIFIED_CLAIMS, NEW_HORIZONS, OPEN_THEOREMS,
│                                    PAPERS_AUDIT, PAPERS_REORG_PLAN
│                                    (HPW_UPGRADE_RECIPE.md was never written — HPW axiom deleted 2026-04-17)
└── diagrams/                      ← figures, schematics
```

## Lean 4 build (WSL-native, NEVER use wsl.exe wrapper)
```bash
~/.elan/bin/lake build --log-level=error                    # full project
~/.elan/bin/lake build OmegaTheory.Module --log-level=error # single module
~/.elan/bin/lake exe cache get                              # Mathlib cache
```

## WORKFLOW PRINCIPLES — SOTA cycle orchestration (2026-04-24, binding)

This section codifies **strict phase ordering** and **power hygiene** for the
agent orchestration pipeline. Enforced by cron loops `5ff5a3e1` (cycle),
`9023e7c5` (meta), `985da81c` (doc-refresh). Violations waste agent work and
machine thermals.

### Phase-based cycle model

Every cycle has three phases. Phases are strictly sequential:

| Phase | Trigger | Who runs | Embedder `:7999` | Reranker `:7996` | Exit condition |
|-------|---------|----------|:-:|:-:|----------------|
| **A — PROPOSE** | Phase C completed & verified, OPEN candidates exist | 1 × `grothendieck-sage` (Cypher + `mcp__omega-search__*` retrieval) | **ON** | **ON** | Sage returns batch `.md`; wizards spawned |
| **B — PROVE** | ≥1 wizard active | 4-8 × `lean-proof-wizard` parallel on disjoint files | **OFF** (power hygiene) | **OFF** (power hygiene) | All wizards landed; ≥3 landings accumulated |
| **C — CLOSE** | ≥3 landings since last Phase C | parent orchestrator (sequential script) | **ON** | **ON** | All 7 refresh steps verified |

### Server state transitions (binding)

```
C → A : KEEP servers ON — sage needs retrieval + reranking
A → B : KILL servers   — wizards are Lean-only (CPU-bound Ryzen)
B → C : RESTART servers — dumps/loads/reembed need them
A standalone (meta)     : START servers (sage), KILL on completion
```

### Why the reranker matters

`grothendieck-sage` uses `mcp__omega-search__find_similar`, `neighbors`,
`retrieve_premises`, `explain_theorem`, `subsystem_of` — all powered by
Qwen3-Reranker-8B CPU at `:7996` + Qwen3-Embedding-8B GPU at `:7999`. Without
both up, sage's recommendations fall back to pure-Cypher graph walks and miss
semantic near-neighbors — quality drops ~30%.

### PHASE C strict ordering (non-negotiable)

Phase C must complete **all seven steps in order before any Phase A sage-fire**.
Do NOT fire sage-for-next-batch until graph + embeddings are fully refreshed —
sage proposals based on stale graph waste the team's work.

**Executable form: `mcp__omega-orchestrator__refresh_graph(dry_run=False)` is
ASYNC — returns `job_id` instantly, runs all 8 steps (sentinel→build→
dump_decls→dump_arrows→load_decls→load_arrows→reembed→verify) in a detached
subprocess, publishes a structured `progress` field on each step, invalidates
caches on success. Poll via `job_status(id)` / `job_tail(id, n)`. Do NOT pass
`sync_mode=True` — that blocks the MCP stdio loop for 5-30 min and risks
child-process disconnect (lesson 2026-04-25). `axiom_audit()` is step 1
(also folded into the async chant); `servers_control('start'|'stop')` is
steps 2/6; parent writes the memo for step 7. The cron prompt at
`~/.claude/commands/cycle-completion-loop.md` is the canonical executor.**

The seven steps (philosophy):

1. **AXIOM SENTINEL** — `axiom_audit(targets=<paper capstones>)` MUST return
   `[propext, Classical.choice, Quot.sound]` only. If any research axiom leaks
   → PushNotification + blocker task; halt.
2. **POWER UP servers** — `servers_control(action='start')` (embedder + reranker;
   embedder GPU takes ~20s warm-up).
3. **SEQUENTIAL graph refresh** — `refresh_graph(dry_run=False)` runs in order:
   `lake build` → `dump_decls` → `dump_arrows --include-mathlib` →
   `load_declarations_env_v2.py` → `load_arrows_parallel.py` →
   `reembed_qwen3_delta.py`. No skips, no parallel reordering. Returns
   `{missing_emb, deltas, axioms}`.
4. **VERIFY refresh integrity** — `refresh_graph` returns `missing_emb`; **must
   be 0** (sage blind-spot if >0). If >0, the MCP retries reembed automatically;
   if still nonzero, halt.
5. **PRUNE orphaned `:Axiom` nodes** — handled by `refresh_graph` step 5; only
   nodes unreachable via `ASSUMES|APPLIES*1..5` are removed (Lean-core axioms
   stay).
6. **POWER DOWN servers** — `servers_control(action='stop')` (heat/power rule
   2026-04-24).
7. **MEMORY-WRITE cycle closure** — parent writes
   `notes/NOTES_CYCLE_<N>_COMPLETION_YYYY-MM-DD.md` with landings, axiom
   footprint before/after, build-jobs delta, next-cycle seeds. Parent's job
   per `parent owns memory` rule; MCP never writes memos.

Only after Step 7 written → transition to Phase A. If any step errors, halt
the pipeline and notify user.

### POWER HYGIENE rule (binding, updated 2026-04-24)

**Embedder `:7999` + reranker `:7996` are ON during Phase A and Phase C only.
OFF during Phase B (proving, the longest phase).**

Enforced by `servers_control(action='stop')` after Phase C step 6 and again
after Phase A handoff. Verify pre-Phase-B with `servers_control(action='status')`
— both `healthy: false`.

Rationale: Phase B (wizards proving) is CPU-bound on Ryzen 9950X — GPU + CPU
reranker are wasted thermals. Phase A (sage) needs both for `mcp__omega-search`
retrieval quality. Phase C (dump/load/reembed) needs both for embeddings.
Transitions:
- `B → C`: `servers_control('start')` (embedder GPU takes ~20s warm-up).
- `C → A`: keep both running — sage starts immediately.
- `A → B`: `servers_control('stop')` — wizards don't need them.

### GROTHENDIECK-AS-ORCHESTRATOR pattern

`grothendieck-sage` fires at TWO moments only:

1. **Phase A start** (after Phase C verified complete) — proposes next batch.
2. **Phase B unblock** (mid-proving, if a wizard is stuck) — suggests tactic or
   narrower statement. NOT a next-batch fire.

Sage NEVER edits `.lean` files. Output is always `.md` or Neo4j `:TheoremCandidate`
node creation. Role-lock is from feedback 2026-04-22 (see memory
`feedback_grothendieck_proposes_wizard_proves.md`).

### SELF-PACING rule

Cron ticks (every 30min/2h/6h) are **safety nets, not clocks**. When a phase
finishes, chain to the next phase IMMEDIATELY — do not wait for cron. Loops
run back-to-back until genuinely idle (no OPEN candidates AND Phase C just
refreshed AND sage just proposed).

### AXIOM-MINIMIZATION mandate

Every cycle dedicates ≥1 wizard to axiom-narrowing or elimination:
- Swap `Real.pi_transcendental` for `Real.irrational_pi` (Niven, Mathlib) where
  transcendence isn't strictly needed — only irrationality.
- Decompose Lindemann-Weierstrass, Roth, Nesterenko, Mahler into 10-30 Lean-sized
  sub-lemmas; port each to `OmegaTheory/Irrationality/CustomMath/<Name>.lean`.
- **No fear of proving it ourselves if Mathlib doesn't have it.**

### FAILURE MODES (diagnose fast)

- **Sage fires on stale graph** → wastes its proposal. Fix: enforce Phase C
  strict ordering (this section); verify `missing_emb = 0` before Phase A.
- **Embedders left running during Phase B** → wasted GPU thermals. Fix: kill
  immediately after Phase C step 6; verify `pgrep llama-server` returns nothing
  before spawning any wizard.
- **Wizard touches another wizard's file** → merge collision. Fix: in each brief,
  list files OFF-LIMITS (current wizard territory); inspect TaskList before
  spawning.
- **Axiom regression into capstone** → breaks paper-headline footprint. Fix:
  doc-refresh loop's sentinel raises `PushNotification`; halt cycle until narrowed.

## Neo4j ingest pipeline — USE MCP, DO NOT ROLL YOUR OWN

Full ground-truth pipeline lives in `~/lean-v2/.neo4j/`. See
`LeanFormalizationV2/.neo4j/CLAUDE.md` for details. Two Lean metaprograms
produce the env dumps; Python loaders MERGE them into the `math` container
(bolt://localhost:7687, neo4j/omegatheory2026). Never regex-parse `.lean`
files for graph work — Mirfak measured the regex path drops 46% of fresh
theorems.

**Executable form (preferred):** `mcp__omega-orchestrator__ingest_graph(run_dump=True, run_load=True)` returns a `job_id`; poll via `job_status` / `job_tail`. Embeddings via `embed_delta(fields=['embedding_lean'])`. **For the full Phase C 7-step chant use `refresh_graph(dry_run=False)` — it is now ASYNC (returns `job_id`, publishes structured live progress); `sync_mode=True` is a legacy escape hatch only and risks MCP stdio disconnect on multi-min runs.**

**Key files (catalogue — extend them, don't rewrite):**
- `OmegaTheory/Meta/DumpDeclarations.lean` (Schedar) — env declaration dumper
- `OmegaTheory/Meta/DumpArrows.lean` (Sheratan) — 12-arrow typed env extractor
- `.neo4j/load_declarations_env_v2.py` (Naos) — delta declaration loader
- `.neo4j/load_arrows_parallel.py` — **SOTA parallel loader** 16-worker × batched UNWIND (~500× faster than sequential; 10–17k edges/s)
- `.neo4j/load_arrows_from_env_v2.py` (Rasalhague) — legacy sequential APOC loader (slow, keep for debugging)
- `.neo4j/reembed_qwen3_delta.py` — Qwen3-Embedding-8B BF16 GPU embedder

**CRITICAL: nodes must use fully-qualified names** (`module + "." + short_name`) to match dump_arrows output. Post-hoc rename fix in `.neo4j/CLAUDE.md`.

**DO NOT use** `.neo4j/extractors/lean_arrow_extractor.py` (regex, deprecated)
for production graph work. It's kept for fallback when Lean env is broken.

Embedder endpoints (managed by `servers_control`):
- `http://localhost:7999/v1/embeddings` — Qwen3-8B BF16 GPU (dim 4096)
- `http://localhost:7996/rerank` — Qwen3-Reranker-8B CPU

## HARD RULES for all work
1. **0 sorry** in Lean — absolutely never
2. **0 new axioms / primitive assumptions** — project rests on exactly **5
   primitive assumptions**: 4 physical existence postulates (c, ℏ, G_N, k_B as
   opaque `Classical.choice` bundles — 0 `axiom` *declarations*, but
   MATHEMATICALLY still existence postulates for positive reals) + 1 transcendence
   axiom (`Real.pi_transcendental`, pending Mathlib Lindemann–Weierstrass port).
   Plus 4 HermitePadé research axioms sealed inside `Irrationality/HermitePade/`
   as pending mathlib-port placeholders = **9 total including research**. Honest
   three-way split: `0 axiom-declarations · 5 primitive-assumptions · 9 total`.
3. **Must compile GREEN** before reporting done
4. **Quality over speed** — iterate on errors until clean
5. **Narrower true theorem > false dressed-up claim**
6. **No edits to `OmegaTheoryAlgebra/` or `V3-for-Lean/` from this repo** unless the
   task explicitly targets them — those trees are maintained from separate workflows.

## Proof automation — USE BEFORE manual proof
```lean
exact?       -- search 210K+ Mathlib lemmas + local theorems (30s, most powerful)
apply?       -- find applicable lemmas
aesop        -- white-box multi-step proof search
grind        -- SMT solver (Gröbner basis + cutsat, Lean 4.22+)
positivity   -- auto-prove 0 < x or 0 ≤ x
ring         -- ring equalities
field_simp   -- clear denominators then ring
linarith     -- linear arithmetic over ordered fields
nlinarith    -- nonlinear arithmetic
decide       -- exhaustive finite enumeration
omega        -- Presburger arithmetic (ℤ/ℕ)
norm_num     -- numeric normalization
push_cast    -- push coercions through expressions
fin_cases    -- case split on Fin n (exhaustive for small n)
fun_prop     -- continuity / differentiability
gcongr       -- generalized congruence (monotonicity)
```

## Mathlib v4.29.0 name changes (CRITICAL)
- `div_le_iff₀` NOT `div_le_iff` (note ₀ suffix)
- `div_lt_iff₀` NOT `div_lt_iff`
- `mul_div_cancel₀` NOT `mul_div_cancel` (needs ne_zero)
- `Finset.not_mem_empty` NOT `Finset.mem_empty`

## What the theory derives (from 4 opaque-bundle constants only)
*(Post-2026-04-24 refactor: c, ℏ, G_N, k_B each realised as
`noncomputable opaque X_bundle : {x : ℝ // 0 < x}`, i.e., a Classical.choice
witness carrying its own positivity. The 8-axiom count in the table below
refers to the historical (pre-Lesath) formulation; the derivations are
unchanged — the bundle refactor only tightened the foundation.)*

### Pre-capstone (cycles 2–23, all LOCKED)
| Physics | Status | Key theorem |
|---------|--------|-------------|
| Quantum Mechanics (10 postulates) | ✅ | `grand_qm_emergence` |
| General Relativity | ✅ 7 regimes | `vacuum_einstein_emergence` |
| U(1) gauge (EM) | ✅ | `photonSubstrateMassBound_pos` |
| SU(2) gauge (weak) | ✅ | `weakCouplingConstant_from_substrate` |
| SU(3) gauge (strong) | ✅ | `strongCouplingConstant_from_substrate` |
| Higgs mechanism | ✅ | `HiggsField := computationalUncertainty` |
| Dark energy w=-1 | ✅ | `darkEnergyEquationOfState_w` |
| Inflation | ✅ | `healingFlow_drives_inflation` |
| Big Bounce | ✅ | `substrate_avoids_singularity` |
| Bell nonlocality | ✅ | `classical_CHSH_bound` + `substrate_CHSH_violation` |
| Path integral | ✅ | `pathIntegral_interference` |
| Λ problem resolved | ✅ | `cosmological_constant_problem_resolved` |
| 20 predictions | ✅ (1 verified) | See `Predictions/*.lean` |
| Cor Caroli cycle-23 capstone | ✅ (now a lemma of V2) | `omega_theory_grand_capstone` |

### Cycles 24–43 (Mekbuda 60-theorem backlog — now CLOSED)
| Physics | Status | Key theorem |
|---------|--------|-------------|
| Electroweak unification | ✅ | `substrate_electroweak_unification_theorem` |
| Ω_total = 1 cosmology | ✅ | `omega_total_equals_one` |
| Baby universe + sterile ν / DM | ✅ | `sterile_neutrino_from_fourth_irrational` |
| Connes 4-channel calibration | ✅ | `Z_sterile_from_connes_DF_eigenvalue` |
| SU(3) color = 3 channels + non-abelian F | ✅ | `SU3_color_from_three_irrationals` |
| Connes D_F → Yukawa masses | ✅ | `mass_ratio_e_mu_from_sqrt2_e_channel_ratio` |
| CKM three-step ladder | ✅ | `CKM_hierarchy_from_pi_e_sqrt2_ordering` |
| Higgs VEV + Dirac/Majorana split | ✅ | `higgs_vev_substrate_headline`, `higgs_mass_hierarchy_first_bundle_in_V2` |
| Baryogenesis / leptogenesis | ✅ | `BaryogenesisLeptogenesis.lean` |
| Cyclic cosmology | ✅ | `CyclicCosmology.lean` |
| BH information paradox | ✅ | `QuantumGravityBHInfo.lean` |
| **Grand Capstone V2** (Polaris cycle 43) | ✅ | `grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE` |
| **Meta-capstone** | ✅ | `omega_theory_v2_final_meta_capstone` |
| **8-axiom minimality** | ✅ | `omega_theory_minimal_constants_are_exactly_eight` |
| **Falsifiability panel** | ✅ | `omega_theory_falsifiability_witness_panel` |
| **4-irrational uniqueness** | ✅ | `four_irrationals_necessary_and_sufficient` |

## Current frontiers (cycles 44+ — OPEN)
- **Absolute particle masses**: `m_e`, `m_μ`, `m_τ`, quarks within 1% of PDG from
  Connes D_F eigenvalues alone (capstone research track)
- **CP-violation phase derivation** for baryogenesis (Grothendieck puzzle MP-8)
- **113 open `:TheoremCandidate` nodes** + **44 paper_worthy `:GraphFinding` nodes**
  (Neo4j `math`, measured 2026-04-21; 52 candidates already closed, 1 blocked)
- **`Real.pi_transcendental` axiom** (1 of the 5 primitive assumptions) — waiting
  on Mathlib Lindemann–Weierstrass
- **4 HermitePadé research axioms** (Siegel-Shidlovskii, Nesterenko 1996, Roth 1955,
  Mahler framework) — eliminated incrementally via `pi-formalizer`; elimination of
  any of these brings the 9-total down toward the 5-primitive-assumption floor
- **su(3) Jacobi identity**: still a hypothesis, fixable via `fin_cases` at high heartbeats
- **Non-abelian F = dA + [A,A]** full general bundle (partial progress in Tiaki cycle 29)
- **Proton mass / Λ_QCD**: unshipped after cycle 43; see `notes/NOTES_PROTON_MASS_SCOPE.md`
  Pathway A (δ_comp → Λ_QCD via one-loop RG)
- **Kempf β/γ/δ integration**: UV-cutoff / bandlimited-field / CMB-oscillation bridges
  all unshipped; see `notes/NOTES_KEMPF_BRIDGE.md` + `NOTES_KEMPF_DELTA_CMB.md`
- **Seeley-DeWitt 9 `Prop := True` sites**: closed-form `a₀/a₂/a₄` coefficients still
  parametric; see `notes/NOTES_SEELEY_DEWITT_DESIGN.md`
- **Clifford off-diagonal** ~~12 cases hypothesized~~ **CLOSED** (Tureis + Dubhe 2026-04-17,
  `DiracEquation.lean:209 gammaClifford_offDiagonal`)

## The Pi Hunch (central thesis)
OmegaTheory's deepest claim: **the irrationality of π produces quantum mechanics**,
and the **four irrationals** {π, e, √2, Catalan G} produce the **four channels**
(three active generations + one sterile/DM).

Chain: π irrational → can't be computed exactly → per-tick truncation error
`δ_comp(N) = ℓ_P·4/(2N+3)` from Leibniz series → extended Heisenberg
`ℏ/2 + δ_comp > ℏ/2` → QM is NECESSARY.

- **π-truncation**: `O(1/N)`, LARGEST residual δ  → heavy generation (top, etc.)
- **Catalan G**:    `O(1/(2N+1)²)` (quadratic)     → sterile / DM channel
- **e-truncation**: `O(1/N!)`,  factorial decay    → middle generation (charm, etc.)
- **√2-truncation**: super-exp `O(2^{-2^N})`       → light generation (up, etc.)
  (inserted as the 4th channel — see Mekbuda's `THEOREM_BACKLOG_CYCLES_24_43.md`;
  **asymptotic ordering is `π > G > e > √2` for N ≥ 6** — e decays O(1/N!) faster
  than G's O(1/(2N+1)²) past N=5. Corrected 2026-04-24 per meta-sage audit.)

### ⚠️ Convention correction (2026-04-17, still binding)
**"Hardest to compute" means MOST residual errors, not least.** π is hardest BECAUSE
it has the largest δ at any fixed N. Do NOT invert the ordering via Connes
`Λ = 1/δ`-style arguments — those conflate the UV spectral cutoff (gravity action
strength) with the fermion mass scale (D_F eigenvalues / Yukawa). The mapping
`m = f(δ)` is likely non-linear, but the **ordering stays: π heaviest, √2 lightest**.

Related infrastructure:
- `OmegaTheory/Irrationality/Approximations.lean` — truncated_pi/e/sqrt2/catalan_g
- `OmegaTheory/Irrationality/BoundsLemmas.lean` — error bounds
- `OmegaTheory/Irrationality/Uncertainty.lean` — δ_comp, iterationBudget
- `OmegaTheory/Irrationality/PredictionsBridge.lean` — π → QM chain
- `OmegaTheory/Irrationality/HermitePade/Decoupling.lean` — Theorem 4C.3 (0 sorry)
- `OmegaTheory/Predictions/SterileNeutrinoFromFourthIrrational.lean` — Catalan G channel
- `Real.pi_transcendental` axiom — waits on Mathlib Lindemann–Weierstrass

The probe file `OmegaTheory/Probe/PiAndOmegaStructure.lean` attempts the thesis in one line:
`irrationality_implies_quantum_uncertainty : ℏ/2 < ℏ/2 + computationalUncertainty N`

## Custom agents (`LeanFormalizationV2/.claude/agents/`)
All agent definitions are repo-pinned at `LeanFormalizationV2/.claude/agents/`.
- `omega-team-lead` — coordinates wizard + creative pairs in cycles
- `lean-proof-wizard` — Lean 4 specialist, all tactics, all build commands
- `quantum-physics-creative` — wild physics ideas + literature search
- `grothendieck-sage` — graph synthesis / gap hunting over the 184K-theorem Lean+Mathlib graph (canonical at `LeanFormalizationV2/.claude/agents/grothendieck-sage.md`; mirrored to `~/.claude/agents/` for global discoverability)
- `pi-irrationality-hunter` — Pi-Hunch specialist: π-truncation, transcendence, 3-generation hypothesis
- `pi-formalizer` — Lean formalization of π properties + Hermite–Padé
- `pi-physics-bridge` — π math → physical predictions (masses, QM, generations)

## Key references
- Diraq: Huang et al., Nature 627, 772–777 (2024) — first verified prediction
- Connes: noncommutative geometry spectral action
- Popławski: spin–torsion, baby-universe branch
- Similarity algebra: arXiv:2602.14075 (Feb 2026)
- ILL VCN: Ackermann et al., arXiv:2604.09312 (2026) — cold-neutron PRL target
