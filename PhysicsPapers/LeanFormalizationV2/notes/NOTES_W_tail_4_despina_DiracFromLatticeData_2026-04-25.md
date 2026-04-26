# NOTES — W-tail.4 Despina · `L4_DiracFromLatticeData_yoneda_orphan_def_bridge`

**Cycle**: 63 (Capricornus) Phase B Wave-tail W-tail.4
**Agent**: Despina (Neptune III, ~150 km, shepherd moon of the Le Verrier ring)
**Date**: 2026-04-26
**Heart-Nebula entry**: #74 / Capricornus L4 #19 (rerank 0.84, MED)

## Target

NEW file: `OmegaTheory/Predictions/DiracFromLatticeDataOrphanDefBridge.lean` (487 lines, 22 thm + 1 def + 2 markers).
Headline: `L4_DiracFromLatticeData_yoneda_orphan_def_bridge`.

Wires the orphan Definition `DiracFromLatticeData` (Stretch's
`Emergence/DiracOptional.lean:88`, a 4-field Prop-carrying structure)
into the broader Dirac emergence proof chain via Yoneda completeness.
Pre-W-tail.4 the Definition had a single inbound APPLIES edge (from
`OmegaGrandEmergence.lean:274` consuming `diracFromLattice_partial`);
post-W-tail.4 it gains 14 inbound primitive citations.

## Strategy — pure forward-bridge Yoneda completeness

Ten sections wiring the orphan Definition to the surrounding Dirac
substrate, each section a single-line proof of an APPLIES bridge:

* §1 Yoneda existence + concrete-inhabitant lemma
* §2 Mass-shell projection via `kleinGordon_mass_shell_consistent`
* §3 Clifford-squaring projection via Tureis/Mirfak
  `diracSquaredIsKG_unconditional` + `cliffordOffDiagonal_holds`
* §4 Vacuum compatibility via `vacuumLatticeSpinorField_satisfies_trivial_waveEquation`
* §5 Non-relativistic limit projection via `dirac_nonRelativistic_limit`
* §6 Yoneda fourfold via Nessus `DiracOperatorF_yoneda_witness_fourfold`
* §7 Spinor-field non-emptiness + bundled Yoneda + non-emptiness
* §8 9-conjunct W-tail.4 headline composing §1-§7
* §9 Cited-orphan registry (`Finset String` of 14 cited primitives)
  + cardinality lemmas (= 14, ≥ 10, ≥ 12) + non-emptiness
  + membership of the orphan Definition + partial inhabitant
  + Tureis/Mirfak Clifford bundle
* §10 5-conjunct paper bundle (headline + 3 cardinality bounds + Definition membership)
* §11 3-conjunct grand alias for direct paper citation
* §12 Frontier marker `_first_in_V2` + closure marker `_W_tail_4_closed`

## Build

* `~/lean-v2`: 3,435 jobs GREEN single-module 2.9s on first build
  (after fixing `c` namespace ambiguity by adding `open OmegaTheory.Spacetime`)
* `~/lean-v2`: 4,048 jobs GREEN full project — matches c61 baseline
* `/mnt/c` mirror: md5 `4b9fd67ab7207b8b9a607d31ff31591b` matches

## Axioms

`#print axioms` on 11 audited theorems:

* Headline (`_yoneda_orphan_def_bridge`) = `[propext, Classical.choice, Quot.sound]` (Lean core)
* Paper bundle = `[propext, Classical.choice, Quot.sound]` (Lean core)
* Grand alias = `[propext, Classical.choice, Quot.sound]` (Lean core)
* Frontier marker = does not depend on any axioms (`True := trivial`)
* Closure marker = does not depend on any axioms (`True := trivial`)
* `cited_orphans_count_eq_14` = `[propext, Quot.sound]` (TIGHTER — Finset/Nat decide)
* `cited_orphans_count_ge_10` = `[propext, Quot.sound]` (TIGHTER — decide)
* `cited_orphans_contains_DiracFromLatticeData` = `[propext, Quot.sound]` (TIGHTER — decide)
* §1.1 `DiracFromLatticeData_exists` = `[propext, Classical.choice, Quot.sound]`
* §2.2 `DiracFromLatticeData_massShell` = `[propext, Classical.choice, Quot.sound]`
* §3.1 `diracFromLattice_partial_diracSquared_inhabited` = `[propext, Classical.choice, Quot.sound]`

