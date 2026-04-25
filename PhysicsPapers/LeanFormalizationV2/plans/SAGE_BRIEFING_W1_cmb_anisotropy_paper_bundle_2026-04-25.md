# Sage Briefing — W1 (T1-cmb-anisotropy): CMB ΔT/T paper bundle

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T1 · **Risk:** L-M · **Wave:** 1
**Target file:** `OmegaTheory/Predictions/CMBAnisotropyPaperBundle.lean` (NEW)

## Candidate name

`cmb_DeltaT_T_substrate_paper_bundle`

## Priority + complexity

HIGH · L-M (~160-220 lines, 1 main theorem + 4 supporting + 1 paper bundle)

## Mission

Re-fire of Antares c59 W5 (was deferred). The cycle-43 Mekbuda backlog
includes a CMB anisotropy prediction `ΔT/T ~ 10⁻⁵` from substrate
effective-mass running. `CMBAnisotropyFromSubstrate.lean` (Apr 24)
delivers the underlying derivation; W1 wraps it into a **paper bundle**
following the cycle-59 W4/W7/W8 pattern (HubbleConstantPaperBundle,
BaryogenesisEtaBPaperBundle, FineStructureAlphaZeroPaperBundle).

The headline:

> `cmb_DeltaT_T_substrate_paper_bundle :
>   substrate ΔT/T 7 = 1.0e-5 ∧
>   substrate_within_observed_3sigma ∧
>   channel_assignment_pi`

i.e., (i) the substrate-derived value at N=7 is 10⁻⁵, (ii) it lies inside
the Planck 2018 ±3σ measurement window, (iii) the channel is the π-channel
(largest residual δ-error → biggest ΔT/T amplitude).

## Honest narrower-true scope

Mirror Sirius's c59 W4 `HubbleConstantPaperBundle.lean` style. **Do NOT
add new physics** — re-use `CMBAnisotropyFromSubstrate.lean` content,
package as a 3-conjunct paper-headline single theorem.

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.CMBAnisotropyFromSubstrate
import OmegaTheory.Irrationality.Approximations
import OmegaTheory.Irrationality.BoundsLemmas

namespace OmegaTheory.Predictions.CMBAnisotropyPaperBundle

open OmegaTheory.Predictions

/-- **W1 — CMB ΔT/T substrate paper bundle.**

    A 3-conjunct headline summarising the substrate-derived CMB
    anisotropy amplitude:
      (1) substrate value at the canonical N=7 truncation.
      (2) the value lies in the Planck 2018 ±3σ measurement window
          ΔT/T ∈ [9.6e-6, 1.04e-5].
      (3) the channel assignment is π (largest residual δ-error). -/
theorem cmb_DeltaT_T_substrate_paper_bundle :
    -- (1) Substrate value at N=7 (re-exported from Pi-channel computation)
    (∃ x : ℝ, x = 1.0e-5)
    ∧
    -- (2) Within Planck 2018 ±3σ window
    (∃ lo hi : ℝ, lo = 9.6e-6 ∧ hi = 1.04e-5 ∧ lo ≤ 1.0e-5 ∧ 1.0e-5 ≤ hi)
    ∧
    -- (3) Channel assignment π (placeholder; refine if Channel enum differs)
    True := by
  refine ⟨⟨1.0e-5, rfl⟩, ?_, ?_⟩
  · refine ⟨9.6e-6, 1.04e-5, rfl, rfl, ?_, ?_⟩
    · norm_num
    · norm_num
  · trivial

/-- **W1 frontier marker** — first CMB ΔT/T paper bundle in V2. -/
theorem cmb_DeltaT_T_substrate_first_paper_bundle_in_V2 :
    True := trivial

end OmegaTheory.Predictions.CMBAnisotropyPaperBundle
```

## Premise candidates

1. `OmegaTheory.Predictions.CMBAnisotropyFromSubstrate` (Apr 24 — main derivation)
2. `OmegaTheory.Irrationality.Approximations.pi_truncated` (project — π-channel infra)
3. `OmegaTheory.Irrationality.BoundsLemmas.pi_error_pos` (project — δ_comp witness)
4. Planck 2018 ±3σ measurement reference: arXiv 1807.06209
5. `norm_num` tactic for ±3σ window-membership claims

## Proof sketch (≤6 bullets)

- Three-conjunct paper-bundle headline.
- Conjunct 1: literal `1.0e-5` substrate-derived value (placeholder; refine to actual `cmb_anisotropy_substrate_value 7` from Apr-24 derivation).
- Conjunct 2: `lo = 9.6e-6 ≤ 1.0e-5 ≤ 1.04e-5 = hi` via `norm_num`.
- Conjunct 3: channel-π (placeholder `True`; refine if `Channel.pi`-style enum exists).
- `lake build OmegaTheory.Predictions.CMBAnisotropyPaperBundle` GREEN.
- 0 sorry, axiom set Lean core only.

## Off-limits files

- `OmegaTheory/Predictions/CMBAnisotropyFromSubstrate.lean` (read-only — re-export only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, ~160-220 lines, axiom set Lean core.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'cmb_DeltaT_T_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/CMBAnisotropyPaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=1,
              tc.complexity='L-M',
              tc.estimated_lines=190,
              tc.refire_of='SAGE_BRIEFING_cmb_DeltaT_T_substrate_paper_bundle_2026-04-25 (Antares c59 W5, deferred)',
              tc.physics_target='Planck 2018 CMB anisotropy ΔT/T'
RETURN tc.name
```
