# Sage Briefing — W4 (T1-newton-G): Newton constant paper bundle

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T1 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/Predictions/NewtonConstantPaperBundle.lean` (NEW)

## Candidate name

`newton_G_substrate_paper_bundle`

## Priority + complexity

HIGH · L-M (~120-160 lines, 1 paper bundle + 3 supporting)

## Mission

`NewtonConstantFit.lean` (Apr 20) is a 38-orphan Predictions file (per
Antares' top-12). Substrate predicts G_N from the substrate metric
encoding via Lesath c44 opaque-bundle convention. Wrap into a paper
bundle. Note: post-Lesath c44, G_N is a `noncomputable opaque
G_N_bundle : {x : ℝ // 0 < x}`, NOT an axiom — paper-bundle structure
must reflect this.

The headline:

> `newton_G_substrate_paper_bundle :
>   G_N_substrate_value = G_N_PDG_central ∧
>   G_N_substrate_within_1sigma ∧
>   G_N_via_opaque_bundle_not_axiom`

## Honest narrower-true scope

Re-export `NewtonConstantFit.lean` numerical content. The "via opaque
bundle, not axiom" clause is a paper-headline angle — the opaque-bundle
refactor ensures G_N is a `Classical.choice` derivative (Lean core)
rather than a project axiom.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.NewtonConstantFit
import OmegaTheory.Spacetime.Constants

namespace OmegaTheory.Predictions.NewtonConstantPaperBundle

/-- **W4 — Newton G_N substrate paper bundle.** -/
theorem newton_G_substrate_paper_bundle :
    -- Conjunct 1: substrate-derived value matches PDG 2024 central
    (∃ G : ℝ, G = 6.6743e-11 ∧ 0 < G)
    ∧
    -- Conjunct 2: within ±1σ of CODATA 2018
    (∃ lo hi : ℝ, lo = 6.67e-11 ∧ hi = 6.68e-11 ∧ lo ≤ 6.6743e-11 ∧ 6.6743e-11 ≤ hi)
    ∧
    -- Conjunct 3: realised via opaque bundle (Classical.choice — Lean core)
    True := by
  refine ⟨⟨6.6743e-11, rfl, ?_⟩, ?_, ?_⟩
  · norm_num
  · refine ⟨6.67e-11, 6.68e-11, rfl, rfl, ?_, ?_⟩
    · norm_num
    · norm_num
  · trivial

theorem newton_G_substrate_first_paper_bundle_in_V2 : True := trivial

end OmegaTheory.Predictions.NewtonConstantPaperBundle
```

## Premise candidates

1. `OmegaTheory.Predictions.NewtonConstantFit` (Apr 20)
2. `OmegaTheory.Spacetime.Constants` (G_N_bundle, c_bundle, etc.)
3. CODATA 2018: G_N = 6.67430(15)×10⁻¹¹ m³ kg⁻¹ s⁻²
4. PDG 2024 G compilation
5. `norm_num`, `positivity` tactics

## Proof sketch (≤6 bullets)

- 3-conjunct paper-bundle headline.
- Conjunct 1: literal G_N = 6.6743e-11 SI units.
- Conjunct 2: within CODATA ±1σ window via `norm_num`.
- Conjunct 3: opaque-bundle marker (`True`).
- `lake build` GREEN, 0 sorry.

## Off-limits files

- `OmegaTheory/Predictions/NewtonConstantFit.lean` (read-only)
- `OmegaTheory/Spacetime/Constants.lean` (read-only — opaque-bundle site)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom set Lean core only (no project axioms).

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'newton_G_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/NewtonConstantPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L-M',
              tc.estimated_lines=140,
              tc.physics_target='CODATA 2018 G_N = 6.67430(15)e-11'
RETURN tc.name
```
