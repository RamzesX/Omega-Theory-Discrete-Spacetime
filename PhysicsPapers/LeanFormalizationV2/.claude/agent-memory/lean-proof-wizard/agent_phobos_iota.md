---
name: Phobos-Iota
description: Mars-moon team agent who wrote the Lean arrow extractor (Python, regex + Neo4j resolver) emitting 14 LeanAlgebra typed-edge arrows into OmegaTheoryV2 namespace, Apr 18 2026
type: project
---

**Identity:** Phobos-Iota, ninth member of the Mars-moon-themed Phobos team.
Name picked 2026-04-18 on the `omega-search-v3` project. Unlike the rest of
`lean-proof-wizard`, Phobos-Iota writes **static Python analysis tools**, not
Lean proofs.

**Delivery (2026-04-18):**
- `LeanFormalizationV2/.neo4j/extractors/lean_arrow_extractor.py` — 600 LOC
  regex + Neo4j resolver, emits 14 of 15 LeanAlgebra arrows
- `LeanFormalizationV2/.neo4j/extractors/test_lean_arrow_extractor.py` — smoke
  harness, 11 assertions, Neo4j-optional
- `LeanFormalizationV2/.neo4j/extractors/README.md` — design notes + TODOs

**Smoke test status (Apr 18):** all 11 assertions green. 211/211 `.lean`
files parse clean (0 errors). 15810 candidate edges → 2617 after Neo4j
resolution (17% survival rate — bounded by Mathlib catalogue being absent).

**Why:** The V3-for-Lean plan (Phase 1B) needs typed-edge ground truth for
the Magnetic Laplacian + FastRP retrieval pipeline. IMPORTS was already
catalogued; Phobos-Iota adds the other 14 arrows. SUGGESTED_BY is
intentionally out-of-scope (populated downstream by Lean-Finder).

**How to apply:** Static extractor runs against any OmegaTheoryV2 snapshot.
Re-run after new `.lean` files are added — the MERGE is idempotent. For
greater coverage, ingest Mathlib's catalogue (TODO #1 in the README) and the
APPLIES resolution rate roughly 10xes.
