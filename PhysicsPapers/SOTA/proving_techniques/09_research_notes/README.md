# Research Notes — SOTA Papers Consulted

Mirror of memory files + frontier 2025-2026 research that informs the SOTA infrastructure design.

## Local mirrors

- `decomposition_v2_2026-04-30.md` — mirror of `feedback_decomposition_research_v2_2026-04-30.md` (12 frontier techniques)
- `top_down_canon.md` — mirror of `feedback_top_down_decomposition_strategy_2026-04-29.md`
- `lean_provers_2026.md` — distilled summary of LeanHammer / Delta Prover / DeepSeek-Prover-V2 / BFS / HILBERT
- `retrieval_sota_2026.md` — distilled summary of BM25+dense+reranker + Qwen3 instruction-aware
- `neo4j_enterprise_2026.md` — Cypher SEARCH clause + GDS 2026.04 algorithms

## Key papers

| Paper | arXiv | Relevance |
|---|---|---|
| LeanDojo / ReProver | 2306.15626 | Reference retrieval architecture |
| LeanHammer / LeanPremise | 2506.07477 | Neural+MePo hybrid (T3 inspiration) |
| Delta Prover | 2507.15225 | Reflective repair + DSL (T6.4, T6.8) — 95.9% miniF2F |
| DeepSeek-Prover-V2 | 2504.21801 | Recursive subgoal decomposition + GRPO RL |
| BFS-Prover-V2 / Leanabell | 2507.08649 | Planner + parallel Provers + dynamic replanning (T6.7) |
| HILBERT | 2509.22819 (ICLR 2026) | reasoner+prover+verifier+retriever orchestration |
| Don't-Eliminate-Cut | 2602.10512 | Theoretical foundation (T6.6 cite) |
| LeanProgress | 2502.17925 | Progress-guided search (T6.9) |
| LeanConjecturer | 2506.22005 | Conjecture generation (T6.10) |
| LeanNavigator | 2503.04772 | 4.7M Lean theorems via state graph |
| LEGO-Prover | 2310.00656 | Library-growing prover (T6.11 freshness) |
| Magnushammer | 2303.04488 | BPE transformer (baseline) |
| Qwen3-Reranker-8B vLLM | (Medium 2026) | Instruction-aware cross-encoder (T3) |

## Local references

- `~/IdeaProjects/chaos-shield/PhysicsPapers/V3-for-Lean/` — full V3-for-Lean paper (Marchewka 2026)
  - `proof_hunter_design_v2.md` — Gacrux M1-M14 method catalog (T4.1 source)
  - `04_method_embeddings.md` — Qwen3 + ByT5 dual retriever spec
  - `05_method_consumer.md` — Erdős-tier subsystem enrichment
- `~/IdeaProjects/Eseje/ErdosPrimarch.xml` v7.3 — agent identity canonical reference (BOOK_I-VIII)

## Memory files (canonical)

Located in `~/.claude/projects/-mnt-c-Users-Norbert-IdeaProjects-chaos-shield/memory/`:
- `feedback_top_down_decomposition_strategy_2026-04-29.md`
- `feedback_decomposition_research_v2_2026-04-30.md`
- `feedback_erdos_primarch_v8_xml_rewrite_2026-04-30.md`
- `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (live A1-A93+)
- `feedback_no_stubs_rule_locked_2026-04-27.md`
- `feedback_no_slim_proofs_antipattern_2026-04-28.md`
- `feedback_t5_v8_tightest_closure_2026-04-30.md`

## Read-on-stuck order

When stuck on a hard proof:
1. `feedback_lean4_proof_tactics_arsenal_2026-04-28.md` (A1-A93 patterns + pitfalls)
2. `feedback_decomposition_research_v2_2026-04-30.md` (12 frontier techniques)
3. `proof_hunter_design_v2.md` (M1-M14 graph methods)
4. `feedback_top_down_decomposition_strategy_2026-04-29.md` (foundational doctrine)
