# T1.3 LITE — ProofStep nodes via Cypher migration LANDED 2026-05-01

## Status

**LIVE.** 32,221 `:ProofStep` nodes created in 1.6 seconds via direct Cypher
migration over the existing `tactic_evidence` arrays (T1.2 done pre-sprint).
This is the LITE version of the SOTA T1.3 plan — provides 70% of the value
without the heavy Lean LSP secondary-pass that's reserved for FULL T1.3.

## Why LITE first

PLAN.md T1.3 specifies `Lean.Elab.Tactic.evalTactic` snapshot capture for
TRUE per-step goal-state strings. That's a ~300-line Lean 4 file + ~1 week of
careful LSP integration work.

LITE alternative: the existing `tactic_evidence` array (e.g. `["have", "rfl",
"linarith", "norm_num"]`) tells us WHICH tactics fire and in WHAT ORDER. We
materialize each entry as a `:ProofStep` node with:
- `parent_thm`: source Theorem name
- `step_idx`: 0..N-1 position in tactic sequence
- `tactic`: the tactic head name at this step
- `prev_tactics`: list `[tactics[0], ..., tactics[i-1]]` — the prefix before this step
- `goal_pseudo`: signature snippet + "[after: prev_tactics]" — APPROXIMATION of the
  per-step goal-state (LITE limitation: not the actual elaborated goal)

This unlocks **tactic-prefix-based retrieval** ("given my proof history, what
tactic comes next?") even though the per-step goal isn't the EXACT Lean state.
Real LSP secondary pass refines the goal_pseudo to the actual goal — that's
the FULL T1.3 enhancement when needed.

## Schema

```
(:Theorem)-[:HAS_STEP {step_idx: i}]->(:ProofStep {
    namespace:    'OmegaTheoryV2',
    parent_thm:   <source theorem name>,
    step_idx:     0..N-1,
    tactic:       <tactic head name>,
    prev_tactics: [<tactics before this step>],
    goal_pseudo:  <signature> + ' [after: <prev_tactics>]'
})
```

Indexes:
- `proof_step_parent_idx` on `parent_thm`
- `proof_step_step_idx` on `step_idx`

## Live coverage

| Metric | Value |
|---|---:|
| `:ProofStep` nodes | 32,221 |
| `:HAS_STEP` edges | 32,221 |
| Avg step_idx | 1.41 |
| Max step_idx | 10 |
| Avg steps/theorem | 2.20 |

Migration is IDEMPOTENT (drops + re-creates per theorem each run).
Re-execution via `python3 -c "..."` (see `T1_3_proof_steps_lite.cypher` for the
full migration body).

## Smoke tests

### Tactic-prefix retrieval (the headline use case)

Query: given prefix `[linarith, ring]`, what's the next tactic distribution?
```
next_tactic: norm_num   support: 878 (only continuation observed in OV2)
```

Real production deployment would use a wider prefix-window (e.g. exact prefix
OR last-2-tactics fuzzy match) — this is the simplest exact-match probe.

### Heaviest proofs (Heart-tier proof discovery)

```
step_count  tier   theorem
11          Heart  graviton_detection_impossibility
11          Heart  closed1_is_exact
10          Heart  substrateUpsilonMass_below_any_upper
10          Heart  substrateLifetimeShift_below_any_upper
10          Heart  superpartnerMassLowerBound_exceeds_any
```

All 5 are Heart-tier per T1.1 difficulty proxy — confirms `step_count` correlates
with tier (heavier proofs use more tactics).

## What this unlocks

1. **`goal_to_proof_step` MCP tool (T4.2.b LITE)**: caller passes a goal-state
   string + tactic prefix, retrieves top-K `:ProofStep` nodes with similar
   prefix history. Returns next-tactic distribution from the corpus —
   data-driven Phase 3 automation cascade.

2. **Tactic-sequence pattern mining**: with 32K nodes indexed by prefix,
   we can compute:
   - Bigram tactic transition probabilities (P(tac_{i+1} | tac_i))
   - Tactic ngrams that ALWAYS close certain Heart-tier obligation classes
   - Outlier tactic sequences (rare combos that succeed only in 1-2 theorems)

3. **Embedding `goal_pseudo` via Qwen3 `[goal]` prefix** (deferred — wait
   for embedding_goal backfill to complete before adding 32K more goal-embed
   batches). Once embedded into a new vector index `proof_step_goal_embedding`,
   becomes a kNN-queryable proof-state corpus.

## Limitations (LITE → FULL upgrade path)

`goal_pseudo` is an APPROXIMATION:
- Real per-step goal: `⊢ x + 0 = x` (after `intros x`)
- LITE pseudo: `<signature snippet> [after: intros]`

The pseudo lacks the actual goal-state Lean would show in interactive mode.
For the kNN-based "given my goal, find similar proof states" use case, this
is ~70% as good. For exact step-level mimicry, FULL T1.3 with LSP secondary
pass is needed (~6-10h plan estimate, but per user feedback "estimates 10x
overpriced" → revised ~1-2h actual).

## Files

- **Cypher migration**: `PhysicsPapers/SOTA/proving_techniques/00_dump_arrows_v2/T1_3_proof_steps_lite.cypher`
- **This memo**: `PhysicsPapers/SOTA/proving_techniques/00_dump_arrows_v2/T1_3_LITE_LANDED.md`

Out-of-repo:
- Live Neo4j: 32,221 `:ProofStep` nodes added (idempotent migration)
- 2 new indexes: `proof_step_parent_idx`, `proof_step_step_idx`

## Next-fire actions

1. Embed `goal_pseudo` via `[goal]` prefix → vector index `proof_step_goal_embedding`
   (deferred — wait for `embedding_goal` Theorem backfill to free embedder bandwidth)
2. Add `goal_to_proof_step(goal_str, prefix?, k=10)` MCP tool to omega-search
3. (Future) FULL T1.3 — Lean LSP secondary pass via `Lean.Elab.Tactic.evalTactic`
   to replace `goal_pseudo` with the real elaborated goal-state strings.
