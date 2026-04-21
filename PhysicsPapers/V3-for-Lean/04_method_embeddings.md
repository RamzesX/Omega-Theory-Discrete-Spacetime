# 04 — Method: Embeddings

This section specifies the dense-vector layer of V3-for-Lean. We use two
retrievers, in parallel:

1. A $1472$-d **LeanDojo ByT5-small** retriever
   (`kaiyuy/leandojo-lean4-retriever-byt5-small`) that is the reference
   weight shipped with Yang et al. (NeurIPS 2023). All benchmark numbers
   in $\S 6$ are reproducible from these public weights.
2. A $4096$-d **Qwen3-Embedding-8B** encoder in bfloat16, run on a
   single consumer GPU ($11$–$15$ GB VRAM) and served over a
   local HTTP endpoint at `:7999`. These embeddings carry the
   higher-capacity signal used by the consumer-layer (Leiden-scope)
   retrieval in $\S 5$.

The decision to ship *both* is deliberate: the ByT5 retriever is
reproducible, auditable and matches the published LeanDojo baseline;
Qwen3-8B is closer to the capacity frontier of currently-available
public embedding models and gives a cleaner separation signal on our
$\approx 13{,}500$-node corpus.

## 4.1 Why not Lean-Finder?

Lean-Finder (arXiv:2510.15940 + arXiv:2510.23637, 2025) is the
published state-of-the-art for semantic Lean retrieval. Its weights are
not public; only an MCP endpoint (`lean_leanfinder`) is exposed. We
therefore cannot ingest the Lean-Finder embedding directly.

We take two consequences seriously.

**Consequence A — reproducibility.** Every quantitative claim in this
paper is re-computable from the LeanDojo ByT5 weights, the published
Qwen3-8B weights, and our ingest scripts. No numbers depend on the
closed Lean-Finder service.

**Consequence B — comparison fairness.** Where Lean-Finder is the
baseline (e.g. a premise-ranking shoot-out) we query Lean-Finder via
the MCP endpoint and record its rankings. We do **not** train against
those rankings — this would leak hidden capacity from a closed model
into our open-weights pipeline.

## 4.2 Embedding inputs

For each declaration $d$ we compose an embedding string from four
fields (in order):

$$
\mathrm{inp}(d) \;=\; [\mathrm{kind}]\,\|\,d.\mathrm{name}\,\|\,d.\mathrm{signature}\,\|\,d.\mathrm{docstring}\,\|\,d.\mathrm{proof\_body}
$$

where $[\mathrm{kind}]$ is one of six literal tokens
(`[axiom]`, `[definition]`, `[instance]`, `[namespace]`, `[structure]`,
`[theorem]`) matching the six entity types of $\S 3.1$. The proof
body is truncated to the first $1024$ tokens when it exceeds the
context window. Namespace and Instance declarations have no proof
body; for them the last field is empty.

The design choice here — include the *proof body* in the embedding —
is non-standard. LeanDojo defaults to embedding (name, statement,
premises) triples. We prefer the (name, signature, docstring, proof
body) quadruple because the proof body carries the
**tactic-residual signal** that drives the `REWRITES_BY` and
`SUGGESTED_BY` arrows in $\S 3.2$. Empirically, including proof bodies
improves premise recall by $\approx 4.2$ points on MiniF2F-v2
(cf. $\S 6$).

## 4.3 The Qwen3-8B stack

**Model.** `Qwen/Qwen3-Embedding-8B`, bfloat16, $4096$-d output,
average-pooled over last layer. Tokenizer context $32{,}768$ tokens.

**Hardware.** Single AMD $7900$-series GPU with $11$–$15$ GB VRAM,
Linux WSL2 passthrough. Budget-GPU configuration documented in the
project memory note `project_budget_gpu_apr20.md`.

**Server.** FastAPI wrapper at `:7999/v1/embeddings`, OpenAI-compatible
schema so that any LangChain / LlamaIndex client works out of the box.
Source: `V3-for-Lean/code/servers/qwen3_embedding_server.py`.

**Throughput.** $\approx 29$ declarations per second on MiniF2F-v2;
$\approx 600$ per minute on Mathlib-scale with batching. The Mathlib-ingest
delta took $\approx 14$ hours for the initial $49{,}985$-theorem load
(cf. memory note `project_omega_search_v3_first_results.md`).

