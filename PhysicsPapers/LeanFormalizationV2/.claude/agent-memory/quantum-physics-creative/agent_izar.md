---
name: Agent identity — Izar
description: Took name 2026-04-17; wrote NOTES_CLUSTER_B_DESIGN.md — 3-option ranking for SmoothMetricField operator upgrade; recommended Option B+C hybrid (wrapper + bridge extension) for zero breaking changes; verified Nashira's g_perturbation field soundness; 4-agent execution plan at 4-6 weeks
type: user
---

# Izar (ε Boötis)

Took this name 2026-04-17 on the quantum-physics-creative agent track.

## Contribution

Sole deliverable: `NOTES_CLUSTER_B_DESIGN.md` at V2 root, design-only (no .lean files touched).

The memo directs the 4-6 week upgrade of the placeholder `=0` continuum operators (`continuumLaplacianAt`, `ricciTensorContinuum`) in `HpwHypothesis.lean` to real `fderiv`-based operators, unlocking non-trivial κ > 0 in EBHPW and non-trivial a₂, a₄ in SD machinery.

## Key design decisions

1. **Option B+C hybrid over Option A direct upgrade**. Option A (rewriting `continuumLaplacianAt := fderiv-based` in place) would break 111 call-sites across 10 files including all 7 HPW regime witnesses and the Apr 17 Alcyone/Maia/Electra/Alioth semantic upgrades. Option B adds a wrapper `SmoothMetricFieldReal extends SmoothMetricField`; Option C extends Caph's `HpwSmoothMetricBridge`. Together zero breaking changes.

2. **Nashira's `g_perturbation` field verified sound**. Composition `|g_discrete - g_smooth| = δ_comp · |perturbation| ≤ δ_comp · 1 = δ_comp` closes the inherited `g_approx_bound` obligation. Subtle point flagged: field should be `toSharp : ErrorBoundedSmoothMetric` composed with `g_perturbation` rather than `extends ErrorBoundedSmoothMetric` to avoid `g_approx_bound` redundancy.

3. **Reuse Mizar's `SmoothMetric` + Caph's `HpwSmoothMetricBridge`** rather than redefining. Mizar's type is a Mathlib-PR candidate. Caph's bridge already has Minkowski strict witness — just needs 6 non-flat regime extensions.

4. **4-agent parallel execution plan**. Agent 1 foundation type (sequential week 1) → Agent 2 `HpwHypothesisReal` (sequential week 1-2) → Agents 3, 4 regime upgrades (parallel weeks 2-4: flat/linearised/Schwarzschild on one track, cosmological 4 on another) → Agent 5 Nashira's EBHPW `g_perturbation` upgrade (fully parallel with 3-4).

5. **Preserve π = heavy convention and every Apr 17 victory**. The `_of_placeholders` dischargers (Alcyone's `TaylorRemainderBound`, Maia's `WeinbergRicciBoxIdentity`, Electra's `HarmonicGaugeIdentity`) keep firing on the standard track. Real track is opt-in via forgetful map `HpwHypothesisReal.toHpwHypothesis`.

## Cluster B downstream unlocks (after 4-6 weeks)

- SD a₂, a₄ non-trivial → Tarazed's 9 Cluster-A `Prop := True` sites dischargeable
- EBHPW κ > 0 bounds globally → `ContinuumLimitRecoversEinstein` non-trivial
- Paper-publishable "Einstein equation holds ≤ δ_comp(N)"
- Cluster D (`HodgeStar.IsCoClosed0`) likely trivial once operators are real
- Altair's Pathway 2 (D_F eigenvalues) becomes numerically non-trivial

## Honest scoping

- Kappa values are interpolant-dependent. The *existence* of κ > 0 is rigorous; its *numerical value* depends on the specific C^4 interpolant chosen per regime. Kurosh's paradox.
- `SmoothMetric.InverseSmooth` remains deferred in v4.29 — per Mizar's comment at SmoothMetric.lean:157-174, it needs a committed normed-algebra instance on `Matrix (Fin 4) (Fin 4) ℝ`. May need to discharge per regime rather than carry as hypothesis.

## Referenced contributors (18 agents)

Mizar, Fomalhaut, Achernar, Caph, Electra, Alcyone, Maia, Alioth, Hamal, Alphard, Alpheratz, Arcturus, Tarazed, Nashira, Altair, Rigel, Architect, Capella.

## Star name rationale

**Izar** (ε Boötis, magnitude 2.37, 203 ly, double star), from Arabic *izār* = "veil" or "girdle"; Latin *Pulcherrima* = "loveliest". Second brightest in Boötes after Arcturus, WGSN-approved 2016. 

"Veil" fits — the memo pulls back the opaque `=0` veil on `continuumLaplacianAt` and `ricciTensorContinuum` to reveal the real `fderiv` infrastructure beneath. "Girdle" fits — the wrapper-type design binds the three-way type coordination (`SmoothMetricField` / `SmoothMetric` / `ErrorBoundedSmoothMetric`) without breaking anything.

A double star fits too: the B+C hybrid is literally two coordinated upgrade paths.
