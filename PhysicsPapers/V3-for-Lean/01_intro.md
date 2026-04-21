# 01 — Introduction

## 1.1 OmegaTheory V2 in one paragraph

OmegaTheory V2 is a unified physics formalisation developed by Marchewka
(2026) that derives quantum mechanics, general relativity and the
Standard-Model gauge group $U(1) \times SU(2) \times SU(3)$ from **eight
physical constants** on a $\ell_P \cdot \mathbb{Z}^4$ Planck lattice. The
central thesis — the *Pi Hunch* — is that the irrationality of $\pi$, $e$,
$\sqrt{2}$ (together with Catalan-$G$ as a post-capstone addition) forces a
strictly-positive computational residual

$$
\delta_{\text{comp}}(N) \;=\; \ell_P \cdot \frac{4}{2N+3}
$$

from the Leibniz-series truncation of $\pi$ at iteration budget $N$, and
that this residual *is* the extended Heisenberg lower bound

$$
\Delta x\,\Delta p \;\geq\; \frac{\hbar}{2} + \delta_{\text{comp}}(N).
$$

As of cycle $43$ the Lean 4 library (`LeanFormalizationV2`) contains
$8{,}996$ theorems, $4{,}465$ definitions and $8$ physical axioms, with a
single meta-capstone proposition `omega_theory_v2_final_meta_capstone`
(Polaris) that bundles the entire derivation. The project compiles
$3{,}835$ build-jobs GREEN with $0$ `sorry`s. Three SM fermion generations are
postulated to arise from the residual-$\delta$ ordering

$$
\delta_\pi \sim O(1/N) \;>\; \delta_e \sim O(1/N!) \;>\; \delta_{\sqrt{2}} \sim O(2^{-2^{N}})
$$

with a fourth Catalan-$G$ channel reserved for a sterile-neutrino
dark-matter sector. The first experimental prediction — a $T^{-2.5}$ power-law
gate-fidelity scaling $F(T) = F_0/(1 + \alpha T)$ — was independently
confirmed by Diraq / Huang et al., *Nature* 627, 772–777 (2024).

## 1.2 The V3 framework in one paragraph

The V3 framework (Marchewka 2026, originally formulated for software-system
architecture knowledge graphs) couples three ingredients:

1. A **typed multigraph** schema with a small number of entity types and a
   larger number of typed arrows equipped with algebraic selection rules
   (HARD-BLOCK forbidden compositions).
2. A **Magnetic Laplacian** $\mathfrak{A} \in \mathbb{C}^{n\times n}$
   (Hermitian, phase parameter $g$) whose per-relation rank-$2$ decomposition
   captures non-commutativity between arrow types as imaginary phase.
3. A **FastRP + Leiden + $K$-means + consensus** pipeline that turns the
   typed multigraph plus Laplacian phase into a dense node embedding suitable
   for community detection, link prediction and retrieval-augmented
   reasoning.

V3 succeeds on system-architecture graphs precisely because realistic
architectures are *not* strongly partitioned: modules are fibered over
capabilities, not separated from them. The Lean theorem-prover setting
is the first domain in which we apply V3 outside software.

## 1.3 Why couple V3 to a theorem-prover corpus?

The dominant retrieval-augmented proof synthesis frameworks for Lean 4 —
LeanDojo / ReProver (Yang et al., NeurIPS 2023), Magnushammer (Mikuła et al.,
2023), Lean-Finder (2025, hosted-only closed-weights), Premise-Selection-for-a-Lean-Hammer
(arXiv:2506.07477), LeanAgent (Kumarappan et al., ICLR 2025) and Rango
(Thompson et al., ICSE 2025) — all treat the proof-state × premise problem as
a dense-retrieval problem: compute a query vector from the goal, retrieve the
top-$k$ nearest lemmas, feed them to a prover. The graph is used — if at all —
only for premise filtering.

We claim that the **typed dependency graph itself** carries independent
signal that is lost in a pure dense-retrieval approach:

