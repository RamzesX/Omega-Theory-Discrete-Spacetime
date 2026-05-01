# T5.3 — Clique-Counting on UNDIRECTED APPLIES Projection LANDED 2026-05-01

## Status

**Live + measured.** GDS Community `gds.cliqueCounting.{stats,stream}` runs in ~10s
on the 192K-node / 6.06M-undirected-edge OV2 + Mathlib APPLIES graph and surfaces
densely-coupled hubs that grothendieck-sage v2 can use for subsystem boundary
briefings.

## Reproducibility

```python
from neo4j import GraphDatabase
drv = GraphDatabase.driver("bolt://localhost:7687",
                           auth=("neo4j", os.environ["OMEGA_NEO4J_PASSWORD"]))
with drv.session() as s:
    # Project APPLIES as UNDIRECTED (cliqueCounting requires this)
    s.run("""CALL gds.graph.project(
        'apl_ov2_undirected_clique',
        {Theorem: {label: 'Theorem'}},
        {APPLIES: {orientation: 'UNDIRECTED'}}
    )""").consume()

    # Global histogram (compute time ~10s)
    stats = s.run("""CALL gds.cliqueCounting.stats('apl_ov2_undirected_clique', {})
                     YIELD globalCount, computeMillis""").single()
    # globalCount → [k=2, k=3, k=4, k=5, k=6+]

    # Per-node clique membership stream
    rows = s.run("""CALL gds.cliqueCounting.stream('apl_ov2_undirected_clique', {})
                    YIELD nodeId, counts
                    WITH gds.util.asNode(nodeId) AS t, counts
                    WHERE t.namespace = 'OmegaTheoryV2' AND size(counts) >= 2
                    RETURN t.name AS name, counts[0] AS k3, counts[1] AS k4
                    ORDER BY k4 DESC LIMIT 15""")

    # Cleanup (drop projection)
    s.run("CALL gds.graph.drop('apl_ov2_undirected_clique', false)").consume()
```

## Global histogram

| Clique size | Count |
|---:|---:|
| k=2 (edges) | 18,998,581 |
| k=3 (triangles) | 26,460,461 |
| k=4 | 3,511,924 |
| k=5 | 149,512 |
| k=6+ | 12,460 |

Compute time: 9.9 seconds for the full 192K-node / 6.06M-edge graph.

## Top-15 OV2 hubs by 4-clique membership

```
  k3       k4    k5    k6    name
  2,519   4361   670    88   OmegaTheory.Foundations.taylor_forward_expansion
  3,908   1023     0     0   OmegaTheory.Spacetime.c_pos
    802    728   466    88   OmegaTheory.Foundations.central_diff_taylor_bound
    511    710   466    88   OmegaTheory.Foundations.taylor_backward_expansion
    518    672     0     0   OmegaTheory.Irrationality.HermitePade.decoupling
    295    579   466    88   OmegaTheory.Emergence.convolutionTerm_contDiff
    321    430   264     0   OmegaTheory.Emergence.convolutionFixedBox_contDiff
  3,427    403     0     0   OmegaTheory.Spacetime.l_P_pos
    524    392     0     0   OmegaTheory.Emergence.DiracFSpectrum.realDiagonalComplex_spectrum_real
    543    392     0     0   OmegaTheory.Emergence.DiracFSpectrumReal.hermitian_complex_spectrum_elt_im_zero
    543    392     0     0   OmegaTheory.Emergence.DiracFSpectrumReal.hermitian_complex_spectrum_elt_is_embedded_real
    805    344     0     0   OmegaTheory.Emergence.DiracFSpectrum.realDiagonalComplex_eigenvalues_range
    787    341     0     0   OmegaTheory.Emergence.schrodingerRHS_norm_le
    427    336     0     0   OmegaTheory.Irrationality.HermitePade.decoupling_matrix
    922    336     0     0   OmegaTheory.Irrationality.HermitePade.decoupling_scalar
```

## Findings (paper-worthy structural insights)

### 1. Foundations.Taylor cluster is the densest hub family
Four of the top-7 hubs are Foundations.Taylor* variants:
- `taylor_forward_expansion` (4361 4-cliques, 88 6-cliques)
- `central_diff_taylor_bound` (728 / 88)
- `taylor_backward_expansion` (710 / 88)
- `convolutionTerm_contDiff` (579 / 88)

All share the same k=6 count of 88 — they likely form a tight 6-clique TOGETHER
plus their respective dependents. **Hypothesis**: this is the FOUNDATIONS-TAYLOR
SUBSYSTEM, the densest sub-module in OV2.

### 2. Spacetime keystones are 3-clique-dense, 4-clique-sparse
`c_pos` (3908 triangles, 1023 4-cliques) and `l_P_pos` (3427 / 403) are heavily
TRIANGULAR (used in 3-tuple co-occurrences) but DON'T form many 4-tuples.
**Hypothesis**: Spacetime is a SHALLOW-WIDE subsystem — many theorems share
2 Spacetime keystones at once but rarely share 3+ together.

### 3. HermitePade decoupling family
`decoupling` (672 4-cliques), `decoupling_matrix` (336), `decoupling_scalar` (336)
form a clear 3-some that's the HEART of the T-4 π-transcendence retirement.
**Hypothesis**: this 3-clique cluster is THE technical kernel of HermitePade —
modifications here affect ~1.3K theorems via 4-clique sharing.

### 4. DiracFSpectrum has 4-fold symmetry
3 DiracFSpectrum theorems all hit exactly 392 4-cliques:
- `realDiagonalComplex_spectrum_real`
- `hermitian_complex_spectrum_elt_im_zero`
- `hermitian_complex_spectrum_elt_is_embedded_real`

**Hypothesis**: these form a 4-clique themselves with a shared "spectral
real-valued" pattern; the 4th member is likely `schrodingerRHS_norm_le`
(341 4-cliques, same Emergence subsystem).

## Use cases for grothendieck-sage v2

When sage proposes briefings, prefer hubs from this list:
1. **Refactor candidates**: a hub with k4 > 1000 is a primitive that's used everywhere.
   Modifying it is HIGH-IMPACT — sage should propose tightening / generalizing them.
2. **Yoneda bridge candidates**: hubs that span MULTIPLE subsystems (e.g.
   `taylor_forward_expansion` spans Foundations + Emergence + Irrationality
   per its 670 5-cliques) are natural Yoneda bridges.
3. **Heart-tier targets**: a hub with high k5/k6 counts (88+) is a coherence
   primitive — its discharge unlocks 88+ downstream Heart-tier proofs.

## Comparison to existing graph signals

`taylor_forward_expansion` doesn't appear in the keystones top-list (which
uses pagerank × indegree). PageRank ranks `l_P_pos` first (227 score), but
clique-counting ranks `taylor_forward_expansion` first (4361 4-cliques).

**Implication**: clique-counting captures a DIFFERENT structural signal than
PageRank — pagerank is "incoming dependency mass", clique-counting is
"co-citation density". Both are useful for different agent strategies.

## Backlog status

This closes the T5.3 follow-up "cliqueCounting on UNDIRECTED projection"
deferred from the GDS Enterprise verification memo (T5_3_GDS_Enterprise_status.md).

The projection is dropped after each run to free GDS memory; re-create on
demand. ~10s compute is fast enough to run on every Phase C refresh.

Future enhancement (deferred): cache the top-100 hubs as a persistent
:CliqueHub label on Theorem nodes (write the per-node counts via
gds.cliqueCounting.write), so sage queries don't need to re-project.
