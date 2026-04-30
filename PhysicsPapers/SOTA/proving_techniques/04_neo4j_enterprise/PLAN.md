# T5 — Neo4j Enterprise Leverage

**Status**: TODO Day 4-5 | **Effort**: 1 day | **Hardware**: 192GB RAM available

## T5.1 — 100 GB heap config

Edit `<neo4j_home>/conf/neo4j.conf`:
```
server.memory.heap.initial_size=100G
server.memory.heap.max_size=100G
server.memory.pagecache.size=40G
server.jvm.additional=-XX:+UseG1GC
```

WSL2 budget: 160 GB total → 100G heap + 40G pagecache + 20G OS = fits with 20G margin.

**Conservative start**: 80G/30G if peak pressure unknown. Bump if breached.

Restart: `mcp__omega-orchestrator__servers_control(action='restart')`.

## T5.2 — Cypher SEARCH clause migration (Neo4j 2026.01+)

Replace deprecated procedures:
```cypher
// OLD (deprecated 2026.04):
CALL db.index.vector.queryNodes('idx_name', k, $vec) YIELD node, score

// NEW (2026.01+ preferred):
SEARCH (n:Theorem)
USING VECTOR INDEX idx_name (n.embedding_lean)
WITH QUERY $vec
LIMIT k
YIELD node = n, score
```

~10 sites in `~/lean-v2/.neo4j/*.py`.

Verification: Cypher EXPLAIN shows new `IndexedSearchPlan`.

## T5.3 — GDS Enterprise features

```cypher
CALL gds.license.state()  // verify Enterprise active
```

New 2026.04 algorithms unlocked:
- `gds.cliqueCounting.stream` — tightly-coupled subsystem detection
- `gds.maxFlow` with `nodeCapacityProperty` — capacitated bottleneck detection
- `gds.minCostMaxFlow` — optimal proof-route via theorem graph

Apache Arrow import/export → graph backups, eliminate ingest race conditions:
```cypher
CALL gds.graph.export.cypher('omega', {writeConcurrency: 8})
```

## T5.4 — Neo4j FTS for BM25 layer (T3 dependency)

```cypher
CREATE FULLTEXT INDEX theorem_fts FOR (t:Theorem) ON EACH [t.name, t.signature, t.docstring]
OPTIONS {analyzer: 'standard'}
```

Used by T3 hybrid retrieval BM25 stage (alternative to external Tantivy).

## Verification

```cypher
CALL gds.license.state()                       // Enterprise active
CALL db.index.fulltext.list()                  // theorem_fts present
SHOW INDEXES YIELD name, type WHERE type = 'VECTOR'  // 4 vector indexes (1472-d + 4096-d)
```
Plus `dbms.memory.heap_used_bytes` ~ 60-80 GB under load.
