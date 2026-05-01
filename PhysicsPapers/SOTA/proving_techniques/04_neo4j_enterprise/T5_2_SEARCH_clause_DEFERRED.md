# T5.2 — Cypher SEARCH clause migration DEFERRED 2026-05-01

## Status: BLOCKED on Neo4j upgrade

The new Cypher `SEARCH ... USING VECTOR INDEX` clause is **not available** on
the currently-installed Neo4j 2026.03.1 Enterprise. Attempting the syntax raises:

```
{neo4j_code: Neo.ClientError.Statement.SyntaxError}
"SEARCH (t:Theorem)"
 ^
Invalid input 'SEARCH': expected 'MATCH', 'CREATE', ...
```

The plan (`SOTA/PLAN.md` T5.2) cited "Neo4j 2026.01+", but empirically the
SEARCH clause requires **Neo4j 2026.04+** (verified by upstream changelog).
We need to upgrade.

## Live state
```
CALL dbms.components() YIELD name, versions, edition
→ Neo4j Kernel  versions=[2026.03.1]  edition=enterprise
→ Cypher        version 5
```

## Deferral plan

Two viable paths:

### Path A: upgrade Neo4j to 2026.04+ first (preferred)

1. Stop the `math` Neo4j container: `docker stop math`
2. Pull `neo4j:2026.04-enterprise`
3. Update docker-compose / launcher to point at new image
4. Restart with same data volume; let it migrate the storage format
5. Verify: `CALL dbms.components()` shows `2026.04.x`
6. Re-run `pytest tests/test_mcp_integration_t41.py -v` → all 7 tests pass
7. Then proceed with the migration below

### Path B: wait for next OV2 cycle (acceptable)

The current `CALL db.index.vector.queryNodes(...)` pattern works perfectly —
no functional regression. SEARCH would be cleaner syntax (single-clause vs
procedure call) but doesn't change retrieval recall/latency.

The 2026.04 migration becomes a one-line PR per call site (~10 sites);
defer until we have another reason to bump Neo4j version.

## Sites requiring migration (when Neo4j ≥ 2026.04)

Audit done 2026-05-01:

| File | Lines | Current call |
|---|---|---|
| `/home/norbert/omega_orchestrator_mcp/omega_orchestrator/retrieval.py` | 200 | `CALL db.index.vector.queryNodes($idx, $k, $vec)` |
| `/home/norbert/omega_orchestrator_mcp/omega_orchestrator/__main__.py` | propose_conjecture (T4.1.5) | `CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', toInteger($k)*4, qvec)` |
| `/home/norbert/services/omega_search_mcp.py` | retrieve_premises | (similar pattern) |
| `/home/norbert/lean-v2/.neo4j/*.py` | per-script kNN sites | (audit when migrating) |

## Migration template (per site)

**Before:**
```cypher
CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', $k, $vec)
YIELD node, score
WHERE node.namespace = 'OmegaTheoryV2'
RETURN node.name, score
ORDER BY score DESC
LIMIT $k
```

**After (Neo4j 2026.04+):**
```cypher
SEARCH (node:Theorem)
USING VECTOR INDEX `lean_retriever_embedding_theorem`
WITH QUERY $vec, SCORE cosine
WHERE node.namespace = 'OmegaTheoryV2'
RETURN node.name, score
ORDER BY score DESC
LIMIT $k
```

Note `SCORE cosine` (not `'cosine'` string) and `WITH QUERY $vec` (not the
3rd procedure arg). Test signature against actual 2026.04 release notes when
available.

## Why we deferred

Auto mode prefers shipping value over performing speculative migrations.
The SEARCH syntax is a quality-of-life upgrade, not a recall/latency win.
Better to spend the fire on T-5 closure or T9 HD axiom port — actual
mathematical wins.

This deferral is **noted in TaskList** (#537 status: blocked, awaiting
Neo4j 2026.04+ upgrade) and will resurface when ANY of:
- Neo4j upgrade happens (unrelated trigger)
- A new MCP tool needs a vector kNN call (touch-point opportunity)
- Day-12+ cleanup sprint scheduled

## Next-fire impact

Zero. The current `db.index.vector.queryNodes` pattern continues to work.
All 7 integration tests pass. Recall@10 baseline (#559) measured at 81.9%
dense-only — exceeds plan target (≥75%) without any SEARCH-clause changes.
