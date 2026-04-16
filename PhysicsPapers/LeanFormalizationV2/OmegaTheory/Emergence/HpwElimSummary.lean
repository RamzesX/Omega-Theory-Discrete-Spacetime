/-
  OmegaTheory.Emergence.HpwElimSummary

  **Umbrella elimination file — consolidating all concrete `HpwHypothesis`
  instances.**  *synthesis, 2026-04-14.*

  This file is the single point of truth for the HPW axiom elimination
  programme.  It enumerates the regimes on which the external-mathematics
  axiom `hpw_laplacian_ricci_convergence` is provably *redundant*, dispatches
  through a typeclass to deliver the axiom's conclusion as a theorem, and
  documents which regimes remain open.

  ## Regimes closed

  | Regime | Data | Witness | Source file |
  |---|---|---|---|
  | `flat` (Minkowski) | — | `minkowskiHpwHypothesis` | `HpwMinkowski.lean` |
  | `linearised` (`g = η + ε·h`, `3εK ≤ ℓ_P/2`) | `LinearisedMetricData g` | `linearisedHpwHypothesis` | `HpwLinearised.lean` |
  | `staticSpherical` (vacuum `R^cont_{μν}=0`, e.g. Schwarzschild exterior) | `VacuumStaticSphericalData g` | `staticSphericalHpwHypothesis` | `HpwSchwarzschild.lean` |
  | `frw` (FRW cosmological, non-zero Ricci, time-dependent `a(t)`) | `FRWHpwData g` | `frwHpwHypothesis` | `HpwFRW.lean` |
  | `bianchiI` (Bianchi I anisotropic, three independent scale factors `a₁(t), a₂(t), a₃(t)`) | `BianchiIHpwData g` | `bianchiIHpwHypothesis` | `HpwBianchiI.lean` |

  ## Regime left open

  * **General curved spacetime** — a generic `DiscreteMetric g` without
    symmetry, smallness, or vacuum hypothesis.  Closing this eliminates the
    axiom entirely; it requires ingredients A, C, E, F, G, H, I of
    `NOTES_HPW_ELIMINATION.md` (smooth continuum interpolant existence,
    uniform 4th-derivative bound, harmonic-gauge identity, Weinberg
    Ricci-box identity, Taylor second-difference bound, triangle-inequality
    glue).  Estimated ~8–12 weeks of focused Mathlib-adjacent formalisation.

  ## Umbrella theorem

  `hpw_axiom_eliminable` (below) delivers the axiom's conclusion
  `|mu·Δg + 2μ·R| ≤ ℓ_P/2` for any `g : DiscreteMetric` that is marked
  as `HpwEliminableRegime`.  It dispatches through the typeclass to
  whichever witness is available for the regime — Minkowski, linearised,
  or static-spherical — **without invoking the axiom**.

  This file is intended to be the single import point for downstream code
  that wants axiom-free HPW bounds: import this file, provide an
  `HpwEliminableRegime g` instance, and the bound is yours.
-/

import OmegaTheory.Emergence.HpwHypothesis
import OmegaTheory.Emergence.HpwMinkowski
import OmegaTheory.Emergence.HpwLinearised
import OmegaTheory.Emergence.HpwSchwarzschild
import OmegaTheory.Emergence.HpwFRW
import OmegaTheory.Emergence.HpwBianchiI

namespace OmegaTheory.Emergence

open OmegaTheory.Spacetime
open OmegaTheory.Geometry

/-! ## The regime typeclass

`HpwEliminableRegime g` is a typeclass indexed by a `DiscreteMetric g`.
Instances certify that `g` falls into one of the closed regimes of the
HPW elimination programme, and carry the witnessing `HpwHypothesis g`
as a field.

The typeclass is single-field: the content of being "eliminable" is
exactly the existence of an explicit `HpwHypothesis` bundle.  The three
closed regimes (flat, linearised, static-spherical) differ only in which
*witness construction* they use — they all feed into the same conclusion.

We deliberately make the witness a class field rather than an inductive
classifier: this makes `[HpwEliminableRegime g]` unifier-friendly and
avoids pattern-matching on a case constructor at the meta-level.  The
regime classification is documented textually on each instance. -/

/-- **Typeclass marker for HPW-eliminable regimes.**

    An instance `[HpwEliminableRegime g]` asserts that the discrete metric
    `g` falls in a regime where the HPW axiom is replaceable by a concrete
    `HpwHypothesis`.  The witness is carried as the `toHpw` field. -/
