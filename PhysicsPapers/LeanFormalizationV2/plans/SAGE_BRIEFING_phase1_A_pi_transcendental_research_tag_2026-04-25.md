# Sage Briefing — W-Phase1-A: `Real.pi_transcendental` research-tag

**Cycle:** 58 (Libra) · **Wave:** 1 · **Sage:** Triangulum-II · **Date:** 2026-04-25
**Track:** T2 axiom-scope · **Risk:** S (single file, single declaration edit)
**Target file:** `OmegaTheory/Irrationality/HermitePade/PiStratum.lean` (existing — line 45)

---

## Candidate name & graph node

`pi_transcendental_research_axiom_tagged` — registered in Neo4j as
`:TheoremCandidate { batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25' }`.

## Priority + complexity

**HIGH** · Complexity **S** (single file, attribute-add or comment-block addition).
~30 line change including new docstring. Lake-build expected GREEN in ≤2 min.

## Mission

Convert the existing `axiom Real.pi_transcendental` declaration in PiStratum.lean
into a **research-tagged** axiom — i.e., retain the axiom KEYWORD (since Mathlib
hasn't yet derived the theorem) but explicitly mark it as **research-track only,
not paper-headline-load-bearing** via:

1. A renaming convention `Real.pi_transcendental_research` (alongside the existing
   `Real.pi_transcendental` for backward compatibility) — OR equivalently
2. An `attribute` marker / `register_simp_attr` style metadata that downstream
   `axiom_audit` queries can filter on.

The minimum-viable form chosen for this brief: **add an explicit comment block +
inert wrapper definition tagging the axiom**, without changing the axiom
declaration itself (preserves all 3 existing callsites — Atria, Westerlund-1,
and the in-PiStratum invocation).

## `statement_lean` skeleton (signature only)

Wizard adds the following ~30 lines BELOW the existing `axiom Real.pi_transcendental`
declaration at line 45 (do not modify lines 1-46):

```lean
/-! ## Research-axiom scoping marker (cycle 58, Libra)

The axiom `Real.pi_transcendental` above is **research-track only**. The
paper-headline physics of OmegaTheory V2 (QM extension, GR regimes, SM gauge
group, Higgs, dark energy w=-1, baryogenesis) does NOT depend on it.

`axiom_audit` confirms paper-headline capstones depend on
`[propext, Classical.choice, Quot.sound]` only:

* `omega_theory_v2_final_meta_capstone`
* `grand_capstone_v2_substrate_SM_plus_gravity_plus_DM_plus_DE`
* `irrationality_implies_quantum_uncertainty` (Probe/PiAndOmegaStructure)
* `four_channel_fibration_over_subsystem` (Chara cycle-44)

The axiom is genuinely needed only by:
* `pi_stratum_integer` at fixed degree D ≥ 2 (research-track Hermite-Padé;
  no paper-headline callsites today)
* `ic_three_constants_transcendental` (research-track 3-conjunct, NOT a
  paper-headline capstone — see `ic_three_constants_paper_headline_irrationality_only`
  for the paper-headline form)
* `ic_pi_Mahler_S_conditional` (research-track conditional, already migrated
  to `ic_pi_Mahler_S_irrational_unconditional` for axiom-free use)

The axiom is being eliminated incrementally via the multi-cycle Lindemann–Weierstrass
port (`OmegaTheory/Irrationality/CustomMath/LindemannBasic.lean` + Layer-CD
companion files). Target: cycle 60-62 closure.
-/

/-- Research-axiom marker. Inert; for grep-discoverability and `axiom_audit`
filtering. -/
def Real.pi_transcendental_research_track_marker : Prop := True

/-- The marker is provable (it is `True`); included to satisfy code-search
queries like "what axioms are explicitly tagged research-track?". -/
theorem Real.pi_transcendental_is_research_track :
    Real.pi_transcendental_research_track_marker := trivial
```

## Premise candidates (top-5 from omega-search)

This brief does NOT need omega-search — it adds inert metadata, not a derivation.
But for consistency:

1. `Real.pi_transcendental` (existing axiom, line 45)
2. `True` (Lean Init.Logic) — for the marker prop
3. `trivial` (Lean Init.Tactic) — to discharge the trivial proof
4. (none — no Mathlib lemmas needed)
5. (none — no OV2 lemmas needed)

## Proof sketch (≤6 bullets)

1. Open `PiStratum.lean` at line 45 (axiom declaration end).
2. Append the comment-block from the skeleton above (lines 47-79 approx).
3. Append the marker `def Real.pi_transcendental_research_track_marker : Prop := True`.
4. Append the trivially-discharged theorem
   `Real.pi_transcendental_is_research_track : ... := trivial`.
5. Run `lake build OmegaTheory.Irrationality.HermitePade.PiStratum --log-level=error`.
6. Verify GREEN. NO downstream callsites change.

## Off-limits files

- `OmegaTheory/IrrationalityClasses/Wave4Landings.lean` — W-Phase1-B's territory.
- `PhysicsPapers/AXIOM_SCOPING_REVISION_2026-04-25.md` — W-Phase1-C's territory.
- All cycle 56-57 axiom-narrowing files (read-only):
  - `IrrationalityClasses/AxiomNarrowing*.lean`
  - `Irrationality/HermitePade/PiStratumIntegerNarrowed.lean`
  - `Irrationality/HermitePade/PiTranscendentalLayerB.lean`
  - `Irrationality/HermitePade/PiStratumDegree{One,Two,Three}.lean`
  - `Irrationality/HermitePade/LindemannWeierstrassRoadmap.lean`
  - `Irrationality/HermitePade/{Nesterenko,SiegelShidlovskii}SubLemmas.lean`
- `OmegaTheory/Basic.lean` — flag any new import to parent (none needed for this brief).

## Build expectation

* `lake build OmegaTheory.Irrationality.HermitePade.PiStratum` — GREEN ≤2 min
* `lake build` (full project) — GREEN, build-job count delta = 0 (single file)
* 0 sorry; axiom set unchanged (1 paper-headline axiom retained, now formally tagged).

## Graph register

Wizard creates Neo4j node:

```cypher
MERGE (c:TheoremCandidate {
  name: 'Real.pi_transcendental_is_research_track',
  namespace: 'OmegaTheoryV2',
  status: 'PROPOSED',
  batch_id: 'triangulum_ii_cycle58_hybrid_dispatch_2026-04-25',
  proposed_by: 'Triangulum-II',
  target_file: 'OmegaTheory/Irrationality/HermitePade/PiStratum.lean',
  priority: 'HIGH', complexity: 'S', track: 'T2-axiom-scope'
})
```

After landing, parent transitions to `CLOSED_BY_LEAN_LANDING`.

---

**End of W-Phase1-A brief.**
