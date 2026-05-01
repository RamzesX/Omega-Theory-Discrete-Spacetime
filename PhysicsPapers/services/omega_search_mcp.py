#!/usr/bin/env python3
"""
omega_search_mcp — MCP server exposing V3-for-Lean retrieval + prover tools
to Lean agents.

Tools exposed:
  retrieve_premises(goal, k=10, namespace=None, rerank=False, rerank_pool=50)
      kNN + optional cross-encoder rerank → top-k premise dicts
      rerank=True → kNN returns `rerank_pool` candidates, CPU reranker on :7996
                   re-orders to final top-k (better precision on ambiguous goals)
  explain_theorem(name, namespace="Mathlib")
      signature + docstring + proof_body + top incoming/outgoing edges
  rerank_documents(query, documents, top_k=10)
      direct cross-encoder reranker — scores (query, doc) pairs on CPU :7996
      use for on-demand bridge scoring, cross-namespace filtering
  subsystem_of(name, namespace="Mathlib")
      which Leiden cluster; its ai_instructions if populated
  neighbors(name, rel=None, direction="both", k=10)
      traverse typed edges
  find_similar(name, k=10, rerank=False)
      kNN by embedding_lean; rerank=True adds cross-encoder pass

Runs via stdio per MCP spec. Register via ~/.claude.json mcpServers config:
  "omega-search": {
    "command": "/home/norbert/genai_env/bin/python",
    "args": ["/home/norbert/services/omega_search_mcp.py"]
  }
"""
from __future__ import annotations

import json
import os
import sys
import traceback
from typing import Optional

import httpx
from neo4j import GraphDatabase

NEO4J_URI = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
NEO4J_USER = os.environ.get("NEO4J_USER", "neo4j")
NEO4J_PASSWORD = os.environ.get("NEO4J_PASSWORD", "omegatheory2026")

RETRIEVER_URL = os.environ.get("RETRIEVER_URL", "http://localhost:7999/v1/embeddings")
RERANKER_URL = os.environ.get("RERANKER_URL", "http://localhost:7996/v1/rerank")


# Lazily-created singletons
_driver = None
_http = None


def driver():
    global _driver
    if _driver is None:
        _driver = GraphDatabase.driver(NEO4J_URI, auth=(NEO4J_USER, NEO4J_PASSWORD))
    return _driver


def http_client():
    global _http
    if _http is None:
        _http = httpx.Client(timeout=60)
    return _http


# ============================================================================
# Tool implementations
# ============================================================================


# Task descriptions for Qwen3-Embedding-8B instruction-aware retrieval.
# Queries get prefixed per Qwen3 official format: "Instruct: {task}\nQuery:{text}".
# Documents (theorems in corpus) stay raw per Qwen3 docs.
# Source: https://huggingface.co/Qwen/Qwen3-Embedding-8B
TASK_PREMISES = (
    "Given a Lean 4 theorem statement or goal, retrieve theorems from the "
    "OmegaTheoryV2 corpus (discrete spacetime substrate + four irrationals π, "
    "e, √2, Catalan-G) that are logically dependent premises, via APPLIES / "
    "UNFOLDS / ASSUMES edges, or that would close this goal by composition."
)
TASK_SIMILAR = (
    "Given a Lean 4 theorem name, retrieve theorems semantically related to "
    "it — same subsystem, same proof pattern, or bridging across the "
    "substrate-irrationals quiver of typed arrows."
)
TASK_BRIDGE = (
    "Given a Lean 4 theorem in one subsystem, retrieve Mathlib premises or "
    "cross-namespace theorems whose application would bridge this theorem to "
    "a target namespace — favor logical connectivity over surface similarity."
)


def format_query(task_description: str, query: str) -> str:
    """Qwen3-Embedding official query-side instruction format."""
    return f"Instruct: {task_description}\nQuery:{query}"


def embed_text(text: str, is_query: bool = True,
               task: str = TASK_PREMISES) -> list[float]:
    """Embed one text. Queries get instruction prefix; documents stay raw."""
    payload = format_query(task, text) if is_query else text
    r = http_client().post(
        RETRIEVER_URL,
        json={"input": payload, "model": "qwen3-embedding-8b"},
        timeout=30,
    )
    r.raise_for_status()
    return r.json()["data"][0]["embedding"]


# Backward-compat alias. Uses TASK_PREMISES task instruction.
def embed_goal(text: str) -> list[float]:
    return embed_text(text, is_query=True, task=TASK_PREMISES)