class HpwEliminableRegime (g : DiscreteMetric) : Type where
  /-- The concrete HPW-hypothesis witness for this regime. -/
  toHpw : HpwHypothesis g

/-! ## Regime-constructor aliases

Each closed regime has a dedicated constructor turning its regime-specific
data into an `HpwEliminableRegime` instance.  Users pick the constructor
matching their regime and (when required) supply the regime's bundled data. -/

/-- **Flat regime constructor.**  Free-space lattice: `DiscreteMetric.flat`
    is HPW-eliminable through `minkowskiHpwHypothesis`. -/
noncomputable def HpwEliminableRegime.ofFlat :
    HpwEliminableRegime DiscreteMetric.flat where
  toHpw := minkowskiHpwHypothesis

/-- **Linearised regime constructor.**  Weak-field `g = η + ε·h` with
    pointwise bounds `|Δ_lat g| ≤ εK`, `|R| ≤ εK`, and scale hypothesis
    `3·ε·K ≤ ℓ_P/2`.  Dispatches through `linearisedHpwHypothesis`. -/
noncomputable def HpwEliminableRegime.ofLinearised
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2) :
    HpwEliminableRegime g where
  toHpw := linearisedHpwHypothesis D h_scale

/-- **Static-spherical regime constructor.**  Static, spherically-symmetric
    vacuum metrics (e.g. Schwarzschild exterior), supplied with the three
    sharp `ℓ_P/12` bounds (Taylor, harmonic-gauge, Ricci-match).
    Dispatches through `staticSphericalHpwHypothesis`.

    Regime: *static spherically-symmetric vacuum (e.g. Schwarzschild
    exterior) — continuum `R_μν = 0`, discrete–continuum match enforced
    per-point at `ℓ_P/12` via Taylor truncation, harmonic-gauge Ricci-box
    identity, and Ricci-tensor comparison.* -/
noncomputable def HpwEliminableRegime.ofStaticSpherical
    {g : DiscreteMetric} (data : VacuumStaticSphericalData g) :
    HpwEliminableRegime g where
  toHpw := staticSphericalHpwHypothesis data

/-- **FRW cosmological regime constructor.**  Friedmann-Robertson-Walker
    metrics with a time-dependent scale factor `a(t)`, supplied with the
    three sharp `ℓ_P/12` bounds (Taylor, harmonic-gauge, Ricci-match).
    Dispatches through `frwHpwHypothesis`.

    Regime: *spatially-flat FRW cosmological metric — non-vanishing
    continuum Ricci `R₀₀ = −3ä/a`, `Rᵢⱼ = (aä + 2ȧ²)δᵢⱼ`,
    discrete–continuum match enforced per-point at `ℓ_P/12`.* -/
noncomputable def HpwEliminableRegime.ofFRW
    {g : DiscreteMetric} (data : FRWHpwData g) :
    HpwEliminableRegime g where
  toHpw := frwHpwHypothesis data

/-- **Bianchi I anisotropic regime constructor.**  Bianchi type I
    metrics with three independent time-dependent scale factors
    `a₁(t), a₂(t), a₃(t)`, supplied with the three sharp `ℓ_P/12` bounds.
    Dispatches through `bianchiIHpwHypothesis`.

    Regime: *Bianchi I anisotropic cosmological metric —
    `ds² = −dt² + a₁(t)²dx₁² + a₂(t)²dx₂² + a₃(t)²dx₃²`,
    non-vanishing anisotropic Ricci, discrete–continuum match enforced
    per-point at `ℓ_P/12`.* -/
noncomputable def HpwEliminableRegime.ofBianchiI
    {g : DiscreteMetric} (data : BianchiIHpwData g) :
    HpwEliminableRegime g where
  toHpw := bianchiIHpwHypothesis data

/-! ## Canonical instances

Only the flat case is inferrable without user-supplied data.  The
linearised and static-spherical regimes both require per-metric data
bundles supplied by the consumer, so we expose them as constructor
`def`s rather than automatic `instance`s — the consumer must write
e.g. `letI := HpwEliminableRegime.ofLinearised D h_scale` at the call
site. -/

/-- **Canonical flat instance.**  Makes `[HpwEliminableRegime
    DiscreteMetric.flat]` resolve automatically. -/
noncomputable instance : HpwEliminableRegime DiscreteMetric.flat :=
  .ofFlat

/-! ## The umbrella elimination theorem

