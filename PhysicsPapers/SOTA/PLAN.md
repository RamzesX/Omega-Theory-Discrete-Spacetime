# SOTA Proof-Helper Infrastructure — Frontier 2026 Build Plan

## Context

The user wants to **stop chasing T-5 atom-by-atom** and instead **build the proof-helper infrastructure** that will close T-5 (and every other hard theorem in irrationality + physics) much faster.

**Why now**:
- T-5 V8-atom-1 strict has been factored to TC1-monomial UNCONDITIONAL ✓ (commit 3eed094) + Hi-Glue residual.
- The V3-for-Lean paper (`PhysicsPapers/V3-for-Lean/`) already specifies the SOTA blueprint (Qwen3-8B + ByT5 dual retriever, 14 hunter methods, FastRP fusion, Leiden subsystems).
- Infrastructure gaps remain: `dump_arrows` captures only 12 of 15 V3 arrows, no tactic sequences, no goal-state checkpoints, no LeanDojo-tier active-proof retrieval, no hybrid BM25+dense+reranker pipeline.
- Hardware is over-provisioned vs current use: **192 GB RAM, GPU running Qwen3-Embedding-8B (:7999) AND Qwen3-Reranker-8B (:7996) CONCURRENTLY, Neo4j Enterprise (can take 100 GB heap)**. We're using ~20% of available capacity.
- The 1 remaining axiom (`Nesterenko_1996` in `HermitePade/`) needs porting; current tools won't suffice.

**Goal**: a `PhysicsPapers/SOTA/` folder housing all advanced infrastructure work + the actual built tools, leveraging FULL hardware power for SOTA graph + SOTA proof-flow retrieval.

**User mandates** (verbatim, this turn):
- "create on disk special folder SOTA"
- "first infra and best SOTA graph for the proof writing, completing"
- "embeeder and rernaker are working on the same time" (concurrent GPU advantage)
- "192GB of ram and neo4j database can have even the 100GB ram"
- "we need full power and full infra power"
- "the targer is infra first" (latest message)

## Recommended approach

Build infra FIRST in 8 sequenced tracks (T0-T7), then resume T-5 closure (T8) with the new tooling. Each track ships standalone — no track blocks the next.

```
                         FOLDER (T0)
                            │
                            ▼
DUMP_ARROWS v2 (T1) ── QWEN3 GOAL EMBED (T2) ── HYBRID RETRIEVAL (T3)
        │                       │                      │
        ▼                       ▼                      ▼
                     MCP TOOLS WAVE (T4) ──── NEO4J ENTERPRISE (T5)
                            │                      │
                            ▼                      ▼
                  FRONTIER DECOMP V2 (T6) ── AGENTS v4 (T7)
                            │                      │
                            ▼                      ▼
                          T-5 CLOSURE RESUME (T8)
                          HD AXIOM PORT (T9, parallel)
```

## SOTA folder structure (T0 — create FIRST)

Path: `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/SOTA/`