# Task instructions for Qwen3-Reranker-8B per official format.
# Wrapped format: "<Instruct>: {task}\n<Query>: {query}"
# Source: https://huggingface.co/Qwen/Qwen3-Reranker-8B
RERANK_TASK_PREMISE = (
    "Given a Lean 4 theorem / goal, judge whether the candidate document is a "
    "logically dependent premise — i.e. the goal applies, unfolds, or assumes the "
    "document's content in its proof chain. Prefer proof-relevant connections over "
    "surface keyword overlap."
)
RERANK_TASK_BRIDGE = (
    "Given a Lean 4 theorem, judge whether the candidate is a cross-namespace "
    "bridge premise — a Mathlib or OmegaTheoryV2 theorem whose application would "
    "connect this theorem's subsystem to another, closing an otherwise-empty "
    "APPLIES chasm between communities."
)


def format_rerank_query(task_description: str, query: str) -> str:
    """Qwen3-Reranker official query-side instruction wrap. The reranker's
    classifier head was trained on this exact pattern; prefixing amounts to
    setting the task context the model expects to see."""
    return f"<Instruct>: {task_description}\n<Query>: {query}"


def rerank_pairs(query: str, documents: list[str], timeout: int = 300,
                 task: str = RERANK_TASK_PREMISE) -> list[dict]:
    """Call CPU reranker (Qwen3-Reranker-8B on :7996) for (query, doc) pairs.
    Wraps `query` with Qwen3 instruction format so the classifier head sees the
    task context. Returns list of {index, relevance_score}."""
    wrapped = format_rerank_query(task, query)
    r = http_client().post(
        RERANKER_URL,
        json={"query": wrapped, "documents": documents, "model": "qwen3-reranker-8b"},
        timeout=timeout,
    )
    r.raise_for_status()
    return r.json().get("results", [])


def tool_retrieve_premises(args: dict) -> dict:
    goal = args.get("goal")
    if not goal:
        return {"error": "missing 'goal'"}
    k = args.get("k", 10)
    namespace = args.get("namespace")
    rerank = bool(args.get("rerank", False))
    rerank_pool = int(args.get("rerank_pool", 50))

    # Use cross-namespace BRIDGE task when caller requests Mathlib namespace;
    # otherwise use PREMISES task (APPLIES/UNFOLDS focus).
    task = TASK_BRIDGE if namespace == "Mathlib" else TASK_PREMISES
    vec = embed_text(goal, is_query=True, task=task)
    fetch_k = max(k, rerank_pool) if rerank else k

    with driver().session() as s:
        ns_clause = "WHERE n.namespace = $ns" if namespace else ""
        q = f"""
        CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', $top, $vec)
        YIELD node AS n, score
        {ns_clause}
        RETURN n.name AS name,
               n.mathlib_module AS module,
               labels(n)[0] AS label,
               n.namespace AS ns,
               substring(coalesce(n.signature, ''), 0, 400) AS signature,
               substring(coalesce(n.docstring, ''), 0, 200) AS docstring,
               n.subsystem_id AS subsystem_id,
               n.subtopology_id AS subtopology_id,
               score
        ORDER BY score DESC LIMIT $k
        """
        params = {"vec": vec, "top": max(100, fetch_k * 3), "k": fetch_k}
        if namespace:
            params["ns"] = namespace
        rows = [dict(r) for r in s.run(q, params)]

    if rerank and rows:
        docs = [
            (row["signature"] or "") + ("\n" + row["docstring"] if row["docstring"] else "")
            for row in rows
        ]
        try:
            ranks = rerank_pairs(goal, docs)
            for row in rows:
                row["knn_score"] = row.pop("score")
                row["rerank_score"] = None
            for r_ in ranks:
                idx = r_.get("index")
                if 0 <= idx < len(rows):
                    rows[idx]["rerank_score"] = r_.get("relevance_score")
            rows.sort(key=lambda x: x.get("rerank_score") or -1e9, reverse=True)
            rows = rows[:k]
        except Exception as e:
            rows = rows[:k]
            return {"query": goal, "k": k, "results": rows, "rerank_error": str(e)}
    else:
        rows = rows[:k]

    return {"query": goal, "k": k, "reranked": rerank, "results": rows}


