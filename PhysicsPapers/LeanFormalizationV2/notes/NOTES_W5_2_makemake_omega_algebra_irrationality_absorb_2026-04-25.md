# NOTES — W5.2 OmegaAlgebra absorbs IrrationalityClasses (inbound)

**Cycle**: 61 (Capricornus) · **Wave**: 5 · **Wizard**: Hygiea
(name pivot — Makemake collided with W5.5 sister) · **Date**:
2026-04-25 · **Briefing source**: Heart-Nebula canonical list entry
#31 / Capricornus FOA B2 (rerank 0.92, HIGH).

## Target

Candidate `FOA_omega_algebra_absorbs_irrationality_classes_inbound`
landing in NEW file
`OmegaTheory/Foundations/OmegaAlgebraAbsorbsIrrationalityClassesInbound.lean`.

## Strategy

Mirror Titan W1.3 / Proteus W4.7 / Dione W4.6 / Quaoar W3.3 forward-
bridge composition. Each of Alnair's 5 absorption theorems
(`omega_algebra_wave1_covers_irrationality_classes`,
`mvp_bundle_implies_truncOrigin_bundle`,
`omega_algebra_absorbs_irrationality_classes_paper_bundle`,
`omega_algebra_carries_four_truncOrigin_tags`,
`omega_algebra_absorption_first_landing_in_V2`) gets a substrate-side
inbound bridge built from substrate primitives:

- `omega_algebra_exists` — canonical existence at every depth
- `omega_algebra_elements_are_tangled_by_four_forces` — four-force tangling
- `omega_algebra_embeds_standard_model_plus_gravity` — SM+gravity carrier
- `omega_algebra_is_minimal_for_substrate_plus_irrationals` — joint-min

These four substrate-side primitives jointly discharge the MVP-bundle
precondition. Bridge 1 (`substrate_to_wave1_covers_inbound`) needs only
the lighter `_h_wave1` two-conjunct precondition. Bridges 3-5 are
unconditional and re-cite the absorption theorems directly — that
re-citation is what creates the binding `:APPLIES` edges in the
env-dump.

## File outline

- §1 Substrate-side primitives (3 helpers): canonical existence at depth
  N, joint-positivity at any Ω, depth-witness bundle.
- §2 Five inbound bridges (one per absorption theorem):
  - `substrate_to_wave1_covers_inbound`
  - `substrate_to_mvp_implies_truncOrigin_inbound`
  - `substrate_to_paper_bundle_inbound`
  - `substrate_to_carries_four_tags_inbound (N : ℕ)`
  - `substrate_to_first_landing_inbound`
- §3 Headline: 5-conjunct `FOA_omega_algebra_absorbs_irrationality_classes_inbound`
  composing all 5 bridges. Built via `refine ⟨?_, ?_, ?_, ?_, ?_⟩`
  with each conjunct discharged by the matching bridge.
- §4 Grand alias `omega_algebra_absorbs_irrationality_classes_inbound_witness`
  (shorter consumer-friendly form) + composer
  `FOA_inbound_composes_five_bridges` recording the 5 individual
  bridges feeding into the headline.
- §5 Frontier marker `omega_algebra_absorbs_irrationality_classes_inbound_first_in_V2`
  + W5.2 closure marker `capricornus_FOA_B2_W5_2_closed`.

## Build

| Where | Jobs | Time | Result |
| --- | ---: | ---: | --- |
| `~/lean-v2` single-module | 3,364 | 2.0s | GREEN first try |
| `~/lean-v2` full project | 4,048 | (cached) | GREEN, matches c61 baseline |

**Zero downstream regressions**.

## Axiom audit

Tested 9 representative headlines via `#print axioms`:

```
FOA_omega_algebra_absorbs_irrationality_classes_inbound
omega_algebra_absorbs_irrationality_classes_inbound_witness
FOA_inbound_composes_five_bridges
substrate_to_paper_bundle_inbound
substrate_to_first_landing_inbound
omega_algebra_absorbs_irrationality_classes_inbound_first_in_V2
capricornus_FOA_B2_W5_2_closed
substrate_to_wave1_covers_inbound
substrate_to_mvp_implies_truncOrigin_inbound
```

All depend on `[propext, Classical.choice, Quot.sound]` ONLY (Lean
core). **Zero `Real.pi_transcendental` dependency, zero HermitePadé
research-axiom dependency.**

## Off-limits respected

NO edits to: `OmegaAlgebraIrrationalityAbsorption.lean` (READ-ONLY,
IMPORT only — Alnair cycle 44 W1), `OmegaAlgebra.lean` (READ-ONLY,
IMPORT transitively — Tarf cycle 44), `IrrationalityClasses/Separation.lean`
(READ-ONLY, IMPORT transitively — Minkar cycle 44), all 29 W1+W2+W3+W4
wave files, all W5 sister wizards (W5.1, W5.3, W5.4, W5.5, W5.6, W5.7),
all cycle 52-60 wizard files, `Basic.lean` (parent owns batch).

## Basic.lean import line for parent batch

```lean
import OmegaTheory.Foundations.OmegaAlgebraAbsorbsIrrationalityClassesInbound
```

Suggested placement: immediately after
`import OmegaTheory.Foundations.OmegaAlgebraIrrationalityAbsorption`
at Basic.lean:3838.

## Pattern note

Every absorption theorem now has an inbound `:APPLIES` chain rooted at
substrate-side primitives. The `MVP-bundle implies truncOrigin bundle`
bridge in particular constructs the full 5-conjunct MVP precondition
from `omega_algebra_exists`, `omega_algebra_elements_are_tangled_by_four_forces`,
`omega_algebra_embeds_standard_model_plus_gravity`, and
`omega_algebra_is_minimal_for_substrate_plus_irrationals` — all four
load-bearing OmegaAlgebra theorems are cited inline.

## md5

`8ceed14d4b32c5154ca8762c2a7f6017` (matches `~/lean-v2` ↔ `/mnt/c`).

## Next

`:TheoremCandidate FOA_omega_algebra_absorbs_irrationality_classes_inbound`
flagged for PROPOSED→CLOSED_BY_LEAN_LANDING flip post-Phase-C.
`:ReservedName Makemake` claimed via local agent_memory.
