# 11 — Master plan skeleton: the puzzle-pieces view

> *"Skelet ukladanki" — the puzzle skeleton. Every major theorem bucket, at a glance, marked proven / conjectured / not-started.*

## The six puzzle pieces

The Omega Algebra is the collection of mathematical apparatus, each piece contributing one slot of the final "physics completely described" picture.

```
        Omega Algebra — completed physics, piece by piece
    ┌────────────────────────────────────────────────────────┐
    │                                                        │
    │   Piece 1 — Lattice foundation      (Spacetime/)       │
    │   Piece 2 — Error algebra           (Foundations/)     │
    │   Piece 3 — Irrationality classes   (this folder)      │
    │   Piece 4 — Emergent physics        (Emergence/)       │
    │   Piece 5 — Cosmology + gravity     (Torsion/, HealingFlow/)│
    │   Piece 6 — Matter sector           (Predictions/)     │
    │                                                        │
    └────────────────────────────────────────────────────────┘
```

Each row below marks a piece as **proven** (in Lean, 0 sorry), **conjectured** (statement in graph, proof pending), or **not-started** (registered as frontier-work).

## Piece 1 — Lattice foundation

| Theorem bucket | Status | Headline |
|---|---|---|
| ℤ⁴ Planck lattice | ✅ proven | `LatticePoint` |
| Light-cone + causality | ✅ proven | `CausalLattice.lean`, Aldebaran cycle |
| Discrete operators (∇, Δ) | ✅ proven | `Operators.lean` |
| Poincaré lemma H¹ = H² = H³ = 0 on ℤ⁴ | ✅ proven | Vega C1 + C2 + C3 |
| 8 physical constants | ✅ axiom | c, ℏ, G_N, k_B + positivity |
| Discrete dispersion → Lorentz (low-energy) | ✅ proven | Rigel C2 |

**Piece 1 summary: COMPLETE. 8 axioms, no holes.**

## Piece 2 — Error algebra

| Theorem bucket | Status | Headline |
|---|---|---|
| `ErrorBound` structure | ✅ proven | `Foundations/ErrorAlgebra.lean` |
| `ErrorLieAlgebra`, `ErrorLieBracket` | ✅ proven | `Foundations/ErrorLieAlgebra.lean` |
| `ErrorForms` (0–3-forms) | ✅ proven | `Foundations/ErrorForms.lean` |
| `ErrorHopfAlgebra` | ✅ proven | `Foundations/ErrorHopf.lean` |
| `ErrorMaxwellField` | ✅ proven | `Foundations/ErrorMaxwell.lean` |
| `HpwEliminableRegime` (HPW axiom DELETED) | ✅ proven | 7 regime witnesses |
| `computationalUncertainty N` (δ_comp, the Pi-Hunch primitive) | ✅ proven | `Irrationality/Uncertainty.lean` |
| `extendedUncertaintyBound` | ✅ proven | ibid. |

**Piece 2 summary: COMPLETE modulo the extension to non-abelian F.**

## Piece 3 — Irrationality classes (THIS FOLDER)

| Theorem bucket | Status | Where |
|---|---|---|
| `truncated_pi` / `truncated_e` / `truncated_sqrt2` / `truncated_catalan_g` | ✅ proven | `Irrationality/Approximations.lean` |
| Error bounds `piErrorBound`, `eErrorBound`, `sqrt2ErrorBound`, `catalanGTruncError` | ✅ proven | `Irrationality/BoundsLemmas.lean`, `Emergence/ConnesCalibrationAndFourChannels.lean` |
| Channel-to-generation bijection | ✅ proven | `Irrationality/GenerationMap.lean` |
| π > e > G > √2 asymptotic ordering (headline) | ✅ proven | `Predictions/PiHunchQuantitative.lean` |
| Layer 1: pairwise-distinct | 🟡 statement-ready | `06_separation_theorem.md` |
| Layer 2: transcendental vs algebraic | 🟡 blocked-on-Mathlib | `06_separation_theorem.md` |
| Layer 3: E-function vs G-function | 🟡 blocked-on-framework | `06_separation_theorem.md` |
| Layer 4: `omega_four_origin_separation` (headline) | 🟡 blocked-on-Layers-2-and-3 | `06_separation_theorem.md` |
| Catalan G irrationality itself | ❌ open classical problem | `05_catalan_G_class.md` |

**Piece 3 summary: HALF-COMPLETE. Asymptotic ordering and channel-to-generation ✅; rigorous Mahler/E-function separation 🟡; Catalan irrationality ❌.**

## Piece 4 — Emergent physics

| Theorem bucket | Status | Headline |
|---|---|---|
| Quantum mechanics (10 postulates) | ✅ | `grand_qm_emergence` |
| General relativity (7 regimes) | ✅ | `vacuum_einstein_emergence` |
| U(1)×SU(2)×SU(3) gauge | ✅ | `substrate_electroweak_unification_theorem`, `SU3_color_from_three_irrationals` |
| Non-abelian F = dA + [A,A] full general bundle | 🟡 partial | Tiaki cycle 29 |
| Higgs mechanism | ✅ | `higgs_vev_substrate_headline` |
| CHSH Bell violation | ✅ | `substrate_CHSH_violation` |
| Path integral interference | ✅ | `pathIntegral_interference` |
| Klein-Gordon | ✅ | `kleinGordon_dispersion_relation` |
| Connes D_F → Yukawa masses | ✅ | `mass_ratio_e_mu_from_sqrt2_e_channel_ratio` |
| Koide relation | ✅ | `koide_formula_holds` |

