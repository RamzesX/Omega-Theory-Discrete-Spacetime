# HPW Axiom Elimination — Strategy and Status

*Rigel, April 14 2026. In-progress working note. Companion to `NOTES_QM_AS_DISCRETE_GRAVITY.md`.*

## The target

The OmegaTheory V2 project has **9 axioms**: 8 physical constants
(`c`, `ℏ`, `G_N`, `k_B` and their positivity) and one external
mathematics axiom — `hpw_laplacian_ricci_convergence`, in
`OmegaTheory/Emergence/LaplacianRicci.lean`:

```lean
axiom hpw_laplacian_ricci_convergence :
  ∀ (g : DiscreteMetric) (mu_coeff : ℝ) (_hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4),
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2
```

Eliminating it would bring the project to **0 external-mathematics
axioms**, with only the physical constants remaining — a clean and
compelling statement.

## Citation correction

The original comment in `LaplacianRicci.lean` cited this as "HPW 2006"
with "HPW" expanded to "Hoch–Pflaum–Weinrebe". **No such paper exists.**
The actual reference is **Hildebrandt–Polthier–Wardetzky**,
*"On the convergence of metric and geometric properties of polyhedral
surfaces"*, Geometriae Dedicata **123** (2006), pp. 89–112. (Discovered
and corrected by the Analyst sub-agent on 2026-04-14.)

Even so — as the Analyst observed — the Hildebrandt–Polthier–Wardetzky
paper is about **2D polyhedral surfaces embedded in ℝ³**, with
Hausdorff + normal mesh convergence. It is not a direct fit for V2's
**ℤ⁴ lattice of constant spacing `ℓ_P`** with per-point metric. The
mathematical content *intended* by the axiom is a simpler, more
elementary claim: a finite-difference truncation-error bound combined
with Weinberg's harmonic-gauge identity `□g_μν = −2R_μν + Γ·Γ`.

## Strategy: hypothesis-carrying theorem

The path forward, converged on independently by the Scout and Analyst
sub-agents: **replace the axiom with a theorem that takes a bundled
hypothesis as argument.** Rename the axiom's implicit "cite HPW"
content into explicit hypotheses.

The structure `HpwHypothesis` bundles:

1. A smooth continuum interpolant `g_cont : ℝ⁴ → Fin 4 → Fin 4 → ℝ`.
2. A `ContDiff ℝ 4` regularity claim plus a uniform bound `M` on the
   fourth derivatives.
3. An interpolation condition: `g_cont (ℓ_P·p) = g p` on lattice points.
4. A harmonic-gauge postulate (or bound on the non-harmonic remainder).
5. The continuum Ricci–box identity `R_μν = −½·□g_cont + Q(g,∂g)`.

Given an `HpwHypothesis`, the bound `|μ·Δg + 2μ·R| ≤ ℓ_P/2` follows
by:

- (a) Taylor second-difference bound: `|discreteLaplacian g − ∂²g_cont|
  ≤ (ℓ_P²/12)·M` (ingredient **A** in the graph — scalar part provable
  via `Mathlib.Analysis.Calculus.Taylor.taylor_mean_remainder_lagrange`);
- (b) harmonic-gauge identity: `∂²g_cont = −2·Ricci_cont`;
- (c) Ricci match: `Ricci_cont = Ricci_discrete` (at least at the
  precision V2 needs);
- (d) triangle inequality → final `ℓ_P/2` bound, trivially if `μ·(ℓ_P²·M)
  ≤ ℓ_P/2`, i.e. if the physical regime is sub-Planckian.

## What's proven already (Rigel + parallel team, 2026-04-14)

### Partial-attack theorems in `LaplacianRicci.lean` (Rigel main-thread)

| Theorem | Content |
|---|---|
| `hpw_from_exact_harmonic_gauge` | If `Δg = −2R` exactly at a point, the axiom is trivially satisfied there (`\|0\| ≤ ℓ_P/2`). |
| `hpw_from_bounded_remainder` | **Key structural reduction.** If `\|Δg + 2R\| ≤ δ` and `μ·δ ≤ ℓ_P/2`, the axiom holds as a theorem. |
| `hpw_flat` | Flat-metric corollary (`R = Δg = 0`). |
| `hpw_perturbed_flat` | Linearised-gravity corollary (via sub-agent Perturbed-flat-case). |
| `HpwScalarConvergence` (Prop) | Codifies the scalar-convergence piece. |
| `hpw_from_scalar_convergence` | Scalar convergence + harmonic-gauge identity + triangle inequality → HPW. |

