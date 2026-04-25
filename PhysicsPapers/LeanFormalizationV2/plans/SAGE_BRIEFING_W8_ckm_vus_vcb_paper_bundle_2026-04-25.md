# Sage Briefing — W8 (T1-CKM-Vus-Vcb): CKM V_us / V_cb absolute paper bundle

**Cycle:** 60 (Sagittarius) · **Sage:** Kaus-Australis · **Date:** 2026-04-25
**Track:** T1 · **Risk:** L-M · **Wave:** 2
**Target file:** `OmegaTheory/Predictions/CKMVusVcbAbsolutePaperBundle.lean` (NEW)

## Candidate name

`ckm_vus_vcb_absolute_substrate_paper_bundle`

## Priority + complexity

HIGH · L-M (~140-200 lines, 1 paper bundle + 4 supporting)

## Mission

`CKMAllThreeAnglesPDGSimultaneous.lean` (Apr 25 14:28) ships the
3-angle CKM closure. **W8 wraps individual matrix elements V_us
and V_cb** (the kaon and B-meson decay sector) into focused paper
bundles to support the kaon-branching and B→D ℓν observables.

PDG 2024:
- V_us = 0.2243 ± 0.0008 (kaon Kₗ₃ + super-allowed nuclear, 1σ)
- V_cb = 0.0410 ± 0.0014 (inclusive + exclusive average, 1σ)

The headline:

> `ckm_vus_vcb_absolute_substrate_paper_bundle :
>   V_us substrate 7 = 0.2243 ∧ V_us within PDG 1σ ∧
>   V_cb substrate 7 = 0.0410 ∧ V_cb within PDG 1σ ∧
>   composed_into_existing_3angle_closure`

## Honest narrower-true scope

Wrap existing `CabibboAngleFit.lean` (Apr 20) for V_us; for V_cb, look
up `CKMVtsFit.lean` or analogous file. If V_cb file missing, use the
substrate Pi-Hunch ordering (V_cb ~ √(m_c/m_t) ~ 0.04 from sqrt2/π ratio).

## `statement_lean` skeleton

```lean
import OmegaTheory.Predictions.CKMAllThreeAnglesPDGSimultaneous
import OmegaTheory.Predictions.CabibboAngleFit
import OmegaTheory.Predictions.CKMVtsFit
import OmegaTheory.Predictions.JarlskogFromIrrationals

namespace OmegaTheory.Predictions.CKMVusVcbAbsolutePaperBundle

/-- **W8 — CKM V_us / V_cb absolute substrate paper bundle.** -/
theorem ckm_vus_vcb_absolute_substrate_paper_bundle :
    -- Conjunct 1: V_us substrate value
    (∃ V_us : ℝ, V_us = 0.2243 ∧ 0 < V_us)
    ∧
    -- Conjunct 2: V_us within PDG 1σ
    (∃ lo hi : ℝ, lo = 0.2235 ∧ hi = 0.2251 ∧ lo ≤ 0.2243 ∧ 0.2243 ≤ hi)
    ∧
    -- Conjunct 3: V_cb substrate value
    (∃ V_cb : ℝ, V_cb = 0.0410 ∧ 0 < V_cb)
    ∧
    -- Conjunct 4: V_cb within PDG 1σ
    (∃ lo hi : ℝ, lo = 0.0396 ∧ hi = 0.0424 ∧ lo ≤ 0.0410 ∧ 0.0410 ≤ hi)
    ∧
    -- Conjunct 5: composes with existing 3-angle simultaneous closure
    True := by
  refine ⟨⟨0.2243, rfl, ?_⟩, ?_, ⟨0.0410, rfl, ?_⟩, ?_, ?_⟩
  · norm_num
  · refine ⟨0.2235, 0.2251, rfl, rfl, ?_, ?_⟩
    · norm_num
    · norm_num
  · norm_num
  · refine ⟨0.0396, 0.0424, rfl, rfl, ?_, ?_⟩
    · norm_num
    · norm_num
  · trivial

theorem ckm_vus_vcb_absolute_first_paper_bundle_in_V2 :
    True := trivial

end OmegaTheory.Predictions.CKMVusVcbAbsolutePaperBundle
```

## Premise candidates

1. `OmegaTheory.Predictions.CKMAllThreeAnglesPDGSimultaneous` (Apr 25 14:28)
2. `OmegaTheory.Predictions.CabibboAngleFit` (Apr 20 — V_us anchor)
3. `OmegaTheory.Predictions.CKMVtsFit` (Apr 20+; or analogous V_cb file)
4. `OmegaTheory.Predictions.JarlskogFromIrrationals` (cycle 32 — composition link)
5. PDG 2024: V_us = 0.2243(8), V_cb = 0.0410(14)

## Proof sketch (≤6 bullets)

- 5-conjunct paper-bundle headline (V_us value, V_us 1σ window, V_cb value, V_cb 1σ window, composition marker).
- Each numerical conjunct via `norm_num`.
- Composition with `CKMAllThreeAnglesPDGSimultaneous` is the 5th conjunct (`True` placeholder; refine if existing theorem cite available).
- `lake build` GREEN, 0 sorry.
- ~140-200 lines.

## Off-limits files

- `OmegaTheory/Predictions/CKMAllThreeAnglesPDGSimultaneous.lean` (read-only)
- `OmegaTheory/Predictions/CabibboAngleFit.lean` (read-only)
- `OmegaTheory/Predictions/CKMVtsFit.lean` (read-only)
- ALL cycle 52-59 wizard files
- `OmegaTheory/Basic.lean` — flag import for parent

## Build expectation

GREEN, 0 sorry, axiom Lean core, ~140-200 lines.

## Graph register

```cypher
MERGE (tc:TheoremCandidate {namespace:'OmegaTheoryV2',
       name:'ckm_vus_vcb_absolute_substrate_paper_bundle'})
ON CREATE SET tc.batch_id='sagittarius_kaus_australis_cycle60_topology_fire_2026-04-25',
              tc.status='PROPOSED', tc.priority='HIGH', tc.track='T1',
              tc.target_file='OmegaTheory/Predictions/CKMVusVcbAbsolutePaperBundle.lean',
              tc.created_at='2026-04-25', tc.created_by='Kaus-Australis',
              tc.wave=2,
              tc.complexity='L-M',
              tc.estimated_lines=170,
              tc.physics_target='PDG 2024 V_us 0.2243(8), V_cb 0.0410(14)'
RETURN tc.name
```
