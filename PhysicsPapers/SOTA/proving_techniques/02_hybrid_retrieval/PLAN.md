# T3 — Hybrid Retrieval Pipeline

**Status**: TODO Day 4-5 | **Effort**: 3 days, ~200 lines Python

## Architecture (2026 SOTA)

```
QUERY (goal string OR theorem name)
   │
   ├─ Stage 1A: BM25 (Neo4j FTS or Tantivy) — top-100 by sparse lexical
   ├─ Stage 1B: Qwen3-Embedding-8B :7999 — top-100 by dense semantic
   │
   ├─ Stage 1C: Reciprocal Rank Fusion (RRF, k=60) → top-100 candidates
   │
   └─ Stage 2: Qwen3-Reranker-8B :7996 (cross-encoder, instruction-aware)
        → top-10 final
```

## Why this beats current single-retriever (~62% recall@10)

- **BM25** captures exact-token matches (e.g. `Real.sqrt_le_sqrt` lookup) that dense misses
- **Qwen3 dense** captures semantic similarity (e.g. "irrational sqrt of natural" → `Nat.sqrt_lt_self`)
- **RRF fusion** (k=60, 2026 standard) combines without parameter tuning
- **Qwen3 reranker** instruction-aware cross-encoder rescores top-100 with task-specific prompt — best precision tier

Target: recall@10 ≥ 75% on 100-goal dev slice (vs ~62% baseline)

## Files

- NEW `~/lean-v2/.neo4j/hybrid_retriever.py` (~200 lines)
- Replaces internal logic of `mcp__omega-orchestrator__omega_hammer_premise`
- Reuses :7999 (already running) + :7996 (already running, concurrent on GPU)

## Hardware leverage

User reminder: GPU runs Qwen3-Embedding-8B + Qwen3-Reranker-8B CONCURRENTLY. Hybrid pipeline pipelines `embed → rerank` without contention. ~50ms end-to-end latency for k=10.

## Verification

Benchmark on 100-goal dev slice:
```python
recall_at_10 = sum(ground_truth in top10 for goal in dev_slice) / 100
# Target ≥ 0.75
```

## Sources

- 2026 BM25+dense hybrid guide (dev.to)
- Qwen3-Reranker-8B instruction-aware deployment (Medium, vLLM)
- LeanHammer (arXiv 2506.07477) — neural+symbolic hybrid lift
