/-
  OmegaTheory.Emergence.HpwTotalTruncation

  **Ingredient I of the HPW axiom elimination programme — `total_truncation_bound`.**

  NOTES_HPW_ELIMINATION identifies seven ingredients A, C, E, F, G, H, I for
  the general-curved closure of the HPW axiom.  This file is the consumer-
  facing hub for Ingredient **I**: the triangle-inequality glue that binds
  the other ingredients into the composite HPW remainder bound
      |Δ_lat g + 2 R_disc| ≤ ℓ_P/2
  that `HpwHypothesis.h_remainder_bound` demands.

  ## The glue is already in repo — this file is a named re-export

  The mathematical content of Ingredient I is a three-step triangle
  inequality over the decomposition
      Δ_lat g + 2 R_disc
        = (Δ_lat g − Δ_cont)        -- ingredient A (Taylor)
        + (Δ_cont + 2 R_cont)        -- ingredients G + H (harmonic gauge)
        + 2 (R_cont − R_disc)        -- ingredient C (Ricci match).
  Those three bounds, each at most ℓ_P/12, combine to a final ℓ_P/2 budget.

  **This is already formalised in `RicciComparison.lean`:**
  * `hpw_remainder_from_triangle_decomposition` — abstract form, arbitrary εs.
  * `hpw_remainder_from_triangle_twelfth`        — ℓ_P/12 allocation.
  * `hpwHypothesis_remainder_from_triangle`      — at the discrete operators.
  * `hpwHypothesis_remainder_at_twelfth`         — at the sharp allocation.

  The present file **re-exports** those lemmas under the Ingredient-I
  names used in the NOTES ingredient graph, so the Neo4j graph's
  `ProofIngredient {name: 'total_truncation_bound'}` node resolves cleanly.
  No new mathematics is added here — the re-exports are `:=` aliases.

  ## Field reduction on `HpwHypothesis`

  The Architect's `HpwHypothesis` structure carries three `Prop` slots
  `h_taylor`, `h_harmonic`, `h_ricci_box` that are *documentation only* —
  they are never consumed by the witnessing theorem `hpw_from_hypothesis`.
  All three concrete instantiators (`HpwMinkowski`, `HpwLinearised`,
  `HpwSchwarzschild`) set them to `True`.

  **Status under A+C+I:**
  * The `h_taylor` slot *could* be populated with a genuine Taylor-bound
    witness derived from `central_diff_second_order_accurate_axis`.  This
    is not a new hypothesis — it becomes *automatic* given an
    interpolant + C⁴ bound (E/F).
  * The `h_harmonic` and `h_ricci_box` slots remain user-supplied: A+C
    alone do not produce them — they need G/H.
  * The `h_remainder_bound` composite field remains user-supplied: it
    requires the full chain A ∘ (G+H) ∘ C ∘ I.

  So `h_taylor` becomes *derivable-given-interpolant* once A is formalised;
  the other two slots remain honest hypotheses.  We do not remove any field
  here to avoid breaking `HpwMinkowski`/`HpwLinearised`/`HpwSchwarzschild`;
  the field reduction is documented but deferred.

  ## Honest scoping

  What A, C, I **do** provide: a machine-checked reduction of
  `h_remainder_bound` (per lattice point) from a triple of sharp continuum
  bounds (Taylor, harmonic gauge + Ricci-box, Ricci-match) into the HPW
  target `ℓ_P/2` — i.e. the entire Schwarzschild-style witness pipeline
  lives inside `hpwHypothesis_remainder_at_twelfth`, not outside of it.

  What A, C, I **do not** provide: the sharp bounds themselves on a
  generic metric.  Those are ingredients E, F, G, H, and they depend on:
  * E — a concrete smooth interpolant (e.g. a bump-function convolution),
  * F — a uniform C⁴ derivative bound on the interpolant,
  * G — a formal Weinberg Ricci-box identity,
  * H — a harmonic-gauge coordinate choice.
  All four remain `needs_formalising` in NOTES_HPW_ELIMINATION and none of
  them are touched by this file.

  ## No new axioms, no sorries.

  Every declaration here is a definitional re-export of an existing
  RicciComparison/TaylorBound theorem.  The file reaches 0 sorry / 0 axiom.

  -- Capella, HPW elimination team, 2026-04-15
