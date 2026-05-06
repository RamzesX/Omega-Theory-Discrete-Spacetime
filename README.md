# Ω-Theory — Discrete-Substrate Quantum Gravity, formalized in Lean 4

**Author:** Norbert Marchewka · [ORCID 0009-0007-3029-175X](https://orcid.org/0009-0007-3029-175X) · CC BY 4.0
**Lean corpus:** [`PhysicsPapers/LeanFormalizationV2/OmegaTheory/`](PhysicsPapers/LeanFormalizationV2/) (Lean 4 + Mathlib v4.29.0)
**Build (2026-05-06):** **4 620 jobs GREEN · 0 sorry · paper-headlines axiom Lean-core only**
**Site:** [ramzesx.github.io/Omega-Theory-Discrete-Spacetime](https://ramzesx.github.io/Omega-Theory-Discrete-Spacetime/) · [Lean by domain](https://ramzesx.github.io/Omega-Theory-Discrete-Spacetime/lean/)

---

## What this project is, in one paragraph

A Lean 4 formalization of a **discrete substrate** for physics — a ℤ⁴ Planck lattice on which π, e, √2, and Catalan G cannot be computed exactly, yielding a strictly-positive truncation residual `δ_comp(N) := ℓ_P · 4/(2N+3)` that extends the Heisenberg relation `Δx Δp ≥ ℏ/2 + δ_comp(N) > ℏ/2`. The substrate has a **healing-flow PDE** with proven Lyapunov dissipation. The headline machine-checked result is the **first Lean 4 formalization of π's transcendence** (cycle 64, 2026-04-27, custom Lindemann–Weierstrass port). The project's central organizing principle is the **signature-match bridging framework**: each Standard Model particle / force has a specific informational signature in the substrate, derivable two ways (substrate + standard physics), and the match theorem connecting the two derivations is the bridge proof.

---

## The vision (where this is going)

We do **not** try to derive the Standard Model's quantum numbers (spin, color, hypercharge) from substrate axioms. The SM is its own well-formalized body of mathematics; we **import it as a given from textbooks** (Peskin & Schroeder, Weinberg, Landau–Lifshitz) and formalize the SM's precise mathematics on the typed Lean side.

What we *do* contribute is the **bridge** between SM events and substrate / healing-flow / spacetime events:

1. **Build the SM trees** — proper representation theory, gauge actions, Yukawa, EW SSB, all in Lean.
2. **Extract the information signature** of each particle / force from its standard-physics stress-energy tensor / Lagrangian.
3. **Match it to our substrate** `informationStressEnergyTensor` + `gaugeInformation` densities.
4. **Show how the healing flow acts** on each signature — what gets dispersed, what gets crystallized, what changes the spacetime topology.
5. **That is the bridge**: SM ↔ substrate ↔ spacetime ↔ gravity, particle by particle, with one machine-checked match theorem per row.

**First match landed (2026-05-06):** the photon. Substrate `gaugeInformation gc p = (1/2)·Σ F²` matches textbook EM density `(1/2)(|E|² + |B|²)` (Landau–Lifshitz vol 2 §27) up to a units-convention factor of 2. The dictionary now has one entry; the methodology works; we extend particle-by-particle from here.

---

## What we have (Tier 1 — peer-review-ready)

| Result | Lean witness | What it gives |
|---|---|---|
| **First Lean 4 proof of π-transcendence** | `Real.pi_transcendental` ([`PiStratum.lean`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/Irrationality/HermitePade/PiStratum.lean)) | Custom Lindemann–Weierstrass port, ~3 000 LOC, single-day single-thread closure. Audit Lean-core only. |
| **Discrete-substrate quantum-uncertainty chain** | `irrationality_implies_quantum_uncertainty` | π irrational → δ_comp(N) > 0 → extended Heisenberg. Fully discharged. |
| **Healing-flow Lyapunov dissipation** | `dissipationRate_nonpos` ([`HealingFlow/Lyapunov.lean`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/HealingFlow/Lyapunov.lean)) | The substrate functional decreases monotonically along the gradient flow. |
| **Photon information-signature match** (the FIRST particle bridge, 2026-05-06) | `photon_information_signature_match` ([`PhotonInformationSignature.lean`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/Foundations/PhotonInformationSignature.lean)) | Substrate `gaugeInformation` reduces to textbook `(1/2)(\|E\|²+\|B\|²)` under the natural F-decomposition. |

## What machinery we will build (the bridge dictionary, in progress)

| Particle / Force | Substrate signature | Standard-physics signature | Match status |
|------------------|---------------------|----------------------------|--------------|
| Photon (γ) | `gaugeInformation gc p = (1/2)·Σ F²` | `(1/2)(\|E\|² + \|B\|²)` | ✅ shipped |
| Mass / matter | `informationStressEnergyTensor = -defectTensor` | textbook matter T_μν | ✅ pre-existing |
| Gluon (g) | non-abelian curvature `F = dA + [A,A]`, |F|² density | textbook QCD energy density | 🔶 next |
| EM coupling current | substrate `J^μ A_μ` source | textbook charge-current Lagrangian | 🔶 next |
| Graviton (h_μν) | Einstein-Hilbert action `(1/16πG)·∫√(-g)R` | textbook GR T_μν | 🔶 deferred |
| Higgs (h) | substrate Mexican-hat + δ_comp | textbook scalar T_μν | 🔶 deferred |
| Fermion (ψ) | curved Dirac on substrate | textbook Dirac T_μν | 🔶 deferred |

Each row gets its own `*InformationSignature.lean` file with a substrate definition, a standard-physics definition, and a match theorem. The dictionary is the project's central deliverable.

---

## Honest scope — what is NOT a derived theorem

To prevent over-claiming:

- **Mass values** (μ², λ_H for Higgs; Yukawa couplings for fermions) are CHOICES in the substrate ([`HiggsSubstrateBridge.lean:39-43,78,83`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/HealingFlow/HiggsSubstrateBridge.lean)), not derived. Closing this requires the Connes spectral action `a₄` coefficient — multi-month Vassilevich heat-kernel port.
- **"Where fermions come from"** is unsolved. Fermion content is SPECIFIED in [`FermionContent.lean`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/Emergence/FermionContent.lean), not derived from substrate axioms.
- **"Why 3 generations from 3 irrationals"** (Pi-Hunch) is docstring speculation, not a theorem. Research frontier.
- **Full Connes spectral action** `S = Tr(f(D/Λ))` is not formalized end-to-end. The `A_F = ℂ × ℍ × M_3(ℂ)` componentwise structure is shipped, but the heat-kernel `a_k` derivation is multi-month future work.
- **Full Fock-space QFT** is not shipped. Truncated single-mode Fock space exists; multi-mode + creation/annihilation + Wick's theorem is deferred.
- **Graviton scattering amplitudes** — only cubic + quartic vertex algebra ships, no tree-level S-matrix.

See [`PhysicsPapers/README.md`](PhysicsPapers/README.md) for the full Tier 1 / Tier 2 split with explicit deferred-task catalog (F1–F9).

---

## What happened to all the old code

In late April 2026 the project ran a **subagent dispatch protocol** that produced ~150 000 LOC of mass-batch Yoneda-witness scaffolding, PDG calibration tautologies, and paper-bundle citation files. They compiled, but they were physics-empty: every "theorem" reduced to `decide` or `norm_num` on hand-picked numerical placeholders that satisfied the stated bound by construction.

The 2026-05-05/06 cleanup deleted **~117 000 LOC across nine batches**: 250+ `*CategoricalYonedaWitness.lean` files, 156 paper-bundle / inbound / orphan-capstone bridges, 81 `T1_*PDG*` anchor files, 22 `*Fit.lean` PDG-tautology files, 19 Higgs/EW/CLFV envelope-tautology files, plus surgical rewires of `HeatKernelMinimal §5–§9` and `ConnesSpectralAction §3–§6`.

The hand-authored substrate spine survived intact. Build is **4 620 jobs GREEN, 0 sorry, all paper-headlines axiom Lean-core only**. The Tier-2 framework (Connes, Yukawa, etc.) was demoted from "research-grade conjecture with Lean scaffolding" to "structural encoding of the SM for the bridging framework", and the legacy `Complete-Omega-Theory-Unified-Framework.md` (1 042 lines of speculative claims like "spacetime and SM are dual projections of Ω") was deleted.

### Lesson for other Claude Code users (locked rule, 2026-04-26 + reinforced 2026-05-06)

> **Single-thread Opus 4.7 [1M context] with thinking effort `high` or `max` produces sensible mathematics. Mass-batch subagent provers without thinking produce trash.**

The pathology was *mass-batch dispatch without doctrine*, not subagents per se. A subagent with full doctrine (`prove-wizard-v3` v4.4+, Phase 0 memory read, Phase 7 graph write, NO STUBS, BUILD_MATHLIB_MACHINERY_T6_13) is fine. A subagent with "land 50 Yoneda witnesses in parallel, no doctrine, no audit" is a trash factory.

The rule that survived the audit: **for paper-grade physics, single-thread Opus 4.7 [1M context] with high thinking budget, hand-authored, audit-after-every-file, NEVER `def OmegaConjecture`, NEVER `: True := trivial`, NEVER mass-batch Yoneda witnesses.**

If you fork this project: ship one theorem, audit, commit, ship the next. Do not parallelize cheap-prover subagents on paper-headline work. The build-job count is meaningless if the theorems are vacuous.

---

## Repository layout

```
chaos-shield/
├── README.md                          ← this file
├── PAPERS.md                          ← hub: all papers and notes
├── Physics-Papers-Summary.md          ← friendly tour of the physics corpus
├── INDEX.md                           ← full flat index
├── ConvQMath/                         ← Convergent Rationals math program (16 essays)
├── PhysicsPapers/                     ← physics formalization
│   ├── README.md                      ← physics-side scope + bridging dictionary
│   ├── CompleteOmegaTheory.md         ← formal paper (with §0 honest scope)
│   ├── Main-Paper-Postulates.md       ← postulational summary (with reframe banner)
│   ├── papers/                        ← Tier-1 short papers
│   │   ├── Paper-Pi-Transcendence-Lean4-FirstFormalization.md  ← Tier 1 method note
│   │   └── Paper-QM-From-Discrete-Gravity.md
│   ├── appendices/                    ← technical appendices A–S
│   └── LeanFormalizationV2/           ← THE LEAN CORPUS
│       └── OmegaTheory/
│           ├── Spacetime/             ← substrate constants, lattice
│           ├── Defects/               ← defect tensor, sparsity
│           ├── Geometry/              ← discrete forms, curvature, Hodge
│           ├── HealingFlow/           ← Lyapunov flow, Mexican-hat, semismooth limit
│           ├── Conservation/          ← informationStressEnergyTensor (the first bridge)
│           ├── Emergence/             ← gauge groups, fermion content, gauge-information density
│           ├── Foundations/           ← Higgs doublet, photon signature match, Connes A_F
│           ├── Variational/           ← Einstein-Hilbert, graviton vertices
│           ├── Tensor/                ← curvature tensor algebra
│           ├── Predictions/           ← experimental predictions
│           ├── Irrationality/         ← π/e/√2/G; HermitePade T-4 chain
│           └── Capstones/             ← top-level META composites
└── site/                              ← Astro static site
```

---

## MCP servers & custom agents (the engineering layer that drives the proofs)

The Lean corpus is not handwritten in isolation. Two custom MCP (Model Context Protocol) servers and one custom Lean-proof agent sit between Claude Code and the corpus, providing semantic retrieval over 184 K theorems (10 K OmegaTheory V2 + 175 K Mathlib v4.29.0), graph-topology analytics, axiom-audit gating, and a hardened proof-loop doctrine. This is the part of the project that doubles as a deliverable for an MCP / agent-engineering work assignment — a custom MCP server that a custom agent uses end-to-end.

### MCP server inventory

| Server | Source | What it exposes |
|---|---|---|
| **omega-search** | [`PhysicsPapers/services/omega_search_mcp.py`](PhysicsPapers/services/omega_search_mcp.py) (940 LOC) | `retrieve_premises` · `find_similar` · `neighbors` · `explain_theorem` · `subsystem_of` · `rerank_documents` · `tactic_continuation` · `goal_to_proof_step` · `auto_tactic_suggest` |
| **omega-orchestrator** | [`PhysicsPapers/services/omega_orchestrator_mcp/`](PhysicsPapers/services/omega_orchestrator_mcp/) (1 713 LOC) | `omega_hammer_premise` · `propose_proof` · `build_status` · `axiom_audit` · `cycle_state` · `graph_health` · `find_keystones` · `find_iff_cycles` · `find_bridge_lemmas` · `find_missing_edges` · `refresh_graph` (+ 11 other inspect/job tools) |
| **neo4j-math** | (3rd-party MCP) | `read_neo4j_cypher` · `write_neo4j_cypher` · `get_neo4j_schema` over the `OmegaTheoryV2` / `Mathlib` / `OmegaWizardLessons` namespaces |
| **lean-lsp** | (3rd-party MCP) | `lean_loogle` · `lean_leansearch` · `lean_state_search` · `lean_multi_attempt` · `lean_goal` · `lean_diagnostic_messages` · `lean_hammer_premise` (+ 8 others) |

**Backing infrastructure** for `omega-search`: Qwen3-Embedding-8B at `:7999` (4096-d, instruction-aware retrieval per the [official Qwen3 task-prefix format](https://huggingface.co/Qwen/Qwen3-Embedding-8B)) + Qwen3-Reranker-8B at `:7996` (cross-encoder filtering) + Neo4j 2026.03.1 vector indexes (`lean_retriever_embedding_theorem`, `proof_step_embedding_goal` over 254 K Mathlib elaborated goals).

### Example tool call: `retrieve_premises`

The canonical kNN-over-embeddings retriever. Source: [`omega_search_mcp.py:162`](PhysicsPapers/services/omega_search_mcp.py).

```python
# Call (from a wizard's MCP cascade):
omega_search.tool_retrieve_premises({
    "goal":      "irrational pi transcendental",
    "k":         5,
    "namespace": "OmegaTheoryV2",
    "rerank":    True,           # adds CPU cross-encoder pass on top-50 pool
})

# Return (shape verified by tests/test_omega_search_integration.py):
{
  "query":    "irrational pi transcendental",
  "k":        5,
  "reranked": True,
  "results": [
    {"name":"OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental",
     "label":"Theorem", "ns":"OmegaTheoryV2",
     "signature":"theorem Real.pi_transcendental : Transcendental ℤ Real.pi",
     "knn_score": 0.91, "rerank_score": 0.87},
    {"name":"OmegaTheory.Irrationality.PiIrrationality.pi_irrational", ...},
    ...
  ]
}
```

### Example tool call: `find_keystones` (graph-topology MCP, omega-orchestrator)

Articulation-point proxy via `pagerank × log(1 + indeg_applies)`. Identifies single-points-of-failure in the proof DAG. Source: [`SOTA/proving_techniques/03_mcp_tools/code/orchestrator_t41_excerpt.py`](PhysicsPapers/SOTA/proving_techniques/03_mcp_tools/code/orchestrator_t41_excerpt.py).

```python
# End-to-end verified 2026-05-01:
find_keystones(k=3) → [
  ("OmegaTheory.Spacetime.l_P_pos",       score=225.98),
  ("OmegaTheory.Spacetime.c_pos",         score=160.03),
  ("OmegaTheory.Spacetime.hbar_pos",       score= 93.96),
]
```

### Example tool call: `omega_hammer_premise`

The default cascade entrypoint a wizard calls *before* writing any tactic — a 4096-d kNN over the unified Mathlib + OV2 corpus, optionally with freshness boost. Used inside the wizard's [Phase A premise-search](PhysicsPapers/LeanFormalizationV2/.claude/agents/prove-wizard-v3.md) before any `aesop` / `exact?` / manual term-mode is attempted.

```python
omega_hammer_premise(goal="∀ n, 0 < δ_comp n", top_k=10, mix_mathlib=True)
# → top-10 Mathlib + OV2 candidates ranked by Qwen3 similarity, freshness, and
#   typed-arrow neighbourhood. Wizard tries each via `exact?` / `apply?`.
```

### Custom agent: `prove-wizard-v3`

Source: [`PhysicsPapers/LeanFormalizationV2/.claude/agents/prove-wizard-v3.md`](PhysicsPapers/LeanFormalizationV2/.claude/agents/prove-wizard-v3.md) (2 216-line agent prompt). Frontmatter:

```yaml
name:        prove-wizard-v3
version:     4.4.0-2026-05-02
model:       opus[1m]                  # Claude Opus 4.7, 1 M context
effort:      max                        # high thinking budget
maxTurns:    10000                      # multi-day single-thread sessions
tools:       (45 MCP tools — omega-search, omega-orchestrator, lean-lsp,
              neo4j-math; full list in the frontmatter)
```

Identity: **Erdős Primarch × Mathematical Pantheon × Warhammer Last Wall × Escanor's Pride** — a hardened motivation/doctrine layer that resists context-compaction drift. The technical doctrine is the **5-PHASE HYBRID composition strategy**:

1. **Phase A — Top-Down Statement** (Pólya step 1+2 / Tao Think Ahead): state the harder theorem first with `n` NAMED Prop hypotheses `H₁..Hₙ`.
2. **Phase B — Truth-Rank** (Hindry-Silverman canon): sort `H₁..Hₙ` by estimated truth confidence (Tier-99 routine → Tier-80 medium → Tier-Heart analytical) and discharge in that order.
3. **Phase C — Discharge per Tier** (Tao Trim-the-Fat): `omega_hammer_premise → exact?` for Tier-99; LSP-assisted `aesop / lean_loogle` for Tier-80; long single-thread for Tier-Heart.
4. **Phase D — Bottom-Up Filling** (Fikhtenholz): when sub-machinery is missing, build foundational pieces concretely; **never defer with "Mathlib gap, defer to next wizard"** — `BUILD_MATHLIB_MACHINERY_T6_13` doctrine: *port what's needed*.
5. **Phase E — Compose & Review** (Pólya step 3+4 / Tao Question Everything): assemble unconditional theorem, run `axiom_audit` (must return `[propext, Classical.choice, Quot.sound]` only), run Yoneda bridge sweep (`find_similar` top-10).

The wizard reads `OmegaWizardLessons` Neo4j graph for prior-incident memory in its **Phase 0_GRAPH_READ** (sub-second, ≤10 K tokens) and writes new `:Lesson` / `:AntiPattern` / `:ProofPattern` / `:Incident` nodes back in **Phase 7_GRAPH_WRITE** — a self-improving feedback loop across runs.

### The empirical lesson — thinking + doctrine = solid; mass-batch = trash

The 117 000 LOC trash purge of 2026-05-05/06 had a single root cause: **mass-batch subagent dispatch without thinking and without doctrine produces compiling-but-vacuous output.** Reverse direction:

- **What works**: single-thread Opus 4.7 [1M context], `effort=max` (high thinking budget), full `prove-wizard-v3` v4.4 doctrine prompt, `omega_hammer_premise → omega-search` cascade per obligation, axiom-audit after every file, `BUILD_MATHLIB_MACHINERY_T6_13` rule (do not defer when Mathlib lacks an API).
- **What does not work**: mass-batch dispatch ("land 50 Yoneda witnesses in parallel, no doctrine, no audit") — produces `def OmegaConjecture := True` / `Nonempty S` citation stubs that compile but encode no math.

When deployed in *teams* — multiple `prove-wizard-v3` agents on disjoint files, each with thinking enabled and full doctrine — the wizard delivered cleanly: e.g. T-4 π-transcendence (14 files / ~3000 LOC / single day), T-5 Roth Wave 1–8 architectural compression (5 of 7 residual NAMEDs eliminated in 70 min wall-clock). The agent template is reusable; the doctrine is the load-bearing piece.

For deeper engineering context: [`PhysicsPapers/SOTA/proving_techniques/03_mcp_tools/`](PhysicsPapers/SOTA/proving_techniques/03_mcp_tools/) (PLAN.md + the four graph-topology tool excerpts + integration tests).

---

## Quick links

| What | Where |
|------|-------|
| Lean corpus | [`PhysicsPapers/LeanFormalizationV2/OmegaTheory/`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/) |
| Build | `cd PhysicsPapers/LeanFormalizationV2 && ~/.elan/bin/lake build` |
| Verify π milestone | `~/.elan/bin/lake env lean -e '#print axioms OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental'` (expect `[propext, Classical.choice, Quot.sound]`) |
| Physics-side scope + bridging dictionary | [`PhysicsPapers/README.md`](PhysicsPapers/README.md) |
| Formal paper with Tier 1 / Tier 2 honest-scope §0 | [`PhysicsPapers/CompleteOmegaTheory.md`](PhysicsPapers/CompleteOmegaTheory.md) |
| Static site (papers rendered) | [ramzesx.github.io/Omega-Theory-Discrete-Spacetime](https://ramzesx.github.io/Omega-Theory-Discrete-Spacetime/) |
| Style guide & doctrine | [`PhysicsPapers/LeanFormalizationV2/STYLE_GUIDE.md`](PhysicsPapers/LeanFormalizationV2/STYLE_GUIDE.md) |

---

## A note on historical references

This README and several papers were rewritten 2026-05-06 to remove the speculative framing (e.g., "Standard Model generates geometry as output", "mass is geometry-reshaping cost") that outran the actual machine-checked corpus. Older versions of these documents — and the now-deleted `Complete-Omega-Theory-Unified-Framework.md` — contained Lean-witness theorem references with file:line links that reflect the **2026-04-21 cycle-43 corpus**. After the trash purge, **many of those file paths and theorem names no longer exist or have moved**. Treat any historical citation as needing a fresh `grep` against the current corpus before relying on it.

The substrate spine — π transcendence, healing-flow Lyapunov, the bridging-framework infrastructure — is intact and machine-checked. The framework's identity is now the **bridging dictionary**, not the legacy "Ω = unified theory of everything" framing.

---

## License

CC BY 4.0. Contributions welcome — see [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

*Norbert Marchewka & Claude Opus 4.7 · OmegaTheory V2 · 2026.*
