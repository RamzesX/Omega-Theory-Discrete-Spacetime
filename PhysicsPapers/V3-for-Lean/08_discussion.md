# 08 — Discussion

We discuss limitations, failure modes, open questions, and the
implications of the fibered four-channel result for the physics-side
agenda.

## 8.1 Limitations

**L1 — Single-corpus evidence.** All empirical claims are measured on
OmegaTheory V2 (plus Mathlib as an imported background). The V3
framework itself is validated on a software-architecture graph
(`CheckItOutSystem`, Marchewka 2026) and now on a physics Lean corpus.
We do not yet have evidence that the Magnetic-Laplacian-$\lambda_1 /
\lambda_2$ signal generalises to *generic* Lean 4 projects (PhysLean,
mathlib4 in isolation, competition corpora). A follow-up paper will
evaluate on mathlib4 as a stand-alone.

**L2 — Qwen3 dependency.** The $4096$-d layer depends on a specific
embedding checkpoint (`Qwen/Qwen3-Embedding-8B`, BF16). If the model
weights shift or the checkpoint is withdrawn, the Qwen3 side of our
hybrid retriever is not reproducible. Mitigation: all benchmark numbers
are also reproducible from pure ByT5 (LeanDojo), at the cost of
$\approx 2$–$4$ pass@$8$ points.

**L3 — Leiden stochasticity.** Leiden with random seed $42$ is
deterministic per run, but the *semantic* labels on communities
(Section $5$) are human assignments. Jaccard-stability between runs is
$\geq 0.87$ for $14$-macro-subsystems but individual theorems drift
across seeds. A fully deterministic label assignment would require
either a deterministic centroid-first Voronoi re-projection or a
consensus-over-seeds step; neither is in the current pipeline.

**L4 — Held-out leakage risk.** The $200$ held-out theorems were
moved after the fact. If any held-out theorem's *docstring* mentions
its target lemma, the retriever can cheat via docstring-to-embedding
leakage. We audit for this — any held-out theorem whose top-$1$
retrieved premise equals its own ground-truth target via docstring
alone is flagged and excluded. Current audit count: $12$ of $200$
flagged, $188$ retained.

**L5 — No RLHF on the prover.** We do not fine-tune the prover on the
retrieved premises. The prover is standard Lean $4.29$ with the
automation stack (`aesop`, `grind`, `exact?`, `omega`, etc.). Adding
RLHF would likely increase pass@$k$ but would obscure the contribution
of the graph topology versus the prover improvements.

## 8.2 Failure modes

**FM1 — Bridge candidates are noise.** The twelve MP-6 bridges are
filtered at $\mathrm{sem} > 0.85$ and $\mathrm{lnk} < 3$. If the
semantic filter is too permissive, bridges will fail to compress real
proofs. We pre-register the canary ($\S 7$) as the sharpest test: if
the canary fails because bridges don't cover the tactic steps, the
filter is too permissive (failure mode F2 in $\S 7.5$).

**FM2 — Fibered structure is a labelling artefact.** The channel
membership is assigned by keyword match on theorem names (`pi`,
`sqrt2`, `catalan`, `sterile`). A more principled assignment would use
the proof-body content or the dependency structure. We argue the
keyword match is a *lower bound* on the fibered structure: if it holds
under the noisy keyword assignment, it will hold more sharply under a
content-driven assignment. A follow-up will verify this.

**FM3 — Non-abelian signal is finite-size.** The $\lambda_1 /
\lambda_2 = 1.038$ result is $3.8\%$ above the abelian null. On a
larger corpus (Mathlib at full $\approx 500$K) the ratio may drift.
Early indications from the $49{,}985$-theorem Mathlib slice show
$\lambda_1 / \lambda_2 \approx 1.051$ — *larger* in Mathlib than in
OmegaTheory V2. If this holds at full Mathlib scale, the non-abelian
signal is a generic feature of typed Lean corpora, not specific to
physics. We will report at full Mathlib scale in a follow-up.