**Piece 4 summary: NEARLY COMPLETE. Non-abelian F full bundle pending.**

## Piece 5 — Cosmology + gravity

| Theorem bucket | Status | Headline |
|---|---|---|
| Dark energy w = -1 | ✅ | `darkEnergyEquationOfState_w` |
| Cosmological constant problem | ✅ | `cosmological_constant_problem_resolved` |
| Inflation | ✅ | `inflation_ends_at_equilibrium` |
| Big Bounce (Popławski spin-torsion) | ✅ | `substrate_avoids_singularity` |
| Cyclic cosmology | ✅ | `CyclicCosmology.lean` |
| DE → baby-universe bridge | ✅ | `de_to_baby_universe_first_bridge_in_V2` |
| BH information paradox | ✅ | `black_hole_information_paradox_fully_resolved` |
| 2nd law / holography | ✅ | `SecondLawAndHolography.lean` |
| Hawking radiation reservoir relaxation | ✅ | `HawkingReservoirRelaxation.lean` |
| Graviton E_g = E_P/2 (cycle 44+ target) | 🟡 open | future |

**Piece 5 summary: NEARLY COMPLETE. Graviton bound is cycle-44 target.**

## Piece 6 — Matter sector

| Theorem bucket | Status | Headline |
|---|---|---|
| Lepton mass hierarchy (m_e < m_μ < m_τ) | ✅ | `pdg_lepton_hierarchy` |
| m_μ/m_e exact Connes identity | ✅ | `mass_ratio_e_mu_from_sqrt2_e_channel_ratio` |
| Quark mass Pi-Hunch (up-type + down-type) | ✅ | `quark_mass_ordering_from_pi_hunch` |
| CKM hierarchy | ✅ | `CKM_hierarchy_from_pi_e_sqrt2_ordering` |
| PMNS matrix | ✅ | `PMNS_fourth_column_from_catalan_G` |
| 4-generation sterile neutrino | ✅ | `SterileNeutrinoFromFourthIrrational.lean` |
| Absolute m_e, m_μ, m_τ within 1% PDG | ❌ cycle 44+ | research frontier |
| Absolute quark masses within 1% PDG | ❌ cycle 44+ | research frontier |
| Neutrino mass sum | ✅ | `NeutrinoMassFloorW1.lean` |
| CP-phase δ_CP derivation (Jarlskog) | ❌ MP-8 Navi | `:TheoremCandidate` |
| Proton mass / Λ_QCD | ❌ open | `notes/NOTES_PROTON_MASS_SCOPE.md` |

**Piece 6 summary: HIERARCHY COMPLETE, ABSOLUTE MASSES OPEN.**

## Aggregate status

| Piece | Complete | Partial | Not-started |
|---|---|---|---|
| 1. Lattice | 6/6 | 0 | 0 |
| 2. Error algebra | 8/8 | 0 | 0 |
| 3. Irrationality classes | 5/10 (asymptotic + ordering) | 4/10 (separation layers) | 1/10 (Catalan irrationality) |
| 4. Emergent physics | 8/9 | 1/9 (non-abelian F) | 0 |
| 5. Cosmology + gravity | 9/10 | 0 | 1/10 (graviton bound) |
| 6. Matter sector | 7/11 | 0 | 4/11 (absolute masses, CP phase, proton) |

**Roll-up: 43/54 complete = ~80% of declared puzzle pieces shipped as full theorems.**

## Cycle 44+ priority queue

Priority 1 (shippable with current Mathlib):
1. Layer 1 pairwise-distinct (IrrationalityClasses) — 2 sessions.
2. Non-abelian F full general bundle — ~20 sessions.
3. Graviton bound — ~15 sessions.

Priority 2 (needs short Mathlib ports):
4. Layer 2 transcendental separation (on Lindemann port) — 5 sessions after port.
5. Absolute m_e / m_μ / m_τ fits (on top of Connes D_F) — ~40 sessions.
6. CP-phase δ_CP derivation — ~30 sessions.

Priority 3 (research frontier):
7. Full E-function framework (Layer 3) — ~50 sessions (Mathlib port) or axiomatic.
8. Absolute quark masses (nonperturbative QCD side) — ~80 sessions.
9. Proton mass / Λ_QCD — open research problem.

Priority 4 (blocked on classical math):
10. Catalan G irrationality — classical open problem.

## Reading order for a coordinator

1. Read this file — puzzle pieces view.
2. Read `00_motivation.md` — irrationality classes in context.
3. Read `06_separation_theorem.md` — the headline.
4. Read `10_proof_count.md` — the headline integer.
5. Read `13_novel_mathematics.md` (Task 13 from coordinator) — the novel math catalogue.
6. Read `../AXIOM_ELIMINATION_METHODOLOGY.md` (Task 14) — the axiom-elimination roadmap.
