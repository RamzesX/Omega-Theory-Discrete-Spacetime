# T1.3 FULL — DumpProofSteps.lean LANDED 2026-05-01

## Status

**LIVE.** `lake exe dump_proof_steps` produces REAL elaborated goal-state
strings (`goal_before`, `goal_after`) for every tactic step in any OmegaTheory
or Mathlib `.lean` source file. Replaces the LITE Cypher migration's
`goal_pseudo` approximation.

OV2 full sweep started 2026-05-01 10:15 UTC (running, ~10-30 min ETA).
Mathlib top-200 driver ready (`dump_mathlib_top_referenced.py`); deferred to
overnight cron.

## Why FULL beats LITE

| Aspect | LITE (Cypher migration) | FULL (DumpProofSteps.lean) |
|---|---|---|
| `goal_before` | `<signature> [after: prev_tactics]` (string concat) | Real `Meta.ppGoal` output: `case h\n⊢ gen1 ≠ gen2` |
| `goal_after` | not captured | Real, including `"no goals"` when proof closes |
| Tactic prefix retrieval | works (substring match) | works + REAL state for kNN |
| Per-step kNN by goal-state | impossible (no real goal) | enabled (queryable proof corpus) |
| Position info | none | `line, col` of tactic syntax |
| Tactic kind | not captured | `Lean.Parser.Tactic.tacticHave__` etc. |
| Build cost | 1.6s (Cypher only) | ~10-30 min OV2 / +overnight Mathlib |

## Architecture

```
~/lean-v2/OmegaTheory/Meta/DumpProofSteps.lean    (350 lines, Algol β Persei)
  ├─ Lean.Elab.IO.processCommands                 ← re-elaborates source file
  ├─ commandState.infoState.enabled := true       ← captures InfoTrees
  ├─ InfoTree.visitM' walker                      ← per-tactic visitor
  ├─ ContextInfo.ppGoals                          ← REAL goal-state pp
  ├─ PrettyPrinter.ppTactic                       ← tactic syntax pp
  └─ namespace-qualified parent_thm               ← matches Neo4j Theorem.name

~/lean-v2/.neo4j/load_proof_steps.py              (loader, idempotent upsert)
  ├─ DETACH DELETE existing :ProofStep per (parent_thm, step_idx)
  ├─ CREATE :ProofStep with full_t1_3=true marker
  ├─ Auto-detect namespace (OmegaTheoryV2 vs Mathlib)
  └─ batched 200 records/tx

~/lean-v2/.neo4j/dump_mathlib_top_referenced.py   (Mathlib targeted driver)
  ├─ Query Neo4j for top-N most-cited Mathlib files by OV2 APPLIES
  ├─ Per-file `lake exe dump_proof_steps --file PATH`
  ├─ Per-file output + optional combined JSONL
  └─ Resume support via --start-at
```

## Smoke test (FCNCAbsence.lean, 160 tactic steps)

```
parent_thm: OmegaTheory.Predictions.fcnc_absence_e_mu
step 1: tactic = "apply neutral_current_off_diagonal_vanishes"
  goal_before: ⊢ neutral_current_amplitude gen1 gen2 = 0
  goal_after:  case h
               ⊢ gen1 ≠ gen2
step 2: tactic = "decide"
  goal_before: case h
               ⊢ gen1 ≠ gen2
  goal_after: no goals
```

**This is identical to what Lean shows in interactive mode** — no longer a
substring approximation.

## Per-step JSONL schema

```json
{
  "parent_thm":     "OmegaTheory.Predictions.fcnc_absence_e_mu",
  "step_idx":       1,
  "tactic":         "apply neutral_current_off_diagonal_vanishes",
  "tactic_kind":    "Lean.Parser.Tactic.applyTactic",
  "goal_before":    "\n⊢ neutral_current_amplitude gen1 gen2 = 0",
  "goal_after":     "\ncase h\n⊢ gen1 ≠ gen2",
  "n_goals_before": 1,
  "n_goals_after":  1,
  "file":           "/home/norbert/lean-v2/OmegaTheory/Predictions/FCNCAbsence.lean",
  "line":           42,
  "col":            2
}
```