## 8.3 Open questions

**Q1 — Is the $14$-macro-subsystem number theory-specific or
statistical?** The dominant gap at rank $14$ is stable across
$\gamma$. Is it an accident of OmegaTheory V2's sector structure, or
a generic feature of a physics Lean corpus? Testable by applying the
same pipeline to PhysLean.

**Q2 — Does the Pi-Hunch residual ordering extend to four channels?**
We observed $\|v_\pi\|^2 > \|v_G\|^2 > \|v_{\sqrt{2}}\|^2$. The
theory predicts that the four irrationals order as
$\pi > e > G > \sqrt{2}$ by residual-$\delta$ magnitude, but our
current keyword audit has too few `e`-specific theorems to resolve
the $e$ position cleanly ($14$ theorems, all with `exp` or `e_error`
in the name, giving a noisy mean norm). Resolving this is the single
cleanest experiment to run before the camera-ready.

**Q3 — Does the Catalan-$G$ channel carry the sterile-$\nu$ dark-matter
signature?** Navi's MP-5 tags Catalan-$G$ as the 4th channel for
sterile-$\nu$ / dark-matter. The Lean theorems that carry this channel
are a mix of `dark_matter_*` and `sterile_neutrino_*` lemmas. Whether
the sterile-$\nu$ mass derivation ultimately lives in this channel is
an open physics question — see
`V3-for-Lean/substrate_exchange_deep_dive.md` $\S 4$.

**Q4 — Can the `SPECIALIZES` arrow be recovered from proof bodies
alone?** Currently `SPECIALIZES` is populated by the semantic recipe
`V3-for-Lean/code/cypher_recipes/semantic_arrows_v1.cypher` (cosine
similarity + substring constraint). A more rigorous approach would
use Lean's `isDefEq` on the statement level. Worth trying.

**Q5 — What is the *asymptotic* value of $\lambda_1 / \lambda_2$ as
the corpus grows?** If the corpus approaches a fixed-sector
equilibrium (a theoretical upper bound on what OmegaTheory V2 can say
about physics), the Magnetic-Laplacian spectrum should converge. If
the corpus keeps growing (new cycles, new predictions), the spectrum
will drift. A cycle-by-cycle tracking plot would reveal which regime
we're in.

## 8.3a Comparison to graph-augmented Lean retrieval (arXiv:2510.23637)

Lean-Finder plus the graph-augmented follow-up paper arXiv:$2510.23637$
($2025$) report a $+25\%$ improvement over ReProver on standard
retrieval benchmarks. They achieve this through a closed-weight
transformer retriever with a graph-projection layer on top of the
Lean dependency graph. The weights are not public; we cannot
benchmark against them directly.

However, the claims are **orthogonal** and expected to compose:

- arXiv:$2510.23637$ **optimises the retrieval function** — a learned
  embedding with graph-aware loss, operating over a **flat**
  dependency graph where edges are treated homogeneously as
  "depends on".
- V3-for-Lean **restructures the underlying corpus** — a six-entity /
  fifteen-typed-arrow algebra with explicit selection rules, a
  Magnetic-Laplacian decomposition, and FastRP propagation weights
  $\alpha_k$ derived from the spectral residual.

The two papers operate on different abstraction layers. A retriever
of the arXiv:$2510.23637$ kind, trained over the V3-for-Lean typed
graph rather than a flat dependency graph, is the natural composition.
Our empirical evidence ($\S 6.3.3$) is that typed-arrow FastRP adds
$+6$ to $+8$ points R@$5/10$ over a pure dense baseline (Qwen$3$-only);
arXiv:$2510.23637$'s $+25\%$ over ReProver is on a different task
(MiniF2F pass@$1$) and baseline, but both results indicate that graph
signal is a real addition rather than a statistical artefact.

