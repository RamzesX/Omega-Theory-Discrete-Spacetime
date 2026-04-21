# Strategic Formalization Plan — Omega Theory / Chaos Shield

**Last updated**: 2026-04-12
**Repository root**: `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/`

---

## Current State (after April 11-12 session)

| Metric | Value |
|---|---|
| **Files** | 40 `.lean` files |
| **Definitions + Theorems** | ~690 |
| **Sorries** | **0** |
| **Axioms** | **9** (8 physical constants + 1 external math theorem) |
| **Build** | Clean (3368 jobs, Lean v4.29.0, Mathlib v4.29.0) |

### What was accomplished in the April 11-12 session

**Analysis**: 14 opus-code-crawler agents across 4 waves mapped V1 vs V2, all physics papers, Mathlib infrastructure, and publication readiness.

**Paper fixes** (4 appendices corrected):
- Appendix S: circular chronology protection retracted, replaced with honest Lyapunov periodic-orbit theorem + §7A formal critique
- Appendix D Thm 7.2: trace gap made explicit with matching condition (7.4.M)
- Appendix D Thm 6.1: Cauchy-Schwarz sign error replaced with Young's inequality
- Appendix P Thm 3.1: index failure fixed, reformulated as magnitude bound
- Appendix F: restored from git after accidental overwrite

**New Lean files** (9 created):
1. `HealingFlow/Periodic.lean` — rescued Theorem 7.1 + Proposition 7.2
2. `Geometry/Examples.lean` — BoundedSymmetryMetric + BianchiMetric non-vacuity witnesses
3. `Irrationality/ActionDensity.lean` — Appendix A action density definitions
4. `Conservation/SpinInformation.lean` — spin-statistics via `native_decide`
5. `Tensor/ValuedGeometry.lean` — valuedChristoffelSymbol with PROVEN error bounds
6. `Spacetime/CausalLattice.lean` — directed causal structure, no-CTC theorem
7. `Variational/InformationGeodesics.lean` — log-barrier potential, kinetic Lagrangian
8. `Emergence/Gravitons.lean` additions — Bekenstein derivation (`I_max = π/ln2`)
9. `Conservation/Information.lean` additions — L8 info-metric + L11 global conservation

**Axiom reduction**: 19 → 9 (deleted 8 `True`-typed audit markers, collapsed 3 HPW axioms into 1 by defining `continuumBoxG := -2R`)

**Key innovations made real**:
- `Valued` error-propagation pipeline proven end-to-end through Christoffel symbols (was dead code)
- E6 action convexity closed (completes Erdős-Noether bundle E2+E6+E8)
- Honesty renames on misleading theorems (`bounce_prevents_singularity`, Noether projections)

### The 9 irreducible axioms

| # | Axiom | Location | Why irreducible |
|---|---|---|---|
| 1 | `c : ℝ` | `Constants.lean:23` | Speed of light — physics |
| 2 | `c_pos : 0 < c` | `Constants.lean:24` | Positivity — physics |
| 3 | `hbar : ℝ` | `Constants.lean:27` | Planck constant — physics |
| 4 | `hbar_pos : 0 < hbar` | `Constants.lean:28` | Positivity — physics |
| 5 | `G_N : ℝ` | `Constants.lean:31` | Gravitational constant — physics |
| 6 | `G_N_pos : 0 < G_N` | `Constants.lean:32` | Positivity — physics |
| 7 | `k_B : ℝ` | `Constants.lean:35` | Boltzmann constant — physics |
| 8 | `k_B_pos : 0 < k_B` | `Constants.lean:36` | Positivity — physics |
| 9 | `hpw_laplacian_ricci_convergence` | `LaplacianRicci.lean:67` | HPW 2006 + harmonic gauge — 1 external math theorem |

---

## Remaining TODO (ordered by priority)

### Task 1 — ~~Extend Valued pipeline to valuedRiemann~~ DONE

Completed: `Tensor/ValuedCurvature.lean` — 0 sorry, proven end-to-end.

---

### Task 2 — ~~Add U(1) charge current as second Noether instance~~ DONE