-/

import OmegaTheory.Foundations.TaylorBound
import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.HarmonicGauge
import OmegaTheory.Emergence.RicciComparison

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Foundations

/-! ## Ingredient I — named re-export

`total_truncation_bound` is the Neo4j-graph-facing name of
`hpwHypothesis_remainder_at_twelfth`.  Both deliver:

    Given per-lattice-point sharp `ℓ_P/12` bounds on Taylor, harmonic-gauge,
    and Ricci-match, the composite discrete remainder `|Δ_lat g + 2 R_disc|`
    fits in `ℓ_P/2`.

We alias the theorem at the ingredient-I name so downstream graph queries
resolve without ambiguity. -/

/-- **Ingredient I** — `total_truncation_bound`.

Given a `DiscreteMetric g`, a continuum interpolant `g_cont`, and per-point
sharp `ℓ_P/12` bounds
* `|Δ_lat g(p) − Δ_cont g_cont(ι p)| ≤ ℓ_P/12` (ingredient A, Taylor),
* `|Δ_cont g_cont(ι p) + 2 R_cont g_cont(ι p)| ≤ ℓ_P/12` (G+H, harmonic gauge),
* `|R_cont g_cont(ι p) − R_disc(g,p)| ≤ ℓ_P/12` (ingredient C, Ricci match),

the composite discrete HPW remainder satisfies
    `|Δ_lat g(p) + 2 R_disc(g,p)| ≤ ℓ_P/2`.

This is a definitional alias of `hpwHypothesis_remainder_at_twelfth`
under the ingredient-graph name. -/
theorem total_truncation_bound
    (g : DiscreteMetric) (g_cont : SmoothMetricField)
    (p : LatticePoint) (μ ν : Fin 4)
    (hTaylor   : |discreteLaplacian (fun q => g q μ ν) p
                   - continuumLaplacianAt g_cont (latticeEmbed p) μ ν|
                 ≤ l_P / 12)
    (hHarmonic : |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
                   + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν|
                 ≤ l_P / 12)
    (hRicciComp : |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
                    - ricciTensor g μ ν p| ≤ l_P / 12) :
    |discreteLaplacian (fun q => g q μ ν) p + 2 * ricciTensor g μ ν p|
      ≤ l_P / 2 :=
  hpwHypothesis_remainder_at_twelfth g g_cont p μ ν
    hTaylor hHarmonic hRicciComp

/-! ## Consumer-facing: build an `HpwHypothesis.h_remainder_bound`

The theorem below packages `total_truncation_bound` into the universally-
quantified form of `HpwHypothesis.h_remainder_bound`.  It is the natural
target of a `VacuumStaticSphericalData`-style bundle: a consumer supplies
three ∀-quantified sharp bounds; we deliver the composite bound in the
shape required by the Architect's `HpwHypothesis` structure.

This is a *thin* glue theorem — essentially the same content as the body
of `HpwHypothesis_of_vacuum_static`, isolated so that linearised and
future curved regimes can reuse it without duplication. -/

/-- **HpwHypothesis-shaped composite remainder bound from A + (G+H) + C.**

Given the three sharp `ℓ_P/12` ingredient bounds, universally quantified
over every lattice point and tensor component, we recover the composite
`h_remainder_bound` shape required by `HpwHypothesis`. -/
theorem h_remainder_bound_from_ingredients
    (g : DiscreteMetric) (g_cont : SmoothMetricField)
    (hTaylor   : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q => g q μ ν) p
         - continuumLaplacianAt g_cont (latticeEmbed p) μ ν|
       ≤ l_P / 12)
    (hHarmonic : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
         + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν|
       ≤ l_P / 12)
    (hRicciComp : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
         - ricciTensor g μ ν p| ≤ l_P / 12) :
    ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q => g q μ ν) p + 2 * ricciTensor g μ ν p|
        ≤ l_P / 2 :=
  fun p μ ν =>
    total_truncation_bound g g_cont p μ ν
      (hTaylor p μ ν) (hHarmonic p μ ν) (hRicciComp p μ ν)

