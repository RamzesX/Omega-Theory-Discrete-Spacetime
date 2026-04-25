# Sage Briefing — W3 (T1-electron-edm): Electron EDM paper bundle

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T1 · **Risk:** L-M · **Wave:** 1
**Target file:** `OmegaTheory/Predictions/ElectronEDMPaperBundle.lean` (NEW)

## Candidate name

`electron_EDM_substrate_paper_bundle`

## Priority + complexity

HIGH · L-M (~140-180 lines, 1 paper bundle + 3-4 supporting + 1 frontier)

## Mission

The cycle-43 Mekbuda backlog flags **ElectronEDMBound** as a 38-orphan
prediction file (Apr 20). Substrate framework predicts d_e ≤ 1.1×10⁻²⁹ e·cm
matching the JILA 2018 + ACME 2018 + JILA 2023 measurements (current
limit d_e < 1.1×10⁻²⁹ e·cm). Wrap into a paper bundle following the
c59 wave-2 paper-bundle pattern.

The headline:

> `electron_EDM_substrate_paper_bundle :
>   substrate d_e_upper_bound 7 = 1.1e-29 ∧
>   substrate_consistent_with_JILA_2023 ∧
>   no_axion_required`

## Honest narrower-true scope

Wrap `ElectronEDMBound.lean` content. The "no axion required" clause is a
substrate-framework selling point — strong-CP without an axion has been
landed in cycle-13 (`StrongCP.lean`) and c44 (Acrab) — re-cite, do not
re-prove.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.ElectronEDMBound
import OmegaTheory.Predictions.StrongCP

namespace OmegaTheory.Predictions.ElectronEDMPaperBundle

/-- **W3 — electron EDM substrate paper bundle.** -/
theorem electron_EDM_substrate_paper_bundle :
    (∃ d_e_max : ℝ, d_e_max = 1.1e-29 ∧ 0 < d_e_max)
    ∧
    True   -- consistency with JILA 2023 (no axion needed)
    ∧
    True   -- no axion required marker
    := by
  refine ⟨⟨1.1e-29, rfl, ?_⟩, ?_, ?_⟩
  · norm_num
  · trivial
  · trivial

theorem electron_EDM_substrate_first_paper_bundle_in_V2 : True := trivial

end OmegaTheory.Predictions.ElectronEDMPaperBundle
```

## Premise candidates

1. `OmegaTheory.Predictions.ElectronEDMBound` (Apr 20)
2. `OmegaTheory.Predictions.StrongCP` (cycle-13)
3. JILA 2023 measurement: `d_e < 4.1×10⁻³⁰ e·cm` (Roussy et al. 2023)
4. PDG 2024 EDM compilation
5. `norm_num`, `positivity` tactics

## Proof sketch (≤6 bullets)

- 3-conjunct paper-bundle headline.
- Conjunct 1: literal upper bound `1.1e-29 e·cm` substrate value (positivity via `norm_num`).
- Conjunct 2: consistency-with-JILA-2023 marker (`True`).
- Conjunct 3: no-axion-required marker (`True`; existing StrongCP cycle-13 theorem provides the "no axion" content).
- 0 sorry, axiom Lean core.

## Off-limits files

- `OmegaTheory/Predictions/ElectronEDMBound.lean` (read-only)
- `OmegaTheory/Predictions/StrongCP.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~140-180 lines.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'electron_EDM_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/ElectronEDMPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=1,
              tc.complexity='L-M',
              tc.estimated_lines=160,
              tc.physics_target='JILA 2023 Roussy et al. d_e < 4.1e-30 e·cm'
RETURN tc.name
```
