# 02 — Related Work

We cover four literatures: (a) neural premise selection for interactive
theorem provers, (b) conjecture generation and autoformalisation from a
formal library, (c) graph-based retrieval, knowledge-graph completion and
link prediction, (d) algebraic / spectral methods for directed multigraphs
and the original V3 framework in its system-architecture setting.

## 2.1 Neural premise selection for Lean and Coq

**LeanDojo / ReProver** (Yang, Swope, Gu et al., NeurIPS 2023, arXiv:2306.15626)
established the $98{,}734$-theorem LeanDojo benchmark and the first
retrieval-augmented DPR pipeline for Lean 4. The ByT5-small retriever released
with that paper (`kaiyuy/leandojo-lean4-retriever-byt5-small`, $1472$-d) is the
retriever we re-use in $\S 4$; we substitute its default weights when computing
embeddings over OmegaTheory V2 and Mathlib.

**Magnushammer** (Mikuła et al., arXiv:2303.04488, 2023–2024) is a
transformer-based premise selector (BPE, no feature engineering) that
attains $59.5\%$ vs Sledgehammer's $38.3\%$ on PISA. It is the strongest
published dense-retrieval-only baseline and the number we must beat on
OmegaTheory-held-out.

**Lean-Finder** (2025, arXiv:2510.15940 + arXiv:2510.23637) is a
closed-weights semantic search service exposed via `lean_leanfinder` in the
lean-lsp MCP surface. Because weights are not public we cannot benchmark
against it directly; we re-use the MCP surface for baseline queries and
substitute the LeanDojo retriever for reproducible experiments.

**Premise Selection for a Lean Hammer** (arXiv:2506.07477, 2025) is a hybrid
neural-symbolic hammer. The `lean_hammer_premise` MCP call is the fastest
ground-truth check in our pipeline; we use it both as a baseline and as a
verifier for candidate bridge theorems.

**LeanAgent** (Kumarappan et al., ICLR 2025, arXiv:2409.13329) introduced
rolling / lifelong premise indexing: update the retriever per commit rather
than once per paper. This matches our "live Neo4j refresh" advantage: every
`lake build` GREEN triggers a `dump_declarations` + `dump_arrows` + Qwen3
re-embed delta. We borrow the *lifelong* framing and extend it to typed
arrows and Magnetic-Laplacian recomputation.

**Rango** (Thompson et al., ICSE 2025) is a retrieval-augmented proof
synthesis tool for Coq with a $\delta$-step premise budget. We adopt the
bounded-depth retrieval pattern for the hunter agent's Step 4 (see
`proof_hunter_design_v2.md`).

**Nazrin** (arXiv:2602.18767, 2026) is a GNN + atomic-tactic system for
Lean 4 that atomises $170{,}180$ theorems and recommends tactics. It is the
strongest current GNN baseline; we compare against it on MiniF2F-v2 in $\S 6$.

**Graph Sequence Learning for Premise Selection** (Elsevier 2024) encodes
the proof graph as a sequence and predicts edges. This is the closest
cognate to our link-prediction sub-task, though it does not use typed
arrows or a Magnetic Laplacian.

## 2.2 Conjecture generation and autoformalisation

**LeanConjecturer** (Isomoto, Hayashi et al., arXiv:2506.22005, 2025)
combines LLM extraction with rule-based context to generate $12{,}289$
conjectures from $40$ Mathlib files; $3{,}776$ pass syntactic validity and
non-triviality filters. We use the same FORMULATE pattern in the
theorem-gap hunter (see memo `theorem_gap_hunter_design.md`, §3) but
additionally require the conjecture to close a specific graph-topological gap
(missing APPLIES edge, under-connected Leiden pair, dual-pair completion),
not just a general syntactic slot.

**LeanNavigator** (arXiv:2503.04772, 2025) extracts provable states by
re-running tactics at every proof position and harvests $4.7$ M theorems,
$1$ B tokens. We treat LeanNavigator's output as a *premise pool*; a V3-for-Lean
hunter can filter that pool against our typed-arrow topology.

**TheoremLlama** (arXiv:2407.03203, 2024) is a general-purpose LLM
fine-tuned for theorem proving; open weights. We position it as a
secondary proposal engine behind Opus in a PROPOSE-then-VERIFY loop.

**LEGO-Prover** (arXiv:2310.00656, 2023–2024) grows the premise library
from newly-proved lemmas. Our `:GrothendieckRecipe` provenance nodes
implement exactly this feedback pattern on typed arrows.

**DSP — Draft, Sketch, Prove** (Jiang et al., ICLR 2023, arXiv:2210.12283)
uses informal-draft $\to$ formal-sketch $\to$ formal-proof. Adopted as the
template for the hunter's FORMULATE step (memo §5).

**Lemmanaid** (arXiv:2504.04942, 2025) is a neuro-symbolic QuickSpec port
to Lean 4 and is the best-in-class for equational-lemma synthesis
(commutativity, associativity, distributivity). We integrate Lemmanaid as
the algebraic back-end for method M15 (QuickSpec-style equational
synthesis) in the gap hunter catalogue.

