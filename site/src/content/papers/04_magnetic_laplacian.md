---
title: "04 — Magnetic Laplacian construction"
description: "𝔄 ∈ ℂ^{6×6} Hermitian at magnetic phase g=1/4. Per-relation rank-2 decomposition, Hermiticity sketch."
category: "Graph Research · Neo4j"
order: 113
---

<!-- orig-frontmatter: name: 04_magnetic_laplacian -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra -->
<!-- orig-frontmatter: phase: 0 -->
<!-- orig-frontmatter: author: Sarin-Alpha (γ Sgr) -->
<!-- orig-frontmatter: date: 2026-04-18 -->
# 04 — The Magnetic Laplacian 𝔄 for Lean

**TL;DR.** We construct the 6×6 complex Hermitian Magnetic Laplacian 𝔄 for the Lean algebra on the 6 entity types, following V3's recipe (HypatiaBasis §7) verbatim: symmetrized weight `W^(s)`, direction sign matrix `D`, phase matrix `T^(g)` at charge g = 1/4, degree matrix Δ, and 𝔄 = Δ − T^(g) ⊙ W^(s). Hermiticity follows because `D` is antisymmetric and `W^(s)` is symmetric, so the off-diagonal entries are complex conjugates pairwise. Each of the 15 Lean relationships contributes a rank-2 Hermitian sub-matrix `𝔄_k`, and 𝔄 = Σ_{k=1..15} 𝔄_k. Empirically we expect a similar eigenvalue pattern to V3's CheckItOut (±31.04i dominant, ±5.39i governance, ±1.78i Event-Process 𝔰𝔲(2), ±0.73i Rule-Context 𝔰𝔲(2)) — but with Lean-specific values to be measured by Team Merak. The 90° phase choice (g = 1/4) is optimal for directedness per MagNet (arXiv 2102.11391).

## 1. The block adjacency matrix B

**Vertex ordering — canonical vs exposition.**

