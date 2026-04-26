# NOTES W7-tail.1 — Sunflower — coordinationNumber inbound

Cycle 62 Capricornus Phase B Wave 7-tail wizard 1 — Sunflower (M63 / NGC 5055).
Date 2026-04-26.

## Target

Heart-Nebula canonical-list entry **#61** / Capricornus **M M2**
(rerank 0.80, MED). Headline:

```
M_coordinationNumber_inbound_via_lattice_topology
```

Sage's brief: `OmegaTheory.Spacetime.coordinationNumber : ℕ := 8`
(Phoebe c61 W1.6 substrate, `Spacetime/Lattice.lean:80`) was an
inbound-orphan. `out_d=217` (many downstream consumers), `in_d=0`
(no upstream derivation tied the literal `8` to substrate topology).

## Strategy

Pure forward-bridge composition into `Direction × Bool`:

* `Direction` is a 4-element `Fintype` (t, x, y, z) — substrate axis
  enumeration.
* Each lattice site offers 2 nearest-neighbor moves per direction
  (`shift` forward, `shiftBack` backward).
* Product cardinality `2 × 4 = 8` matches the literal `8`.
* `decide` closes every cardinality lemma; `rfl` closes the literal
  equality; `simp [coordinationNumber]; decide` chains via
  `Fintype.card_prod` to give the step-set form.

## Theorems (14 total)

| name | form | axioms |
|------|------|--------|
| `direction_card_eq_four` | `Fintype.card Direction = 4` | `[propext, Classical.choice, Quot.sound]` |
| `direction_card_pos` | `0 < Fintype.card Direction` | (Lean core) |
| `substrate_coordination_count_eq_eight` | `2 * Fintype.card Direction = 8` | (Lean core) |
| `step_set_card_eq_eight` | `Fintype.card (Direction × Bool) = 8` | (Lean core) |
| `step_set_card_eq_two_card_direction` | bridge | (Lean core) |
| `coordinationNumber_eq_two_card_direction` | **bridge eq** | `[propext, Classical.choice, Quot.sound]` |
| `coordinationNumber_eq_step_set_card` | **bridge eq** | `[propext, Classical.choice, Quot.sound]` |
| `coordinationNumber_eq_eight` | `coordinationNumber = 8` | NONE |
| `coordinationNumber_pos` | `0 < coordinationNumber` | NONE |
| `latticePoint_has_neighbor` | `∀ n, ∃ m, isNeighbor n m` | `[propext]` |
| `M_coordinationNumber_inbound_via_lattice_topology` | **5-conjunct headline** | `[propext, Classical.choice, Quot.sound]` |
| `coordinationNumber_inbound_witness` | grand alias | `[propext, Classical.choice, Quot.sound]` |
| `coordinationNumber_inbound_compact` | 3-conjunct compact alias | `[propext, Classical.choice, Quot.sound]` |
| `coordinationNumber_inbound_first_in_V2` | frontier marker | NONE |
| `M_coordinationNumber_inbound_W7_tail_1_closed` | closure marker | NONE |

## Build

* Single-module: 3,286 jobs GREEN, 14s, first try.
* Full project: 4,048 GREEN — matches cycle-61 baseline.
* 0 sorry. 0 new axioms. ZERO `Real.pi_transcendental` dependency,
  ZERO HermitePadé dependency.

## Significance

Pre-W7-tail.1: the literal `coordinationNumber = 8` had no inbound
APPLIES edge from substrate-derivation primitives. 217 downstream
files used the literal but no derivation tied it to lattice
topology. Post-W7-tail.1: the bridge equation
`coordinationNumber = 2 × Fintype.card Direction
= Fintype.card (Direction × Bool)` exposes `8` as the substrate-derived
count of nearest-neighbor moves on Z⁴, giving downstream geometry,
curvature, discrete-Noether and coordination-bound files a
categorical citation point instead of a magic literal.

## Guardrails respected

* NO edits to `Spacetime/Lattice.lean` (Phoebe W1.6, READ-ONLY IMPORT).
* NO edits to all 50+ W1-W8 wave files.
* NO edits to all sister overflow/tail wizards.
* NO edits to all cycle 52-60 wizard files.
* NO edits to `Basic.lean` (parent owns batch).

Basic.lean import line flagged for parent batch:
`import OmegaTheory.Spacetime.CoordinationNumberInbound`

md5 `5fa05bc35aace5ee860ff7b10065ae45` matches `~/lean-v2` ↔ `/mnt/c`.