def tool_rerank_documents(args: dict) -> dict:
    query = args.get("query")
    documents = args.get("documents")
    top_k = int(args.get("top_k", 10))
    if not query or not isinstance(documents, list) or not documents:
        return {"error": "need query:str and documents:[str,...]"}
    try:
        ranks = rerank_pairs(query, documents)
        scored = [
            {"index": r["index"], "document": documents[r["index"]], "score": r["relevance_score"]}
            for r in ranks
            if 0 <= r.get("index", -1) < len(documents)
        ]
        scored.sort(key=lambda x: x["score"], reverse=True)
        return {"query": query, "top_k": top_k, "results": scored[:top_k]}
    except Exception as e:
        return {"error": f"rerank failed: {e}"}


def tool_explain_theorem(args: dict) -> dict:
    name = args.get("name")
    if not name:
        return {"error": "missing 'name'"}
    namespace = args.get("namespace", "Mathlib")

    with driver().session() as s:
        q = """
        MATCH (n {namespace: $ns, name: $name})
        WHERE any(l IN labels(n) WHERE l IN ['Theorem','Lemma','Definition','Axiom','Structure','Instance'])
        OPTIONAL MATCH (n)-[r_out]->(t) WHERE NOT t.namespace IS NULL
        WITH n, type(r_out) AS rel_out, collect(DISTINCT t.name)[0..5] AS out_targets
        WITH n, collect({rel: rel_out, targets: out_targets}) AS out_edges
        OPTIONAL MATCH (s2)-[r_in]->(n) WHERE NOT s2.namespace IS NULL
        WITH n, out_edges, type(r_in) AS rel_in, collect(DISTINCT s2.name)[0..5] AS in_sources
        WITH n, out_edges, collect({rel: rel_in, sources: in_sources}) AS in_edges
        RETURN n.name AS name,
               labels(n)[0] AS label,
               n.namespace AS namespace,
               n.mathlib_module AS module,
               n.signature AS signature,
               n.proof_body AS proof_body,
               n.docstring AS docstring,
               n.source_span AS source_span,
               out_edges,
               in_edges
        LIMIT 1
        """
        rec = s.run(q, {"name": name, "ns": namespace}).single()
    if not rec:
        return {"error": f"not found: {namespace}/{name}"}
    return dict(rec)


def tool_subsystem_of(args: dict) -> dict:
    name = args.get("name")
    namespace = args.get("namespace", "Mathlib")
    with driver().session() as s:
        q = """
        MATCH (n {namespace: $ns, name: $name})
        OPTIONAL MATCH (n)<-[:CONTAINS]-(sub:SubsystemNavigator)
        OPTIONAL MATCH (n)<-[:CONTAINS]-(subt:Subtopology)
        RETURN n.name AS name,
               labels(n)[0] AS label,
               n.subsystem_id AS subsystem_id,
               n.subtopology_id AS subtopology_id,
               n.cluster_topo AS cluster_topo,
               n.cluster_graph AS cluster_graph,
               n.berry_flux_mag AS berry_flux_mag,
               n.berry_flux_phase AS berry_flux_phase,
               sub.ai_instructions AS ai_instructions,
               sub.entry_points AS entry_points,
               sub.key_patterns_modules AS key_patterns_modules,
               sub.key_patterns_arrows AS key_patterns_arrows,
               subt.mean_phase AS subt_mean_phase,
               subt.mean_mag AS subt_mean_mag
        LIMIT 1
        """
        rec = s.run(q, {"name": name, "ns": namespace}).single()
    if not rec:
        return {"error": f"not found: {namespace}/{name}"}
    return dict(rec)


def tool_neighbors(args: dict) -> dict:
    name = args.get("name")
    if not name:
        return {"error": "missing 'name'"}
    namespace = args.get("namespace", "Mathlib")
    rel = args.get("rel")  # e.g. "APPLIES", or None for any
    direction = args.get("direction", "both")
    k = args.get("k", 10)

    if direction == "out":
        pattern = "(n)-[r" + (f":{rel}" if rel else "") + "]->(other)"
    elif direction == "in":
        pattern = "(n)<-[r" + (f":{rel}" if rel else "") + "]-(other)"
    else:
        pattern = "(n)-[r" + (f":{rel}" if rel else "") + "]-(other)"

    with driver().session() as s:
        q = f"""
        MATCH (n {{namespace: $ns, name: $name}})
        MATCH {pattern}
        WHERE other.namespace IS NOT NULL
        RETURN DISTINCT type(r) AS rel,
                        other.name AS other_name,
                        other.namespace AS other_ns,
                        labels(other)[0] AS other_label,
                        substring(coalesce(other.signature, ''), 0, 200) AS other_sig
        LIMIT $k
        """
        rows = [dict(r) for r in s.run(q, {"name": name, "ns": namespace, "k": k})]
    return {"source": name, "direction": direction, "rel": rel, "k": k, "results": rows}


