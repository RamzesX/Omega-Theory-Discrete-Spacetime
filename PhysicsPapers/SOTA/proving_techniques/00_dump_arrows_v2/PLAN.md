# T1 — dump_arrows v2 (proof-flow extraction)

**Status**: T1.1 ✓ DONE 2026-04-30 | T1.2 TODO Day 2 | T1.3 TODO Day 8-10
**Effort**: T1.1 (1hr), T1.2 (1 day), T1.3 (1 week)

## Sub-layers

### T1.1 ✓ DONE — Difficulty proxy + tier classification

Status: **LANDED 2026-04-30**.

Properties added to all 17,524 OV2 Theorems via direct Cypher (`set_difficulty_and_freshness.cypher`):
- `difficulty: float` — composite score
- `tier: "99" | "80" | "Heart"` — quantile-based classification
- `n_have_obtain_refine: int` — count of `have/obtain/refine` tactics in proof body
- `n_named_in_sig: int` — count of `_NAMED_` tokens in signature
- `freshness: float` — exp(-(now - env_dumped_at) / 7d) — for retrieval boost (T6.11)

Distribution:
- Tier-99: 5,784 (33.0%)
- Tier-80: 5,782 (33.0%)
- Tier-Heart: 5,958 (34.0%)
- Range: difficulty ∈ [0.6, 207.91]; q33=2.93, q66=12.06

Top Heart-tier examples (by difficulty):
1. `eventually_periodic_digit_frequency_rational` — d=207.91 (34 have/obtain/refine)
2. `errorTerm_bounded` — d=178.91
3. `digit_count_eq` — d=176.09
4. `taylor_tail_bound` — d=146.27
5. `OmegaTheory.Irrationality.pi_quarter_error_bound` — d=92.63

Verification query:
```cypher
MATCH (t:Theorem {namespace: "OmegaTheoryV2"}) WHERE t.tier IS NOT NULL
RETURN t.tier AS tier, count(t) AS n
ORDER BY CASE t.tier WHEN "99" THEN 1 WHEN "80" THEN 2 ELSE 3 END
```

Files:
- `~/lean-v2/.neo4j/set_difficulty_and_freshness.cypher` (idempotent, re-runnable)

### T1.2 — Tactic sequences extraction (TODO Day 2)

**Goal**: extract ordered list of tactic head names per `thmInfo.value`. Emit as `tactics: ["intros", "obtain", "rw", "linarith"]` JSONL field.

**Implementation**:
- Edit `~/lean-v2/OmegaTheory/Meta/DumpArrows.lean` (~80 lines)
- Use `Lean.Elab.Tactic` to walk the `Syntax` tree of each thm's value
- Extract head identifier of each tactic invocation
- Filter to canonical tactic names (skip `<;>`, `;`, etc.)

**Loader update**:
- Edit `~/lean-v2/.neo4j/load_arrows_parallel.py` to ingest `tactics` field as Theorem property
- New SET clause: `SET t.tactics = $tactics`

**Verification**:
```cypher
MATCH (t:Theorem {namespace: "OmegaTheoryV2"}) WHERE t.tactics IS NOT NULL
RETURN size(t.tactics) AS len, count(t) AS n ORDER BY len
```

Expected: distribution of tactic-sequence lengths (1-50 typical).

**Unlocks**: `tactic_continuation` MCP tool (T4.2) — given a tactic prefix, return distribution of next tactics from corpus.

### T1.3 — Goal-state checkpoints (TODO Day 8-10)

**Goal**: materialize proof state at every tactic boundary. Emit `:ProofStep {parent_thm, step_idx, goal_str, tactic, goal_after_str}` records.

**Implementation**:
- NEW file `~/lean-v2/OmegaTheory/Meta/DumpProofSteps.lean` (~300 lines)
- LSP-driven secondary pass: for each `thmInfo`, run `Lean.Elab.Tactic.evalTactic` with snapshot capture
- Emit JSONL with goal-string + tactic + post-state

**Loader**:
- New file `~/lean-v2/.neo4j/load_proof_steps.py`
- Schema: `(t:Theorem)-[:HAS_STEP]->(ps:ProofStep)`

**Embedding**:
- After ingest, embed `:ProofStep.goal_str` via Qwen3 with `[goal]` prefix (T2 endpoint)
- Index in new vector index `proof_step_goal_embedding` (4096-d, cosine)

**Verification**:
```cypher
MATCH (t:Theorem)-[:HAS_STEP]->(ps:ProofStep) RETURN count(ps)
```
Expected: ~50K-200K ProofStep nodes (~3-12 steps per theorem on average).

**Unlocks**:
- `goal_to_proof_step` MCP tool (T4.2) — given current goal, retrieve analogous proof states + their next tactic
- LeanDojo-tier active-proof retrieval

**Risk**: Lean LSP secondary-pass is non-trivial. Defer if T1.1 + T1.2 + T2 already deliver 80% of value.

## Hardware leverage

- T1.2 Lean parsing reuses existing `lake build` toolchain at `~/lean-v2` (no new binaries)
- T1.3 LSP secondary pass uses existing Lean 4.29.0 + Mathlib v4.29.0 (no new deps)
- Embeddings flow through existing :7999 Qwen3 server (concurrent with reranker :7996)
- Neo4j writes: ProofStep nodes (~200K) fit in 100GB heap with margin

## Sources

- `~/lean-v2/OmegaTheory/Meta/DumpArrows.lean` — current 12-arrow extractor
- `~/lean-v2/OmegaTheory/Meta/DumpDeclarations.lean` — node extractor (per-decl JSONL)
- `~/lean-v2/.neo4j/load_arrows_parallel.py` — loader with shard-by-source partitioning
- V3-for-Lean §3.2 — 15 V3 arrows (12 currently extracted)
- `Lean.Elab.Tactic.evalTactic` — Lean 4 stdlib snapshot capture
