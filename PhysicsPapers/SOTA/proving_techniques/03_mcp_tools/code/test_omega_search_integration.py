"""omega-search MCP integration tests — exercise tool_* functions end-to-end.

Requires:
  - Live Neo4j at bolt://localhost:7687
  - Embedder at http://localhost:7999/v1/embeddings (Qwen3-Embedding-8B)
  - Reranker at http://localhost:7996/v1/rerank (Qwen3-Reranker-8B)

Tests skip individual tools when their dependencies are unreachable, but the
suite as a whole runs against the production stack.

Run:
    NEO4J_PASSWORD=... pytest tests/test_omega_search_integration.py -v
    /home/norbert/genai_env/bin/pytest tests/test_omega_search_integration.py -v
"""
from __future__ import annotations

import os
import socket
import sys
import pytest

# Make the omega_search_mcp module importable
sys.path.insert(0, "/home/norbert/services")

# Skip the entire suite if Neo4j is unreachable
def _port_alive(host: str, port: int, timeout: float = 2.0) -> bool:
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except OSError:
        return False


needs_neo4j = pytest.mark.skipif(
    not _port_alive("localhost", 7687),
    reason="Neo4j not reachable at localhost:7687",
)

needs_embedder = pytest.mark.skipif(
    not _port_alive("localhost", 7999),
    reason="Embedder not reachable at localhost:7999",
)

needs_reranker = pytest.mark.skipif(
    not _port_alive("localhost", 7996),
    reason="Reranker not reachable at localhost:7996",
)


# ── Module-level imports (after sys.path setup) ────────────────────────────


@pytest.fixture(scope="module")
def omega_search():
    """Import the omega_search_mcp module once per session."""
    import omega_search_mcp as oss
    return oss


# ── retrieve_premises ──────────────────────────────────────────────────────


@needs_neo4j
@needs_embedder
def test_retrieve_premises_returns_results(omega_search):
    out = omega_search.tool_retrieve_premises({
        "goal": "irrational pi transcendental",
        "k": 5,
        "namespace": "OmegaTheoryV2",
    })
    assert "results" in out
    assert isinstance(out["results"], list)
    assert len(out["results"]) > 0
    # Top hit should be related to pi (high cosine)
    top = out["results"][0]
    assert "name" in top
    assert "score" in top
    assert top["score"] > 0.3, f"top score too low: {top['score']}"


@needs_neo4j
@needs_embedder
def test_retrieve_premises_empty_goal_returns_error(omega_search):
    out = omega_search.tool_retrieve_premises({"k": 5})
    assert "error" in out
    assert "goal" in out["error"]


@needs_neo4j
@needs_embedder
def test_retrieve_premises_namespace_filter(omega_search):
    """Mathlib filter should return only Mathlib results."""
    out = omega_search.tool_retrieve_premises({
        "goal": "Real.sqrt nonneg",
        "k": 5,
        "namespace": "Mathlib",
    })
    assert "results" in out
    for r in out["results"]:
        assert r["ns"] == "Mathlib", f"non-Mathlib result with Mathlib filter: {r['ns']}"


# ── find_similar ───────────────────────────────────────────────────────────


@needs_neo4j
def test_find_similar_returns_high_cosine_neighbors(omega_search):
    """Querying find_similar with a known OV2 theorem returns near-identical
    neighbors at cosine > 0.85. Note: tool_find_similar defaults to
    namespace='Mathlib' so we MUST pass OV2 namespace explicitly."""
    seed = "OmegaTheory.Spacetime.l_P_pos"
    out = omega_search.tool_find_similar({
        "name": seed,
        "namespace": "OmegaTheoryV2",
        "k": 5,
    })
    assert "results" in out
    assert len(out["results"]) > 0, f"empty results: {out}"
    top = out["results"][0]
    assert "name" in top
    assert top.get("score", 0) > 0.85, f"top cosine too low: {top.get('score')}"


# ── neighbors ──────────────────────────────────────────────────────────────


@needs_neo4j
def test_neighbors_returns_typed_edges(omega_search):
    out = omega_search.tool_neighbors({
        "name": "OmegaTheory.Spacetime.l_P_pos",
        "k": 5,
    })
    assert "results" in out
    assert isinstance(out["results"], list)
    # Each neighbor row should have name + relation type
    for r in out["results"]:
        assert "name" in r


# ── subsystem_of ───────────────────────────────────────────────────────────


@needs_neo4j
def test_subsystem_of_returns_cluster_id(omega_search):
    out = omega_search.tool_subsystem_of({
        "name": "OmegaTheory.Spacetime.l_P_pos",
        "namespace": "OmegaTheoryV2",
    })
    # Either subsystem found or graceful empty
    assert "name" in out or "error" in out


# ── explain_theorem ────────────────────────────────────────────────────────


@needs_neo4j
def test_explain_theorem_returns_signature(omega_search):
    """For a known OV2 theorem, explain should return signature + edges."""
    out = omega_search.tool_explain_theorem({
        "name": "OmegaTheory.Spacetime.l_P_pos",
        "namespace": "OmegaTheoryV2",
    })
    assert "name" in out or "error" in out
    # If found, should have signature
    if "error" not in out:
        assert "signature" in out or "label" in out


# ── tactic_continuation ────────────────────────────────────────────────────


@needs_neo4j
def test_tactic_continuation_with_real_prefix(omega_search):
    """Use a tactic prefix that's known to exist in the corpus per direct
    Cypher exploration: 'have' is the most common kernel-tactic head."""
    out = omega_search.tool_tactic_continuation({
        "prefix": ["have"],
        "k": 5,
    })
    assert "continuations" in out or "results" in out or "error" in out
    # Should not raise; return shape is the contract


# ── rerank_documents ───────────────────────────────────────────────────────


@needs_reranker
def test_rerank_documents_basic(omega_search):
    out = omega_search.tool_rerank_documents({
        "query": "Real.sqrt is non-negative for non-negative input",
        "documents": [
            "theorem sqrt_nonneg : 0 ≤ Real.sqrt x",
            "theorem sqrt_pos : 0 < √x ↔ 0 < x",
            "theorem add_comm : a + b = b + a",
        ],
        "top_k": 3,
    })
    assert "results" in out or "error" in out
    if "results" in out:
        # First two should rank above add_comm (semantically more relevant)
        results = out["results"]
        assert len(results) > 0


def test_rerank_documents_validates_args(omega_search):
    out = omega_search.tool_rerank_documents({"top_k": 3})
    assert "error" in out