```
SOTA/
├── README.md                         ← master index, status table, hardware leverage notes
├── PLAN.md                           ← this plan, mirrored
├── 00_dump_arrows_v2/                ← T1
│   ├── PLAN.md
│   ├── 01_difficulty_proxy.md       (Layer 1.2 — 1 hour, 30 lines Python)
│   ├── 02_tactic_sequences.md       (Layer 1.1 — 1 day, ~80 lines Lean)
│   └── 03_goal_state_checkpoints.md (Layer 1.3 — heavy, ~300 lines Lean LSP)
├── 01_qwen3_goal_endpoint/           ← T2 (~120 lines Python on existing :7999 server)
│   ├── PLAN.md
│   └── design.md                    ← POST /v1/goal_embeddings
├── 02_hybrid_retrieval/              ← T3 (BM25 + dense Qwen3 + Qwen3 reranker, concurrent on GPU)
│   ├── PLAN.md
│   ├── architecture.md              ← bi-encoder + cross-encoder, RRF fusion + reranker
│   ├── bm25_layer.md                ← Tantivy/Lucene OR Neo4j FTS over signature+docstring
│   └── instruction_aware.md         ← Qwen3-Reranker-8B instruction-aware rerank
├── 03_mcp_tools/                     ← T4
│   ├── PLAN.md
│   ├── omega_orchestrator_5_new.md  ← propose_conjecture, find_missing_edges, find_keystones,
│   │                                  find_iff_cycles, find_bridge_lemmas
│   └── omega_search_3_new.md        ← goal_to_premises, goal_to_proof_step, tactic_continuation
├── 04_neo4j_enterprise/              ← T5
│   ├── PLAN.md
│   ├── 01_heap_100gb.md             ← neo4j.conf: server.memory.heap.{initial,max}_size=100G
│   ├── 02_search_clause.md          ← migrate from db.index.vector.queryNodes to Cypher SEARCH
│   ├── 03_gds_enterprise.md         ← Apache Arrow import/export, cluster write workloads
│   └── 04_full_text_indexes.md      ← BM25 layer in Neo4j FTS (alternative to Tantivy)
├── 05_frontier_decomp_v2/            ← T6 (12 techniques from feedback_decomposition_research_v2)
│   ├── PLAN.md
│   ├── 01_nl_sketch_phase_a0.md
│   ├── 02_consistency_alignment.md
│   ├── 03_type_a_variants.md
│   ├── 04_reflective_repair_loop.md
│   ├── 05_failure_extraction_named.md
│   ├── 06_cut_aware_doctrine.md
│   ├── 07_dynamic_replanning.md
│   ├── 08_subgoal_dsl.md
│   ├── 09_progress_prediction.md
│   ├── 10_conjecture_generation.md
│   ├── 11_library_freshness.md
│   └── 12_two_mode_generation.md
├── 06_agents_v4/                     ← T7
│   ├── PLAN.md
│   ├── prove-wizard-fast.md         ← routine/medium fast-path
│   ├── irrationality-hunter-v2.md   ← upgraded for HD axiom port + π/e/√2/G research
│   └── grothendieck-sage-v2.md      ← uses new MCP tools + frontier decomp
├── 07_hd_axiom_port/                 ← T9 (parallel track)
│   ├── PLAN.md
│   ├── references.md                ← Nesterenko 1996, Siegel-Shidlovskii, Mahler framework
│   └── decomposition.md             ← apply 5-PHASE HYBRID + frontier V2 to HermitePade
├── 08_t5_closure_resume/             ← T8 (post-infra)
│   └── PLAN.md                      ← Hi-Glue + V7N1U + 3 SM + V8 capstone using new tools
└── 09_research_notes/                ← SOTA papers consulted, mirrors of memory
    ├── decomposition_v2_2026-04-30.md (mirror of memory)
    ├── retrieval_sota_2026.md
    ├── neo4j_enterprise_2026.md
    └── lean_provers_2026.md         ← LeanHammer, Delta Prover, DeepSeek-Prover-V2, BFS, HILBERT
```

Each track folder has a `PLAN.md` with: goal, files-to-edit, line counts, verification, dependencies.

## Track-by-track implementation

### T0 — SOTA folder (5 minutes)

Action: `mkdir -p PhysicsPapers/SOTA/{00..09}_*` + write `README.md` + `PLAN.md` mirror.

Critical files:
- `PhysicsPapers/SOTA/README.md` — master index with status table
- `PhysicsPapers/SOTA/PLAN.md` — this plan mirrored

Verification: `ls PhysicsPapers/SOTA/` shows 10 subfolders + 2 files.

### T1 — dump_arrows v2 (~3 days)

Three sub-layers, ordered by ROI:

**T1.1 — Difficulty proxy (1 hour)**
- Edit `~/lean-v2/.neo4j/load_arrows_parallel.py` (~30 lines added)
- Compute per-Theorem: `difficulty = log(byte_len) + 0.3·#applies + 0.5·count("have"|"obtain"|"refine") + 1.0·count_NAMED`
- Add `tier: "99" | "80" | "Heart"` based on difficulty quantiles (0.33/0.66 splits)
- Verification: Cypher `MATCH (t:Theorem) WHERE t.tier IS NOT NULL RETURN t.tier, count(*)` shows distribution

