# Strategic Formalization Plan — Omega Theory / Chaos Shield

**Date**: 2026-04-11
**Analysis**: 14 opus-code-crawler agents across 4 waves
**Repository root**: `/mnt/c/Users/Norbert/IdeaProjects/chaos-shield/PhysicsPapers/`

---

## Executive Summary

V2 is technically impressive (255 theorems, 0 sorry, 5 declared axioms, clean build) but the **effective rigor is lower than the headline**: six load-bearing `structure` fields act as hidden axioms, the flagship `einstein_with_matter_emergence` theorem is tautological on a balance-equation hypothesis, the `Valued` error-propagation innovation is dead code, and no concrete non-flat `BoundedSymmetryMetric` instance exists (so every curvature-symmetry bound is currently vacuous).

However, three publishable units are **effectively done** and can ship in 30–90 days. The single highest-ROI bet is to **polish and submit the Weyl trace-free paper to Classical and Quantum Gravity as a Note**. This is the only target where "paradigm-shifting" and "already proven in Lean" overlap.

The "no chronology protection" claim in Appendix S is **circular** and must not be formalized as stated. Proving the Laplacian-Ricci correspondence (HPW 2006) from scratch is **research-grade 2–4 FTE-years** blocked on Mathlib lacking Ricci curvature, Sobolev spaces, and discrete exterior calculus. The Popławski bounce density bound requires a Friedmann equation infrastructure that does not exist.

A **critical bug** was discovered: today (commit `9c1c86e`) the source file `Appendix-F-Information-Flow-Conservation.md` was accidentally overwritten during "Reorganization beginning v2" with a 106-line π/continued-fraction stub, deleting 989 lines of the original. V2 Lean docstrings cite `§1.4`, `§9.4`, `§9.5`, `§9A.2` which are now dangling. The real 1038-line file is preserved in `site/src/content/papers/appendix-f-information-flow-conservation.md` and is recoverable from `git show 6eab85e`. **Fix this first.**

---

## Part 1 — Current State (Honest Assessment)

### 1.1 V2 Metrics vs. Reality

| Claim | Reality |
|---|---|
| 0 `sorry` | ✓ Literally true |
| 5 axioms | ✗ Effective count ~11 once structure fields are counted |
| 255 theorems | ✓ Literal count; many are 1-line extractions |
| Error-propagating `Valued` types | ✗ Defined but never propagated upward; dead code |
| `einstein_with_matter_emergence` | ✗ Tautological on `IsHealingEquilibrium.balance` + HPW |
| `bounce_prevents_singularity` | ✗ Literal alias for `torsionPressure_negative` (a sign lemma) |

### 1.2 Hidden Axioms (the 6 load-bearing structure fields)

1. `BoundedSymmetryMetric.pair_swap_bounded` — `Geometry/CurvatureSymmetries.lean:41`. Cascades into every curvature-symmetry bound; no concrete non-flat instance exists anywhere in V2.
2. `BianchiMetric.contracted_bianchi_assumption` — `Geometry/CurvatureSymmetries.lean:396`. Central Bianchi identity posited, not derived.
3. `SemiSmoothMetric.defect_bounded` — `Defects/DefectTensor.lean:91`. Defines "ε-semi-smooth"; no existence theorem.
4. `IsHealingEquilibrium.balance` — `HealingFlow/Flow.lean:71`. **The equilibrium equation itself is a structure field.** This is why the prize theorem is tautological.
5. `InformationSource.conserved` — `Conservation/StressEnergy.lean:41`. Conservation posited; the one "existence" theorem is witnessed by the zero field.
6. `BoundedSymmetryMetric.{inv_metric_bounded, metric_bounded}` — uniform bounds on `g⁻¹`, `g`.

### 1.3 The Flagship Theorem Read Honestly

`einstein_with_matter_emergence` in `Emergence/EinsteinEmergence.lean:93` literally reads (after unfolding):