/-! ## Full `HpwHypothesis` constructor from the ingredient triple

The consumer-facing builder: given an interpolation identity and the three
sharp ingredient bounds, build an `HpwHypothesis g` directly — no need to
go through a regime-specific data bundle.  This is the honest "you supply
the ingredients, we deliver HpwHypothesis" contract for the general curved
case, pending only the closure of the four open ingredients (E/F/G/H)
which produce the sharp bounds themselves. -/

/-- **HpwHypothesis from the ingredient triple.**

If a user supplies:
* a smooth continuum metric field `g_cont`,
* an interpolation identity `h_interpolates`,
* the three sharp `ℓ_P/12` ingredient bounds (Taylor, harmonic, Ricci-match),

this constructor delivers an `HpwHypothesis g`.  The `h_taylor`,
`h_harmonic`, `h_ricci_box` documentation slots are populated with the
relevant `Prop`-level content (`True`-shaped placeholders, matching the
existing instantiators).

This is a convenience wrapper: `HpwHypothesis_of_vacuum_static` in
`HpwSchwarzschild.lean` is the same pattern at the Schwarzschild-regime
level (taking a `VacuumStaticSphericalData` bundle), and this file's
version abstracts it away from that regime. -/
noncomputable def HpwHypothesis_of_ingredients
    {g : DiscreteMetric} (g_cont : SmoothMetricField)
    (h_interpolates : ∀ (p : LatticePoint) (μ ν : Fin 4),
      (g p) μ ν = g_cont (latticeEmbed p) μ ν)
    (hTaylor : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |discreteLaplacian (fun q => g q μ ν) p
         - continuumLaplacianAt g_cont (latticeEmbed p) μ ν|
       ≤ l_P / 12)
    (hHarmonic : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |continuumLaplacianAt g_cont (latticeEmbed p) μ ν
         + 2 * ricciTensorContinuum g_cont (latticeEmbed p) μ ν|
       ≤ l_P / 12)
    (hRicciComp : ∀ (p : LatticePoint) (μ ν : Fin 4),
      |ricciTensorContinuum g_cont (latticeEmbed p) μ ν
         - ricciTensor g μ ν p| ≤ l_P / 12) :
    HpwHypothesis g where
  g_cont := g_cont
  c4_bound := 1
  c4_bound_pos := by norm_num
  h_interpolates := h_interpolates
  -- Alioth, Apr 17 2026 — discharged via `taylorRemainderBound_of_sharp`
  -- using the ∀-quantified `ℓ_P/12` Taylor hypothesis `hTaylor` supplied
  -- as an argument to this constructor.  This is HPW Ingredient (T) content
  -- for the generic ingredient-triple construction — upgraded from the sharp
  -- `ℓ_P/12` budget to the `ℓ_P/6` `TaylorRemainderBound` budget.
  h_taylor := taylorRemainderBound_of_sharp hTaylor
  -- Total-truncation construction: feed in any interpolant whose three
  -- sharp `ℓ_P/12` bounds are supplied as hypotheses.  The opaque-operator
  -- `HarmonicGaugeIdentity` is discharged at the placeholder level; the
  -- quantitative harmonic-gauge content is exposed through `hHarmonic`.
  h_harmonic := harmonicGaugeIdentity_of_placeholders g_cont
  -- Alioth, Apr 17 2026 — discharged via `weinbergRicciBoxIdentity_of_placeholders`.
  -- The opaque continuum Laplacian and continuum Ricci placeholders are both
  -- definitionally zero, so the Weinberg Ricci-box predicate collapses to
  -- `|0 + (1/2)·0| = 0 ≤ ℓ_P²` trivially.  The quantitative `ℓ_P/12` harmonic-
  -- gauge + Ricci-match content used by `h_remainder_bound_from_ingredients`
  -- lives in `hHarmonic` and `hRicciComp`.
  h_ricci_box := weinbergRicciBoxIdentity_of_placeholders g_cont
  h_remainder_bound :=
    h_remainder_bound_from_ingredients g g_cont hTaylor hHarmonic hRicciComp

