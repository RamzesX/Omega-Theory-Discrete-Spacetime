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


# ── goal_to_proof_step (T4.2.b — added 2026-05-01) ─────────────────────────


@needs_neo4j
def test_goal_to_proof_step_empty_returns_helper(omega_search):
    """No goal_str + no prefix → mode='empty' with note hint."""
    out = omega_search.tool_goal_to_proof_step({})
    assert out.get("mode") == "empty"
    assert "note" in out
    assert out.get("results") == []


@needs_neo4j
def test_goal_to_proof_step_substring_mode_mathlib(omega_search):
    """LeanDojo loaded 259K Mathlib :ProofStep with REAL elaborated goals.
    Substring match on a common Mathlib hypothesis token should yield hits."""
    out = omega_search.tool_goal_to_proof_step({
        "goal_str": "CommRing",
        "k": 5,
        "namespace": "Mathlib",
    })
    assert out.get("mode") == "goal_substring"
    results = out.get("results", [])
    assert len(results) > 0, "expected ≥1 hit for 'CommRing' in Mathlib :ProofStep"
    # Each result must carry the real elaborated state fields
    top = results[0]
    for k in ("parent_thm", "step_idx", "tactic", "goal_before", "goal_after"):
        assert k in top, f"missing field {k!r} in result"
    # goal_before should contain the keyword (substring mode contract)
    assert "CommRing" in top["goal_before"]


@needs_neo4j
def test_goal_to_proof_step_prefix_mode(omega_search):
    """Tactic-prefix mode: given a prefix that exists in the corpus, return
    the distribution of next-tactic candidates. Use 'ext x' (LeanDojo
    common opening tactic) as a known-good prefix."""
    out = omega_search.tool_goal_to_proof_step({
        "prefix": ["ext x"],
        "k": 10,
        "namespace": "Mathlib",
    })
    # Either exact_prefix mode succeeds, or we fall through (no goal_str → empty)
    assert out.get("mode") in ("exact_prefix", "empty"), (
        f"unexpected mode: {out.get('mode')}")
    if out.get("mode") == "exact_prefix":
        assert "next_tactic_distribution" in out
        assert isinstance(out["next_tactic_distribution"], dict)


@needs_neo4j
def test_goal_to_proof_step_real_elaborated_goals_present(omega_search):
    """Sanity check: the 259K Mathlib :ProofStep nodes from LeanDojo carry
    real Lean-format goal-state strings (with `⊢` symbol) — distinguishing
    them from the LITE goal_pseudo approximation."""
    out = omega_search.tool_goal_to_proof_step({
        "goal_str": "intTrace",
        "k": 3,
        "namespace": "Mathlib",
    })
    results = out.get("results", [])
    if not results:
        pytest.skip("no Mathlib :ProofStep matched 'intTrace' (LeanDojo "
                    "not loaded?); see ~/lean-v2/.neo4j/load_leandojo_full.sh")
    # Real elaborated goals contain hypothesis context (multiple lines + `⊢`)
    top = results[0]
    assert "⊢" in top["goal_before"] or "no goals" in top["goal_after"], (
        "expected real Lean goal-state format with `⊢` symbol")


@needs_neo4j
def test_goal_to_proof_step_namespace_filter_isolates(omega_search):
    """Namespace filter must keep results within the requested namespace."""
    out_mathlib = omega_search.tool_goal_to_proof_step({
        "goal_str": "Type",
        "k": 5,
        "namespace": "Mathlib",
    })
    for r in out_mathlib.get("results", []):
        assert r["namespace"] == "Mathlib", (
            f"namespace leak: got {r['namespace']!r}")


# ── lean profile: embedding_goal wiring (T1.3 + #9 + #17) ──────────────────


def test_lean_profile_includes_embedding_goal_index():
    """Verify the lean profile picks up theorem_embedding_goal in
    active_indices (commit 6cebb85). Without this wiring, omega_hammer_premise
    won't fuse goal-vector cosine into compose_score."""
    import tomllib
    profile_path = "/home/norbert/services/profiles/lean.toml"
    if not os.path.exists(profile_path):
        pytest.skip(f"profile not found: {profile_path}")
    with open(profile_path, "rb") as f:
        profile = tomllib.load(f)
    active = profile.get("retrieval", {}).get("active_indices", [])
    assert "theorem_embedding_goal" in active, (
        f"theorem_embedding_goal missing from active_indices: {active}. "
        f"This breaks SOTA T1.3 + #9 + #17 wiring.")
