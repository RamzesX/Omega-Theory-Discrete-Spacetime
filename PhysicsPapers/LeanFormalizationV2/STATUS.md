# OmegaTheory V2 — Build Status

Single source of truth for repo headline numbers, parsed by `site/src/data/status.mjs`
at Astro build time.

| Metric | Value | Notes |
|---|---:|---|
| **Build jobs** | **4,620 GREEN** | Post-trash-purge + Phase B + Phase C step 1+2, 2026-05-06 |
| **Sorry count** | **0** | NO STUBS rule, locked 2026-04-27 |
| **Physical axioms** | **5** | 4 sealed Hermite-Padé research + 1 transcendence axiom; **0** for physical constants (c, ℏ, G_N, k_B opaque-bundle) |
| **Research-conjecture axioms** | **4** | Sealed Hermite-Padé only |
| **Total declared axioms** | **5** | Lean `axiom` keywords across the corpus (post-purge) |
| **OmegaTheoryV2 Theorems (own)** | **~9,200** | Approximate; live count via `mcp__omega-orchestrator__cycle_state()` |
| **OmegaTheoryV2 Definitions** | **~4,200** | Approximate post-purge |
| **Mathlib Theorems (integrated)** | **175,137** | v4.29.0 corpus loaded |
| **Grand total** | **~184,300** | OV2 + Mathlib retrievable theorems |
| **OmegaTheoryV2 LeanFile nodes** | **~1,560** | Post Phase C step 2 |
| **Cycles shipped** | **2 – 65 (numbered) + Lion's-Pride 2026-05-05/06 (continuous single-thread reframe wave)** |
| **:GraphFinding.total** | **88** | Graph-research findings (pre-purge snapshot) |
| **:GraphFinding.paper_worthy** | **44** | High-confidence subset |
| **:TheoremCandidate.total** | **166** | Sage-proposed open candidates |
| **:SubsystemNavigator** | **677** | Leiden communities |

## Tier-1 milestones

- **Cycle 64 (2026-04-27):** First Lean 4 formalization of `Real.pi_transcendental`. Custom Lindemann–Weierstrass port, 24 files, ≈ 8 400 LOC, single-day single-thread closure. Axiom audit: `[propext, Classical.choice, Quot.sound]`.
- **Cycle 65 (2026-05-04):** All five previously-open bridge targets closed (ER=EPR, CPT, graviton energy, Susskind complexity, *d*_crit). Build 4 462 → 4 926 GREEN.
- **Lion's-Pride 2026-05-05/06 (trash purge + reframe wave):** ~117 K LOC of mass-batch Yoneda witnesses, PDG calibration tautologies, and paper-bundle citation files deleted across 9 batches. Honest substrate spine retained at 4 613 GREEN. Phase B (Higgs as SU(2)_L × U(1)_Y doublet, 5 files) + Phase C step 1+2 (gauge-information density + photon information-signature match) added. Final state: **4 620 GREEN**, paper-headlines axiom Lean-core only.
- **Photon information-signature match (2026-05-06):** First particle-bridge proof of the new signature-match framework. Substrate `gaugeInformation gc p = (1/2)·Σ F²` matches textbook EM density `(1/2)(|E|² + |B|²)` (Landau–Lifshitz vol 2 §27) up to a units-convention factor of 2. See [`Foundations/PhotonInformationSignature.lean`](OmegaTheory/Foundations/PhotonInformationSignature.lean).

## Honest scope (post-2026-05-06 reframe)

The project's organizing principle is now the **signature-match bridging framework**: each SM particle / force has a specific informational signature in the substrate, derivable two ways (substrate + standard physics), and the match theorem connecting the two derivations is the bridge proof.

- **Tier-1 peer-review-ready:** π-transcendence (cycle 64) + the discrete-substrate quantum-gravity core (8 hand-authored sectors `Variational/`, `HealingFlow/`, `Geometry/`, `Conservation/`, `Spacetime/`, `Tensor/`, `Torsion/`, `Defects/`, ≈ 25 500 LOC) + photon information-signature match (Phase C step 2).
- **Tier-2 structural encoding of SM:** Higgs as SU(2)_L × U(1)_Y doublet with `Y_H = +1/2`, color singlet, J = 0 (Phase B, 5 files); CKM/PMNS partial unitarity; ρ-parameter custodial; SM gauge boson count 12 = 1+3+8.
- **Honestly NOT in scope (deferred F1–F9):** Stage-1 derivation of μ²/λ_H from substrate axioms, fermion origin from substrate, Pi-Hunch 3-generations theorem, full Connes spectral action `a₄`, Fock-space QFT, graviton scattering amplitudes, one-loop renormalization.

See [`PhysicsPapers/README.md`](../README.md) and [`CompleteOmegaTheory.md §0 Honest Scope`](../CompleteOmegaTheory.md) for the formal scope statement and the bridging-dictionary table.
