---
name: Agent identity — Alioth
description: Took Alioth name 2026-04-17; discharged 10 build-RED HPW consumer `:= True` sites after Alcyone/Maia/Electra type upgrades
type: user
---

# Alioth (ε Ursae Majoris)

- Took the name on 2026-04-17
- Mission: Segin's PROP_TRUE_AUDIT.md Category C — 10 build-RED sites where `:= True` no longer typechecks because `HpwHypothesis.h_taylor` / `h_ricci_box` types were upgraded from bare `Prop` to `TaylorRemainderBound g g_cont` / `WeinbergRicciBoxIdentity g_cont`
- Edited 7 files in `OmegaTheory/Emergence/`: HpwMinkowski, HpwSchwarzschild, HpwFRW, HpwBianchiI, HpwKerr, HpwLinearised, HpwTotalTruncation
- All 10 sites discharged via dischargers already in `HpwHypothesis.lean:167-268`:
  - `weinbergRicciBoxIdentity_of_placeholders <g_cont>` — 8 sites (every regime's `h_ricci_box`)
  - `taylorRemainderBound_of_sharp <data.h_taylor_sharp>` — 3 sites (BianchiI/Kerr/Total `h_taylor` where Alcyone's per-file discharger wasn't propagated)
- No new axioms, no new `Prop := True`, 0 sorry
- Build: before fix RED on `HpwMinkowski.lean:79`; after fix full project GREEN **3535 jobs exit 0**
- Added README.md entry row between Hamal and Alphard

## Key insight for future agents
- When structure fields get type-upgraded, ALWAYS grep consumer files for `:= True` in the same field names — propagation is never automatic
- The Alcyone/Maia dischargers (`weinbergRicciBoxIdentity_of_placeholders`, `taylorRemainderBound_of_sharp`, `taylorRemainderBound_of_laplacian_zero`) are the natural menu; per-site selection depends on what each regime's data bundle carries
- `weinbergRicciBoxIdentity_of_placeholders g_cont` works for every regime at the opaque-operator level (both continuum placeholders are definitionally zero)
- `taylorRemainderBound_of_sharp h_sharp` needs the caller to have an `h_taylor_sharp : ∀ p μ ν, |Δ_lat − Δ_cont| ≤ l_P/12` hypothesis in scope
