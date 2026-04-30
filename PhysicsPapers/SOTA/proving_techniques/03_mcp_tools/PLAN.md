# T4 — MCP Tools Wave (8 new)

**Status**: 1/8 LIVE (`tactic_continuation`) | **Effort**: 2 days, ~250 lines Python total
**Depends on**: T2 Qwen3 goal-endpoint (✓ T4.2.a; LIVE via existing `retrieve_premises`), T1.3 ProofStep nodes (T4.2.b)
**Server source**: `/home/norbert/services/omega_search_mcp.py` (omega-search) + omega-orchestrator (TBD)

## T4.1 — omega-orchestrator: 5 new tools (~150 lines)

Each is a Cypher-recipe wrapper. Recipes already exist in `V3-for-Lean/proof_hunter_design_v2.md` M1-M14.

| Tool | Method | Returns | Status |
|---|---|---|---|
| `propose_conjecture(seed, k=10)` | M3 + M4 (analogy + Mendeleev) | top-K `:TheoremCandidate` with provenance | TODO |
| `find_missing_edges(target, k=10)` | M2 Adamic-Adar | top-K candidate APPLIES edges | TODO |
| `find_keystones(k=20)` | M13 articulation points | definitive SPOFs | TODO |
| `find_iff_cycles()` | M12 SCC in APPLIES DAG | latent iff-equivalences | TODO |
| `find_bridge_lemmas(threshold=-0.9)` | M6 negative-Ricci | bridge candidates | TODO |

## T4.2 — omega-search: 3 new tools (~100 lines)

| Tool | Input | Returns | Status |
|---|---|---|---|
| `goal_to_premises(goal_str, k=20)` | Lean goal string | top-K Theorems via T2 + T3 hybrid | ✓ COVERED — existing `retrieve_premises` does this; uses Qwen3 instruction-aware embed + optional rerank |
| `goal_to_proof_step(goal_str, k=10)` | Lean goal string | top-K `:ProofStep` + next-tactic | BLOCKED on T1.3 |
| `tactic_continuation(prefix=[...], k=10)` | tactic-set | next-tag distribution + theorems | ✓ LIVE 2026-04-30 |

### `tactic_continuation` smoke test

```python
tool_tactic_continuation({'prefix': ['linarith', 'ring'], 'namespace': 'OmegaTheoryV2', 'k': 5})
# → next_tag_distribution: {'norm_num': 5, 'rw_or_simp': 5, 'rfl': 5, 'congr': 5,
#                           'cases': 5, 'lambda': 5, 'have': 5, 'exists_intro': 4,
#                           'absurd': 2, 'or_intro': 1}
```

Backed by `Theorem.tactic_evidence` set via `~/lean-v2/.neo4j/set_tactic_evidence.cypher` (T1.2).

## Verification

`tactic_continuation` returns expected schema (verified 2026-04-30).
omega-orchestrator tool source: TBD — needs `find /home/norbert -maxdepth 5 -name "*orchestrator*"`.
