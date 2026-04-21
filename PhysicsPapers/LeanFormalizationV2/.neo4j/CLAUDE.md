# Neo4j Ingest Pipeline — OmegaTheory V2

Full ground-truth pipeline for mirroring the Lean 4 environment into the `math`
Neo4j container. All scripts live in `~/lean-v2/.neo4j/` (native ext4 workdir).
Edits to `.lean` files on disk never touch the graph until the pipeline runs.

## Two ground-truth metaprograms (run from `~/lean-v2`)

### 1. `lake exe dump_declarations`
**Source:** `OmegaTheory/Meta/DumpDeclarations.lean` (Schedar, α Cassiopeiae).
Emits one JSONL record per Lean environment `ConstantInfo`:
```
lake exe dump_declarations --out .neo4j/declarations_from_env_v2.jsonl
```
Fields per record: `name`, `kind` (theorem/lemma/def/axiom/structure/instance),
`namespace`, `type` (fully elaborated), `value_body` (proof body for theorems /
def body for defs), `module`, `levelParams`, `source_span`, `isPropType`,
`isNoncomputable`.

Output: ~50–100 MB for the full OmegaTheory + Mathlib env.

### 2. `lake exe dump_arrows`
**Source:** `OmegaTheory/Meta/DumpArrows.lean` (Sheratan, β Arietis). Replaces
the 63 KB regex extractor at `.neo4j/extractors/lean_arrow_extractor.py`
(Mirfak showed it drops 46 % of fresh theorems).
```
lake exe dump_arrows --out .neo4j/arrows_from_env_cycle15.jsonl --include-mathlib
```
Emits 12 of 15 V3 arrows directly from `Lean.Environment` without re-inspecting
proofs (the env IS the ground truth — it already typechecked):

**Per-declaration (10):**
- `APPLIES` — constants in the value/body
- `ASSUMES` — subset whose `ConstantInfo` is `axiomInfo`
- `UNFOLDS` — constants in the type/signature
- `REDUCES_TO` — `defnInfo` head symbol of value
- `EXTENDS` — parent structures via `getStructureInfo?`
- `INSTANTIATES` — instance head type (class)
- `HAS_TYPE` — head of return type after `forallTelescope`
- `CONSTRAINED_BY` — heads of `instImplicit` binders
- `PARAMETRIZES` — level params + implicit binder heads
- `ELABORATES_AS` — abbrev/reducible fully-reduced head

**Per-module (2):**
- `IMPORTS` — from `env.header.moduleData[i].imports`
- `OPENS_NAMESPACE` — SKIPPED in v1 (requires Frontend pass)

Last known snapshot: `arrows_from_env_cycle15.jsonl` — 20,674 records,
3,481 module imports + 17,193 declaration arrow-rows. Mathlib included.

## Two ingest loaders (Python + Neo4j driver, not MCP)

### `load_declarations_env_v2.py` (Naos, ζ Puppis)
Delta-load `declarations_from_env_v2.jsonl` into Neo4j. MERGE on `(namespace, name)`.
Non-destructive: skips records whose `env_dumped_at` is newer than JSONL.
```
python3 load_declarations_env_v2.py
```

### `load_arrows_parallel.py` (SOTA — USE THIS)
**Parallelized batched loader — ~500× faster than sequential.**
16 worker threads × own Neo4j session × UNWIND batched MERGE. Uses label-hint
OPTIONAL MATCH pattern (`:Theorem`/`:Definition`/`:Axiom`/`:LeanFile`) so
Neo4j hits the `name` indexes instead of full-scanning 1M nodes.
```
python3 load_arrows_parallel.py path/to/arrows_from_env_cycleN.jsonl --workers 16 --batch 1000
```
**Measured: 10-17s for 192k edges (10,000-17,000 edges/s).**
Idempotent via apoc.merge.relationship. CLI flags:
- `--workers N` (default 16) — concurrent threads
- `--batch B` (default 2000) — edges per UNWIND call
- `--only-rel REL` — filter to one arrow type

