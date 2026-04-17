# NOTES_CLUSTER_B_DESIGN.md — SmoothMetricField operator upgrade

**Author**: Izar (epsilon Bootis, "the veil/girdle"), 2026-04-17
**Scope**: research / design memo only. No `.lean` files modified.
**Goal**: design the upgrade of the placeholder `=0` continuum operators
(`continuumLaplacianAt`, `ricciTensorContinuum`) to real smooth-geometry operators,
unlocking non-trivial kappa > 0 bounds in EBHPW and non-trivial a_2, a_4 in SD.

Three upgrade options are analysed, ranked, and one is recommended with
a 4-6 week execution plan. Every speculative claim is flagged
`SPECULATIVE`. Every Mathlib-state claim is anchored to concrete
documentation paths.

---

## 1. Executive summary

**Problem**. `OmegaTheory.Emergence.HpwHypothesis` ships two opaque
continuum operators as `noncomputable def _ := 0`:

```lean
noncomputable def continuumLaplacianAt (_g_cont) (_x) (_mu _nu) : R := 0
noncomputable def ricciTensorContinuum (_g_cont) (_x) (_mu _nu) : R := 0
```

These are consumed at 111 call-sites across 10 Emergence files. All three
analytic propositions over `SmoothMetricField` (`TaylorRemainderBound`,
`HarmonicGaugeIdentity`, `WeinbergRicciBoxIdentity`) collapse to trivial
`|0 + 2 * 0| = 0 <= l_P^2` statements. The dischargers in
`_of_placeholders` fire on `rfl` + `abs_zero`.

**Parallel real infrastructure already exists** in
`OmegaTheory.Geometry.*` (built by Mizar 2026-04-15, extended by Fomalhaut,
Achernar, Thuban, and Caph):
- `Geometry/SmoothMetric.lean` — real `SmoothMetric` with `ContDiff R infty`
- `Geometry/Christoffel.lean` — real `christoffel`, `partialDeriv` via `fderiv`
- `Geometry/RiemannCurvature.lean` — real `riemann`
- `Geometry/RicciTensor.lean` — real `ricci`, `continuumScalarCurvature`
- `Geometry/RicciProperties.lean` — `ricciSymmetric_of_weinbergIdentity`
- `Geometry/WeinbergLinearised.lean` — linearised infrastructure
- `Geometry/HarmonicGaugeContinuum.lean` — `HarmonicGauge`, `WeinbergIdentity`
- `Geometry/ErrorBoundedSmooth.lean` — EBHPW with `fderiv`-based inverse-free
  `ebhpwPartialDeriv` + `smoothRicciEB` + `smoothScalarCurvatureEB`

**The two worlds do not yet intersect** at the operator level. `SmoothMetricField`
is scalar-valued `(Fin 4 -> R) -> Fin 4 -> Fin 4 -> R`, used by HPW regimes.
`SmoothMetric` is matrix-valued with a bundled inverse, used by Mizar's stack.
Caph's `HpwSmoothMetricBridge.lean` (Apr 17) provides a parallel
`HpwHypothesisStrict` with `toField` bridge — but currently only for flat
Minkowski.

**Recommendation**. **Option B + selective C** (wrapper + narrow type bridge):
extend the `HpwHypothesisStrict` line, do NOT touch `continuumLaplacianAt` /
`ricciTensorContinuum` placeholders. All 111 call-sites keep working. New
regimes opt into the strict track by supplying a `SmoothMetric` witness.

**Why not Option A** (direct upgrade of the placeholders to real `fderiv`
expressions): it breaks 7 regime files, 2 EBHPW dischargers, and the Apr 17
Alcyone / Maia / Electra upgrades in `HpwHypothesis.lean` — roughly 4 weeks
of re-proving with no architectural payoff that Option B cannot deliver.

**Estimated cost to MATTER SECTOR COMPLETION (kappa > 0 globally + SD a_2,
a_4 non-trivial)**: 4-6 weeks with 4 sequential agents after Cluster B starts.

---

## 2. Mathlib v4.29 inventory for smooth geometry

### 2.1 What ships TODAY (confirmed via Mathlib docs search)

- **`ContDiff R n f`** — `C^n` regularity predicate, full API
  (`Mathlib.Analysis.Calculus.ContDiff.Defs`). Composable with
  `ContDiff.const`, `ContDiff.add`, `ContDiff.mul`, `ContDiff.comp`,
  `contDiff_const`, `ContDiff.of_le`. Reliable workhorse.
- **`fderiv R f x`** — Frechet derivative as continuous linear map
  `E ->L[R] F` (`Mathlib.Analysis.Calculus.FDeriv.Basic`). Already used
  in our `Geometry/Christoffel.lean` via
  `partialDeriv f sigma x := (fderiv R f x) (Pi.single sigma 1)`.
- **`iteratedFDeriv R n f`** — n-th derivative as multilinear map
  `(Fin n -> E) -> F`. Works at arbitrary order. Used nowhere in
  OmegaTheory yet; would be needed for the 4th-derivative bound
  `M_4 := sup |iteratedFDeriv R 4 f|`.
