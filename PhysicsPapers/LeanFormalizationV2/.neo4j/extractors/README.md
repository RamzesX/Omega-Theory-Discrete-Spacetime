# Lean arrow extractor

**Team:**   Phobos (Mars-moon)
**Agent:**  Phobos-Iota
**Date:**   2026-04-18
**Plan:**   `~/.claude/plans/elegant-sauteeing-simon.md` (Phase 1B)
**Schema:** `.neo4j/lean_algebra_arrows.cypher` (15 QuiverArrow generators)

Static parser that walks `OmegaTheory/**/*.lean`, (a) MERGEs Neo4j nodes
for the 3 vertex types missing from the legacy catalogue (Structure,
Instance, Namespace) plus a LeanFile backfill, then (b) emits 14 of the
15 LeanAlgebra typed-arrow edges from surface syntax against the live
`math` Neo4j container (`OmegaTheoryV2` namespace).

## Arrows in scope

| Category      | Arrow              | Status | How we derive it |
|---------------|--------------------|--------|------------------|
| Structural    | IMPORTS            | done by `catalogue_scan.py` | — |
| Structural    | OPENS_NAMESPACE    | regex  | `^open …` per current `namespace` |
| Structural    | EXTENDS            | regex  | `(structure|class) X extends Y, Z where` |
| Structural    | INSTANTIATES       | regex  | `instance … : Klass T …` |
| Dependency    | ASSUMES            | regex+resolver | any Theorem→Axiom reference (auto-promoted from APPLIES) |
| Dependency    | APPLIES            | regex  | `exact/apply/refine X`, term-mode head ident |
| Dependency    | UNFOLDS            | regex+resolver | `unfold X`, auto-promoted from APPLIES when target is a Definition |
| Dependency    | SPECIALIZES        | regex  | `specialize X` |
| Dependency    | REWRITES_BY        | regex  | `rw [X]`, `simp only [X]` |
| Type-theoretic| HAS_TYPE           | regex  | `def foo : Ty := …` |
| Type-theoretic| CONSTRAINED_BY     | regex  | `[Klass α]` binders |
| Type-theoretic| PARAMETRIZES       | regex  | explicit `(x : Ty)` args |
| Computational | REDUCES_TO         | hook   | not yet emitted — needs `rfl`-body analysis; TODO |
| Computational | ELABORATES_AS      | regex  | `abbrev X := Y` head ident |
| Computational | SUGGESTED_BY       | out of scope | populated downstream by the retrieval pipeline |

Everything except IMPORTS and SUGGESTED_BY is produced by the extractor.
`REDUCES_TO` has zero emissions — the `rfl`-body detection hook is in place
but deliberately does nothing until the LSP-driven pass lands.

## Resolution strategy

Two-pass:

1. **Extract candidates per file** — regex on stripped Lean source (nested
   `/-…-/` and `-- …` comments removed line-for-line). Each candidate
   carries `(arrow_type, source_name, target_name, source_file, line_number,
   snippet)`.
2. **Filter against Neo4j declaration index** — a single
   `MATCH (n) WHERE n.namespace = 'OmegaTheoryV2'` pull loads every Axiom,
   Theorem, Definition, Structure, Instance, LeanFile and Namespace into a
   `{identifier: label}` dict (keyed on `.name` for short identifiers,
   `.path` for LeanFile, `.dotted_name` for Namespace). A candidate is
   emitted iff both endpoints resolve. Target-label-driven promotions:
   * `APPLIES → Axiom`     becomes  `ASSUMES`
   * `APPLIES → Definition` becomes  `UNFOLDS`
   * `APPLIES → Structure`  becomes  `CONSTRAINED_BY`

Unresolved identifiers (Mathlib lemmas, stdlib, synthetic tactic names
like `add_comm` when you haven't ingested Mathlib's catalogue yet) are
dropped silently.

## Usage