def tool_goal_to_proof_step(args: dict) -> dict:
    """SOTA T4.2.b — Given a goal-state string and optional tactic prefix, return
    top-K :ProofStep nodes (real elaborated goals from FULL T1.3) with similar
    goal_before context. Each result names the parent theorem, step index,
    actual tactic that fired at that point, and the resulting goal_after.

    Use case: "I'm staring at `⊢ ∀ x, P x → Q x` after `intro x; intro hp`.
    What tactic do practitioners typically use next?" Returns concrete examples
    from the OV2 + Mathlib proof corpus.

    Two retrieval modes:
      1. Exact prefix match (fast path) — tactic_prefix matches ProofStep.tactic
         sequence up to step_idx-1. Returns next-tactic frequency distribution.
      2. Goal-state kNN (semantic) — when prefix is empty OR no exact-prefix
         hits exist, falls back to substring match on goal_before. Eventually
         (when proof_step_goal_embedding index lands) will use real kNN.

    Backed by :ProofStep nodes with full_t1_3=true (loaded from
    dump_proof_steps.lean output via load_proof_steps.py).

    Created: 2026-05-01 (SOTA T4.2.b LITE — exact-prefix match mode).
    """
    goal_str = (args.get("goal_str") or "").strip()
    prefix = args.get("prefix") or []
    namespace = args.get("namespace")
    k = int(args.get("k", 10))
    if not isinstance(prefix, list):
        return {"error": "'prefix' must be list[str]"}

    with driver().session() as s:
        ns_clause = "AND ps.namespace = $ns" if namespace else ""
        # Mode 1: exact prefix match (most powerful when caller has history).
        # We require ps.step_idx == size(prefix) AND prev N tactics match.
        if prefix:
            q_prefix = f"""
            MATCH (ps:ProofStep)
            WHERE ps.full_t1_3 = true
              AND ps.step_idx = $prefix_len
              {ns_clause}
            // Pull the chain of preceding steps and verify each matches prefix.
            WITH ps
            MATCH (psib:ProofStep {{parent_thm: ps.parent_thm, full_t1_3: true}})
            WHERE psib.step_idx < ps.step_idx
            WITH ps, psib ORDER BY psib.step_idx ASC
            WITH ps, collect(psib.tactic) AS prev_tactics
            WHERE prev_tactics = $prefix
            RETURN ps.parent_thm AS parent_thm,
                   ps.step_idx AS step_idx,
                   ps.tactic AS tactic,
                   ps.tactic_kind AS tactic_kind,
                   ps.goal_before AS goal_before,
                   ps.goal_after AS goal_after,
                   ps.n_goals_before AS n_goals_before,
                   ps.namespace AS namespace,
                   ps.file AS file
            ORDER BY size(ps.goal_after) ASC
            LIMIT $k
            """
            params = {"prefix": prefix, "prefix_len": len(prefix), "k": k}
            if namespace:
                params["ns"] = namespace
            rows = [dict(r) for r in s.run(q_prefix, params)]
            if rows:
                from collections import Counter
                tac_freq: Counter = Counter()
                for r in rows:
                    tac_freq[r["tactic"]] += 1
                return {
                    "mode": "exact_prefix",
                    "prefix": prefix,
                    "k": k,
                    "namespace": namespace,
                    "results": rows,
                    "next_tactic_distribution": dict(tac_freq.most_common(20)),
                }

        # Mode 2: substring/keyword fallback on goal_before
        # (will be replaced by kNN once proof_step_goal_embedding index lands).
        if goal_str:
            keyword = goal_str.split("⊢")[-1].strip()[:60] if "⊢" in goal_str else goal_str[:60]
            q_substr = f"""
            MATCH (ps:ProofStep)
            WHERE ps.full_t1_3 = true
              AND ps.goal_before CONTAINS $kw
              {ns_clause}
            RETURN ps.parent_thm AS parent_thm,
                   ps.step_idx AS step_idx,
                   ps.tactic AS tactic,
                   ps.tactic_kind AS tactic_kind,
                   ps.goal_before AS goal_before,
                   ps.goal_after AS goal_after,
                   ps.n_goals_before AS n_goals_before,
                   ps.namespace AS namespace,
                   ps.file AS file
            ORDER BY ps.step_idx ASC
            LIMIT $k
            """
            params = {"kw": keyword, "k": k}
            if namespace:
                params["ns"] = namespace
            rows = [dict(r) for r in s.run(q_substr, params)]
            from collections import Counter
            tac_freq2: Counter = Counter()
            for r in rows:
                tac_freq2[r["tactic"]] += 1
            return {
                "mode": "goal_substring",
                "keyword": keyword,
                "k": k,
                "namespace": namespace,
                "results": rows,
                "next_tactic_distribution": dict(tac_freq2.most_common(20)),
            }

    return {
        "mode": "empty",
        "results": [],
        "note": "Provide either 'goal_str' or 'prefix' to query.",
    }