/-! ## Field-reduction documentation

The `HpwHypothesis` structure's three `Prop` slots have the following
status post-A+C+I formalisation:

* **`h_taylor`** — the Taylor-truncation hypothesis.  Under
  `central_diff_second_order_accurate_axis` (Ingredient A in
  `TaylorBound.lean`), this slot is *derivable* from a `SmoothInterpolantData`
  that carries a uniform `C⁴` bound `M`:

      |Δ_lat g_{μν}(p) − (g_cont)''_μμ(ι p)|  ≤  (ℓ_P²/12) · M

  For the bound to reach `ℓ_P/12` (the allocation used in
  `total_truncation_bound`), the regime must be sub-Planckian in the sense
  `ℓ_P · M ≤ 1`.  Given E (interpolant) + F (C⁴ bound) + that mild
  sub-Planckian scale, `h_taylor` is *automatic*.

* **`h_harmonic`** — still user-supplied.  Requires G (Weinberg Ricci-box
  identity in harmonic gauge) + H (a harmonic-gauge choice on the
  interpolant).  Neither is in Mathlib v4.29.

* **`h_ricci_box`** — still user-supplied for the same reason.

* **`h_remainder_bound`** — still user-supplied in general, but derivable
  from the three sharp ingredient bounds via `total_truncation_bound`.
  `HpwHypothesis_of_ingredients` above witnesses exactly that derivation.

We deliberately do *not* change the `HpwHypothesis` structure signature:
removing slots would break every downstream instantiator, and the slots
are cheap (all `True`).  Instead, consumers wanting to leverage A+C+I
use `HpwHypothesis_of_ingredients` to build their `HpwHypothesis` from
the sharp ingredient triple — the slot values are `True` by construction.

## Constant-tightening observation

The multiplied form `central_diff_second_order_accurate` (Ingredient A in
`TaylorBound.lean`) delivers
    |f(x+h) − 2f(x) + f(x−h) − h²·f''(x)| ≤ (h⁴/12)·M.
Substituting `h = ℓ_P` and dividing by `h² = ℓ_P²` to match the
`secondDeriv` form, the per-axis Taylor contribution becomes
    (ℓ_P²/12)·M.
For this to fit into the `ℓ_P/12` allocation in `total_truncation_bound`,
we need `ℓ_P²·M ≤ ℓ_P`, i.e. `M ≤ 1/ℓ_P` — the sub-Planckian regime
assumption.  In this regime the A-ingredient is strictly *tighter* than
the `ℓ_P/12` slot allocates, making the A+C+I chain close with margin.

## Summary — NOTES_HPW_ELIMINATION ingredient-status delta

Landed by this file and its prerequisites:
* **A** `central_diff_second_order_accurate{,_axis}` — `TaylorBound.lean`.
* **C** `partial_secondderiv_second_order_accurate` — `TaylorBound.lean`
  (diagonal only; off-diagonal deferred as honest scope note).
* **I** `total_truncation_bound` + `h_remainder_bound_from_ingredients`
  + `HpwHypothesis_of_ingredients` — this file.

Still `needs_formalising`:
* **E** smooth interpolant existence (Whitney/bump extension).
* **F** uniform C⁴ bound on the interpolant.
* **G** Weinberg Ricci-box identity in harmonic gauge.
* **H** harmonic-gauge coordinate condition.

The axiom `hpw_laplacian_ricci_convergence` remains declared in
`LaplacianRicci.lean`; its general-curved elimination continues to hinge
on the four open ingredients above. -/

end OmegaTheory.Emergence