**MaLARea / MaLARea-SG1** (Urban et al., LPAR 2007, 2008) is the
historically-important naive-Bayes premise ranker; its insight that
*counter-models drive conjecturing when too few premises are recommended*
informs the hunter's fall-back routing on low-confidence bridges.

## 2.3 Graph-based retrieval, KG completion, link prediction

**Topological link prediction in Neo4j GDS.** The Graph Data Science
library (v$2.x$, $496$ procedures verified on $2026$-$04$-$19$) provides
native Cypher-callable Adamic-Adar, Common-Neighbors, Resource-Allocation,
Preferential-Attachment and Same-Community heuristics. These run in
seconds on our $13{,}461$-node graph and require no training set. On
OmegaTheory V2 they are both our first-pass gap detector and the
ground-truth baseline against which we measure GNN link-prediction uplift.

**Efficient Link Prediction via GNN Layers Induced by Negative Sampling**
(TKDE 2024, arXiv:2310.09516) compares node-wise vs edge-wise architectures
for sparse graphs. We use their negative-sampling scheme when training the
`omegaApplies` GraphSAGE baseline.

**Link prediction without learning** (HAL 2024) shows that plain heuristics
remain competitive on many benchmarks before GNN is necessary. We use this
as justification for reporting heuristic-first numbers in $\S 6$.

**BioPathNet** (Nat. Biomed. Eng. 2025) is a KG-completion with
explanations pattern in a bio-ontology; architecturally the closest match
to what a typed-arrow-aware proof hunter must emit (a `TheoremCandidate`
node with a typed provenance path).

**Hyperedge prediction — DeepHypergraph, HyperNetX, HPRA** (Kumar et al.
2020) predict hyperedges of any cardinality. A theorem using $N$ premises
is naturally a hyperedge; hyper-methods see compositional structure that
pairwise GNNs miss. We use HPRA as the M11 method in the hunter catalogue.

**HyperTree Proof Search (HTPS)** (Lample et al., NeurIPS 2022,
arXiv:2205.11491) is the reference architecture for online-training
transformer-provers; we cite it as the target hand-off architecture for
the ESCALATE step.

**Persistent homology on theorem-dependency graphs**
(Edelsbrunner–Morozov + Cohen-Steiner–Edelsbrunner–Harer stability theorem
2007) gives $H_1$-cycles as iff-gap candidates. We use `giotto-tda` /
`ripser` on FastRP embeddings for method M8.

**Mapper and TDA review** (arXiv:2504.09042, 2025) covers `kmapper` for
qualitative topology of high-dimensional embeddings; we use it in the
human-in-the-loop triage step of the proof hunter.

## 2.4 Algebraic and spectral methods; the V3 origin

**Magnetic Laplacians.** The magnetic-Laplacian construction on directed
graphs goes back to Lieb–Loss (1993) for physical systems and was lifted
to graph learning by Zhang et al. (ICML 2021, "MagNet"). Our construction
differs in two respects: (a) we couple the magnetic phase to *arrow type*
(fifteen types), not to edge orientation alone, and (b) we decompose
$\mathfrak{A}$ into rank-$2$ per-relation blocks to measure arrow-wise
non-commutativity directly rather than via a single global spectrum.

**FastRP.** The random-projection embedding of Chen et al. (2019) is a
cheap alternative to matrix factorisation for large graphs. V3 uses
FastRP with per-relation propagation weights $\alpha_k$ derived from the
Magnetic-Laplacian spectrum; this is the point at which the algebraic
lens and the geometric lens couple.

**Leiden.** Traag, Waltman, van Eck (Scientific Reports 2019) established
Leiden as the modularity optimiser of record for large graphs; we apply
it at $\gamma = 0.5$ on the shared `APPLIES $\cup$ UNFOLDS` projection and
report $Q = 0.89$ on $11{,}921$ nodes.

**V3 in its original domain.** V3 was first applied to a $1{,}000$-node
software-system knowledge graph (the `CheckItOutSystem` namespace of the
`checkItOut` marketplace codebase, Marchewka 2026) where the six entity
types are `Controller`, `Configuration`, `Security`, `Implementation`,
`Diagnostics`, `Lifecycle` and the arrows encode control-flow, data
dependency and observability relationships. The NavigationMaster
three-level architecture and the 6-entity behavioural categorisation were
both stress-tested there before being adapted to Lean. The present paper
is the first published V3-for-Lean adaptation.

## 2.5 Positioning of this work

Our contribution is *orthogonal* to the ReProver / Magnushammer /
Lean-Finder line: those works optimise the retrieval function against a
fixed corpus; we re-structure the corpus itself as a typed multigraph
with algebraic laws and geometric embeddings, exposing signals that a
pure dense-retrieval approach cannot see. Under the framing of
Kumarappan et al.'s LeanAgent (ICLR 2025), we give the *substrate* that
a lifelong learner must index; under the framing of Isomoto et al.'s
LeanConjecturer, we give the *topological prior* that distinguishes a
valuable conjecture from a noise one.