> *Given* a semi-smooth metric satisfying bounded-symmetry + Bianchi-bound assumptions (hidden axioms 1–3), *given* `IsHealingEquilibrium.balance` (hidden axiom 4), *given* `InformationSource.conserved` (hidden axiom 5), *given* the HPW Laplacian-Ricci axiom at O(l_P): **then** `|−2μR − (λD + γ(I−Ī))| ≤ l_P`.

The proof is a one-line unfolding of `heq.balance` combined with the HPW axiom. The result is valuable as a *conditional statement* but it is not a proof that Einstein's equations emerge. The trace-reversal `R_{μν} → G_{μν} = R_{μν} − ½gR` is never performed. The coupling constant `8πG/c⁴` is fit, not derived.

### 1.4 Catastrophic Circularities in the Papers

- **Appendix D Thm 7.2 trace gap**: Thm 5.1 says `μΔg → −2R_{μν}`; Thm 7.2 Step 3 then silently writes `μΔg → −R_{μν} + ½g_{μν}R` (the Einstein tensor form). These are different tensors. The paper's chain is broken.
- **Appendix D Thm 6.1 Cauchy-Schwarz sign error**: Step 1 invokes Cauchy-Schwarz to conclude a sign, but Cauchy-Schwarz bounds `|⟨x,y⟩|`, not `⟨x,y⟩ ≤ 0`.
- **Appendix P Thm 3.1 index failure**: The 6-step proof drops tensor indices between steps 4 and 5; index structure does not close.
- **Appendix P Thm 6.1 circular baby universe**: The conclusion (information goes to baby universe) is assumed as a premise (Einstein-Rosen bridge exists).
- **Appendix S Thm 7.1 chronology protection**: Step 4 ("information exists twice") is equivalent to "no CTCs" already. The conclusion is smuggled into a premise. **Don't formalize.**

### 1.5 Appendix F Citation Bug (URGENT)

Today's commit `9c1c86e` ("Reorganization beginning v2", 2026-04-11 19:24) overwrote `PhysicsPapers/Appendix-F-Information-Flow-Conservation.md` reducing it from 1038 lines to 56 lines. The new content is a π/continued-fraction paper that belongs elsewhere (probably with `LevelOfIrratotionalityOfPi/`).

V2's `Conservation/Information.lean` and `NoetherMetaStructure.lean` cite `Appendix F §1.4`, `§9.4`, `§9.5`, `§9A.2` — none of which exist in the current file. The real 1038-line version is preserved in:
- `site/src/content/papers/appendix-f-information-flow-conservation.md` (Astro-frontmattered mirror)
- `git show 6eab85e:PhysicsPapers/Appendix-F-Information-Flow-Conservation.md`

**Recommended fix**: restore the original under its original name, rename the new π paper to something like `Note-Continued-Fraction-Information-Channels.md` or move it into `LevelOfIrratotionalityOfPi/`.

---

## Part 2 — V1 vs V2: What to Un-Abandon

V2's PROJECT.md lists V1 files as "explicitly superseded". Forensic comparison shows the supersession is **partially misleading**. Four V1 files have content not in V2 that is worth rescuing:

| Priority | V1 file | Content to rescue | Effort |
|---|---|---|---|
| 1 | `DiscreteSpacetime/Axioms/Spacetime.lean` (596 lines) | Explicit M1–M6 + physical axioms. Contains `curvature_derivative_symmetry` which is exactly what V2 hides inside `BoundedSymmetryMetric`. Moving to a named, reviewable file is a pure auditability win. | 1 day |
| 2 | `DiscreteSpacetime/Geometry/Curvature/Symmetries.lean` + `Bianchi.lean` + `Ricci.lean` | Full algebraic proofs of Bianchi, `ricci_symmetric` etc. **on general symmetric metrics**, not just `BoundedSymmetryMetric`. V2's versions only work on the bounded class. | 3–5 days |
| 3 | `DiscreteSpacetime/Conservation/SpinInformation.lean` (317 lines, 0 sorries) | Spin-statistics via `native_decide`, axial anomaly density, spin-decoherence monotonicity. **Pure net-positive content** V2 dropped. | 2 days |
| 4 | `DiscreteSpacetime/Variational/InformationGeodesics.lean` | Log-barrier potential, kinetic Lagrangian, `kinetic_term_nonneg`, `potential_equilibrium_at_half`. Clean variational-principle content. | 1 day |
| 5 | `DiscreteSpacetime/Emergence/ContinuumLimit.lean` (definitions only, sorries dropped) | Discrete Sobolev scaffolding: `MultiIndex`, `lpNorm`, `discreteSobolevNorm`, `W^{k,2}` structure. Valuable scaffolding for any future τ→∞ convergence theorem. | 2 days for defs only |

