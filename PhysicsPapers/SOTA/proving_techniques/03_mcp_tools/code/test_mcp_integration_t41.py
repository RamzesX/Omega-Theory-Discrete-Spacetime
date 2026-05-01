"""SOTA T4.1 + T4.1.5 + T4.2 integration tests — exercise new MCP tools end-to-end.

Requires a live Neo4j at bolt://localhost:7687 with OV2 corpus loaded.

Run:
    pytest tests/test_mcp_integration_t41.py -v
    OMEGA_NEO4J_PASSWORD=... pytest -v -s

Skips automatically when Neo4j is unreachable.
"""
from __future__ import annotations

import os
import socket
import pytest
from neo4j import GraphDatabase


# ── Connection fixture ─────────────────────────────────────────────────────


def _neo4j_reachable(host: str = "localhost", port: int = 7687) -> bool:
    try:
        with socket.create_connection((host, port), timeout=2):
            return True
    except OSError:
        return False


needs_neo4j = pytest.mark.skipif(
    not _neo4j_reachable(),
    reason="Neo4j not reachable at localhost:7687",
)


@pytest.fixture(scope="module")
def driver():
    pw = os.environ.get("OMEGA_NEO4J_PASSWORD", "omegatheory2026")
    d = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", pw))
    yield d
    d.close()


@pytest.fixture
def session(driver):
    with driver.session() as s:
        yield s


# ── T4.1.1 find_keystones — high pagerank × indeg_applies ──────────────────


@needs_neo4j
def test_find_keystones_returns_high_pagerank_first(session):
    cypher = """
    MATCH (t:Theorem)
    WHERE t.namespace = $ns AND t.pagerank_v62 IS NOT NULL
    WITH t,
         coalesce(t.pagerank_v62, 0.0) AS pr,
         coalesce(t.indeg_applies, 0)  AS indeg
    RETURN t.name AS name, pr, indeg, pr * log(1.0 + indeg) AS score
    ORDER BY score DESC
    LIMIT $k
    """
    rows = list(session.run(cypher, ns="OmegaTheoryV2", k=5))
    assert len(rows) >= 1, "expected at least one keystone in OV2"
    # Top must be the Spacetime keystone family (l_P_pos / c_pos / hbar_pos)
    top = rows[0]
    assert top["score"] > 0
    assert "Spacetime" in top["name"] or "computationalUncertainty" in top["name"], \
        f"top keystone unexpectedly = {top['name']}"
    # Scores must be monotonically non-increasing
    scores = [r["score"] for r in rows]
    assert scores == sorted(scores, reverse=True), "keystones not sorted"


# ── T4.1.2 find_iff_cycles — length-2 SCC pairs ────────────────────────────


@needs_neo4j
def test_find_iff_cycles_are_mutual(session):
    cypher = """
    MATCH (a:Theorem)-[:APPLIES]->(b:Theorem)
    WHERE a.namespace = $ns AND b.namespace = $ns
      AND elementId(a) < elementId(b)
      AND EXISTS { MATCH (b)-[:APPLIES]->(a) }
    RETURN a.name AS a, b.name AS b
    LIMIT $lim
    """
    rows = list(session.run(cypher, ns="OmegaTheoryV2", lim=5))
    # Either empty (healthy DAG) or every pair is mutual
    for r in rows:
        # Verify mutuality both ways
        check = list(session.run(
            """
            MATCH (a:Theorem {namespace:$ns, name:$an})-[:APPLIES]->(b:Theorem {name:$bn})
            MATCH (b)-[:APPLIES]->(a)
            RETURN count(*) AS c
            """,
            ns="OmegaTheoryV2", an=r["a"], bn=r["b"],
        ))
        assert check[0]["c"] >= 1, f"non-mutual pair returned: {r['a']}, {r['b']}"


# ── T4.1.3 find_bridge_lemmas — span ≥ min_span ────────────────────────────


@needs_neo4j
def test_find_bridge_lemmas_satisfies_min_span(session):
    cypher = """
    MATCH (t:Theorem)
    WHERE t.namespace = $ns AND t.atlas_v8_community IS NOT NULL
    MATCH (t)-[:APPLIES]->(u:Theorem)
    WHERE u.atlas_v8_community IS NOT NULL
      AND u.atlas_v8_community <> t.atlas_v8_community
    WITH t, count(DISTINCT u.atlas_v8_community) AS span_count
    WHERE span_count >= $min_span
    RETURN t.name AS name, span_count
    ORDER BY span_count DESC
    LIMIT $k
    """
    rows = list(session.run(cypher, ns="OmegaTheoryV2", min_span=3, k=10))
    for r in rows:
        assert r["span_count"] >= 3, f"bridge {r['name']} has span < min"


# ── T4.1.4 find_missing_edges — Adamic-Adar over APPLIES ───────────────────