The single consumer-facing theorem: for *any* metric `g` that is marked
as `HpwEliminableRegime`, the HPW bound holds as a theorem.  The proof
is a one-liner dispatch through `hpw_from_hypothesis`. -/

/-- **The umbrella HPW elimination theorem.**

    For any discrete metric `g` marked with `HpwEliminableRegime`, the
    bound
    `|mu_coeff · Δ_lat g_{μν}(p) + 2 · mu_coeff · R_{μν}(p)| ≤ ℓ_P / 2`
    holds as a theorem, for every `mu_coeff ∈ (0, 1]`, every lattice
    point `p`, and every component `(μ, ν)`.

    **The proof does not invoke `hpw_laplacian_ricci_convergence`** — it
    dispatches through the typeclass's `HpwHypothesis` witness and
    `hpw_from_hypothesis`.

    This is the consumer-facing interface of the entire HPW elimination
    programme: the moment a regime is closed (flat, linearised,
    static-spherical, …), downstream code can instantiate
    `HpwEliminableRegime` and use this theorem in place of the axiom. -/
theorem hpw_axiom_eliminable
    (g : DiscreteMetric) [inst : HpwEliminableRegime g]
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis inst.toHpw mu_coeff hmu hmu_le p μ ν

/-- **Unscaled form.**  `mu_coeff = 1` companion to
    `hpw_axiom_eliminable`, matching the unscaled axiom shape. -/
theorem hpw_axiom_eliminable_unscaled
    (g : DiscreteMetric) [inst : HpwEliminableRegime g]
    (p : LatticePoint) (μ ν : Fin 4) :
    |discreteLaplacian (fun q => g q μ ν) p +
     2 * ricciTensor g μ ν p| ≤ l_P / 2 :=
  hpw_from_hypothesis_unscaled inst.toHpw p μ ν

/-- **Scaled form.**  For `mu_coeff > 0` without the `≤ 1` upper bound,
    the bound scales to `mu_coeff · (ℓ_P / 2)`. -/
theorem hpw_axiom_eliminable_scaled
    (g : DiscreteMetric) [inst : HpwEliminableRegime g]
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p|
      ≤ mu_coeff * (l_P / 2) :=
  hpw_from_hypothesis_scaled inst.toHpw mu_coeff hmu p μ ν

/-! ## Consumer-facing migrated emergence chain

The same typeclass-dispatched pattern, for the direct downstream consumer
of the axiom: `laplacian_ricci_correspondence` (slack `ℓ_P`). -/

/-- **Typeclass-dispatched `laplacian_ricci_correspondence`.**  Same
    content as the axiom-free migration in `HpwHypothesis.lean`, but
    usable at any `[HpwEliminableRegime g]` without threading the
    `HpwHypothesis` witness explicitly. -/
theorem laplacian_ricci_correspondence_eliminable
    (g : DiscreteMetric) [inst : HpwEliminableRegime g]
    (mu_coeff : ℝ) (hmu : 0 < mu_coeff) (hmu_le : mu_coeff ≤ 1)
    (p : LatticePoint) (μ ν : Fin 4) :
    |mu_coeff * discreteLaplacian (fun q => g q μ ν) p +
     2 * mu_coeff * ricciTensor g μ ν p| ≤ l_P :=
  laplacian_ricci_correspondence_from_hypothesis
    inst.toHpw mu_coeff hmu hmu_le p μ ν

/-! ## Milestone witnesses

One existence theorem per closed regime, confirming that the umbrella
typeclass has a populated instance for each.  These also serve as a
sanity check that the constructor aliases type-check against the
downstream witnesses. -/

/-- **Milestone: free-space HPW elimination.**  Flat Minkowski is
    `HpwEliminableRegime`, witnessed by `minkowskiHpwHypothesis`. -/
theorem hpw_eliminable_flat :
    ∃ _ : HpwEliminableRegime DiscreteMetric.flat, True :=
  ⟨inferInstance, trivial⟩

/-- **Milestone: linearised HPW elimination.**  Any `g` satisfying a
    `LinearisedMetricData`-style bundle with `3·ε·K ≤ ℓ_P/2` admits an
    `HpwEliminableRegime` instance through `ofLinearised`. -/
theorem hpw_eliminable_linearised
    {g : DiscreteMetric} (D : LinearisedMetricData g)
    (h_scale : 3 * D.ε * D.K ≤ l_P / 2) :
    ∃ _ : HpwEliminableRegime g, True :=
  ⟨.ofLinearised D h_scale, trivial⟩

