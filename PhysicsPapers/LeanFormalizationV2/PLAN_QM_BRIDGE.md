# QM-Bridge 5-Phase Plan (Option B — no shortcuts)

*Created 2026-04-14 by team-lead Rigel, approved by Norbert.*

## Mission

**Derive non-relativistic quantum mechanics from the OmegaTheory V2 discrete-gravity substrate**, end to end, with every step a machine-checked Lean theorem. Target narrative:

> "This result that other substrate-derivation papers (Kulkarni's SSM, 't Hooft's cellular-automaton interpretation, Wolfram physics, Adler's trace dynamics) cite as a heuristic — we proved it as a theorem from Planck-scale first principles."

Target venue: **Foundations of Physics** or **Phys. Rev. Lett.** after Phases 1–4 all land. Interim venue after Phase 2: Journal of Mathematical Physics.

## Phase-by-phase structure

### Phase 1 — Dynamical snapshot-sequence update rule

**Blocking Phase 2.** Current `SnapshotSequence` has tick-independent metric; `schrodinger_prover` truthfully admitted this forced a static-only scope on the Schrödinger bound.

**Deliverable:** `OmegaTheory/Emergence/SnapshotDynamics.lean`. Complex-valued dynamical update `propagateDynamic : Snapshot → Snapshot` where the metric perturbation at tick `n+1` depends on the metric gradient (via discrete Laplacian) at tick `n`. This is the missing computational-feedback rule.

**Lead:** new teammate `dynamics_architect`.

**Estimated sessions:** 1–2.

### Phase 2 — Dynamical Schrödinger bound (headline)

Extend `coarseGrain_satisfies_schrodinger_static` from static to dynamical snapshot sequences. The proof goes: per-tick metric perturbation → per-tick KL-density change → per-tick `coarseGrain` change ≈ `(−iℏΔ/2m)·L·t_P`.

**Deliverable:** `coarseGrain_satisfies_schrodinger_dynamic` with explicit constant `C`, added to `SchrodingerFromLattice.lean`.

**Lead:** `schrodinger_prover` (reassigned after Phase 1 lands).

**Estimated sessions:** 2–3.

### Phase 3 — Born rule as a conservation theorem

Prove `∑_p |L(s, p, n)|² = ∑_p |L(s, p, n+1)|²` under the dynamical update. Probability conservation is a *theorem*, not an axiom.

**Deliverable:** `coarseGrain_born_rule_conservation` in new `OmegaTheory/Emergence/BornRule.lean`.

**Lead:** new teammate `probability_conservator`.

**Estimated sessions:** 1–2.

### Phase 4 — Two-slit interference from superposition

Two distinct snapshot sequences with plane-wave phases `k₁·p − ω₁·n` and `k₂·p − ω₂·n` combine via a superposition rule; the coarse-grained field at the detection lattice shows constructive/destructive bands matching `cos²((k₁ − k₂)·p/2)`.

**Deliverable:** `two_slit_interference` in new `OmegaTheory/Emergence/Interference.lean`. Uses `planeWavePhase` from `CoarseGrainingMap.lean`.

**Lead:** new teammate `interference_prover` (spawn only after Phase 2 lands; highest-risk phase per the author's own NOTES §4.4 flagging).

**Estimated sessions:** 2–4.

### Phase 5 — Paper (concurrent with Phase 4)

Update `PAPER_DRAFT.md` as theorems land. Final paper covers:

1. Abstract — four theorems from one substrate
2. §1–3 — framework
3. §4 — Phase 1 dynamical update rule
4. §5 — Phase 2 dynamical Schrödinger bound
5. §6 — Phase 3 Born rule conservation
6. §7 — Phase 4 interference
7. §8 — Discussion: Kulkarni positioning, HPW open side, Born rule derivation
8. §9 — Open: relativistic extension (Klein-Gordon from lattice, future work)

**Lead:** `paper_draft` (continuous across phases).

## Team structure

Current `qm_schrodinger` team:

| Name | Role |
|---|---|
| team-lead (Rigel) | Orchestration, synthesis, cross-phase coordination |
| `coarse_grain_builder` (Altair) | Phase 1/2/3/4 — extend `CoarseGrainingMap` as needed |
| `schrodinger_prover` | Phase 2 lead, reassigned after Phase 1 lands |
| `dispersion_wire` | Relativistic-limit bridge, on call |
| `paper_draft` | Continuous paper maintenance |

Expanding:

| Name | Role |
|---|---|
| `dynamics_architect` | Phase 1 lead (spawn NOW) |
| `probability_conservator` | Phase 3 lead (spawn after Phase 1 lands) |
| `interference_prover` | Phase 4 lead (spawn after Phase 2 lands) |

## Cross-phase rules

- **No `sorry`, no new axioms** — absolute. If a phase truly needs new external math, halt and escalate to team-lead for strategic redesign.
- **Incremental build between phases.** `lake build <module> --log-level=error` between every sub-step. No big-bang landings.
- **Honest scoping.** If a theorem genuinely doesn't close, ship the narrower true version and flag it in the paper's "Open Questions" section.
- **Peer `SendMessage` is the coordination channel.** Signatures shared via DM, blockers raised to team-lead. Neo4j graph is the background blackboard.
- **Use WSL-native `~/.elan/bin/lake` directly** — no `wsl.exe` prefix. Long timeouts acceptable; no session pressure.

## Success criteria

- Phase 1 complete: `DynamicalSnapshotSequence` exists, builds clean, has a non-trivial instance.
- Phase 2 complete: `coarseGrain_satisfies_schrodinger_dynamic` proved on a non-trivial dynamical sequence.
- Phase 3 complete: `coarseGrain_born_rule_conservation` proved.
- Phase 4 complete: `two_slit_interference` proved for a specific superposition instance.
- Paper complete: `PAPER_DRAFT.md` has final theorem statements and passes an honest readthrough.
- Final state: **0 sorry, 9 axioms (unchanged), full `lake build` clean, paper-ready**.

## Non-goals (flagged to prevent scope creep)

- Relativistic Schrödinger-from-lattice (Klein-Gordon). Flagged as future work in paper.
- Many-body / entangled quantum states. Future work.
- Continuous-time limit (vs discrete tick). Future work.
- General-curved Einstein side (HPW elimination). Parallel workstream, outside this plan.

---

*This plan is a working document. Each phase's sub-agent can propose plan modifications via `SendMessage` to team-lead. Approved modifications are recorded at the bottom of this file under "Amendments".*

## Amendments

*(none yet)*
