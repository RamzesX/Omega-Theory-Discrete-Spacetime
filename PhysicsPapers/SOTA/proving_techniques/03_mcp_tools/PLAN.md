# T4 — MCP Tools Wave (8 new)

**Status**: TODO Day 6-7 | **Effort**: 2 days, ~250 lines Python total
**Depends on**: T2 Qwen3 goal-endpoint (for T4.2.a/b), T1.3 ProofStep nodes (for T4.2.b/c)

## T4.1 — omega-orchestrator: 5 new tools (~150 lines)

Each is a Cypher-recipe wrapper. Recipes already exist in `V3-for-Lean/proof_hunter_design_v2.md` M1-M14.

| Tool | Method | Returns |
|---|---|---|
| `propose_conjecture(seed, k=10)` | M3 + M4 (analogy + Mendeleev) | top-K `:TheoremCandidate` with provenance |
| `find_missing_edges(target, k=10)` | M2 Adamic-Adar | top-K candidate APPLIES edges |
| `find_keystones(k=20)` | M13 articulation points | definitive SPOFs |
| `find_iff_cycles()` | M12 SCC in APPLIES DAG | latent iff-equivalences |
| `find_bridge_lemmas(threshold=-0.9)` | M6 negative-Ricci | bridge candidates |

## T4.2 — omega-search: 3 new tools (~100 lines)

| Tool | Input | Returns |
|---|---|---|
| `goal_to_premises(goal_str, k=20)` | Lean goal string | top-K Theorems via T2 + T3 hybrid |
| `goal_to_proof_step(goal_str, k=10)` | Lean goal string | top-K `:ProofStep` + next-tactic |
| `tactic_continuation(prefix=["intros","obtain"], k=10)` | tactic prefix | next-tactic distribution |

## Server source location

First action: `find /home/norbert -maxdepth 5 -name "*orchestrator*" -o -name "*omega*search*server*" 2>/dev/null`

## Verification

Each new tool returns expected schema for sample input. One MCP call from `prove-wizard-v3` succeeds.