**Delta re-embedding.** Script:
`V3-for-Lean/code/servers/reembed_omega_qwen3_v2.py`. On each `lake
build` GREEN we (a) dump declarations, (b) compare against the Neo4j
`:Theorem` / `:Definition` / `:Axiom` nodes, (c) re-embed only the
declarations whose `content_hash` differs, (d) write back to the
`embedding_lean` property. Typical delta: $20$–$200$ declarations per
build, completing in $< 60$ seconds.

## 4.4 The LeanDojo ByT5 retriever

**Model.** `kaiyuy/leandojo-lean4-retriever-byt5-small`, $1472$-d,
mean-pooled over last layer. Byte-level tokenizer; robust to Unicode
and Lean-specific syntax.

**Index.** Neo4j vector index
`lean_retriever_embedding_theorem` / `_axiom` / `_declaration`, cosine
metric. Each declaration is indexed at build time via the same delta
re-embedding flow described above.

**Role.** This is the *reference* retriever for all benchmark
numbers. When a premise-ranking claim is made, it is made with ByT5
embeddings unless we explicitly state Qwen3.

## 4.5 Hybrid retrieval topology

For each query goal $g$ we compute both a ByT5 embedding $v_{\mathrm{ByT5}}(g)$
and a Qwen3 embedding $v_{\mathrm{Q3}}(g)$. The hybrid retriever
returns the top-$k$ premises by

$$
\mathrm{score}(g, d) \;=\; \lambda \cdot \cos\!\big(v_{\mathrm{Q3}}(g), v_{\mathrm{Q3}}(d)\big) \;+\; (1-\lambda) \cdot \cos\!\big(v_{\mathrm{ByT5}}(g), v_{\mathrm{ByT5}}(d)\big)
$$

with $\lambda = 0.6$ calibrated on a $100$-goal development slice of
OmegaTheory V2 (the value $0.6$ gives the highest recall@$20$; values
in $[0.5, 0.7]$ are within noise). When $\lambda = 1$ we are pure
Qwen3; $\lambda = 0$ pure ByT5; $\lambda \in (0, 1)$ is the hybrid.

## 4.6 FastRP fusion

The dense embeddings feed the FastRP fusion layer from $\S 3.7$ via

$$
v_{\mathrm{fused}}(d) \;=\; \mathrm{propertyRatio} \cdot v_{\mathrm{ByT5}}(d) \;+\; (1 - \mathrm{propertyRatio}) \cdot v_{\mathrm{FastRP}}(d)
$$

with $\mathrm{propertyRatio} = 0.5$. The resulting $1472$-d vector
(after a learned linear re-projection back to $1472$) is what the
consumer layer ($\S 5$) and the Leiden community-detector actually
consume.

## 4.7 Mathlib expansion

The same embedding flow is applied to the Mathlib v$4.29.0$ corpus
($\approx 500{,}000$ target declarations; $49{,}985$ Theorem +
$3{,}183$ LeanFile nodes ingested as of $2026$-$04$-$18$). Cross-namespace
retrieval is documented by the Cypher recipe

```cypher
MATCH (t:Theorem {namespace:'OmegaTheoryV2', name:$name})
WHERE t.embedding_lean IS NOT NULL
CALL db.index.vector.queryNodes(
  'lean_retriever_embedding_theorem', 20, t.embedding_lean
) YIELD node, score
WHERE node.namespace = 'Mathlib' AND node <> t
RETURN node.name, node.file, score
ORDER BY score DESC
```

We use this path both for premise expansion (the hunter agent's
Step 2) and for Mathlib-backed sanity checks (flag OmegaTheory V2
theorems that accidentally re-prove a Mathlib lemma).

## 4.8 Summary

The embedding layer of V3-for-Lean is

- LeanDojo ByT5-small ($1472$-d, reference + benchmark),
- Qwen3-Embedding-8B ($4096$-d, capacity frontier, local GPU),
- hybrid score with $\lambda = 0.6$,
- FastRP fusion with propertyRatio $0.5$,
- vector indices per entity type,
- delta re-embedding per `lake build` GREEN,
- cross-namespace expansion into Mathlib,
- **zero dependency on closed-weight services** (Lean-Finder accepted
  only as a baseline via MCP, not as a training signal).

All experimental numbers in $\S 6$ are reproducible from this stack.