```bash
# Activate the Python env once per session
source ~/genai_env/bin/activate

# Dry run on everything: prints per-type candidate counts + post-resolution counts
python .neo4j/extractors/lean_arrow_extractor.py --dry-run

# Dry run on a subset of files (relative or absolute paths accepted)
python .neo4j/extractors/lean_arrow_extractor.py --dry-run \
    --files OmegaTheory/Spacetime/Constants.lean \
            OmegaTheory/Emergence/EinsteinEmergence.lean

# Write to Neo4j (MERGE fresh + idempotent)
python .neo4j/extractors/lean_arrow_extractor.py --write

# Nuke extractor-emitted edges + consolidate legacy :Definition / extractor
# :Structure duplicates + re-write fresh.  Use after resolver-priority or
# label-routing changes.
python .neo4j/extractors/lean_arrow_extractor.py --rewire

# Read current Neo4j edge counts
python .neo4j/extractors/lean_arrow_extractor.py --stats

# Smoke test (no Neo4j needed)
python .neo4j/extractors/test_lean_arrow_extractor.py --verbose
```

## Node-emission pass (since Apr-18 2026 label extension)

Before edges are MERGEd the extractor emits **nodes** for the vertex types
missing from the legacy catalogue. This is what made Dubhe's 6x6 Magnetic
Laplacian measurement have non-zero Structure/Instance/Namespace blocks.

What gets MERGEd on every `--write`:
- **LeanFile backfill** — every `.lean` file we see, even if the legacy
  `catalogue_*.cypher` pipeline skipped it. Closes the gap from 59 to 211.
- **Structure** — every `structure`, `class`, `inductive` declaration
  (collapse per `01_entity_types.md` §2.3). `declaration_type` property
  records which one of the three kinds it was.
- **Instance** — every `instance` declaration. Anonymous instances get
  `_anon_instance_<file_offset>` as a stable synthetic name.
- **Namespace** — distinct dotted-namespace strings found in `namespace …`
  statements. Additionally any LeanFile whose path matches the namespace's
  conventional `.lean` path (`OmegaTheory.X.Y` ↔ `OmegaTheory/X/Y.lean`)
  gets dual-labelled `:LeanFile:Namespace`.

Constraints auto-created on first `--write`:
- `(Structure.namespace, Structure.name)` UNIQUE
- `(Instance.namespace, Instance.name)` UNIQUE
- `(Namespace.namespace, Namespace.dotted_name)` UNIQUE

## Current numbers (211 `.lean` files, Apr-18 2026, post-label-extension)

| Arrow          | Candidates | Emitted |
|----------------|-----------:|--------:|
| OPENS_NAMESPACE|        546 |      42 |
| EXTENDS        |         14 |       9 |
| INSTANTIATES   |         26 |       4 |
| APPLIES        |       3993 |     172 |
| UNFOLDS        |       3582 |     677 |
| REWRITES_BY    |       3813 |     556 |
| HAS_TYPE       |        665 |     222 |
| CONSTRAINED_BY |        137 |       5 |
| PARAMETRIZES   |       2974 |    1005 |
| ELABORATES_AS  |         60 |      23 |
| ASSUMES        |      (auto) |     24 |
| SPECIALIZES    |          0 |       0 |
| REDUCES_TO     |          0 |       0 |
| **Total**      |     15810 |    2739 |

Neo4j node population after a full write:
- Axiom: 9, Theorem: 800, Definition: 401
- Structure: 146, Instance: 26 (extractor-created)
- Namespace: 86 standalone + 35 LeanFile-dual-labelled = 121 total :Namespace
- LeanFile: 211 (extractor backfills 152 the legacy catalogue skipped)

**Coverage:** 211 / 211 files parsed, 0 errors. 1611 declaration names
indexed (up from 1268 pre-extension) across 7 resolvable label kinds.

**Why resolution rate is ~17%:** most `APPLIES` / `REWRITES_BY` /
`CONSTRAINED_BY` candidates target Mathlib lemmas (`add_comm`, `div_pos`,
`Real.sqrt_pos_of_pos`, …). Neo4j currently only holds OmegaTheoryV2
declarations. When the Path-B Mathlib ingestion lands, these counts should
roughly 10x.