**Prerequisite indexes (create once):**
```cypher
CREATE INDEX theorem_name_idx IF NOT EXISTS FOR (n:Theorem) ON (n.name);
CREATE INDEX definition_name_idx IF NOT EXISTS FOR (n:Definition) ON (n.name);
CREATE INDEX axiom_name_idx IF NOT EXISTS FOR (n:Axiom) ON (n.name);
CREATE INDEX leanfile_module_idx2 IF NOT EXISTS FOR (n:LeanFile) ON (n.module);
```

**IMPORTANT name format:** dump_arrows emits FULLY-QUALIFIED names like
`OmegaTheory.Predictions.FooFit.lemma_name`. Your ingest scripts must save
nodes with fully-qualified names (use `module + "." + short_name`), NOT bare
short names — otherwise the loader won't match them. A post-hoc rename fix:
```cypher
MATCH (t) WHERE t.namespace = 'OmegaTheoryV2' AND t.module IS NOT NULL
  AND NOT t.name STARTS WITH 'OmegaTheory.'
WITH t, t.module + '.' + t.name AS qualified
OPTIONAL MATCH (existing {namespace: 'OmegaTheoryV2', name: qualified})
WHERE existing IS NULL
SET t.name = qualified
RETURN count(t)
```

### `load_arrows_from_env_v2.py` (Rasalhague, α Ophiuchi — legacy sequential)
Single-threaded per-record MERGE. ~20-100 edges/s. Keep only for debugging
idempotency. Use `load_arrows_parallel.py` for production.

## Full pipeline (single cycle)

```
cd ~/lean-v2
~/.elan/bin/lake build --log-level=error          # must be GREEN
~/.elan/bin/lake exe dump_declarations --out .neo4j/declarations_from_env_v2.jsonl
~/.elan/bin/lake exe dump_arrows --out .neo4j/arrows_from_env_cycleN.jsonl --include-mathlib
cd .neo4j
python3 load_declarations_env_v2.py               # MERGE Theorem/Def/Axiom nodes
python3 load_arrows_from_env_v2.py                # APOC-batched arrow MERGE
python3 reembed_qwen3_delta.py                    # Qwen3-8B BF16 embeddings (GPU :7999)
```

## Embedding servers

- `http://localhost:7999/v1/embeddings` — Qwen3-Embedding-8B BF16 on GPU
  (dim 4096). Primary embedder.
- `http://localhost:7996/v1/embeddings` — Qwen3-Embedding-8B CPU backup.
- `http://localhost:7997/rerank` — Qwen3-Reranker-8B CPU.

## Historical delta files

- `arrows_from_env.jsonl` — Apr 19 initial Sheratan dump (no Mathlib)
- `arrows_from_env_v2.jsonl` — Rasalhague's post-fun-wave delta (Apr 20 00:41)
- `arrows_from_env_cycle{3..8}.jsonl` — per-cycle snapshots Apr 20
- `arrows_from_env_cycle15.jsonl` — current, Apr 20 16:01, Mathlib included

## Why this beats regex

The regex extractor (`extractors/lean_arrow_extractor.py`, Phobos-Iota) was
Mirfak-measured to drop 46 % of fresh theorems because Lean 4 macro/elab sugar
cannot be pattern-matched. `Lean.Environment` already has the typechecked
answer — one pass over `env.constants` is authoritative. Also: env-based
extraction picks up Mathlib cross-namespace arrows (`APPLIES→Mathlib`) for
free, because the elaborator resolves names at compile time. Regex-based
extractors require a separate Mathlib name-table lookup pass and miss
qualified vs unqualified resolutions.

## Common pitfalls

- `lake exe dump_arrows` requires a full successful `lake build` first —
  otherwise the env is stale and declarations are missing.
- Use `--include-mathlib` if you want cross-namespace APPLIES→Mathlib edges;
  without it, only `OmegaTheory.*` declarations are emitted.
- MCP Neo4j tools sometimes stall in auto mode — use Python driver via Bash
  when the main agent ingests. MCP works fine for read-only queries from
  sub-agents (see `~/.claude/projects/.../memory/feedback_mcp_vs_driver.md`).
- Build must stay GREEN (0 sorry, 8 physical axioms) at every cycle
  transition — the env-dumper is meaningless on a broken env.