def tool_tactic_continuation(args: dict) -> dict:
    """SOTA T4.2 — Find theorems whose elaborated-term tactic-evidence covers
    a given set of tactics, ranked by richness of co-occurring extra tactics.

    Use case: "I've already invoked [linarith, ring]. Which OV2/Mathlib proofs
    use this combination AND something else? What's the empirical follow-up
    distribution?" Useful for tactic-suggestion + proof-pattern discovery.

    Backed by `Theorem.tactic_evidence` (set via T1.2 Cypher migration over
    proof_body — see ~/lean-v2/.neo4j/set_tactic_evidence.cypher).

    Created: 2026-04-30 / 2026-05-01 (SOTA T4.2 ENABLE).
    """
    prefix = args.get("prefix", [])
    namespace = args.get("namespace")
    k = int(args.get("k", 10))
    if not isinstance(prefix, list) or not all(isinstance(t, str) for t in prefix):
        return {"error": "'prefix' must be list[str]"}

    with driver().session() as s:
        ns_clause = "AND t.namespace = $ns" if namespace else ""
        q = f"""
        MATCH (t:Theorem)
        WHERE t.tactic_evidence IS NOT NULL
          AND all(tag IN $prefix WHERE tag IN t.tactic_evidence)
          {ns_clause}
        WITH t, [tag IN t.tactic_evidence WHERE NOT tag IN $prefix] AS extra
        RETURN t.name AS name,
               t.namespace AS namespace,
               t.tactic_evidence AS evidence,
               extra,
               size(t.tactic_evidence) AS n_evidence,
               t.difficulty AS difficulty,
               t.tier AS tier,
               substring(coalesce(t.signature, ''), 0, 200) AS signature
        ORDER BY size(extra) DESC, n_evidence DESC, t.difficulty ASC
        LIMIT $k
        """
        params = {"prefix": prefix, "k": k}
        if namespace:
            params["ns"] = namespace
        rows = [dict(r) for r in s.run(q, params)]

    from collections import Counter
    tag_freq: Counter = Counter()
    for row in rows:
        for tag in row.get("extra") or []:
            tag_freq[tag] += 1

    return {
        "prefix": prefix,
        "namespace": namespace,
        "k": k,
        "results": rows,
        "next_tag_distribution": dict(tag_freq.most_common(20)),
    }


def tool_find_similar(args: dict) -> dict:
    name = args.get("name")
    if not name:
        return {"error": "missing 'name'"}
    namespace = args.get("namespace", "Mathlib")
    k = args.get("k", 10)
    rerank = bool(args.get("rerank", False))
    rerank_pool = int(args.get("rerank_pool", 50))
    fetch_k = max(k, rerank_pool) if rerank else k
    with driver().session() as s:
        q = """
        MATCH (seed {namespace: $ns, name: $name})
        WHERE seed.embedding_lean IS NOT NULL
        WITH seed, seed.embedding_lean AS vec, seed.signature AS seed_sig
        CALL db.index.vector.queryNodes('lean_retriever_embedding_theorem', $k + 1, vec)
        YIELD node AS n, score
        WHERE elementId(n) <> elementId(seed)
        RETURN seed_sig AS seed_sig,
               n.name AS name,
               n.namespace AS namespace,
               labels(n)[0] AS label,
               n.mathlib_module AS module,
               substring(coalesce(n.signature, ''), 0, 300) AS signature,
               n.subsystem_id AS subsystem_id,
               n.subtopology_id AS subtopology_id,
               score
        ORDER BY score DESC LIMIT $k
        """
        raw = [dict(r) for r in s.run(q, {"name": name, "ns": namespace, "k": fetch_k})]

    seed_sig = raw[0].get("seed_sig", name) if raw else name
    rows = [{k_: v for k_, v in r.items() if k_ != "seed_sig"} for r in raw]

    if rerank and rows:
        docs = [r.get("signature", "") or r.get("name", "") for r in rows]
        try:
            ranks = rerank_pairs(seed_sig or name, docs)
            for r in rows:
                r["knn_score"] = r.pop("score")
                r["rerank_score"] = None
            for rr in ranks:
                idx = rr.get("index")
                if 0 <= idx < len(rows):
                    rows[idx]["rerank_score"] = rr.get("relevance_score")
            rows.sort(key=lambda x: x.get("rerank_score") or -1e9, reverse=True)
        except Exception as e:
            return {"seed": name, "k": k, "results": rows[:k], "rerank_error": str(e)}

    return {"seed": name, "k": k, "reranked": rerank, "results": rows[:k]}