## Mathlib coverage strategy

**Why Mathlib too?** OV2 cites 1,731 distinct Mathlib files via APPLIES
(192K Mathlib theorems indexed in graph). Top-200 most-cited Mathlib files
cover >80% of OV2's actual usage (top-15 each have 9-43 OV2-cited theorems).

```bash
# After OV2 sweep completes:
OMEGA_NEO4J_PASSWORD=... python3 ~/lean-v2/.neo4j/dump_mathlib_top_referenced.py \
  --top 200 \
  --out-dir /tmp/mathlib_proof_steps/ \
  --combined-out /home/norbert/lean-v2/.neo4j/data/proof_steps_mathlib_top200.jsonl
```

Estimated runtime: 200 files × ~30-60s each = 1.5-3h (Mathlib oleans
already cached, only elaboration cost). Recommend overnight cron.

Full Mathlib (~3000 files) is feasible but ~24h; usually unnecessary since
top-200 saturates retrieval value for OV2 use cases.

## Idempotency + namespace marker

LITE :ProofStep nodes have NO `full_t1_3` property (defaults to absent).
FULL :ProofStep nodes have `full_t1_3 = true`. The loader DETACH-DELETEs
matching (parent_thm, step_idx) tuples before CREATEing FULL nodes — so
re-running the loader is safe and an OV2 file's LITE+FULL records merge
cleanly with FULL winning.

Cypher to find LITE-only theorems (still need FULL upgrade):
```cypher
MATCH (t:Theorem {namespace: 'OmegaTheoryV2'})
WHERE NOT EXISTS {
  MATCH (t)-[:HAS_STEP]->(ps:ProofStep {full_t1_3: true})
}
AND EXISTS { MATCH (t)-[:HAS_STEP]->(:ProofStep) }
RETURN count(t) AS lite_only_theorems
```

## Files

- **Lean exe**: `~/lean-v2/OmegaTheory/Meta/DumpProofSteps.lean` (350 lines)
- **Loader**: `~/lean-v2/.neo4j/load_proof_steps.py`
- **Mathlib driver**: `~/lean-v2/.neo4j/dump_mathlib_top_referenced.py`
- **lakefile entry**: `[[lean_exe]] name = "dump_proof_steps"`
- **This memo**: `PhysicsPapers/SOTA/proving_techniques/00_dump_arrows_v2/T1_3_FULL_LANDED.md`
- **Supersedes**: `T1_3_LITE_LANDED.md` (LITE migration kept for history)

## Mirror

- `/mnt/c/.../LeanFormalizationV2/OmegaTheory/Meta/DumpProofSteps.lean`
- `/mnt/c/.../LeanFormalizationV2/.neo4j/load_proof_steps.py`
- `/mnt/c/.../LeanFormalizationV2/.neo4j/dump_mathlib_top_referenced.py`
- `/mnt/c/.../LeanFormalizationV2/lakefile.toml`

## Next-fire actions

1. Wait for OV2 sweep to complete (~10-30 min)
2. Load OV2 records via `load_proof_steps.py --in /home/norbert/lean-v2/.neo4j/data/proof_steps_ov2.jsonl`
3. Schedule Mathlib top-200 dump as overnight cron (1.5-3h)
4. Embed `goal_before` strings via Qwen3 `[goal]` prefix → vector index
   `proof_step_goal_embedding` (after `embedding_goal` Theorem backfill frees embedder)
5. `goal_to_proof_step(goal_str, prefix?, k=10)` MCP tool returns top-K
   :ProofStep nodes by kNN over real goal-state embeddings — enables
   "given my current goal, what tactic do practitioners use?" retrieval.
