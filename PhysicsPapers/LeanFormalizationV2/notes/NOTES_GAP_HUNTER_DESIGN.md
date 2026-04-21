# Theorem Gap Hunter — Design Memo

**Author**: scout `gap-hunter-scout` (team member of OmegaTheory V2)
**Date**: 2026-04-19
**Status**: pre-implementation design (survived cycle-43 reorg, agent still not built)
**Purpose**: design spec for a long-lived teammate agent `theorem-gap-hunter`
**Graph state referenced**: OmegaTheoryV2 = 1,900 theorems / 8 axioms / 162 files / 281 Leiden subsystems / 2,482 "never-used" theorems / 35 DUAL_OF pairs / 344 transitive-closure gaps; Mathlib = 175,137 theorems (as of 2026-04-19)

> **Post-cycle-43 status (2026-04-21):** corpus has grown to **8,996 OmegaTheoryV2 theorems / 24 axioms / 211 files / 677 SubsystemNavigators / 86 GraphFindings** — roughly 5× the numbers quoted below. The design (literature review, loop shape, hunter-emit schema) is unchanged; only the scale and the specific "never-used" / "APPLIES-gap" counts in §1 are stale. Re-measure before running this agent for real. Build: 3,835 jobs green, 0 sorry.

---

## 1. Problem statement

OmegaTheory V2 has a Neo4j knowledge graph of 1,900 formalized theorems linked by 15 typed arrows (APPLIES, ASSUMES, UNFOLDS, REWRITES_BY, DUAL_OF, ADDITIVE_PAIR, …) and embedded in a 1472-d ByT5 retriever space. The FastRP + Leiden + K-means + Berry-phase pipeline (*Grothendieck V3-for-Lean*) gave us **281 subsystems**, modularity +0.447, and top relation α_UNFOLDS = 2.20.

But clustering alone does not identify *what is missing*. We observe:
- **2,482 / 1,900 theorems are never used** by any other theorem in the corpus (they are "terminal" / leaves).
- **35 DUAL_OF pairs** exist, but the ErrorForms / ErrorHopf / ErrorMaxwell modules have obvious algebraic duals not yet formalized (closed ↔ exact, left ↔ right Hopf module, Bianchi ↔ Maxwell).
- **344 APPLIES transitive-closure gaps** (a→b→c but no a→c). Some are not worth closing; some are missing lemmas.
- **2,097 theorems have no APPLIES/ASSUMES premises** at all — likely missing edges rather than genuine leaves, since almost every Lean proof invokes *some* prior result.

We need a **long-lived hunter** that wakes up, scans the graph, cross-references literature, and proposes concrete new theorems. This memo designs that hunter.

---

## 2. Literature review

### 2.1 Conjecture generation from formal-math knowledge graphs