# ============================================================================
# MCP protocol (minimal JSON-RPC stdio)
# ============================================================================


TOOLS = {
    "retrieve_premises": {
        "description": "Retrieve top-k Lean premises relevant to a goal. Two-stage: Qwen3-Embedding-8B (GPU :7999) → Neo4j vector kNN → optional Qwen3-Reranker-8B (CPU :7996, when rerank=true) for final precision. Rerank ~1s per pair; use for ambiguous goals or cross-namespace bridge search.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "goal": {"type": "string", "description": "Lean goal text"},
                "k": {"type": "integer", "default": 10, "description": "Final top-k returned"},
                "namespace": {"type": "string", "description": "Filter by namespace (Mathlib / OmegaTheoryV2)"},
                "rerank": {"type": "boolean", "default": False, "description": "Enable CPU cross-encoder rerank"},
                "rerank_pool": {"type": "integer", "default": 50, "description": "How many kNN candidates to rerank"},
            },
            "required": ["goal"],
        },
        "_handler": tool_retrieve_premises,
    },
    "rerank_documents": {
        "description": "Score a query against a list of candidate documents using Qwen3-Reranker-8B on CPU :7996. Use for on-demand bridge scoring, cross-namespace candidate filtering, or re-ordering externally-retrieved lists. Latency: ~1s per pair at 16 cores. Keep documents list ≤50.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "query": {"type": "string", "description": "Anchor text (e.g. goal, theorem headline, hypothesis sentence)"},
                "documents": {"type": "array", "items": {"type": "string"}, "description": "Candidate documents (signatures / docstrings / hypotheses)"},
                "top_k": {"type": "integer", "default": 10},
            },
            "required": ["query", "documents"],
        },
        "_handler": tool_rerank_documents,
    },
    "explain_theorem": {
        "description": "Get full signature + proof_body + docstring + typed-edge neighborhood for a declaration.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "namespace": {"type": "string", "default": "Mathlib"},
            },
            "required": ["name"],
        },
        "_handler": tool_explain_theorem,
    },
    "subsystem_of": {
        "description": "Return the Grothendieck/Leiden subsystem for a declaration + its ai_instructions (after subsystem detection runs).",
        "inputSchema": {
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "namespace": {"type": "string", "default": "Mathlib"},
            },
            "required": ["name"],
        },
        "_handler": tool_subsystem_of,
    },
    "neighbors": {
        "description": "Get typed-edge neighbors of a declaration (APPLIES/UNFOLDS/ASSUMES/...).",
        "inputSchema": {
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "rel": {"type": "string", "description": "Edge type filter, or omit for any"},
                "direction": {"type": "string", "enum": ["in", "out", "both"], "default": "both"},
                "namespace": {"type": "string", "default": "Mathlib"},
                "k": {"type": "integer", "default": 10},
            },
            "required": ["name"],
        },
        "_handler": tool_neighbors,
    },
    "find_similar": {
        "description": "Get top-k theorems most similar to a seed theorem. Pure kNN by default; set rerank=true for CPU cross-encoder filtering (useful when seed has many surface-similar matches that differ conceptually).",
        "inputSchema": {
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "namespace": {"type": "string", "default": "Mathlib"},
                "k": {"type": "integer", "default": 10},
                "rerank": {"type": "boolean", "default": False},
                "rerank_pool": {"type": "integer", "default": 50},
            },
            "required": ["name"],
        },
        "_handler": tool_find_similar,
    },
    "goal_to_proof_step": {
        "description": "SOTA T4.2.b — Given a goal-state string and/or tactic prefix, return top-K :ProofStep nodes (real elaborated goals from FULL T1.3 dump_proof_steps) with similar context. Returns concrete next-tactic examples with parent theorem + step index + actual tactic + resulting goal_after. Two modes: (1) exact prefix match — when prefix=[t0,t1,...] all match preceding steps in some theorem, returns step_idx=len(prefix) tactics; (2) goal substring fallback — keyword match on goal_before. Backed by :ProofStep nodes with full_t1_3=true.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "goal_str": {"type": "string", "description": "Goal text (e.g. '⊢ ∀ x, P x → Q x'); used in fallback mode"},
                "prefix": {"type": "array", "items": {"type": "string"}, "description": "Tactic prefix already invoked (ordered list); used in exact-match mode"},
                "namespace": {"type": "string", "description": "Filter by namespace (OmegaTheoryV2 / Mathlib)"},
                "k": {"type": "integer", "default": 10},
            },
        },
        "_handler": tool_goal_to_proof_step,
    },
    "tactic_continuation": {
        "description": "Find Theorems whose elaborated-term tactic-evidence covers a given set of tactics, ranked by richness of co-occurring extras. Returns next-tag frequency distribution. Use when stuck mid-proof and want empirical evidence: 'after linarith+ring, what tactic typically lands the proof?' Backed by Theorem.tactic_evidence (T1.2). Tactics tracked: linarith, ring, norm_num, positivity, polyrith, gcongr, fun_prop, aesop, decide, rw_or_simp, rfl, congr, absurd, cases, and_intro, or_intro, iff_apply, exists_intro, nat_induct, lambda, have.",
        "inputSchema": {
            "type": "object",
            "properties": {
                "prefix": {
                    "type": "array",
                    "items": {"type": "string"},
                    "description": "Tactics already invoked (set, not sequence). Empty list = no filter (all-theorem distribution).",
                },
                "namespace": {
                    "type": "string",
                    "description": "Filter by namespace (Mathlib / OmegaTheoryV2). Default: both.",
                },
                "k": {"type": "integer", "default": 10},
            },
            "required": ["prefix"],
        },
        "_handler": tool_tactic_continuation,
    },
}