- **Typed arrows** (`APPLIES`, `UNFOLDS`, `SPECIALIZES`, `REWRITES_BY`,
  `INSTANTIATES`, `HAS_TYPE`, $\ldots$ — fifteen in total) distinguish
  structural from semantic from type-theoretic relationships; a flat
  "depends on" edge collapses this into noise.
- **Selection rules** encode algebraic laws that a valid proof-chain must
  respect (e.g. `REWRITES_BY` cannot compose with `HAS_TYPE`); they prune
  the search space at the algebra level.
- **Magnetic-Laplacian non-commutativity** measures to what degree the
  arrow landscape is abelian — a low value indicates that order of
  application matters, which is precisely the condition under which
  commutative retrieval misses the point.
- **Leiden community structure** identifies proof subsystems that are
  semantically close but structurally under-linked — *bridge candidates*,
  the theorem-prover analogue of under-theorised scientific subfields.

The V3-for-Lean paper is the first published application of these
instruments to a nine-thousand-theorem physics corpus with full proof bodies
and embeddings.

## 1.4 Contributions

This paper makes five contributions.

**C1. The V3 schema for Lean.** We define `LeanAlgebra`, a six-entity,
fifteen-typed-arrow, twelve-composition schema with seven selection rules.
The schema is an algebraic law, not data: it describes the *shape* of
Lean-as-graph without committing to any individual theorem.

**C2. The Magnetic Laplacian for a theorem corpus.** We give the first
rank-$2$ Magnetic-Laplacian decomposition of a Lean 4 library, measure
the principal spectrum on $11{,}921$ nodes, and report the first
$\lambda_1/\lambda_2 = 1.038$ degeneracy-breaking that is inconsistent
with any abelian substrate.

**C3. Fibered community structure.** Leiden at $\gamma = 0.5$ gives
modularity $Q = 0.89$ on $116$ communities with *no sharp four-band gap*.
We show that the four-irrational channel $\{\pi, e, \sqrt{2}, G\}$ is
**fibered over** the Leiden base rather than partitioning it — the
channel-wise FastRP norm ordering matches the residual-$\delta$
ordering of the Pi Hunch. This is a positive, falsifiable prediction
about how a post-capstone formalisation is internally structured.

**C4. Twenty-three predicted bridge / dual / frontier theorems.**
Eight categorical, homological and spectral passes (MP-1 through MP-8 in
the companion Grothendieck memo) identify concrete `TheoremCandidate` nodes
missing from the corpus: twelve FastRP-predicted bridge theorems between
under-connected Leiden communities, seven missing left/right dual fermion
doublets, and four Pi-Hunch frontier statements (tightness, saturation,
uniqueness, stability of the extended Heisenberg bound).

**C5. A reproducible benchmark and pipeline.** We release the Neo4j
ingest scripts (`DumpDeclarations.lean`, `DumpArrows.lean`,
`load_declarations_env_v2.py`, `load_arrows_parallel.py`), the
Magnetic-Laplacian computation recipes, the $1472$-d embedding re-projection
(`reembed_omega_qwen3_v2.py`), a MiniF2F-v2 harness and an OmegaTheory
held-out benchmark suite. All numbers in this paper are reproducible from
a fresh Lean build.

## 1.5 Paper structure

Section $2$ surveys related work on premise selection, conjecture generation,
and graph-based retrieval for interactive theorem provers. Section $3$
defines the `LeanAlgebra` schema and the Magnetic-Laplacian algebraic lens.
Section $4$ details the Qwen3-8B embedding stack and its substitution for
Lean-Finder. Section $5$ documents the Erdős-tier SubsystemNavigator
enrichment. Section $6$ reports the MiniF2F-v2 and OmegaTheory-held-out
experimental results. Section $7$ presents the `einstein_tensor_emergence`
canary: a target for compressing a $172$-line proof to under $100$ lines via
bridge-theorem routing. Section $8$ discusses limitations, failure modes
and open questions.

The complete GraphRAG recipe, the $969$-line Grothendieck Math Puzzle
that motivates twenty-three of the predicted theorem candidates, and the
five long-form research memos that drive the physics-side agenda all live
under `V3-for-Lean/` and `OmegaTheoryAlgebra/` in the project repository.
