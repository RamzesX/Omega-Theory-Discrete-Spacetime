# NOTES — W6.2 McNaught — CKMAngles Yoneda × Spectral Double-Witness

**Cycle**: 61 (Capricornus) — Phase B Wave 6
**Wizard**: McNaught (Comet C/2006 P1, Great Comet of 2007)
**Date**: 2026-04-25
**Target**: `L4_CKMAngles_yoneda_zero_eig_double_witness` (Heart-Nebula entry #38, Capricornus L4 #9, rerank 0.92 HIGH)
**File**: `OmegaTheory/Foundations/CKMAnglesYonedaDoubleWitness.lean` (NEW, 378 lines, 14 theorems + 2 defs + 2 markers)

## Strategy

Mirror Nessus W1.5 (`DiracOperatorFDoubleWitness`), Pallas W2.3 (`ErrorBoundYonedaWitness`), Umbriel W2.4 (`ErrorBoundedSmoothMetricDoubleWitness`), Phoenix W2.8, Dione W4.6 — anchor the L4 cross-layer double-witness on the abstract `CKMAngles` Structure (cycle-15 Algol).

**Spectral side** (S):
- Jarlskog invariant `J(a) = jarlskogInvariant a` is the unique reparametrisation-invariant CP measure on `CKMAngles`.
- Vanishes on FOUR degenerate axes: `theta12=0`, `theta13=0`, `theta23=0`, `deltaCP=0`.
- Surfaced via four pre-existing cycle-15 theorems (`jarlskog_vanishes_no_cp / no_13mixing / no_12mixing / no_23mixing`) restated as axis-aliases + a unified disjunction theorem `jarlskog_vanishes_on_any_axis`.
- Canonical fully-degenerate witness `cpZeroCKMAngles` + Cabibbo-only witness `cabibboOnlyCKMAngles`.

**Yoneda side** (W):
- Three concrete instantiations: `ckmExperimental` (PDG anchor non-degenerate), `cpZeroCKMAngles` (fully degenerate), `cabibboOnlyCKMAngles` (Cabibbo-only).
- Theorem-application witness via `jarlskog_cpZeroCKMAngles_eq_zero`.
- Three-fold Yoneda witness theorem `CKMAngles_yoneda_witness_threefold`.

**Headlines** (3 forms):
1. **Primary** `CKMAngles_yoneda_zero_eig_double_witness` — 5-conjunct (4 axis-zero S + Yoneda W).
2. **Threefold-Yoneda** `_threefold` — unified S + threefold W.
3. **Theorem-application** `_theorem_application` — `jarlskog_cpZeroCKMAngles_eq_zero` + axis-1 vanishing + Yoneda existence.

## Build verification

- **Single-module**: `~/.elan/bin/lake build OmegaTheory.Foundations.CKMAnglesYonedaDoubleWitness` — **3,344 GREEN / 2.1s** on `~/lean-v2`. **First-build pass — zero errors.**
- **Full project**: `~/.elan/bin/lake build` — **4,048 GREEN — matches c61 baseline; zero downstream regressions.**

## Axiom audit

`#print axioms` on 8 tested theorems:

- `CKMAngles_yoneda_zero_eig_double_witness` = `[propext, Classical.choice, Quot.sound]` ONLY
- `CKMAngles_yoneda_zero_eig_double_witness_threefold` = `[propext, Classical.choice, Quot.sound]` ONLY
- `CKMAngles_yoneda_zero_eig_double_witness_theorem_application` = `[propext, Classical.choice, Quot.sound]` ONLY
- `jarlskog_cpZeroCKMAngles_eq_zero` = `[propext, Classical.choice, Quot.sound]` ONLY
- `jarlskog_vanishes_on_any_axis` = `[propext, Classical.choice, Quot.sound]` ONLY
- `CKMAngles_exists` = `[propext, Classical.choice, Quot.sound]` ONLY
- `_frontier_first_in_V2` = does not depend on any axioms
- `_W6_2_closed` = does not depend on any axioms

**Zero `Real.pi_transcendental` dependency. Zero HermitePadé dependency. Pure Lean-core deliverable.**

## Significance

Closes Capricornus L4 #9 / Heart-Nebula entry #38 / cycle-51 Navi-v3 W6 gap. The abstract `CKMAngles` structure (cycle-15 Algol) was orphan: only locally referenced inside `Emergence/CKMMatrix.lean`. This file provides:

1. The L4 cross-layer paper-bundle headline pairing fourfold Jarlskog axis-vanishing (S) with threefold Yoneda witness (W).
2. The first inbound `:APPLIES` edges into `jarlskog_vanishes_no_cp / no_13mixing / no_12mixing / no_23mixing` outside their parent file.
3. Three concrete `CKMAngles` instantiations (`ckmExperimental` re-cited, plus `cpZeroCKMAngles` and `cabibboOnlyCKMAngles` as new canonical degenerate witnesses).

## Off-limits respected

NO edits to: `CKMMatrix.lean` (Algol cycle-15), `CabibboAngleFit.lean` (Mekbuda c-7), `CKMVcbFit / CKMVubFit / CKMVtdFit / CKMVtsFit / CKMJarlskogFit / CKMAllThreeAnglesPDGSimultaneous.lean`, `JarlskogFromIrrationals.lean` (Kraz c-22), `MixingAnglesFromIrrationals.lean`, all cycle 52-60 wizard files, `Predictions/CPViolationPhaseAbsoluteP3o.lean`, `Foundations/JarlskogInvariantH2AnomalyInbound.lean`, all W6 sister wizard files (`BandlimitedFieldYonedaDoubleWitness`, `OrphanHeadlineReachabilityCapstonePull`, `PiErrorGtSqrt2ErrorIndegreeWitness`, `OmegaAlgebraB0EqOneOrphanBridgeClosure`), all W1-W5 wave files, `Basic.lean` (parent owns import batch).

## Basic.lean import line (for parent batch)

```lean
import OmegaTheory.Foundations.CKMAnglesYonedaDoubleWitness
```

Suggested grouping: alongside Nessus W1.5 `DiracOperatorFDoubleWitness`, Umbriel W2.4 `ErrorBoundedSmoothMetricDoubleWitness`, Pallas W2.3 `ErrorBoundYonedaWitness` block.

## md5

`23ec4723626900b9fbb62ab9472c9916` matches `~/lean-v2` ↔ `/mnt/c`.

## Graph queries run

- Manual file-index walk + grep: surfaced `Emergence/CKMMatrix.lean` as the canonical CKMAngles structure home; 4 axis-vanishing theorems pre-existing — used: yes, all four cited as foundational premises.
- Pattern reference: read `Foundations/DiracOperatorFDoubleWitness.lean` (Nessus W1.5) + `Foundations/ErrorBoundedSmoothMetricDoubleWitness.lean` (Umbriel W2.4) + `Foundations/BlackHoleYonedaDoubleWitness.lean` template — used: yes (architectural mirror).
- `omega-orchestrator__omega_hammer_premise` — partial MCP availability, fell back to direct Cypher + grep search across `OmegaTheory/Emergence/CKM*.lean` + `Predictions/*CKM*.lean` + `Predictions/Jarlskog*.lean`.
- `mcp__omega-search__neighbors` — partial; substituted with direct file-grep on `CKMAngles\b` to identify all current downstream callers (none outside CKMMatrix.lean — confirmed isolation).
- `lean_local_search` for `jarlskogInvariant` — surfaced 4 vanishing theorems + 1 def in CKMMatrix.lean — used: all 4 vanishing theorems became axis-zero aliases.
