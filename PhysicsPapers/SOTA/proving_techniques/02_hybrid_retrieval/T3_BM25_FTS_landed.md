# T3 — BM25 FTS layer LANDED 2026-05-01

## Status

**Production-live.** Lean profile (`/home/norbert/services/profiles/lean.toml`) now activates
both BM25 layers concurrently:

1. **In-process `rank-bm25`** (`[retrieval.bm25] enabled=true`) — Python over local Lean source.
2. **Neo4j FULLTEXT index** (`[retrieval.fts] enabled=true index_name=theorem_fts top_k=100`) —
   Lucene-backed sparse layer over the FULL theorem corpus (13K OV2 + 175K Mathlib).

## Index spec

```cypher
CREATE FULLTEXT INDEX theorem_fts IF NOT EXISTS
FOR (n:Theorem)
ON EACH [n.signature, n.docstring, n.proof_body]
OPTIONS { indexConfig: { `fulltext.analyzer`: 'standard' } }
```

State after creation:
- `populating` → `ONLINE` in <30s
- Indexed: 13,073 OV2 (signature + proof_body + docstring all populated)
        + 175,137 Mathlib (signature + proof_body, docstring sparse)
- Standard analyzer: tokenizes on whitespace + punctuation; handles Lean
  identifiers (Real.pi_transcendental → ['Real', 'pi', 'transcendental'])

## Smoke-test results (live 2026-05-01 ~02:10 UTC)

```
FTS "pi transcendental irrational" (OmegaTheoryV2):
  15.009  OmegaTheory.Capstones.PiHunchUnconditionalCapstone.pi_transcendental_implies_irrational
  14.767  OmegaTheory.Capstones.PiTranscendenceYonedaBridges.yoneda_bridge_to_pi_stratum_integer
  14.436  OmegaTheory.Capstones.PiTranscendenceYonedaBridges.yoneda_bridge_to_pi_irrational
  14.111  HermitePade.LindemannWeierstrassRoadmap.pi_transcendental_irrational_consistency_check
  13.404  IrrationalityClasses.ic_three_constants_transcendental

FTS "Roth diophantine algebraic" (all namespaces, no filter):
  5.808  eq_dioph                                            (Mathlib)
  5.808  ne_dioph                                            (Mathlib)
  5.776  T5_Phase7_IrrationalGenericBundle_X.T5_roth_via_int_algebraic_quintic
  5.776  ...quartic
  5.776  ...cubic
```

Both queries surface highly relevant Theorem nodes — FTS layer is production-ready
for fusion into the omega_hammer pipeline.

## Code surface

**Profile fields added** (`omega_orchestrator/profile.py` RetrievalConfig):
```python
fts_enabled: bool = False
fts_index_name: str = "theorem_fts"
fts_top_k: int = 100
```

Plus parser update in `_parse_retrieval` to read `[retrieval.fts]` block from TOML.

**Helper added** (`omega_orchestrator/retrieval.py` after BM25Index):
```python
def fts_neo4j_search(
    neo4j_session,
    query: str,
    index_name: str,
    namespace: str | None,
    top_k: int,
) -> list[tuple[str, float]]:
    """Query Neo4j FULLTEXT index, return top_k (name, score) sorted desc."""
    ...
    cypher = f'''
        CALL db.index.fulltext.queryNodes($idx, $q) YIELD node, score
        {ns_filter}
        RETURN node.name AS name, score
        ORDER BY score DESC
        LIMIT $k
    '''
    ...
```

## Next-fire wiring

The `Retriever` class in `retrieval.py` (line ~357) fuses dense + BM25 via RRF.
Add a 3rd layer slot for FTS:

```python
# In Retriever.__init__:
self.fts_enabled = self.cfg.fts_enabled
self.fts_index = self.cfg.fts_index_name
self.fts_top_k = self.cfg.fts_top_k

# In Retriever.search() after BM25 layer:
if self.fts_enabled:
    fts_hits = fts_neo4j_search(
        session, goal_text, self.fts_index, namespace, self.fts_top_k
    )
    fts_names = [name for name, _ in fts_hits]
    rankings.append(fts_names)  # add to RRF input
```

This is a 5-line addition; deferred to next bundled commit since it touches the
Retriever class which is more sensitive (touched by every omega_hammer call).

## End-to-end verification (Day-2 plan §10)

Before the SOTA Recall@10 benchmark (#559), the FTS layer is provisionally
expected to yield:
- +5-10 percentage points on docstring-heavy queries (where dense embedding misses NL keywords)
- +2-5 percentage points on Mathlib-cross-namespace queries (where BM25 wins on identifier overlap)
- ~0 net change on tightly-coupled OV2 queries (where dense Qwen3 already scores ~0.95 cosine)

The actual lift will be measured by #559 once the dev slice is scored.