**Why OPENS_NAMESPACE jumped 0 → 42:** the extractor backfills LeanFile
nodes for every `.lean` file it sees, AND dual-labels 35 of them :Namespace.
`open OmegaTheory.Irrationality.HermitePade` can now resolve because that
path is a real file. Container-only namespaces that don't correspond to a
single `.lean` file (`open OmegaTheory.Spacetime` → `OmegaTheory/Spacetime.lean`
doesn't exist) are still dropped — 546 - 42 of them.

**Auto-promotion rule** (unchanged): a candidate `APPLIES` edge becomes
`ASSUMES` if the target resolves to an Axiom, `UNFOLDS` if to a Definition,
`CONSTRAINED_BY` if to a Structure. This is why CONSTRAINED_BY has 137
*candidates* but only 5 emissions — most `[Fintype α]`-style binders cite
Mathlib typeclasses.

## Design notes

* Each `(src_label, tgt_label, arrow_type)` bucket gets its own Cypher
  MERGE because Cypher relationship labels and node labels must be
  literal in the query. One transaction per `BATCH_SIZE=100` rows.
* `MERGE` idempotency: repeat runs don't duplicate edges. `ON CREATE
  SET` seeds `source_file`, `line_number`, `snippet`, `arrow_type`,
  `arrow_namespace='LeanAlgebra'`, `created_at=datetime()`. `ON MATCH SET`
  refreshes `arrow_type`/`arrow_namespace` but preserves the earliest
  `source_file`/`line_number` via `coalesce` to avoid clobbering provenance.
* No Lean build required. No `.lean` edits. No dependency on the Lean
  LSP. This is strictly static analysis.

## Known blockers & TODOs

1. **Mathlib catalogue missing** — `APPLIES`/`REWRITES_BY`/`CONSTRAINED_BY`
   drop 90%+ of candidates because Mathlib identifiers aren't in the DB.
   Fix: Path-B ingestion (in progress by Dubhe / Merak) will load Mathlib
   declarations into `namespace: 'Mathlib'`. Then extend
   `fetch_declaration_index` to union OmegaTheoryV2 + Mathlib.
2. **OPENS_NAMESPACE container-namespaces** — `open OmegaTheory.Spacetime`
   still drops because `OmegaTheory/Spacetime.lean` doesn't exist (it's a
   directory). ~42 of 546 candidates resolve after Apr-18 dual-labelling;
   the rest are container-only. Further fix: upgrade standalone Namespace
   nodes so `OmegaTheory.Spacetime` has a target to resolve to even when no
   single `.lean` file represents it.
3. **REDUCES_TO** — the body-is-`rfl` check is a stub. Proper support
   needs a mini-type-checker or LSP hook (`lean_declaration_file` +
   `lean_hover_info`) to confirm that the `rfl` is structural, not
   tactic-mode. Flagged in `_extract_theorem_edges`.
4. **SPECIALIZES** — hard without Lean's elaborator. Currently only
   catches `specialize X` tactic; structural specialization (e.g.
   `foo.symm`) and type-level specialization (`@foo` at fixed args) are
   out of scope for regex.
5. **Instance names are synthetic when anonymous** — `instance : CommGroup ℤ`
   gets `_anon_instance_<offset>` as its name. These DO now resolve against
   Neo4j because the extractor emits an Instance node with that synthetic
   name. Alternative would be to emit them under the class name (e.g.
   `CommGroup_Int`) but that risks collisions when multiple anonymous
   instances share a class. Kept synthetic for idempotency.
6. **Anonymous theorems / `example`** — `example : 1 = 1 := rfl` is
   skipped because it has no name. OK for now (`example` isn't a
   persisted declaration).

## File layout

```
.neo4j/extractors/
├── README.md                        <- this file
├── lean_arrow_extractor.py          <- ~600 LOC, main entry point
└── test_lean_arrow_extractor.py     <- smoke test, no Neo4j needed
```

## Provenance

All emitted edges carry:
* `source_file` — repo-relative `.lean` path where the edge originates
* `line_number` — 1-indexed line of the source declaration
* `snippet` — ≤200-char quote of the surface syntax that produced the edge
* `arrow_type` — the final arrow name (post-promotion)
* `arrow_namespace` — `'LeanAlgebra'`
* `created_at` — `datetime()` on insert

Downstream queries can filter with `r.arrow_namespace = 'LeanAlgebra'` to
isolate extractor-emitted edges from hand-authored or legacy ones.