**Do NOT port**: `Axioms/Computation.lean`, `Axioms/Action.lean`, `Dynamics/Healing.lean`, `Dynamics/Stability.lean`, `Emergence/EinsteinEmergence.lean`, `Irrationality/TensorErrors.lean`, `ConvergenceComparison.lean`, `PrecisionHierarchy.lean`, `Geometry/Einstein.lean` — these are legitimately superseded.

---

## Part 3 — Mathlib Infrastructure V2 Is NOT Using

V2 currently uses approximately **10% of directly relevant Mathlib**. Top leverage opportunities:

| # | Mathlib module | What it gives V2 | How to use it |
|---|---|---|---|
| 1 | `Analysis/InnerProductSpace/Laplacian.lean` | Concrete continuum `Δ` on finite-dim inner product spaces | Target object for discrete→continuous Laplacian convergence in Appendix S |
| 2 | `Geometry/Manifold/VectorBundle/CovariantDerivative/Torsion.lean` | **Continuum torsion already exists** — `IsCovariantDerivativeOn.torsion`, `torsion_eq_zero_iff` | Appendix P's torsion claims should import this, not reinvent |
| 3 | `InformationTheory/KullbackLeibler/Basic.lean` | KL divergence with chain rule | Natural home for `I(n) = ½log det(-g) + ½Tr(g⁻¹g₀)` as a KL-between-Gaussians |
| 4 | `Analysis/ODE/PicardLindelof.lean` + `Gronwall.lean` + `Dynamics/OmegaLimit.lean` | ODE existence/uniqueness, Grönwall, ω-limit sets | Reframe healing flow as honest ODE; prove convergence via Grönwall |
| 5 | `Combinatorics/Quiver/*` + `SimpleGraph/Acyclic.lean` | Directed graphs, paths, acyclicity | Carrier for any *reformulated* causal lattice / no-CTC work |
| 6 | `Geometry/Manifold/Riemannian/Basic.lean` | `IsRiemannianManifold` typeclass | Target object for continuum limit theorems |
| 7 | `LinearAlgebra/ExteriorAlgebra/*` + `Alternating/Basic.lean` | `∧`, alternating multilinear maps | Discrete differential forms for a DEC-flavored reformulation |
| 8 | `Analysis/InnerProductSpace/Spectrum.lean` + `Rayleigh.lean` | Spectral theorem, Rayleigh quotient | Variational characterization of the discrete Laplacian spectrum |
| 9 | `Analysis/Calculus/Taylor.lean` | Taylor remainder | Drops ~500 lines of bookkeeping from the irrationality error bounds |
| 10 | `Analysis/InnerProductSpace/LaxMilgram.lean` | Variational existence for elliptic problems | Existence half of a minimizer for `F[g]` when the second variation is coercive |

**Confirmed gaps in Mathlib itself** (where V2 would be a net contributor):
- Ricci / Riemann curvature tensors on a Riemannian manifold (connection + torsion exist, curvature does not)
- Sobolev spaces `W^{k,p}`
- Discrete exterior calculus
- Lyapunov function formalism
- Cheeger's inequality
- Relativity content (Minkowski, Lorentzian signature, Einstein equations)

---

## Part 4 — Paradigm-Shift Target Ranking