**T1.2 — Tactic sequences (1 day)**
- Edit `~/lean-v2/OmegaTheory/Meta/DumpArrows.lean` (~80 lines added)
- Parse `Syntax` from `thmInfo.value` via `Lean.Elab.Tactic` — extract ordered list of tactic head names
- Emit `tactics: ["intros", "obtain", "rw", "linarith"]` field per Theorem JSONL record
- Update `~/lean-v2/.neo4j/load_arrows_parallel.py` to ingest the new field as Theorem property
- Verification: `lake build OmegaTheory.Meta.DumpArrows` GREEN; sample 5 OV2 theorems and confirm tactic arrays match Read of file

**T1.3 — Goal-state checkpoints (1 week, defer to Day 8-10)**
- NEW file `~/lean-v2/OmegaTheory/Meta/DumpProofSteps.lean` (~300 lines)
- LSP-driven secondary pass: for each `thmInfo`, materialize proof state at every tactic boundary via `Lean.Elab.Tactic.evalTactic` snapshot capture
- Emit `:ProofStep {parent_thm, step_idx, goal_str, tactic, goal_after_str}` JSONL records
- New loader `~/lean-v2/.neo4j/load_proof_steps.py`
- Verification: Cypher `MATCH (t:Theorem)-[:HAS_STEP]->(ps:ProofStep) RETURN count(ps)` ~ 50K-200K nodes

### T2 — Qwen3 goal-embedding endpoint (2 days)

- Edit `~/lean-v2/V3-for-Lean/code/servers/qwen3_embedding_server.py` (~120 lines added)
- Add `POST /v1/goal_embeddings` — same model, same bf16, same throughput (~29 goals/sec)
- Goal string prefix `[goal] ` to differentiate from corpus prefixes (`[theorem] [axiom] [definition] ...`)
- Co-existence: existing reranker port 7996 untouched (independent process; both run concurrently per user)
- Verification: `curl -X POST http://localhost:7999/v1/goal_embeddings -d '{"goals":["⊢ ∀ x, x = x"]}'` returns 4096-d vector

### T3 — Hybrid retrieval pipeline (3 days)

The user's hardware advantage: GPU runs **Qwen3-Embedding-8B (:7999) + Qwen3-Reranker-8B (:7996) CONCURRENTLY**. Best 2026 architecture for this is the **dual-stage hybrid**: BM25 (recall) → Qwen3 dense (semantic recall) → Qwen3 reranker (precision).

- New file `~/lean-v2/.neo4j/hybrid_retriever.py` (~200 lines)
- Stage 1 (recall, top-100): hybrid BM25 (Neo4j full-text index OR external Tantivy) + Qwen3 dense kNN, fuse via Reciprocal Rank Fusion (RRF, k=60)
- Stage 2 (precision, top-10): Qwen3-Reranker-8B cross-encoder rescoring with **instruction-aware prompts** ("rate relevance of this premise for this proof goal")
- Replace existing `omega_hammer_premise` internal logic to use this pipeline
- Verification: benchmark recall@10 on 100-goal dev slice — target ≥75% (existing single-retriever ~62%)

### T4 — MCP tool wave (2 days)

**T4.1 — omega-orchestrator: 5 new tools (1 day, ~250 lines)**
- Locate server source: first action is `find /home/norbert -name "*orchestrator*server*" -o -name "*mcp*omega*"`
- Add tools (each is a Cypher-recipe wrapper, recipes already in `proof_hunter_design_v2.md` M1-M14):
  - `propose_conjecture(seed_theorem, k=10)` — M3 embedding-structure mismatch + M4 Mendeleev cell
  - `find_missing_edges(target, k=10)` — M2 Adamic-Adar link prediction
  - `find_keystones(k=20)` — M13 articulation points (definitive SPOF)
  - `find_iff_cycles()` — M12 SCC in APPLIES DAG (latent iff-equivalences)
  - `find_bridge_lemmas(threshold=-0.9)` — M6 negative-Ricci bridge edges
- Verification: each tool returns expected schema; one MCP call from prove-wizard-v3 succeeds

**T4.2 — omega-search: 3 new tools (1 day)**
- `goal_to_premises(goal_string, k=20)` — uses Qwen3 goal-embedding endpoint (T2) → kNN against Theorem corpus → reranker (T3)
- `goal_to_proof_step(goal_string, k=10)` — kNN against `:ProofStep.goal_str` (after T1.3) → returns next-tactic suggestions
- `tactic_continuation(prefix=["intros","obtain"], k=10)` — match `:Theorem.tactics` prefix → return next-tactic distribution
- Verification: `goal_to_premises("⊢ rothIndex P q R ≤ t - √(mε)")` returns OV2+Mathlib top-20

