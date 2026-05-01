# T3 — Weighted-RRF Production Wiring 2026-05-01

## Status

**LIVE in production retriever.** Yesterday's empirical finding (w_dense=1.5
optimal, +2.4pp recall@10 over dense alone) is now the default behavior in
the omega-orchestrator MCP.

## Code changes

`/home/norbert/omega_orchestrator_mcp/omega_orchestrator/retrieval.py`:
- Added `weighted_rrf_fuse(rankings_with_weights, k=60)` helper
- Replaced the BM25-fusion `rrf_fuse` call at line 463 with weighted variant
- Cites the sweep finding inline so future maintainers see the empirical basis

`/home/norbert/omega_orchestrator_mcp/omega_orchestrator/profile.py`:
- Added `RetrievalConfig.w_dense_in_rrf: float = 1.5` (production default)
- Added `RetrievalConfig.w_fts_in_rrf: float = 1.0`
- `_parse_retrieval()` reads `w_dense_in_rrf` from `[retrieval]` block and
  `w_in_rrf` from `[retrieval.fts]` block (TOML-friendly nesting)

## Test coverage (4 NEW unit tests, all passing)

```
test_weighted_rrf_fuse_unit_weights_match_unweighted   PASS
test_weighted_rrf_fuse_higher_weight_pulls_ranking_up  PASS
test_weighted_rrf_fuse_empty_input                     PASS
test_retrieval_config_w_dense_default_is_15            PASS
```

Total orchestrator MCP test suite: **195 tests** (was 191, +4).

## Production behavior change

When `bm25_enabled=true` in lean profile (already the case), the Retriever
class now fuses dense kNN + BM25 via weighted RRF:

```python
fused = weighted_rrf_fuse(
    [(dense_names, self.cfg.w_dense_in_rrf),   # default 1.5
     (bm25_names,  self.cfg.w_fts_in_rrf)],    # default 1.0
    k=self.cfg.rrf_k,
)
```

Effect: dense ranks count 1.5× as much as BM25 ranks in the fusion. Empirically
this saturates the recall@10 benefit (no further gain at w=2/3/5).

## Profile override

Users can tune via profile if needed:
```toml
[retrieval]
w_dense_in_rrf = 2.0  # override production default

[retrieval.fts]
w_in_rrf = 0.8        # de-emphasize FTS noise
```

## Pending plumbing (deferred)

The `fts_neo4j_search` helper still exists but isn't wired into the Retriever
class — that's a 3-source fusion (dense + BM25 + FTS) which needs a more
careful refactor. Today's commit limits to the 2-source (dense + BM25) fusion
to ship the production-default change without scope creep.

Next-fire wiring: extend Retriever.search() to call fts_neo4j_search when
`fts_enabled=true`, then 3-way weighted fusion via:
```python
weighted_rrf_fuse([
    (dense_names, w_dense),
    (bm25_names, w_bm25),
    (fts_names, w_fts),
], k=rrf_k)
```

## Backlog drain status

This closes the "weighted RRF wiring" follow-up implicit in the
T3_RECALL10_WEIGHTED_RRF_FINDINGS.md memo. The full hybrid story now has:
- ✓ Dense kNN over Qwen3 embedding (production)
- ✓ BM25 in-process (production, lean profile bm25.enabled=true)
- ✓ Weighted RRF fusion (production, w_dense=1.5)
- ⏳ FTS Neo4j Lucene (helper exists, profile flag exists, not yet plumbed
  into Retriever — pending 3-way fusion refactor)
- ⏳ Goal-only embedding kNN (post-backfill)
- ⏳ Reranker stage (CPU→GPU promoted; integrate into compose_score)

Production recall@10 with current wiring: ≥0.747 on N=83 OV2 dev slice,
empirical sweep result already confirmed.
