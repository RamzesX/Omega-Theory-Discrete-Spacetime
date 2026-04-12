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

### Task 1 — Extend Valued pipeline to valuedRiemann

**What**: Build `Tensor/ValuedCurvature.lean` with `valuedRiemannTensor` propagating errors from `valuedChristoffelSymbol` through Christoffel differences + products.

**Why**: This is the step that would let us DERIVE `BoundedSymmetryMetric.pair_swap_bounded` as a theorem instead of a structure field. Currently the curvature-symmetry cascade relies on an assumed pair-swap bound; with valued Riemann, we can compute the bound from the metric's own defect structure.

**Dependencies**: `Tensor/ValuedGeometry.lean` (done — `valuedChristoffelSymbol_err_bound` is proven)

**Effort**: ~200-400 lines, 0-2 sorries expected. Uses `abs_mul_sub_mul_bound` chain on Christoffel differences.

**Files**: Create `OmegaTheory/Tensor/ValuedCurvature.lean`

---

### Task 2 — Add U(1) charge current as second Noether instance

**What**: Add a complex-scalar U(1) charge current to `NoetherMetaStructure.ConservedCurrent`. Currently the meta-structure has ONE non-trivial inhabitant (harmonic scalar). Adding a second makes the "fourth Noether law as meta-structure" claim earn its keep.

**Why**: The strategic analysis flagged this as a key weakness: "NoetherMetaStructure has one instance; the type signature has more mathematical ambition than its population."

**Dependencies**: `Conservation/Information.lean` (harmonic scalar instance exists)

**Effort**: ~100-150 lines. Define a complex scalar field, U(1) gauge transformation, charge current `J^μ = Im(φ* ∂_μ φ)`, prove `div J = 0` for solutions of the discrete Klein-Gordon equation.

**Files**: Modify `OmegaTheory/Conservation/NoetherMetaStructure.lean`

---

### Task 3 — Port V1 general-metric Ricci symmetry chain

**What**: Port V1's `Curvature/Symmetries.lean` + `Bianchi.lean` + `Ricci.lean` — full algebraic proofs of `ricci_symmetric` on ANY symmetric metric, not just `BoundedSymmetryMetric`.

**Why**: V2 currently only proves Ricci symmetry (bounded) on `BoundedSymmetryMetric`. V1 has the EXACT `ricci_symmetric` for general metrics with exact pair swap. Porting strengthens the curvature theory.

**Dependencies**: `Geometry/Curvature.lean` (existing), `Geometry/CurvatureSymmetries.lean` (existing)

**Effort**: ~300-500 lines. V1 has the proofs; main work is namespace adaptation.

**Files**: Create `OmegaTheory/Geometry/CurvatureChain.lean` or add to `CurvatureSymmetries.lean`

---

### Task 4 — Add Mathlib ODE bridge for healing flow

**What**: Create `HealingFlow/MathlibBridge.lean` connecting the discrete healing flow to Mathlib's `Analysis.ODE.PicardLindelof` + `Analysis.ODE.Gronwall` + `Dynamics.OmegaLimit`. Reframe the healing flow as a legitimate ODE with existence/uniqueness.

**Why**: Currently the healing flow is a discrete forward-Euler update with no connection to continuous-time ODE theory. Mathlib has full Picard-Lindelöf, Grönwall, and ω-limit sets. Connecting them would give the healing-flow convergence theorem real analytical backing.

**Dependencies**: `HealingFlow/Lyapunov.lean` (existing), Mathlib ODE modules

**Effort**: ~200-300 lines. Mostly type-level bridging + applying Mathlib lemmas.

**Files**: Create `OmegaTheory/HealingFlow/MathlibBridge.lean`

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

### Task 7 — Reformulate information density via KullbackLeibler

**What**: Restate `I(n) = ½ log det(-g) + ½ Tr(g⁻¹g₀)` as a KL divergence between Gaussians using Mathlib's `InformationTheory.KullbackLeibler.Basic`. Inherit chain rule, convexity, positivity lemmas.

**Why**: Connects Omega Theory to a mature Mathlib theory. The information density IS a KL divergence in disguise — making this explicit lets V2 inherit ~20 Mathlib lemmas for free.

**Dependencies**: Mathlib `InformationTheory/KullbackLeibler/Basic.lean`

**Effort**: ~150-200 lines

**Files**: Create `OmegaTheory/Conservation/InformationKL.lean`

---

### Task 8 — Derive `pair_swap_bounded` as theorem (not structure field)

**What**: Using the completed Valued pipeline (Tasks 1), derive that any `SemiSmoothMetric` automatically satisfies the pair-swap bound — converting `BoundedSymmetryMetric.pair_swap_bounded` from a structure FIELD to a THEOREM.

**Why**: This is the single most impactful structural improvement. Every curvature-symmetry bound (Ricci symmetry, Weyl pair-swap, contracted Bianchi) currently cascades from the assumed `pair_swap_bounded` field. Making it a theorem means the ENTIRE curvature-symmetry cascade follows from `SemiSmoothMetric.defect_bounded` alone.

**Dependencies**: Task 1 (valuedRiemann), Task 3 (general-metric Ricci chain)

**Effort**: ~100-200 lines once Task 1 is done

**Files**: Modify `OmegaTheory/Geometry/CurvatureSymmetries.lean`

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