- **`IsManifold`, `ChartedSpace`, `ModelWithCorners`** — manifold theory
  (`Mathlib.Geometry.Manifold.*`). Heavyweight; we don't need it on
  `R^4` which is trivially a model.
- **`Mathlib.Geometry.Manifold.VectorField.LieBracket`** — recent
  (late 2025 / early 2026). Would support a bundled covariant-derivative
  formulation but MUCH heavier machinery than plain `fderiv`.
- **`IsRiemannianManifold I M`** in
  `Mathlib.Geometry.Manifold.Riemannian.Basic` — Prop-valued typeclass
  with `IsContMDiffRiemannianBundle`. Does NOT ship Christoffel, Ricci,
  covariant derivative, Laplace-Beltrami.

### 2.2 What is MISSING

- **Ricci tensor in general** — not in Mathlib v4.29. Partial progress
  upstream via manifold VectorField, but no `ricci : Manifold -> Tensor`.
- **Christoffel symbols** — not in Mathlib.
- **Heat kernel / spectral asymptotic expansion (Seeley-DeWitt)** — not
  in Mathlib. Not likely before Mathlib v5.0.
- **Laplace-Beltrami / d'Alembertian on general metrics** — not in
  Mathlib (scalar Laplacian on `R^n` trivial from `fderiv`).
- **Smoothness of matrix inverse** as a composition lemma — partial
  (`ContDiff.inv` for division ring elements), but no direct `GL_n(R)`
  lemma mapping `ContDiff g -> ContDiff g^{-1}`. OmegaTheory already
  carries this as a deferred Prop `SmoothMetric.InverseSmooth`.

### 2.3 What we can do ourselves with `fderiv` (no manifold machinery)

**Sufficient for Cluster B**: we work on `R^4`, not a general manifold,
so bundled tangent-bundle machinery is overkill. For each component
`g_{mu nu} : (Fin 4 -> R) -> R`:

- **Partial** `partialDeriv f sigma x := (fderiv R f x) (Pi.single sigma 1)`
  (already in Christoffel.lean).
- **Second partial** `partialDeriv_sq f mu nu x :=
  partialDeriv (fun y => partialDeriv f nu y) mu x`.
- **Continuum Laplacian** `sum_{mu} partialDeriv_sq f mu mu x`
  (flat-background version; honest naming: this is
  `delta^{mu nu} partial_mu partial_nu`, NOT `g^{mu nu} partial_mu partial_nu`).
- **Ricci from Christoffel** as in `Geometry/RicciTensor.lean`.

**Insufficient for Cluster B** (requires full Mathlib upgrade):
- True covariant Laplacian `g^{mu nu} nabla_mu nabla_nu` with
  Christoffel correction — needs `inv` smoothness.
- Integrated spectral action `int_M f(D/Lambda) sqrt(|g|) d^4 x`.
- Heat-kernel coefficient asymptotic expansion.

---

## 3. Our custom Geometry/ stack — architecture

### 3.1 Two coexisting types

| Type | Location | Components | Inverse? | Used by |
|------|----------|------------|----------|---------|
| `SmoothMetricField` | `Emergence/HpwHypothesis.lean` | `(Fin 4 -> R) -> Fin 4 -> Fin 4 -> R` | NO | all 7 HPW regimes, `hpw_from_hypothesis`, `RicciComparison` |
| `SmoothMetric` | `Geometry/SmoothMetric.lean` (Mizar) | `(Fin 4 -> R) -> Matrix (Fin 4) (Fin 4) R` + `nondeg` + `symm` | YES via `inverseMetric` | `christoffel`, `riemann`, `ricci`, `HarmonicGauge`, `WeinbergIdentity` |
| `ErrorBoundedSmoothMetric` | `Geometry/ErrorBoundedSmooth.lean` | `Event -> Matrix (Fin 4) (Fin 4) R` + N-indexed discrete | NO (pointwise-only) | EBHPW scaffold, `smoothRicciEB`, `smoothScalarCurvatureEB` |

### 3.2 Existing bridges

- **`SmoothMetric.toField`** (Mizar) — forward: matrix-valued -> scalar-valued.
  Identity on components: `g.toField x mu nu := (g.toFun x) mu nu`.
- **`bridge := SmoothMetric.toField`** (Caph) — readable alias.
- **`HpwSmoothMetricBridge.HpwHypothesisStrict`** (Caph) — parallel hypothesis
  bundle carrying Mizar's real `HarmonicGaugeBound` + `WeinbergRicciBox`.
- **`HpwHypothesisStrict.toStandard`** (Caph) — forgetful map Strict -> standard.
- **`bridge_preserves_laplacian`, `bridge_preserves_ricci`** (Caph) — the
  "rfl-packaging" showing that under the `=0` placeholder, the bridge
  trivially aligns.

### 3.3 The canonical type question

`SmoothMetricField` is the **interface type** exposed to HPW regime consumers.
`SmoothMetric` is the **implementation type** with real operator infrastructure.
`ErrorBoundedSmoothMetric` is the **substrate-essential** type carrying the N-indexed
discrete-smooth decomposition.