Scoring: Novelty / (inverted) Difficulty / Rigor payoff / Paradigm potential / Publishability, each 1–10, max 50.

### Tier S — Ready to ship (total 36+)

| Target | Score | Status |
|---|---|---|
| **A. Weyl trace-free on lattice (structure-preserving)** | **46/50** | Proven in `Weyl.lean:194`. Draft exists. CQG Note candidate. |
| **E. Extended uncertainty from truncation bounds** | 41/50 | Proven in `Irrationality/Uncertainty.lean`. Bundle candidate. |
| **C. Irrationality rates (π, e, √2)** | 38/50 | Proven in `Irrationality/BoundsLemmas.lean`. Formalization paper candidate. |
| **F. Bekenstein → `E_rq = E_P·log 5/π`** | 37/50 | Two-line proof missing from `Gravitons.lean`. 1 hour to add. |
| **D. Erdős-Noether bundle (E2+E6+E8)** | 36/50 | E2 and E8 proven in `Variational/`. E6 (convexity) missing — ~1 week. |

### Tier A — Strategic bets (25–35)

| Target | Score | Effort |
|---|---|---|
| **L. Emergent torsion from `[Δ_μ, Δ_ν]g`** | 35/50 | 1–2 months |
| **K. Spin-statistics via `native_decide`** | 33/50 | 2 days (port from V1) |
| **R. Hierarchical uncertainty via Liouville measures** | 32/50 | 2–3 months |
| **O. Healing flow τ→∞ convergence** | 31/50 | 2+ months (blocked on Sobolev) |
| **P. Weyl via Clifford algebra generalization** | 30/50 | 1–2 months |
| **Q. Discrete Bianchi as cochain complex closure** | 29/50 | 2 months |

### Tier B — Long-horizon research goals

| Target | Score | Effort |
|---|---|---|
| **B. §6 conjecture: characterization of lattice-surviving identities** | 28/50 | 1–2 years |
| **M. Three-generation from π₁ = ℤ₃** | 27/50 | Research-grade, Mathlib-blocked |
| **N. Dimensional flow `d_eff = 4 − 2E/E_P`** | 25/50 | Research-grade, needs spectral dimension |

### Tier F — Traps (do NOT pursue)

| Target | Why | |
|---|---|---|
| **G. Full HPW from scratch** | 2–4 FTE-years. Mathlib has no Ricci, no Sobolev, no DEC. Will consume everything. |
| **I. Big Bounce density bound `ρ ≤ 2ρ_P`** | Requires Friedmann/Raychaudhuri ODE infrastructure V2 lacks. Research-grade. |
| **H. Appendix S Theorem 7.1 (Chronology Protection)** | **CIRCULAR** — Step 4 smuggles in the conclusion. Do not formalize as stated. |

---

## Part 5 — 6-Month Roadmap

### Month 1 — Foundation Repair (and the publication push)

**Week 1 (URGENT)**:
- [ ] **FIX Appendix F citation bug**: restore `Appendix-F-Information-Flow-Conservation.md` from `git show 6eab85e`, rename the new π paper (move to `LevelOfIrratotionalityOfPi/` or rename to `Note-Continued-Fraction-Information-Channels.md`).
- [ ] **Add a CI check**: grep V2 Lean docstrings for `§X.Y` references and verify each matches a heading in the cited `.md` file. Prevents recurrence.

**Weeks 1–2**:
- [ ] **Construct one concrete non-flat `BoundedSymmetryMetric` instance**. Build `Geometry/Examples.lean` with `g = η + ε·h` for a small perturbation `h`; compute `C_ps`, `M_inv`, `M_g` explicitly. This is the single highest-leverage line of code in the whole project — it turns the Weyl paper from vacuous-conditional to sound.

**Week 2**:
- [ ] **Easy wins from Appendix A/G**:
  - Add `actionDensity`, `thermalActionDensity`, `emergentTime` definitions.
  - Prove `I_max_eq_pi_over_ln2 : I_max(4πℓ_P²) = π/ln 2` (2 lines in `Gravitons.lean`).
  - Prove `E_rq_eq_E_P_log5_over_pi` as a real theorem, not a definitional unfold.