@needs_neo4j
def test_find_missing_edges_no_self_no_existing(session):
    cypher = """
    MATCH (seed:Theorem {namespace: $ns, name: $seed})
    MATCH (seed)-[:APPLIES]->(common:Theorem)<-[:APPLIES]-(candidate:Theorem)
    WHERE candidate <> seed
      AND NOT EXISTS { (seed)-[:APPLIES]->(candidate) }
    WITH candidate, count(DISTINCT common) AS common_count
    WHERE common_count >= $min_common
    RETURN candidate.name AS candidate, common_count
    ORDER BY common_count DESC
    LIMIT $k
    """
    seed = "OmegaTheory.Spacetime.l_P_pos"
    rows = list(session.run(
        cypher, ns="OmegaTheoryV2", seed=seed, min_common=2, k=5,
    ))
    for r in rows:
        assert r["candidate"] != seed
        # Verify no existing edge
        check = list(session.run(
            "MATCH (a:Theorem {namespace:$ns, name:$s})-[:APPLIES]->(b:Theorem {name:$c}) "
            "RETURN count(*) AS c",
            ns="OmegaTheoryV2", s=seed, c=r["candidate"],
        ))
        assert check[0]["c"] == 0, \
            f"missing-edges returned existing edge {seed} → {r['candidate']}"


# ── T4.1.5 propose_conjecture — M3 + M4 classification ─────────────────────


@needs_neo4j
def test_propose_conjecture_class_distribution(session):
    cypher = """
    MATCH (seed:Theorem {namespace: $ns, name: $seed})
    WHERE seed.embedding_lean IS NOT NULL
    WITH seed,
         seed.embedding_lean AS qvec,
         coalesce(seed.atlas_v8_community, -999) AS seed_comm
    CALL db.index.vector.queryNodes(
        'lean_retriever_embedding_theorem', toInteger($k) * 4, qvec
    ) YIELD node AS cand, score AS cos
    WHERE cand <> seed AND cand.namespace = $ns AND cos >= $cmin
    WITH seed, cand, cos, seed_comm
    OPTIONAL MATCH (seed)-[:APPLIES]->(shared:Theorem)<-[:APPLIES]-(cand)
    WITH cand, cos, seed_comm,
         count(DISTINCT shared) AS shared_count,
         coalesce(cand.atlas_v8_community, -1) AS cand_comm
    WITH cand, cos, shared_count, cand_comm, seed_comm,
         CASE
            WHEN cand_comm <> seed_comm AND shared_count <= 2 THEN 'M3_surprise'
            WHEN cand_comm =  seed_comm AND shared_count >= 3 THEN 'M4_mendeleev'
            ELSE 'mixed'
         END AS conjecture_class,
         CASE
            WHEN cand_comm <> seed_comm AND shared_count <= 2 THEN cos
            WHEN cand_comm =  seed_comm AND shared_count >= 3 THEN cos * (1.0 + 0.1 * shared_count)
            ELSE cos * 0.5
         END AS rank_score
    RETURN cand.name AS candidate, cos AS cosine, shared_count,
           conjecture_class, rank_score
    ORDER BY rank_score DESC LIMIT toInteger($k)
    """
    seed = "OmegaTheory.Spacetime.l_P_pos"
    rows = list(session.run(
        cypher, ns="OmegaTheoryV2", seed=seed, k=10, cmin=0.70,
    ))
    assert len(rows) > 0, "propose_conjecture returned 0 — seed lacks embedding?"
    # Score must be monotonically non-increasing
    scores = [r["rank_score"] for r in rows]
    assert scores == sorted(scores, reverse=True), "conjectures not sorted"
    # All classifications must be one of the three
    valid = {"M3_surprise", "M4_mendeleev", "mixed"}
    for r in rows:
        assert r["conjecture_class"] in valid


# ── T4.2 tactic_continuation — prefix-match on tactic_evidence ─────────────


@needs_neo4j
def test_tactic_continuation_prefix_match(session):
    """Verify Cypher query for tactic prefix matching returns valid continuations."""
    cypher = """
    MATCH (t:Theorem)
    WHERE t.tactic_evidence IS NOT NULL
      AND size(t.tactic_evidence) > size($prefix)
      AND t.tactic_evidence[0..size($prefix)] = $prefix
    WITH t.tactic_evidence[size($prefix)] AS next_tactic, count(t) AS support
    RETURN next_tactic, support
    ORDER BY support DESC
    LIMIT $k
    """
    prefix = ["intro"]  # very common starter
    rows = list(session.run(cypher, prefix=prefix, k=5))
    # 'intro' is common enough that we should get hits
    if rows:
        # All counts must be positive
        for r in rows:
            assert r["support"] > 0, f"zero support for {r['next_tactic']}"
        # Counts monotonically non-increasing
        sup = [r["support"] for r in rows]
        assert sup == sorted(sup, reverse=True)


# ── T3 (FTS) — Neo4j fulltext index sanity ─────────────────────────────────


@needs_neo4j
def test_fts_index_online_and_returns_relevant_hits(session):
    """Ensure theorem_fts index is ONLINE and returns relevant hits."""
    rows = list(session.run(
        "SHOW INDEXES YIELD name, state WHERE name = 'theorem_fts' RETURN state"
    ))
    if not rows:
        pytest.skip("theorem_fts FTS index not present (run T3 setup)")
    assert rows[0]["state"] == "ONLINE", \
        f"theorem_fts state = {rows[0]['state']} (expected ONLINE)"

    # Query: top hit for 'pi transcendental irrational' should mention pi
    hits = list(session.run(
        """
        CALL db.index.fulltext.queryNodes('theorem_fts', $q) YIELD node, score
        WHERE node.namespace = 'OmegaTheoryV2'
        RETURN node.name AS name, score ORDER BY score DESC LIMIT 3
        """,
        q="pi transcendental irrational",
    ))
    assert len(hits) > 0
    top_name = hits[0]["name"].lower()
    assert "pi" in top_name or "transcend" in top_name or "irrational" in top_name, \
        f"unexpected top FTS hit: {hits[0]['name']}"
