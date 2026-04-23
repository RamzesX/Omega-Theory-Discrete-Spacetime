# Plan — Hilbert-Space Emergence (Phase 2)

*Deferred plan. Saved 2026-04-15. Queued after Team Betelgeuse (HPW general-curved) and any other higher-priority work.*

## Thesis

No existing prover (Mathlib, Isabelle, Coq) *derives* QM's Hilbert-space
machinery from a physical substrate — they all **assume** it. Omega V2
already puts the discrete Z⁴ lattice + healing flow *below* QM and recovers
seven von-Neumann postulates as theorems (`grand_qm_emergence`). The
missing 8th conjunct: **the Hilbert-space structure itself emerges**.

If delivered, the headline sharpens to: *the universe's quantum structure
is a theorem, not an axiom.*

## Target theorem bundle

| Theorem | Content | Status | Effort |
|---|---|---|---|
| `lattice_hilbert_structure` | `LatticeComplexField` on a finite region forms a Mathlib `InnerProductSpace ℂ` | Unproven | Small |
| `discreteLaplacian_self_adjoint` | `⟨f, Δg⟩ = ⟨Δf, g⟩` on bounded region | Ingredients landed in `HodgeDecomposition` | Small-medium |
| `hamiltonian_hermitian` | `H = −(ℏ²/2m)·Δ + V` is self-adjoint (V real) | Corollary of above | Small |
| `substrate_embeds_in_hilbert` | Unitary embedding `SnapshotSequence → H` factoring `coarseGrain` | Structural | Medium |
| `observable_expectation_real` | `⟨ψ, Oψ⟩ ∈ ℝ` for Hermitian O | Immediate corollary | Small |
| `grand_qm_emergence_hilbert` | New 8th conjunct extending the capstone | Assembly | Small |

## What's already in the repo (reusable)

- **Complex amplitudes**: `coarseGrain : SnapshotSequence → LatticeComplexField`
  (`Emergence/CoarseGrainingMap.lean`)
- **L² norm conservation**: `bornRuleConservation` is unitarity on finite region
- **δ adjoint to d**: `codiff0_comp_codiff1`, `backwardDiff_comm'`,
  `summation_by_parts_1_antisym`, `hodge_orthogonal`
  (`Geometry/HodgeDecomposition.lean`, `Geometry/HodgeStar.lean`)
- **Hodge Laplacian = discrete Laplacian**: `hodgeLaplacian0_eq_discreteLaplacian`
  (`Geometry/HodgeStar.lean`)

## Proposed file

`OmegaTheory/Emergence/HilbertEmergence.lean` — ~300–500 lines, single new file.

## Team structure (5 roles, when spawned)

1. **Strategist** — read Mathlib `InnerProductSpace`, pick region-restricted
   `LatticeComplexField`-over-`Finset LatticePoint` as the carrier, scaffold file.
2. **Inner-product prover** — instance `InnerProductSpace ℂ (LatticeComplexField restricted to region)`.
3. **Laplacian self-adjoint** — lift `HodgeDecomposition` summation-by-parts
   to the explicit adjoint equality with complex scalars.
4. **Hamiltonian Hermitian** — real potential V + Laplacian → `H† = H`.
5. **Capstone connector** — add 8th conjunct to `QuantumMechanicsCapstone.lean`'s
   `QuantumMechanicsPostulates`, prove under `HasZeroFunctional`.

## Hard constraints (matching project convention)

- 0 sorry. 0 new axioms.
- Incremental build after each phase.
- Star-name credit per role in README.
- File doc-block in existing editorial style.

## Dependencies

- **Blocked by**: Team Betelgeuse reporting (avoid worktree conflicts).
- **Could run parallel with**: any non-Emergence/non-Geometry work.

## Priority rationale

*Highest headline-value target after HPW general-curved closure.* If
Betelgeuse lands general-curved HPW, the project becomes axiom-free beyond
physical constants. Adding Hilbert-emergence on top then delivers the full
"QM structure as theorem, not axiom" claim — a headline that reviewers
quote verbatim.

Preferred star-name pool (unused as of 2026-04-15): Capella, Procyon,
Arcturus, Deneb, Aldebaran, Spica, Antares, Regulus.
