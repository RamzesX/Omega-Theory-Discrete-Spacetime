/-
  OmegaTheory.HealingFlow.EnrichedInformationDensity

  **Lion's-Pride Phase 1.2 (2026-05-06)**: enrich the healing-flow's
  information-density source `I_field` to include gauge-field
  contributions.  Wires the Phase-C-step-1 `gaugeInformation`
  density (`Emergence/GaugeInformationDensity.lean`, 2026-05-06)
  into the substrate's healing-flow PDE so that photon
  electromagnetic energy back-reacts on the metric, alongside
  the existing matter mass-density contribution.

  ## Why this file

  The healing-flow PDE
       `g(τ+δτ) = g(τ) + δτ · (μΔg − λD − γ(I−Ī))`
  takes `I : ℝ → InformationDensity` as an arbitrary scalar
  source.  The Phase-C-step-1 `gaugeInformation gc p = (1/2)·Σ F²`
  is shipped but DISCONNECTED from the flow — verified by grep, no
  HealingFlow file references `gaugeInformation`.

  This file ships the bridge:

       I_field_enriched I_matter gc τ p :=
           I_matter τ p + gaugeInformation gc p

  so the substrate's information density at `(τ, p)` is the sum of
  the standard matter (mass-density) source and the gauge-field
  (electromagnetic energy) source.  Under the substrate's healing
  flow, both contribute to driving the metric.

  This converts the substrate's `T_μν^I = -defectTensor` bridge from
  carrying mass-density-only to carrying mass+gauge-field-energy
  contributions — the load-bearing piece of the user's
  bridging-framework pivot 2026-05-06:

  > *"the bridge of influence of how the massless particles can
  > influence the spacetime or how the forces like electromagnetism
  > could do that"*

  ## What this file ships

  | Theorem                                       | Content                                                |
  |-----------------------------------------------|--------------------------------------------------------|
  | `I_field_enriched`                            | enriched information-density source                    |
  | `I_field_enriched_def`                        | rfl unfolding                                          |
  | `I_field_enriched_pointwise`                  | pointwise sum form                                     |
  | `I_field_enriched_nonneg`                     | non-negativity propagation                             |
  | `I_field_enriched_at_vacuum_eq_matter`        | zero-gauge-potential reduces to bare matter source    |
  | `I_field_enriched_separates`                  | linear separation: enriched − matter = gauge-info      |
  | Headline 4-conjunct                           | `enriched_information_density_report`                  |

  ## Honest scope

  - The "+" combination of matter and gauge-field information
    density is the natural choice for a non-interacting
    superposition; gauge-matter interaction terms (e.g.
    `J^μ A_μ`) would require an additional cross-coupling source
    handled separately.
  - The "I_bar" mean is left to the caller — for typical use,
    `I_bar` should be the spatial average of `I_field_enriched`
    so that `(I_enriched − I_bar)` measures DEPARTURE from
    spatially-uniform energy density, the correct healing-flow
    driving term.

  ## Lion's-Pride doctrine

  Rule 1: zero `sorry`. Rule 2: zero new axioms.  Direct
  composition: `gaugeInformation` (from Phase C step 1) +
  pointwise addition of two scalar fields.

  ## Author

  Lion's-Pride dynamic /loop iteration (2026-05-06).
  Single-thread Opus 4.7 [1M context], no mass wizards.
-/

import OmegaTheory.HealingFlow.Flow
import OmegaTheory.Emergence.GaugeInformationDensity

namespace OmegaTheory.HealingFlow.EnrichedInformationDensity

open OmegaTheory.Spacetime
open OmegaTheory.Geometry
open OmegaTheory.Conservation
open OmegaTheory.Emergence.ErrorGaugeField
open OmegaTheory.Emergence.GaugeInformationDensity

/-! ## Section 1 — Enriched information density -/

/-- **Enriched information-density source** for the healing flow.

    The substrate's information density at `(τ, p)` is the sum of
    the matter (mass-density) source and the gauge-field
    (electromagnetic energy) source:

        I_enriched(τ, p) := I_matter(τ, p) + (1/2)·Σ F_{μν}(gc, p)²

    where `gaugeInformation gc p = (1/2)·Σ F²` is the Phase-C-step-1
    gauge-information density.

    The healing-flow PDE
        `path(τ+δτ) = path(τ) + δτ·(μΔg − λD − γ·(I_enriched − Ī))`
    with this enriched source has photon electromagnetic energy
    back-reacting on the metric. -/
noncomputable def I_field_enriched (I_matter : ℝ → InformationDensity)
    (gc : GaugeConnection) (τ : ℝ) (p : LatticePoint) : ℝ :=
  I_matter τ p + gaugeInformation gc p

