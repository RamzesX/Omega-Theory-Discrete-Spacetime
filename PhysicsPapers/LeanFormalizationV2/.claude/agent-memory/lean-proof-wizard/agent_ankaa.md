---
name: Agent identity — Ankaa
description: Took Ankaa 2026-04-17 for minimal Seeley-DeWitt machinery file (Foundations/HeatKernelMinimal.lean); built full skeleton per Tarazed design, 5 sector presence predicates + 5 constructors, full project 3540 jobs GREEN, SD-discharge now unblocked to eliminate 9 Prop := True sites.
type: user
---

## Identity
- **Star name**: Ankaa (α Phoenicis, "the Phoenix"), taken 2026-04-17.
- **Assigned task**: SD-skeleton wizard — build `Foundations/HeatKernelMinimal.lean` per Tarazed's `NOTES_SEELEY_DEWITT_DESIGN.md`.
- **Sibling agent**: Tarazed (γ Aquilae) — wrote the design memo in parallel; I read and implemented.
- **Downstream consumer**: SD-discharge agent (spawned after my machinery) will use `build_has_X` constructors to eliminate the 9 `Prop := True` sites.

## Deliverable
- 1 file: `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/OmegaTheory/Foundations/HeatKernelMinimal.lean` (~800 lines)
- Registered in `Basic.lean` immediately after `Geometry.ErrorBoundedSmooth` (forward dep on Layer 3/4, not strict Layer 0 — lives IN Foundations namespace but needs EBHPW).
- Full project: **3540 jobs GREEN**, `lake build --log-level=error` exits 0.
- README row added in the AI Agent Contributors table.

## Machinery inventory (10 sections)
1. `SpectralMoments` — cutoff function moments f0/f2/f4 + non-neg + non-triv + `unit` canonical inhabitant.
2. `GeneralizedLaplacian g` — inverse-metric-free, `fiberDim : ℕ` (positive), `endomorphismTrace : Event → ℝ`; pointwise `a0/a2/a4` + Vassilevich decomposition `a2 = tr(E) + a2_grav`.
3. `A4EssentialSectors` — 4-sector split (grav/gauge/higgs/spin), non-neg each, `essential_a4` sum, `zero`/`constantSectors` inhabitants.
4. `HeatKernelExpansion g N` — master record with `Λ_eq : Λ = 1/computationalUncertainty N` (substrate lock) and `essentially_substrate` hypothesis.
5. **Five sector predicates**: `HasCosmologicalConstant / HasEinsteinHilbert / HasYangMills / HasHiggs / HasFermionKinetic`.
6. **Five constructors**: `build_has_cosmologicalConstant / _einsteinHilbert / _yangMills / _higgs / _fermionKinetic`. The CONTRACT with SD-discharge — any `HeatKernelExpansion g N` immediately discharges every predicate.
7. Canonical `canonicalLaplacian g N` + `canonicalExpansion g N` (fiberDim=4, endomorphismTrace = computationalUncertainty N).
8. `canonical_realizes_X` × 5 — one-liner realizations.
9. `minkowskiHeatKernelExpansion N` via Hamal's `minkowskiEBHPWMetric` + `minkowski_realizes_X` × 5 — proof-of-concept that downstream discharge just works.
10. Summary table mapping 9 sites to `HasX` / `build_has_X`.

## Key design decisions
- **Used `computationalUncertainty N` directly, NOT `higgs_vev N`** — keeps file in Foundations layer without Emergence imports (even though higgs_vev = computationalUncertainty definitionally).
- **Scope discipline, NO edits to ConnesSpectralAction.lean or SpectralActionExpansion.lean** — coordinator explicitly redirected me mid-task to STOP after machinery is perfect; SD-discharge agent will use my machinery downstream.
- **Inverse-metric-free (path B)**: Tarazed §5 analysis shows this sidesteps Cluster B dependency; all 9 sites are Cluster-B-independent at the pointwise predicate level.
- **Rule 3 substrate-essentiality**: every `HasX` predicate references either `H.Λ` (locked via `Λ_eq`) or `H.moments.f_k` in product with `H.Λ^p`. No predicate discharges for arbitrary cutoff.

## Non-trivial traps hit (and fixed)
- `field_simp` after `unfold substrateCutoff` on `1/x · x = 1` unfolded to a `div_self` goal, not a ne-zero obligation; adding `have hne := (computationalUncertainty_pos N).ne'` BEFORE `field_simp` makes field_simp dispatch it automatically.
- Full-project `lake build` had transient failures (corrupted `Basic.setup.json`, phantom "olean not found" for modules that built green per-module). Each re-run cleared different subsets; the final build completed with 3540 jobs GREEN. Always re-run on unexplained cascade errors before assuming my code is the problem.
- `Exists.choose_eq` for `bundleDim` extraction — went with direct `a₀_eq_bundleDim` reduction + `linarith` instead of choose rewriting (cleaner).

## Contract with SD-discharge agent
To replace `has_X := True` in ConnesSpectralAction.lean:290-297 or SpectralActionExpansion.lean:272-281:
```lean
  -- pick: g := minkowskiEBHPWMetric, then use minkowskiHeatKernelExpansion N
  has_cosmological_constant := HasCosmologicalConstant (minkowskiHeatKernelExpansion N)
  -- proof in all_sectors clause:
  all_sectors := ⟨minkowski_realizes_cosmologicalConstant N, ..., ...⟩
```
or using the raw canonical:
```lean
  has_cosmological_constant := HasCosmologicalConstant (canonicalExpansion g N)
  -- with g := constEBHPW M hsymm
```
The `build_has_X H` theorems close every presence predicate given ANY `HeatKernelExpansion`.
