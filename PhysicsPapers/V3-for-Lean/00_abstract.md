# 00 — Abstract

**V3-for-Lean: Magnetic-Laplacian retrieval, Leiden subsystems, and fibered community structure on a 9k-theorem physics corpus.**

We adapt the V3 framework (Marchewka 2026), originally designed for system
architecture knowledge graphs, to the Lean 4 theorem-prover setting. We ingest
OmegaTheory V2 — a cycle-43, Grand-Capstone-closed formal-physics library
with $8{,}996$ theorems, $4{,}465$ definitions, $8$ physical axioms and $0$
`sorry`s — into a Neo4j knowledge graph under a six-entity / fifteen-typed-arrow
schema (`LeanAlgebra`). Declarations carry full signatures, proof bodies,
docstrings and $1472$-dimensional LeanDojo ByT5 retriever embeddings.

On this typed multigraph we construct a **Magnetic Laplacian**
$\mathfrak{A} \in \mathbb{C}^{6\times 6}$ with phase parameter $g=1/4$, rank-2
per-relation decomposition, and a FastRP embedding pipeline parametrised by
per-relation weights $\alpha_k$. The first empirical measurement yields a
saturating rank-$7$ spectrum with leading ratio $\lambda_1/\lambda_2 = 1.038$
— the first machine-proved non-abelian signal in a theorem-prover corpus —
and a $73.3\%$ non-commutativity rate between the fifteen arrow categories.

Leiden community detection at $\gamma = 0.5$ produces $116$ communities with
modularity $Q = 0.89$ on $11{,}921$ nodes. Crucially, the community-size
distribution exhibits **no sharp four-band gap**: the theory's postulated
partition into four irrational channels ($\pi$, $e$, $\sqrt{2}$, Catalan-$G$)
is *fibered* over the Leiden base rather than partitioned against it — the
channel-wise spectral norm ordering $\|v_\pi\|^2 > \|v_G\|^2 > \|v_{\sqrt{2}}\|^2$
nonetheless matches the theoretical residual-$\delta$ ordering to within $2\sigma$.

Eight categorical / homological / spectral passes on the post-capstone corpus
identify twenty-three concrete `TheoremCandidate` nodes — twelve FastRP-predicted
bridge theorems between under-connected Leiden communities, seven missing
left/right dual fermion doublets, and four Pi-Hunch frontier statements
(tightness, saturation, uniqueness, stability of the extended Heisenberg bound
$\Delta x\,\Delta p \geq \hbar/2 + \delta_{\text{comp}}(N)$).

We release the full ingest pipeline, the Magnetic-Laplacian decomposition
scripts, the Neo4j schema, and a MiniF2F-v2 plus OmegaTheory-held-out benchmark
suite. The principal contribution is methodological: we show that a physics
theory's formal-library graph carries structure — descent data, fibrations,
Betti numbers, dual-pair asymmetries — that is directly actionable as a list
of next-cycle proof-search targets, and we provide a reproducible recipe for
extracting it.

**Word count:** $\sim$ $315$.
**Target venues:** NeurIPS 2026 Math-AI workshop; ICLR 2027; Foundations of
Physics long-form companion.
