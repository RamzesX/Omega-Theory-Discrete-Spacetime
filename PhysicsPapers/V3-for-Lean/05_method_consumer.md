# 05 — Method: Consumer Layer (Erdős-Tier `SubsystemNavigator` Enrichment)

The consumer layer sits between the algebraic schema ($\S 3$) and the
dense embeddings ($\S 4$) on one side, and the benchmark harness ($\S 6$)
on the other. Its job is to turn the raw Leiden output into a set of
*named, retrievable* subsystems that a downstream prover or a human
reviewer can reason about. We call this **Erdős-tier enrichment** because
the naming and ranking protocol follows the "Erdős number" convention:
every subsystem is named after its central theorem, and its importance
is measured by its graph-distance to the axiom layer.

## 5.1 Why a consumer layer?

A Leiden community id ($116$ integers on our corpus) is not a useful
retrieval target — it carries no semantic meaning for a human or for an
LLM-prover. The consumer layer translates `navi_community = 42` into a
node of type `:SubsystemNavigator` with fields

| field | type | meaning |
|---|---|---|
| `subsystem_id` | int | Leiden community id |
| `name` | string | chosen centroid-theorem name (e.g. `einstein_tensor_emergence`) |
| `size` | int | number of theorems in the community |
| `centroid_theorem` | node ref | most-central theorem by betweenness |
| `ai_description` | string | LLM-generated human summary ($\leq 80$ words) |
| `depth_from_axiom` | int | minimum hop-count to any `:Axiom` |
| `modularity_contrib` | float | this community's contribution to global $Q$ |
| `dominant_arrow` | string | arrow type with highest within-community density |
| `boundary_edges` | int | APPLIES edges crossing the community boundary |
| `paper_worthy` | bool | see $\S 5.5$ |

These nodes are materialised in Neo4j via the `subsystem_hub_shannon_entropy_v1.cypher`
recipe (`V3-for-Lean/code/cypher_recipes/`).

## 5.2 Enrichment procedure

The enrichment runs in six steps.

**S1. Leiden.** $\gamma = 0.5$, seed $42$, $5$ levels. Output: cluster id
per theorem (property `navi_community`).

**S2. Filter.** Keep communities with $|C| \geq 50$ nodes (top $\approx 40$).
Smaller communities are tagged `minor` and not promoted to
`:SubsystemNavigator`.

**S3. Centroid.** For each kept community, compute the FastRP centroid:

$$
\widehat{c}_k \;=\; \frac{1}{|C_k|}\sum_{t \in C_k} v_t^{\text{FastRP}}
$$

and the theorem $t^\star_k \in C_k$ minimising $\|v_{t^\star_k} - \widehat{c}_k\|_2$.
This is the centroid theorem — the "spokesperson" for the community.

**S4. Betweenness.** Run `gds.betweenness.stream` restricted to the
within-community induced subgraph, pick the top-$1$ node. In most
communities this coincides with the centroid from S3; when they differ
we report both (centroid is semantic, betweenness is structural). The
`centroid_theorem` field is filled with the S3 result; an auxiliary
`structural_centroid` field records the S4 result.

**S5. Shannon-entropy audit.** For each community compute

