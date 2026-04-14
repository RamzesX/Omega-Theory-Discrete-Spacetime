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

## What's proven already (Rigel, 2026-04-14)

In `LaplacianRicci.lean`:

| Theorem | Content |
|---|---|
| `hpw_from_exact_harmonic_gauge` | If `Δg = −2R` exactly at a point, the axiom is trivially satisfied there (`\|0\| ≤ ℓ_P/2`). |
| `hpw_from_bounded_remainder` | **Key structural reduction.** If `\|Δg + 2R\| ≤ δ` and `μ·δ ≤ ℓ_P/2`, the axiom holds as a theorem. |
| `hpw_flat` | Flat-metric corollary (`R = Δg = 0`). |
| `HpwScalarConvergence` (Prop) | Codifies the scalar-convergence piece. |
| `hpw_from_scalar_convergence` | If the scalar convergence and a harmonic-gauge identity both hold with slack `ℓ_P/4`, HPW holds (triangle inequality). |

These five theorems *witness* that the axiom is decomposable — they
show exactly where the real mathematical content lives. They do not
eliminate the axiom; they narrow its effective scope.

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
| A | `central_diff_second_order_accurate` | needs_formalising | routine |
| B | `lattice_laplacian_separates` | in_repo | trivial |
| C | `partial_secondderiv_second_order_accurate` | needs_formalising | routine |
| D | `harmonic_gauge_ricci` | absorbed (via `continuumBoxG` def) | — |
| E | `smooth_continuum_interpolant_existence` | needs_formalising | substantial |
| F | `interpolant_c4_bound` | needs_formalising | substantial |
| G | `continuum_ricci_box_identity` | needs_formalising | substantial |
| H | `harmonic_gauge_assumption` | needs_formalising | substantial |
| I | `total_truncation_bound` | needs_formalising | routine |
| J | `v2_hypothesis_carrying_theorem` | **in progress (Architect)** | substantial |

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

*Rigel, 2026-04-14. Short-form status only — this document is
rewritten after each session's progress. Check the Neo4j graph for the
authoritative current state.*