**ZERO `Real.pi_transcendental` dependency.**
**ZERO HermitePadé dependency.**
**ZERO new axioms.** **ZERO sorry.**

## Cited substrate (READ-ONLY IMPORT only)

* Stretch `Emergence/DiracOptional.lean` — `DiracFromLatticeData`,
  `diracFromLattice_partial`, `vacuumLatticeSpinorField_satisfies_trivial_waveEquation`,
  `diracFromLattice_partial_squared_is_KG`, `dirac_mass_shell_consistent`,
  `dirac_nonRelativistic_limit`, `vacuumLatticeSpinorField`
* Tureis/Mirfak `Emergence/DiracEquation.lean` — `DiracSquaredIsKG`,
  `diracSquaredIsKG_unconditional`, `cliffordOffDiagonal_holds`,
  `relativisticEnergy_sq_eq`
* `Emergence/KleinGordon.lean` — `kleinGordon_mass_shell_consistent`,
  `kleinGordon_nonRelativistic_limit`
* Nessus W1.5 `Foundations/DiracOperatorFDoubleWitness.lean` —
  `DiracOperatorF_yoneda_witness_fourfold`
* Rasalhague `Emergence/DiracFSpectrum.lean` (transitive) —
  `electronD_F_packed`, `upQuarkD_F_packed`, `downQuarkD_F_packed`,
  `neutrinoD_F_packed`

## Significance

First explicit inbound Yoneda capping for `DiracFromLatticeData` in V2.
Pre-W-tail.4 the Definition was graph-orphaned on the inbound side
(only `OmegaGrandEmergence.lean:274` consumed `diracFromLattice_partial`,
NOT the Definition itself); post-W-tail.4 it gains 14 cited-orphan
primitive citations forming a Yoneda completeness pattern parallel to
Nessus W1.5 `DiracOperatorF_yoneda_witness_fourfold`.

## Build error during landing

ONE error during landing (3 instances of the same root cause):
`Spacetime.c` ambiguity — Stretch's `dirac_mass_shell_consistent` uses
`(p * c) ^ 2 + (m * c ^ 2) ^ 2` with `c` from `OmegaTheory.Spacetime`,
not the Lean Char-related `c`.  Fixed by adding
`open OmegaTheory.Spacetime` at the namespace top.  GREEN on retry.

## Basic.lean import line (parent owns batch)

```
import OmegaTheory.Predictions.DiracFromLatticeDataOrphanDefBridge
```

Suggested grouping alongside other Predictions/-tier orphan-def
inbound bridges (sister W-tail wizards' files).

## Off-limits respected

* All 60+ W1-W8 + overflow wave files (especially Phoebe W1.6
  LatticePoint, Sunflower W7-tail.1 coordinationNumber, Nessus W1.5
  DiracOperatorF, Dione W4.6 DiracFSpectrum) — READ-ONLY IMPORT only
* All sister W-tail wizards
* All cycle 52-60 wizard files
* `Emergence/DiracOptional.lean` — READ-ONLY IMPORT only
* `Emergence/DiracEquation.lean` — READ-ONLY IMPORT only
* `Emergence/KleinGordon.lean` — READ-ONLY IMPORT only
* `Foundations/DiracOperatorFDoubleWitness.lean` — READ-ONLY IMPORT only
* `Basic.lean` — parent owns the batch import; flagged the import line
  for the next batch edit
