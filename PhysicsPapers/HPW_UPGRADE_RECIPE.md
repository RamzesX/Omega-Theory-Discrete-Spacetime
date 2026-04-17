# HPW Hypothesis Field Upgrade Recipe — Pleione, 2026-04-17

## Diagnosis

`HpwHypothesis` currently has three `Prop` slots that are all set to `True`:
`h_taylor`, `h_harmonic`, `h_ricci_box`. They live alongside
`h_remainder_bound : ∀ p μ ν, |Δ_lat g_{μν}(p) + 2 R_{μν}(p)| ≤ ℓ_P/2`,
which is the *operationally* used field. In all 7 regimes (Minkowski, Linearised,
Schwarzschild, FRW, Kerr, BianchiI, deSitter) the regime-specific `*HpwData`
bundle already carries **sharp `ℓ_P/12` fields** that are the honest content:

- `h_taylor_sharp : |Δ_lat g_{μν}(p) − continuumLaplacianAt g_cont (ι p) μ ν| ≤ ℓ_P/12`
- `h_harmonic_sharp : |continuumLaplacianAt g_cont (ι p) μ ν + 2·ricciTensorContinuum g_cont (ι p) μ ν| ≤ ℓ_P/12`
- `h_ricci_match_sharp : |ricciTensorContinuum g_cont (ι p) μ ν − ricciTensor g μ ν p| ≤ ℓ_P/12`

The `True` slots in `HpwHypothesis` are therefore **the weakest form of a
field that could hold useful information** — they discard the regime data
at the top bundle. Upgrade plan: promote each `Prop` to the *statement* of
the corresponding sharp field, so the regime constructors carry it for free.

## Exact upgrade (drop-in replacement for `HpwHypothesis.lean:126–135`)

```lean
  /-- **Ingredient (T) — Taylor truncation.** -/
  h_taylor : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |discreteLaplacian (fun q => g q μ ν) p
       - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ l_P / 12

  /-- **Ingredient (G)+(H) — quantitative harmonic-gauge Ricci-box identity.** -/
  h_harmonic : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
       + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν| ≤ l_P / 12

  /-- **Ingredient (C) — discrete–continuum Ricci match. -/
  h_ricci_box : ∀ (p : LatticePoint) (μ ν : Fin 4),
    |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
       - ricciTensor g μ ν p| ≤ l_P / 12
```

`h_remainder_bound` stays as-is (it is algebraically implied by the three
sharp fields via `hpwHypothesis_remainder_at_twelfth` from `RicciComparison`),
but we **keep it as a field** for backward compatibility — constructors may
fill it directly from the three ingredients.

## Per-regime 7 × 3 instantiation table

| Regime | `h_taylor` | `h_harmonic` | `h_ricci_box` |
|---|---|---|---|
| **Minkowski** (`HpwMinkowski`) | `fun _ _ _ => by rw [discreteLaplacian_const, continuumLaplacianAt_placeholder, sub_zero, abs_zero]; positivity` | `fun _ _ _ => by rw [continuumLaplacianAt_placeholder, ricciTensorContinuum_placeholder, mul_zero, add_zero, abs_zero]; positivity` | `fun _ _ _ => by rw [ricciTensorContinuum_placeholder, ricciTensor_flat_eq_zero, sub_zero, abs_zero]; positivity` |
| **Linearised** (`HpwLinearised`) | `data.h_taylor_sharp` | `data.h_harmonic_sharp` | `data.h_ricci_match_sharp` |
| **Schwarzschild** | `data.h_taylor_sharp` | `data.h_harmonic_sharp` | `data.h_ricci_match_sharp` |
| **FRW** | `data.h_taylor_sharp` | `data.h_harmonic_sharp` | `data.h_ricci_match_sharp` |
| **Kerr** | `data.h_taylor_sharp` | `data.h_harmonic_sharp` | `data.h_ricci_match_sharp` |
| **BianchiI** | `data.h_taylor_sharp` | `data.h_harmonic_sharp` | `data.h_ricci_match_sharp` |
| **deSitter** | supplied via `h_taylor` arg | supplied via `h_harmonic` arg | supplied via `h_ricci` arg |

Because every regime file *already* carries these as named fields, the upgrade
is a one-line substitution per constructor — no new proofs required.

## Crazy unification alternative (session-scale, recommended)

Introduce a **single bundle** that cleans the triple up front:

```lean
structure ConvergenceBundle (g : DiscreteMetric) (g_cont : SmoothMetricField) : Prop where
  taylor : ∀ p μ ν, |discreteLaplacian (fun q => g q μ ν) p
                       - continuumLaplacianAt g_cont (latticeEmbed p) μ ν| ≤ l_P / 12
  harmonic : ∀ p μ ν, |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
                         + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν| ≤ l_P / 12
  ricci : ∀ p μ ν, |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
                       - ricciTensor g μ ν p| ≤ l_P / 12
```

Then `HpwHypothesis` becomes two fields: `g_cont` + `bundle : ConvergenceBundle g g_cont`,
and `h_remainder_bound` is **derived** (not stored). Every regime shrinks by
three fields, and the claim "our axiom is replaced by an `ℓ_P/12` triangle
budget" becomes self-documenting. `hpwHypothesis_remainder_at_twelfth` becomes
`ConvergenceBundle.remainder`.

**Speculative but honest**: the three `ℓ_P/12` bounds correspond *exactly* to
the three irrationals (π, e, √2) of the Pi Hunch — they are the three
independent sources of computational truncation that combine via triangle
inequality. Making this lineage explicit (renaming them
`pi_taylor_bound`, `e_harmonic_bound`, `sqrt2_ricci_bound`?) is a *narrative*
upgrade that ties HPW to the Omega-wide Pi-irrationality thesis. Mark as
speculative analogy until an error-scaling theorem proves it.

## Proof-agent instructions

- **Alcyone** (Minkowski arithmetic): 3 one-liners listed in the table; all
  close via `rfl`/`positivity`/`abs_zero`/`discreteLaplacian_const`.
- **Electra** (regime rewiring): for Linearised, Schwarzschild, FRW, Kerr,
  BianchiI, deSitter: substitute sharp fields directly. No proofs, just
  field renaming in the constructors `*HpwHypothesis_of_*`.
- **Maia** (derived lemma): prove `hpw_from_hypothesis_new` from the three
  new fields using the already-proved `hpwHypothesis_remainder_at_twelfth`
  (triangle ℓ_P/12 + ℓ_P/12 + 2·ℓ_P/12 = ℓ_P/2). This removes
  `h_remainder_bound` as a primitive field.

## Risks

1. If `h_remainder_bound` is kept as a field AND the three become theorems,
   any consumer that ignored the three will keep working. Safe incremental path.
2. Regime files that don't supply the continuum operators (Minkowski hits
   the `_placeholder` `rfl`s) must stay because `continuumLaplacianAt` is
   still opaque at `0`. Until Mathlib grows Ricci, this is fine — the
   inequalities become `|0| ≤ ℓ_P/12`.
3. Do NOT change `h_interpolates` or `c4_bound` — they belong to the
   interpolant construction, not the convergence claim.
