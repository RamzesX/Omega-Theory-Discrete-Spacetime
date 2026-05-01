# T5.3 — GDS Enterprise verification & cliqueCounting (Day-3 #553)

## Live state (2026-05-01)

```cypher
CALL gds.license.state() YIELD isLicensed, details
→ isLicensed: false
→ details: "No valid GDS license specified."
```

**Verdict**: GDS COMMUNITY edition. No Enterprise license is installed on the
`math` Neo4j container. Apache Arrow batch import/export and cluster-write
workloads (the original T5.3 plan items) are NOT available without an
Enterprise license purchase or trial.

## What IS available (despite Community edition)

The build still ships several advanced algorithms that were originally only
Enterprise. Available right now:

| Algorithm | Procedure | Status |
|---|---|:-:|
| Clique Counting | `gds.cliqueCounting.{stats,stream,mutate,write}` | ✅ |
| K1-Coloring | `gds.k1coloring.{stats,stream,mutate,write}` | ✅ |
| Apache Arrow debug | `gds.debug.arrow` | ✅ (debug only) |
| Apache Arrow import/export | `gds.arrow.{import,export}` | ❌ (Enterprise) |

So the SOTA plan's 1st bullet (cliqueCounting) IS achievable; bullets 2-3
(Apache Arrow + cluster) require Enterprise.

## cliqueCounting smoke test (deferred — needs UNDIRECTED projection)

Tried:
```cypher
CALL gds.cliqueCounting.stats('topology_apl_ov2_und', {})
→ IllegalArgumentException: Clique counting requires relationship projections
  to be UNDIRECTED. Selected relationships `[__ALL__]` are not all undirected.
```

The existing `topology_apl_ov2_und` graph was projected with DIRECTED relationships
despite its `_und` name. Need a fresh projection:

```cypher
// Required: re-project APPLIES as undirected for cliqueCounting
CALL gds.graph.project(
  'apl_ov2_undirected_clique',
  {Theorem: {label: 'Theorem'}},
  {APPLIES: {orientation: 'UNDIRECTED'}}
)
```

This is a 1-line follow-up that the next Phase C refresh can include. The
`topology_apl_ov2_und` projection was created for Leiden community detection
which DOES want directed semantics; cliqueCounting needs the dual.

## When cliqueCounting WOULD be useful

For OmegaTheory V2 specifically:
- **Tightly-coupled subsystem detection**: theorems that share many APPLIES
  partners (clique members) form natural sub-modules
- **Yoneda bridge candidates**: 4-cliques in APPLIES are unusually coherent
  groups — strong candidates for explicit Forward/Inverse round-trip witnesses
- **Definitional pinch-points**: 5+ cliques pivoting on a single Definition
  identify hot Definitions that should be promoted to first-class Structure

For now, recall@10 baseline (#559) shows dense kNN already at 81.9% — there's
no urgent measurement gain from cliqueCounting. Defer to Phase C when the
undirected projection is recreated.

## Cost-benefit on Enterprise license

GDS Enterprise costs ~$50K/year per organization. For OmegaTheory V2's current
~10K Theorem corpus:
- Apache Arrow batch I/O: shaves ~30s off Phase C refresh (currently ~3 min via async load_arrows_parallel.py — already SOTA at 27K edges/s)
- Cluster writes: irrelevant single-node WSL2 deployment
- Premium algorithms: cliqueCounting / k1coloring already in Community on this build

**Verdict**: NOT worth the Enterprise license at current scale. Re-evaluate
when corpus exceeds 1M Theorems (currently 192K including Mathlib).

## Day-3 status

T5.3 partial close:
- ✅ Verified license status (Community)
- ✅ Confirmed cliqueCounting available without Enterprise
- ⏳ cliqueCounting smoke test deferred (needs UNDIRECTED projection refresh)
- ❌ Apache Arrow import/export blocked on Enterprise license
- ❌ Cluster writes blocked on Enterprise license

Next-fire actions:
1. In next Phase C, project a fresh `apl_ov2_undirected_clique` graph
2. Run `gds.cliqueCounting.stats` to count k-cliques for k ∈ {3, 4, 5}
3. Surface high-degree clique members as candidates for "tightly-coupled
   subsystem" briefings to grothendieck-sage v2