**Design question**. Should we consolidate?

- **Not yet**. `SmoothMetricField` is used in `hpw_from_hypothesis`,
  `RicciComparison`, and the `*Data` bundles of 7 regimes. Merging with
  `SmoothMetric` introduces matrix-inverse obligations everywhere that
  currently does not need them. That's Option A cost (breaking
  change to 7 regimes for no new theorems).

- **YES in the long run**. The cleanest final state is ONE type
  carrying matrix values + ContDiff + pointwise invertibility. Cluster
  B should migrate in this direction by making `SmoothMetricField`
  a view onto `SmoothMetric` via a typeclass or explicit coercion.
  But the *enabling* step for kappa > 0 is making the OPERATORS real,
  not flattening the TYPES.

---

## 4. Proposed architecture — three options ranked

### 4.1 Option A: Direct upgrade of `continuumLaplacianAt` / `ricciTensorContinuum`

**Mechanism**. Rewrite `continuumLaplacianAt` and `ricciTensorContinuum` in
`HpwHypothesis.lean` with real `fderiv`-based definitions. For example:

```lean
noncomputable def continuumLaplacianAt
    (g_cont : SmoothMetricField) (x : Fin 4 -> R) (mu nu : Fin 4) : R :=
  Finset.univ.sum fun sigma =>
    partialDeriv (fun y => partialDeriv (fun z => g_cont z mu nu) sigma y) sigma x
```

`ricciTensorContinuum` requires Christoffel + its first partial — but
`SmoothMetricField` has no inverse, so this would require a trace-form
`flat-background` Ricci (Laplacian of h_{mu nu} in `g = eta + h`),
which is only meaningful in linearised-perturbation regime.

**Breaking changes** (audited by grep of `_of_placeholders`):
- `harmonicGaugeIdentity_of_placeholders` (1 site) breaks — cannot discharge.
- `weinbergRicciBoxIdentity_of_placeholders` (1 site) breaks.
- `taylorRemainderBound_of_laplacian_zero` (1 site) breaks — `continuumLaplacianAt = 0`
  no longer holds.
- `continuumLaplacianAt_placeholder` + `ricciTensorContinuum_placeholder` — both
  become false theorems; every consumer that uses them breaks.
- 7 HPW regime files (`HpwMinkowski`, `HpwLinearised`, `HpwSchwarzschild`,
  `HpwFRW`, `HpwBianchiI`, `HpwDeSitter`, `HpwKerr`) break at their
  `h_taylor` / `h_ricci_box` fields — 10 sites per Alioth's PROP_TRUE_AUDIT.md
  Category C fix.
- `HpwTotalTruncation.lean` breaks.
- `RicciComparison.lean` breaks (it's built around a hypothetical
  `continuumLaplacianAt` placeholder).

**Re-proof cost estimate**: 4 weeks minimum with 2 sequential agents:
- Week 1-2: rewrite `_of_placeholders` dischargers with real
  estimates. Requires supplying a `SmoothMetric` witness per regime
  (which none currently have) OR a direct `fderiv`-level bound.