- [ ] **Port V1's `Axioms/Spacetime.lean`** to V2 as `Axioms/SpacetimePostulates.lean`. Move the hidden `pair_swap_bounded` / `contracted_bianchi_assumption` into this file explicitly as named assumptions.

**Weeks 3–4**:
- [ ] **Polish and submit Weyl trace-free paper to CQG**. Finalize draft at `Note-Structure-Preserving-Lattice-Curvature.md`:
  - Trim abstract to 150 words.
  - Cite the new concrete `BoundedSymmetryMetric` instance for non-vacuity.
  - Check Schouten (1954) and Eisenhart (1926) for alternate-routing prior art.
  - Upgrade §6 from "conjecture" to "observation with case-by-case verification of the Exact entries".
  - Add references: Regge 1961, Hirani 2003, Arnold-Falk-Winther 2006.
  - Submit to arXiv (`gr-qc` + `math.DG`) simultaneously.

**Deliverables**: Appendix F fixed, one concrete `BoundedSymmetryMetric` instance, Weyl paper submitted, easy wins from Appendix A/G in V2.

### Month 2 — Mathlib Integration + V1 Rescue

- [ ] **Port V1's curvature symmetries**: `Symmetries.lean`, `Bianchi.lean`, `Ricci.lean` — the general-metric versions that work without `BoundedSymmetryMetric`. This makes the curvature-symmetry chain independently useful.
- [ ] **Port V1's `SpinInformation.lean`** (317 lines). Adds spin-statistics via `native_decide`, axial anomaly, spin-decoherence monotonicity.
- [ ] **Reframe healing flow as a Mathlib ODE**:
  - Import `Analysis/ODE/PicardLindelof.lean` and `Gronwall.lean`.
  - State `IsHealingFlow` as an ODE in a finite-dim space (metric component-wise).
  - Use `Dynamics/OmegaLimit.lean` for the ω-limit characterization.
- [ ] **Split the HPW axiom** into two:
  - `discrete_laplacian_smooth_target_converges` — the pure HPW O(l_P²) rate.
  - `harmonic_gauge_box_eq_ricci` — the continuum harmonic-gauge identity.
  - Derive the current `laplacian_ricci_correspondence` from the two pieces with explicit rate.
- [ ] **Bundle the C+E+F "Computational Uncertainty Trilogy" paper** for arXiv and a journal submission (Foundations of Physics, Int. J. Theor. Phys., or similar). All proofs exist; the work is writing + narrative framing.

**Deliverables**: V1 curvature chain ported, SpinInformation ported, healing flow as ODE, HPW axiom split, Computational Uncertainty paper in flight.

### Month 3 — Erdős-Noether Paper + Hidden-Assumption Cleanup

- [ ] **Close E6 (action convexity) in `Variational/GraphAction.lean`**. This is the missing piece for the Erdős-Noether bundle (E2+E6+E8). Estimated 1 week.
- [ ] **Package the Erdős-Noether paper** as a self-contained contribution to discrete variational calculus. Submit to a formalization venue (CPP, ITP) or a discrete-math journal.
- [ ] **Structure-field audit**: for each of the 6 hidden axioms, either
  - (a) prove it from more primitive assumptions, or
  - (b) state it explicitly as an `axiom` or Prop-typed hypothesis in `Axioms/SpacetimePostulates.lean`.
  Collapse the 5 logical + 6 hidden = 11 effective assumptions into an honest inventory.
- [ ] **Rename misleading theorems**:
  - `bounce_prevents_singularity` → `torsionPressure_sign_correct`
  - Collapse `gauge_symmetry_implies_conservation`, `momentum_conservation`, `harmonic_gradient_current_conserved` into one theorem with aliases.
  - `gradient_current_exists_for_metric` — explicitly mark as vacuous-witnessed-by-zero.

