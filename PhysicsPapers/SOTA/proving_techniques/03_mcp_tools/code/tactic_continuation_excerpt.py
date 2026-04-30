"""SOTA T4.2 — `tactic_continuation` MCP tool (excerpt).

Mirror of the new tool added to /home/norbert/services/omega_search_mcp.py
on 2026-04-30 / 2026-05-01. The live MCP server is outside this repo (under
~/services/), so this file documents the implementation for git history.

Authority: ~/.claude/plans/binary-painting-dijkstra.md T4.2
Depends:   T1.2 set_tactic_evidence.cypher (sets Theorem.tactic_evidence)

Smoke test result (2026-05-01):
  prefix=['linarith', 'ring']  →  next_tag_distribution = {
    'norm_num': 5, 'rw_or_simp': 5, 'rfl': 5, 'congr': 5, 'cases': 5,
    'lambda': 5, 'have': 5, 'exists_intro': 4, 'absurd': 2, 'or_intro': 1
  }
"""

# Tool registration (added to TOOLS dict in omega_search_mcp.py):
TOOL_DESCRIPTOR = {
    "tactic_continuation": {
        "description": (
            "Find Theorems whose elaborated-term tactic-evidence covers a given "
            "set of tactics, ranked by richness of co-occurring extras. Returns "
            "next-tag frequency distribution. Use when stuck mid-proof and want "
            "empirical evidence: 'after linarith+ring, what tactic typically "
            "lands the proof?' Backed by Theorem.tactic_evidence (T1.2). Tactics "
            "tracked: linarith, ring, norm_num, positivity, polyrith, gcongr, "
            "fun_prop, aesop, decide, rw_or_simp, rfl, congr, absurd, cases, "
            "and_intro, or_intro, iff_apply, exists_intro, nat_induct, lambda, have."
        ),
        "inputSchema": {
            "type": "object",
            "properties": {
                "prefix": {
                    "type": "array",
                    "items": {"type": "string"},
                    "description": "Tactics already invoked (set, not sequence).",
                },
                "namespace": {
                    "type": "string",
                    "description": "Filter by namespace. Default: both.",
                },
                "k": {"type": "integer", "default": 10},
            },
            "required": ["prefix"],
        },
    },
}


def tool_tactic_continuation(args: dict, driver) -> dict:
    """Find theorems whose elaborated-term tactic-evidence covers `prefix`.

    Backed by `Theorem.tactic_evidence` (set via T1.2 Cypher migration).
    Returns top-k theorems ordered by richness of co-occurring extra tactics
    plus a frequency distribution of next-tags ("what tactic typically follows").
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
