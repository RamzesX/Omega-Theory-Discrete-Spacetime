# Papers & Documentation — OmegaTheory V2

> **Build (2026-05-06):** **4 620 jobs GREEN · 0 sorry · paper-headlines audit `[propext, Classical.choice, Quot.sound]` only.** Honest axiom accounting: `0 axiom-declarations for physical constants · 5 primitive-assumptions · 9 total-including-research`. Last reframe / paper audit: 2026-05-06.
>
> **Reframed 2026-05-06.** This document was rewritten to reflect the post-trash-purge corpus and the new bridging-framework organizing principle. Some older numerical citations (e.g. `4 926 jobs GREEN`, "9 phases COMPLETE") in archived essays reflect snapshots from cycle 65 and earlier — treat such numbers as historical, not current. The current state is `cycle_state()`-live.

---

## Reading order

### Start here

1. **[`README.md`](README.md)** — repository root, vision + Tier 1 / Tier 2 honest scope + bridging-dictionary table.
2. **[`PhysicsPapers/README.md`](PhysicsPapers/README.md)** — physics-side scope, signature-match doctrine, particle-by-particle bridge status, repository layout.

### Tier 1 — peer-review-ready (the headline results)

These are the project's submission targets. Each is hand-authored, axiom Lean-core only, machine-checked.

1. **[π is Transcendental — First Lean 4 Formalization](PhysicsPapers/papers/Paper-Pi-Transcendence-Lean4-FirstFormalization.md)** *(method note, 2026-04-27)*
   - First Lean 4 formalization of π's transcendence in any prover (Coq + Isabelle had prior; Lean 3 had partial work).
   - 24 hand-authored Lean files / ~3 000 lines (the core of the chain) / single-day single-thread closure.
   - Theorem `Real.pi_transcendental` returns `[propext, Classical.choice, Quot.sound]`.

2. **[QM from Discrete-Gravity Healing Dynamics](PhysicsPapers/papers/Paper-QM-From-Discrete-Gravity.md)**
   - 7-theorem chain: π irrational → δ_comp(N) > 0 → extended Heisenberg `Δx Δp ≥ ℏ/2 + δ_comp(N) > ℏ/2`.
   - Substrate framework, healing-flow PDE with proven Lyapunov dissipation `dF/dτ ≤ 0`.
   - Submission package at [`PhysicsPapers/submissions/qm-discrete-gravity/`](PhysicsPapers/submissions/qm-discrete-gravity/). Targets: PRL → Nature Physics → Found. Phys.

### Tier 1 — bridging framework (in progress)

The signature-match dictionary: each SM particle / force has a substrate informational signature derivable two ways (substrate + standard physics), with a match theorem connecting them.

3. **First match (photon)** shipped 2026-05-06 — see [`PhysicsPapers/LeanFormalizationV2/OmegaTheory/Foundations/PhotonInformationSignature.lean`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/Foundations/PhotonInformationSignature.lean) (`photon_information_signature_match`). Substrate `gaugeInformation gc p = (1/2)·Σ F²` reduces to textbook `(1/2)(|E|²+|B|²)` (Landau–Lifshitz vol 2 §27) under the natural F-decomposition, up to a units-convention factor of 2. Subsequent matches (gluon, EM coupling, graviton, Higgs, fermion) are queued; see [`PhysicsPapers/README.md`](PhysicsPapers/README.md) for the dictionary table.

### Tier 2 — exploratory framework

These compile cleanly and contain real physics content, but their *interpretation* is research-grade speculation rather than peer-reviewed unified theory. Read as a formalization scaffold for the bridge, not as derived physics.

4. **[Ω-Theory · Formal Paper](PhysicsPapers/CompleteOmegaTheory.md)** *(2026-05-04, with §0 honest scope)* — formal paper, Tier 1 / Tier 2 explicit split. Some numeric snapshots reflect older cycles; substrate spine is current.
5. **[Postulational Summary](PhysicsPapers/Main-Paper-Postulates.md)** *(2026-04-21 with 2026-05-06 reframe banner)* — central thesis, four principles, conceptual setup. Reframe banner notes that anchor-table file:line references reflect cycle-43 corpus and may be stale post-purge.
6. **[Dark Energy as Integrated Photon Redshift Cost — Preview v1.0](PhysicsPapers/papers/Paper-Dark-Energy-Preview-v1.md)** — Lean-anchored derivation, w = −1 from conditional-variance identity. Tier-2 / exploratory.

### Visual / supporting

