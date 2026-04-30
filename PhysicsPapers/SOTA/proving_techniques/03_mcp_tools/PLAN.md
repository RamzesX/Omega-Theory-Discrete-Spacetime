# T4 — MCP Tools Wave (8 new)

**Status**: 5/8 LIVE | **Effort**: 2 days, ~250 lines Python total
**Depends on**: T2 Qwen3 goal-endpoint (✓ T4.2.a; LIVE via existing `retrieve_premises`), T1.3 ProofStep nodes (T4.2.b)
**Server source**: `/home/norbert/services/omega_search_mcp.py` (omega-search) + `/home/norbert/omega_orchestrator_mcp/` (omega-orchestrator)

## T4.1 — omega-orchestrator: 5 new tools (~150 lines)

Each is a Cypher-recipe wrapper. Recipes already exist in `V3-for-Lean/proof_hunter_design_v2.md` M1-M14.

| Tool | Method | Returns | Status |
|---|---|---|---|
| `propose_conjecture(seed, k=10)` | M3 + M4 (analogy + Mendeleev) | top-K `:TheoremCandidate` with provenance | TODO |
| `find_missing_edges(seed, k=10)` | M2 Adamic-Adar | top-K candidate APPLIES edges | ✓ LIVE 2026-05-01 |
| `find_keystones(k=20)` | M13 (pagerank × indegree proxy) | top-K SPOFs | ✓ LIVE 2026-05-01 |
| `find_iff_cycles(limit=50)` | M12 (length-2 SCC) | latent iff-equivalences | ✓ LIVE 2026-05-01 |
| `find_bridge_lemmas(min_span=3, k=20)` | M6 (community-span proxy) | bridge candidates | ✓ LIVE 2026-05-01 |

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

## Smoke tests (2026-05-01)

| Tool | Sample call | Result |
|---|---|---|
| `find_keystones(k=3)` | top-3 OV2 keystones | l_P_pos (225.98), c_pos (160.03), hbar_pos (93.96) |
| `find_iff_cycles(limit=5)` | length-2 cycles | 0 found (healthy DAG) |
| `find_bridge_lemmas(min_span=4, k=3)` | bridges spanning ≥4 communities | 5-span: P2/Gienah waves |
| `find_missing_edges(seed='OmegaTheory.Irrationality.computationalUncertainty_pos', k=3)` | Adamic-Adar | top: electronMassScaleBound_pos (AA=3.92, common=34) |

## Verification

`tactic_continuation` returns expected schema (verified 2026-04-30).
T4.1 4-tool batch end-to-end verified 2026-05-01 (see code/orchestrator_t41_excerpt.py).
