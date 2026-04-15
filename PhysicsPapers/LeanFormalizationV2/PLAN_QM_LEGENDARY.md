# Phase 6 — The Legendary Plan: Complete QM from Discrete Gravity

*Created 2026-04-15 by team-lead Rigel. Authorised by Norbert: "do what will make this repo legendary, connect with QM."*

## Thesis

After Phases 1–4 (dynamical update, Schrödinger evolution, Born rule, interference), three von-Neumann postulates of QM remain underived from the substrate: **uncertainty, measurement, entanglement**. This plan derives all three **as theorems**, then assembles a single capstone theorem

    grand_qm_emergence : (substrate axioms) → (von Neumann postulates)

stating that every defining feature of non-relativistic QM emerges as a theorem from discrete-gravity healing dynamics.

If the capstone lands, this is the first machine-checked complete derivation of QM from a discrete substrate. The paper's headline theorem becomes **quoted verbatim** by any reviewer who cares about the claim.

## Phase 6A — Heisenberg uncertainty principle

**Target theorem.** For a `LatticeComplexField` ψ with normalisation `∑ |ψ|² = 1` over a finite region, and position / momentum operators defined on the lattice:

```lean
theorem heisenberg_uncertainty_from_lattice
    (ψ : LatticeComplexField) (region : Finset LatticePoint) (tick : ℕ)
    (hnorm : ∑ p ∈ region, ‖ψ p tick‖² = 1) :
    variance_x ψ region tick * variance_p ψ region tick ≥ (ℏ / 2)²
```

**Infrastructure:** existing `Irrationality/Uncertainty.lean` has `extendedUncertaintyBound` (Planck-scale corrected form) and `computationalUncertainty`. Bridge these to the coarseGrain / LatticeComplexField framework.

**Owner:** new teammate `uncertainty_prover`.

**Status:** sessional.

## Phase 6B — Measurement / projection

**Target theorem.** Measurement at a lattice point `q ∈ region` is modelled as a coarse-graining truncation that zeros out ψ everywhere except `q`, renormalising. The probability of outcome `q` equals `|ψ q|²` (Born rule, already proved in Phase 3), and the post-measurement state is well-defined.

```lean
def measurementProjector (q : LatticePoint) : LatticeComplexField →ₗ LatticeComplexField := ...

theorem measurement_postulate
    (ψ : LatticeComplexField) (q : LatticePoint) (tick : ℕ) :
    let ψ' := measurementProjector q ψ
    probability_of_outcome ψ q tick = ‖ψ q tick‖²
  ∧ post_measurement_state ψ' q tick = normalise (ψ · δ_q)
```

**Infrastructure:** uses Phase 3's `coarseGrainWithPhase_info_bounded` + `BornRule.bornRuleConservation`.

**Owner:** new teammate `measurement_prover`.

**Status:** sessional.

## Phase 6C — Entanglement & tensor product

**Target theorem.** Two snapshot sub-systems `s₁, s₂` on disjoint lattice regions can be combined into a joint `SnapshotSequencePair` whose coarseGrain is the **tensor product** of the individual coarse-grains. Bell-state configurations exist and violate the CHSH inequality.

```lean
structure SnapshotSequencePair where
  s₁ : SnapshotSequence; s₂ : SnapshotSequence; regions_disjoint : ...

def tensorField : SnapshotSequencePair → LatticeComplexField × LatticeComplexField → ℂ

theorem bell_state_exists : ∃ pair : SnapshotSequencePair, is_maximally_entangled pair

theorem chsh_violation
    (pair : SnapshotSequencePair) (h : is_maximally_entangled pair) :
    chsh_correlator pair ≥ 2 * Real.sqrt 2
```

**Infrastructure:** uses Phase 4 superposition structure from `Interference.lean`.

**Owner:** new teammate `entanglement_architect`.

**Status:** highest-risk of the three. If the full CHSH inequality closure is out of scope, ship the **correlation-function theorem** (two entangled lattice subsystems show `cos²(θ₁ − θ₂)` correlations, which is already non-classical).

## Phase 6D — Capstone: the Grand Theorem

**Target theorem.** A single statement bundling all 4+3 = 7 QM postulates as derived theorems:

```lean
theorem grand_qm_emergence
    (s : DynamicalSnapshotSequence) (hscope : s.HasZeroFunctional) :
    let ψ := coarseGrain s
    -- P1 (States): ψ is a LatticeComplexField with bounded L² norm
    LatticeL2Norm_bounded ψ ∧
    -- P2 (Superposition): coarseGrain preserves complex addition structure
    linear_in_snapshot_superposition ψ ∧
    -- P3 (Dynamics / Schrödinger): ψ obeys the dynamical bound
    satisfies_schrodinger_dynamic ψ ∧
    -- P4 (Born rule): ∑|ψ|² conserved
    satisfies_born_rule ψ ∧
    -- P5 (Interference): exact two-path formula
    satisfies_interference ψ ∧
    -- P6 (Uncertainty): ΔxΔp ≥ ℏ/2
    satisfies_heisenberg ψ ∧
    -- P7 (Measurement): projection is well-defined
    satisfies_measurement ψ
```

**Owner:** `capstone_theorist` (new teammate; spawned after 6A, 6B, 6C land). Assembles the 7 pieces via `And` + references.

## Team expansion for Phase 6

Additions to `qm_schrodinger_v2`:

| Name | Phase | Owner of |
|---|---|---|
| `uncertainty_prover` | 6A | `Heisenberg.lean` |
| `measurement_prover` | 6B | `Measurement.lean` |
| `entanglement_architect` | 6C | `Entanglement.lean` |
| `capstone_theorist` | 6D | `QuantumMechanicsCapstone.lean` (post-6A/B/C) |

Continuing: `paper_draft` for §8 capstone section + rewriting abstract to reflect the grand theorem.

## Rules (same as before)

- **No `sorry`, no new axioms.** Absolute.
- **No shortcuts.** Narrower true theorem beats dressed-up false one.
- **Incremental build between phases.**
- **`HasZeroFunctional` scope** remains the common regime — extend only if possible.
- **Honest scoping** for Phase 6C if CHSH closure is out of reach.

## Success criteria

- 6A + 6B + 6C each land with zero sorry, zero new axioms.
- 6D capstone assembles cleanly.
- Full `lake build` stays green throughout.
- Paper section §8 rewritten as "Grand QM Emergence Theorem" with the capstone as the headline.

## Publication target

**Foundations of Physics** primary, **Phys. Rev. Lett.** alternative (short-form 4-page letter with the capstone theorem as the abstract-equation). Possible follow-up: submission to the annual "Best Foundational Paper" prize at whichever venue accepts.

---

*This is the legendary push. Execute carefully.*
