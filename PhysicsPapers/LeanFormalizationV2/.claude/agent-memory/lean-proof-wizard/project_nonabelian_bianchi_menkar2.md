---
name: Non-abelian Bianchi DF=0 closed (Menkar², Apr 17 late)
description: NonAbelianGauge.lean now has covariantD, nonAbelianBianchi_full (conditional on LeibnizOnBracket), leibnizOnBracket_of_abelian, covariantD_curvature_abelian (unconditional); L-valued d²=0 proven exact via `simp only [smul_sub]; rw [shiftFin_comm...]; abel`.
type: project
---

Menkar² closed the non-abelian Bianchi gap on 2026-04-17 late afternoon in `OmegaTheory/Emergence/NonAbelianGauge.lean`. 

**Why:** original file only had the conditional (`nonAbelianBianchi_abelian`). Coordinator wanted DF = 0 for F = dA + [A,A].

**How to apply:** Anyone needing the non-abelian Bianchi should use:
- `naExteriorD2_comp_naExteriorD` — EXACT L-valued d²=0 (no hypotheses).
- `covariantD A ω = naExteriorD2 ω + naBracketForm2 A ω`.
- `nonAbelianBianchi_full` — requires `LeibnizOnBracket A` hypothesis (bundles Leibniz + Jacobi + bracket-additivity into a single pointwise identity).
- `leibnizOnBracket_of_abelian` — trivial discharge for abelian L.
- `covariantD_curvature_abelian` — direct unconditional abelian corollary.

**Key tactical trick:** to prove L-valued d²=0 on a Module ℝ, use `simp only [smul_sub]` BEFORE `rw [shiftFin_comm ...]` so `abel` can see all 12 doubly-shifted terms as pure additive combinations (no nested `(1/l_P) • ((1/l_P) • X)`).

**Honest limitation:** `LeibnizOnBracket` is NOT proven from `ErrorLieBracket` alone — the class has no definitional bilinearity/Jacobi/antisymmetry (only approximate in `ErrorLieAlgebra`). So full non-abelian Bianchi remains conditional on this structural bundle; abelian case is unconditional.

SU3JacobiFull.lean has pre-existing build errors unrelated to my changes (created by another agent at 15:57, untracked file with `Prod.mk.inj_iff.mp` unknown constant issues).