$$
H(C_k) \;=\; -\sum_{a \in \text{arrows}} p_a \log p_a, \qquad p_a = \frac{\#\text{edges of type } a \text{ inside } C_k}{\#\text{edges inside } C_k}
$$

Communities with $H < 1.5$ are *single-arrow-dominated* (e.g. a
`REWRITES_BY` island) and are candidates for refactor. Communities
with $H > 3.5$ carry all fifteen arrow types roughly evenly and are
the theory's "universal connectors".

**S6. LLM description.** For each community, feed
`{centroid_theorem.signature, 5 random members' names, dominant_arrow}`
to an LLM with a 80-word summary prompt. Result populates
`ai_description`. The prompt + a worked example is in
`V3-for-Lean/code/cypher_recipes/README.md`.

## 5.3 Current enrichment state (cycle 43)

From the Leiden output reported in $\S 3.8$:

| Rank | community_id | size | centroid theorem (abridged) | depth_from_axiom |
|---|---|---|---|---|
| 1 | $18$ | $1648$ / $900^\dagger$ | `grand_qm_emergence` | $6$ |
| 2 | $22$ | $1362$ / $983$ | `einstein_tensor_emergence` | $5$ |
| 3 | $96$ | $1034$ / $859$ | `darkEnergyEquationOfState_w` | $4$ |
| 4 | $47$ | $843$ | `higgsFieldIsComputationalUncertainty` | $3$ |
| 5 | $34$ | $775$ / $339$ | `redshift_as_information_cost` | $4$ |
| 6 | $4$ | $678$ / $512$ | `substrate_extends_heisenberg` | $2$ |
| 7 | $64$ | $614$ / $279$ | `grav_decoherence_T_scaling` | $5$ |
| 8 | $30$ | $506$ / $294$ | `perTickDelay_high_momentum_bound` | $3$ |
| 9 | $62$ | $371$ / $258$ | `pathIntegral_interference` | $4$ |
| 10 | *** | *** | (remaining through rank 14) | |

$\dagger$ Two size columns reflect the two Leiden variants run:
$11{,}921$-node full projection vs the namespace-restricted projection.

These nodes are queryable via the graph:

```cypher
MATCH (sub:SubsystemNavigator {namespace:'OmegaTheoryV2'})
RETURN sub.subsystem_id, sub.name, sub.size,
       sub.centroid_theorem, sub.depth_from_axiom
ORDER BY sub.size DESC LIMIT 20
```

## 5.4 The $\approx 14$-macro-subsystem claim

$\S 3.8$ reported that the Leiden community-size distribution has its
dominant gap at rank $14$ (ratio $1.48$). This defines the boundary
between *macro-subsystems* (size $\geq$ threshold) and
*specialised islands* (size below). We therefore promote the top-$14$
communities to `:MacroSubsystem` nodes and use them as the primary
retrieval target.

The $14$ macro-subsystems decompose, to a first approximation, as

1. Quantum mechanics (Schrödinger, von Neumann, CHSH)
2. General relativity (Einstein, Weyl, Poincaré)
3. Dark energy (reservoir, $w = -1$, cosmological constant)
4. Higgs + mass spectrum
5. Redshift + information-cost bridge
6. Substrate / Heisenberg extension
7. Decoherence / gate fidelity predictions
8. Per-tick delay / dispersion
9. Path integral / interference
10. Hodge / Maxwell / gauge
11. Lattice / spacetime primitives
12. Irrationality / $\delta_{\text{comp}}$ / Pi Hunch
13. HealingFlow / Lyapunov / convergence
14. Torsion / Big Bounce / Popławski

This decomposition is not hard-coded — it emerges from Leiden on the
post-capstone corpus. The decomposition is *stable* across seeds (Jaccard
$\geq 0.87$ between runs with five different seeds).

## 5.5 The `paper_worthy` flag

Forty-four `:GraphFinding` nodes across the cycle-$24$ to cycle-$43$
sweep have been tagged `paper_worthy=true` by the various research
agents (`Graph-mapper-scout`, `Graph-mapper-researcher`, `Pollux`,
`Navi`, etc.). A `:SubsystemNavigator` inherits the flag if its
centroid theorem or any of its top-$5$ betweenness nodes has at least
one `paper_worthy` GraphFinding pointing into it. This gives a fast
triage: when the human reviewer asks "which subsystems should the
paper show?", the flag returns the answer in a single Cypher round
trip.

On the current snapshot, the `paper_worthy` flag fires on: QM,
Einstein, dark-energy, Higgs, redshift-info-cost, substrate-Heisenberg,
decoherence-predictions, per-tick delay, path integral, and
irrationality. Ten of fourteen macro-subsystems — consistent with the
paper's "one figure per subsystem" ambition for $\S 7$ (the
`einstein_tensor_emergence` canary is itself a paper-worthy target).

## 5.6 Bridge-prediction consumption

The twelve FastRP-predicted bridges from Navi's MP-6 pass are
consumed by the enrichment via two Neo4j properties:

- `bridge_candidate_to`: a list of `(community_id, score)` pairs for
  bridges *to* other subsystems.
- `bridge_candidate_from`: the inverse.

Both are populated by the Cypher recipe

```cypher
MATCH (ci:SubsystemNavigator), (cj:SubsystemNavigator)
WHERE ci.subsystem_id < cj.subsystem_id
WITH ci, cj, gds.similarity.cosine(ci.centroid, cj.centroid) AS sem
WHERE sem > 0.85
OPTIONAL MATCH (a:Theorem {navi_community: ci.subsystem_id})-[:APPLIES]-(b:Theorem {navi_community: cj.subsystem_id})
WITH ci, cj, sem, count(*) AS lnk
WHERE lnk < 3
SET ci.bridge_candidate_to = coalesce(ci.bridge_candidate_to, []) + [{id: cj.subsystem_id, score: sem}],
    cj.bridge_candidate_from = coalesce(cj.bridge_candidate_from, []) + [{id: ci.subsystem_id, score: sem}]
```

with $\mathrm{sem} > 0.85$ and $\mathrm{lnk} < 3$ as the MP-6 gate.

## 5.7 Summary

The consumer layer turns $116$ Leiden community ids into $14$
macro-subsystems plus $\sim 25$ minor islands, each with a centroid
theorem, LLM summary, depth from axiom, arrow-entropy profile, and
paper-worthy flag. It is the layer that a downstream prover — or a
human writing a review — actually queries. The algebraic schema and
the dense embeddings provide the *primitives*; the consumer layer
provides the *targets*.