Completed: `linkCurrent` + `u1ChargeConservedCurrent` in `NoetherMetaStructure.lean` — 0 sorry.

---

### Task 3 — ~~EXACT curvature symmetry chain for general metrics~~ DONE

Completed: `riemann_lower_antisym_12_exact` + `ricci'_symmetric_exact` + `ricci_symmetric_exact` in `CurvatureSymmetries.lean` — 0 sorry. By Meridian.

**What**: Prove the exact (not bounded) curvature symmetry chain for any symmetric nondegenerate metric with exact pair swap:

1. `riemann_lower_antisym_12_exact`: derived — `R_{ρσμν} = -R_{σρμν}`
2. `ricci'_symmetric_exact`: derived — `R'_{μν} = R'_{νμ}`
3. `ricci_symmetric_exact`: derived — `R_{μν} = R_{νμ}`

**Why**: V2 only has BOUNDED versions (`|R_{μν} - R_{νμ}| ≤ 16·M·C·ε`). The EXACT chain is the classical GR result for smooth metrics. Having both the exact and bounded versions shows the full picture: smooth → exact symmetry, lattice with defects → bounded symmetry.

**Concrete proof plan** (designed by Meridian, verified against V1):

Add a new section `ExactCurvatureSymmetries` at the end of `CurvatureSymmetries.lean`,
AFTER the existing `BoundedSymmetryMetric` and `BianchiMetric` sections.

```
section ExactCurvatureSymmetries
  variable (g) (hsym) (hnd)
  variable (h_pair_swap : ∀ ρ σ μ ν p, riemannLower g ρ σ μ ν p = riemannLower g μ ν ρ σ p)

  Theorem 1: riemann_lower_antisym_12_exact
    Proof: pair_swap → antisym_34 → pair_swap (3-step calc, ~5 lines)
    Uses: riemannLower_antisym_34 from Curvature.lean

  Theorem 2: ricci'_symmetric_exact
    Proof: rewrite R_{ρμσν} = R_{σνρμ} via pair swap, swap sum order,
           use inverseMetric_symm (from Metric.lean) (~15 lines)
    Uses: ricciTensor', inverseMetric_symm, Finset.sum_comm

  Theorem 3: ricci_symmetric_exact
    Proof: bridge through ricciTensor' (3-step calc, ~5 lines)
    Uses: ricciTensor_eq_ricciTensor' from Curvature.lean
end ExactCurvatureSymmetries
```

**V2 building blocks confirmed available**:
- `riemannLower_antisym_34` (Curvature.lean:77) — exact
- `first_bianchi_lower` (Curvature.lean:247) — exact
- `ricciTensor_eq_ricciTensor'` (Curvature.lean:165) — bridge
- `inverseMetric_symm` (Metric.lean:123) — g^{ρσ} = g^{σρ}

**Dependencies**: `Geometry/Curvature.lean` (already imported by CurvatureSymmetries.lean)

**Effort**: ~60-80 lines including comments. 0 sorries expected. Pure algebra.

**Files**: Add section to `OmegaTheory/Geometry/CurvatureSymmetries.lean` (line ~425, after BianchiMetric)

---

### Task 4 — ~~Derive `pair_swap_bounded` from Valued Riemann~~ DONE

Completed by Meridian. Two new theorems:
- `riemannLower_perturbation_bound` in `ValuedCurvature.lean` — extends Valued pipeline to lowered Riemann via `abs_mul_sub_mul_bound` on the g·R product
- `pair_swap_from_valued_pipeline` in `CurvatureSymmetries.lean` — combines lowered Riemann bound + exact pair swap on g_exact + `pair_swap_bounded_from_riemann_diff` → pair swap bounded as THEOREM

The full error chain: metric defect ε → Christoffel error → Riemann error → lowered Riemann error → pair swap bound = 2 · riemannLowerError.

---

### Task 5 — Submit Weyl trace-free paper to CQG

**What**: Polish and submit `Note-Structure-Preserving-Lattice-Curvature.md` as a Classical and Quantum Gravity Note.

