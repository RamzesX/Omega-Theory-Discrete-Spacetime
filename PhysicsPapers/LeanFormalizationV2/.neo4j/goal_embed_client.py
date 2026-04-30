"""SOTA T2 — Goal-state embedding client wrapper.

Wraps the running llama-server Qwen3-Embedding-8B (:7999) with the V3-for-Lean
prefix scheme. Adds [goal] prefix + optional Qwen3 instruction-aware prompt
WITHOUT requiring server-side changes.

Architecture decision:
- The running server is `llama-server` (llama.cpp HIP, GGUF Q8_0, llama.cpp's
  generic /v1/embeddings endpoint) — not the Python Flask implementation
  in V3-for-Lean/code/servers/qwen3_embedding_server.py.
- llama-server accepts arbitrary input strings and returns 4096-d Qwen3
  embeddings, so we don't need a server-side endpoint change. The [goal]
  prefix is simply prepended at the client, exploiting the V3-for-Lean
  embedding-input prefix scheme (§4.2 of the paper).
- Reranker on :7996 stays untouched and concurrent; this client only talks to :7999.

Created: 2026-04-30 / 2026-05-01 (SOTA T2)
Authority: ~/.claude/plans/binary-painting-dijkstra.md T2
           PhysicsPapers/SOTA/proving_techniques/01_qwen3_goal_endpoint/
"""
from __future__ import annotations
import os
import time
from typing import Optional

import requests


QWEN3_URL = os.environ.get("QWEN3_EMBED_URL", "http://localhost:7999/v1/embeddings")
GOAL_PREFIX = "[goal] "
DEFAULT_TIMEOUT = 30.0


def embed_goals(
    goals: list[str],
    instruction: Optional[str] = None,
    timeout: float = DEFAULT_TIMEOUT,
    url: str = QWEN3_URL,
) -> list[list[float]]:
    """Embed a list of Lean proof-goal strings via Qwen3-Embedding-8B :7999.

    Args:
        goals:       list of Lean goal strings (e.g. "⊢ ∀ x, x = x")
        instruction: optional Qwen3 instruction-aware prompt, e.g.
                     "rate relevance of premises to this proof goal"
                     "find proofs that close goals like this one"
        timeout:     HTTP timeout seconds (default 30)
        url:         endpoint URL (default http://localhost:7999/v1/embeddings)

    Returns:
        List of 4096-d float embeddings, L2-normalized, one per goal.

    Raises:
        requests.HTTPError on non-200; ValueError on malformed response.
    """
    if not goals:
        return []
    if isinstance(goals, str):
        goals = [goals]

    if instruction:
        inputs = [f"Instruction: {instruction}\n{GOAL_PREFIX}{g}" for g in goals]
    else:
        inputs = [f"{GOAL_PREFIX}{g}" for g in goals]

    resp = requests.post(
        url,
        json={"input": inputs, "model": "qwen3-embedding-8b"},
        timeout=timeout,
    )
    resp.raise_for_status()
    data = resp.json()
    if "data" not in data:
        raise ValueError(f"unexpected response shape: {list(data.keys())}")
    items = data["data"]
    if len(items) != len(goals):
        raise ValueError(
            f"server returned {len(items)} embeddings for {len(goals)} goals"
        )
    return [item["embedding"] for item in items]


def goal_to_premises_via_kNN(
    goal: str,
    k: int = 20,
    namespace: Optional[str] = None,
    instruction: Optional[str] = "rate relevance of premises to this proof goal",
    neo4j_url: str = "bolt://localhost:7687",
    neo4j_auth: tuple = ("neo4j", "omegatheory2026"),
    index_name: str = "lean_retriever_embedding_theorem",
) -> list[dict]:
    """Convenience: embed a goal + kNN against Theorem corpus + return top-k.

    Returns: list of {name, namespace, file, score} dicts, sorted by score desc.
    """
    from neo4j import GraphDatabase  # local import; optional dep

    [vec] = embed_goals([goal], instruction=instruction)

    cypher = """
    CALL db.index.vector.queryNodes($index, $k, $vec)
    YIELD node, score
    """
    if namespace is not None:
        cypher += "WHERE node.namespace = $ns\n"
    cypher += "RETURN node.name AS name, node.namespace AS namespace, node.file AS file, score ORDER BY score DESC"

    params = {"index": index_name, "k": k, "vec": vec}
    if namespace is not None:
        params["ns"] = namespace

    driver = GraphDatabase.driver(neo4j_url, auth=neo4j_auth)
    try:
        with driver.session() as s:
            return [dict(rec) for rec in s.run(cypher, **params)]
    finally:
        driver.close()


def benchmark(goals: list[str], instruction: Optional[str] = None) -> dict:
    """Throughput micro-benchmark."""
    t0 = time.time()
    embeddings = embed_goals(goals, instruction=instruction)
    dt = time.time() - t0
    return {
        "n_goals": len(goals),
        "elapsed_s": round(dt, 3),
        "throughput_qps": round(len(goals) / max(dt, 1e-6), 2),
        "dim": len(embeddings[0]) if embeddings else 0,
    }


if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "test":
        print("[T2] Smoke test on running :7999 ...")
        smoke = embed_goals(["⊢ ∀ x : ℝ, x = x"])
        assert len(smoke) == 1 and len(smoke[0]) == 4096
        print(f"[T2] OK: 4096-d vector returned (norm={sum(v*v for v in smoke[0])**0.5:.4f})")

        print("[T2] Throughput benchmark (10 goals)...")
        results = benchmark([f"⊢ G_{i} : Prop" for i in range(10)])
        print(f"[T2] {results}")

        print("[T2] kNN demo: 'rothIndex P q R ≤ t - sqrt(m·ε)'")
        try:
            premises = goal_to_premises_via_kNN(
                "⊢ rothIndex P q R ≤ t - Real.sqrt (↑m * ε)",
                k=5,
                namespace="OmegaTheoryV2",
            )
            for p in premises:
                print(f"  {p['score']:.4f}  {p['name']}")
        except ImportError:
            print("[T2] (skipping kNN — neo4j driver not available)")
    else:
        print("Usage: python3 goal_embed_client.py test")