- **LeanConjecturer** — Isomoto, Hayashi et al. (arXiv:2506.22005, 2025): LLM + rule-based context extraction produced 12,289 conjectures from 40 Mathlib files, 3,776 syntactically valid and non-trivial. Uses iterative generate→evaluate→filter. *Directly applicable* as sub-procedure for Steps 4–5 of our loop. [arXiv:2506.22005](https://arxiv.org/abs/2506.22005)
- **LeanNavigator** — "Generating Millions Of Lean Theorems" (arXiv:2503.04772, 2025): state-graph exploration of Lean proof states to synthesize 4.7 M theorems / 1 B tokens. Technique: **extract new provable states by re-running tactics at every proof position**. Combines well with our APPLIES graph. [arXiv:2503.04772](https://arxiv.org/abs/2503.04772)
- **QuickSpec / Hipster / HipSpec** — Claessen, Smallbone, Johansson (multiple, 2010–2025): enumerate terms by size, test for equalities, propose equational lemmas. Strong on algebra; their Isabelle pipeline (Hipster) generated many missing lemmas for automated inductive provers. Recent port to Lean is **Lemmanaid** (arXiv:2504.04942, 2025), neuro-symbolic. [arXiv:2504.04942](https://arxiv.org/abs/2504.04942), [QuickSpec paper](https://www.cse.chalmers.se/~jomoa/papers/Automated_Conjecturing_in_QuickSpec.pdf)
- **MaLARea / MaLARea-SG1** — Urban et al. (LPAR 2007, 2008): naive-Bayes pairing of symbols with premise-names; **key insight**: countermodels drive conjecturing when too few premises are recommended. Still influential for "statistical-conjecturing over a formal corpus." [MaLARea](https://link.springer.com/chapter/10.1007/978-3-540-71070-7_37), [Statistical Conjecturing](https://ceur-ws.org/Vol-1785/W23.pdf)

### 2.2 Premise selection + GraphRAG

- **Magnushammer** — Mikuła et al. (arXiv:2303.04488, 2023, updated 2024): transformer-based, treats states/premises as text, **59.5 % vs Sledgehammer's 38.3 %** on PISA. No feature engineering. [arXiv:2303.04488](https://arxiv.org/abs/2303.04488)
- **LeanDojo / ReProver** — Yang, Swope, Gu et al. (arXiv:2306.15626, NeurIPS 2023): 98,734-theorem benchmark + retrieval-augmented LM. *Our retriever is already a LeanDojo derivative* (`kaiyuy/leandojo-lean4-retriever-byt5-small`). [arXiv:2306.15626](https://arxiv.org/abs/2306.15626)
- **Premise Selection for a Lean Hammer** — (arXiv:2506.07477, 2025): neural + symbolic; we should read this closely as a direct next step. [arXiv:2506.07477](https://arxiv.org/abs/2506.07477)
- **Graph Sequence Learning for Premise Selection** — ScienceDirect (2024): encodes the proof-graph as a sequence and predicts edges. Directly cognate with link prediction on our APPLIES graph. [Elsevier](https://www.sciencedirect.com/science/article/pii/S0747717124000804)

### 2.3 Persistent homology / Mapper on dependency graphs

- **Persistent Graph Homology** — Edelsbrunner & Morozov; survey (Handbook, 2017 + update). Barcodes of filtered simplicial complexes are *stable* under noise (stability theorem, Cohen-Steiner–Edelsbrunner–Harer 2007). Useful for finding **cycles of mutually-entailing theorems that lack a bridging edge**. [Handbook chapter](https://www.csun.edu/~ctoth/Handbook/chap24.pdf)
- **Mapper algorithm review (2007–2025)** — arXiv:2504.09042: Python impl `kmapper`. Constructs a nerve cover over a lens function, gives qualitative topology of a high-dimensional dataset. Could be run on FastRP embeddings to find **gluing regions between subsystems** — bridge theorems live there. [arXiv:2504.09042](https://arxiv.org/abs/2504.09042)

### 2.4 ML for Lean / Mathlib (2024–2025)

- **Nazrin** — atomic tactics + GNN for Lean 4 (arXiv:2602.18767, 2026): atomized 170,180 theorems, GNN-based tactic recommendation. [arXiv:2602.18767](https://arxiv.org/html/2602.18767)
- **Olympiad-level formal mathematical reasoning with RL** — Nature 2025 (DeepMind, Aristotle, ...). [Nature article](https://www.nature.com/articles/s41586-025-09833-y)
- **Formal Mathematical Reasoning: A New Frontier in AI** — survey (arXiv:2412.16075, 2024). [arXiv:2412.16075](https://arxiv.org/pdf/2412.16075)
- **HyperTree Proof Search (HTPS)** — Lample et al. (arXiv:2205.11491, NeurIPS 2022): online-training transformer-prover, miniF2F 31 → 42 %. Reference for *how* to drive proof search once a conjecture is proposed. [arXiv:2205.11491](https://arxiv.org/abs/2205.11491)
- **HOList / DeepHOL** — Bansal, Loos et al. (arXiv:1904.03241, ICML 2019): HOL-Light RL environment. Historical baseline. [arXiv:1904.03241](https://arxiv.org/abs/1904.03241)
- **TRAIL** — IBM (AAAI 2021, arXiv:1911.02065): RL on saturation-based ATP, +15 % over RL baselines. [arXiv:1911.02065](https://arxiv.org/pdf/1911.02065)

### 2.5 Large knowledge-graph completion

- **Topological link prediction** in Neo4j GDS — Common-Neighbors, Adamic-Adar, Resource-Allocation, Preferential-Attachment, Same-Community. Native Cypher-callable (`gds.alpha.linkprediction.*`). [Neo4j docs](https://neo4j.com/docs/graph-data-science/current/algorithms/linkprediction/)
- **Efficient Link Prediction via GNN Layers Induced by Negative Sampling** — TKDE 2024 (arXiv:2310.09516). Node-wise vs edge-wise architectures; both useful. [arXiv:2310.09516](https://arxiv.org/html/2310.09516v2)
- **Link prediction without learning** — HAL 2024: plain heuristics remain competitive on many benchmarks, a useful first cut before GNN. [hal-04643971](https://hal.science/hal-04643971v1/file/link_prediction_without_learning_2024.pdf)
- **BioPathNet (Nat. Biomed. Eng. 2025)**: template for biomedical KG-completion with explanations — structurally close to what a theorem-gap hunter should emit. [Nature](https://www.nature.com/articles/s41551-025-01598-z)
- **Hyperedge prediction** — DeepHypergraph (`dhg` PyPI), HyperNetX, XGI. HPRA (Kumar et al. 2020) predicts hyperedges of *any* cardinality. A theorem using N premises is naturally a hyperedge, so **hypergraph methods see compositional structure that pairwise GNN misses**. [DHG](https://github.com/iMoonLab/DeepHypergraph), [HyperNetX](https://www.theoj.org/joss-papers/joss.06016/10.21105.joss.06016.pdf)

---

## 3. Methods catalogue

| # | Method | What gap it finds | Implementation | Priority |
|---|---|---|---|---|
| 1 | PageRank / reverse PageRank | Central theorems (authorities) and hub theorems | `gds.pageRank` in Neo4j GDS | HIGH — already piloted manually; automate |
| 2 | Betweenness centrality | **Bridge theorems** between subsystems; structural holes | `gds.betweenness` (Brandes) in Neo4j GDS | HIGH — cheap on 1.9K nodes |
| 3 | Topological link prediction (Adamic-Adar, Common-Neighbors, Resource-Allocation, Pref-Attachment) | Missing APPLIES/DUAL_OF/ADDITIVE_PAIR edges | `gds.alpha.linkprediction.*` | HIGH — runs in seconds, no training |
| 4 | Embedding-based link prediction (cosine on ByT5 retriever vectors) | Missing edges where source + target are semantically close but not linked | Custom Cypher + the existing `lean_retriever_embedding_theorem` vector index | HIGH — embeddings already populated |
| 5 | Dual-pair completion (DUAL_OF / ADDITIVE_PAIR / MUL_PAIR symmetry audit) | Missing algebraic duals (e.g. closed ↔ exact, left ↔ right, additive ↔ multiplicative) | Cypher rule: find vertex X with a DUAL_OF neighbour but a potentially-symmetric vertex Y without one | HIGH — cheap, high precision |
| 6 | Transitive-closure hole detection (a→b→c with no a→c) | Missing compositional lemmas | Depth-2 Cypher pattern; our graph has **344** such holes today | HIGH — already queryable |
| 7 | Community-overlap / inter-subsystem-overlap nodes | Bridge theorems between Leiden subsystems | For each pair of adjacent subsystems, rank nodes by cross-subsystem APPLIES degree | HIGH — uses existing 281 SubsystemNavigators |
| 8 | Persistent homology (H₁ holes in the proof graph) | Cycles of mutually-entailing theorems with missing edge; structural loops suggesting an iff-theorem | `giotto-tda` or `ripser` on FastRP embeddings; filtration by depth_from_axiom | MEDIUM — needs Python ETL pipeline, more research-grade |
| 9 | Mapper / TDA graph | Qualitative topology of the 1472-d retriever space — finds clusters that clustering misses (e.g. long thin bridges) | `kmapper` Python library | MEDIUM — good for visualization and human-in-the-loop triage |
| 10 | Graph neural network link prediction (TransE, RotatE, ComplEx, NBFNet, PROXI) | High-recall candidate missing edges on a large corpus | PyTorch Geometric, DGL, or Neo4j GDS native pipelines | MEDIUM — requires training set; our 35 DUAL_OF + 157 ASSUMES pairs may be too small |
| 11 | Hyperedge analysis / prediction | **Compositional theorems**: if a∧b∧c are co-premises for many theorems, maybe a∧b∧c are conjunctively equivalent to something | `DeepHypergraph` / HPRA on N-ary premise sets | MEDIUM — exponential search space, but the ErrorLieAlgebra sector is small enough to enumerate |
| 12 | Mutually-implies cycles ("iff-cycles") | Groups of 3+ theorems entailing each other; a missing member is a novel equivalent | Cypher `MATCH cycle=(a)-[:APPLIES*2..5]->(a)` + filter | MEDIUM — finds "obviously should be iff" cases |
| 13 | Label propagation (proved/conjectured status) | When a :Prediction node is surrounded by proved neighbours, it is likely cheap | `gds.labelPropagation`, with binary label "has proof body" | LOW — secondary prioritization signal |
| 14 | Degree-corrected null-model residuals | Edges predicted by chance vs observed; high residuals = structurally implied missing edges | `networkx.bipartite` or custom numpy on the APPLIES matrix | LOW — overlapping with #3 |
| 15 | QuickSpec-style equational-lemma synthesis | Missing algebraic equalities among defined functions (commutativity, associativity, distributivity variants) | Lemmanaid (arXiv:2504.04942, Lean-4 port) or a custom term-enumeration script | RESEARCH-GRADE — needs integration with the Lean elaborator |
| 16 | Mathlib cross-namespace retrieval | OmegaTheoryV2 theorems without any IMPORTS-reachable Mathlib premise suggest **re-proving Mathlib internally** (a gap in the OTHER direction) | existing `cypher_mathlib.sh find_similar` | LOW-MEDIUM — sanity audit |
| 17 | Spectral gap on the MagneticLaplacian 𝔄 | New degeneracies or phase-transitions in the relation landscape; empirical signal for introducing new arrow types | numpy eigen-decomposition of 𝔄 | LOW — already part of Grothendieck pipeline, but periodic re-run gives drift signal |

**Coverage by gap type**:
- Missing theorem (new lemma): #5, #6, #11, #12, #15
- Missing edge (dependency the proof uses but graph didn't capture): #3, #4, #10
- Missing bridge (between clusters): #2, #7, #9
- Unverified conjecture (statement plausible, proof status open): #6, #10, #11, #13

---

## 3.X — Neo4j GDS-native algorithms for theorem-gap detection

**Stack verified on 2026-04-19**: Neo4j Enterprise 2026.03.1, GDS 2.x, **496 procedures installed** (via `CALL gds.list()`). All algorithms enumerated below are present in stream/mutate/write/stats variants, ready to run.

The choice of variant matters operationally:
- `.stream` — return rows to Cypher (best for exploratory hunting + triage).
- `.mutate` — write results to an in-memory graph projection (feeds into pipelined computation).
- `.write` — persist results as node properties (best when the hunter wants to *remember* a ranking across wake-ups).
- `.stats` — summary statistics only.
- `.estimate` — predict memory/time cost before running. **Always call on 1.9K-node graphs before a `.write` that touches ALL theorems**; negligible on our size but a good habit.

### 3.X.1 Centrality + ranking

| Algorithm | Procedure | Gap type | Priority | One-line rationale |
|---|---|---|---|---|
| PageRank | `gds.pageRank` | central theorems (authorities) | HIGH | validate against the manually-seen top-10 fanout (`einstein_tensor_emergence` etc.) |
| ArticleRank | `gds.articleRank` | damped-PageRank alternative | MEDIUM | favours hub nodes with few out-edges; different top-10 than PageRank — comparing the diff reveals fragile "load-bearing" theorems |
| Betweenness | `gds.betweenness` | **bridge theorems** | **HIGHEST** | bridges between Leiden subsystems ≡ structural holes ≡ missing lemma candidates |
| Closeness | `gds.closeness` and `.harmonic` | global reach | MEDIUM | harmonic variant handles disconnected graphs (important — our WCC likely has leaves) |
| Eigenvector | `gds.eigenvector` | importance via neighbour importance | MEDIUM | no damping — sensitive to cycles; complements PageRank |
| HITS | `gds.hits` | **hub vs authority split** | HIGH | theorem that *APPLIES* many lemmas (hub) vs theorem *applied by* many (authority); mismatch ⇒ structural asymmetry |
| Influence Maximization (CELF) | `gds.influenceMaximization.celf` | which K theorems unlock the most downstream | HIGH | "if we prove these 3, how many conjectures open up" — strategic targeting |

**Concrete Cypher (run on our graph today)**:

```cypher
// project APPLIES graph
CALL gds.graph.project(
  'omegaApplies',
  {Theorem: {label:'Theorem', properties:[]}},
  {APPLIES: {type:'APPLIES', orientation:'NATURAL'}},
  {nodeFilter: 'n.namespace = "OmegaTheoryV2"'}
);

// betweenness: top 20 bridge theorems
CALL gds.betweenness.stream('omegaApplies')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).name AS theorem,
       gds.util.asNode(nodeId).file AS file,
       score
ORDER BY score DESC LIMIT 20;

// HITS: who's a hub vs an authority?
CALL gds.hits.stream('omegaApplies', {hitsIterations: 20})
YIELD nodeId, values
RETURN gds.util.asNode(nodeId).name AS name,
       values.hub AS hub, values.auth AS auth,
       values.hub - values.auth AS hub_minus_auth
ORDER BY abs(values.hub - values.auth) DESC LIMIT 20;

// CELF — pick 5 theorems to prove next to unlock maximum downstream
CALL gds.influenceMaximization.celf.stream('omegaApplies', {seedSetSize: 5})
YIELD nodeId, spread
RETURN gds.util.asNode(nodeId).name, spread;
```

### 3.X.2 Community + clustering (complementary to Leiden)

| Algorithm | Procedure | Gap type | Priority | Notes |
|---|---|---|---|---|
| Louvain | `gds.louvain` | baseline communities | LOW | our Leiden already beats this; keep only for modularity-diff sanity checks |
| Label Propagation | `gds.labelPropagation` | **fast** soft communities | MEDIUM | O(E); useful on every wake-up to spot drift vs Leiden |
| Triangle Count | `gds.triangleCount` | local clustering coefficient / density | MEDIUM | high-triangle nodes are "over-proved", low-triangle = sparse neighbourhoods (candidates for new triangulating lemmas) |
| Local Clustering Coefficient | `gds.localClusteringCoefficient` | normalized triangle density | MEDIUM | ranks nodes by neighbourhood "closure" deficit |
| Weakly Connected Components | `gds.wcc` | **isolated theorem clusters ≡ suspected gaps** | HIGH | if a cluster of theorems never APPLIES anything outside, it's either self-contained (OK) or disconnected from the rest of physics (problem) |
| Strongly Connected Components | `gds.scc` | **iff-cycle groups** | HIGH | in a DAG APPLIES graph, SCC > 1 shouldn't exist — any SCC is a latent iff-equivalence class |
| K-Core decomposition | `gds.kcore` | layered proof core | MEDIUM | k-core with highest k = the "unbudgeable" foundational sector |
| K-Means on embeddings | `gds.kmeans` | geometric clustering on FastRP / ByT5 embeddings | MEDIUM | we already use this in Grothendieck; good for validating subsystem count |

**Concrete Cypher**:

```cypher
// find all SCCs of size > 1 in APPLIES — any hit is an iff-cycle gap
CALL gds.scc.stream('omegaApplies')
YIELD nodeId, componentId
WITH componentId, collect(gds.util.asNode(nodeId).name) AS members
WHERE size(members) > 1
RETURN componentId, members, size(members) AS k
ORDER BY k DESC;

// WCC: how many disconnected islands in APPLIES?
CALL gds.wcc.stream('omegaApplies')
YIELD nodeId, componentId
RETURN componentId, count(*) AS size
ORDER BY size DESC LIMIT 20;

// k-core: the deepest layer is the theory's spine
CALL gds.kcore.stream('omegaApplies')
YIELD nodeId, coreValue
RETURN coreValue, count(*) AS n
ORDER BY coreValue DESC;
```

### 3.X.3 Similarity + path

| Algorithm | Procedure | Gap type | Priority | Notes |
|---|---|---|---|---|
| Node Similarity (Jaccard / Overlap) | `gds.nodeSimilarity`, `.filtered` | **twin theorems that should MUTUALLY_IMPLY** | **HIGHEST** | two theorems with identical in- or out-neighbourhoods are prime candidates for an iff |
| kNN on embeddings | `gds.knn` | alternative to ByT5 kNN | MEDIUM | can use the `embedding_lean` property directly |
| Filtered Node Similarity | `gds.nodeSimilarity.filtered` | only compare within same subsystem | HIGH | avoids spurious matches across physics sectors |
| Dijkstra / shortest path | `gds.shortestPath.dijkstra` | lemma-chain length ≈ proof complexity | MEDIUM | long shortest paths between "obviously equivalent" statements = missing-shortcut lemma |
| All shortest paths | `gds.allShortestPaths.dijkstra` | full reachability map | LOW | expensive; use selectively |

**Concrete Cypher**:

```cypher
// Node Similarity — find the top-10 pairs with Jaccard > 0.8, predict DUAL_OF or MUTUALLY_IMPLIES
CALL gds.graph.project(
  'omegaAppliesOut',
  'Theorem',
  {APPLIES: {type:'APPLIES', orientation:'NATURAL'}}
);
CALL gds.nodeSimilarity.stream('omegaAppliesOut', {similarityCutoff: 0.8, topK: 1})
YIELD node1, node2, similarity
RETURN gds.util.asNode(node1).name AS a,
       gds.util.asNode(node2).name AS b,
       similarity
ORDER BY similarity DESC LIMIT 10;
```

### 3.X.4 Link prediction — the core of gap hunting

| Algorithm | Procedure | Signal | Priority |
|---|---|---|---|
| Adamic-Adar | `gds.linkprediction.adamicAdar` | low-degree shared neighbours ⇒ weighted evidence | **HIGHEST** |
| Common Neighbors | `gds.linkprediction.commonNeighbors` | baseline | HIGH |
| Preferential Attachment | `gds.linkprediction.preferentialAttachment` | hub-to-hub bias | MEDIUM |
| Resource Allocation | `gds.linkprediction.resourceAllocation` | degree-weighted Adamic-Adar variant | HIGH |
| Same Community | `gds.linkprediction.sameCommunity` | Boolean: within-subsystem? | HIGH |
| Total Neighbors | `gds.linkprediction.totalNeighbors` | naive size union | LOW |
| **ML Pipeline** | `gds.beta.pipeline.linkPrediction.*` | trained classifier on engineered features + node2vec | HIGH |
| **GraphSAGE** | `gds.beta.graphSage` | inductive GNN | MEDIUM (needs node features) |

**Concrete Cypher — the hunter's core query**:

```cypher
// for any theorem pair NOT currently linked by APPLIES, compute Adamic-Adar + Common Neighbors
// keep top-20 by AA; these are the hunter's prime candidates
MATCH (t1:Theorem {namespace:'OmegaTheoryV2'})
MATCH (t2:Theorem {namespace:'OmegaTheoryV2'})
WHERE id(t1) < id(t2)
  AND NOT (t1)-[:APPLIES]->(t2)
  AND NOT (t2)-[:APPLIES]->(t1)
WITH t1, t2,
     gds.linkprediction.adamicAdar(t1, t2, {relationshipQuery:'APPLIES'}) AS aa,
     gds.linkprediction.commonNeighbors(t1, t2, {relationshipQuery:'APPLIES'}) AS cn
WHERE aa > 0.5
RETURN t1.name, t2.name, aa, cn
ORDER BY aa DESC LIMIT 20;
```

**ML link-prediction pipeline** (train once, re-predict on every new build):

```cypher
// create a link-prediction pipeline
CALL gds.beta.pipeline.linkPrediction.create('omegaLinkPrediction');

// use fastRP embedding as input feature
CALL gds.beta.pipeline.linkPrediction.addNodeProperty(
  'omegaLinkPrediction', 'fastRP', {embeddingDimension: 128, randomSeed: 42});
CALL gds.beta.pipeline.linkPrediction.addFeature(
  'omegaLinkPrediction', 'HADAMARD', {nodeProperties: ['fastRP']});

// train on APPLIES edges (negative-sampled)
CALL gds.beta.pipeline.linkPrediction.train(
  'omegaApplies', {
    pipeline: 'omegaLinkPrediction',
    modelName: 'omegaApplyModel',
    targetRelationshipType: 'APPLIES',
    metrics: ['AUCPR']
  });

// predict top-50 missing APPLIES edges
CALL gds.beta.pipeline.linkPrediction.predict.stream(
  'omegaApplies', {modelName: 'omegaApplyModel', topN: 50, threshold: 0.5})
YIELD node1, node2, probability
RETURN gds.util.asNode(node1).name AS a,
       gds.util.asNode(node2).name AS b,
       probability
ORDER BY probability DESC;
```

### 3.X.5 Embeddings beyond FastRP

| Algorithm | Procedure | Purpose |
|---|---|---|
| FastRP | `gds.fastRP` | **currently used** (Grothendieck pipeline); validated m=64 per relation |
| node2vec | `gds.node2vec` | random-walk learned embedding — **comparing to FastRP exposes walk-sensitive structure** (long-range dependencies FastRP misses) |
| GraphSAGE | `gds.beta.graphSage` | inductive, needs node features (use `depth_from_axiom`, `fanout`, `in_degree`) |
| HashGNN | `gds.hashgnn` | newer GNN variant, parameter-free, very fast |

We already have FastRP at m=64. Suggestion: re-run with node2vec for comparison, compute per-node embedding divergence, flag nodes where the two disagree most — those are structurally ambiguous (possible gap markers).

### 3.X.6 Topological / structural

| Algorithm | Procedure | Gap type | Priority |
|---|---|---|---|
| Articulation Points | `gds.articulationPoints` | **a single theorem whose removal disconnects the graph ⇒ crucial load-bearing lemma** | **HIGHEST** |
| Bridges | `gds.bridges` | **edges whose removal disconnects** — direct bridge-lemma candidates | **HIGHEST** |

**Concrete Cypher**:

```cypher
// articulation points — these theorems are the theory's "keystones"
CALL gds.articulationPoints.stream('omegaAppliesUndirected')
YIELD nodeId, articulationPoint
WHERE articulationPoint = true
RETURN gds.util.asNode(nodeId).name, gds.util.asNode(nodeId).file;

// bridge edges — direct structural-hole markers
CALL gds.bridges.stream('omegaAppliesUndirected')
YIELD from, to
RETURN gds.util.asNode(from).name AS src, gds.util.asNode(to).name AS tgt;
```

### 3.X.7 Recommended first-wake-up GDS battery (1 hour, deterministic)

The hunter's very first wake-up should execute this fixed script, whose total runtime on our 1,900-node graph is under 10 seconds plus I/O:

1. `gds.graph.project('omegaApplies', 'Theorem', 'APPLIES')`
2. `gds.pageRank.write` + `gds.articleRank.write` + `gds.betweenness.write` + `gds.closeness.harmonic.write` + `gds.hits.write` + `gds.eigenvector.write`
3. `gds.wcc.write` + `gds.scc.write` + `gds.kcore.write`
4. `gds.nodeSimilarity.stream` with cutoff 0.85, collect pairs
5. `gds.linkprediction.adamicAdar` pairwise over non-edges, keep top-100
6. `gds.articulationPoints.write` + `gds.bridges.stream`
7. `gds.influenceMaximization.celf.stream` with seedSetSize 10

All seven together produce a **provenance bundle**: every theorem now carries `pagerank`, `articleRank`, `betweenness`, `closeness`, `hub`, `auth`, `wccId`, `sccId`, `kcore`, `articulation` properties. Every subsequent wake-up compares deltas and flags changes. That alone is a research-grade paper ("Centrality evolution of a live Lean proof corpus").

---

## 3.Y — How our stack differs from published academic work

This is not a rhetorical section — every point below is a concrete methodological advantage.

1. **Live corpus vs static benchmark.** All published Lean / Mathlib mining work (LeanDojo, Magnushammer, LeanConjecturer, LeanNavigator) operates on a frozen snapshot. We refresh Mathlib + OmegaTheoryV2 ingestion with every green build (≤ hours stale). The hunter can therefore see *regressions* (edges deleted by refactors) and *drift* (fanout shifting month-over-month), neither of which the static work can.
2. **Domain-specific embeddings with structural labels.** Published work uses either (a) a generic BPE-trained sequence model (Magnushammer, ReProver) or (b) a GNN trained on synthetic tasks. We have *both*: a domain-specific ByT5 retriever **and** a Grothendieck-V3 subsystem label on every node (281 Leiden subsystems carrying a FastRP-residual α-score per arrow type). Published link-prediction pipelines do not consume arrow-type-specific features.
3. **Typed arrow algebra.** Nearly all published graph-mining work on proof-corpora uses a single edge type ("depends_on"). We have 15 typed arrows with categorical structure (structural / dependency / type-theoretic / computational) plus a MagneticLaplacian giving rank-2 per-relation spectra. Link-prediction can be arrow-typed, not just link-existence — that is, we can ask "is this a missing DUAL_OF or a missing APPLIES?" instead of just "is this a missing edge?".
4. **Closing the loop.** LeanDojo, ReProver, Magnushammer, Nazrin all target *premise retrieval during a proof*: given a goal, find useful lemmas. We target the upstream problem: find **which new goals are worth stating**. LeanConjecturer is the closest published analogue and is pure-LLM; our approach is hybrid graph-algorithmic + LLM.
5. **Dual ingestion.** Our `OmegaTheoryV2` namespace is linked to the `Mathlib` namespace via IMPORTS edges across **175,137 Mathlib theorems** also embedded and indexed. No published work combines a domain-specific proof-graph with the full Mathlib ambient in a single retrieval-capable store. That means the hunter can instantly test "is this proposed gap already proved elsewhere?" without spinning up Loogle.
6. **Live Neo4j Enterprise GDS.** Most academic work uses igraph / snap / DGL / PyG on CSV exports. We have 496 GDS procedures ready to run against the live store via Cypher, including the 2026 additions to the Graph Data Science library (kcore, articulationPoints, bridges, HashGNN, CELF influence maximization). This reduces the wall-clock for a full-battery sweep from "train overnight on a cluster" to "run 7 calls in under 10 seconds."
7. **Opus-4.7 + MCP + interleaved thinking.** No published paper integrates a frontier LLM as the *controller* of graph analytics with tool-level access to both the graph store and the theorem prover. Our hunter, unlike every cited system, can: observe graph → hypothesize gap → test with lean-lsp → fetch literature → register prediction, **all in one agent, one shot, with reasoning traces between each step**. This removes the academic bottleneck of "human-in-the-loop for every hypothesis."

**Methodological claim.** A paper titled "Graph-Algorithmic Theorem-Gap Mining on a Live Lean Proof Corpus" with sections (3 methodology, 2 Lean case studies, 1 Mathlib cross-audit) is **novel** and publishable at AITP / CICM / even ICLR-workshop. The novelty is not in any single algorithm — it is in the integration of (typed-arrow graph) × (domain embedding) × (GDS procedural suite) × (frontier LLM controller) × (live refresh). No prior art simultaneously holds all five.

---

## 4. Recommended hunter loop (5 steps)

**Cadence**: triggered (a) manually via `SendMessage`, (b) after every Grothendieck re-run, (c) after every green build that grows the theorem count by ≥ 20.

### Step 1 — Observe

```cypher
// (i) what was added since last wake-up
MATCH (t:Theorem {namespace:'OmegaTheoryV2'})
WHERE t.last_modified > $since_iso
RETURN t.name, t.file, t.signature LIMIT 200;

// (ii) snapshot size
MATCH (nav:NavigationMaster {namespace:'OmegaTheoryV2'})
RETURN nav.theorem_count, nav.axiom_count, nav.file_count, nav.build_jobs;
```

Compare against memory file `last_snapshot.json`.

### Step 2 — Hypothesize (multi-method sweep: the GDS battery from §3.X.7 + 3 of the non-GDS methods)

```cypher
// A. Dual-pair completion (method #5)
MATCH (a:Theorem {namespace:'OmegaTheoryV2'})-[:DUAL_OF]->(a_dual)
WITH collect(a.name) + collect(a_dual.name) AS paired
MATCH (b:Theorem {namespace:'OmegaTheoryV2'})
WHERE b.name IN ['closed1_is_exact','exact1_is_closed_on_ball','left_hopf_coassoc','right_hopf_coassoc']
  AND NOT b.name IN paired
RETURN b.name AS unpaired_candidate;

// B. Transitive-closure holes (method #6)
MATCH (a)-[:APPLIES]->(b)-[:APPLIES]->(c)
WHERE a.namespace='OmegaTheoryV2' AND b.namespace='OmegaTheoryV2' AND c.namespace='OmegaTheoryV2'
  AND NOT (a)-[:APPLIES]->(c)
  AND a <> c
RETURN a.name, b.name, c.name
LIMIT 20;

// C. Inter-subsystem bridges (method #7)
MATCH (t:Theorem)-[:APPLIES]->(u:Theorem)
WHERE t.namespace='OmegaTheoryV2' AND u.namespace='OmegaTheoryV2'
  AND t.subsystem_id IS NOT NULL AND u.subsystem_id IS NOT NULL
  AND t.subsystem_id <> u.subsystem_id
RETURN t.subsystem_id AS from_sub, u.subsystem_id AS to_sub, count(*) AS edges
ORDER BY edges DESC LIMIT 20;
```

### Step 3 — Validate (is the gap *really* missing?)

For each candidate produced by Step 2, run:

```
mcp__lean-lsp__lean_local_search(query=<candidate name>)  # already formalized?
mcp__lean-lsp__lean_leanfinder(query=<human restatement>)  # exists in Mathlib?
~/services/cypher_mathlib.sh search_sig '<signature pattern>'
```

If any returns a hit, downgrade the candidate. If all four return empty, the gap is real.

### Step 4 — Evaluate (does literature support it?)

For each surviving candidate:
- `WebSearch` on the statement.
- `WebFetch` on the top 2 results to check whether *someone else has already proven this* in Coq / Isabelle / Mizar.
- If yes and no Lean port: priority HIGH (clear direct port).
- If no prior art: priority HIGH (novel contribution, cite as such).

### Step 5 — Propose (write node + optional dispatch)

```cypher
MERGE (p:Prediction {namespace:'OmegaTheoryV2', name:$name})
SET p.statement       = $statement,
    p.rationale       = $rationale,
    p.discovery_method = $method,       // e.g. 'transitive_hole' / 'dual_pair' / 'subsystem_bridge'
    p.literature_refs  = $refs,         // JSON list of arXiv IDs
    p.discovered_at    = datetime(),
    p.discovered_by    = 'theorem-gap-hunter',
    p.status           = 'open',
    p.priority         = $priority      // HIGH | MEDIUM | LOW
WITH p
UNWIND $related AS r
MATCH (t:Theorem {namespace:'OmegaTheoryV2', name: r})
MERGE (p)-[:RELATED_TO]->(t);
```

If priority HIGH and proof looks short (≤ 30 lines estimated), dispatch a message to `lean-proof-wizard`:

```
SendMessage(
  to='lean-proof-wizard',
  body='Hunt target: <name>. Statement: <lean syntax>. Related theorems: <list>. Expected tactic: exact? / aesop / linarith.')
```

---

## 5. Teammate agent spec

| Field | Value |
|---|---|
| Subagent type | `general-purpose` (has full tool access including MCP) |
| Agent name | `theorem-gap-hunter` |
| Memory location | `~/.claude/agent-memory/theorem-gap-hunter/` |
| Wake-up cadence | (a) manual `SendMessage`; (b) after Grothendieck; (c) after large build delta |
| Budget per wake-up | 20–40 min agent time, 3 methods from the catalogue per wake-up |
| Tools required | Bash, Read, Grep, Glob, Write, Edit, WebSearch, WebFetch |
| MCP servers required | `neo4j-math` (Cypher read + write, incl. GDS procedure calls), `lean-lsp` (search + hover), `omega-search` (retrieve + neighbours + subsystem_of) |
| GDS procedures exercised per wake-up | battery of §3.X.7 (7 calls) + ad-hoc link-prediction + articulationPoints |
| Graph shell wrapper | `~/services/cypher_mathlib.sh` (fallback if MCP unavailable in subagent) |
| Thinking mode | interleaved / extended — observe → hypothesize → validate → evaluate → propose |
| Write permissions | create `:Prediction` / `:OpenTheorem` nodes; update `status` on existing ones; **never** edit `.lean` files directly — those go to `lean-proof-wizard` |
| Output artefact | one markdown memo per wake-up at `~/papers/V3-for-Lean/hunts/YYYY-MM-DD_HHMM_hunt.md` summarising Steps 1–5 |

**Tool-bundle verdict**: the current `general-purpose` definition suffices, provided `mcp__neo4j-math__write_neo4j_cypher` is enabled. If the team is uncomfortable with write access at agent scope, fall back to: hunter writes a `.cypher` patch file in `~/papers/V3-for-Lean/hunts/` and the human merges.

---

## 6. First three concrete gaps to hunt (from current graph)

Based on exploration done while writing this memo (graph state 2026-04-19):

### Gap #1 — Exactness / closedness dual completion in ErrorForms

- **Signal**: `closed1_is_exact` is one of the top-10 fanout theorems (31 uses). Only 35 DUAL_OF pairs in the whole corpus; ErrorForms has many one-sided statements. Loogle-style survey: we have `d_squared_zero`, `closed1_is_exact`, but no mirrored `exact1_is_closed`, no Poincaré lemma in the ambient 2-form sector beyond `lineIntZ_shift_2form_closed`.
- **Candidate theorem**: `exact1_is_closed_on_ball : ∀ (ω : OneForm), IsExactOn B ω → IsClosedOn B ω`.
- **Discovery method**: dual-pair completion (#5) + the observation that `lineIntZ_shift_2form_closed` and `lineIntZ_shift_2form_closed_K` appear twice in the top-10 (entropy signal of a missing abstraction).
- **Why believable**: algebraic duality in de Rham is textbook; gap is artefact of formalization order.

### Gap #2 — π/e/√2 error-bound symmetry family

- **Signal**: `pi_quarter_error_bound` (fanout 29), `e_error_bound` (24), `sqrt2_error_bound` (22) all in top-10. All three irrationals should have (i) a convergence theorem `*_error_tendsto_zero`, (ii) a monotone-decreasing bound, (iii) a first-derivative rate, (iv) an iteration-budget corollary. Audit of `Irrationality/BoundsLemmas.lean` + the graph shows **missing monotonicity for the e family** and **missing derivative-rate for sqrt2**.
- **Candidate theorems**:
  - `e_error_bound_monotone : ∀ N M, N ≤ M → e_error_bound M ≤ e_error_bound N`
  - `sqrt2_error_bound_derivative_rate : ∃ C, ∀ N, |e_error_bound (N+1) - e_error_bound N| ≤ C * (1/2)^(2^N)`
- **Discovery method**: dual-pair completion (#5) + subsystem-overlap (#7) — these three theorems share a Leiden subsystem.
- **Literature support**: QuickSpec / Lemmanaid-style equational exploration would find the monotonicity automatically.

### Gap #3 — Subsystem-bridge: Einstein tensor ↔ computational uncertainty

- **Signal**: `einstein_tensor_emergence` is the top fanout theorem (38 uses). It lives in `Emergence/`, while `computationalUncertainty` lives in `Irrationality/`. Current graph shows **no APPLIES edges between the two subsystems** at depth 1, yet they are semantically adjacent (GR ↔ QM).
- **Candidate theorem**: `einstein_tensor_has_uncertainty_floor : ∀ g N, ‖einsteinTensor g - continuumLimit g‖ ≤ C * computationalUncertainty N`.
- **Discovery method**: inter-subsystem-overlap (#7) + embedding cosine (#4). This is exactly the kind of bridge theorem persistent-homology / Mapper would surface because the two subsystems are close in the retriever-space but topologically disconnected in the APPLIES graph.
- **Why it matters**: makes the central thesis "irrationality of π implies QM + GR emerges from the same substrate" a *provable* statement rather than a philosophical one. Downstream impact on paper narrative.

---

## 7. Risks + mitigations

| Risk | Mitigation |
|---|---|
| Hunter proposes gaps that are already formalized under a different name | **Always** run `lean_local_search` + `mcp__neo4j-math__read_neo4j_cypher` on aliases before creating `:Prediction` |
| `:Prediction` nodes accumulate without ever being closed | Add a weekly Grothendieck sweep that prunes `:Prediction` nodes whose `statement` matches a newly-added theorem's signature |
| Link-prediction false positives (many algebraically-plausible "edges" are wrong types) | Hunter must emit a **typed** prediction (which arrow?) and filter against `:SelectionRule` HARD_BLOCK edges from LeanAlgebra |
| Hunter steals credit from humans or from `quantum-physics-creative` | Provenance on every `:Prediction`: `discovered_by`, `discovery_method`, `literature_refs`. Claim is "suggested" not "proved" until `lean-proof-wizard` closes it |
| GNN-based methods need training data we don't have | Default to the 8 *training-free* methods (#1, #2, #3, #5, #6, #7, #12, #16). Keep GNN/HyperGNN as research-grade follow-up |
| Write access to Neo4j at agent scope | Use patch-file fallback: hunter writes `.cypher` to `~/papers/V3-for-Lean/hunts/` and logs a `SendMessage` asking for human merge |
| π-ordering mistake repeats (see memory) | Pin hunter's prompt to remind: "hardest = most residual errors, π heaviest, √2 lightest; do NOT invert via Connes Λ = 1/δ" |
| Budget runaway on WebSearch | Per-wake-up hard cap: 10 searches total, 5 WebFetch max |

---

## 8. Next steps (for the team to decide)

1. Greenlight `theorem-gap-hunter` as a new agent role.
2. Bootstrap memory at `~/.claude/agent-memory/theorem-gap-hunter/` with:
   - `loop.md` (Steps 1–5),
   - `pi_ordering_correction.md` (mirror of repo note),
   - `first_three_gaps.md` (section 6 above),
   - `method_catalogue.md` (section 3 table).
3. Run the **first hunt immediately on the 3 gaps in §6**; if ≥ 2 of 3 survive Step 3 validation, declare proof-of-concept.
4. Add a `Prediction` label to the OmegaTheoryV2 schema in Neo4j.
5. Iterate monthly: add one new method from the catalogue per month (priority order: #2, #3, #7, #6, #4, #8).

---

*End of memo — 2026-04-19*