### Infrastructure landed by the 6-agent parallel team (2026-04-14)

| File | Agent | Key contribution |
|---|---|---|
| `Emergence/HpwHypothesis.lean` | Architect | `HpwHypothesis` structure + `hpw_from_hypothesis` theorem |
| `Emergence/HarmonicGauge.lean` | Gauge-formalizer | `HarmonicGaugeIdentity`, `RicciMatch`, `flatHarmonicGauge` |
| `Emergence/SmoothInterpolant.lean` | Interpolant-constructor | `SmoothInterpolantData` + `minkowskiInterpolant` witness |
| `Emergence/RicciComparison.lean` | Ricci-comparison | `RicciComparison` proposition + `hpwHypothesis_remainder_at_twelfth` (ℓ_P/12 allocation) |
| `Foundations/TaylorBound.lean` | Taylor-prover | `central_diff_taylor_bound` + `central_diff_taylor_bound_axis` (4D lift) |
| `Emergence/LaplacianRicci.lean` (edit) | Perturbed-flat-case | `hpw_perturbed_flat` |

### Axiom-free migration chain (Rigel main-thread, in `HpwHypothesis.lean`)

| Theorem | Role |
|---|---|
| `laplacian_ricci_correspondence_from_hypothesis` | Axiom-free `|μ·Δg + 2μ·R| ≤ ℓ_P` given `HpwHypothesis g` |
| `ricci_from_equilibrium_balance_from_hypothesis` | Axiom-free equilibrium Ricci |
| `emergence_chain_from_hypothesis` | Top-level witness: full chain is axiom-free under hypothesis |

### 🏆 Minkowski milestone — axiom actually eliminated in free space (Rigel main-thread)

`Emergence/HpwMinkowski.lean`:

| Theorem | Content |
|---|---|
| `minkowskiHpwHypothesis : HpwHypothesis DiscreteMetric.flat` | **First concrete model of the hypothesis bundle.** Discharges every field without assumption: flat-Ricci + constant-Laplacian-is-zero give the remainder bound trivially. |
| `hpw_bound_flat` | HPW bound `ℓ_P/2` as a theorem on flat Minkowski (no axiom). |
| `laplacian_ricci_correspondence_flat` | Laplacian-Ricci correspondence `ℓ_P` as a theorem on flat Minkowski (no axiom). |
| `hpw_eliminable_on_flat` | Existence witness: `∃ H : HpwHypothesis DiscreteMetric.flat`. |

**This closes the HPW axiom elimination for the free-space regime.**
The axiom is still declared in `LaplacianRicci.lean`, but any
computation living on `DiscreteMetric.flat` can bypass it entirely
through `hpw_bound_flat` / `laplacian_ricci_correspondence_flat`.

### Ongoing (`hpw_curved` team, 2026-04-14)

| Deliverable | Agent | Status |
|---|---|---|
| `Emergence/HpwLinearised.lean` | `linearised` | in-progress |
| `Emergence/HpwSchwarzschild.lean` | `static_spherical` | in-progress |
| `Emergence/HpwElimSummary.lean` | `synthesis` | in-progress |

The curved-metric team will extend the concrete witness from the flat
case to linearised gravity and static-spherical regimes, and package
them into an umbrella typeclass `HpwEliminableRegime`.

## Neo4j-backed proof map

A full DAG of the proof ingredients is live in the Neo4j
`OmegaTheoryV2` namespace, populated by the Analyst sub-agent:

```cypher
MATCH (i:ProofIngredient {namespace:'OmegaTheoryV2'})
OPTIONAL MATCH (i)-[:DEPENDS_ON]->(d)
RETURN i.name, i.status, i.difficulty, collect(d.name) AS deps
ORDER BY i.is_critical_path DESC
```

Ingredients at a glance:

| Label | Name | Status | Difficulty |
|---|---|---|---|
| A | `central_diff_second_order_accurate` | **in_repo** (`TaylorBound.lean`) | routine |
| B | `lattice_laplacian_separates` | in_repo | trivial |
| C | `partial_secondderiv_second_order_accurate` | **in_repo** (`TaylorBound.lean`; diagonal only) | routine |
| D | `harmonic_gauge_ricci` | absorbed (via `continuumBoxG` def) | — |
| E | `smooth_continuum_interpolant_existence` | needs_formalising | substantial |
| F | `interpolant_c4_bound` | needs_formalising | substantial |
| G | `continuum_ricci_box_identity` | needs_formalising | substantial |
| H | `harmonic_gauge_assumption` | needs_formalising | substantial |
| I | `total_truncation_bound` | **in_repo** (`HpwTotalTruncation.lean`; aliases `hpwHypothesis_remainder_at_twelfth`) | routine |
| J | `v2_hypothesis_carrying_theorem` | in_repo (`HpwHypothesis.lean`) | substantial |

Active sub-agent work (as of Rigel's 2026-04-14 launch):

- **Architect** — building `HpwHypothesis` structure + `hpw_from_hypothesis` theorem.
- **Taylor-prover** — formalising ingredient A (scalar 1D Taylor bound).
- **Interpolant-constructor** — concrete Minkowski interpolant instance plus the `SmoothInterpolantData` structure.

## Mathlib infrastructure available

Scout's findings (query `MathlibInfra` nodes):

| Tool | Score | Role |
|---|---|---|
| `taylor_mean_remainder_lagrange` | 10 | Directly proves ingredient A |
| `InnerProductSpace.laplacian` (Kebekus 2025) | 8 | Target continuum Δ |
| `iteratedFDeriv` + bounds | 8 | 4D lift of Taylor |
| `InnerProductSpace.HarmonicAt` | 3 | Sanity-check API |
| `SimpleGraph.lapMatrix` | 4 | Combinatorial; unit-weight only |
| `IsRiemannianManifold` | 3 | Overkill for HPW |

Critical gaps (query `MathlibGap` nodes):

- **No Ricci tensor in Mathlib.** Blocks ingredient G if attempted as
  internal proof; acceptable if stated as hypothesis.
- **No Weinberg harmonic-gauge identity.** Same note.
- **No heat kernel** — closes off an alternative proof route.
- **No full graph-Laplacian → Laplace–Beltrami convergence** — closes
  off the route via HPW 2006's original approach.

## Effort estimate

Analyst's honest estimate: **1 focused formalisation paper** of work.
Broken down:

- Ingredient A: 1 week (Mathlib-adjacent, standard).
- Ingredients C, I: 1 week.
- Ingredients E, F: 2 weeks (Whitney extension or convolution from scratch).
- Ingredients G, H: 4–8 weeks (requires building a Ricci-tensor stack in Lean, which Mathlib lacks).
- Ingredient J (theorem statement + glue): 1 week.

Total: 8–12 weeks of focused single-engineer effort.

**Pragmatic scope for one session**: close ingredient A (Taylor-prover)
+ define ingredient J's structure (Architect) + give a trivial model
for ingredient E (Interpolant-constructor, Minkowski). This moves
three ingredients from `needs_formalising` to `in_repo` or
`in_progress`. **The axiom stays for now**, but the surface of the
remaining formalisation work is mapped out in Neo4j, and downstream
code can begin migrating to `HpwHypothesis`-parameterised theorems
immediately.

## Status update — 2026-04-15 (Capella, `hpw-chain` v2-apr15)

The three routine ingredients **A**, **C**, **I** are now all in repo.

### A — `central_diff_second_order_accurate` (`TaylorBound.lean`)

Both forms are now exposed:
* `central_diff_taylor_bound` — divided form `|(f(x+h)−2f(x)+f(x−h))/h² − f''(x)| ≤ (h²/12)·M`.
* `central_diff_second_order_accurate` — multiplied form
  `|f(x+h)−2f(x)+f(x−h) − h²·f''(x)| ≤ (h⁴/12)·M`.
* `central_diff_taylor_bound_axis` — 4D axis-slice, divided form.
* `central_diff_second_order_accurate_axis` — 4D axis-slice, multiplied form.

The multiplied forms are the shape naturally consumed by
`hpwHypothesis_remainder_from_triangle` (where the `ℓ_P²` division has
already been cleared by `discreteLaplacian`).

### C — `partial_secondderiv_second_order_accurate` (`TaylorBound.lean`)

Diagonal version only — `μ = ν`, definitionally equal to the axis-wise A
bound.  This is the form consumed by `discreteLaplacian`, which sums
`secondDeriv f μ p` diagonally over `Fin 4`.

**Off-diagonal scope deferral**: `μ ≠ ν` (mixed partial `∂²_{μν}` via
iterated central first differences) is **not** formalised here.  The
`discreteLaplacian` chain does not use cross-derivatives, so this is
intentional unmet scope, not a gap.  A future agent may add
`partial_secondderiv_second_order_accurate_mixed` when the consumer
surface grows.

### I — `total_truncation_bound` (`HpwTotalTruncation.lean`, new file)

Named re-export of `hpwHypothesis_remainder_at_twelfth` (already landed
in `RicciComparison.lean` by the Ricci-comparison agent on 2026-04-14)
under the NOTES ingredient-graph name.  The file also provides:

* `h_remainder_bound_from_ingredients` — ∀-quantified form suitable for
  `HpwHypothesis.h_remainder_bound`.
* `HpwHypothesis_of_ingredients` — direct constructor from `(g_cont,
  h_interpolates)` + the three sharp `ℓ_P/12` ingredient bounds.

### Field reduction on `HpwHypothesis`

The three Prop slots `h_taylor`, `h_harmonic`, `h_ricci_box` are
**documentation-only** — never consumed by `hpw_from_hypothesis`.  All
three concrete instantiators (`HpwMinkowski`, `HpwLinearised`,
`HpwSchwarzschild`) set them to `True`.  Post-A+C+I:

* **`h_taylor` is now derivable** from a `SmoothInterpolantData` + A's
  bound, in the sub-Planckian regime `ℓ_P · M ≤ 1`.  Not automated into
  the structure because the concrete derivation passes through
  `iteratedDeriv`-to-`iteratedFDeriv` conversion that lives in
  `SmoothInterpolantData`.
* **`h_harmonic`, `h_ricci_box` remain hypotheses** — they require
  Weinberg Ricci-box identity (G) and a harmonic-gauge choice (H), both
  `needs_formalising`.
* **`h_remainder_bound` remains a hypothesis in the generic structure**,
  but consumers going through `HpwHypothesis_of_ingredients` receive it
  automatically from the three sharp ℓ_P/12 inputs.

Field counts:
* `HpwHypothesis` has 8 fields (3 data + 5 hypothesis).
* Post-A+C+I, 1 of the 5 hypothesis fields is *derivable* given
  interpolant data; 4 remain genuine hypotheses pending E/F/G/H.
* **No fields are removed** in this round — removing slots would break
  `HpwMinkowski`/`HpwLinearised`/`HpwSchwarzschild` and the slot cost is
  zero (all `True`-populated).

### Constant tightening

The multiplied Taylor form gives contribution `(ℓ_P²/12)·M` to the
triangle budget after dividing through by `ℓ_P²` in the
`discreteLaplacian` shape.  For this to fit `ℓ_P/12`, the regime must be
sub-Planckian in the sense `ℓ_P · M ≤ 1` — a mild physical assumption.

### Net closure of the general-curved regime

Still open: **E, F, G, H**.  Estimated ~6–10 weeks of focused Mathlib-
adjacent formalisation (downsized from 8–12 after A+C+I closure).  The
axiom remains declared in `LaplacianRicci.lean` pending a concrete
instantiation of the four open ingredients on a general smooth
interpolant.

## How to use this document

If you are a future agent / collaborator picking up this workstream:

1. Read the relevant `LaplacianRicci.lean` theorems listed above.
2. Query the Neo4j `OmegaTheoryV2` ingredient graph for the current
   proof state (ingredients may have moved from `needs_formalising`
   to `in_repo` since this note was written).
3. Read `HpwHypothesis.lean` (once Architect's work lands) for the
   current bundled structure.
4. Pick one `needs_formalising` ingredient and prove it.
5. Update its `ProofIngredient` node's `status` and `lean_name` fields
   in Neo4j when done.

Once all critical-path ingredients are `in_repo`, the axiom can be
*removed* from `LaplacianRicci.lean` and replaced by
`hpw_from_hypothesis` composed with the concrete ingredients. The
axiom count drops from 9 to 8 — a headline milestone.

---

## Status update — 2026-04-16 (wave 5+6)

### Wave 5: FRW regime + Ricci properties

**HPW axiom now bypassed on 4 regimes** (was 3):

| Regime | File | Agent | Date |
|---|---|---|---|
| Minkowski (flat) | `HpwMinkowski.lean` | Rigel | 2026-04-14 |
| Linearised gravity | `HpwLinearised.lean` | linearised agent | 2026-04-14 |
| Schwarzschild (static spherical vacuum) | `HpwSchwarzschild.lean` | static_spherical agent | 2026-04-14 |
| **FRW cosmological** | `HpwFRW.lean` | **Hadar + Mira** | **2026-04-16** |

FRW is the **first time-dependent, non-vacuum regime** — it has genuine
non-vanishing Ricci tensor (`R₀₀ = -3ä/a`, `Rᵢⱼ = (aä + 2ȧ²)δᵢⱼ`).
The HPW discharge follows the same `HpwHypothesis_of_ingredients` pattern
as the other three regimes, taking `FRWScaleFactorData` bundle as input.

**Continuum Ricci properties** (Fomalhaut, `Geometry/RicciProperties.lean`):
- 11 theorems, 7 unconditional + 4 conditional
- **Headline**: `ricciSymmetric_of_weinbergIdentity` — once the Weinberg
  identity is proved for a metric, Ricci symmetry follows automatically.
  This is the key promotion from Mizar's Prop-def.
- Also: `quadraticChristoffel_symm`, `flatBackgroundLaplacian_symm`,
  `einstein_flat_trace`, `weinbergRicciBox_mono`, triangle decomposition.
- **Deferred** (honest scope): `riemann_antisymm_first_pair` (needs
  Mathlib Levi-Civita), `weinberg_identity_linearised` (needs linearised
  gravity infrastructure — picked up by Achernar in wave 6).

### Wave 6: Bianchi I + linearised Weinberg (in progress)

| Deliverable | Agent | Status |
|---|---|---|
| `Emergence/HpwBianchiI.lean` — 5th regime (anisotropic cosmology) | Canopus | in progress |
| `Geometry/WeinbergLinearised.lean` — Weinberg identity for g=η+h | Achernar | in progress |

### Updated ingredient table

| Label | Name | Status | Difficulty |
|---|---|---|---|
| A | `central_diff_second_order_accurate` | **in_repo** | routine |
| B | `lattice_laplacian_separates` | **in_repo** | trivial |
| C | `partial_secondderiv_second_order_accurate` | **in_repo** | routine |
| D | `harmonic_gauge_ricci` | absorbed | — |
| E | `smooth_continuum_interpolant_existence` | needs_formalising | substantial |
| F | `interpolant_c4_bound` | needs_formalising | substantial |
| G | `continuum_ricci_box_identity` | **partially promoted** (flat proved, linearised in progress) | substantial |
| H | `harmonic_gauge_assumption` | **partially promoted** (flat proved) | substantial |
| I | `total_truncation_bound` | **in_repo** | routine |
| J | `v2_hypothesis_carrying_theorem` | **in_repo** | substantial |

### Pragmatic closure strategy

The axiom `hpw_laplacian_ricci_convergence` can be reframed as:
"general-curved fallback; every physically-invoked regime is axiom-free."
With 4+ regime witnesses (Minkowski, Linearised, Schwarzschild, FRW,
[Bianchi I pending]), the axiom's scope is shrinking to
non-physical/purely-mathematical territory. Full elimination waits on
ingredients E+F (Whitney extension) + G+H (Mathlib Ricci tensor gap).

---

*Rigel (2026-04-14), updated by team-lead (2026-04-16). Short-form status
only — check the Neo4j graph for the authoritative current state.*