def rpc_send(response: dict):
    sys.stdout.write(json.dumps(response) + "\n")
    sys.stdout.flush()


def handle_request(req: dict):
    method = req.get("method")
    rid = req.get("id")

    if method == "initialize":
        rpc_send({
            "jsonrpc": "2.0",
            "id": rid,
            "result": {
                "protocolVersion": "2024-11-05",
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "omega-search", "version": "0.1.0"},
            },
        })
        return

    if method == "notifications/initialized":
        return  # ignore

    if method == "tools/list":
        rpc_send({
            "jsonrpc": "2.0",
            "id": rid,
            "result": {
                "tools": [
                    {"name": n, "description": d["description"], "inputSchema": d["inputSchema"]}
                    for n, d in TOOLS.items()
                ]
            },
        })
        return

    if method == "tools/call":
        params = req.get("params", {})
        tool_name = params.get("name")
        args = params.get("arguments", {})
        if tool_name not in TOOLS:
            rpc_send({"jsonrpc": "2.0", "id": rid,
                      "error": {"code": -32601, "message": f"Unknown tool: {tool_name}"}})
            return
        try:
            result = TOOLS[tool_name]["_handler"](args)
            rpc_send({
                "jsonrpc": "2.0",
                "id": rid,
                "result": {
                    "content": [{"type": "text", "text": json.dumps(result, indent=2, default=str)}]
                },
            })
        except Exception as e:
            rpc_send({
                "jsonrpc": "2.0",
                "id": rid,
                "error": {"code": -32603, "message": f"{type(e).__name__}: {e}",
                          "data": {"traceback": traceback.format_exc()}},
            })
        return

    rpc_send({"jsonrpc": "2.0", "id": rid,
              "error": {"code": -32601, "message": f"Unknown method: {method}"}})


def main():
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except json.JSONDecodeError as e:
            sys.stderr.write(f"parse error: {e}\n")
            continue
        handle_request(req)


if __name__ == "__main__":
    main()