### T5 — Neo4j Enterprise leverage (1 day)

**T5.1 — 100 GB heap config**
- Edit `<neo4j_home>/conf/neo4j.conf`: `server.memory.heap.initial_size=100G`, `server.memory.heap.max_size=100G`, `server.memory.pagecache.size=40G`
- WSL2 has 160 GB allocated; 100G heap + 40G pagecache + ~20G OS = fits with ~20G margin
- Restart Neo4j; verify via `mcp__omega-orchestrator__servers_control(action='status')`
- Start with 80G/30G if peak-pressure unknown; bump only if 80G is breached

**T5.2 — Cypher SEARCH clause migration (Neo4j 2026.01+)**
- Replace `CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', k, $vec)` with `CYPHER SEARCH ... USING VECTOR ...` (preferred per 2026.04 deprecation note)
- Edit `~/lean-v2/.neo4j/*.py` files using the old call (~10 sites)
- Verification: existing test suite still passes; Cypher EXPLAIN shows new SEARCH plan

**T5.3 — GDS Enterprise features**
- Verify Enterprise license via `CALL gds.license.state()`
- Enable Apache Arrow import/export for graph backups (eliminates ingest race conditions)
- Add cluster-aware write workloads if multi-instance becomes needed
- New algorithm: `gds.cliqueCounting.stream` for tightly-coupled subsystem detection

### T6 — Frontier decomposition V2 integrations (2 days, mostly rule + Cypher)

12 techniques from `feedback_decomposition_research_v2_2026-04-30.md`. Top 4 ship Day 1, rest Day 2.

**Day 1 (high-ROI quick wins)**:
- 11. **Library freshness boost** (1 hr) — Cypher `MATCH (t:Theorem) WHERE t.committed_at IS NOT NULL SET t.freshness = exp(-(now - t.committed_at) / 7d)` + `omega_hammer_premise` adds 0.2·freshness to score
- 1. **NL sketch in Phase A.0** — rule update only; add to `prove-wizard-v3` BOOK_I COMBAT_DOCTRINE
- 3. **Type-(a) standalone variants** — rule + audit existing Type-(b) NAMED Props for missing standalone forms
- 6. **Cut-aware doctrine cite** — add reference to `arXiv:2602.10512` in `prove-wizard-v3` BOOK_I

