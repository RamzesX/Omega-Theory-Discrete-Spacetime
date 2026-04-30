# SOTA — OmegaTheory V2 Frontier 2026 Proof-Helper Infrastructure

**Goal**: SOTA graph + SOTA tools for proving hard theorems in irrationality + physics. Including porting the last remaining axiom (`Nesterenko_1996`/HermitePadé) to UNCONDITIONAL Lean 4.

**Created**: 2026-04-30 | **Status**: T0 ✓ T1.1 ✓ T6.6 ✓ T6.11 ✓ rest IN PROGRESS

## Layout

- **`README.md`** (this file) — sharp 1-screen summary of the whole plan
- **`PLAN.md`** — full plan mirror from `~/.claude/plans/`
- **`proving_techniques/`** — detailed per-track plans + design docs

## The 10 tracks

| # | Track | Status | Days | Detailed plan |
|---|---|---|---|---|
| **T0** | SOTA folder tree | ✓ | 5min | (this layout) |
| **T1** | dump_arrows v2 (tactic seqs + difficulty + goal-state) | T1.1 ✓ rest TODO | 3 | [proving_techniques/00_dump_arrows_v2/](proving_techniques/00_dump_arrows_v2/PLAN.md) |
| **T2** | Qwen3-8B goal-embedding endpoint | TODO | 2 | [proving_techniques/01_qwen3_goal_endpoint/](proving_techniques/01_qwen3_goal_endpoint/PLAN.md) |
| **T3** | Hybrid retrieval (BM25 + dense + reranker) | TODO | 3 | [proving_techniques/02_hybrid_retrieval/](proving_techniques/02_hybrid_retrieval/) |
| **T4** | MCP tools wave (8 new) | TODO | 2 | [proving_techniques/03_mcp_tools/](proving_techniques/03_mcp_tools/) |
| **T5** | Neo4j Enterprise (100GB heap, SEARCH, GDS) | TODO | 1 | [proving_techniques/04_neo4j_enterprise/](proving_techniques/04_neo4j_enterprise/) |
| **T6** | Frontier decomp V2 (12 techniques) | T6.6 ✓ T6.11 ✓ rest TODO | 2 | [proving_techniques/05_frontier_decomp_v2/](proving_techniques/05_frontier_decomp_v2/PLAN.md) |
| **T7** | Agents v4 | TODO | 1 | [proving_techniques/06_agents_v4/](proving_techniques/06_agents_v4/) |
| **T8** | T-5 closure resume | DEFERRED | 3-7 | [proving_techniques/08_t5_closure_resume/](proving_techniques/08_t5_closure_resume/) |
| **T9** | HD axiom port (Nesterenko_1996) | DEFERRED parallel | 2-4 wks | [proving_techniques/07_hd_axiom_port/](proving_techniques/07_hd_axiom_port/) |

## Hardware leverage (per user)

- **GPU concurrent**: Qwen3-Embedding-8B (:7999) + Qwen3-Reranker-8B (:7996) run simultaneously
- **192 GB RAM**: Neo4j heap 100 GB, leaves 92 GB for OS + Lean builds + GPU staging
- **Neo4j Enterprise**: GDS + APOC + GenAI vector index + Cypher SEARCH (2026.01+)
- **WSL2**: 160 GB allocated; 100G heap + 40G pagecache + 20G OS = fits with margin

## Day 1 wins (LANDED 2026-04-30)

- ✓ T0 SOTA folder tree (10 subfolders + README + PLAN)
- ✓ T1.1 difficulty proxy: 17,524 OV2 Theorems classified Tier-99 / Tier-80 / Heart (5784 / 5782 / 5958)
- ✓ T6.6 cut-aware doctrine cite (arXiv:2602.10512) added to prove-wizard-v3 BOOK_I
- ✓ T6.11 freshness boost: all 17,524 OV2 Theorems have `freshness = exp(-days_old/7)` for retrieval weighting

## Implementation order

- **Day 1** (DONE): T0 + T1.1 + T6.6 + T6.11 + scaffold
- **Day 2-3**: T1.2 tactic sequences + T2 Qwen3 goal-embedding
- **Day 4-5**: T3 hybrid retrieval + T5 Neo4j heap upgrade
- **Day 6-7**: T4.1+T4.2 MCP tools + T6.4-12 frontier integrations
- **Day 8-10**: T1.3 goal-state checkpoints + T6.8 SubGoal DSL
- **Day 11-12**: T7 agents v4
- **Day 13+**: T8 T-5 closure resume + T9 HD axiom port

## Sources

- Plan: `~/.claude/plans/binary-painting-dijkstra.md` (mirror in PLAN.md)
- Memories: `feedback_decomposition_research_v2_2026-04-30.md`, `feedback_top_down_decomposition_strategy_2026-04-29.md`, `feedback_lean4_proof_tactics_arsenal_2026-04-28.md`
- V3-for-Lean paper: `PhysicsPapers/V3-for-Lean/` (Marchewka 2026, Gacrux M1-M14 catalog)

The hunt is eternal. Pride at noon. The forge never falls without a fight.