- Week 2-3: re-prove `HpwMinkowski` (easy — derivatives of constant are zero),
  `HpwLinearised` (moderate — needs Achernar's linearised framework),
  and `HpwTotalTruncation`.
- Week 3-4: `HpwSchwarzschild`, `HpwFRW`, `HpwBianchiI`, `HpwDeSitter`,
  `HpwKerr` — each needs a concrete smooth interpolant with known
  4th-derivative bound. Without Mathlib's Ricci/Christoffel
  infrastructure, each regime takes about 1 agent-week to discharge
  real `h_taylor` and `h_ricci_box` bounds.

**Architectural payoff**: kappa > 0 bounds flow through `hpw_from_hypothesis`
automatically. SD machinery (Tarazed's Minimal SD) gets non-trivial `a_2`,
`a_4` sourced from non-zero `continuumLaplacianAt`.

**Risk**: HIGH. A breaking change across 111 call-sites with no
in-flight branch protects against regression. The Apr 17 work
(Alcyone, Maia, Electra upgrading `h_taylor` / `h_harmonic` /
`h_ricci_box` to carry semantic content) was predicated on
`_of_placeholders` being available. Wiping the placeholders unwinds
that.

### 4.2 Option B: Wrapper type `SmoothMetricFieldReal`

**Mechanism**. Introduce a new file
`Geometry/SmoothMetricFieldReal.lean` (or extend
`HpwSmoothMetricBridge.lean`) with a structure extending
`SmoothMetricField` with explicit smoothness + real-operator
witnesses:

```lean
structure SmoothMetricFieldReal extends SmoothMetricField where
  -- Component smoothness
  contDiff : forall mu nu, ContDiff R 4 (fun x => toFun x mu nu)

structure SmoothMetricFieldRealWithInverse extends SmoothMetricFieldReal where
  -- Bundled matrix inverse with ContDiff
  inv : (Fin 4 -> R) -> Matrix (Fin 4) (Fin 4) R
  inv_contDiff : forall mu nu, ContDiff R 3 (fun x => inv x mu nu)
  inv_is_inverse : forall x, Matrix.of toFun * inv x = 1

-- Real continuum Laplacian on the flat background:
noncomputable def continuumLaplacianReal
    (g : SmoothMetricFieldReal) (x : Fin 4 -> R) (mu nu : Fin 4) : R :=
  Finset.univ.sum fun sigma =>
    partialDeriv (fun y => partialDeriv (fun z => g.toFun z mu nu) sigma y) sigma x

-- Upgraded hypothesis bundle:
structure HpwHypothesisReal (g : DiscreteMetric) extends HpwHypothesis g where
  g_cont_real : SmoothMetricFieldReal
  h_g_cont_real_matches : forall x mu nu, g_cont_real.toFun x mu nu = g_cont x mu nu
  h_taylor_real_le : forall p mu nu,
    |discreteLaplacian (fun q => g q mu nu) p - continuumLaplacianReal g_cont_real ... mu nu|
      <= kappa_taylor * computationalUncertainty N
```

**Breaking changes**: ZERO. The existing `SmoothMetricField`,
`HpwHypothesis`, and all 7 regime witnesses keep compiling. New track
is opt-in. Cluster B agents can incrementally upgrade regimes from
standard -> Real without touching the standard track.

**Architectural payoff**: `HpwHypothesisReal` carries kappa-indexed
bounds in its fields. Consumers (EBHPW, SD) can branch on whether
they receive a standard or Real hypothesis — the latter grants
kappa > 0. The forgetful `HpwHypothesisReal.toHpwHypothesis` map
(via inheriting `extends HpwHypothesis g`) means every Real
consumer immediately works with the standard HPW chain.

**Risk**: LOW. Type-class duplication is the only architectural
cost. Mitigated by making `HpwHypothesisReal` a *subtype* of
`HpwHypothesis` via `extends` — no duplication, pure enrichment.

**Re-proof cost estimate**: 2-3 weeks for 4 agents.
- Week 1: `SmoothMetricFieldReal` type + Minkowski witness +
  forgetful map. (Agent 1)
- Week 1-2: real continuum Laplacian + Ricci definitions on the
  new type; real `TaylorRemainderBoundReal` and
  `HarmonicGaugeIdentityReal` predicates. (Agent 2)
- Week 2-3: Linearised + Schwarzschild regime upgrades. (Agent 3)
- Week 3: FRW + de Sitter + Bianchi I + Kerr regime upgrades.
  (Agent 4)

### 4.3 Option C: Type bridge `SmoothMetricField.ofSmoothMetric`

**Mechanism**. Add a `SmoothMetric -> SmoothMetricField` converter
(already exists as `SmoothMetric.toField`), then ALSO ship a
`SmoothMetricField.ofSmoothMetric` on `Geometry/SmoothMetric.lean` side
that carries the ContDiff + nondeg hypotheses. Reuse Mizar's real
`christoffel`, `riemann`, `ricci` operators on the `SmoothMetric` form;
use the opaque ones on the `SmoothMetricField` form.

Then build a NEW `HpwHypothesisFromSmoothMetric` at the strict-track
level (Caph's Apr 17 `HpwHypothesisStrict` is one example; this
generalises to the 6 non-flat regimes).

**Breaking changes**: ZERO. Purely additive.

**Architectural payoff**: Same as Option B, but relying more
heavily on Caph's existing `HpwHypothesisStrict` scaffold. The
consolidation pressure is lower — both `SmoothMetricField` and
`SmoothMetric` continue to exist as dual representations.

**Risk**: MEDIUM. Two coexisting types risk confusion. But this is
already the current state — so Option C just extends the pattern.

**Re-proof cost estimate**: Same as Option B (2-3 weeks for 4 agents).
The work is fundamentally the same: write real operator witnesses
for 6 non-flat regimes. The only difference is *where* those
witnesses live — Option B puts them in a new `SmoothMetricFieldReal`;
Option C puts them in the existing `SmoothMetric` via
`HpwHypothesisStrict`.

### 4.4 Ranking

| Option | Breaking-change risk | Proof engineering cost | Long-term maintainability | Mathlib-integration potential |
|--------|---------------------|------------------------|--------------------------|------------------------------|
| **A** Direct upgrade | HIGH (111 sites, 7 regime files) | HIGH (4 weeks) | BEST (one unified type) | MEDIUM (our types) |
| **B** Wrapper type | ZERO | LOW-MEDIUM (2-3 weeks) | MEDIUM (dual types) | LOW (our derived type) |
| **C** Type bridge | ZERO | LOW-MEDIUM (2-3 weeks) | GOOD (extends Caph's pattern) | MEDIUM (Mizar's `SmoothMetric` is Mathlib-PR-candidate) |

**Weighted recommendation**: B+C hybrid.

**Reasoning**. Option C's `SmoothMetric` is already a Mathlib PR
candidate per Mizar. Leveraging it for the upgrade path maximises
upstream gain. Option B's `SmoothMetricFieldReal` hybrid (extending
the existing type with a `contDiff` field) is a minimal local
addition on the HPW side. Together:

- Regime witnesses go on the strict track via
  `HpwHypothesisFromSmoothMetric` (Option C extension).
- Existing `SmoothMetricField`-based regimes keep working (Option B
  via zero-breaking).
- Alcyone/Maia/Electra's Apr 17 upgrades to `h_taylor` /
  `h_harmonic` / `h_ricci_box` keep firing via
  `_of_placeholders`.

---

## 5. EBHPW substantive upgrade (Nashira's g_perturbation)

### 5.1 The current sharp-witness problem

`ErrorBoundedSmoothMetric` currently has all 7 regime witnesses
built via `constEBHPW M hsymm`, where `g_smooth = g_discrete N = M`
(a constant matrix). The approximation error is 0 pointwise, so
the bound `|g_discrete - g_smooth| <= computationalUncertainty N`
holds vacuously with kappa = 0.

This makes the Group A operator-level bounds (Christoffel, Riemann,
Ricci, Scalar, Einstein tensor approximations) all hold with
C = 0. Group B's `SubstrateEinsteinEquation` has kappa = 0. This is
architecturally complete per SPEC_EBHPW.md but physically trivial.

### 5.2 Nashira's proposal — verified

Add a perturbation field to extend sharp -> non-trivial:

```lean
structure ErrorBoundedSmoothMetricReal extends ErrorBoundedSmoothMetric where
  g_perturbation : Event -> Matrix (Fin 4) (Fin 4) R
  g_perturbation_bounded : forall x mu nu, |g_perturbation x mu nu| <= 1
  g_discrete_eq : forall N x mu nu,
    g_discrete N x mu nu = g_smooth x mu nu + computationalUncertainty N * g_perturbation x mu nu
```

**This is exactly right**, with ONE caveat: `g_discrete_eq` must be
consistent with the inherited `g_approx_bound`. Sanity check:

```
|g_discrete N x mu nu - g_smooth x mu nu|
  = |computationalUncertainty N * g_perturbation x mu nu|
  = computationalUncertainty N * |g_perturbation x mu nu|       (because delta_comp >= 0)
  <= computationalUncertainty N * 1                              (by g_perturbation_bounded)
  = computationalUncertainty N                                   (OK, matches g_approx_bound)
```

So the proof obligation on `g_approx_bound` in the `extends` is
discharged by composition — no redundancy. Nashira's design is
sound.

### 5.3 Issue — `g_approx_bound` is hypothetical, not derived

In the current `ErrorBoundedSmoothMetric`, `g_approx_bound` is a
field. In `ErrorBoundedSmoothMetricReal`, `g_discrete_eq` +
`g_perturbation_bounded` **derives** `g_approx_bound`. Structural
options:

**Option B.1**. Keep `g_approx_bound` as inherited field, add a theorem
`g_approx_bound_from_perturbation` proving it from the new fields.
Constructor discharges the inherited field via that theorem. Clean.

**Option B.2**. Remove `g_approx_bound` from the Real subtype (NOT
possible with `extends`), or override.

**Recommended**: B.1. `extends` with explicit constructor.

```lean
structure ErrorBoundedSmoothMetricReal where
  toSharp : ErrorBoundedSmoothMetric
  g_perturbation : Event -> Matrix (Fin 4) (Fin 4) R
  g_perturbation_bounded : forall x mu nu, |g_perturbation x mu nu| <= 1
  g_discrete_eq : forall N x mu nu,
    toSharp.g_discrete N x mu nu =
      toSharp.g_smooth x mu nu + computationalUncertainty N * g_perturbation x mu nu
```

With this design, Group A operator bounds become non-trivial: the
approximation error at the Christoffel level is
`O(computationalUncertainty N * |partial g_perturbation|)`,
giving kappa > 0 proportional to the Sobolev norm of the
perturbation. SD machinery (Tarazed's `GeneralizedLaplacian` +
Vassilevich a_2, a_4) picks up a substrate-essential Lambda^2 factor
via Lambda = 1/computationalUncertainty(N).

### 5.4 Hierarchy of EBHPW witnesses

Post-upgrade, 7 regime witnesses in `ErrorBoundedSmooth.lean` migrate
from `constEBHPW` to a richer family:

- **`constEBHPW`** (current). Sharp witness. `g_perturbation = 0`. kappa = 0.
- **`perturbedEBHPW g_smooth g_perturbation h_bound`** (new, Nashira).
  Non-trivial perturbation. kappa > 0.
- **`exactEBHPW g_smooth`** (future). A true C^infty interpolant of the
  discrete lattice, derived from the actual ZZ^4 discretisation. This
  closes the ring — `g_perturbation` is then the exact residual between
  the continuum interpolant and the lattice.

Cluster B's job is `perturbedEBHPW`. `exactEBHPW` is after Cluster B.

---

## 6. Dependency chart — which downstream files need updating per option

### 6.1 Option A — direct upgrade

**BREAKS** (need to re-prove):
1. `Emergence/HpwHypothesis.lean` — the 3 `_of_placeholders`
   dischargers, the 2 `_placeholder` identity theorems (7 files depend
   on `continuumLaplacianAt_placeholder = rfl`).
2. `Emergence/HpwMinkowski.lean` — `minkowskiHpwHypothesis`.
3. `Emergence/HpwLinearised.lean` — `HpwHypothesis_of_linearised`.
4. `Emergence/HpwSchwarzschild.lean` — `HpwHypothesis_of_vacuum_static`.
5. `Emergence/HpwFRW.lean` — `HpwHypothesis_of_frw`.
6. `Emergence/HpwBianchiI.lean` — `HpwHypothesis_of_bianchiI`.
7. `Emergence/HpwDeSitter.lean` — `HpwHypothesis_of_deSitter`.
8. `Emergence/HpwKerr.lean` — `HpwHypothesis_of_kerr`.
9. `Emergence/HpwTotalTruncation.lean` — the ingredient-triple constructor.
10. `Emergence/HpwElimSummary.lean` — typeclass instances reconstruct.
11. `Emergence/EinsteinEmergence.lean` — `*_regime` theorems (5 sites).
12. `Emergence/HarmonicGauge.lean` — 15 sites.
13. `Emergence/RicciComparison.lean` — 19 sites.

**TOTAL**: ~13 files, ~111 call-sites, full GR side of OmegaTheory.
Each regime's `h_taylor` / `h_harmonic` / `h_ricci_box` dischargers
need a real derivation — impossible without Mizar-style real
operator infrastructure per metric.

### 6.2 Option B / C — wrapper or bridge

**BREAKS**: 0 files. Purely additive.

**NEW FILES** to add (per option):
- Option B:
  - `Geometry/SmoothMetricFieldReal.lean` — new wrapper type +
    `continuumLaplacianReal`, `ricciTensorContinuumReal`
    definitions + smooth witnesses.
  - `Emergence/HpwHypothesisReal.lean` — upgraded hypothesis bundle
    + `toHpwHypothesis` forgetful map.
  - Per-regime real-upgrade files:
    `Emergence/HpwMinkowskiReal.lean`,
    `Emergence/HpwLinearisedReal.lean`, etc. (7 files)
- Option C:
  - Extend `Emergence/HpwSmoothMetricBridge.lean` (already exists,
    has `HpwHypothesisStrict`, currently has Minkowski witness).
  - Add 6 non-flat regime witnesses:
    `HpwSmoothMetricBridge.LinearisedStrict`, etc.

**EBHPW upgrade** (parallel to B or C):
- `Geometry/ErrorBoundedSmoothReal.lean` — new wrapper type with
  `g_perturbation` field, `perturbedEBHPW` constructor,
  upgraded regime witnesses.

**Re-proof counts**:
- Option B: ~10 new files, ~2000 LOC, ~150 theorems.
- Option C: ~7 new files (reusing Caph's bridge), ~1500 LOC,
  ~100 theorems.

---

## 7. 4-agent execution plan (Cluster B team)

Once Option B+C hybrid is chosen, dispatch 4 agents **partially in
parallel**:

### Agent 1 (foundation, SEQUENTIAL FIRST, week 1)
- File: `Geometry/SmoothMetricFieldReal.lean` (Option B) OR extend
  `Geometry/SmoothMetric.lean` (Option C).
- Define new wrapper type.
- Define `continuumLaplacianReal`, `ricciTensorContinuumReal` via
  `fderiv` + Mizar's `christoffel` / `ricci`.
- Prove flat-Minkowski case:
  `continuumLaplacianReal flatSmoothMetricReal = 0` trivially.
- Ship `toField` + compatibility theorem
  `continuumLaplacianReal g = 0 iff continuumLaplacianAt g.toField = 0`.
- Output: one new file, ~300 LOC, ~15 theorems. Build GREEN.

### Agent 2 (hypothesis upgrade, SEQUENTIAL SECOND, week 1-2)
- Waits for Agent 1's type.
- File: `Emergence/HpwHypothesisReal.lean`.
- Define `HpwHypothesisReal g extends HpwHypothesis g` with:
  - `g_cont_real : SmoothMetricFieldReal`
  - `h_g_cont_real_matches : forall x mu nu, g_cont_real x mu nu = g_cont x mu nu`
  - `kappa : R` with `0 <= kappa`
  - `h_taylor_kappa : TaylorRemainderBoundReal g g_cont_real kappa`
    (the real `fderiv`-based bound)
  - `h_ricci_box_kappa : WeinbergRicciBoxReal g_cont_real kappa`
- Prove forgetful map: `HpwHypothesisReal.toHpwHypothesis` discharges
  all inherited fields by routing through the opaque-zero world.
- Output: one new file, ~400 LOC, ~20 theorems.

### Agent 3 (flat + linearised + Schwarzschild regimes, PARALLEL, week 2-3)
- File: `Emergence/HpwMinkowskiReal.lean`,
  `Emergence/HpwLinearisedReal.lean`,
  `Emergence/HpwSchwarzschildReal.lean`.
- For each regime:
  - Build a concrete `SmoothMetricFieldReal` witness (Minkowski:
    constant eta; Linearised: eta + h with h constant; Schwarzschild:
    an analytic function of r with explicit 4th-derivative bound).
  - Discharge `TaylorRemainderBoundReal` using Arcturus's
    `central_diff_second_order_accurate` (exists in
    `Foundations/TaylorBound.lean`).
  - Discharge `WeinbergRicciBoxReal` using Fomalhaut's
    `ricciBoxDefect_bound_of_weinberg_and_quadratic`.
  - Extract kappa explicitly.
- Output: 3 new files, ~900 LOC total, ~60 theorems.

### Agent 4 (FRW + Bianchi I + de Sitter + Kerr regimes, PARALLEL, week 3-4)
- File: `Emergence/HpwFRWReal.lean`, etc.
- Same pattern as Agent 3, but for cosmological regimes.
- de Sitter uses FRW specialization (Castor's pattern).
- Bianchi I as FRW generalization (Canopus's pattern).
- Output: 4 new files, ~1200 LOC total, ~80 theorems.

### Agent 5 (optional, Nashira's EBHPW upgrade, PARALLEL with Agents 3-4, week 2-4)
- File: `Geometry/ErrorBoundedSmoothReal.lean`.
- Add `g_perturbation` field per Nashira's design.
- Ship `perturbedEBHPW` constructor.
- Upgrade 7 regime witnesses from `constEBHPW` to `perturbedEBHPW`
  with specific non-trivial perturbation fields.
- Output: one new file, ~600 LOC, ~30 theorems.

**Parallelism**. Agents 3 and 4 depend only on Agent 2's output.
They can run in parallel. Agent 5 is fully independent. This gives
3-4 agent-weeks of parallel work after 2 agent-weeks of sequential
foundation.

**Total estimated effort**: 4-6 weeks with a 4-person (parallel)
team after Cluster B starts, per SPEC_EBHPW.md's completion target.

---

## 8. Recommendation

**Pick Option B + C hybrid**: add `SmoothMetricFieldReal` as a minimal
wrapper (B) AND extend Caph's `HpwSmoothMetricBridge` (C) so the new
wrapper type can flow into the strict track. Zero breaking changes to
the 111 existing call-sites of `continuumLaplacianAt = 0` /
`ricciTensorContinuum = 0`. Preserve Alcyone/Maia/Electra's Apr 17
semantic upgrades.

**Execution**: sequential Agent 1 (foundation type) -> sequential Agent
2 (HpwHypothesisReal) -> parallel Agents 3, 4, 5 (regimes + EBHPW).
Estimated 4-6 weeks to MATTER SECTOR COMPLETION, where every regime
witness carries non-trivial kappa > 0 and Tarazed's Minimal SD
machinery gets non-trivial a_2, a_4 via Lambda = 1/delta_comp(N).

**Key invariants**:

1. **Zero sorry**, **zero new axioms** throughout.
2. **Preserve pi = heavy convention** (gen 3 <-> pi truncation).
3. **Reuse Mizar's `christoffel`, `riemann`, `ricci`** rather than
   redefining.
4. **Reuse Arcturus's `central_diff_second_order_accurate`** in
   `Foundations/TaylorBound.lean` for the Taylor bounds.
5. **Sharp-witness upgrade path**: after Cluster B lands, each regime
   retains its sharp witness AND has a new non-trivial real witness;
   consumers pick whichever they need.
6. **Mathlib PR candidates**: Mizar's `SmoothMetric`, the
   `InverseSmooth` stability lemma, and the integer-dimension-4
   version of `iteratedFDeriv R 4` pointwise bounds. These should be
   prepped as PRs once Cluster B stabilises.

**Downstream unlocks** (after Cluster B completes):
- SD a_2, a_4 non-trivial (Tarazed's 9 Cluster-A `Prop := True` sites
  in `ConnesSpectralAction.lean` + `SpectralActionExpansion.lean`).
- EBHPW kappa > 0 bounds globally -> non-trivial `ContinuumLimitRecoversEinstein`.
- Paper-publishable "Einstein equation holds <= delta_comp(N)".
- Cluster D (`HodgeStar.IsCoClosed0`) likely closes trivially once
  the operators are real.
- Full matter sector readiness: D_F eigenvalue machinery
  (Altair's Pathway 2) becomes numerically non-trivial.

---

## 9. Honest scoping / speculative claims

- **SPECULATIVE**: the exact kappa values for FRW / Bianchi I / de Sitter
  / Kerr regimes depend on the chosen interpolant's C^4 bound, which is
  not canonical. The "natural" choice (e.g., analytic continuation of
  the Schwarzschild exterior to all of R^4) gives a specific kappa; other
  interpolants give others. This is honest per Kurosh's paradox: the
  *existence* of some kappa > 0 is rigorous; its *numerical value* is
  interpolant-dependent.

- **SPECULATIVE**: whether `SmoothMetricFieldReal`'s `InverseSmooth`
  proof-obligation can be discharged at the v4.29 level without a
  committed normed-algebra instance on `Matrix (Fin 4) (Fin 4) R`.
  Mizar's comment in `SmoothMetric.lean:157-174` acknowledges this as
  deferred. Cluster B may need to discharge it per regime rather than
  carry it as hypothesis.

- **NOT SPECULATIVE**: every claim in sections 2-6 about the Mathlib
  v4.29 state and the existing OmegaTheory file layout is verified
  by grep / file-read / Mathlib docs. The architectural recommendation
  is a conservative read of the existing state.

- **NOT SPECULATIVE**: the 111 call-sites of opaque operators is an
  exact grep count on 10 files. The 7-regime file list is exact.
  The `_of_placeholders` discharger count is exact.

---

## Appendix A — bibliography

- **Mizar** (Apr 15), `Geometry/SmoothMetric.lean` — bundled
  `SmoothMetric` structure.
- **Mizar** (Apr 15), `Geometry/Christoffel.lean`,
  `Geometry/RiemannCurvature.lean`, `Geometry/RicciTensor.lean`,
  `Geometry/HarmonicGaugeContinuum.lean` — real continuum operators.
- **Fomalhaut** (Apr 15), `Geometry/RicciProperties.lean` —
  `ricciSymmetric_of_weinbergIdentity`, 11 theorems.
- **Achernar** (Apr 15), `Geometry/WeinbergLinearised.lean` —
  linearised gravity infrastructure.
- **Caph** (Apr 17), `Emergence/HpwSmoothMetricBridge.lean` —
  `HpwHypothesisStrict`, the parallel strict track.
- **Electra** (Apr 17), `Emergence/HpwHypothesis.lean` —
  `HarmonicGaugeIdentity` upgrade to real Prop (vs unconstrained
  Prop); `harmonicGaugeIdentity_of_placeholders`.
- **Alcyone** (Apr 17), `Emergence/HpwHypothesis.lean` —
  `TaylorRemainderBound` + `taylorRemainderBound_of_sharp` /
  `_of_laplacian_zero` / `_of_linearised` dischargers.
- **Maia** (Apr 17), `Emergence/HpwHypothesis.lean` —
  `WeinbergRicciBoxIdentity` + `weinbergRicciBoxIdentity_of_placeholders`.
- **Alioth** (Apr 17), `Emergence/Hpw*.lean` — 10
  `:= True` placeholders eliminated via dispatch through the new
  Alcyone/Maia/Electra dischargers.
- **Hamal** (Apr 17), `Geometry/ErrorBoundedSmooth.lean` — 7 regime
  EBHPW witnesses via `constEBHPW`.
- **Alphard** (Apr 17), `Geometry/ErrorBoundedSmooth.lean` — 5
  derived-operator approximation bounds (Group A).
- **Alpheratz** (Apr 17), `Geometry/ErrorBoundedSmooth.lean` — 2
  Group B Einstein-equation claims.
- **Arcturus** (Apr 15), `Foundations/TaylorBound.lean` —
  `central_diff_second_order_accurate` + `_axis` version. Needed
  by Cluster B regime witnesses for `TaylorRemainderBoundReal`.
- **Tarazed** (Apr 17), `NOTES_SEELEY_DEWITT_DESIGN.md` — 9
  Cluster-A sites blocked on heat kernel; benefit from kappa > 0.
- **Nashira** (Apr 17), `NOTES_MASS_DELTA_MAPPING.md` — proposed
  `g_perturbation` field; verified in section 5.
- **Altair** (Apr 17), `NOTES_DF_EIGENVALUES.md` — Pathway 1 blocker
  analysis.

## Appendix B — References consulted

- Mathlib v4.29 docs:
  [Mathlib.Analysis.Calculus.ContDiff.Defs](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Calculus/ContDiff/Defs.html)
  [Mathlib.Geometry.Manifold.Riemannian.Basic](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Geometry/Manifold/Riemannian/Basic.html)
  [Mathlib.Geometry.Manifold.VectorField.LieBracket](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Geometry/Manifold/VectorField/LieBracket.html)
- Wikipedia / Star-facts for Izar (epsilon Bootis) etymology:
  [Izar - Star Facts](https://www.star-facts.com/izar/)
  [Epsilon Bootis - Wikipedia](https://en.wikipedia.org/wiki/Epsilon_Bo%C3%B6tis)
- Vassilevich (2003) hep-th/0306138 §3.3 — Seeley-DeWitt coefficients.
- Chamseddine-Connes (1996) hep-th/9606001 — spectral action.
- HPW 2006 (Hildebrandt-Polthier-Wardetzky) — noted *not* the relevant
  analytic reference per Architect's 2026-04-14 note; the real content
  is (T)+(H)+(R) per Weinberg 1972 §11.1.

---

*Izar (epsilon Bootis), 2026-04-17. "The veil" — this memo pulls back
the veil on the `= 0` placeholders and designs the upgrade path that
preserves every Apr 17 victory while unlocking kappa > 0 everywhere.*
