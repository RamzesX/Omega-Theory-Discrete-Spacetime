---
name: Agent identity — Avior
description: Took Avior name 2026-04-17 on GravitonConditions mission — new Emergence/GravitonConditions.lean packaging 3 graviton existence predicates with all witnesses discharged via primitives from existing Gravitons.lean; full project GREEN 3545 jobs
type: user
---

# Avior (ε Carinae)

Chose star name 2026-04-17. Brightest star of the Carina constellation (modern RAF-coined navigational name for the bright binary star of the keel of Argo Navis at ~630 ly). One of 57 stars used in celestial navigation. Binary system, fitting for a file that disambiguates dual graviton objects (field graviton vs repair quantum).

## Mission

Created `OmegaTheory/Emergence/GravitonConditions.lean` — ~155 lines, 0 sorry, 0 new axioms, 0 new `Prop := True`. Packages three graviton existence predicates with discharged witnesses:

- `RealFieldGravitonExists ω := 0 < ω ∧ ∃ E, E = fieldGravitonEnergy ω`
- `VirtualGravitonExists E p := E^2 ≠ (p·c)^2`
- `RepairQuantumTriggered defect := l_P < defect`

Plus `field_vs_repair_distinct` as direct re-export of `field_and_repair_distinct_below_planck` from `Gravitons.lean`, and Minkowski sanity witness `minkowskiFieldGravitonExistsWitness` at `ω=1`.

Wired into `Basic.lean` line 115 directly after `Emergence.Gravitons`.

## Technical notes for future sessions

1. **`ne_of_gt` semantics**: `ne_of_gt : a > b → a ≠ b` (i.e., `b < a → a ≠ b`). Initial attempt used `.symm` which reversed direction and caused a type mismatch. Target is `E^2 ≠ (p*c)^2` from hypothesis `(p*c)^2 < E^2`; `ne_of_gt hEp` returns exactly that (no `.symm` needed).

2. **WSL filesystem race**: the full project build initially failed with a bogus "no such file or directory" error for `.lake/build/lib/lean/OmegaTheory/Basic.olean`. The trace file was written but the olean file wasn't. Simply re-running `lake build --log-level=error` succeeds on retry — transient WSL/Windows filesystem sync issue. The same happened for the top-level `OmegaTheory.olean`. Second retry always succeeded.

3. **No `ω_planck` in Constants.lean**: the spec mentioned `ω_planck` as potentially-needed. Confirmed via grep that `ω_planck` / `omega_planck` is not defined anywhere. Instead, the distinctness theorem is stated with the direct hypothesis `hbar * ω < repairQuantumEnergy` — strictly more general than `ω < c/l_P` since the numerical gap is ~31 orders of magnitude.

4. **`fieldGravitonEnergy_ne_repairQuantumEnergy` does NOT exist** — the spec mentioned this name but the actual theorem in Gravitons.lean is `field_and_repair_distinct_below_planck (ω : ℝ) (hω : 0 < ω) (h_below : hbar * ω < repairQuantumEnergy) : fieldGravitonEnergy ω ≠ repairQuantumEnergy`. The new `field_vs_repair_distinct` wrapper reuses this verbatim.

## Per-module build

```
~/.elan/bin/lake build OmegaTheory.Emergence.GravitonConditions --log-level=error
# → ✔ [3287/3287] Built (213s)
```

## Full project build

```
~/.elan/bin/lake build --log-level=error
# → ✔ [3544/3545] Built OmegaTheory (147s)
# → Build completed successfully (3545 jobs).
```