**Deliverables**: Erdős-Noether paper in flight, honest axiom inventory, no more misleading theorem names.

### Month 4 — Propagate `Valued` Through Tensor Calculus

This is the month that turns V2's "innovation" from vaporware into reality.

- [ ] **Tag the repo** before starting — this is invasive refactor territory.
- [ ] **Port the geometry stack to `Valued` types**:
  - `valuedMetric : ValuedTensor02Field`
  - `valuedChristoffelSymbol` using `abs_mul_sub_mul_bound` for product rule
  - `valuedRiemannTensor` propagating errors through connection differences
  - `valuedRicciTensor` via trace contraction
  - `valuedEinsteinTensor`
- [ ] **Derive `pair_swap_bounded` from the `Valued` machinery** — now that errors propagate upward, the bound becomes a *theorem* from the metric's own error structure, not an assumption.
- [ ] **Construct `BoundedSymmetryMetric_from_SemiSmoothMetric` constructor** — every semi-smooth metric now canonically gives a bounded-symmetry metric with computable constants.

**Risk**: This is the biggest technical month. If it doesn't work, the `Valued` innovation remains dead code.

**Deliverables**: `Valued` types propagated, `pair_swap_bounded` becomes a theorem, `BoundedSymmetryMetric` has a general-purpose constructor.

### Month 5 — Information Geometry + KL Divergence

- [ ] **Reformulate `I(n)` as a KL divergence between Gaussians**. Import `InformationTheory/KullbackLeibler/Basic.lean`. Show `I(n) = KL(g(n) ‖ g₀(n))` for an appropriate Gaussian interpretation. Inherits chain rule, convexity, positivity for free.
- [ ] **Fisher information metric**: derive from `Probability/Moments/CovarianceBilin.lean` as a bilinear form on the tangent space of the metric parameter.
- [ ] **Port V1's `InformationGeodesics.lean`** (log-barrier potential, Lagrangian) under the new KL-based information geometry.
- [ ] **Add an honest tensor-valued Noether instance** to `NoetherMetaStructure`. Use `stress-energy tensor from Lagrange multipliers` (the A12 schema from Appendix A). Gives `ConservedCurrent` a second non-trivial inhabitant.

**Deliverables**: Information geometry on Mathlib's KL foundation, second non-trivial Noether instance.

### Month 6 — Causal Structure Groundwork (Cautiously)

- [ ] **Build `CausalLattice` as `Quiver V` + partial order on vertices**. Define `Quiver.IsAcyclic` (~20 lines, natural Mathlib PR candidate).
- [ ] **Formalize the TRIVIAL version of Appendix S Theorem 7.1** — i.e., "if information flow respects a global time ordering, no cycles exist" — as a lemma, NOT as "chronology protection derived from information conservation". Mark explicitly in the docstring that the time-monotonicity is an **axiom**, not a consequence of `∂_μ J^μ_I = 0`.
- [ ] **Take the `Valued` machinery** from Month 4 and prove `einstein_with_matter_emergence` with a **computed** error bound that depends on the metric's own `ε`, rather than the coarse `l_P` bound. This gives the flagship theorem real teeth.
- [ ] **Submit the Weyl Clifford-generalization paper** (target P in the ranking) as a follow-up to the Month 1 CQG Note.

**Deliverables**: Causal-lattice scaffold, honest chronology-protection lemma (not the circular one), improved emergence bound, sequel paper in flight.

---

## Part 6 — Top 5 Quick Wins (< 1 day each)

Do these this week regardless of the rest of the plan:

1. **Fix Appendix F citation bug** — restore from git (15 minutes).
2. **Add `I_max_eq_pi_over_ln2`** (2 lines) and `E_rq_via_Bekenstein` (5 lines) to `Emergence/Gravitons.lean`. Turns definitional unfoldings into real theorems with crisp physical meaning.
3. **Add `actionDensity`, `thermalActionDensity`, `emergentTime` definitions** to `Irrationality/Uncertainty.lean` or a new `Irrationality/ActionDensity.lean` (30 minutes). Appendix A Def 2.1/2.2/2.5.
4. **Rename `bounce_prevents_singularity`** → `torsionPressure_sign_correct`. Stops a misleading name from propagating into V2's headline claims.
5. **Add module-level comment to `NoetherMetaStructure.lean`** honestly flagging that `fourth_noether_meta_law` is a typeclass projection with one non-trivial inhabitant. Reader-honest.