**Day 2 (medium-ROI)**:
- 4. **Reflective repair loop** — codify in `prove-wizard-v3` BOOK_IV phase 4 (manual fallback)
- 5. **Failure-extraction NAMED Prop** — new `propose_named_from_failure` MCP tool (omega-orchestrator)
- 10. **Conjecture generation tool** — new `propose_conjecture_from_proven` (subset of T4.1's `propose_conjecture`)
- 7. **Dynamic replanning trigger** — rule: stuck>3 fires → auto-spawn sub-factoring agent
- 9. **Progress-prediction tiny model** — train on 17.5K OV2 (input: goal_embedding, target: tactics_remaining)
- 12. **Two-mode (fast/deep)** — ship `prove-wizard-fast` (T7)
- 2. **Consistency-penalty rule** — add to `prove-wizard-v3` BOOK_VII FORBIDDEN
- 8. **SubGoal DSL** — new `~/lean-v2/OmegaTheory/Meta/SubgoalDSL.lean` (~200 lines macros)

### T7 — Agents v4 (1 day)

Three agent files in `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/`:

**T7.1 — `prove-wizard-fast.md`** (~300 lines XML, slim variant of v3)
- Trigger: `difficulty<0.3` OR explicit `/prove-fast`
- Skip Phases A/B/D/E; just automation cascade (`exact?` → `aesop` → `grind` → `linarith` → `omega`)
- Saves ~60% time on Tier-99 obligations

**T7.2 — `irrationality-hunter-v2.md`** (~700 lines XML)
- Specialized for π/e/√2/Catalan G research + HD axiom port
- Pantheon emphasis: Niven, Apéry, Hermite, Lindemann-Weierstrass, Nesterenko, Mahler, Rivoal-Zudilin
- New MCP cascade: T2 goal embedding + T4.2 `goal_to_premises` + T4.1 `propose_conjecture`
- Use case: T-5 Hi-Glue, T-4 successors, HD axiom port

**T7.3 — `grothendieck-sage-v2.md`** (update existing ~600 lines XML)
- Add T4 MCP tools to its toolbox
- Update for 5-PHASE HYBRID + frontier V2 techniques
- Maintain role separation (sage proposes `.md` only, never edits `.lean`)

### T8 — T-5 closure resume (POST-infra, ~3-7 days)

After T1-T7 land, return to T-5:
- **Hi-Glue discharge** — use new `goal_to_proof_step` MCP to find analogous proofs for AM-QM √(mε) birth pattern
- **V7N1U-D5 monolithic** (~200 lines) — sub-factor via SubGoal DSL (T6.8) + reflective repair (T6.4)
- **3 SM (Schmidt machinery)** — use `propose_conjecture_from_proven` to surface analogous Schmidt aux constructions in Mathlib
- **V8 capstone** — final composition + `axiom_audit` Lean-core only + Yoneda bridge sweep

### T9 — HD axiom port (PARALLEL track, longer-term)

Port `Nesterenko_1996` axiom in `~/lean-v2/OmegaTheory/Irrationality/HermitePade/` to UNCONDITIONAL Lean proof.

This is the analogue of T-4's `Real.pi_transcendental` retirement. Apply the same workflow:
- 5-PHASE HYBRID composition (state hard, factor, discharge)
- Use new infra (T1-T7) to accelerate retrieval + decomposition
- Multiple parallel sub-factoring fires per `irrationality-hunter-v2`
- Estimated 2-4 weeks single-thread (T-4 was 1 day for π but had Mathlib L-W partial; HD has nothing upstream)

## Critical files (modified or created)

**Modified**:
- `~/lean-v2/OmegaTheory/Meta/DumpArrows.lean` (T1.2 tactic sequences)
- `~/lean-v2/.neo4j/load_arrows_parallel.py` (T1.1 difficulty proxy + T1.2 tactic ingest)
- `~/lean-v2/V3-for-Lean/code/servers/qwen3_embedding_server.py` (T2 goal endpoint)
- `~/lean-v2/.neo4j/*.py` (T5.2 SEARCH clause migration, ~10 sites)
- `<neo4j_home>/conf/neo4j.conf` (T5.1 100 GB heap)
- `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/grothendieck-sage.md` (T7.3 v2)
- `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/prove-wizard-v3.md` (T6 doctrine integrations)

**Created**:
- `chaos-shield/PhysicsPapers/SOTA/` (entire folder tree, T0)
- `~/lean-v2/OmegaTheory/Meta/DumpProofSteps.lean` (T1.3 goal-state checkpoints)
- `~/lean-v2/OmegaTheory/Meta/SubgoalDSL.lean` (T6.8 DSL macros)
- `~/lean-v2/.neo4j/hybrid_retriever.py` (T3 BM25+dense+reranker pipeline)
- `~/lean-v2/.neo4j/load_proof_steps.py` (T1.3 loader)
- `<omega-orchestrator-MCP>/tools/{propose_conjecture,find_missing_edges,find_keystones,find_iff_cycles,find_bridge_lemmas}.py` (T4.1)
- `<omega-search-MCP>/tools/{goal_to_premises,goal_to_proof_step,tactic_continuation}.py` (T4.2)
- `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/prove-wizard-fast.md` (T7.1)
- `chaos-shield/PhysicsPapers/LeanFormalizationV2/.claude/agents/irrationality-hunter-v2.md` (T7.2)

## Reused functions / utilities

- `mcp__omega-orchestrator__omega_hammer_premise` — extend internal scoring with reranker (T3)
- `mcp__omega-search__find_similar` — extend with goal-embedding input (T4.2)
- `qwen3_embedding_server.py` — add endpoint (T2), reuse existing model + tokenizer
- Qwen3-Reranker-8B at :7996 — add cross-encoder rerank stage (T3); already running concurrently
- `Lean.Elab.Tactic.evalTactic` — Lean 4 stdlib for goal-state capture (T1.3)
- `MvPolynomial.induction_on'` pattern (validated 2026-04-30 on TC1-monomial) — port to SubgoalDSL primitives (T6.8)
- `Finset.exists_min_image` (validated by Hi-1 fire) — primitive for `SubGoal.ShowBy` combinator
- Existing 14 Cypher recipes in `proof_hunter_design_v2.md` M1-M14 — direct wrap as MCP tools (T4.1)
- Lean 4 LSP `Lean.Server.lspWriteRequest` for LSP-driven secondary pass (T1.3)

## Hardware leverage (per user reminder)

- **GPU concurrent**: Qwen3-Embedding-8B (:7999) + Qwen3-Reranker-8B (:7996) run simultaneously without conflict — T3 hybrid pipeline can pipeline embed + rerank without GPU contention
- **192 GB RAM**: T5.1 takes 100 GB for Neo4j heap, leaves 92 GB for OS + Lean builds + GPU staging
- **Neo4j Enterprise**: T5.3 unlocks Apache Arrow + cluster write + new GDS algorithms (clique counting, Min-Cost Max Flow)
- **WSL2 160 GB**: 100G heap + 40G pagecache + ~20G OS = fits with ~20G margin

## Verification plan (end-to-end)

After all tracks land:

1. **T0 SOTA folder**: `tree PhysicsPapers/SOTA/` shows 10 subfolders + ≥30 PLAN.md files.
2. **T1 dump_arrows v2**: Cypher `MATCH (t:Theorem {namespace:'OmegaTheoryV2'}) WHERE t.tactics IS NOT NULL AND t.difficulty IS NOT NULL RETURN count(t)` ~ 17.5K (full coverage).
3. **T2 Qwen3 goal endpoint**: `curl POST :7999/v1/goal_embeddings` returns 4096-d vector for a Lean goal string.
4. **T3 hybrid retrieval**: benchmark `recall@10` on 100-goal dev slice ≥ 75% (vs current ~62%).
5. **T4 MCP tools**: 8 new tools available; each one returns expected schema for a sample input.
6. **T5 Neo4j Enterprise**: heap 100 GB, GDS license active, Cypher SEARCH clause works.
7. **T6 frontier V2**: 12 integrations live; `omega_hammer_premise` boosts freshness; `prove-wizard-v3` references cut-aware doctrine.
8. **T7 agents v4**: 3 agent files, each builds correctly when invoked via Agent tool.
9. **T8 T-5 resume**: Hi-Glue discharge attempt uses `goal_to_proof_step` MCP — completes in <half the previous fire-count.
10. **Closure**: `mcp__omega-orchestrator__axiom_audit(targets=["omega_theory_v2_T5_roth_paper_headline_V8"])` returns Lean-core only.

## Risk register

| # | Risk | Probability | Mitigation |
|---|---|:-:|---|
| 1 | T1.3 goal-state extraction blocks (Lean LSP secondary-pass non-trivial) | MED | Defer to Day 8-10; ship T1.1+T1.2 first as 80% value |
| 2 | T3 hybrid retrieval doesn't beat baseline on small dev slice | LOW | Increase dev slice to 500 goals; tune RRF k, λ, top-100 cutoff |
| 3 | T5.1 100 GB heap causes WSL2 OOM under load | MED | Start with 80 GB; monitor; bump only if peak page-cache pressure justifies |
| 4 | T4 MCP server source files not where expected | LOW | First action of T4: `find /home/norbert -name "*orchestrator*server*"` and `*search*server*` |
| 5 | T9 HD axiom port harder than T-4 (Nesterenko has no Mathlib partial) | HIGH | Defer T9 until T1-T8 land + measure baseline acceleration |

## Implementation order (sequenced, infra-first)

**Day 1** (~6 hours, all Tier-99 quick wins):
- T0 SOTA folder
- T1.1 difficulty proxy (1 hr)
- T6 freshness boost (1 hr)
- T6 Type-(a) variant rule + cut-aware doctrine cite (rule-only)
- T2 begin Qwen3 goal-endpoint design

**Day 2-3**:
- T1.2 tactic sequences extraction
- T2 ship Qwen3 goal-embedding endpoint
- T4.2 begin `goal_to_premises` (depends on T2)

**Day 4-5**:
- T3 hybrid retrieval pipeline (BM25 + Qwen3 dense + Qwen3 reranker, instruction-aware)
- T5.1+T5.2 Neo4j heap upgrade + SEARCH clause migration

**Day 6-7**:
- T4.1 5 omega-orchestrator MCP tools
- T4.2 finish `goal_to_premises`
- T6.4-12 remaining frontier integrations

**Day 8-10**:
- T1.3 goal-state checkpoints (heaviest piece)
- T4.2 `goal_to_proof_step` + `tactic_continuation` (depend on T1.3)
- T6.8 SubGoal DSL

**Day 11-12**:
- T7 agents v4 (`prove-wizard-fast` + `irrationality-hunter-v2` + `grothendieck-sage-v2`)

**Day 13+**:
- T8 T-5 closure resume (Hi-Glue, V7N1U, 3 SM, V8 capstone) using new infra
- T9 HD axiom port (parallel)

## Decomposition strategy applied (5-PHASE HYBRID, meta)

This plan ITSELF was forged via the 5-PHASE HYBRID:
- **Phase A** TOP_DOWN STATEMENT: state goal (SOTA infra-first), identify 9 tracks (T0-T8) + 1 deferred (T9)
- **Phase B** TRUTH_RANK: T0 = trivial routine (folder creation); T1.1, T6 freshness/cite/Type-(a) = Tier-99 (1-hr each); T2, T3, T5 = Tier-80 (days each); T1.3 = Heart-tier (1 week)
- **Phase C** DISCHARGE per tier: ship Tier-99 Day 1; Tier-80 Days 2-7; Heart-tier Days 8-10
- **Phase D** BOTTOM_UP fill: SubGoal DSL primitives + Lean LSP scaffolding when needed
- **Phase E** COMPOSE: end-to-end verification (10 checks above) + Yoneda bridge to existing OV2 corpus + axiom_audit on T-5 V8 capstone

The hunt is eternal. Pride at noon. The lion does not blink.
The forge never falls without a fight. Frontier mathematics is solved here, single-thread, NO STUBS.

## Sources (frontier 2025-2026 research)

- [LeanHammer / LeanPremise — arXiv 2506.07477](https://arxiv.org/html/2506.07477) — neuro-symbolic premise selection, hybrid neural+MePo
- [Qwen3-Reranker-8B vLLM deployment](https://medium.com/@kimdoil1211/deploying-qwen3-reranker-8b-with-vllm-instruction-aware-reranking-for-next-generation-retrieval-c35a57c9f0a6) — instruction-aware cross-encoder rerank
- [Hybrid retrieval BM25+dense — 2026 dev.to guide](https://dev.to/kuldeep_paul/advanced-rag-from-naive-retrieval-to-hybrid-search-and-re-ranking-4km3)
- [Neo4j 2026 GenAI plugin + Cypher SEARCH](https://neo4j.com/docs/cypher-manual/current/indexes/semantic-indexes/vector-indexes/)
- [Neo4j GDS 2026.04](https://neo4j.com/docs/graph-data-science/current/) — Enterprise edition algorithms
- [Don't Eliminate Cut — arXiv 2602.10512](https://arxiv.org/html/2602.10512) — exponential separation for hierarchical proving
- [DeepSeek-Prover-V2 — arXiv 2504.21801](https://arxiv.org/html/2504.21801v1)
- [Delta Prover (95.9% miniF2F) — arXiv 2507.15225](https://arxiv.org/html/2507.15225v1)
- [BFS-Prover-V2 / Leanabell — arXiv 2507.08649](https://arxiv.org/html/2507.08649v1)
- [HILBERT — ICLR 2026](https://arxiv.org/pdf/2509.22819)
- [V3-for-Lean local paper](file:///mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/V3-for-Lean/proof_hunter_design_v2.md) — Gacrux M1-M14 catalog
- [feedback_decomposition_research_v2_2026-04-30.md (memory)](file:///home/norbert/.claude/projects/-mnt-c-Users-Norbert-IdeaProjects-chaos-shield/memory/feedback_decomposition_research_v2_2026-04-30.md)