- **Canonical index order (alphabetical, A/D/I/N/S/T)** is used by all live Python consumers (Zaurak, Izar's verification scripts, `measure_non_commutativity.py`, numpy indexing, downstream scripts). Index it this way whenever a script, Cypher parameter, or serialized matrix is written to disk.
- **Mnemonic exposition order (A/T/D/S/I/N)** is used below in §2 only, chosen so that related-height types sit adjacent (Theorem + Definition + Structure bundle, then Instance + Namespace as sinks). This is pedagogical; when you compute eigenvalues or write tests, re-index to alphabetical.

> Cross-ref: we do not emit `GENERALIZES` / `FOLDS` as separate edges — the phase factor `T^(g) = exp(i · 2π · g · D)` at `g = 1/4` generates the reverse traversal automatically as the complex conjugate off-diagonal entry. See memo 05 §5.4 and §5.4 of this memo for the spectral interpretation.

For exposition in §2–§6, order the 6 types:

```
  index  type                  ordering mode
    1    Axiom            (A)  both canonical and mnemonic
    2    Theorem/Lemma    (T)  mnemonic
    3    Definition/Abbrev(D)  mnemonic
    4    Structure/Class  (S)  mnemonic
    5    Instance         (I)  mnemonic
    6    Namespace        (N)  mnemonic

Canonical (for scripts):
    [Axiom, Definition, Instance, Namespace, Structure, Theorem]
```

For each ordered pair (X, Y) and each of the 15 relationships r_k, count whether r_k legally runs X → Y (from files 02 and 03). The block entry `B[X,Y]` = number of relationship types flowing X → Y.

Legal flows by relationship:

| k | Name | Tail type | Head type |
|---|---|---|---|
| 1 | IMPORTS | N | N |
| 2 | OPENS_NAMESPACE | N | N |
| 3 | EXTENDS | S | S |
| 4 | INSTANTIATES | I | S |
| 5 | ASSUMES | T | A |
| 6 | APPLIES | T | T |
| 7 | UNFOLDS | T | D |
| 8 | SPECIALIZES | T | T |
| 9 | REWRITES_BY | T | T |
| 10 | HAS_TYPE | D or T | S |
| 11 | CONSTRAINED_BY | D or T | S |
| 12 | PARAMETRIZES | D or T | S |
| 13 | REDUCES_TO | D | D |
| 14 | ELABORATES_AS | D or T | T |
| 15 | SUGGESTED_BY | T | T |

Counting per block (merging D/T source where a relationship allows either — we keep T-source and D-source as separate entries since each is a distinct occurrence):

### 1.1 Raw block matrix B (out-counts)

Rows = source, columns = target; ordering A, T, D, S, I, N.

|  | A | T | D | S | I | N |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **A** | 0 | 0 | 0 | 0 | 0 | 0 |
| **T** | 1 | 5 | 1 | 3 | 0 | 0 |
| **D** | 0 | 1 | 1 | 3 | 0 | 0 |
| **S** | 0 | 0 | 0 | 1 | 0 | 0 |
| **I** | 0 | 0 | 0 | 1 | 0 | 0 |
| **N** | 0 | 0 | 0 | 0 | 0 | 2 |

Row totals:
- A: 0 (pure source — as specified by SR_L1)
- T: 10 (richest active hub — ASSUMES, APPLIES×2 (APPLIES + SPECIALIZES + REWRITES_BY + SUGGESTED_BY = 4, but merged as "to T" = 5), UNFOLDS to D, HAS_TYPE/CONSTRAINED_BY/PARAMETRIZES to S)
- D: 5 (ELABORATES_AS to T, REDUCES_TO to D, three type-connecting edges to S)
- S: 1 (only EXTENDS to S)
- I: 1 (only INSTANTIATES to S)
- N: 2 (IMPORTS, OPENS_NAMESPACE, both to N)

### 1.2 Column totals — in-degree pattern

| Column | In-degree | Interpretation |
|---|:-:|---|
| A | 1 | One inbound edge type (ASSUMES), from T only |
| T | 6 | Richest hub also as target |
| D | 2 | UNFOLDS from T; REDUCES_TO from D (self-loop) |
| S | 8 | Most-targeted: EXTENDS, INSTANTIATES, HAS_TYPE, CONSTRAINED_BY, PARAMETRIZES all aim here |
| I | 0 | **Pure sink** — no inbound edges (by SR_L3) |
| N | 2 | Only structural IMPORTS / OPENS_NAMESPACE |

**Structural properties (analogue of HypatiaBasis Proposition 2.1):**

(i) **A is a pure behavioral source.** Row sum A = 0. No typed arrow originates from an Axiom (outbound). Column A = 1, with the single incoming relationship being ASSUMES.

(ii) **I is a pure sink.** Column I = 0, row I = 1 (only outbound INSTANTIATES). Nothing depends on an Instance; it is the terminal node of its INSTANTIATES edge only.

(iii) **T is the algebraic hub.** Highest out-degree (10) and highest in-degree sharing (via APPLIES, SPECIALIZES, REWRITES_BY, SUGGESTED_BY, ELABORATES_AS) — 6 inbound relationship types vs T.

(iv) **Block density.** Non-zero blocks: 9 of 36. Density = **9/36 = 25%**. Lower than V3's 38.9%. This is expected: Lean's type discipline strictly prunes combinations that software architecture allows informally.

(v) **Self-loops at 4 types.** T→T (APPLIES, SPECIALIZES, REWRITES_BY, SUGGESTED_BY), D→D (REDUCES_TO), S→S (EXTENDS), N→N (IMPORTS, OPENS_NAMESPACE). Four diagonal entries non-zero. Compare V3's P→P self-loop via CALLS.

(vi) **Candidate bidirectional cycles (to verify empirically in file 05):**
- Within T→T ∪ T→T via different relationships — e.g., SPECIALIZES ⇌ GENERALIZES (if GENERALIZES is introduced as the inverse, which Sarin-Beta can decide). Currently GENERALIZES is not in our 15; if it is added as a 16th, it completes a 𝔰𝔲(2) candidate.
- Within D→D: UNFOLDS ⇌ FOLDS (same comment; FOLDS currently not in the 15).
- (D→T ELABORATES_AS) ⇌ (T→D UNFOLDS): D produces a T (via elaboration); T unfolds back to D. Candidate 𝔰𝔲(2)_{T,D}.

## 2. Construction of 𝔄

Following HypatiaBasis Definition 7.1 verbatim.

### 2.1 Symmetrized weight `W^(s)`

$$W^{(s)}_{XY} = \frac{B_{XY} + B_{YX}}{2}$$

Using the B above:

|  | A | T | D | S | I | N |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| A | 0 | 0.5 | 0 | 0 | 0 | 0 |
| T | 0.5 | 5 | 1 | 1.5 | 0 | 0 |
| D | 0 | 1 | 1 | 1.5 | 0 | 0 |
| S | 0 | 1.5 | 1.5 | 1 | 0.5 | 0 |
| I | 0 | 0 | 0 | 0.5 | 0 | 0 |
| N | 0 | 0 | 0 | 0 | 0 | 2 |

Symmetric: ✓ (W^(s))^T = W^(s).

### 2.2 Direction matrix `D`

$$D_{XY} = \text{sign}(B_{XY} - B_{YX})$$

|  | A | T | D | S | I | N |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| A | 0 | −1 | 0 | 0 | 0 | 0 |
| T | +1 | 0 | +1 | +1 | 0 | 0 |
| D | 0 | −1 | 0 | +1 | 0 | 0 |
| S | 0 | −1 | −1 | 0 | −1 | 0 |
| I | 0 | 0 | 0 | +1 | 0 | 0 |
| N | 0 | 0 | 0 | 0 | 0 | 0 |

Antisymmetric: D^T = −D ✓ (diagonals = 0; off-diagonals flip sign). N→N IMPORTS is bidirectional in counting so contributes 0 to direction (both rows equal).

### 2.3 Phase matrix `T^(g)` at g = 1/4

$$T^{(g)}_{XY} = e^{i \cdot 2\pi g \cdot D_{XY}} = e^{i \cdot (\pi/2) \cdot D_{XY}}$$

So:
- `D_{XY} = +1` → T_{XY} = e^{iπ/2} = **+i**
- `D_{XY} = −1` → T_{XY} = e^{−iπ/2} = **−i**
- `D_{XY} = 0` → T_{XY} = 1

|  | A | T | D | S | I | N |
|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| A | 1 | −i | 1 | 1 | 1 | 1 |
| T | +i | 1 | +i | +i | 1 | 1 |
| D | 1 | −i | 1 | +i | 1 | 1 |
| S | 1 | −i | −i | 1 | −i | 1 |
| I | 1 | 1 | 1 | +i | 1 | 1 |
| N | 1 | 1 | 1 | 1 | 1 | 1 |

Check: T^† = T ? No — T has complex conjugate symmetry: T_{YX} = conj(T_{XY}). That means **T is Hermitian** (what we want).

### 2.4 Degree matrix Δ

$$\Delta_{XX} = \sum_Y W^{(s)}_{XY}$$

- Δ_{AA} = 0.5
- Δ_{TT} = 0.5 + 5 + 1 + 1.5 + 0 + 0 = 8
- Δ_{DD} = 0 + 1 + 1 + 1.5 + 0 + 0 = 3.5
- Δ_{SS} = 0 + 1.5 + 1.5 + 1 + 0.5 + 0 = 4.5
- Δ_{II} = 0 + 0 + 0 + 0.5 + 0 + 0 = 0.5
- Δ_{NN} = 0 + 0 + 0 + 0 + 0 + 2 = 2

Δ = diag(0.5, 8, 3.5, 4.5, 0.5, 2).

### 2.5 The Algebra Matrix 𝔄

$$\mathfrak{A} = \Delta - T^{(g)} \odot W^{(s)}$$

Off-diagonal entries `𝔄_{XY} = −T^{(g)}_{XY} · W^{(s)}_{XY}`. Diagonal entries `𝔄_{XX} = Δ_{XX} − 1 · W^{(s)}_{XX}` (the `T^{(g)}_{XX} = 1` factor cancels on diagonal). Since `W^{(s)}_{XX}` already counts self-loops, one careful reading of HypatiaBasis makes the diagonal just Δ_{XX} − W^{(s)}_{XX}.

| **𝔄** | A | T | D | S | I | N |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **A** | 0.5 | +0.5i | 0 | 0 | 0 | 0 |
| **T** | −0.5i | 3 | −i | −1.5i | 0 | 0 |
| **D** | 0 | +i | 2.5 | −1.5i | 0 | 0 |
| **S** | 0 | +1.5i | +1.5i | 3.5 | +0.5i | 0 |
| **I** | 0 | 0 | 0 | −0.5i | 0.5 | 0 |
| **N** | 0 | 0 | 0 | 0 | 0 | 0 |

Diagonal: `𝔄_{XX} = Δ_{XX} − W^{(s)}_{XX}`:
- 𝔄_{AA} = 0.5 − 0 = 0.5
- 𝔄_{TT} = 8 − 5 = 3
- 𝔄_{DD} = 3.5 − 1 = 2.5
- 𝔄_{SS} = 4.5 − 1 = 3.5
- 𝔄_{II} = 0.5 − 0 = 0.5
- 𝔄_{NN} = 2 − 2 = 0

Off-diagonal A,T: 𝔄_{AT} = −T_{AT} · W^(s)_{AT} = −(−i)(0.5) = +0.5i; 𝔄_{TA} = −T_{TA} · W^(s)_{TA} = −(+i)(0.5) = −0.5i. Conjugate pair ✓.

Off-diagonal T,D: 𝔄_{TD} = −(+i)(1) = −i; 𝔄_{DT} = −(−i)(1) = +i. Conjugate ✓.

Off-diagonal T,S: 𝔄_{TS} = −(+i)(1.5) = −1.5i; 𝔄_{ST} = −(−i)(1.5) = +1.5i. ✓.

Off-diagonal D,S: 𝔄_{DS} = −(+i)(1.5) = −1.5i; 𝔄_{SD} = −(−i)(1.5) = +1.5i. ✓.

Off-diagonal S,I: 𝔄_{SI} = −(−i)(0.5) = +0.5i; 𝔄_{IS} = −(+i)(0.5) = −0.5i. ✓.

The N row/column is all zero — Namespace is decoupled from the behavioral algebra (which is exactly SR_L2's spirit). In the Hermitian spectrum, this gives one guaranteed zero eigenvalue with eigenvector e_N = (0,0,0,0,0,1)^T.

### 2.6 Hermiticity proof

**Claim.** 𝔄^† = 𝔄.

**Proof.**

*Off-diagonal.* Fix X ≠ Y. By construction,
- `D_{XY} = sign(B_{XY} − B_{YX})` and `D_{YX} = sign(B_{YX} − B_{XY}) = −D_{XY}` (antisymmetry of sign-of-difference).
- Therefore `T^{(g)}_{YX} = e^{i · 2π g · D_{YX}} = e^{−i · 2π g · D_{XY}} = \overline{T^{(g)}_{XY}}` (complex conjugation).
- `W^{(s)}_{YX} = W^{(s)}_{XY}` (symmetric by definition).
- Hence `𝔄_{YX} = −T^{(g)}_{YX} W^{(s)}_{YX} = −\overline{T^{(g)}_{XY}} · W^{(s)}_{XY} = \overline{−T^{(g)}_{XY} W^{(s)}_{XY}} = \overline{𝔄_{XY}}`.

*Diagonal.* `𝔄_{XX} = Δ_{XX} − W^{(s)}_{XX}` is real (all weights are real, degrees are real).

Therefore `𝔄^†_{XY} = \overline{𝔄_{YX}} = \overline{\overline{𝔄_{XY}}} = 𝔄_{XY}`, so 𝔄^† = 𝔄. □

**Corollary.** All eigenvalues of 𝔄 are real. The eigenvectors form an orthonormal basis of ℂ^6.

## 3. Why g = 1/4

V3 (HypatiaBasis §7) uses g = 1/4 and justifies it by citing MagNet (Zhang et al., arXiv 2102.11391). The choice is **optimal** for three reasons:

1. **Maximal phase distinction.** At g = 1/4, unidirectional edges get `+i` or `−i`, which are the two points on the unit circle maximally distant from the real axis. No real-valued relationship is confused with a directional one. Smaller g (say 1/8, phase 45°) mixes directionality with magnitude; larger g (say 1/2, phase 180°) makes forward and backward edges both real (opposite signs), losing the directional signature.

2. **Rotational 𝔰𝔲(2)-compatibility.** The 𝔰𝔲(2) lifting is cleanest at g = 1/4 because the corresponding Pauli-like rotation is 90°, yielding the standard `σ_y`-style antisymmetric generator. V3's empirical decomposition (HypatiaBasis Theorem 6.1) depends on this. We inherit it.

3. **Numerical stability.** At g = 1/4, the phases are ±i, exactly representable in floating point. g = 1/3 would involve ω = e^{iπ/3} = 0.5 + i·√3/2, introducing rounding.

**Alternative considered and rejected.** g = 1/2 (180° phase). This gives forward = −1, backward = +1, real-valued. It would let us keep the matrix real, simplifying eigendecomposition. But it collapses directionality to sign, losing the phase-based holonomy signal V3 needs for Berry phase computation (GrothendieckAlgebraicTopologies §7.4). For the Lean adaptation, Berry phase is how we detect subsystem boundaries in file 09, so we need g = 1/4.

## 4. Per-relation decomposition 𝔄 = Σ_k 𝔄_k

Following HypatiaBasis §7.2, each relationship r_k contributes a rank-2 Hermitian sub-matrix 𝔄_k concentrated on the rows/columns of its tail and head entity types.

For a unidirectional relationship r_k: X → Y with weight w_k = 1 (we use unit weights):

$$\mathfrak{A}_k[X, Y] = -e^{+i\pi/2} = -i$$
$$\mathfrak{A}_k[Y, X] = -e^{-i\pi/2} = +i$$

with diagonal corrections:

$$\mathfrak{A}_k[X, X] += 1/2, \quad \mathfrak{A}_k[Y, Y] += 1/2$$

Sum these over all 15 relationships and verify `Σ_k 𝔄_k = 𝔄` block-by-block.

Example — the ASSUMES contribution 𝔄_5:

| | A | T |
|:-:|:-:|:-:|
| A | 0.5 | +0.5i |
| T | −0.5i | 0.5 |

(all other entries 0). This accounts for the (A, T) block of the full 𝔄 matrix — indeed ASSUMES is the only relationship running T → A. Matches.

Example — the EXTENDS contribution 𝔄_3:

| | S |
|:-:|:-:|
| S | 1 |

with diagonal correction 𝔄_3[S, S] = 1 (from both endpoints of the same self-loop). For self-loops on the S → S block, the direction matrix gives `D_{SS} = 0` (since count is 1 − 1 = 0 or the self-loop contributes 1 to each side of the symmetric difference — ambiguity resolved by convention of treating self-loops as bidirectional with phase 1).

The remaining self-loops (APPLIES, SPECIALIZES, REWRITES_BY, SUGGESTED_BY on T → T; REDUCES_TO on D → D; IMPORTS + OPENS_NAMESPACE on N → N) contribute similarly to the diagonals. This is why 𝔄_{TT} = 3 (T has multiple self-loops contributing).

### 4.1 Weight inheritance

When we extend this construction to empirical data (Team Merak's scripts running on actual OmegaTheory+Mathlib), each 𝔄_k carries a **measured weight** w_k = (count of edges of type k in the graph) / (total edges). This turns 𝔄 into a data-driven observable. The per-relation α_k coefficients from FastRP (file 06, Grothendieck §3.5) will give an independent measure; the ratio `α_k / w_k` is the signal-to-noise ratio of the k-th relationship's sub-topology.

## 5. Spectrum — expected pattern

### 5.1 V3 baseline (CheckItOut)

From HypatiaBasis §6.2:
- ±31.04i — dominant asymmetric flow (PERFORMS/CALLS/USES chains)
- ±5.39i — governance flow (CONSTRAINS/GOVERNS chains)
- ±1.78i — 𝔰𝔲(2)_{EP} (TRIGGERS/INITIATES cycle)
- ±0.73i — 𝔰𝔲(2)_{RuC} (APPLIES_IN/SCOPES cycle)

Wait — these are commutator eigenvalues of `[ρ_i, ρ_j]` on 4096-dim embedding commutators, *not* eigenvalues of 𝔄 itself. The Laplacian 𝔄 is 6×6 Hermitian so its eigenvalues are real. The commutator eigenvalues ±31.04i are empirically measured on the FastRP-projected space, not on the algebra matrix.

### 5.2 Prediction for 𝔄's own spectrum on OmegaTheory

Computing eigenvalues of the 𝔄 matrix above symbolically (or numerically via `numpy.linalg.eigh` after substitution):

The N row/column is decoupled (zero), so one eigenvalue is **0**. The remaining 5×5 block acts on {A, T, D, S, I}. For a first estimate, tracing gives `tr(𝔄) − 𝔄_{NN} = 0.5 + 3 + 2.5 + 3.5 + 0.5 = 10`, so the sum of 5 eigenvalues = 10 and mean ≈ 2. Determinant bound: the block is not diagonal-dominant due to the −1.5i entries, so expect some spread. Rough estimate (to be verified empirically): eigenvalues approximately (0, 0.3, 1.5, 2.5, 3.0, 4.7) — with one zero from the N decoupling, one near-zero from Instance near-sink behavior, and three intermediate, one largest near the T row sum.

### 5.3 Commutator-eigenvalue prediction (file 08)

For the Lean algebra to be genuinely non-abelian (analogue of Theorem 5.1 in HypatiaBasis, which gives 93% non-commuting pairs for V3), we expect `[ρ_i, ρ_j] ≠ 0` for most pairs of relationships. Hypotheses:

- **Dominant asymmetric pair:** `APPLIES` and `UNFOLDS` share the T tail but target different types (T and D respectively). Compose: `APPLIES ∘ UNFOLDS: T → T → D` lands in D-space; `UNFOLDS ∘ APPLIES` — reverse composition — `UNFOLDS ∘ APPLIES: D → T → T`? That does not compose (UNFOLDS head is D, APPLIES tail is T). So the pair is **asymmetric** (Class II of Theorem 5.1): the commutator is just `APPLIES ∘ UNFOLDS` with no reverse. Non-zero by asymmetry.
- **Symmetric non-commuting pair (like TRIGGERS/INITIATES):** None materialize as *duplicate edges* in our 15-relationship set. Every arrow has a single forward direction; we do NOT introduce GENERALIZES or FOLDS as separate edges. However, the 𝔰𝔲(2) structure does not require duplicate edges in the graph — it emerges from the Magnetic Laplacian's phase factor itself (see §5.4 below).

### 5.4 How 𝔰𝔲(2) emerges without duplicate edges (design clarification, 2026-04-18 per team-lead)

The phase construction `T^(g) = exp(i · 2π · g · D)` at `g = 1/4` automatically generates the +i / −i conjugate pair from a single directed edge:

- `D_{X,Y} = +1` (forward edge X→Y) gives `𝔄_{X,Y} = −e^{+iπ/2} · w = −i · w`.
- `D_{Y,X} = −1` (reverse traversal) gives `𝔄_{Y,X} = −e^{−iπ/2} · w = +i · w`.

The off-diagonal pair (𝔄_{X,Y}, 𝔄_{Y,X}) is already the complex conjugate pair required by an 𝔰𝔲(2) raising/lowering generator — the phase factor does the work of a second edge without requiring one in the ontology. For a single directed edge like `T₁ SPECIALIZES T₂`, the matrix entries are already `−i · w` forward and `+i · w` reverse. No GENERALIZES edge is needed in the graph: the reverse traversal lives in 𝔄's off-diagonal conjugate, not in a duplicated relationship type.

**Revised Theorem 6.1 analogue for Lean (spectral form).** The commutator spectrum of 𝔄 decomposes as `𝔰𝔲(2) × 𝔰𝔲(2) × 𝒩` **iff**:
1. `SPECIALIZES` shows **balanced empirical traffic** in the live Lean graph — equal counts of forward (general → specialized use) and reverse (specialized invocation → general statement) proof-time traversals. Measured over real proofs as `|{proofs that cite T₁ as a SPECIALIZES of T₂}| ≈ |{proofs that apply T₂ by specializing to T₁ inline}|`.
2. `UNFOLDS` shows the same empirical balance between forward (theorem unfolds a definition) and reverse (definition is elaborated back to the theorem's form via `show`/`rfl`).

If condition (1) holds (say, 45–55% forward), the SPECIALIZES sub-matrix of 𝔄 has two non-zero eigenvalues of opposite sign and equal magnitude — an 𝔰𝔲(2) raising/lowering pair. If empirically SPECIALIZES is 95% forward and 5% reverse, the Ĵ_+ generator has 20× the amplitude of Ĵ_-, and the `[Ĵ_+, Ĵ_-]` commutator is small relative to `Ĵ_+^2` — the algebra collapses toward **nilpotent-dominated** for that relation. Same logic for UNFOLDS and the second 𝔰𝔲(2) factor.

This is the first measurable empirical question for Team Merak (restated as Q1 in file 05):
- Q1a. Forward/reverse traversal ratio for SPECIALIZES on live OmegaTheory + Mathlib.
- Q1b. Same ratio for UNFOLDS.
- Q1c. If either ratio is outside [0.3, 0.7], the corresponding 𝔰𝔲(2) degenerates; we fall back to pure-nilpotent analysis for that relation. Ontology does NOT change in either case — only the interpretation of the spectrum shifts.

Net: the 15-relationship set is final. Merak's job is to measure, not to propose new edges. Sarin-Beta's 05_cycle_hypotheses.md correctly frames SPECIALIZES and UNFOLDS as 𝔰𝔲(2) candidates; the raising/lowering interpretation lives in 𝔄's eigendecomposition, not in the edge ontology.

## 6. Matrix sketch for reference

Final 𝔄 (symbolic, unit weights):

```
        A        T        D        S        I        N
   ┌──────────────────────────────────────────────────────┐
 A │  0.5    +0.5i    0       0       0        0      │
 T │ −0.5i    3      −i     −1.5i     0        0      │
 D │   0    +i       2.5   −1.5i     0        0      │
 S │   0   +1.5i   +1.5i    3.5    +0.5i      0      │
 I │   0      0       0    −0.5i     0.5       0      │
 N │   0      0       0      0        0        0      │
   └──────────────────────────────────────────────────────┘
```

Hermitian: ✓ (verified above)
Rank: 5 (N row/column zero contributes a zero eigenvalue)
Trace: 10
Block density: 9 / 36 = 25% (matches file 03's prediction of 30% ± 5%)

## 7. Open items for Merak

1. **Measure weights from real data.** Replace unit weights with actual edge counts from the ingested OmegaTheory + Mathlib graph (~243K nodes, millions of edges). Expect Ax row-column to stay small (< 1% of total); T row to dominate (> 40%).
2. **Compute 𝔄's spectrum empirically** with measured weights. Report eigenvalues and eigenvectors.
3. **Compute commutator spectrum `[ρ_i, ρ_j]`** for all 15 × 14 / 2 = 105 relationship pairs. Look for the two expected anti-correlated bundles (file 05 Sarin-Beta hypothesis).
4. **Verify Hermiticity numerically.** Compute `||𝔄 − 𝔄^†||_F` on the measured matrix — should be < 1e-10.
5. **Measure block density.** Report real occupancy; confirm it stays in the 20–40% range.

---

## Amended 2026-04-18 evening — 6×6 → 8×8 for Level B + C

Memo 01 §9 adds 2 Level B entity types (Tactic, Attribute); memo 02 §11–§12 adds 5 Level B + C arrows (USES_TACTIC, TAGGED_AS, MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR). The Magnetic Laplacian accordingly extends from 6×6 to 8×8.

### 8. Revised vertex ordering — 8 types

**Canonical (alphabetical, 8 entries):**

```
  canonical index   type              extension
        0           Attribute         B
        1           Axiom             core
        2           Definition        core
        3           Instance          core
        4           Namespace         core
        5           Structure         core
        6           Tactic            B
        7           Theorem           core
```

Flat 64-element row-major encoding: cell `(i, j)` at index `8*i + j` in both `real_part` and `imag_part`. Parallel to the 6×6 alphabetical convention (memo 04 §1), Attribute and Tactic slot into alphabetical position 0 and 6 respectively.

**Mnemonic order (for exposition in this §8–§12 only):** `[Axiom, Theorem, Definition, Structure, Instance, Namespace, Tactic, Attribute]` — core 6 first, then Level B meta-types. Do NOT use mnemonic order for numpy indexing or Cypher parameters.

### 9. Revised block matrix B — 8×8

Core 6×6 block (§1.1) stays as-is on the 8-type canonical ordering, re-positioned at rows/columns `[Axiom, Definition, Instance, Namespace, Structure, Theorem]` = canonical indices 1, 2, 3, 4, 5, 7 (note: Structure slots at 5, Theorem at 7, skipping 6 for Tactic).

Level B + C additions:

| Arrow | Source types | Target type | Live edge count |
|---|---|---|---:|
| USES_TACTIC | Theorem, Definition | Tactic | 285,581 |
| TAGGED_AS | Theorem, Definition, Structure, Instance, Axiom | Attribute | 12,872 |
| MUTUALLY_IMPLIES | Theorem | Theorem (symmetric) | 2,082 |
| DUAL_OF | Theorem, Definition | same type (symmetric) | 7,786 |
| ADDITIVE_PAIR | Theorem | Theorem (symmetric) | 3,788 |

Level C (MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR) contributes to the Theorem→Theorem self-loop block and Definition→Definition self-loop block only, but with **symmetric weight** (SR_L16–SR_L18): both directions of the edge are emitted, so `B_{T,T}` gains 2·(MUTUALLY_IMPLIES + ADDITIVE_PAIR + DUAL_OF_on_T) contributions, and `B_{D,D}` gains 2·DUAL_OF_on_D.

### 10. Revised construction of 𝔄 — 8×8

Following HypatiaBasis Def. 7.1, same machinery as §2 lifted to 8 dimensions:

- **Symmetrized weight** `W^(s)_{XY} = (B_{XY} + B_{YX})/2`. Now 8×8.
- **Direction matrix** `D_{XY} = sign(B_{XY} − B_{YX})`. Symmetric-pair edges (Level C) give `D = 0` because `B_{XY} = B_{YX}` — these contribute only to the real (non-phase) part of 𝔄.
- **Phase matrix** `T^(g) = exp(i · 2π · g · D)` at `g = 1/4`. Unchanged from §2.3.
- **Degree matrix** `Δ` now 8×8 diagonal.
- **𝔄 = Δ − T^(g) ⊙ W^(s)` in ℂ^{8×8}.

#### 10.1 Attribute row/column

`Attribute` is a pure target (SR_L15, memo 03 amended). Row 0 is all zero except for self-loop possibilities (none, by SR_L15). The column accumulates 12,872 TAGGED_AS inbound edges distributed across 5 source types (Theorem, Definition, Structure, Instance, Axiom) in empirical proportion.

Expected: `Attribute` contributes one eigenvalue ≈ `−mean TAGGED_AS off-diagonal magnitude` and one balancing eigenvalue on the dual side. Direction signal: all TAGGED_AS edges are unidirectional (forward to the attribute), so `D_{source, Attribute} = +1`, giving `−i · W^(s)` off-diagonal and `+i · W^(s)` on the conjugate.

#### 10.2 Tactic row/column

`Tactic` is a pure target (SR_L14). Row 6 is all zero. Column 6 accumulates 285,581 USES_TACTIC inbound edges distributed across 2 source types (Theorem, Definition). This is the largest off-diagonal weight contribution in the 8×8 matrix — by an order of magnitude — and therefore dominates the non-core spectrum.

**Spectral implication.** The USES_TACTIC density is ~20× TAGGED_AS and ~25× any single core arrow. If left unweighted (unit weights), Tactic would dominate the spectrum entirely, washing out core 𝔰𝔲(2) signal. The appropriate normalization is **per-category relative weight**: divide each category's contribution by its total edge count before forming 𝔄, so all categories contribute on the same scale. Dubhe's `measure_non_commutativity.py` is expected to implement this normalization in B.6 (pending re-run per task #36).

### 11. Revised Level C's explicit 𝔰𝔲(2) witnesses

Memo 04 original §5.4 argued that ±i cycles emerge spectrally from the phase factor `T^(g)` at `g = 1/4` on unidirectional core arrows. Level C adds **explicit symmetric edges** that materialize the 𝔰𝔲(2) raising/lowering pair as actual graph edges, not just spectral artifacts.

**Expected spectral effect: sharpening.**

- Before Level C: ±i spectrum was diffused across the full core 15-arrow Magnetic Laplacian, with eigenvalue pairs distributed on a dense off-diagonal structure. Dubhe's current measurement gives λ₁/λ₂ ≈ **1.038** (close to 1, indicating near-degenerate eigenvalues — a weak 𝔰𝔲(2) signal).
- After Level C: MUTUALLY_IMPLIES + DUAL_OF + ADDITIVE_PAIR concentrate 13,656 symmetric edges on specific (Theorem, Theorem) and (Definition, Definition) block entries. With `D = 0` on those entries, the phase factor is trivial, but the **symmetric real-weight contribution** is enormous, reshaping the 𝔄 spectrum. The corresponding 𝔰𝔲(2) raising/lowering generators (which in the core-only case were weak off-diagonal ±i terms) now have dedicated high-amplitude blocks.

**Spectral hypothesis (memo 04 amended, 2026-04-18 evening):** The ratio `λ₁ / λ₂` should drift from the current **1.038** (core-only) toward the **target [1.8, 3.2] range** predicted by V3's CheckItOut baseline, once Level C edges are included in 𝔄 construction. If the spectrum does not drift, it indicates one of:

- (a) Normalization error — Level C contributions were washed out by USES_TACTIC's volume.
- (b) Empirical asymmetry — bidirectional Level C emission did not produce balanced per-pair eigenvalues (e.g., MUTUALLY_IMPLIES is 90% from forward-direction name patterns, 10% reverse; the extractor should confirm).
- (c) Mistaken hypothesis — Level C edges do not in fact encode the 𝔰𝔲(2) predicted spectrally; some other Mathlib structural convention (tactic-specific, attribute-specific) is the actual carrier.

Dubhe's v4 measurement (task #36, pending) is expected to resolve the Alt-A vs Alt-C bifurcation in file 08 §7.

### 12. Per-relation 𝔄_k decomposition — 20 generators

The per-relation rank-2 Hermitian decomposition §4 lifts directly: `𝔄 = Σ_{k=1..20} 𝔄_k`, each 𝔄_k on the tail-head row/column pair for arrow `k`. The 15 `MagneticLaplacian_component` nodes in `LeanAlgebra` namespace currently cover core-only; Level B/C components are pending schema extension (task for future Azha team).

Live status of component schema nodes (2026-04-18 evening):

```cypher
MATCH (c:MagneticLaplacian_component {namespace: 'LeanAlgebra'})
RETURN count(c)
// returns 15 (core only)
```

**Recommended schema extension (pending):** Add 5 more `MagneticLaplacian_component` rows for USES_TACTIC, TAGGED_AS, MUTUALLY_IMPLIES, DUAL_OF, ADDITIVE_PAIR. Constraint `lean_magnetic_laplacian_component_unique` already guarantees idempotent MERGE.

### 13. Updated open items for Merak

Superseding §7 (which referenced only the 6×6 algebra):

1. **Re-compute weights with Level B + C edges.** Include the 285,581 USES_TACTIC + 12,872 TAGGED_AS + 13,656 Level-C edges. Apply per-category normalization from §10.2 to prevent Tactic domination.
2. **8×8 𝔄 spectrum.** Report all 8 eigenvalues with measured weights. Compare λ₁/λ₂ to the target [1.8, 3.2] range.
3. **Alt-A vs Alt-C bifurcation.** Confirm which spectral signature emerges — a sharpened 𝔰𝔲(2) pair with Level C or a broadened mixture without sharpening.
4. **Hermiticity check on 8×8.** Compute `‖𝔄 − 𝔄^†‖_F`; should be < 1e-10 independent of dimension.
5. **Per-category eigenvalue attribution.** For each of the 8 eigenvectors, project onto core-vs-Level-B-vs-Level-C subspaces; identify which eigenvalues are "core 𝔰𝔲(2)", which are "behavioral Tactic-driven", which are "symmetric Level-C".

The 8×8 matrix is now canonical for all future measurements. The 6×6 matrix in §1–§7 remains valid for historical / core-only interpretation.
