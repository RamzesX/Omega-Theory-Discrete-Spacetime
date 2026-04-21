---
title: "05 — Cycle hypotheses (𝔰𝔲(2) candidates)"
description: "SPECIALIZES⇌GENERALIZES and UNFOLDS⇌FOLDS bidirectional cycles. ±i eigenvalue predictions."
category: "Graph Research · Neo4j"
order: 114
---

<!-- orig-frontmatter: name: 05_cycle_hypotheses -->
<!-- orig-frontmatter: date: 2026-04-18 -->
<!-- orig-frontmatter: author: Sarin-Beta (Nunki, σ Sagittarii) -->
<!-- orig-frontmatter: parent: OmegaTheoryAlgebra Phase 0 -->
<!-- orig-frontmatter: status: speculative design memo -->
# 05. Cycle Hypotheses: Does the Lean Theorem Graph Carry 𝔰𝔲(2) × 𝔰𝔲(2)?

**TL;DR.** V3 software systems carry two commuting 𝔰𝔲(2) cycles (P⇌E and Ru⇌C). We conjecture that a theorem-graph over Lean 4 carries at least one, and possibly two, analogous 𝔰𝔲(2) cycles — built from the pairs (SPECIALIZES, GENERALIZES) and (UNFOLDS, FOLDS). We write out the Cartan generators, predict three spectral signatures for Team Merak to measure on live data (OmegaTheory ≈ 3.5K nodes plus Mathlib ≈ 240K), and flag the single place the analogy could cleanly fail. This is physics-letter-style speculation with an explicit kill-switch.

## 1. Why expect cycles at all?

V3 (HypatiaBasis §2.3 and §6) identifies two bidirectional cycles in the software quiver — P⇌E via TRIGGERS/INITIATES and Ru⇌C via APPLIES_IN/SCOPES — and proves that each one induces an 𝔰𝔲(2) subalgebra inside the commutator algebra, with one raising generator, one lowering generator, and a Cartan element given by the difference of the two endpoint idempotents. The dominant empirical commutator eigenvalues (±31.04i, ±5.39i, ±1.78i, ±0.73i; HypatiaBasis §6.2) match a rank-4 algebra of the form 𝔰𝔲(2) × 𝔰𝔲(2) × 𝒩.

Lean 4 mathematics has a different surface, but the same underlying "acts-and-is-acted-on" texture: some theorems are *specializations* of others; some theorems *unfold* definitions while others *fold* back into definitions. Those actions are reversible in the sense that the pair partners are mutually inverse operations on the graph. If that reversibility is algebraically clean — meaning the compositions land in different endpoint blocks in just the way TRIGGERS∘INITIATES vs. INITIATES∘TRIGGERS do — then Theorem 6.1 of HypatiaBasis transcribes almost verbatim.

## 2. Primary candidates

### 2.1 SPECIALIZES ⇌ GENERALIZES

Consider a concrete Lean pair inside OmegaTheory V2, drawn from `OmegaTheory/Irrationality/Uncertainty.lean`:

- `computationalUncertainty_pos (N : ℕ) : 0 < computationalUncertainty N` is a generic positivity statement about the δ_comp function.
- `extended_gt_heisenberg (N : ℕ) : ℏ/2 < ℏ/2 + computationalUncertainty N` specializes that positivity fact to a specific physical inequality.

The specialization arrow points Theorem → Theorem (both live in the `Theorem` entity type from file `01_entity_types.md`). Its partner GENERALIZES points backward: extracting the shared positivity hypothesis from the specialized statement recovers the generic lemma. This is not bookkeeping — Lean proof engineering routinely encodes both directions (lemmas with `@[simp]` hints, unfolded via `apply_assumption`, or reused verbatim by downstream theorems).

Define, on the Theorem block:

- Ĵ_+ = SPECIALIZES (raising: carries a generic statement down to a concrete instance)
- Ĵ_− = GENERALIZES (lowering: abstracts a specific statement to its general form)
- Ĵ_z = (e_Theorem − e_Axiom) / 2 (difference of the two height-level idempotents involved)

