# Omega Orchestrator MCP — architecture + progress (2026-04-24)

> **Live plan**: `/home/norbert/.claude/plans/elegant-sauteeing-simon.md` (approved).
> **Memory**: `~/.claude/projects/-mnt-c-.../memory/project_omega_orchestrator_mcp_2026-04-24.md`.
> This file is an on-disk mirror so the architecture survives session close.

## Context

Our Lean theorem-proving pipeline has 30 MCP tools across 3 servers (`omega-search` 6 · `neo4j-math` 3 · `lean-lsp` 21). Wizards call 3-5 of them per proof and synthesize tactics manually. The Omega Orchestrator MCP consolidates these into atomic primitives so a wizard call becomes `propose_proof(goal)` → pastable tactic stub.

## MVP (Phase 1 — 6 tools)

| # | Tool | What it returns | Delegates to |
|---|------|-----------------|--------------|
| 1 | `propose_proof(goal, wizard_name, k=5)` | `{tactic_stub, cited_premises, confidence, rationale}` — a Lean 4 pastable block | `omega-search.retrieve_premises` + `omega-search.neighbors` + synth |
| 2 | `omega_hammer_premise(goal, top_k=20, mix_mathlib=True, rerank=True)` | `{premises: [{name, score, namespace}]}` — ranked list, OV2-aware replacement for `lean_hammer_premise` | :7999 embed + vector-kNN + :7996 rerank |
| 3 | `axiom_audit(targets=CAPSTONES)` | `{clean: bool, violations: [...], by_capstone: {...}}` | subprocess `lake env lean` + parse `#print axioms` |
| 4 | `phase_detect()` | `{phase: A\|B\|C\|idle, reason, next_action, servers, graph}` | `neo4j-math` + health probes |
| 5 | `refresh_graph(dry_run=True)` | `{steps: [...], verified: bool}` — atomic Phase C | shell + `neo4j-math.write_neo4j_cypher` |
| 6 | `upsert_theorem_candidate(name, sig, rationale, sketch)` | `{id, embedded: bool}` | `omega-search` embed + `neo4j-math` write |

**Size target**: ~600 LOC glue across 3 files (`__main__.py`, `synthesis.py`, `orchestration.py`).

## Full scope (Phase 2, deferred)

7. `similar_candidates(name)` — kNN on TheoremCandidate embeddings (needs backfill)
8. `dispatch_wizard_batch(candidates, parallel=6)`
9. `backfill_embeddings(label, namespace)` — close 559 Def + 370 Cand + 150 Finding gaps
10. `verify_no_regression(cycle_N)`
11. `bridge_match(goal)` — candidate → completed Mathlib proof match
12. `cohomology_gap_map()` — Betti + obstruction reporting for paper
13. `cycle_summary(N)` — atomic cycle-close writer

## Architecture

```
omega-orchestrator (stdio MCP, FastMCP framework)
├── facade layer (httpx + mcp-client async)
│   ├── → omega-search (:7999 embed + :7996 rerank + retrieval)
│   ├── → neo4j-math (bolt://:7687, cypher only)
│   └── → lean-lsp (verify + diagnostics — proving stays with wizard)
├── synthesis layer ≈150 LOC (NEW)
│   ├── extract tactic patterns from proof_body
│   ├── rewrite with renamed premises + wizard goal
│   └── format Lean block with citation comments
├── orchestration layer ≈200 LOC (NEW)
│   ├── Phase A/B/C state machine
│   ├── 7-step Phase C runner (power-hygiene respected)
│   └── bulk #print axioms invoker
└── service layer
    ├── FastMCP stdio transport
    ├── shared Neo4j driver pool (3 conn)
    └── shared httpx AsyncClient
```

## Files

### Modify (expand scaffold at `~/omega_orchestrator_mcp/`)
- `omega_orchestrator/__main__.py` — 325 → ~400 LOC; delete `find_similar_proofs`, add 3 new tools, refactor 2 scaffolded
- `pyproject.toml` — add `mcp-client`, optional `structlog`

### Create
- `omega_orchestrator/synthesis.py` — tactic-stub synthesis
- `omega_orchestrator/orchestration.py` — Phase-C runner + state machine + bulk axiom audit
- `tests/test_propose_proof.py` — golden-file
- `tests/test_phase_detect.py` — state machine
- `README.md` — 1-page install + tool reference

### Register
- `~/.claude.json` → add `omega-orchestrator` under `mcpServers` (Claude Code restart required)

## Audit baselines (2026-04-24)

### Embedding state
| Namespace | Label | Total | Embedded | % |
|-----------|-------|-------|----------|---|
| OmegaTheoryV2 | Theorem | 10,142 | 10,142 | 100 |
| Mathlib | Theorem | 175,137 | 175,137 | 100 |
| OmegaTheoryV2 | Definition | 5,024 | 4,465 | 88.9 |
| OmegaTheoryV2 | TheoremCandidate | 370 | 0 | 0 |
| OmegaTheoryV2 | GraphFinding | 150 | 0 | 0 |

### RAM / Neo4j
- Host: 129 GB free of 157 GB
- Container: 23 GiB used; Heap 12-24 GB; Pagecache 64 GB (40% used)
- DB: 17.5 GB · 282K nodes · 11.4M rels
- Adding 3 more indices: ~200 MB total — trivial

### lean-lsp reuse
- Open-source Python at `~/.local/share/uv/tools/lean-lsp-mcp/` (v0.26.1, 5,607 LOC)
- Uses `leanclient` to talk to `lake env lean --server` (Lean LSP)
- Remote HTTP tools: `lean_loogle`, `lean_leansearch`, `lean_leanfinder`, `lean_hammer_premise`, `lean_state_search`
- **We build `omega_hammer_premise` instead of forking hammer** — domain-matched over OV2+Mathlib, no rate limit, strictly better for OV2 proofs

## Progress

- [x] 2026-04-24 — scaffold at `~/omega_orchestrator_mcp/` (3 tools, 325 LOC)
- [x] 2026-04-24 — 3 parallel read-only audits (embeddings, RAM, gap-vs-tools)
- [x] 2026-04-24 — lean-lsp source audit
- [x] 2026-04-24 — plan approved + mirrored on-disk
- [x] 2026-04-24 — **MVP implementation complete**
  - `synthesis.py` 251 LOC · `orchestration.py` 337 LOC · `__main__.py` 520 LOC · tests 386 LOC
  - All 26 tests passing (`pytest` in `~/genai_env/`)
  - 6 `@app.tool()` decorators registered on FastMCP app
  - Registered in `~/.claude.json` under `mcpServers.omega-orchestrator`
- [ ] **Claude Code restart required** to activate the server
- [ ] Wizard-prompt migration
- [ ] Parity measurement (token drop + close-rate)

## Verification

1. Unit: `pytest omega_orchestrator/tests/` golden-file tactic output + state-machine transitions
2. Integration: boot both servers, `propose_proof("π is irrational to degree 2")` → valid Lean 4 block
3. Parity: migrate 1 wizard prompt, confirm ≥40% token drop + close rate ≥ baseline
4. Smoke: `refresh_graph(dry_run=True)` prints 7 steps without touching graph
5. Axiom sentinel: `axiom_audit()` on 3,938 GREEN build returns `{clean: true, violations: []}`

## Handoff

One general-purpose agent (NOT lean-proof-wizard — Python tooling, not Lean proving) with model=opus, run_in_background=True, full plan inline. Deliverables per §Handoff in plan file.