---

## Part 7 — Top 3 Strategic Moves (unlock future work)

1. **Port V1's `Axioms/Spacetime.lean`** — makes the hidden axioms visible, gives reviewers a single auditable file.
2. **Propagate `Valued` through tensor calculus** (Month 4) — turns the "error-aware tensors" innovation from vaporware into real rigor.
3. **Reformulate information density via `KullbackLeibler`** (Month 5) — connects Omega Theory to a mature Mathlib theory, inherits convexity/positivity lemmas.

---

## Part 8 — Top 3 Traps (tempting but to avoid)

1. **Proving Laplacian-Ricci from scratch (G)** — 2–4 FTE-years, Mathlib has no Ricci curvature on manifolds. Split the axiom instead.
2. **Big Bounce density bound (I)** — looks close (`Torsion/BigBounce.lean` exists!) but has no actual density-bound theorem, only sign lemmas. Needs Friedmann ODE infrastructure.
3. **Appendix S Chronology Protection (H)** — **circular**. Step 4 of the 7-step proof is equivalent to "no CTCs" already. Do not formalize as stated. Either (a) reformulate with explicit time-monotonicity axiom (but then the "landmark" status evaporates — it becomes trivial), or (b) pivot to Theorem 4.1 (Energy Maintenance) which is honestly variational.

---

## Part 9 — The Single Biggest Bet

If you had 3 months and had to pick ONE target to bet everything on:

**Polish and ship the Weyl trace-free paper to Classical and Quantum Gravity as a Note.**

Not "work on it". **Ship it.** The proofs are done in `Weyl.lean:194` (`weyl_tracefree`) and `Weyl.lean:402` (`weyl_antisym_12_bounded`). The draft exists at `Note-Structure-Preserving-Lattice-Curvature.md`. The only remaining work is:

- One concrete `BoundedSymmetryMetric` instance for non-vacuity (Month 1 deliverable).
- Check Schouten/Eisenhart for alternate-routing prior art (1 day).
- Abstract trim to 150 words (1 hour).
- Update references + §6 prose (1 day).

**Why Weyl specifically:**

1. **Only target where "paradigm-shifting" and "already proven" overlap.** Every other high-score target (B §6 conjecture, L emergent torsion, M three-generation) needs months of new Lean work before you even know if it's provable. Weyl is done.

2. **The paradigm statement is crisp**: a curvature identity can be *exact* on a lattice even when identities you'd expect to be more basic are only *bounded* — and exactness depends on the proof route. Reviewers can't hand-wave that away.

3. **Route-dependence is the real bombshell**. Most people assume tensor identities either survive discretization or they don't. The fact that *which equivalent form you start from* determines survival is a statement about discretization as a functor failing on the nose. Makes numerical relativists, DEC researchers, and discrete differential geometers all stop and think.

4. **Creates a research program**. Weyl leads to §6 conjecture (B), Clifford generalization (P), and Bianchi-as-cochain (Q). One published paper becomes four follow-ups.

5. **Asymmetric risk**. Worst case: CQG bounces you to J. Math. Phys. — still respectable. Worst case for B/L/M: three months, no result, no paper, no credibility.

**Concrete 3-month plan if you pick this bet:**

- **Weeks 1–4**: Construct `BoundedSymmetryMetric` instance, check literature, polish draft, submit to arXiv + CQG.
- **Weeks 5–8**: Bundle C+E+F as the "Computational Uncertainty Trilogy" paper. All proofs exist; this is writing.
- **Weeks 9–12**: Close E6 convexity, package the Erdős-Noether paper, submit.