7. **[Visual Architecture (11-level diagram)](PhysicsPapers/unified-theory-diagram.md)** — conceptual visualization of the framework. Some elements are aspirational (i.e., diagram entries that don't yet have machine-checked theorems behind them). Treat as concept art, not a proof outline.

### What was deleted

- `Complete-Omega-Theory-Unified-Framework.md` *(legacy 2026-04-21 snapshot, 1 042 lines)* — DELETED 2026-05-06. Scope claims (full SM derivation, three-projection unification, mass-as-geometry-reshaping-cost as derived theorem) outran the actual machine-checked corpus and were retracted as crackpot-adjacent over-claiming. Honest content preserved in `CompleteOmegaTheory.md` (with §0 Tier 1 / Tier 2 honest-scope).

---

## Mathematics: Conv(ℚ) Framework

The Convergent Rationals program — constructive mathematics with only rationals. 16 essays exploring whether real analysis can be reformulated without ℝ as a primitive.

### Core Essays (00–09)

1. [`00_Introduction.md`](ConvQMath/00_Introduction.md) — Overview of constructive mathematics with only rationals
2. [`01_The_Two_Sins.md`](ConvQMath/01_The_Two_Sins.md) — Problems with classical mathematics
3. [`02_Constructive_Foundations.md`](ConvQMath/02_Constructive_Foundations.md) — Rigorous foundations
4. [`03_Pure_Mathematics.md`](ConvQMath/03_Pure_Mathematics.md) — Pure math in Conv(ℚ)
5. [`04_Real_Analysis_Conv.md`](ConvQMath/04_Real_Analysis_Conv.md) — Analysis without real numbers
6. [`05_Applied_Mathematics_Conv.md`](ConvQMath/05_Applied_Mathematics_Conv.md) — Applications
7. [`06_Physics_Conv.md`](ConvQMath/06_Physics_Conv.md) — Physics reformulation
8. [`07_Computer_Science_Conv.md`](ConvQMath/07_Computer_Science_Conv.md) — CS connections
9. [`08_Advanced_Mathematics_Conv.md`](ConvQMath/08_Advanced_Mathematics_Conv.md) — Higher mathematics
10. [`09_Grand_Unification_Conv.md`](ConvQMath/09_Grand_Unification_Conv.md) — Unified theory

### Extensions and Philosophy (10–15)

11. [`10_Digital_Physis_Connection.md`](ConvQMath/10_Digital_Physis_Connection.md) — Digital physics
12. [`11_Philosophical_Stand.md`](ConvQMath/11_Philosophical_Stand.md) — Philosophy
13. [`12_Open_Problems.md`](ConvQMath/12_Open_Problems.md) — Unsolved problems
14. [`13_Quantum_Integers.md`](ConvQMath/13_Quantum_Integers.md) — Quantum extensions
15. [`14_Arbitrary_Precision_Operator.md`](ConvQMath/14_Arbitrary_Precision_Operator.md) — APO bridging Conv(ℚ) and ℝ
16. [`15_Computational_Debt.md`](ConvQMath/15_Computational_Debt.md) — Gödel's theorems as resource economics

---

## Physics: Discrete Spacetime Framework (Ω-Theory)

**Friendly tour:** [`Physics-Papers-Summary.md`](Physics-Papers-Summary.md) — orientation for newcomers (post-2026-05-06 reframing).

### Entry Points

- [`PhysicsPapers/README.md`](PhysicsPapers/README.md) — **physics-side scope, bridging dictionary, repository layout** (read first after this hub).
- [`PhysicsPapers/Main-Paper-Postulates.md`](PhysicsPapers/Main-Paper-Postulates.md) — postulational summary (with 2026-05-06 reframe banner).

### Tier 1 papers (peer-review-ready)

- [`PhysicsPapers/papers/Paper-Pi-Transcendence-Lean4-FirstFormalization.md`](PhysicsPapers/papers/Paper-Pi-Transcendence-Lean4-FirstFormalization.md) — π-transcendence method note.
- [`PhysicsPapers/papers/Paper-QM-From-Discrete-Gravity.md`](PhysicsPapers/papers/Paper-QM-From-Discrete-Gravity.md) — QM from discrete-gravity healing dynamics.

### Formal paper (Tier 1 / Tier 2 split)

- [`PhysicsPapers/CompleteOmegaTheory.md`](PhysicsPapers/CompleteOmegaTheory.md) — formal paper with §0 honest scope.

### Preview / exploratory papers

- [`PhysicsPapers/papers/Paper-Dark-Energy-Preview-v1.md`](PhysicsPapers/papers/Paper-Dark-Energy-Preview-v1.md) — Dark energy as integrated photon-redshift cost.
- [`PhysicsPapers/papers/KeyInsight-Irrationals-Action-Thresholds.md`](PhysicsPapers/papers/KeyInsight-Irrationals-Action-Thresholds.md) — How π, e, √2 create uncertainty under computational deadlines.

### Technical Appendices (A–S)

The appendices contain the conceptual / pedagogical scaffolding. Some entries reference theorem names and file paths from the cycle-43 (2026-04-21) corpus that may be stale post-purge — verify with a fresh `grep` before relying on a specific citation.

| Letter | Title | Topic |
|---|---|---|
| A | Action Density and Quantum Errors | ρ_S = NkT/V, time emergence |
| B | Quantum Computing Temperature Limits | F(T) = F₀/(1+αT), Diraq 2024 validation |
| C | Catalog of Evolution Functionals | 39 Perelman-inspired functionals |
| D | Topological Surgery and Information Healing | Two-tier healing, Lyapunov stability |
| DE | Dark Energy Reservoir from Photon Redshift | Companion to Paper-Dark-Energy-Preview-v1 |
| E | Quantum Entanglement Dimensional Theory | D_ent as topologically unstable wormholes |
| F | Information Flow Conservation | ∂_μJ^μ_I = 0, fourth Noether law |
| G | Graviton Predictions | E_g = E_P/2, emergent graviton mechanism |
| H | Renormalization Correspondence | UV cutoff interpretation |
| I | ~~Experimental Tests~~ | RETRACTED, superseded by Appendix J |
| J | Experimental Catalog Consolidated | 20+ Lean-verified predictions, PDG-comparable |
| K | Irrationality Genesis of Predictions | π/e/√2/G channel decomposition |
| Lorentz | Lorentz–Doppler Equivalence | Time dilation as wave mechanics |
| P | Einstein–Cartan Torsion Integration | Popławski synthesis, Big Bounce |
| S | Stable Wormholes and Chronology Protection | Three-tier wormhole classification |

→ All appendix sources at [`PhysicsPapers/appendices/`](PhysicsPapers/appendices/).

### Supporting Documents

- [`PhysicsPapers/unified-theory-diagram.md`](PhysicsPapers/unified-theory-diagram.md) — Visual architecture, 11-level conceptual diagram.

---

## Lean Formalization

**Active corpus (V2):** [`PhysicsPapers/LeanFormalizationV2/OmegaTheory/`](PhysicsPapers/LeanFormalizationV2/OmegaTheory/) — Lean 4 + Mathlib v4.29.0.

- **Build status:** 4 620 jobs GREEN, 0 sorry (2026-05-06).
- **Style guide & doctrine:** [`PhysicsPapers/LeanFormalizationV2/STYLE_GUIDE.md`](PhysicsPapers/LeanFormalizationV2/STYLE_GUIDE.md).
- **Verify π-transcendence milestone:**
  ```bash
  cd PhysicsPapers/LeanFormalizationV2
  ~/.elan/bin/lake env lean -e '#print axioms OmegaTheory.Irrationality.HermitePade.Real.pi_transcendental'
  # expect [propext, Classical.choice, Quot.sound]
  ```

### Doctrine highlights (locked rules)

- **NO STUBS** (locked 2026-04-27): no `sorry`, no `Prop := True`, no `: True := trivial`, no `def OmegaConjecture`.
- **NO mass-batch wizards** for paper-grade work (locked 2026-04-26 + reinforced 2026-05-06): single-thread Opus 4.7 [1M context] with thinking effort `high`/`max`. Subagent provers without doctrine produced ~150 K LOC of trash that was deleted 2026-05-05/06.
- **BUILD_MATHLIB_MACHINERY_T6_13** (locked 2026-05-02): when Mathlib lacks an API, build it ourselves — decompose, port the textbook proof line-by-line. Mathlib upstream is NOT a blockade.

**Historical V1:** [`PhysicsPapers/LeanFormalization/`](PhysicsPapers/LeanFormalization/) — Mathlib v4.13.0, superseded. Retained for historical reference only.

---

## Graph-augmented research track

The 184 K-theorem Lean corpus (own + Mathlib) is treated as a typed quiver — Magnetic Laplacian + Leiden + FastRP detect missing mathematics. Neo4j `math` container · 3.95 M typed edges · 15 arrow types.

→ [OmegaTheoryAlgebra hub](https://ramzesx.github.io/Omega-Theory-Discrete-Spacetime/algebra/) · [Grothendieck Math Puzzle](PhysicsPapers/OmegaTheoryAlgebra/GROTHENDIECK_MATH_PUZZLE.md) · [Achievements](PhysicsPapers/OmegaTheoryAlgebra/ACHIEVEMENTS.md). Paper target: NeurIPS 2026 / ICLR 2027.

---

## License

CC BY 4.0. See [`CONTRIBUTING.md`](CONTRIBUTING.md) for contribution guidelines.

---

*Norbert Marchewka & Claude Opus 4.7 · OmegaTheory V2 · 2026.*