/-- **Definitional unfolding** of the enriched source. -/
theorem I_field_enriched_def
    (I_matter : ℝ → InformationDensity) (gc : GaugeConnection)
    (τ : ℝ) (p : LatticePoint) :
    I_field_enriched I_matter gc τ p =
      I_matter τ p + gaugeInformation gc p := rfl

/-- **Pointwise formula**: enriched = matter + (1/2)·Σ F². -/
theorem I_field_enriched_pointwise
    (I_matter : ℝ → InformationDensity) (gc : GaugeConnection)
    (τ : ℝ) (p : LatticePoint) :
    I_field_enriched I_matter gc τ p =
      I_matter τ p +
        (1 / 2) * ∑ μ : Fin 4, ∑ ν : Fin 4,
          ((gaugeCurvature gc).form p μ ν) ^ 2 := by
  unfold I_field_enriched gaugeInformation gaugeInformationPointwise
  rfl

/-! ## Section 2 — Non-negativity propagation -/

/-- **Non-negativity propagation**: if the matter source is
    non-negative pointwise (the standard physical requirement for a
    mass-density), then so is the enriched source.  Gauge-field
    information `|F|²/2 ≥ 0` automatically. -/
theorem I_field_enriched_nonneg
    {I_matter : ℝ → InformationDensity} (gc : GaugeConnection)
    (hmatter : ∀ τ p, 0 ≤ I_matter τ p) (τ : ℝ) (p : LatticePoint) :
    0 ≤ I_field_enriched I_matter gc τ p := by
  unfold I_field_enriched
  apply add_nonneg
  · exact hmatter τ p
  · exact gaugeInformation_nonneg gc p

/-! ## Section 3 — Vacuum reduction -/

/-- **Zero-potential reduction**: when the gauge connection is
    identically zero (no electromagnetic field), the enriched source
    reduces to the bare matter source. -/
theorem I_field_enriched_at_vacuum_eq_matter
    (I_matter : ℝ → InformationDensity) (τ : ℝ) (p : LatticePoint) :
    I_field_enriched I_matter zeroGaugeConnection τ p = I_matter τ p := by
  unfold I_field_enriched
  rw [gaugeInformation_zero_potential]
  ring

/-! ## Section 4 — Linear separation -/

/-- **Linear separation**: the enriched source minus the matter
    source equals the gauge-information density.

    This is the precise statement of "gauge-field energy is the
    additional source contribution" for the healing flow. -/
theorem I_field_enriched_separates
    (I_matter : ℝ → InformationDensity) (gc : GaugeConnection)
    (τ : ℝ) (p : LatticePoint) :
    I_field_enriched I_matter gc τ p - I_matter τ p =
      gaugeInformation gc p := by
  unfold I_field_enriched
  ring

/-! ## Section 5 — Capstone -/

/-- **Enriched information density report (4-conjunct headline)**:

    The substrate's information density `I_field` is now wired to
    include both matter (mass-density) and gauge-field
    (electromagnetic energy) contributions, with the following
    properties:

    1. Pointwise additive: enriched = matter + gauge-info.

    2. Non-negativity propagates: matter ≥ 0 ⟹ enriched ≥ 0
       (gauge-info `|F|²/2 ≥ 0` automatically).

    3. Vacuum (zero gauge potential): enriched reduces to bare
       matter source.

    4. Linear separation: enriched − matter = gauge-info, the
       precise statement of "gauge-field energy is the additional
       source contribution". -/
theorem enriched_information_density_report
    (I_matter : ℝ → InformationDensity) (gc : GaugeConnection)
    (hmatter : ∀ τ p, 0 ≤ I_matter τ p) :
    -- (1) Pointwise additive
    (∀ τ p, I_field_enriched I_matter gc τ p =
        I_matter τ p + gaugeInformation gc p) ∧
    -- (2) Non-negativity propagates
    (∀ τ p, 0 ≤ I_field_enriched I_matter gc τ p) ∧
    -- (3) Vacuum reduces to matter
    (∀ τ p, I_field_enriched I_matter zeroGaugeConnection τ p =
        I_matter τ p) ∧
    -- (4) Linear separation
    (∀ τ p, I_field_enriched I_matter gc τ p - I_matter τ p =
        gaugeInformation gc p) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro τ p; exact I_field_enriched_def I_matter gc τ p
  · intro τ p; exact I_field_enriched_nonneg gc hmatter τ p
  · intro τ p; exact I_field_enriched_at_vacuum_eq_matter I_matter τ p
  · intro τ p; exact I_field_enriched_separates I_matter gc τ p

end OmegaTheory.HealingFlow.EnrichedInformationDensity