The Cartan-level choice `e_Theorem − e_Axiom` follows from the height ladder we assigned in `01_entity_types.md`: Axioms sit below Theorems in the dependency height function, and specialization walks the ladder. A fuller check requires Team Merak to compute `[Ĵ_+, Ĵ_−]` on a 200-theorem Lean subsample and verify proportionality to 2 Ĵ_z within the ±10% tolerance V3 accepts for empirical commutators.

### 2.2 UNFOLDS ⇌ FOLDS

The second candidate pair is built on definitional traffic:

- `extended_gt_heisenberg` UNFOLDS the definition `computationalUncertainty` (the proof literally replaces that name with `ℓ_P · 4 / (2N + 3)` via `unfold` or `show`).
- A downstream theorem such as `extendedUncertaintyBound_pos` FOLDS the unfolded expression back into the named definition when the simp lemmas fire in the opposite direction (reducible defs and `@[simp]`-tagged definitional lemmas are the folding channels).

Define on the (Theorem, Definition) block:

- K̂_+ = UNFOLDS (Theorem → Definition → Theorem chain, similar to TRIGGERS∘INITIATES)
- K̂_− = FOLDS (Definition → Theorem → Definition chain, reverse traversal)
- K̂_z = (e_Theorem − e_Definition) / 2

The expected eigenvalue ordering, matching V3's pattern (P⇌E cycle is heavier than Ru⇌C), is that SPECIALIZES/GENERALIZES should dominate UNFOLDS/FOLDS by roughly the same ratio V3 observes (1.78 / 0.73 ≈ 2.44). The physical reason: specialization is stressed at nearly every theorem (Lean proofs constantly cite prior lemmas in specialized form) whereas definitional folding is used more sparingly, typically once per lemma to introduce the definition and once to eliminate it.

## 3. A novel conjecture: three sectors → three Lie factors

V3's full commutator algebra decomposes as 𝔰𝔲(2) × 𝔰𝔲(2) × 𝒩 where 𝒩 is nilpotent. We hypothesize that the 15 Lean relationships (ontology in `02_relationships.md`: 4 structural + 5 dependency + 3 type-theoretic + 3 computational) split into the same three-factor pattern:

| V3 factor | Lean analogue | Basis for the claim |
|---|---|---|
| 𝔰𝔲(2)_EP | SPECIALIZES ⇌ GENERALIZES on Theorems | two-endpoint reversible traffic |
| 𝔰𝔲(2)_RuC | UNFOLDS ⇌ FOLDS on Theorem/Definition | second reversible cycle on a distinct block |
| 𝒩 (nilpotent) | USES, IMPORTS, INSTANTIATES, REWRITES, COMPUTES_TO | asymmetric one-directional compositions |

This is the core speculative claim of the memo: **the three-way split between structural, dependency, and type-theoretic relationships in Lean is not accidental — it might be the image, under our ontology, of the three summands of the V3 commutator algebra**. If true, the rank of the commutator algebra on the live graph should be 4 (two Cartans plus two nilpotent directions), matching V3 exactly.

## 4. Predictions for Team Merak

Team Merak runs the empirical spectrum measurement in `08_empirical_spectrum.md` and the subsystem-sanity check in `09_subsystem_sanity.md`. We hand them three falsifiable predictions:

1. **Rank 4.** The commutator spectrum of 𝔄_Lean on OmegaTheory + Mathlib is rank 4 (four nonzero eigenvalue pairs), matching V3. If the rank is 2 we have only one 𝔰𝔲(2); if it is 6+ the Lean algebra is richer than V3 and 𝒩 is no longer the right nilpotent residue.