**Why**: This is the #1 paradigm-shift target — an EXACT tensor identity surviving discretization where neighbors are only bounded. Already proven in Lean. The paper draft exists. The `flatBSM` non-vacuity witness exists.

**Remaining work**:
- Trim abstract to 150 words
- Check Schouten (1954) and Eisenhart (1926) for alternate-routing prior art
- Add references: Regge 1961, Hirani 2003, Arnold-Falk-Winther 2006
- Update V2 commit hash in the paper
- Submit to arXiv (`gr-qc` + `math.DG`) simultaneously

**Dependencies**: `Geometry/Examples.lean` non-vacuity witness (done)

**Effort**: 1-2 weeks of writing (not coding)

**Files**: `Note-Structure-Preserving-Lattice-Curvature.md`

---

### Task 6 — Bundle Computational Uncertainty Trilogy paper

**What**: Bundle the irrationality rates (π, e, √2 with proven convergence), extended uncertainty principle (`extended_gt_heisenberg`), and Bekenstein energy identity (`repairQuantumEnergy_from_bekenstein`) into a single paper.

**Why**: Three proven, novel results that together form a coherent story: "computational truncation at the Planck scale → concrete error bounds → extended Heisenberg → Bekenstein-derived graviton energy."

**Dependencies**: All Lean content exists and builds

**Effort**: 2-3 weeks of writing

**Files**: Create new paper draft

---

### Task 7 — ~~Reformulate information density via KullbackLeibler~~ DONE

Completed by Meridian. Created `Conservation/InformationKL.lean` with:
- `informationDensityKL` definition: ½ log|det g| + ½ Tr(g⁻¹ g₀)
- Volume/shape decomposition with proven properties
- Self-divergence: I(g,g) = ½ log|det g| + 2
- Flat metric: I(η,η) = 2
- Mathlib v4.29 has abstract KL but no Gaussian KL formula; used Option B (concrete Matrix.det/trace/Real.log)

---

### Task 8 — ~~Derive `pair_swap_bounded` as theorem~~ DONE (merged with Task 4)

Completed as part of Task 4. See `pair_swap_from_valued_pipeline` in `CurvatureSymmetries.lean`.

---

### Future tasks (lower priority)

| Task | Description | Effort |
|---|---|---|
| Weyl via Clifford algebra | Generalize Weyl tracefree from dim 4 to arbitrary dim using Mathlib `CliffordAlgebra` | 1-2 months |
| Discrete Bianchi as cochain | Prove Bianchi identity as `d² = 0` using Mathlib `ExteriorAlgebra` | 2 months |
| Emergent torsion from `[Δ_μ, Δ_ν]g` | Full derivation of Appendix P Thm 3.1 from commutator | 1-2 months |
| Three-generation from π₁ = ℤ₃ | Particle generation count from fundamental group — moonshot | Research-grade |
| §6 characterization conjecture | "Identity survives discretization iff derived from 5 primitives" | 1-2 year PhD thesis |

---

## Do NOT pursue

| Target | Why |
|---|---|
| Full HPW from scratch | 2-4 FTE-years. Mathlib lacks Ricci curvature on manifolds. |
| Big Bounce density bound `ρ ≤ 2ρ_P` | Needs Friedmann/Raychaudhuri ODE infrastructure. |
| Appendix S Thm 7.1 as "chronology protection" | Circular — already retracted and replaced with Lyapunov theorem. |

---

## Publication pipeline

| Paper | Status | Target venue | Lean backing |
|---|---|---|---|
| Weyl trace-free structure-preserving | Draft exists, proofs done | CQG Note | `Weyl.lean`, `Examples.lean` |
| Computational Uncertainty Trilogy | Proofs done, needs writing | Foundations of Physics | `BoundsLemmas.lean`, `Uncertainty.lean`, `Gravitons.lean` |
| Discrete Erdős-Noether bundle | E2+E6+E8 proven, needs writing | CPP/ITP | `GraphAction.lean`, `DiscreteNoether.lean` |
