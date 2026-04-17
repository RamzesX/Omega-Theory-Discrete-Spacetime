---
name: Agent identity — Adhara
description: Took Adhara 2026-04-17 for Nashira's g_perturbation EBHPW upgrade; substantive EBHPW with κ > 0 via ErrorBoundedSmoothMetricReal (composition not extends, per Izar) in Geometry/ErrorBoundedSmoothReal.lean; non-breaking, full project GREEN 3540 jobs
type: user
---

Took the name **Adhara** (ε Canis Majoris, "the virgins/maidens" in Arabic) on 2026-04-17 for the EBHPW `g_perturbation` upgrade mission.

## Mission shipped
Built `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/LeanFormalizationV2/OmegaTheory/Geometry/ErrorBoundedSmoothReal.lean`.

## Key design decisions
- **Composition, not `extends`** (per Izar's `NOTES_CLUSTER_B_DESIGN.md` correction that landed mid-session).
- `g_discrete` is a `noncomputable def` (derived), NOT a field — prevents desync with the sharp-witness pair.
- `g_approx_bound` is a THEOREM proved from `g_perturbation_bounded` + `computationalUncertainty_nonneg`.
- Tight κ = 1 witness in `g_approx_bound` (vs Hamal's κ = 0).
- Ships Izar's unconditional `toSharp` projection + zero-perturbation `toSharpWitness` specialisation + reverse `ofSharpWitness` lift.

## Structure shipped
```
structure ErrorBoundedSmoothMetricReal where
  g_smooth : Event → Matrix (Fin 4) (Fin 4) ℝ
  g_perturbation : Event → Matrix (Fin 4) (Fin 4) ℝ
  g_smooth_contDiff : ∀ μ ν, ContDiff ℝ 4 (fun x => g_smooth x μ ν)
  g_symmetric : ∀ x μ ν, g_smooth x μ ν = g_smooth x ν μ
  g_perturbation_symmetric : ∀ x μ ν, g_perturbation x μ ν = g_perturbation x ν μ
  g_perturbation_bounded : ∀ x μ ν, |g_perturbation x μ ν| ≤ 1
```

## Theorems shipped (6 theorems + 4 defs + 1 structure + 2 sanity lemmas)
- `g_discrete` (def), `g_discrete_component`, `g_discrete_symmetric`
- **`g_approx_bound`** (headline: κ = 1 bound)
- `toSharp` (def, Izar's unconditional projection), `toSharp_g_discrete`
- `toSharpWitness` (def, zero-perturbation specialisation), `toSharpWitness_g_discrete_eq`
- `ErrorBoundedSmoothMetricReal.ofSharpWitness` (def, reverse lift)
- `ofSharpWitness_perturbation_zero`, `ofSharpWitness_g_discrete_eq`
- `minkowskiEBHPWReal` (def, sanity instance via Hamal's `minkowskiEBHPWMetric`)
- `minkowskiEBHPWReal_perturbation_zero`, `minkowskiEBHPWReal_g_discrete_eq`

## Non-breaking guarantee
- Zero edits to `OmegaTheory/Geometry/ErrorBoundedSmooth.lean` (Hamal+Alphard+Alpheratz's file preserved).
- Only addition to `Basic.lean`: one import line after `ErrorBoundedSmooth`.
- Full project build: **3540 jobs GREEN**, exit code 0.
- 0 sorry, 0 new axioms.

## Technical notes for future agents
- Matrix arithmetic: `Matrix.add_apply`, `Matrix.smul_apply`, `smul_eq_mul` chain works cleanly.
- `abs_of_nonneg (computationalUncertainty_nonneg N)` is the key step — multiplying by `1` via perturbation bound.
- In `toSharp`, the proof of `g_approx_bound` must be inlined (cannot reuse theorem-level `g_approx_bound` because it's on the real EBHPW, not the sharp one being constructed).
- Unused variables (`h_zero_pert`, `h`) prefixed with `_` to silence linter while keeping mathematical content of the signatures.