2. **Two 𝔰𝔲(2) signatures.** There exist two distinct eigenvalue pairs ±λ₁i and ±λ₂i with λ₁/λ₂ ∈ [1.8, 3.2] and λ₁ associated (via eigenvector overlap > 0.7) with SPECIALIZES/GENERALIZES, λ₂ associated with UNFOLDS/FOLDS. If the eigenvector overlap falls below 0.4 or if λ₁ ≈ λ₂, our cycle assignment is wrong.

3. **Non-commutativity fraction ≥ 90%.** The fraction of non-commuting legal 2-compositions on the Lean graph is at least as high as V3's 93%. If it drops below 70%, Lean is materially more lattice-like (more abelian) than typed software, and the whole "typed-quiver as gauge theory" transplant is wobbly.

All three are quantitative and cheap to check once FastRP (file 06) has populated the per-relation embeddings.

## 5. Alternative hypotheses (kill-switches)

To keep this honest we name the three ways the analogy could break and what Merak's data would look like if each is true.

**Alt-A: Only one 𝔰𝔲(2).** Lean might carry SPECIALIZES/GENERALIZES cleanly but lack a sharp UNFOLDS/FOLDS cycle (e.g., Mathlib's heavy use of `reducible` defs could collapse the Theorem/Definition distinction, killing the second cycle). Signature: the second eigenvalue pair λ₂i is absent or order-of-magnitude smaller than λ₁i.

**Alt-B: Weaker non-abelian signature.** Dependency arrows (IMPORTS, USES) might dominate the Lean graph so strongly that the non-commutativity fraction falls below V3's 93%. Signature: the diagonal-commutator (abelian) block dwarfs the off-diagonal one. Physical reading: Lean proofs are more *serial* (a single long dependency chain) and less *interacting* (few genuine feedback loops) than Spring Boot code.

**Alt-C: Open (non-closed) commutator set.** The 15 Lean relations might fail to close under composition — i.e., [R_i, R_j] sometimes produces a path whose endpoint types fall outside the span of the original 15. In V3 this does not happen (Proposition 3.1 of HypatiaBasis). Signature: a handful of "orphan" commutator classes with no eigenvector overlap to any single R_k. If found, we need a 16th relation (or a composition like SPECIALIZES∘UNFOLDS treated as a first-class arrow).

Each alt is a real possibility; we take the primary conjecture seriously precisely because all three have failure modes that would show up loudly in the spectrum.

## 6. What we predict / what could kill this

**We predict:** the Lean theorem graph, modeled by the 15-relation ontology of `02_relationships.md`, carries rank-4 non-abelian structure with two 𝔰𝔲(2) summands whose Cartan subalgebra is spanned by the two height-difference idempotents (e_Theorem − e_Axiom)/2 and (e_Theorem − e_Definition)/2. The dominant eigenvalue pair λ₁i tracks SPECIALIZES/GENERALIZES; the second pair λ₂i tracks UNFOLDS/FOLDS; the ratio λ₁/λ₂ lies in [1.8, 3.2].

**What kills this.** Any one of the three predictions in §4 failing on Merak's measurement. In particular, if the non-commutativity fraction is below 70%, or if the rank is ≤ 2, the V3-to-Lean transplant cannot be literally 𝔰𝔲(2) × 𝔰𝔲(2) × 𝒩 and we must either (a) enlarge the ontology (add missing relations so the commutator set closes) or (b) accept that Lean is a simpler, weaker algebra — still typed, still non-abelian, but not quite a "gauge theory on typed embeddings" in V3's strong sense.

If the analogy does survive, a beautiful corollary follows: theorem-graph traversal is also a discrete gauge theory, and retrieval-for-proof (Lean-Finder + graph-aug premise selection) inherits the same Hermitian spectral guarantees V3 uses for subsystem detection. That would validate the central bet of `OmegaTheoryAlgebra`: Lean is structurally a physics object.

---

*Companion files:* `04_magnetic_laplacian.md` (Alpha) defines 𝔄 we diagonalize here. `08_empirical_spectrum.md` (Merak) reports the measured eigenvalues. `verify_cycles.py` will implement the [Ĵ_+, Ĵ_−] check on a live subsample.
