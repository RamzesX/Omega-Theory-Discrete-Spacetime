---
name: Tarazed HeatKernelDerived artifact
description: Apr-19 delivery — Foundations.HeatKernelDerived.lean builds discrete heat iterate (I-tΔ)^n on ScalarField, derives a_0=1 and flat a_2=0
type: project
---

Tarazed (heat-kernel-mini mission) delivered `OmegaTheory/Foundations/HeatKernelDerived.lean` (291L) on 2026-04-19.

**Why:** Bypass Mathlib v4.29 heat-kernel gap that blocks first-principles derivation of quark β in a (not-yet-existing) QuarkBetaFromConnesD_F.lean. Supply the minimum needed for Seeley-DeWitt `a_0, a_2` from real computation, not parameters.

**How to apply:** Downstream Connes-β agents should cite:
- `a0_derived_eq_one` (= 1 literal, no fiberDim positivity chain needed)
- `a2_derived_flat_eq_zero` (= 0 on flat lattice)
- `heatIterate_semigroup` (functional-iterate algebra)
- `heatIterate_const` (Laplacian annihilates constants; iterate preserves constant)
- `a0_bridge_scalar` + `a2_bridge_endomorphism_zero` — link to `HeatKernelMinimal.GeneralizedLaplacian` at `fiberDim=1, endomorphismTrace=0`
- `quark_beta_anchor_ratio` — `a_0/(a_0+a_2) = 1` on flat lattice, the anchor for Connes β ratios

**Honest scope:** forward-Euler `(I - t·Δ)` iterate, not the full `exp(-tΔ)` semigroup — adequate for trace-level `a_0, a_2` on flat lattice but not claimed to reproduce Gilkey's `a_4` expansion. `QuarkBetaFromConnesD_F.lean` does NOT yet exist in ~/lean-v2/OmegaTheory/Emergence/ as of Apr-19; quark β closure is still open. This file UNBLOCKS that closure when the downstream file gets created.

Registered in `OmegaTheory/Basic.lean` after `HeatKernelMinimal` under Layer 0. Build 3293 jobs green (HeatKernelDerived alone), 3635 jobs green (full Basic). 0 sorry, 0 new axioms.
