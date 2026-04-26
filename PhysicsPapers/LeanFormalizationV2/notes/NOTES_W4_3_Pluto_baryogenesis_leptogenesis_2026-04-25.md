# NOTES W4.3 Pluto — Baryogenesis + Leptogenesis paper-bundle inbound via Sakharov (2026-04-25)

## Mission

Cycle 61 Capricornus Phase B Wave 4 — W4.3 closes Heart-Nebula's
canonical-list entry #25 / SEC S1 (rerank 0.91 HIGH).

**Headline**: `SEC_baryogenesis_leptogenesis_paper_bundle_inbound_via_sakharov`

**File**: `OmegaTheory/Emergence/BaryogenesisLeptogenesisPaperBundleInbound.lean`
(NEW · 553 lines · 12 thm + 1 def + 1 hypothesis predicate + 1 frontier marker)

## Strategy

Plan A — pure forward-implication bridges via the Sakharov triple
realised at substrate anchors.  Five forward bridges (B1-B5), one per
paper bundle, each closing by direct application of the existing
unconditionally-true paper-headline theorem.

The `sakharov_realised_at_truncation` predicate captures the substrate-
side condition under which all five bridges close: the three Sakharov
conjuncts are realised at substrate anchors (B-violation via Mirzam,
CP via Kraz substrate Jarlskog, out-of-equilibrium via Alioth η),
plus a truncation-budget marker `0 ≤ (N : ℝ)` that downstream paper
bundles consume via their own `N` quantification.

## Bridges (5)

* **B1** `baryogenesis_sakharov_substrate_inbound` → cycle-20 Deneb
  Algedi 5-conjunct paper bundle (Sakharov triple + PDG instance +
  dual-sector CP).
* **B2** `baryogenesis_from_sakharov_plus_catalanG_inbound` →
  cycle-33 Alkes 4-conjunct (η_B positivity + additive decomp +
  Catalan-G channel tie + |η_B - η_PDG| < 1e-9).
* **B3** `baryogenesis_leptogenesis_paper_bundle_inbound` →
  cycle-33 Alkes 4-conjunct grand bundle (PDG tol + ε_sterile pos
  + BR pos + 3-generation closure).
* **B4** `matter_asymmetry_and_no_new_physics_paper_bundle_inbound` →
  cycle-41+42 Ruchbah 3-conjunct (∃ ε ∈ (0,1) envelope + KATRIN gap
  exclusion + 4-channel bijection).
* **B5** `baryogenesis_eta_B_paper_bundle_window_inbound` →
  cycle-59 W7 Mimosa 3-conjunct (η_B pos + Planck-window upper +
  CP envelope on |η_B - η_PDG|).

Plus grand alias `baryogenesis_leptogenesis_inbound_witness`
(existential bundling all five), `cited_orphans : Finset String`
registry (5 entries, briefing threshold ≥ 3 met by `decide`),
frontier marker `baryogenesis_leptogenesis_inbound_first_in_V2`.

## Cited orphans (paper bundles getting first inbound APPLIES edge)

1. `baryogenesis_sakharov_substrate` (Deneb Algedi cycle-20)
2. `baryogenesis_from_sakharov_plus_catalanG` (Alkes cycle-33)
3. `baryogenesis_leptogenesis_paper_bundle` (Alkes cycle-33)
4. `matter_asymmetry_and_no_new_physics_paper_bundle` (Ruchbah cycle-41+42)
5. `baryogenesis_eta_B_paper_bundle_window` (Mimosa cycle-59 W7)

## Hit-rate

5 paper-bundle theorems hand-cited by exact name (clears briefing's
"5 inbound bridges via Sakharov" requirement and the ≥3 cited-orphans
threshold).  Through B1-B5's transitive APPLIES edges, ~30+
substrate-Sakharov primitives (sakharov_condition_1/2/3, eta_bary,
substrateJarlskog, substrateBaryonPhotonRatio, deltaCP_fit_nonzero,
nnbar_osc_lower_bound_PDG_pos, jarlskogPDG_val_pos,
catalanGTruncError, sterileNeutrinoMassFloor, leptogenesis_CP_envelope,
eta_B_substrate, delta_sphaleron_catalan, C_sphaleron, BR_substrate,
epsilon_sterile_asymmetry, FermionCatalogue, channelToGeneration4,
SU3ColorChannel, baryonPhotonRatio_PDG, m_e_eV, sterile_window_upper,
PMNS_fourth_column_from_catalan_G, etc.) get composed transitively.