**End state at month 3**: three papers in flight, Weyl is the flagship, Computational Uncertainty is the bundled quick-win, Erdős-Noether is the research paper. You've demonstrated that Omega Theory produces *machine-verified* results at journal pace, and reviewers start taking the program seriously rather than treating it as crankwork.

---

## Part 10 — Honest Caveats

This plan is aggressive. Some risks the user should know about:

1. **The `Valued` propagation in Month 4 may fail**. It's an invasive refactor and the tensor algebra for discrete connections is fiddly. If it doesn't work, the error-aware-tensors innovation stays dead code — that's a real risk.

2. **CQG may not take the Weyl paper at Note length**. They may ask for expansion. The contingency is J. Math. Phys., Class. Quant. Grav. Letters, or Letters in Math. Phys.

3. **The Erdős-Noether bundle's convexity proof (E6)** may turn out to need Mathlib `StrictConvexOn` infrastructure that doesn't exist for the exact space-of-paths formulation. Budget 2 weeks instead of 1, with a fallback of a weaker `ConvexOn` statement.

4. **Fixing Appendix F without breaking the new π paper**. The new content isn't garbage — it's a genuine paper about continued fractions and irrationality that belongs with `LevelOfIrratotionalityOfPi/`. Handle this carefully.

5. **Any claim that requires the full Laplacian-Ricci correspondence at O(l_P²) rate** is locked behind Mathlib not having Ricci curvature on manifolds. Don't promise `l_P²` rates in any paper until that gap closes.

6. **Appendix D Thm 7.2 trace gap is a catastrophic finding**. The paper claims Einstein tensor emergence but only derives Ricci tensor emergence. Before publishing any "Einstein emergence" result from Omega Theory, the trace reversal needs to be explicit — the current chain is broken.

---

## Appendix — Reference Data

**Analysis waves summary** (14 opus-code-crawler agents):
- Wave 1: V2 map, V1 vs V2 forensic comparison, physics paper catalog, Appendix D deep dive
- Wave 2: Appendix F+A, Appendix P + BigBounce, Appendix E+G, secondary appendix sweep
- Wave 3: Mathlib infrastructure inventory, Weyl paper publication readiness, Appendix S deep dive, missing Appendix F hunt
- Wave 4: 6-month roadmap, risk/hidden-assumption triage, paradigm-shift target ranking

**Key file references**:
- `LeanFormalizationV2/PROJECT.md` — the canonical V2 architecture document
- `LeanFormalizationV2/OmegaTheory/Geometry/Weyl.lean:194` — `weyl_tracefree` (Tier S)
- `LeanFormalizationV2/OmegaTheory/Irrationality/BoundsLemmas.lean` — π/e/√2 rates (Tier S)
- `LeanFormalizationV2/OmegaTheory/Emergence/EinsteinEmergence.lean:93` — tautological flagship
- `LeanFormalizationV2/OmegaTheory/HealingFlow/Flow.lean:71` — `IsHealingEquilibrium.balance` hidden axiom
- `LeanFormalizationV2/OmegaTheory/Emergence/LaplacianRicci.lean:60` — the HPW axiom
- `Note-Structure-Preserving-Lattice-Curvature.md` — Weyl paper draft
- `site/src/content/papers/appendix-f-information-flow-conservation.md` — real Appendix F
- Git commit `6eab85e` — last-known-good Appendix F in source tree
- Git commit `9c1c86e` (2026-04-11 19:24) — where the bug entered

**Authoritative claim count on V2**:
- Theorems: 255 (of which ~40 are structural one-liners or tautologies)
- Declared axioms: 5 (of which 4 are physical constants + 1 HPW)
- Hidden axioms in structure fields: 6
- Effective axiom count: ~11
- Non-trivial proven theorems: ~215
- Top-tier proven content: ~25 (Weyl tracefree, π/e/√2 rates, ricci_symmetric_bounded chain, dissipationRate identity, first_bianchi, harmonic_gradient_current_conserved, etc.)