**Our claim relative to arXiv:$2510.23637$.** V3-for-Lean is not
presented as a retrieval-function improvement; it is a
*corpus-structure* contribution. If someone applied the
arXiv:$2510.23637$ retriever over our `LeanAlgebra` schema, the
expected result is a *further* uplift beyond their reported $+25\%$
— because the graph they propagate over is richer. This is a
natural follow-up experiment and we do not claim the composition
result here.

## 8.4 Positive contributions of the fibered result

The most distinctive empirical finding of this paper — that the
four-irrational channel is *fibered over* the Leiden subsystem base
rather than partitioning it — has implications beyond our corpus.

**For theorem-prover corpora generally.** A formalisation that encodes
multiple cross-cutting concerns (e.g. both a sector decomposition and
an irrationality decomposition) should expect a fibered structure, not
a partitioned one. Pipeline designers who insist on a clean partition
are fighting the natural structure of the corpus.

**For Leiden users in mathematics.** Modularity $Q = 0.89$ on a
theorem-prover corpus is high by typical standards
($Q > 0.7$ is considered strong in social-network applications). The
corresponding community structure is therefore meaningful, but it is
orthogonal to *any* single semantic axis. Users who expect Leiden to
pick up a specific axis (e.g. "please find me the QM subsystem") will
be disappointed; Leiden picks up *all* axes at once, fibered.

**For OmegaTheory V2 specifically.** The fibered structure is a
falsifiable property of the Lean formalisation. If a competitor theory
were to formalise an equivalent lattice physics in Lean, its
Magnetic-Laplacian spectrum and community structure could be compared
directly against ours. Dual theories can now be *benchmarked against
each other on typed-graph grounds*, not only on predictive accuracy.

## 8.5 Physics-side implications

We close with the physics-side implications of the graph-side result.

**The Grand Capstone is coherent.** The post-capstone corpus has
$b_0 = 75$ connected components with one giant component ($11{,}201$
nodes). The giant component contains every paper-worthy claim of the
theory (QM, GR, SM, dark energy, Big Bounce, information conservation,
path integral, Bell nonlocality). The $74$ small islands are sandbox
theorems, legacy aliases, and unfinished prototypes. The corpus is not
fragmenting.

**The frontier is concrete.** The $23$ Navi-predicted theorem candidates
($12$ bridges + $7$ duals + $4$ Pi-Hunch frontier) constitute a
*graph-motivated* to-do list for cycles $44$–$60$. A prover that can
close all $23$ closes the shape of the fibration.

**Catalan-$G$ is a first-class channel.** The appearance of Catalan-$G$
in the fibered channel structure is the first empirical trace of the
4th irrational in a formal-library graph. The physics-side prediction
— sterile-$\nu$ dark-matter with a computable mass ratio — is the
natural next theorem to pin down.

**Dimensional consistency.** The non-abelian signal
($\lambda_1 / \lambda_2 = 1.038$) and the UNFOLDS-spine
($\alpha_{\text{UNFOLDS}} = 2.20$) together indicate that the corpus'
reasoning patterns are not separable into commuting blocks. This is
physics-consistent: general covariance and quantum non-commutativity
should leave signatures in how theorems compose, and they do.

## 8.6 Summary

V3-for-Lean is the first V3 adaptation to a theorem-prover corpus.
Its core algebraic / geometric instruments (six entities, fifteen
arrows, Magnetic Laplacian with $g = 1/4$, rank-$2$ decomposition,
FastRP fusion, Leiden at $\gamma = 0.5$) produce three concrete
empirical results: a non-abelian $\lambda_1 / \lambda_2 = 1.038$
signal, a fibered four-channel structure over a $\approx 14$-macro-subsystem
base, and a list of $23$ graph-motivated theorem candidates. The open
questions $\S 8.3$ and the pre-registered canary $\S 7$ define the
shape of the follow-up paper. We hope the release of the ingest
pipeline, the cypher recipes, and the benchmark harness will allow
independent replication on comparable Lean corpora.