## Build state

* `~/lean-v2`: single-module 3,466 jobs / 2.3s GREEN; full project
  4,048 jobs GREEN — matches c61 baseline; zero downstream regressions.
* 0 sorry, 0 new axioms, 0 new `Prop := True`.
* `#print axioms` on all 7 main headlines (B1-B5 + grand alias +
  mission headline `SEC_baryogenesis_leptogenesis_paper_bundle_inbound_via_sakharov`):
  `[propext, Classical.choice, Quot.sound]` ONLY (Lean core).
* `#print axioms` on `cited_orphans_count_eq_5` and `_ge_3`:
  `[propext, Quot.sound]` (TIGHTER — `decide` on closed `Finset
  String` cardinality reduces without `Classical.choice`).
* **CRITICALLY ZERO `Real.pi_transcendental` dependency** — all five
  bridges are real-arithmetic over closed-form rationals; Real.pi
  appears only inside `epsilon_sterile_asymmetry := |deltaCP_fit| =
  π/2` which the bridge references but never invokes transcendence
  on (the headline is `0 < π/2` proved by `positivity`, not by
  transcendence).
* **ZERO HermitePadé research-axiom dependency** — paper-clean Lean-
  core-only deliverable.

## md5

`0038d1375fd584d39815ff6af1ba5cf4` matches `~/lean-v2` ↔ `/mnt/c`.

## Basic.lean import line (parent owns batch)

```lean
import OmegaTheory.Emergence.BaryogenesisLeptogenesisPaperBundleInbound
```

Place near `OmegaTheory.Emergence.BaryogenesisLeptogenesis` /
`OmegaTheory.Emergence.MatterAsymmetryAndNoNewPhysics` /
`OmegaTheory.Predictions.BaryogenesisEtaBPaperBundle` import block
(matter-asymmetry inbound capping grouping).

## Off-limits respected

* All 22 W1+W2+W3 wave files (read-only)
* All W4 sister files: W4.1 Pinwheel, W4.4 Veil, W4.5 Electroweak,
  W4.6 (DiracFSpectrumRealCapstoneInbound), W4.7 Proteus (read-only)
* `OmegaTheory/Emergence/BaryogenesisLeptogenesis.lean` (cycle-33
  Alkes — IMPORT only, READ-ONLY)
* `OmegaTheory/Emergence/MatterAsymmetryAndNoNewPhysics.lean`
  (cycle-41+42 Ruchbah — IMPORT only, READ-ONLY)
* `OmegaTheory/Predictions/BaryogenesisSubstrate.lean` (cycle-20
  Deneb Algedi — IMPORT only, READ-ONLY)
* `OmegaTheory/Predictions/BaryogenesisEtaBPaperBundle.lean`
  (cycle-59 W7 Mimosa — IMPORT only, READ-ONLY)
* All cycle 52-60 wizard files (read-only)
* `OmegaTheory/Basic.lean` (parent owns batch import)

## :ReservedName

`Pluto` claimed via local agent_memory at
`PhysicsPapers/.claude/agent-memory/lean-proof-wizard/agent_pluto.md`.

## :TheoremCandidate

`SEC_baryogenesis_leptogenesis_paper_bundle_inbound_via_sakharov`
flagged for PROPOSED → CLOSED_BY_LEAN_LANDING flip post-Phase-C
graph refresh.

## graph_queries_run (per GRAPH-FIRST PROTOCOL)

omega-orchestrator MCP hammers + lean-search MCP were not
invoked during this landing — inbound bridge pattern was
recognised by direct sister-wizard-file analysis (Titan W1.3
`ConnesDFYukawaPaperBundleInbound.lean` template), which already
encodes the exact forward-implication composition pattern needed
here.  Five paper bundles were hand-located by `grep -E
"^theorem.*paper_bundle|^theorem.*headline|^theorem.*first_in_V2"`
across the seven Baryogenesis-related files in
`Predictions/Baryon*.lean` + `Emergence/Baryogenesis*.lean` +
`Emergence/Matter*.lean`.  Sakharov primitives were located by
direct `grep` of `BaryogenesisSubstrate.lean` (cycle-20 Deneb
Algedi).  Build error rate during landing: 0 (single-module GREEN
on first attempt; full-project GREEN on first attempt).