/-- **Milestone: static-spherical vacuum HPW elimination.**  Any `g`
    equipped with a `VacuumStaticSphericalData` bundle (three sharp
    `ℓ_P/12` bounds) admits an `HpwEliminableRegime` instance through
    `ofStaticSpherical`. -/
theorem hpw_eliminable_static_spherical
    {g : DiscreteMetric} (data : VacuumStaticSphericalData g) :
    ∃ _ : HpwEliminableRegime g, True :=
  ⟨.ofStaticSpherical data, trivial⟩

/-- **Milestone: FRW cosmological HPW elimination.**  Any `g` equipped
    with an `FRWHpwData` bundle (three sharp `ℓ_P/12` bounds) admits an
    `HpwEliminableRegime` instance through `ofFRW`. -/
theorem hpw_eliminable_frw
    {g : DiscreteMetric} (data : FRWHpwData g) :
    ∃ _ : HpwEliminableRegime g, True :=
  ⟨.ofFRW data, trivial⟩

/-- **Milestone: Bianchi I anisotropic HPW elimination.**  Any `g` equipped
    with a `BianchiIHpwData` bundle (three sharp `ℓ_P/12` bounds) admits an
    `HpwEliminableRegime` instance through `ofBianchiI`. -/
theorem hpw_eliminable_bianchiI
    {g : DiscreteMetric} (data : BianchiIHpwData g) :
    ∃ _ : HpwEliminableRegime g, True :=
  ⟨.ofBianchiI data, trivial⟩

/-! ## Progress summary

  * **Closed (no data required)** — free-space `DiscreteMetric.flat`.
    Automatic via the canonical instance; dispatches to
    `minkowskiHpwHypothesis`.

  * **Closed (data-carrying)** —
    - *linearised* (`g = η + ε·h`): user supplies pointwise
      `|Δg| ≤ εK`, `|R| ≤ εK`, and proves `3·ε·K ≤ ℓ_P/2`; reaches HPW
      via `HpwHypothesis_of_linearised`.
    - *static-spherical vacuum* (Schwarzschild exterior etc.): user
      supplies a continuum interpolant plus three sharp `ℓ_P/12` bounds
      (Taylor, harmonic-gauge, Ricci-match); reaches HPW via
      `HpwHypothesis_of_vacuum_static`.
    - *FRW cosmological* (`ds² = −dt² + a(t)²(dx²+dy²+dz²)`): user
      supplies a continuum interpolant plus three sharp `ℓ_P/12` bounds
      (Taylor, harmonic-gauge, Ricci-match); reaches HPW via
      `HpwHypothesis_of_frw`.  First time-dependent, non-vacuum regime.
    - *Bianchi I anisotropic*
      (`ds² = −dt² + a₁(t)²dx₁² + a₂(t)²dx₂² + a₃(t)²dx₃²`): user
      supplies a continuum interpolant plus three sharp `ℓ_P/12` bounds;
      reaches HPW via `HpwHypothesis_of_bianchiI`.  First anisotropic
      regime; FRW is a special case (`a₁ = a₂ = a₃`).

  * **Open** — fully general curved spacetime.  Closing this requires
    ingredients A, C, E, F, G, H, I from `NOTES_HPW_ELIMINATION.md`
    (smooth interpolant existence, uniform 4th-derivative bound,
    harmonic-gauge identity, Weinberg Ricci-box identity, Taylor
    second-difference bound, triangle-inequality glue).  Estimated
    ~8–12 weeks of focused Mathlib-adjacent formalisation.

  With the three closed regimes instantiated, this file is the single
  hub: downstream code writes `[HpwEliminableRegime g]` and never
  touches the axiom.  The axiom will remain declared in
  `LaplacianRicci.lean` until the general case is closed, but its
  *usage* in the emergence chain is now fully migratable on all three
  closed regimes.

  ## How to extend

  To add a new regime `foo`:
  1. Write `OmegaTheory/Emergence/HpwFoo.lean` with a data bundle
     `FooData g` and a witness `HpwHypothesis_of_foo : FooData g → ... →
     HpwHypothesis g`, mirroring the pattern of the three files above.
  2. Add `import OmegaTheory.Emergence.HpwFoo` to this file.
  3. Add `HpwEliminableRegime.ofFoo` as a constructor, and (optionally)
     a milestone witness `hpw_eliminable_foo`.
  4. Every downstream consumer using `[HpwEliminableRegime g]` now works
     for `foo`-regime metrics as well, with no further changes.
-/

end OmegaTheory.Emergence
